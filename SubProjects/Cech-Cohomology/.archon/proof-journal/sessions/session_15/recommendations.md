# Recommendations for the next plan iteration (post iter-015)

## HIGH — blueprint adequacy gap blocking the P3 L1 lane
The lean-vs-blueprint-checker (`cechacyclic`) flags that the consolidated chapter's
`lem:cech_acyclic_affine` proof sketch is **silent on L1** (the categorical→module bridge). A prover
**cannot begin L1 from the blueprint alone** — it is currently described only inside a strategy
comment in `CechAcyclic.lean` itself. **Action:** before re-dispatching any L1 prover lane, dispatch
a **blueprint-writer** on `Cohomology_CechHigherDirectImage.tex` to add an explicit L1 paragraph:
identify `(CechComplex f 𝒰 F).X p` with `∏_{σ:Fin(p+1)→ι} Γ(D(s_σ), F)` and the differential with the
alternating localisation-restriction coboundary; reference
`affineOpenCoverOfSpanRangeEqTop_f i = Spec.map (algebraMap R (Localization.Away (s i)))`,
`IsAffineOpen.isLocalization_of_eq_basicOpen`, `pushPullObj`, `Scheme.Modules.pushforward`. Also
specify the **dependent-coefficient** L3 port (varying modules `M_{s_σ s_r}`, prepend-iso
`A(Fin.cons r τ) ≃ A τ`). Report: `.archon/logs/iter-015/lean-vs-blueprint-checker-cechacyclic-report.md`.

## HIGH — coverage debt: 11 unmatched `lean_aux` nodes need blueprint wiring
`archon dag-query unmatched` lists 11 Lean declarations with no blueprint block. They are invisible to
the dependency graph until wired. **The review agent does not author blueprint prose** (Step 6) — the
planner should restore correspondence next iter, using the **bundling pattern** (append to an existing
block's multi-name `\lean{...}` list; do NOT create new environments). Suggested targets (confirmed by
both the prover task_results and the lvb-checker):

Bundle into `lem:cech_acyclic_affine`'s `\lean{...}` list (all `private`, namespace
`AlgebraicGeometry.CombinatorialCech`, all proved axiom-clean, **no project deps** — proofs rely only
on `Fin.*` / `Finset.sum_involution` / `Fintype.sum_prod_type`):
- `combDifferential`
- `combDifferential_comp`
- `combDifferential_eq_of_cocycle`
- `combDifferential_exact`
- `combHomotopy`
- `combHomotopy_spec`
- `combHomotopy_zero`
- `combSign_flip`
- `cons_comp_succAbove_succ`

Bundle into `lem:injective_cech_acyclic`'s `\lean{...}` list:
- `AlgebraicGeometry.injective_toPresheafOfModules` (Part 1; relies on
  `PresheafOfModules.sheafificationAdjunction`, `sheafification`'s `PreservesMonomorphisms` instance,
  `Injective.injective_of_adjoint`, and the defeq `toPresheafOfModules X = forget ⋙ restrictScalars (𝟙 _)`).

Bundle into `lem:cech_complex_hom_identification`'s `\lean{...}` list:
- `AlgebraicGeometry.freeYonedaHomEquiv` (per-term core; relies on `PresheafOfModules.freeHomEquiv`,
  `CategoryTheory.yonedaEquiv`).

## HIGH — closest-to-completion next targets (frontier-ready, recipes verified)
The P3b lane is the bottleneck (effort 3000+). The single highest-value first target is:
1. **`sectionCechComplex`** (`def:section_cech_complex`, frontier, effort 1709) — build the
   `CosimplicialObject` `[p] ↦ ∏_{σ:Fin(p+1)→ι} F(⨅ σ)`, component at `τ` on `α:[p]⟶[q]` = projection
   at `τ∘α` then restriction `F(⨅(τ∘α))⟶F(⨅τ)`, then `alternatingCofaceMapComplex` (free `d²=0`). The
   functor laws `map_id`/`map_comp` are the work (~50–150 LOC). **Do NOT** derive from the Čech nerve
   in `Opens X` (poset degenerates the products, loses `ι`).
2. **`cechFreePresheafComplex`** (`def:cech_free_presheaf_complex`, frontier, effort 3079) — once (1)
   lands; build via a *simplicial* object + `AlternatingFaceMapComplex`. Use `PresheafOfModules.free`
   + `yoneda`, not a bespoke `j_!`. Quasi-iso via `HomologicalComplex.Homotopy` → `HomotopyEquiv.toQuasiIso`.
3. **Additive/natural upgrade of `freeYonedaHomEquiv`** — needed before the full hom-identification.
   Note Mathlib has **no** `biproduct.homEquiv`/`Sigma.homEquiv`; assemble from `Sigma.ι`/`Sigma.desc`
   + `Sigma.ι_desc` (`ext i; simp [Sigma.ι_desc]`).

## MEDIUM — stale status comments (lean-auditor `iter015`, 3 major; cleanup, not blocking)
These claim work "remaining"/"not yet closed" that is in fact proved — misleading the next agent:
- `AcyclicResolution.lean:924–963` — block says "TARGET 3 remains" but
  `rightDerivedIsoOfAcyclicResolution` is proved at L893.
- `CechHigherDirectImage.lean:245–260` — calls `pushPullMap_comp` "remaining"; proved at L627.
- `CechHigherDirectImage.lean:410–449` — calls `rawPushPullMap_comp` "not yet closed"; closed at L536.
A prover or refactor pass touching those files should prune them; not worth a dedicated lane.

## Do NOT retry (blocked-approach register)
- **L3 via `ExtraDegeneracy`** — wrong variance, no cosimplicial dual in Mathlib. The explicit module
  homotopy (`CombinatorialCech`) is the intended, now-built replacement.
- **`sectionCechComplex` / `cechFreePresheafComplex` via the Čech nerve in `Opens X`** — poset fibre
  products degenerate; the indexed product over `Fin(p+1)→ι` must be explicit.
- **`Fin.val_castPred`** — does not exist; use `Fin.coe_castPred`.
- **One-line term form of `injective_toPresheafOfModules`** — typeclass timeout; use the
  `haveI : Injective (C := SheafOfModules X.ringCatSheaf) I := ‹Injective I›` realignment.

## Process note — provers ran cleanly this iter
The iter-011 weekly-API-limit abort did NOT recur; both P3 and P3b lanes produced real, axiom-clean
declarations. There is now genuine prover trajectory data for these routes, so a **progress-critic**
dispatch is meaningful next plan phase (it was correctly skipped while the only trajectory was the
external abort). No churning signal: every attempt this iter closed a goal or wrote a documented recipe.
