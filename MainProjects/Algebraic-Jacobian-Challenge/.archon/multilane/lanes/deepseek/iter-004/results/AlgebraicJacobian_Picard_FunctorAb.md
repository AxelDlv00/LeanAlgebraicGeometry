# AlgebraicJacobian/Picard/FunctorAb.lean

## Result: RESOLVED (no sorries needed)

### `PicardFunctorAb` (line 48)

- **Status:** ALREADY CLOSED — no sorry was present.
- **Approach:** The refactor agent (iter-004) already wrote the full `Functor` constructor with `obj`, `map`, `map_id`, and `map_comp` filled in. No prover action was required.
- **Body:**

```lean4
noncomputable def PicardFunctorAb
    (C : Over (Spec (CommRingCat.of k))) :
    (Over (Spec (CommRingCat.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u} where
  obj S := AddCommGrpCat.of (Additive
    (Pic (Limits.pullback C.hom S.unop.hom) ⧸
      (Pic.pullback (Limits.pullback.snd C.hom S.unop.hom)).range))
  map {_ _} f :=
    AddCommGrpCat.ofHom (MonoidHom.toAdditive (PicardFunctor.quotMap C f.unop))
  map_id _ := by
    simp only [unop_id, PicardFunctor.quotMap_id, MonoidHom.toAdditive_id,
      AddCommGrpCat.ofHom_id]
  map_comp f g := by
    simp only [unop_comp, PicardFunctor.quotMap_comp]
    rw [show MonoidHom.toAdditive
        ((PicardFunctor.quotMap C g.unop).comp (PicardFunctor.quotMap C f.unop)) =
        (MonoidHom.toAdditive (PicardFunctor.quotMap C g.unop)).comp
          (MonoidHom.toAdditive (PicardFunctor.quotMap C f.unop)) from rfl,
      AddCommGrpCat.ofHom_comp]
```

- **Key design decisions:**
  - Uses `Additive` wrapper to convert the multiplicative `CommGroup` on the `Pic` quotient to the `AddCommGroup` required by `AddCommGrpCat.of`.
  - `MonoidHom.toAdditive` bridges the multiplicative `PicardFunctor.quotMap` to the additive world expected by `AddCommGrpCat.ofHom`.
  - Functoriality reduces to existing `PicardFunctor.quotMap_id` / `PicardFunctor.quotMap_comp` via `simp`.
- **Compilation:** `lake build` passes clean — no errors, no warnings for this file.
- **Axioms:** No new axioms.
- **Blueprint markers:** `def:Pic_functorAb` is ready for `\leanok` (statement + proof both complete).
