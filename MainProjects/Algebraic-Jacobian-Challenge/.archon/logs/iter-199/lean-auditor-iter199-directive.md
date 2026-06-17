# Lean Auditor — iter199 scope

Files modified this iter (prover phase):

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean`

## Scope

Audit the 4 prover-touched files as Lean code (no strategy bias):

1. Newly added substrate declarations — confirm signatures are not
   over-constrained, no fake/placeholder bodies hidden in proofs,
   no instance-vs-theorem soundness regressions.
2. Specifically check the FGAPicRepresentability.lean carrier-soundness
   refactor: the moved `instHasSmoothProperQuotient` ⟨sorry⟩ instance
   constructor at L346 — is this the carrier-soundness probe pattern
   correctly applied, or has the sorry moved without semantic
   improvement?
3. Confirm the 2 new axiom-clean substrate helpers in WeilDivisor.lean
   (`order_neg`, `order_pow_of_ne_zero`) have correct hypothesis
   minimality.
4. Confirm the 4 new helpers in CodimOneExtension.lean
   (`cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`
   etc.) have correctly-named typeclass parameters and that the
   downstream `isRegularLocalRing_stalk_of_smooth` is properly
   constrained.
5. Flag any `sorryAx`-via-instance-synthesis leak (the iter-193 KB
   pattern).

Output the standard per-file checklist + flagged-issues block. Report
under `task_results/lean-auditor-iter199.md`.
