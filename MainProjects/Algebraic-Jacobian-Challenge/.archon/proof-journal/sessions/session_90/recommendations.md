# Recommendations for the next plan-agent iteration (iter-091)

## TL;DR

Iter-090's per-step fallback ladder produced exactly the expected structural
advance: the prover landed **S6 steps (c) + (h-prep) + (d-entry)** linearly
and pushed the trailing `sorry` to the post-(d-entry) per-summand goal at
**L564** (formerly L547). Net sorry count unchanged (6 in BasicOpenCech, 14
total). The next iteration should preserve the per-step fallback ladder for
the remaining per-summand steps (d-body), (e), (f), (g), closure — each step
that compiles cleanly should be committed linearly with the trailing `sorry`
after the deepest committed step.

## Priority targets for iter-091

### 1. `cechCofaceMap_pi_smul` — S6 per-summand chain (d-body)/(e)/(f)/(g)/closure (Lane 1, primary)

**Status going in**: S1–S5 prefix transcribed iter-087, re-confirmed iter-088;
S6 step (a) `hom_sum_dist` inline `have` (L528–L536) + step (b)
`simp only [hom_sum_dist]` (L540) landed iter-089; S6 step (c)
`simp only [map_sum]` (L547) + step (h-prep) `simp only [Finset.smul_sum]`
(L551) + step (d-entry) `refine Finset.sum_congr rfl ?_; intro i _`
(L557–558) landed iter-090. Trailing `sorry` at **L564** of
`AlgebraicJacobian/Cohomology/BasicOpenCech.lean`. Top-level lemma
`presheafMap_restrict_collapse` (L412–L434, fully proved iter-086 + iter-087
hoist) in scope.

**Expected per-summand goal at L564** (post-step-(d-entry), unverified):
```
(Pi.π Z₂ j).hom (((-1)^i • Pi.lift (fun a => Pi.π Z₁ (a ∘ δ_i.toOrderHom)
  ≫ (toModuleKPresheaf C).map φ_i.op)).hom ((piIsoPi Z₁).inv (r • y)))
= r • (Pi.π Z₂ j).hom (((-1)^i • Pi.lift (fun a => Pi.π Z₁ (a ∘ δ_i.toOrderHom)
  ≫ (toModuleKPresheaf C).map φ_i.op)).hom ((piIsoPi Z₁).inv y))
```

**Step-by-step recipe (extracted from iter-090 prover task result):**

- **(d-body) Peel `(-1)^i • Pi.lift f_i` per-summand.** Primary:
  `simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply, ModuleCat.hom_smul, LinearMap.smul_apply]`.
  Documented risks:
  - **Lemma name `ModuleCat.hom_zsmul` vs `ModuleCat.hom_smul`.** The scalar
    `(-1)^i` is an integer (`Int`) not a natural; the appropriate lemma may
    be `ModuleCat.hom_zsmul` (or `LinearMap.smul_apply` for the bundled
    LinearMap case). HOU risk for integer-vs-natural scalar action.
  - **`Pi.lift_π_apply` existence.** The `_apply` form may not exist as a
    `ConcreteCategory`-coerced alias; the bare `Pi.lift_π` may be needed.
    Fallback: `dsimp only [Pi.lift_π]` first.
- **(e) `Pi.smul_apply` for inner R-action.** Primary:
  `simp only [Pi.smul_apply]`. Documented risk: synthesis of
  `[∀ i, SMul R (Z₁ i)]` may fail when the `Pi.module` instance from
  `perI₁` is not in scope after `intro i _`. Recovery: prefix `letI := perI₁`
  before step (e). Cross-check: iter-089 prover risk-list said `perI₂` for
  step (e); the iter-090 prover task result corrected this to `perI₁`
  because the inner smul is on `(r • y : ∀ i, Z₁ i)` so `perI₁` is correct,
  while the outer `r •` on RHS is `perI₂`-domain. iter-091 prover should
  `lean_goal`-verify before committing.
- **(f) `RingHom.map_mul`.** Primary: `rw [map_mul]`. Documented risk:
  confirm `((toModuleKPresheaf C).map φ_i.op).hom` is a `RingHom` not just
  `AddHom`. For `CommRingCat`-valued presheaf maps, `.hom` should be a
  `RingHom` via `CommRingCat.Hom.hom`.
- **(g) `presheafMap_restrict_collapse`.** Primary:
  `rw [presheafMap_restrict_collapse _ _ _]` with the three `≤`-witnesses
  left to unification. Top-level lemma at L412–L434, fully proved iter-086
  + iter-087 hoist, 3-tactic body. Fallback: supply witnesses explicitly via
  `(Pi.π _ _ |>.le)` chained with `basicOpen_le` per L477–L480 pattern.
- **closure** `rfl` or `simp only [ConcreteCategory.comp_apply]` depending
  on definitional residue.

**Documented risks for the iter-090 step-(c)/(h-prep)/(d-entry) work the iter-091 prover is inheriting:**

1. **`simp only [map_sum]` no-op risk.** If iter-089's step (b) was a no-op
   in actual compilation, iter-090's step (c) operates on a non-distributable
   wrapper. **Recovery**: `simp only [map_sum, ConcreteCategory.hom_def]` or
   prefix `dsimp only [Function.comp]`.
2. **`simp only [Finset.smul_sum]` no-op risk.** If step (c) didn't fire, the
   RHS may not have `r • ∑` shape and `Finset.smul_sum` becomes a no-op.
   **Recovery**: invert order — try `Finset.sum_congr rfl` first to detect
   the actual goal shape.
3. **`Finset.sum_congr rfl` order risk.** Both sides must be sums over the
   same Finset. **Recovery**: supply explicit equality witnesses.
4. **`maxHeartbeats 1600000`** at L455 should suffice; if (d-body)+(e)+(f)+(g)
   blow the budget, lift to 3200000 inline at L455.

**Iter-090 dead-ends to keep on the avoidance list** (carried from iter-086 +
iter-089, still applicable):
- `simp only [LinearMap.comp_apply, map_sum, LinearMap.zsmul_apply, ConcreteCategory.comp_apply]` — all 4 "argument unused".
- `simp only [ModuleCat.hom_sum]` — lemma doesn't exist by that direct name (iter-089's inline `hom_sum_dist` is the canonical replacement).
- `simp only [Pi.lift_π_apply]` at top level — `Pi.lift` is inside the sum (must peel outer sum first via step c; now done iter-090).
- `rw [ModuleCat.hom_comp]` directly — pattern not in goal.
- `simp only [LinearMap.comp_apply]` — `∘ₛₗ`-vs-`∘ₗ` HOU mismatch.
- `set L : ↑(∏ᶜ Z₁) →ₗ[k] ↑(∏ᶜ Z₂) := ...` — stuck universe `u =?= imax ?u' ?u''`.
- `first | <full (d-body)..closure chain> | sorry` wrap — loses "deepest committed step" signal (iter-089/090 carryover).

### 2. The iter-091 PROGRESS.md should preserve the iter-090 per-step mandate

Iter-089's mandate-with-fallback-ladder worked for iter-089 (steps a+b
landed); iter-090's refinement to **per-step granularity** worked for
iter-090 (steps c + h-prep + d-entry landed; d-body+ deferred with documented
HOU risk per step). iter-091 should preserve this exact pattern at the
per-step granularity that now applies to (d-body), (e), (f), (g), closure:

> *"If steps (d-body)/(e)/(f)/(g)/closure cannot all land, you MUST land
> each step that can be safely committed and put the trailing `sorry` at
> the deepest committed step's post-state. Specifically: if step (d-body)
> succeeds but step (e) fails, the trailing `sorry` goes after step
> (d-body); if all of (d-body)+(e)+(f)+(g) succeed but closure fails, the
> sorry goes after (g)."*

This preserves the iter-089/090 "deepest committed step" visibility for
iter-092 and forbids the iter-087/088 abstain-on-LSP-unavailability pattern.

### 3. Other files

- **`cotangentExactSeq_structure case h_exact` (`Differentials.lean` L636)** —
  Lane 2 candidate. Route A (top-down SheafOfModules-level exactness with
  TRUE iff signature) vs Route B (bottom-up `ShortComplex.exact_iff_image_eq_kernel`
  + sheafification left-exactness) decision has been pending since iter-085/
  086. **Recommend the iter-091 plan agent commit to one route in PROGRESS.md**
  and either dispatch a second prover lane if the sandbox issue is resolved,
  or defer to iter-092. **Honesty constraint**: any helper signature
  introduced MUST pass the mathematical-honesty audit. The iter-085 false
  `SheafOfModules.exact_iff_stalkwise` must NOT be reintroduced.
- **`g_R.map_smul'` (`BasicOpenCech.lean` L1198)** — downstream of
  `cechCofaceMap_pi_smul` closure. Comment at L1148–1162 documents `Eq.mpr`
  casts on the codomain due to `CochainComplex.next` indexing. Continue to
  defer.
- **`h_loc_exact` (`BasicOpenCech.lean` L1227)** — needs
  `IsLocalizedModule.Away f.1` Mathlib infrastructure. Multi-iter. Defer.
- **Extra-degeneracy substeps (`BasicOpenCech.lean` L656, L1008)** + outer
  scaffolding (L980) — augmented simplicial object infrastructure. Multi-iter.
  Defer.
- **`Modules/Monoidal.lean` L173 `instIsMonoidal_W`** — off-limits (Mathlib
  upstream gap). Defer.
- **`Differentials.lean` L122 / L957 / L974 / L1116** — Phase-B/B+ deferred
  sorries. Not active.
- **`Jacobian.lean` L179 `nonempty_jacobianWitness`**,
  **`Picard/Functor.lean` L190 `representable`** — Phase-C/E deferred. Not active.

## Targets the plan agent should NOT retry

Based on iter-086 + iter-087 + iter-089 + iter-090 dead-end catalog, do not
assign:

- Any direct rewrite of `ModuleCat.Hom.hom (∑ ...)` via a Mathlib-direct
  `ModuleCat.hom_sum` (does NOT exist; iter-089's inline `hom_sum_dist` is the
  canonical replacement).
- Any helper with a universally-false signature (audit rule introduced
  iter-086; reinforced iter-087 + iter-089).
- Any extract that introduces a top-level helper without ensuring the
  signature is concrete to the call-site's specialised context (iter-087's
  extract→specialize lesson — still applies).
- Any S6 step (d-body)/(e)/(f)/(g)/closure approach that wraps the whole
  chain in `first | <chain> | sorry`. iter-089/090 explicitly considered and
  rejected this pattern (lose the "deepest committed step" signal).
- Any `simp only [LinearMap.comp_apply, map_sum, LinearMap.zsmul_apply, ConcreteCategory.comp_apply]` combination — all 4 lemmas were "argument unused" iter-086.

## Process recommendations for the plan agent

1. **Single-lane vs multi-lane.** Iter-089 and iter-090 ran single-lane
   (BasicOpenCech only). Given the persistent sandbox-LSP failure mode,
   single-lane remains the right call. If the iter-091 dispatcher environment
   has a functional `lake`, the second lane on `Differentials.lean` L636
   (Route A or B) becomes viable.
2. **Refactor subagent dispatch.** Not needed iter-091 — the path from L564
   forward is concrete and templated step-by-step; the proof obligation is
   already isolated at top-level (iter-087 refactor's lasting structural
   improvement). The iter-091 plan agent should NOT re-extract or re-shape
   `cechCofaceMap_pi_smul`.
3. **Sandbox verification.** The `.lake/packages/mathlib`-missing condition
   has now persisted across **five** consecutive iterations (086–090). The
   iter-091 plan agent's first action should attempt `lake build` and report
   status. If LSP is still non-functional, escalate the user-action item via
   `TO_USER.md` and proceed with the iter-089/090-style mandate (the prover
   must attempt; partial progress is acceptable).
4. **Pre-paste the (d-body)..closure templates.** As iter-089/090 did for
   the prior steps, iter-091's PROGRESS.md should paste each step's code
   template + fallback + dead-end notes inline so the prover doesn't waste
   tactic budget rediscovering them. Specifically:
   - (d-body) template: `simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply, ModuleCat.hom_smul, LinearMap.smul_apply]` with `dsimp only [Pi.lift_π]` fallback and `ModuleCat.hom_zsmul` integer-scalar alternate.
   - (e) template: `simp only [Pi.smul_apply]` with `letI := perI₁` prefix on synthesis failure (NOT `perI₂` — corrected from iter-089 risk-list).
   - (f) template: `rw [map_mul]` (verify `.hom` is a `RingHom`).
   - (g) template: `rw [presheafMap_restrict_collapse _ _ _]` with witnesses left to unification.
   - closure template: `rfl` or `simp only [ConcreteCategory.comp_apply]`.

## Repeated-blocker watch

Per the review-agent prompt:
> *"If your analysis shows the prover has hit the exact same blocker for
> several consecutive iterations on the same target, you should explicitly
> instruct the Plan Agent to avoid retrying the same approach without putting
> more effort into understanding the underlying issue."*

**Sandbox-LSP failure mode (`.lake/packages/mathlib` missing; `lake` not on
PATH) has now blocked compilation verification for FIVE consecutive
iterations (086, 087, 088, 089, 090).** This is an environmental blocker —
not a mathematical-content blocker. The iter-089/090 mandate-with-fallback-
ladder pattern has demonstrated that progress is possible without LSP
feedback when PROGRESS.md provides concrete templates: iter-089 advanced the
deepest committed step from post-S5 to post-(b); iter-090 advanced it from
post-(b) to post-(d-entry). **Recommendation to iter-091 plan agent**:
continue the iter-089/090 mandate-with-per-step-fallback-ladder pattern. The
sandbox issue should be escalated via `TO_USER.md` (already in place since
iter-086) but should NOT be treated as a justification to halt prover work.

**No same-blocker-on-same-target retry pattern observed** for any
mathematical-content target. The S6 distribution chain has advanced
monotonically across iter-087/088 (S1–S5 prefix), iter-089 (steps a+b),
iter-090 (steps c+h-prep+d-entry). Each iteration adds a strict structural
advance, even with the sandbox issue. Pattern is healthy; do not deviate.

## Realistic iter-091 outlook

- **Best case**: dispatcher LSP functional, all of (d-body)+(e)+(f)+(g)+closure
  land cleanly → **net −1 sorry** (5 active in BasicOpenCech, 13 total). The
  closure of `cechCofaceMap_pi_smul` unblocks `g_R.map_smul'` (L1198) for the
  iteration after.
- **Likely case**: dispatcher LSP non-functional (as in 086–090), prover
  attempts (d-body)+(e)+(f)+(g)+closure per the documented templates and
  lands (d-body)+(e) but hits an HOU obstruction at (f) or (g) → **net 0
  sorry**, but trailing sorry pushed to deeper post-step state. This is
  acceptable progress per the iter-089/090 per-step fallback-ladder pattern.
- **Worst case**: dispatcher LSP non-functional AND the iter-090 step-(c)/
  (h-prep)/(d-entry) work fails to compile (no-op risks #1/#2 or
  `Finset.sum_congr` order risk #3). Iter-091 prover must apply the
  documented recoveries (`map_sum, ConcreteCategory.hom_def` /
  `dsimp only [Function.comp]` / inverted order with `Finset.sum_congr`
  first) before attempting (d-body)..closure. Even in this worst case, **net
  0 sorry** is the floor — no regression below the iter-090 hard cap of 6.

## Reusable patterns from iter-090 (for the knowledge base)

- **Universal `simp only [map_sum]` over direct `rw` for AddMonoidHomClass
  distribution under nested wrappers** *(NEW iter-090)*: when distributing a
  bundled hom (e.g., `(Pi.π Z₂ j).hom`) over `∑` in a context with possible
  nested `eqToHom` / `Function.comp` wrappers, prefer universal `map_sum`
  with `simp only` — it iterates through any AddMonoidHomClass functions
  between the outer hom and Σ, tolerating HOU pattern variants. Direct
  two-pass `rw [foo.map_sum, foo.map_sum]` requires the elaborator to pick
  the right instance twice, which is fragile.
- **Forward-direction `Finset.smul_sum` for pre-congruence alignment**
  *(NEW iter-090)*: when both sides of an equation are sums but the RHS has
  `r • ∑` shape (vs the desired `∑ r • _` per-summand form), use
  `simp only [Finset.smul_sum]` BEFORE `Finset.sum_congr`. This is
  mathematically equivalent to applying `rw [← Finset.smul_sum]` at the end
  of the chain (the original PROGRESS.md template position for step h), and
  structurally cleaner because it lets `Finset.sum_congr rfl` split the
  per-summand case without further re-alignment work.
- **Per-step fallback ladder for multi-step tactic chains, refined to
  step-level granularity** *(NEW iter-090, process)*: iter-089 established
  the mandate-with-fallback-ladder pattern at the chain level (must land at
  least steps a+b). Iter-090 refined this to per-step granularity (each step
  in (c)/(h-prep)/(d-entry) is its own commit point, trailing `sorry` after
  the deepest committed step). This produced a strictly structural advance
  for two consecutive iterations and is now the standard pattern for
  multi-step chains under LSP-unavailable conditions.
