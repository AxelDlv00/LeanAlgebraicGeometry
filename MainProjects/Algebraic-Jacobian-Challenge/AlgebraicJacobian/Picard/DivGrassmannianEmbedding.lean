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

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

namespace DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}

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
