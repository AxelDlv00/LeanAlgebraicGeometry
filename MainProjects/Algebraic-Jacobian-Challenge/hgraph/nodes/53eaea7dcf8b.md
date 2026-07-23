---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.exists_finite_presentation_of_isIso_fromTilde
docstring: '**A finite module sheaf on `Spec R` (R noetherian) with invertible

  tilde–Γ counit admits a finite presentation.**  Choose a finite generating

  family of the global sections (`Module.Finite.exists_fin`); the kernel of

  the induced surjection from the finite free module is finitely generated

  because `R` is noetherian; `presentationTilde` packages the data into a

  finite `SheafOfModules.Presentation` of the tilde, which transports to `F`

  across the (invertible) counit `fromTildeΓ`.'
file: AlgebraicJacobian/Picard/RigidPushforwardTransfer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.exists_finite_presentation_of_isIso_fromTilde
type: lean
updated: '2026-07-16T21:14:27'
---
theorem exists_finite_presentation_of_isIso_fromTildeΓ {R : CommRingCat.{u}}
    (F : (Spec R).Modules) [IsIso (Scheme.Modules.fromTildeΓ F)]
    [IsNoetherianRing (R : Type u)]
    (hfin : Module.Finite (R : Type u) Γ(F, ⊤)) :
    ∃ P : F.Presentation, P.IsFinite := by
  set M0 : ModuleCat.{u} (R : Type u) :=
    (modulesSpecToSheaf.obj F).presheaf.obj (op (⊤ : (Spec R).Opens)) with hM0
  haveI hfin0 : Module.Finite (R : Type u) M0 := hfin
  obtain ⟨n, w, hw⟩ := hfin0.exists_fin
  set s : Set M0 := Set.range w with hsdef
  haveI : Finite (↥s) := (Set.finite_range w).to_subtype
  haveI : Module.Finite (R : Type u) (↥s →₀ (R : Type u)) := by infer_instance
  haveI : _root_.IsNoetherian (R : Type u) (↥s →₀ (R : Type u)) :=
    isNoetherian_of_isNoetherianRing_of_finite _ _
  obtain ⟨T, hT⟩ := _root_.IsNoetherian.noetherian
    (Finsupp.linearCombination (R : Type u) (Subtype.val : ↥s → M0)).ker
  haveI : Finite (↥(T : Set (↥s →₀ (R : Type u)))) := T.finite_toSet.to_subtype
  let P0 : (tilde M0).Presentation :=
    presentationTilde M0 s hw (T : Set (↥s →₀ (R : Type u))) hT
  haveI hP0gen : P0.generators.IsFiniteType :=
    { finite := inferInstanceAs (Finite ↥s) }
  haveI hP0rel : P0.relations.IsFiniteType :=
    { finite := inferInstanceAs (Finite (↥(T : Set (↥s →₀ (R : Type u))))) }
  haveI hP0 : P0.IsFinite :=
    SheafOfModules.Presentation.IsFinite.mk.{u, u, u} (p := P0) hP0gen hP0rel
  let eT : tilde M0 ≅ F :=
    @asIso _ _ _ _ (Scheme.Modules.fromTildeΓ F) ‹_›
  exact ⟨SheafOfModules.Presentation.ofIsIso.{u} eT.hom P0, inferInstance⟩

set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 1600000 in
-- Heartbeat headroom for the slice-site presentation transports and their
-- `IsFinite` instance searches, as elsewhere in the QuotScheme transport layer.
set_option synthInstance.maxHeartbeats 800000 in