---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.vanishingDiv_matching
docstring: '**The cofactor family matches through the theta-ideal transition units**

  (`u_{pq} = (f_q/f_p) · θ^{±a}`): cancelling the regular equation `f_p` reduces the

  matching to the side matching against the ratio law.'
file: AlgebraicJacobian/Picard/DivSchemeCertificate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.vanishingDiv_matching
type: lean
updated: '2026-07-17T16:57:13'
---
lemma vanishingDiv_matching (p q : A.index) :
    (relCurve C R).resHom
        (inf_le_left : (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens)
          ≤ ⊤ ⊓ A.pieces p) (vanishingDiv A a x p)
      = (relCurve C R).resHom
          (le_inf (inf_le_left.trans inf_le_right) inf_le_right :
            (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens)
              ≤ A.pieces p ⊓ A.pieces q)
          ((A.thetaIdealUnit a p q : Γ(relCurve C R, A.pieces p ⊓ A.pieces q)ˣ) :
            Γ(relCurve C R, A.pieces p ⊓ A.pieces q))
        * (relCurve C R).resHom
            (le_inf (inf_le_left.trans inf_le_left) inf_le_right :
              (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens)
                ≤ ⊤ ⊓ A.pieces q) (vanishingDiv A a x q) := by
  refine A.eqn_res_cancel p (inf_le_left.trans inf_le_right) ?_
  -- `f_p · (s_p/f_p) = s_p` restricted to the double overlap
  have hL := congrArg ((relCurve C R).resHom
    (inf_le_left : (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens)
      ≤ ⊤ ⊓ A.pieces p))
    (A.eqn_mul_eqnDiv p inf_le_right (vanishingSide A a x p)
      (vanishingSide_germ_mem x p))
  -- `f_q · (s_q/f_q) = s_q` restricted to the double overlap
  have hR := congrArg ((relCurve C R).resHom
    (le_inf (inf_le_left.trans inf_le_left) inf_le_right :
      (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens) ≤ ⊤ ⊓ A.pieces q))
    (A.eqn_mul_eqnDiv q inf_le_right (vanishingSide A a x q)
      (vanishingSide_germ_mem x q))
  -- the ratio law `f_p · (f_q/f_p) = f_q` restricted to the double overlap
  have hratio := congrArg ((relCurve C R).resHom
    (le_inf (inf_le_left.trans inf_le_right) inf_le_right :
      (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens)
        ≤ A.pieces p ⊓ A.pieces q))
    (A.eqn_mul_eqnRatio p q)
  -- the side matching
  have hside := vanishingSide_matching x p q
  -- the ideal unit is the ratio unit times the twisting unit
  have hunit := congrArg ((relCurve C R).resHom
    (le_inf (inf_le_left.trans inf_le_right) inf_le_right :
      (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens)
        ≤ A.pieces p ⊓ A.pieces q))
    (show ((A.thetaIdealUnit a p q : Γ(relCurve C R, A.pieces p ⊓ A.pieces q)ˣ) :
        Γ(relCurve C R, A.pieces p ⊓ A.pieces q))
      = ((A.eqnRatio p q : Γ(relCurve C R, A.pieces p ⊓ A.pieces q)ˣ) :
          Γ(relCurve C R, A.pieces p ⊓ A.pieces q))
        * ((A.thetaOvlUnit a p q : Γ(relCurve C R, A.pieces p ⊓ A.pieces q)ˣ) :
            Γ(relCurve C R, A.pieces p ⊓ A.pieces q)) from rfl)
  rw [map_mul] at hL hR hratio hunit
  simp only [Scheme.resHom_resHom] at hL hR hratio hunit
  linear_combination hL + hside
    - (relCurve C R).resHom
        (le_inf (inf_le_left.trans inf_le_right) inf_le_right :
          (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens)
            ≤ A.pieces p ⊓ A.pieces q)
        ((A.thetaOvlUnit a p q : Γ(relCurve C R, A.pieces p ⊓ A.pieces q)ˣ) :
          Γ(relCurve C R, A.pieces p ⊓ A.pieces q)) * hR
    - (relCurve C R).resHom
        (le_inf (inf_le_left.trans inf_le_right) inf_le_right :
          (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens)
            ≤ A.pieces p ⊓ A.pieces q)
        ((A.thetaOvlUnit a p q : Γ(relCurve C R, A.pieces p ⊓ A.pieces q)ˣ) :
          Γ(relCurve C R, A.pieces p ⊓ A.pieces q))
      * (relCurve C R).resHom
          (le_inf (inf_le_left.trans inf_le_left) inf_le_right :
            (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens) ≤ ⊤ ⊓ A.pieces q)
          (vanishingDiv A a x q) * hratio
    - (relCurve C R).resHom
        (inf_le_left.trans inf_le_right :
          (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens) ≤ A.pieces p)
        (A.eqn p)
      * (relCurve C R).resHom
          (le_inf (inf_le_left.trans inf_le_left) inf_le_right :
            (⊤ ⊓ A.pieces p ⊓ A.pieces q : (relCurve C R).Opens) ≤ ⊤ ⊓ A.pieces q)
          (vanishingDiv A a x q) * hunit

variable (A a) in