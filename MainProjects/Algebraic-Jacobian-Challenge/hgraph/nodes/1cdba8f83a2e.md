---
author: sync
content_type: theorem
created: '2026-07-30T11:05:08'
decl: Probe.twistLeft_snd
file: probe_p3_hcov4.lean
generated: lean
lean_status: lean_ok
title: Probe.twistLeft_snd
type: lean
updated: '2026-07-31T08:18:14'
---
theorem twistLeft_snd (T : Over (Spec (CommRingCat.of k))) (γ : k' ≃ₐ[k] k') :
    twistLeft T γ ≫ pullback.snd T.hom (specMapAlgebra k k')
      = pullback.snd T.hom (specMapAlgebra k k') ≫ specGal γ :=
  pullback.lift_snd _ _ _