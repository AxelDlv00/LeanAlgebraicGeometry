/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivPushforwardFlat
import AlgebraicJacobian.Picard.CurveProjectivity
import AlgebraicJacobian.Picard.GrassmannianRepresentability
import AlgebraicJacobian.Picard.RigidPushforwardP1Sheaf
import AlgebraicJacobian.Picard.RigidPushforwardRank
import AlgebraicJacobian.Picard.SerreTwistSections
import AlgebraicJacobian.Picard.TwoTermFiniteFree
import AlgebraicJacobian.Cohomology.QcohTildeSections
import AlgebraicJacobian.RiemannRoch.Ledger.FixedFiberDegree
import AlgebraicJacobian.RiemannRoch.Ledger.UniformRiemannRoch

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

/-- **Tensoring on the right preserves epimorphisms in `Scheme.Modules`.**

An epimorphism of module sheaves is locally surjective after forgetting to
abelian-group sheaves.  The presheaf tensor preserves local surjectivity in
either variable by right-exactness of tensor products, and sheafification
turns that local surjectivity back into an epimorphism.  This avoids the false
intermediate claim that a sheaf epimorphism is pointwise epi as a presheaf. -/
theorem tensorObj_functoriality_epi_right
    {X : Scheme.{u}} {M N N' : X.Modules} (g : N ⟶ N') [hg : Epi g] :
    Epi (tensorObj_functoriality (𝟙 M) g) := by
  let J := Opens.grothendieckTopology X
  letI : (SheafOfModules.toSheaf X.ringCatSheaf).PreservesEpimorphisms :=
    AlgebraicGeometry.toSheaf_preservesEpimorphisms X.ringCatSheaf
  have hgSheaf : Epi ((SheafOfModules.toSheaf X.ringCatSheaf).map g) :=
    @Functor.map_epi _ _ _ _ (SheafOfModules.toSheaf X.ringCatSheaf) _ _ _ g hg
  have hgLoc : PresheafOfModules.IsLocallySurjective J g.val := by
    exact (Sheaf.isLocallySurjective_iff_epi'
      AddCommGrpCat ((SheafOfModules.toSheaf X.ringCatSheaf).map g)).mpr hgSheaf
  let M' : _root_.PresheafOfModules
      (X.presheaf ⋙ forget₂ CommRingCat RingCat) := M.val
  let g' : MonoidalCategory.tensorObj M' N.val ⟶
      MonoidalCategory.tensorObj M' N'.val := M' ◁ g.val
  have htLoc : PresheafOfModules.IsLocallySurjective J g' :=
    PresheafOfModules.isLocallySurjective_whiskerLeft M' g.val hgLoc
  have htSheafLoc : Sheaf.IsLocallySurjective
      ((presheafToSheaf J AddCommGrpCat).map
        ((PresheafOfModules.toPresheaf
          (X.presheaf ⋙ forget₂ CommRingCat RingCat)).map g')) := by
    rw [Presheaf.isLocallySurjective_presheafToSheaf_map_iff]
    exact htLoc
  have htSheafEpi : Epi
      ((presheafToSheaf J AddCommGrpCat).map
        ((PresheafOfModules.toPresheaf
          (X.presheaf ⋙ forget₂ CommRingCat RingCat)).map g')) :=
    (Sheaf.isLocallySurjective_iff_epi' AddCommGrpCat.{u} _).mp htSheafLoc
  have hmap : Epi ((SheafOfModules.toSheaf X.ringCatSheaf).map
      (tensorObj_functoriality (𝟙 M) g)) := by
    change Epi ((presheafToSheaf J AddCommGrpCat).map
      ((PresheafOfModules.toPresheaf
        (X.presheaf ⋙ forget₂ CommRingCat RingCat)).map g'))
    exact htSheafEpi
  exact (SheafOfModules.toSheaf X.ringCatSheaf).epi_of_epi_map hmap

/-- On an affine scheme, surjectivity on global sections reflects to an
epimorphism between quasi-coherent module sheaves.

The affine tilde--Gamma counits identify the sheaves with the tildes of their
global-section modules.  Naturality of the counit then transports the module
epimorphism back to the original sheaf morphism. -/
theorem epi_of_globalSections_surjective
    {R : CommRingCat.{u}} {M N : (Spec R).Modules}
    [M.IsQuasicoherent] [N.IsQuasicoherent]
    (q : M ⟶ N)
    (hq : Function.Surjective
      ((moduleSpecΓFunctor (R := R)).map q).hom) :
    Epi q := by
  have hM : IsIso M.fromTildeΓ := isIso_fromTildeΓ_of_quasicoherent M
  have hN : IsIso N.fromTildeΓ := isIso_fromTildeΓ_of_quasicoherent N
  haveI hqΓ : Epi ((moduleSpecΓFunctor (R := R)).map q) := by
    rw [ModuleCat.epi_iff_surjective]
    exact hq
  haveI hqtilde : Epi
      ((tilde.functor R).map ((moduleSpecΓFunctor (R := R)).map q)) := by
    infer_instance
  haveI : IsIso M.fromTildeΓ := hM
  haveI : IsIso N.fromTildeΓ := hN
  have key : M.fromTildeΓ ≫ q =
      (tilde.functor R).map ((moduleSpecΓFunctor (R := R)).map q) ≫
        N.fromTildeΓ :=
    ((fromTildeΓNatTrans (R := R)).naturality q).symm
  rw [← epi_comp_iff_of_epi M.fromTildeΓ]
  rw [key]
  exact epi_comp' hqtilde
    (@IsIso.epi_of_iso _ _ _ _ N.fromTildeΓ hN)

/-- **Affine fibrewise-surjectivity criterion.**  A morphism of quasi-coherent
modules on `Spec R` is epi when its global-section cokernel is finite and the
global-section map becomes surjective after base change to every maximal
residue field.

This is the Nakayama globalization needed by the D2 evaluation map: it turns
fieldwise generation into an epimorphism over an arbitrary affine test base,
without a noetherian, representability, or rational-point hypothesis. -/
theorem epi_of_baseChange_surjective
    {R : CommRingCat.{u}} {M N : (Spec R).Modules}
    [M.IsQuasicoherent] [N.IsQuasicoherent]
    (q : M ⟶ N)
    [Module.Finite R
      ((moduleSpecΓFunctor (R := R)).obj N ⧸
        LinearMap.range ((moduleSpecΓFunctor (R := R)).map q).hom)]
    (hfib : ∀ (m : Ideal R), m.IsMaximal →
      Function.Surjective
        (((moduleSpecΓFunctor (R := R)).map q).hom.baseChange (R ⧸ m))) :
    Epi q := by
  apply epi_of_globalSections_surjective q
  exact AlgebraicJacobian.TwoTerm.surjective_of_baseChange_quotient_surjective hfib

/-- Finite global sections of the target automatically supply the finite
cokernel in `epi_of_baseChange_surjective`. -/
theorem epi_of_baseChange_surjective_of_finite
    {R : CommRingCat.{u}} {M N : (Spec R).Modules}
    [M.IsQuasicoherent] [N.IsQuasicoherent]
    (q : M ⟶ N)
    [Module.Finite R ((moduleSpecΓFunctor (R := R)).obj N)]
    (hfib : ∀ (m : Ideal R), m.IsMaximal →
      Function.Surjective
        (((moduleSpecΓFunctor (R := R)).map q).hom.baseChange (R ⧸ m))) :
    Epi q := by
  apply epi_of_baseChange_surjective q
  exact hfib

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

set_option maxHeartbeats 1600000 in
-- Support descent expands two affine base-change transports; the default budget
-- times out before the affine-instance reduction finishes.
set_option synthInstance.maxHeartbeats 400000 in
/-- **Finite-support base change.**  A quasi-coherent module whose schematic
support is finite over the base has the expected arbitrary base-change
isomorphism.  The support descent presentation turns the statement into the
affine base-change theorem twice: once for the finite support map and once for
its closed immersion into the ambient scheme.  No flatness of the base change
is used. -/
noncomputable def pullbackPushforwardIso_of_isFinite_schematicSupport
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g) (F : X.Modules) [F.IsQuasicoherent]
    (hfin : IsFinite (schematicSupportι F ≫ f)) :
    (pullback g).obj ((pushforward f).obj F) ≅
      (pushforward f').obj ((pullback g').obj F) := by
  let i := schematicSupportι F
  let N := (pullback i).obj F
  haveI : IsAffineHom i :=
    inferInstanceAs (IsAffineHom F.annihilator.subschemeι)
  haveI : IsFinite (i ≫ f) := hfin
  haveI : IsAffineHom (i ≫ f) := inferInstance
  have sq₁ : IsPullback (Limits.pullback.fst i g') (Limits.pullback.snd i g') i g' :=
    IsPullback.of_hasPullback _ _
  have sqZ : IsPullback (Limits.pullback.fst i g')
      (Limits.pullback.snd i g' ≫ f') (i ≫ f) g :=
    sq₁.paste_vert sq
  haveI : IsAffineHom (Limits.pullback.snd i g') :=
    MorphismProperty.pullback_snd _ _ (inferInstance : IsAffineHom i)
  haveI : IsAffineHom (Limits.pullback.snd i g' ≫ f') :=
    MorphismProperty.of_isPullback sqZ inferInstance
  haveI : N.IsQuasicoherent := pullback_isQuasicoherent_hom i F inferInstance
  let hdesc : F ≅ (pushforward i).obj N := schematicSupportDescentIso F
  let eSupport := AlgebraicGeometry.pushforwardPullbackBaseChangeIso sqZ N
  let eImmersion := AlgebraicGeometry.pushforwardPullbackBaseChangeIso sq₁ N
  exact (pullback g).mapIso
      ((pushforward f).mapIso hdesc ≪≫
        ((pushforwardComp i f).app N).symm) ≪≫
    eSupport ≪≫
    (pushforwardComp (Limits.pullback.snd i g') f').app _ ≪≫
    (pushforward f').mapIso
      (eImmersion.symm ≪≫ (pullback g').mapIso hdesc.symm)

set_option backward.isDefEq.respectTransparency false in
/-- The fibre of affine global sections computes fibre `H⁰` once pushforward
commutes with the residue-field base change. -/
theorem fiberRank_gammaTop_eq_fiberH0_of_iso
    {R : CommRingCat.{u}} {X : Scheme.{u}} (f : X ⟶ Spec R)
    (F : X.Modules) [F.IsQuasicoherent] [QuasiCompact f] [QuasiSeparated f]
    (t : PrimeSpectrum R)
    (e : (Scheme.Modules.pullback
          ((Spec R).fromSpecResidueField (t : Spec R))).obj
          ((pushforward f).obj F) ≅
        (pushforward (f.fiberToSpecResidueField t)).obj (f.fiberModule t F)) :
    Module.finrank t.asIdeal.ResidueField
        (t.asIdeal.Fiber
          Γ((pushforward f).obj F, (⊤ : (Spec R).Opens))) =
      f.fiberH0 F t := by
  let M := (pushforward f).obj F
  haveI : M.IsQuasicoherent := pushforward_isQuasicoherent f F
  letI aRK : Algebra Γ(Spec R, ⊤)
      Γ(Spec ((Spec R).residueField t), ⊤) :=
    (((Spec R).fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
  have step₁ : Module.finrank t.asIdeal.ResidueField
        (t.asIdeal.Fiber Γ(M, (⊤ : (Spec R).Opens))) =
      Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        (TensorProduct Γ(Spec R, ⊤)
          Γ(Spec ((Spec R).residueField t), ⊤) Γ(M, ⊤)) := by
    refine finrank_tensor_eq_of_ringEquiv
      (Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv.symm
      (specResidueFieldRingEquiv R t) ?_ (AddEquiv.refl _) ?_
    · intro r
      have h := appLE_fromSpecResidueField_apply R t
        ((Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv.symm r)
      rw [RingEquiv.apply_symm_apply] at h
      exact h.symm
    · intro r n
      rw [smul_gammaSpecTop M r n]
      rfl
  obtain ⟨⟨ePull, -⟩⟩ := pullback_app_isoTensor_baseMap_sectionLinearEquiv
    ((Spec R).fromSpecResidueField (t : Spec R)) M (isAffineOpen_top _)
      (isAffineOpen_top _) le_top
  letI fiberBase := (f.fiberToSpecResidueField t).baseSectionsModule
    (f.fiberModule t F) (⊤ : (f.fiber t).Opens)
  let eSheaf : Γ(((Scheme.Modules.pullback
      ((Spec R).fromSpecResidueField t)).obj M), ⊤) ≃ₗ[
        Γ(Spec ((Spec R).residueField t), ⊤)]
      Γ(((Scheme.Modules.pushforward (f.fiberToSpecResidueField t)).obj
        (f.fiberModule t F)), ⊤) := by
    let eAdd := ((toPresheafOfModules (Spec ((Spec R).residueField t)) ⋙
      PresheafOfModules.evaluation (Spec ((Spec R).residueField t)).ringCatSheaf.obj
        (Opposite.op ⊤)).mapIso e).toLinearEquiv.toAddEquiv
    refine eAdd.toLinearEquiv ?_
    intro r x
    exact Scheme.Modules.Hom.app_smul e.hom r x
  let ePush := Scheme.Modules.pushforwardTopEquivBaseSections
    (f.fiberToSpecResidueField t) (f.fiberModule t F)
  let eΓ := eSheaf.trans ePush
  have step₂ : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        (TensorProduct Γ(Spec R, ⊤)
          Γ(Spec ((Spec R).residueField t), ⊤) Γ(M, ⊤)) =
      Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        Γ((f.fiberModule t F), ⊤) := by
    exact (LinearEquiv.finrank_eq ePull).trans (LinearEquiv.finrank_eq eΓ)
  have step₃ : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        Γ((f.fiberModule t F), ⊤) = f.fiberH0 F t := by
    letI := f.fiberSectionsModule t (f.fiberModule t F)
    refine finrank_eq_of_ringEquiv_addEquiv
      (Scheme.ΓSpecIso ((Spec R).residueField t)).commRingCatIsoToRingEquiv
      (AddEquiv.refl _) ?_
    intro r m
    change r • m = _
    rw [Scheme.Hom.baseSectionsModule_smul_def]
    change _ = ((f.fiberResidueMap t).hom
      ((Scheme.ΓSpecIso ((Spec R).residueField t)).commRingCatIsoToRingEquiv r)) • m
    congr 1
    simp only [Scheme.Hom.fiberResidueMap, CommRingCat.hom_comp, RingHom.comp_apply]
    have hLE : (f.fiberToSpecResidueField t).appLE ⊤ ⊤ le_top =
        (f.fiberToSpecResidueField t).appTop := Scheme.Hom.appLE_eq_app _
    rw [hLE]
    congr 1
    have h₁ := congrArg (fun φ : Γ(Spec ((Spec R).residueField t), ⊤) ⟶
        Γ(Spec ((Spec R).residueField t), ⊤) => φ.hom r)
      (Scheme.ΓSpecIso ((Spec R).residueField t)).hom_inv_id
    simp only [CommRingCat.hom_comp, RingHom.comp_apply, CommRingCat.hom_id,
      RingHom.id_apply] at h₁
    exact h₁.symm
  exact step₁.trans (step₂.trans step₃)

theorem fiberRank_gammaTop_eq_fiberH0_of_isFinite_schematicSupport
    {R : CommRingCat.{u}} {X : Scheme.{u}} (f : X ⟶ Spec R)
    (F : X.Modules) [F.IsQuasicoherent] [QuasiCompact f] [QuasiSeparated f]
    (hfin : IsFinite (schematicSupportι F ≫ f)) (t : PrimeSpectrum R) :
    Module.finrank t.asIdeal.ResidueField
        (t.asIdeal.Fiber
          Γ((pushforward f).obj F, (⊤ : (Spec R).Opens))) =
      f.fiberH0 F t :=
  fiberRank_gammaTop_eq_fiberH0_of_iso f F t
    (pullbackPushforwardIso_of_isFinite_schematicSupport
      (IsPullback.of_hasPullback f
        ((Spec R).fromSpecResidueField (t : Spec R))) F hfin)

end Modules

namespace DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}

/-- The divisor quotient remains epi after tensoring with any module.

This is the pre-pushforward epimorphism in the D2' evaluation map.  It uses
only the `DivFamily` quotient's existing epimorphism; global generation after
pushforward remains the separate curve-theoretic obligation. -/
theorem twistQuotientMap_epi (L : X.Modules) (x : DivFamily π T) :
    Epi (x.twistQuotientMap L) := by
  letI := x.epi
  haveI : Epi (Modules.tensorObj_functoriality
      (𝟙 ((Modules.pullback (pullback.fst π T.hom)).obj L))
      ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q)) :=
    Modules.tensorObj_functoriality_epi_right _
  change Epi ((Modules.tensorObj_right_unitor
    ((Modules.pullback (pullback.fst π T.hom)).obj L)).inv ≫
      Modules.tensorObj_functoriality
        (𝟙 ((Modules.pullback (pullback.fst π T.hom)).obj L))
        ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q))
  letI : Epi (Modules.tensorObj_right_unitor
      ((Modules.pullback (pullback.fst π T.hom)).obj L)).inv := inferInstance
  infer_instance

set_option backward.isDefEq.respectTransparency false in
/-- On an affine test base, a finite-flat divisor pushforward is locally free
of the divisor's fibre degree.  The proof supplies finite presentation and
projectivity from the existing pushforward producers; the rank is computed by
the finite-support base-change bridge above, not assumed separately.

This is the available affine/noetherian bridge: it still requires the explicit
`LocallyQuasiFinite` support instance and `[IsNoetherianRing R]`.  It is not yet
the arbitrary-`Over S` producer for the twisted D2' target. -/
theorem pushforward_isLocallyFreeOfRank
    {R : CommRingCat.{u}} {S X : Scheme.{u}} {π : X ⟶ S}
    [IsProper π] (f : Spec R ⟶ S) [IsNoetherianRing R]
    (x : DivFamily π (Over.mk f))
    [LocallyQuasiFinite
      (Modules.schematicSupportι x.F ≫ pullback.snd π (Over.mk f).hom)]
    {d : ℕ} (hx : x.HasFiberDeg d) :
    SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π f)).obj x.F) d := by
  letI : IsLocallyNoetherian (Over.mk f).left := by
    change IsLocallyNoetherian (Spec R)
    infer_instance
  letI : x.F.IsFinitePresentation := x.isFinitePresentation
  letI : x.F.IsQuasicoherent := by
    exact inferInstance
  let q := pullback.snd π (Over.mk f).hom
  let M : (Spec R).Modules := (Modules.pushforward q).obj x.F
  haveI : QuasiCompact q := by
    dsimp [q]
    infer_instance
  haveI : QuasiSeparated q := by
    dsimp [q]
    infer_instance
  haveI : M.IsFinitePresentation := x.isFinitePresentation_pushforward
  haveI : M.IsQuasicoherent := x.isQuasicoherent_pushforward
  letI baseM := ((𝟙 (Spec R)) : Spec R ⟶ Spec R).baseSectionsModule M
    (⊤ : (Spec R).Opens)
  haveI : IsNoetherianRing Γ(Spec R, (⊤ : (Spec R).Opens)) :=
    isNoetherianRing_of_ringEquiv R
      (Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv.symm
  have hfinΓ : Module.Finite Γ(Spec R, (⊤ : (Spec R).Opens))
      Γ(M, (⊤ : (Spec R).Opens)) :=
    Modules.module_finite_sections_of_isFinitePresentation M
      ⟨⊤, isAffineOpen_top (Spec R)⟩
  have hfin : Module.Finite R Γ(M, (⊤ : (Spec R).Opens)) :=
    module_finite_top_of_gammaSpecTop M hfinΓ
  letI : Module.Finite Γ(Spec R, (⊤ : (Spec R).Opens))
      Γ(M, (⊤ : (Spec R).Opens)) := hfinΓ
  have hflatΓ : Module.Flat Γ(Spec R, (⊤ : (Spec R).Opens))
      Γ(M, (⊤ : (Spec R).Opens)) :=
    Modules.flat_sections_of_coherentSheafFlat_id
      x.coherentSheafFlat_id_pushforward (isAffineOpen_top (Spec R))
  letI : Module.Flat Γ(Spec R, (⊤ : (Spec R).Opens))
      Γ(M, (⊤ : (Spec R).Opens)) := hflatΓ
  letI : Module.FinitePresentation Γ(Spec R, (⊤ : (Spec R).Opens))
      Γ(M, (⊤ : (Spec R).Opens)) :=
    Module.finitePresentation_of_finite Γ(Spec R, (⊤ : (Spec R).Opens)) _
  have hprojΓ : Module.Projective Γ(Spec R, (⊤ : (Spec R).Opens))
      Γ(M, (⊤ : (Spec R).Opens)) :=
    Module.Flat.projective_of_finitePresentation
  have hproj : Module.Projective R Γ(M, (⊤ : (Spec R).Opens)) :=
    module_projective_top_of_gammaSpecTop M hprojΓ
  letI : Module.Projective R Γ(M, (⊤ : (Spec R).Opens)) := hproj
  letI : Module.Flat R Γ(M, (⊤ : (Spec R).Opens)) := Module.Flat.of_projective
  apply Modules.isLocallyFreeOfRank_of_finite_projective_sections M hfin inferInstance
  intro t
  change Module.rankAtStalk Γ(M, (⊤ : (Spec R).Opens)) t = d
  rw [Module.rankAtStalk_eq]
  haveI : IsProper (Modules.schematicSupportι x.F ≫ q) := x.properSupport
  have hsupport : IsFinite (Modules.schematicSupportι x.F ≫ q) :=
    IsFinite.of_isProper_of_locallyQuasiFinite _
  exact (Modules.fiberRank_gammaTop_eq_fiberH0_of_isFinite_schematicSupport
    q x.F hsupport t).trans (hx t)

end DivFamily

end Scheme

namespace FiberCoordinateData

/-- Extension-uniform global generation for every campaign curve.

The fixed coordinate construction supplies the `UniformBaseDivisor` witness
that the generation theorem needs, so this endpoint has only the standard
smooth, proper, geometrically integral curve assumptions.  It is the
fieldwise generation input for the D2' evaluation map; passing from all
geometric fibres to an epi over an arbitrary test base is a separate descent
step. -/
theorem uniformGeneration_fixedCoordinate
    {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIntegral C.hom] :
    UniformGeneration C :=
  uniformGeneration_of_uniformBaseDivisor C
    (uniformBaseDivisor_fixedCoordinate C)

end FiberCoordinateData

namespace Adelic

/-- A concrete D2' twist witness, selected from the projectivity theorem for a
smooth proper geometrically integral curve.  Keeping the choice named makes
the projective input consumable by later Grassmannian constructions without
adding a rational-point binder or another representability class.

At this mathlib pin `IsProjectiveWith` is Scheme-`0`-valued, so this named
witness is the small-universe (`k : Type`) route rather than a universe-polymorphic
seam witness. -/
noncomputable def d2ProjectiveTwist
    {k : Type} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] : C.left.Modules :=
  Classical.choose (exists_isProjectiveWith_of_smoothProperGeometricallyIntegral C)

theorem d2ProjectiveTwist_isProjectiveWith
    {k : Type} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    C.hom.IsProjectiveWith (d2ProjectiveTwist C) :=
  Classical.choose_spec (exists_isProjectiveWith_of_smoothProperGeometricallyIntegral C)

theorem d2ProjectiveTwist_isLocallyTrivial
    {k : Type} [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    Scheme.LineBundle.IsLocallyTrivial (d2ProjectiveTwist C) := by
  obtain ⟨n, hn, i, hi, hcomp, ⟨e⟩⟩ :=
    d2ProjectiveTwist_isProjectiveWith C
  letI : Finite n := hn
  exact Scheme.LineBundle.IsLocallyTrivial.of_iso e.symm
    ((ProjTwist.twistingSheaf_isLocallyTrivial n
      (Spec (CommRingCat.of k)) 1).pullback i)

end Adelic

end AlgebraicGeometry
