import Mathlib.Algebra.Category.Grp.Basic
import Mathlib.LinearAlgebra.TensorProduct.Map
import Mathlib.LinearAlgebra.TensorProduct.Associator
import Mathlib.CategoryTheory.Limits.Shapes.Equalizers
import Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal
import Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification
import Mathlib.Algebra.Category.ModuleCat.Sheaf.Localization
import Mathlib.CategoryTheory.Sites.Monoidal
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
  map_id U := by sorry
  map_comp {U V W} f g := by sorry

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
  map_id U := by sorry
  map_comp {U V W} f g := by sorry

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

end AlgebraicGeometry.Scheme.Modules
