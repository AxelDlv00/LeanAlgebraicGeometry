---
author: sync
content_type: lemma
created: '2026-07-29T05:13:20'
decl: AlgebraicGeometry.ThetaGeneratorSeed.below
file: AlgebraicJacobian/Picard/DivisorFamilyAffSeedGate.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.ThetaGeneratorSeed.below
type: lean
updated: '2026-07-29T11:07:21'
---
lemma below as *"the gate is not about nothing"*, never as *"the gate is non-trivially
inhabited"*.

What is known about `n > 0` is unchanged by this file: the gate fires whenever the degree datum is
supplied at that `n`, and nothing in the hypothesis set forces `n = 0`; supplying that datum from
geometry at a specific `n > 0` is the seed layer's business.  The genuinely non-vacuous witness
would need a straddling divisor, which exists over every field (spec ADDENDUM 4 §4.3) but is out
of scope to formalise (§4.5 — it needs `Sym^g C`).  Cf. `DivisorFamilyAffStrict.lean`, whose
strictness theorem carries the identical caveat for the identical reason. -/