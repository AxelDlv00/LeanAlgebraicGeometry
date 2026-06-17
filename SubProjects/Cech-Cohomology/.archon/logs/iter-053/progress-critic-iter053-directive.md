# Directive: progress-critic (iter-053)

Assess convergence of the active route(s) below. Verdict per route: CONVERGING / CHURNING /
STUCK / UNCLEAR. Use ONLY the signals here.

## Route P5a-resolution — `cechAugmented_exact` (the augmented Čech complex is a resolution of qcoh F)

Strategy estimate: P5a phase `ACTIVE`, `Iters left ~4–5`. Phase entered its current (cechAugmented)
sub-work at iter-050.

Per-iter signals (last 4 iters):
- **iter-050:** dispatched as a Lane on `CechHigherDirectImage.lean`, but a plan-validate parser bug
  dropped both objectives → 0 provers actually ran. No prover data.
- **iter-051:** PARTIAL. Built the augmented-complex OBJECT layer (+6 axiom-clean decls:
  `cechAugmentedComplex` + 5 companions). The then-current "stalk-at-prime" route hit a genuine
  Mathlib gap (no `SheafOfModules.stalk`, no exact-iff-stalkwise). NO sorry inserted. Status PARTIAL.
- **iter-052:** PARTIAL. Planner re-routed to "sections/sheafification". Prover adopted it, then
  discovered `cechAugmented_exact` CANNOT be proved in `CechHigherDirectImage.lean` (every route
  ingredient lives in a file that transitively IMPORTS it ⇒ import cycle). Built +3 axiom-clean
  upstream site lemmas (`isZero_presheafToSheaf_obj_of_W` / `_of_W_isZero` / `_of_isLocallyBijective`)
  instead. NO sorry. Status PARTIAL. Prover's explicit recommendation: RELOCATE the theorem to a new
  downstream file.
- **iter-053 (proposed this iter):** relocate `cechAugmented_exact` to a NEW downstream file
  `CechAugmentedResolution.lean` (imports CechAcyclic + HigherDirectImagePresheaf + AffineSerreVanishing
  + QcohTildeSections, so all route ingredients are in scope); scaffold the stub; prover builds the
  one remaining bridge (module-sheafification IsZero reflected through faithful `toSheaf`, matching
  the existing `presheafToSheaf` site lemmas) + closes the theorem.

Sorry count: 0 across all iters (no hole ever inserted). Helpers added: +6 (i51), +3 (i52).
Recurring blocker phrase: "Mathlib gap (no stalk)" [i51] → "import cycle / file placement" [i52].

QUESTION FOR YOU: each iter added axiom-clean helpers but the named target `cechAugmented_exact` is
still unproved. Is this CHURNING (helpers multiply, residual unchanged), or is it genuine forward
progress toward an identified structural blocker that the iter-053 relocation actually resolves?
The key fact to weigh: the iter-051/052 helpers are NOT thrown away — they are exactly the object
layer + Step-2 site lemmas the relocated theorem imports and uses. The blocker shifted from "Mathlib
gap" (false framing) to "file placement" (a one-time routing fix), not the same wall re-hit.

## Route P5a-consumer — `higherDirectImage_openImmersion_comp` (affine open immersions are f_*-acyclic)

Strategy estimate: P5a phase `ACTIVE`, `Iters left ~4–5`.

Signals: FRESH route — no Lean declaration exists yet; no prior prover attempt. Its blueprint proof
sketch is complete and was blueprint-reviewer-cleared (iter-052). It consumes `affine_serre_vanishing`
(now unconditional, closed iter-052) + `higher_direct_image_presheaf` (done) +
`acyclic_resolution_computes_derived` (done, P4). Proposed this iter as a NEW parallel lane: scaffold
the stub (new file `OpenImmersionPushforward.lean`) + attempt as far as possible (mathlib-build).

QUESTION FOR YOU: this is a fresh lane (expect UNCLEAR). Flag only if opening it ALONGSIDE the
cechAugmented relocation in the same iter is an over-load risk given both are "deep" targets.

## This iter's proposed `## Current Objectives` (2 files, both new this iter)
1. `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean` — build `cechAugmented_exact`
   (deep, mathlib-build). [NEW FILE, scaffolded plan-phase]
2. `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean` — build
   `higherDirectImage_openImmersion_comp` (deep, mathlib-build). [NEW FILE, scaffolded plan-phase]
