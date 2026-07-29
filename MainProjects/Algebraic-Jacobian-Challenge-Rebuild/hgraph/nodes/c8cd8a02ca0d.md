---
author: sync
content_type: definition
created: '2026-07-28T19:44:59'
decl: AlgebraicGeometry.Over.dualNumberSectionsOfIsAffineOpen
docstring: 'The carrier translation at an **affine** open — the form the two-chart
  cover supplies, since

  `Cohomology/RelativeTwoCover.lean`''s `relCover` provides affine thickened charts
  (and an affine

  overlap). Affine opens are qcqs.'
file: AlgebraicJacobian/Tangent/DualNumberCarrier.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.dualNumberSectionsOfIsAffineOpen
type: lean
updated: '2026-07-29T15:26:33'
---
noncomputable def Over.dualNumberSectionsOfIsAffineOpen {W : C.left.Opens}
    (hW : IsAffineOpen W) :
    DualNumber Γ(C.left, W) ≃+*
      Γ((C ⊗ overSpec k (DualNumber k)).left,
        (fst C (overSpec k (DualNumber k))).left ⁻¹ᵁ W) :=
  Over.dualNumberSections C hW.isCompact hW.isQuasiSeparated

/-! ## Naturality in the open -/