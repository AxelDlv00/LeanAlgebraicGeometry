---
author: sync
content_type: definition
created: '2026-07-29T08:27:50'
decl: AlgebraicGeometry.collapseCechH1Equiv
docstring: '**(T3-5): the two-chart Čech `Ȟ¹`-of-units groups of `C.left` and of `relCurve
  C k` agree.**


  The seam worksheet §7.6 found between the truncated-exponential engine (which computes
  on `C.left`)

  and the geometric comparison (which lands on `relCurve C k`). `QuotientGroup.congr`
  of

  `collapseUnits` and the subgroup equality above — and, per the module docstring,
  **both subgroups

  must be named explicitly** in that call; leaving them as `_` produces a spurious
  `.Normal`

  synthesis failure.'
file: AlgebraicJacobian/Tangent/CollapseCechH1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.collapseCechH1Equiv
type: lean
updated: '2026-08-01T09:44:18'
---
noncomputable def collapseCechH1Equiv
    (hc : ∀ s, IsCompact ((V s : Set C.left))) (hq : ∀ s, IsQuasiSeparated ((V s : Set C.left)))
    (hci : IsCompact (((V false ⊓ V true : C.left.Opens) : Set C.left)))
    (hqi : IsQuasiSeparated (((V false ⊓ V true : C.left.Opens) : Set C.left))) :
    (Γ(C.left, V false ⊓ V true)ˣ ⧸ cechCoboundaryUnits
        (C.left.resHom (inf_le_left : V false ⊓ V true ≤ V false))
        (C.left.resHom (inf_le_right : V false ⊓ V true ≤ V true))) ≃*
      (Γ(relCurve C k, (fst C (overSpec k k)).left ⁻¹ᵁ (V false ⊓ V true))ˣ ⧸
        cechCoboundaryUnits
          ((relCurve C k).resHom (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left
            (inf_le_left : V false ⊓ V true ≤ V false)))
          ((relCurve C k).resHom (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left
            (inf_le_right : V false ⊓ V true ≤ V true)))) :=
  QuotientGroup.congr
    (cechCoboundaryUnits
      (C.left.resHom (inf_le_left : V false ⊓ V true ≤ V false))
      (C.left.resHom (inf_le_right : V false ⊓ V true ≤ V true)))
    (cechCoboundaryUnits
      ((relCurve C k).resHom (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left
        (inf_le_left : V false ⊓ V true ≤ V false)))
      ((relCurve C k).resHom (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left
        (inf_le_right : V false ⊓ V true ≤ V true))))
    (collapseUnits C (V false ⊓ V true) hci hqi)
    (map_cechCoboundaryUnits_collapseUnits C hc hq hci hqi)

@[simp]