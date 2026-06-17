# Session 35 — Iter-026 Prover Round (Path-2 Mayer-Vietoris LES *finalization*: 3 declarations)

## Metadata

- **Archon iteration**: 026 (canonical, per dispatcher invocation header).
- **Session number**: 35 (prover-round counter).
- **Stage**: prover (single-lane, on `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`).
- **PROGRESS.md stage label at session start**: `iteration 026 — Path-2 Mayer-Vietoris LES *finalization*: three short one-liners ...`. The plan-agent realigned the narrative label from `iteration 023` to `iteration 026`, closing the two-step desync surfaced in sessions 33/34.
- **Sorry count before this session**: 9 (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean`).
- **Sorry count after this session**: 9 (unchanged at the project level — the 3 new declarations were closed in the same Edit that introduced them; transient `9 → 12 → 9` was condensed).
- **Targets attempted**: 3 (the LES exactness theorem `HModule'_sequence_exact` + two `δ`-zero `simp` companions `HModule'_δ_toBiprod` and `HModule'_fromBiprod_δ`, all in `Cohomology/StructureSheafModuleK.lean`).
- **Targets solved this session**: 3 (all three, single-Edit).
- **Edits made by the prover**: **1** (per `attempts_raw.jsonl` summary: `edits: 1, files_edited: ["Cohomology/StructureSheafModuleK.lean"]`).
- **First-edit closure rate**: 100% (1/1 — single Edit landed all 3 declarations with closure bodies in place).
- **New `axiom` declarations**: 0.
- **Files edited**: 1 (`Cohomology/StructureSheafModuleK.lean`).
- **Pre-processed events** (`attempts_raw.jsonl`): 12 events — 3 Reads of the target file, 1 Edit (the single-Edit closure adding ~39 lines / 3 declarations), 1 `lean_diagnostic_messages` call (clean — `error_count: 0, warning_count: 0`), 3 `lean_verify` calls (each returning kernel-only axioms `[propext, Classical.choice, Quot.sound]` plus the harmless L397 docstring "local instance" heuristic match), 1 sorry-analyzer call (`9 total across 3 file(s)`), 1 `wc -l` Bash call, 1 ToolSearch, 1 Write of the prover's task-result file.

## Targets

The session covered three tightly-coupled declarations that mirror Mathlib `MayerVietoris.lean` L140–149 line-by-line for the `ModuleCat k` flavor — the LES exactness theorem (L140–141 mirror) and the two `δ`-zero `simp` companions (L143–149 mirror).

### Target 1 — `AlgebraicGeometry.Scheme.HModule'_sequence_exact` (lemma)

**File**: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`, lines 742–751.
**Status**: SOLVED (single-Edit closure with probe-confirmed body).
**Significance**: Mayer-Vietoris LES exactness theorem. Asserts that the iter-022 sequence `HModule'_sequence` is exact (in the `ComposableArrows.Exact` sense). Mirror of Mathlib `MayerVietoris.lean` L140–141.

#### Attempt 1 (single-Edit closure)

- **Strategy**: append `lemma HModule'_sequence_exact ... := <term-mode body>` directly with the probe-confirmed body. No `:= by sorry` placeholder; no separate refactor sub-phase. This is the nineteenth consecutive single-Edit closure.
- **Code tried**:
  ```lean
  /-- Iter-026: Mayer-Vietoris LES exactness theorem (mirror Mathlib
  `MayerVietoris.lean` L140–141). The iter-022 sequence is exact via the iter-023
  comparison iso to `Ext.contravariantSequence`. -/
  lemma HModule'_sequence_exact
      (k : Type u) [Field k]
      {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
      [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
      [HasExt (Sheaf J (ModuleCat.{u} k))]
      (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
      (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
      (HModule'_sequence k S F n₀ n₁ h).Exact :=
    ComposableArrows.exact_of_iso (HModule'_sequenceIso k S F n₀ n₁ h).symm
      (Abelian.Ext.contravariantSequence_exact _ _ _ _ _)
  ```
- **Lean error**: none.
- **Goal before**: `(HModule'_sequence k S F n₀ n₁ h).Exact`.
- **Goal after**: closed (no goals).
- **Result**: success.
- **Insight**: One-line term-mode body. `ComposableArrows.exact_of_iso` is the canonical Mathlib idiom for transporting exactness across an iso of `ComposableArrows` objects; it consumes the iter-023 comparison iso `HModule'_sequenceIso` (used `.symm`) and Mathlib's `Abelian.Ext.contravariantSequence_exact`. Both `ComposableArrows.exact_of_iso` and `Abelian.Ext.contravariantSequence_exact` need explicit qualification because the file does not `open ComposableArrows` / `open Abelian`. The five `_` placeholders for `contravariantSequence_exact` resolve via unification.

### Target 2 — `AlgebraicGeometry.Scheme.HModule'_δ_toBiprod` (lemma, `@[reassoc (attr := simp)]`)

**File**: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`, lines 753–763.
**Status**: SOLVED (single-Edit closure with probe-confirmed body).
**Significance**: `δ ≫ toBiprod = 0` `simp` companion. Mirror of Mathlib L143–145.

#### Attempt 1 (single-Edit closure)

- **Strategy**: term-mode one-liner via `(...).zero 2`.
- **Code tried**:
  ```lean
  /-- Iter-026: `δ ≫ toBiprod = 0` simp companion (mirror Mathlib L143–145). -/
  @[reassoc (attr := simp)]
  lemma HModule'_δ_toBiprod
      (k : Type u) [Field k]
      {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
      [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
      [HasExt (Sheaf J (ModuleCat.{u} k))]
      (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
      (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
      HModule'_δ k S F n₀ n₁ h ≫ HModule'_toBiprod k S F n₁ = 0 :=
    (HModule'_sequence_exact k S F n₀ n₁ h).zero 2
  ```
- **Lean error**: none.
- **Result**: success.
- **Insight**: Direct one-line consequence of Target 1: `(seq.Exact).zero i` asserts that the composition of the `i`-th and `(i+1)`-th arrows in `seq` is zero. Position `2` in the `ComposableArrows.mk₅`-built `HModule'_sequence` is the `δ`-arrow, so `(...).zero 2` gives `δ ≫ toBiprod n₁ = 0`. The `@[reassoc (attr := simp)]` attribute auto-generates the `_assoc` variant and registers both as `simp` lemmas.

### Target 3 — `AlgebraicGeometry.Scheme.HModule'_fromBiprod_δ` (lemma, `@[reassoc (attr := simp)]`)

**File**: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`, lines 765–775.
**Status**: SOLVED (single-Edit closure with probe-confirmed body).
**Significance**: `fromBiprod ≫ δ = 0` `simp` companion. Mirror of Mathlib L147–149.

#### Attempt 1 (single-Edit closure)

- **Strategy**: term-mode one-liner via `(...).zero 1`.
- **Code tried**:
  ```lean
  /-- Iter-026: `fromBiprod ≫ δ = 0` simp companion (mirror Mathlib L147–149). -/
  @[reassoc (attr := simp)]
  lemma HModule'_fromBiprod_δ
      (k : Type u) [Field k]
      {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
      [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
      [HasExt (Sheaf J (ModuleCat.{u} k))]
      (S : J.MayerVietorisSquare) (F : Sheaf J (ModuleCat.{u} k))
      (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
      HModule'_fromBiprod k S F n₀ ≫ HModule'_δ k S F n₀ n₁ h = 0 :=
    (HModule'_sequence_exact k S F n₀ n₁ h).zero 1
  ```
- **Lean error**: none.
- **Result**: success.
- **Insight**: Same idiom as Target 2 with the position index `1` (the `fromBiprod n₀ → δ` pair).

## Verification (this session)

1. **Diagnostics**: `lean_diagnostic_messages /home/archon/Lean_tests/AlgebraicJacobian/AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` returns `{success: true, items: [], failed_dependencies: []}` (no errors, no warnings). Re-confirmed by review agent (this session).
2. **Axioms**: `lean_verify` on each of the three new declarations returns `{axioms: [propext, Classical.choice, Quot.sound], warnings: [(line: 397, pattern: "local instance")]}` — kernel-only. The L397 warning is the same harmless source-scan heuristic match on the iter-019 `ModuleCat_free_isLeftAdjoint` instance docstring text "project-local instance"; persists from iter-019 through iter-025. Re-confirmed by review agent (this session).
3. **Sorry analyzer**: `9 total across 3 file(s)` — distribution `5 Jacobian.lean + 3 AbelJacobi.lean + 1 Picard/Functor.lean`. `Cohomology/StructureSheafModuleK.lean` does not appear in the list. Sorry trajectory `9 → 9` (the planned `9 → 12 → 9` was condensed by the single-Edit closure).
4. **`Genus.lean` unchanged**: iter-011 first-protected closure intact (sorry-analyzer reports `Genus.lean` not in the active-sorry list; cold-LSP `lean_diagnostic_messages` returned `success: false` with empty `items` and `failed_dependencies`, the documented benign cold-start pattern from session 33).
5. **`archon-protected.yaml` unchanged**: `git diff archon-protected.yaml` empty.
6. **No new axioms**: file uses only kernel axioms.
7. **File LOC**: `Cohomology/StructureSheafModuleK.lean` grew from 774 → 812 LOC (+38 LOC for the 3 new declarations including docstrings). **412 LOC over the ~400 LOC threshold** — the iter-027 `Cohomology/MayerVietoris.lean` file split is now seventh-time-of-asking URGENT.

## Key findings / proof patterns

- **Nineteenth consecutive single-Edit closure** (iter-006 through iter-022 plus iter-023 [session 34] plus iter-026 [this session]; iter-024 was a verify-only zero-Edit round). The two-phase refactor + prover dispatcher plan continues to be structurally over-engineered for narrow, probe-confirmed objectives in unprotected territory; the prover collapses it into a single Edit. **Maximally strongly recurring pattern**.
- **`ComposableArrows.exact_of_iso` is the canonical Mathlib idiom** for transporting `ComposableArrows.Exact` across an iso (added iter-026). Takes the iso `(target ≅ known-exact source)` and an `Exact` proof of the source, returns `Exact` on the target.
- **`(seq.Exact).zero i` is the canonical Mathlib idiom** for extracting the `i`-th composition-is-zero relation from a `ComposableArrows.Exact` proof (added iter-026). Position `i` ranges from `0` to `n-1` in a `ComposableArrows _ n`.
- **Direct value-category-agnostic transfer of Mathlib's MV-LES exactness wrap-up**: the entire L140–149 block of `MayerVietoris.lean` transfers verbatim under the substitution `S.sequence_exact F → HModule'_sequence_exact k S F`, `S.δ_toBiprod F → HModule'_δ_toBiprod k S F`, `S.fromBiprod_δ F → HModule'_fromBiprod_δ k S F`. **Mathlib gap surfaced this session: none.**
- **Iteration-counter desync corrected**: PROGRESS.md narrative label now matches dispatcher counter at `iteration 026`. Sessions 33–34 had drifted to `iteration 023` (two-step lag); this session realigned cleanly. Recommend the iter-027 plan-agent maintain the alignment by reading `meta.json` directly.
- **File-split urgency escalates (seventh-time-of-asking)**: `Cohomology/StructureSheafModuleK.lean` is now 812 LOC (~412 LOC over the ~400 LOC threshold). Iter-027 must run the `Cohomology/MayerVietoris.lean` split as its **first action** before any further declarations are added. The natural semantic boundary (iter-016 → iter-026 LES infrastructure cohort) is now complete and self-contained.

## Recommendations for next session

See `recommendations.md` for the full plan-agent-facing recommendations for iter-027.

## Blueprint markers updated

Three lemma blocks each gained a `\leanok` on both the statement and the proof in `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`:

- `Cohomology_StructureSheafModuleK.tex`, `lem:Scheme_HModule_prime_sequence_exact` (statement, after `\uses{...}` at L1027): added `\leanok` to statement.
- `Cohomology_StructureSheafModuleK.tex`, `lem:Scheme_HModule_prime_sequence_exact` proof block (after `\uses{...}` at L1036): added `\leanok` to proof.
- `Cohomology_StructureSheafModuleK.tex`, `lem:Scheme_HModule_prime_delta_toBiprod` (statement, after `\uses{...}` at L1043): added `\leanok` to statement.
- `Cohomology_StructureSheafModuleK.tex`, `lem:Scheme_HModule_prime_delta_toBiprod` proof block (after `\uses{...}` at L1052): added `\leanok` to proof.
- `Cohomology_StructureSheafModuleK.tex`, `lem:Scheme_HModule_prime_fromBiprod_delta` (statement, after `\uses{...}` at L1059): added `\leanok` to statement.
- `Cohomology_StructureSheafModuleK.tex`, `lem:Scheme_HModule_prime_fromBiprod_delta` proof block (after `\uses{...}` at L1068): added `\leanok` to proof.

All three Lean declarations were verified to exist at the names given by the `\lean{...}` macros, the file compiles clean, and `lean_verify` confirms kernel-only axioms `[propext, Classical.choice, Quot.sound]` (the L397 warning is unrelated heuristic noise from the iter-019 `ModuleCat_free_isLeftAdjoint` docstring).

No `\lean{...}` rename was needed; no `\notready` markers were present; the existing remark "Mayer-Vietoris LES build-out: status after iter-026" was retained intact.

## Process drift note (resolved this session)

The dispatcher iteration counter is now in sync with the PROGRESS.md narrative label (both at `026`). The iter-026 plan-agent first pass explicitly addressed the two-step desync flagged in sessions 33/34 ("Iteration counter desync correction" subsection). Drift counter status: **0** (in sync).
