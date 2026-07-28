---
author: sync
content_type: theorem
created: '2026-07-29T06:00:33'
decl: PiTensorProduct.toUnder_algHomOfMkUnderHom
file: AlgebraicJacobian/Albanese/TensorPowerCofan.lean
generated: lean
lean_status: lean_ok
title: PiTensorProduct.toUnder_algHomOfMkUnderHom
type: lean
updated: '2026-07-29T06:00:33'
---
theorem toUnder_algHomOfMkUnderHom {B : Under k} (f : CommRingCat.mkUnder k A ⟶ B) :
    (algHomOfMkUnderHom k A f).toUnder = f := rfl

/-! ## §2. The cofan and its colimit property

Nothing here is new mathematics: `desc` is `coprodLift`, `fac` is
`coprodLift_comp_singleAlgHom`, and `uniq` is `PiTensorProduct.algHom_ext`. -/