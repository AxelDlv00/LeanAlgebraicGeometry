# Strategy Critic Report

## Slug
iter110

## Iteration
110

## Pre-flight: directive vs. protected declarations

Minor consistency note (not strategy-fatal): the directive's "Project goal" lists the
nine protected declarations under namespace `AlgebraicGeometry.Curve.*`
(e.g. `AlgebraicGeometry.Curve.genus`). The frozen `archon-protected.yaml`
lists them under `AlgebraicGeometry.*` (e.g. `AlgebraicGeometry.genus`).
The strategy text itself doesn't depend on the namespace, so I treat this as
a directive-text drift rather than a strategic flaw. The planner should reconcile
the namespace in the next planning round.

## Routes audited

### Route: Phase A — Čech acyclicity residual work (`BasicOpenCech.lean`)

- **Goal-alignment**: PASS — Čech acyclicity is a prerequisite for `H¹(X, O_X)` =
  the genus definition; closing the residual sorries does feed the final goal.
- **Mathematical soundness**: PASS — escape-valve Option (i) (budget-deferral with
  `-- DEFERRED (budget)` annotation, NOT a named Mathlib gap) is mathematically
  honest: the substep is true and provable, just not within the iteration budget.
- **Sunk-cost reasoning detected**: no — strategy explicitly PAUSED L1120 after
  "7 PARTIAL + 2+ PAUSED iters" rather than defending continued attempts. Good
  example of strategy *not* being captured by past investment.
- **Phantom prerequisites**: none new; the Mathlib infra the substeps need is
  acknowledged as "infrastructure-blocked" rather than claimed present.
- **Effort honesty**: under-counted, possibly — see CHALLENGE below.
  Estimate of "~2–4 iters / ~30–80 LOC" is described as residual prover work on
  three "tractable Mathlib-infrastructure-blocked items". The phrase is
  internally contradictory: if Mathlib infra is blocking them, they aren't
  presently tractable, and the LOC estimate is aspirational rather than a
  budget for *this* loop. Either reclassify them as named Mathlib gaps or
  explain what local workaround makes the 30–80 LOC realistic.
- **Verdict**: SOUND-with-CHALLENGE — escape valve was a sound call; the
  residual estimate needs sharpening.

### Route: Phase B — Cotangent sheaves (`Differentials.lean`)

- **Goal-alignment**: PASS — cotangent sheaf is the bridge to the genus
  (`H¹(X, O_X)`, via Serre duality / smoothness rank) and to the
  `smoothOfRelativeDimension_genus` instance.
- **Mathematical soundness**: PASS — `h_exact` (L636) deferred parallel to
  `instIsMonoidal_W` is a defensible parallel-gating choice; the named gap is
  honestly disclosed.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: VERIFIED via leansearch —
  `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
  exists and is the relevant rank lemma for the smoothness bridge.
  `CategoryTheory.Sheaf.H` (sheaf cohomology) exists. Serre duality
  *for the specific case used at L877* could not be found by name in Mathlib
  — strategy correctly flags this as a variance risk.
- **Effort honesty**: estimate "~8–12 iters / ~250 LOC" for 5 sorries (~50
  LOC/sorry) is likely too tight for L877 specifically (Serre duality for
  curves is non-trivial even when underlying duality machinery exists). The
  variance flag is the right mitigation — but see CHALLENGE on its scope.
- **Verdict**: SOUND-with-CHALLENGE — variance-flag scope must be made
  precise before Phase B begins (see Q2 in "Re-verification answers" below).

### Route: Phase C0 — Monoidal `X.Modules` (deferred via named Mathlib gap)

- **Goal-alignment**: PASS — `BraidedCategory (X.Modules)` is load-bearing for
  the protected `Pic`, `Pic.pullback`, `PicardFunctor*`, and the
  `Jacobian.lean` / `AbelJacobi.lean` consumers downstream. The strategy's
  framing that "the protected declarations will type-check against the named
  gap" is correct: instance-conditional formalization is a legitimate end-state.
- **Mathematical soundness**: PASS — `stalk_tensorObj` for *varying-ring* R₀
  is genuinely missing from Mathlib b80f227 (loogle returns the `pullback*`
  family and the `Sheafify` family but no `stalk_tensorObj` matching the
  varying-ring shape). Honest named gap.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none —
  `CategoryTheory.Functor.Monoidal.εIso` exists (confirmed via leansearch),
  so the strategy's claim that the C1 sister pair "collapses to εIso when
  the monoidal instance lands" is mathematically grounded.
- **Effort honesty**: 0 iters / 0 LOC because deferred. Reasonable.
- **Verdict**: SOUND.

### Route: Phase C1 — Refined `LineBundle` (DONE iter-109; verify)

- **Goal-alignment**: PASS — C1 promotion was a structural change to
  `LineBundle` to interface against the new `Modules` monoidal scaffold,
  not a new protected declaration.
- **Mathematical soundness**: PASS — the named-gap pair
  (`pullback_tensorObj`, `pullback_oneIso`) is exactly the (`μ`, `ε`)
  coherence pair for the missing monoidal instance on `SheafOfModules.pullback`.
  See Q1 in "Re-verification answers" for the labelling-honesty audit.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: `SheafOfModules.pullback` exists (verified
  via loogle); the strategy's *absence* of `SheafOfModules.pullback_tensorObj`
  is also verified (loogle returns the `pullbackId`/`pullbackComp`/
  `pullbackPushforwardAdjunction` family but no `pullback_tensorObj` /
  `pullback_oneIso`). Both gaps are real.
- **Effort honesty**: marked DONE with verify-only follow-up. Reasonable
  pending iter-110 confirmation.
- **Verdict**: SOUND.

### Route: Phase C2 — `PicardFunctor` re-derivation

- **Goal-alignment**: PASS — `PicardFunctor` is the staging ground for the
  Jacobian-as-abelian-variety (post-representability) construction.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none — `AlgebraicGeometry.Scheme.LocalRepresentability.isRepresentable`
  exists (confirmed via leansearch) as the local-representability harness
  Phase C3 would consume *if* it were attempted.
- **Effort honesty**: "~4–6 iters / ~150 LOC" hedged with "may or may not
  be required against the new `LineBundle` — needs verification". The hedge
  is honest, and iter-110 candidate #3 is the right verification step.
  This phrasing makes the estimate elastic; not a flaw, but the planner
  should commit one way or the other after the iter-110 verification round.
- **Verdict**: SOUND.

### Route: Phase C3 — Representability / `JacobianWitness` (DEFERRED via exit policy)

- **Goal-alignment**: PARTIAL — the protected declarations type-check
  conditional on `nonempty_jacobianWitness`. This means the
  `AlgebraicGeometry.Jacobian` instance fields (`instGrpObj`,
  `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`)
  carry their content *projected through* a postulated witness rather than
  through a Mathlib-resolved Jacobian construction. The strategy is honest
  about this ("Jacobian framework conditional on `nonempty_jacobianWitness`").
  A maximalist read of the project goal — "deliver the Jacobian
  unconditionally" — would call this a goal-miss; the strategy's honest
  framing reclassifies the goal as "deliver the framework, with the
  representability ingredient as the named-deferred sorry". I accept that
  framing for soundness, while flagging that a future reader of the protected
  decls will see content gated on a `sorry`.
- **Mathematical soundness**: PASS — the deferred sorry is for a *true*
  statement (the Jacobian of a smooth proper geometrically irreducible curve
  over a field exists), so the soundness rule (no helper for universally
  false signatures) is preserved.
- **Sunk-cost reasoning detected**: no — exit policy explicitly cites
  "Hilbert/Quot schemes + finite-group quotients absent from Mathlib
  b80f227". This is the right kind of justification (Mathlib state, not
  past iteration investment).
- **Phantom prerequisites**: none — the absent infrastructure is named, not
  assumed present.
- **Effort honesty**: deferred — appropriate.
- **Verdict**: SOUND.

### Route: Phase D, E — Genus / Jacobian / Abel–Jacobi file-level closure

- **Goal-alignment**: PASS (file-level) / BLOCKED-ON-C3 (content-level).
  Strategy correctly distinguishes file-level closure (no inline `sorry`
  in `Genus.lean`/`Jacobian.lean`/`AbelJacobi.lean` beyond the named gaps)
  from content-level closure (which needs C3).
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: VERIFIED — `Scheme.HModule` could not be
  located by Mathlib leansearch, so this is presumably a *local* definition
  in `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`. The strategy
  does not claim it as a Mathlib piece, so no phantom.
- **Effort honesty**: 0 iters / 0 LOC, consistent with current state.
- **Verdict**: SOUND.

## Re-verification answers

### Q1 — Is `pullback_oneIso` honestly a named-deferred Mathlib gap (sibling to `pullback_tensorObj`) and not a project-introduced ancillary?

**YES — honestly a sibling Mathlib gap.**

Reasoning: any monoidal functor `F` carries two coherence isomorphisms:
the unit-coherence `ε : 𝟙_D ≅ F(𝟙_C)` and the multiplicative coherence
`μ_{X,Y} : F(X) ⊗ F(Y) ≅ F(X ⊗ Y)`. Both are facets of a *single*
underlying piece of missing Mathlib content: a `Monoidal` instance on
`SheafOfModules.pullback` (the pullback functor along a continuous map of
sites with rings). The strategy's claim that "`pullback_oneIso` collapses
to `Monoidal.εIso` when `pullback_tensorObj` resolves" is correct *modulo*
phrasing — they collapse *together* when Mathlib adds the
`SheafOfModules.pullback.Monoidal` instance. Calling each one separately
a named gap is honest: project code currently uses both as standalone
lemmas, and Mathlib presently provides neither.

Loogle verification: the `SheafOfModules.pullback*` family
(`pullbackId`, `pullbackComp`, `pullbackPushforwardAdjunction`,
`pullbackIso`, `instIsLeftAdjointPullback`) is present in
`Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackContinuous`, but
no member named `pullback_tensorObj`, `pullback_oneIso`, or
`pullback.Monoidal` exists. Both gaps are real.

The end-state count "6 named gaps + 1 budget-deferral" (was 5+1 pre-iter-109)
is honest. Labelling-honesty principle (carried Q2 from iter-109) survives.

### Q2 — Iter-110 candidate ordering, and is the variance-flag prescription binding for ALL Phase B sorries or only L877?

**Recommended ordering: 3 → 1 → 2.** Run iter-110 candidate #3
(Phase C2 verification on `Picard/Functor.lean`) FIRST as cheap intel.
It's read-only-ish (lake build + spot inspection) and determines whether
the Phase C2 estimate ("~4–6 iters / ~150 LOC") needs to be revised
downward by a lot or kept where it is. Information that cheap, that
load-bearing on the Phase C2 budget, should not be sequenced behind
new-proof work.

After that, between candidate #1 (open Phase B non-L877) and #2 (defer
Phase B to iter-111), candidate #1 is preferable *if* the variance-flag
prescription does not gate L122/L718/L735.

**Variance-flag scope — CHALLENGE.** The strategy's wording is:
"dispatch mathlib-analogist on Serre-duality coverage for `Module.finrank`-style
consumers BEFORE scheduling Phase B." Read literally this gates *all of
Phase B*. Read mathematically, the gating concerns L877
(`serre_duality_genus`) specifically — Serre duality is what L877 consumes.
The other Phase B sorries (L122, L718, L735) live in the cotangent-exact-sequence
and smoothness-criterion chapter content per the blueprint summary, and are
not Serre-duality consumers.

The planner must clarify in STRATEGY.md (or in iter-110 plan.md as an
explicit rebuttal): is the analogist dispatch gating L877 specifically,
or all four Phase B sorries? Right now the prose admits both readings,
and that ambiguity will cost an iteration if it isn't pinned down before
provers fan out.

### Q3 — Is the "unconditional vs framework-conditional" enumeration still accurate given iter-109 LineBundle promotion?

**Partial — and the enumeration itself is not in the verbatim STRATEGY.md
under review.** The directive's Q3 references an enumeration the strategy
text doesn't actually present in explicit form; the closest the STRATEGY
text comes is the per-phase table and the end-state paragraph
("conditional on `nonempty_jacobianWitness`, AND … conditional on
`instIsMonoidal_W` + the pair (`pullback_tensorObj`, `pullback_oneIso`)").

What I *can* check against the file structure (Glob result):

- `AlgebraicJacobian/Picard/LineBundle.lean` exists and per the strategy
  table is now C1-promoted with the two named gaps. The `CommGroup`
  instance on `Pic` remains framework-conditional on `instIsMonoidal_W`
  (Phase C0 gap) — that part of the enumeration is *unchanged* by C1
  promotion.
- The new addition is that `Pic.pullback` is now framework-conditional on
  the named pair (`pullback_tensorObj`, `pullback_oneIso`). This is a
  *new* condition that wasn't on the books pre-iter-109.

So the enumeration *if it were re-stated* should classify
`Picard/LineBundle.lean`'s `Pic.pullback` arc as framework-conditional
on TWO things (the C0 monoidal gap AND the new pullback-monoidal pair),
not one. The strategy implicitly says this but doesn't make the
enumeration explicit.

**Recommendation**: add a `## What's unconditional vs framework-conditional`
section to STRATEGY.md naming, per chapter, the conditioning gaps. The
present strategy makes the reader assemble this from the table + end-state
paragraph + per-chapter Pic.pullback notes — error-prone.

## Alternative routes (suggested)

### Alternative: Pic⁰ via étale-sheafified divisor classes, bypassing C2

- **What it looks like**: instead of re-deriving `PicardFunctor`'s
  `quotMap`/`fiberMap` content (Phase C2 work), one could define Pic⁰ as
  the étale-sheafified relative divisor-class functor and bypass the
  intermediate `quotMap`/`fiberMap` machinery. Mathlib has
  `AlgebraicGeometry.Scheme.LocalRepresentability` (verified to exist),
  which provides a local-representability harness.
- **Why it might be cheaper or sounder**: skips a chapter's worth of
  monoidal-functor coherence and lands Pic⁰ closer to a form
  consumable by the `JacobianWitness` exit policy. Saves the ~4–6
  iter Phase C2 budget if it works.
- **What the current strategy may have rejected**: the blueprint
  (`Picard_Functor.tex`) commits to the `S ↦ Pic(X ×_k S) / Pic(S)`
  presentation, which forces the `quotMap`/`fiberMap` development.
  Switching presentations breaks the blueprint contract. Planner should
  confirm this contract is binding before considering the alternative.
- **Severity of the omission**: minor — the protected signatures don't
  visibly depend on the Pic presentation, so the alternative is in scope,
  but the blueprint commitment is real and the savings (~150 LOC) are
  modest. Worth a one-line acknowledgement in STRATEGY.md, not a route
  switch.

### Alternative: defer L1846 + L1212/L1536/L1564 *together* as one Phase-A close-out

- **What it looks like**: rather than treating L1846 as the only
  budget-deferral and L1212/L1536/L1564 as "tractable infrastructure-blocked
  items", reclassify all four under a single Phase-A close-out marker
  with consistent `-- DEFERRED (budget): ...` annotations. Removes the
  "tractable-but-blocked" contradictory framing.
- **Why it might be cheaper or sounder**: Phase A drops to 0 active
  prover iters; the project's named-gap count picks up at most 3 more
  lines if any of L1212/L1536/L1564 turn out to need named Mathlib
  flagging. Removes ambiguity about whether the Phase A residual
  estimate is binding.
- **What the current strategy may have rejected**: presumably the
  planner believes L1212/L1536/L1564 will close in the autonomous loop
  once their substep dependencies clear. If so, say which dependencies
  in STRATEGY.md instead of "tractable Mathlib-infrastructure-blocked".
- **Severity of the omission**: minor — strategic but small.

## Sunk-cost flags

None detected. The strategy's treatment of L1120 (PAUSED after 7
PARTIAL + 2+ PAUSED iters) and L1846 (escape-valve Option (i) =
budget-deferral) is the *opposite* of sunk-cost reasoning — it
explicitly stops investing in stuck routes rather than defending the
investment. Good.

## Prerequisite verification

- `SheafOfModules.pullback`: VERIFIED — `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackContinuous`.
- `SheafOfModules.pullback_tensorObj`: MISSING — confirmed as named gap.
- `SheafOfModules.pullback_oneIso`: MISSING — confirmed as named gap
  (no loogle hit on either name; the sibling-gap framing is honest).
- `CategoryTheory.Functor.Monoidal.εIso`: VERIFIED —
  `Mathlib.CategoryTheory.Monoidal.Functor`. Supports the strategy's
  "collapses to εIso" framing for the C1 sister pair.
- `AlgebraicGeometry.Scheme.Modules`: VERIFIED —
  `Mathlib.AlgebraicGeometry.Modules.Sheaf`.
- `CategoryTheory.Sheaf.H` (sheaf cohomology): VERIFIED —
  `Mathlib.CategoryTheory.Sites.SheafCohomology.Basic`.
- `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`:
  VERIFIED — `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`.
  Useful bridge for the smoothness-rank side of Phase B.
- `AlgebraicGeometry.Scheme.LocalRepresentability.isRepresentable`:
  VERIFIED — `Mathlib.AlgebraicGeometry.Sites.Representability`.
- `stalk_tensorObj` (for varying-ring R₀, as Phase C0 gap):
  MISSING — could not locate; supports the gap framing.
- Hilbert / Quot schemes representability (Phase C3 reference):
  MISSING — no name match in Mathlib. Supports the exit policy.
- `Scheme.HModule`: not located in Mathlib by leansearch; strategy
  doesn't claim it as Mathlib — presumably a local def. Not a phantom
  by the strategy's own framing.

## Must-fix-this-iter

- **Route Phase A — CHALLENGE**: the framing "tractable Mathlib-infrastructure-blocked
  items the project flagged for future closure" is internally contradictory.
  Either name the *infrastructure* (so it can become a named Mathlib gap or
  an Archon-side helper task) or remove the "tractable" word. The "~2–4
  iters / ~30–80 LOC" estimate should reflect whichever framing wins.

- **Route Phase B — CHALLENGE**: the variance-flag prescription
  ("dispatch mathlib-analogist on Serre-duality coverage BEFORE
  scheduling Phase B") must specify whether it gates *all four* Phase B
  sorries or *only* L877. The blueprint summary suggests only L877
  consumes Serre duality; the strategy's current wording suggests all of
  Phase B. Pin this down in STRATEGY.md or in iter-110 plan.md before
  any Phase B prover dispatch.

- **Iter-110 ordering — CHALLENGE**: the three candidates are not
  symmetric. Candidate #3 (Phase C2 verification) is cheap intel that
  load-bears the Phase C2 budget and should run FIRST. Strategy should
  state a preferred ordering rather than three parallel options.

- **Q3 unconditional-core enumeration — CHALLENGE**: the enumeration
  referenced in the directive is not actually present in STRATEGY.md;
  the reader must reconstruct it from the per-phase table plus the
  end-state paragraph. Add an explicit `## Unconditional vs framework-conditional`
  section so future critics (and provers) don't have to reconstruct it.

## Overall verdict

**SOUND-with-CHALLENGE.** A fresh mathematician would accept this
strategy's macro-shape — the named-gap end-state framing, the
`JacobianWitness` exit policy, the parallel-gating of `h_exact` to
`instIsMonoidal_W`, and the C1 promotion's sister pair are all honest
and mathematically defensible. The prerequisite chain through Mathlib
(verified above) is intact: every concrete Mathlib name the strategy
relies on either exists or is honestly flagged missing.

The remaining frictions are not strategic flaws but precision gaps:
(i) Phase A residual estimate uses contradictory "tractable-but-blocked"
language; (ii) the Phase B variance flag's scope (L877-only vs all of
Phase B) is ambiguous; (iii) the three iter-110 candidates need a
recommended ordering; (iv) the Q3 enumeration is referenced but not
written out. Each is a one-paragraph fix in STRATEGY.md, not a route
re-architecture.

No `REJECT` verdict. No phantom prerequisites. No sunk-cost reasoning.
The strategy survives a cold read.
