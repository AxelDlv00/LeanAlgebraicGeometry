---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.basicOpen_mul_le_right
file: AlgebraicJacobian/Picard/DescentClassRepBuild.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.basicOpen_mul_le_right
type: lean
updated: '2026-07-16T21:33:28'
---
private lemma basicOpen_mul_le_right
    (f g : Γ(SA, ⊤)) :
    (SA).basicOpen (f * g) ≤ (SA).basicOpen g :=
  ((SA).basicOpen_mul f g).trans_le inf_le_right

set_option maxHeartbeats 1600000 in
-- the concrete section-ring instance stacks exceed the default budget
/-- Restriction of the trivializing value to a smaller basic open is the evaluation of
the correspondingly restricted generator. -/
private lemma μval_res (w : Γ(Sq, ⊤)ˣ)
    (hW : Module.IsDescentCocycle
      (Units.map (Scheme.ΓSpecIso (.of (B ⊗[A] B))).hom.hom.toMonoidHom w))
    (F : Scheme.TrivializingFamily (SA) (Γ(SA, ⊤) ⊗[A] ↥(hW.descended)))
    (a : SA) (g' : Γ(SA, ⊤))
    (hle : (SA).basicOpen g' ≤ (SA).basicOpen (F.sec a)) :
    ((SB).presheaf.map (homOfLE ((gS).preimage_mono hle)).op).hom (μval w hW F a)
      = evalT (hW.descended) ((SA).basicOpen g') ((gS) ⁻¹ᵁ (SA).basicOpen g') le_rfl
          (cancelN (k := k) w hW g'
            (LinearMap.rTensor _ ((SA).basicRes (F.sec a) g' hle).toLinearMap
              ((F.triv a).symm 1))) := by
  refine (evalT_res (hW.descended) le_rfl le_rfl hle ((gS).preimage_mono hle)
    ((((SA).basicRes (F.sec a) g' hle).toLinearMap).restrictScalars A)
    (fun _ => rfl) _).trans ?_
  exact congrArg _ (cancelN_rTensor (k := k) w hW (F.sec a) g' hle ((F.triv a).symm 1))