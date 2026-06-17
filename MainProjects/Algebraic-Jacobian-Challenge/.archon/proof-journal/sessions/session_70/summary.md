# Session 70 — iter-070 review

## Metadata

- **Archon iteration**: 070
- **Stage**: plan-agent blueprint rewrite and audit (no prover dispatch); prover attempts in `attempts_raw.jsonl` are pre-directive / stale and made zero net progress
- **Plan-agent work this iteration (pre-prover)**:
  - Rewrote all 12 blueprint chapters to mathematical prose (removed Lean identifiers, tactics, iteration numbers from main text).
  - Audited Lean declarations against blueprint entries; added 5 missing `\lean{...}` entries to `Cohomology_MayerVietoris.tex`.
  - Explicitly deferred prover work per user directive 2026-05-12.
- **Sorry count before iter-070**: 26 file-counted (11 `BasicOpenCech.lean` + 6 `Differentials.lean` + 5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean`)
- **Sorry count after iter-070**: 26 file-counted (unchanged)
- **Net change**: 0 sorries closed. No `.lean` files modified with net effect.
- **Clean diagnostics**: All project `.lean` files compile with 0 errors via LSP.

---

## Prover attempt analysis (from `attempts_raw.jsonl`)

The pre-processed attempt log contains **1006 events** (28 edits, 28 goal checks, 27 diagnostic checks, 55 lemma searches, 0 builds). The edits span three files: `BasicOpenCech.lean`, `Differentials.lean`, and `lakefile.toml`. No sorry was closed.

### Target 1 — `h_π_split` (BasicOpenCech.lean, L787)

**Status**: Blocked (remains `sorry`). This is the same blocker identified in session 69.

The prover made **8 distinct code-change attempts** on the `h_π_split` proof body, all failing with the same root cause: inability to syntactically identify `π.f i` with the `Pi.lift` form needed for `splitEpi_pi_lift_of_injective`.

#### Attempt 1 — `simp π` + direct `rw [Category.id_comp]` (raw log ~04:33)

- **Strategy**: Simplify `π.f i` to expose the `Pi.lift` form, then apply `splitEpi_pi_lift_of_injective`.
- **Code tried**:
  ```lean
  have h_π_split (i : ℕ) : SplitEpi (π.f i) := by
    -- Attempt: simp π.f i to expose the `Pi.lift` form, then apply the helper.
    simp [π]
    rw [show g_simp = FormalCoproduct.cechFunctor.map g_FC by rfl]
    simp [FormalCoproduct.cechFunctor_map_app, FormalCoproduct.powerMap_f, FormalCoproduct.powerMap_φ]
    dsimp [g_FC]
    congr
    funext i_1
    erw [Limits.Pi.map_id, CategoryTheory.op_id, CategoryTheory.Functor.map_id, CategoryTheory.Category.comp_id]
  ```
- **Lean error**: `Tactic 'rewrite' failed: Did not find an occurrence of the pattern 𝟙 ?m ≫ ?f` (line ~803). The `𝟙 X ≫ _` factor was not syntactically present after `simp`.
- **Insight**: `alternatingCofaceMapComplex.map` does not expose a usable `map_f` simp lemma; the composition `𝟙 X ≫ (...).f i` does not appear in the goal after simplification.

#### Attempt 2 — `convert splitEpi_pi_lift_of_injective ... using 2` (raw log ~04:51)

- **Strategy**: Use `convert ... using 2` to match the goal with the helper while leaving two subgoals.
- **Code tried**:
  ```lean
  convert splitEpi_pi_lift_of_injective _ (fun j' => g_FC.f ∘ j') (h_inj' i) using 2
  · -- After convert, the goal is π.f i = Pi.lift (...).
    simp only [π, NatTrans.hcomp_app, Functor.whiskerLeft_app, NatTrans.id_app, HomologicalComplex.Hom.comm]
    rw [show g_simp = FormalCoproduct.cechFunctor.map g_FC by rfl]
    simp [FormalCoproduct.cechFunctor_map_app, FormalCoproduct.powerMap_f, FormalCoproduct.powerMap_φ]
  ```
- **Lean error**: Same `rw [Category.id_comp]` failure. Also `g_simp` not found in target after `simp`.
- **Insight**: The `convert` approach generates the right shape but the equality subgoal cannot be closed because the simp-set for `FormalCoproduct.cechFunctor` and `alternatingCofaceMapComplex` lacks component-level lemmas.

#### Attempt 3 — `erw [Category.id_comp]` + comment-only change (raw log ~05:08–05:22)

- **Strategy**: Switch `rw` to `erw` and adjust comments.
- **Code tried**: Replacing `rw [Category.id_comp]` with `erw [Category.id_comp]`; later replacing with `simp [π]` before the `rw [show g_simp = ...]`.
- **Lean error**: `simp made no progress` (line 803); `Tactic 'rewrite' failed: Did not find an occurrence of the pattern g_simp`.
- **Insight**: The expression `π.f i` is too deeply wrapped in functor applications for `simp` to reduce it to the desired `Pi.lift` form without dedicated `map_f` lemmas.

**Conclusion on `h_π_split`**: The missing ingredient remains a dedicated simp/rewrite lemma for `alternatingCofaceMapComplex.map_f` or `FormalCoproduct.cechFunctor.map_app` that exposes the `Pi.lift` form directly. The prover's lemma searches (`AlternatingCofaceMapComplex.map_f`, `FormalCoproduct.cechFunctor_map_app`, `cechComplexFunctor`) confirmed no such lemma exists in the current Mathlib version.

---

### Target 2 — `cotangentExactSeqBeta` (Differentials.lean, L218)

**Status**: Already solved in iter-069 (session 69). The prover attempts in this session were **redundant**.

#### Attempt 1 — Skeleton with `by sorry` (raw log ~04:54)

- **Code**: Replaced `:= sorry` with `:= by sorry` (scaffolding step, no progress).

#### Attempt 2 — Full adjunction-based construction (raw log ~06:57)

- **Strategy**: Re-implemented the same adjunction factorization + derivation lift + universal property pattern that closed this target in iter-069.
- **Code**: Identical structure to the iter-069 solution (`φ1'`, `φ2'`, `adj_f`, `adj_fg`, `η`, `hη`, `d2`, `d1`, `presheafHom`).
- **Result**: The code compiled (no diagnostics errors recorded for Differentials.lean in the attempt log), but since the target was already solved, this represents **zero net change**.

**Conclusion on `cotangentExactSeqBeta`**: The prover re-derived a known solution. No new insights.

---

### Target 3 — `lakefile.toml` doc-gen4 workaround (environment)

**Status**: Temporary workaround applied and reverted within the same session.

- **04:33–05:33 UTC**: Prover commented out `doc-gen4` and `checkdecls` requirements in `lakefile.toml` to bypass filesystem permission errors.
- **07:34 UTC**: Prover restored both requirements to their original state.
- **Net effect**: No change to `lakefile.toml`.

---

## Blueprint markers updated (manual)

- `Cohomology_MayerVietoris.tex`: added 5 missing `\lean{...}` entries (plan-agent audit, iter-070):
  - `AlgebraicGeometry.Scheme.HModule'_shortComplex_f_mono`
  - `AlgebraicGeometry.Scheme.HModule'_shortComplex_g_epi`
  - `AlgebraicGeometry.Scheme.HModule'_shortComplex_exact`
  - `AlgebraicGeometry.Scheme.splitEpi_pi_lift_of_injective`
  - `AlgebraicGeometry.Scheme.cechCohomology_subsingleton_of_cechCochain_exactAt`

No `\mathlibok` additions this iteration (no new Mathlib re-exports/aliases). No `\lean{...}` corrections needed. No stale `\notready` markers removed (none exist).

---

## Key findings / proof patterns discovered

1. **No new proof patterns discovered this iteration.** The prover phase made no progress. The blueprint rewrite consolidated existing knowledge but did not produce new formal insights.

2. **`h_π_split` blocker remains the highest-priority technical obstacle** for Track 2A (Čech acyclicity). The 8 failed attempts in `attempts_raw.jsonl` all converge on the same gap: missing `alternatingCofaceMapComplex.map_f` / `FormalCoproduct.cechFunctor.map_app` simp lemmas.

3. **Blueprint coverage is now complete.** All 12 chapters have been rewritten to mathematical prose, and the audit confirms every Lean declaration in the active project files has a corresponding `\lean{...}` entry.
