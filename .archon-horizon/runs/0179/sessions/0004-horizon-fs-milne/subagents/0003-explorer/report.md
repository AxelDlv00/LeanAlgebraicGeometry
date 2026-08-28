Read-only exploration complete. The most directly useful API is:

```lean
import Mathlib.Topology.Sheaves.LocallySurjective
import Mathlib.CategoryTheory.ConcreteCategory.EpiMono
```

Exact declaration:

```lean
#check TopCat.Presheaf.locally_surjective_iff_surjective_on_stalks
```

It states:

```lean
TopCat.Presheaf.IsLocallySurjective T ↔
  ∀ x, Function.Surjective
    ((TopCat.Presheaf.stalkFunctor C x).map T)
```

For a scheme-module morphism `φ : M ⟶ N`, the following compiled in `/tmp/check.lean`:

```lean
example {X : Scheme} {M N : X.Modules} (φ : M ⟶ N)
    (h : ∀ x : X,
      Function.Surjective
        ((TopCat.Presheaf.stalkFunctor AddCommGrpCat x).map φ.mapPresheaf)) :
    Epi φ := by
  let F := SheafOfModules.toSheaf X.ringCatSheaf
  have hl : TopCat.Presheaf.IsLocallySurjective (F.map φ).hom :=
    (TopCat.Presheaf.locally_surjective_iff_surjective_on_stalks _).2 h
  have he : Epi (F.map φ) := by
    letI : CategoryTheory.Sheaf.IsLocallySurjective (F.map φ) := hl
    infer_instance
  exact F.epi_of_epi_map he
```

`F.epi_of_epi_map` works because `SheafOfModules.toSheaf` is faithful, and faithful functors reflect epimorphisms via `Functor.epi_of_epi_map`.

Avoid `TopCat.Sheaf.isLocallySurjective_iff_epi` here: its `Balanced (Sheaf ... AddCommGrpCat)` instance is not available. The forward implication through `letI : Sheaf.IsLocallySurjective ...` is sufficient.

For the residue-fibre-to-stalk step:

- `Mathlib.Algebra.Category.ModuleCat.Stalk` supplies the module structure
  ```lean
  PresheafOfModules.stalk
  ```
  over the local ring `R.stalk x`.
- `PresheafOfModules.germ_smul` (or `germ_ringCat_smul`) proves germs respect scalar multiplication, allowing the additive stalk map to be packaged as a `LinearMap`.
- Existing project theorem:
  ```lean
  MilneLib.LinearMap.surjective_of_surjective_residue
  ```
  lifts surjectivity of
  ```lean
  (((IsLocalRing.maximalIdeal R) • (⊤ : Submodule R N)).mkQ).comp f
  ```
  to surjectivity of `f`, assuming `Module.Finite R N`.

The remaining formalization gap is identifying the stated residue fibre (usually tensoring with the residue field) with the quotient by `maximalIdeal • ⊤`, and obtaining `Module.Finite` for a coherent target stalk. Mathlib has `SheafOfModules.IsFiniteType` and local generators, but no direct finite-stalk theorem was found.

Also relevant for fixed-ring module maps is `Mathlib.RingTheory.LocalProperties.Exactness`:

```lean
LinearMap.surjective_of_localized_maximal
LinearMap.exact_of_localized_maximal
```

The current untracked `MilneLib/LocalProperties.lean` wraps these as `MilneLib.LinearMap.surjective_of_localized_at_maximal` and `exact_of_localized_at_maximal`.
