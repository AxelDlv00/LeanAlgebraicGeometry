---
author: sync
content_type: structure
created: '2026-07-30T19:28:43'
decl: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators
docstring: Aligned source-ring generators for the two pulled-back Laurent charts.
file: AlgebraicJacobian/Picard/FiniteMapLaurentGenerators.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.LaurentChartData.FiniteMapGenerators
type: lean
updated: '2026-07-30T20:02:41'
---
structure LaurentChartData.FiniteMapGenerators (D : LaurentChartData Y)
    (pi : C ⟶ Y) : Type u where
  n0 : ℕ
  n1 : ℕ
  d : ℕ
  aa : Fin n0 ⊕ Fin n1 → Γ(C.left, pi.left ⁻¹ᵁ D.V₀)
  bb : Fin n0 ⊕ Fin n1 → Γ(C.left, pi.left ⁻¹ᵁ D.V₁)
  pos : 0 < d
  compatible : ∀ i,
    D.sourceRestriction0 pi (aa i) =
      (D.sourceRestriction0 pi (D.pullbackX pi)) ^ d *
        D.sourceRestriction1 pi (bb i)
  span0 :
    letI : Algebra Γ(Y.left, D.V₀) Γ(C.left, pi.left ⁻¹ᵁ D.V₀) :=
      RingHom.toAlgebra (pi.left.app D.V₀).hom
    Submodule.span Γ(Y.left, D.V₀) (Set.range aa) = ⊤
  span1 :
    letI : Algebra Γ(Y.left, D.V₁) Γ(C.left, pi.left ⁻¹ᵁ D.V₁) :=
      RingHom.toAlgebra (pi.left.app D.V₁).hom
    Submodule.span Γ(Y.left, D.V₁) (Set.range bb) = ⊤