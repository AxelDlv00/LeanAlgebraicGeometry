/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.LineBundleCoherence
import AlgebraicJacobian.Picard.PullbackFinitePresentation
import AlgebraicJacobian.Picard.TensorObjSubstrate

/-!
# Finite presentation after tensoring by a line bundle

The divisor-to-Grassmannian construction tensors a finitely presented module
by a locally trivial line bundle.  This small substrate keeps the presentation
transport available to both the curve pushforward producers and the larger
embedding module without making either module import the other.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

/-! Keep the slice-site presentation transport opaque after construction.  This
avoids unfolding the equivalence again while proving finiteness of its index
types. -/
noncomputable def tensorPresentationOver
    {X : Scheme.{u}} (L F : X.Modules) (W : X.Opens)
    (PF : (F.over W).Presentation)
    (eL : L.restrict W.ι ≅ SheafOfModules.unit (W : Scheme).ringCatSheaf) :
    ((tensorObj L F).over W).Presentation := by
  let eRes : (tensorObj L F).restrict W.ι ≅ F.restrict W.ι :=
    tensorObj_restrict_iso W.ι L F ≪≫
      tensorObjIsoOfIso eL (Iso.refl _) ≪≫
      tensorObj_left_unitor _
  let eOver : (tensorObj L F).over W ≅ F.over W :=
    (restrictOverIso W (tensorObj L F)).symm ≪≫
      (overEquivalence W).functor.mapIso eRes ≪≫
      restrictOverIso W F
  exact SheafOfModules.Presentation.ofIsIso.{u, u, u} eOver.inv PF

set_option synthInstance.maxHeartbeats 1000000 in
set_option maxRecDepth 10000 in
lemma tensorPresentationOver_isFinite
    {X : Scheme.{u}} (L F : X.Modules) (W : X.Opens)
    (PF : (F.over W).Presentation)
    (eL : L.restrict W.ι ≅ SheafOfModules.unit (W : Scheme).ringCatSheaf)
    [PF.IsFinite] :
    (tensorPresentationOver L F W PF eL).IsFinite := by
  dsimp only [tensorPresentationOver]
  infer_instance

set_option synthInstance.maxHeartbeats 1000000 in
set_option maxRecDepth 10000 in
set_option maxHeartbeats 2000000 in
/-- Tensoring a finitely presented module sheaf on the left by a locally
trivial line bundle preserves finite presentation.  The proof refines a
finite-presentation cover for `F` by a trivializing cover for `L`; on every
intersection the tensor product is isomorphic to `F`, so its finite
presentation transports across that isomorphism. -/
theorem isFinitePresentation_tensorObj_left_of_isLocallyTrivial
    {X : Scheme.{u}} (L F : X.Modules)
    (hL : LineBundle.IsLocallyTrivial L) (hF : F.IsFinitePresentation) :
    (tensorObj L F).IsFinitePresentation := by
  obtain ⟨q, hq⟩ := hF.exists_quasicoherentData
  obtain ⟨I, U, _hUaff, hUtop, hUiso⟩ := hL.exists_trivializing_cover
  let W : q.I × I → X.Opens := fun ij => q.X ij.1 ⊓ U ij.2
  have hWcover : (Opens.grothendieckTopology X).CoversTop W := by
    intro V x hx
    obtain ⟨V', fV, hf, hxV'⟩ := q.coversTop ⊤ x (by trivial)
    obtain ⟨i, ⟨gi⟩⟩ := hf
    have hxq : x ∈ q.X i := (leOfHom gi) hxV'
    have hxU : x ∈ iSup U := by rw [hUtop]; trivial
    rw [TopologicalSpace.Opens.mem_iSup] at hxU
    obtain ⟨j, hxj⟩ := hxU
    exact ⟨V ⊓ W (i, j), homOfLE inf_le_left,
      ⟨(i, j), ⟨homOfLE inf_le_right⟩⟩, ⟨hx, ⟨hxq, hxj⟩⟩⟩
  let P : ∀ ij, ((tensorObj L F).over (W ij)).Presentation := fun ij =>
    tensorPresentationOver L F (W ij)
      (presentationOverOpens (W ij) F (q.X ij.1)
        (q.presentation ij.1) inf_le_left)
      (restrictIsoUnitOfLE inf_le_right (hUiso ij.2).some)
  let qT : (tensorObj L F).QuasicoherentData :=
    { I := q.I × I
      X := W
      coversTop := hWcover
      presentation := P }
  have hqT : qT.IsFinitePresentation := by
    apply SheafOfModules.QuasicoherentData.IsFinitePresentation.mk
    intro ij
    dsimp only [P]
    letI : (q.presentation ij.1).IsFinite := hq.isFinite_presentation _
    apply tensorPresentationOver_isFinite
  have hsh : qT.shrink.IsFinitePresentation :=
    { isFinite_presentation := fun ij =>
        hqT.isFinite_presentation (Exists.choose ij.property) }
  exact { exists_quasicoherentData := ⟨qT.shrink, hsh⟩ }

end Modules

end Scheme

end AlgebraicGeometry
