; inherits: ruby
; extends

(call
  method: (identifier) @context.identifier
  block: (block body: (block_body) @context.end)
) @context
