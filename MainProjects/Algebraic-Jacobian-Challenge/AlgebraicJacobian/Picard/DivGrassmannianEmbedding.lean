/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivPushforwardFlat
import AlgebraicJacobian.Picard.GrassmannianRepresentability
import AlgebraicJacobian.Picard.RigidPushforwardP1Sheaf

/-!
# The divisor-to-Grassmannian comparison

This file begins campaign milestone D2': a divisor family is twisted by a fixed
module on the curve, and the pullback--pushforward base-change map followed by
the divisor quotient gives the canonical evaluation morphism used by the
Grassmannian construction.

The definitions in the first section are unconditional.  In particular,
`DivFamily.grassmannianEval` exists before the Riemann--Roch argument proves it
epimorphic.  Keeping the map separate from its eventual `Epi` proof prevents
uniform generation from becoming an assumption in the definition of the
comparison.

The second section records two affine algebra bridges used to turn finite flat
pushforwards into the rank-indexed local-freeness predicate expected by
`Scheme.LocallyFreeQuotient`.  They do not introduce a representability gate:
their inputs are ordinary finite-presentation, finiteness, and projectivity
properties with producers elsewhere in the Picard development.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

namespace AlgebraicGeometry

namespace Scheme

namespace DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}

private lemma map_tensorHom_comp2 {C D : Type*} [Category C] [MonoidalCategory C]
    [Category D] (F : C ⥤ D) {a₀ a₁ a₂ b₀ b₁ b₂ : C}
    (a : a₀ ⟶ a₁) (b : a₁ ⟶ a₂) (d : b₀ ⟶ b₁) (e : b₁ ⟶ b₂) :
    F.map (MonoidalCategory.tensorHom a d) ≫ F.map (MonoidalCategory.tensorHom b e) =
      F.map (MonoidalCategory.tensorHom (a ≫ b) (d ≫ e)) := by
  rw [← F.map_comp, MonoidalCategory.tensorHom_comp_tensorHom]

/-- The twist of the divisor structure sheaf by a module on the original
family.  For the D2' embedding, `L` is the chosen sufficiently positive
projective twist. -/
noncomputable def twist (L : X.Modules) (x : DivFamily π T) :
    (pullback π T.hom).Modules :=
  Modules.tensorObj ((Modules.pullback (pullback.fst π T.hom)).obj L) x.F

/-- Tensor the divisor quotient `O -> O_D` with the pulled-back twist. -/
noncomputable def twistQuotientMap (L : X.Modules) (x : DivFamily π T) :
    (Modules.pullback (pullback.fst π T.hom)).obj L ⟶ x.twist L :=
  (Modules.tensorObj_right_unitor _).inv ≫
    Modules.tensorObj_functoriality (𝟙 _)
      ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q)

/-- Equivalent divisor families have isomorphic twists, compatibly with the
twisted quotient maps.  This is the representative-level descent input for
the D2' Grassmannian comparison. -/
lemma twistQuotientMap_rel (L : X.Modules) {x y : DivFamily π T} (h : x.Rel y) :
    ∃ f : x.twist L ≅ y.twist L,
      x.twistQuotientMap L ≫ f.hom = y.twistQuotientMap L := by
  obtain ⟨f, hf⟩ := h
  refine ⟨Modules.tensorObjIsoOfIso (Iso.refl _) f, ?_⟩
  change ((Modules.tensorObj_right_unitor _).inv ≫
      Modules.tensorObj_functoriality (𝟙 _)
        ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q)) ≫
      Modules.tensorObj_functoriality (𝟙 _) f.hom =
    (Modules.tensorObj_right_unitor _).inv ≫
      Modules.tensorObj_functoriality (𝟙 _)
        ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ y.q)
  rw [Category.assoc]
  rw [show Modules.tensorObj_functoriality (𝟙 _) _ ≫
        Modules.tensorObj_functoriality (𝟙 _) f.hom =
      Modules.tensorObj_functoriality ((𝟙 _) ≫ (𝟙 _))
        (((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q) ≫ f.hom) by
    simp only [Modules.tensorObj_functoriality]
    exact map_tensorHom_comp2
      (C := _root_.PresheafOfModules
        ((pullback π T.hom).presheaf ⋙ forget₂ CommRingCat RingCat))
      _ _ _ _ _]
  simp only [Category.id_comp]
  rw [Category.assoc, hf]

/-- The canonical D2' evaluation morphism.

It first base-changes `π_* L` from `S` to `T`, then pushes forward the twisted
divisor quotient along `X_T -> T`.  Uniform Riemann--Roch will prove that this
map is an epimorphism for a sufficiently positive `L`; no such conclusion is
built into the definition. -/
noncomputable def grassmannianEval (L : X.Modules) (x : DivFamily π T) :
    (Modules.pullback T.hom).obj ((Modules.pushforward π).obj L) ⟶
      (Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L) :=
  pushforwardBaseChangeMap π T.hom (pullback.snd π T.hom)
      (pullback.fst π T.hom) pullback.condition L ≫
    (Modules.pushforward (pullback.snd π T.hom)).map (x.twistQuotientMap L)

/-- Equivalent divisor families have isomorphic evaluation targets, and the
isomorphism commutes with the D2' evaluation maps. -/
lemma grassmannianEval_rel (L : X.Modules) {x y : DivFamily π T} (h : x.Rel y) :
    ∃ f : (Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L) ≅
        (Modules.pushforward (pullback.snd π T.hom)).obj (y.twist L),
      x.grassmannianEval L ≫ f.hom = y.grassmannianEval L := by
  obtain ⟨f, hf⟩ := twistQuotientMap_rel L h
  refine ⟨(Modules.pushforward (pullback.snd π T.hom)).mapIso f, ?_⟩
  change (pushforwardBaseChangeMap π T.hom (pullback.snd π T.hom)
      (pullback.fst π T.hom) pullback.condition L ≫
        (Modules.pushforward (pullback.snd π T.hom)).map (x.twistQuotientMap L)) ≫
      (Modules.pushforward (pullback.snd π T.hom)).map f.hom =
    pushforwardBaseChangeMap π T.hom (pullback.snd π T.hom)
      (pullback.fst π T.hom) pullback.condition L ≫
        (Modules.pushforward (pullback.snd π T.hom)).map (y.twistQuotientMap L)
  rw [Category.assoc, ← Functor.map_comp, hf]

/-- Epimorphy of the D2' evaluation map is invariant under
`DivFamily.Rel`. -/
lemma grassmannianEval_epi_of_rel (L : X.Modules) {x y : DivFamily π T}
    (h : x.Rel y) (hx : Epi (x.grassmannianEval L)) :
    Epi (y.grassmannianEval L) := by
  obtain ⟨f, hf⟩ := grassmannianEval_rel L h
  letI := hx
  rw [← hf]
  infer_instance

/-- The rank-local-freeness obligation on the D2' evaluation target is
invariant under `DivFamily.Rel`. -/
lemma grassmannianTarget_isLocallyFreeOfRank_of_rel
    (L : X.Modules) {x y : DivFamily π T} (hxy : x.Rel y) {d : ℕ}
    (hx : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (y.twist L)) d := by
  obtain ⟨f, _⟩ := grassmannianEval_rel L hxy
  obtain ⟨ι, U, hU, hloc⟩ := hx
  exact ⟨ι, U, hU, fun i =>
    ⟨(Modules.pullback (U i).ι).mapIso f.symm ≪≫ (hloc i).some⟩⟩

/-- The evaluation map is epi as soon as its two displayed factors are epi.
This keeps the base-change and divisor-quotient obligations separate, so a
later uniform-generation proof can discharge only the factor it actually
proves. -/
theorem grassmannianEval_epi (L : X.Modules) (x : DivFamily π T)
    (hbase : Epi (pushforwardBaseChangeMap π T.hom
      (pullback.snd π T.hom) (pullback.fst π T.hom) pullback.condition L))
    (hquot : Epi ((Modules.pushforward (pullback.snd π T.hom)).map
      (x.twistQuotientMap L))) :
    Epi (x.grassmannianEval L) := by
  letI := hbase
  letI := hquot
  dsimp [grassmannianEval]
  infer_instance

/-- **The conditional D2' quotient datum.**  Once the evaluation map is an
epimorphism and its target has constant locally-free rank `d`, it is exactly a
rank-`d` locally free quotient of the pulled-back pushforward of `L`.

The two arguments are deliberately explicit: the evaluation map is the
uniform-generation obligation, while the locally-free target is the
finite/projective/rank obligation.  This constructor packages those genuine
outputs without introducing a class or an instance that could hide either one.
-/
noncomputable def grassmannianQuotient (L : X.Modules) (x : DivFamily π T)
    [IsLocallyNoetherian S] {d : ℕ} (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    LocallyFreeQuotient ((Modules.pushforward π).obj L) d T := by
  letI := hEpi
  exact {
    F := (Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)
    q := x.grassmannianEval L
    epi := inferInstance
    locFree := hLocFree }

/-- The conditional D2' quotient datum respects the divisor-family
equivalence relation.  The epi and rank witnesses on the second representative
are transported from the first, rather than assumed again. -/
lemma grassmannianQuotient_rel
    (L : X.Modules) {x y : DivFamily π T} [IsLocallyNoetherian S] {d : ℕ}
    (hxy : x.Rel y) (hxEpi : Epi (x.grassmannianEval L))
    (hxLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    (grassmannianQuotient L x hxEpi hxLocFree).Rel
      (grassmannianQuotient L y
        (grassmannianEval_epi_of_rel L hxy hxEpi)
        (grassmannianTarget_isLocallyFreeOfRank_of_rel L hxy hxLocFree)) := by
  obtain ⟨f, hf⟩ := grassmannianEval_rel L hxy
  exact ⟨f, hf⟩

/-- The quotient-class value of the D2' comparison in the relative
Grassmannian functor.  This is the representation-facing object consumed by
the Grassmannian representability theorem; well-definedness under
`DivFamily.Rel` is a separate comparison lemma. -/
noncomputable def grassmannianClass (L : X.Modules) (x : DivFamily π T)
    [IsLocallyNoetherian S] {d : ℕ} (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    (Grassmannian ((Modules.pushforward π).obj L) d).obj (Opposite.op T) :=
  Quotient.mk _ (grassmannianQuotient L x hEpi hLocFree)

/-- The D2' Grassmannian class is well-defined on `DivFamily.Rel`.  Both
analytic obligations are transported along the relation witness, so this
descent theorem introduces no additional hypotheses. -/
theorem grassmannianClass_eq_of_rel
    (L : X.Modules) {x y : DivFamily π T} [IsLocallyNoetherian S] {d : ℕ}
    (hxy : x.Rel y) (hxEpi : Epi (x.grassmannianEval L))
    (hxLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    grassmannianClass L x hxEpi hxLocFree =
      grassmannianClass L y
        (grassmannianEval_epi_of_rel L hxy hxEpi)
        (grassmannianTarget_isLocallyFreeOfRank_of_rel L hxy hxLocFree) :=
  Quotient.sound (grassmannianQuotient_rel L hxy hxEpi hxLocFree)

/-- The componentwise form of `grassmannianClass`: once the base-change and
divisor-quotient factors are epi, only the target's rank condition remains. -/
noncomputable def grassmannianClassOfComponents (L : X.Modules) (x : DivFamily π T)
    [IsLocallyNoetherian S] {d : ℕ}
    (hbase : Epi (pushforwardBaseChangeMap π T.hom
      (pullback.snd π T.hom) (pullback.fst π T.hom) pullback.condition L))
    (hquot : Epi ((Modules.pushforward (pullback.snd π T.hom)).map
      (x.twistQuotientMap L)))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    (Grassmannian ((Modules.pushforward π).obj L) d).obj (Opposite.op T) :=
  grassmannianClass L x (grassmannianEval_epi L x hbase hquot) hLocFree

end DivFamily

namespace Modules

set_option backward.isDefEq.respectTransparency false in
/-- A finite global presentation of a module sheaf on `Spec R` induces a
finite presentation of its module of global sections.

The proof reconstructs the finite module cokernel underlying the sheaf
presentation.  Full faithfulness of `tilde` identifies that cokernel with the
global-section module, without any noetherian hypothesis on `R`. -/
theorem module_finitePresentation_top_of_presentation
    {R : CommRingCat.{u}} (M : (Spec R).Modules) (P : M.Presentation)
    [P.IsFinite] :
    Module.FinitePresentation R Γ(M, (⊤ : (Spec R).Opens)) := by
  let g := (tilde.functor R).preimage <|
    (tildeFinsupp _).hom ≫ P.relations.π ≫ kernel.ι _ ≫ (tildeFinsupp _).inv
  let Q := (P.generators.I →₀ R) ⧸ LinearMap.range g.hom
  have hQ : Module.FinitePresentation R Q := by
    apply Module.finitePresentation_of_surjective
      (Submodule.mkQ (LinearMap.range g.hom)) (Submodule.mkQ_surjective _)
    rw [Submodule.ker_mkQ]
    simpa only [LinearMap.range_eq_map] using Module.Finite.fg_top.map g.hom
  let iso : cokernel ((tilde.functor R).map g) ≅
      cokernel (P.relations.π ≫ kernel.ι _) := by
    refine cokernel.mapIso _ _ (tildeFinsupp _) (tildeFinsupp _) ?_
    simp only [g, (tilde.functor R).map_preimage]
    simp
  let eC : tilde (cokernel g) ≅ M :=
    PreservesCokernel.iso (tilde.functor R) g ≪≫ iso ≪≫
      IsColimit.coconePointUniqueUpToIso (colimit.isColimit _) P.isColimit
  let eQ : tilde (ModuleCat.of R Q) ≅ M :=
    (tilde.functor R).mapIso (ModuleCat.cokernelIsoRangeQuotient g).symm ≪≫ eC
  haveI : IsIso M.fromTildeΓ := isIso_fromTildeΓ_of_presentation M P
  let eΓ : ModuleCat.of R Q ≅ moduleSpecΓFunctor.obj M :=
    (tilde.functor R).preimageIso (eQ ≪≫ qcoh_iso_tilde_sections M)
  exact eΓ.toLinearEquiv.finitePresentation_iff.mp hQ

/-- On an affine scheme, finite projective global sections of constant stalk
rank produce the project-local rank-indexed freeness predicate used by the
Grassmannian functor. -/
theorem isLocallyFreeOfRank_of_finite_projective_sections
    {R : CommRingCat.{u}} (M : (Spec R).Modules) [M.IsQuasicoherent]
    (hfin : Module.Finite R Γ(M, (⊤ : (Spec R).Opens)))
    (hproj : Module.Projective R Γ(M, (⊤ : (Spec R).Opens)))
    {d : ℕ} (hrank : ∀ t : PrimeSpectrum R, sectionsRankAtStalk M t = d) :
    SheafOfModules.IsLocallyFreeOfRank M d := by
  choose U htU hfree using fun t =>
    exists_free_restrict_of_finite_projective_sections' M hfin hproj t
  refine ⟨PrimeSpectrum R, U, ?_, fun t => ?_⟩
  · rw [eq_top_iff]
    intro t _
    exact TopologicalSpace.Opens.mem_iSup.mpr ⟨t, htU t⟩
  · exact (hrank t) ▸ hfree t

end Modules

end Scheme

end AlgebraicGeometry
