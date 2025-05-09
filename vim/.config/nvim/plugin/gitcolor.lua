local gitcolor = {}

-- Check if string is a valid color (named, 0-255, or hex)
function gitcolor.is_color(token)
    if token:match("^#%x%x%x%x%x%x$") or token:match("^#%x%x%x$") then
        return true -- hex
    elseif tonumber(token) and tonumber(token) >= 0 and tonumber(token) <= 255 then
        return true -- ansi 256 color
    elseif token:match("^bright?[%a]+$") or token == "default" or token == "normal" then
        return true -- named color
    end
    return false
end

-- Parse attribute or its negated form
function gitcolor.parse_attribute(token, style)
    local negate = token:match("^no%-?(.+)$")
    local attr = negate or token

    local map = {
        bold = "bold",
        dim = "dim",
        ul = "underline",
        blink = "blink",
        reverse = "reverse",
        italic = "italic",
        strike = "strikethrough"
    }

    local key = map[attr]
    if key then
        if negate then
            style[key] = false
        elseif key == "dim" then
            style.blend = 30
        else
            style[key] = true
        end
    end
end

-- Parse a git color string (e.g. "bold red #ff0000 ul")
function gitcolor.parse_git_color(config_key)
    local handle = io.popen("git config --get " .. config_key)
    if not handle then
        return nil, "Failed to run git command"
    end

    local result = handle:read("*a")
    handle:close()

    result = result:match("^%s*(.-)%s*$")
    if result == "" then
        return nil, "No config value found for " .. config_key
    end

    local parts = {}
    for word in result:gmatch("%S+") do
        table.insert(parts, word)
    end

    local style = {}
    local color_count = 0

    for _, part in ipairs(parts) do
        if gitcolor.is_color(part) then
            if color_count == 0 then
                style.fg = part
            elseif color_count == 1 then
                style.bg = part
            end
            color_count = color_count + 1
        else
            gitcolor.parse_attribute(part, style)
        end
    end

    return style
end

function gitcolor.highlight(group, config_key, fallback)
    local style, err = gitcolor.parse_git_color(config_key)
    if not style and fallback then
        style = fallback
    elseif not style then
        vim.notify("gitcolor: " .. err, vim.log.levels.WARN)
        return
    end

    local groups = type(group) == "table" and group or { group }
    for _, g in ipairs(groups) do
        vim.api.nvim_set_hl(0, g, style)
    end
end

--- #273C5B hsl(215.77 40% 25%) oklch(0.35 0.0606 257.97)
--- #4493f8 hsl(213.67 93% 62%) oklch(0.66 0.1692 255.92)
-- Dim Blue
gitcolor.highlight({
  "GitNew",
  "diffAdded",
  "DiffAdd",
  "DiffText",
  "Added",
}, "color.diff.new")
gitcolor.highlight("DiffText", "color.diff-highlight.newNormal")
gitcolor.highlight("DiffTextAdded", "color.diff-highlight.newHighlight")
gitcolor.highlight({
  "GitDiffAdd",
}, "color.diff-highlight.newHighlight")
-- Bright Blue
gitcolor.highlight({
  "GitSignsAdd",
  "gitCommitDiscardedFile",
  "gitCommitDiscardedType",
}, "color.status.added")

-- #463023 oklch(0.33 0.039 51.54)
-- #d29922 oklch(0.72 0.1401 79.91)
-- Dim orange
gitcolor.highlight({
  "GitDeleted",
  "diffRemoved",
  "DiffDelete",
}, "color.diff.old")
gitcolor.highlight({
  "GitSignsChange",
  "gitCommitSelectedFile",
  "gitCommitSelectedFileType",
}, "color.status.changed")
gitcolor.highlight({
  "diffOldFile",
  "ConflictMarkerCommonAncestors",
}, "color.status.remoteBranch")

gitcolor.highlight({
  "gitCommitBranch",
  "diffNewFile",
  "ConflictMarkerBegin",
}, "color.status.localBranch")
gitcolor.highlight("gitDiff", "color.diff.context")
gitcolor.highlight({
  "ConflictMarkerOurs",
  "DiffChange",
}, "color.diff.newMoved")
gitcolor.highlight("ConflictMarkerCommonAncestorsHunk", "color.diff.oldMoved")

-- #38af00 oklch(0.66 0.2372 137.54)
-- #104900 oklch(0.35 0.1267 137.54)
gitcolor.highlight({
  "GitDirty",
  "GitSignsDelete",
  "gitCommitRemovedFile",
  "gitCommitRemovedType",
  "Changed",
  "ConflictMarkerTheirs",
}, "color.diff.contextDimmed")

gitcolor.highlight({ "ConflictMarkerEnd" }, "color.diff.contextBold")

gitcolor.highlight({
  "gitMeta",
  "diffIndexLine",
  "diffFile",
}, "color.diff.meta")

return gitcolor
