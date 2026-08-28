Audit complete.

- `MilneLib.GroupVariety.pointTranslationIso_hom_apply` is compiled in `MilneLib/GroupScheme.lean` with only `import Mathlib.AlgebraicGeometry.Group.Abelian`:

```lean
@[simp]
theorem pointTranslationIso_hom_apply (x y : 𝟙_ (Over S) ⟶ G) (s : S) :
    (pointTranslationIso G x y).hom (x.left s) = y.left s := by
  rw [pointTranslationIso_hom, ← Scheme.Hom.comp_apply, ← Over.comp_left,
    comp_pointTranslation_hom]
```

Context: `namespace MilneLib.GroupVariety`, `open AlgebraicGeometry`, `{S : Scheme} (G : Over S) [GrpObj G]`.

- The identity result is named `MilneLib.Isogeny.id`, not `isogeny_id`, and is also compiled from the same sole import:

```lean
@[simp]
theorem Isogeny.id (A : Over (Spec (.of K))) [GrpObj A] :
    Isogeny (𝟙 A) := by
  constructor
  · infer_instance
  · dsimp [isogenyKernelToBase, isogenyKernel]
    infer_instance
```

The second `infer_instance` uses `IsClosedImmersion (η[A]).left`, hence `IsFinite`, then finite stability under pullback. The generated `.ilean` files confirm both declarations and no hidden axioms/sorries.

Workspace-wide search found sibling `pointTranslationIso_hom_apply` declarations in Mumford/AJC namespaces, but no collision with `MilneLib.GroupVariety`; no `isogeny_id` or other `MilneLib.Isogeny.id` exists. The current source already contains `MilneLib.Isogeny.id`, so adding a duplicate is unsafe.

For composition, surjectivity is immediate after `rw [Over.comp_left]; infer_instance`, but finite-kernel composition is not derivable from the current `Isogeny` predicate alone. A checked conditional route works when `[IsFinite f.left] [IsFinite g.left]` are supplied: install `letI : Surjective f.left := hf.1` and similarly for `g`, unfold the pullback kernel, then `infer_instance`. Full geometric rigidity remains substantially larger; the sibling categorical `rigidity_snd_lift` is only the one-line `ext1 <;> simp` skeleton.
