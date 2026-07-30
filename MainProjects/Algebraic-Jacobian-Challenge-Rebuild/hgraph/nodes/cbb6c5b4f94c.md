---
author: sync
content_type: theorem
created: '2026-07-20T01:31:14'
decl: AlgebraicGeometry.ThetaGeneratorSeed.sec_mem_ker_kColengthMap_comp_subtype
docstring: 'The seed section, viewed in `K`, is in the kernel of `f_z = kColengthMap
  z ∘ K.subtype`.

  The class of `⟨sec z, sec_mem z⟩` under `f_z` is `kColengthMap z (sec z) = 0`.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivClose.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ThetaGeneratorSeed.sec_mem_ker_kColengthMap_comp_subtype
type: lean
updated: '2026-07-30T15:28:04'
---
theorem sec_mem_ker_kColengthMap_comp_subtype (z : relCurve C R) :
    (⟨D.sec z, D.sec_mem z⟩ : ↥K) ∈
      LinearMap.ker ((D.kColengthMap z).comp K.subtype) := by
  rw [LinearMap.mem_ker, LinearMap.comp_apply, Submodule.subtype_apply]
  exact D.kColengthMap_sec_eq_zero z