# Strategy Critic Directive

## Slug
ts240

## What changed (why you are re-dispatched)
`STRATEGY.md` was edited this iter. The high-level routes are UNCHANGED, but the
PROOF RECIPES for the two active lanes pivoted after iter-239's prover walls +
iter-240 mathlib-analogist consults:

1. **A.1.c substrate `IsInvertible.pullback`** — the prior "sectionwise
   `extendScalars.Monoidal` on `PresheafOfModules.pullback`" recipe was found DEAD
   (the pullback is an abstract left adjoint with no sectionwise/stalkwise formula;
   `Adjunction.leftAdjointOplaxMonoidal` does not exist). NEW recipe = **Route Z =
   local-chart finality**, two phases: Phase 1 `pullbackUnitIso` (cheap, globalize
   the proven `IsLocallyTrivial.pullback` `pullbackObjUnitToUnit` finality
   chart-chase); Phase 2 `pullbackTensorIso` (build a `pullbackObjTensorToTensor`
   map, prove iso by the same finality chart-chase, package via
   `Functor.CoreMonoidal.ofOplaxMonoidal` — a genuine Mathlib gap, no upstream
   pullback tensorator).
2. **A.2.c-engine FlatBaseChange affine close** — the 4-iter `Module.compHom`
   carrier wall is fixed by `algebraize [φ.hom]` (honest `Algebra`/`IsScalarTower`),
   and the route aligns to upstream `isIso_fromTildeΓ_pushforward` / `IsLocalizing`
   (#37189, post-pin); chosen the bump-free in-tree port (Mathlib bump deferred as
   too disruptive mid-flight).

## Your question
Read `STRATEGY.md` (verbatim, the current file) and judge it as a fresh
mathematician with NO investment in the project's momentum. Specifically:

- Is **Route Z** (local-chart finality for pullback strong-monoidality) sound and
  the right call, given the dead sectionwise recipe? Is Phase 2
  (`pullbackObjTensorToTensor` + `CoreMonoidal.ofOplaxMonoidal`) a reasonable
  multi-iter build, or is there a structurally simpler route to
  `IsInvertible.pullback` we are missing (e.g. the FLAT-restriction fallback the
  strategy names — since the RPF maps are all flat — being promoted to PRIMARY)?
- Is deferring the **Mathlib bump** (which would collapse the FlatBaseChange affine
  close to ~3 lines per the analogist) the right call vs. taking the bump now? Weigh
  the disruption of a project-wide bump mid-flight against the in-tree port cost.
- Any other strategic soundness concern: is the critical path
  (A.1.c.SubT DONE → A.1.c → A.2.c) still the right spine? Is the engine-parallel
  posture sound? Is the autoduality-RR-freeness open question being deferred
  appropriately?

## Files to read (read ONLY these — do NOT read iter sidecars, PROGRESS.md, task_results, or review reports)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` (verbatim — the strategy under review)
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md` (the reference index)
- `analogies/pullback-monoidal.md` and `analogies/fbc-qc.md` (the two iter-240
  design consults the recipe pivots rest on — read for the Mathlib citations)

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: nine protected declarations headed
by `AlgebraicGeometry.Jacobian` / `Jacobian.nonempty_jacobianWitness` — an
Albanese/Jacobian object uniform over the `k`-rational pointing of a smooth proper
geometrically irreducible curve `C/k` (`[Field k]` only). `J := Pic⁰_{C/k}` built
unconditionally; only `isAlbaneseFor` quantified over the pointing. End state: zero
inline sorry in the dependency cone of each protected decl, 0 project axioms.

## Blueprint chapter index (titles, one line each — for the cross-chapter view)
Picard_TensorObjSubstrate (Scheme.Modules.tensorObj + group law + pullback-monoidality);
Picard_RelPicFunctor (relative Picard functor + ét sheafification);
Picard_LineBundlePullback (line-bundle pullback on a relative curve);
Picard_FGAPicRepresentability; Picard_QuotScheme; Picard_FlatteningStratification;
Picard_IdentityComponent; Picard_Pic0AbelianVariety; Picard_RelativeSpec;
Cohomology_FlatBaseChange (i=0 flat base change, Stacks 02KH);
Cohomology_HigherDirectImage (Rⁱf_*, i≥1); Cohomology_MayerVietoris;
Albanese_AlbaneseUP / _CodimOneExtension / _Thm32RationalMapExtension / _AuslanderBuchsbaum;
AbelianVarietyRigidity; RigidityKbar; RiemannRoch_* (PAUSED); Genus; Jacobian; AbelJacobi.

## How to report
Verdict per strategic point: SOUND / CHALLENGE / REJECT, with a one-paragraph
rationale each. If you CHALLENGE or REJECT, name the concrete alternative.
