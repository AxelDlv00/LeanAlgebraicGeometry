/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivSchemeHighWindowSecondContainment
import AlgebraicJacobian.Picard.DivSchemeEps
import AlgebraicJacobian.Picard.DivisorThetaFibreData

/-!
# U2's ε-identity at the universal point, from the certificate alone

The DDR9-U ε-identity (`informal/w4-ddr9-worksheet.md` §3.1 U2) asks that the
tautological pair-chart data at the universal point satisfy the ε-identity: over the
`Z(♦)`-chart ring `R_Z`, the certified family of the universal seed has

> `ε = (x₁, x₂)`  with  `x₁ = divUniversalFstWindow`, `x₂ = divUniversalSndWindow`

the universal tautological pair.  This file discharges that identity from **one**
hypothesis, `IsCertified`, having found that the other three inputs of the landed
ε-projection identity are already available at the universal point.

## What was already landed, and had not been composed

`ThetaGeneratorSeed.divFamEps_certifiedFamily` (`Picard/DivSchemeEps.lean`) takes four
inputs beyond the seed: a generator clause `hD`, a certificate `hc`, two `thetaGluedEval`
surjectivities, and the second-window containment `hle₂`.  At the universal point:

* **`hD` is free** — `PointwiseAchiever.isGenerator_highWindowPointwiseGeneratorSeed`
  (`Picard/DivSchemeHighWindowPointwiseGenerator.lean`) is a generator clause for the
  seed at `K = divUniversalSeedK`, over `R_Z` itself, from `hO`, `hχ` and
  `hb : 0 < windowBound π hπ` only.  It routes through `pointwiseSeedRDN_of_highWindow`,
  so it needs **no** germ-divisibility input: it is *not* `isGenerator_seedUniv'`, which
  is the seed whose RD-N hypothesis is the recorded geometric wall (I-0302 §residual
  2b/2c).  Two different seeds over the same ring, and only one of them is gated.
* **`hle₂` is free** — `PointwiseAchiever.divUniversalSndWindow_le_highWindow_divisorWindow`
  (`Picard/DivSchemeHighWindowSecondContainment.lean`) is exactly the second-window
  containment *for this seed*, from the same three hypotheses.
* **both surjectivities are free given `hc`** —
  `DivisorAdaptation.IsCertified.thetaGluedEval_surjective`
  (`Picard/DivisorThetaFibreData.lean`) derives them from the certificate itself, at any
  window `≥ M` with the ledger `H¹` input.  The second window is `M + s ≥ M`.

So the ε-identity at the universal point is a **corollary of the certificate**, and the
composition is what this file records.  Nothing here is new mathematics; what is new is
that the four inputs are the *same* seed's, which is why the composite had not been
formed — the generator and containment lemmas live in the 44-file `DivSchemeHighWindow*`
family, which is sorry-free but was **not reachable from the root aggregator**, so no
root-target measurement ever saw them (the failure mode of inbox `I-0362`, at
44-file scale, on the critical path).

## Main declarations

* `AlgebraicGeometry.PointwiseAchiever.divFamEps_highWindow_eq_universal_pair` — **the
  DDR9-U ε-identity at the universal point**: `ε` of the certified family of the
  high-window universal seed is the universal tautological pair.  One hypothesis beyond
  the ambient ledger data: the certificate.
* `AlgebraicGeometry.PointwiseAchiever.exists_certifiedFamily_divFamEps_eq_universal_pair`
  — the existential form, which is what a chart-class producer consumes.

## What this does NOT do

It produces no certificate, hence no `DivFamZar` over `R_Z` and no `IsChartClause`: the
`IsCertified` input is the standing G-4 obligation and is the widened certificate lane's
endpoint (`exists_isCertified_of_swallowing_affineOpen`, inbox `I-0565`).  U2 remains
unproved.  What changes is that its ε-identity half is no longer an obligation at all —
the debt is exactly a certificate at the universal point, with `0 < windowBound π hπ`
as a scalar side condition.
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

namespace PointwiseAchiever

section UniversalEpsIdentity

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {pi : C.left ⟶ P1 k} [IsFinite pi] [IsDominant pi]

noncomputable local instance instOverCleftDivRepChartClassUniv :
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

/-- The high-window universal seed, abbreviated: the theta generator seed over the
`Z(♦)`-chart ring at the universal first-window seed module `K_univ`. -/
noncomputable abbrev univSeed (hb : 0 < windowBound pi hpi) :
    ThetaGeneratorSeed C RZ pi (windowM_choice pi hpi g)
      (divUniversalSeedK C pi hpi g r1 r2 b1 b2 i j) :=
  highWindowPointwiseGeneratorSeed C hpi g r1 r2 b1 b2 i j hO hchi hb

/-- The generator clause of `univSeed`, which is free at the universal point. -/
theorem isGenerator_univSeed (hb : 0 < windowBound pi hpi) :
    (univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).IsGenerator :=
  isGenerator_highWindowPointwiseGeneratorSeed C hpi g r1 r2 b1 b2 i j hO hchi hb

set_option maxHeartbeats 2400000 in
-- The composite instantiates the ε-projection identity at the universal windows over the
-- heavy `DivCarveChartRing` / `relThetaSections` types; same profile as the two inputs.
set_option synthInstance.maxHeartbeats 800000 in
/-- **The DDR9-U ε-identity at the universal point, from the certificate alone**
(`informal/w4-ddr9-worksheet.md` §3.1 U2, the ε half).

`ε` of the certified family of the high-window universal seed **is** the universal
tautological pair `(divUniversalFstWindow, divUniversalSndWindow)`.

Every input of `ThetaGeneratorSeed.divFamEps_certifiedFamily` other than the certificate
is discharged at the universal point:

* the generator clause by `isGenerator_highWindowPointwiseGeneratorSeed` — note this is
  the *high-window pointwise* seed, whose RD-N comes from `pointwiseSeedRDN_of_highWindow`
  and therefore needs **no** germ-divisibility input, unlike `seedUniv'`;
* the two `thetaGluedEval` surjectivities by
  `DivisorAdaptation.IsCertified.thetaGluedEval_surjective`, from the certificate itself
  (the second window `M + s` is `≥ M`);
* the second-window containment by
  `divUniversalSndWindow_le_highWindow_divisorWindow`, for this very seed.

`divUniversalSeedK` is by construction the submodule parameter the ε-projection identity
asks for at `x₁ = divUniversalFstWindow` (`Picard/DivSchemeSeedUniv.lean`), which is what
makes the instantiation type-correct with no transport. -/
theorem divFamEps_highWindow_eq_universal_pair (hb : 0 < windowBound pi hpi)
    (hc : ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).divisorAdaptation
      (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)).IsCertified g) :
    divFamEps hpi g (DivFam.mk
        ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).certifiedFamily g
          (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb) hc))
      = ((divUniversalFstWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule,
         (divUniversalSndWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule) :=
  ThetaGeneratorSeed.divFamEps_certifiedFamily hpi
    (divUniversalFstWindow C pi hpi g r1 r2 b1 b2 i j)
    (divUniversalSndWindow C pi hpi g r1 r2 b1 b2 i j)
    (univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)
    (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb) hc
    (hc.thetaGluedEval_surjective hO hchi
      (relThetaPairH1_windowM C pi hpi g) le_rfl)
    (hc.thetaGluedEval_surjective hO hchi
      (relThetaPairH1_windowMS C pi hpi g) (Nat.le_add_right _ _))
    (divUniversalSndWindow_le_highWindow_divisorWindow
      C hpi g r1 r2 b1 b2 i j hO hchi hb)

/-- **The existential form**, which is what a chart-class producer consumes: a certificate
at the universal point yields a certified divisor family over the `Z(♦)`-chart ring whose
`ε` pair is the universal tautological pair.

This is the shape U2 needs, because `IsDivRepClassify`'s framing clauses are stated as
equalities between `Module.Grassmannian.map ω (pairTautFst/Snd)` and the coordinate image
of `divFamEps`, and the universal windows are by definition (`divUniversalFstWindow`,
`divUniversalSndWindow` in `Picard/DivSchemeSeedUniv.lean`) the `congrAmbient` transports
of `divUniversalFst/Snd`, i.e. of `pairTautFst/Snd` pushed along the quotient
presentation `divCarveChartMk`. -/
theorem exists_certifiedFamily_divFamEps_eq_universal_pair (hb : 0 < windowBound pi hpi)
    (hc : ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).divisorAdaptation
      (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)).IsCertified g) :
    ∃ G : CertifiedDivisorFamily C RZ pi g,
      divFamEps hpi g (DivFam.mk G)
        = ((divUniversalFstWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule,
           (divUniversalSndWindow C pi hpi g r1 r2 b1 b2 i j).toSubmodule) :=
  ⟨_, divFamEps_highWindow_eq_universal_pair C hpi g r1 r2 b1 b2 i j hO hchi hb hc⟩

/-- **The `DivFamZar` class of the universal point**, from the same certificate: the
locally certified class over the `Z(♦)`-chart ring that U2 asks a producer to exhibit.
A global certificate is a local one through the trivial one-member cover
(`CertifiedDivisorFamily.isLocallyCertified`), so no Zariski shrinking is needed here. -/
noncomputable def divFamZarUniv (hb : 0 < windowBound pi hpi)
    (hc : ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).divisorAdaptation
      (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)).IsCertified g) :
    DivFamZar C RZ pi g :=
  DivFamZar.mk
    ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).certifiedFamily g
      (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb) hc).eqns
    ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).certifiedFamily g
      (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb) hc).isLocallyCertified

end UniversalEpsIdentity

end PointwiseAchiever

end AlgebraicGeometry
