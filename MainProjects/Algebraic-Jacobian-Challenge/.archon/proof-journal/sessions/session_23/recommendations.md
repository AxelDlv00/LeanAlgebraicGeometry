# Recommendations for the next plan-agent iteration (iter-029)

## TL;DR

- **Priority 1 (primary, iter-029 prover lane)**: build the first downstream consumer of `Scheme.AffineCoverMVSquare` — the simp-companion lemma `Scheme.AffineCoverMVSquare.cover_top` identifying `S.toMayerVietorisSquare.toSquare.X₄` with `⊤` via `S.cover`. Single declaration, narrow scope, suitable for a single-Edit closure with a `lean_run_code` probe-confirmed body. Probe target: `Opens.mayerVietorisSquare U₁ U₂ |>.toSquare.X₄ = U₁ ⊔ U₂` is `rfl` (already verified iter-028); composing with `S.cover : U₁ ⊔ U₂ = ⊤` should make `S.toMayerVietorisSquare.toSquare.X₄ = ⊤` provable by `simp [S.cover]` or `S.cover ▸ rfl`-style.
- **Priority 1 alternative (heavier, single-scaffold)**: pre-stage `Scheme.AffineCoverMVSquare.HModule'_apply` — apply `HModule'_sequence_exact` to `S.toMayerVietorisSquare` and `toModuleKSheaf C` to produce the 5-term LES on a concrete `C.AffineCoverMVSquare` (per the iter-028 task_result § *Next-iteration suggestions*).
- **Track 2 (parallel low-coupling)**: still none recommended. Polish backlog remains empty.
- **Mathlib gating watch**: re-probe the Čech-vs-derived-functor comparison API at iter-029 plan-agent time. If newly ungated, that opens **Option A** (the deeper affine-finiteness primitive) from the session-36 menu as an alternative.
- Do **not** re-issue `representable`, the 8 remaining protected sorries, direct `LineBundle` refinement, or any of the closed scaffold sites (iter-014 → iter-026 + iter-028). All final, in `task_done.md`.

## Context

Iter-028 (this iteration) was the **first concrete step of the Serre-finiteness chain** (Phase A step 6 *Path 2*). Two declarations landed in a single Edit:

- `Scheme.AffineCoverMVSquare` — bundled 2-affine cover structure with affine intersection, six fields. The affineness predicates and the cover-totality hypothesis are scheme-flavored data the abstract Mathlib `MayerVietorisSquare` does not record.
- `Scheme.AffineCoverMVSquare.toMayerVietorisSquare` — `noncomputable def` accessor delegating to `Opens.mayerVietorisSquare S.U₁ S.U₂`, producing the underlying abstract MV square the iter-026 LES theorem `HModule'_sequence_exact` consumes.

Sorry count `9 → 9` (no transient via single-Edit). `archon-protected.yaml` untouched. File compiles clean with `{success: true, items: [], failed_dependencies: []}`. Four corner-equality `rfl`-smoke checks pass (verified by plan-agent `lean_run_code` probe). New file LOC: `Cohomology/MayerVietoris.lean` 559 → 600 (+41 LOC).

Post-iter-028 state:
- `Cohomology/MayerVietoris.lean`: 600 LOC, 0 sorries, contains the 23 iter-016 → iter-026 LES infrastructure declarations + the 2 iter-028 scaffold declarations.
- `Cohomology/StructureSheafModuleK.lean`: 299 LOC, 0 sorries, unchanged.
- Blueprint `Cohomology_MayerVietoris.tex`: 617 → 617 LOC (existing iter-028 § already in place from the iter-028 plan-agent prose pass; review-agent added two `\leanok` markers post-prover-closure).

## Detailed Track 1 — `cover_top` simp companion (Priority 1)

### Why this iteration

`Scheme.AffineCoverMVSquare` is the geometric input bundle; `toMayerVietorisSquare` produces the abstract MV square. The next bridge is to **identify the `X₄` corner with `⊤`** so the LES applied to a concrete `C.AffineCoverMVSquare` reads off cohomology of the whole scheme. This is the load-bearing identification the blueprint subsection *§ Use in Serre finiteness* (L670–679 of `Cohomology_MayerVietoris.tex`) calls out as step (2) of the iter-029+ chain.

### Suggested probe target

```lean
@[simp]
lemma Scheme.AffineCoverMVSquare.cover_top {X : Scheme.{u}}
    (S : X.AffineCoverMVSquare) :
    S.toMayerVietorisSquare.toSquare.X₄ = ⊤ := by
  -- toSquare.X₄ = S.U₁ ⊔ S.U₂ definitionally; use S.cover.
  simp [AffineCoverMVSquare.toMayerVietorisSquare, Opens.mayerVietorisSquare, S.cover]
```

Or in term mode if the `simp` reduction goes through cleanly:

```lean
@[simp]
lemma Scheme.AffineCoverMVSquare.cover_top {X : Scheme.{u}}
    (S : X.AffineCoverMVSquare) :
    S.toMayerVietorisSquare.toSquare.X₄ = ⊤ :=
  S.cover
```

The plan agent should **probe both shapes via `lean_run_code`** before fixing the prover directive: term-mode `S.cover` is correct iff `S.toMayerVietorisSquare.toSquare.X₄` reduces to `S.U₁ ⊔ S.U₂` by `rfl` (probe-confirmed in iter-028). If yes, the body is just `S.cover`.

### Naming convention

`cover_top` mirrors a Mathlib idiom for "the top-cover-equals-`⊤`" simp companions of bundled-cover structures. Alternatives (`X₄_eq_top`, `eq_top_of_cover`) are less idiomatic — prefer `cover_top`.

### Hard avoid (do not assign for iter-029)

- `representable` (`Picard/Functor.lean` L190): still blocked on `LineBundle` refinement + FGA. Multi-iteration.
- The 8 remaining protected sorries (5 `Jacobian.lean` lines 77/88/97/104/114 + 3 `AbelJacobi.lean` lines 35/41/53): Phase C representability + Phase E geometric content. Multi-iteration.
- Direct `LineBundle` refinement: blocked on Mathlib `MonoidalCategory X.Modules`.
- Any vacuous-functor / vacuous-sheaf closures (forbidden shortcut list in `PROJECT_STATUS.md`).
- Iter-014 → iter-026 closures + iter-028 scaffolds: all final, in `task_done.md`. Do not re-open.

## Detailed Track 1 alternative — `HModule'_apply` (heavier scaffold)

### Why this might be preferable

If the plan agent's iter-029 probe confirms that `cover_top` is a one-liner (which iter-028's probe data strongly suggests), the iteration's "interesting" content is small. A heavier alternative is the LES instantiation:

```lean
noncomputable def Scheme.AffineCoverMVSquare.HModule'_apply
    {k : Type*} [Field k] (X : Scheme.{u})
    (S : X.AffineCoverMVSquare)
    (F : Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k))
    [HasWeakSheafify (Opens.grothendieckTopology X.toTopCat) (Type u)]
    [HasSheafify (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k)]
    [HasExt (Sheaf (Opens.grothendieckTopology X.toTopCat) (ModuleCat.{u} k))]
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    (HModule'_sequence k S.toMayerVietorisSquare F n₀ n₁ h).Exact :=
  HModule'_sequence_exact k S.toMayerVietorisSquare F n₀ n₁ h
```

This is a name-shorthand for "apply the iter-026 exactness theorem to the iter-028 scaffold" and bundles it under the `Scheme.AffineCoverMVSquare` namespace for downstream ergonomics. The plan agent should re-probe to confirm the typeclass burden is tractable; if any of the `HasExt`/`HasSheafify` instances doesn't auto-resolve at this slot, the heavier scaffold is more expensive and should defer to iter-030+.

### Sequencing

If the iter-029 plan agent picks `cover_top` (the simp companion), `HModule'_apply` queues for iter-030 alongside an affine-vanishing input. If the iter-029 plan agent picks `HModule'_apply` directly, `cover_top` queues for iter-030 as a one-line companion that will likely be needed before any concrete cohomology computation can use the LES on a curve.

**Reviewer's recommendation**: pick `cover_top` for iter-029. It is the smaller, more clearly-load-bearing step; it threads `S.cover` into the LES setup (no other declaration uses `S.cover` yet); and it stages a clean foundation for iter-030's heavier `HModule'_apply` work.

## Reusable proof patterns from prior sessions (still applicable, not re-listed)

See `PROJECT_STATUS.md` § *Knowledge Base / Proof Patterns* (currently 60+ patterns spanning sessions 1–37). The iter-028-specific additions (added to `PROJECT_STATUS.md` this session):

- Bundled-structure pattern for "geometric data the abstract Mathlib categorical structure does not capture".
- `Opens.mayerVietorisSquare U₁ U₂` is the canonical Mathlib idiom; the four corners hold by `rfl`.
- `noncomputable` propagates through `Opens.mayerVietorisSquare`-style delegations.
- `section <Name>` headers within an existing `namespace` are purely organisational.

## Process drift status

- **Refactor + prover sub-phase collapse**: eleventh consecutive substantive occurrence (iter-015 → iter-022, iter-023, iter-026, iter-028). For iter-027 the dispatcher correctly skipped the prover phase; for iter-028 it correctly invoked it (substantive scaffold addition, not pure refactor).
- **Iteration-counter desync**: still resolved (drift counter 0; in sync). Iter-028 began at the correct iteration counter; `Archon iteration: 028` matches `logs/iter-028/` and the dispatcher commit-message conventions.
- **`attempts_raw.jsonl` freshness**: this iteration refreshed it (12 events, all timestamped `2026-05-08T16:04…16:06`Z). No stale-data carryover (unlike iter-027).
- **Single-Edit reliability**: ten consecutive substantive single-Edit closures of probe-confirmed bodies (sessions 25–37 modulo refactor-only iter-027 / verify-only iter-024). The pattern is mature; iter-029 should default to it for `cover_top` unless the plan-agent's pre-prover probe surfaces an obstacle.

## Session-37 task_results status

- `.archon/task_results/MayerVietoris.lean.md`: complete (prover task result, 80 lines).
- The iter-029 plan agent should:
  1. Migrate the iter-028 scaffold entries to `task_done.md` (two new entries).
  2. Update `task_pending.md` to remove the iter-028 candidates and queue iter-029+ next-steps (cover_top → HModule'_apply → affine vanishing → Module.Finite).
  3. Update PROGRESS.md / STRATEGY.md narrative labels to reflect that the Serre-finiteness chain has commenced.
  4. Optionally append `AlgebraicGeometry.Scheme.AffineCoverMVSquare` and `AlgebraicGeometry.Scheme.AffineCoverMVSquare.toMayerVietorisSquare` to `blueprint/lean_decls`.
  5. Re-probe Mathlib for Čech-vs-derived-functor comparison API state. If still gated (likely), proceed with `cover_top`. If newly ungated, reconsider with Option A (affine-finiteness primitive).

## Verification fingerprint (for the iter-029 plan-agent verification step)

If iter-029 plan-agent re-runs verification on iter-028 deliverables (sanity check):

1. `wc -l AlgebraicJacobian/Cohomology/MayerVietoris.lean` → `600`.
2. `lean_diagnostic_messages` on `Cohomology/MayerVietoris.lean` → `{success: true, items: [], failed_dependencies: []}`.
3. `sorry_analyzer.py AlgebraicJacobian/ --format=summary` → `9 total across 3 file(s)` (5 + 3 + 1).
4. `git diff archon-protected.yaml` → empty.
5. `lake env lean ...` (full project build) → succeeds with no errors.
6. `grep -n 'AffineCoverMVSquare' AlgebraicJacobian/Cohomology/MayerVietoris.lean` → matches at L559, 572, 588, 593, 594, 598.
7. `grep -n 'AffineCoverMVSquare' blueprint/src/chapters/Cohomology_MayerVietoris.tex` → matches at L619, 632, 634, 638 (et seq.).
8. `grep '\\\\leanok' blueprint/src/chapters/Cohomology_MayerVietoris.tex | wc -l` → 42 (40 pre-iter-028 + 2 iter-028 statement-level markers added this session).
