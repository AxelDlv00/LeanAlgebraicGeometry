# Blueprint Doctor

## Malformed annotations

Annotations with an empty argument (`\uses{}`, `\proves{}`, `\label{}`, `\ref{}`, ...) or an empty list item (`\uses{a,,b}`, `\uses{a,}`). plastex emits `Label '' could not be resolved` for each of these and then the leanblueprint depgraph builder enters infinite recursion (`RecursionError`), so the blueprint never finishes building. Fix each one by either filling in the intended label or deleting the empty annotation. Do NOT defer — the next `leanblueprint web` run will crash until these are resolved.

### `blueprint/src/chapters/AbelJacobi.tex`
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>} ×2

### `blueprint/src/chapters/Jacobian.tex`
- `\literal-ref{...}` — literal "Chapter~REF" placeholder — use \cref{<label>} ×3
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "Theorems~REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>} ×2

