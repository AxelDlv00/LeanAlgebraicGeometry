---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Pic0.finiteDimensional_cotangentSpace_of_locallyOfFiniteType
docstring: '**Sorry-free, scheme-general.** For a scheme locally of finite type over
  a

  field, the cotangent space at any point is finite-dimensional over the residue

  field — the local-Noetherianity input dimension arguments need.'
file: AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0.finiteDimensional_cotangentSpace_of_locallyOfFiniteType
type: lean
updated: '2026-07-16T21:14:27'
---
theorem finiteDimensional_cotangentSpace_of_locallyOfFiniteType {k : Type u} [Field k]
    (X : Over (Spec (.of k))) [LocallyOfFiniteType X.hom] (x : X.left) :
    FiniteDimensional (IsLocalRing.ResidueField (X.left.presheaf.stalk x))
      (IsLocalRing.CotangentSpace (X.left.presheaf.stalk x)) := by
  letI : IsLocallyNoetherian X.left := LocallyOfFiniteType.isLocallyNoetherian X.hom
  infer_instance