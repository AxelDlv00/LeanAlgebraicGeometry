# Session 93 — iter-093 review

## Metadata

- **Archon iteration**: 093
- **Stage**: prover (single substantive prover lane — `Cohomology/BasicOpenCech.lean`).
- **Session id** (prover): `89cc32b6-c253-4645-9cb9-933f2cf645b7`, model
  `claude-opus-4-7`, 78 turns, ~$9.62 USD, 1465 s wall.
- **Sorry count before iter-093** (per session_92 / PROJECT_STATUS):
  **14** total / **6** in `BasicOpenCech.lean` (L570, L662, L986,
  L1014, L1204, L1233) — compile-verified.
- **Sorry count after iter-093**: **14** total — direct grep + LSP-
  diagnostics verified:
  - `BasicOpenCech.lean`: **6** at **L578, L670, L994, L1022, L1212,
    L1241** (line numbers shifted +8 to +10 due to the iter-093 14-line
    `--` comment expansion at L556–L569 + `have key₁` block at
    L570–L577). Same sorry SITES as iter-092, just at higher line
    numbers. **Hard cap 6 respected.**
  - `Differentials.lean`: **5** at L122, L636, L957, L974, L1116
    (unchanged, off-limits).
  - `Modules/Monoidal.lean`: **1** at L173 (unchanged, off-limits).
  - `Jacobian.lean`: **1** at L179 (unchanged, off-limits).
  - `Picard/Functor.lean`: **1** at L190 (unchanged, off-limits).
- **Net sorry change**: **0**. Hard cap respected. Substantive
  progress in `cechCofaceMap_pi_smul` body but the trailing `sorry`
  did not move past step (b→c) bridge.
- **Compilation status iter-093**: **VERIFIED** —
  `lean_diagnostic_messages` with `severity=error` returns `[]` on
  whole file (last invocation at 08:15:19Z); only pre-existing linter
  advisories remain. Second consecutive compile-verified iteration
  (iter-092 + iter-093 streak).
- **Env state**: `attempts_raw.jsonl` is again **stale** (timestamps
  06:07–06:27 from iter-091 prover artefact; iter-093 prover startedAt
  is 07:51:22Z). The actual iter-093 prover log at
  `.archon/logs/iter-093/provers-combined.jsonl` reports **78 turns /
  3 source `Edit`s + 1 `Write` (task_result) / 14 `lean_multi_attempt`
  / 6 `lean_diagnostic_messages` / 3 `lean_goal` / 3 `lean_local_search`
  / 8 `lean_loogle` / 1 `lean_hover_info` / 12 Read / 11 Bash / 10
  Grep / 4 TodoWrite / 1 ToolSearch**. LSP/lake worked throughout
  this iteration (iter-092 fix held). The
  `attempts_raw.jsonl`-staleness was also noted in session_92 — this
  is a recurring pre-processor harness issue, not new.
- **`lean_verify`**: not run this iteration.

## Per-target detail

### Target 1 — `cechCofaceMap_pi_smul` (BasicOpenCech.lean L568 → L578)

**Status**: PARTIAL. Substantive progress committed; full step (b)
chain NOT closed.

**Iter-093 entry goal** (per PROGRESS.md, post-iter-092 step (a)):
the equality
```
(ConcreteCategory.hom (Pi.π Z₂ j))
  ((ModuleCat.Hom.hom (eqToHom ⋯) ∘ₗ
    ModuleCat.Hom.hom (∑ i, (-1)^↑i • Pi.lift fun i_1 ↦ ...))
   ((piIsoPi Z₁).toLinearEquiv.symm (r • y))) =
r • (... similar with e₁.symm y)
```
Sum is wrapped inside `∘ₗ` (LinearMap composition with an `eqToHom`-
derived prefix). Step (b) is distributing `.hom` over the categorical
`∑`.

**Iter-093 commit** (lines 556–578):
- 14-line `--` doc comment (L556–L569) summarising the iter-093 sub-
  blocker and iter-094 routes.
- `have key₁ : ∀ F z, ((∑ i, F i) : ∏ᶜ Z₁ ⟶ ∏ᶜ Z₂).hom z = ∑ i, (F i).hom z`
  (L570–L577): the **per-application form** of `ModuleCat.hom_sum`.
  Proof body:
  ```lean
  intro F z
  rw [ModuleCat.hom_sum F Finset.univ]
  exact LinearMap.sum_apply Finset.univ (fun i => (F i).hom) z
  ```
  Builds cleanly with empty diagnostics.
- Trailing `sorry` at L578.

**What `key₁` accomplishes**: it stores the post-(b)+post-(c) goal
shape in a single body-local helper. Unifies what would be two
separate rewrites (`.hom`-distribution and `map_sum`-distribution)
into one statement. Once `∘ₗ`-unfolding works, `rw [key₁]` will fire
in one step.

**Eight attempts traced in `provers-combined.jsonl`**:

1. **Route (A) — `simp_rw [hom_sum_dist]` / `simp_rw [ModuleCat.hom_sum]`**
   (`lean_multi_attempt` at L570).
   - Result: `simp made no progress`.
   - Insight: `simp_rw`'s elaboration-time unification does not help.
     The HOU obstruction is at a lower level than simp's rewrite tier.
   - Verdict: **Route (A) eliminated as a viable iter-094 starting
     point** (carry into "do not retry" list).

2. **Route (B) — explicit AddMonoidHom + `map_sum`** (`lean_multi_attempt`
   probe with `homAH : (M ⟶ N) →+ (M →ₗ[k] N)`).
   - Result: `homAH` build typechecks. The `map_zero' :=
     ModuleCat.hom_zero` / `map_add' := ModuleCat.hom_add` fields are
     correct. Probe NOT committed because attempt 3's `have key₁`
     route is cleaner.
   - Insight: Route (B) is viable as a fallback if Route (D) fails in
     iter-094.

3. **Route (B′) / Specialised hom_sum — `have key₁ : ∀ F, (∑F).hom = ∑ (F i).hom`**
   followed by `rw [key₁]`.
   - Result: `have key₁` proves cleanly via `exact ModuleCat.hom_sum F
     Finset.univ`. `rw [key₁]` then FAILS with `Did not find an
     occurrence of the pattern `ModuleCat.Hom.hom (∑ i, ?F i)``.
   - Insight: Specialising the index type doesn't help. The HOU is
     about the SURROUNDING `∘ₗ`-context, not the sum-bind.

4. **Route (B′′) / Per-application form — `have key₁ : ∀ F z, (∑F).hom z = ∑ (F i).hom z`**.
   - Result: SUCCESS — `key₁` builds, `lean_diagnostic_messages`
     returns `[]` on lines 555–575.
   - Insight: This is the iter-093 substantive commit. The "next
     blocker" lives in unfolding `∘ₗ`-application BEFORE `rw [key₁]`
     can match.

5. **Step (b→c) bridge — `simp only [LinearMap.comp_apply]`** to expose
   `(∑F).hom z`.
   - Result: `simp made no progress`. Also tried `simp only
     [LinearMap.coe_comp, Function.comp_apply]`, `rw
     [LinearMap.comp_apply]`, `rw [show (?g ∘ₗ ?h) ?x = g (h x) from
     fun _ _ _ => rfl]`. All fail with either "no progress" or
     "pattern not found `(?g ∘ₗ ?h) ?x`".
   - Diagnosis: `set_option pp.notation false in show True` reveals
     the goal contains `((ModuleCat.Hom.hom (eqToHom ⋯)).comp
     (ModuleCat.Hom.hom (Finset.univ.sum fun i ↦ ...)))`. The `.comp`
     IS `LinearMap.comp`. But the `eqToHom`'s source ModuleCat is
     metavariable-driven (from `dif_pos hRel` at L535) and is NOT
     syntactically `∏ᶜ Z₂` — it's some def-equal unfolding (likely
     `ModuleCat.of k ((i : Fin (n+1) → ↥s₀) → ↑(Z₂ i))`). The
     discrimination-tree LHS pattern `(?f ∘ₗ ?g) ?x` cannot bind
     `?g`'s codomain.
   - **Key finding (NEW)**: the HOU obstruction has shifted DOWN one
     layer — from step (b) sum-distribution to step (b→c) `∘ₗ`-
     unfolding. The downstream root cause is the `dif_pos hRel`-
     introduced `eqToHom`.

6. **`show` / `change` with explicit eqToHom source**.
   - Result: `Application type mismatch: argument has type ?m ⟶ ?m'
     but is expected to have type ModuleCat.Hom ?m'' (∏ᶜ Z₂)`.
   - Insight: The eqToHom term cannot be reconstructed from local
     `Z₁, Z₂` data alone — its source ModuleCat lives in a
     metavariable context fed by `dif_pos hRel`.

7. **Route (F) — categorical `Preadditive.sum_comp`** (NOT REACHED).
   - Would require restructuring proof BEFORE the iter-088 dsimp at
     L526–L535, since dsimp unfolded the categorical structure into
     LinearMap form. Out of scope for iter-093.
   - `Preadditive.sum_comp` / `Preadditive.comp_sum` verified to
     exist at `Mathlib/CategoryTheory/Preadditive/Basic.lean` L180–186.

8. **Commit `have key₁` + trailing `sorry` at L578** and verify file
   compiles via `lean_diagnostic_messages`.
   - Result: SUCCESS. Final diagnostic call at 08:15:19Z returns `[]`
     for severity=error on whole file.

**Net iter-093 result**: 6 sorries unchanged; substantive progress is
the body-local `have key₁` helper that pre-stores the post-(b)+(c)
goal shape and pins the active blocker to `∘ₗ`-unfolding (rather than
the iter-092 step-(b) `.hom`-distribution).

### Target 2–9 — off-limits (per PROGRESS.md)

`BasicOpenCech.lean` L670/L994/L1022 (augmented Čech infrastructure),
L1212 (`g_R.map_smul'`, gated on `cechCofaceMap_pi_smul`), L1241
(`h_loc_exact`, gated on `IsLocalizedModule.Away`); `Differentials.lean`
L636 (`cotangentExactSeq_structure case h_exact`); `Modules/Monoidal.lean`
L173 (Mathlib gap); `Jacobian.lean` L179 (Phase C/E); `Picard/Functor.lean`
L190 (Phase C gating). All deferred per PROGRESS.md.

## Key findings / proof patterns discovered

### Pattern 1 — Per-application form of categorical sum-distribution

The `have key₁ : ∀ F z, ((∑ i, F i) : ...).hom z = ∑ i, (F i).hom z`
pattern combines `ModuleCat.hom_sum` + `LinearMap.sum_apply` into a
single body-local statement keyed on BOTH the family `F` and the
input `z`. This avoids HOU on the discrimination tree because:

- The LHS `((∑ F).hom z)` has both arguments syntactically present.
- `rw [key₁]` will fire when the goal contains the LHS shape directly,
  WITHOUT requiring sum-distribution to occur first.

Proof body:
```lean
intro F z
rw [ModuleCat.hom_sum F Finset.univ]
exact LinearMap.sum_apply Finset.univ (fun i => (F i).hom) z
```

**Reusability**: any project-local proof that needs to distribute
`.hom` over a `Finset.sum` in `ModuleCat k` context can adopt this
pattern. The two-argument keying is the cure for HOU obstructions
where the sum is wrapped in further LinearMap composition.

### Pattern 2 — Diagnose `LinearMap.comp` HOU via `set_option pp.notation false in show True`

When `simp only [LinearMap.comp_apply]` reports "no progress" but the
goal visually contains `(?f ∘ₗ ?g) ?x`, force the elaborator to print
the un-notated term via `set_option pp.notation false in show True`.
This reveals:
- whether `.comp` is `LinearMap.comp` (rfl-lemma applies) or some
  other composition;
- whether the implicit source/target ModuleCats reduce syntactically
  to the named ones from local context;
- whether an `eqToHom` is hiding a metavariable-driven cast.

The diagnosis is what isolated the iter-093 sub-blocker
(`dif_pos hRel`-introduced eqToHom with non-syntactic source).

### Pattern 3 — Mathlib `Preadditive.sum_comp` / `Preadditive.comp_sum`

When ModuleCat `∘ₗ`-unfolding fails because of eqToHom-source HOU,
the categorical-level alternative is `(∑ F) ≫ Pi.π Z₂ j = ∑ (F i ≫
Pi.π Z₂ j)` via `Preadditive.sum_comp` (Mathlib
`CategoryTheory/Preadditive/Basic.lean` L185). Verified to exist this
iteration. Requires the proof to operate at categorical level BEFORE
the iter-088 dsimp at L526–L535 unfolds to LinearMap form. Reserved
for iter-094 Route (F).

## Recommendations for next session

See `recommendations.md` (companion file).

## Blueprint markers updated (manual)

None this iteration. `cechCofaceMap_pi_smul` is a project-local helper
without a `\lean{...}` entry in `Cohomology_MayerVietoris.tex`; no
blueprint surface changed. The iter-092 prover already retracted the
"ModuleCat.hom_sum absent from Mathlib" misclaim in `PROJECT_STATUS.md`
and `PROGRESS.md` — no further marker work needed.

The deterministic `sync_leanok` phase runs between the prover and
this review; any `\leanok` adds/removes it produced are recorded in
the inner-git commit `archon[093/marker-sync]` and not listed here.
