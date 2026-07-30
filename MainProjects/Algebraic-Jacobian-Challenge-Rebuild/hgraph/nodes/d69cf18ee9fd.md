---
author: sync
content_type: definition
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.relQuotBaseChangeAff
docstring: '**Base change of a quotient of section rings at an arbitrary affine open**
  (the widened

  colength transport): for a set `E` of equations on `V`,

  `R'' ⊗[R] (Γ(V) ⧸ (E)) ≃ₐ[R''] Γ(V'') ⧸ (E'')` with `V'' = relCurveMap ⁻¹ᵁ V` and
  `E''` the image

  of `E` under the section comparison.  Quotient right-exactness

  (`Algebra.TensorProduct.tensorQuotientEquiv`) followed by transport along

  `relSectionsBaseChangeAff`.


  At `E = {f}` this is the widened (c1) colength transport; at a two-element `E` it
  is the

  overlap-colength transport — and, unlike the chart-typed layer, the two are the
  SAME

  declaration at two opens, because an overlap of affine opens is again an affine
  open and needs

  no re-presentation as a basic open of anything.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffSections.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relQuotBaseChangeAff
type: lean
updated: '2026-07-30T15:28:04'
---
noncomputable def relQuotBaseChangeAff {V : (relCurve C R).Opens} (hV : IsAffineOpen V)
    (E : Set Γ(relCurve C R, V)) :
    R' ⊗[R] (Γ(relCurve C R, V) ⧸ Ideal.span E) ≃ₐ[R']
      Γ(relCurve C R', relCurveMap C R R' ⁻¹ᵁ V) ⧸
        Ideal.span (relAffSectionsMap C R' V '' E) :=
  (Algebra.TensorProduct.tensorQuotientEquiv R' Γ(relCurve C R, V) R' (Ideal.span E)).trans
    (Ideal.quotientEquivAlg _ _ (relSectionsBaseChangeAff C R' hV)
      (relSpanAff_map_eq C R' hV E))