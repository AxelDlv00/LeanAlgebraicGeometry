# Blueprint Writer Report

## Slug
a4d-sym-g

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Albanese_AlbaneseUP.tex

## Changes Made

- **Updated** strategy-note preamble (lines ~5--57) — recorded the
  iter-174/iter-175 route decision: route (i) moduli/autoduality DEMOTED
  (gates on excised theorem of the cube via Milne~III~6.6 autoduality),
  route (ii) symmetric-power COMMITTED (Milne's Prop~6.1 proof verbatim;
  uses only proven `thm:rigidity_lemma` + `thm:rational_map_to_av_extends`).
- **Revised** setup paragraph (lines ~78--91) — replaced the
  Poincar\'e-bundle / moduli sketch with the symmetric-power
  `Sym^g C → A` ⇨ `J → A` chain.
- **Revised** `thm:albanese_universal_property` `\uses{}` (lines ~99--102) —
  replaced `lem:poincare_bundle_pullback, lem:moduli_pullback_morphism`
  with `def:symmetric_power_curve, lem:symmetric_product_av_map,
  lem:symmetric_product_to_jacobian, lem:descent_through_birational_sigma`.
  Kept `lem:abel_jacobi_morphism`, `thm:rational_map_to_av_extends`,
  `def:pic_scheme`.
- **Removed** `lem:poincare_bundle_pullback` (Poincar\'e-bundle pullback
  along $\varphi \times \mathrm{id}$) — moved its wording to the
  "Alternative route history" `% NOTE` block at the end of the chapter
  for reference only (no `\label`/`\lean`/`\uses` so it does not feed
  the leanblueprint dependency graph).
- **Removed** `lem:moduli_pullback_morphism` (moduli classifier of a
  trivialised line bundle) — also moved to the `% NOTE` block.
- **Added definition** `def:symmetric_power_curve`
  `\lean{AlgebraicGeometry.Pic0.SymmetricPower}` — scheme-theoretic
  $g$-th symmetric power $\mathrm{Sym}^g C$ via Milne's affine-and-glue
  recipe (Prop~III~3.1). Explicitly documents the Mathlib absence and
  the project-side `\Spec(A^{\otimes g})^{S_g}` construction sketch.
- **Added lemma** `lem:symmetric_product_av_map`
  `\lean{AlgebraicGeometry.Pic0.symmetricPowerAVMap}` — symmetrisation
  of `\varphi : C → A` to `Sym^g \varphi : Sym^g C → A` using
  $S_g$-equivariance of `add_A : A^g → A`. Includes verbatim Milne
  proof-quote from §III.6.1 (first sentence of Prop~6.1's proof).
- **Added lemma** `lem:symmetric_product_to_jacobian`
  `\lean{AlgebraicGeometry.Pic0.symmetricPowerToJacobian}` — the
  birational morphism `f^{(g)} : Sym^g C → J`, identification as
  divisor-class map `(P_1,…,P_g) ↦ [\mathcal O_C(P_1+⋯+P_g - gP_0)]`,
  birationality via Riemann–Roch generic-fibre singleton + dimension
  count. Verbatim source quote: Milne III~Theorem~5.1(a) (p.~101).
- **Added lemma** `lem:descent_through_birational_sigma`
  `\lean{AlgebraicGeometry.Pic0.descentThroughBirationalSigma}` —
  promotes the rational map $J \dashrightarrow A$
  (= $\mathrm{Sym}^g\varphi \circ (f^{(g)})^{-1}$) to a regular morphism
  via Milne~I~Theorem~3.2 (`thm:rational_map_to_av_extends`). This is
  the unique consumer of A.4.c in the chapter. Verbatim source quote:
  Milne III~6.1 proof, sentence "which (I~3.2) shows to be a regular
  map".
- **Replaced** the proof body of `thm:albanese_universal_property`
  (§sec:albaneseup_proof, lines ~535--620) — previously had two
  parallel presentations (Milne's symmetric-power proof + moduli-route
  proof); now a single five-step Sym^g proof following Milne~III~6.1
  verbatim:
  1. Symmetrisation (via `lem:symmetric_product_av_map`).
  2. Descent to regular morphism $\psi : J → A$ (via
     `lem:descent_through_birational_sigma`).
  3. Factorisation $\psi \circ \iota_{P_0} = \varphi$ on $\bar k$-points
     using $\iota_{P_0}(Q) = f^{(g)}(Q + (g-1)P_0)$.
  4. Homomorphism via Milne~I~Corollary~1.2 (a consequence of
     `thm:rigidity_lemma`).
  5. Uniqueness on the dense iterated sum
     $\iota_{P_0}(C) + \cdots + \iota_{P_0}(C)$.
  Verbatim Milne `% SOURCE QUOTE PROOF` from p.~104 retained immediately
  before `\begin{proof}`.
- **Revised** §sec:albaneseup_lean_encoding to list the five new
  Lean targets:
  `AlgebraicGeometry.Pic0.abelJacobi`,
  `AlgebraicGeometry.Pic0.SymmetricPower`,
  `AlgebraicGeometry.Pic0.symmetricPowerAVMap`,
  `AlgebraicGeometry.Pic0.symmetricPowerToJacobian`,
  `AlgebraicGeometry.Pic0.descentThroughBirationalSigma`,
  `AlgebraicGeometry.Pic0.albanese_universal_property`. Records
  `SymmetricPower` as a non-Mathlib sub-build with a `\notready`
  marker recommendation until the affine-and-glue construction lands.
- **Revised** §sec:albaneseup_out_of_scope — added explicit out-of-scope
  bullets for (i) the `\mathrm{Sym}^g C` scheme-theoretic construction
  (Mathlib absence; project-side sub-build); (ii) the autoduality
  $J \cong J^\vee$ / Poincar\'e-bundle moduli Albanese route (cube
  dependency); kept all pre-existing out-of-scope bullets.
- **Added** `% NOTE: Alternative route history` block at the chapter's
  end — preserves the retired Poincar\'e-bundle and moduli-classifier
  wording, with a note that the cube-dependence enters at Milne~III~6.6
  autoduality. No `\label`/`\lean`/`\uses` tags so it does not feed
  the leanblueprint dependency graph.
- **Corrected** cross-reference: the active blueprint label is
  `thm:rigidity_lemma` (not `lem:rigidity_lemma`); fixed in four
  occurrences (`\cref{thm:rigidity_lemma}` and the main theorem
  proof's `\uses{}` clause).

## Cross-references introduced

- `\uses{def:symmetric_power_curve, lem:symmetric_product_av_map,
  lem:symmetric_product_to_jacobian, lem:descent_through_birational_sigma,
  thm:rigidity_lemma}` added in the main theorem's `\uses{}` and proof
  body. All five labels are now defined in this chapter
  (the four new ones) or in `AbelianVarietyRigidity.tex`
  (`thm:rigidity_lemma`, verified at line 90 of that chapter).
- `\cref{thm:rational_map_to_av_extends}` retained — defined in
  `Albanese_Thm32RationalMapExtension.tex:49`.
- `\cref{def:pic_scheme}` retained — defined in
  `Picard_FGAPicRepresentability.tex`.
- `\cref{def:line_bundle_on_product}` retained in
  `lem:abel_jacobi_morphism` (defined in `Picard_LineBundlePullback.tex`).

## References consulted

- `references/summary.md` — index of project references; confirmed Milne
  AV §III.6.1 is the verbatim source for the UP and Milne §III.3 / §III.5
  cover Sym^g existence and birationality.
- `references/abelian-varieties.md` — Milne AV deep-map; identified
  Prop~3.1 (Sym^g existence, p.~94) and Theorem~5.1(a) (`f^{(g)}`
  birational, p.~101) as the verbatim quote targets for two of the new
  sub-lemma blocks.
- `references/abelian-varieties.pdf` (Milne) — read PDF pages 100
  (= doc p.~94, §III.3 Prop~3.1), 107 (= doc p.~101, §III.5 Thm~5.1(a)),
  and 110 (= doc p.~104, §III.6 Prop~6.1). All three pages used for
  verbatim `% SOURCE QUOTE` and `% SOURCE QUOTE PROOF` blocks.

## Reference-retriever dispatches

None. All necessary verbatim quotes were already in
`references/abelian-varieties.pdf`. The directive named the Mumford 1970
and Hartshorne IV.4 references as alternatives, but Milne's notes
(§III.3 Prop~3.1 + §III.5 Thm~5.1(a) + §III.6 Prop~6.1) cover every
verbatim quote the new declaration blocks need.

## Macros needed

None. The chapter uses only `\Pic`, `\Spec`, `\mathcal`, and standard
LaTeX environments that the existing `macros/common.tex` provides.

## Notes for Plan Agent

- **The `Sym^g C` scheme construction is a non-trivial sub-build.** The
  Lean target `AlgebraicGeometry.Pic0.SymmetricPower` has no Mathlib
  analogue (Mathlib's `Sym` / `SymmetricPower` cover types and modules
  only). The intended construction is Milne's affine-and-glue
  (`\Spec(A^{\otimes g})^{S_g}` on each open affine, glued by the
  standard open-cover patching, Milne~III.3 / Mumford 1970 II.7 \&
  III.11). Until this lands, the prover lane should skeleton the
  declaration with a `\notready` marker. The chapter \emph{specifies}
  the target but does not develop its construction.
- **Milne~I~Corollary~1.2 dependency.** The proof body of
  `thm:albanese_universal_property` cites Milne~I~Corollary~1.2
  ("a regular morphism of abelian varieties sending the identity to
  the identity is a homomorphism", a direct consequence of the
  Rigidity Lemma). The blueprint label of this corollary inside
  `AbelianVarietyRigidity.tex` is its own block (was not given an
  explicit `\label` in my read but is present at the file as "Corollary
  1.2"). If the plan agent wants this dependency formally pinned, a
  `lem:av_regular_map_is_hom`-style label is the natural choice (the
  declaration is already present in the project's Jacobian.tex
  `\uses{}` clauses, line 643 / 677); I did not add a new label to
  `AbelianVarietyRigidity.tex` since that is out of my write-domain.
  The current proof text instead cites `thm:rigidity_lemma` directly
  with a parenthetical note pointing at Milne~Cor~1.2 in
  `chap:AbelianVarietyRigidity`.
- **Witness wiring section (§sec:albaneseup_witness_wiring) unchanged.**
  The downstream Albanese-witness wiring (`grpObj`, `proper`,
  `smoothGenus`, `geomIrred`, `isAlbaneseFor`) does not depend on
  which proof route is used inside this chapter, so the section
  remains correct as written.
- **Out-of-scope sister content remains correct.** The genus-0 arm
  (`\cref{def:genusZeroWitness}`, `\cref{thm:rigidity_genus0_curve_to_AV}`,
  $\mathbb G_m$-scaling shortcut) and the Galois descent
  (sub-step C.2.f of `chap:Jacobian`) are out-of-scope items
  pre-existing in the chapter; they are not affected by the Sym^g
  refactor.

## Strategy-modifying findings

None. This chapter edit \emph{executes} the iter-174 / iter-175 route
decision (commit to Sym^g, retire moduli/autoduality) recorded in
`STRATEGY.md`; it does not surface any new strategy-level issues.
