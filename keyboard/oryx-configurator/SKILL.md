---
name: oryx-configurator
description: >
  Programmatically configure ZSA keyboard layouts (ErgoDox EZ, Moonlander, Voyager) through
  the Oryx web configurator at configure.zsa.io. Use this skill whenever the user wants to
  recreate a QMK keymap in Oryx, bulk-edit keys or layers, add macros, port a layout from
  keymap.c to Oryx, or automate any repetitive keyboard configuration task in the browser.
  Also use when the user mentions ZSA, Oryx, ErgoDox, Moonlander, Voyager, or keyboard layout
  configuration, even if they don't explicitly say "programmatic" — the browser automation
  approach is almost always faster than clicking through the UI key by key.
---

# Oryx Layout Configurator

Configure ZSA keyboard layouts programmatically by manipulating the MobX-state-tree (MST)
store that powers Oryx's React UI. This is dramatically faster than clicking through the
web editor for bulk changes, and it lets you port existing QMK keymaps without manually
re-entering hundreds of keys.

## How It Works

Oryx is a React app backed by a MobX-state-tree store. Every key, layer, and layout is a
node in this tree. By walking the React fiber tree from the DOM, you can find the MST store
and then read or write any key's configuration as a JSON snapshot. Changes made this way
update the React UI instantly, and calling `persist()` saves them to ZSA's servers.

## Prerequisites

- Chrome browser with the Oryx configurator open (configure.zsa.io)
- An existing layout in Oryx to modify (create one through the UI first if needed)
- The Claude-in-Chrome MCP tools for browser interaction

## Step 1: Find the MST Store

The React app mounts on `#app` (not `#root`). Walk the React fiber tree to find the
component whose `memoizedProps.value` contains a `layouts` map.

The React container property name on the DOM element changes on every page load (e.g.,
`__reactContainer$tyr911a02af` one time, `__reactContainer$19zw7bqqh2r` the next).
Always discover it dynamically:

```javascript
const appEl = document.getElementById('app');
const keys = [];
for (let k in appEl) { if (k.startsWith('__react')) keys.push(k); }

let fiber = appEl[keys[0]], store = null;
const visited = new Set(), queue = [fiber];
while (queue.length > 0) {
  const f = queue.shift();
  if (!f || visited.has(f)) continue;
  visited.add(f);
  try {
    if (f.memoizedProps?.value?.layouts) {
      store = f.memoizedProps.value;
      break;
    }
  } catch(e) {}
  if (f.child) queue.push(f.child);
  if (f.sibling) queue.push(f.sibling);
  if (f.return) queue.push(f.return);
  if (visited.size > 10000) break;
}
```

After finding the store, get a reference to the layout revision:

```javascript
const rev = store.layouts.get('<LAYOUT_KEY>').revision;
```

The layout key is the hex string in the Oryx URL path (e.g., `8938ee6a3699147004ee36f6ebe26526`
for URL `/ergodox-ez/layouts/GmLxR/latest/0`). You can find it by inspecting
`Array.from(store.layouts.keys())`.

## Step 2: Access Layers and Keys

```javascript
const layer = rev.layers[0];       // layer index 0-N
const key = layer.keys[42];        // key index within layer
```

Read a key's current state:
```javascript
JSON.stringify(key.$treenode.snapshot);
```

## Step 3: Apply Key Snapshots

MST objects are "protected" — you cannot assign properties directly. Use the internal
`_applySnapshot` method on the tree node:

```javascript
key.$treenode._applySnapshot({
  glowColor: null,
  lockGlowColor: null,
  customLabel: null,
  icon: null,
  emoji: null,
  tap: {
    description: null,
    code: "KC_A",
    color: null,
    modifier: null,
    modifiers: null,
    layer: null,
    macro: null
  },
  hold: null,
  doubleTap: null,
  tapHold: null,
  tappingTerm: null,
  detached: false,
  swapping: false,
  swapped: false,
  pristine: false
});
```

Always include every field in the snapshot. Omitting fields can leave stale data from
the previous configuration.

## Step 4: Save Changes

After modifying keys on a layer, persist to ZSA's servers:

```javascript
layer.persist();
```

This is critical. Without it, navigating away from the layer (even just switching to
another layer tab in Oryx) will lose your changes. Persist after each batch of changes
to a layer, not after every single key.

## Key Code Reference

Oryx uses QMK-style key codes. Common mappings:

| Key | Code | Notes |
|-----|------|-------|
| Letters | `KC_A` through `KC_Z` | |
| Numbers | `KC_1` through `KC_0` | |
| F-keys | `KC_F1` through `KC_F24` | |
| Enter | `KC_ENTER` | |
| Escape | `KC_ESCAPE` | |
| Backspace | `KC_BSPACE` | |
| Tab | `KC_TAB` | |
| Space | `KC_SPACE` | |
| Minus | `KC_MINUS` | |
| Equal | `KC_EQUAL` | |
| Left Bracket | `KC_LBRACKET` | |
| Right Bracket | `KC_RBRACKET` | |
| Backslash | `KC_BSLASH` | |
| Semicolon | `KC_SCOLON` | |
| Quote | `KC_QUOTE` | |
| Grave | `KC_GRAVE` | |
| Comma | `KC_COMMA` | |
| Dot | `KC_DOT` | |
| Slash | `KC_SLASH` | |
| Caps Lock | `KC_CAPSLOCK` | |
| Delete | `KC_DELETE` | |
| Insert | `KC_INSERT` | |
| Home/End | `KC_HOME`, `KC_END` | |
| Page Up/Down | `KC_PGUP`, `KC_PGDN` | |
| Arrows | `KC_LEFT`, `KC_RIGHT`, `KC_UP`, `KC_DOWN` | |
| Modifiers | `KC_LSHIFT`, `KC_RSHIFT`, `KC_LCTRL`, `KC_RCTRL` | |
|  | `KC_LALT`, `KC_RALT`, `KC_LGUI`, `KC_RGUI` | |
| Meh | `KC_MEH` | Ctrl+Shift+Alt |
| Hyper | `KC_HYPR` | Ctrl+Shift+Alt+Gui |
| Transparent | `KC_TRANSPARENT` | Inherit from lower layer |
| No key | `KC_NO` | Explicitly nothing |
| Print Screen | `KC_PSCREEN` | |
| Scroll Lock | `KC_SCROLLLOCK` | |
| Num Lock | `KC_NUMLOCK` | |
| Volume | `KC_AUDIO_VOL_UP`, `KC_AUDIO_VOL_DOWN`, `KC_AUDIO_MUTE` | |
| Media | `KC_MEDIA_PLAY_PAUSE`, `KC_MEDIA_NEXT_TRACK`, `KC_MEDIA_PREV_TRACK`, `KC_MEDIA_STOP` | |
| Mouse | `KC_MS_UP`, `KC_MS_DOWN`, `KC_MS_LEFT`, `KC_MS_RIGHT` | |
|  | `KC_MS_BTN1`, `KC_MS_BTN2`, `KC_MS_BTN3` | |
|  | `KC_MS_WH_UP`, `KC_MS_WH_DOWN` | |

When unsure of the exact Oryx code string, create the key manually in the UI first, then
read its snapshot to discover the code. This is the most reliable way to handle edge cases.

## Layer Tap and Momentary Layer Keys

For keys that activate a layer on hold and send a keycode on tap:

```javascript
tap: { code: "KC_A", ... },   // what it types on tap
hold: {
  description: null,
  code: "KC_TRANSPARENT",
  color: null,
  modifier: null,
  modifiers: null,
  layer: 4,               // layer number to activate on hold
  macro: null
}
```

For momentary layer (hold-only, no tap):

```javascript
tap: { code: "KC_TRANSPARENT", ... },
hold: { ..., layer: 1 }
```

For layer-tap with a specific hold code, the `hold.code` is typically `KC_TRANSPARENT`
and the `hold.layer` field does the work.

## Macros

Macros let a single key produce a sequence of keystrokes. The tap code must be
`KC_TRANSPARENT` and the macro object goes in `tap.macro`:

```javascript
tap: {
  code: "KC_TRANSPARENT",
  macro: {
    name: null,
    keys: [
      {
        code: "KC_DOT",
        modifiers: {
          leftAlt: false, leftCtrl: false, leftGui: false, leftShift: true,
          rightAlt: false, rightCtrl: false, rightGui: false, rightShift: false
        },
        delay: 10
      },
      { code: "KC_EQUAL", modifiers: null, delay: 10 }
    ],
    endEnter: false,
    applyAlt: false
  }
}
```

The example above produces `>=` (Shift+dot = `>`, then `=`).

Important details about macros:

- Set `customLabel` on the key to show what the macro does (e.g., `">="`).
- Shifted characters use modifier flags, not separate keycodes. `>` is `KC_DOT` with
  `leftShift: true`. `!` is `KC_1` with `leftShift: true`. Think in terms of physical
  keystrokes, not ASCII characters.
- For OS-specific shortcuts (like macOS Option+Shift+Hyphen for em-dash), use the
  appropriate modifier. `leftAlt` = Option on macOS.
- `delay: 10` between keys works well. No need to go higher unless you hit reliability issues.
- `endEnter: false` unless you want the macro to press Enter at the end.

### Common Shifted Characters Quick Reference

| Character | Code | Modifier |
|-----------|------|----------|
| `!` | `KC_1` | leftShift |
| `@` | `KC_2` | leftShift |
| `#` | `KC_3` | leftShift |
| `$` | `KC_4` | leftShift |
| `%` | `KC_5` | leftShift |
| `^` | `KC_6` | leftShift |
| `&` | `KC_7` | leftShift |
| `*` | `KC_8` | leftShift |
| `(` | `KC_9` | leftShift |
| `)` | `KC_0` | leftShift |
| `_` | `KC_MINUS` | leftShift |
| `+` | `KC_EQUAL` | leftShift |
| `{` | `KC_LBRACKET` | leftShift |
| `}` | `KC_RBRACKET` | leftShift |
| `\|` | `KC_BSLASH` | leftShift |
| `:` | `KC_SCOLON` | leftShift |
| `"` | `KC_QUOTE` | leftShift |
| `~` | `KC_GRAVE` | leftShift |
| `<` | `KC_COMMA` | leftShift |
| `>` | `KC_DOT` | leftShift |
| `?` | `KC_SLASH` | leftShift |

## ErgoDox EZ Physical Layout

The ErgoDox EZ has 76 keys per layer (indices 0-75). The mapping from index to physical
position is not obvious, especially for the thumb clusters.

See `references/ergodox-key-indices.md` for the complete index-to-position mapping,
including the thumb cluster tables that were empirically determined.

## Porting a QMK keymap.c

When porting an existing keymap.c to Oryx, follow this process:

### 1. Parse the Source Layout

Read the `LAYOUT_ergodox()` calls in the keymap.c. Each call defines one layer.
The parameters follow the physical layout order documented in qmk_firmware's
`ergodox_ez.h`, but the Oryx key indices are different. Use the index mapping in
`references/ergodox-key-indices.md` to translate.

### 2. Translate Key Codes

QMK keymap.c uses shorthand codes that differ from Oryx's naming:

| QMK keymap.c | Oryx Code |
|--------------|-----------|
| `KC_SCLN` | `KC_SCOLON` |
| `KC_COMM` | `KC_COMMA` |
| `KC_MINS` | `KC_MINUS` |
| `KC_EQL` | `KC_EQUAL` |
| `KC_LBRC` | `KC_LBRACKET` |
| `KC_RBRC` | `KC_RBRACKET` |
| `KC_BSLS` | `KC_BSLASH` |
| `KC_QUOT` | `KC_QUOTE` |
| `KC_GRV` | `KC_GRAVE` |
| `KC_SLSH` | `KC_SLASH` |
| `KC_BSPC` | `KC_BSPACE` |
| `KC_SPC` | `KC_SPACE` |
| `KC_ENT` | `KC_ENTER` |
| `KC_ESC` | `KC_ESCAPE` |
| `KC_DEL` | `KC_DELETE` |
| `KC_INS` | `KC_INSERT` |
| `KC_TRNS` | `KC_TRANSPARENT` |
| `KC_PSCR` | `KC_PSCREEN` |
| `KC_NLCK` | `KC_NUMLOCK` |
| `KC_EXLM` | Macro: `KC_1` + leftShift |
| `KC_AT` | Macro: `KC_2` + leftShift |
| `KC_HASH` | Macro: `KC_3` + leftShift |
| `KC_DLR` | Macro: `KC_4` + leftShift |
| `KC_PERC` | Macro: `KC_5` + leftShift |
| `KC_CIRC` | Macro: `KC_6` + leftShift |
| `KC_AMPR` | Macro: `KC_7` + leftShift |
| `KC_ASTR` | Macro: `KC_8` + leftShift |
| `KC_LPRN` | Macro: `KC_9` + leftShift |
| `KC_RPRN` | Macro: `KC_0` + leftShift |
| `KC_TILD` | Macro: `KC_GRAVE` + leftShift |
| `KC_PIPE` | Macro: `KC_BSLASH` + leftShift |
| `LSFT(KC_X)` | Either shifted key code or macro depending on Oryx support |

Note: Oryx handles some shifted characters natively (check by creating one in the UI).
For characters where Oryx doesn't have a native code, use a single-key macro with
the shift modifier.

### 3. Handle QMK Features

Some QMK features map differently in Oryx:

- **`LT(layer, kc)`**: Use layer-tap (tap code + hold layer). See the layer tap section above.
- **`MO(layer)`**: Momentary layer. `tap.code = "KC_TRANSPARENT"`, `hold.layer = N`.
- **`F(n)` / `ACTION_MACRO_TAP`**: These are custom QMK functions. Analyze the firmware
  source to understand what they do, then replicate the behavior using Oryx's layer-tap
  or toggle-layer features.
- **`M(n)` / custom macros**: Read the `action_get_macro()` function in the keymap.c
  to see what keystrokes each macro produces, then create equivalent Oryx macros.
- **`MEH_T(kc)`**: Tap for kc, hold for Meh (Ctrl+Shift+Alt).
- **`ALL_T(kc)`**: Tap for kc, hold for Hyper (Ctrl+Shift+Alt+Gui).
- **Dual-role shift keys (faux shifts)**: The Ordinary layout's layer lock/shift behavior
  uses custom `fn_actions` and C code. In Oryx, approximate this with layer-tap keys
  (tap = character, hold = momentary layer).

### 4. Verify Systematically

After programming each layer, verify every key:

1. Read all 76 key snapshots from the store
2. Compare each one against the expected value from the keymap.c
3. Pay special attention to:
   - Thumb cluster keys (index mapping is tricky)
   - Keys with hold behavior (layer taps)
   - Transparent keys (should pass through to lower layers)
   - Macro keys (verify the keystroke sequence, not just the label)

Batch the verification by reading all keys at once:
```javascript
const layer = rev.layers[0];
const summary = layer.keys.map((k, i) => {
  const s = k.$treenode.snapshot;
  return {
    idx: i,
    tap: s.tap?.code,
    hold: s.hold?.layer ?? s.hold?.code ?? null,
    macro: s.tap?.macro ? s.tap.macro.keys.map(k => k.code).join('+') : null,
    label: s.customLabel
  };
});
JSON.stringify(summary);
```

### 5. Watch for These Pitfalls

- **Container key changes**: The React `__reactContainer$...` property suffix changes on
  every page load. Always discover it dynamically (see Step 1).
- **Protected object errors**: Never assign to MST properties directly. Always use
  `$treenode._applySnapshot()`.
- **Recursive layer triggers**: If key X activates layer 4 via `LT(4, X)` on the base
  layer, do NOT put `LT(4, X)` on layer 4 as well — that creates a recursive loop.
  On the target layer, use the plain tap key instead.
- **Persist before navigating**: Always call `layer.persist()` before switching layers
  or navigating away. Oryx does not auto-save programmatic changes.
- **Macro naming bugs in source**: Some keymap.c files have misleading macro names
  (e.g., a macro named `GrtEq` that actually produces `<=`). Always verify against
  the actual keystroke sequence in the `action_get_macro()` function, not the name.
- **Shifted keycodes vs. base keycodes**: In QMK, `KC_EXLM` is `!` (shifted `1`).
  In Oryx, you need either Oryx's native shifted code (if it exists) or a macro with
  `KC_1` + leftShift modifier. Check by creating the character in the UI first.

## Workflow Summary

1. Open the layout in Oryx in Chrome
2. Run the store discovery code via `javascript_tool`
3. Read the layout key from the URL or `store.layouts.keys()`
4. For each layer:
   a. Build an array of 76 key snapshots
   b. Apply them via `_applySnapshot()`
   c. Call `layer.persist()`
   d. Verify by reading back and comparing to source
5. Have the user visually confirm before compiling/flashing
