---
author: sync
content_type: theorem
created: '2026-07-17T21:17:13'
decl: AlgebraicGeometry.JacobianData.comp_pullbackHom
docstring: 'The action of `pullbackHom` on test points, `symm` form: composition with
  the

  underlying morphism `(pullbackHom dX dY g).hom.hom : dY.J ⟶ dX.J` sends the morphism

  classified by a degree-zero class `λ` to the morphism classified by

  `pic0Pullback g T λ`.'
file: AlgebraicJacobian/Picard/Pic0PullbackGrp.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.JacobianData.comp_pullbackHom
type: lean
updated: '2026-07-30T15:46:05'
---
theorem comp_pullbackHom (dX : JacobianData X) (dY : JacobianData Y) (g : X ⟶ Y)
    {T : Over (Spec (.of k))} (f : T ⟶ dY.J) :
    f ≫ (pullbackHom dX dY g).hom.hom
      = dX.homEquiv.symm (pic0Pullback g T (dY.homEquiv f)) := by
  letI := dX.grpObj
  letI := dY.grpObj
  exact congrArg
    (fun (α : yonedaGrpObj dY.J ⟶ yonedaGrpObj dX.J) => (α.app (op T)) f)
    (yonedaGrp_map_pullbackHom dX dY g)