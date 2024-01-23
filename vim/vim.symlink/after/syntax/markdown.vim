 " Front matter
   if v:lnum == 1 && line == '---'
     let b:markdown_frontmatter = 1
     return ">1"
   endif

   " End of front matter
   if (line == '---') && b:markdown_frontmatter
     unlet b:markdown_frontmatter
     return '<1'
   endif
