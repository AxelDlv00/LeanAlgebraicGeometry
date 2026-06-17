/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import Mathlib.AlgebraicGeometry.Modules.Sheaf
import Mathlib.AlgebraicGeometry.Modules.Tilde
import Mathlib.AlgebraicGeometry.Restrict
import Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent
import Mathlib.Algebra.Category.ModuleCat.Sheaf.PushforwardContinuous
import Mathlib.Topology.Sheaves.Over
import Mathlib.CategoryTheory.Sites.CoverPreserving
import Mathlib.CategoryTheory.Sites.DenseSubsite.Basic

/-!
# Restriction of an `𝒪_{Spec R}`-module to a basic open (Stacks 01I8) — Route-P step P1a

Project-local supplement for the affine quasi-coherence equivalence.
-/

open AlgebraicGeometry CategoryTheory

namespace AlgebraicGeometry

/-! ## Project-local Mathlib supplement — restriction of modules to a basic open -/

variable {R : CommRingCat.{u}} (f : R)

/-- The basic open `D(f) ⊆ Spec R`, as an open subscheme of `Spec R`. -/
abbrev specBasicOpen : (Spec R).Opens := PrimeSpectrum.basicOpen f

/-- The localisation morphism `Spec R_f ⟶ Spec R` factoring through `D(f)`: the inverse of the
affine identification `D(f) ≅ Spec R_f` followed by the open immersion of `D(f)`. -/
noncomputable abbrev specAwayToSpec :
    Spec (CommRingCat.of (Localization.Away f)) ⟶ Spec R :=
  (basicOpenIsoSpecAway f).inv ≫ (specBasicOpen f).ι

/-- **Stacks 01I8, `lemma-widetilde-pullback`.** Restriction of an `𝒪_{Spec R}`-module to the basic
open `D(f)`, transported to a sheaf of `𝒪_{Spec R_f}`-modules along the affine identification
`D(f) ≅ Spec R_f`.  Built by restricting first along the open immersion `D(f) ↪ Spec R`, then along
the (iso, hence open) inverse of `basicOpenIsoSpecAway f`.  Project-local: assembles two Mathlib
restrictions into the single transport used by the affine quasi-coherence equivalence. -/
noncomputable def modulesRestrictBasicOpen (F : (Spec R).Modules) :
    (Spec (CommRingCat.of (Localization.Away f))).Modules :=
  (F.restrict (specBasicOpen f).ι).restrict (basicOpenIsoSpecAway f).inv

/-- **Stacks 01I8, `lemma-widetilde-pullback`.** The transported restriction
`modulesRestrictBasicOpen f F` is canonically isomorphic to the inverse image of `F` along the
localisation morphism `Spec R_f ⟶ Spec R`.  This identifies the double restriction with a single
pullback, and is the comparison isomorphism `F|_{D(f)} ≅ F_{(f)}` of the blueprint.  Project-local:
reconciles the (good-defeq) iterated `restrict` with the conceptual inverse-image description. -/
noncomputable def modulesRestrictBasicOpenIso (F : (Spec R).Modules) :
    modulesRestrictBasicOpen f F ≅
      (Scheme.Modules.pullback (specAwayToSpec f)).obj F :=
  ((Scheme.Modules.restrictFunctorComp (basicOpenIsoSpecAway f).inv (specBasicOpen f).ι).app F).symm
    ≪≫ (Scheme.Modules.restrictFunctorIsoPullback (specAwayToSpec f)).app F

/-- The localisation morphism `Spec R_f ⟶ Spec R` of `specAwayToSpec` is exactly the spectrum of the
away-localisation ring map `R → R_f`.  Project-local: identifies the geometric transport map with
the algebraic `Spec.map (algebraMap …)`, so that pullback along it computes base change. -/
theorem specAwayToSpec_eq :
    specAwayToSpec f = Spec.map (CommRingCat.ofHom (algebraMap R (Localization.Away f))) := by
  rw [specAwayToSpec, Iso.inv_comp_eq]
  exact (IsOpenImmersion.isoOfRangeEq_hom_fac _ _ _).symm

/-! ## Project-local Mathlib supplement — Route B presentation transport (B2–B4) -/

open SheafOfModules in
set_option backward.isDefEq.respectTransparency false in
/-- **Route B, step B2.** If `M.over U` carries a presentation and `D(g) ⊆ U`, then the further
over-restriction `M.over D(g)` admits a presentation. -/
noncomputable def presentationOverBasicOpen
    (M : (Spec R).Modules) (U : (Spec R).Opens)
    (P : (M.over U).Presentation) (g : R) (hg : specBasicOpen g ≤ U) :
    (M.over (specBasicOpen g)).Presentation :=
  letI W : Over U := Over.mk (homOfLE hg)
  letI e : SheafOfModules.{u} ((Spec R).ringCatSheaf.over W.left) ≌
      SheafOfModules.{u} (((Spec R).ringCatSheaf.over U).over W) :=
    pushforwardPushforwardEquivalence
    (Over.iteratedSliceEquiv W)
    (S := ((Spec R).ringCatSheaf.over U).over W)
    (R := (Spec R).ringCatSheaf.over W.left) (𝟙 _) (𝟙 _)
    (by ext : 2; exact (Spec R).ringCatSheaf.1.map_id _)
    (by ext : 2; exact (Spec R).ringCatSheaf.1.map_id _)
  letI P1 : ((M.over U).over W).Presentation :=
    P.map (pushforward (𝟙 (((Spec R).ringCatSheaf.over U).over W))) (by rfl)
  letI P2 : (e.inverse.obj ((M.over U).over W)).Presentation :=
    P1.map e.inverse (.refl _)
  letI iso : e.inverse.obj ((M.over U).over W) ≅ M.over W.left :=
    e.fullyFaithfulFunctor.preimageIso
      (by exact e.counitIso.app ((M.over U).over W))
  show (M.over W.left).Presentation from Presentation.ofIsIso.{u, u, u} iso.hom P2

end AlgebraicGeometry
