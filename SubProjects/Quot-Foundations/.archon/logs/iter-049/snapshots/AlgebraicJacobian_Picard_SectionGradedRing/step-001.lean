import Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal
import Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification
import Mathlib.AlgebraicGeometry.Modules.Sheaf

/-!
# Section graded ring infrastructure, Layer 1: tensor powers of a sheaf of modules

This file builds the Mathlib-absent infrastructure of
`blueprint/src/chapters/Picard_SectionGradedRing.tex`, Layer 1
(`sec:sgr_tensor_powers`): the tensor product, tensor powers, and twists of
sheaves of modules over a scheme `X`, together with the unitor and braiding
isomorphisms of the sheaf tensor product.

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
* `AlgebraicGeometry.Scheme.Modules.sheafificationCounitIso` — the reflective
  counit iso `(F.toPresheaf)^# ≅ F`.
* `AlgebraicGeometry.Scheme.Modules.tensorObjUnitIso`,
  `AlgebraicGeometry.Scheme.Modules.tensorObjRightUnitor`,
  `AlgebraicGeometry.Scheme.Modules.tensorBraiding` — the left/right unitor and
  braiding isomorphisms of the sheaf tensor product.

The comparison isomorphism `L^{⊗m} ⊗ L^{⊗m'} ≅ L^{⊗(m+m')}`
(`lem:sheafTensorPow_add`) is **deferred**: see the handoff note before the end
of the file for the single missing ingredient (strong-monoidality of the module
sheafification functor) and the launching pad assembled here.
-/

universe u

open CategoryTheory MonoidalCategory Limits

namespace AlgebraicGeometry.Scheme.Modules

variable {X : Scheme.{u}}

/-- The scheme-level sheafification functor, sending a presheaf of modules over a
scheme `X` to its associated sheaf of modules `X.Modules`.  It is the
`PresheafOfModules.sheafification` functor for the identity morphism of the
underlying presheaf of rings (which is locally bijective). -/
private noncomputable def sheafification : X.PresheafOfModules ⥤ X.Modules :=
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

/-! ### Unitor and braiding isomorphisms of the sheaf tensor product

These are the parts of the (would-be) symmetric monoidal structure on `X.Modules`
that descend through sheafification from `PresheafOfModules.monoidalCategory`
using only *functoriality* of `sheafification` (and, for the unitors, the
reflective counit iso) — no strong-monoidality of `sheafification` is needed, so
they are axiom-clean.  They are the launching pad for `tensorPowAdd`. -/

/-- The counit isomorphism of the module sheafification adjunction: sheafifying
the underlying presheaf of a sheaf of modules returns the sheaf itself.  This is
an isomorphism because the counit of `sheafification ⊣ toPresheafOfModules` is
invertible (the right adjoint `SheafOfModules.forget` is fully faithful).  It is
the launching pad for the left-unitor base case of `tensorPowAdd`. -/
noncomputable def sheafificationCounitIso (G : X.Modules) :
    sheafification.obj ((toPresheafOfModules X).obj G) ≅ G :=
  (asIso (PresheafOfModules.sheafificationAdjunction
    (𝟙 X.ringCatSheaf.obj)).counit).app G

/-- The left-unitor isomorphism `unitModule X ⊗ G ≅ G` of the sheaf tensor
product: the presheaf left unitor `λ_` descended through sheafification, composed
with the counit iso `sheafificationCounitIso`.  This is the base case (`m = 0`) of
`tensorPowAdd`.  Axiom-clean. -/
noncomputable def tensorObjUnitIso (G : X.Modules) :
    tensorObj (unitModule X) G ≅ G :=
  sheafification.mapIso
      (MonoidalCategory.leftUnitor (C := MonoidalPresheaf X)
        ((toPresheafOfModules X).obj G)) ≪≫
    sheafificationCounitIso G

/-- The right-unitor isomorphism `G ⊗ unitModule X ≅ G` of the sheaf tensor
product: the presheaf right unitor `ρ_` descended through sheafification, composed
with the counit iso `sheafificationCounitIso`.  Axiom-clean (no monoidal structure
on `X.Modules` is required). -/
noncomputable def tensorObjRightUnitor (G : X.Modules) :
    tensorObj G (unitModule X) ≅ G :=
  sheafification.mapIso
      (MonoidalCategory.rightUnitor (C := MonoidalPresheaf X)
        ((toPresheafOfModules X).obj G)) ≪≫
    sheafificationCounitIso G

/-- The braiding isomorphism `F ⊗ G ≅ G ⊗ F` of the sheaf tensor product,
descended through sheafification from the symmetric braiding on
`X.PresheafOfModules` (`PresheafOfModules.monoidalCategory`).  Axiom-clean: the
braiding is pure sheafification-functoriality of the presheaf-level braiding, so
no monoidal structure on `X.Modules` is required.  This is the symmetry used in
the inductive step of `tensorPowAdd`. -/
noncomputable def tensorBraiding (F G : X.Modules) :
    tensorObj F G ≅ tensorObj G F :=
  sheafification.mapIso
    (BraidedCategory.braiding (C := MonoidalPresheaf X)
      ((toPresheafOfModules X).obj F) ((toPresheafOfModules X).obj G))

/-
### The tensor-power comparison isomorphism `tensorPowAdd` — DEFERRED (handoff)

The canonical comparison isomorphism (`lem:sheafTensorPow_add`, [Stacks, Tag 01CU])

  `tensorPowAdd (L : X.Modules) (m m' : ℕ) :`
  `  tensorObj (tensorPow L m) (tensorPow L m') ≅ tensorPow L (m + m')`

is **not** provided in this iteration.  Per the `mathlib-build` discipline it is
left *absent* rather than backed by a `sorry`.  Its proof is by induction on `m`:

* **base case `m = 0`** — FULLY AVAILABLE, axiom-clean:
  `tensorObjUnitIso (tensorPow L m') ≪≫ eqToIso (by rw [Nat.zero_add])`
  (left unitor `unitModule X ⊗ L^{⊗m'} ≅ L^{⊗m'}`, transported along `0 + m' = m'`).

* **inductive step `m = k+1`** — needs the sheaf-level **associator**
  `tensorObj (tensorObj A B) C ≅ tensorObj A (tensorObj B C)`.  Concretely, with
  `A = L^{⊗k}`, `B = L^{⊗m'}`, one must produce
  `(A ⊗ L) ⊗ B ≅ (A ⊗ B) ⊗ L` (= associator, then `tensorBraiding`, then
  associator⁻¹), combine with the inductive hypothesis `L^{⊗(k+m')} ≅ A ⊗ B`
  and `Nat.succ_add`.  Everything here EXCEPT the associator is already built
  (`tensorBraiding`, `tensorPow_succ`).

THE SINGLE MISSING INGREDIENT is the associator, equivalently the
**strong-monoidality of the module sheafification functor**
`sheafification : X.PresheafOfModules ⥤ X.Modules`: the canonical maps
`sheafification.obj (P ⊗ Q) ⟶ sheafification.obj ((sheafification.obj P).val ⊗ Q)`
— obtained by applying `sheafification` to `η_P ⊗ 𝟙_Q`, where
`η = (PresheafOfModules.sheafificationAdjunction (𝟙 _)).unit` — are isomorphisms.
This holds because `η_P ⊗ 𝟙_Q` is inverted by sheafification: it is a stalkwise
isomorphism (tensor commutes with the filtered-colimit stalks and `η_P` is a
stalk iso), even though it need not be locally *injective* (tensoring is only
right exact).  Mathlib (pinned commit) supplies the abstract
`CategoryTheory.Localization.Monoidal` machinery but **not** its instantiation for
the presheaf-of-modules sheafification localizer, nor a stalkwise-iso criterion
for morphisms of sheaves of modules; building either is the next-iteration task.

LAUNCHING PAD (all axiom-clean, BUILT ABOVE): `sheafificationCounitIso`,
`tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`.
-/

end AlgebraicGeometry.Scheme.Modules
