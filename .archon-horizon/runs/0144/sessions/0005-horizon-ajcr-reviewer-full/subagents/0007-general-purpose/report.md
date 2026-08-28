## Progress

- **`AlgebraicJacobian/Picard/Pic0RankOneSectionFibreNonzero.lean`** (new, 163 lines): both required declarations proved, kernel-clean, no `sorry`. Committed to the ledger as `21091eb533`.

**Status: complete.**

## Declarations

1. `AlgebraicGeometry.BasicOpenCocycleDatum.sectionsMapTop_ne_zero_of_divEq_certified` — for `D : BasicOpenCocycleDatum C B pi` (`[IsAffineHom pi]`), `s : ↥(gluedSubmodule B D.pieces D.unit ⊤)`, any subordinated pointed cover (`𝒲 : (relCurve C B).PointedCover`, `σ : relCurve C B → D.index`, `hσ : ∀ x, 𝒲.opens x ≤ D.pieces (σ x)`), germ-regularity `hreg` (the exact `sectionLocalEquations` hypothesis), `hd : IsLocallyCertifiedAff (genus C) d`, and `hdiv : DivEq (D.sectionLocalEquations s 𝒲 σ hσ hreg) d`: conclusion `D.sectionsMapTop q.asIdeal.ResidueField s ≠ 0` for every `q : PrimeSpectrum B`.
2. `AlgebraicGeometry.BasicOpenCocycleDatum.tmul_residueField_ne_zero_of_divEq_certified` — tensor-form consumer (`[IsFinite pi]`, `hH1 : Subsingleton (datumPair D).H1`): for `y : Sheaf.HModule D.sheaf 0` whose glued section (via `Sheaf.HModule.linearEquiv₀ … isTerminalTop D.sheaf y`) satisfies the same divisor hypotheses, `y ⊗ₜ[B] (1 : κ(q)) ≠ 0` in `Sheaf.HModule D.sheaf 0 ⊗[B] κ(q)` — literally the input shape of `Module.exists_notMem_bijective_toSpanSingleton` / `exists_notMem_smul_eq_of_tmul_ne_zero`.

**Proof route** (as designed): contradiction at an arbitrary point `z` of the integral fibre curve (`instIsIntegralBaseChange`, `IsIntegral.nonempty`). Vanishing of `sectionsMapTop` zeroes every base-changed component (`component_sectionsMapTop` + a private `component_zero`), hence the pulled cut equation is the zero section (`Scheme.Hom.appLE_resHom` + `resHom_piecesMap_eq_relAffSectionsMap`); the certificate's arbitrary-tower engine `IsLocallyCertifiedAff.germ_pullbackEqn_mem_nonZeroDivisors` plus `germ_pullbackEqn_mem_nonZeroDivisors_of_divEq` (DivisorFamilyZarKit) makes that germ a nonzerodivisor; `zero_notMem_nonZeroDivisors` in the nontrivial local stalk closes it. Corollary reduces through `linearEquiv₀_datumH0BaseChange_one_tmul` + `TensorProduct.comm`.

## Axiom audit (lean_verify)

Both theorems: exactly `[propext, Classical.choice, Quot.sound]`. Source-scan flags only line 46 "local instance" — the house-standard `attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra` preamble every sibling file carries.

## Verification output

- `lake env lean AlgebraicJacobian/Picard/Pic0RankOneSectionFibreNonzero.lean` → clean, zero output.
- `lake build AlgebraicJacobian.Picard.Pic0RankOneSectionFibreNonzero` → `✔ Built … Build completed successfully (8904 jobs)`. All warnings in the log are **pre-existing replays from other modules** (`Pic.lean` show-linter, `DivRepClassifyZar*`/`GluedSheafH0BaseChange` maxHeartbeats-comment linter, the known `Challenge.lean:278` `sorry` stub `Jacobian`); the new file contributes none.

## Deviations (none weakening; all forced by actual signatures)

- Standing curve bundle `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` added as variables — required for `genus C` to typecheck and for fibre integrality (same bundle as Pic0RankOneLocalDivisor.lean).
- Corollary carries `hH1 : Subsingleton (datumPair D).H1` — required for the datum H⁰ base-change bridge to exist (same hypothesis as sibling `sectionsMapTop_ne_zero_of_one_tmul_ne_zero`); discharged on the rank-one lane by `P.datumPair_h1_baseChange`.
- Used `germ_pullbackEqn_mem_nonZeroDivisors_of_divEq` directly instead of `divEq_pullback` (sharper: no need to construct the pulled system); no point-in-piece selection needed since the pulled equation vanishes on the whole pulled member.
- `set_option maxHeartbeats 1600000` on the corollary only (dependent glued-sheaf carriers; sibling H0-base-change files use up to 2000000), with the linter-required justifying comment. The `relCurve.instOver` priority bump was not needed.
