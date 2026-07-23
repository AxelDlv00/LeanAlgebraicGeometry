---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicJacobian.GaloisDescent.SemilinearAction.extendScalarsAlgHom
docstring: 'Extension of scalars of a `K`-algebra map on the invariants, through the
  descent

  isomorphism: `A ≃ L ⊗ A^Γ → L ⊗ B`.'
file: AlgebraicJacobian/Picard/GaloisDescent/SemilinearAlgebras.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearAction.extendScalarsAlgHom
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def extendScalarsAlgHom (g : invariantsSubalgebra K L A →ₐ[K] B) :
    A →ₐ[L] L ⊗[K] B :=
  (Algebra.TensorProduct.map (AlgHom.id L L) g).comp
    (descentAlgEquiv K L A).symm.toAlgHom