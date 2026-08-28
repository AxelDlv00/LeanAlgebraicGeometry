---
author: sync
content_type: theorem
created: '2026-07-29T13:19:43'
decl: AlgebraicGeometry.Over.appLE_dualNumberSections
docstring: '**§7.8''s section equation, ring form**: restricting the `ε ↦ 0` image
  of a thickened section

  gives the collapse of `fst x`.


  Stated with the target open `V''` and its `e`-binder **explicit**, rather than at

  `fst_k ⁻¹ᵁ W`: that is what keeps the opens cast (module docstring) out of the statement,
  since a

  consumer supplies whichever `≤` its own opens satisfy and this equation never has
  to mention the

  propositional equality of the two preimages.


  Two ingredients, both landed and both named by worksheet §6.24 as what the missing
  link would need:

  `Over.relSectionsMap_dualNumberSections` — the `(b-coeff)` reduction — and the identification
  of

  `sectionsCollapse` against `Over.sectionsBaseChange` at `· ⊗ₜ 1`, which is `hbridge`
  below and cost

  two rewrites plus `rfl`. The remaining step is `Scheme.Hom.appLE_map`: `appLE` followed
  by a

  restriction is a single `appLE`, by proof irrelevance of the inclusion witnesses.'
file: AlgebraicJacobian/Tangent/EpsReductionSquare.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.appLE_dualNumberSections
type: lean
updated: '2026-08-01T09:44:18'
---
theorem appLE_dualNumberSections {W : C.left.Opens}
    (hW : IsCompact (W : Set C.left)) (hW' : IsQuasiSeparated (W : Set C.left))
    {V' : (relCurve C k).Opens}
    (e : V' ≤ relCurveMap C (DualNumber k) k ⁻¹ᵁ
        ((fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ W))
    (hle : V' ≤ (fst C (overSpec k k)).left ⁻¹ᵁ W)
    (x : DualNumber Γ(C.left, W)) :
    ((relCurveMap C (DualNumber k) k).appLE
        ((fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ W) V' e).hom
        (Over.dualNumberSections C hW hW' x)
      = (relCurve C k).resHom hle (collapseRingEquiv C W hW hW' (TrivSqZeroExt.fst x)) := by
  have h0 := Over.relSectionsMap_dualNumberSections C hW hW' x
  have hbridge : Over.sectionsBaseChange C k hW hW' (TrivSqZeroExt.fst x ⊗ₜ (1 : k))
      = collapseRingEquiv C W hW hW' (TrivSqZeroExt.fst x) := by
    rw [Over.sectionsBaseChange_tmul_one]
    change _ = sectionsCollapse C W hW hW' (TrivSqZeroExt.fst x)
    rw [sectionsCollapse_apply]
    rfl
  rw [hbridge] at h0
  rw [← h0, relSectionsMap]
  exact (congr((CommRingCat.Hom.hom $(Scheme.Hom.appLE_map (relCurveMap C (DualNumber k) k)
    (le_of_eq (relCurveMap_preimage C (DualNumber k) k W).symm)
    (homOfLE hle).op)) (Over.dualNumberSections C hW hW' x))).symm