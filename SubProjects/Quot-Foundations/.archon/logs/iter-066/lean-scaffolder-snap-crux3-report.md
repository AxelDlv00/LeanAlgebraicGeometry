# Report — lean-scaffolder, slug `snap-crux3` (iter-066)

## Outcome: SUCCESS

Both target declarations added to `AlgebraicJacobian/Picard/SectionGradedRing.lean`.
`lake build AlgebraicJacobian.Picard.SectionGradedRing` is green.
Both new decls register as real sorries (lines 977 and 1031 in the build output).

---

## Declarations added

### 1. `AlgebraicGeometry.Scheme.Modules.ztensor_whisker_localIso`

**File:** `AlgebraicJacobian/Picard/SectionGradedRing.lean` (line ~976)
**Blueprint:** `lem:snap_ztensor_whisker_localIso` (chapter line ~716)

```lean
lemma ztensor_whisker_localIso {P Q : X.PresheafOfModules}
    (f : P ⟶ Q)
    (hf : (opensTopology X).W ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map f))
    (R : X.PresheafOfModules) :
    (opensTopology X).W
      ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map
        (MonoidalCategory.whiskerRight (C := MonoidalPresheaf X) f R)) := by
  sorry
```

**Phrasing note:** The blueprint says "morphism of abelian-group presheaves", but the Lean
statement uses `PresheafOfModules` morphisms (whose underlying abelian morphism is assumed
in `J.W`). This is the directly applicable form: the prover applies this with `f` being
the underlying PresheafOfModules lift of `η_P`, which is what appears in the
`isIso_sheafification_whiskerRight_unit` proof route.

**Key fix:** `MonoidalCategoryStruct X.PresheafOfModules` does NOT synthesize (instance is
on `PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat)`, and `X.ringCatSheaf.obj` is
`RingCat`-valued, not recognizably in that form). Fix: use `(C := MonoidalPresheaf X)`
ascription (as in the existing `sectionsMul` declaration).

---

### 2. `AlgebraicGeometry.Scheme.Modules.isIso_sheafification_whiskerRight_unit`

**File:** `AlgebraicJacobian/Picard/SectionGradedRing.lean` (line ~1030)
**Blueprint:** `lem:isIso_sheafification_whiskerRight_unit` (chapter line ~961)

```lean
lemma isIso_sheafification_whiskerRight_unit (P Q : X.PresheafOfModules) :
    IsIso (sheafification.map
      (MonoidalCategory.whiskerRight (C := MonoidalPresheaf X)
        ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app P) Q)) :=
  sorry
```

**Strategy comment:** A `/- Planner strategy: ... -/` block immediately above the declaration
encodes the full 4-step proof:
1. Apply `isIso_sheafification_map_iff` to reduce to `J.W` question.
2. Present `P ⊗_p Q` as a coequalizer via `relativeTensorCoequalizerIso` (axiom-clean in-file).
3. Apply `ztensor_whisker_localIso` (decl 1) + `localIso_toPresheaf_map_unit` to show the
   ℤ-whiskered unit maps on both rows lie in `J.W`; use that left-adjoint sheafification
   preserves the coequalizer and turns `J.W`-morphisms into isos.
4. Feed back through `(isIso_sheafification_map_iff _).mpr`.

Key references injected: `evaluationJointlyReflectsColimits` (Mathlib file + line),
`relativeTensorCoequalizerIso` API, `AddCommGrpCat` vs `AddCommGrp` note,
`MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q` spelling note.

---

## Build status

```
Build completed successfully (2436 jobs)
```

Warnings: only long-line style lints (pre-existing + comment lines in new blocks).
No errors. Two new sorry declarations confirmed at:
- line 977: `ztensor_whisker_localIso`
- line 1031: `isIso_sheafification_whiskerRight_unit`

---

## Uncovered declarations

None — both scaffolded declarations have corresponding blueprint entries
(`lem:snap_ztensor_whisker_localIso` and `lem:isIso_sheafification_whiskerRight_unit`).
