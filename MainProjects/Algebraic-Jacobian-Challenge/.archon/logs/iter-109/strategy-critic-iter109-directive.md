# Strategy Critic Directive

## Slug
iter109

## Iter
109

## Project goal (verbatim, from `references/challenge.lean` header)

> Formalize the Jacobian of a smooth proper geometrically irreducible curve over a field. The nine declarations listed in `archon-protected.yaml` are the deliverables:
> `AlgebraicGeometry.genus`,
> `AlgebraicGeometry.Jacobian`,
> `AlgebraicGeometry.Jacobian.instGrpObj`,
> `AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus`,
> `AlgebraicGeometry.Jacobian.instIsProper`,
> `AlgebraicGeometry.Jacobian.instGeometricallyIrreducible`,
> `AlgebraicGeometry.Jacobian.ofCurve`,
> `AlgebraicGeometry.Jacobian.comp_ofCurve`,
> `AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp`.
> A correct construction equips the Jacobian as a smooth proper geometrically-irreducible group scheme of dimension `genus` whose `ofCurve` map satisfies the universal Abel-Jacobi property.

## References index

```
| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

(There is exactly one informal source for this project. Everything else is Mathlib + the blueprint.)

## Blueprint summary (chapter title + one-line topic per chapter)

- **AbelJacobi.tex** — The Abel–Jacobi map: `ofCurve P : C → Jacobian C` and its universal property.
- **Cohomology_MayerVietoris.tex** — Mayer–Vietoris long exact sequence for sheaf cohomology with k-module coefficients; the Čech-acyclicity infrastructure currently in `BasicOpenCech.lean` lives in the Čech-acyclicity sections of this chapter.
- **Cohomology_SheafCompose.tex** — Sheaf condition along the structure-sheaf forget composite.
- **Cohomology_StructureSheafAb.tex** — Structure sheaf as a sheaf of abelian groups; sheafification + Ext infrastructure.
- **Cohomology_StructureSheafModuleK.tex** — Sheaves of k-modules: sheafification, Ext, and the structure sheaf as a sheaf of k-modules.
- **Differentials.tex** — Sheaf of relative differentials, smoothness, cotangent exact sequence, Serre duality for a curve.
- **Genus.tex** — Genus of a smooth proper curve (`finrank k H¹(X, 𝒪_X)`).
- **Jacobian.tex** — The Jacobian as an abelian variety (group scheme + instances).
- **Modules_Monoidal.tex** — Symmetric monoidal category of 𝒪_X-modules; carries the deferred `instIsMonoidal_W` sorry for the varying-ring `stalk_tensorObj` gap.
- **Picard_Functor.tex** — The relative Picard functor; carries the `PicardFunctor.representable` deferral.
- **Picard_FunctorAb.tex** — The relative Picard functor as an abelian-group-valued presheaf.
- **Picard_LineBundle.tex** — Line bundles on schemes and the Picard group (current Lean body uses the global-sections approximation `CommRing.Pic Γ(X, ⊤)`; C1 refactor is the active design question this iter).
- **Rigidity.tex** — Rigidity for morphisms of group schemes (Mumford §4).

## Current STRATEGY.md

Read the file verbatim at `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`. This is the primary subject of your review.

## What I'm asking

Re-verify the current strategy for `Algebraic-Jacobian-Challenge` from a fresh-context view. In particular:

- The iter-108 plan adopted a specific firing order: this iter (Archon iter-109) fires the **C1 promotion** of `Picard/LineBundle.lean` via the `refactor` subagent with the mathlib-analogist `c1-route` recipe pre-loaded (target name `(Shrink (Skeleton X.Modules))ˣ`; default option (c) for `Pic.pullback` introduces a *5th named sorry* `SheafOfModules.pullback_tensorObj`; post-C1 `instIsMonoidal_W` becomes load-bearing).
- The strategy commits to a final sorry-disclosure surface of **5 named Mathlib-gap sorries + 1 budget-deferral** at end-state, with the project shipping a *framework conditional* on those gaps rather than the autonomous-loop autonomously constructing the Jacobian.

Please render your verdict on:

1. Is firing C1 promotion this iter the right next move, given the analogist's findings? Or is there an alternative ordering you'd recommend (e.g. fire Phase B first; or fire a smaller scope of C1 only)?

2. Is the **post-C1 named-sorry-count increase from 4 to 5 (adding `SheafOfModules.pullback_tensorObj`)** an acceptable trade vs. building the `Functor.Monoidal (Scheme.Hom.pullback f)` instance (multi-iter, multi-hundred LOC) or hand-rolling the iso (smaller scope, no new gap)? The strategy commits to option (c) "smallest scope, named deferral, mirrors `instIsMonoidal_W` posture" — challenge this if there is a better trade.

3. Is the **end-state framing of "Jacobian framework conditional on `nonempty_jacobianWitness` AND post-C1 framework conditional on `instIsMonoidal_W`"** acceptable mathematics-wise, or does this conditional-on-conditional structure cross a soundness line you would flag for the human reader? The "Plain-language disclosure" section in STRATEGY.md is the current best-effort honest accounting; challenge if it understates or overstates.

4. Re-verify previously CHALLENGED items: the iter-108 strategy-critic challenged the labelling of L1846 as "Mathlib gap" and forced re-labelling as "budget-deferral"; verify post-iter-108 that the strategy now treats them as distinct categories.

5. Are there alternative routes (other than C1 promotion) that the strategy mentions but the blueprint does not cover? Or routes that the strategy *should* mention that it doesn't?

6. Carry-over check: the iter-107/108 variance flag on `serre_duality_genus` (Phase B `Differentials.lean:877`) is still live and not actionable this iter (Phase B not dispatched). Confirm this is the right call, or push back.

Output your standard report shape (per `.archon/subagents/strategy-critic.md` body). Do NOT read any file outside what is named in this directive (no iter sidecars, no task_pending, no task_results, no recent prover narrative).
