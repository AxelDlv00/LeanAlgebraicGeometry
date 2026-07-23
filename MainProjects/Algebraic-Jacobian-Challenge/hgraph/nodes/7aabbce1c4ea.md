---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.Modules.pullbackKernelComparison_comp_
file: AlgebraicJacobian/Picard/FlatKernelBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullbackKernelComparison_comp_
type: lean
updated: '2026-07-24T03:02:10'
---
lemma Modules.pullbackKernelComparison_comp_ι
    {X' X : Scheme.{u}} (g' : X' ⟶ X) {E F : X.Modules} (q : E ⟶ F) :
    Modules.pullbackKernelComparison g' q ≫
        Limits.kernel.ι ((Scheme.Modules.pullback g').map q) =
      (Scheme.Modules.pullback g').map (Limits.kernel.ι q) :=
  kernelComparison_comp_ι q (Scheme.Modules.pullback g')