---
author: sync
content_type: theorem
created: '2026-07-17T21:31:16'
decl: AlgebraicGeometry.mem_pic0Subgroup_picEtCrossBase_iff
docstring: '**The degree-zero restriction of the componentwise lift** (the B-4a →
  B-4b

  handshake discharged): an étale Picard class of `C` on the pushed test and its

  componentwise lift to `C_L` are simultaneously degree-zero.'
file: AlgebraicJacobian/Picard/Pic0ThetaAssembly.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mem_pic0Subgroup_picEtCrossBase_iff
type: lean
updated: '2026-08-01T09:44:16'
---
theorem mem_pic0Subgroup_picEtCrossBase_iff
    (s : picEt C ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).obj T)) :
    s ∈ pic0Subgroup C
        ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k L)))).obj T)
      ↔ picEtCrossBase k L C T s ∈ pic0Subgroup ((baseChange k L).obj C) T :=
  mem_pic0Subgroup_iff_of_degAt_pushFieldPoint_eq C
    (fun _ _ _ _ _ t => degAt_pushFieldPoint_picEtCrossBase k L C s t)

end DegAtMatching

/-! ## The degree-zero subgroup comparison -/