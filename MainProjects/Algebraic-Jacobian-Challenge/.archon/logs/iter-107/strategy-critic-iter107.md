# Strategy Critic Report

## Slug
iter107

## Iteration
107

## Routes audited

### Route: Phase A — Čech acyclicity, L1802 `h_loc_exact` (active prover lane)

- **Goal-alignment**: PASS — closing `h_loc_exact` is on the genuine
  critical path to `BasicOpenCech.lean` and to the cohomology-vanishing
  results that Phase B and downstream consume.
- **Mathematical soundness**: PASS — the 4-step mathlib-analogist Q1
  recipe (`IsAffineOpen.isLocalization_of_eq_basicOpen` per-coord;
  `IsLocalizedModule.pi` for finite products; `IsLocalizedModule.iso`
  for transport; `LinearEquiv.exact_iff_exact` for the exactness
  transport) is a structurally coherent reduction of a product-of-
  localisations exactness statement to the named Mathlib facts. The
  recipe is *bounded* in the precise sense that each step has a
  named target lemma.
- **Sunk-cost reasoning detected**: no — the L1802 lane is in its
  *first* prover iter on a fresh recipe blessed by the analogist; one
  iter of partial-progress (Steps 1a + 1b landed, Steps 1c–4 deferred)
  is the normal cadence for a bounded ~100-line proof. L1120's 7-iter
  history of failure is correctly walled off and not implicitly
  inherited.
- **Phantom prerequisites**: the recipe cites `IsLocalizedModule.pi`
  at `Mathlib.RingTheory.TensorProduct.IsBaseChangePi:93`. The analogist
  vouched for it. Not re-verified here, but a single-line LSP spot-check
  before the iter-109 prover dispatch costs nothing and the planner
  should do it (the citation form `IsBaseChangePi:93` suggests a
  typeclass file, not a `Pi`-named lemma — verify the name).
- **Effort honesty**: reasonable — ~100–110 LOC remaining for Steps
  1c–4 on top of the ~19 LOC already landed is within the analogist's
  ~80–120 LOC envelope and consistent with the 4-step decomposition.
- **Verdict**: CHALLENGE — the route is sound to attempt in iter-109,
  but **the strategy does not articulate an exit criterion**. Without
  one, this lane risks repeating L1120's trajectory: each iter "looks
  bounded," partial progress accrues, and the recipe quietly slides
  from "100 LOC, 1 iter" into "300 LOC, 7 iters." The planner must
  commit an explicit budget *before* dispatching the iter-109 prover.
  Recommendation: max 2 further prover iters on L1802 before the
  decision tree fires (close, defer-as-Mathlib-gap, or promote C1).

### Route: Phase A — L1120 `cechCofaceMap_pi_smul` PAUSED

- **Goal-alignment**: PASS — closure of this lemma is required for the
  R-linearity certification of `cechCofaceMap`.
- **Mathematical soundness**: PASS — the underlying claim is true; the
  failure is uniformly at the *tactical / elaboration* layer (Pi.lift
  codomain whnf, discrim-tree unification).
- **Sunk-cost reasoning detected**: no — the strategy correctly pauses
  this lane and **explicitly retires** the "refactor body" option as
  sunk-cost. This is good practice. The iter-107 scaffold preservation
  ("load-bearing partial progress") is borderline-sunk-cost language
  but is defensible: those `have` blocks compile, are correct, and
  reduce the trailing-sorry surface area for a future re-attempt.
- **Phantom prerequisites**: none new.
- **Effort honesty**: now-deferred; no estimate carried.
- **Verdict**: SOUND — the pause + scaffold-preserve decision is
  the right call, and Path B (`set F := ... + change`) documented for
  a future re-attempt gives the planner a structurally-new attack
  rather than another re-skin of the failed approach.

### Route: Phase B — `Differentials.lean` non-`h_exact` sorries

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — `h_exact` correctly deferred
  parallel to `instIsMonoidal_W` on a named Mathlib gap (stalkwise
  criterion for sheaf-of-modules exactness).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none flagged.
- **Effort honesty**: 8–12 iters / 250 LOC for 4 sorries
  (`relativeDifferentialsPresheaf_isSheaf`, `smooth_iff_locally_free_omega`,
  `cotangent_at_section`, `serre_duality_genus`) is **plausible to mildly
  under-counted**. `serre_duality_genus` in particular is a Serre-duality
  invocation; if Mathlib's Serre-duality machinery doesn't apply
  directly at the smooth-proper-curve level it's a multi-iter route in
  its own right. Not enough information in the strategy to judge whether
  the 250 LOC absorbs that risk.
- **Verdict**: SOUND with a note — flag `serre_duality_genus` as the
  individual highest-variance item in Phase B's LOC budget and
  consider an analogist spot-check before scheduling it.

### Route: Phase C0 — Monoidal `X.Modules`

- **Goal-alignment**: PASS — deferring `instIsMonoidal_W` is the
  soundness-rule-compliant treatment of the `stalk_tensorObj` Mathlib gap.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Verdict**: SOUND.

### Route: Phase C1 — `LineBundle` refactor (queued)

- **Goal-alignment**: PASS — the existing `CommRing.Pic Γ(X, ⊤)` body
  is admitted-wrong on non-affine schemes; replacing it with
  `MonoidalCategory.Invertible (X.Modules)` is required for the
  protected `LineBundle` to carry the intended mathematical content.
- **Mathematical soundness**: PASS — the route is standard.
- **Sunk-cost reasoning detected**: no.
- **Effort honesty**: 5–8 iters / 200–300 LOC reflects the iter-105
  revision (up from 3 / 100); the comm-group structure on
  `Invertible (X.Modules)` may need new lemmas about tensor inverses,
  acknowledged. Reasonable.
- **Verdict**: SOUND. The trigger condition is the operative concern
  (see Must-fix below).

### Route: Phase C2 — `PicardFunctor` re-derivation

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Effort honesty**: 4–6 iters / 150 LOC including étale
  sheafification and abelian-group structure is on the optimistic side
  but defensible given that the protected signatures are unchanged.
- **Verdict**: SOUND.

### Route: Phase C3 — DEFERRED via `JacobianWitness` exit policy

- **Goal-alignment**: PARTIAL — the protected `Jacobian`, `ofCurve`,
  and `Jacobian` instances compile against `Nonempty (JacobianWitness C)`,
  not against an actual construction. The strategy explicitly
  acknowledges this in the "plain-language disclosure" paragraph. This
  is the soundness-rule-compliant landing for an unbounded gap. Per
  directive, not re-litigated this iter.
- **Mathematical soundness**: PASS — the witness pattern is
  axiomatically equivalent to declaring the named Mathlib gap.
- **Verdict**: SOUND (stable from iter-106; directive forbids
  re-litigation).

### Route: Phases D, E — `Genus`/`Jacobian`/instances; Abel–Jacobi

- **Goal-alignment**: PARTIAL — re-classified iter-105/107 as
  BLOCKED-ON-C3-WITNESS. The honest framing is now in STRATEGY.md.
- **Verdict**: SOUND (stable).

## Alternative routes (suggested)

### Alternative: Defer L1802 `h_loc_exact` as a fourth named Mathlib gap

- **What it looks like**: Surface
  `IsLocalizedModule.Away f.1` on finite products explicitly as a
  fourth scope-resident named Mathlib gap (alongside `instIsMonoidal_W`,
  `h_exact`, `nonempty_jacobianWitness`). Leave the inline `sorry`
  at L1802 with a `-- MATHLIB GAP: ...` annotation; cite the named
  Mathlib lemma the gap would close to. The remainder of
  `BasicOpenCech.lean` then flows downward against that named sorry,
  unblocking Phases B/C1/C2.
- **Why it might be cheaper or sounder**: the strategy already accepts
  the soundness-rule precedent for this move (`h_exact`,
  `instIsMonoidal_W`, `nonempty_jacobianWitness`). The "TRACTABLE
  within scope, ~80 LOC" judgment on L1802 was made *before*
  Phase A had ever attempted it. After iter-109, if Steps 1c–4 don't
  close cleanly, defer is the natural escape valve and is structurally
  cheaper than promoting C1 (which is a strict expansion of scope).
  Critically: deferring L1802 *does not* expand the project's named-gap
  surface in any qualitatively-new way — it just makes one more named
  gap explicit.
- **What the current strategy may have rejected**: the strategy
  asserts L1802 is "TRACTABLE within scope, will be closed during
  Phase A" but cites no positive evidence beyond the analogist Q1
  ALIGN verdict. If iter-109's prover lane partials, the planner
  should treat that assertion as falsified and switch.
- **Severity of the omission**: major — the strategy commits to
  "C1 promotion" as the iter-110 escape valve if L1802 stalls, but
  defer-as-gap is a strictly cheaper escape that should be evaluated
  first. C1 promotion is the right move if the *strategic* plan needs
  to reroute around Phase A entirely; defer-as-gap is the right move
  if the *tactical* plan just needs to unblock downstream against a
  named gap.

### Alternative: Time-boxed parallelism on L1802 and Phase B

- **What it looks like**: While iter-109 dispatches a prover on L1802
  Steps 1c–4, the planner *simultaneously* dispatches a second prover
  lane on a non-`h_exact` Phase B sorry (e.g.,
  `relativeDifferentialsPresheaf_isSheaf` at L113) that does not
  depend on Phase A closure. Phase B sorries are independent of
  `h_loc_exact` at the file level.
- **Why it might be cheaper or sounder**: hedges against the
  L1802-stall outcome by accumulating Phase B closure in parallel.
  The autonomous loop has been single-lane-substantive every iter
  since iter-107's "single prover lane" policy; that policy was right
  *while* the lane was unblocked-and-bounded, but is now a single
  point of failure.
- **What the current strategy may have rejected**: the iter-108 plan
  cited "single substantive prover lane on L1783" as deliberate. The
  rationale was attention concentration on a known-hard recipe; with
  the recipe now partially landed and the next steps named, that
  rationale weakens.
- **Severity of the omission**: minor — parallelism risks dispatcher
  contention and complicates progress-critic accounting; reasonable to
  defer until L1802's outcome is known. But the planner should
  consider it for iter-110+ if L1802 ships and Phase B starts.

## Sunk-cost flags

- `"The iter-107 partial-proof scaffold (incl. have h_iter104 at L1119)
  is preserved as load-bearing partial progress for a future
  re-attempt."` — Why this is sunk-cost-adjacent: preserving compiled
  partial-proof scaffolding *can* be sound (it's correct code), but
  the "load-bearing" framing can drift into "we already wrote it, so
  the future re-attempt must reuse it." Recommendation: when the
  L1120 lane is reopened (whenever that happens), the future planner
  should explicitly *re-evaluate* whether `have h_iter104` is on the
  optimal proof path, not preserve it by default. The Path B approach
  (`set F := cechCofaceMap_summand_family s₀ n` + `change`) may
  bypass it entirely.

(No other sunk-cost claims rise to flagging.)

## Prerequisite verification

- `IsLocalizedModule.pi` (cited at
  `Mathlib.RingTheory.TensorProduct.IsBaseChangePi:93`): NOT
  RE-VERIFIED — the analogist returned ALIGN_WITH_MATHLIB; the
  citation form suggests a typeclass instance, not necessarily a
  `Pi`-named lemma. The planner should LSP-spot-check the exact
  declaration name before dispatching the iter-109 prover. If the
  name is wrong, the prover wastes the iter chasing the rename
  rather than the proof.
- `IsAffineOpen.isLocalization_of_eq_basicOpen`: NOT VERIFIED —
  similar recommendation.
- `IsLocalizedModule.iso`: NOT VERIFIED — similar.
- `LinearEquiv.exact_iff_exact`: NOT VERIFIED — similar.

The strategy correctly cites the analogist as the verifier, so this
section is a procedural belt-and-braces note, not a substantive
phantom-prerequisite flag.

## Must-fix-this-iter

- **Route Phase A (L1802): CHALLENGE** — the iter-109 entry plan
  language in STRATEGY.md ("Branch a: closes L1783" / "Branch b:
  stalls on L1783") does not accommodate the actual iter-108 outcome
  (**partial progress within the bounded recipe**). The planner must
  add a third branch — "Branch c: iter-108 partial-progressed within
  recipe; iter-109 dispatches prover on Steps 1c–4 with an explicit
  budget of N further iters" — and pick N before dispatch. Recommended
  N = 1 further iter; on second consecutive PARTIAL, the decision
  tree fires (defer-as-gap OR C1 promotion). Without the budget, the
  iter-108→109 transition smuggles in indefinite continuation by
  default.

- **Alternative "defer L1802 as Mathlib gap": major** — the strategy
  treats C1 promotion as *the* escape valve for an L1802 stall, but
  defer-as-named-gap is a strictly cheaper alternative that the
  strategy doesn't mention. The planner must either add it to the
  iter-109+ decision tree as a third option (alongside "close L1802"
  and "fire C1 promotion") or record an explicit rebuttal naming why
  defer-as-gap is structurally worse than C1 promotion here.

- **Route Phase B (`serre_duality_genus`): note** — flag this single
  sorry as the variance-driver in Phase B's 250 LOC budget; an
  analogist Q on Mathlib's Serre-duality coverage for smooth proper
  curves should fire *before* this sorry is scheduled, not after.
  Not a CHALLENGE on the current iter (Phase B is mid-term).

## Overall verdict

A fresh mathematician would approve the strategy with **two specific
amendments**: (1) the iter-109 entry plan needs a "partial-progress
within bounded recipe" branch with an explicit further-iter budget,
because the iter-108 outcome falsifies the strategy's binary
close-or-stall framing; (2) defer-L1802-as-named-Mathlib-gap should
be added to the iter-110+ escape-valve menu, currently artificially
narrowed to "fire C1 promotion." Neither is a REJECT; both are
material enough that proceeding without addressing them would
re-introduce the same sunk-cost vulnerability the strategy correctly
identified for L1120. The Phase C3 exit policy and its plain-language
disclosure are the project's most mature strategic decisions and
remain sound; Phase B / C0 / C1 / C2 sequencing is sound; the
L1120-paused decision is sound. The single live concern is **the
iter-109 dispatch should not happen without a written exit criterion
on L1802.**
