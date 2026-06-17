# Blueprint Doctor

## Broken cross-references

These `\ref{...}` / `\uses{...}` / `\cref{...}` (etc.) calls point at labels that no `\label{...}` defines anywhere in the included tex tree. The dependency graph rendered by leanblueprint will draw a missing edge for each. Common causes: label typos (case mismatch, plural/singular), labels moved to an orphan chapter, or copy-paste of `\uses{...}` lists that weren't updated when targets renamed.

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex`
- `\uses{\leanok
        thm:divisor_degree_hom}` — no matching `\label`
- `\uses{\leanok
        thm:euler_char_eq_deg_plus_one_minus_genus}` — no matching `\label`

