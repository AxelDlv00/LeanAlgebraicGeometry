---
author: sync
content_type: class
created: '2026-07-29T06:51:20'
decl: half
file: AlgebraicJacobian/Picard/Pic0ChartCoverageAbel.lean
generated: lean
lean_status: lean_ok
title: half
type: lean
updated: '2026-07-29T06:51:20'
---
class half alone has not supplied the datum — the Σ-component is what pins the chart point to
lie *over* the test, and it is free only because `W.ι ≫ a` is what `D.hom` must equal.

## THE CORRECTION THIS FILE CARRIES, against this lane's own headline

`Pic0ChartUnivReduce.lean:40` says of its `chartLocusOpens`:

> `chartLocusOpens` is **constructed**, not hypothesised — the `W` field costs zero, which is
> a real reduction of the datum from four fields to three

**The second clause is false, and the roadmap `c9b` row repeats it** ("`W` needs nothing").
`chartLocusOpens` takes an argument `haff`, the affine-local openness of the locus at every
affine open of the test, and *nothing in the tree discharges it*:
`isOpen_chartLocus_of_affineLocal'` (`Pic0ChartLocusIsoInvariance.lean`) removed the
`IsSplitWitnessIsoInvariant` hypothesis and passes `haff` straight through, as does
`isOpen_chartLocus_of_affineLocal` before it.  The affine case that would feed it is
`isOpen_setOf_isSplitWitness_of_presentation` (`Pic0ChartLocusIsOpen.lean:321`), which is
itself conditional on `IsChartDatumPresentation` — B-4's *named residue*.

**Update, same session** (`Picard/Pic0ChartPresentationConverse.lean`): that residue is now
*entirely witness-free*.  Its forward half already was (the trivial splitting), and its
converse `hconv` — the descent direction, open for three sessions — is discharged by plus-unit
injectivity.  So what `haff` ultimately costs is a `cechPicClass` base-change identity: no
witness, no `H¹`, no divisor, and nothing certificate- or divRep-gated.

So the honest accounting is: **`W` costs `haff`, which costs B-4's presentation residue.**  The
datum went from four fields to three *shapes* but not to three *obligations*.  What is
genuinely free is the type-level crossing above, and `chartLocusHaff` below is the residue
named so it cannot be lost again.

## Main declarations

* `AlgebraicGeometry.abelChartApp_eq` — the Abel chart's value at a point of the divisor
  scheme, as an explicit `Sigma.mk`.  Both components, since the datum needs both.
* `AlgebraicGeometry.ChartLocusAffineLocal` — the `haff` residue, named.  This is what
  `chartLocusOpens` silently costs.
* `AlgebraicGeometry.chartLocusOpens_of_affineLocal` — `chartLocusOpens` from it, so the
  dependency is explicit in the API rather than in an argument position.
* `AlgebraicGeometry.chartLocusAffineLocal_of_presentation` — the residue **reduced to B-4's
  own named obligation**: a per-affine-piece `IsChartDatumPresentation` gives it.  This is the
  link that was asserted in `Pic0ChartLocusIsOpen`'s docstring and never written.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

/-! ## The Abel chart's value, both components -/

/-- **The Abel chart map evaluated at a point of the divisor scheme.**

`abelSigmaChart` is `rep.toSigmaExtension ≫ Over.sigmaExtensionNat (chartValueTrans …)`, and
both factors act componentwise on the Σ-extension, so the value at `x : Y ⟶ D.left` is the
pair whose structure morphism is `x ≫ D.hom` and whose class is the chart value of the divisor
family `rep.homEquiv (Over.homMk x rfl)`.

Recorded as an equation because a coverage producer has to match this against a *given*
section, and the match is two equations rather than one: the Σ-components must agree before
the classes are even in the same type.  Leaving it to unfold at the use site is how the
Σ-component gets forgotten. -/
@[simp]