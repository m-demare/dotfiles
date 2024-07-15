
(macro_invocation
  macro: (identifier) @_macro (#eq? @_macro "test_interpret")
    (token_tree
      (identifier)
      (string_literal
        (string_content) @injection.content (#set! injection.language "lua") (#set! "priority" 130))
    )
)
