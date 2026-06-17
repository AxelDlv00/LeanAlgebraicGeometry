# Blueprint-writer directive — bw-cech264

## Chapter to edit
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (ONLY this chapter).

## Context (strategy slice)
This chapter blueprints the A.2.c-engine relative Čech / `Rⁱf_*` lane (`CechHigherDirectImage.lean`).
The push-pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `(Y,p) ↦ p_* p^* F`, is the lone remaining hole in
`CechNerve`. iter-263 landed its object/morphism bricks `pushPullObj`/`pushPullMap` (axiom-clean) and —
crucially — DISCOVERED that the functor laws are DE-COUPLED from the project's TensorObjSubstrate Sq1.
A Lean↔blueprint check (lvb-cech263) found 2 must-fix adequacy failures. Fix exactly the items below;
do NOT add/remove `\leanok`/`\mathlibok` markers.

## Required fixes

### 1. [MUST-FIX] Correct the dependency claim in `sec:cech_three_part` paragraph (2)
The paragraph currently asserts `G`'s functor laws are "the same pushforward/pullback coherence
machinery developed for the tensor–pullback substrate … a consumer of that coherence" — i.e. coupled to
the project-local Sq1 (`sheafificationCompPullback_comp`). This is FALSE (refuted iter-263). Replace it
with: the functor laws `pushPullMap_id` / `pushPullMap_comp` use ONLY Mathlib's pseudofunctor packaging
`Pseudofunctor (LocallyDiscrete Schemeᵒᵖ) (Adj Cat)` — the named 2-cell coherences
`conjugateEquiv_pullbackComp_inv` (`conjugate(pullbackComp.inv) = pushforwardComp.hom`),
`conjugateEquiv_pullbackId_hom`, and the unitor/pentagon lemmas `pseudofunctor_left_unitality`,
`pseudofunctor_right_unitality`, `pseudofunctor_associativity` — and are INDEPENDENT of the project-local
Sq1. Note the laws are still non-trivial (a multi-step mate calculus over the `eqToHom` triangle
transports along `Over.w` and the adjunction unit; plain `simp` makes no progress), but the obstacle is
Lean proof engineering over EXISTING Mathlib coherence, not a missing project ingredient.

### 2. [MUST-FIX] Add a lemma block + `\lean{}` + proof sketch for the functor laws
In `sec:cech_three_part` (after the push-pull brick paragraph) add a block for the functor laws — either
two lemmas or one combined "push-pull functor assembly" block — with:
- `\lean{AlgebraicGeometry.pushPullMap_id}` and `\lean{AlgebraicGeometry.pushPullMap_comp}` hints.
- A proof sketch naming the route:
  - `pushPullMap_id`: rewrite the head `unit ≫ (pushforwardComp 𝟙 Y.hom).hom` as the conjugate-mate of
    `(pullbackComp 𝟙 Y.hom).inv` via `conjugateEquiv_pullbackComp_inv`, then collapse the identity leg
    with `conjugateEquiv_pullbackId_hom` + `pseudofunctor_right_unitality` (at `X := Y.left`, `f :=
    Y.hom`), discharging the two `eqToHom` transports against the unitality `eqToHom`.
  - `pushPullMap_comp`: the same mate rewrite, then `pseudofunctor_associativity` (at `f := h.left`,
    `g := g.left`, `h := Y₁.hom`) to reassociate the three pullback comparisons, plus
    `Adjunction.unit_naturality` to slide the inner unit past the outer pushforward.
  - Note the bookkeeping friction: the `eqToHom`-through-`Over.w` transports and the
    `set_option backward.isDefEq.respectTransparency false` setting the Mathlib unitor lemmas are stated
    under; the `eqToHom`-glued composites must be written as fully-applied forward terms with explicit
    `congrArg` proofs (`refine ?_ ≫ ?_` fails).
- A `\uses{}` listing the relevant prior bricks (`pushPullObj`, `pushPullMap`, and the
  `def:cech_nerve` it feeds).

### 3. [MAJOR] Add `\lean{}` pins for the now-axiom-clean bricks
Add `\lean{}` references (with short definition blocks where none exist) for the iter-263 axiom-clean
declarations currently described only in prose:
- `\lean{AlgebraicGeometry.pushPullObj}` (object map `(Y,p) ↦ p_* p^* F`),
- `\lean{AlgebraicGeometry.pushPullMap}` (the 5-step morphism composite: adjunction unit ≫
  `pushforwardComp.hom` ≫ two `eqToHom` along `Over.w` ≫ `pushforward.map (pullbackComp.hom.app F)`),
- `\lean{AlgebraicGeometry.coverArrow}`, `\lean{AlgebraicGeometry.coverCechNerve}`,
  `\lean{AlgebraicGeometry.relativeCechComplexOfNerve}` (backbone plumbing).

## Out of scope
- Do NOT edit any other chapter.
- Do NOT touch `\leanok`/`\mathlibok`.
- Do NOT change the 4 documented sorry-theorems' statements (`CechAcyclic.affine`,
  `cech_computes_higherDirectImage`, `cech_flatBaseChange`, `CechNerve`) — they are correct and honestly
  gated on absent Mathlib infrastructure.
- Prose + `\lean{}`/`\uses{}` hints only; no Lean tactic code.

## References available
The Čech-to-derived-functor comparison is backed by Stacks ch.30 (Cohomology of Schemes) and the Čech
tags 02KE–02KH already cited in the chapter. The pseudofunctor coherence claim is a Mathlib-API fact
(no external textbook needed). Your write-domain includes `references/**` if you find you need a fresh
Stacks tag, but it is optional here.
