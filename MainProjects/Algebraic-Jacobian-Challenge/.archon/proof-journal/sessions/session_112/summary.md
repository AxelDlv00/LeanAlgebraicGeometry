# Session 112 — Review of iter-112

## Metadata

- **Session number**: 112 (= Archon iter-112)
- **Date**: 2026-05-15
- **Stage**: prover (single Phase B lane on `AlgebraicJacobian/Differentials.lean` L122 `relativeDifferentialsPresheaf_isSheaf`)
- **Sorry count before iter**: project total **16** (BasicOpenCech 6 / LineBundle 2 / Modules-Monoidal 1 / Picard.Functor 1 / Differentials 5 / Jacobian 1)
- **Sorry count after iter**: project total **16** (same per-file distribution; `Differentials.lean` still at 5 — L122's sorry was *moved* into new helper `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` at L159; the main theorem L220 is now fully closed)
- **Net change**: **0** (no closure; structural advance — Bar B per the iter-112 success bar in `PROGRESS.md`)
- **Compilation status**: ✅ `lake env lean AlgebraicJacobian/Differentials.lean` returns only the 5 expected `declaration uses sorry` warnings; `lean_diagnostic_messages` severity=error returns `[]` end-to-end.
- **Targets attempted**: 1 (`relativeDifferentialsPresheaf_isSheaf` at L122)
- **Status verdict**: **PARTIAL (Bar B achieved)** — Route (a) chosen explicitly, ≥2 named helpers instantiated, surrounding scaffolding visibly enacts the chapter Step 1 / Step 2+3 recipe; helper #1 body remains `sorry`. Bar A (file sorry count 5 → 4) not met.

## Iteration outcome at a glance

**Bar B (acceptable) per `PROGRESS.md` § Concrete iter-112 success bar.** The L122 sorry in `relativeDifferentialsPresheaf_isSheaf` is replaced by a structured scaffolding that enacts the blueprint Route (a) recipe:

- **Main theorem** `relativeDifferentialsPresheaf_isSheaf` (L220, fully closed) performs **Step 1** (forgetful reduction Ab ⥤ Type) via `Presheaf.isSheaf_iff_isSheaf_comp _ _ (CategoryTheory.forget AddCommGrpCat)` and delegates **Step 2 + Step 3** to the helper `relativeDifferentialsPresheaf_isSheaf_type`.
- **Helper #2** `relativeDifferentialsPresheaf_isSheaf_type` (L188, fully closed) derives the sheaf-of-types condition from helper #1 via the equivalence `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover`.
- **Helper #1** `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (L159, body `sorry`) packages Step 2 (affine identification of `D(g) ↦ Ω_{B[1/g]/A}` with `AlgebraicGeometry.tilde Ω_{B/A}`) and Step 3 (cofinality refinement against the affine basis) into a single load-bearing claim. The body is `intro ι U; sorry` with the full Step 2 / Step 3 recipe documented in inline comments.

The structural advance is the **exposure of helper #1 as the single residual mathematical content**: closing it (Step 2 affine identification + Step 3 cofinality refinement, ~100–200 LOC by the iter-113+ recipe in the prover task result) advances Bar B → Bar A (file sorry count 5 → 4).

## Target #1: `relativeDifferentialsPresheaf_isSheaf` (L122 / now L220) — PARTIAL (Bar B)

**File**: `AlgebraicJacobian/Differentials.lean`. **Goal at L122 entry**:
```
X S : Scheme
f : X ⟶ S
⊢ Presheaf.IsSheaf (Opens.grothendieckTopology ↑X.toTopCat)
    (PresheafOfModules.presheaf (relativeDifferentialsPresheaf f))
```

### Strategy
Route (a) per `blueprint/src/chapters/Differentials.tex` §28–§54 + `PROGRESS.md` recipe: Step 1 (forgetful reduction Ab ⥤ Type), Step 2 (affine identification via `tilde Ω_{B/A}`), Step 3 (globalisation via `isSheaf_iff_isSheafOpensLeCover`). Decompose into named sub-helpers exposing Step 2 + Step 3 as a single load-bearing claim.

### Attempt 1 — Step 1 forgetful-reduction probe (`rw` with TopCat namespace + bare `forget`)
- **Code tried**:
  ```lean
  rw [TopCat.Presheaf.isSheaf_iff_isSheaf_comp (forget AddCommGrpCat) _]; sorry
  ```
- **Lean error / diagnostic**: rewrite engaged but with the wrong namespace path; `forget AddCommGrpCat` parsed as `AlgebraicGeometry.Scheme.forget` due to `open AlgebraicGeometry` at the file top.
- **Insight**: when `Opens.grothendieckTopology X.toTopCat` is the goal's Grothendieck topology, the relevant rewrite is `CategoryTheory.Presheaf.isSheaf_iff_isSheaf_comp` (bare `Presheaf` namespace), NOT the `TopCat.Presheaf.isSheaf_iff_isSheaf_comp` variant. The latter rewrites the alias `TopCat.Presheaf.IsSheaf` rather than the raw `Presheaf.IsSheaf`; these are defeq but the syntactic rw match fails.

### Attempt 2 — Step 1 with `CategoryTheory.forget`
- **Code tried**:
  ```lean
  rw [TopCat.Presheaf.isSheaf_iff_isSheaf_comp (CategoryTheory.forget AddCommGrpCat) _]; sorry
  ```
- **Lean error**: same wrong-namespace issue (the alias-rewrite path).
- **Insight**: confirmed that the `TopCat.Presheaf.isSheaf_iff_isSheaf_comp` variant is not the right entry point. Need the bare `CategoryTheory.Presheaf.isSheaf_iff_isSheaf_comp` version.

### Attempt 3 — Step 1 with bare `Presheaf` namespace — SUCCESS for Step 1
- **Code tried**:
  ```lean
  rw [Presheaf.isSheaf_iff_isSheaf_comp _ _ (CategoryTheory.forget AddCommGrpCat)]; sorry
  ```
- **Result**: rewrite succeeds; goal becomes
  `Presheaf.IsSheaf (Opens.grothendieckTopology X.toTopCat) ((relativeDifferentialsPresheaf f).presheaf ⋙ forget AddCommGrpCat)`.
- **Insight**: this is the right Step 1 reduction. The `_ _` placeholders give the two category-level metavariables; the explicit argument is the forgetful functor.

### Attempt 4 — packaging Step 3 inline via `isSheafOpensLeCover` — multi-rw probe
- **Code tried**:
  ```lean
  rw [Presheaf.isSheaf_iff_isSheaf_comp _ _ (CategoryTheory.forget AddCommGrpCat),
      TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover]; sorry
  ```
- **Lean error**: the second rw failed to find a pattern (the post-Step-1 goal uses `Presheaf.IsSheaf` not `TopCat.Presheaf.IsSheaf`); the `isSheaf_iff_isSheafOpensLeCover` lemma is TopCat-namespaced and can't fire after the previous bare-namespace rewrite.
- **Insight**: Step 2 + Step 3 cannot be performed inline by a second rewrite — they need to be packaged via a helper that explicitly states the goal at the OpensLeCover level.

### Attempt 5 — inline `(mpr by intro ι U; sorry)` packaging
- **Code tried**:
  ```lean
  rw [Presheaf.isSheaf_iff_isSheaf_comp _ _ (CategoryTheory.forget AddCommGrpCat)]
  exact (TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover _).mpr (by intro ι U; sorry)
  ```
- **Lean error**: unsolved goals after the `exact` (the `exact` argument doesn't match the post-rw goal shape; same namespace gymnastic).
- **Insight**: inline packaging is not the right approach — the `isSheafOpensLeCover` characterisation needs to be applied to a separately-named lemma whose signature already exposes `TopCat.Presheaf.IsSheafOpensLeCover` as the conclusion.

### Refactoring into helpers v1 (rejected) — two identical-signature helpers
- **Approach**: introduced two top-level lemmas, both with signature `... .IsSheafOpensLeCover`, one delegating to the other.
- **Why rejected**: indistinguishable mathematically; pure boilerplate. Sorry count: 1 (= 5 total file).

### Refactoring into helpers v2 (rejected — regression)
- **Approach**: introduced helper `_isLimit_on_affine` (taking an affine `V` + containment) and helper `_isLimit_opensLeCover` (global), each with its own `sorry` body.
- **Lean error (first probe)**: `Invalid field IsSheafOpensLeCover: The environment does not contain CategoryTheory.Functor.IsSheafOpensLeCover, so it is not possible to project the field IsSheafOpensLeCover from an expression ...`.
- **Insight**: the field-projection access `((...).presheaf ⋙ forget AddCommGrpCat).IsSheafOpensLeCover` is wrong: `IsSheafOpensLeCover` is a standalone declaration under `TopCat.Presheaf`, not a `Functor` field. Fix: use the explicit `TopCat.Presheaf.IsSheafOpensLeCover (...)` form in the signature.
- **Why rejected (after fix)**: sorry count would be 2 in this file (= 6 total project), a regression. Rejected.

### Refactoring into helpers v3 (committed) — load-bearing #1 + derived #2
- **Final shape**:
  - **Helper #1** `relativeDifferentialsPresheaf_isSheafOpensLeCover_type (f : X ⟶ S) : TopCat.Presheaf.IsSheafOpensLeCover ((relativeDifferentialsPresheaf f).presheaf ⋙ CategoryTheory.forget AddCommGrpCat) := by intro ι U; sorry` (L159, body `sorry`).
  - **Helper #2** `relativeDifferentialsPresheaf_isSheaf_type (f : X ⟶ S) : Presheaf.IsSheaf (Opens.grothendieckTopology X.toTopCat) ((relativeDifferentialsPresheaf f).presheaf ⋙ CategoryTheory.forget AddCommGrpCat) := (TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover _).mpr (relativeDifferentialsPresheaf_isSheafOpensLeCover_type f)` (L188, fully closed).
  - **Main theorem** body (L220-L227):
    ```lean
    rw [Presheaf.isSheaf_iff_isSheaf_comp _ _ (CategoryTheory.forget AddCommGrpCat)]
    exact relativeDifferentialsPresheaf_isSheaf_type f
    ```
- **Compile-check**: `lean_diagnostic_messages` returns `[]` (errors); only the expected warning `declaration uses sorry` at L159.
- **Sorry trajectory**: file 5 → 5 (L122 sorry moved into L159 helper #1; main theorem body is now closed).
- **Insight (reusable)**: when a `rw` Step-1 reduction is followed by a different-namespace characterisation, **package the post-Step-1 statement as a separate lemma whose signature exposes the new namespace** (here `TopCat.Presheaf.IsSheafOpensLeCover ...`), then derive the original goal-shape via the namespace-bridging characterisation. The bridging lemma (`TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover` here) fires cleanly in the helper-2 body because the LHS shape is the helper-2 statement, not the post-rw goal.

## Key findings / proof patterns discovered

### Reusable patterns
- **`Presheaf.isSheaf_iff_isSheaf_comp _ _ (CategoryTheory.forget AddCommGrpCat)` is the right Step-1 reduction over `Opens.grothendieckTopology`**: not the `TopCat.Presheaf.isSheaf_iff_isSheaf_comp` variant. The TopCat-namespaced version rewrites the alias `TopCat.Presheaf.IsSheaf` rather than the raw `Presheaf.IsSheaf`; these are defeq but syntactic rw matching fails. The `_ _` placeholders fill the two category-level metavariables. — *Documented at* `AlgebraicJacobian/Differentials.lean:225`.
- **`forget AddCommGrpCat` (without `CategoryTheory.` prefix) is parsed as `AlgebraicGeometry.Scheme.forget`** under the file's `open AlgebraicGeometry` (and `namespace AlgebraicGeometry.Scheme`). Always use the fully-qualified `CategoryTheory.forget AddCommGrpCat`. — *Documented at* `AlgebraicJacobian/Differentials.lean:225`.
- **`TopCat.Presheaf.IsSheafOpensLeCover (...)` is a standalone declaration, not a field projection** on `Functor` or on `Presheaf`. Field-access syntax `(X.presheaf ⋙ forget _).IsSheafOpensLeCover` fails with "The environment does not contain `CategoryTheory.Functor.IsSheafOpensLeCover`". Always use the explicit qualified form in lemma signatures. — *Documented at* `AlgebraicJacobian/Differentials.lean:160`.
- **Bar-B scaffolding pattern**: when a single-sorry "main theorem" needs to enact a multi-step recipe but the load-bearing content is one consolidated sub-claim, expose **one** sorry-bodied helper packaging the load-bearing content + **one** fully-closed derived helper packaging the namespace bridge + **fully-closed main body** delegating to the derived helper. Keeps sorry count flat; surfaces the residual mathematical content cleanly. — *Documented at* `AlgebraicJacobian/Differentials.lean:98–227`.

### Verified Mathlib names (the iter-112 plan-agent's re-verification list, all confirmed during this prover session)
- `CategoryTheory.Presheaf.isSheaf_iff_isSheaf_comp` ✓ (used at L225 of Differentials.lean)
- `TopCat.Presheaf.isSheaf_iff_isSheaf_comp` ✓ (rejected — wrong namespace path for this goal)
- `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover` ✓ (used at L192 of Differentials.lean)
- `TopCat.Presheaf.IsSheafOpensLeCover` ✓ (used in helper #1 signature at L160 of Differentials.lean)
- `AlgebraicGeometry.tilde` ✓ (verified in `Mathlib.AlgebraicGeometry.Modules.Tilde`; **namespace correction** for the blueprint chapter which writes `AlgebraicGeometry.Modules.tilde` — confirmed iter-112 by the prover that the chapter's writing is wrong)
- `KaehlerDifferential.isLocalizedModule_map` ✓ (instance form; load-bearing for iter-113+ closure of helper #1)
- `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` ✓ (load-bearing for iter-113+ Step 2)
- `AlgebraicGeometry.Scheme.isBasis_affineOpens` ✓ (load-bearing for iter-113+ Step 3)

## Blueprint markers updated (manual)

- `blueprint/src/chapters/Differentials.tex`, `thm:smooth_iff_locally_free_omega` (L183): added `% NOTE:` flagging that the Lean signature uses dimension-free `Smooth f` plus a free `n : ℕ`, while the blueprint prose pins "smooth of relative dimension n"; future prover must pivot to `AlgebraicGeometry.IsSmoothOfRelativeDimension n f`.
- `blueprint/src/chapters/Differentials.tex`, `cor:cotangent_at_section` (L203): added `% NOTE:` mirroring the same signature-mismatch flag.
- `blueprint/src/chapters/Differentials.tex`, `thm:serre_duality_genus` (L223): added `% NOTE:` flagging the H^0-vs-H^1 mismatch — Lean writes both sides as `HModule k _ 0` but blueprint asserts `dim H^0(Ω_{C/k}) = dim H^1(O_C)`; current Lean equation is mathematically false for genus > 1.

`\leanok` markers were not touched (deterministic `sync_leanok` phase responsibility). No `\mathlibok` markers were added this iter. No `\notready` removals.

## Notes (low-severity)

- `lean-auditor-iter112` re-flagged 3 carry-over majors (Differentials.lean L27–30 header rot, BasicOpenCech.lean L1715/L1752 cross-iter excuse-comments) and 1 new minor (Differentials.lean L213–215 inline "Project-level sorry total: 5" claim contradicts L146's "file-level" phrasing). All carry-over; no new must-fix. Report: `.archon/task_results/lean-auditor-iter112.md`.
- `lean-vs-blueprint-checker-differentials-iter112` confirmed the iter-112 scaffolding is faithful to the chapter Route (a) recipe and flagged 3 pre-existing must-fix signature mismatches in `Differentials.lean` (the 3 `% NOTE:` annotations above respond to those flags). Report: `.archon/task_results/lean-vs-blueprint-checker-differentials-iter112.md`.

## Recommendations summary

See `recommendations.md`. Headline: **iter-113 should dispatch a prover lane on helper #1 `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (L159)** following the iter-113+ recipe sketched in the prover task result (Sub-lemma A — affine identification + Sub-lemma B — cofinality refinement). Bar A advance (file sorry 5 → 4) is the success metric. The 3 signature-mismatch must-fix items flagged by the lean-vs-blueprint-checker are pre-existing and downstream of L122 — they should be addressed by a refactor lane (not a prover) since they involve signature changes, not proof bodies.
