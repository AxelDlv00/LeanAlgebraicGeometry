Both endpoint theorems (`picClass_eq_one_iff`, `picClass_map`) depend only on the standard axioms `propext`, `Classical.choice`, `Quot.sound` — no `sorryAx`. Final verification passed: `lake env lean AlgebraicJacobian/Descent/UnitDescent.lean` exits 0 with no output, and `grep sorry` finds nothing.

## Report

**File:** `/home/Axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/UnitDescent.lean` (575 lines; over the 500 soft cap — started at 358 with stubs, correctness prioritized)

**All 8 sorries closed, none resisted:**
1. `baseChange_unitCoaction` (tmul) — `simp only` with `LinearMap.baseChange_tmul`, `tmul_mul_tmul`, `one_mul`, exactly per sketch.
2. `descendedOneEquiv` — `equivDescended` against `AlgebraTensorModule.rid A B B`; compatibility on pure tensors via `tmul_smul`/`smul_tmul'`.
3. `descendedMulEquiv` — via new private helper `descendedMulAux` (distribBaseChange ≪≫ congr of the two descentEquivs ≪≫ lid) with simp lemma `descendedMulAux_tmul` proved by a defeq `change` (simp couldn't match `descentEquiv_tmul` through the non-reducible `IsDescentCocycle.descended`); compatibility closed with `linear_combination` after splitting pure tensors.
4. `isDescentCocycle_descentCoboundary` — normalization by `lmul'_apply_tmul` + `Units.mul_inv`; cocycle telescopes under `simp only [tmul_mul_tmul, Units.inv_mul, ...]`.
5. `descendedCoboundaryMulEquiv` — explicit `LinearEquiv` structure; both membership directions by `linear_combination` with unit relations `(β⁻¹⊗1)(β⊗1)=1`, `(1⊗β⁻¹)(1⊗β)=1`.
6. `eq_descentCoboundary_of_equiv` — the composite `rid.symm ≪≫ baseChange e.symm ≪≫ descentEquiv` equals `b ↦ b * m₀` **by `rfl`**; `IsUnit.of_mul_eq_one` (current mathlib name), finish by `Units.ext` + `linear_combination`.
7. `IsDescentCocycle.map` — four naturality `have`s by `TensorProduct.induction_on`, then transport of `hu`'s two fields.
8. `descendedMapEquiv` — `liftBaseChange B' (h ∘ₗ subtype)`; bijectivity via `letI : Algebra B B' := h.toRingHom.toAlgebra` + tower, factoring through `cancelBaseChange.symm ≪≫ LinearEquiv.baseChange B B' _ _ descentEquiv ≪≫ rid B B' B'` (all-B'-linear — the sketch's mixed-ring `TensorProduct.congr` blocked `map_add`/`map_zero`); compatibility by applying `map h h` to the membership equation + `linear_combination`.

**No statement/signature changes.** Additions beyond proofs: private `ofUnit_coaction` (simp, rfl), private `descendedMulAux`/`descendedMulAux_tmul`, one explicit `(N := ...)` hint at an `equivDescended` call (elaboration-order fix the CLI caught but the LSP missed).

**One repair to pre-existing code (flagging):** `DescentDatum.ofUnit.coassoc`'s proof stopped closing once `baseChange_unitCoaction` became a real proof — the trailing goal `descentFace₁₃ u * descentFace₁₂ (m ⊗ₜ 1) = descentFace₁₃ u * descentFace₁₃ (m ⊗ₜ 1)` no longer closed via `rw`'s implicit rfl; appended `simp only [descentFace₁₂_tmul, descentFace₁₃_tmul]`. Proof-only change, statement untouched.

result: All 8 sorries in AlgebraicJacobian/Descent/UnitDescent.lean closed axiom-clean (picClass calculus: one/mul/coboundary/eq-one-iff/map); `lake env lean` exits 0 with no output, no statement changes.
