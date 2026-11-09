; Every block (`system {`, `unit 0 {`, `term t1 {` ...) appears in the outline.
(statement
  status: (status)? @context
  name: (_) @name
  !arguments
  body: (block)) @item

(statement
  status: (status)? @context
  name: (_) @name
  arguments: (arguments) @name
  body: (block)) @item
