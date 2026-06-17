# Strategy Critic Directive

## Slug
iter127

## Iter
127

## Project goal

The project formalizes Christian Merten's "Algebraic Jacobian Challenge" (see `references/challenge.lean`): the construction of the Jacobian of a smooth proper geometrically irreducible curve `C` over a field `k` as an abelian variety, together with the universal property of the Abel–Jacobi morphism. Nine signatures are protected (mathematician-frozen): the `genus` definition in `Genus.lean`; `Jacobian`, `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible` in `Jacobian.lean`; and `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp` in `AbelJacobi.lean`. Critically, the foundational existence theorem `nonempty_jacobianWitness` quantifies over arbitrary smooth proper geometrically irreducible curves with no $k$-rational-point hypothesis — Brauer–Severi conics over `ℚ` are counterexamples to the false unconditional `C ≅ ℙ¹_k` claim. The end-state (per iter-121 user pivot, reaffirmed by iter-126 user hint) is **zero inline `sorry` in the project**, no named axioms, every Mathlib gap filled in-tree as a Mathlib-merge-quality contribution candidate.

## Re-verification request

STRATEGY.md is **substantially unchanged** from the iter-126 revisions. Iter-126 made the following load-bearing decisions that you reviewed last iter:

1. **M1 EXCISED** iter-126 (was previously parked under the iter-128 hard trigger; iter-126 strategy-critic CHALLENGE on the sunk-cost-adjacent deferral was accepted, and the bridge + 6 support helpers were deleted from `Differentials.lean`).
2. **M2.a scaffold** landed iter-126 (new file `RigidityKbar.lean` with `rigidity_over_kbar` named declaration + sorry body; Option B abstract genus-0-curve encoding).
3. **Shared cotangent-vanishing pile scoped** by `mathlib-analogist-cotangent-vanishing-pile-iter126`: 3 critical scoping corrections (piece (i) 4× upward to 800–1500 LOC; piece (iv) Serre duality DEFERRED entirely; piece (iii) committed Option A Frobenius iteration); persistent file `analogies/cotangent-vanishing-pile.md` (NEW iter-126).
4. **M2.d-alt collapsed** into the shared pile per iter-125 strategy-critic CHALLENGE #3 (single estimate gates both M2.a body and M2.d-alt genus-0 identification).
5. **M3 user-hint absorbed** iter-126 (option 2 named-axiom REJECTED; option 1 PR-and-wait + do-the-work selected; STRATEGY.md § Off-critical-path M3 + § Soundness rules + § M1 hard exit (c) all updated).

Iter-127 is plan-phase-only by design: dispatches `refactor-m2b-scaffold-iter127` (define `genusZeroWitness` builder), dispatches `mathlib-analogist-cotangent-vanishing-pile-over-k-iter127` (scope the direct-over-k alternative raised by your iter-126 alternative #1), 3 mandatory critics, and stages iter-128 prover target for the META-PATTERN TRIPWIRE.

Re-verify the unchanged strategy:

- Is the over-k rigidity alternative (which would drop M2.c — 4–8 iter / 300–500 LOC savings) properly scoped to dispatch this iter as a follow-up analogist consult? Is the iter-126 commitment to dispatch the over-k analogist iter-127 still the right call, or should it have happened iter-126?
- Is the M2.b scaffold framing (genus-0 witness with `isAlbaneseFor` branching on vacuity vs `rigidity_over_kbar` application) mathematically sound? In particular, is the vacuity branch (C(k) = ∅) really vacuously true, or does the `IsAlbanese` definition's quantifier force something on the empty branch?
- Is the iter-128 META-PATTERN TRIPWIRE still load-bearing, or has iter-127's scaffold deliverable resolved the convergence-by-scaffolding concern that prompted it?
- Are the iter-129+ shared-pile estimates honest? Piece (i) at 800–1500 LOC is the dominant driver; does the analogist's chain (cotangent-sheaf base + Lie-algebra-of-GrpObj + mulRight-globalisation) cover the full cost or is more upstream Mathlib work hiding?
- Is there a route the strategy is not considering? Particularly: the analogist's iter-126 report flagged the **presheaf-vs-sheaf bridge cost** as material for piece (i). Should the project build the scheme-level cotangent sheaf first (a separate Mathlib gap) before attempting piece (i)?
- M2.d (the Riemann–Roch path) remains in STRATEGY.md as the "fallback" to M2.d-alt. With M2.d-alt's piece (iv) Serre duality deferred, is the project actually committed to M2.d-alt or is the choice still genuinely open?

## Strategy under review

[paste verbatim — see STRATEGY.md at /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md]

Read STRATEGY.md directly from disk (it's at /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md). Do NOT read PROGRESS.md, task_pending.md, recent iter sidecars, or task_results/. Your value depends on freshness.

## References index

The project has exactly one reference: `references/challenge.lean` (Christian Merten's original challenge file with the formal statement of the 9 protected declarations the project must formalize).

## Blueprint summary (one-line per chapter)

- `AbelJacobi.tex` — the protected Abel–Jacobi morphism definitions in `AbelJacobi.lean` (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`), each obtained by projection from the `JacobianWitness`.
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris infrastructure for the Čech computation of `H¹(C, O_C)` used by `genus`.
- `Cohomology_SheafCompose.tex` — `HasSheafCompose` instance for the forget from `CommRingCat` to `AddCommGrpCat`, the foundation of the Čech computation.
- `Cohomology_StructureSheafAb.tex` — `AddCommGrpCat`-valued structure sheaf via `HasSheafCompose`.
- `Cohomology_StructureSheafModuleK.tex` — `ModuleCat k`-valued structure sheaf upgrade (`HModule` / `HModule'`) for the genus computation.
- `Differentials.tex` — post-iter-126-excise: relative-differentials presheaf, the rfl identification of its sections with `KaehlerDifferential`, the `Subsingleton`-of-`Ω` localization lemma, the `Ω` tower-cancellation `LinearEquiv` (M1.d Mathlib-PR candidate), and the forward-direction smoothness criterion `smooth_locally_free_omega`.
- `Genus.tex` — protected `AlgebraicGeometry.genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`.
- `Jacobian.tex` — protected `Jacobian C` + 4 instances + `IsAlbanese` universal property + `JacobianWitness` bundle + the single foundational sorry `nonempty_jacobianWitness`. Contains the genus-stratified body decomposition (the `by_cases h : genus C = 0` outline for the future restructure).
- `RigidityKbar.tex` — NEW iter-126; names `rigidity_over_kbar` and decomposes its proof into C.2.b reduction + C.2.c image-dimension dichotomy + C.2.d cotangent-vanishing keystone + C.2.e set-to-scheme promotion; documents the shared cotangent-vanishing Mathlib pile with per-piece (i)+(ii)+(iii) (piece (iv) DEFERRED) sub-builds.
- `Rigidity.tex` — protected `Scheme.Over.ext_of_eqOnOpen` (iter-125 refactor); the project's load-bearing rigidity lemma consumed by C.2.b.
- `Modules_Monoidal.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`, `Picard_LineBundle.tex` — **orphan chapters** (not in `content.tex`; carry-forward from earlier strategy iterations; not in scope this iter).

## What to challenge

Apply your standard rubric: goal alignment, mathematical soundness, alternative routes, sunk-cost reasoning, prerequisite assumptions, effort-estimate honesty. Note: the strategy has had FOUR previous strategy-critic dispatches (iter-122, iter-123, iter-124, iter-125, iter-126) with substantial inline responses. Be especially wary of (a) iter-126 corrections that were applied to STRATEGY.md but may not have been propagated to PROGRESS.md / blueprint / sequencing tables, and (b) commitments to "do the work" that may have understated cost.

Write your report per the descriptor; verdict per route plus a one-paragraph summary.
