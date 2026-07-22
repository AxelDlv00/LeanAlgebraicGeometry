---
author: sync
content_type: definition
created: '2026-07-19T11:31:12'
decl: AlgebraicGeometry.divRepClassifyZar
docstring: '**The keystone of F4** (w4-ddr9 §2.1, `divRepAff.symm`''s content): the
  backward

  classification of locally certified divisor classes over an affine test, as a

  morphism of `Over (Spec k)`.  Characterized by `divRepClassifyZar_isDivRepClassify`;

  independent of every choice by `divRepClassifyZar_eq_of_isDivRepClassify`.'
file: AlgebraicJacobian/Picard/DivRepClassifyZar.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divRepClassifyZar
type: lean
updated: '2026-07-19T11:31:12'
---
noncomputable def divRepClassifyZar (F₀ : DivFamZar C S π g) :
    overSpec k S ⟶
      divSchemeOver k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁
        (b₂.map (windowShiftEquiv hπ g).symm) :=
  (exists_overHom_isDivRepClassify hπ g hO hχ r₁ r₂ b₁ b₂ F₀).choose

include hO hχ in