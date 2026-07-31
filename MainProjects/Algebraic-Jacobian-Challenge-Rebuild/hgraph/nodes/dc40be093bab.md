---
author: sync
content_type: theorem
created: '2026-07-29T06:51:20'
decl: AlgebraicGeometry.isChartDatumPlusFibreAt_self
docstring: '**`IsChartDatumPlusFibreAt` at `L := κ(t)` IS `IsChartDatumPlusFibre`
  at `t`** — by

  `Iff.rfl`, so the generalisation in `L` is a genuine generalisation of the *same*
  equation and

  not a different statement that happens to specialise.


  This is the upper half of the two-sided check on `hplus` below, and it is the sharp
  one: it shows

  the extra strength of `hplus` over `hfib` is exactly "the same identity at every
  extension", so a

  lane reading `hplus` knows precisely what it owes beyond `hfib` — the naturality
  of `cechPicClass`

  along `κ(t) → L`, and nothing else.


  **The lower half was measured too, and is recorded here because it cannot be a theorem.**  A

  reduction whose new hypothesis is *satisfiable by construction* is vacuous, and
  `D` in

  `IsChartDatumPlusFibreAt` is chosen by the consumer — exactly the configuration
  in which that

  happens.  Probed at arbitrary `μ`, `D`, `t`, `L`: `rfl` fails on the left-hand side,
  and `simp`

  and `aesop` both leave unsolved goals.  So it is a genuine equation between two
  plus classes and

  not a `Prop` true for free.  (A passing automation attempt would have refuted the
  reduction, which

  is why the probe is worth running before pricing anything as a residue.)


  **And the probe has a second form, which the first does not cover.**  Junk-inhabitation
  is the risk

  when the hypothesis is *consumer-chosen* — `D` here.  When it is *determined* by
  the setting, the

  mirror risk is **unsatisfiability**: a reduction to a false hypothesis passes every
  `sorry` census

  and every axiom probe, because it then *is* a theorem.  `hplus` is determined in
  `μ`, so that

  direction needs a witness, and the witness is landed and unconditional:

  `exists_splitting_of_picEt` produces, for **any** plus class over **any** reading
  field, a finite

  separable `L` and a presenting class `M` with exactly the identity `hplus` asserts.  So
  the

  plus-class identity is *inhabited* at every `μ`, not merely consistent.'
file: AlgebraicJacobian/Picard/Pic0ChartPresentationConverse.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.isChartDatumPlusFibreAt_self
type: lean
updated: '2026-07-31T20:14:51'
---
theorem isChartDatumPlusFibreAt_self {A : Type u} [CommRing A] [Algebra k A]
    (μ : picEt C (overSpec k A)) (D : BasicOpenCocycleDatum C A π)
    (t : (overSpec k A).left) (h : IsChartDatumPlusFibre C π μ D) :
    IsChartDatumPlusFibreAt C π μ D t (Over.testPointField (T := overSpec k A) t) :=
  h t

/-! ## CHART-U(b)'s residue, assembled -/

variable (C π) in