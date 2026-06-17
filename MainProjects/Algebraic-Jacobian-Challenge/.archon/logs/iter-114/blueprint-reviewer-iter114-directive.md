# Blueprint Reviewer Directive

## Slug
iter114

## Strategy snapshot

End-state. The project formalizes the Jacobian of a smooth proper geometrically irreducible curve over a field. 9 protected declarations (signatures frozen) are the deliverables. Phase A (Čech acyclicity in `BasicOpenCech.lean`) is paused/deferred via Option (i) budget-deferral + L1120 PAUSED. Phase B (cotangent sheaves in `Differentials.lean`) is the active prover route this iter, with 3 in-scope sorries (L175 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`, L880 `smooth_iff_locally_free_omega`, L897 `cotangent_at_section`) + 2 named-deferred (L798 `h_exact`, L1039 `serre_duality_genus`). Phase C1 (refined `LineBundle`) is DONE; Phase C2 (PicardFunctor) collapsed; Phase C3 (representability) deferred via `JacobianWitness` exit policy.

Iter-114 prover lane target: `Differentials.lean` L175 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` (the iter-113 NEW Bar-B-variant sub-helper that carries the residual mathematical content of the sheaf-condition proof for `Ω_{X/S}` after the iter-113 reformulation).

## Routes

Single load-bearing route this iter: Phase B unique-gluing closure on `Differentials.lean`. The chapter `Differentials.tex` is the load-bearing blueprint for the prover lane this iter. Other blueprint chapters should be audited for completeness/correctness per the standard mandatory pass.

## References

- `references/challenge.lean`: original Christian Merten challenge file; pins the 9 protected declarations and signatures.

## Focus areas (optional)

- **`Differentials.tex`** — iter-113 introduced a new top-level helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` at Lean L168 (with sorry body) and re-routed helper #1 at Lean L209 through the Mathlib chain `isSheaf_of_isSheafUniqueGluing_types → IsSheaf.isSheafOpensLeCover`. The blueprint Route (a) prose (L33–L53 of Differentials.tex) describes the proof of `relativeDifferentialsPresheaf_isSheaf` as a refinement-cofinality argument against `isSheaf_iff_isSheafOpensLeCover`, NOT via the unique-gluing pivot. Lean-vs-blueprint-checker-iter113 flagged this as a major blueprint adequacy gap. Audit: is this gap currently must-fix? (The iter-114 plan will dispatch a blueprint-writer for Differentials.tex regardless; the question is whether your audit raises new must-fixes elsewhere.)
- Also flagged by lean-vs-blueprint-checker-iter113: `serre_duality_genus` (L1039) has residual hypothesis-strength mismatches — Lean uses `IsIntegral C.left` + `Smooth C.hom` (dimension-free), chapter prose says "geometrically irreducible curve" + dimension-1 implicit. Strategy is to relax prose to match Lean (since `IsGeometricallyIntegral` for schemes is `[gap]` in Mathlib b80f227 per iter-113 verification). Audit: is this must-fix for the iter-114 prover lane on L175? (Likely no — L175 is on a different theorem — but you decide.)

## Known issues

- Iter-112 blueprint-reviewer's stale-line-ref items in `Cohomology_MayerVietoris.tex` and `Picard_Functor.tex` (line numbers drift from declaration-line vs sorry-line). Cosmetic; queue for iter-114+ cleanup if you flag.
- `Picard_FunctorAb.tex` "scaffolded" wording at chapter L31–L41 is stale (the etale-sheafification is in fact closed at Lean L107–L111). Cosmetic.

The iter-114 plan-phase will dispatch a blueprint-writer for `Differentials.tex` regardless of your verdict — the route divergence + the Serre-duality hypothesis mismatch + a `\lean{...}` block for the new helper are all on the writer's agenda. Your verdict gates additional prover dispatches; the writer dispatch is pre-committed.
