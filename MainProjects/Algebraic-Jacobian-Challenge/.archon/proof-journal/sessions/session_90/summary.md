# Session 90 — iter-090 review

## Metadata

- **Archon iteration**: 090
- **Stage**: prover (single substantive prover lane — `Cohomology/BasicOpenCech.lean`).
- **Sorry count before iter-090** (per iter-089 state inherited): 14 syntactic
  sites — 6 in `BasicOpenCech.lean` (L547, L639, L963, L991, L1181, L1210),
  5 in `Differentials.lean`, 1 in `Modules/Monoidal.lean`, 1 in `Jacobian.lean`,
  1 in `Picard/Functor.lean`.
- **Sorry count after iter-090**: **14** total. Net **0**. Per-file distribution
  unchanged (6 / 5 / 1 / 1 / 1). In `BasicOpenCech.lean` the trailing sorry
  that was at L547 has been pushed to **L564**: lines shifted by +17 because
  the prover added 3 substantive tactic lines (S6 steps c, h-prep, d-entry) and
  ~15 lines of brief stepwise comments inside `cechCofaceMap_pi_smul`.
  Current `BasicOpenCech.lean` sorry sites: **L564, L656, L980, L1008, L1198,
  L1227** (the iter-089 sites L547/L639/L963/L991/L1181/L1210 all shifted by
  +17). Verified by direct grep this pass.
- **Compilation status iter-090**: **NOT VERIFIED IN SANDBOX**. The prover
  and this review confirmed `.lake/packages/` contains only `checkdecls` and
  `doc-gen4` — Mathlib is missing — and `lake` is not on PATH
  (`No such file or directory: 'lake'`). `lean_diagnostic_messages` failed at
  startup with the same error documented across iter-086…iter-089. This is
  the **fifth consecutive iteration** with this environmental gap. The
  dispatcher environment is expected to fetch Mathlib and verify.
- **Env state** (from `attempts_raw.jsonl` summary line): 28 total events; **1**
  source `Edit` to `BasicOpenCech.lean` (replacing the trailing `sorry` at L547
  with steps c, h-prep, d-entry + ~15 comment lines + trailing `sorry`); **0**
  `lean_goal` (LSP unavailable); **2** `lean_diagnostic_messages` (both
  returned errors — LSP cannot start in this sandbox); **0** `lean_build`;
  **3** `lean_local_search` calls (queries: `Finset.smul_sum`, `smul_sum`,
  `map_sum` — all returned empty `{"items":[]}` because the local repository
  has no Mathlib in scope); **1** `ToolSearch` (loading TodoWrite schema);
  **0** `lean_run_code`, `lean_loogle`, `lean_leansearch`.
- **`lean_verify`**: not run this iteration.

---

## Lane summary

| Lane | File | Status | Sorry Δ | Compile |
|---|---|---|---|---|
| 1 | `Cohomology/BasicOpenCech.lean` | **STEPS (c) + (h-prep) + (d-entry) LANDED (compilation unverified in sandbox)** — distributed `(Pi.π Z₂ j).hom` over outer Σ via `simp only [map_sum]`, pushed RHS outer `r •` through Σ via `simp only [Finset.smul_sum]`, and dropped to per-summand goal via `refine Finset.sum_congr rfl ?_; intro i _`. Trailing `sorry` re-located after step (d-entry) at the per-summand goal. Steps (d-body)/(e)/(f)/(g)/closure explicitly NOT attempted inline. | 0 (6 → 6) | UNVERIFIED |

---

## Lane 1 — `BasicOpenCech.lean`: S6 steps (c) + (h-prep) + (d-entry) landed; (d-body)/(e)/(f)/(g)/closure deferred

**Status**: PARTIAL. Iter-090 PROGRESS.md preserved the iter-089
"you MUST attempt" mandate with a refined **per-step fallback ladder** for
steps (c)–(h): each step that compiles cleanly is committed linearly with the
trailing `sorry` after the deepest committed step. The prover delivered three
substantive steps and explicitly justified deferring the per-summand inner
work (d-body, e, f, g, closure) on HOU/lemma-name uncertainty without LSP
feedback.

### Concrete delivery (single Edit event, L540–L564 post-edit)

The iter-089 trailing `sorry` at L547 (post-step-(b) goal) was replaced with:

```lean
  simp only [hom_sum_dist]                              -- iter-089 step (b), preserved
  -- S6 step (c) [iter-090]: distribute `(Pi.π Z₂ j).hom` (a LinearMap via
  -- the ModuleCat `.hom` projection) over the outer Finset.sum via
  -- universal `map_sum` (LinearMap is AddMonoidHomClass). `simp only`
  -- tolerates HOU pattern variants and iterates through any nested
  -- AddMonoidHom-class functions (e.g., `eqToHom`) sitting between the
  -- outer hom and Σ.
  simp only [map_sum]                                   -- iter-090 step (c)
  -- S6 step (h-prep) [iter-090]: push outer `r •` on RHS through Σ via
  -- `Finset.smul_sum` (forward direction `r • ∑ = ∑ r • _`) so both sides
  -- align to `∑ i ∈ s, _` form, enabling per-summand congruence.
  simp only [Finset.smul_sum]                           -- iter-090 step (h-prep)
  -- S6 step (d-entry) [iter-090]: drop the outer Σ via per-summand
  -- congruence. After this, the goal is per-summand for a fixed i:
  --   (Pi.π Z₂ j).hom (((-1)^i • Pi.lift f_i).hom ((piIsoPi Z₁).inv (r • y)))
  --   = r • (Pi.π Z₂ j).hom (((-1)^i • Pi.lift f_i).hom ((piIsoPi Z₁).inv y))
  -- where f_i a = Pi.π Z₁ (a ∘ δ_i.toOrderHom) ≫ (toModuleKPresheaf C).map φ_i.op.
  refine Finset.sum_congr rfl ?_                        -- iter-090 step (d-entry)
  intro i _
  -- S6 (d-body)/(e)/(f)/(g)/closure remain for iter-091: peel `(-1)^i •` and
  -- `Pi.lift` (via Pi.lift_π_apply or Pi.lift_π); surface inner `r •` via
  -- `Pi.smul_apply`; `map_mul` to split the restricted-product;
  -- `presheafMap_restrict_collapse` to collapse the algebra-map chain;
  -- close by `rfl` or `simp only [ConcreteCategory.comp_apply]`.
  sorry
```

Counts: 3 substantive tactic lines (L547, L551, L557–558) + ~15 commentary
lines (well under the 20-line PROGRESS.md cap) + trailing `sorry` at L564.
Comparison: iter-089 added ~25 lines (10 for the `hom_sum_dist` `have` block
+ 1 for `simp only [hom_sum_dist]` + ~12 of commentary); iter-090's increment
is ~17 lines (3 tactic + ~15 comment, partially overlapping with iter-089's
commentary which was replaced).

### Adaptation notes from PROGRESS.md template

The PROGRESS.md template for step (h) was at the END of the chain
(`rw [← Finset.smul_sum]`); the prover **re-ordered** it to before the
per-summand congruence (forward direction `r • ∑ = ∑ r • _`). Rationale
from the task result: mathematically equivalent, and lets `Finset.sum_congr`
split per-summand cleanly without needing both sides re-aligned later.

The PROGRESS.md template for step (c) used a direct two-pass `rw`
(`rw [(Pi.π Z₂ j).hom.map_sum, (Pi.π Z₂ j).hom.map_sum]`); the prover
preferred universal `simp only [map_sum]` for HOU robustness through nested
AddMonoidHomClass functions (e.g., `eqToHom`). This generalisation is
defensible — the universal `map_sum` fires under any AddMonoidHomClass
instance and tolerates the elaborator's choice of how to shape the prior
`simp` chain.

### Why steps (d-body)/(e)/(f)/(g)/closure were NOT attempted inline

The prover task result enumerates the per-step HOU risks (verbatim):

- **(d-body)** Peel `(-1)^i • Pi.lift f_i` per-summand. The scalar `(-1)^i`
  requires `ModuleCat.hom_zsmul` (lemma name unverified locally; may be
  `ModuleCat.hom_smul` or `LinearMap.smul_apply` — each carrying HOU risk
  for the integer-vs-natural scalar action). The `Pi.lift` peel requires
  `Pi.lift_π_apply` (`.hom`-elementwise form; iter-089 confirmed name
  uncertainty).
- **(e)** `Pi.smul_apply` on `(r • y) (j ∘ δ_i.toOrderHom)`. May need
  `letI := perI₁` prefix for `[∀ i, SMul R (Z₁ i)]` synthesis
  (PROGRESS.md documented risk #2).
- **(f)** `map_mul` on `((toModuleKPresheaf C).map φ_i.op).hom`. Must
  confirm this `.hom` is a `RingHom`, not just `AddHom`.
- **(g)** `presheafMap_restrict_collapse _ _ _` — the three `≤`-witnesses
  are documented to flow from unification.
- **closure** — `rfl` or `simp only [ConcreteCategory.comp_apply]`
  depending on definitional residue.

Each step carries non-trivial HOU risk without LSP feedback. Chaining them
inline would risk a compile error at the deepest failing step, breaking the
file. The prover explicitly considered and **rejected** a
`first | <full (d-g) chain> | sorry` wrap per the iter-089 dead-end list
(loses the "deepest committed step" signal for iter-091 re-scoping).

### Attack record (iter-090) — Lane 1

| Event | Tactic / Action | Result | Insight |
|---|---|---|---|
| 5 | `Read` BasicOpenCech.lean | OK | inspecting pre-edit state |
| 7 | `ls .lake/packages/` | `checkdecls\ndoc-gen4` | mathlib package missing (same as iter-086+, fifth consecutive iter) |
| 9 | `lean_diagnostic_messages` (relative path) | `Invalid Lean file path` | sandbox-LSP path resolution failure |
| 11 | `lean_diagnostic_messages` (absolute path) | `Failed to start Lean language server: 'lake' not on PATH` | sandbox-LSP failure mode confirmed — fifth consecutive iter |
| 17 | `lean_local_search` `Finset.smul_sum` | `[]` | local repo has no Mathlib indexed — search engine empty |
| 18 | `lean_local_search` `smul_sum` | `[]` | same |
| 19 | `lean_local_search` `map_sum` | `[]` | same |
| 20 | `Grep` `Finset.smul_sum` | (presumed found in project comments or none) | name verification offline |
| 21 | `Edit` — single replacement at L547: trailing `sorry` → 17-line block (3 tactic + ~15 comment) ending in trailing `sorry` at new L564 | wrote OK | step (c) `simp only [map_sum]` + step (h-prep) `simp only [Finset.smul_sum]` + step (d-entry) `refine Finset.sum_congr rfl ?_; intro i _` landed |
| 22 | `Read` post-edit | OK | verified the edit landed at the right offsets |
| 24 | `Grep` `Pi.lift_π_apply` | (likely no project hits — Mathlib offline) | name verification for iter-091 deferred work |
| 25 | `Grep` `Pi.lift_π_apply|Pi.smul_apply|Pi.lift_π` | same | combined query, same result |
| 27 | `Write` task result | OK | partial-progress report per PROGRESS.md report-shape requirements |

### Risks for iter-091 inheriting iter-090's step-(c)/(h-prep)/(d-entry) work

Verbatim from prover task result:

1. **`simp only [map_sum]` no-op risk.** If iter-089's step (b)
   (`simp only [hom_sum_dist]`) was a no-op in actual compilation (iter-089
   risk #2), then iter-090's step (c) operates on the pre-(b) form
   `(Pi.π Z₂ j).hom ((eqToHom ∘ₗ Σ.hom) ...)`. `map_sum` may not fire if
   the outer wrapping is non-distributable. Recovery: try
   `simp only [map_sum, ConcreteCategory.hom_def]` or prefix with
   `dsimp only [Function.comp]` to expose subterms.
2. **`simp only [Finset.smul_sum]` no-op risk.** If step (c) didn't fire
   correctly, the RHS may not have `r • ∑` shape. Then step (h-prep) is a
   no-op, and `refine Finset.sum_congr rfl ?_` fails. Recovery: invert
   order — try `Finset.sum_congr` first to detect the actual goal shape.
3. **`Finset.sum_congr rfl` order risk.** Both sides must be sums over the
   same Finset. Recovery: try `Finset.sum_congr` with explicit equality
   witnesses.
4. **`maxHeartbeats 1600000`** at L455 should suffice; if (d-entry) blows
   the budget, lift to 3200000 inline.

### Iter-091 Lane 1 path forward (concrete, from prover task result)

Post-(d-entry) per-summand goal (expected, unverified):
```
(Pi.π Z₂ j).hom (((-1)^i • Pi.lift (fun a => Pi.π Z₁ (a ∘ δ_i.toOrderHom)
  ≫ (toModuleKPresheaf C).map φ_i.op)).hom ((piIsoPi Z₁).inv (r • y)))
= r • (Pi.π Z₂ j).hom (((-1)^i • Pi.lift (fun a => Pi.π Z₁ (a ∘ δ_i.toOrderHom)
  ≫ (toModuleKPresheaf C).map φ_i.op)).hom ((piIsoPi Z₁).inv y))
```

Per-summand steps for iter-091:
- **(d-body)** `simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply, ModuleCat.hom_smul, LinearMap.smul_apply]` — fallback `dsimp only [Pi.lift_π]`.
- **(e)** `simp only [Pi.smul_apply]` — prefix `letI := perI₁` on synthesis failure.
- **(f)** `rw [map_mul]` — verify `.hom` is a `RingHom`.
- **(g)** `rw [presheafMap_restrict_collapse _ _ _]` — three `≤`-witnesses to unification.
- **closure** `rfl` or `simp only [ConcreteCategory.comp_apply]`.

Estimated ~20–30 LOC after step (d-entry).

---

## Aggregate findings & iter-091 outlook

- **Net sorry count unchanged at 14.** The single `sorry` at the body of
  `cechCofaceMap_pi_smul` (former L547, now L564) was replaced with the S6
  steps (c) + (h-prep) + (d-entry) tactics and a trailing `sorry` at the
  per-summand goal. `BasicOpenCech.lean` count holds at 6 syntactic sorries.
- **Iter-090 process outcome — PROGRESS.md mandate satisfied (refined
  fallback level).** The iter-089 mandate-with-fallback-ladder pattern was
  refined to per-step granularity for iter-090, and the prover delivered the
  expected three substantive steps. **The "deepest committed step" advanced
  from post-(b) (iter-089) to post-(d-entry) (iter-090)** — a strict
  structural advance.
- **Iter-090 step re-ordering (worth noting).** The prover re-ordered step
  (h) from the END of the chain (per PROGRESS.md template) to before the
  per-summand congruence (forward direction). This is mathematically
  equivalent and structurally cleaner; documented in the task result with
  the explicit rationale.
- **Realistic iter-091 target.** Net **−1 sorry** (5 active in
  BasicOpenCech, 13 total) if steps (d-body) + (e) + (f) + (g) + closure
  chain lands cleanly. Path forward is concrete: 5 well-documented steps
  with templates and fallbacks already enumerated in the prover task
  result.
- **Iter-091 mandate (matching iter-089/090's pattern).** The iter-091 plan
  agent should preserve the "you MUST attempt; trailing sorry at deepest
  committed step" mandate. Per-step granularity now applies to (d-body),
  (e), (f), (g), closure.
- **Sandbox issue persists — FIFTH consecutive iteration.**
  `.lake/packages/` still missing `mathlib`; `lake` not on PATH. The
  iter-089 mandate framing (environmental, not justification to abstain)
  produced two successive structurally-positive iterations (089, 090).
  Continue the pattern. `TO_USER.md` re-emphasised.

## Blueprint markers updated (manual)

No manual marker changes this iter.

- `cechCofaceMap_pi_smul` and `presheafMap_restrict_collapse` are
  project-local helpers without their own `\lean{...}` entries in
  `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — they are internal
  scaffolding for the main theorem
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (chapter L987–991).
  That main theorem still carries downstream sorries (L1198, L1227 in
  BasicOpenCech.lean), so the deterministic `sync_leanok` phase correctly
  did not add `\leanok` to it.
- No `\mathlibok` candidates this iter (nothing landed as a Mathlib alias —
  iter-090 was inline tactic work only).
- No `\notready` to strip.
- No `\lean{...}` renames (no new top-level helpers introduced this iter).
- The deterministic `sync_leanok` phase ran before this review — its
  `\leanok` placements/removals stand untouched.

## TO_USER status

The sandbox-LSP issue (`.lake/packages/mathlib` missing; `lake` not on PATH)
has now persisted across iter-086, 087, 088, 089, **090** — five consecutive
iterations. Four consecutive prover reports (087, 088, 089, 090) have cited
this as a structural obstacle. The iter-089/090 mandate-with-fallback-ladder
pattern has shown that progress is possible without LSP feedback when
PROGRESS.md provides concrete templates: iter-089 advanced from post-S5 to
post-(b); iter-090 advanced from post-(b) to post-(d-entry). But actual
validation (compilation, real goal states, real error messages) still cannot
happen in this sandbox. `TO_USER.md` is updated to re-emphasise the gap.
