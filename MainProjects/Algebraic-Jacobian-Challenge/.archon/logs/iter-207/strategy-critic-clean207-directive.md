# strategy-critic — clean207

Fresh-context critique of the project strategy. Read ONLY the inputs named here.
Do NOT read iter sidecars, task_results, PROGRESS.md, or any per-iter narrative.

## Inputs to read
1. `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` (verbatim — the object of critique).
2. `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md` (reference index).
3. Blueprint chapter titles (one per chapter) — supplied below; do not read the chapters.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: nine protected declarations headed by
`AlgebraicGeometry.Jacobian` + `Jacobian.nonempty_jacobianWitness` — construct an
Albanese/Jacobian object `J := Pic⁰_{C/k}` uniform over the k-rational pointing of a smooth
proper geometrically irreducible curve C/k, with NO `C(k)≠∅` and NO `CharZero` (only `[Field k]`).
Witness built unconditionally; only `isAlbaneseFor` quantified over the pointing.

## Blueprint chapter titles
- Picard_TensorObjSubstrate: Relative Picard sheaf — Scheme.Modules.tensorObj group law (ACTIVE lane)
- Picard_RelPicFunctor: relative Picard functor + étale sheafification
- Picard_FGAPicRepresentability: FGA representability of the Picard scheme
- Picard_{RelativeSpec, LineBundlePullback, QuotScheme, FlatteningStratification, IdentityComponent, Pic0AbelianVariety}
- Albanese_{AlbaneseUP, AuslanderBuchsbaum, CodimOneExtension, CoheightBridge, Thm32RationalMapExtension}
- RiemannRoch_{WeilDivisor, OCofP, OcOfD, RRFormula, H1Vanishing, RationalCurveIso} (Route C, PAUSED)
- AbelianVarietyRigidity, RigidityKbar, Rigidity, RigidityLemma, Genus, Genus0BaseObjects_*, Jacobian, AbelJacobi
- Cohomology_* (sheaf cohomology substrate), Differentials, Cotangent_GrpObj

## What changed this iter (so you can focus)
The file was COMPRESSED for readability (Goal 28→11 lines) and the A.1.c.SubT row was updated:
the lane's blocker, previously framed as a multi-file absent-Mathlib monoidal wall, is now pinned
to a SINGLE bounded ~40–90 LOC sectionwise instance `(restrictScalars φ).LaxMonoidal` (the mate
lemma and δ comparison map already ship in Mathlib).

## Your job
Challenge the strategy as a fresh mathematician. In particular:
- Is the bottom-up critical path (A.1.c.SubT → A.1.c → A.2.c) sound and is A.2.c genuinely RR-free?
- Is the `J := Pic⁰` route + the degComp-vs-Pic^z RR caveat correctly stated?
- Is the Albanese `rmk:Alb` vs Thm-3.2 excision framing sound (does representability really yield
  the Albanese UP RR-free)?
- Did the compression drop any load-bearing strategic content?
- Any unnecessary phases, hallucinated routes, or missing prerequisites?

Issue SOUND / CHALLENGE / REJECT per point with reasoning.
