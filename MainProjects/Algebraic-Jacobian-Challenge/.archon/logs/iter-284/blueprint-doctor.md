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

### `blueprint/src/chapters/RiemannRoch_OCofP.tex`
- `\math-delim{...}` — line 27: \( opened inside $…$ math
- `\math-delim{...}` — line 27: \) without a matching \(
- `\math-delim{...}` — line 424: \( opened inside $…$ math
- `\math-delim{...}` — line 424: \) without a matching \(
- `\math-delim{...}` — line 495: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 495: \) without a matching \( ×2

### `blueprint/src/chapters/RiemannRoch_OcOfD.tex`
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>} ×43
- `\math-delim{...}` — line 231: \( opened inside $…$ math
- `\math-delim{...}` — line 231: \) without a matching \(
- `\math-delim{...}` — line 411: \( opened inside $…$ math
- `\math-delim{...}` — line 411: \) without a matching \(
- `\math-delim{...}` — line 438: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 438: \) without a matching \( ×2

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex`
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>} ×35
- `\math-delim{...}` — line 121: \( opened inside $…$ math ×3
- `\math-delim{...}` — line 121: \) without a matching \( ×3
- `\math-delim{...}` — line 726: \( opened inside $…$ math
- `\math-delim{...}` — line 726: \) without a matching \(

### `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`
- `\math-delim{...}` — line 36: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 36: \) without a matching \( ×2
- `\math-delim{...}` — line 51: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 51: \) without a matching \( ×2

### `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`
- `\math-delim{...}` — line 1370: \( opened inside $…$ math
- `\math-delim{...}` — line 1370: \) without a matching \(
- `\math-delim{...}` — line 142: \( opened inside $…$ math
- `\math-delim{...}` — line 142: \) without a matching \(
- `\math-delim{...}` — line 52: \( opened inside $…$ math
- `\math-delim{...}` — line 52: \) without a matching \(

