---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: Algebra.EtaleCover.baseChange
docstring: 'The base change of a cover along `A → A''`: the cover of `Spec A''` with
  carrier

  `A'' ⊗[A] E.Carrier` (the fiber product of the covering spectrum with the new base).'
file: AlgebraicJacobian/Algebra/EtaleCover.lean
generated: lean
lean_status: lean_ok
stale: true
title: Algebra.EtaleCover.baseChange
type: lean
updated: '2026-07-29T15:26:39'
---
noncomputable def baseChange (E : EtaleCover A) : EtaleCover A' :=
  .of (A' ⊗[A] E.Carrier) PrimeSpectrum.comap_surjective_of_faithfullyFlat