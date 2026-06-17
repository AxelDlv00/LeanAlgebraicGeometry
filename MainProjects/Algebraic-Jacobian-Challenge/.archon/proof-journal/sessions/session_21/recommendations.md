# Recommendations for the next plan-agent iteration (iter-027)

## TL;DR

- **Priority 0 (URGENT — seventh-time-of-asking):** run the long-deferred file split. The iter-016 → iter-026 LES infrastructure cohort (~480 LOC) is now self-contained at the natural semantic boundary; this is the canonical moment to invoke the `refactor` subagent and create `AlgebraicJacobian/Cohomology/MayerVietoris.lean`. After the split, `Cohomology/StructureSheafModuleK.lean` shrinks back to ~330 LOC.
- **Priority 1 (primary, iter-027 prover lane):** begin the first Serre-finiteness lemma on a 2-affine cover, the first concrete step toward `Module.Finite k (HModule k F i)` (multi-iteration; consumed by `smoothOfRelativeDimension_genus`).
- **Track 2 (parallel low-coupling):** none recommended.
- Do **not** re-issue `representable`, the 8 remaining protected sorries, direct `LineBundle` refinement, or any of the closed scaffold sites. The iter-014 → iter-026 closures are final and live in `task_done.md`.

## Context

Iter-026 (this session) closed the Mayer-Vietoris LES proper for the `ModuleCat k` flavor, three short one-liners on top of the iter-023 sequence iso:

- `HModule'_sequence_exact` (lemma): the LES exactness theorem (Mathlib `MayerVietoris.lean` L140–141 mirror), one-liner via `ComposableArrows.exact_of_iso (...) (Ext.contravariantSequence_exact _ _ _ _ _)`.
- `HModule'_δ_toBiprod` (`@[reassoc (attr := simp)]` lemma): `δ ≫ toBiprod = 0` (L143–145 mirror), one-liner via `(... .zero 2)`.
- `HModule'_fromBiprod_δ` (`@[reassoc (attr := simp)]` lemma): `fromBiprod ≫ δ = 0` (L147–149 mirror), one-liner via `(... .zero 1)`.

Sorry trajectory: `9 → 9` (collapsed by single-Edit closure; transient `9 → 12 → 9` was condensed). Kernel-only axioms on each new declaration. Total file LOC: 774 → 812 (+38).

This concludes the Path-2 Mayer-Vietoris LES build-out. The cohort iter-014 → iter-026 forms a tightly-coupled semantic unit (~480 LOC) — exactly what the file split should move to `Cohomology/MayerVietoris.lean`.

## Detailed Track 1 — File split (URGENT, Priority 0)

### Why this iteration

- `Cohomology/StructureSheafModuleK.lean` is now **812 LOC, ~412 LOC over the ~400 LOC threshold**.
- The iter-016 → iter-026 LES cohort (~480 LOC) is now **complete and self-contained** — the natural semantic boundary for splitting.
- Six prior iterations (iter-021 through iter-026) have flagged this as urgent. The longer the deferral, the more declarations migrate together; the sweet spot is now.
- Iter-027 Serre-finiteness work will add 100–200 LOC of new declarations. If those land in the same file, it crosses 1000 LOC.

### What to move to `Cohomology/MayerVietoris.lean`

All declarations in `Cohomology/StructureSheafModuleK.lean` from `HModule'_cohomologyPresheafFunctor` (currently L278) through `HModule'_fromBiprod_δ` (currently L767). Concretely:

| iter | Declaration | LOC range (post-iter-026) |
|---|---|---|
| 016 | `HModule'_cohomologyPresheafFunctor` | ~278–296 |
| 016 | `HModule'_cohomologyPresheaf` | ~297–319 |
| 017 | `HModule'_toBiprod` | ~321–343 |
| 017 | `HModule'_fromBiprod` | ~345–378 |
| 018 | `HModule'_toBiprod_fromBiprod` | ~380–399 |
| 019 | `ModuleCat_free_isLeftAdjoint` | ~400–419 |
| 019 | `HModule'_isPushoutModuleCatFreeSheaf` | ~420–451 |
| 019 | `HModule'_shortComplex` | ~453–489 |
| 020 | `ModuleCat_free_preservesMonomorphisms` | ~491–504 |
| 020 | `HModule'_shortComplex_f_mono` | ~505–522 |
| 020 | `HModule'_shortComplex_g_epi` | ~523–537 |
| 020 | `HModule'_shortComplex_exact` | ~538–555 |
| 020 | `HModule'_shortComplex_shortExact` | ~556–589 |
| 021 | `HModule'_δ` | ~590–613 |
| 022 | `HModule'_sequence` | ~615–625 |
| 023 | `HModule'_toBiprod_apply` | ~629–648 |
| 023 | `HModule'_fromBiprod_biprodIsoProd_inv_apply` | ~650–667 |
| 023 | `HModule'_biprodAddEquiv_symm_biprodIsoProd_hom_toBiprod_apply` | ~675–685 |
| 023 | `HModule'_mk₀_f_comp_biprodAddEquiv_symm_biprodIsoProd_hom` | ~691–710 |
| 023 | `HModule'_sequenceIso` | ~712–737 |
| 026 | `HModule'_sequence_exact` | ~742–751 |
| 026 | `HModule'_δ_toBiprod` | ~755–763 |
| 026 | `HModule'_fromBiprod_δ` | ~767–775 |

### What stays in `Cohomology/StructureSheafModuleK.lean`

- iter-005/006/007 step 5 main scaffold (`HasSheafify_Opens_ModuleCatK`, `HasExt_Sheaf_Opens_ModuleCatK`, etc.)
- iter-009/010 `HModule` + `HModule_zero_linearEquiv`
- iter-014/015 `HModule'` + `HModule'_zero_linearEquiv` (the **carrier definitions**, kept in `StructureSheafModuleK.lean` because `MayerVietoris.lean` will import them)
- iter-012 Čech scaffolding (`cechCochain_OC`, `cechCohomology_OC`)

Estimated post-split LOC: `StructureSheafModuleK.lean` ~330 LOC, `MayerVietoris.lean` ~480 LOC. Both well under threshold.

### Refactor agent invocation

Plan agent should pass the directive **inline** in the `refactor` subagent prompt (per the `.archon/CLAUDE.md` rule: never write to `REFACTOR_DIRECTIVE.md`). The directive should specify:

1. Create `AlgebraicJacobian/Cohomology/MayerVietoris.lean` with the same `import` block as `StructureSheafModuleK.lean` plus an `import AlgebraicJacobian.Cohomology.StructureSheafModuleK` line.
2. Move the 23 declarations listed above verbatim (same names, same signatures, same bodies, same attributes including `@[reassoc (attr := simp)]` and `set_option backward.isDefEq.respectTransparency false in` wrappers).
3. Preserve the `namespace AlgebraicGeometry.Scheme` namespace context in the new file.
4. Update `AlgebraicJacobian.lean` (the root module) to add `import AlgebraicJacobian.Cohomology.MayerVietoris` if needed.
5. Verify `lean_diagnostic_messages` is clean on both files post-split.
6. None of the moved declarations are in `archon-protected.yaml`, so no path-key updates to `archon-protected.yaml` are required.

Note: `archon-protected.yaml` should be re-read by the refactor agent for safety; based on session-34 notes, no protected declarations live in `Cohomology/StructureSheafModuleK.lean`, but verify.

## Detailed Track 1.5 — Serre-finiteness first lemma (after split)

After the file split, the iter-027 prover lane should begin Serre finiteness on a 2-affine cover. The first concrete target is the affine-finiteness lemma: for `X` a quasi-compact separated `k`-scheme covered by two affines `U₁, U₂` with `U₁ ∩ U₂ = U₁₂` affine, and `F` a quasi-coherent sheaf on `X`, the cohomology `H^i(X, F)` is finite-dimensional over `k` for all `i ≥ 0`.

The Mathlib-side prerequisites depend on Mathlib's Čech-vs-derived-functor comparison (still being built upstream). The plan agent should re-probe Mathlib for the latest state of the comparison API before scoping the iter-027 prover objective; if the API is not yet stable, the plan agent may opt for an intermediate scaffold lemma instead.

If the Čech comparison is still gated upstream, an alternative iter-027 Track 1 is:

- Begin the **2-affine cover MV-LES specialization**: a `MayerVietorisSquare` constructor `Scheme.affine_2cover_MVSquare` that takes a quasi-compact separated `k`-scheme `X`, two affines `U₁, U₂` covering it, and assumes `U₁ ∩ U₂` is affine, yielding `J.MayerVietorisSquare` for `J = Opens.grothendieckTopology X`. This is the bridge from the abstract MV-LES (iter-014–026) to the concrete Serre-finiteness setup.

## Hard avoid (do not assign)

- `representable` (`Picard/Functor.lean` L190): blocked on `LineBundle` refinement (`MonoidalCategory X.Modules` Mathlib gap) plus FGA argument. Multi-iteration.
- The 8 remaining protected sorries (5 `Jacobian.lean` + 3 `AbelJacobi.lean`): Phase C representability + Phase E geometric content. Multi-iteration.
- Direct `LineBundle` refinement: blocked on Mathlib `MonoidalCategory X.Modules`.
- Any vacuous-functor / vacuous-sheaf closures (forbidden shortcut list in `PROJECT_STATUS.md`).
- Iter-014 → iter-026 closures: all final, in `task_done.md`. Do not re-open.

## Reusable proof patterns discovered this session

- **`ComposableArrows.exact_of_iso (iso) (exact_proof)`** — transports `ComposableArrows.Exact` across an iso. Used for: any LES exactness derivation when the source category has an iso to a Mathlib-known-exact `ComposableArrows`.
- **`(seq.Exact).zero i`** — extracts the `i`-th composition-is-zero relation. Used for: deriving `simp` companions of an LES exactness theorem at each interior position.
- **`@[reassoc (attr := simp)]` on a one-liner `lemma X ≫ Y = 0`** — auto-generates `_assoc` variant + registers both as `simp`. Used for: any composition-is-zero `simp` companion of an exactness theorem.

## Process drift status

- **Iteration-counter desync**: resolved this iteration. PROGRESS.md narrative label realigned from `iteration 023` → `iteration 026` to match the dispatcher counter. The plan-agent first pass explicitly addressed this (see PROGRESS.md "Iteration counter desync correction" subsection). Drift counter at session 35: **0** (in sync).
- **Refactor + prover sub-phase collapse**: tenth consecutive recurrence (iter-015 → iter-022, iter-023, iter-026; iter-024 was verify-only). This is a **maximally strongly recurring pattern**; the dispatcher / project should standardise it for narrow probe-confirmed scaffolds in unprotected territory by skipping the refactor sub-phase by design.

## Session-35 task_results status

- `task_results/Cohomology_StructureSheafModuleK.lean.md`: written by the iter-026 prover; reports RESOLVED on all three targets.
- `task_results/refactor.md`: not written (refactor + prover sub-phases collapsed into single Edit, as in iter-015 → iter-025).
- Plan agent should migrate the iter-026 closures to `task_done.md` and clear `Cohomology_StructureSheafModuleK.lean.md` after acceptance.

## Verification fingerprint (for the iter-027 plan-agent verification step)

If iter-027 plan-agent re-runs verification on iter-026 closures (sanity check):

1. `lean_diagnostic_messages /home/archon/Lean_tests/AlgebraicJacobian/AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` → `{success: true, items: [], failed_dependencies: []}`.
2. `lean_verify` on `AlgebraicGeometry.Scheme.HModule'_sequence_exact`, `AlgebraicGeometry.Scheme.HModule'_δ_toBiprod`, `AlgebraicGeometry.Scheme.HModule'_fromBiprod_δ` → `{axioms: [propext, Classical.choice, Quot.sound], warnings: [(line: 397, pattern: "local instance")]}`.
3. `sorry_analyzer.py AlgebraicJacobian/ --format=summary` → `9 total across 3 file(s)` (5 + 3 + 1).
4. `git diff archon-protected.yaml` → empty.
