---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: CategoryTheory.shortExact_of_degreewise_splitting
docstring: 'A short complex of cochain complexes that is *degreewise split* (each
  degree carries a

  `ShortComplex.Splitting`) is short exact. Project-local because Mathlib only provides
  the

  degreewise-short-exact criterion `shortExact_of_degreewise_shortExact`; this packages
  the

  common special case where the degreewise data is a splitting.'
file: AlgebraicJacobian/Cohomology/AcyclicResolution.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.shortExact_of_degreewise_splitting
type: lean
updated: '2026-07-24T03:02:09'
---
lemma shortExact_of_degreewise_splitting
    {S : ShortComplex (CochainComplex 𝒜 ℕ)}
    (splits : ∀ n, (S.map (HomologicalComplex.eval 𝒜 (ComplexShape.up ℕ) n)).Splitting) :
    S.ShortExact :=
  HomologicalComplex.shortExact_of_degreewise_shortExact S (fun n => (splits n).shortExact)

omit [HasInjectiveResolutions 𝒜] in