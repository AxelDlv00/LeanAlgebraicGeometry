# Strategy-critic directive — iter-239 (slug ts239)

Read the strategy as a fresh mathematician. Challenge sunk cost. Your inputs are below; do NOT seek
iter-by-iter history.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): nine protected
declarations headed by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` — an
Albanese/Jacobian object uniform over the `k`-rational pointing of a smooth proper geometrically
irreducible curve `C/k` ([Field k] only; no C(k)≠∅, no CharZero). `J := Pic⁰_{C/k}` built
unconditionally; only `isAlbaneseFor` is quantified over the pointing. End-state: zero inline `sorry`
in the dependency cone of each protected decl, 0 project axioms, kernel-only axioms.

## STRATEGY.md (verbatim)

See `.archon/STRATEGY.md` (read it in full).

## References index

See `references/summary.md` (read it in full). Backing sources: Kleiman "The Picard scheme" (FGA),
Nitsure (Hilbert/Quot), Milne "Abelian Varieties", Mumford, Hartshorne, Stacks (modules/coherent/
constructions/divisors/varieties/fields/algebra).

## Blueprint chapter index (title — one line each)

Picard_TensorObjSubstrate (⊗ substrate A.1.c.SubT — group law DONE iter-238); Picard_LineBundlePullback
(line-bundle pullback A.1.b); Picard_RelPicFunctor (relative Picard functor + ét-sheafification A.1.c);
Picard_FGAPicRepresentability (FGA representability A.2.c); Picard_QuotScheme; Picard_RelativeSpec;
Picard_IdentityComponent; Picard_FlatteningStratification; Picard_Pic0AbelianVariety; Cohomology_*
(FlatBaseChange i=0, HigherDirectImage i≥1, MayerVietoris, SheafCompose, StructureSheaf{Ab,ModuleK});
Albanese_{AlbaneseUP, AuslanderBuchsbaum, CodimOneExtension, CoheightBridge, Thm32RationalMapExtension};
AbelianVarietyRigidity; Rigidity; RigidityKbar; RiemannRoch_* (PAUSED by user); Differentials; Genus;
Jacobian; AbelJacobi.

## What changed this iter (the specific thing to challenge)

1. A.1.c.SubT group law (`picCommGroup`, carrier = tensor-invertibility `IsInvertible`) landed
   axiom-clean iter-238 — phase marked DONE.
2. A.1.c (relative Picard functor) re-opened with a CORRECTED decomposition: the earlier "re-base the
   consumer onto `IsInvertible` is cheap" claim was found WRONG. The consumer (`OnProduct`/RPF) is phrased
   on line bundles (`IsLocallyTrivial`); connecting it to the `IsInvertible` group needs a real substrate
   lemma. Two routes were identified and **Route Y chosen**: re-base `OnProduct` onto `IsInvertible`,
   requiring `IsInvertible.pullback` (general pullback strong-monoidal — backbone Mathlib
   `(extendScalars f).Monoidal` + `sheafificationCompPullback`). Route X (build `IsLocallyTrivial ⟹
   IsInvertible`, i.e. locally-free-rank-1 ⟹ tensor-invertible via dual-gluing) rejected as harder/deferred.

## Questions for you
- Is the **Route Y vs Route X** decision sound? Is there a THIRD option (e.g. carry the relative functor
  directly on `IsInvertible` from A.1.b, never introducing `IsLocallyTrivial` as the OnProduct carrier)?
- Is `IsInvertible.pullback` via extension-of-scalars strong-monoidality the right backbone, or is there a
  cleaner abstract route (pullback as a strong-monoidal left adjoint already in Mathlib for these objects)?
- Does the overall A.1.c → A.2.c → A.4 arc still hold, given the group law is now real? Any sunk-cost
  structure (the deferred dual bridge, the held engine) that should be re-examined now that the carrier
  pivot is fully realized?
- The autoduality-RR-freeness open question (A.4) and the Route-1 RR-free fallback: still correctly
  deferred to "when A.2.c nears", or should it be verified sooner?

You must return SOUND / CHALLENGE / REJECT with explicit reasons; if you CHALLENGE, name the concrete
strategy edit you'd want.
