;; extends

; VS Code "Dark 2026" colors storage keywords (const/let/var) and the arrow
; (=>) differently from control-flow keywords. Re-capture them so the
; dark2026 colorscheme can paint them red via @keyword.modifier.

([
  "const"
  "let"
  "var"
] @keyword.modifier (#set! "priority" 110))

("=>" @keyword.modifier (#set! "priority" 110))
