# Progress-critic directive — iter-055

Assess convergence of the two active prover routes. Per-route verdict
(CONVERGING / CHURNING / STUCK / UNCLEAR) + the corrective TYPE for any
CHURNING/STUCK route.

## Route 1 — `cechAugmented_exact` (file `CechAugmentedResolution.lean`)

The augmented Čech complex is a resolution of F (P5a-resolution input). Signals:

- iter-051: object layer built (+6 axiom-clean decls); exactness theorem NOT added
  (hit a stalk-functor Mathlib gap). sorry on the theorem not yet present.
- iter-052: discovered the theorem cannot live in `CechHigherDirectImage.lean`
  (import cycle); theorem absent; landed +3 upstream site lemmas instead.
- iter-053: relocated theorem to new file `CechAugmentedResolution.lean`; wired the
  whole sections/sheafification bridge end-to-end down to ONE residual `hSec`;
  +2 axiom-clean helpers. sorry = 1.
- iter-054: built `isZero_homology_of_homotopy_id_zero` (+1 helper); WIRED it in;
  sharpened the single residual from `IsZero (D.homology p)` to the exact
  contracting-homotopy obligation `Homotopy (𝟙 D) 0`. sorry = 1 (unchanged count).
- Recurring blocker phrase across 053/054: the residual is "Sub-brick A" = the
  per-degree section identification `Γ(V, pushPullObj F Y) ≅ ∏_σ Γ(U_σ ∩ V, F)` —
  the SAME L1 categorical→combinatorial bridge that also blocks the dead
  `CechAcyclic.affine`. iter-054 prover explicitly raised a "D1 reversal signal —
  genuine multi-iter wall" and recommended a STRUCTURAL move (extract the shared
  section-identification lemma; promote the `private` `CombinatorialCech.Dependent`
  engine to public), NOT another whole-theorem re-dispatch.
- helpers added per iter: 051 +6, 052 +3, 053 +2, 054 +1. Residual unchanged in
  essence (same wall) for 053→054.
- Strategy `Iters left` for this phase: ~1–2. Phase entered: ~iter-051 (so ~4
  elapsed iters in the phase already).

Planner's proposed iter-055 action for Route 1: do NOT re-dispatch the whole
theorem. Instead execute the structural corrective — (a) dispatch `effort-breaker`
to split Sub-brick A into a `\uses`-chain of atomic sub-lemmas in the blueprint
(backbone geometry, sections-over-coproduct, pullback-along-open-immersion,
differential match, contractibility-via-Dependent-engine); (b) `mathlib-analogist`
to de-risk the section/coproduct/pullback infra; (c) `refactor` to de-privatize the
`Dependent` engine + scaffold a new shared-lemma file; (d) prover scaffolds/starts
the bottom-most leaf. Is this the right corrective TYPE? Or is the route STUCK
(pivot needed)?

## Route 2 — `higherDirectImage_openImmersion_acyclic`/`_comp` (file `OpenImmersionPushforward.lean`)

Affine open immersions are f_*-acyclic (P5a-consumer). Signals:

- iter-053: new file; +1 axiom-clean private `isAffineHom_of_affine_separated`;
  both tops upgraded from bare sorry to real reductions; both bottom out on a
  SHARED bridge (1) = cohomology-presheaf identification. sorry = 2.
- iter-054: +4 axiom-clean helpers (`isZero_presheafToSheaf_of_sections_locally_zero`,
  `pushforwardSectionsFunctor` + additivity, a duplicated `isZero_of_faithful...`);
  `_acyclic` wired axiom-clean down to ONE precisely-typed residual
  `IsZero (((pushforwardSectionsFunctor j W).rightDerived q).obj H)` (= Serre
  vanishing on the affine `j⁻¹W`, q>0); `_comp` re-signed `Nonempty(A≅B)`→`A≅B`,
  body blocked on `_acyclic`. sorry = 2 (unchanged count).
- Recurring blocker phrase: the residual is the "02kg change-of-base" leaf —
  rightDerived-of-sections ↔ `Ext(jShriekOU(j⁻¹W),·)` + change-of-space
  `j⁻¹W ≅ Spec Γ`. iter-054 prover called it "a multi-iteration job."
- helpers added per iter: 053 +1, 054 +4. Residual sharpened 053→054 (now a clean
  precisely-typed Serre leaf).
- Strategy `Iters left` for this phase: ~2–3. Phase entered: ~iter-053 (so ~2
  elapsed iters in the phase).

Planner's proposed iter-055 action for Route 2: continue with a prover attacking
the residual (rightDerived-sections↔Ext + change-of-space transport to Spec R to
invoke the done `affine_serre_vanishing`); possibly decompose first. Is Route 2
CONVERGING (keep proving) or already needing decomposition?

## What I need from you

1. Per-route verdict.
2. For any CHURNING/STUCK route, the corrective TYPE (blueprint expansion /
   decomposition / Mathlib-idiom consult / structural refactor / route pivot).
3. Specifically: is the planner's Route-1 structural corrective the right response,
   or is it over-engineering (should I just fine-grained one leaf)?
4. Is dispatching BOTH routes' provers this iter sound, or should one wait while the
   other's decomposition lands?
