# Session 91 — iter-091 review

## Metadata

- **Archon iteration**: 091
- **Stage**: prover (single substantive prover lane —
  `Cohomology/BasicOpenCech.lean`).
- **Sorry count before iter-091** (carried from iter-090): **14** syntactic
  sites — 6 in `BasicOpenCech.lean` (L564, L656, L980, L1008, L1198, L1210),
  5 in `Differentials.lean`, 1 in `Modules/Monoidal.lean`, 1 in
  `Jacobian.lean`, 1 in `Picard/Functor.lean`.
- **Sorry count after iter-091**: **13** total — direct grep this pass
  confirms BasicOpenCech.lean dropped from 6 → **5** sites:
  - `BasicOpenCech.lean`: **L675, L999, L1027, L1217, L1246** (the iter-090
    sites L656/L980/L1008/L1198/L1227 have all shifted by +19 due to the
    iter-091 chain commit at L559–L583; the L564 sorry that was
    `cechCofaceMap_pi_smul`'s post-(d-entry) per-summand goal is **gone**).
  - `Differentials.lean`: **5** at L122, L636, L957, L974, L1116 (unchanged).
  - `Modules/Monoidal.lean`: **1** at L173 (unchanged).
  - `Jacobian.lean`: **1** at L179 (unchanged).
  - `Picard/Functor.lean`: **1** at L190 (unchanged).
- **Net sorry change this iter**: **−1** (14 → 13), all from
  `BasicOpenCech.lean` going 6 → 5. **The realistic-best-case projected in
  the iter-090 review landed.**
- **Compilation status iter-091**: **NOT VERIFIED IN SANDBOX**. The prover
  reported and this review confirmed `.lake/packages/` still contains only
  `checkdecls` and `doc-gen4` (no `mathlib`); `lake` binary still not on
  PATH. `lean_diagnostic_messages` failed at startup with the same error
  message documented across iter-086…iter-090. **Sixth consecutive
  iteration** with this environmental gap. The dispatcher environment is
  expected to fetch Mathlib and verify the iter-091 chain commit compiles.
- **Env state** (from `attempts_raw.jsonl` summary line): 32 total events;
  **3** source `Edit`s to `BasicOpenCech.lean` (one chain-commit + one
  `try`-wrapping experiment + one revert back to the bare chain — net effect
  is the bare chain, see below); **0** `lean_goal` (LSP unavailable); **2**
  `lean_diagnostic_messages` (both returned startup errors); **0**
  `lean_build`; **0** `lean_local_search` calls (skipped this iter); **1**
  `ToolSearch` (TodoWrite); **0** `lean_run_code`, `lean_loogle`,
  `lean_leansearch`.
- **`lean_verify`**: not run this iteration.

---

## Lane summary

| Lane | File | Status | Sorry Δ | Compile |
|---|---|---|---|---|
| 1 | `Cohomology/BasicOpenCech.lean` | **FULL S6 (d-body)+(e)+(f)+(g)+closure CHAIN LANDED — bare-commit per PROGRESS.md mandate** (compilation unverified in sandbox). `cechCofaceMap_pi_smul` body is sorry-free, the trailing `sorry` at iter-090's L564 has been replaced by the five-tactic chain ending in `rfl` at L583. | **−1** (6 → 5) | UNVERIFIED |

---

## Lane 1 — `BasicOpenCech.lean`: S6 (d-body)+(e)+(f)+(g)+closure landed bare; `cechCofaceMap_pi_smul` body is sorry-free

**Status**: SOLVED (compilation unverified in sandbox). The iter-091
PROGRESS.md mandate to "attempt the per-summand steps
(d-body)+(e)+(f)+(g)+closure linearly" (no `try` wrapping, no
`first | <chain> | sorry`) was satisfied. The prover committed all five
remaining S6 steps as bare tactics, ending in `rfl`. The risk explicitly
flagged in the prover's task result is that if any single step is a HOU
no-op the whole file breaks at the deepest failing tactic; that risk is
inherent to the mandate and can only be resolved by the dispatcher's LSP.

### Concrete delivery — final landed chain at `BasicOpenCech.lean` L559–L583

The iter-090 trailing `sorry` at L564 (post-(d-entry) per-summand goal) was
replaced with the following five-step chain (verbatim from the post-edit
file state, line numbers as committed):

```lean
  -- S6 step (d-body) [iter-091]: peel `(-1)^i • Pi.lift f_i` per-summand.
  -- `Pi.lift_π_apply` collapses `(Pi.π j).hom ((Pi.lift f).hom x)` to
  -- `(f j).hom x`; `ModuleCat.hom_smul` + `LinearMap.smul_apply` peel the
  -- scalar `(-1)^i` through the `.hom` projection;
  -- `ConcreteCategory.comp_apply` normalises the `≫`-composition in `f j`.
  simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply,
    ModuleCat.hom_smul, LinearMap.smul_apply]
  -- S6 step (e) [iter-091]: surface inner R-action via `Pi.smul_apply`:
  -- `(r • y) (j ∘ δ_i.toOrderHom) = r • y (j ∘ δ_i.toOrderHom)`. `perI₁`
  -- is in scope from the theorem's `letI` block (L472–481).
  simp only [Pi.smul_apply]
  -- S6 step (f) [iter-091]: split `((toModuleKPresheaf C).map φ_i.op).hom`
  -- over the restricted-product `r * y_at_{j∘δ_i}`. The `.hom` of a
  -- `CommRingCat`-valued presheaf map is a `RingHom`, so `map_mul` fires.
  rw [map_mul]
  -- S6 step (g) [iter-091]: collapse the nested algebra-map chain
  -- `R → Γ(V_{j∘δ_i}) → Γ(V_j)` to the direct `R → Γ(V_j)` via the
  -- top-level lemma `presheafMap_restrict_collapse` (L425). The three
  -- `≤`-witnesses are `basicOpen_le` chains, left to unification.
  rw [presheafMap_restrict_collapse _ _ _]
  -- S6 closure [iter-091]: after the algebra-map chain collapses and the
  -- `r •` action on RHS (via `perI₂`) reduces to the same direct
  -- restriction-multiplication form, both sides match definitionally
  -- (`≤`-witnesses equal by proof irrelevance), closed by `rfl`.
  rfl
```

Counts: 5 substantive tactic lines (L564–L565, L569, L573, L578, L583) +
~20 lines of stepwise `--` commentary (slight overage above PROGRESS.md's
"≤ 15 lines" guidance — defensible at 4 commentary lines per step × 5
steps). The S1–S5 prefix (iter-087/088), step (a) `hom_sum_dist` inline
`have` (iter-089, L528–L536), step (b) `simp only [hom_sum_dist]` (iter-089,
L540), and steps (c)+(h-prep)+(d-entry) (iter-090, L547/L551/L557–L558) are
preserved byte-for-byte.

### Edit timeline within the session (3 Edits, net = bare chain)

| Event | Edit content | Net effect |
|---|---|---|
| log_line 43 (06:15:52) | Replace L564 `sorry` with bare 5-step chain ending in `rfl`. | Initial commit of the chain. |
| log_line 60 (06:18:05) | Wrap each step in a `try`-and-fallback layer, retain trailing `first | rfl | sorry`. | Hedged against HOU no-ops. |
| log_line 67 (06:19:37) | Revert: re-replace the hedged block with the bare chain from log_line 43. | Back to bare commit per PROGRESS.md ("DO NOT wrap the chain in `first | ... | sorry`"). |

The prover's task result frames event 60 as a deliberation step that was
abandoned: the `try`-wrap loses the "deepest committed step" signal (which
PROGRESS.md mandated preserving), so the bare chain is the only directive-
compliant form. The final on-disk file state (verified by direct read at
L559–L583) matches event 67.

### Decision rationale committed by the prover (verbatim from task result)

The iter-091 PROGRESS.md mandate had three explicit constraints:

1. *"You MUST attempt the per-summand steps (d-body)+(e)+(f)+(g)+closure
   this iteration."*
2. *"If `lean_diagnostic_messages` is unavailable, that is environmental
   and **not a justification to abstain**."*
3. *"**DO NOT wrap the chain in `first | <full chain> | sorry`**."*

Decision tree the prover documented:

1. **Bare chain + `rfl`** (chosen): maximal signal for iter-092 — if any
   step fails the file breaks at that exact tactic. Risk: file may not
   compile.
2. **`try` per step + trailing `first | rfl | sorry`** (briefly committed
   then reverted at log_line 67): always compiles but `try` masks
   per-step failures, retains 1 syntactic `sorry`, target 5 unreachable —
   violates mandate constraint (1)/(3) in spirit.
3. **Single-step (d-body only) + sorry** (rejected): below the "(d-body)
   .. closure" upper-bound mandate.

The bare-commit path is the unique directive-compliant choice when LSP is
unavailable: anything less ducks constraint (1), anything more hedged
violates constraint (3).

### Per-step HOU risk landscape documented by the prover

- **(d-body) `ModuleCat.hom_smul` vs `ModuleCat.hom_zsmul`** — the scalar
  `(-1)^i` is an integer, and the simp set picks the natural-scalar
  variant `ModuleCat.hom_smul`. If it doesn't fire on integer scalars,
  step (d-body) errors with "simp made no progress". Fallback
  `ModuleCat.hom_zsmul` + `LinearMap.zsmul_apply` documented but not
  applied.
- **(e) `Pi.smul_apply` synthesis** — requires the term form `(r • y) (a)`.
  If iter-090's step (c) or (d-entry) didn't fully unfold the
  `(piIsoPi Z₁).inv` wrapper, the `r • y` may still be wrapped. Fallback
  `letI := perI₁` prefix documented but not applied.
- **(f) `rw [map_mul]` AddHom-vs-RingHom HOU** — requires the term to be
  a `RingHom.map_mul` shape. For `CommRingCat`-valued presheaf maps this
  should hold via `CommRingCat.Hom.hom` coercion, but HOU on
  `((toModuleKPresheaf C).map φ_i.op).hom` is possible. Fallback
  `rw [RingHom.map_mul]` documented but not applied.
- **(g) `presheafMap_restrict_collapse _ _ _` `≤`-witness unification** —
  if unification can't fill the three `≤`-witnesses, explicit witnesses
  via `(Pi.π _ _).le.trans (basicOpen_le _)` would be needed (L477–480
  pattern). Fallback documented but not applied.
- **(closure) `rfl` definitional equality** — requires LHS (post-(g))
  and RHS (after `perI₂` reduces the outer `r •` to the same direct
  restriction-multiplication form) to match definitionally, with
  `≤`-witnesses equal by proof irrelevance. Fallback
  `simp only [ConcreteCategory.comp_apply]` then `ring` documented but
  not applied.

### Attack record (iter-091) — Lane 1

| Event | Tactic / Action | Result | Insight |
|---|---|---|---|
| log 3 | `Read` BasicOpenCech.lean | OK | inspect pre-edit state |
| log 9 | `ls .lake/packages/` | `checkdecls\ndoc-gen4` | mathlib missing — sixth consecutive iter |
| log 10 | `lean_diagnostic_messages` (absolute path) | startup failure: `No such file or directory: 'lake'` | sandbox LSP failure mode confirmed (6th consecutive) |
| log 11–15 | Several `Read`s (L495–L590 and below) | OK | confirm pre-edit chain context |
| log 16 | `Edit` — replace L564 trailing `sorry` with bare 5-step chain ending in `rfl` | wrote OK | initial commit |
| log 18 | `lean_diagnostic_messages` (relative path) | startup failure | LSP still down post-edit |
| log 19 | `Read` post-edit | OK | verify edit landed |
| log 20–22 | Grep checks (sorry count, simp-only patterns) | line numbers shifting | progress check |
| log 23 | `Edit` — wrap chain in `try`-and-fallback layer | wrote OK | hedged variant briefly committed |
| log 24 | Grep sorry | confirm sorry still present in hedged form | hedged form retains 1 trailing `sorry` |
| log 25 | `Edit` — revert hedged → bare chain | wrote OK | back to directive-compliant form |
| log 26–28 | Grep `sorry$` / `^\s*sorry\b` / bash grep count | confirm `cechCofaceMap_pi_smul` body sorry gone | target 5 achieved (if chain compiles) |
| log 29 | `Read` final state | OK | verify the revert landed |
| log 31 | `Write` task result | OK | iter-091 report committed |
| log 33 | Append to `.debug-feedback/debug_feedback.md` | OK | sandbox-LSP escalation note |

### Risks inherited from iter-090 work below the iter-091 chain commit

Verbatim from prover task result — these are SHARED with iter-091 because
the iter-091 chain begins at the post-(d-entry) state produced by
iter-090's three substantive tactics:

1. **`simp only [map_sum]` no-op risk** (iter-090 risk #1). If iter-089
   step (b) `simp only [hom_sum_dist]` was a no-op (e.g., due to
   `eqToHom` wrapping), iter-090's step (c) would operate on a
   non-distributable form. If so, the iter-091 (d-body) is reading a
   goal the prover didn't predict.
2. **`simp only [Finset.smul_sum]` no-op risk** (iter-090 risk #2).
3. **`Finset.sum_congr rfl` order risk** (iter-090 risk #3).

These risks predate iter-091 and can only be resolved by LSP feedback.

### Why this lane is recorded as `solved` (status)

The `cechCofaceMap_pi_smul` body is **syntactically sorry-free** at the
end of iter-091: direct grep confirms the L564 trailing `sorry` is gone
and is replaced by the 5-step chain ending in `rfl`. Source-level sorry
count for the file is 5 (was 6), and the iter-091 prover delivered the
full chain the iter-090 review projected. The compilation caveat is
real but does **not** invalidate the structural delivery — the iter-090
review's "best case" outlook was precisely the bare-chain-lands path,
and that's the on-disk state.

If the dispatcher LSP reports a compile error in the chain, iter-092's
prompt is straightforward: roll back to the deepest working step + a
trailing `sorry` at that point. Each of the five steps has a documented
fallback (see "Per-step HOU risk landscape" above) and the
`presheafMap_restrict_collapse` top-level lemma (L412–L434) is a fully
proved infrastructure.

---

## Aggregate findings & iter-092 outlook

- **Net sorry count dropped from 14 → 13.** The `cechCofaceMap_pi_smul`
  body sorry is gone. This is the first iteration since iter-085 with a
  raw `−1` sorry delta in a non-deferred file — the prior five iterations
  (086–090) all moved the trailing sorry to a deeper post-state without
  closing it.
- **Mandate-with-per-step-fallback-ladder pattern produced the projected
  outcome.** Iter-089 added steps (a)+(b); iter-090 added (c)+(h-prep)+
  (d-entry); iter-091 added (d-body)+(e)+(f)+(g)+closure. Three
  consecutive iterations of strict structural advance under sandbox-LSP-
  unavailable conditions, culminating in the chain's closure this iter.
- **Sandbox issue persists — SIXTH consecutive iteration.** The iter-086
  through iter-091 prover and review reports all document
  `.lake/packages/mathlib` missing and `lake` not on PATH. The
  mandate-with-per-step-fallback-ladder pattern works around this, but
  actual compilation verification still cannot happen in this sandbox.
- **Realistic iter-092 outlook**: dispatcher LSP confirms the chain
  compiles → iter-092 unblocks `g_R.map_smul'` at L1217 (was L1198),
  proceeding to **net −1 sorry** again (4 active in BasicOpenCech, 12
  total). If LSP reports an error in the chain, iter-092 rolls back per
  the per-step fallback ladder to the deepest working step + trailing
  `sorry`, and re-attempts the failed step with the documented variant.
- **Process hygiene**: the prover did one round-trip experiment (bare →
  hedged → bare) inside the session that produced no net source change
  but added one extra Edit event. This is acceptable deliberation under
  no-LSP conditions. No new top-level helpers; no new axioms; no new
  false-signature helpers; `presheafMap_restrict_collapse` continues as
  the only top-level infrastructure helper used by this proof.

## Blueprint markers updated (manual)

No manual marker changes this iter.

- `cechCofaceMap_pi_smul` and `presheafMap_restrict_collapse` are
  project-local helpers without their own `\lean{...}` entries in
  `blueprint/src/chapters/Cohomology_MayerVietoris.tex` (verified by direct
  grep `cechCofaceMap_pi_smul` / `\lean{...cech...}` — no hits). They are
  internal scaffolding for the main theorem
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` whose `\lean{...}`
  entry remains in the chapter; that main theorem still carries downstream
  sorries (L1217, L1246 in BasicOpenCech.lean — `g_R.map_smul'` and
  `h_loc_exact`), so the deterministic `sync_leanok` phase correctly did
  not add `\leanok` to it this iter.
- No `\mathlibok` candidates this iter (no new Mathlib aliases landed —
  iter-091 was inline tactic work only).
- No `\notready` to strip (none on currently-formalized blocks).
- No `\lean{...}` renames (no new top-level helpers introduced this iter).
- The deterministic `sync_leanok` phase ran before this review — its
  `\leanok` placements/removals stand untouched.

## TO_USER status

The sandbox-LSP issue (`.lake/packages/mathlib` missing; `lake` not on
PATH) has now persisted across iter-086, 087, 088, 089, 090, **091** —
**six consecutive iterations**. Five consecutive prover reports (087–091)
have cited this. The mandate-with-per-step-fallback-ladder pattern has
demonstrated that progress is possible without LSP feedback when
PROGRESS.md provides concrete templates: iter-089 advanced post-S5 →
post-(b); iter-090 advanced post-(b) → post-(d-entry); iter-091 closed the
chain (post-(d-entry) → sorry-free, modulo compile verification). But
**actual validation (compilation, real goal states, real error messages)
still cannot happen in this sandbox**, and iter-091's full-chain bare
commit raises the stakes: if the dispatcher LSP reports an error, iter-092
needs to roll back to the deepest working step. `TO_USER.md` is updated
to re-emphasise the gap and the iter-091 compile-verification dependency.
