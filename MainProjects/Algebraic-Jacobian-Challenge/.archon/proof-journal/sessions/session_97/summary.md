# Session 97 — iter-099 review

## Metadata

- **Archon iteration (harness meta)**: 097. Project narrative
  (`PROGRESS.md`, `task_results/`, `refactor` reports, Lean
  source comments) labels this iteration's two stages **iter-098
  (refactor lane: `alt-sum-pi-smul-aux-sum-comp`)** and **iter-099
  (prover lane on `BasicOpenCech.lean`)**. The review below uses the
  project narrative names; `session_97/` is the directory selected by
  the system prompt rule (`M == iteration`).
- **Stage**: refactor + prover (parallel lanes inside a single
  Archon iteration). Refactor was scheduled because iter-097
  exhausted six tactic-level bridging routes for `cechCofaceMap_pi_smul`
  Step 2 (see `session_96/recommendations.md` § Priority 1).
- **Refactor lane** (`.archon/logs/iter-097/refactor-alt-sum-pi-smul-aux-sum-comp-report.md`):
  inserted `alternating_sum_pi_smul_aux_sum_comp` at L513–L532 with
  `sorry` body, splitting iter-097's single-slot morphism family
  `F : ι' → (∏ᶜ Z₁ ⟶ ∏ᶜ Z₂)` into a family `G : ι' → (∏ᶜ Z₁ ⟶
  ∏ᶜ Z_int)` plus a single `E : ∏ᶜ Z_int ⟶ ∏ᶜ Z₂`. Status `COMPLETE`,
  no protected signatures touched, no existing decls modified.
  Universe hygiene: `ι_int : Type u`. No `Module R (∀ k, Z_int k)`
  instance added.
- **Prover session** (`.archon/logs/iter-097/provers-combined.jsonl`,
  `meta.json`): single lane
  `AlgebraicJacobian_Cohomology_BasicOpenCech`, model `claude-opus-4-7`
  (Archon harness default), prover stage `durationSecs` 1202 s wall.
- **Sorry count entering iter-099 (post-refactor)**: **15** total /
  **7** in `BasicOpenCech.lean` (L532 NEW from refactor, L695, L787,
  L1111, L1139, L1329, L1358). The refactor added L532 over the
  iter-097 close baseline of 6.
- **Sorry count leaving iter-099**: **14** total / **6** in
  `BasicOpenCech.lean` (verified by direct grep at iter-099 close:
  L728, L820, L1144, L1172, L1362, L1391). The L532 site no longer
  exists — its body has been committed.
  - Net iteration change (refactor+prover combined): **0** net
    sorries (refactor +1, prover −1). Matches the iter-098 plan's
    "Acceptable" outcome: refactor lemma's body filled, plus partial
    progress on L695 (now L728).
  - Hard cap 7 in `BasicOpenCech.lean` respected.
- **Compilation status iter-099 close**: **VERIFIED** —
  `lean_diagnostic_messages` with `severity=error` on the whole file
  returns `[]` (per `attempts_raw.jsonl` log_lines 14, 19, 27, 57 —
  four clean-diagnostic checks across the session). Sixth consecutive
  compile-verified prover iteration (iter-092 + iter-093 + iter-094
  + iter-095 + iter-097 + iter-099).
- **`attempts_raw.jsonl` freshness**: **FRESH** (timestamps
  11:58:49Z–12:18:28Z fall inside the iter-097 prover stage window
  per `meta.json` `startedAt: 2026-05-14T11:40:14Z`). Third consecutive
  iteration without pre-processor staleness.
- **Tool usage (from `attempts_raw.jsonl` summary on line 1)**:
  **63 total events / 3 `Edit`s + 1 `Write` (task_result) /
  7 `lean_multi_attempt` / 5 `lean_diagnostic_messages` /
  3 `lean_goal` / 12 lemma searches (8 `lean_local_search`/
  `lean_loogle` + 4 leansearch/hammer) / 1 `lean_run_code` /
  4 Read / 5 Bash / 4 TodoWrite / 1 `lean_hover_info` / 1
  `lean_term_goal` / 3 ToolSearch / 4 Grep**. LSP/lake working
  throughout (severity=error empty after every edit).
- **`lean_verify`**: not run this iteration.

## Per-target detail

### Target 1 — `alternating_sum_pi_smul_aux_sum_comp` body (BasicOpenCech.lean L532, NEW from iter-098 refactor) — RESOLVED

**Status**: **SOLVED** on first try. The plan's Step 1 recipe (`intro
r y; rw [Preadditive.sum_comp s G E]; exact alternating_sum_pi_smul_aux
Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG r y`) closed the goal in **one
commit** with zero error turnaround.

**Entry goal** (from `attempts_raw.jsonl` log_line 15, `lean_goal` at
L532):
```
k : Type u, [Field k]
R : Type u_1, [Ring R]
ι₁ ι_int ι₂ : Type u
Z₁ : ι₁ → ModuleCat k
Z_int : ι_int → ModuleCat k
Z₂ : ι₂ → ModuleCat k
_mZ1 : Module R ((i : ι₁) → ↑(Z₁ i))
_mZ2 : Module R ((j : ι₂) → ↑(Z₂ j))
ι' : Type u_2
s : Finset ι'
G : ι' → (∏ᶜ Z₁ ⟶ ∏ᶜ Z_int)
E : ∏ᶜ Z_int ⟶ ∏ᶜ Z₂
e₁ : ↑(∏ᶜ Z₁) ≃ₗ[k] (i : ι₁) → ↑(Z₁ i)
e₂ : ↑(∏ᶜ Z₂) ≃ₗ[k] (j : ι₂) → ↑(Z₂ j)
hG : ∀ i ∈ s, ∀ (r : R) (y : (i : ι₁) → ↑(Z₁ i)),
       e₂ ((G i ≫ E).hom (e₁.symm (r • y))) =
         r • e₂ ((G i ≫ E).hom (e₁.symm y))
⊢ ∀ (r : R) (y : (i : ι₁) → ↑(Z₁ i)),
    e₂ (((∑ i ∈ s, G i) ≫ E).hom (e₁.symm (r • y))) =
      r • e₂ (((∑ i ∈ s, G i) ≫ E).hom (e₁.symm y))
```

#### Attempt 1 — directive recipe (COMMITTED)

- **Probe**: `lean_multi_attempt` with snippet
  `intro r y; rw [Preadditive.sum_comp s G E]; exact
  alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG r y`.
  Result: `goals: []`, only a 100-char line-length warning (no error).
  Logged at `attempts_raw.jsonl` log_line 16.
- **Code (L532–L537, verbatim from the file at iter-099 close):**
  ```lean
    -- iter-099 Step 1: distribute `Preadditive.sum_comp` (HOU-free since `G`
    -- and `E` are lemma binders, not literals), then apply
    -- `alternating_sum_pi_smul_aux` on the family `fun i ↦ G i ≫ E`.
    intro r y
    rw [Preadditive.sum_comp s G E]
    exact alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG r y
  ```
- **Commit sequence**: `Edit` at log_line 18 → `lean_diagnostic_messages`
  at log_line 19 (clean) → sorry-grep at log_line 20 confirms count
  dropped from 7 → 6 (with L532 closed but L695 → L700 line-shift
  because of comment block added).
- **Insight**: with `G` and `E` as binders rather than literals,
  `rw [Preadditive.sum_comp]` fires HOU-free — Miller-pattern
  unification succeeds because `?f i` only needs to abstract `G i`
  (a binder reference, not `(-1)^↑i • Pi.lift fun i_1 ↦ …`). This is
  exactly the workaround iter-094/095/097 needed but could not
  express at the literal call site. The iter-098 refactor's
  signature-level split (G + E rather than F=G≫E) is what makes the
  rewrite HOU-free — confirming the refactor's design hypothesis.

### Target 2 — `cechCofaceMap_pi_smul` L695 trailing sorry — PARTIAL (bridge applied; residual `hG` open at L728)

**Status**: **PARTIAL — Bridge SUCCESSFUL, residual `hG` open.** The
iter-099 prover successfully applied the iter-098 structural lemma
at the call site (the central goal of the iteration), reducing the
L695 sorry to a single per-summand R-linearity sub-goal `hG` at the
new line L728. Six tactic strategies for the residual `hG` discharge
were probed; all failed at the same root cause (polymorphic `(-1)^↑i`
scalar elaboration), and the prover committed a partial chain
`simp only [ModuleCat.hom_comp, LinearMap.comp_apply]` plus `sorry`
so iter-100 starts from the partially-distributed goal.

**Entry goal** (post-iter-097 B1 bridge at L699, from
`attempts_raw.jsonl` log_line 22, `lean_goal` at L700):
```
case h
… (heavy context: K₀, scK₀, Z₁, Z₂, e₁, e₂, perI₁, perI₂, h_mod_pi₁/₂, …)
r : ↑R
y : (i : Fin ((ComplexShape.up ℕ).prev n + 1) → ↥s₀) → ↑(Z₁ i)
…
⊢ (piIsoPi Z₂).hom.hom
    (ConcreteCategory.hom
      ((∑ i, (-1)^↑i • Pi.lift fun i_1 ↦
          Pi.π Z₁ (i_1 ∘ ⇑(SimplexCategory.δ i).toOrderHom) ≫
          (toModuleKPresheaf C).map (Pi.lift fun x ↦
            Pi.π (basicOpenCover ↑s₀ ∘ i_1) ((δ i).toOrderHom x)).op)
        ≫ eqToHom ⋯)
      ((piIsoPi Z₁).toLinearEquiv.symm (r • y)) j =
  r • (piIsoPi Z₂).hom.hom
        (ConcreteCategory.hom (… same expression …))
         ((piIsoPi Z₁).toLinearEquiv.symm y) j
```

#### Attempt 1 — `rw [← Pi.smul_apply (i := j)]; refine congrFun (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _ e₁ e₂ ?_ r y) j` (COMMITTED — bridge succeeds, only `?_` open)

- **Probe sequence** (`attempts_raw.jsonl` log_lines 23, 24): probed
  the two-line bridge through `lean_multi_attempt`; both probes
  reported the goal advanced cleanly to the `hG` sub-goal with the
  four `_` placeholders filled by Lean's Miller-pattern unifier
  (`Z_int`, `G`, `E`, `s := Finset.univ`).
- **Code (committed at L700–L712):**
  ```lean
    -- iter-099 Step 2: rewrite `r • _ j` to `(r • _) j` (Pi.smul_apply reverse)
    -- to lift the goal to family level, then `congrFun` removes `j` on both
    -- sides, then apply the iter-098 structural lemma
    -- `alternating_sum_pi_smul_aux_sum_comp` with Miller-pattern unification.
    -- Miller-pattern unification fills the four `_` placeholders (Z_int, G, E, s):
    --   ?Z_int unified against the codomain of `Pi.lift` summands.
    --   ?G : ι' → (∏ᶜ Z₁ ⟶ ∏ᶜ Z_int) := fun i ↦ (-1)^↑i • Pi.lift_thing_at_i.
    --   ?E := the trailing `eqToHom ⋯` (independent slot, bypasses iter-097 Attempt-5).
    --   ?s := Finset.univ.
    -- One remaining sub-goal: the per-summand R-linearity hypothesis `hG`.
    rw [← Pi.smul_apply (i := j)]
    refine congrFun
      (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _ e₁ e₂ ?_ r y) j
  ```
- **Commit sequence**: `Edit` at log_line 26 → `lean_diagnostic_messages`
  at log_line 27 (clean) → `lean_goal` at log_line 29 confirms the
  goal is now the per-summand `hG` sub-goal at L707.
- **Result**: SUCCESS — the iter-098 structural lemma is applied
  at the call site. The `E` slot's `eqToHom ⋯` lands in its
  independent elaboration slot, bypassing iter-097 Attempt-5's
  index-type non-unification through `ComplexShape.prev`. The
  central goal of the iteration (apply the new lemma) is hit.
- **Key insight**: `← Pi.smul_apply (i := j)` reverses the goal's
  RHS `r • (...) j` to `(r • (...)) j`, allowing `congrFun ?_ j` to
  strip the `j`-evaluation **symmetrically** on both LHS and RHS,
  lifting the goal from j-evaluated form to family level. The
  iter-098 lemma then fires HOU-free because all four placeholders
  unify against the literal goal shape via Miller-pattern.

#### Attempt 2 — `hG` per-summand R-linearity discharge (~6 routes explored, all FAILED at the same root cause)

**Root cause across all six routes**: the polymorphic `(-1)^↑i`
scalar at the head of the smul-wrapped Pi.lift sub-term elaborates
with a type that Lean cannot pin to either `k`, `ℤ`, or `R` from
the goal's surface, blocking pattern-matching on every smul-aware
lemma. The smul `(-1 : ?S)^(↑i : ℕ)` carries `?S` as a typeclass
constraint that is partially synthesised but not enough to fire
`Linear.smul_comp` / `Preadditive.zsmul_comp` / `ModuleCat.hom_smul`.

- **Approach 2a (`attempts_raw.jsonl` log_line 30)**: directive's
  suggested simp chain `simp only [Preadditive.smul_comp,
  ModuleCat.hom_smul, LinearMap.smul_apply, ModuleCat.hom_comp,
  LinearMap.comp_apply, Pi.smul_apply, map_smul]`.
  - **Result**: FAILED. `Preadditive.smul_comp` is **NOT** a Mathlib
    constant — the correct names are `CategoryTheory.Linear.smul_comp`
    (for k-action) and `CategoryTheory.Preadditive.zsmul_comp` (for
    ℤ-action). Of the remaining lemmas, only `ModuleCat.hom_comp` +
    `LinearMap.comp_apply` actually fired; `ModuleCat.hom_smul`,
    `LinearMap.smul_apply`, `Pi.smul_apply`, `map_smul` all reported
    "unused".

- **Approach 2b** (`attempts_raw.jsonl` log_line 42): `simp only
  [Linear.smul_comp]` (k-action smul-comp, loogle-verified at
  log_line 41).
  - **Result**: FAILED — `simp` made no progress. Pattern
    `(?r • ?f) ≫ ?g` exists syntactically in the goal but does not
    unify, likely because the polymorphic `(-1)^↑i` does not
    elaborate as `k`.

- **Approach 2c**: `simp only [Preadditive.zsmul_comp]` (ℤ-action,
  leansearch-verified at log_line 36).
  - **Result**: FAILED — same "pattern not found". `(-1)^↑i` is
    neither inferred as `k` nor as `ℤ` from Lean's perspective at
    this goal position, despite being mathematically valued in `ℤ`.

- **Approach 2d** (`attempts_raw.jsonl` log_line 48): `rw
  [Linear.smul_comp]` after the comp unfolding, with the rewrite
  fully qualified.
  - **Result**: FAILED — same pattern-not-found.

- **Approach 2e** (`attempts_raw.jsonl` log_line 51): `simp only
  [ModuleCat.hom_comp, LinearMap.comp_apply, ModuleCat.hom_smul,
  LinearMap.smul_apply, map_smul]; rfl`.
  - **Result**: FAILED — only `ModuleCat.hom_comp` and
    `LinearMap.comp_apply` fired; the `ModuleCat.hom_smul`
    typeclass chain `[Monoid S] [DistribMulAction S _]
    [SMulCommClass k S _]` cannot synthesise with the
    polymorphic scalar. Standalone `run_code` test (log_line 54)
    confirmed `ModuleCat.hom_smul` exists at the loogle-reported
    name; the obstacle is specifically the typeclass synthesis
    inside this goal's context.

- **Approach 2f** (`attempts_raw.jsonl` log_line 50, 53): smoke tests
  of `simp only [neg_smul, one_smul, smul_neg, pow_succ, pow_zero]`
  and `simp only [zsmul_comp]` (a name from leansearch).
  - **Result**: FAILED — neither makes progress on the head smul.
    These were exploratory attempts to coax the scalar into a more
    cooperative form; they all hit "no progress" because the head
    smul is structurally opaque to the simp set.

- **Decision (committed at log_line 56)**: commit the partial chain
  ```lean
    intro i _ r' y'
    simp only [ModuleCat.hom_comp, LinearMap.comp_apply]
    sorry
  ```
  at L726–L728. This distributes the categorical composition's
  underlying linear-map application (separating
  `((-1)^↑i • Pi.lift_thing)` from `eqToHom`), leaving iter-100 a
  partially-prepared goal. Detailed comment block at L713–L725
  records the dead-end class and outlines five candidate iter-100
  approaches.
- **Result**: PARTIAL — file compiles, 6 sorries in `BasicOpenCech.lean`
  (down 1 from the post-refactor 7).

### Targets 3–7 (BasicOpenCech.lean L820, L1144, L1172, L1362, L1391) — UNTOUCHED

Per the plan's "Off-limits this iteration" §, these five sorries are
gated on Lane 1 closing `cechCofaceMap_pi_smul` (L728) or on multi-iter
Mathlib infrastructure (L820, L1144, L1172 augmented-Čech /
extra-degeneracy). Untouched at iter-099.

### Targets 8–12 (Differentials.lean L122, L636, L957, L974, L1116) — OFF-LIMITS

Per the plan's "Off-limits this iteration" §, `Differentials.lean`
was not assigned. Untouched.

### Other off-limits — UNTOUCHED

- `Modules/Monoidal.lean` L173 (Mathlib gap).
- `Jacobian.lean` L179 (Phase C/E, iter-100+).
- `Picard/Functor.lean` L190 (gated on Phase C C0–C3).

## Key findings and proof patterns discovered

### Findings (this session)

1. **The iter-098 split-slot refactor's design hypothesis is
   VINDICATED.** Both call sites of the new lemma fired HOU-free at
   the first probe:
   - L532 body: `rw [Preadditive.sum_comp s G E]` succeeds because
     `G` and `E` are binders.
   - L695 call site: `refine congrFun (alternating_sum_pi_smul_aux_sum_comp
     Z₁ _ Z₂ Finset.univ _ _ e₁ e₂ ?_ r y) j` succeeds because Lean's
     Miller-pattern unifier fills `Z_int`, `G`, `E`, `s` from the
     literal goal shape, with the `eqToHom` landing in `E`'s
     independent elaboration slot.
   This is exactly the iter-097 dead-end (Attempt-5
   `Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀` vs `Fin (n+1) → ↑s₀`
   non-unification) finally bypassed at the structural level.

2. **The residual `hG` discharge is BLOCKED by polymorphic-scalar
   typeclass synthesis, not by HOU.** Six routes attempted via
   `Linear.smul_comp` / `Preadditive.zsmul_comp` / `ModuleCat.hom_smul`
   / explicit `change`. None fired. Standalone `run_code` confirmed
   the lemmas exist and synthesise in vacuum; the obstacle is the
   `Monoid S`/`DistribMulAction S _`/`SMulCommClass k S _` typeclass
   chain in this *specific* goal context with `(-1 : ?S)^(↑i : ℕ)`
   left polymorphic.

3. **A bona fide structural advance.** Even with the `hG` sorry
   remaining, the call-site is now reduced from "find a bridge from
   `(piIsoPi Z₂).hom.hom (((∑ G_lit) ≫ eqToHom).hom z) j`-form to a
   useful structural lemma" to "discharge per-summand R-linearity
   on a single concrete summand body". The conceptual gap shrinks
   from "design a new lemma" to "carefully manage typeclass
   synthesis for one polymorphic scalar". Iter-100 is a well-scoped
   tactic-level task (~20–40 lines), not a refactor.

4. **`ModuleCat.zero_hom` → `ModuleCat.hom_zero` lesson re-confirmed.**
   The directive said `Preadditive.smul_comp`; the actual Mathlib
   name is `CategoryTheory.Linear.smul_comp` (or
   `CategoryTheory.Preadditive.zsmul_comp` for ℤ). Single-character
   suffix swaps and missing namespace prefixes recur. Continue to
   verify all lemma names via `lean_loogle` / `lean_local_search`
   before transcribing recipes.

5. **`whnf` timeout class did NOT recur this iteration.** The
   iter-097 dead-end (Attempts 2, 5) — hand-typing the literal
   Čech alternating-sum body — was avoided this iteration because
   the iter-098 refactor's split-slot signature lets Miller
   unification do the work without ever forcing the elaborator to
   reduce `(ComplexShape.up ℕ).prev n + 1` outside tactic state.

### Proof patterns (reusable across targets)

1. **`rw [← Pi.smul_apply (i := j)]; refine congrFun (… ?_ … r y) j`
   as a j-eval lifter** *(iter-099, NEW)*: when a goal has shape
   `f z j = r • g z j` where `f` and `g` agree as functions of `z`,
   reverse the smul-eval on the RHS to `(r • _) j` form, then strip
   `j` symmetrically with `congrFun`. The remaining sub-goal is the
   family-level statement, on which a family-level structural lemma
   can be applied via Miller unification.
2. **Refactor split-slot pattern for HOU-blocked single-slot lemmas**
   *(iter-098/099, NEW)*: when an abstract structural lemma's
   single morphism slot `F : ι' → (A ⟶ B)` is HOU-blocked at a call
   site whose literal F-body has nested non-Miller binder references,
   refactor to a two-slot signature `(G : ι' → (A ⟶ C), E : C ⟶ B)`
   with `F i = G i ≫ E`. The two-slot version's Miller-pattern
   unification at the call site puts the literal "blocker"
   (`eqToHom`, fixed post-composition, etc.) into the independent
   `E` slot. Body proved from the single-slot version via
   `Preadditive.sum_comp` + family-level rewrite.
3. **Name-correction discipline for directive transcription**
   *(iter-097/099, meta-pattern, re-confirmed)*: directives often
   mis-name Mathlib lemmas one suffix swap or namespace away.
   `lean_local_search` / `lean_loogle` / `lean_leansearch` resolve
   in 30s; transcribe the recipe with the corrected names.

### Anti-patterns (re-confirmed iter-099, do not retry)

1. **`simp only [Preadditive.smul_comp]`** — `Preadditive.smul_comp`
   does NOT exist in Mathlib. Use `CategoryTheory.Linear.smul_comp`
   (k-action) or `CategoryTheory.Preadditive.zsmul_comp` (ℤ-action).
2. **`simp only [Linear.smul_comp]` / `simp only [Preadditive.zsmul_comp]`
   on a goal containing `(-1 : ?S)^(↑i : ℕ) • …`** — pattern not
   found because the polymorphic scalar's `?S` blocks pattern
   matching. **Must force-elaborate `?S` first** via `change` with
   explicit `: ℤ` or `: k` ascription (taking care with the nested
   `Pi.lift` metavariables) before any smul-comp rewrite.
3. **`rw [ModuleCat.hom_smul]` after composition unfolding** when
   the head is `((-1 : ?S)^(↑i : ℕ) • _)` — typeclass chain
   `[Monoid S] [DistribMulAction S _] [SMulCommClass k S _]` cannot
   synthesise with `?S` unresolved.
4. **`simp only [zsmul_comp]`** without namespace — wrong lemma
   (resolves to a different declaration than
   `CategoryTheory.Preadditive.zsmul_comp`).
5. **`simp only [neg_smul, one_smul, smul_neg, pow_succ, pow_zero]`
   on the head smul** — no progress; these unfold low-level
   arithmetic but do not touch the typeclass synthesis blocker.

## Recommendations for next session

See `recommendations.md` for the structured iter-100 directive.

## Blueprint markers updated (manual)

**None.**

- `alternating_sum_pi_smul_aux_sum_comp` (BasicOpenCech.lean L513):
  no `\lean{...}` blueprint entry (project-local helper introduced
  by iter-098 refactor); no marker change needed.
- `cechCofaceMap_pi_smul` (BasicOpenCech.lean L559): no blueprint
  entry; no marker change.
- `alternating_sum_pi_smul_aux` (BasicOpenCech.lean L462): no
  blueprint entry; no marker change.
- No `\mathlibok` candidates surfaced this iteration.
- No `\lean{...}` macro rename / file-relocation flagged in the
  task result.
- No stale `\notready` to strip.
- The deterministic `sync_leanok` phase (the marker-sync commit
  `archon[097/marker-sync]`) ran before this review; its changes
  (if any) are NOT included here per § "Record what you changed".

## Validation checklist (Step 7)

- [x] `milestones.jsonl` has valid JSON on every line.
- [x] Each milestone has `target.file`, `target.theorem`, `status`.
- [x] Each non-blocked milestone has at least 1 attempt with
  `code_tried` or `strategy`.
- [x] Number of attempts per milestone is proportional to edits in
  `attempts_raw.jsonl` (Target 1: 1 attempt = 1 successful Edit;
  Target 2: 7 attempts = 2 Edits + 5 failed probes).
- [x] `summary.md` includes specific code/errors, not just high-level
  summaries (see Attempt-by-Attempt above with code blocks and
  Lean error texts).
- [x] `recommendations.md` includes actionable next steps.
- [x] **No `\leanok` marker was manually added or removed** — the
  deterministic `sync_leanok` phase handles that.
- [x] No Mathlib-backed declarations reported by the prover this
  iteration; no `\mathlibok` adds needed.
- [x] No `\lean{...}` macro rename was flagged in the task result.
- [x] No `\notready` markers remain on landed declarations (none
  changed this iteration).
