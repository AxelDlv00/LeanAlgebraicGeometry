/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroRep
import AlgebraicJacobian.Picard.Pic0ChartSubsingletonCollapse
import AlgebraicJacobian.Picard.Pic0AtlasFromDivRep

/-!
# THE DEGREE-ZERO `rep` PRODUCER, APPLIED — two unconditional use sites

`divFunctorZeroRepresentableBy` (`Picard/DivisorFamilyDegreeZeroRep.lean`) is sorry-free and
axiom-clean, and neither fact makes it a *producer*.  The workspace has a standing lesson for
exactly this (`axiom-clean-vs-applicable`): a term whose binders cannot be met at a real
consumer, or whose consumer lives in a module that cannot import it, is a statement about
elaboration rather than a discharge.  This file is the test, and it is stated as theorems so
the test cannot silently rot.

## What is discharged here

* `divFunctorObjSubsingleton_zero` — pic-c's `DivFunctorObjSubsingleton C π 0`, the antecedent
  their whole `abel-noninj` collapse is quantified over, is now **unconditionally true**.  It
  was reachable only through `divFunctorObjSubsingleton_of_forall_ring`, whose hypothesis is
  the general-`R` subsingleton — i.e. precisely the question
  `Picard/DivisorFamilyDegreeZeroUnique.lean` recorded as open.
* `abelSigmaChartZero` — the Abel chart at parameter `0`, built with no `rep` hypothesis in
  its signature.  Every earlier `abelSigmaChart` in the tree carries `rep` as a binder; this
  one does not, because the producer supplies it.

Both are *unconditional in the curve's own binders*: no field extension, no test-ring
hypothesis, no chart typing, no coverage datum.

## What these use sites do NOT show

They do not make the chart part of a working atlas.  `not_mem_chartLocus_of_two_le_genus_zero_param`
(same import, pic-c's file) proves the chart locus at `n = 0` is empty once `g ≥ 2`, so this
chart's locus — the thing coverage would have to reach — is *provably empty* in the interesting
genus range.  The chart exists and is honest; what it cannot do is be covered.

That is the joint state to carry forward: the `rep` slot is inhabited at the one parameter where
coverage is impossible, and coverage is unconditional at the one parameter where `rep` has no
producer.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]

/-- **pic-c's subsingleton antecedent is unconditionally true at parameter `0`.**

`DivFunctorObjSubsingleton` (`Picard/Pic0ChartSubsingletonCollapse.lean`) is the hypothesis of
the `abel-noninj` collapse — the Abel chart being a monomorphism, `D` terminal, the `V`-interval
degenerating to `{⊥, ⊤}`.  It had no producer.  The bridge
`divFunctorObjSubsingleton_of_forall_ring` reduces it to the subsingleton at every `k`-algebra,
which is `instSubsingletonDivFamZarZeroGeneral`. -/
theorem divFunctorObjSubsingleton_zero
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    DivFunctorObjSubsingleton C pi 0 :=
  divFunctorObjSubsingleton_of_forall_ring C pi 0
    (fun _ _ _ => instSubsingletonDivFamZarZeroGeneral)

/-- **The Abel chart at parameter `0`, with NO `rep` binder.**

Compare `abelSigmaChart` (`Picard/Pic0AtlasFromDivRep.lean:205`), which takes
`rep : (divFunctor C π n).RepresentableBy D` as a hypothesis: every chart in the tree until now
was a chart *shape*, contingent on an input nothing produced.  Here the representing object is
the terminal object of the slice and the representation is
`divFunctorZeroRepresentableBy`.

This is the applicability test for the producer, at the exact consumer whose signature the
campaign is organised around. -/
noncomputable def abelSigmaChartZero
    [IsIntegral (C ⊗ overSpec k k).left]
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (0 : ℕ)) :
    yoneda.obj (Over.mk (𝟙 (Spec (CommRingCat.of k)))).left ⟶ (pic0SigmaSheaf C).1 :=
  abelSigmaChart C pi 0 divFunctorZeroRepresentableBy m Z hdeg

end AlgebraicGeometry
