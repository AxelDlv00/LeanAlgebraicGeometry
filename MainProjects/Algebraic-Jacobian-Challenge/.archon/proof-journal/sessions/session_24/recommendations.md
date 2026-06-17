# Recommendations for the next plan-agent iteration (iter-030)

## TL;DR

- **Priority 1 (primary, iter-030 prover lane)**: build the next downstream consumer of the iter-029 cohort. Two clear candidates:
  - **(a) `Scheme.AffineCoverMVSquare.HModule'_apply`** — the `toModuleKSheaf C`-specialisation of the iter-029 sheaf-parameterised LES, producing the 5-term Mayer-Vietoris LES on a concrete `C.AffineCoverMVSquare` for the structure sheaf. One declaration, narrow scope, term-mode one-liner consuming `S.HModule'_sequence_exact k F …` with `F := toModuleKSheaf C`.
  - **(b) Affine-vanishing input** `Scheme.HModule'_vanishing_of_isAffineOpen` (name TBD) — the statement `H'>0(SpecA, F) = 0` for an affine open `U` and a quasi-coherent sheaf `F`. This is the third of the four Serre-finiteness building blocks.
- **Reviewer's recommendation**: pick **(a)** for iter-030 — it is the smaller, more tightly-coupled-to-iter-029 step. The plan agent should re-probe Mathlib's affine-vanishing API at iter-030 plan time; if newly ungated, **(b)** becomes the natural iter-031 follow-on.
- **Track 2 (parallel low-coupling)**: still none recommended. Polish backlog remains empty.
- **Mathlib gating watch**: re-probe the Čech-vs-derived-functor comparison API state. Also probe the affine-vanishing API and the `Module.Finite` API for `Sheaf J (ModuleCat.{u} k)`-valued cohomology.
- Do **not** re-issue `representable`, the 8 remaining protected sorries, direct `LineBundle` refinement, or any of the closed scaffold sites (iter-014 → iter-026 + iter-028 + iter-029). All final, in `task_done.md`.

## Context

Iter-029 (this iteration) was the **second concrete step of the Serre-finiteness chain** (Phase A step 6 *Path 2*). Six declarations landed in a single Edit (with one corrective Edit for sub-namespace shadowing on the LES def + exactness pair):

- Four `@[simp]` corner-identification lemmas (`X₁`, `X₂`, `X₃`, `X₄`): three by `rfl`, one by `S.cover` — first downstream consumer of the `cover` field.
- A sheaf-parameterised abstract-LES specialisation `Scheme.AffineCoverMVSquare.HModule'_sequence` (`noncomputable def`).
- The corresponding LES exactness lemma `Scheme.AffineCoverMVSquare.HModule'_sequence_exact`.

Sorry count `9 → 9 → 9` (no transient via term-mode one-liners). `archon-protected.yaml` untouched. File compiles clean with `{success: true, items: [], failed_dependencies: []}`. New file LOC: `Cohomology/MayerVietoris.lean` 600 → 652 (+52 LOC).

Post-iter-029 state:

- `Cohomology/MayerVietoris.lean`: 652 LOC, 0 sorries, contains the 23 iter-016 → iter-026 LES infrastructure declarations + the 2 iter-028 scaffold declarations + the 6 iter-029 companion declarations.
- `Cohomology/StructureSheafModuleK.lean`: 299 LOC, 0 sorries, unchanged.
- Blueprint `Cohomology_MayerVietoris.tex`: 766 LOC (existing iter-029 § already in place from the iter-029 plan-agent prose pass; review-agent added six statement-level + five proof-level `\leanok` markers post-prover-closure).

Steps of the Serre-finiteness sketch (per blueprint § *Use in Serre finiteness*):

| Step | Description | Status |
|---|---|---|
| 1 | The MV-LES applied to `S.toMayerVietorisSquare` and a generic sheaf `F` gives a 5-term sequence relating H⁰ and H¹. | **Complete (iter-029)** |
| 2 | The `cover` field identifies `X₄` with `⊤` (i.e. all of `C`). | **Complete (iter-029)** |
| 3 | The affineness of `U₁`, `U₂`, `U₁ ∩ U₂` collapses `H^{>0}` (Serre vanishing on affines). | Open — iter-030 or iter-031 |
| 4 | Each `H^0` piece is a `k`-module given by a finite ring computation, hence finite-dimensional. | Open — iter-031 or later |

## Detailed Track 1A — `HModule'_apply` (Priority 1, recommended)

### Why this iteration

Iter-029 left the LES specialisation parameterised over a generic sheaf `F`. The next bridge is to specialise to `toModuleKSheaf C` (the structure sheaf with values in `ModuleCat.{u} k`), which is the actual sheaf the Serre-finiteness theorem on a proper `k`-curve consumes. This is the load-bearing step that converts the iter-029 *abstract reusable* infrastructure into a *concrete* statement about cohomology of `C` itself.

### Suggested probe target

```lean
noncomputable def Scheme.AffineCoverMVSquare.HModule'_apply
    {k : Type u} [Field k] {C : Scheme.{u}} -- or with extra hypotheses
    (S : C.AffineCoverMVSquare)
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    ComposableArrows AddCommGrpCat 5 :=
  S.HModule'_sequence k (toModuleKSheaf C) n₀ n₁ h
```

The plan agent should probe:

1. Whether `toModuleKSheaf C` lives in `Sheaf (Opens.grothendieckTopology C.toTopCat) (ModuleCat.{u} k)` directly (it does, per iter-012 / iter-014 cohort).
2. Whether the `[HasWeakSheafify ...]` and `[HasSheafify ...]` typeclasses are auto-resolvable at this slot, or whether they need to be added explicitly.
3. Whether the `HModule'_apply` name fits Mathlib's `apply`-suffix convention or whether `HModule'` (no suffix) or `HModule'_sequence` (matching the parent) is preferable.

### Naming convention note

`HModule'_apply` is a placeholder — the actual choice depends on the Mathlib analog. Possibilities:

- `HModule'_apply` — applied LES (mirrors `HModule.apply` if such a name exists).
- `HModuleSeq` — short form.
- `cohomology_sequence` — mathematically descriptive.

Plan agent should probe Mathlib for the canonical naming idiom.

### Hard avoid (do not assign for iter-030)

- `representable` (`Picard/Functor.lean` L190): still blocked on `LineBundle` refinement + FGA. Multi-iteration.
- The 8 remaining protected sorries (5 `Jacobian.lean` lines 77/88/97/104/114 + 3 `AbelJacobi.lean` lines 35/41/53): Phase C representability + Phase E geometric content. Multi-iteration.
- Direct `LineBundle` refinement: blocked on Mathlib `MonoidalCategory X.Modules`.
- Any vacuous-functor / vacuous-sheaf closures (forbidden shortcut list in `PROJECT_STATUS.md`).
- Iter-014 → iter-026 closures + iter-028 + iter-029 scaffolds: all final, in `task_done.md`. Do not re-open.
- **Bare in-namespace short names inside `def AffineCoverMVSquare.X` bodies that collide with parent-namespace names.** Use `_root_.AlgebraicGeometry.Scheme.<name>` qualification (added iter-029).

## Detailed Track 1B — affine-vanishing input (alternative)

### Why this might be preferable

If the iter-030 plan-agent probe re-confirms that `HModule'_apply` is a one-liner (which iter-029's pattern strongly suggests), the iteration's "interesting" content is small. A heavier alternative is the affine-vanishing input:

```lean
lemma Scheme.HModule'_vanishing_of_isAffineOpen
    {k : Type u} [Field k] {X : Scheme.{u}}
    (U : X.Opens) (hU : IsAffineOpen U)
    (F : Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k))
    [-- typeclasses TBD]
    (n : ℕ) (hn : 1 ≤ n) :
    HModule' k U F n = 0  -- or IsZero (...) or Subsingleton (...) etc.
  := sorry
```

The challenge: this is a **substantive mathematical claim** (Serre vanishing on affines for quasi-coherent modules), not a routine specialisation. It will require either:

1. Direct Mathlib invocation if the comparison API is ungated (probe at iter-030 time).
2. A multi-step proof via the Čech complex on a single-cover (`U` covers itself).
3. A several-iteration build-out if Mathlib's sheaf-cohomology = derived-functor-cohomology comparison is still gated.

### Sequencing

If iter-030 plan-agent picks `HModule'_apply` (the lighter step), affine vanishing queues for iter-031+ (after a Mathlib API probe). If iter-030 plan-agent picks affine vanishing directly, `HModule'_apply` queues for iter-030 as a likely prerequisite (since affine vanishing is the input that makes the LES meaningful on a curve).

**Reviewer's recommendation**: pick `HModule'_apply` for iter-030. It is the smaller, more clearly-load-bearing step; it threads `toModuleKSheaf C` into the iter-029 framework; and it stages a clean foundation for iter-031's affine-vanishing work.

## Reusable proof patterns from prior sessions (iter-029-specific additions)

The following patterns are added to `PROJECT_STATUS.md` § *Knowledge Base / Proof Patterns* this session:

- **`_root_.X.Y.Z` qualification is required when the new declaration's name collides with a parent-namespace declaration.** Sub-namespace auto-open inside `def X.Y` bodies shadows parent-namespace bare names. Workarounds (`Y.Z`, `X.Y.Z` without `_root_`) double-prefix; only `_root_.X.Y.Z` works.
- **Six-declaration prover rounds in a single Edit (with one corrective Edit for namespace shadowing) when the cohort splits into a tightly-coupled `simp`-companion sublist and an LES specialisation pair**.
- **`@[simp]` lemmas materialising abstract MV-square corner accessors** are useful even when the underlying equalities hold by `rfl`.
- **Sheaf-parameterised LES specialisation** (parameterised over a generic sheaf `F`) is reusable across different sheaf flavours.
- **Probe-confirmed term-mode bodies adopted verbatim continue to land at ~100% reliability** at the semantic content level; ~95% reliability for short-name resolution under deep sub-namespacing.

See `PROJECT_STATUS.md` § *Knowledge Base / Proof Patterns* for the full list of 60+ patterns spanning sessions 1–38.

## Process drift status

- **Refactor + prover sub-phase collapse**: twelfth consecutive substantive occurrence (iter-015 → iter-022, iter-023, iter-026, iter-028, iter-029). For iter-027 the dispatcher correctly skipped the prover phase (refactor-only); for iter-029 it correctly invoked it (substantive scaffold addition).
- **Iteration-counter desync**: still resolved (drift counter 0; in sync). Iter-029 began at the correct iteration counter; `Archon iteration: 029` matches `logs/iter-029/` and the dispatcher commit-message conventions.
- **`attempts_raw.jsonl` freshness**: this iteration refreshed it (16 events, all timestamped `2026-05-08T16:32…16:37`Z). No stale-data carryover.
- **Single-Edit reliability**: eleven consecutive substantive single-Edit closures (sessions 25–37) plus this iteration's *single-Edit-plus-corrective-Edit* pattern. The pattern is mature; iter-030 should default to single-Edit unless the plan-agent's pre-prover probe surfaces a sub-namespace shadowing risk (in which case the directive should pre-specify `_root_.` qualification).

## Session-38 task_results status

- `.archon/task_results/MayerVietoris.lean.md`: complete (prover task result, 115 lines).
- The iter-030 plan agent should:
  1. Migrate the iter-029 cohort entries to `task_done.md` (six new entries).
  2. Update `task_pending.md` to remove the iter-029 candidates and queue the iter-030+ next-step candidates (`HModule'_apply` → affine vanishing → Module.Finite).
  3. Update PROGRESS.md / STRATEGY.md narrative labels: Step 1 (LES) and Step 2 (cover-totality) of the Serre-finiteness sketch are now complete; Step 3 (affine vanishing) and Step 4 (finite-dimensional `H^0`) remain.
  4. Append the six new declaration names to `blueprint/lean_decls`.
  5. Re-probe Mathlib for affine-vanishing and Čech-vs-derived-functor API state.
  6. **Pre-specify `_root_.AlgebraicGeometry.Scheme.<name>` in any iter-030 directive that defines a new declaration with a sub-namespace prefix that collides with a parent-namespace declaration.** This is the iter-029 lesson learned.

## Verification fingerprint (for the iter-030 plan-agent verification step)

If iter-030 plan-agent re-runs verification on iter-029 deliverables (sanity check):

1. `wc -l AlgebraicJacobian/Cohomology/MayerVietoris.lean` → `652`.
2. `lean_diagnostic_messages` on `Cohomology/MayerVietoris.lean` → `{success: true, items: [], failed_dependencies: []}`.
3. `sorry_analyzer.py AlgebraicJacobian/ --format=summary` → `9 total across 3 file(s)` (5 + 3 + 1).
4. `git diff archon-protected.yaml` → empty.
5. `lake env lean ...` (full project build) → succeeds with no errors.
6. `grep -n 'AffineCoverMVSquare\.' AlgebraicJacobian/Cohomology/MayerVietoris.lean` → matches at L593, 601, 607, 613, 621, 633, 643 (et seq.) for the eight declarations (2 from iter-028 + 6 from iter-029).
7. `grep -n 'AffineCoverMVSquare' blueprint/src/chapters/Cohomology_MayerVietoris.tex` → matches in iter-028 § + iter-029 §.
8. `grep '\\\\leanok' blueprint/src/chapters/Cohomology_MayerVietoris.tex | wc -l` → 53 (42 pre-iter-029 + 6 statement + 5 proof iter-029 markers added this session).
9. `lean_verify AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence` → kernel-only axioms.
10. `lean_verify AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence_exact` → kernel-only axioms.
