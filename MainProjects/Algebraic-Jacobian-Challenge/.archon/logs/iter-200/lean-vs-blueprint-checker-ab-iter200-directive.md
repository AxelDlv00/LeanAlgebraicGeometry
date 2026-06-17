# Lean ↔ blueprint check — `Albanese/AuslanderBuchsbaum.lean` vs
# `Albanese_AuslanderBuchsbaum.tex`

## Files

- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

## Iter-200 edits

Lane AB-gap1-HasPdLT (mathlib-build, ALIGN_WITH_MATHLIB pivot per
mathlib-analogist `ab-natrecursive` Path A recipe).

4 new axiom-clean substrate helpers added to `RingTheory.Module`
namespace:

1. `hasProjectiveDimensionLT_succ_of_projectiveDimension_eq` (L1290)
   — bridge from `Module.projectiveDimension R M = (n : WithBot ℕ∞)`
   to `HasProjectiveDimensionLT (ModuleCat.of R M) (n + 1)`.
2. `hasProjectiveDimensionLT_ker_of_surjection` (L1311) — syzygy
   descent via `LinearMap.shortExact_shortComplexKer` +
   `ModuleCat.projective_of_free` +
   `ShortComplex.ShortExact.hasProjectiveDimensionLT_X₁`.
3. `hasProjectiveDimensionLT_succ_of_hasProjectiveDimensionLT_ker`
   (L1340) — companion ascent via `hasProjectiveDimensionLT_X₃`.
4. `depth_ker_ge_min_of_surjection_finite_localRing` (L1376) — depth
   lower bound for kernel of surjection from free.

Body of `auslander_buchsbaum_formula_succ_pd` (L1574-area) modified to
set up the SES-descent path; ends in trailing sorry (closure blocked
on Stacks 00MF + ℕ∞ arithmetic).

Sorries: 1 → 1.

## What I need from you

Bidirectional check, per your descriptor:

1. **Lean → blueprint**: are the 4 new substrate helpers reflected in
   the chapter? The prover's handoff explicitly recommends:
   (a) update `\subsec:ab_gap1_first_step` → indicate the
   ALIGN_WITH_MATHLIB pivot (gap (1)'s "full chain complex" cost
   replaced by 4 axiom-clean per-syzygy helpers);
   (b) reclassify gap (3) (snake lemma on minimal resolution) from
   "open" to "OBVIATED" — the SES-descent path obviates it entirely.
2. **Blueprint → Lean**: the iter-199 plan agent added a standalone
   `\lean{RingTheory.Module.exists_minimalSurjection_finite_localRing}`
   block and a `\subsec:ab_gap1_first_step` subsection. Confirm those
   `\lean{...}` pins still resolve correctly.
3. **Chapter completeness for iter-201+ prover**: gap (2) Stacks 00MF
   is the binding closure gap. Does the chapter currently sketch a
   recipe for 00MF? If not, flag for plan-agent expansion.

## Severity rating

- `must-fix-this-iter` blocks downstream prover work next iter.
- `soon` should be addressed within 1-2 iters.
- `major` / `minor` are advisory.

## Output

Write to `.archon/task_results/lean-vs-blueprint-checker-ab-iter200.md`.
