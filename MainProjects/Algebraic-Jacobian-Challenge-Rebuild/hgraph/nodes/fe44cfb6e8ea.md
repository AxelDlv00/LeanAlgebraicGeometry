---
author: sync
content_type: theorem
created: '2026-07-29T00:02:40'
decl: AlgebraicGeometry.Scheme.map_twoChartClass_eq_one_iff
docstring: '**The kernel form of the quotient-level square**: a two-chart Čech class
  dies in `X.CechPic`

  after pullback exactly when its pulled-back class does. This is the shape the `ε`-kernel

  computation reads, since `twoChartClass` is injective (`twoChartClass_injective`)
  and so the

  `CechPic`-level kernel is computed by the `Ȟ¹`-level one.'
file: AlgebraicJacobian/Tangent/TwoChartQuotientNaturality.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.map_twoChartClass_eq_one_iff
type: lean
updated: '2026-07-29T15:26:39'
---
theorem map_twoChartClass_eq_one_iff (f : X ⟶ Y) (sel : Y → Bool) (hmem : ∀ y, y ∈ V (sel y))
    (hsel : Function.Surjective sel)
    (hsel' : Function.Surjective (fun x ↦ sel (f.base x)))
    (q : Γ(Y, V false ⊓ V true)ˣ ⧸ TruncExpCech.cechCoboundaryUnits
      (Y.resHom (inf_le_left : V false ⊓ V true ≤ V false))
      (Y.resHom (inf_le_right : V false ⊓ V true ≤ V true))) :
    Scheme.CechPic.map f (twoChartClass V sel hmem hsel q) = 1
      ↔ pullbackOverlapQuot f q = 1 := by
  rw [map_twoChartClass f sel hmem hsel hsel' q]
  constructor
  · intro h
    exact (injective_iff_map_eq_one _).mp
      (twoChartClass_injective (fun s ↦ f ⁻¹ᵁ V s) (fun x ↦ sel (f.base x))
        (fun x ↦ hmem (f.base x)) hsel') _ h
  · intro h
    rw [h, map_one]