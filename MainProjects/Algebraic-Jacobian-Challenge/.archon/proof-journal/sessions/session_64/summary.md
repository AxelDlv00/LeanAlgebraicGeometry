# Session 64 — iter-064 review

## Metadata

- **Archon iteration**: 064
- **Stage**: prover (re-dispatch missed Phase B scaffold + continue substep component (i))
- **Plan-agent work this iteration (pre-prover)**:
  - Re-dispatched the missed iter-063 Phase B objective (`Differentials.lean` scaffold) alongside the primary Track 2A.3b.i objective (Čech refinement transport `s → s₀`).
  - Both objectives dispatched in parallel; `meta.json.provers` shows two entries (BasicOpenCech + Differentials), correcting the iter-063 process gap.
- **Sorry count before iter-064 prover round**: 11 (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean` + 2 `BasicOpenCech.lean`).
- **Sorry count after iter-064 prover round**: 20 (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean` + 4 `BasicOpenCech.lean` + 7 `Differentials.lean`).
- **Net change**: +9 sorries (+2 from BasicOpenCech decomposition, +7 from new Differentials scaffold). All new sorries are transient/scaffold.
- **Clean diagnostics**: Both files compile with 0 errors. BasicOpenCech has 1 expected `declaration uses 'sorry'` warning. Differentials has 7 expected `declaration uses 'sorry'` warnings.

## Target 1 — `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (BasicOpenCech.lean)

**Status**: Partial (scaffolding advanced, 4 transient sorries inside the theorem body).

The original single substep (b)+(c) sorry at L633 was decomposed into three focused transient sorries plus structured scaffolding, turning a monolithic obligation into three independent attack surfaces.

### Attempt 1 — Main decomposition Edit (raw log event 264)

- **Strategy**: Replace the iter-063 `sorry` at L633 with a structured proof block containing:
  1. `obtain ⟨s₀, h_sub, h_top⟩ := hs_fin` — unpack the finite subspanning set.
  2. `let K := cechCochain ... (basicOpenCover s)` and `let K₀ := cechCochain ... (basicOpenCover ↑s₀)` — readable names for the two cochain complexes.
  3. `have h_transport : Function.Exact (K.sc n).f (K.sc n).g ↔ Function.Exact (K₀.sc n).f (K₀.sc n).g := by sorry` — component (i), Čech refinement transport.
  4. `have h_K₀_exact : Function.Exact (K₀.sc n).f (K₀.sc n).g := by ... sorry` — component (ii), exactness of the finite-cover complex via `exact_of_isLocalized_span`.
  5. `exact h_transport.mpr h_K₀_exact` — close the original goal.

- **Code applied** (L636–723, ~87 lines of new scaffolding + comments):
  ```lean
  obtain ⟨s₀, h_sub, h_top⟩ := hs_fin
  let K := cechCochain C (toModuleKSheaf C) (basicOpenCover s)
  let K₀ := cechCochain C (toModuleKSheaf C)
    (basicOpenCover (C := C) (U := U) (↑s₀ : Set Γ(C.left, U)))
  have h_transport : Function.Exact ... ↔ Function.Exact ... := by sorry
  have h_K₀_exact : Function.Exact ... := by
    have h_a₀ : ∀ (f : ↑s₀), ... ExactAt n := by intro f; sorry
    have h_a₀_fun : ∀ (f : ↑s₀), Function.Exact ... := by ...
    sorry  -- substep (b2)+(c) for s₀
  exact h_transport.mpr h_K₀_exact
  ```

- **Goal before Edit** (raw log event 157 — `lean_goal` at L633):
  `⊢ Function.Exact ⇑(ConcreteCategory.hom (HomologicalComplex.sc K n).f) ⇑(ConcreteCategory.hom (HomologicalComplex.sc K n).g)` with `hs_fin : ∃ s', ↑s' ⊆ s ∧ Ideal.span ↑s' = ⊤` already in scope.

- **Diagnostic check after Edit** (raw log event 268): `{errors: [], warnings: ["declaration uses `sorry` at line 402"], error_count: 0, warning_count: 1}` — clean, but one line exceeded 100 characters.

### Attempt 2 — Line-break formatting Edit (raw log event 274)

- **Strategy**: Split the overlong `let K₀ := ...` line into two lines to fix the linter warning.
- **Code applied**: Broke `let K₀ := cechCochain C (toModuleKSheaf C) (basicOpenCover (C := C) (U := U) (↑s₀ : Set Γ(C.left, U)))` across two lines.
- **Diagnostic check after Edit** (raw log event 278): `{errors: [], warnings: ["declaration uses `sorry` at line 402"], error_count: 0, warning_count: 1}` — fully clean.

### Attempts tried but NOT committed

- The prover used `lean_multi_attempt` and `lean_run_code` probes internally during the session (8 `lean_multi_attempt` probes and several `lean_run_code` shape verifications in the BasicOpenCech lane, per the summary stats). None of these resulted in committed Edits — the prover settled on the decomposition strategy directly.

### Key insight

The decomposition follows the iter-063 3-component trajectory exactly:
- Component (i): `h_transport` — Čech refinement transport `s → s₀`.
- Component (ii): `h_K₀_exact` — finite product-localisation commutation + `exact_of_isLocalized_span` on `s₀`.
- The original substep (a) at L444 remains, plus a new `h_a₀` (substep a for `s₀`) inside `h_K₀_exact`.

The closure pattern `exact h_transport.mpr h_K₀_exact` means the original goal is now reduced to proving exactness of the finite-cover complex `K₀`; transport back to `K` is handled by the bidirectional equivalence.

## Target 2 — `Differentials.lean` Phase B scaffold

**Status**: Partial (new file created, 2 defs with real definitions, 6 theorems with sorry bodies).

### Attempt 1 — Initial Write (raw log event 666)

- **Strategy**: Create `AlgebraicJacobian/Differentials.lean` with all 8 declarations and `sorry` bodies, using `X.ringCatSheaf.val.obj` for ring-section access.
- **Compilation result** (raw log event 673): FAILED — type mismatch errors:
  - `relativeDifferentialsPresheaf_isSheaf`: `relativeDifferentialsPresheaf f` has type `X.PresheafOfModules` but expected `Presheaf.IsSheaf ...`.
  - `universalDerivation`: `X.ringCatSheaf` has type `TopCat.Sheaf RingCat ...` but `.val` gives a presheaf, not matching expected types.
  - `smooth_iff_locally_free_omega`: `Module` instance synthesis failed.

### Attempt 2 — Second Write (raw log event 699)

- **Strategy**: Rewrite with corrected types: use `.val.presheaf` instead of `.val.obj` for sheaf-level access, add explicit `letI` instances, and refine the `relativeDifferentials` definition.
- **Compilation result** (raw log event 703): FAILED — `Function expected at X.ringCatSheaf.obj` (still using `.obj` directly on a sheaf).

### Attempt 3 — Third Write (raw log event 717)

- **Strategy**: Use `X.ringCatSheaf.presheaf.obj` throughout, simplify `relativeDifferentialsPresheaf` definition, adjust `cotangent_exact_sequence` and `smooth_iff_locally_free_omega` types.
- **Compilation result** (raw log event 721): FAILED — `Function expected at X.ringCatSheaf.obj` persisted in some places; also `S.ringCatSheaf.obj` errors.

### Attempt 4 — Fourth Write + Edits (raw log events 736, 761, 765, 799)

- **Strategy**: Final correction pass:
  1. `universalDerivation`: changed `X.ringCatSheaf.val ⋙ ...` to `X.ringCatSheaf.presheaf ⋙ ...` (Edit 761).
  2. `smooth_iff_locally_free_omega`: changed `X.ringCatSheaf.val.obj` to `X.ringCatSheaf.presheaf.obj` (Edit 765).
  3. `serre_duality_genus`: split long line (Edit 799).
- **Compilation result** (raw log event 803): `lake build AlgebraicJacobian.Differentials` — **success** (8320 jobs, 6 `sorry` warnings only).
- **Full project build** (raw log event 816): `lake build AlgebraicJacobian` — **success**.

### Declarations scaffolded

| Line | Declaration | Type | Status |
|------|-------------|------|--------|
| 59 | `relativeDifferentialsPresheaf` | `X.PresheafOfModules` | **Solved** (noncomputable def, real definition) |
| 67 | `relativeDifferentialsPresheaf_isSheaf` | `Presheaf.IsSheaf ...` | **Partial** (sorry) |
| 76 | `relativeDifferentials` | `X.Modules` | **Solved** (noncomputable def, real definition) |
| 86 | `universalDerivation` | morphism of abelian presheaves | **Partial** (sorry) |
| 102 | `cotangent_exact_sequence` | `∃ α β, ShortComplex.Exact ... ∧ Epi β` | **Partial** (sorry) |
| 118 | `smooth_iff_locally_free_omega` | `Smooth f ↔ ... Module.Free ...` | **Partial** (sorry) |
| 134 | `cotangent_at_section` | similar for pullback along section | **Partial** (sorry) |
| 155 | `serre_duality_genus` | equality of `Module.rank k (HModule ...)` | **Partial** (sorry) |

## Key findings / proof patterns

- **`exact h_transport.mpr h_K₀_exact` closure pattern** *(iter-064, new)*: when the original goal `G` is equivalent to a subgoal `G₀` via a bidirectional `have h_transport : G ↔ G₀`, and `G₀` is attackable independently, close the original goal with `exact h_transport.mpr h_K₀_exact`. This decouples the transport proof from the subgoal proof.
- **Component-based sorry decomposition pattern** *(iter-064, generalises iter-062 → iter-063)*: a monolithic substep sorry is decomposed into N independent transient sorries, each with its own commentary and trajectory. The original goal is reduced to a closure term (`h_transport.mpr h_K₀_exact`) that wires the components together.
- **Data-bearing `have` for substep payloads** *(iter-064, continues iter-061 → iter-063)*: `h_a₀_fun` mirrors `h_a_fun` but for the finite cover `s₀`, providing the per-`f` `Function.Exact` payload needed by `exact_of_isLocalized_span`.
- **Matlib presheaf API navigation** *(iter-064, Differentials lane)*: `X.ringCatSheaf` is a `TopCat.Sheaf RingCat`, not a presheaf functor. Accessing sections requires `X.ringCatSheaf.presheaf.obj (Opposite.op U)` (or `X.presheaf.obj (Opposite.op U)` for `CommRingCat`). The deprecated `.val` accessor was removed in recent Mathlib; `.presheaf` is the current accessor.
- **Sheaf upgrade pattern** *(iter-064, Differentials lane)*: `relativeDifferentials` packages `relativeDifferentialsPresheaf` with `relativeDifferentialsPresheaf_isSheaf` into `X.Modules` via `⟨presheaf, sheafCond⟩`. This matches Mathlib's `SheafOfModules.mk` pattern.
- **Eighteenth zero-corrective Edit-cluster streak** *(iter-047 → iter-064)*: the BasicOpenCech prover delivered exactly two Edits (main body + line-break) with zero corrective passes on the main body. The Differentials prover required 4 Writes + 3 Edits to reach compilation, which is typical for scaffold creation with new Mathlib API surface.

## Process discipline

- **Fourth iteration under the 2026-05-11 user-directive policy**. Plan agent did NOT pre-verify candidate bodies. Both provers used `lean_multi_attempt` / `lean_run_code` internally for shape verification. No substep helpers extracted as standalone objectives.
- **Parallel dispatch corrected**: iter-063's process gap (only 1 of 2 objectives dispatched) was corrected this iteration. Both BasicOpenCech and Differentials provers ran in parallel and completed.
- **Twenty-fifth clear-as-you-go iteration in a row** (iter-040 → iter-064): both files compile with zero errors.

## Blueprint markers updated (manual)

**None.** The `Differentials.tex` chapter contains no `\lean{...}` macros (written in mathematical language per user directive). The deterministic `sync_leanok` script has no declarations to look up in this chapter, so no `\leanok` markers were added or removed automatically either. No `\mathlibok` additions warranted (all new declarations are project-level constructions, not direct Mathlib re-exports). No stale `\notready` markers to strip.

The following label → declaration mappings were established by the Differentials prover and should be used by the plan agent if `\lean{...}` macros are added in a future iteration:
- `def:relative_kaehler_presheaf` → `relativeDifferentialsPresheaf`
- `def:relative_kaehler_sheaf` → `relativeDifferentials`
- `def:universal_derivation` → `universalDerivation`
- `thm:cotangent_exact_sequence` → `cotangent_exact_sequence`
- `thm:smooth_iff_locally_free_omega` → `smooth_iff_locally_free_omega`
- `cor:cotangent_at_section` → `cotangent_at_section`
- `thm:serre_duality_genus` → `serre_duality_genus`

## Final verification

- `lean_diagnostic_messages` on `BasicOpenCech.lean`: 0 errors, 1 expected warning.
- `lean_diagnostic_messages` on `Differentials.lean`: 0 errors, 7 expected warnings (6 declaration-level + 1 `by sorry` inside `ShortComplex.mk`).
- `lake build AlgebraicJacobian`: full project builds (8320+ jobs, success).
- `sorry_analyzer.py` / grep count: 20 total sorries across 5 files (verified).
- No new `axiom` declarations.
- `archon-protected.yaml`: untouched.
