---
author: sync
content_type: theorem
created: '2026-07-19T14:31:14'
decl: AlgebraicGeometry.isSeparated_carveScheme
docstring: '**The glued carve locus is separated** (absolutely).'
file: AlgebraicJacobian/Picard/DivSchemeQProj.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isSeparated_carveScheme
type: lean
updated: '2026-08-01T09:44:12'
---
theorem isSeparated_carveScheme : (carveScheme k g r₁ r₂ μ).IsSeparated := by
  haveI : IsSeparated (carveSchemeι k g r₁ r₂ μ ≫ grPairStructMap k g r₁ g r₂) :=
    isSeparated_carveSchemeOverHom k g r₁ r₂ μ
  rw [Scheme.isSeparated_iff,
    ← terminal.comp_from (carveSchemeι k g r₁ r₂ μ ≫ grPairStructMap k g r₁ g r₂)]
  infer_instance

end Carve

/-! ## The campaign spellings (the DAT-D windows) and the §4.1 bundle -/

section Curve

open Scheme Grassmannian

variable (k : Type u) [Field k] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of k))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of k))] [IsIntegral X]
variable (A B : X.CurveDivisor) (g r₁ r₂ : ℕ)
variable (b₁ : Module.Basis (Fin r₁) k ↥(divisorSections k B ⊤))
variable (b₂ : Module.Basis (Fin r₂) k ↥(divisorSections k (A + B) ⊤))