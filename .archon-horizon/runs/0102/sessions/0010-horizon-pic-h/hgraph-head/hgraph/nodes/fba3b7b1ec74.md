---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: Module.DescentDatum.projective_descended
file: AlgebraicJacobian/Descent/InvertibleModule.lean
generated: lean
lean_status: lean_ok
title: Module.DescentDatum.projective_descended
type: lean
updated: '2026-08-01T09:44:10'
---
theorem projective_descended [Module.Finite B M] [Projective B M] :
    Projective A D.descended := by
  have : Module.Finite B (B ⊗[A] D.descended) := Module.Finite.equiv D.descentEquiv.symm
  have : Projective B (B ⊗[A] D.descended) := Projective.of_equiv D.descentEquiv.symm
  exact Projective.of_projective_tensorProduct_of_faithfullyFlat A B D.descended