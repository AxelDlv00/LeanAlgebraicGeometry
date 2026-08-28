Cross-project reuse findings (read-only; no edits):

- Hartshorne’s current substrate is already sufficient for a clean quotient API:
  - `HartshorneLib/Chapter4DivisorClass.lean`: `LinearlyEquivalent`, `DivisorClassGroup`, `divisorClass`, `linearlyEquivalent_iff_divisorClass_eq`, `linearlyEquivalent_iff_exists`, and simp theorem `divisorClass_principalDivisor`.
  - `HartshorneLib/Chapter4DegreeClass.lean`: `PrincipalDivisorsHaveDegreeZero`, `degreeClass`, `degreeClass_divisorClass`, `degreeClass_zero`, `degreeClass_add`, `degree_eq_of_linearlyEquivalent`, and now `degreeClass_principalDivisor` (already added by another agent). Focused `lake env lean HartshorneLib/Chapter4DegreeClass.lean` passes.

- Recommended next proof target:
  ```lean
  theorem divisorClass_eq_zero_iff_exists_principal (D : CurveDivisor k X) :
      divisorClass D = 0 ↔ ∃ g : X.left.functionFieldˣ, D = principalDivisor g
  ```
  Proof chain:
  `divisorClass D = 0 ↔ divisorClass D = divisorClass 0` by simp,
  `(linearlyEquivalent_iff_divisorClass_eq D 0).symm`,
  `linearlyEquivalent_iff_exists D 0`,
  then simp to reduce `D - 0 = D`.
  It is source-facing, useful for later Jacobian work, and requires no new geometric assumptions.

- AJC exact principal-degree APIs (not directly importable because separate lakefile/import cone):
  - `AlgebraicGeometry.Scheme.WeilDivisor.addEquivNonGeneric_principal`
  - `AlgebraicGeometry.Scheme.WeilDivisor.degree_principal_eq_deg`
  - `AlgebraicGeometry.Scheme.WeilDivisor.degree_principal_eq_zero_of_isAlgClosed`
  - bundled `AlgebraicGeometry.Scheme.WeilDivisor.degree_principal_eq_zero_curve`
  from `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/PrincipalTransport.lean`.
  Supporting declarations include `CurveDivisorIndexBridge.degree_eq_sum_nonGeneric`, `Ledger.ResidueOneAlgClosed`’s `Scheme.CurveDivisor.deg_eq_sum_of_isAlgClosed` and `sum_divOf_eq_zero_of_isAlgClosed`, `Ledger.ChiLedger.deg_divOf`, and `Ledger.PrincipalCompare.Scheme.ordZ_toAdd_eq_log_ordFrac`.

- AJC also has `Scheme.WeilDivisor.principal_degree_zero` in `RiemannRoch/WeilDivisor.lean` and `AlgebraicGeometry.degree_principal_eq_zero_of_isAlgClosed_curve` in `RiemannRoch/Adelic/ResidueField.lean`, but both depend on a large χ-ledger/residue/index transport stack and are poor immediate Hartshorne targets. No Mathlib product-formula/principal-divisor degree theorem was found.

- StacksProject contains generic-point/cycle infrastructure (`IntegralCarrier.genericPoint`, `genericPoint_mem`, `closure_genericPoint`, `PointCycle.finite_carrierSupport_of_isCompact`) and standard-open APIs, but those projects are separate libraries and are useful as proof patterns rather than imports.
