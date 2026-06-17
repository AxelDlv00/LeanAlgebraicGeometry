import Mathlib.Algebra.Category.Grp.Basic
import Mathlib.LinearAlgebra.TensorProduct.Map
import Mathlib.LinearAlgebra.TensorProduct.Associator
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal
import Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification
import Mathlib.Algebra.Category.ModuleCat.Sheaf.Localization
import Mathlib.CategoryTheory.Sites.Monoidal
import Mathlib.CategoryTheory.Sites.PreservesSheafification
import Mathlib.CategoryTheory.Sites.Adjunction
import Mathlib.Algebra.Category.ModuleCat.Monoidal.Closed
import Mathlib.Algebra.Category.ModuleCat.Monoidal.Symmetric
import Mathlib.Algebra.Category.ModuleCat.ChangeOfRings
import Mathlib.Algebra.Category.Grp.ZModuleEquivalence
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
underlying presheaf of rings (which is locally bijective).  Non-private because it
appears in the statement of `isIso_sheafification_whiskerRight_unit`. -/
noncomputable def sheafification : X.PresheafOfModules ⥤ X.Modules :=
  PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)

/-- The category `X.PresheafOfModules` of presheaves of modules over a scheme,
presented in the exact form `PresheafOfModules (R ⋙ forget₂ CommRingCat RingCat)`
for which Mathlib equips it with a symmetric monoidal structure.  This is
*definitionally* `X.PresheafOfModules` (since
`X.ringCatSheaf.obj = X.sheaf.obj ⋙ forget₂ CommRingCat RingCat`), so a term of
either type is accepted for the other. -/
private abbrev MonoidalPresheaf (X : Scheme.{u}) : Type _ :=
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
private noncomputable abbrev unitModule (X : Scheme.{u}) : X.Modules :=
  SheafOfModules.unit X.ringCatSheaf

/-- The `m`-th tensor power `L^{⊗m}` of a sheaf of modules over a scheme, defined
by recursion: `L^{⊗0} = 𝒪_X` (the unit module) and
`L^{⊗(m+1)} = L^{⊗m} ⊗ L`.  See [Stacks, Tag 01CU] (`def:sheafTensorPow`). -/
noncomputable def tensorPow (L : X.Modules) : ℕ → X.Modules
  | 0 => unitModule X
  | (m + 1) => tensorObj (tensorPow L m) L

@[simp] private lemma tensorPow_zero (L : X.Modules) : tensorPow L 0 = unitModule X := rfl

@[simp] private lemma tensorPow_succ (L : X.Modules) (m : ℕ) :
    tensorPow L (m + 1) = tensorObj (tensorPow L m) L := rfl

/-- The `m`-twist `F(m) = F ⊗ L^{⊗m}` of a sheaf of modules `F` by the `m`-th
tensor power of a line bundle `L` (`def:sheafModuleTwist`).  This is the
degree-`m` carrier of the section graded module. -/
noncomputable def moduleTensorPow (F L : X.Modules) (m : ℕ) : X.Modules :=
  tensorObj F (tensorPow L m)

@[simp] private lemma moduleTensorPow_zero (F L : X.Modules) :
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
private noncomputable def sheafificationCounitIso (G : X.Modules) :
    sheafification.obj ((toPresheafOfModules X).obj G) ≅ G :=
  (asIso (PresheafOfModules.sheafificationAdjunction
    (𝟙 X.ringCatSheaf.obj)).counit).app G

/-- The left-unitor isomorphism `unitModule X ⊗ G ≅ G` of the sheaf tensor
product: the presheaf left unitor `λ_` descended through sheafification, composed
with the counit iso `sheafificationCounitIso`.  This is the base case (`m = 0`) of
`tensorPowAdd`.  Axiom-clean. -/
private noncomputable def tensorObjUnitIso (G : X.Modules) :
    tensorObj (unitModule X) G ≅ G :=
  sheafification.mapIso
      (MonoidalCategory.leftUnitor (C := MonoidalPresheaf X)
        ((toPresheafOfModules X).obj G)) ≪≫
    sheafificationCounitIso G

/-- The right-unitor isomorphism `G ⊗ unitModule X ≅ G` of the sheaf tensor
product: the presheaf right unitor `ρ_` descended through sheafification, composed
with the counit iso `sheafificationCounitIso`.  Axiom-clean (no monoidal structure
on `X.Modules` is required). -/
private noncomputable def tensorObjRightUnitor (G : X.Modules) :
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
private noncomputable def tensorBraiding (F G : X.Modules) :
    tensorObj F G ≅ tensorObj G F :=
  sheafification.mapIso
    (BraidedCategory.braiding (C := MonoidalPresheaf X)
      ((toPresheafOfModules X).obj F) ((toPresheafOfModules X).obj G))

/-! ### Lax-monoidal global sections: the section multiplication

The global-sections functor `Γ(X, -)` is only *lax* monoidal: a pair of global
sections does not commute with sheafification, so the multiplication is a map,
not an isomorphism.  It is nonetheless `Γ(X, 𝒪_X)`-linear and is the data the
section graded ring is built from. -/

/-- The **section multiplication** (`def:sectionMul`), the `Γ(X,𝒪_X)`-bilinear map
`Γ(X,F) ⊗_{Γ(X,𝒪_X)} Γ(X,G) → Γ(X, F ⊗ G)`.

Its domain `(F.toPresheaf ⊗ G.toPresheaf)(X)` is, by the objectwise formula of
`PresheafOfModules.monoidalCategory`, the `Γ(X,𝒪_X)`-module
`Γ(X,F) ⊗_{Γ(X,𝒪_X)} Γ(X,G)` of elementary tensors of global sections; a pair
`(σ, τ)` is sent to `σ ⊗ τ`.  Postcomposing with the global-sections component of
the sheafification unit `η : P → P^#` (`def:sheafTensorObj`) lands in
`Γ(X, F ⊗ G)`.  As a morphism in `ModuleCat (Γ(X,𝒪_X))` it is automatically
`Γ(X,𝒪_X)`-bilinear; this records that linearity.  Axiom-clean: it is pure
sheafification-unit naturality, requiring no monoidal structure on `X.Modules`. -/
noncomputable def sectionsMul (F G : X.Modules) :
    (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
        ((toPresheafOfModules X).obj F) ((toPresheafOfModules X).obj G)).obj (Opposite.op ⊤) ⟶
      (tensorObj F G).val.obj (Opposite.op ⊤) :=
  ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
      (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
        ((toPresheafOfModules X).obj F) ((toPresheafOfModules X).obj G))).app (Opposite.op ⊤)

/-! ### The strong-monoidality comparison `isIso_sheafification_whiskerRight_unit`

Following `analogies/snap-route.md` (Analogue 1) and the blueprint proof of
`lem:isIso_sheafification_whiskerRight_unit`: module sheafification is the
localization functor at the class `W := J.W.inverseImage (toPresheaf R₀)` of
morphisms of presheaves of modules whose underlying abelian-presheaf morphism is a
local isomorphism (a `J.W` for the opens topology `J` on `X`). -/

/-- The Grothendieck topology on the opens of the scheme `X`. -/
private abbrev opensTopology (X : Scheme.{u}) : GrothendieckTopology (TopologicalSpace.Opens X) :=
  Opens.grothendieckTopology (X : TopCat)

open MorphismProperty in
/-- **Localization criterion for module sheafification.**  The scheme-level module
sheafification `sheafification.map f` is an isomorphism of sheaves of modules iff the
underlying abelian-presheaf morphism `(PresheafOfModules.toPresheaf _).map f` lies in
the weak-equivalence class `J.W` of the opens topology (i.e. is a local isomorphism of
abelian-group presheaves).  This is the reduction step of
`isIso_sheafification_whiskerRight_unit`: it turns the strong-monoidality comparison
into a purely abelian local-isomorphism statement.  Project-local: it specialises
`_root_.PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` to the
identity morphism of `X.ringCatSheaf.obj`. -/
lemma isIso_sheafification_map_iff {P Q : X.PresheafOfModules} (f : P ⟶ Q) :
    IsIso (sheafification.map f) ↔
      (opensTopology X).W ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map f) := by
  have e := _root_.PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms
      (J := opensTopology X) (𝟙 X.ringCatSheaf.obj)
  constructor
  · intro h
    have h' : ((MorphismProperty.isomorphisms (SheafOfModules X.ringCatSheaf)).inverseImage
        (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj))) f := h
    rw [← e] at h'
    exact h'
  · intro h
    have h' : (((opensTopology X).W).inverseImage
        (PresheafOfModules.toPresheaf X.ringCatSheaf.obj)) f := h
    rw [e] at h'
    exact h'

/-- **The sheafification unit is an abelian local isomorphism.**  The underlying
abelian-presheaf morphism of the module sheafification unit `η_P : P ⟶ P^#` is
*definitionally* the abelian sheafification unit `toSheafify J P.presheaf`
(`PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app`), which lies
in the weak-equivalence class `J.W` of the opens topology by
`GrothendieckTopology.W_toSheafify`.  Project-local: this is the `η_P ∈ J.W`
ingredient of the abelian-`J.W`-monoidality transfer underlying
`isIso_sheafification_whiskerRight_unit`. -/
lemma localIso_toPresheaf_map_unit (P : X.PresheafOfModules) :
    (opensTopology X).W ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map
      ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app P)) := by
  rw [PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app]
  exact (opensTopology X).W_toSheafify _

/-- **Sheafification inverts the localization unit.**  `sheafification.map η_P` is an
isomorphism of sheaves of modules (the reflective-localization unit becomes invertible
after sheafifying).  Obtained by feeding `localIso_toPresheaf_map_unit` through the
localization criterion `isIso_sheafification_map_iff`.  Project-local: the `m = 0`
launching pad and the un-whiskered special case of
`isIso_sheafification_whiskerRight_unit`. -/
lemma isIso_sheafification_map_unit (P : X.PresheafOfModules) :
    IsIso (sheafification.map
      ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app P)) :=
  (isIso_sheafification_map_iff _).mpr (localIso_toPresheaf_map_unit P)

/-! ## Project-local Mathlib supplement — relative tensor product as a coequalizer

This section builds the **objectwise** content of `lem:relativeTensor_as_coequalizer`
(`relativeTensorCoequalizerIso`): over a commutative ring `S` and `S`-modules `M, N`,
the relative tensor product `M ⊗[S] N` is the coequalizer, *in the category of abelian
groups*, of the two `S`-action maps

  `M ⊗[ℤ] S ⊗[ℤ] N  ⇉  M ⊗[ℤ] N`,    `m ⊗ s ⊗ n ↦ (s • m) ⊗ n`  /  `m ⊗ (s • n)`.

This is the Mathlib-absent brick on which the strong-monoidality comparison
`isIso_sheafification_whiskerRight_unit` rests: the underlying abelian presheaf of the
presheaf-level relative tensor `P ⊗_p Q` is, objectwise, exactly this coequalizer.  The
universal property is the abelian-group universal property of the relative tensor product,
packaged by `TensorProduct.liftAddHom`.  Everything here is axiom-clean.

The promotion of this objectwise colimit to the presheaf category `Cᵒᵖ ⥤ AddCommGrp`
(where colimits are computed objectwise) and the identification of the whiskered unit
`η_P ▷ Q` with the induced map of coequalizers are the next steps; see the handoff note. -/

namespace RelativeTensorCoequalizer

open TensorProduct

variable (S : Type u) [CommRing S] (M N : Type u)
  [AddCommGroup M] [Module S M] [AddCommGroup N] [Module S N]

/-- The `S`-action map `S ⊗[ℤ] N → N`, `s ⊗ n ↦ s • n`, as a `ℤ`-linear map. -/
noncomputable def actN : (S ⊗[ℤ] N) →ₗ[ℤ] N :=
  TensorProduct.lift (LinearMap.mk₂ ℤ (fun s n => s • n)
    (fun s1 s2 n => add_smul s1 s2 n) (fun c s n => smul_assoc c s n)
    (fun s n1 n2 => smul_add s n1 n2) (fun c s n => smul_comm s c n))

/-- The `S`-action map `M ⊗[ℤ] S → M`, `m ⊗ s ↦ s • m`, as a `ℤ`-linear map. -/
noncomputable def actM : (M ⊗[ℤ] S) →ₗ[ℤ] M :=
  TensorProduct.lift (LinearMap.mk₂ ℤ (fun m s => s • m)
    (fun m1 m2 s => smul_add s m1 m2) (fun c m s => smul_comm s c m)
    (fun m s1 s2 => add_smul s1 s2 m) (fun c m s => smul_assoc c s m))

/-- Right action map `M ⊗[ℤ] (S ⊗[ℤ] N) → M ⊗[ℤ] N`, `m ⊗ (s ⊗ n) ↦ m ⊗ (s • n)`. -/
noncomputable def actRmap : (M ⊗[ℤ] (S ⊗[ℤ] N)) →ₗ[ℤ] (M ⊗[ℤ] N) :=
  TensorProduct.map LinearMap.id (actN S N)

/-- Left action map `M ⊗[ℤ] (S ⊗[ℤ] N) → M ⊗[ℤ] N`, `m ⊗ (s ⊗ n) ↦ (s • m) ⊗ n`. -/
noncomputable def actLmap : (M ⊗[ℤ] (S ⊗[ℤ] N)) →ₗ[ℤ] (M ⊗[ℤ] N) :=
  (TensorProduct.map (actM S M) LinearMap.id).comp
    (TensorProduct.assoc ℤ M S N).symm.toLinearMap

omit [Module S M] in
@[simp] lemma actRmap_tmul (m : M) (s : S) (n : N) :
    actRmap S M N (m ⊗ₜ (s ⊗ₜ n)) = m ⊗ₜ (s • n) := rfl

omit [Module S N] in
@[simp] lemma actLmap_tmul (m : M) (s : S) (n : N) :
    actLmap S M N (m ⊗ₜ (s ⊗ₜ n)) = (s • m) ⊗ₜ n := rfl

/-- The canonical projection `M ⊗[ℤ] N → M ⊗[S] N`, `m ⊗ n ↦ m ⊗ n`, as a `ℤ`-linear
map.  It is the cofork map exhibiting `M ⊗[S] N` as the coequalizer. -/
noncomputable def projL : (M ⊗[ℤ] N) →ₗ[ℤ] (M ⊗[S] N) :=
  (TensorProduct.liftAddHom
    { toFun := fun m =>
        (LinearMap.toAddMonoidHom (((TensorProduct.mk S M N) m).restrictScalars ℤ))
      map_zero' := by ext n; simp
      map_add' := fun m1 m2 => by ext n; simp }
    (fun r m n => by simp)).toIntLinearMap

@[simp] lemma projL_tmul (m : M) (n : N) : projL S M N (m ⊗ₜ n) = m ⊗ₜ[S] n := rfl

/-- The projection `M ⊗[ℤ] N → M ⊗[S] N` is surjective (it is the canonical
quotient map onto the relative tensor). -/
lemma projL_surjective : Function.Surjective (projL S M N) := by
  intro y
  induction y using TensorProduct.induction_on with
  | zero => exact ⟨0, map_zero _⟩
  | tmul m n => exact ⟨m ⊗ₜ[ℤ] n, projL_tmul S M N m n⟩
  | add a b ha hb =>
    obtain ⟨pa, rfl⟩ := ha; obtain ⟨pb, rfl⟩ := hb; exact ⟨pa + pb, map_add _ _ _⟩

/-- The two action maps become equal after the projection: this is the cofork
coequalizing condition, established at the level of `ℤ`-linear maps. -/
lemma projL_comp_act :
    (projL S M N).comp (actLmap S M N) = (projL S M N).comp (actRmap S M N) := by
  apply TensorProduct.ext'; intro m x
  induction x with
  | zero => rw [tmul_zero, map_zero, map_zero]
  | tmul s n =>
    change projL S M N (actLmap S M N (m ⊗ₜ (s ⊗ₜ n)))
      = projL S M N (actRmap S M N (m ⊗ₜ (s ⊗ₜ n)))
    rw [actLmap_tmul, actRmap_tmul, projL_tmul, projL_tmul, ← TensorProduct.smul_tmul',
      TensorProduct.tmul_smul]
  | add a b ha hb => rw [tmul_add, map_add, map_add, ha, hb]

/-- Left action map as a morphism of abelian groups. -/
noncomputable def aL :
    AddCommGrpCat.of (M ⊗[ℤ] (S ⊗[ℤ] N)) ⟶ AddCommGrpCat.of (M ⊗[ℤ] N) :=
  AddCommGrpCat.ofHom (actLmap S M N).toAddMonoidHom
/-- Right action map as a morphism of abelian groups. -/
noncomputable def aR :
    AddCommGrpCat.of (M ⊗[ℤ] (S ⊗[ℤ] N)) ⟶ AddCommGrpCat.of (M ⊗[ℤ] N) :=
  AddCommGrpCat.ofHom (actRmap S M N).toAddMonoidHom
/-- The projection as a morphism of abelian groups. -/
noncomputable def piMor :
    AddCommGrpCat.of (M ⊗[ℤ] N) ⟶ AddCommGrpCat.of (M ⊗[S] N) :=
  AddCommGrpCat.ofHom (projL S M N).toAddMonoidHom

@[simp] lemma piMor_apply (x) : (ConcreteCategory.hom (piMor S M N)) x = projL S M N x := rfl

instance piMor_epi : Epi (piMor S M N) :=
  ConcreteCategory.epi_of_surjective (piMor S M N) (projL_surjective S M N)

/-- The projection coequalizes the two action maps (as morphisms of abelian groups). -/
lemma coeq_condition : aL S M N ≫ piMor S M N = aR S M N ≫ piMor S M N := by
  ext x; exact LinearMap.congr_fun (projL_comp_act S M N) x

/-- The cofork `M ⊗[ℤ] (S ⊗[ℤ] N) ⇉ M ⊗[ℤ] N → M ⊗[S] N` of abelian groups. -/
noncomputable def cofork : Limits.Cofork (aL S M N) (aR S M N) :=
  Limits.Cofork.ofπ (piMor S M N) (coeq_condition S M N)

/-- The descent map out of `M ⊗[S] N` induced by a cofork `s`: a pair of global
sections balanced under the `S`-action factors through the relative tensor.  This
is the universal property packaged by `TensorProduct.liftAddHom`. -/
noncomputable def descHom (s : Limits.Cofork (aL S M N) (aR S M N)) :
    (M ⊗[S] N) →+ s.pt :=
  TensorProduct.liftAddHom
    { toFun := fun m =>
        { toFun := fun n => (ConcreteCategory.hom s.π) (m ⊗ₜ[ℤ] n)
          map_zero' := by rw [tmul_zero, map_zero]
          map_add' := fun n1 n2 => by rw [tmul_add, map_add] }
      map_zero' := by ext n; simp [zero_tmul]
      map_add' := fun m1 m2 => by ext n; simp [add_tmul] }
    (fun a m n => by
      simp only [AddMonoidHom.coe_mk, ZeroHom.coe_mk]
      have key :=
        congrArg (fun φ => (ConcreteCategory.hom φ) (m ⊗ₜ[ℤ] (a ⊗ₜ[ℤ] n))) s.condition
      simpa using key)

@[simp] lemma descHom_tmul (s : Limits.Cofork (aL S M N) (aR S M N)) (m : M) (n : N) :
    descHom S M N s (m ⊗ₜ[S] n) = (ConcreteCategory.hom s.π) (m ⊗ₜ[ℤ] n) := rfl

/-- The descent map as a morphism of abelian groups out of the cofork apex. -/
noncomputable def descMor (s : Limits.Cofork (aL S M N) (aR S M N)) :
    (cofork S M N).pt ⟶ s.pt :=
  AddCommGrpCat.ofHom (descHom S M N s)

/-- The descent map factors the cofork's projection: `π ≫ descMor s = s.π`. -/
lemma descFac (s : Limits.Cofork (aL S M N) (aR S M N)) :
    (cofork S M N).π ≫ descMor S M N s = s.π := by
  ext x
  induction x using TensorProduct.induction_on with
  | zero => simp
  | tmul m n =>
    change descHom S M N s (projL S M N (m ⊗ₜ[ℤ] n)) = (ConcreteCategory.hom s.π) (m ⊗ₜ[ℤ] n)
    rw [projL_tmul, descHom_tmul]
  | add a b ha hb => simp only [map_add, ha, hb]

/-- **`M ⊗[S] N` is the coequalizer**, in the category of abelian groups, of the two
`S`-action maps `M ⊗[ℤ] (S ⊗[ℤ] N) ⇉ M ⊗[ℤ] N`.  This is the objectwise content of
`lem:relativeTensor_as_coequalizer`; uniqueness uses that the projection `piMor` is an
epimorphism.  Axiom-clean. -/
noncomputable def isColimitCofork : Limits.IsColimit (cofork S M N) :=
  Limits.Cofork.IsColimit.mk _ (descMor S M N) (descFac S M N)
    (fun s _ hf => (cancel_epi (piMor S M N)).mp (hf.trans (descFac S M N s).symm))

end RelativeTensorCoequalizer

/-! ## Project-local Mathlib supplement — presheaf promotion of the coequalizer (Step 1)

The objectwise coequalizer `RelativeTensorCoequalizer.isColimitCofork` exhibits, for a fixed
open `U`, the relative tensor `Γ(U,P) ⊗_{R(U)} Γ(U,Q)` as a coequalizer of the two
`R(U)`-action maps on `Γ(U,P) ⊗_ℤ R(U) ⊗_ℤ Γ(U,Q) ⇉ Γ(U,P) ⊗_ℤ Γ(U,Q)`.  To promote this
to the functor category `(Opens X)ᵒᵖ ⥤ Ab` (where colimits are computed objectwise, via
`CategoryTheory.Limits.evaluationJointlyReflectsColimits`) one first needs the two **domain
presheaves of the cofork as honest functors**, whose restriction maps are the `ℤ`-tensors of
the underlying restriction maps.  This section builds the first of those two functors
(`relTensorDomainPresheaf`, the `Γ(-,P) ⊗_ℤ Γ(-,Q)` presheaf); it is the concrete Step-1 brick
of `lem:relativeTensor_as_coequalizer` (`relativeTensorCoequalizerIso`).

See the handoff note at the end of the file for the verified recipe for the remaining pieces
(triple-tensor presheaf, the natural action/projection transformations, the colimit lift, and
the apex identification) and the heartbeat/coercion friction points that must be budgeted. -/

open scoped TensorProduct

/-- Restriction map for a presheaf of modules with syntactic `↥(P.obj U)` carriers.
The underlying function is `(P.presheaf.map f).hom`; the type annotation forces the
domain/codomain to print as `↥(P.obj U)` / `↥(P.obj V)` (not `↥((P.presheaf).obj U)`,
which are rfl-defeq but syntactically distinct).  The syntactic agreement is the
load-bearing ingredient for `TensorProduct.map_tmul` unification in
`relTensorActL.naturality` / `relTensorActR.naturality`. -/
private noncomputable def objRestrict (P : X.PresheafOfModules)
    {U V : (TopologicalSpace.Opens X)ᵒᵖ} (f : U ⟶ V) :
    ↥(P.obj U) →ₗ[ℤ] ↥(P.obj V) :=
  (show ↥(P.obj U) →+ ↥(P.obj V) from
    { toFun := (P.presheaf.map f).hom
      map_zero' := map_zero (P.presheaf.map f).hom
      map_add' := map_add (P.presheaf.map f).hom }).toIntLinearMap

@[simp] private lemma objRestrict_apply (P : X.PresheafOfModules)
    {U V : (TopologicalSpace.Opens X)ᵒᵖ} (f : U ⟶ V) (x : ↥(P.obj U)) :
    objRestrict P f x = (P.presheaf.map f).hom x := rfl

/-- Identity law for the syntactic-carrier restriction: `objRestrict P (𝟙 U) = id`. -/
private lemma objRestrict_id (P : X.PresheafOfModules) (U : (TopologicalSpace.Opens X)ᵒᵖ) :
    objRestrict P (𝟙 U) = LinearMap.id := by
  ext x
  simp only [objRestrict_apply, CategoryTheory.Functor.map_id, AddCommGrpCat.hom_id,
    AddMonoidHom.id_apply, LinearMap.id_coe, id_eq]

/-- Composition law for the syntactic-carrier restriction:
`objRestrict P (f ≫ g) = (objRestrict P g) ∘ (objRestrict P f)`. -/
private lemma objRestrict_comp (P : X.PresheafOfModules)
    {U V W : (TopologicalSpace.Opens X)ᵒᵖ} (f : U ⟶ V) (g : V ⟶ W) :
    objRestrict P (f ≫ g) = (objRestrict P g).comp (objRestrict P f) := by
  ext x
  simp only [objRestrict_apply, CategoryTheory.Functor.map_comp, AddCommGrpCat.hom_comp,
    AddMonoidHom.coe_comp, Function.comp_apply, LinearMap.comp_apply]

/-- The objectwise `ℤ`-tensor presheaf `U ↦ Γ(U,P) ⊗_ℤ Γ(U,Q)` of two presheaves of modules
over a scheme, as a functor into abelian groups, with restriction maps the `ℤ`-tensors of the
two underlying restriction maps.  This is the codomain (apex-adjacent) presheaf of the cofork
in the presheaf promotion of `RelativeTensorCoequalizer.isColimitCofork`; it is the concrete
Step-1 brick of the presheaf-level coequalizer iso `relativeTensorCoequalizerIso`
(`lem:relativeTensor_as_coequalizer`).  Project-local: no objectwise `ℤ`-tensor of
abelian-group presheaves is provided by Mathlib (`AddCommGrpCat` carries no monoidal
structure in the current pin). -/
noncomputable def relTensorDomainPresheaf (P Q : X.PresheafOfModules) :
    (TopologicalSpace.Opens X)ᵒᵖ ⥤ Ab where
  obj U := AddCommGrpCat.of (P.obj U ⊗[ℤ] Q.obj U)
  map {U V} f := AddCommGrpCat.ofHom
    (TensorProduct.map (objRestrict P f) (objRestrict Q f)).toAddMonoidHom
  map_id U := by
    ext x
    induction x using TensorProduct.induction_on with
    | zero => simp
    | tmul m n =>
      simp only [AddCommGrpCat.hom_ofHom, LinearMap.toAddMonoidHom_coe, TensorProduct.map_tmul,
        objRestrict_apply, CategoryTheory.Functor.map_id, AddCommGrpCat.hom_id,
        AddMonoidHom.id_apply]
    | add a b ha hb => simp only [map_add, ha, hb]
  map_comp {U V W} f g := by
    ext x
    induction x using TensorProduct.induction_on with
    | zero => simp
    | tmul m n =>
      simp only [AddCommGrpCat.hom_ofHom, LinearMap.toAddMonoidHom_coe, TensorProduct.map_tmul,
        objRestrict_apply, CategoryTheory.Functor.map_comp,
        AddCommGrpCat.hom_comp, AddMonoidHom.coe_comp, Function.comp_apply]
    | add a b ha hb => simp only [map_add, ha, hb]

/-- The objectwise `ℤ`-tensor triple presheaf `U ↦ Γ(U,P) ⊗_ℤ (𝒪_X(U) ⊗_ℤ Γ(U,Q))` of two
presheaves of modules over a scheme, as a functor into abelian groups, with restriction maps the
`ℤ`-tensors of the underlying restriction maps (the middle factor restricting via the ring
restriction map of `𝒪_X`).  This is the **domain** row of the relative-tensor coequalizer
presentation (`lem:relativeTensor_as_coequalizer`); objectwise it is the triple tensor on which
the two `R(U)`-action maps `RelativeTensorCoequalizer.actLmap`/`actRmap` act.  Project-local: no
objectwise `ℤ`-tensor of abelian-group presheaves is provided by Mathlib. -/
noncomputable def relTensorTriplePresheaf (P Q : X.PresheafOfModules) :
    (TopologicalSpace.Opens X)ᵒᵖ ⥤ Ab where
  obj U := AddCommGrpCat.of (P.obj U ⊗[ℤ] (X.sheaf.obj.obj U ⊗[ℤ] Q.obj U))
  map {U V} f := AddCommGrpCat.ofHom
    (TensorProduct.map (objRestrict P f)
      (TensorProduct.map (X.sheaf.obj.map f).hom.toAddMonoidHom.toIntLinearMap
        (objRestrict Q f))).toAddMonoidHom
  map_id U := by
    have hR : (X.sheaf.obj.map (𝟙 U)).hom.toAddMonoidHom.toIntLinearMap =
        LinearMap.id (R := ℤ) (M := ↥(X.sheaf.obj.obj U)) := by
      ext s
      simp only [CategoryTheory.Functor.map_id, CommRingCat.hom_id, RingHom.toAddMonoidHom_eq_coe,
        AddMonoidHom.coe_toIntLinearMap, LinearMap.id_coe, id_eq]
      rfl
    rw [objRestrict_id P U, objRestrict_id Q U, hR, TensorProduct.map_id, TensorProduct.map_id]
    rfl
  map_comp {U V W} f g := by
    have hR : (X.sheaf.obj.map (f ≫ g)).hom.toAddMonoidHom.toIntLinearMap =
        ((X.sheaf.obj.map g).hom.toAddMonoidHom.toIntLinearMap).comp
          ((X.sheaf.obj.map f).hom.toAddMonoidHom.toIntLinearMap) := by
      ext s
      simp only [CategoryTheory.Functor.map_comp, CommRingCat.hom_comp,
        RingHom.toAddMonoidHom_eq_coe, AddMonoidHom.coe_toIntLinearMap, LinearMap.coe_comp,
        Function.comp_apply]
      rfl
    rw [objRestrict_comp P f g, objRestrict_comp Q f g, hR, TensorProduct.map_comp,
      TensorProduct.map_comp]
    rfl

/-- The **left-action** natural transformation of the coequalizer rows
(`def:relTensorActL`): `relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q`, whose
component at `U` is the objectwise left-action map
`RelativeTensorCoequalizer.actLmap` collapsing the middle ring factor through the scalar
action of `𝒪_X(U)` on `Γ(U,P)`, `m ⊗ (s ⊗ n) ↦ (s • m) ⊗ n`.  Naturality in `U` is the
compatibility of the module action with the restriction maps, checked on elementary tensors
by `⊗`-induction (the single fact `PresheafOfModules.map_smul`, bridged to the abelian
restriction by `objRestrict_apply`). -/
noncomputable def relTensorActL (P Q : X.PresheafOfModules) :
    relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q where
  app U := AddCommGrpCat.ofHom
    (RelativeTensorCoequalizer.actLmap (X.sheaf.obj.obj U) (P.obj U) (Q.obj U)).toAddMonoidHom
  naturality {U V} f := by
    -- The underlying ℤ-linear naturality square, proven by `⊗`-induction.  The single
    -- mathematical fact is `PresheafOfModules.map_smul` (semilinearity of the restriction).
    have key :
        (RelativeTensorCoequalizer.actLmap (↥(X.sheaf.obj.obj V)) (↥(P.obj V)) (↥(Q.obj V))).comp
            (TensorProduct.map (objRestrict P f)
              (TensorProduct.map (X.sheaf.obj.map f).hom.toAddMonoidHom.toIntLinearMap
                (objRestrict Q f)))
          = (TensorProduct.map (objRestrict P f) (objRestrict Q f)).comp
              (RelativeTensorCoequalizer.actLmap (↥(X.sheaf.obj.obj U)) (↥(P.obj U))
                (↥(Q.obj U))) := by
      apply TensorProduct.ext'
      intro m y
      induction y using TensorProduct.induction_on with
      | zero => simp
      | tmul s n =>
        change ((X.sheaf.obj.map f).hom.toAddMonoidHom.toIntLinearMap s • objRestrict P f m)
              ⊗ₜ[ℤ] objRestrict Q f n
            = objRestrict P f (s • m) ⊗ₜ[ℤ] objRestrict Q f n
        congr 1
        rw [objRestrict_apply, objRestrict_apply]
        exact (PresheafOfModules.map_smul P f s m).symm
      | add a b ha hb => simp only [map_add, ha, hb, TensorProduct.tmul_add]
    -- Transport the linear-map square to the categorical naturality square in `Ab`.
    apply AddCommGrpCat.hom_ext
    dsimp only [relTensorTriplePresheaf, relTensorDomainPresheaf]
    ext z
    have hz := LinearMap.congr_fun key z
    simpa only [AddCommGrpCat.hom_comp, AddCommGrpCat.hom_ofHom, AddMonoidHom.comp_apply,
      LinearMap.toAddMonoidHom_coe, LinearMap.comp_apply] using hz

/-- The **right-action** natural transformation of the coequalizer rows
(`def:relTensorActR`): `relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q`, whose
component at `U` is the objectwise right-action map
`RelativeTensorCoequalizer.actRmap` collapsing the middle ring factor through the scalar
action of `𝒪_X(U)` on `Γ(U,Q)`, `m ⊗ (s ⊗ n) ↦ m ⊗ (s • n)`.  Naturality is the
compatibility of the module action with the restriction maps (`PresheafOfModules.map_smul`
on `Q`), checked on elementary tensors by `⊗`-induction. -/
noncomputable def relTensorActR (P Q : X.PresheafOfModules) :
    relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q where
  app U := AddCommGrpCat.ofHom
    (RelativeTensorCoequalizer.actRmap (X.sheaf.obj.obj U) (P.obj U) (Q.obj U)).toAddMonoidHom
  naturality {U V} f := by
    have key :
        (RelativeTensorCoequalizer.actRmap (↥(X.sheaf.obj.obj V)) (↥(P.obj V)) (↥(Q.obj V))).comp
            (TensorProduct.map (objRestrict P f)
              (TensorProduct.map (X.sheaf.obj.map f).hom.toAddMonoidHom.toIntLinearMap
                (objRestrict Q f)))
          = (TensorProduct.map (objRestrict P f) (objRestrict Q f)).comp
              (RelativeTensorCoequalizer.actRmap (↥(X.sheaf.obj.obj U)) (↥(P.obj U))
                (↥(Q.obj U))) := by
      apply TensorProduct.ext'
      intro m y
      induction y using TensorProduct.induction_on with
      | zero => simp
      | tmul s n =>
        change objRestrict P f m
              ⊗ₜ[ℤ] ((X.sheaf.obj.map f).hom.toAddMonoidHom.toIntLinearMap s • objRestrict Q f n)
            = objRestrict P f m ⊗ₜ[ℤ] objRestrict Q f (s • n)
        congr 1
        rw [objRestrict_apply, objRestrict_apply]
        exact (PresheafOfModules.map_smul Q f s n).symm
      | add a b ha hb => simp only [map_add, ha, hb, TensorProduct.tmul_add]
    apply AddCommGrpCat.hom_ext
    dsimp only [relTensorTriplePresheaf, relTensorDomainPresheaf]
    ext z
    have hz := LinearMap.congr_fun key z
    simpa only [AddCommGrpCat.hom_comp, AddCommGrpCat.hom_ofHom, AddMonoidHom.comp_apply,
      LinearMap.toAddMonoidHom_coe, LinearMap.comp_apply] using hz

/-- The **projection** natural transformation (`relTensorProj`):
`relTensorDomainPresheaf P Q ⟶ (toPresheaf).obj (P ⊗_p Q)`, whose component at `U` is the
canonical quotient `RelativeTensorCoequalizer.projL` from the objectwise `ℤ`-tensor onto the
relative tensor `Γ(U,P) ⊗_{𝒪_X(U)} Γ(U,Q)` (the apex of the cofork, identified with the value of
the presheaf monoidal tensor by `PresheafOfModules.Monoidal.tensorObj_obj`).  This is the cofork
map of the presheaf-level coequalizer presentation `relativeTensorCoequalizerIso`. -/
noncomputable def relTensorProj (P Q : X.PresheafOfModules) :
    relTensorDomainPresheaf P Q ⟶
      (PresheafOfModules.toPresheaf X.ringCatSheaf.obj).obj
        (MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q) where
  app U := AddCommGrpCat.ofHom
    (RelativeTensorCoequalizer.projL (X.sheaf.obj.obj U) (P.obj U) (Q.obj U)).toAddMonoidHom
  naturality {U V} f := by
    -- NATURALITY (the square `projL_V ∘ domain.map f = apex.map f ∘ projL_U`).  We prove the
    -- underlying `ℤ`-linear square as `key` and transport it to the categorical square in `Ab`.
    -- An element-level `⊗`-induction at the `Ab` level is blocked by the `AddCommGrpCat.of` carrier
    -- instance mismatch (`map_add` fails to fire on the bundled `Ab`-morphism applied to `a + b`);
    -- working with bare `ℤ`-linear maps and `TensorProduct.ext'` sidesteps it entirely.  On an
    -- elementary tensor `m ⊗ₜ n` both composites send it to
    -- `(objRestrict P f m) ⊗ₜ[R(V)] (objRestrict Q f n)` definitionally: the LHS via
    -- `TensorProduct.map`+`projL`, the RHS via `projL`+`tensorObj_map_tmul`
    -- (both `⊗ₜ`-on-the-nose).  The `S = X.sheaf.obj.obj V` vs `R.obj V` base-ring discrepancy is a
    -- `forget₂ CommRingCat RingCat`-identity, so the elementary-tensor case is `rfl` (no instance
    -- re-synthesis, since the existing goal instances are reused).
    have key :
        (RelativeTensorCoequalizer.projL (↑(X.sheaf.obj.obj V)) (↑(P.obj V)) (↑(Q.obj V))).comp
            (TensorProduct.map (objRestrict P f) (objRestrict Q f))
          = (AddCommGrpCat.Hom.hom
                (((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).obj
                  (MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q)).map
                    f)).toIntLinearMap.comp
              (RelativeTensorCoequalizer.projL (↑(X.sheaf.obj.obj U)) (↑(P.obj U))
                (↑(Q.obj U))) := by
      apply TensorProduct.ext'
      intro m n
      rfl
    apply AddCommGrpCat.hom_ext
    ext z
    have hz := LinearMap.congr_fun key z
    simpa only [AddCommGrpCat.hom_comp, AddCommGrpCat.hom_ofHom, AddMonoidHom.comp_apply,
      LinearMap.toAddMonoidHom_coe, LinearMap.comp_apply, AddMonoidHom.coe_toIntLinearMap] using hz

/-- The cofork condition for the presheaf-level relative-tensor coequalizer: the left- and
right-action rows compose equally with the projection, `a_L ≫ π = a_R ≫ π`, as natural
transformations of `(Opens X)ᵒᵖ ⥤ Ab`.  Objectwise it is
`RelativeTensorCoequalizer.coeq_condition`. -/
lemma relTensorActL_proj_eq (P Q : X.PresheafOfModules) :
    relTensorActL P Q ≫ relTensorProj P Q = relTensorActR P Q ≫ relTensorProj P Q := by
  ext U : 2
  exact RelativeTensorCoequalizer.coeq_condition (X.sheaf.obj.obj U) (P.obj U) (Q.obj U)

/- Planner strategy: 3-step promotion (blueprint `lem:relativeTensor_as_coequalizer` proof):
1. OBJECTWISE — at each `U`, instantiate `RelativeTensorCoequalizer.isColimitCofork` with
   `S = O_X(U)`, `M = P(U)`, `N = Q(U)`. (API DONE axiom-clean.)
2. PROMOTE — the three objectwise families ARE `relTensorActL`/`relTensorActR`/`relTensorProj`
   (already natural). A functor-category cocone is a colimit iff every evaluation is, via
   `CategoryTheory.Limits.evaluationJointlyReflectsColimits` [Mathlib, verify with leansearch].
   NOTE (iter-063): leansearch only finds `CategoryTheory.Limits.evaluationJointlyReflectsLimits`
   (limits), not the colimit version; the colimit analogue may be
   `PresheafOfModules.evaluationJointlyReflectsColimits` or
   `CategoryTheory.Limits.combinedIsColimit` — verify before use.
3. APEX — identify the apex presheaf `U ↦ P(U) ⊗_{O_X(U)} Q(U)` with the underlying Ab-presheaf
   of `P ⊗_p Q` via `PresheafOfModules.Monoidal.tensorObj_obj` (verified in Mathlib);
   transport the colimit along it.
Reusable recipe: the `TensorProduct.ext'`→transport-to-`Ab` idiom from `relTensorProj.naturality`
is the carrier-bookkeeping pattern. `(P ⊗ Q)` in a fresh `have` must be written
`MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q` (bare `⊗` re-resolves to TensorProduct).
-/
/-- The underlying abelian-group presheaf of the presheaf-level relative tensor product
`P ⊗_p Q` is the coequalizer, in the functor category `(Opens X)ᵒᵖ ⥤ Ab`, of the parallel pair
`relTensorActL P Q` / `relTensorActR P Q` with cofork leg `relTensorProj P Q`.  This is the
presheaf-level promotion of `RelativeTensorCoequalizer.isColimitCofork` (the objectwise content of
`lem:relativeTensor_as_coequalizer`): colimits in a functor category are computed objectwise, so
the objectwise coequalizer at each `U` promotes to a coequalizer in `(Opens X)ᵒᵖ ⥤ Ab`.
(`lem:relativeTensor_as_coequalizer`, `lem:evaluationJointlyReflectsColimits_mathlib`,
`lem:presheaf_tensorObj_obj_mathlib`.) -/
noncomputable def relativeTensorCoequalizerIso (P Q : X.PresheafOfModules) :
    Limits.IsColimit (Limits.Cofork.ofπ (relTensorProj P Q) (relTensorActL_proj_eq P Q)) :=
  evaluationJointlyReflectsColimits _ fun U =>
    (isColimitMapCoconeCoforkEquiv ((evaluation _ _).obj U) (relTensorActL_proj_eq P Q)).symm
      (RelativeTensorCoequalizer.isColimitCofork (X.sheaf.obj.obj U) (P.obj U) (Q.obj U))

/-
### Action / projection natural transformations of the coequalizer rows — DEFERRED (handoff)

The next promotion step assembles `actLmap`/`actRmap`/`projL` into NATURAL transformations of
`(Opens X)ᵒᵖ ⥤ Ab` between `relTensorTriplePresheaf P Q`, `relTensorDomainPresheaf P Q`, and the
apex `(toPresheaf).obj (P ⊗_p Q)`, then lifts the cofork via
`CategoryTheory.Limits.evaluationJointlyReflectsColimits` (apex identified by
`PresheafOfModules.Monoidal.tensorObj_obj`) to `relativeTensorCoequalizerIso`
(`lem:relativeTensor_as_coequalizer`).

The left-action component
`app U := AddCommGrpCat.ofHom (RelativeTensorCoequalizer.actLmap (X.sheaf.obj.obj U) (P.obj U)
(Q.obj U)).toAddMonoidHom : relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q` TYPECHECKS,
and naturality reduces mathematically to the SINGLE fact `PresheafOfModules.map_smul` on
`m ⊗ (s ⊗ n)`, bridged onto the abelian restriction by the verified lemma
`PresheafOfModules.presheaf_map_apply_coe : (M.presheaf.map f).hom x = (ConcreteCategory.hom (M.map f)) x`.

BLOCKER (iter-056, root-caused after ~12 distinct attempts — a genuine whnf/defeq matching wall):
after peeling the `≫`-composite (`AddCommGrpCat.hom_comp` + `AddMonoidHom.comp_apply`),
`TensorProduct.map_tmul` / `LinearMap.toAddMonoidHom_coe` REFUSE to reduce the inner
`(TensorProduct.map (P.presheaf.map f).hom.toIntLinearMap …).toAddMonoidHom (m ⊗ₜ (s ⊗ₜ n))`.
Root cause: the `tmul` element comes from `TensorProduct.induction_on` on `x : ↥(obj U)` where
`obj U = AddCommGrpCat.of (P.obj U ⊗[ℤ] …)`, so `m : ↥(P.obj U)`, whereas the restriction map
(`(P.presheaf.map f).hom.toIntLinearMap`, the only `ℤ`-linear restriction Mathlib provides) has
domain `↥((P.presheaf).obj U)`.  These carriers are `rfl`-defeq but SYNTACTICALLY distinct, so
`map_tmul`'s LHS `(TensorProduct.map ?f ?g) (?a ⊗ₜ ?b)` cannot unify the element's tensor type with
the map's domain.  VERIFIED: the identical reduction succeeds in isolation when the carriers agree
(both free, or both `(AddCommGrpCat.Hom.hom φ).toIntLinearMap` with matching domain).

Attempts ruled out THIS iter (all hit the SAME element-vs-map carrier gap from a different angle):
  • pure-`LinearMap` lemma + `LinearMap.congr_fun` (`comp_apply` peels one side, `rw` misses other);
  • `show … from`-ascribing restriction maps to `↥(P.obj ·)` — defeq-erased, no effect;
  • `inferInstanceAs`-aligning `actLmap`'s domain carriers to `(P.presheaf).obj ·` — typechecks, but
    the restriction-map side still mismatches the `obj`-carrier element;
  • making BOTH presheaves' `obj` carriers `(P.presheaf).obj ·` (so induction elements match the
    maps) — CASCADES: breaks the proven `relTensorDomainPresheaf.map_id`/`map_comp` (their `𝟙`/`rfl`
    leaves now mismatch) AND `comp_apply` becomes intermittent; reverted;
  • full `simp`, `erw`, explicit `rw` chains, `conv … => enter [2]` (focuses the subterm, the def-
    unfold + `hom_ofHom` fire there but `map_tmul` STILL doesn't) — same wall.

NEXT-ITER HANDLES (untried, in priority order):
  (1) Provide a `ℤ`-linear restriction with SYNTACTIC `↥(P.obj U) → ↥(P.obj V)` carriers as a DISTINCT
      term (not a defeq ascription) — e.g. from the `ModuleCat` restriction `P.map f` via
      `ModuleCat.Hom.hom` + a `restrictScalars` carrier-identity — and use it uniformly in
      `relTensorTriplePresheaf`/`relTensorDomainPresheaf` AND `actLmap`, so element and map carriers
      agree by construction.  Re-prove the (now trivial) `map_id`/`map_comp`.
  (2) After peeling, `eqToHom`/`cast`-transport the inner element `BIG : ↥((P.presheaf).obj V)⊗…` to
      the `↥(P.obj V)⊗…`-form (or vice versa) so `map_tmul` matches, then transport back.
  (3) Escalate: this is the documented diamond/whnf friction (memory `quot-gap1-closed-opaque-immersion`),
      and the math content is one `map_smul`; a Mathlib-side `@[simp]` apply lemma for the abelian
      restriction-map-on-tmul (or a `PresheafOfModules`/`AddCommGrpCat`-tensor restriction API) would
      dissolve it.

-/

/-
### (superseded handoff notes — retained for the additional `inferInstanceAs` detail)

The remaining promotion step assembles `actRmap`/`projL` into NATURAL transformations of
`(Opens X)ᵒᵖ ⥤ Ab` between `relTensorTriplePresheaf P Q`, `relTensorDomainPresheaf P Q`, and the
apex `(toPresheaf).obj (P ⊗_p Q)`, then lifts the cofork via
`CategoryTheory.Limits.evaluationJointlyReflectsColimits` (apex identified by
`PresheafOfModules.Monoidal.tensorObj_obj`) to `relativeTensorCoequalizerIso`
(`lem:relativeTensor_as_coequalizer`).

The left-action component
`app U := AddCommGrpCat.ofHom (RelativeTensorCoequalizer.actLmap (X.sheaf.obj.obj U) (P.obj U)
(Q.obj U)).toAddMonoidHom : relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q` TYPECHECKS,
and naturality reduces mathematically to `PresheafOfModules.map_smul` on `m ⊗ (s ⊗ n)`, bridged onto
the abelian restriction by the verified lemma
`PresheafOfModules.presheaf_map_apply_coe : (M.presheaf.map f).hom x = (ConcreteCategory.hom (M.map f)) x`.

BLOCKER (iter-056, attempted at length, NOT a carrier mismatch): after peeling the `≫`-composite
(`AddCommGrpCat.hom_comp` + `AddMonoidHom.comp_apply` — both fire), `simp`/`rw` REFUSE to reduce the
inner `(TensorProduct.map …).toAddMonoidHom (m ⊗ₜ (s ⊗ₜ n))` while it sits UNDER the
`actLmap.toAddMonoidHom (…)` head: `LinearMap.toAddMonoidHom_coe` and `TensorProduct.map_tmul` report
`unused`/no-progress, *even though* the IDENTICAL reduction succeeds in isolation (verified:
`simp only [LinearMap.toAddMonoidHom_coe, TensorProduct.map_tmul]` closes
`(TensorProduct.map A (TensorProduct.map B C)).toAddMonoidHom (m ⊗ₜ (s ⊗ₜ n)) = A m ⊗ₜ (B s ⊗ₜ C n)`).

Approaches tried and ruled out THIS iter:
  • pure-`LinearMap` naturality lemma + `LinearMap.congr_fun` transport — `LinearMap.comp_apply`
    peels one side, `rw` fails to find the pattern on the other (`(?f ∘ₛₗ ?g) ?x` not matched);
  • `show … from`-ascribing the restriction maps to `↥(P.obj ·)` carriers — defeq-erased, no effect;
  • aligning `actLmap`'s domain carriers to the `(P.presheaf).obj ·`-form via VERIFIED
    `inferInstanceAs`-transported `Module` instances (so `actLmap`'s domain matches the restriction
    maps' codomain SYNTACTICALLY) — typechecks, but `simp` STILL refuses the inner reduction, proving
    the wall is a `simp`/whnf descent pathology under the (folded, large) `actLmap` head, NOT the
    `(P.presheaf).obj`-vs-`P.obj` carrier gap;
  • full `simp` (vs `simp only`), `erw`, explicit `rw` chains — same.

NEXT-ITER HANDLES (untried): (1) reduce the inner map application BEFORE composing — e.g. rewrite
`(relTensorTriplePresheaf P Q).map f` to a pre-reduced `tmul`-aware form via a dedicated
`@[simp] relTensorTriplePresheaf_map_tmul` lemma proved by `rfl`/`induction`, so the naturality leaf
never has to descend under `actLmap`; (2) `conv`-navigate explicitly into the `actLmap` argument
and rewrite there; (3) prove the AddMonoidHom equality by `DFunLike.ext` on the COMPOSITE BEFORE
peeling, exposing both maps' actions simultaneously.  The genuine mathematical content is the single
`map_smul`/`presheaf_map_apply_coe` step.

The component `app U := AddCommGrpCat.ofHom (actLmap (X.sheaf.obj.obj U) (P.obj U)
(Q.obj U)).toAddMonoidHom : relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q` TYPECHECKS,
and naturality reduces mathematically to `PresheafOfModules.map_smul` on `m ⊗ (s ⊗ n)`, bridged onto
the abelian restriction `(P.presheaf.map f)` by the verified lemma
`PresheafOfModules.presheaf_map_apply_coe : (M.presheaf.map f).hom x = (ConcreteCategory.hom (M.map f)) x`.

BLOCKER (iter-056, root-caused): after peeling the `≫`-composite (`AddCommGrpCat.hom_comp` +
`AddMonoidHom.comp_apply`, both fire on the small folded form), `simp`/`rw` CANNOT descend into
`actLmap_V.toAddMonoidHom (BIG)` to reduce the inner
`BIG = (TensorProduct.map …).toAddMonoidHom (m ⊗ₜ (s ⊗ₜ n))`: `LinearMap.toAddMonoidHom_coe` and
`TensorProduct.map_tmul` (verified to fire on the IDENTICAL term in isolation) report `unused`.
Cause: `BIG : ↥((P.presheaf).obj V) ⊗ …` (codomain of the abelian restriction maps in
`relTensorTriplePresheaf.map`), whereas `actLmap_V`'s domain is `↥(P.obj V) ⊗ …`.  These are
`rfl`-defeq but SYNTACTICALLY distinct, so `simp`'s congruence motive `fun a => actLmap_V.toAddMonoidHom a`
fails to typecheck `BIG` at the abstracted (P.obj-form) domain and refuses to rewrite under the head.

ATTEMPTED + RULED OUT: (i) a pure-`LinearMap` naturality lemma + `LinearMap.congr_fun` transport —
same carrier mismatch (`rw [LinearMap.comp_apply]` peels one side, fails on the other).  (ii) Type
ascription `show ↥(P.obj U) →ₗ[ℤ] ↥(P.obj V) from (P.presheaf.map f).hom.toIntLinearMap` on the
presheaves' restriction maps — ELABORATED AWAY (defeq), the underlying term stays `(P.presheaf.map f)`.

GENUINE FIX (next iter), most promising FIRST: align `actLmap`'s domain carriers with the restriction
maps' `(P.presheaf).obj`-form instead of the reverse.  Define `app U` as
`AddCommGrpCat.ofHom (actLmap (X.sheaf.obj.obj U) ((P.presheaf).obj U) ((Q.presheaf).obj U)).toAddMonoidHom`,
supplying the `Module ↥(X.sheaf.obj.obj U) ↥((P.presheaf).obj U)` instances (NOT auto-found) by
`inferInstanceAs (Module _ ↥(P.obj U))` — VERIFIED to elaborate (the carriers are `rfl`-defeq and the
instance transports).  Then `actLmap_V`'s domain is SYNTACTICALLY `↥((P.presheaf).obj V) ⊗ …`,
matching `BIG`, so `simp` descends and `map_tmul`/`actLmap_tmul`/`presheaf_map_apply_coe`/`map_smul`
close it.  The wrinkle: the `letI`/`haveI` instances must be in scope for the `naturality` proof too
(use a top-level `haveI` by writing the `NatTrans` via `{ app := …, naturality := … }` inside a
`by`-block that opens the instances, or thread them explicitly).  Alternative fixes: (a) a `(P.map f)`-derived
`ℤ`-linear restriction with `P.obj` codomain; (b) `erw`/`conv`/`eqToHom`-transport of `BIG`.  The genuine
mathematical content is the single `map_smul`/`presheaf_map_apply_coe` step; the rest is carrier
bookkeeping.  Once `relTensorActL`/`relTensorActR`/`relTensorProj` land, lift the cofork to
`Cᵒᵖ ⥤ Ab` via `CategoryTheory.Limits.evaluationJointlyReflectsColimits` (apex identified with
`(toPresheaf).obj (P ⊗_p Q)` by `PresheafOfModules.Monoidal.tensorObj_obj`), giving
`relativeTensorCoequalizerIso` (`lem:relativeTensor_as_coequalizer`).

-/

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
`tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`, `sectionsMul` (the
lax-monoidal multiplication, which does NOT need the associator), and — NEW in
iter-052 — the localization-criterion reduction `isIso_sheafification_map_iff`,
together with `localIso_toPresheaf_map_unit` and `isIso_sheafification_map_unit`.

ITER-052 STATUS — the crux `isIso_sheafification_whiskerRight_unit`
(`IsIso (sheafification.map (η_P ▷ Q))`) is now reduced to exactly ONE abelian
statement, and the un-whiskered special case is CLOSED:

* `isIso_sheafification_map_iff f : IsIso (sheafification.map f) ↔ J.W (toPresheaf.map f)`
  (axiom-clean) turns the crux into the purely abelian local-isomorphism claim
      `J.W ((PresheafOfModules.toPresheaf _).map (η_P ▷ Q))`
  where `J = opensTopology X` and `J.W` is the local-iso class on abelian-group
  presheaves on `X`.  Hence the crux is precisely
      `(isIso_sheafification_map_iff _).mpr (?_ : J.W (toPresheaf.map (η_P ▷ Q)))`.
* `localIso_toPresheaf_map_unit` proves the `η_P ∈ J.W` half (the underlying abelian
  map of the unit IS `toSheafify`, a local iso), and `isIso_sheafification_map_unit`
  closes the un-whiskered `IsIso (sheafification.map η_P)`.

THE REMAINING GAP is the single abelian fact
      `J.W (toPresheaf.map (η_P)) → J.W (toPresheaf.map (η_P ▷ Q))`,
i.e. *the relative-tensor right-whiskering of an abelian local isomorphism by `Q` is
again an abelian local isomorphism*.  Note `toPresheaf.map (η_P ▷ Q)` is the
underlying map of `(η_P).app U ⊗_{R(U)} 𝟙_{Q(U)}` (relative `R(U)`-tensor), NOT the
abelian `ℤ`-tensor whiskering, so Mathlib's `GrothendieckTopology.W.whiskerRight`
(`Sites/Monoidal.lean`, for the `ℤ`-tensor on `Cᵒᵖ ⥤ Ab`) does not apply directly.
All three routes to bridge relative-⊗ to abelian-⊗ are confirmed blocked on a
DISTINCT Mathlib-absent brick (verified by local search this iter):

  (a) **abelian-`J.W` coequalizer transfer** (snap-route Analogue 1): needs
      `P ⊗_{R} Q ≅ coequalizer (P ⊗_ℤ R ⊗_ℤ Q ⇉ P ⊗_ℤ Q)` in `Cᵒᵖ ⥤ Ab`,
      naturally, identified with the Mathlib relative-tensor whiskering.  NO
      tensor-product-as-coequalizer presentation exists in pinned Mathlib
      (`grep coequalizer` over `LinearAlgebra/TensorProduct`, `Algebra/Category`
      returns nothing).  This is the lowest-absent-infra route (it reuses the
      present `GrothendieckTopology.W.monoidal` for `ℤ`).
  (b) **Day's reflection / closed** (snap-assoc Analogue 2): needs
      `MonoidalClosed (PresheafOfModules R₀)` — ABSENT (only `Rep`/functor-category
      closed instances exist; module presheaves carry restriction-of-scalars).
  (c) **stalkwise-iso** (snap-route Analogue 2): needs a stalk theory for
      `X.Modules` + `(F⊗G)_x ≅ F_x ⊗ G_x` — module-sheaf stalks ABSENT.

ITER-053 PROGRESS — the OBJECTWISE half of route (a)'s brick is now BUILT, axiom-clean,
in `namespace RelativeTensorCoequalizer` above (`isColimitCofork`).  Concretely, for a
commutative ring `S` and `S`-modules `M, N`, the relative tensor `M ⊗[S] N` is exhibited
as the coequalizer **in `AddCommGrpCat`** of the two `S`-action maps
`M ⊗[ℤ] (S ⊗[ℤ] N) ⇉ M ⊗[ℤ] N`:
  * `actN`/`actM`/`actLmap`/`actRmap` — the two action maps (`ℤ`-linear);
  * `projL` (surjective, `projL_surjective`) — the quotient map `M ⊗[ℤ] N ↠ M ⊗[S] N`;
  * `piMor` (an `Epi`, `piMor_epi`), `cofork`, and `isColimitCofork` — the cofork plus its
    universal property, the latter proved from `TensorProduct.liftAddHom` (existence) and
    epi-cancellation of `piMor` (uniqueness).
This is the genuinely Mathlib-absent mathematical core (`TensorProduct.liftAddHom` is the
abelian universal property; there is no tensor-as-coequalizer lemma in pinned Mathlib).

NEXT-ITER TASK (presheaf promotion + crux): lift `isColimitCofork` from a single object to
the functor category `Cᵒᵖ ⥤ AddCommGrpCat`, where colimits are computed objectwise
(`CategoryTheory.Limits.evaluationJointlyReflectsColimits` /
`Functor.preservesColimit` of `(evaluation _ _).obj U`).  Steps:
  1. Assemble `actN`/`actM`/`projL` into NATURAL transformations of `Cᵒᵖ ⥤ AddCommGrpCat`
     between the `ℤ`-tensor presheaves `P ⊗_ℤ R₀ ⊗_ℤ Q ⇉ P ⊗_ℤ Q` (objectwise = the maps
     above at `U`; naturality = compatibility with restriction, which holds because each map
     is built from the module action, natural in `U`).
  2. Identify the apex `U ↦ P(U) ⊗_{R₀(U)} Q(U)` with `(toPresheaf R₀).obj (P ⊗_p Q)`
     (Mathlib `PresheafOfModules.Monoidal.tensorObj`, via `tensorObj_obj` /
     `tensorObj_map_tmul`), giving `relativeTensorCoequalizerIso`
     (`lem:relativeTensor_as_coequalizer`).
  3. Identify `toPresheaf.map (η_P ▷ Q)` with the map of coequalizers induced by whiskering
     the two rows with `η_P ⊗_ℤ (-)`; abelian sheafification `a` (left adjoint) preserves the
     coequalizer, and `GrothendieckTopology.W.monoidal` inverts the `ℤ`-whiskered rows, so the
     induced map lands in `J.W` — closing `isIso_sheafification_whiskerRight_unit` via
     `(isIso_sheafification_map_iff _).mpr`.
Then ride the associator/`tensorPowAdd` (hence `sectionMul_coherent` and the graded-ring
assembly) on top — these wait only on the crux.

(Routes (b) Day's-closed and (c) stalkwise remain blocked on `MonoidalClosed
(PresheafOfModules R₀)` / module-sheaf stalks respectively — do not pursue.)
-/

/-! ## Project-local Mathlib supplement — relative-tensor whiskering preserves `J.W`

The class `J.W` of abelian local isomorphisms is closed under right-whiskering by an
arbitrary presheaf in the **pointwise** monoidal structure on `Cᵒᵖ ⥤ A` whenever `A` is
braided monoidal closed: this is Mathlib's `GrothendieckTopology.W.whiskerRight`
(Day reflection, `CategoryTheory/Sites/Monoidal.lean`).  Two gaps separate that statement
from `ztensor_whisker_localIso`:

* `Ab` carries no (tensor) monoidal structure in Mathlib, and the `ModuleCat` monoidal
  structure insists that ring and modules live in the same universe.  We therefore work in
  `ModuleCat.{u} (ULift.{u} ℤ)` and transport `J.W` along the carrier-preserving
  equivalence `modToAb` (an equivalence is a left adjoint in both directions, hence
  preserves sheafification both ways — `W_whiskerRight_modToAb_iff`).
* the morphism in `ztensor_whisker_localIso` is the *relative*-tensor whiskering
  `f ▷ R` (over `𝒪_X`), not the `ℤ`-tensor one.  The coequalizer presentation
  `relativeTensorCoequalizerIso` exhibits its underlying abelian map as the map induced on
  coequalizers by the two `ℤ`-tensor whiskered rows (`domWhisker`, `tripWhisker`); abelian
  sheafification preserves the coequalizers and inverts the rows, hence inverts the induced
  map (`GrothendieckTopology.W_iff`).
-/

section ZTensorWhisker

open TensorProduct

/-- Promote an additive homomorphism of abelian groups to a `ULift ℤ`-linear map (any
additive map of abelian groups is `ℤ`-linear, and the `ULift ℤ`-action is the `ℤ`-action). -/
private def toULiftIntLinearMap {M N : Type u} [AddCommGroup M] [AddCommGroup N]
    (φ : M →+ N) : M →ₗ[ULift.{u} ℤ] N where
  toFun := φ
  map_add' := φ.map_add
  map_smul' c x := by
    change φ (c.down • x) = c.down • φ x
    exact map_zsmul φ c.down x

@[simp] private lemma toULiftIntLinearMap_apply {M N : Type u} [AddCommGroup M]
    [AddCommGroup N] (φ : M →+ N) (x : M) : toULiftIntLinearMap φ x = φ x := rfl

/-- The `ℤ`- and `ULift ℤ`-actions on abelian groups are tensor-compatible. -/
private instance compatibleSMul_int_uliftInt (M N : Type u) [AddCommGroup M]
    [AddCommGroup N] : CompatibleSMul ℤ (ULift.{u} ℤ) M N :=
  ⟨fun c m n => smul_tmul c.down m n⟩

/-- The relative tensor product over `ULift ℤ` of two abelian groups agrees with their
`ℤ`-tensor product (`TensorProduct.equivOfCompatibleSMul`); both directions send an
elementary tensor `m ⊗ₜ n` to `m ⊗ₜ n`. -/
private noncomputable def uTensorEquiv (M N : Type u) [AddCommGroup M] [AddCommGroup N] :
    (M ⊗[ULift.{u} ℤ] N) ≃ₗ[ℤ] (M ⊗[ℤ] N) :=
  TensorProduct.equivOfCompatibleSMul ℤ (ULift.{u} ℤ) ℤ M N

@[simp] private lemma uTensorEquiv_tmul (M N : Type u) [AddCommGroup M] [AddCommGroup N]
    (m : M) (n : N) : uTensorEquiv M N (m ⊗ₜ n) = m ⊗ₜ n := rfl

@[simp] private lemma uTensorEquiv_symm_tmul (M N : Type u) [AddCommGroup M]
    [AddCommGroup N] (m : M) (n : N) : (uTensorEquiv M N).symm (m ⊗ₜ n) = m ⊗ₜ n := rfl

/-- The triple-tensor variant of `uTensorEquiv`:
`M ⊗[ULift ℤ] (S ⊗[ULift ℤ] N) ≃ M ⊗[ℤ] (S ⊗[ℤ] N)`, sending `m ⊗ₜ (s ⊗ₜ n)` to itself. -/
private noncomputable def uTripleEquiv (M S N : Type u) [AddCommGroup M] [AddCommGroup S]
    [AddCommGroup N] :
    (M ⊗[ULift.{u} ℤ] (S ⊗[ULift.{u} ℤ] N)) ≃ₗ[ℤ] (M ⊗[ℤ] (S ⊗[ℤ] N)) :=
  (uTensorEquiv M (S ⊗[ULift.{u} ℤ] N)) ≪≫ₗ
    (TensorProduct.congr (LinearEquiv.refl ℤ M) (uTensorEquiv S N))

@[simp] private lemma uTripleEquiv_tmul (M S N : Type u) [AddCommGroup M] [AddCommGroup S]
    [AddCommGroup N] (m : M) (s : S) (n : N) :
    uTripleEquiv M S N (m ⊗ₜ (s ⊗ₜ n)) = m ⊗ₜ (s ⊗ₜ n) := rfl

@[simp] private lemma uTripleEquiv_symm_tmul (M S N : Type u) [AddCommGroup M]
    [AddCommGroup S] [AddCommGroup N] (m : M) (s : S) (n : N) :
    (uTripleEquiv M S N).symm (m ⊗ₜ (s ⊗ₜ n)) = m ⊗ₜ (s ⊗ₜ n) := rfl

/-- The presheaf of `ULift ℤ`-modules underlying a presheaf of `𝒪_X`-modules, with the
syntactic `↥(P.obj U)` carriers of `objRestrict`.  This places the underlying abelian
presheaf of `P` in a category (`Cᵒᵖ ⥤ ModuleCat (ULift ℤ)`) which Mathlib equips with a
pointwise braided monoidal-closed structure, so that
`GrothendieckTopology.W.whiskerRight` applies. -/
private noncomputable def uModPresheaf (P : X.PresheafOfModules) :
    (TopologicalSpace.Opens X)ᵒᵖ ⥤ ModuleCat.{u} (ULift.{u} ℤ) where
  obj U := ModuleCat.of (ULift.{u} ℤ) ↥(P.obj U)
  map {U V} g := ModuleCat.ofHom (toULiftIntLinearMap (objRestrict P g).toAddMonoidHom)
  map_id U := by
    ext x
    exact LinearMap.congr_fun (objRestrict_id P U) x
  map_comp {U V W} g h := by
    ext x
    exact LinearMap.congr_fun (objRestrict_comp P g h) x

/-- The presheaf of `ULift ℤ`-modules underlying the structure sheaf of `X`. -/
private noncomputable def uModRingPresheaf (X : Scheme.{u}) :
    (TopologicalSpace.Opens X)ᵒᵖ ⥤ ModuleCat.{u} (ULift.{u} ℤ) where
  obj U := ModuleCat.of (ULift.{u} ℤ) ↥(X.sheaf.obj.obj U)
  map {U V} g := ModuleCat.ofHom
    (toULiftIntLinearMap (X.sheaf.obj.map g).hom.toAddMonoidHom)
  map_id U := by
    ext s
    change (X.sheaf.obj.map (𝟙 U)).hom s = s
    rw [CategoryTheory.Functor.map_id]
    rfl
  map_comp {U V W} g h := by
    ext s
    change (X.sheaf.obj.map (g ≫ h)).hom s
      = (X.sheaf.obj.map h).hom ((X.sheaf.obj.map g).hom s)
    rw [CategoryTheory.Functor.map_comp]
    rfl

/-- The morphism of `ULift ℤ`-module presheaves underlying a morphism of presheaves of
modules. -/
private noncomputable def uModHom {P Q : X.PresheafOfModules} (f : P ⟶ Q) :
    uModPresheaf P ⟶ uModPresheaf Q where
  app U := ModuleCat.ofHom (toULiftIntLinearMap (f.app U).hom.toAddMonoidHom)
  naturality {U V} g := by
    ext x
    exact PresheafOfModules.naturality_apply f g x

/-- The carrier-preserving equivalence from `ULift ℤ`-modules to abelian groups:
restriction of scalars along `ℤ ≅ ULift ℤ` followed by the standard equivalence
`ModuleCat ℤ ≌ Ab`. -/
private noncomputable def modToAb : ModuleCat.{u} (ULift.{u} ℤ) ⥤ Ab.{u} :=
  ModuleCat.restrictScalars (ULift.ringEquiv.symm : ℤ ≃+* ULift.{u} ℤ).toRingHom ⋙
    forget₂ (ModuleCat.{u} ℤ) AddCommGrpCat.{u}

private instance : modToAb.{u}.IsEquivalence := by
  unfold modToAb
  infer_instance

@[simp] private lemma modToAb_map_apply {M N : ModuleCat.{u} (ULift.{u} ℤ)} (ψ : M ⟶ N)
    (x : M) : (ConcreteCategory.hom (modToAb.map ψ)) x = ψ.hom x := rfl

/-- **`J.W` transfers along `modToAb`** (both directions).  The equivalence `modToAb` is a
left adjoint in both directions, hence preserves sheafification both ways
(`Sheaf.preservesSheafification_of_adjunction`). -/
private lemma W_whiskerRight_modToAb_iff {C : Type u} [SmallCategory C]
    (J : GrothendieckTopology C) {F G : Cᵒᵖ ⥤ ModuleCat.{u} (ULift.{u} ℤ)} (ψ : F ⟶ G) :
    J.W (Functor.whiskerRight ψ modToAb.{u}) ↔ J.W ψ := by
  haveI h₁ : J.PreservesSheafification modToAb.{u} :=
    Sheaf.preservesSheafification_of_adjunction J modToAb.{u}.asEquivalence.toAdjunction
  haveI h₂ : J.PreservesSheafification modToAb.{u}.asEquivalence.inverse :=
    Sheaf.preservesSheafification_of_adjunction J modToAb.{u}.asEquivalence.symm.toAdjunction
  constructor
  · intro h
    have h2 := J.W_of_preservesSheafification modToAb.{u}.asEquivalence.inverse _ h
    refine ((J.W).arrow_mk_iso_iff ?_).mp h2
    refine Arrow.isoMk
      (NatIso.ofComponents
        (fun U => modToAb.{u}.asEquivalence.unitIso.symm.app (F.obj U)) ?_)
      (NatIso.ofComponents
        (fun U => modToAb.{u}.asEquivalence.unitIso.symm.app (G.obj U)) ?_) ?_
    · intro U V g
      exact modToAb.{u}.asEquivalence.unitIso.inv.naturality (F.map g)
    · intro U V g
      exact modToAb.{u}.asEquivalence.unitIso.inv.naturality (G.map g)
    · ext U : 2
      simp only [NatTrans.comp_app, NatIso.ofComponents_hom_app, Arrow.mk_hom]
      exact (modToAb.{u}.asEquivalence.unitIso.inv.naturality (ψ.app U)).symm
  · intro h
    exact J.W_of_preservesSheafification modToAb.{u} _ h

/-- The abelian presheaf underlying `uModPresheaf P` is the underlying abelian presheaf
of `P` (carrier-preserving comparison). -/
private noncomputable def uModForgetIso (P : X.PresheafOfModules) :
    uModPresheaf P ⋙ modToAb.{u} ≅
      (PresheafOfModules.toPresheaf X.ringCatSheaf.obj).obj P :=
  NatIso.ofComponents
    (fun U =>
      { hom := AddCommGrpCat.ofHom
          { toFun := fun x => x
            map_zero' := rfl
            map_add' := fun _ _ => rfl }
        inv := AddCommGrpCat.ofHom
          { toFun := fun x => x
            map_zero' := rfl
            map_add' := fun _ _ => rfl }
        hom_inv_id := by ext x; rfl
        inv_hom_id := by ext x; rfl })
    (fun {U V} g => by
      apply AddCommGrpCat.hom_ext
      ext x
      rfl)

/-- The abelian presheaf underlying the pointwise tensor `uModPresheaf P ⊗ uModPresheaf R`
is the `ℤ`-tensor presheaf `relTensorDomainPresheaf P R` (componentwise `uTensorEquiv`). -/
private noncomputable def uDomIso (P R : X.PresheafOfModules) :
    (MonoidalCategory.tensorObj (uModPresheaf P) (uModPresheaf R)) ⋙ modToAb.{u} ≅
      relTensorDomainPresheaf P R :=
  NatIso.ofComponents
    (fun U =>
      { hom := AddCommGrpCat.ofHom
          (uTensorEquiv ↥(P.obj U) ↥(R.obj U)).toLinearMap.toAddMonoidHom
        inv := AddCommGrpCat.ofHom
          (uTensorEquiv ↥(P.obj U) ↥(R.obj U)).symm.toLinearMap.toAddMonoidHom
        hom_inv_id := by
          ext z
          exact (uTensorEquiv ↥(P.obj U) ↥(R.obj U)).symm_apply_apply z
        inv_hom_id := by
          ext z
          exact (uTensorEquiv ↥(P.obj U) ↥(R.obj U)).apply_symm_apply z })
    (fun {U V} g => by
      apply AddCommGrpCat.hom_ext
      ext z
      induction z using TensorProduct.induction_on with
      | zero => simp only [map_zero]
      | tmul m n => rfl
      | add a b ha hb => simp only [map_add, ha, hb])

/-- The abelian presheaf underlying `uModPresheaf P ⊗ (uModRingPresheaf X ⊗ uModPresheaf R)`
is the `ℤ`-tensor triple presheaf `relTensorTriplePresheaf P R` (componentwise
`uTripleEquiv`). -/
private noncomputable def uTripIso (P R : X.PresheafOfModules) :
    (MonoidalCategory.tensorObj (uModPresheaf P)
        (MonoidalCategory.tensorObj (uModRingPresheaf X) (uModPresheaf R))) ⋙ modToAb.{u} ≅
      relTensorTriplePresheaf P R :=
  NatIso.ofComponents
    (fun U =>
      { hom := AddCommGrpCat.ofHom
          (uTripleEquiv ↥(P.obj U) ↥(X.sheaf.obj.obj U) ↥(R.obj U)).toLinearMap.toAddMonoidHom
        inv := AddCommGrpCat.ofHom
          (uTripleEquiv ↥(P.obj U) ↥(X.sheaf.obj.obj U)
            ↥(R.obj U)).symm.toLinearMap.toAddMonoidHom
        hom_inv_id := by
          ext z
          exact (uTripleEquiv _ _ _).symm_apply_apply z
        inv_hom_id := by
          ext z
          exact (uTripleEquiv _ _ _).apply_symm_apply z })
    (fun {U V} g => by
      apply AddCommGrpCat.hom_ext
      ext z
      induction z using TensorProduct.induction_on with
      | zero => simp only [map_zero]
      | tmul m y =>
        induction y using TensorProduct.induction_on with
        | zero => simp only [TensorProduct.tmul_zero, map_zero]
        | tmul s n => rfl
        | add a b ha hb => simp only [TensorProduct.tmul_add, map_add, ha, hb]
      | add a b ha hb => simp only [map_add, ha, hb])

/-- The `ℤ`-tensor right-whiskering of `f` on the domain row, transported from the
pointwise whiskering `uModHom f ▷ uModPresheaf R` along the comparison isos. -/
private noncomputable def domWhisker {P Q : X.PresheafOfModules} (f : P ⟶ Q)
    (R : X.PresheafOfModules) :
    relTensorDomainPresheaf P R ⟶ relTensorDomainPresheaf Q R :=
  (uDomIso P R).inv ≫
    Functor.whiskerRight
      (MonoidalCategory.whiskerRight (uModHom f) (uModPresheaf R)) modToAb.{u} ≫
    (uDomIso Q R).hom

/-- The `ℤ`-tensor right-whiskering of `f` on the triple row, transported from the
pointwise whiskering `uModHom f ▷ (uModRingPresheaf X ⊗ uModPresheaf R)`. -/
private noncomputable def tripWhisker {P Q : X.PresheafOfModules} (f : P ⟶ Q)
    (R : X.PresheafOfModules) :
    relTensorTriplePresheaf P R ⟶ relTensorTriplePresheaf Q R :=
  (uTripIso P R).inv ≫
    Functor.whiskerRight
      (MonoidalCategory.whiskerRight (uModHom f)
        (MonoidalCategory.tensorObj (uModRingPresheaf X) (uModPresheaf R))) modToAb.{u} ≫
    (uTripIso Q R).hom

/-- `uModHom f` is a local isomorphism whenever the underlying abelian map of `f` is. -/
private lemma W_uModHom {P Q : X.PresheafOfModules} (f : P ⟶ Q)
    (hf : (opensTopology X).W ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map f)) :
    (opensTopology X).W (uModHom f) := by
  rw [← W_whiskerRight_modToAb_iff]
  refine (((opensTopology X).W).arrow_mk_iso_iff
    (Arrow.isoMk (uModForgetIso P) (uModForgetIso Q) ?_)).mpr hf
  ext U : 2
  apply AddCommGrpCat.hom_ext
  ext x
  rfl

/-- The whiskered domain row is a local isomorphism (`W.whiskerRight` over
`ModuleCat (ULift ℤ)`, transported). -/
private lemma W_domWhisker {P Q : X.PresheafOfModules} (f : P ⟶ Q)
    (hf : (opensTopology X).W ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map f))
    (R : X.PresheafOfModules) :
    (opensTopology X).W (domWhisker f R) := by
  have h1 : (opensTopology X).W
      (MonoidalCategory.whiskerRight (uModHom f) (uModPresheaf R)) :=
    (W_uModHom f hf).whiskerRight _
  have h2 := (W_whiskerRight_modToAb_iff (opensTopology X) _).mpr h1
  refine (((opensTopology X).W).arrow_mk_iso_iff
    (Arrow.isoMk (uDomIso P R) (uDomIso Q R) ?_)).mp h2
  simp [domWhisker]

/-- The whiskered triple row is a local isomorphism. -/
private lemma W_tripWhisker {P Q : X.PresheafOfModules} (f : P ⟶ Q)
    (hf : (opensTopology X).W ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map f))
    (R : X.PresheafOfModules) :
    (opensTopology X).W (tripWhisker f R) := by
  have h1 : (opensTopology X).W
      (MonoidalCategory.whiskerRight (uModHom f)
        (MonoidalCategory.tensorObj (uModRingPresheaf X) (uModPresheaf R))) :=
    (W_uModHom f hf).whiskerRight _
  have h2 := (W_whiskerRight_modToAb_iff (opensTopology X) _).mpr h1
  refine (((opensTopology X).W).arrow_mk_iso_iff
    (Arrow.isoMk (uTripIso P R) (uTripIso Q R) ?_)).mp h2
  simp [tripWhisker]

/-- The whiskered rows commute with the left-action transformation. -/
private lemma actL_domWhisker {P Q : X.PresheafOfModules} (f : P ⟶ Q)
    (R : X.PresheafOfModules) :
    relTensorActL P R ≫ domWhisker f R = tripWhisker f R ≫ relTensorActL Q R := by
  ext U : 2
  apply AddCommGrpCat.hom_ext
  ext z
  induction z using TensorProduct.induction_on with
  | zero => simp only [map_zero]
  | tmul m y =>
    induction y using TensorProduct.induction_on with
    | zero => simp only [TensorProduct.tmul_zero, map_zero]
    | tmul s n =>
      show (f.app U) (s • m) ⊗ₜ[ℤ] _ = (s • (f.app U) m) ⊗ₜ[ℤ] _
      congr 1
      exact map_smul (f.app U).hom s m
    | add a b ha hb => simp only [TensorProduct.tmul_add, map_add, ha, hb]
  | add a b ha hb => simp only [map_add, ha, hb]

/-- The whiskered rows commute with the right-action transformation. -/
private lemma actR_domWhisker {P Q : X.PresheafOfModules} (f : P ⟶ Q)
    (R : X.PresheafOfModules) :
    relTensorActR P R ≫ domWhisker f R = tripWhisker f R ≫ relTensorActR Q R := by
  ext U : 2
  apply AddCommGrpCat.hom_ext
  ext z
  induction z using TensorProduct.induction_on with
  | zero => simp only [map_zero]
  | tmul m y =>
    induction y using TensorProduct.induction_on with
    | zero => simp only [TensorProduct.tmul_zero, map_zero]
    | tmul s n => rfl
    | add a b ha hb => simp only [TensorProduct.tmul_add, map_add, ha, hb]
  | add a b ha hb => simp only [map_add, ha, hb]

/-- The whiskered domain row covers the relative-tensor whiskering through the
coequalizer projections. -/
private lemma proj_domWhisker {P Q : X.PresheafOfModules} (f : P ⟶ Q)
    (R : X.PresheafOfModules) :
    domWhisker f R ≫ relTensorProj Q R =
      relTensorProj P R ≫ (PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map
        (MonoidalCategory.whiskerRight (C := MonoidalPresheaf X) f R) := by
  ext U : 2
  apply AddCommGrpCat.hom_ext
  ext z
  induction z using TensorProduct.induction_on with
  | zero => simp only [map_zero]
  | tmul m n => rfl
  | add a b ha hb => simp only [map_add, ha, hb]

end ZTensorWhisker

/-- **A ℤ-whiskered stalkwise isomorphism is a local isomorphism** (`lem:snap_ztensor_whisker_localIso`).
Let `f : P ⟶ Q` be a morphism of presheaves of `𝒪_X`-modules such that the underlying
abelian-presheaf morphism `(toPresheaf _).map f` lies in the weak-equivalence class `J.W`
of the opens topology on `X` (i.e., `f` is a stalkwise isomorphism of abelian-group
presheaves). Then for any presheaf of modules `R`, the underlying abelian morphism of the
right-whiskered map `f ▷ R : P ⊗_p R ⟶ Q ⊗_p R` (in the presheaf monoidal structure
`PresheafOfModules.monoidalCategory`) is again a stalkwise isomorphism, hence lies in `J.W`.

Proof strategy: the stalk functor at a point `x` is a filtered colimit over neighbourhoods
of `x`, and `⊗_ℤ` commutes with filtered colimits, so `(A ⊗_ℤ C)_x ≅ A_x ⊗_ℤ C_x`
naturally in `A`. The stalk of the whiskered map at `x` is `f_x ⊗_ℤ id`, which is an
isomorphism because `f_x` is. A stalkwise isomorphism of abelian-group presheaves on a
topological space lies in `J.W` (`GrothendieckTopology.W_toSheafify`). -/
lemma ztensor_whisker_localIso {P Q : X.PresheafOfModules}
    (f : P ⟶ Q)
    (hf : (opensTopology X).W ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map f))
    (R : X.PresheafOfModules) :
    (opensTopology X).W
      ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map
        (MonoidalCategory.whiskerRight (C := MonoidalPresheaf X) f R)) := by
  -- Apply the abelian sheafification functor `a` to the coequalizer presentations of
  -- `P ⊗_p R` and `Q ⊗_p R` (`relativeTensorCoequalizerIso`); the whiskered rows
  -- `tripWhisker`/`domWhisker` become isomorphisms (they lie in `J.W`), so the induced
  -- map of coequalizer points — which is `a.map` of our morphism — is an isomorphism.
  have hWdom : (opensTopology X).W (domWhisker f R) := W_domWhisker f hf R
  have hWtrip : (opensTopology X).W (tripWhisker f R) := W_tripWhisker f hf R
  rw [GrothendieckTopology.W_iff]
  set a := presheafToSheaf (opensTopology X) Ab.{u} with ha
  have hcP := Limits.isColimitOfPreserves a (relativeTensorCoequalizerIso P R)
  have hcQ := Limits.isColimitOfPreserves a (relativeTensorCoequalizerIso Q R)
  -- the morphism of parallel pairs given by the whiskered rows
  let β : Limits.parallelPair (relTensorActL P R) (relTensorActR P R) ⟶
      Limits.parallelPair (relTensorActL Q R) (relTensorActR Q R) :=
    Limits.parallelPairHom (relTensorActL P R) (relTensorActR P R)
      (relTensorActL Q R) (relTensorActR Q R) (tripWhisker f R) (domWhisker f R)
      (actL_domWhisker f R) (actR_domWhisker f R)
  have hβ : ∀ j, IsIso ((Functor.whiskerRight β a).app j) := by
    rintro (_ | _)
    · show IsIso (a.map (β.app Limits.WalkingParallelPair.zero))
      rw [show β.app Limits.WalkingParallelPair.zero = tripWhisker f R from
        Limits.parallelPairHom_app_zero ..]
      exact ((opensTopology X).W_iff _).mp hWtrip
    · show IsIso (a.map (β.app Limits.WalkingParallelPair.one))
      rw [show β.app Limits.WalkingParallelPair.one = domWhisker f R from
        Limits.parallelPairHom_app_one ..]
      exact ((opensTopology X).W_iff _).mp hWdom
  haveI : IsIso (Functor.whiskerRight β a) :=
    NatIso.isIso_of_isIso_app _
  -- the induced map of cocone points is `a.map` of our morphism …
  have hmap : hcP.map
      (a.mapCocone (Limits.Cofork.ofπ (relTensorProj Q R) (relTensorActL_proj_eq Q R)))
      (Functor.whiskerRight β a)
      = a.map ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map
          (MonoidalCategory.whiskerRight (C := MonoidalPresheaf X) f R)) := by
    apply hcP.hom_ext
    intro j
    rw [Limits.IsColimit.ι_map]
    have hone :
        (Functor.whiskerRight β a).app Limits.WalkingParallelPair.one ≫
          (a.mapCocone (Limits.Cofork.ofπ (relTensorProj Q R)
            (relTensorActL_proj_eq Q R))).ι.app Limits.WalkingParallelPair.one
        = (a.mapCocone (Limits.Cofork.ofπ (relTensorProj P R)
            (relTensorActL_proj_eq P R))).ι.app Limits.WalkingParallelPair.one ≫
          a.map ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map
            (MonoidalCategory.whiskerRight (C := MonoidalPresheaf X) f R)) := by
      show a.map (β.app Limits.WalkingParallelPair.one) ≫ a.map (relTensorProj Q R)
        = a.map (relTensorProj P R) ≫ a.map _
      rw [show β.app Limits.WalkingParallelPair.one = domWhisker f R from
        Limits.parallelPairHom_app_one .., ← Functor.map_comp, ← Functor.map_comp,
        proj_domWhisker]
    match j with
    | Limits.WalkingParallelPair.one => exact hone
    | Limits.WalkingParallelPair.zero =>
      have wP := (a.mapCocone (Limits.Cofork.ofπ (relTensorProj P R)
        (relTensorActL_proj_eq P R))).w Limits.WalkingParallelPairHom.left
      have wQ := (a.mapCocone (Limits.Cofork.ofπ (relTensorProj Q R)
        (relTensorActL_proj_eq Q R))).w Limits.WalkingParallelPairHom.left
      rw [← wP, ← wQ, CategoryTheory.Category.assoc, CategoryTheory.Category.assoc, hone,
        ← CategoryTheory.Category.assoc, ← CategoryTheory.Category.assoc]
      congr 1
      exact ((Functor.whiskerRight β a).naturality
        Limits.WalkingParallelPairHom.left).symm
  rw [← hmap,
    show hcP.map
      (a.mapCocone (Limits.Cofork.ofπ (relTensorProj Q R) (relTensorActL_proj_eq Q R)))
      (Functor.whiskerRight β a)
      = (Limits.IsColimit.coconePointsIsoOfNatIso hcP hcQ
          (asIso (Functor.whiskerRight β a))).hom by simp]
  infer_instance

/- Planner strategy: 4-step proof (blueprint `lem:isIso_sheafification_whiskerRight_unit`):

Step 1 (LOCALIZATION CRITERION). Apply `isIso_sheafification_map_iff` to reduce the goal
    `IsIso (sheafification.map (η_P ▷ Q))`
to the purely abelian statement
    `(opensTopology X).W ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map (η_P ▷ Q))`.

Step 2 (COEQUALIZER PRESENTATION). The underlying abelian-group presheaf of `P ⊗_p Q` is
the coequalizer of `relTensorActL P Q` / `relTensorActR P Q` with cofork leg `relTensorProj P Q`
in `(Opens X)ᵒᵖ ⥤ Ab`. This is `relativeTensorCoequalizerIso P Q` (the `IsColimit` of the
cofork), axiom-clean in-file. Abelian sheafification (`presheafToSheaf J Ab`) is a left adjoint
and therefore preserves this coequalizer.

Step 3 (WHISKERED UNITS IN J.W). The morphism `(toPresheaf _).map (η_P ▷ Q)` is the coequalizer
map induced by the ℤ-whiskerings `η_{P,ab} ⊗_ℤ id_Q` and `η_{P,ab} ⊗_ℤ id_{R₀ ⊗_ℤ Q}` on both
rows of the parallel pair (by the objectwise formula `PresheafOfModules.Monoidal.tensorObj_obj`).
By `localIso_toPresheaf_map_unit`, the underlying abelian map `η_{P,ab}` lies in `J.W`. Apply
`ztensor_whisker_localIso` to each row to conclude both whiskered maps lie in `J.W`. A morphism
of parallel pairs lying in `J.W` induces a `J.W`-morphism on coequalizers (sheafification
preserves coequalizers and turns them into isomorphisms).

Step 4 (CLOSING). Fed back through `(isIso_sheafification_map_iff _).mpr`, this closes the
original `IsIso` goal.

KEY MATHLIB REFERENCES (verified by planner):
- `CategoryTheory.Limits.evaluationJointlyReflectsColimits` EXISTS at
  `Mathlib/CategoryTheory/Limits/FunctorCategory/Basic.lean:103`; fallback
  `combinedIsColimit` same file L145.
- `relativeTensorCoequalizerIso` and the full `RelativeTensorCoequalizer` 22-decl API
  are DONE axiom-clean in-file (closed iter-053).
- The abelian-group category in this file is `AddCommGrpCat`, NOT `AddCommGrp`. Any fresh
  `have` about `P ⊗ Q` must spell
  `MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q`.
- `ztensor_whisker_localIso` (the declaration immediately above) closes the stalkwise-iso
  ingredient for each whiskered row.
-/
/-- **Sheafification inverts the whiskered localization unit** (`lem:isIso_sheafification_whiskerRight_unit`).
For presheaves of `𝒪_X`-modules `P` and `Q`, let `η_P : P ⟶ P^#` be the unit of the
sheafification adjunction (here `P^# = (toPresheafOfModules X).obj (sheafification.obj P)`).
The sheafification of the right-whiskered map `η_P ▷ Q : P ⊗_p Q ⟶ P^# ⊗_p Q` (in the
presheaf monoidal structure), namely
  `(η_P ▷ Q)^# : (P ⊗_p Q)^# ⟶ (P^# ⊗_p Q)^#`,
is an isomorphism of sheaves of modules. This is the strong-monoidality comparison of the
module sheafification functor on a whiskered unit; it is the key brick for the sheaf-level
associator (`cor:sheafTensorObjAssoc`) and the `tensorPowAdd` comparison. -/
lemma isIso_sheafification_whiskerRight_unit (P Q : X.PresheafOfModules) :
    IsIso (sheafification.map
      (MonoidalCategory.whiskerRight (C := MonoidalPresheaf X)
        ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app P) Q)) :=
  (isIso_sheafification_map_iff _).mpr
    (ztensor_whisker_localIso _ (localIso_toPresheaf_map_unit P) Q)

end AlgebraicGeometry.Scheme.Modules
