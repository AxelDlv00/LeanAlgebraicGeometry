# Session 76 — iter-076 review

## Metadata

- **Archon iteration**: 076
- **Stage**: prover (two parallel REPAIR lanes: Differentials, BasicOpenCech)
- **Sorry count before iter-076** (per `PROJECT_STATUS.md` after iter-075):
  - BasicOpenCech 6 + Differentials 7 + Jacobian 1 + AbelJacobi 0 + Picard/Functor 1 = **15**.
  - *(Plan agent corrected baseline to 14 — BasicOpenCech 6 + Differentials 6 + 1 + 0 + 1 — reconciling a stale L122 vs L113 sorry attribution in the iter-075 review. Use **14** as the iter-076 starting baseline going forward.)*
- **Sorry count after iter-076** (verified via `sorry_analyzer.py` on each file):
  - BasicOpenCech **7** + Differentials **7** + Jacobian 1 + AbelJacobi 0 + Picard/Functor 1 = **16**.
- **Net change**: **+2 sorries** (within the plan's `≤ +5` repair budget: lane 1 budget +2 on Differentials, lane 2 budget +3 on BasicOpenCech).
- **Compilation status**: BOTH FILES NOW COMPILE CLEANLY. `lean_diagnostic_messages` returns `error_count: 0` post-edit on `BasicOpenCech.lean` (log line 45) and `Differentials.lean` (log line 75). This **resolves the iter-076 plan-pass-flagged 5 + 12 = 17 errors** identified at the start of the iteration. Both files were broken when iter-076 began.
- **Env state**: `lean_diagnostic_messages` works correctly and returns useful diagnostics (the iter-068+ "build environment broken" framing was stale — corrected by plan-agent this iteration). `lean_run_code` was not used (per user policy). `lean_multi_attempt` returned empty `diagnostics: []` for snippets that did NOT close the goal — flagged via debug-feedback.

---

## Prover attempt analysis (from `attempts_raw.jsonl`)

The pre-processed attempt log records **87 events** (summary + 86): 17 edits across 2 files, 1 goal check, 14 diagnostic checks, 0 builds, 2 lemma searches. Per-file `code_change` counts:

| File | code_change | code_write |
|---|---:|---:|
| `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` | 11 | 1 (task_result) |
| `AlgebraicJacobian/Differentials.lean` | 6 | 1 (task_result) |

Both lanes ran `lean_diagnostic_messages` repeatedly — 14 calls total, two terminating in clean state (BasicOpenCech log line 45, Differentials log line 75). The diagnostic-driven loop replaced the iter-074/075 commit-without-verification policy that produced the broken state.

---

## Lane 1 — `Cohomology/BasicOpenCech.lean` REPAIR (target: zero errors, ≤9 sorries)

**Status**: RESOLVED. File compiles cleanly. Sorries: 6 → 7 (+1).

### Sorry mapping (old → new)

Original 6 (pre-iter-076): L495, L819, L847, L1166, L1181, L1260.
Final 7 (post-iter-076): L495, L819, L847, **L1077** (h_diff_pi_smul_f body, rolled back from L1083+ chain), **L1106** (f_R.map_smul' body, NEW rollback), **L1116** (g_R.map_smul' body, NEW rollback), L1145 (h_loc_exact, was L1260).

Removed entirely: the `h_diff_pi_smul_g` declaration (its statement could not type-check — see attempt 6 below).

### Significant attempts

**Attempt 1 — `h_diff_pi_smul_f` via funext + 5-layer simp + Finset.sum_congr per-summand + smul_comm chain** (log lines 41–49)
- `code_tried`: `funext j; simp only [...5-layer functor stack unfold...]; refine Finset.sum_congr rfl fun k _ => ?_; rw [smul_comm]; congr 1`
- `lean_error`: `simp made no progress` (L1088); the 5-layer unfold does NOT expose alternating-sum form (`Pi.smul_apply / Finset.sum_apply / Finset.smul_sum` don't fire).
- `insight`: The iter-073/074/075 staircase hopeful framing was wrong — `Finset.sum_congr` cannot bridge to a per-summand `_ j = _ j` goal that doesn't have ∑ at the head.

**Attempt 2 — `try`-wrapped simp + `Finset.sum_congr rfl`** (intermediate edit)
- `code_tried`: `try simp only [Pi.smul_apply, Finset.sum_apply, Finset.smul_sum]; refine Finset.sum_congr rfl fun k _ => ?_`
- `lean_error`: `Finset.sum_congr rfl` doesn't apply — goal is `_ j = _ j`.
- `insight`: confirms entire iter-075 chain unreachable.

**Attempt 3 — Roll back `h_diff_pi_smul_f` to bare sorry** (log line 66, final state)
- `code_tried`: `by intro r y; sorry` (with iter-073/075/076 reduction recipe preserved as comment).
- `result`: success (sorry).

**Attempt 4 — `h_mod_X₃` repair via `convert h using N` / `convert h; congr 1`** (log lines 58, 95)
- `code_tried`: `convert h using 1; congr 1` (and variants `using 4`, `exact h.cast (...)`)
- `lean_error`: `case h.e_2` left `Module ↑R T₁ = Module ↑R T₂`; `Invalid field cast: Module.cast`; `No applicable extensionality theorem found for type Type u`.
- `insight`: ROOT CAUSE diagnosed — `scK₀.X₃ = K₀.X ((ComplexShape.up ℕ).next n)` and `ComplexShape.next` is OPAQUE (defined via `Classical.choose` over `Rel`). It does NOT reduce to `n + 1` by `rfl`. `convert h` succeeds verbatim for X₁/X₂ (literal `n` indices) but not X₃.

**Attempt 5 — `h_mod_X₃` via pre-rewrite using Mathlib `CochainComplex.next`** (log line 125, final state)
- `code_tried`:
  ```lean
  have h_eq : scK₀.X₃ = K₀.X (n + 1) := by
    show K₀.X ((ComplexShape.up ℕ).next n) = K₀.X (n + 1)
    rw [CochainComplex.next]
  rw [h_eq]
  dsimp [K₀, cechCochain, cechComplexFunctor, toModuleKSheaf, toModuleKPresheaf_obj]
  letI := h_mod_pi₃
  have h : Module R ↑(∏ᶜ Z₃) := e₃.toAddEquiv.module R
  convert h
  ```
- `lean_error`: none — `lean_diagnostic_messages` clean (log line 45).
- `insight`: **REUSABLE PATTERN**. For ANY `K.X ((ComplexShape.up α).next i)` / `K.X (prev i)` instance-transport, pre-rewrite the projection via the explicit Mathlib lemma `CochainComplex.next : (ComplexShape.up α).next i = i + 1` BEFORE the dsimp.

**Attempt 6 — Drop `h_diff_pi_smul_g` declaration entirely**
- `code_tried`: remove the whole `have h_diff_pi_smul_g : ... := by ...` block; replace with ITER-076 rollback comment.
- `insight`: The statement `e₃ ((ConcreteCategory.hom scK₀.g) (e₂.symm (r • y)))` could not type-check because `↑scK₀.X₃ ≠ ↑(∏ᶜ Z₃)` definitionally (same opaqueness as L952). Unlike `h_diff_pi_smul_f` (where `↑scK₀.X₂ ≡ ↑(∏ᶜ Z₂)` because `n` is literal), the g-variant needs an explicit `CochainComplex.next` rewrite inside the **statement type**, not the proof body. Removing the declaration eliminates the L1170–1182 cascade.

**Attempt 7 — Roll back `f_R.map_smul'` and `g_R.map_smul'` bodies**
- `code_tried`: `intro r x; sorry` for both.
- `lean_error` (pre-rollback): L1205 unsolved `(ConcreteCategory.hom scK₀.f)(r • x) = (ConcreteCategory.hom scK₀.f)(e₁.symm (r • e₁ x))`; L1213 isDefEq heartbeat.
- `insight`: ROOT CAUSE — `convert h` derives `Module R scK₀.X_i` that differs from the canonical `e_i.toAddEquiv.module R` by a residual eta-congruence. The `r • x = e_i.symm (r • e_i x)` step does NOT close by `rfl` because the smul comes from the convert-derived instance, not from `e_i.toEquiv.smul R`. Iter-077 needs to rebuild `h_mod_X_i` via explicit `Eq.mpr` over a manual type equality.

### Key learnings (Lane 1)

- **`ComplexShape.next` opaqueness**: any `(ComplexShape.up α).next i` term needs an EXPLICIT rewrite via `CochainComplex.next` (Mathlib) to reduce to `i + 1`. The dsimp set never unfolds it.
- **Instance literality vs. definitional equality**: `convert h` produces an instance that is propositionally equal to the canonical one but NOT definitionally equal. This breaks downstream `rfl`-dependent steps. Pre-rewriting type-level equalities (rather than coercing instances) is the safer pattern.

---

## Lane 2 — `Differentials.lean` REPAIR (target: zero errors, ≤8 sorries)

**Status**: RESOLVED. File compiles cleanly. Sorries: 6 → 7 (+1 net, but +3 rollbacks − 2 merge of `h_exact`/`h_epi` into a single outer `_structure` sorry).

### Sorry inventory (final)

| Line | Decl | Origin |
|------|------|--------|
| 122 | `relativeDifferentialsPresheaf_isSheaf` | pre-iter-076 |
| 207 | `cotangentExactSeqAlpha` | ITER-076 rollback |
| 232 | `cotangentExactSeqBeta` | ITER-076 rollback |
| 266 | `cotangentExactSeq_structure` | ITER-076 rollback (absorbs old L604/L617 `h_exact` + `h_epi` two sub-sorries) |
| 543 | `smooth_iff_locally_free_omega` | pre-iter-076 |
| 559 | `cotangent_at_section` | pre-iter-076 |
| 703 | `serre_duality_genus` | pre-iter-076 |

### Significant attempts (3 rollbacks)

**Attempt 1 — Roll back `cotangentExactSeqAlpha` body to `sorry`** (log line 178)
- `lean_error` (pre-rollback): L244 unsolved additivity goal `D_X.d ((f.c.app U).hom (a+b)) = D_X.d (… a) + D_X.d (… b)`; L248 `rw` pattern `(CommRingCat.Hom.hom (f.c.app U)) (?a * ?b)` not found despite syntactically present; L256 `Function expected at ConcreteCategory.hom h` (`congr_arg (fun h => ConcreteCategory.hom h x) (f.c.naturality f')` underspecified `h`); L258 same as L248; L266 `rfl` claim fails for `φ_g' ≫ f.c = adj_f.unit ≫ pushforward.map φ_fg'` (adjunction-coherence across `(f ≫ g).base = g.base ≫ f.base` NOT definitionally true).
- `code_tried`: `noncomputable def cotangentExactSeqAlpha (f : X ⟶ Y) (g : Y ⟶ S) : ... := by sorry`
- `result`: partial (sorry); strategy comment preserved.

**Attempt 2 — Roll back `cotangentExactSeqBeta` body to `sorry`** (log line 181)
- `lean_error` (pre-rollback): L297, L342, L343 `whnf` heartbeat ≥ 200000 hb from the `set adj_fg / set η / hη` chain; L332 `No goals to be solved` on `exact h4` after upstream simp closed the goal.
- `code_tried`: `... := by sorry`
- `recovery routes for iter-077`: prepend `set_option maxHeartbeats 400000 in`, or inline `η` rather than `set`-ing it.

**Attempt 3 — Roll back `cotangentExactSeq_structure` whole body to single `sorry`** (log line 188)
- Eliminated L604 / L617 (old sub-sorries `h_exact` / `h_epi`). Preserved in-flight Steps 1–7 chain (~220 LOC with `hα_fac` / `hβ_fac` / `hd_app` setup, adjunction-coherence `hcoh`, `SheafOfModules.hom_ext`, `isUniversal'.postcomp_injective`, `Derivation.congr_d`, `postcomp_d_apply` chain) as a `/- ITER-076 disabled chain ... -/` block comment.
- `lean_error` (pre-rollback): L452 `simp made no progress` plus cascading `Unknown identifier cotangentExactSeqBeta` once Beta is sorried.

**Attempt 4 — Block-comment delimiter repair** (log lines 206, 212, 222)
- Initial block-comment `/-! ...` open delimiter mis-parsed; intermediate compile errors (`No applicable extensionality theorem found for type Type u` + cascade).
- Fix: switch to `/- ... -/` with leftover syntactic `sorry`s neutralised as `-- (sorry)`.

### Key learnings (Lane 2)

- **Five-error cumulative cascade exceeds in-iteration repair budget**. When a single tactic block has 5+ independent errors, rollback is correct triage. Plan-agent's targeted fixes are correct in principle but require coordinated rewrite — defer to next iter.
- **Block-comment hygiene**: `/-! ...` for module-doc blocks; `/- ... -/` for ordinary blocks. Stray `sorry` inside a malformed block-open is counted as syntactic by lean.
- **`Adjunction.homEquiv = unit ≫ G.map` is `rfl` ONLY for single-adjunction** — for composed-adjunction coherence (`φ_g' ≫ f.c = adj_f.unit ≫ pushforward.map φ_fg'`), it requires explicit `Adjunction.homEquiv_naturality` + `Equiv.symm_apply_eq`. The iter-075 "rfl" framing was wrong.

---

## Cross-lane learnings

1. **`lean_diagnostic_messages` actually works**. The persistent "build env broken since iter-068" framing was stale (corrected by plan-agent this iter). Each prover-edit followed by a diagnostic call gives precise error attribution.
2. **`lean_multi_attempt` returns empty `diagnostics: []` for snippets that did not close the goal**. This is misleading — empty diagnostics ≠ success. Provers should verify by editing+`lean_diagnostic_messages`, not by reading `multi_attempt` output naively. Logged to `.debug-feedback/`.
3. **`ComplexShape.next/prev` opaqueness is a project-wide issue**. Wherever an instance/coercion is transported across a `K.X (next n)` boundary, the explicit `CochainComplex.next` rewrite must come BEFORE the dsimp.
4. **Convert-derived instances ≠ canonical instances**. Use `Eq.mpr` over manual type equalities to ensure literal instance equality where downstream `rfl` is needed.

---

## Blueprint markers updated (manual)

None this session. Reasoning:
- No prover renames of declarations (both lanes rolled back to existing names).
- No protected-decl path changes (`archon-protected.yaml` unchanged).
- No new Mathlib-backed declarations to add `\mathlibok` for.
- No stale `\notready` markers identified on landed declarations (this iter's net delta is +2 sorries, no closures).

The deterministic `sync_leanok` phase that ran before me will have adjusted `\leanok` markers based on the new sorry state (Differentials: same line numbers shifted; BasicOpenCech: previously-marked `h_diff_pi_smul_f` will lose `\leanok` if it had one and the surrounding theorem's `\leanok` will be reassessed). No manual marker work is needed.

---

## Sorry-count budget tracking

| Lane | Plan budget | Actual delta | Within budget? |
|---|---|---|---|
| Lane 1 BasicOpenCech | ≤ +3 (start 6, max 9) | +1 (6 → 7) | YES (2 under) |
| Lane 2 Differentials | ≤ +2 (start 6, max 8) | +1 (6 → 7) | YES (1 under) |
| **Project total** | n/a | **+2 (14 → 16)** | n/a |

Both lanes returned PARTIAL with compilation restored — the iter-076 repair goal. No new axioms, no new helpers, no protected-signature changes.

---

## Process discipline (iter-076 retro)

- Plan-agent correctly identified the iter-074/075 commit-without-LSP-verification policy as the root cause of the broken state.
- The corrected dev loop (edit + `lean_diagnostic_messages` per save) worked — both lanes landed clean diagnostics within ~20 minutes each.
- Hard constraints honored: no new helpers, no new axioms, no `lean_run_code` pre-validation.
- `archon-protected.yaml` unchanged.
- One debug-feedback note appended (`lean_multi_attempt` empty-diagnostics issue).
