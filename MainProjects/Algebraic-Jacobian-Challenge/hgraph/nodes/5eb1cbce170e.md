---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.pullbackTensorPowIso
docstring: '**Pullback commutes with tensor powers**: `f^*(L^{⊗m}) ≅ (f^*L)^{⊗m}`,
  by

  induction on `m` from the unit case (`Modules.pullbackUnitIso`, proved

  sorry-free in `TensorObjSubstrate.lean`) and the binary case

  (`Modules.pullbackSheafTensorIso`, resting on the

  `Modules.pullbackTensorMap_isIso` leaf), the isomorphisms being pushed through

  the recursion `L^{⊗(m+1)} = L^{⊗m} ⊗ L` by the tensor congruence

  `Modules.sheafTensorObjCongr`.'
file: AlgebraicJacobian/Picard/QuotFunctorDef.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullbackTensorPowIso
type: lean
updated: '2026-07-16T21:14:27'
---
noncomputable def Modules.pullbackTensorPowIso {Z Y : Scheme.{u}} (f : Y ⟶ Z)
    (L : Z.Modules) :
    (m : ℕ) → ((Scheme.Modules.pullback f).obj (Modules.tensorPow L m) ≅
      Modules.tensorPow ((Scheme.Modules.pullback f).obj L) m)
  | 0 => Modules.pullbackUnitIso f
  | (m + 1) =>
      Modules.pullbackSheafTensorIso f (Modules.tensorPow L m) L ≪≫
        Modules.sheafTensorObjCongr (Modules.pullbackTensorPowIso f L m) (Iso.refl _)

set_option backward.isDefEq.respectTransparency false in