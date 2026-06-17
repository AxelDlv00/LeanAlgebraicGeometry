import Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal
import Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification
import Mathlib.AlgebraicGeometry.Modules.Sheaf

/-!
# Section graded ring infrastructure, Layer 1: tensor powers of a sheaf of modules

This file builds the Mathlib-absent infrastructure of
`blueprint/src/chapters/Picard_SectionGradedRing.tex`, Layer 1
(`sec:sgr_tensor_powers`): the tensor product, tensor powers, and twists of
sheaves of modules over a scheme `X`, together with the canonical
tensor-power comparison isomorphism.

The category `X.Modules = SheafOfModules X.ringCatSheaf` of sheaves of modules
over a scheme carries **no** monoidal structure in Mathlib (the structure sheaf
varies the base ring over opens).  Mathlib *does* supply:

* the symmetric monoidal structure on the category of **presheaves** of modules
  `PresheafOfModules.monoidalCategory`
  (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal`), and
* the sheafification functor `PresheafOfModules.sheafification`
  (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification`).

We therefore build the tensor product of sheaves of modules as the sheafification
of the objectwise (presheaf) tensor product, following
[Stacks, Tag 01CA].

## Main definitions

* `AlgebraicGeometry.Scheme.Modules.sheafification` — the scheme-level
  sheafification functor `X.PresheafOfModules ⥤ X.Modules`.
* `AlgebraicGeometry.Scheme.Modules.tensorObj` (`def:sheafTensorObj`) —
  `F ⊗ G := (F.toPresheaf ⊗ G.toPresheaf)^#`.
* `AlgebraicGeometry.Scheme.Modules.tensorPow` (`def:sheafTensorPow`) —
  the `m`-th tensor power `L^{⊗m}` of a sheaf of modules.
* `AlgebraicGeometry.Scheme.Modules.moduleTensorPow` (`def:sheafModuleTwist`) —
  the `m`-twist `F(m) = F ⊗ L^{⊗m}`.
* `AlgebraicGeometry.Scheme.Modules.tensorPowAdd` (`lem:sheafTensorPow_add`) —
  the canonical comparison isomorphism `L^{⊗m} ⊗ L^{⊗m'} ≅ L^{⊗(m+m')}`.
-/

universe u

open CategoryTheory MonoidalCategory Limits

namespace AlgebraicGeometry.Scheme.Modules

variable {X : Scheme.{u}}

/-- The scheme-level sheafification functor, sending a presheaf of modules over a
scheme `X` to its associated sheaf of modules `X.Modules`.  It is the
`PresheafOfModules.sheafification` functor for the identity morphism of the
underlying presheaf of rings (which is locally bijective). -/
noncomputable def sheafification : X.PresheafOfModules ⥤ X.Modules :=
  PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)

/-- The category `X.PresheafOfModules` of presheaves of modules over a scheme,
presented in the exact form `PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat)`
for which Mathlib equips it with a symmetric monoidal structure.  This is
*definitionally* `X.PresheafOfModules` (since
`X.ringCatSheaf.obj = X.sheaf.obj ⋙ forget₂ CommRingCat RingCat`), so a term of
either type is accepted for the other. -/
abbrev MonoidalPresheaf (X : Scheme.{u}) : Type _ :=
  _root_.PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat RingCat)

/-- The tensor product of two sheaves of modules over a scheme, defined as the
sheafification of the objectwise tensor product presheaf
(Mathlib `PresheafOfModules.monoidalCategory`).  See [Stacks, Tag 01CA]
(`def:sheafTensorObj`). -/
noncomputable def tensorObj (F G : X.Modules) : X.Modules :=
  sheafification.obj
    (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
      ((toPresheafOfModules X).obj F) ((toPresheafOfModules X).obj G))

/-- The structure sheaf as a sheaf of modules over itself: the unit object of the
tensor product, i.e. the zeroth tensor power `L^{⊗0} = 𝒪_X`
(`lem:moduleUnit_mathlib`). -/
noncomputable abbrev unitModule (X : Scheme.{u}) : X.Modules :=
  SheafOfModules.unit X.ringCatSheaf

/-- The `m`-th tensor power `L^{⊗m}` of a sheaf of modules over a scheme, defined
by recursion: `L^{⊗0} = 𝒪_X` (the unit module) and
`L^{⊗(m+1)} = L^{⊗m} ⊗ L`.  See [Stacks, Tag 01CU] (`def:sheafTensorPow`). -/
noncomputable def tensorPow (L : X.Modules) : ℕ → X.Modules
  | 0 => unitModule X
  | (m + 1) => tensorObj (tensorPow L m) L

@[simp] lemma tensorPow_zero (L : X.Modules) : tensorPow L 0 = unitModule X := rfl

@[simp] lemma tensorPow_succ (L : X.Modules) (m : ℕ) :
    tensorPow L (m + 1) = tensorObj (tensorPow L m) L := rfl

/-- The `m`-twist `F(m) = F ⊗ L^{⊗m}` of a sheaf of modules `F` by the `m`-th
tensor power of a line bundle `L` (`def:sheafModuleTwist`).  This is the
degree-`m` carrier of the section graded module. -/
noncomputable def moduleTensorPow (F L : X.Modules) (m : ℕ) : X.Modules :=
  tensorObj F (tensorPow L m)

@[simp] lemma moduleTensorPow_zero (F L : X.Modules) :
    moduleTensorPow F L 0 = tensorObj F (unitModule X) := rfl

/-!
### The tensor-power comparison isomorphism

`tensorPowAdd` is the canonical isomorphism
`L^{⊗m} ⊗ L^{⊗m'} ≅ L^{⊗(m+m')}` of [Stacks, Tag 01CU] (`lem:sheafTensorPow_add`).

**Status (iter-047): documented typed `sorry`.** Proving it requires the
*monoidal* (associator + unitor) structure on the category `X.Modules` of
sheaves of modules — concretely the natural isomorphisms

* `tensorObj (unitModule X) G ≅ G`  (left unitor), and
* `tensorObj (tensorObj A B) C ≅ tensorObj A (tensorObj B C)`  (associator),

descended through sheafification from the symmetric monoidal structure on
`X.PresheafOfModules` (`PresheafOfModules.monoidalCategory`).  Mathlib supplies
the monoidal structure only on **presheaves** of modules and, separately, on
`Sheaf J A` for a *fixed* monoidal `A` (`CategoryTheory.Sites.Monoidal`); it has
**no** monoidal structure on `SheafOfModules R` over a sheaf of rings `R`.
Building it amounts to showing the module sheafification functor
`sheafification : X.PresheafOfModules ⥤ X.Modules` is (strong/lax) monoidal,
i.e. the comparison map `sheafification.obj (P ⊗ Q) ⟶ ...` assembling
`sheafification.obj P ⊗_sh sheafification.obj Q` is an isomorphism, which in turn
uses that the sheafification unit `η` is a "local isomorphism" stable under
tensoring (Day-convolution / reflective-monoidal-localization machinery,
`CategoryTheory.Localization.Monoidal`).

**Decomposition for the next iteration (handoff):**
1. `sheafificationCounitIso (G : X.Modules) :`
   `  sheafification.obj ((toPresheafOfModules X).obj G) ≅ G`
   — the counit of `sheafification ⊣ toPresheafOfModules`, an iso because the
   right adjoint (`SheafOfModules.forget`) is fully faithful.  BUILT BELOW
   (axiom-clean, no missing infra).
2. `tensorObjUnitIso (G : X.Modules) : tensorObj (unitModule X) G ≅ G`
   — presheaf left unitor `λ_` followed by (1).  Available once the identification
   `(toPresheafOfModules X).obj (unitModule X) = 𝟙_ (MonoidalPresheaf X)` is set up.
3. `sheafificationMonoidalComparison` — strong-monoidality of `sheafification`
   (`sheafification.obj P ⊗_sh sheafification.obj Q ≅ sheafification.obj (P ⊗ Q)`).
   THE MISSING INGREDIENT.  Route: instantiate
   `CategoryTheory.Localization.Monoidal` for the reflective localization
   `sheafification ⊣ forget`, checking the localizer (local isomorphisms) is
   stable under `⊗` for presheaves of modules.
4. `tensorPowAdd` then follows by induction on `m` (base case = (2), step =
   associator from (3) + the recursive definition of `tensorPow`).
-/

/-- The counit isomorphism of the module sheafification adjunction: sheafifying
the underlying presheaf of a sheaf of modules returns the sheaf itself.  This is
an isomorphism because the forgetful functor `toPresheafOfModules X` is fully
faithful (so the counit of `sheafification ⊣ toPresheafOfModules` is invertible).
It is the launching pad for the left-unitor base case of `tensorPowAdd`. -/
noncomputable def sheafificationCounitIso (G : X.Modules) :
    sheafification.obj ((toPresheafOfModules X).obj G) ≅ G :=
  (asIso (PresheafOfModules.sheafificationAdjunction
    (𝟙 X.ringCatSheaf.obj)).counit).app G

/-- The left-unitor isomorphism `unitModule X ⊗ G ≅ G` of the sheaf tensor
product: the presheaf left unitor `λ_` descended through sheafification, composed
with the counit iso `sheafificationCounitIso`.  This is the base case (`m = 0`) of
`tensorPowAdd`. -/
noncomputable def tensorObjUnitIso (G : X.Modules) :
    tensorObj (unitModule X) G ≅ G :=
  sheafification.mapIso
      (MonoidalCategory.leftUnitor (C := MonoidalPresheaf X)
        ((toPresheafOfModules X).obj G)) ≪≫
    sheafificationCounitIso G

/-- The canonical comparison isomorphism `L^{⊗m} ⊗ L^{⊗m'} ≅ L^{⊗(m+m')}`
([Stacks, Tag 01CU], `lem:sheafTensorPow_add`).

The intended construction is by induction on `m`: the base case `m = 0` is the
left unitor `tensorObj (unitModule X) (tensorPow L m') ≅ tensorPow L m'`, and the
inductive step uses the associator of the sheaf tensor product together with the
recursive definition `tensorPow L (m+1) = tensorObj (tensorPow L m) L`.  Both the
unitor and the associator descend through sheafification from
`PresheafOfModules.monoidalCategory`; the latter requires the
strong-monoidality of the module sheafification functor, which is not yet in
Mathlib.  See the decomposition above. -/
noncomputable def tensorPowAdd (L : X.Modules) (m m' : ℕ) :
    tensorObj (tensorPow L m) (tensorPow L m') ≅ tensorPow L (m + m') :=
  sorry

end AlgebraicGeometry.Scheme.Modules
