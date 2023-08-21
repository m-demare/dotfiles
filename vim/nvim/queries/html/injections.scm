; AngularJS props
(attribute
  (attribute_name) @_attr (#any-of? @_attr
                           "ng-if"
                           "ng-switch"
                           "ng-click"
                           "ng-change"
                           "ng-model"
                           "ng-repeat"
                           "ng-checked"
                           "ng-disabled"
                           "ng-show"
                           "ng-value"
                           "ng-src"
                           "ng-touched"
                           "ng-options"
                           "ng-focus"
                           "ng-mousedown"
                           "ng-keydown"
                           "ng-style"
                           "ng-init"
                           "show-if"
                           "ng-class")
  (quoted_attribute_value
    (attribute_value) @injection.content
    (#set! injection.language "javascript")))

; AngularJS templates inside templates
(script_element
  (start_tag
      (attribute
        (attribute_name) @_attr (#eq? @_attr "type")
        (quoted_attribute_value
          (attribute_value) @_attr_value (#eq? @_attr_value "text/ng-template"))))
  (raw_text) @injection.content
    (#set! injection.language "html"))

; HTML style attribute
(attribute
  (attribute_name) @_attr (#eq? @_attr "style")
  (quoted_attribute_value
    (attribute_value) @injection.content
      (#set! injection.language "css")))

