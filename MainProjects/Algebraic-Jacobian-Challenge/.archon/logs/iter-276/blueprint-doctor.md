# Blueprint Doctor

## Malformed annotations

Annotations with an empty argument (`\uses{}`, `\proves{}`, `\label{}`, `\ref{}`, ...) or an empty list item (`\uses{a,,b}`, `\uses{a,}`). plastex emits `Label '' could not be resolved` for each of these and then the leanblueprint depgraph builder enters infinite recursion (`RecursionError`), so the blueprint never finishes building. Fix each one by either filling in the intended label or deleting the empty annotation. Do NOT defer — the next `leanblueprint web` run will crash until these are resolved.

### `blueprint/src/chapters/AbelJacobi.tex`
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>} ×2

### `blueprint/src/chapters/AbelianVarietyRigidity.tex`
- `\math-delim{...}` — line 25: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 25: \) without a matching \( ×2
- `\math-delim{...}` — line 41: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 41: \) without a matching \( ×2

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex`
- `\bare-label{...}` — bare label "lem:agps" in prose — use \cref{lem:agps} or the human-readable number
- `\math-delim{...}` — line 369: \( opened inside $…$ math
- `\math-delim{...}` — line 369: \) without a matching \(
- `\math-delim{...}` — line 435: \( opened inside $…$ math
- `\math-delim{...}` — line 435: \) without a matching \(
- `\math-delim{...}` — line 79: \( opened inside $…$ math
- `\math-delim{...}` — line 79: \) without a matching \(
- `\math-delim{...}` — line 84: \( opened inside $…$ math
- `\math-delim{...}` — line 84: \) without a matching \(

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`
- `\bare-label{...}` — bare label "lem:depth_drops_by_one" in prose — use \cref{lem:depth_drops_by_one} or the human-readable number
- `\math-delim{...}` — line 158: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 158: \) without a matching \( ×2
- `\math-delim{...}` — line 401: \( opened inside $…$ math
- `\math-delim{...}` — line 401: \) without a matching \(

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex`
- `\math-delim{...}` — line 1686: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 1686: \) without a matching \( ×2
- `\math-delim{...}` — line 1732: \( opened inside $…$ math
- `\math-delim{...}` — line 1732: \) without a matching \(
- `\math-delim{...}` — line 187: \( opened inside $…$ math
- `\math-delim{...}` — line 187: \) without a matching \(

### `blueprint/src/chapters/Albanese_CoheightBridge.tex`
- `\math-delim{...}` — line 111: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 111: \) without a matching \( ×2
- `\math-delim{...}` — line 134: \( opened inside $…$ math
- `\math-delim{...}` — line 134: \) without a matching \(
- `\math-delim{...}` — line 144: \( opened inside $…$ math
- `\math-delim{...}` — line 144: \) without a matching \(

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>}
- `\undefined-macro{...}` — \obj is used but defined nowhere (macros/*.tex or a chapter-local \providecommand) — define it or fix the typo
- `\undefined-macro{...}` — \toUnit is used but defined nowhere (macros/*.tex or a chapter-local \providecommand) — define it or fix the typo

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

### `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`
- `\bare-label{...}` — bare label "cor:algsch" in prose — use \cref{cor:algsch} or the human-readable number
- `\bare-label{...}` — bare label "lm:ctn" in prose — use \cref{lm:ctn} or the human-readable number ×2
- `\bare-label{...}` — bare label "lm:qt" in prose — use \cref{lm:qt} or the human-readable number
- `\bare-label{...}` — bare label "th:main" in prose — use \cref{th:main} or the human-readable number ×2
- `\bare-label{...}` — bare label "th:repDiv" in prose — use \cref{th:repDiv} or the human-readable number
- `\math-delim{...}` — line 129: \( opened inside $…$ math
- `\math-delim{...}` — line 129: \) without a matching \(
- `\math-delim{...}` — line 135: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 135: \) without a matching \( ×2
- `\math-delim{...}` — line 136: \( opened inside $…$ math
- `\math-delim{...}` — line 136: \) without a matching \(

### `blueprint/src/chapters/Picard_FlatteningStratification.tex`
- `\literal-ref{...}` — literal "Corollary~REF" placeholder — use \cref{<label>}
- `\literal-ref{...}` — literal "Definition~REF" placeholder — use \cref{<label>}
- `\literal-ref{...}` — literal "Lemma~REF" placeholder — use \cref{<label>} ×10
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>} ×11
- `\math-delim{...}` — line 742: \( opened inside $…$ math
- `\math-delim{...}` — line 742: \) without a matching \(

### `blueprint/src/chapters/Picard_IdentityComponent.tex`
- `\bare-label{...}` — bare label "cor:sm" in prose — use \cref{cor:sm} or the human-readable number ×2
- `\bare-label{...}` — bare label "lem:agps" in prose — use \cref{lem:agps} or the human-readable number ×12
- `\bare-label{...}` — bare label "th:qpp" in prose — use \cref{th:qpp} or the human-readable number ×3

### `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`
- `\bare-label{...}` — bare label "cor:ch0" in prose — use \cref{cor:ch0} or the human-readable number ×2
- `\bare-label{...}` — bare label "cor:sm" in prose — use \cref{cor:sm} or the human-readable number ×2
- `\bare-label{...}` — bare label "rmk:Jac" in prose — use \cref{rmk:Jac} or the human-readable number ×4
- `\bare-label{...}` — bare label "th:cmp" in prose — use \cref{th:cmp} or the human-readable number
- `\bare-label{...}` — bare label "th:qpp" in prose — use \cref{th:qpp} or the human-readable number ×3
- `\bare-label{...}` — bare label "thm:tgtsp" in prose — use \cref{thm:tgtsp} or the human-readable number ×3
- `\undefined-macro{...}` — \tu is used but defined nowhere (macros/*.tex or a chapter-local \providecommand) — define it or fix the typo

### `blueprint/src/chapters/Picard_QuotScheme.tex`
- `\math-delim{...}` — line 243: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 243: \) without a matching \( ×2
- `\math-delim{...}` — line 332: \( opened inside $…$ math ×2
- `\math-delim{...}` — line 332: \) without a matching \(
- `\math-delim{...}` — line 43: \) without a matching \(

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- `\bare-label{...}` — bare label "th:cmp" in prose — use \cref{th:cmp} or the human-readable number
- `\bare-label{...}` — bare label "th:main" in prose — use \cref{th:main} or the human-readable number ×2
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>} ×3

### `blueprint/src/chapters/Picard_RelativeSpec.tex`
- `\math-delim{...}` — line 686: \( opened inside $…$ math
- `\math-delim{...}` — line 686: \) without a matching \(

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

### `blueprint/src/chapters/Rigidity.tex`
- `\literal-ref{...}` — literal "REF" placeholder — use \cref{<label>}
- `\literal-ref{...}` — literal "Theorem~REF" placeholder — use \cref{<label>}

