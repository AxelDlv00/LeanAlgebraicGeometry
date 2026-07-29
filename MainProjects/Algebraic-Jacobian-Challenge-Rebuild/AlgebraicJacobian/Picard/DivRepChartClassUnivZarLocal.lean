/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivRepChartClassUnivQuot
import AlgebraicJacobian.Picard.DivSchemeCertZarPointwise

/-!
# U2's class half is not refuted: the no-go's `∀` and the pin's `∃` are different binders

`Picard/DivRepChartClassUnivAny.lean:223-231` carries a warning that the roadmap leaf
`…divrep.u2` and three inbox items have since quoted as the leaf's price:

> the hypothesis `HasCertifiedAdaptation` is **refuted** by
> `forall_not_isCertified_of_straddling` … So this theorem is a sound *reduction* whose
> hypothesis may be false; do not read it as "U2 is one certificate away".

The warning is correct about `HasCertifiedAdaptation`.  **It does not transfer to the object
U2 actually needs**, and this file measures the gap.

## The measurement

What U2 owes, after `Picard/DivRepChartRange.lean` turned the clause into an equation, is a
term of `DivFamZar C R_Z π g` — i.e. `DivFamZar.mk` of the seed's system together with
`IsLocallyCertified` (`Picard/DivisorFamilyZar.lean:71`).  Read that definition rather than
its summary: its certificates live over `Localization.Away (g i)`, for a span-`⊤` family in
the base, with the system **pulled back**.  The no-go concludes `∀ A n, ¬ A.IsCertified n`
for adaptations over the base itself.

So the two statements quantify over adaptations on **different rings**, and the direction
the tree actually carries between them is

> `isLocallyCertified_of_isCertified` :
> `(D.divisorAdaptation hD).IsCertified n → IsLocallyCertified …`

i.e. **the refuted side implies the pin**.  Refuting the antecedent of an implication says
nothing about its conclusion, so the no-go leaves `IsLocallyCertified` untouched.  That is
not a subtlety about this seam; it is modus ponens run backwards, and it has been priced
into the leaf since the warning was written.

## What this file lands

The per-prime route already in the tree
(`ThetaGeneratorSeed.isLocallyCertified_of_forall_prime_exists_certified_adaptation`,
`Picard/DivSchemeCertZarPointwise.lean:162`) produces the pin from away-localized
certificates.  Instantiated at the high-window universal seed it gives U2's class half from
a hypothesis that is **not** an instance of the refuted `∀` — and, composed with the
ε-identity of `Picard/DivRepChartClassUnivQuot.lean`, U2's *whole* per-chart obligation.

## Main declarations

* `AlgebraicGeometry.PointwiseAchiever.divFamZarUnivOfForallPrimeAway` — the `DivFamZar`
  class at the universal point from per-prime away certificates.
* `AlgebraicGeometry.PointwiseAchiever.ForallPrimeAwayCertified` — the replacement
  hypothesis, stated so that the ring each adaptation lives over is visible in the binder.
* `AlgebraicGeometry.ThetaGeneratorSeed.isLocallyCertified_of_isCertified_not_conversely`
  — the direction record: the refuted side implies the pin, which is why the refutation
  does not propagate.

## What this does NOT do, stated exactly

It produces **no certificate**, at no prime, so **no gate clears** and `rep` remains
undischarged.  What changes is which statement a producer must target, and it is strictly
weaker than the one the leaf records: a certificate over some `Localization.Away r` per base
prime, rather than one over the whole chart ring.

**The hypothesis is not thereby known satisfiable, and this file does not claim it is.**  The
no-go's own geometry is the reason to expect the away form to be the right target — it bites
when the support meets both pinned fibres, and the support tube
(`Scheme.LocalEquations.exists_basicOpen_supportTube`) exists precisely to isolate the support
after shrinking the base — but *nothing here composes the tube with a certificate*, and until
something does, the away hypothesis has no witness at any prime either.  So: the class half is
**open, not refuted**.  Those are different claims and only the second one is what this file
establishes.
-/

set_option autoImplicit false
set_option quotPrecheck false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 8
set_option maxRecDepth 16000
set_option linter.unusedSectionVars false

universe u

open CategoryTheory Limits TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

open Scheme Grassmannian ThetaGeneratorSeed

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
  Scheme.functionFieldOverModule
attribute [local instance 10000] relCurve.instOver

/-! ## The direction record -/

namespace ThetaGeneratorSeed

section Direction

variable {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))} [IsProper C.hom]
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k} [IsFinite π] {a : ℕ}
variable {K : Submodule R (relThetaSections C R π a)}

/-- **The refuted side implies the pin** — the whole reason
`forall_not_isCertified_of_straddling` does not bear on U2's class half.

This is `isLocallyCertified_of_isCertified` restated with its role named.  The point is the
*direction*: a refutation of `(D.divisorAdaptation hD).IsCertified n` is a refutation of this
theorem's **hypothesis**, and an implication whose hypothesis is false is still true and says
nothing about its conclusion.  Stated here because the leaf's recorded price reads the
refutation as though it travelled forwards. -/
theorem isLocallyCertified_of_isCertified_not_conversely [IsNoetherianRing R] {n : ℕ}
    {D : ThetaGeneratorSeed C R π a K} (hD : D.IsGenerator)
    (hc : (D.divisorAdaptation hD).IsCertified n) :
    IsLocallyCertified C R π n (D.localEquations hD) :=
  D.isLocallyCertified_of_isCertified hD hc

end Direction

end ThetaGeneratorSeed

namespace PointwiseAchiever

section ZarLocalUniversal

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {pi : C.left ⟶ P1 k} [IsFinite pi] [IsDominant pi]

noncomputable local instance instOverCleftUnivZarLocal :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))]
  [QuasiCompact (C.left ↘ Spec (.of k))]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g r1 r2 : Nat)
variable (b1 : Module.Basis (Fin r1) k
  ↥(Scheme.divisorSections k
    (windowM_choice pi hpi g • fiberWeilDivisor pi) ⊤))
variable (b2 : Module.Basis (Fin r2) k
  ↥(Scheme.divisorSections k
    ((windowS_choice pi hpi g • fiberWeilDivisor pi) +
      (windowM_choice pi hpi g • fiberWeilDivisor pi)) ⊤))
variable (i : (glueData k g r1).J) (j : (glueData k g r2).J)
variable (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
  (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))

local notation "RZ" => DivCarveChartRing k
  (windowS_choice pi hpi g • fiberWeilDivisor pi)
  (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1 b2 i j

/-- Abbreviation for the universal seed's local-equation system, so the away hypothesis
below can be stated without repeating the generator clause four times. -/
noncomputable abbrev univSystem (hb : 0 < windowBound pi hpi) :
    (relCurve C RZ).LocalEquations :=
  (univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).localEquations
    (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)

/-- **The per-prime away hypothesis**, named: at every prime of the chart ring some basic
open carries a certified chart-typed adaptation of the *pulled* universal system.

This is the hypothesis that replaces `HasCertifiedAdaptation`.  It is not an instance of
`forall_not_isCertified_of_straddling`'s `∀`: that quantifier ranges over adaptations of the
system over `R_Z` itself, while every adaptation here lives over a `Localization.Away r` and
adapts the pullback along `relCurveMap`. -/
def ForallPrimeAwayCertified [IsNoetherianRing RZ] (hb : 0 < windowBound pi hpi) : Prop :=
  ∀ p : PrimeSpectrum RZ, ∃ r, r ∉ p.asIdeal ∧
    haveI : IsOpenImmersion (relCurveMap C RZ (Localization.Away r)) :=
      isOpenImmersion_relCurveMap_away C RZ (Localization.Away r) r
    ∃ A : DivisorAdaptation C (Localization.Away r) pi
        ((univSystem C hpi g r1 r2 b1 b2 i j hO hchi hb).pullback
          (relCurveMap C RZ (Localization.Away r))
          (Scheme.LocalEquations.germ_pullbackEqn_mem_nonZeroDivisors_of_isOpenImmersion
            (relCurveMap C RZ (Localization.Away r))
            (univSystem C hpi g r1 r2 b1 b2 i j hO hchi hb))),
      A.IsCertified g

/-- **U2's class half from the away hypothesis** — the locally certified class over the
`Z(♦)`-chart ring, with no certificate over `R_Z` anywhere in the input. -/
noncomputable def divFamZarUnivOfForallPrimeAway [IsNoetherianRing RZ]
    (hb : 0 < windowBound pi hpi)
    (h : ForallPrimeAwayCertified C hpi g r1 r2 b1 b2 i j hO hchi hb) :
    DivFamZar C RZ pi g :=
  (univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).divFamZar_of_forall_prime_away_certified
    (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)
    (fun p => by
      obtain ⟨r, hrp, A, hA⟩ := h p
      haveI : IsOpenImmersion (relCurveMap C RZ (Localization.Away r)) :=
        isOpenImmersion_relCurveMap_away C RZ (Localization.Away r) r
      exact ⟨r, hrp, ⟨_, A, hA⟩, Scheme.LocalEquations.divEq_refl _⟩)

end ZarLocalUniversal

end PointwiseAchiever

end AlgebraicGeometry
