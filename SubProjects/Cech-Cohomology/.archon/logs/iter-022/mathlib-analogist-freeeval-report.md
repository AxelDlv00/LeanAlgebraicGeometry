# Mathlib Analogist Report

## Mode
api-alignment

## Slug
freeeval

## Iteration
022

## Question
Mathlib-aligned idiom for `cechFreeEvalEngineIso` (degreewise iso of coproduct-termed
`HomologicalComplex` + evaluation-through-`∐`), the Homotopy→QuasiIso packaging chain, and a
verdict on engine route vs. `ExtraDegeneracy` refactor (Q1–Q4 of the directive).

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1 degreewise iso of coproduct-termed complex | ALIGN_WITH_MATHLIB | major (not yet shipped) |
| Q2 evaluation through `∐` + `mapHomologicalComplex` | PROCEED | informational (already aligned) |
| Q3 contracting homotopy ⟹ QuasiIso | ALIGN_WITH_MATHLIB (Route B) | major (not yet shipped) |
| Q4 engine vs. `ExtraDegeneracy` | DIVERGE_INTENTIONALLY | informational |

## Major

These are ALIGN verdicts on code not yet shipped — the prover should adopt the idiom directly
(no refactor of existing code needed).

- **Q1 — `cechFreeEvalEngineIso` construction.** Use
  `HomologicalComplex.Hom.isoOfComponents` (verified, `Mathlib.Algebra.Homology.HomologicalComplex`;
  has `isoOfComponents_hom_f`/`_inv_f`). Per-degree iso:
  `cechFreeEval_X p`  (already `Limits.PreservesCoproduct.iso`, line 574)  `≫`  hand-built
  *drop-zeros* iso  `≫`  `Limits.Sigma.whiskerEquiv` (verified) fed with `freeYonedaEval_iso_of_le`.
  The `comm` square: `Limits.Sigma.hom_ext` (already used in-file) + `Limits.Sigma.ι_comp_map'` /
  `Limits.Sigma.ι_map` / `Sigma.ι_desc` (all verified). **One sub-iso has no named lemma**: the
  drop-zeros step (`∐_{σ:Fin(p+1)→I₀} … ≅ ∐ over the `V≤U_σ` subtype`), because `whiskerEquiv`
  needs a *bijection* of index types and I₀→survivors is not one. Build it by hand with
  `Sigma.desc`/`Sigma.ι`/`Sigma.hom_ext`, killing complement injections via
  `(freeYonedaEval_isZero_of_not_le _).eq_zero_of_src` — the exact pattern already in
  `isZero_sigma_of_forall_isZero` (line 621).

- **Q3 — Homotopy→QuasiIso. Prefer Route B (the project's own precedent).**
  `HomotopyEquiv.quasiIso_hom` is an **instance** (verified) — `QuasiIso e.hom` is automatic;
  there is **no** `HomotopyEquiv.toQuasiIso`/`Homotopy.toQuasiIso` lemma. But Route A requires
  repackaging `combHomotopy` into a `HomologicalComplex.Homotopy` structure. Route B reuses the
  already-axiom-clean `combDifferential_exact` and mirrors the shipped, axiom-clean
  `CechAcyclic.sectionCech_isZero_homology_of_objD_exact` (line 1247):
  `exactAt_iff_isZero_homology` → `HomologicalComplex.exactAt_iff'` →
  `ShortComplex.moduleCat_exact_iff_function_exact` (verified; ModuleCat analogue of the
  `ab_exact_iff_function_exact` the section side uses) → `combDifferential_exact`. Degree-0
  `H₀ ≅ O_𝒰(V)` from `combHomotopy_spec` at `n=0`; read off with `ChainComplex.toSingle₀Equiv`
  (already used line 343). Transfer to the evaluated augmentation with **`quasiIso_of_arrow_mk_iso`**
  / `quasiIso_iff_of_arrow_mk_iso` (verified; instance `HomologicalComplex.instRespectsIsoQuasiIso`),
  then lift via the existing `quasiIso_of_evaluation` (line 414).

## Informational

- **Q2 — already aligned.** `cechFreeEval_X` (line 574) is literally `PreservesCoproduct.iso _ _`
  under `PresheafOfModules.Finite.evaluation_preservesFiniteColimits`. No hand-threading of
  `mapHomologicalComplex` is needed: `((F.mapHomologicalComplex c).obj K).X p` is defeq
  `F.obj (K.X p)`, so feeding `cechFreeEval_X p` per degree into `isoOfComponents` suffices. No
  `preservesColimitIso`/`ι_preservesColimitsIso_hom` plumbing required.

- **Q4 — keep the engine; do NOT refactor onto `ExtraDegeneracy`.** Already rejected twice in this
  codebase: `FreePresheafComplex.lean:92-93` (DEAD END, "different index convention") and
  `CechAcyclic.lean:58` ("wrong variance — chain vs. cochain — and no cosimplicial dual exists in
  Mathlib"). The per-`V` evaluated object is a coproduct of `ModuleCat`s, not literally a Mathlib
  (co)simplicial object with the right variance; an `ExtraDegeneracy` route would first have to
  reconstruct the augmented simplicial object and reconcile its index convention — strictly more
  work than the engine, which already exists and is axiom-clean (`combDifferential`, `combHomotopy`,
  `combHomotopy_spec`, `combDifferential_comp`, `combDifferential_exact`). Commit to the engine.

- **The real bottleneck is the differential variance match, not the packaging.** The free chain
  differential *lowers* Fin-arity (faces `σ ↦ σ∘δ_i`); `combDifferential` *raises* it. They
  reconcile on the finite biproduct `∐ M = ∏ M` (self-dual over a finite index): the
  injection-indexed face differential `ι_σ ↦ Σ_i (-1)^i (incl) ≫ ι_{σ∘δ_i}` is the transpose of
  `combDifferential`, with `(SimplexCategory.δ i).toOrderHom = Fin.succAbove i`. Prove it
  degreewise on `Sigma.ι` (`Sigma.hom_ext`). This is the line the directive flagged and the place
  to spend prover effort — the rest is the named-lemma scaffolding above.

## Persistent file
- `analogies/free-eval-engine-iso.md` — full skeleton, lemma names, and Q1–Q4 rationale for future iters.

Overall verdict: the engine route is the right shape — build `cechFreeEvalEngineIso` with
`isoOfComponents` + `PreservesCoproduct.iso` (`cechFreeEval_X`) + `Sigma.whiskerEquiv` + a hand-built
drop-zeros iso, package QuasiIso via the `Function.Exact`/`exactAt_iff'`/`moduleCat_exact_iff_function_exact`
precedent feeding `combDifferential_exact`, transfer with `quasiIso_of_arrow_mk_iso`; do NOT refactor onto `ExtraDegeneracy`.
