---
author: sync
content_type: theorem
created: '2026-07-28T12:23:40'
decl: until
file: AlgebraicJacobian/Albanese/AlbaneseUP.lean
generated: lean
lean_status: sorry
stale: true
title: until
type: lean
updated: '2026-07-29T11:05:50'
---
theorem until they close.

### Read this first: the mathematics is proved *elsewhere in this directory*

The six obligations below are stated against `SymmetricPower`, which is a
`sorry`-**bodied definition**. An equation between morphisms out of a junk term
carries no information, so these six cannot be discharged, and discharging them
would establish nothing. They are kept because they pin the challenge's intended
statement shape, not because they are the work.

Milne's argument itself **is** proved, over the symmetric power taken as an
*interface* rather than a `sorry`:

* `Albanese/SymPowInterface.lean` — `SymPowData C n` (carrier, symmetrisation
  projection, universal property), and everything Milne derives from it:
  `SymPowData.symAVMap` (his `Sym^n φ`, now a **construction**),
  `MonObj.basePointShift_comp_powSum` (the collapse behind "use `φ(P₀) = η_A`"),
  and `symPowDataOne` — which **inhabits** the interface (`Sym^1 C = C`), so
  statements quantifying over it are not vacuous.
* `Albanese/AlbaneseFromData.lean` — the connector in **both** directions and the
  universal property assembled over the interface. Worth knowing: the backward
  direction needs neither the quotient property nor that `ψ` is a homomorphism;
  only the forward direction does.
* `Albanese/AVSelfProduct.lean` — commutativity of an abelian variety and pointed
  rigidity, on the project's four-instance package.
* `Albanese/AlbaneseJacobian.lean` — the instantiation at `Pic⁰_{C/k̄}`, plus a
  machine check attributing its `sorryAx` entirely to the Picard seam: the same