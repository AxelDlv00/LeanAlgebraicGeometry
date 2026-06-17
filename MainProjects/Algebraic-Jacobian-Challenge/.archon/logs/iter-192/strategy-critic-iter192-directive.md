# Directive: strategy-critic iter192

You are the iter-192 plan-phase strategy critic. Fresh view of the whole
strategic plan, NO iter-by-iter history. Read only what is provided
below.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: nine protected
declarations headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — existence of an Albanese / Jacobian
object uniform over the `k`-rational pointing of a smooth proper
geometrically irreducible curve `C / k`, with NO `C(k) ≠ ∅` hypothesis.
End-state: zero inline `sorry`, kernel-only axioms (`propext`,
`Classical.choice`, `Quot.sound`). Char-general: the protected
signatures take `[Field k]` only — NO `CharZero`.

## STRATEGY.md (verbatim)

(file: `.archon/STRATEGY.md`)

## Blueprint chapter summary

20363 LOC across these chapters under `blueprint/src/chapters/`:
AbelJacobi, AbelianVarietyRigidity, Albanese_AlbaneseUP,
Albanese_AuslanderBuchsbaum, Albanese_CodimOneExtension,
Albanese_CoheightBridge, Albanese_Thm32RationalMapExtension,
AlgebraicJacobian_Cotangent_GrpObj, Cohomology_MayerVietoris,
Cohomology_SheafCompose, Cohomology_StructureSheafAb,
Cohomology_StructureSheafModuleK, Differentials, Genus,
Genus0BaseObjects_Cross01Substrate, Jacobian, Picard_FGAPicRepresentability,
Picard_FlatteningStratification, Picard_IdentityComponent,
Picard_LineBundlePullback, Picard_QuotScheme, Picard_RelPicFunctor,
Picard_RelativeSpec, RiemannRoch_H1Vanishing, RiemannRoch_OCofP,
RiemannRoch_OcOfD, RiemannRoch_RRFormula, RiemannRoch_RationalCurveIso,
RiemannRoch_WeilDivisor, Rigidity, RigidityKbar.

## references/summary.md

(file present — refer to it for source pointers; ~14 references including
Stacks Algebra/Varieties/Constructions/Fields/Coherent, Kleiman-Picard,
Nitsure-Hilbert-Quot, Mumford-Abelian-Varieties, Milne-Abelian-Varieties,
Hartshorne, FGA-Explained, EGA-IV).

## Live user hint — push hard for ambitious progress

The user has issued a strong hint (verbatim):

> "The provers are currently too slow, you objectives should encourage
> them to not only do their task, but if the task can go further,
> closing the sorry is preferable, it should avoid just stopping after
> making 2/3 edits, it should really work harder. Moreover I added
> modes to the provers, the mathlib builder mode and the finegrain
> mode could unlock gated objectives in the strategy. I believe that
> currently the way you handle the project is in the wrong side, you
> should first solve the mathlib dependencies by starting from the
> bottom (i.e. appending the current mathlib state to progressively
> include all the tools that we need, and not start from the top by
> noticing dependencies are missing at each iteration). You should
> really try to make the project move, because currently you and the
> other agents are too lazy, making small progress and being satisfied
> with it, while the project is really big and we need to make big
> progress at each step."

## Key questions for you

1. **Bottom-up vs top-down**: STRATEGY.md decomposes Route A top-down
   (A.1.a → A.1.b → A.1.c → A.2 → A.3 → A.4). The user explicitly
   says to flip this: build mathlib infrastructure from the bottom
   first. How should the strategy be re-shaped? Are there phases that
   should be promoted (e.g. A.2.a flattening stratification is a
   2000-3500 LOC undertaking — should it be the iter-192 priority?
   Or is the current "fill substrates as needed" approach OK?).

2. **Velocity reality check**: 295-530 iters / 9500-17000 LOC for the
   positive-genus arm. With 191 iters elapsed and 80 sorries, what
   pace is needed? Is the current scope realistic, or should the
   strategy admit a non-Route-A fallback (e.g. dropping the
   universal-Albanese requirement)?

3. **Lane M↓ scope**: Stacks 00TT chain reopened as project-side build
   (~8-15 iters). Is this the right scope, or should it be more
   ambitious / use Mathlib's `RingTheory/Smooth/StandardSmooth`
   Jacobian criterion to short-circuit Stage 3-4?

4. **Lane F sclerosis**: QuotScheme has 13 sorries through 10 iters,
   one analogist consult; A.2.b is 75-150 iters / 2600-5000 LOC.
   Is the FGA Quot construction the right route, or should
   strategy admit a "represent Pic via Nitsure §6 Pic^τ-only
   route" pivot? (Note: Kleiman §5 Jacobian construction does NOT
   go through Quot; investigate.)

5. **A.3.i sanity check**: iter-191 mathlib-analogist found the
   substrate OWNED in Mathlib. Could other "stuck" phases similarly
   be unblocked by a fresh Mathlib state check?

6. **The genus-0 arm**: should it be the iter-192 priority since it
   is much closer to closing (45-65 iters / 2200-3800 LOC)? Closing
   the genus-0 arm fully would let `nonempty_jacobianWitness` go
   GREEN under genus = 0 hypothesis, providing a tangible milestone.

## Required output

Standard SOUND / CHALLENGE / REJECT verdict per strategic claim.
- For SOUND: brief affirmation.
- For CHALLENGE: cite the signal you disagree with, propose alternative.
- For REJECT: name the route that should be abandoned, propose pivot.

Report to `task_results/strategy-critic-iter192.md`.
