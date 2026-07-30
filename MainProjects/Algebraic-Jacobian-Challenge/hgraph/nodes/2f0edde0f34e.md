---
author: sync
content_type: definition
created: '2026-07-30T08:42:04'
decl: Probe.splitLin
file: Scratch2/Split4.lean
generated: lean
lean_status: lean_ok
title: Probe.splitLin
type: lean
updated: '2026-07-30T08:42:04'
---
noncomputable def splitLin : (L ⊗[K] L) →ₗ[L] ((L ≃ₐ[K] L) → L) :=
  (splitHom K L).toLinearMap

omit [FiniteDimensional K L] [IsGalois K L] in