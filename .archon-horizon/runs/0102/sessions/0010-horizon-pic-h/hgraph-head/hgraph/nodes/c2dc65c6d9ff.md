---
author: sync
content_type: theorem
created: '2026-07-30T00:05:11'
decl: ProbeP4e.controlSorry
file: scratch_p4/Probe5.lean
generated: lean
lean_status: sorry
stale: true
title: ProbeP4e.controlSorry
type: lean
updated: '2026-07-30T00:56:05'
---
theorem controlSorry (J : Over (Spec (.of k))) : QuasiCompact J.hom := sorry

section Levels

variable {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of k))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of k))] [IsIntegral X]
variable {A B : X.CurveDivisor} {g r₁ r₂ : ℕ}
variable {b₁ : Module.Basis (Fin r₁) k ↥(Scheme.divisorSections k B ⊤)}
variable {b₂ : Module.Basis (Fin r₂) k ↥(Scheme.divisorSections k (A + B) ⊤)}

local notation "DivO" => divSchemeOver k A B g r₁ r₂ b₁ b₂