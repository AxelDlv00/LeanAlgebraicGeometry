# strategy-critic sc258

Fresh-eyes critique of the project strategy. You have NO iter history — judge the strategy on its merits.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): nine protected
declarations headed by `AlgebraicGeometry.Jacobian` + `Jacobian.nonempty_jacobianWitness` — an
Albanese/Jacobian object uniform over the `k`-rational pointing of a smooth proper geometrically
irreducible curve `C/k` (`[Field k]` only). `J := Pic⁰_{C/k}` built unconditionally; `isAlbaneseFor`
quantified over the pointing. End-state: zero inline `sorry` in each protected decl's cone, 0 project
axioms, kernel-only axioms.

## STRATEGY.md (verbatim)
(Read it at `.archon/STRATEGY.md` — just updated this iter with a NEW phase row "SHARED ROOT —
`SheafOfModules.overEquivalence`" and a gap bullet. The pivot: iter-257 found the A.2.c-engine entry
`chartOverIso` AND the A.1.c.sub dual `sliceDualTransport` BOTH reduce to one missing construction —
the modules-level lift of `Opens.overEquivalence` with the structure-ring-sheaf transported. The plan
makes building that shared root the primary lane this iter.)

## References index
See `references/summary.md` (Kleiman "Picard scheme" FGA, Nitsure FGA Quot/Hilbert, Milne "Abelian
Varieties", Mumford, Stacks tags varieties/fields/algebra/coherent/constructions).

## Blueprint chapter topics (one line each)
- Picard_TensorObjSubstrate: `Scheme.Modules.tensorObj` substrate (A.1.c) — pullback-monoidality (D1–D4),
  dual/inverse, the slice-site equivalences.
- Picard_LineBundleCoherence: coherence of locally trivial line bundles (`IsLocallyTrivial⟹IsFinitePresentation`).
- Picard_LineBundlePullback / RelPicFunctor / FGAPicRepresentability / QuotScheme / RelativeSpec /
  FlatteningStratification / IdentityComponent / Pic0AbelianVariety: the Route-A Picard arc.
- Cohomology_CechHigherDirectImage: Čech `Rⁱf_*` (i≥1), unconditional project build.
- Cohomology_FlatBaseChange / HigherDirectImage / MayerVietoris / StructureSheaf*: cohomology engine.
- Albanese_* / AbelianVarietyRigidity / Rigidity / RigidityKbar: A.4 Albanese UP (Route 1, RR-free).
- RiemannRoch_* / Genus* / AbelJacobi / Jacobian: paused (Route C) + goal nodes.

## Questions for you
1. Is making `SheafOfModules.overEquivalence` (the shared root) the primary lane this iter the right
   prioritization, given it unblocks BOTH the A.2.c-engine deliverable (`IsFinitePresentation`) and the
   A.1.c.sub dual inverse (`exists_tensorObj_inverse`) in one build? Or is there a cheaper route that
   serves each consumer separately (the engine has no sectionwise alternative; the dual had a partial
   sectionwise `sliceDualTransport`)?
2. Is the overall Route-A bottom-up arc still SOUND toward the goal? Any structural mis-step
   (a phase that can't actually close the goal node, a missing prerequisite, a hallucinated route)?
3. The A.2.c-engine row is the dominant pole (~85–140 iters). Is the strategy right to OPEN it in
   parallel with the substrate now (the loc-triv coherence entry is 1 sorry from done), or is that
   premature breadth?
4. Any CHALLENGE/REJECT on the shared-root pivot or the budget estimates.
