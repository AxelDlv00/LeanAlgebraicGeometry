---
author: sync
content_type: definition
created: '2026-07-29T08:19:26'
decl: AlgebraicGeometry.leakProbe_wiringConsumed
docstring: '**THE WIRING IS CONSUMED, not merely stated** — the strongest line in
  this section.


  `alternatingCofaceComplexIsoOfDelta` applied to `twistedComponent` and `twistedComponent_δ_square`

  yields an actual isomorphism of alternating-coface complexes, on the single hypothesis

  `TwistedPerSigmaDeltaCompat`.  Measured because a degreewise family plus a proved
  square is not

  progress until the CONSUMER accepts them, and this workspace has repeatedly shipped
  interfaces that

  nothing could consume.  Clean.'
file: scripts/axiom-frontier.lean
generated: lean
lean_status: sorry
stale: true
title: AlgebraicGeometry.leakProbe_wiringConsumed
type: lean
updated: '2026-07-31T02:29:54'
---
noncomputable def leakProbe_wiringConsumed (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [Finite 𝒰.I₀]
    [IsSeparated f] [IsAffine S] [∀ i, IsAffine (𝒰.X i)]
    [Finite (bcCover f g f' g' h 𝒰).I₀]
    (F : X.Modules) (hF : F.IsQuasicoherent)
    (hcompat : TwistedPerSigmaDeltaCompat f g f' g' h 𝒰 F hF) :
    (AlgebraicTopology.alternatingCofaceMapComplex X'.Modules).obj
        (((CosimplicialObject.whiskering X.Modules X'.Modules).obj
          (Scheme.Modules.pullback g')).obj
          (CosimplicialObject.Augmented.drop.obj (CechNerve 𝒰 F)))
      ≅ (AlgebraicTopology.alternatingCofaceMapComplex X'.Modules).obj
          (CosimplicialObject.Augmented.drop.obj
            (CechNerve (bcCover f g f' g' h 𝒰) ((Scheme.Modules.pullback g').obj F))) :=
  twistedCechComplexIsoOfCompat f g f' g' h 𝒰 F hF hcompat

end Section6i

#print axioms leakProbe_wiringConsumed
#print axioms leakProbe_bareBC_mateElimination
#print axioms leakProbe_wiredDeltaSquare
#print axioms leakProbe_bcNerveCoface_sigma
#print axioms leakProbe_halfA_equiv
#print axioms leakProbe_twistedCompat_from_pullbackSide
#print axioms leakProbe_twistedCompat_from_counitSide
#print axioms leakProbe_counitSide_from_pullbackSide
-- CONTROLS for §6i, the same two as §6h.  They MUST still report `sorryAx`: no endpoint moved this
-- round, and if one of them comes back clean without the twisted square being discharged then the
-- probes above have stopped measuring the thing they are named for.
#print axioms twisted_cech_nerve_iso
#print axioms cech_flatBaseChange_oneLeaf

/-! ### §6j. BOTH MATES ELIMINATED; HALF (a) IS NOW A COHERENCE IDENTITY (run 0068 r6)

**Leading with what did NOT move, because §6h and §6i each had to say it and a longer clean list
invites the opposite reading: NO ENDPOINT MOVED THIS ROUND EITHER.**  `twisted_cech_nerve_iso` and
`cech_flatBaseChange_oneLeaf` still report `sorryAx`, and nothing that was contaminated before this
round became clean.  The project's `sorry` count is unchanged at 3.

What DID change is the *vocabulary* of the one open obligation.  §6i left half (a) as
`BcSquareNaturality`/`BcSquarePullbackSide`/`BcSquareCounitSide` — statements *about the
Beck–Chevalley mate*, and the file recorded for four rounds that nothing here or in mathlib relates
that mate across a change of square.  This round both mates are **eliminated**, and half (a) is
restated as `BcSquareCoherence`, in which `openImmersion_bareBC`, `bcv` and `mateEquiv` do not occur
at all.

The probes below are the new bricks and the reduction.  Each must be **clean**: they are theorems
*from* `BcSquareCoherence`, exactly as §6h's and §6i's probes are theorems from
`TwistedPerSigmaDeltaCompat` — a hypothesis, not a `sorry`.  The two controls must keep reporting
`sorryAx`.  If a control ever comes back clean without the twisted square being discharged, these
probes have stopped measuring what they are named for. -/

-- NOTE: the reduction itself (`BcSquareCoherence`, `bcSquareCounitSide_of_coherence`,
-- `twistedPerSigmaCompat_of_coherence`) lives in
-- `AlgebraicJacobian.Cohomology.CechTwistedCoherenceReduction`, NOT in
-- `CechHigherDirectImageUnconditional` — its proof unfolds two `asIso`-wrapped `IsIso` instances,
-- which is cheap against an olean and pathological when they are local declarations.  This script
-- must import that module for the last two probes below to resolve.

section Section6j

variable {S S' X X' : Scheme.{u}}