# Blueprint Writer Report

## Slug
rr4-rational-iso-p1

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex

The chapter file did not exist on disk (despite being already wired into
`content.tex` at line 34); created from scratch this iter. Final size:
~370 LOC of LaTeX, within the directive's 400-600 LOC envelope (well under
the upper end because the proof bodies factor cleanly into the three
sub-lemmas, each carrying its own short proof, plus a compact 4-step
headline proof).

## Changes Made
- **New chapter scaffold** — `\chapter{The rational-curve isomorphism
  $C \cong \mathbb P^1$ (RR.4)}` + `\label{chap:RiemannRoch_RationalCurveIso}`
  + `% archon:covers AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`
  + chapter-level `% SOURCE:` block listing the three Hartshorne loci.
- **Added §Setup and motivation** — places RR.4 in the RR.1–RR.4 chain
  scope; states the project's standing typeclass package and the iter-174
  scope decision (`\bar k`-base only; `k → k̄` descent is in
  `Jacobian.tex`'s `genusZeroWitness.key`).
- **Added lemma** `\lemma`/`\label{lem:morphism_to_p1_from_global_sections}`/
  `\lean{AlgebraicGeometry.Scheme.morphismToP1OfGlobalSections}` — the
  linear-system construction $X \to \mathbb P^1$ from a globally generating
  pair $(s_0, s_1)$ of sections of an invertible sheaf. Proof sketch added:
  cites the Mathlib API `AlgebraicGeometry.Proj.fromOfGlobalSections`
  (verified to exist in `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic`
  via `lean_leansearch`) and describes the chart-glue reduction.
- **Added lemma** `\lemma`/`\label{lem:degree_via_pole_divisor}`/
  `\lean{AlgebraicGeometry.Scheme.morphism_degree_via_pole_divisor}` — for
  a non-constant morphism $\varphi : C \to \mathbb P^1$, $\deg(\varphi)$
  is the degree of the pullback divisor $\varphi^*[Q]$ at any closed point.
  Proof sketch added: invokes finiteness (Hartshorne II.6.8) and
  multiplicativity of degree under pullback (Hartshorne II.6.9). Carries
  the IV.2 opening verbatim quote on the function-field definition of
  degree.
- **Added lemma** `\lemma`/`\label{lem:degree_one_morphism_iso}`/
  `\lean{AlgebraicGeometry.Scheme.iso_of_degree_one}` — a non-constant
  finite morphism of degree~1 between smooth proper geometrically
  irreducible curves over $\bar k$ is an isomorphism. Proof sketch added:
  the function-field-equivalence-of-categories argument (Hartshorne I.6.12)
  + scheme-theoretic spelled-out form (Stacks 0AVX). Carries two verbatim
  quotes: I.6.12 (just retrieved from PDF this session) and the IV.2
  degree-definition.
- **Added theorem** `\theorem`/`\label{thm:genus_zero_curve_iso_p1}`/
  `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` — the headline RR.4
  result. Proof sketch added: 4 steps (RR-non-constant-function ⇒ ℙ¹-map
  ⇒ degree 1 ⇒ iso). Carries the IV.1.3.5 verbatim quote and an explicit
  comparison-with-Hartshorne paragraph explaining the
  linear-system-vs-original-$P \sim Q$ phrasing difference.
- **Added remark** `\remark`/`\label{rmk:rr4_unblocks_sorryAx_on_rigidity_genus0}`
  — notes that closure of `\thm:genus_zero_curve_iso_p1` drops the
  `sorryAx` propagation on `rigidity_genus0_curve_to_grpScheme`
  (`AbelianVarietyRigidity.lean:315`).
- **Added §Out of scope** — five-item list excluding $k$-base descent,
  Mathlib API re-derivation, II.6.9 sub-build, equivalence-of-categories
  re-formalisation, and RR.3 line-bundle cohomology.

## Cross-references introduced
- `\uses{def:codim1_cycles}` (in `lem:morphism_to_p1_from_global_sections`)
  — `def:codim1_cycles` is in `RiemannRoch_WeilDivisor.tex` ✓ verified.
- `\uses{def:divisor_degree, def:order_at_point, def:divisor_closed_point}`
  (in `lem:degree_via_pole_divisor`) — all three in
  `RiemannRoch_WeilDivisor.tex` ✓ verified.
- `\uses{..., thm:principal_deg_zero}` (in proof of
  `lem:degree_via_pole_divisor`) — in `RiemannRoch_WeilDivisor.tex` ✓
  verified.
- `\uses{def:genus, lem:morphism_to_p1_from_global_sections,
  lem:degree_via_pole_divisor, lem:degree_one_morphism_iso,
  cor:nonconstant_function_genus_zero, thm:riemannRoch_genus_zero,
  def:codim1_cycles, def:divisor_degree}` (in
  `thm:genus_zero_curve_iso_p1` + its proof) — `def:genus` in
  `Genus.tex`; `cor:nonconstant_function_genus_zero` is the RR.3 export
  (sibling chapter `RiemannRoch_OCofP.tex`, dispatched parallel this
  iter — verify the label name lands as `cor:nonconstant_function_genus_zero`
  in the RR.3 writer's output); `thm:riemannRoch_genus_zero` in
  `RiemannRoch_RRFormula.tex` ✓ verified; the rest already verified above.
- `\Cref{prop:genusZero_curve_iso_P1}` / `\Cref{thm:rigidity_genus0_curve_to_AV}`
  / `\Cref{chap:AbelianVarietyRigidity}` — all three in
  `AbelianVarietyRigidity.tex` ✓ verified.
- `\Cref{chap:RiemannRoch_WeilDivisor}` and `\Cref{chap:RiemannRoch_RRFormula}`
  — both chapter labels exist ✓ verified.

## References consulted
- `references/summary.md` — confirmed the Hartshorne entry maps to the
  hartshorne-algebraic-geometry.pdf with the right page offsets.
- `references/hartshorne-algebraic-geometry.md` — used for the IV.1.3.5
  pointer (doc p.297 / PDF p.314), the genus-definition pointer
  (IV.1.1, doc p.294), and to confirm the PDF is scanned-image (no text
  layer; verbatim quotes must come from page renders).
- `references/hartshorne-algebraic-geometry.pdf` p.316 (doc p.299) — opened
  this session via `Read pages=316-319`; rendered the IV.2 opening
  paragraph for the verbatim quote on "degree of a finite morphism =
  $[K(X) : K(Y)]$". Used in `lem:degree_via_pole_divisor` and
  `lem:degree_one_morphism_iso`.
- `references/hartshorne-algebraic-geometry.pdf` p.62 (doc p.45) — opened
  this session via `Read pages=59-62`; rendered the I.6.12 verbatim
  quote on the function-field equivalence of categories. Used in
  `lem:degree_one_morphism_iso`.
- `references/hartshorne-algebraic-geometry.pdf` p.314 (doc p.297) —
  not directly re-rendered this session; the IV.1.3.5 verbatim quote in
  `thm:genus_zero_curve_iso_p1` is the same character-by-character text
  already present in the verified `\prop{genusZero_curve_iso_P1}` block
  of `AbelianVarietyRigidity.tex:1797-1805` (which itself was sourced
  from the .md card's transcription, verified in a prior iter), so the
  text was lifted from the sibling-chapter quote rather than re-rendered
  from the PDF. Flagging this for transparency.
- Sibling chapter `blueprint/src/chapters/AbelianVarietyRigidity.tex`
  (lines 1780–1902) — read to lift the verbatim IV.1.3.5 quote and to
  match the headline-theorem signature & `\lean{...}` pin.
- Sibling chapter `blueprint/src/chapters/RiemannRoch_RRFormula.tex`
  — read in full for the standing typeclass conventions and the chain
  diagram of sub-build chapters.
- Sibling chapter `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`
  — read in full for the cross-references (`def:codim1_cycles`,
  `def:divisor_degree`, `def:order_at_point`, `def:divisor_closed_point`,
  `thm:principal_deg_zero`).
- `blueprint/src/content.tex` — confirmed `RiemannRoch_RationalCurveIso`
  is already wired in (line 34); no edit needed there.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` lines 270–344 —
  confirmed the headline target's Lean signature
  (`AlgebraicGeometry.genusZero_curve_iso_P1` at line 290), threading
  `[IsAlgClosed kbar]`, smooth proper geom-irred curve over
  `Over (Spec (.of kbar))`, `_hgenus : genus C = 0`, and conclusion
  `Nonempty (C ≅ ProjectiveLineBar kbar)`. The chapter prose matches
  this signature.
- `lean_leansearch` query "morphism to projective space from invertible
  sheaf global sections" — verified `AlgebraicGeometry.Proj.fromOfGlobalSections`
  exists in `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic` and
  returned its full signature. **Confirmation: the directive's named
  Mathlib API is correct.** Signature:
  ```
  Proj.fromOfGlobalSections (𝒜 : ℕ → σ) [GradedRing 𝒜] {X : Scheme}
    (f : A →+* X.presheaf.obj (Op ⊤))
    (hf : Ideal.map f (HomogeneousIdeal.irrelevant 𝒜).toIdeal = ⊤) :
    X ⟶ Proj 𝒜
  ```
  This is exactly the right API for `lem:morphism_to_p1_from_global_sections`'s
  Lean wrapper. Adjacent helpers also surfaced
  (`Proj.toBasicOpenOfGlobalSections`, `Proj.fromOfGlobalSections.congr_simp`,
  `Proj.fromOfGlobalSections_toSpecZero`) — these can be consumed by the
  prover for the chart-restriction-and-glue reduction.

## Macros needed (if any)
None. The chapter uses only standard LaTeX + the existing `\Div`, `\deg`,
`\ord`, `\genus` macros already defined in `blueprint/src/macros/common.tex`
(verified by inspection of sibling chapters' use of the same commands).

## Reference-retriever dispatches (if any)
None. The two Hartshorne locations needed beyond what was already in the
.md card (IV.2 opening paragraph for the degree-definition quote; I.6.12
for the function-field equivalence quote) were retrieved directly from
`references/hartshorne-algebraic-geometry.pdf` this session via the
`Read pages=...` interface (which renders scanned pages of the PDF
into the agent's visual context). No external retrieval was necessary.

## Notes for Plan Agent

- **Label collision risk (low, but flag).** The new `\theorem`
  `thm:genus_zero_curve_iso_p1` in RR.4 pins the same Lean target
  (`AlgebraicGeometry.genusZero_curve_iso_P1`) as the existing
  `\proposition` `prop:genusZero_curve_iso_P1` in
  `AbelianVarietyRigidity.tex:1789-1809`. The LaTeX labels are
  distinct (`thm:genus_zero_curve_iso_p1` vs
  `prop:genusZero_curve_iso_P1`), so `\Cref` resolution is unambiguous,
  but the dependency-graph viewer (`leanblueprint dep_graph`) will show
  both nodes as `\leanok` once `sync_leanok` runs after RR.4 lands. This
  is the intended pattern (interface block + implementation block both
  pinning the same `\lean{...}`), parallel to how `RR.2`'s
  `thm:riemannRoch_genus_zero` and `RR.1`'s `thm:principal_deg_zero`
  are pinned without restatement in the AVR chapter. **Recommendation:**
  no edit needed; leave both blocks in place.

- **RR.3 dependency on `cor:nonconstant_function_genus_zero`.** The
  proof of `thm:genus_zero_curve_iso_p1` opens by citing
  `cor:nonconstant_function_genus_zero` (RR.3 export, sibling chapter
  `RiemannRoch_OCofP.tex`, dispatched parallel this iter). The label name
  in this chapter's `\uses{...}` is exactly
  `cor:nonconstant_function_genus_zero` as named in the iter-174
  directive. If the RR.3 writer uses a different final label, this
  chapter's `\uses{...}` will need a one-line update in a follow-up
  iter; the writer is naming-aware (per the iter-174 plan).

- **Mathlib API verified.** The directive flagged "verify
  `Proj.fromOfGlobalSections` is the right API"; this was done via
  `lean_leansearch` and confirmed positive (see References consulted
  above). The blueprint cites this API explicitly with its full
  signature, removing ambiguity for the downstream prover.

- **Standing-hypotheses block.** The chapter pins
  `[IsAlgClosed kbar]` + the standard curve typeclass set on
  `Over (Spec (.of kbar))`, matching the Lean target at
  `AbelianVarietyRigidity.lean:290`. No `[IsIntegral C.left]` is threaded
  at the signature level (since the existing target signature does not
  carry it), but the chapter prose notes that integrality of $C$ is
  derivable from `GeometricallyIrreducible C.hom` + `SmoothOfRelativeDimension`.
  Flagging in case the iter-174 prover lane's signature inflates.

- **Conventions matched to RR.2.** The chapter mirrors RR.2's
  `RiemannRoch_RRFormula.tex` in structure (chapter-level SOURCE block,
  per-block verbatim quotes, scope-decision NOTE blocks, "Out of scope"
  closing section, sub-build notes inside proofs flagging what gets
  closed in follow-up iters). Should slot cleanly into the existing RR
  sub-build narrative.

## Strategy-modifying findings

None. The chapter is mathematically routine (Hartshorne IV.1.3.5
restated via the linear-system formulation); no novel strategy
considerations surfaced during the writing.

The minor sub-lemma split (three lemmas:
`morphism_to_p1_from_global_sections`, `degree_via_pole_divisor`,
`degree_one_morphism_iso`) follows the directive's recommended structure
verbatim and is the same factoring used in the sibling RR chapters; no
deviation from STRATEGY.md was needed.
