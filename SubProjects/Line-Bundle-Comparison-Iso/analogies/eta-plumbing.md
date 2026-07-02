# η-collapse plumbing — verified idioms (iter-028 mathlib-analogist)

Closes the two micro-obstacles that stalled `pushforward_eta_appIso_collapse`
(the RingCat `map_one` non-firing + the `𝟙_ = unit` `OfNat` synthesis failure).
All three snippets were end-to-end verified in-LSP (no `sorry`).

## 1. LHS unit-preservation helper (state `1` via the COMPOSED functor object, not `𝟙_`)

The `OfNat` synthesis failure on `1 : (𝟙_ (PresheafOfModules _)).obj W` is dodged by
typing the unit through `(S ⋙ forget₂ CommRingCat RingCat).obj W` (a genuine ring),
then transporting along the `𝟙_ = unit` defeq. Verified named helper:

```lean
lemma restrictScalars_oplaxMonoidal_η_app_one
    (α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat)
    (hα : ∀ U, Function.Bijective (α.app U).hom) (W : Cᵒᵖ) :
    letI := restrictScalarsMonoidalOfBijective α hα
    ((Functor.OplaxMonoidal.η (PresheafOfModules.restrictScalars α)).app W).hom
        (1 : (S ⋙ forget₂ CommRingCat RingCat).obj W)
      = (1 : (R ⋙ forget₂ CommRingCat RingCat).obj W) := by
  letI := restrictScalarsMonoidalOfBijective α hα
  have hε : ((Functor.LaxMonoidal.ε (PresheafOfModules.restrictScalars α)).app W).hom
      (1 : (R ⋙ forget₂ CommRingCat RingCat).obj W)
      = (1 : (S ⋙ forget₂ CommRingCat RingCat).obj W) := by
    erw [ModuleCat.restrictScalars_η]; exact RingHom.map_one _
  rw [← hε, ← LinearMap.comp_apply, ← ModuleCat.hom_comp, ← PresheafOfModules.comp_app,
      show Functor.LaxMonoidal.ε (PresheafOfModules.restrictScalars α)
          ≫ Functor.OplaxMonoidal.η (PresheafOfModules.restrictScalars α) = 𝟙 _
        from Functor.Monoidal.ε_η _]
  rfl
```

Key moves: lax `ε` sends `1 ↦ 1` (`ModuleCat.restrictScalars_η` + `RingHom.map_one`);
`ε ≫ η = 𝟙` (`Functor.Monoidal.ε_η _`) collapses the rest. The `Functor.Monoidal.ε_η`
rewrite cannot match under `.app W` directly (instance-path mismatch) — feed it via
`show … = 𝟙 _ from Functor.Monoidal.ε_η _` and finish with `rfl`.

## 2. RHS `map_one` on a `ConcreteCategory.hom` of a `CommRing` presheaf map

`map_one` would not fire on `ConcreteCategory.hom (φ.app U) 1` while the `1` was typed
opaquely. Type the argument as `(F ⋙ forget₂ CommRingCat RingCat).obj U` and
`simp only [map_one]` fires:

```lean
example (φ : (F ⋙ forget₂ CommRingCat RingCat) ⟶ (G ⋙ forget₂ CommRingCat RingCat)) (U)
    (lhs) (h : lhs = 1) :
    lhs = (ConcreteCategory.hom (φ.app U)) (1 : (F ⋙ forget₂ CommRingCat RingCat).obj U) := by
  simp only [map_one]; exact h
```

## 3. ModuleCat composite-application collapse

```lean
-- g.hom (f.hom x) = (f ≫ g).hom x
rw [ModuleCat.hom_comp, LinearMap.comp_apply]
```
(`ModuleCat.hom_comp_apply` does NOT exist — use the two-step `hom_comp` + `comp_apply`.)
