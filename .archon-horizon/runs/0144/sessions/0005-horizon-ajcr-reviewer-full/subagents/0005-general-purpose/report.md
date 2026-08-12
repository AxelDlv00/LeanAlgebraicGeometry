All three theorems audit to exactly `[propext, Classical.choice, Quot.sound]`. The "local instance" warnings are just the source-scanner flagging the standard `attribute [local instance]` lines (benign, pre-existing). Task complete.

## Report

**Status per file**
- `AlgebraicJacobian/Picard/Pic0RankOneSplitOfPresentation.lean` — REPAIRED, clean. `lake env lean` exits 0; LSP diagnostics empty.
- `AlgebraicJacobian/Picard/Pic0RankOneSplitMembership.lean` (consumer) — builds clean once the dependency olean exists.
- `lake build AlgebraicJacobian.Picard.Pic0RankOneSplitOfPresentation AlgebraicJacobian.Picard.Pic0RankOneSplitMembership` → "Build completed successfully (9256 jobs)", EXIT=0. (Only pre-existing maxHeartbeats style-lint warnings in unrelated `Pic0RankOneNativeBaseChange*` files.)

**Diffs made** (proofs only; no signature/`sorry`/axiom changes; minimal)

1. Error 1 (testPoint naturality, `Over.exists_overSpecMap_testPoint_comp`): the `rw [..., ← hφ, Over.homMk_left]` failed because the re-introduced `Over.homMk (Spec.map …)` term is only type-correct at default transparency, so `Over.homMk_left` couldn't match at `instances` transparency. Replaced the `← hφ, Over.homMk_left` detour with a term-level bridge:
   ```
   have key : (Over.overSpecMap φ).left = Spec.map (Over.testPointFieldMap f t) :=
     congrArg Over.Hom.left hφ.symm
   rw [Over.comp_left, Over.comp_left, key]
   ```
   (`hφ.symm` avoids re-elaborating the `homMk` term inside the goal; `congrArg` typechecks at default transparency.)

2. Error 2 (`PicRankOneLocalPresentation.isSplitWitness`, the `hM` step): after `relPicAlgMap_mk` the two `CechPic.map` arguments differed only by the spelling `Over.Hom.left (C ◁ Over.overSpecMap (AlgHom.restrictScalars k ψ))` vs `relCurveMap C P.cover.Carrier L`. Added a bridging `have hcurve` mirroring the established sibling pattern in `Pic0RankOneLocalDivisor.lean:403-408`, threaded it into the `rw` chain, and closed the now-syntactically-identical residual with an explicit `rfl` (reducible auto-`rfl` from `rw` was insufficient):
   ```
   have hcurve : Over.Hom.left (C ◁ Over.overSpecMap (AlgHom.restrictScalars k ψ))
       = relCurveMap C P.cover.Carrier L := by
     refine congrArg (fun g : overSpec k L ⟶ overSpec k P.cover.Carrier => (C ◁ g).left) ?_
     exact Over.OverMorphism.ext rfl
   ...
     rw [..., relPicAlgMap_mk, hcurve]
     rfl
   ```

3. Error 3 (`isSplitWitness_of_mem_picRankOneOpen_field`): `rwa [e] at hsplit` failed on the `ConcreteCategory.hom … ↑` coercion pattern. Replaced with `exact e ▸ hsplit`.

**Axiom audit** (all three as expected):
- `AlgebraicGeometry.isSplitWitness_of_mem_picRankOneOpen_field` → `[propext, Classical.choice, Quot.sound]`
- `AlgebraicGeometry.mem_picRankOneOpen_iff_isSplitWitness` → `[propext, Classical.choice, Quot.sound]`
- `AlgebraicGeometry.isSplitWitness_testPoint_of_mem` → `[propext, Classical.choice, Quot.sound]`

No commit was made (not requested); the working tree change is confined to the one target file.
