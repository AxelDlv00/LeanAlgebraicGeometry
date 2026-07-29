---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: IsLocalization.AwayCover.tensorCollapse_piAssemblyUnit
docstring: '**The collapse of the assembled unit is the descent unit of the cover
  cocycle**

  (ζ2·ii, G6): if the componentwise units `w i j` collapse onto the values of a family

  `c i j : (T i j)ˣ` on the overlap models, then `Module.tensorCollapse` carries

  `piAssemblyUnit w` to `cocycleUnit c`.'
file: AlgebraicJacobian/Algebra/PiAssembly.lean
generated: lean
lean_status: lean_ok
stale: true
title: IsLocalization.AwayCover.tensorCollapse_piAssemblyUnit
type: lean
updated: '2026-07-29T15:26:36'
---
theorem tensorCollapse_piAssemblyUnit [Fintype ι] [DecidableEq ι]
    {w : ∀ i j, (S i ⊗[A] S j)ˣ} {c : ∀ i j, (T i j)ˣ}
    (hcol : ∀ i j, componentCollapse B f S T i j (w i j).val = (c i j).val) :
    Units.map (Module.tensorCollapse A B (∀ i, S i)).toRingHom.toMonoidHom
        (Algebra.TensorProduct.piAssemblyUnit A S w)
      = cocycleUnit f S T c := by
  apply Units.ext
  apply (piDoubleEquiv f S T).injective
  rw [piDoubleEquiv_cocycleUnit_val]
  change piDoubleEquiv f S T
      (Module.tensorCollapse A B (∀ i, S i) (Algebra.TensorProduct.piAssemblyUnit A S w).val)
    = fun p : ι × ι => (c p.1 p.2).val
  rw [piDoubleEquiv_tensorCollapse]
  funext p
  rw [Algebra.TensorProduct.piDoubleEquivA_piAssemblyUnit_val]
  exact hcol p.1 p.2