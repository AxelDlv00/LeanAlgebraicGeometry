# Mathlib Analogist Report

## Slug
cotangent-vanishing-pile-iter126

## Iteration
126

## Question

What is current Mathlib's coverage of the **shared cotangent-vanishing
pile** that gates both M2.a body closure and the M2.d-alt genus-0
identification alternative? For each of the four pieces:

(i) Abelian-variety cotangent triviality `Ω_{A/k}` trivial of rank `dim A`;
(ii) scheme-level `df = 0 ⇒ f` factors through `Spec k`;
(iii) characteristic-`p` handling (Frobenius iteration / Mumford / lifting to char 0);
(iv) Serre duality on a smooth proper curve (M2.d-alt-only).

What does Mathlib already have, what's missing, what's the per-piece
project-internal LOC build estimate, what's the recommended build order,
and (for piece iii) which option is most cost-effective?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (i) Abelian-variety cotangent triviality | NEEDS_MATHLIB_GAP_FILL (directive under-scoped 4×) | critical |
| (ii) `df = 0 ⇒ f` factors through `Spec k` | ALIGN_WITH_MATHLIB (ring) + NEEDS_MATHLIB_GAP_FILL (scheme) | major |
| (iii) char-`p` handling — recommend Option A (Frobenius iteration) | NEEDS_MATHLIB_GAP_FILL (scheme-level Frobenius); ALIGN ring-level on `frobenius`/`iterateFrobenius` | critical (option pick) |
| (iv) Serre duality on a smooth proper curve | NEEDS_MATHLIB_GAP_FILL — **DEFER** (directive under-scoped 10-40×, used only by M2.d-alt) | critical |
| (v) [meta] build order | PROCEED on (i) → (ii) → (iii); piece (iv) parked | informational |

## Must-fix-this-iter

These are the items the plan agent must act on **this iteration**
(iter-126) before iter-127+ blueprint chapters and STRATEGY.md
sequencing commit to the wrong LOC budgets:

- **(i) — piece (i) is under-scoped 4×.** The directive (and
  `RigidityKbar.tex:63`) estimate piece (i) at 200-400 LOC. Realistic
  estimate is **800-1500 LOC** because the cotangent triviality is not
  a single lemma: it is a chain (Lie-algebra-of-`GrpObj` definition +
  mulRight-globalisation + trivialisation of the relative cotangent
  presheaf) on top of the project's existing `relativeDifferentialsPresheaf`
  (and inheriting the presheaf-vs-sheaf bridge cost noted in
  `analogies/cotangent-presheaf-design.md`). The iter-127+ blueprint
  chapter for piece (i) and the iter-128 scaffold directive must commit
  to the 800-1500 LOC estimate, not 200-400. **Action**: revise
  `RigidityKbar.tex:63` and `STRATEGY.md:189` (and the iter-128 trigger
  at `STRATEGY.md:486`) to reflect the corrected per-piece estimate.

- **(iv) — piece (iv) is under-scoped 10-40× AND should be DEFERRED.**
  The directive estimates 200-400 LOC; the pre-existing
  `analogies/serre-duality.md` (iter-110) verdict is **3000-8000 LOC**
  for honest closure, deferred as a named gap. Piece (iv) is only used
  by M2.d-alt (genus-0 identification alternative), not by M2.a's
  C.2.d (per the directive's own scoping). **Action**: re-scope piece
  (iv) **out of the iter-129+ shared-pile build**. M2.d-alt's piece
  (iv) becomes a named-gap deferral inside M2.d-alt, mirroring the
  existing `Differentials.lean:877` `serre_duality_genus` named gap.
  Revise `RigidityKbar.tex:75-78` to acknowledge the
  `serre-duality.md` iter-110 verdict.

- **(iii) option pick: Frobenius iteration (Option A) is decisively
  the right choice.** Options B (Mumford no-rational-curves) and C
  (Witt vector lifting) each carry standalone multi-thousand-LOC
  dependencies (Mumford requires the very Pic⁰ / cotangent machinery
  the project is trying to streamline; Witt-vector lifting requires a
  scheme-level Witt functor + smooth deformation + descent that
  Mathlib entirely lacks). Option A (Frobenius iteration) consumes
  Mathlib's first-class ring-level `frobenius` / `iterateFrobenius`
  from `Mathlib.Algebra.CharP.Frobenius.lean` and the project's
  existing scheme-level Frobenius design context from
  `AlgebraicJacobian/Rigidity.lean:48-55`. **Action**: commit
  `STRATEGY.md` and the iter-129+ piece-(iii) build directive to
  Option A.

## Major

- **(ii) — align with `Differential.ContainConstants` typeclass at the
  ring level.** Mathlib's `Mathlib/RingTheory/Derivation/DifferentialRing.lean:62-70`
  has the only existing "derivation kernel = base ring" idiom as a
  typeclass (one Mathlib consumer:
  `FieldTheory/Differential/Liouville.lean`). The project's piece-(ii)
  ring-level half should register an instance
  `[CharZero B] [IsIntegralDomain B] [Algebra A B] [Differential B] ⇒
  ContainConstants A B` rather than re-prove the fact in a parallel
  declaration. The scheme-level half is genuinely missing from Mathlib
  and is NEEDS_MATHLIB_GAP_FILL; recommended name pattern is
  `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` (following the
  iter-125-refactored `ext_of_eqOnOpen` idiom, not the directive's
  `isConst_of_diff_zero`). Realistic estimate: **250-500 LOC** (slightly
  above the directive's 200-400).

- **Naming idiom: piece (i) target should be in the `GrpObj` namespace,
  not `AbelianVariety`.** The directive offers
  `AlgebraicGeometry.AbelianVariety.cotangent_trivial` or
  `GroupScheme.Omega_trivial`. Mathlib `b80f227` has **no `AbelianVariety`
  file at all**, and the `Group/{Abelian,Smooth}.lean` files use
  `GrpObj G` over `Over (Spec (.of K))` (Yang+Merten 2026). The project
  should align with this: recommend
  `AlgebraicGeometry.GrpObj.omega_free` plus
  `AlgebraicGeometry.GrpObj.omega_rank_eq_dim` rather than the
  directive's two candidate names.

## Informational

- **(v) — recommended build order**: piece (i) → piece (ii) → piece
  (iii). Piece (i) is the dominant cost; pieces (ii) and (iii) consume
  it. Piece (iv) is parked, not built.

- **Honest realistic critical-path build**: pieces (i) + (ii) + (iii) =
  **1350-2600 LOC** over **7-14 iters**, vs the directive's combined
  "800-1500 LOC" estimate (which conflated piece costs). Honest M2.a
  body closure lands at **iter-138 to iter-145+**; honest M2 closure
  lands at **iter-150+**, in line with `STRATEGY.md:492`'s
  "iter-152 to iter-170+" range. The user-hint-suggested
  iter-151 lower-bound is achievable only if piece (i) hits its
  optimistic 800-LOC corner.

- **Project consumption of pre-existing analogies**:
  - `analogies/serre-duality.md` (iter-110): verdict reaffirmed for
    piece (iv); deferred-named-gap recommendation stands.
  - `analogies/cotangent-presheaf-design.md` (iter-120): the
    project's existing `relativeDifferentialsPresheaf` is the natural
    input for piece (i)'s cotangent triviality; the presheaf-vs-sheaf
    bridge cost is inherited.
  - `analogies/c1-route.md` (iter-108): not directly relevant to the
    cotangent-vanishing pile (curve-side cohomology infrastructure for
    Picard groups, a different chapter).

## Persistent file

- `analogies/cotangent-vanishing-pile.md` — design rationale captured
  for future iter-129+ build lanes. Contains per-decision Mathlib
  citations (`Group/Abelian.lean:128-145`, `Group/Smooth.lean:38-60`,
  `RingTheory/Derivation/DifferentialRing.lean:62-70`,
  `Algebra/CharP/Frobenius.lean:30-110+`, `RingTheory/WittVector/*`,
  zero hits for Serre duality / dualizing sheaf / Pic⁰ /
  AbelianVariety / no-rational-curves), per-piece LOC estimates with
  correction-factor justifications, and naming-idiom alignment
  recommendations.

## Overall verdict

The directive's four-piece scoping is **structurally correct** (the
four pieces are the right decomposition; the (i)→(ii)→(iii) dependency
is real; piece (iv) is correctly identified as M2.d-alt-only).
**However, two material corrections are required**: piece (i)
under-scoped 4× (800-1500 LOC, not 200-400), and piece (iv)
under-scoped 10-40× AND should be deferred per the binding
`serre-duality.md` verdict (3000-8000 LOC if built; deferred as named
gap per project policy). The recommended characteristic-`p` option is
**Frobenius iteration (Option A)**, decisively over Options B and C
which each carry standalone multi-thousand-LOC dependencies.
