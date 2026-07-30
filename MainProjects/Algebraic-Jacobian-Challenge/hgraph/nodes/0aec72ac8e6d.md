---
author: sync
content_type: lemma
created: '2026-07-30T08:42:04'
decl: Probe.splitHom_tmul
file: Scratch2/Split4.lean
generated: lean
lean_status: lean_ok
stale: true
title: Probe.splitHom_tmul
type: lean
updated: '2026-07-30T09:17:04'
---
@[simp] lemma splitHom_tmul (a b : L) (γ : L ≃ₐ[K] L) :
    splitHom K L (a ⊗ₜ b) γ = a * γ b := by
  simp [splitHom, Algebra.ofId_apply]