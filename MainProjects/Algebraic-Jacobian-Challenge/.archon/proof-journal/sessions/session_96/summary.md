# Session 96 — iter-097 review

## Metadata

- **Archon iteration**: 097
- **Stage**: prover (single substantive prover lane —
  `Cohomology/BasicOpenCech.lean`). Iter-096 refactor landed the
  abstract structural lemma `alternating_sum_pi_smul_aux` (signature
  at L462–L477, body `sorry` at L478). Iter-097's task was to
  (Step 1) fill the L478 body and (Step 2) apply the new lemma to
  close the `cechCofaceMap_pi_smul` trailing sorry at L637/L657.
- **Prover session** (from `.archon/logs/iter-096/provers-combined.jsonl`
  + `meta.json`): single lane
  `AlgebraicJacobian_Cohomology_BasicOpenCech`, model `claude-opus-4-7`
  (per Archon harness default), prover stage `durationSecs` 2024 s wall.
- **Sorry count entering iter-097**: **15** total / **7** in
  `BasicOpenCech.lean` (L478, L637, L729, L1053, L1081, L1271, L1300).
- **Sorry count leaving iter-097**: **14** total / **6** in
  `BasicOpenCech.lean` (verified by direct grep at iter-097 close:
  L657, L749, L1073, L1101, L1291, L1320). The L478 site no longer
  exists — the proof body has been committed.
  - Net change: **−1 sorry**. Matches the plan's **"Acceptable"**
    iter-097 outcome (close ONLY L478; defer L637 → iter-098).
  - Hard cap 7 respected.
- **Compilation status iter-097 close**: **VERIFIED** —
  `lean_diagnostic_messages` with `severity=error` on the whole file
  returns `[]` (per `attempts_raw.jsonl` log_lines 49, 63, 70, 74 —
  four clean-diagnostic checks across the session). Fifth consecutive
  compile-verified iteration (iter-092 + iter-093 + iter-094 +
  iter-095 + iter-097).
- **`attempts_raw.jsonl` freshness**: **FRESH** (timestamps
  10:52:43Z–11:26:00Z match the iter-096 prover-stage window per
  `meta.json` `startedAt: 2026-05-14T10:18:45Z`). The harness
  pre-processor staleness bug noted in sessions 92/93/94 has not
  recurred for the second consecutive iteration (iter-095 + iter-097).
- **Tool usage (from `attempts_raw.jsonl` summary on line 1)**:
  **77 total events / 5 `Edit`s + 1 `Write` (task_result) /
  10 `lean_multi_attempt` / 9 `lean_diagnostic_messages` /
  5 `lean_goal` / 8 `lean_local_search`/`lean_loogle` /
  0 `lean_run_code` / 4 Read / 7 Bash / 4 TodoWrite / 1
  `lean_hover_info` / 2 ToolSearch / 4 Grep**. LSP/lake working
  throughout.
- **`lean_verify`**: not run this iteration.

## Per-target detail

### Target 1 — `alternating_sum_pi_smul_aux` body (BasicOpenCech.lean L478) — RESOLVED

**Status**: **SOLVED**. The plan's Step 1 recipe (`Finset.cons_induction`
on `s`, `simp only` distribution on both LHS and RHS, then `hF` + `ih`
+ `smul_add`) closed the goal in **one commit** with zero error
turnaround.

**Entry goal** (from `attempts_raw.jsonl` log_line 14, lean_goal at
L478):
```
k : Type u, [Field k]
R : Type u_1, [Ring R]
ι₁ ι₂ : Type u
Z₁ : ι₁ → ModuleCat k
Z₂ : ι₂ → ModuleCat k
_mZ1 : Module R ((i : ι₁) → ↑(Z₁ i))
_mZ2 : Module R ((j : ι₂) → ↑(Z₂ j))
ι' : Type u_2
s : Finset ι'
F : ι' → (∏ᶜ Z₁ ⟶ ∏ᶜ Z₂)
e₁ : ↑(∏ᶜ Z₁) ≃ₗ[k] (i : ι₁) → ↑(Z₁ i)
e₂ : ↑(∏ᶜ Z₂) ≃ₗ[k] (j : ι₂) → ↑(Z₂ j)
hF : ∀ i ∈ s, ∀ (r : R) (y : (i : ι₁) → ↑(Z₁ i)),
       e₂ ((F i).hom (e₁.symm (r • y))) = r • e₂ ((F i).hom (e₁.symm y))
⊢ ∀ (r : R) (y : (i : ι₁) → ↑(Z₁ i)),
    e₂ ((∑ i ∈ s, F i).hom (e₁.symm (r • y))) =
      r • e₂ ((∑ i ∈ s, F i).hom (e₁.symm y))
```

#### Attempt 1 — `Finset.cons_induction` after `revert hF` (COMMITTED)

- **Code (L478–L494, verbatim from the file at iter-097 close):**
  ```lean
    revert hF
    induction s using Finset.cons_induction with
    | empty =>
      intro _hF r y
      simp [Finset.sum_empty, ModuleCat.hom_zero, LinearMap.zero_apply,
        map_zero, smul_zero]
    | cons i s' hi ih =>
      intro hF r y
      simp only [Finset.sum_cons, ModuleCat.hom_add, LinearMap.add_apply, map_add]
      rw [hF i (Finset.mem_cons_self i s')]
      rw [ih (fun j hj => hF j (Finset.mem_cons.mpr (Or.inr hj))) r y]
      rw [smul_add]
  ```
- **Probe / commit sequence** (from `attempts_raw.jsonl`):
  - log_line 19 (`lean_multi_attempt`): the full induction body was
    proposed; LSP returned a `goals: []`-equivalent acceptance.
  - log_line 20 (`lean_multi_attempt`): variant pruning probe.
  - log_line 21 (`Edit`): commit the body in place of the `sorry`.
  - log_line 22 (`lean_diagnostic_messages`): clean — confirms close.
- **Result**: `goals: []`, `diagnostics: []`. Sorry at L478 removed.
- **Insight**: the plan's auxiliary `ModuleCat.zero_hom` name was
  wrong; **`ModuleCat.hom_zero`** is the correct Mathlib lemma at
  `Mathlib.Algebra.Category.ModuleCat.Basic` (a one-character swap of
  the suffix). The `simp` on the empty branch picks it up via the
  explicit lemma list. On the cons branch, an earlier `rw`-only
  prototype (per the prover's task report) failed because `rw` fires
  only on left-to-right matches; switching to `simp only` over the
  same lemma list distributes the sum-of-homs across BOTH LHS and RHS
  in one pass.
- **Why HOU-free here**: `F` is a binder of the lemma, not a literal
  Čech alternating-sum body. The cons step rewrites `Finset.sum_cons
  (F i) (∑ j ∈ s', F j)` whose pattern is fully Miller in `F`. The
  iter-094/095 HOU obstruction (outer-binder references at nested
  binding depths in the literal Čech summand) **does not arise** at
  this layer.

### Target 2 — `cechCofaceMap_pi_smul` L637 trailing sorry — PARTIAL (B1 bridge committed, full closure DEFERRED)

**Status**: **PARTIAL**. The iter-097 prover committed the **B1
bridging rewrite** at L656 but could not close the call site to the
new structural lemma. Five subsequent application strategies (suffices
+ congrFun; refine; rw [Preadditive.sum_comp]; refine with explicit
F; ← ConcreteCategory.comp_apply) all failed against either HOU,
type-mismatch through `ComplexShape.prev`, or a `whnf` deterministic
timeout. Final state: L657 `sorry` preserved, file compiles.

**Entry goal** (post-iter-095 `rw [show ... rfl]` at L636, from
`attempts_raw.jsonl` log_line 27):
```
case h
… (heavy context: K₀, scK₀, Z₁, Z₂, e₁, e₂, perI₁, perI₂, h_mod_pi₁/₂, …)
r : ↑R
y : (i : Fin ((ComplexShape.up ℕ).prev n + 1) → ↥s₀) → ↑(Z₁ i)
…
⊢ (ConcreteCategory.hom (Pi.π Z₂ j))
    ((ConcreteCategory.hom
        ((∑ i, (-1)^↑i • Pi.lift fun i_1 ↦
            Pi.π Z₁ (i_1 ∘ ⇑(SimplexCategory.δ i).toOrderHom) ≫
            (toModuleKPresheaf C).map (Pi.lift fun x ↦
              Pi.π (basicOpenCover ↑s₀ ∘ i_1) ((δ i).toOrderHom x)).op)
          ≫ eqToHom ⋯))
      ((piIsoPi Z₁).toLinearEquiv.symm (r • y))) =
  r • (ConcreteCategory.hom (Pi.π Z₂ j))
        ((ConcreteCategory.hom (… same expression …))
         ((piIsoPi Z₁).toLinearEquiv.symm y))
```

#### Attempt 1 — B1 bridge: `simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j]` (COMMITTED)

- **Code (committed at L652–L656 after the iter-095 cosmetic line at L651):**
  ```lean
    rw [show ModuleCat.Hom.hom = ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl]
    -- iter-097 Step 2 (B1): rewrite both `(Pi.π Z₂ j).hom z` to
    -- `(piIsoPi Z₂).hom.hom z j` (== `e₂ z j` definitionally) via
    -- `← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j`.
    simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j]
    sorry
  ```
- **Probe sequence** (`attempts_raw.jsonl` log_lines 30–34): four
  variants tried (`rw`-only with newline, `rw`-only on single line,
  `rw` chained twice, finally `simp_rw`); `simp_rw` succeeded in
  rewriting both occurrences in one pass.
- **Resulting goal** (log_line 36): the `(Pi.π Z₂ j).hom (_)` was
  rewritten to `(piIsoPi Z₂).hom.hom (_) j` on both LHS and RHS. The
  outer `j`-evaluation now sits on the outside of `((piIsoPi Z₂).hom
  .hom (...)) j`, structurally separating it from the inner
  `((∑ G_lit) ≫ eqToHom).hom (e₁.symm (r • y))` body.
- **Result**: `goals: ⟨advanced⟩`, `diagnostics: []` (log_line 49 clean
  after the subsequent revert of Attempt 2). Commit preserved.
- **Insight**: `ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j` is the
  standard Mathlib lemma stating `(Pi.π Z₂ j) ≫ ((piIsoPi Z₂).inv.hom)
  = (Submodule.subtype _) ∘ₗ ((piIsoPi Z₂).hom.hom)`, i.e. the
  `j`-component of the canonical `∏ᶜ Z₂ ≅ ∀ j, Z₂ j` iso. Used in
  the `←` direction, it rewrites the goal's outer `(Pi.π Z₂ j).hom`
  to the `(piIsoPi Z₂).hom.hom z j` form, which matches the `e₂`
  setup since `e₂ := (piIsoPi Z₂).toLinearEquiv`.

#### Attempt 2 — `suffices h_fam : <family-level statement> := by …; simpa [Pi.smul_apply] using congrFun h_fam j` (REVERTED)

- **Code (Edit log_line 42, then reverted at log_line 48):**
  ```lean
    suffices h_fam :
        (ConcreteCategory.hom (ModuleCat.piIsoPi Z₂).hom)
          (((∑ i, (-1)^↑i • Pi.lift (...) ≫ eqToHom (...)).hom)
            ((piIsoPi Z₁).toLinearEquiv.symm (r • y))) =
        r • (ConcreteCategory.hom (ModuleCat.piIsoPi Z₂).hom)
              (((∑ i, ... same ...).hom)
                ((piIsoPi Z₁).toLinearEquiv.symm y)) by
      have := congrFun h_fam j
      simpa [Pi.smul_apply] using this
    sorry
  ```
- **Lean error** (`attempts_raw.jsonl` log_line 46):
  ```
  (deterministic) timeout at `whnf`, maximum number of heartbeats
  (1600000) has been reached
  Note: Use `set_option maxHeartbeats <num>` to set the limit.
  ```
- **Result**: FAILED with deterministic 1.6M-heartbeat `whnf` timeout
  during signature elaboration of the `suffices` body. Reverted in
  the very next Edit (log_line 48), restoring the L656 sorry-with-bridge
  state.
- **Insight**: Hand-typing the literal Čech alternating-sum body
  inside a `suffices` re-introduces exactly the iter-096 refactor
  blocker that defeated the `cechCofaceMap_pi_smul_summand` companion
  helper (see refactor report § "1. `cechCofaceMap_pi_smul_summand`
  elaboration root cause"). The root cause is the same:
  `Pi.lift (fun i_1 => Pi.π Z₁ (i_1 ∘ ⇑(δ i).toOrderHom) ≫ …)` forces
  the elaborator to `whnf`-reduce `(ComplexShape.up ℕ).prev n + 1` to
  `n` outside of any tactic state where `dif_pos hRel` could fire.
  **Dead-end** for iter-098+.

#### Attempt 3 — `refine congrFun (alternating_sum_pi_smul_aux Z₁ Z₂ Finset.univ ?F e₁ e₂ ?hF r y) j` (FAILED)

- **Code (probed at `attempts_raw.jsonl` log_lines 55 and 57):**
  ```lean
    refine congrFun (alternating_sum_pi_smul_aux Z₁ Z₂ Finset.univ ?F e₁ e₂ ?hF r y) j
  ```
  and the annotated variant
  `refine congrFun (alternating_sum_pi_smul_aux Z₁ Z₂ (Finset.univ : Finset (Fin (n+1))) ?F e₁ e₂ ?hF r y) j; sorry; sorry`.
- **Lean errors** (per the prover's task report § Attempt 3, surfaced
  in log_lines 55 / 57 outputs):
  - Unannotated: `typeclass instance problem is stuck: Fintype ?m`
    (Finset.univ's index type is a metavariable that Lean cannot pin
    from the goal's surface).
  - Annotated as `(Finset.univ : Finset (Fin (n+1)))`: **type
    mismatch** — the structural lemma's conclusion
    `e₂ ((∑ F i).hom (e₁.symm (r • y))) = r • e₂ ((∑ F i).hom (e₁.symm y))`
    is in `∀ j, …` form, but the goal's LHS is
    `(piIsoPi Z₂).hom.hom (((∑ G_lit) ≫ eqToHom).hom z) j` — i.e. the
    intermediate `≫ eqToHom` is inside the inner `.hom`-application,
    not absorbed into the structural lemma's frame. `congrFun` cannot
    unify `(F i)` with `(G_lit i ≫ eqToHom)` because the eqToHom is
    outside the summand.
- **Result**: FAILED. Not committed.
- **Insight**: confirms refactor report §2 "(A1)/(A2)" warning — the
  abstract structural lemma's signature does NOT match the L637 goal
  shape directly. Either an inner-eqToHom-absorption bridge OR a
  `Q`-codomain-parametric specialisation is required.

#### Attempt 4 — `rw [Preadditive.sum_comp]` / `rw [key₂]` (FAILED, dead-end re-confirmation)

- **Code (probed at log_lines 50, 51, 53, 59, 62):**
  ```lean
    rw [Preadditive.sum_comp]; sorry
    rw [Preadditive.sum_comp Finset.univ]; sorry
    rw [key₂]; sorry
    simp only [key₂]; sorry
  ```
- **Lean state** (log_lines 53, 59, 62): all four variants left the
  goal **unchanged** (`rw` failed to fire — pattern not found / HOU)
  but compiled with the trailing `sorry`. The goal shape post-tactic
  was bit-for-bit identical to the entry goal.
- **Result**: FAILED with HOU. Re-confirms the iter-094/095 finding:
  pattern `(∑ j ∈ ?s, ?f j) ≫ ?g` does not match
  `(∑ i, (-1)^↑i • Pi.lift (fun i_1 => …uses i…)) ≫ eqToHom` because
  `?f i` cannot abstract over the multiple non-Miller `i` references
  in the body (`(-1)^↑i`, `(δ i).toOrderHom` used twice).
- **Insight**: **DO NOT RETRY** in iter-098+. This is the same HOU
  blocker that iter-094/095 catalogued, and it transfers verbatim to
  `Preadditive.sum_comp` (the underlying lemma of the body-local
  `key₂` from iter-094).

#### Attempt 5 — `have h_struct := alternating_sum_pi_smul_aux ... (fun i => …literal F…) ...` (FAILED)

- **Code (probed at log_lines 65, 66):**
  ```lean
    have h_struct := alternating_sum_pi_smul_aux Z₁ Z₂
      (Finset.univ : Finset (Fin (n+1)))
      (fun i => (-1 : ℤ)^(↑i : ℕ) •
        Pi.lift fun (i_1 : Fin (n+1) → ↥s₀) =>
          Pi.π Z₁ (i_1 ∘ ⇑(SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i)))
          ≫ (toModuleKPresheaf C).map (...)
        ≫ eqToHom (...))
      e₁ e₂ ?hF
  ```
- **Lean error**: deep type-mismatch through `ComplexShape.prev`:
  ```
  Pi.π (basicOpenCover ?m ∘ ?m_1) (...) has type
    ∏ᶜ basicOpenCover ?m ∘ ?m_1 ⟶ ...
  but is expected to have type
    (∏ᶜ fun a ↦ basicOpenCover (↑s₀) (i_1 a)) ⟶ ...
  ```
  Even with the explicitly eta-expanded form
  `fun a => basicOpenCover ↑s₀ (i_1 a)`, the inner secondary `Pi.lift`'s
  index type `Fin ((ComplexShape.up ℕ).prev n + 1) → ↥s₀` does not
  unify with the outer summation index `i_1 : Fin (n+1) → ↥s₀`
  without the tactic-state `dif_pos hRel`.
- **Result**: FAILED. Not committed.
- **Insight**: Hand-providing the literal F with eqToHom baked in
  re-triggers the same `dif_pos hRel`-gated bridge as Attempt 2,
  surfacing as a unification problem **outside** the tactic state.
  This is the same root cause that defeated the iter-096 refactor's
  `cechCofaceMap_pi_smul_summand` companion. **Dead-end class**.

#### Attempt 6 — `rw [← ConcreteCategory.comp_apply]` (FAILED, pattern not found)

- **Code (probed at log_line 71):**
  ```lean
    rw [← ConcreteCategory.comp_apply]; sorry
  ```
- **Lean state**: goal unchanged (pattern not found). Both the outer
  `ConcreteCategory.hom (Pi.π Z₂ j)` and the inner `ConcreteCategory.hom
  ((∑G_lit) ≫ eqToHom)` are already in `ConcreteCategory.hom` form
  post-iter-095 cosmetic — the lemma matches the form
  `(ConcreteCategory.hom (f ≫ g)) x` but the goal is
  `(ConcreteCategory.hom g) ((ConcreteCategory.hom f) x)` with both
  expanded as separate applications, not a composition.
- **Result**: FAILED.
- **Insight**: After the iter-095 cosmetic normalisation
  (`ModuleCat.Hom.hom → ConcreteCategory.hom`), the `← comp_apply`
  re-folding direction requires the **forward direction** of the
  lemma — `(ConcreteCategory.hom g ∘ ConcreteCategory.hom f) x =
  ConcreteCategory.hom (f ≫ g) x` — which is what `iter-094`'s
  `← ModuleCat.hom_comp` accomplishes one layer down. The same shape
  obstruction applies here as in Attempt 3 (the `eqToHom` is **inside**
  the inner application, not outside).

### Targets 3–7 (BasicOpenCech.lean L749, L1073, L1101, L1291, L1320) — UNTOUCHED

Per the plan's "Off-limits this iteration" §, these five sorries are
gated on Lane 1 closing `cechCofaceMap_pi_smul` (L657) or on multi-iter
Mathlib infrastructure (L749, L1073, L1101 augmented-Čech /
extra-degeneracy). Untouched at iter-097.

### Targets 8–12 (Differentials.lean L122, L636, L957, L974, L1116) — OFF-LIMITS

Per the plan's "Off-limits this iteration" §, `Differentials.lean`
was not assigned this iteration. Untouched.

### Other off-limits — UNTOUCHED

- `Modules/Monoidal.lean` L173 (Mathlib gap).
- `Jacobian.lean` L179 (Phase C/E, iter-100+).
- `Picard/Functor.lean` L190 (gated on Phase C C0–C3).

## Key findings and proof patterns discovered

### Findings (this session)

1. **Plan recipe for Step 1 was correct first try.** The
   `Finset.cons_induction + simp only [Finset.sum_cons, ModuleCat.hom_add,
   LinearMap.add_apply, map_add] + rw [hF, ih, smul_add]` recipe
   matched the plan's draft proof exactly (the plan's tiny error was
   suggesting `ModuleCat.zero_hom` instead of `ModuleCat.hom_zero` —
   minor cosmetic correction). **Refactor escalation (iter-096)
   produced a useful abstract hook whose body was 17 lines.**
2. **Refactor report's structural prediction confirmed.** The
   iter-096 refactor report §2 "(A1)/(A2)" warned that the abstract
   `alternating_sum_pi_smul_aux` would NOT match the L637 goal
   directly because of the outer `Pi.π Z₂ j` and intermediate
   `eqToHom`. Iter-097's five failed Step 2 attempts exhibit precisely
   this gap. The recommended path forward (iter-098 follow-up
   refactor with `alternating_sum_pi_smul_aux_pi_proj` specialisation
   baking in the `Pi.π Z₂ j` projection AND the eqToHom-codomain
   bridge) is the only remaining unblocked direction.
3. **The B1 bridge `simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply
   Z₂ j]` is genuine partial progress.** Even though L657 was not
   closed, the bridging rewrite at L656 converts the goal's outer
   `(Pi.π Z₂ j).hom (_)` to `(piIsoPi Z₂).hom.hom (_) j` form on
   BOTH sides simultaneously, exposing the `e₂` (=
   `(piIsoPi Z₂).toLinearEquiv`) structure. Preserve byte-for-byte
   into iter-098.
4. **`whnf` timeout at signature elaboration is a class of dead-end,
   not a single tactic.** Both the iter-096 refactor (companion
   helper `cechCofaceMap_pi_smul_summand`) and the iter-097 Attempt 2
   (`suffices h_fam`) hit the **same** root cause: hand-typing the
   literal Čech alternating sum forces the elaborator to whnf-reduce
   `(ComplexShape.up ℕ).prev n + 1 = n` without `dif_pos hRel`
   available, and this is too heavy. **Anti-pattern lesson**: any
   future Step 2 attempt that hand-types the alternating-sum body
   outside a tactic state will hit this timeout. Use binders.

### Proof patterns (reusable across targets)

1. **`Finset.cons_induction` on a `Finset` *binder* of an abstract
   structural lemma** *(iter-097, NEW)*: when proving a "sum of
   property-P-satisfying maps satisfies P" structural lemma, induct
   on the `s` binder (NOT on `Finset.univ`), `revert` the per-summand
   hypothesis `hF` first to keep the inductive `ih` general, and
   discharge the cons step via
   `simp only [Finset.sum_cons, ModuleCat.hom_add, LinearMap.add_apply, map_add]`
   followed by `rw [hF i …, ih …, smul_add]`. HOU-free because all
   binders are abstract.
2. **`simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j]` to
   re-expose `(piIsoPi Z₂).hom.hom z j` form** *(iter-097, NEW)*: when
   a goal has `(Pi.π Z₂ j).hom z` on both LHS and RHS, this `simp_rw`
   converts both to the `(piIsoPi Z₂).hom.hom z j` form in one pass,
   structurally separating the outer `j`-evaluation from the inner
   body and exposing the `e₂` (`= piIsoPi Z₂ .toLinearEquiv`)
   structure for downstream bridging.
3. **Plan-recipe transcription with name-correction**
   *(iter-097, meta-pattern)*: when the plan's draft proof recipe
   names a Mathlib lemma incorrectly (here `ModuleCat.zero_hom` →
   `ModuleCat.hom_zero`), `lean_local_search` / `lean_loogle` reveals
   the correct name in < 1 minute; the recipe otherwise transcribes
   verbatim.

### Anti-patterns (re-confirmed iter-097, do not retry)

1. **`suffices h_fam : <literal Čech body> := by …`** — `whnf`
   deterministic timeout at 1.6M heartbeats during signature
   elaboration. Same root cause as iter-096 refactor's
   `cechCofaceMap_pi_smul_summand` companion drop.
2. **`refine congrFun (alternating_sum_pi_smul_aux Z₁ Z₂ s ?F e₁ e₂ ?hF r y) j`**
   without a prior outer-eqToHom-absorption — Lean cannot unify
   `(F i)` with `(G_lit i ≫ eqToHom)` because the eqToHom is in the
   wrong structural position.
3. **`rw [Preadditive.sum_comp]` / `rw [key₂]`** on the post-(b') goal
   — HOU on nested-`i` summand body (iter-094/095 dead-end transfers
   verbatim).
4. **`have h_struct := alternating_sum_pi_smul_aux ... (fun i => <literal F with eqToHom>) ...`**
   — type-mismatch through `ComplexShape.prev` (`Fin (prev n + 1)`
   vs `Fin (n+1)` non-unification outside tactic state).
5. **`rw [← ConcreteCategory.comp_apply]`** with both `outer.hom` and
   `inner.hom` already in `ConcreteCategory.hom` form — pattern not
   found (lemma's LHS is a composition, but the goal has two separate
   applications).

## Recommendations for next session

See `recommendations.md` for the structured iter-098 directive.

## Blueprint markers updated (manual)

**None.**

- `alternating_sum_pi_smul_aux` (BasicOpenCech.lean L462): no
  `\lean{...}` blueprint entry (project-local helper); no marker
  change needed. Per the prover's task report § Markers, this is a
  project-local helper without a blueprint entry.
- `cechCofaceMap_pi_smul` (BasicOpenCech.lean L500): no blueprint
  entry; no marker change.
- `presheafMap_restrict_collapse` (L425): no blueprint entry.
- No `\mathlibok` candidates surfaced this iteration. No `\lean{...}`
  rename / file-relocation flagged in the task result. No stale
  `\notready` to strip.
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
  Target 2: 6 attempts = 5 Edits + multiple probes per the log).
- [x] `summary.md` includes specific code/errors, not just high-level
  summaries (see Attempt-by-Attempt above with code blocks and Lean
  error texts).
- [x] `recommendations.md` includes actionable next steps.
- [x] **No `\leanok` marker was manually added or removed** — the
  deterministic `sync_leanok` phase handles that.
- [x] No Mathlib-backed declarations reported by the prover this
  iteration; no `\mathlibok` adds needed.
- [x] No `\lean{...}` macro rename was flagged in the task result.
- [x] No `\notready` markers remain on landed declarations (none
  changed this iteration).
