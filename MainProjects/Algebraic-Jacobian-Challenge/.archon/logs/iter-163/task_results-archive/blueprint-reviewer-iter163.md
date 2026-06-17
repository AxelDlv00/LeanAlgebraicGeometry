# Blueprint Review Report

## Slug
iter163

## Iteration
163

## Top-level summaries

### Incomplete parts
- `AbelianVarietyRigidity.tex` / `lem:hom_additivity_over_product` (Milne Cor 1.5 — THE intended
  next prover target): the proof writes the decomposition `h = f∘p + g∘q` and the difference
  `φ = h − (f∘p + g∘q)` using `+`/`−` on morphisms into `A` freely, but never says where the
  **abelian-group structure on `Hom(V×W, A)`** comes from. In the Lean encoding `A` is `[GrpObj A]`
  only (verified: `AbelianVarietyRigidity.lean:801,852` — *not* `CommGrpObj`). The "+" decomposition
  and its uniqueness presuppose `A` commutative (Milne's Cor 1.4, itself a rigidity consequence), or
  at minimum that the pointwise Hom-monoid is a commutative group. The math is faithful to Milne;
  the *formalizable detail a prover needs* (which instance supplies the commutative-group `+` on
  morphisms-into-`A`) is missing. This is the crux of the Lean work and should be spelled out before
  the prover runs.

### Proofs lacking detail
- `AbelianVarietyRigidity.tex` / `lem:hom_additivity_over_product`: as above — add one sentence
  naming the source of the abelian-group structure on `Hom(−, A)` (commutativity of `A` / a
  `CommGrpObj` instance / Milne Cor 1.4), and how `f∘p + g∘q` is built in Lean (`GrpObj` mul ∘ lift).

### Lean difficulty quality
- `AbelianVarietyRigidity.tex` / `\lean{AlgebraicGeometry.hom_additive_decomp_of_rigidity}` and
  `\lean{AlgebraicGeometry.av_regularMap_isHom_of_zero}`: both are `[expected]` (not yet in the Lean
  file — confirmed absent). The *statements* are well-formed targets, but the return type implicitly
  needs the commutative-group structure on morphisms into `A` (see above). Recommend the writer pin
  this so the prover infers the right type rather than guessing.

### Citation discipline
- No findings. The five new/edited Milne blocks (`lem:hom_additivity_over_product`,
  `lem:av_regular_map_is_hom`, `lem:rational_map_to_av_extends`, `lem:hom_from_Ga_trivial`,
  `prop:morphism_P1_to_AV_constant`) each carry a `% SOURCE:` with a `(read from
  references/abelian-varieties.pdf, PDF page …)` parenthetical (file **exists** on disk), a verbatim
  `% SOURCE QUOTE:` (and `% SOURCE QUOTE PROOF:` where a proof is sourced), and a visible
  `\textit{Source: Milne, Abelian Varieties, …}` matching the `% SOURCE:` pointer. Quotes are in the
  source's original language (English) and notation. Cross-check against the writer report
  (`task_results/blueprint-writer-route-c.md`, "References consulted") confirms
  `references/abelian-varieties.pdf` was opened this session. `prop:genusZero_curve_iso_P1`
  (Hartshorne) was left untouched this iter and its citation is intact.

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - (must-fix, correct) `prop:morphism_P1_to_AV_constant` proof prose contains an internal
    contradiction: it justifies "`f|_{𝔾_a}` is an additive homomorphism (… hence a homomorphism by
    `\cref{lem:av_regular_map_is_hom}`)". But `lem:av_regular_map_is_hom` is Milne Cor 1.2, which
    applies only to maps **between abelian varieties**, and `lem:hom_from_Ga_trivial` *explicitly*
    states "This is NOT a direct instance of `\cref{lem:av_regular_map_is_hom}` … `𝔾_a` is not
    complete." The parenthetical cites the very lemma the chapter says is inapplicable. It should
    instead route the homomorphism property through `lem:hom_from_Ga_trivial`'s additive-defect +
    rigidity argument. One-line prose fix, but it is a genuine "step that does not follow".
  - (complete/detail) `lem:hom_additivity_over_product` omits the commutative-group / `Hom(−,A)`
    structure prerequisite (see Top-level summaries). Faithful math, under-specified for Lean.
  - (observation, not a defect) `lem:av_regular_map_is_hom` (Cor 1.2) is currently consumed by **no**
    downstream block's `\uses{}` in the chapter — its only mention is the erroneous parenthetical
    above. It is legitimate Milne §I.3 infrastructure and a sanctioned prover target, but the plan
    agent should know it is *not* on the `d=1` critical path to `prop:morphism_P1_to_AV_constant`.
  - (positive) Cube-excision is mathematically **correct**: no retained genus-0 block needs the
    theorem of the cube. The new §I.3 chain (`lem:hom_additivity_over_product` → `lem:av_regular_map_is_hom`,
    `lem:rational_map_to_av_extends`, `lem:hom_from_Ga_trivial` → `prop:morphism_P1_to_AV_constant` →
    `thm:rigidity_genus0_curve_to_AV`) derives the base case from `thm:rigidity_lemma` + Thm 3.2 +
    the `𝔾_a/𝔾_m` incompatibility, exactly as Milne §I.3 does (Prop 3.9/3.10). `rmk:cube_not_needed`
    is accurate.
  - (positive) The proven Rigidity-Lemma chain (`thm:rigidity_lemma`, `lem:rigidity_eqOn_dense_open`,
    `lem:rigidity_eqOn_saturated_open_to_affine`, `lem:morphism_eq_of_eqAt_closedPoints`,
    `lem:eq_comp_of_isAffine_of_properIntegral`, `lem:isIntegral_of_retract_of_integral`,
    `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`) reads **untouched, complete and correct**;
    it carries no cube reference. (Stale "single genuinely-deep residual sorry" wording remains in a
    few proof blocks, already flagged by the iter-162 `% NOTE` — refresh to "chain closed iter-162";
    informational only.)
  - (positive) `lem:hom_additivity_over_product` (Cor 1.5) is stated **faithfully** (matches the
    verbatim quote: V,W complete with k-points, A abelian, `h(v0,w0)=0` ⟹ unique `h=f∘p+g∘q`); its
    hypotheses (V complete, V×W geom. irreducible, A a group object) are load-bearing and its proof
    correctly invokes `thm:rigidity_lemma` to collapse the complete axis. The two hand-corrected
    blocks (`rmk:thm32_codim1_mathlib_gap`, `lem:hom_from_Ga_trivial` proof) are sound and mutually
    consistent: the additive-defect map `ψ(x,y)=f(x+y)−f(x)−f(y)` lives on `𝔾_a×𝔾_a`, must be
    extended over `ℙ¹×ℙ¹` via `lem:rational_map_to_av_extends` (Thm 3.2 surface case = Lemma 3.3 =
    Milne Thm 3.4) before Rigidity applies, and this surface-extension gap is correctly stated to be
    **on** the genus-0 path (not deferrable to Route A).
  - (positive) Internal `\uses` graph is forward-acyclic with **no edge to the deleted
    `thm:theorem_of_the_cube`**.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - (must-fix, broken cross-reference) `\cref{thm:theorem_of_the_cube}` appears at **lines 397 and
    453**, but that label was deleted from `AbelianVarietyRigidity.tex` this iter and is defined
    nowhere (confirmed: zero `\label{thm:theorem_of_the_cube}` in the blueprint). Two dangling
    `\cref`s → broken-reference must-fix (blueprint-doctor will flag).
  - (must-fix, stale + mathematically wrong) The same two locations carry the **uncorrected cube
    error**: §C.2.d route (c) (line ~397) still says the base case "is supplied by the *theorem of
    the cube* … the Rigidity Lemma alone does *not* suffice for the base case", and
    `\section{Route (c): rigidity via the theorem of the cube}` (line ~448–453) repeats "the cube is
    **required** here". This directly contradicts the now-corrected `AbelianVarietyRigidity.tex`
    (`rmk:cube_not_needed`) — i.e. the *exact* math error that was fixed in the sibling chapter
    survives here. Cross-chapter inconsistency. The fix is the same writer pass: rewrite §C.2.d
    route (c) and §`sec:av_rigidity_route_c` to describe the Milne §I.3 chain (Cor 1.5 + Cor 1.2 +
    Thm 3.2 + `𝔾_a/𝔾_m`) and delete the cube framing.
  - (positive) The genus-0 witness chain (`def:genusZeroWitness` → `thm:rigidity_genus0_curve_to_AV`
    + faithfully-flat descent) and the witness/Albanese API (`def:JacobianWitness`, `def:IsAlbanese`,
    extraction trio, `thm:nonempty_jacobianWitness` case-split) are otherwise complete and consistent;
    `def:genusZeroWitness`'s `\uses{thm:rigidity_genus0_curve_to_AV}` is correct and acyclic.

### blueprint/src/chapters/RigidityKbar.tex — fallback route (a) artifact; large (≈2620 lines), still carries `[CharZero]`, off critical path. Surveyed structure: all `\lean{}` hints and labels resolve (`thm:rigidity_over_kbar`, `sec:RigidityKbar_shared_pile`, the piece-(i)/(ii) pile), several `\lean{}` deliberately commented out under the "iter-146 disposition". No cube reference, consistent with its documented fallback role. Not feeding an active prover lane. complete + correct as a retained-fallback chapter.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes. (Scheme-level `ext_of_eqOnOpen`; consumed by RigidityKbar and the Albanese uniqueness half.)

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes. (Thin pointer chapter to the Cotangent/GrpObj Lean file; cross-refs into `RigidityKbar.tex` resolve.)

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

## Cross-chapter notes

- `Jacobian.tex` ↔ `AbelianVarietyRigidity.tex`: the cube was correctly excised from
  `AbelianVarietyRigidity.tex` but **not** from `Jacobian.tex` (the route-c writer directive was
  scoped to the rigidity chapter only). `Jacobian.tex` §C.2.d route (c) and §`sec:av_rigidity_route_c`
  remain the *old* "cube is load-bearing for the base case" framing and `\cref` the deleted label.
  Both chapters must agree: the cube is **not** on the genus-0 path. Single writer pass fixes both
  the broken refs and the stale math.
- (informational, Lean/review domain) The Lean docstring of `morphism_P1_to_grpScheme_const`
  (`AlgebraicJacobian/AbelianVarietyRigidity.lean:786–788`) still says "the single-curve base rests
  on the theorem of the cube (blueprint `thm:theorem_of_the_cube`), recorded there as a deferred deep
  input." This references the deleted blueprint label and the corrected-away claim. The review agent
  (semantic-marker owner) should refresh it; out of the plan agent's blueprint-write domain but worth
  queuing.

## Severity summary

**must-fix-this-iter:**
1. `Jacobian.tex` lines 397, 453 — broken `\cref{thm:theorem_of_the_cube}` (deleted label).
2. `Jacobian.tex` §C.2.d route (c) + §`sec:av_rigidity_route_c` — stale/incorrect "cube is required
   for the ℙ¹→A base case" prose; contradicts `rmk:cube_not_needed`. (Same writer pass as #1.)
3. `AbelianVarietyRigidity.tex` `prop:morphism_P1_to_AV_constant` proof — parenthetical misattributes
   the `f|_{𝔾_a}` homomorphism property to `lem:av_regular_map_is_hom` (Cor 1.2), which the chapter
   itself states is inapplicable to `𝔾_a`. Internal contradiction; route through
   `lem:hom_from_Ga_trivial` instead.
4. `AbelianVarietyRigidity.tex` `lem:hom_additivity_over_product` — add the missing
   commutative-group / `Hom(−,A)`-structure prerequisite (commutativity of `A`, i.e. Milne Cor 1.4 /
   a `CommGrpObj` instance) so the `+`/`−` decomposition is formalizable; `A` is encoded `[GrpObj A]`
   only.

**soon:** none.

**informational:**
- Stale "single genuinely-deep residual sorry" wording in `AbelianVarietyRigidity.tex` proof blocks
  (already noted by iter-162 `% NOTE`) — refresh to "chain closed iter-162".
- `lem:av_regular_map_is_hom` not wired into any downstream `\uses` (genuine §I.3 infra; off the
  `d=1` path).
- Lean docstring cube reference at `AbelianVarietyRigidity.lean:786–788` (review-agent cleanup).

### HARD GATE verdict for the iter-163 prover targets

The two intended prover-target *blocks* — `lem:hom_additivity_over_product` (Cor 1.5) and
`lem:av_regular_map_is_hom` (Cor 1.2) — are individually faithful, correctly derived from
`thm:rigidity_lemma`, and acyclic. **However**, their chapter `AbelianVarietyRigidity.tex` is
`correct: partial` (finding #3) and `complete: partial` (finding #4, which touches the Cor 1.5
target directly). Per the per-file gate, the chapter does **not** cleanly clear this iter.

All four must-fix items are small (three are 1–2 line prose fixes; #4 is a sentence + an instance
decision). Recommended path: dispatch a blueprint-writer THIS iter against
`AbelianVarietyRigidity.tex` (#3, #4) **and** `Jacobian.tex` (#1, #2); after it returns and
`lake build`/`leanblueprint` is green, take the **same-iter fast path** — a scoped re-review of
`AbelianVarietyRigidity.tex` — to clear the gate and release the prover on
`hom_additive_decomp_of_rigidity` / `av_regularMap_isHom_of_zero` without burning an iter.

Note: no `## Phases & estimations` table was included in the directive, so no unstarted-phase
proposals are enumerated here. From the chapter set, the only phase with narrative-only (no
declaration-block) coverage is Route A (Hilbert/Quot/FGA representability), documented as prose
inside `Jacobian.tex` `thm:nonempty_jacobianWitness` Route A; it is the project's largest gated
build and is not startable this iter, so this is informational, not a proposal.

Overall verdict: Cube-excision in `AbelianVarietyRigidity.tex` is mathematically correct and the
Rigidity-Lemma chain is intact; the gate is held back by 4 small must-fix items (a parenthetical
contradiction + a missing Cor-1.5 formalization detail in the rigidity chapter, plus 2 stale
cube cross-references/prose in the un-updated sibling `Jacobian.tex`) — fix via one writer pass over
both chapters, then fast-path re-review clears the prover on the two §I.3 targets.
