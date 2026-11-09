; ---------------------------------------------------------------------------
; Generic captures first; more specific (predicate-based) patterns follow and
; take precedence.
; ---------------------------------------------------------------------------

(comment) @comment

(string) @string
(escape_sequence) @string.escape

(word) @variable

; Statement / hierarchy names: `system {`, `host-name r1;`
(statement name: (word) @property)
(statement name: (string) @property)

; Values after the statement name
(arguments (word) @string.special)
(list (word) @string.special)

; `inactive:`, `protect:`, ...
(status) @keyword.modifier
((status) @comment.unused (#eq? @comment.unused "inactive:"))

; `set`, `delete`, `deactivate`, ...
(verb) @keyword

; In set commands, every word is part of the hierarchy path
(command arguments: (arguments (word) @property))

; `[edit ...]` banner
(edit_context "edit" @keyword)
(edit_context (arguments (word) @title))

; Punctuation
["{" "}" "[" "]"] @punctuation.bracket
";" @punctuation.delimiter

; ---------------------------------------------------------------------------
; Typed values (applied to any word)
; ---------------------------------------------------------------------------

; Numbers, ranges and Junos versions (21.4R3.15)
((word) @number
  (#match? @number "^-?[0-9]+(\\.[0-9]+)?([kmgKMG])?(-[0-9]+)?$"))

; IPv4 address / prefix
((word) @number
  (#match? @number "^[0-9]{1,3}(\\.[0-9]{1,3}){3}(/[0-9]{1,2})?$"))

; IPv6 address / prefix
((word) @number
  (#match? @number "^[0-9a-fA-F]{0,4}(:[0-9a-fA-F]{0,4}){2,7}(/[0-9]{1,3})?$"))

; MAC address
((word) @number
  (#match? @number "^[0-9a-fA-F]{2}([:.-][0-9a-fA-F]{2}){5}$"))

; Interface names: ge-0/0/0, xe-1/2/3:1, ae0, lo0.0, irb.100, fxp0...
((word) @type
  (#match? @type "^(ge|xe|et|fe|so|gr|lt|mt|ip|vt|sp|ms|si|ps|pp|lsq|st|pd|pe|ae|reth|fab|swfab|lo|irb|vlan|fxp|em|me|vme|re|bme|jsrv|dsc|gre|ipip|lsi|mtun|pimd|pime|tap|cbp|esi|vtep|pip|ifsw|t1|e1|t3|e3|cp|at)-?[0-9]+(/[0-9]+)*(:[0-9]+)?(\\.[0-9]+)?$"))

; Junos variables ($junos-interface-name) and wildcards (<ge-*>)
((word) @variable.special (#match? @variable.special "^\\$"))
((word) @variable.special (#match? @variable.special "^<.*>$"))

; Booleans / enable-disable
((word) @boolean
  (#match? @boolean "^(enable|disable|true|false|yes|no)$"))

; Policy / firewall actions
((word) @keyword.control
  (#match? @keyword.control "^(accept|reject|discard|next|permit|deny|count|log|syslog|sample|policer|forwarding-class|loss-priority|routing-instance)$"))

; Well-known top-level hierarchies
((word) @keyword
  (#match? @keyword "^(version|system|chassis|interfaces|protocols|routing-options|routing-instances|policy-options|firewall|security|services|snmp|groups|apply-groups|apply-groups-except|class-of-service|vlans|bridge-domains|forwarding-options|event-options|access|switch-options|virtual-chassis|poe|ethernet-switching-options|logical-systems|applications|multi-chassis|tenants|schedulers)$"))
