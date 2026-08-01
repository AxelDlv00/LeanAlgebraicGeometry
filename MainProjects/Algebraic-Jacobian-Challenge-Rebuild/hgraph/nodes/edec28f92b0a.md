---
author: sync
content_type: definition
created: '2026-08-01T13:18:07'
decl: Algebra.DescentDatum.coactionAlgHom
docstring: The algebra homomorphism underlying an algebra descent coaction.
file: AlgebraicJacobian/Descent/AlgebraDescent.lean
generated: lean
lean_status: lean_ok
title: Algebra.DescentDatum.coactionAlgHom
type: lean
updated: '2026-08-01T13:18:07'
---
noncomputable def coactionAlgHom (D : DescentDatum A B R) :
    R →ₐ[B] B ⊗[A] R :=
  AlgHom.ofLinearMap D.coaction D.coaction_one D.coaction_mul