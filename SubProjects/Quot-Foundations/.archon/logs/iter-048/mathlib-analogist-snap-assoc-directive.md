# Mathlib-analogist directive — snap-assoc

## Mode: cross-domain-inspiration

## Structural problem
We need a **monoidal structure (specifically the associator) on `SheafOfModules R`** over a sheaf of rings `R` on a site/space, obtained by sheafifying the monoidal structure on `PresheafOfModules R`. Concretely: the tensor product on sheaves of modules is `tensorObj F G := sheafification(F_presheaf ⊗ G_presheaf)`, and we need the associator `(F⊗G)⊗H ≅ F⊗(G⊗H)`. This reduces to **strong-monoidality of the reflective localization functor** `L = PresheafOfModules.sheafification : PresheafOfModules R ⥤ SheafOfModules R`, i.e. the comparison `L(P) ⊗ L(Q) ≅ L(P ⊗ Q)` is iso, equivalently `L.map (η_P ⊗ 𝟙_Q)` is iso where `η` is the sheafification unit.

The presheaf side IS monoidal in Mathlib (`PresheafOfModules.monoidalCategory`). The unitors and braiding already descend trivially (pure functoriality of `L.mapIso`). Only the **associator** needs the strong-monoidal comparison.

## Failed approaches
- Stalkwise-iso ⟹ IsIso for `SheafOfModules` morphisms: `η_P ⊗ 𝟙_Q` is NOT locally injective (tensor is only right-exact), so the abelian-sheaf "local iso = locally inj+surj" criterion does not apply directly.
- Direct `MonoidalCategory (SheafOfModules R)` instance: ABSENT in pinned Mathlib (`CategoryTheory/Sites/Monoidal.lean` only handles `Sheaf J A` for a FIXED monoidal target `A`, not sheaves of modules over a sheaf of rings).
- `CategoryTheory/Localization/Monoidal` exists but is NOT instantiated for the module-sheafification localizer.

## Search radius: wide

## What I need back
Ranked structural analogues from ANY Mathlib domain where a monoidal structure is transported across a reflective localization / sheafification (or where strong-monoidality of a localization functor is established), with the technique each used and a concrete porting suggestion. In particular:
- Is `CategoryTheory.Localization.Monoidal` (the `LocalizerMorphism`/`MonoidalCategory.transport`-style machinery) genuinely instantiable here? What is the exact "localizer stable under ⊗" obligation it would impose, and is that obligation discharged by tensor commuting with sheafification stalks?
- Does Mathlib establish monoidality of `Sheaf` sheafification anywhere (even for `Sheaf J A`) by a route we can mimic?
- Is there a cheaper path: define `L^{⊗m}` and its `add`-comparison WITHOUT a full `MonoidalCategory (SheafOfModules R)` instance (e.g. by a bespoke stalkwise / objectwise comparison just for line bundles `L`)?
