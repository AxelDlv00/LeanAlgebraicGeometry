# Iter-143 (Archon canonical) — review

## Outcome at a glance

- **Prover lane FIRED** on `AlgebraicJacobian/Cotangent/GrpObj.lean` piece (i.b) Step 2 d_app-only narrowed scope (per iter-143 plan agent's Wave 3 scope) and returned **PARTIAL — 0 strict-count closures**. `meta.json`: `planValidate.status: ok / objectives: 1`, `prover.status: done`, `prover.durationSecs: 2221` (~37 min). Per the pre-committed acceptance matrix (PASS = d_app closes substantively / PARTIAL = d_app does not close / FAIL = d_app + new `pushforward₀`-style blocker resurfaces), iter-143 lands in the **PARTIAL arm → CHURNING-CONFIRMED**.

- **Sorry count delta**: 6 → **6** declarations using `sorry`; 6 → **6** inline `sorry` — **unchanged**. Per-file at iter-143 close (verified via in-Lean diagnostic):
  - `Cotangent/GrpObj.lean:573` — `basechange_along_proj_two_inv_derivation` (1 internal sub-sorry at L663 = d_app; d_map at L664–700 CLOSED iter-142 preserved).
  - `Cotangent/GrpObj.lean:745` — `basechange_along_proj_two_inv_app_isIso` (NEW iter-143 Wave 2 refactor extraction; body `sorry` at L751; OFF-LIMITS to iter-143 prover).
  - `Cotangent/GrpObj.lean:890` — `mulRight_globalises_cotangent` (Main; iter-135 carry-over body `sorry` at L901).
  - `Jacobian.lean:193` — `genusZeroWitness` (L197; M2.b scaffold).
  - `Jacobian.lean:219` — `positiveGenusWitness` (L223; M3 scaffold).
  - `RigidityKbar.lean:75` — `rigidity_over_kbar` (L87; M2.a scaffold).

- **Substantive code delta** (iter-143 prover lane, 7 edits / 6 goal checks / 8 diagnostic checks / 0 builds / 21 lemma searches — `attempts_raw.jsonl`):
  - **`have hw` at L637–638 (NEW iter-143 Step 3.a closure, ~3 LOC)**: `have hw : (fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom := by rw [(fst G G).w, (snd G G).w]`. Closes the Step 3.a categorical identity per the iter-142 blueprint recipe at `RigidityKbar.tex:786`. Verified standalone via `lean_multi_attempt`.
  - **Comment expansion at L602–662 (~60 LOC)** documenting the full Step 3 (3.a–3.d) sub-recipe with cross-references to `RigidityKbar.tex:786` and `analogies/d-app-d-map-recipe-shape.md`. The expansion explicitly chains the planned 3.b (`PresheafedSpace.comp_c_app` lift) + 3.c (`Adjunction.homEquiv_naturality_right_symm` transpose) + 3.d (`ModuleCat.Derivation.d_map` discharge) steps, with the recipe's NEEDS_MATHLIB_GAP_FILL caveat carried inline.
  - **No body closure**: the canonical-form `change` block at L632–635 (preserved verbatim from iter-142) + the iter-142 d_map closure body at L664–700 + the iter-143 `have hw` are all the substantive content. The chase body remains `sorry` at L663.

- **Auditor MAJOR finding (`lean-auditor-review143`)**: **the iter-143 `have hw` at L637–638 is dead-load** (introduces a categorical equality but the proof falls through ~25 LOC of comments straight to `sorry` on L663 without consuming it). Removing the `have` would not change what compiles. This is a real audit-transparency cost; iter-144 must either wire `hw` through to a partial closure (recommended: lift to c-component level via `PresheafedSpace.comp_c_app` per Step 3.b) OR revert it and keep the chase entirely as documentation.

- **Lean-vs-blueprint-checker MAJOR finding (`lean-vs-blueprint-checker-cotangent-grpobj-review143`)**: **the iter-143 Wave 2 refactor's new theorem `basechange_along_proj_two_inv_app_isIso` (L745–751) lacks a first-class blueprint `\begin{theorem}` block**. The blueprint mentions the name inside a `%`-comment NOTE at `RigidityKbar.tex:1141` and documents the closure recipe inline at L1167–1320, but never promotes it to a standalone `\begin{theorem}\label{...}\lean{...}` block. Recommend adding one (<30 LOC of new blueprint prose) before iter-144+ prover lane attacks the body. Iter-143 STRATEGY.md Edit-1 (sorry-must-be-a-named-declaration soundness rule) is satisfied at the Lean side but not at the blueprint side.

- **3 subagent dispatches this iter** (2 mandatory review-phase + 1 reuses prover task-result):
  - **`lean-auditor-review143`** (333 s / $3.58 / 32 turns; 14 files audited): **0 must-fix-this-iter / 1 MAJOR / 3 minor / 0 excuse-comments**. MAJOR: dead-load `have hw`. Minors: heavy 60-LOC in-Lean comment block; `Jacobian.lean:275` longLine lint; potentially-redundant typeclasses on new IsIso theorem. Auditor explicitly **confirmed** that iter-143 changes around L602–662 are scope-disclosure documentation, NOT excuse-comments (extending the iter-140/142 verdict on the long docstrings).
  - **`lean-vs-blueprint-checker-cotangent-grpobj-review143`** (250 s / $1.89 / 15 turns): **0 must-fix-this-iter / 1 MAJOR / 1 MINOR**. MAJOR: missing standalone `\begin{theorem}` block for `basechange_along_proj_two_inv_app_isIso`. MINOR: stale pointer-chapter text (already on iter-144+ cleanup list). Overall verdict: Lean follows the blueprint faithfully; signatures match across all 9 referenced declarations; the iter-143 in-Lean refactor is mathematically authorized by the blueprint NOTE block.
  - `Cotangent_GrpObj.lean.md` task-result (from prover lane): documents the iter-143 prover's own analysis — recipe-level partial close + tooling-level obstacle (Eq.mpr/eqToHom for pushforward composites when only `(f ≫ g) = h` is propositional).

- **Iter-143 STRATEGY.md Edit-2 counter discipline applied**: iter-143 PARTIAL → consecutive-PARTIAL counter 2 → 3 (per iter-143 STRATEGY.md Edit-2 rule). Breakeven at 5 projects iter-146+ at earliest under no further closures. Counter projects: iter-144 PARTIAL → 4, iter-145 PARTIAL → 5 triggers breakeven; iter-144 PASS resets counter from 3 → 2.

- **Sub-iter inputs absorbed (iter-143 prover lane learning)**:
  - **POSITIVE pattern**: `Over.w` chain for Over-categorical-product identities (~3 LOC closure for `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom`). Codified in PROJECT_STATUS.md Knowledge Base.
  - **NEGATIVE anti-pattern 1**: blind `simp only [Adjunction.homEquiv_*_symm]` does NOT close adjunction-transpose goals where the inner equation is a c-component equality (verified iter-143 attempt 4). Codified.
  - **NEGATIVE anti-pattern 2**: `refine (CommRingCat.KaehlerDifferential.D _).d_map ?_` fails when the goal carries `ψ ∘ φ_G` (not literally `φ_LHS ∘ h`) — produces metavariable-typed sub-goal because factoring witness `h` is not surface-derivable. Codified.

## What iter-144 should do (per `recommendations.md`)

- **MAJOR M0**: address the auditor's dead-load `have hw` finding — either wire it through to Step 3.b lift (recommended Arm A) or revert it (Arm B).
- **MAJOR M1**: dispatch `blueprint-writer` on `RigidityKbar.tex` to add a first-class `\begin{theorem}` block for the iter-143 NEW IsIso theorem.
- **MEDIUM Me1**: dispatch focused `mathlib-analogist` on the `pushforward (f ≫ g) X` reconciliation question (the tooling-level obstacle codified iter-143).
- **MEDIUM Me2**: consider `refactor` to extract Step 3.b into a named helper lemma (mirror the iter-143 IsIso refactor pattern; sorry-must-be-named-declaration).
- **MEDIUM Me3**: iter-144 MANDATORY chart-algebra-vs-bundled re-evaluation (carry-forward gate per iter-140 Must-fix #3 + iter-141 scheme-Frobenius HYBRID + iter-143 Watch criterion #4).
- **LOW L1**: blueprint-writer touch-up on stale pointer-chapter text at `AlgebraicJacobian_Cotangent_GrpObj.tex:46–49`.
- **LOW L2**: optional `archon-lean4:doctor` consult on `sync_leanok` mis-mark carry-over at `RigidityKbar.tex:406, 524, 1152`.

## Blueprint markers updated (manual this iter)

- `Jacobian.tex`, `def:genusZeroWitness` (L389): stripped stale `\notready` (Lean scaffold exists at `Jacobian.lean:193`, sorry-bodied; carry-over cleanup from iter-143 plan agent's iter-144+ list).
- `Jacobian.tex`, `def:positiveGenusWitness` (L424): stripped stale `\notready` (Lean scaffold exists at `Jacobian.lean:219`, sorry-bodied; same).

## Files written this review phase

- `proof-journal/sessions/session_143/{summary.md, milestones.jsonl, recommendations.md}`.
- `iter/iter-143/review.md` (this file).
- `.archon/PROJECT_STATUS.md` (Knowledge Base: 3 new entries — 1 Proof Pattern, 2 anti-patterns; Last Updated stamp).
- `.archon/TO_USER.md` (left empty — no impasse; iter-143 plan agent has clear direction; iter-143 outcome PARTIAL matches a pre-committed acceptance arm).
- `blueprint/src/chapters/Jacobian.tex` (2 stale `\notready` strips).

## Blueprint doctor

`blueprint-doctor.md`: no structural findings (every chapter `\input`'d, every `\ref`/`\uses` resolves, no `axiom` declarations under `.lean`). Clean.

## Sidecar contents (this file only)

This file is born-bounded — it contains the iter-143 review narrative only, not a multi-iter log. The mandatory review-phase reports are at `.archon/task_results/{lean-auditor-review143.md, lean-vs-blueprint-checker-cotangent-grpobj-review143.md}` and archived at `.archon/logs/iter-143/{lean-auditor-review143-report.md, lean-vs-blueprint-checker-cotangent-grpobj-review143-report.md}`. The session journal at `.archon/proof-journal/sessions/session_143/` has the structured attempt-by-attempt detail.
