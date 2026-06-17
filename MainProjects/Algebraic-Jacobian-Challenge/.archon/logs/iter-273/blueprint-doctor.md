# Blueprint Doctor

## Malformed annotations

Annotations with an empty argument (`\uses{}`, `\proves{}`, `\label{}`, `\ref{}`, ...) or an empty list item (`\uses{a,,b}`, `\uses{a,}`). plastex emits `Label '' could not be resolved` for each of these and then the leanblueprint depgraph builder enters infinite recursion (`RecursionError`), so the blueprint never finishes building. Fix each one by either filling in the intended label or deleting the empty annotation. Do NOT defer — the next `leanblueprint web` run will crash until these are resolved.

### `blueprint/src/chapters/AbelJacobi.tex`
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>} ×2

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>}

### `blueprint/src/chapters/Cohomology_MayerVietoris.tex`
- `\literal-ref{...}` — literal "Chapter~REF" placeholder — use \cref{<label>} ×3
- `\literal-ref{...}` — literal "Definition~REF" placeholder — use \cref{<label>} ×15
- `\literal-ref{...}` — literal "Lemma~REF" placeholder — use \cref{<label>} ×6
- `\literal-ref{...}` — literal "Section~REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>} ×3

### `blueprint/src/chapters/Cohomology_SheafCompose.tex`
- `\literal-ref{...}` — literal "Definition~REF" placeholder — use \cref{<label>}
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>}

### `blueprint/src/chapters/Cohomology_StructureSheafAb.tex`
- `\literal-ref{...}` — literal "Chapter~REF" placeholder — use \cref{<label>} ×4
- `\literal-ref{...}` — literal "Definition~REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>}

### `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`
- `\literal-ref{...}` — literal "Chapter~REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "Definition~REF" placeholder — use \cref{<label>} ×17
- `\literal-ref{...}` — literal "Lemma~REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "Sections~REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "Section~REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>} ×11

### `blueprint/src/chapters/Differentials.tex`
- `\literal-ref{...}` — literal "Definition~REF" placeholder — use \cref{<label>}
- `\literal-ref{...}` — literal "Lemma~REF" placeholder — use \cref{<label>} ×3
- `\literal-ref{...}` — literal "Remark~REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "Section~REF" placeholder — use \cref{<label>} ×7
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>} ×3

### `blueprint/src/chapters/Jacobian.tex`
- `\literal-ref{...}` — literal "Chapter~REF" placeholder — use \cref{<label>} ×3
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "Theorems~REF" placeholder — use \cref{<label>} ×2
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>} ×2

### `blueprint/src/chapters/Picard_FlatteningStratification.tex`
- `\literal-ref{...}` — literal "Corollary~REF" placeholder — use \cref{<label>}
- `\literal-ref{...}` — literal "Definition~REF" placeholder — use \cref{<label>}
- `\literal-ref{...}` — literal "Lemma~REF" placeholder — use \cref{<label>} ×10
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>} ×11

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>} ×3

### `blueprint/src/chapters/RiemannRoch_OcOfD.tex`
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>} ×43

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex`
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>} ×35

### `blueprint/src/chapters/Rigidity.tex`
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>}
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>}

