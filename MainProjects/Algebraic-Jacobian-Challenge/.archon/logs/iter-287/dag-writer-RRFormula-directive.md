# Blueprint-writer directive — RiemannRoch_RRFormula.tex (literal-REF repair ONLY)

## Chapter
`blueprint/src/chapters/RiemannRoch_RRFormula.tex` (slug `RiemannRoch_RRFormula`, covers
`AlgebraicJacobian/RiemannRoch/RRFormula.lean`).

## Task — surgical, ONE class of edit only
The blueprint-doctor flagged **35 `literal-ref` findings**: the prose contains literal `REF`
placeholder tokens where a real `\cref{<label>}` was intended but never filled in. The chapter
already uses `\cref{...}` correctly in many places — these `REF` tokens are simply unfinished.

**Your ONLY task: replace each literal `REF` placeholder token with the correct
`\cref{<label>}`.** Nothing else.

### Hard scope boundary (do NOT cross)
- Do **not** add, delete, reorder, or reword any prose beyond dropping a single dangling `REF`
  token and inserting its `\cref{}`.
- Do **not** touch any `\leanok`, `\mathlibok`, `\lean{}`, `\uses{}`, `\label{}`, `% SOURCE`,
  `% SOURCE QUOTE`, `\textit{Source: ...}`, statement bodies, or proof math.
- Do **not** change the `\texttt{RR.1}`..`\texttt{RR.4}` mnemonics — fill only the adjacent `(REF)`.
- Some `REF` tokens sit **inside `% NOTE` comment blocks** (lines beginning with `%`, around the
  two NOTE paragraphs near the top). Fix those too: replace the `REF` token with the resolved
  `\cref{}` in place, keeping the leading `%` (the reference stays commented out — that is fine;
  it clears the literal token).
- Do **not** add `\leanok` anywhere.
- This chapter is certified complete + correct; the only defect is the `REF` tokens. Leave every
  other byte unchanged.

## Resolved REF → label mapping (high-confidence; verify against context as you edit)

Chapter / cross-chapter:
- `RR.1` = `\cref{chap:RiemannRoch_WeilDivisor}`, `RR.3` = `\cref{chap:RiemannRoch_OCofP}`,
  `RR.4` = `\cref{chap:RiemannRoch_RationalCurveIso}`.

By context (line numbers approximate — match by surrounding text):
- "The bridge consumed by REF of `\texttt{AbelianVarietyRigidity.tex}`"
  → `\cref{prop:rigidity_genus0_curve_to_AV}`
- "the degree map deg: Div(C)→Z (`\texttt{RR.1}`, REF)" → `\cref{def:divisor_degree}`
- (COMMENT) "restricts the headline theorem % REF to the genus-0 specialisation"
  → `\cref{thm:euler_char_eq_deg_plus_one_minus_genus}`
- (COMMENT) "`\texttt{RR.3}` consumes only % REF, and `\texttt{RR.4}` consumes"
  → `\cref{thm:riemannRoch_genus_zero}`
- (COMMENT) "The intermediate χ-identity % REF is stated and sketched for general g"
  → `\cref{thm:euler_char_eq_deg_plus_one_minus_genus}`
- "The genus g(C) is the one defined in REF of `\texttt{Genus.tex}`" → `\cref{def:genus}`
- "the same finiteness backing REF" (in def:eulerChar_curve) → `\cref{def:l_invariant}`
- "the project's Module k̄-valued sheaf-cohomology wrapper HModule k̄ (REF) applied"
  → `\cref{def:Scheme_HModule}`
- "D ∈ Div(C) be a Weil divisor (REF)" (in def:l_invariant) → `\cref{def:codim1_cycles}`
- "accepts a divisor D : C.WeilDivisor (REF)" → `\cref{def:codim1_cycles}`
- "the same Module k̄-valued sheaf-cohomology pipeline as REF" → `\cref{def:eulerChar_curve}`
- "The proof of REF below decomposes into three substantive substrate lemmas"
  → `\cref{thm:euler_char_eq_deg_plus_one_minus_genus}`
- "The first (REF, additivity)" → `\cref{lem:euler_char_shortExact_add}`
- "the second (REF, iso-invariance)" → `\cref{lem:euler_char_iso}`
- "the third (REF, skyscraper)" → `\cref{lem:euler_char_skyscraperSheaf}`
- "using the definition χ(F)=dim H^0 - dim H^1 (REF), to χ(F2)=…" → `\cref{def:eulerChar_curve}`
- "Unfolding the definition χ(F)=dim H^0 - dim H^1 (REF) closes the goal" → `\cref{def:eulerChar_curve}`
- "By the definition of χ (REF)" → `\cref{def:eulerChar_curve}`
- "the free abelian group on closed points (REF, REF)" →
  `\cref{def:codim1_cycles}, \cref{def:divisor_closed_point}` (first REF = codim1_cycles, second =
  divisor_closed_point)
- "the right-hand side by linearity of deg, REF" → `\cref{thm:divisor_degree_hom}`
- "dim H^1(C,O_C)=g (REF)" (base case) → `\cref{def:genus}`
- "We transport along this isomorphism via iso-invariance of χ, REF.)" → `\cref{lem:euler_char_iso}`
- "Additivity of χ on the short exact sequence (REF, the project-side factoring …)"
  → `\cref{lem:euler_char_shortExact_add}`
- "is the standalone substrate lemma REF (factored from the same Hartshorne~IV.1.3 line)"
  → `\cref{lem:euler_char_skyscraperSheaf}`
- "every closed point contributes 1 to the bare-sum degree of REF" → `\cref{def:divisor_degree}`
- "so by REF [deg(D+[P])+1-g = …]" → `\cref{thm:divisor_degree_hom}`
- "the additivity REF (χ on a short exact sequence …)" → `\cref{lem:euler_char_shortExact_add}`
- "the iso-invariance REF (χ on isomorphism classes …)" → `\cref{lem:euler_char_iso}`
- "the skyscraper identity REF (χ(k(P))=1 …)" → `\cref{lem:euler_char_skyscraperSheaf}`
- "Specialising REF to the genus-0 hypothesis g=0" → `\cref{thm:euler_char_eq_deg_plus_one_minus_genus}`
- "Unfolding χ via REF and the definition ℓ(D)=…" → `\cref{def:eulerChar_curve}`
- "ℓ(D)=dim_k̄ H^0(C,O_C(D)) (REF), this rewrites as" → `\cref{def:l_invariant}`
- "the genus-0 classification REF of `\texttt{AbelianVarietyRigidity.tex}`"
  → `\cref{prop:rigidity_genus0_curve_to_AV}`
- "the degree-zero principal-divisor identity (REF)" → `\cref{thm:principal_deg_zero}`
- "Inside the proof of REF the dependency on O_C(D)" → `\cref{thm:euler_char_eq_deg_plus_one_minus_genus}`
- "consumed as a named premise by REF" → `\cref{thm:riemannRoch_genus_zero}`
- "the degree-0 principal-divisor identity REF from `\texttt{RR.1}`" → `\cref{thm:principal_deg_zero}`

All target labels are confirmed to exist:
`def:genus` (Genus.tex), `def:Scheme_HModule` (Cohomology_StructureSheafModuleK.tex),
`thm:principal_deg_zero`/`thm:divisor_degree_hom`/`def:divisor_degree`/`def:codim1_cycles`/
`def:divisor_closed_point` (RiemannRoch_WeilDivisor.tex), `prop:rigidity_genus0_curve_to_AV`
(AbelianVarietyRigidity.tex), and all `def:eulerChar_curve / def:l_invariant /
lem:euler_char_* / thm:euler_char_eq_deg_plus_one_minus_genus / thm:riemannRoch_genus_zero`
local to this chapter.

## Verification before you finish
Run `grep -nE 'REF' blueprint/src/chapters/RiemannRoch_RRFormula.tex` — there must be **zero**
standalone `REF` placeholder tokens left (the substring "REF" should only ever survive inside a
`\cref{...}` macro name, which it does not, so the file should contain no literal "REF" at all).
Confirm no `\label{}`, `\lean{}`, `\uses{}`, `\leanok`, `% SOURCE`, or math was altered.

## Out of scope
Everything except replacing `REF` placeholder tokens. No new declarations, no proof edits, no
marker changes, no reference retrieval.
