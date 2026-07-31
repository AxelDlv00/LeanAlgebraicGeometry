---
author: sync
content_type: theorem
created: '2026-08-01T05:52:45'
decl: AlgebraicGeometry.Scheme.Modules.isFinitePresentation_tensorObj_left_of_isLocallyTrivial
docstring: 'Tensoring a finitely presented module sheaf on the left by a locally

  trivial line bundle preserves finite presentation.  The proof refines a

  finite-presentation cover for `F` by a trivializing cover for `L`; on every

  intersection the tensor product is isomorphic to `F`, so its finite

  presentation transports across that isomorphism.'
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.isFinitePresentation_tensorObj_left_of_isLocallyTrivial
type: lean
updated: '2026-08-01T07:20:39'
---
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
  let P : ∀ ij, ((tensorObj L F).over (W ij)).Presentation := fun ij => by
    let PF : (F.over (W ij)).Presentation :=
      presentationOverOpens (W ij) F (q.X ij.1)
        (q.presentation ij.1) inf_le_left
    let eL : L.restrict (W ij).ι ≅
        SheafOfModules.unit (W ij : Scheme).ringCatSheaf :=
      restrictIsoUnitOfLE inf_le_right (hUiso ij.2).some
    let eRes : (tensorObj L F).restrict (W ij).ι ≅ F.restrict (W ij).ι :=
      tensorObj_restrict_iso (W ij).ι L F ≪≫
        tensorObjIsoOfIso eL (Iso.refl _) ≪≫
        tensorObj_left_unitor _
    let eOver : (tensorObj L F).over (W ij) ≅ F.over (W ij) :=
      (restrictOverIso (W ij) (tensorObj L F)).symm ≪≫
        (overEquivalence (W ij)).functor.mapIso eRes ≪≫
        restrictOverIso (W ij) F
    exact SheafOfModules.Presentation.ofIsIso.{u, u, u}
      eOver.inv PF
  let qT : (tensorObj L F).QuasicoherentData :=
    { I := q.I × I
      X := W
      coversTop := hWcover
      presentation := P }
  have hP : ∀ ij, (P ij).IsFinite := by
    intro ij
    dsimp only [P]
    letI : (q.presentation ij.1).IsFinite := hq.isFinite_presentation _
    infer_instance
  have hqT : qT.IsFinitePresentation := by
    apply SheafOfModules.QuasicoherentData.IsFinitePresentation.mk
    intro ij
    exact hP ij
  have hsh : qT.shrink.IsFinitePresentation :=
    { isFinite_presentation := fun ij =>
        hqT.isFinite_presentation (Exists.choose ij.property) }
  exact { exists_quasicoherentData := ⟨qT.shrink, hsh⟩ }