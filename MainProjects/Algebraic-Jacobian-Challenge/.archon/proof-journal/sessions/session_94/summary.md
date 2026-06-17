# Session 94 — iter-094 review

## Metadata

- **Archon iteration**: 094
- **Stage**: prover (single substantive prover lane — `Cohomology/BasicOpenCech.lean`).
- **Prover session** (from `.archon/logs/iter-094/provers-combined.jsonl`):
  session_id `24354eb2-05b2-4e64-a292-fb34d3793452`, model `opus`
  (`claude-opus-4-7`), 75 turns, ~$12.91 USD, 1813 s wall.
- **Sorry count before iter-094** (per session_93 / PROJECT_STATUS):
  **14** total / **6** in `BasicOpenCech.lean` (L578, L670, L994,
  L1022, L1212, L1241) — compile-verified.
- **Sorry count after iter-094**: **14** total — direct grep confirmed:
  - `BasicOpenCech.lean`: **6** at **L589, L681, L1005, L1033, L1212
    (now L1223), L1241 (now L1252)** (offsets +1 to +11 due to the
    iter-094 `key₂` block insertion at L580–L588 plus `rw [← ModuleCat.hom_comp]`
    line at L570). Same sorry SITES as iter-093. **Hard cap 6 respected.**
  - `Differentials.lean`: **5** at L122, L636, L957, L974, L1116 (unchanged).
  - `Modules/Monoidal.lean`: **1** at L173 (unchanged).
  - `Jacobian.lean`: **1** at L179 (unchanged).
  - `Picard/Functor.lean`: **1** at L190 (unchanged).
- **Net sorry change**: **0**. Hard cap respected. Substantive structural
  progress on the iter-093 `∘ₗ`-unfolding blocker via a `← ModuleCat.hom_comp`
  fusion move (committed L570), plus a fully-proved body-local helper
  `key₂` (L580–L588). Trailing `sorry` at L589.
- **Compilation status iter-094**: **VERIFIED** —
  `lean_diagnostic_messages` with `severity=error` on the file returns
  `[]` at iter-094 close (per prover task result). Third consecutive
  compile-verified iteration (iter-092 + iter-093 + iter-094).
- **Env state**: `attempts_raw.jsonl` is **stale for the third
  consecutive iteration** — timestamps 06:07–06:27Z carry iter-091
  artefacts (3 edits, 2 diagnostics, 0 multi-attempts; references to
  `iter-091` in `old_text`/`new_text`). Actual iter-094 prover started
  at 08:44:15Z and ran until 09:14:29Z. Counts taken from
  `.archon/logs/iter-094/provers-combined.jsonl`:
  **75 turns / 3 `Edit`s + 1 `Write` (task_result) / 26
  `lean_multi_attempt` / 4 `lean_diagnostic_messages` / 2 `lean_goal`
  / 2 `lean_local_search` / 10 `lean_run_code` / 11 Read / 9 Bash /
  5 TodoWrite / 2 ToolSearch**. LSP/lake working throughout (iter-092
  fix holds). The pre-processor staleness is a recurring harness issue
  (sessions 92, 93, 94).
- **`lean_verify`**: not run this iteration.

## Per-target detail

### Target 1 — `cechCofaceMap_pi_smul` (BasicOpenCech.lean L578 → L589)

**Status**: PARTIAL. Substantive progress committed; full step (b→c)
chain NOT closed.

**Iter-094 entry goal** (post-iter-093 `have key₁`):
```
(ConcreteCategory.hom (Pi.π Z₂ j))
  ((ModuleCat.Hom.hom (eqToHom ⋯) ∘ₗ
    ModuleCat.Hom.hom (∑ i, (-1)^↑i • Pi.lift fun i_1 ↦ ...))
   ((piIsoPi Z₁).toLinearEquiv.symm (r • y))) =
r • (... similar with e₁.symm y)
```
The sum is wrapped inside `LinearMap.comp` (`∘ₗ`) prefixed by an
`eqToHom` whose source ModuleCat is metavariable-driven from
`dif_pos hRel` at L535. Iter-093 documented three recovery routes
(D) / (E) / (F).

**Iter-094 commits** (lines 565–588):
- `rw [← ModuleCat.hom_comp]` at L570 (the iter-094 **breakthrough
  tactic line** — none of (D)/(E)/(F) directly; it implements a
  **new Route (D-variant)** that fuses `eqToHom_hom ∘ₗ (∑F).hom`
  into a categorical composition `((∑F) ≫ eqToHom).hom` via the
  reverse direction of Mathlib's `ModuleCat.hom_comp`).
- `have key₂` block at L580–L588 (8 lines, fully proved with no
  trailing `sorry`):
  ```lean
  have key₂ :
      ∀ (G : Fin (n + 1) → ((∏ᶜ Z₁ : ModuleCat k) ⟶ (∏ᶜ Z₂ : ModuleCat k)))
        (E : (∏ᶜ Z₂ : ModuleCat k) ⟶
              ModuleCat.of k ((i : Fin (n + 1) → ↑s₀) → ↑(Z₂ i)))
        (z : ↑(∏ᶜ Z₁ : ModuleCat k)),
        ((∑ i, G i) ≫ E).hom z = ∑ i, (G i ≫ E).hom z := by
    intro G E z
    rw [Preadditive.sum_comp]
    rw [ModuleCat.hom_sum (fun i => G i ≫ E) Finset.univ]
    exact LinearMap.sum_apply Finset.univ (fun i => (G i ≫ E).hom) z
  ```
- Trailing `sorry` at L589.

**What the iter-094 commits accomplish**:

- **Step (b')** — `rw [← ModuleCat.hom_comp]` re-folds the
  LinearMap-level composition back to the categorical level. After
  the rewrite, the goal contains `((∑F) ≫ eqToHom).hom z` (no `∘ₗ`).
  This **sidesteps the iter-093 `LinearMap.comp_apply`-on-eqToHom
  HOU blocker entirely** because both sides of `≫` are now ModuleCat
  homs whose categorical types are stable.
- **Step (c) infrastructure** — `key₂` is the per-application
  distributor for `(∑G) ≫ E` over a Finset.sum. Proof chain:
  `Preadditive.sum_comp → ModuleCat.hom_sum → LinearMap.sum_apply`.
  Proves cleanly because `G`, `E`, `z` are FREE variables (no HOU
  on the proof side).

**Active blocker (NEW iter-094)**: applying `key₂` via `rw [key₂]`
or `simp_rw [key₂]` fails with
> pattern `(ModuleCat.Hom.hom ((∑ i, ?G i) ≫ ?E)) ?z` not found

Root cause (per prover diagnosis): the summand body
`(-1)^↑i • Pi.lift fun i_1 ↦ ... ((SimplexCategory.δ i) ...) ...`
**references the outer summation binder `i` at nested binding
depths**, and there is **binder shadowing** (`Pi.π (fun i ↦ ...)`
rebinds the same letter `i`). Lean's HOU pattern matcher cannot
determine the `?G` placeholder shape: it needs to abstract a closure
keyed on `i` while the body reads `i` from multiple binder scopes.
`simp only [Preadditive.sum_comp]`, `simp_rw [Preadditive.sum_comp]`,
`simp only [key₂]`, `simp_rw [key₂]` all return "no progress" against
the same HOU pre-filter rejection.

**Twenty-six `lean_multi_attempt` traces in `provers-combined.jsonl`** —
condensed into seven attempt clusters below.

#### Attempt 1 — iter-093 carryover: `simp only [LinearMap.comp_apply]` / variants
- **Approach**: standard rfl-unfold of `(f ∘ₗ g) x` to expose `(∑F).hom z`.
- **Probes**: `simp only [LinearMap.comp_apply]`, `simp_rw
  [LinearMap.comp_apply]`, `rw [LinearMap.comp_apply,
  LinearMap.comp_apply]`, `change _ = _; simp only [LinearMap.comp_apply]`,
  `dsimp only [LinearMap.comp_apply]`, `simp only [LinearMap.coe_comp,
  Function.comp_apply]`, `rw [show ∀ {α β γ} ... (f : β →ₗ[k] γ)
  (g : α →ₗ[k] β) (x : α), (f ∘ₗ g) x = f (g x) from fun ... => rfl]`.
- **Result**: ALL FAILED — "no progress" / "pattern `(?f ∘ₛₗ ?g) ?x`
  not found".
- **Diagnosis**: iter-093 confirmed. The eqToHom's source ModuleCat
  is metavariable-driven (def-equal-not-syntactic-equal to `∏ᶜ Z₂`);
  the discrimination-tree LHS pattern cannot bind. Carried forward
  the iter-093 dead-ends with two additional new variants
  (`dsimp only`, `rw [show ... from rfl]`) that also fail.

#### Attempt 2 (BREAKTHROUGH) — `rw [← ModuleCat.hom_comp]`
- **Approach**: instead of unfolding `∘ₗ`-application, **fuse**
  `eqToHom_hom ∘ₗ (∑F).hom` into `((∑F) ≫ eqToHom).hom` via the
  reverse direction of Mathlib's `ModuleCat.hom_comp`.
- **Multiple `lean_multi_attempt` probes** to test the rewrite at
  various positions; final variant:
  ```lean
  rw [← ModuleCat.hom_comp]
  ```
- **Result**: SUCCESS. Goal now contains `((∑F) ≫ eqToHom).hom z`
  (no `∘ₗ`). `lean_diagnostic_messages` empty (severity=error).
- **Key insight**: The reverse-direction rewrite **trades a LinearMap-
  level eqToHom blocker for a categorical-level sum**. Categorical
  types are stable (no metavariable-driven source); only the
  Preadditive sum-distribution remains.

#### Attempt 3 — `rw [Preadditive.sum_comp]` (forward distribution)
- **Approach**: distribute `(∑F) ≫ E = ∑ i, F i ≫ E` directly via
  the categorical lemma.
- **Result**: FAILED — HOU pattern `(∑ j ∈ ?s, ?f j) ≫ ?g` not unified.
- **Diagnosis**: summand has nested `i` references + variable shadowing.
  Same HOU obstruction as `key₂` rewrite below.

#### Attempt 4 — body-local `key₂` + `rw [key₂]`
- **Approach**: prove the distribution body-locally with FREE `G`, `E`,
  `z` (HOU-friendly), then apply via `rw`.
- **Multi-attempt probe** (committed shape):
  ```lean
  have key₂ : ∀ (G : Fin (n + 1) → ((∏ᶜ Z₁ : ModuleCat k) ⟶ (∏ᶜ Z₂ : ModuleCat k)))
      (E : ...) (z : ...),
      ((∑ i, G i) ≫ E).hom z = ∑ i, (G i ≫ E).hom z := by
    intro G E z
    rw [Preadditive.sum_comp]
    rw [ModuleCat.hom_sum (fun i => G i ≫ E) Finset.univ]
    exact LinearMap.sum_apply Finset.univ (fun i => (G i ≫ E).hom) z
  ```
- **Result**: `have key₂` PROVES (committed at L580–L588, file compiles).
  `rw [key₂]` application against the goal FAILS with same HOU
  pattern not found.
- **Lesson**: **The HOU issue lives at pattern-matching, not at proof
  construction.** Body-local proofs with free variables don't help
  if the subsequent `rw` still has to do HOU unification against an
  `i`-shadowed/multiply-referencing summand.

#### Attempt 5 — `key₃` bundling outer `(Pi.π Z₂ jj).hom`
- **Approach**: bundle the outer `(Pi.π Z₂ jj).hom (...)` with the
  Preadditive distribution into a single combined helper:
  ```lean
  have key₃ : ∀ (G E jj z),
      (Pi.π Z₂ jj).hom (((∑ i, G i) ≫ E).hom z) =
        ∑ i, (Pi.π Z₂ jj).hom ((G i ≫ E).hom z) := by
    intro G E jj z
    rw [Preadditive.sum_comp]
    ...
  ```
- **Result**: FAILED — `(Pi.π Z₂ jj).hom` doesn't accept
  `(G i ≫ E).hom z`-typed input directly because the codomain is the
  Pi-product (def-equal but not syntactically equal to `∏ᶜ Z₂`).
  Same eqToHom obstruction at the meta-level.

#### Attempt 6 — `simp` ensemble `[Preadditive.sum_comp, ModuleCat.hom_sum, LinearMap.sum_apply, map_sum, Finset.smul_sum]`
- **Result**: "no progress" — HOU pre-filter rejects the first lemma;
  cascade doesn't fire.

#### Attempt 7 — `set F :=` with explicit summand
- **Approach**: name the summand `F i := (-1)^↑i • Pi.lift ...` so
  the `rw` can match against `F` instead of the literal closure.
- **Result**: FAILED — type elaboration failure on `(-1)^↑i`
  (heterogeneous power inference) + Pi.π type mismatch.

#### Final commit — `rw [← ModuleCat.hom_comp]` + `have key₂` block
- **Commit**: file replaces L568 `sorry`-tail with the breakthrough
  tactic line (L570) and the `key₂` block (L580–L588), trailing
  `sorry` at L589. File compiles; 6 sorries unchanged.

**Net iter-094 result**: 6 sorries unchanged; substantive progress is
(i) the `rw [← ModuleCat.hom_comp]` breakthrough that **resolves the
iter-093 `∘ₗ`-unfolding blocker**, and (ii) the body-local `key₂`
distributor (proved cleanly), which **pins the next blocker to a new
HOU site** — the inability to `rw [key₂]` against an `i`-shadowed /
multiply-referencing summand body.

### Target 2–9 — off-limits (per PROGRESS.md)

`BasicOpenCech.lean` L681/L1005/L1033 (augmented Čech infrastructure),
L1223 (`g_R.map_smul'`, gated on `cechCofaceMap_pi_smul`), L1252
(`h_loc_exact`, gated on `IsLocalizedModule.Away`); `Differentials.lean`
L636 (`cotangentExactSeq_structure case h_exact`); `Modules/Monoidal.lean`
L173 (Mathlib gap); `Jacobian.lean` L179 (Phase C/E); `Picard/Functor.lean`
L190 (Phase C gating). All deferred per PROGRESS.md.

## Key findings / proof patterns discovered

### Pattern 1 — Reverse-direction `← ModuleCat.hom_comp` to escape LinearMap-level eqToHom

When a goal contains an `eqToHom_hom ∘ₗ f.hom` shape (LinearMap
composition with an `eqToHom` prefix) and `LinearMap.comp_apply`
fails because the `eqToHom`'s source ModuleCat is metavariable-driven
(def-equal but not syntactically the named target), use
`rw [← ModuleCat.hom_comp]` to re-fold the `∘ₗ` into a **categorical
composition** `(f ≫ eqToHom).hom`. The categorical types are stable
under unification because both `f` and `eqToHom` are ModuleCat homs
whose source/target ModuleCats are explicit in the term — there is
no LinearMap-level eqToHom-source HOU.

This pattern **resolves the iter-093 `∘ₗ`-unfolding blocker** in one
line. Reusable in any proof where `LinearMap.comp_apply` reports
"pattern `(?f ∘ₛₗ ?g) ?x` not found" on a `(eqToHom_hom ∘ₗ X).hom z`
goal.

### Pattern 2 — Body-local FREE-variable distributor for categorical Preadditive sums

When you need to distribute `((∑ i, G i) ≫ E).hom z` over a Finset.sum
and the literal `rw [Preadditive.sum_comp]` fails HOU because the
summand `G i` has nested binder shadowing on `i`, build a body-local
helper:
```lean
have key : ∀ G E z, ((∑ i, G i) ≫ E).hom z = ∑ i, (G i ≫ E).hom z := by
  intro G E z
  rw [Preadditive.sum_comp]
  rw [ModuleCat.hom_sum (fun i => G i ≫ E) Finset.univ]
  exact LinearMap.sum_apply Finset.univ (fun i => (G i ≫ E).hom) z
```
The **proof** succeeds because `G`, `E`, `z` are free variables (no
HOU). The **rewrite** `rw [key]` may still fail HOU at the call site
if the summand body has the binder-shadowing problem — but the helper
captures the canonical distribution shape and can be applied via
`convert` or by manual `Finset.cons_induction` as a fallback.

### Pattern 3 — Pinpoint HOU blocker location via attempt-trace

The iter-094 attempt log isolates the HOU blocker to **two structural
features of the summand body**: (1) the outer `i`-binder is referenced
at nested binding depths via `Pi.lift fun i_1 ↦ ... ((SimplexCategory.δ i) i_1)`,
and (2) `Pi.π (fun i ↦ ...)` rebinds the same letter `i`. The HOU
matcher cannot abstract the `?G` placeholder across this pattern. This
**localises** the obstruction precisely enough that the iter-095 plan
can target either (a) `Finset.cons_induction` to bypass HOU entirely,
or (b) renaming the inner binder to escape shadowing.

## Recommendations for next session

See `recommendations.md` (companion file).

## Blueprint markers updated (manual)

None this iteration. `cechCofaceMap_pi_smul` is a project-local helper
without a `\lean{...}` entry in `Cohomology_MayerVietoris.tex`; no
blueprint surface changed. No `\mathlibok` candidates surfaced
(`ModuleCat.hom_comp` is Mathlib but only used internally via `rw`,
not as a Mathlib-backed re-export). No `\notready` removals warranted
(no chapter blocks landed). No `\lean{...}` macro renames flagged in
the prover task result.

The deterministic `sync_leanok` phase runs between the prover and this
review; any `\leanok` adds/removes it produced are recorded in the
inner-git commit `archon[094/marker-sync]` and not listed here.
