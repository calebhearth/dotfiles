" Most of this is from vim-ruby. vim-detailed renames the synID of "" strings to
" detailedInterpolatedString, so matchit.vim will consider those when looking
" for matches for %. It's worst in RSpec, but happens in Ruby too. It means that
" if a string contains a word like if, for, else, end, etc., % will consider
" that word in the string for jumping around.
" the second line adding "detailedInterpolatedString\\|" is the only change
" here, in case it needs to be updated later from the vim-ruby definition. It
" needs to stay within the surrounding < and >.
let b:match_skip =
  \ "synIDattr(synID(line('.'),col('.'),0),'name') =~ '" .
  \ "\\<detailedInterpolatedString\\|" .
  \ "ruby\\%(String\\|.\+Delimiter\\|Character\\|.\+Escape\\|" .
  \ "Regexp\\|Interpolation\\|Comment\\|Documentation\\|" .
  \ "ConditionalModifier\\|RepeatModifier\\|RescueModifier\\|OptionalDo\\|" .
  \ "MethodName\\|BlockArgument\\|KeywordAsMethod\\|ClassVariable\\|" .
  \ "InstanceVariable\\|GlobalVariable\\|Symbol\\)\\>'"
