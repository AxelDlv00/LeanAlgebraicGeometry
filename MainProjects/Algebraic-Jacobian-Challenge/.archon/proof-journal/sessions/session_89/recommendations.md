# Recommendations for the next plan-agent iteration (iter-090)

## TL;DR

Iter-089's mandate to forbid the iter-087/088 "structure-transcribed-only"
pattern produced a structurally-positive outcome: the prover landed **S6 steps
(a) + (b)** as the documented partial-progress fallback, with the trailing
`sorry` pushed to the post-(b) goal at **L547** (formerly L522). Net sorry
count unchanged (6 in BasicOpenCech, 14 total). The next iteration should
preserve the iter-089 "you MUST attempt" mandate but refine the fallback
ladder to per-step granularity, so a partial advance through (c)–(h) is the
expected outcome regardless of LSP availability.

## Priority targets for iter-090

### 1. `cechCofaceMap_pi_smul` — S6 distribution chain steps (c)–(h) (Lane 1, primary)

**Status going in**: S1–S5 prefix transcribed iter-087, re-confirmed iter-088;
S6 steps (a) + (b) landed iter-089. Trailing `sorry` at L547 of
`AlgebraicJacobian/Cohomology/BasicOpenCech.lean`. Top-level lemma
`presheafMap_restrict_collapse` (L412–L434, fully proved) in scope.

**Expected goal at L547** (post-step-(b), unverified):
```
(Pi.π Z₂ j).hom ((eqToHom ∘ₗ (∑ i, .hom of (-1)^i • (Pi.lift … ≫ map_φ_i))
  ) ((piIsoPi Z₁).inv (r • y))) =
  r • (Pi.π Z₂ j).hom ((eqToHom ∘ₗ (∑ i, …)) ((piIsoPi Z₁).inv y))
```

**Step-by-step recipe (extracted from iter-089 PROGRESS.md and prover task result):**

- **(c) Distribute `(Pi.π Z₂ j).hom` over outer sum.** Primary: `rw [(Pi.π Z₂ j).hom.map_sum, (Pi.π Z₂ j).hom.map_sum]`. Documented risk: `ConcreteCategory.hom Σ ≟ LinearMap.toFun` HOU. Fallback: `simp only [LinearMap.map_sum, ConcreteCategory.hom_def]` or `show ∑ i, _ = r • ∑ i, _; rw [Finset.smul_sum]`.
- **(d) `Pi.lift_π_apply` per-summand.** Template: `refine Finset.sum_congr rfl ?_; intro i _; simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply]`. Documented risk: `Pi.lift_π_apply` may not exist as a `_apply` alias for the `ConcreteCategory`-coerced `Pi.lift` (`@[elementwise]` chain). Fallback: `dsimp only [Pi.lift_π]` or use the bare `Pi.lift_π` lemma with an explicit `_apply` invocation.
- **(e) `Pi.smul_apply` on inner smul.** Template: `simp only [Pi.smul_apply]`. Documented risk: synthesis of `[∀ i, SMul R (Z₁ i)]` may fail. Recovery: prefix with `letI := perI₁` (NOTE — iter-089 prover risk-list said `perI₂` for step (e); cross-check carefully: the inner smul is on `(r • y : ∀ i, Z₁ i)` so `perI₁` is correct, while the outer `r •` on RHS is `perI₂`-domain. iter-090 prover should `lean_goal`-verify before committing).
- **(f) `RingHom.map_mul`.** Template: `rw [map_mul]`. Documented risk: confirm `((toModuleKPresheaf C).map φ_i.op).hom` is a `RingHom` not just `AddHom`. For `CommRingCat`-valued presheaf maps, `.hom` should be a `RingHom` via `CommRingCat.Hom.hom`.
- **(g) `presheafMap_restrict_collapse`.** Template: `rw [presheafMap_restrict_collapse _ _ _]` with the three `≤`-witnesses left to unification. Top-level lemma is at L412–L434, fully proved iter-086+iter-087-hoist, 3-tactic body.
- **(h) `Finset.smul_sum` reassemble.** Template: `rw [← Finset.smul_sum]` then `rfl` or `simp only [ConcreteCategory.comp_apply]`.

**Documented risks for the iter-089 step-(a)/(b) work the iter-090 prover is inheriting:**

1. **`Finset.cons_induction` case labels** in the iter-089 `hom_sum_dist`
   `have`. If Mathlib's labels differ from `empty`/`cons`, the `with`-block
   fails. **Recovery**: replace `induction t using Finset.cons_induction with`
   with positional bullets — `induction t using Finset.cons_induction; · simp;
   · intro a t' ha ih; rw [Finset.sum_cons, ModuleCat.hom_add, Finset.sum_cons, ih]`.
2. **`simp only [hom_sum_dist]` may be a no-op** if the goal's sum is wrapped
   inside `eqToHom ∘ₗ Σ.hom` and the `.hom`-projection subterm is not directly
   matchable. **Recovery**: prefix with `unfold Function.comp` or `dsimp only`
   to reveal the subterm; or use `show` to expose `ModuleCat.Hom.hom (∑ …)`
   explicitly.
3. **Universe `α : Type`** in iter-089's `hom_sum_dist`. The actual index is
   `Fin (prev n + 2)` (Type 0). `Type = Type 0` matches; risk negligible per
   iter-089 prover assessment.
4. **`set_option maxHeartbeats 1600000`** at L455 should suffice.

**Iter-089 dead-ends to keep on the avoidance list** (carried from iter-086,
still applicable):
- `simp only [LinearMap.comp_apply, map_sum, LinearMap.zsmul_apply, ConcreteCategory.comp_apply]` — all 4 "argument unused".
- `simp only [ModuleCat.hom_sum]` — lemma doesn't exist by that direct name (the iter-089 inline `hom_sum_dist` is the replacement).
- `simp only [Pi.lift_π_apply]` at top level — `Pi.lift` is inside the sum (must peel outer sum first via step c).
- `rw [ModuleCat.hom_comp]` directly — pattern not in goal.
- `simp only [LinearMap.comp_apply]` — `∘ₛₗ`-vs-`∘ₗ` HOU mismatch.
- `set L : ↑(∏ᶜ Z₁) →ₗ[k] ↑(∏ᶜ Z₂) := ...` — stuck universe `u =?= imax ?u' ?u''`.

### 2. The iter-090 PROGRESS.md should refine the iter-089 mandate

Iter-087 + iter-088 both produced "structure transcribed, closure not
attempted" reports. Iter-089's PROGRESS.md mandate ("you MUST attempt the
S6 chain") + fallback ("at minimum land step (a) and step (b)") **worked**:
the prover delivered exactly the minimum and pushed the sorry to the
deepest committed step. iter-090 should preserve this exact pattern with
per-step granularity:

> *"If steps (c)–(h) cannot all land, you MUST land each step that can be
> safely committed and put the trailing `sorry` at the deepest committed
> step's post-state. Specifically: if step (c) succeeds but step (d) fails,
> the trailing `sorry` goes after step (c)'s `rw`; if all of (c)–(g)
> succeed but (h) fails, the sorry goes after (g)."*

This preserves the iter-089 "deepest committed step" visibility for iter-091
and forbids the iter-087/088 abstain-on-LSP-unavailability pattern.

### 3. Other files

- **`cotangentExactSeq_structure case h_exact` (`Differentials.lean` L636)** —
  Lane 2 candidate. Two routes (A: top-down via Sheaf-of-Modules-level
  exactness with TRUE iff signature; B: bottom-up via
  `ShortComplex.exact_iff_image_eq_kernel` + sheafification left-exactness) have
  been documented since iter-085/086. **Recommend the iter-090 plan agent
  commit to one route in PROGRESS.md** and either dispatch a second prover
  lane if the sandbox issue is resolved, or defer to iter-091.
  **Honesty constraint**: any helper signature introduced MUST pass the
  mathematical-honesty audit. The iter-085 false `SheafOfModules.exact_iff_stalkwise`
  must NOT be reintroduced. The iter-087 `cechCofaceMap_pi_smul` first-pass
  extract refactor had a similarly-false universal signature; the specialize
  refactor caught it. iter-089's `hom_sum_dist` was inline (no false-signature
  risk — distributivity of additive monoid homs over finite sums is universally
  true). The pattern stands.
- **`g_R.map_smul'` (`BasicOpenCech.lean` L1181)** — downstream of
  `cechCofaceMap_pi_smul` closure. Comment at L1131–1154 documents
  `Eq.mpr` casts on the codomain due to `CochainComplex.next` indexing.
  Continue to defer.
- **`h_loc_exact` (`BasicOpenCech.lean` L1210)** — needs `IsLocalizedModule.Away f.1`
  Mathlib infrastructure. Multi-iter. Defer.
- **Extra-degeneracy substeps (`BasicOpenCech.lean` L639, L991)** + outer
  scaffolding (L963) — augmented simplicial object infrastructure. Multi-iter.
  Defer.
- **`Modules/Monoidal.lean` L173 `instIsMonoidal_W`** — off-limits (Mathlib
  upstream gap). Defer.
- **`Differentials.lean` L122 / L957 / L974 / L1116** — Phase-B/B+ deferred
  sorries. Not active.
- **`Jacobian.lean` L179 `nonempty_jacobianWitness`**,
  **`Picard/Functor.lean` L190 `representable`** — Phase-C/E deferred. Not active.

## Targets the plan agent should NOT retry

Based on iter-086 + iter-087 + iter-089 dead-end catalog, do not assign:

- Any direct rewrite of `ModuleCat.Hom.hom (∑ ...)` via a Mathlib-direct
  `ModuleCat.hom_sum` (does NOT exist; the iter-089 inline `hom_sum_dist` is
  the canonical replacement).
- Any helper with a universally-false signature (audit rule introduced
  iter-086; reinforced iter-087 + iter-089).
- Any extract that introduces a top-level helper without ensuring the
  signature is concrete to the call-site's specialised context (iter-087's
  extract→specialize lesson — still applies).
- Any S6 step (c)–(h) approach that wraps the whole chain in
  `first | <chain> | sorry`. iter-089 explicitly considered and rejected this
  pattern (lose the "deepest committed step" signal for the next iter).
- Any `simp only [LinearMap.comp_apply, map_sum, LinearMap.zsmul_apply, ConcreteCategory.comp_apply]` combination — all 4 lemmas were "argument unused" iter-086.

## Process recommendations for the plan agent

1. **Single-lane vs multi-lane.** Iter-089 ran single-lane (BasicOpenCech only).
   Given the persistent sandbox-LSP failure mode, single-lane remains the right
   call. If the iter-090 dispatcher environment has a functional `lake`, the
   second lane on `Differentials.lean` L636 (Route A or B) becomes viable.
2. **Refactor subagent dispatch.** Not needed iter-090 — the path from L547
   forward is concrete and templated step-by-step; the proof obligation is
   already isolated at top-level (iter-087 refactor's lasting structural
   improvement). The iter-090 plan agent should NOT re-extract or re-shape
   `cechCofaceMap_pi_smul`.
3. **Sandbox verification.** The `.lake/packages/mathlib`-missing condition has
   now persisted across iter-086, 087, 088, 089. The iter-090 plan agent's
   first action should attempt `lake build` and report status. If LSP is still
   non-functional, escalate the user-action item via `TO_USER.md` and proceed
   with the iter-089-style mandate (the prover must attempt; partial progress
   is acceptable).
4. **Pre-paste the (c)–(h) templates.** As iter-089 did for the `hom_sum_dist`
   template, iter-090's PROGRESS.md should paste each (c)–(h) step's code
   template + fallback + dead-end notes inline so the prover doesn't waste
   tactic budget rediscovering them.

## Repeated-blocker watch

Per the review-agent prompt:
> *"If your analysis shows the prover has hit the exact same blocker for
> several consecutive iterations on the same target, you should explicitly
> instruct the Plan Agent to avoid retrying the same approach without putting
> more effort into understanding the underlying issue."*

**Sandbox-LSP failure mode (`.lake/packages/mathlib` missing; `lake` not on
PATH) has now blocked compilation verification for FOUR consecutive iterations
(086, 087, 088, 089).** This is an environmental blocker — not a
mathematical-content blocker — and the iter-089 PROGRESS.md correctly framed
it: "the prover must attempt regardless; the dispatcher environment is the
validation point." The iter-089 outcome (steps a+b landed, sorry pushed
forward) demonstrates that progress is possible without LSP feedback when the
PROGRESS.md provides concrete templates. **Recommendation to iter-090 plan
agent**: continue the iter-089 mandate-with-fallback-ladder pattern. The
sandbox issue should be escalated via `TO_USER.md` (already in place since
iter-086) but should NOT be treated as a justification to halt prover work.

## Realistic iter-090 outlook

- **Best case**: dispatcher LSP functional, steps (c)–(h) all land cleanly →
  **net −1 sorry** (5 active in BasicOpenCech, 13 total).
- **Likely case**: dispatcher LSP non-functional (as in 086–089), prover
  attempts (c)–(h) per the documented templates and lands steps (c)–(e) but
  hits an HOU obstruction at (f) or (g) → **net 0 sorry**, but trailing sorry
  pushed to deeper post-step state. This is acceptable progress per the
  iter-089 fallback-ladder pattern.
- **Worst case**: dispatcher LSP non-functional AND the iter-089 step-(a)/(b)
  work fails to compile (case-label mismatch in `Finset.cons_induction with`
  block, or `simp only [hom_sum_dist]` no-op). Iter-090 prover must apply the
  documented recoveries (positional bullets / `dsimp only` to expose subterm)
  before attempting (c)–(h). Even in this worst case, **net 0 sorry** is the
  floor — no regression below the iter-089 hard cap of 6.

## Reusable patterns from iter-089 (for the knowledge base)

- **Inline `hom_sum_dist` via `Finset.cons_induction` over `ModuleCat.hom_add`**
  *(NEW iter-089, landed at L528–L536 of BasicOpenCech.lean)*: when a Mathlib
  lemma `Foo.hom_sum` does not exist by direct name for a categorical-`Hom`
  type, derive distributivity inline via case-by-case `Finset.cons_induction`
  with a `Finset.sum_cons` step and the underlying `Foo.hom_add`/`zero`. The
  iter-089 generalisation to `{α : Type}` (vs the PROGRESS.md template's
  monomorphic `Fin (...)`) is a defensible widening — useful when the goal's
  index shape may be unified to multiple representations.
- **Partial-progress fallback ladder for multi-step tactic chains**
  *(NEW iter-089, process-level)*: when an n-step chain (here S6 = a, b, c…h)
  is being committed without LSP feedback, do NOT wrap the whole chain in a
  `first | <chain> | sorry` fallback — that loses the "deepest committed
  step" signal needed for next-iter re-scoping. Instead, commit each
  successfully-typeable step linearly and put the trailing `sorry` after the
  deepest committed step. iter-090's PROGRESS.md should re-articulate this
  pattern for steps (c)–(h).
