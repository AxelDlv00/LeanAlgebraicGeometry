# lean-vs-blueprint-checker — OCofP.lean ↔ RiemannRoch_OCofP.tex

## File pair

- **Lean**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/OCofP.lean`
- **Blueprint**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_OCofP.tex`

## What changed this iter (Lane D — iter-180)

- `globalSections_iff` body split via `refine ⟨fun _h => ?_, fun _h => ?_⟩` into both Iff directions. Both directions remain `sorry` because both consume the body of `lineBundleAtClosedPoint` (the iter-180 typed sorry blocked on Sheaf-internal Hom + ModuleCat-forget infrastructure).
- File sorry count by declaration unchanged at 5; sorry-token count internal to `globalSections_iff` +1 (split into 2 sub-sorries).
- The prover's task_result raises a concern that `globalSections_iff` as currently typed is "mathematically odd" — the RHS doesn't mention `f`. Flag if the blueprint has the same issue or if the type is in `archon-protected.yaml`.

## Report bidirectionally

1. **Lean → blueprint**: does the chapter's prose match what the Lean lemma's RHS actually says? Is the iff type the right strength for downstream `RR.3` consumers (`dim_eq_two_of_genusZero`, `exists_nonconstant_genusZero`)?
2. **Blueprint → Lean**: is the chapter detailed enough on the `lineBundleAtClosedPoint` construction (dual of ideal sheaf of closed point) for iter-181+ to either land the body OR open the ground-up `IdealSheafDual` helper file the prover recommends?

Output to `task_results/lean-vs-blueprint-checker-ocofp.md`.
