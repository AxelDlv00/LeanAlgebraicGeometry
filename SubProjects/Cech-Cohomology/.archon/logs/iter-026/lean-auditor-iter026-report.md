# Lean Auditor Report — iter-026

**Auditor:** lean-auditor subagent  
**Iteration:** 026  
**Date:** 2026-06-07  
**Scope:** All project source files under `AlgebraicJacobian/`

---

## Per-file checklist

### `AlgebraicJacobian.lean` (root import file, 9 lines)
- [x] Read in full
- [ ] **CRITICAL**: Does NOT import `AlgebraicJacobian.Cohomology.AbsoluteCohomology` — file is orphaned from the build graph (see Must-fix §1)
- [x] All other imports present: `HigherDirectImage`, `HigherDirectImagePresheaf`, `CechHigherDirectImage`, `CechAcyclic`, `AcyclicResolution`, `PresheafCech`, `FreePresheafComplex`, `CechBridge`

### `AbsoluteCohomology.lean` (109 lines) — PRIMARY FOCUS

- [x] Read in full
- [x] 10 declarations identified: `hasExtModules`, `jShriekOU`, `sheafificationHomAddEquiv`, `jShriekOU_homEquiv`, `absoluteCohomology`, `absoluteCohomologyZeroAddEquiv`, `absoluteCohomology_eq_zero_of_injective`, `absoluteCohomology_covariant_exact₁`, `absoluteCohomology_covariant_exact₂`, `absoluteCohomology_covariant_exact₃`
- [x] No `sorry` in file
- [ ] **Minor**: `hasExtModules` is `local instance` — does not propagate to importing files (see Minor §1)
- [ ] **Minor**: `erw` in `sheafificationHomAddEquiv` is genuine but fragile (see Minor §2)
- [x] Three `absoluteCohomology_covariant_exact₁/₂/₃` wrappers are faithful thin delegations to `Ext.covariant_sequence_exact₁/₂/₃` — no weakening, correct hypotheses threaded through
- [x] `absoluteCohomology_eq_zero_of_injective` is a faithful one-liner to `Ext.eq_zero_of_injective`
- [x] `absoluteCohomologyZeroAddEquiv` correctly chains `Ext.homEquiv₀` with `jShriekOU_homEquiv`
- [x] No excuse-comments
- [x] Docstrings are accurate: all describe the delegation to Mathlib correctly
- [x] `AddCommGrpCat.of` usage in `absoluteCohomology` is correct name (not `AddCommGroupCat`)

**Focus area verdicts:**

**`hasExtModules` universe pin** — `HasExt.{u + 1, u, u + 1} X.Modules` with `HasExt.standard _` is the correct standard instance for a module category. The universe triple is non-trivial but consistent with Mathlib's Ext formalism. The `local` qualifier is intentional (the docstring says "without the slow `HasSmallLocalizedHom` typeclass search") and technically correct. Risk: downstream files importing this file will not auto-inherit the instance; they need their own `HasExt` resolution. This is a minor documentation gap, not a correctness error.

**`erw [Functor.map_add, Preadditive.comp_add]; rfl`** — after `simp only [Equiv.toFun_as_coe, Adjunction.homEquiv_unit]`, the goal has functor-application forms whose LHS for `Functor.map_add` does not syntactically match — this is genuine defeq-carrier mismatch arising from the coercion of `Adjunction.homEquiv_unit`. The `erw + rfl` pattern is the correct workaround. The `haveI` on `.Additive` is required to provide the instance for `Functor.map_add`. Not a must-fix, but slightly fragile to Mathlib refactors of the adjunction API.

**Three exact wrappers** — faithful: each passes `jShriekOU U` as the fixed first argument and threads all hypotheses through to the corresponding Mathlib lemma unchanged. No hypothesis is dropped, renamed, or weakened. The signatures correctly specialize `ShortExact` as `hS` throughout.

**`absoluteCohomology_eq_zero_of_injective`** — faithful one-liner. `Ext.eq_zero_of_injective` requires `[Injective I]` on the *second* argument, which is correct here (`I : X.Modules` with `[Injective I]` as the second `Ext` argument).

---

### `CechBridge.lean` (912 lines) — SECONDARY FOCUS

- [x] Read in full (prior session)
- [ ] **Major**: Strategy block L77–119 states wrong combinator for what was shipped (see Major §1)
- [ ] **Major**: "gated on Lane-1" language at L272–283 is stale (see Major §2)
- [x] Module-level `## Declarations` section accurately lists declarations; marks proved ones as "proved" and `cech_eq_cohomology_of_basis` / `affine_serre_vanishing` as "(planned)" — accurate
- [x] `injective_cech_acyclic` — axiom-clean per memory iter-025; appears in file as proved
- [x] `ses_cech_h1` — axiom-clean per memory iter-024
- [x] `cechComplex_hom_identification` + `homCechSectionCosimplicialIso` — axiom-clean per memory iter-019
- [x] No excuse-comments in proof bodies
- [x] All "Project-local" annotations appear accurate

---

### `FreePresheafComplex.lean` (1452 lines)

- [x] Read in full (two passes, this session)
- [x] No `sorry` found anywhere in the file
- [x] `cechFreePresheafComplex` — built as `alternatingFaceMapComplex` of `cechFreeSimplicial`; `d²=0` from simplicial identities (correct path)
- [x] `cechFreeComplex_quasiIso` — proved via `quasiIso_of_evaluation` reducing to empty/nonempty cases; both cases closed axiom-clean
- [x] `cechFreeEvalEngineIso` (line 1150–1160) — built with `HomologicalComplex.Hom.isoOfComponents`; strategy block at L45–100 accurately describes this combinator choice (consistent, no discrepancy here)
- [x] `FreeCechEngine` namespace — self-contained combinatorial engine, correctly ported from `CechAcyclic.lean` analogue; `combHomotopy_spec` proved correctly
- [x] `erw` usage in `cechFreeEvalEngine_comm` (lines 1120–1132) — appropriate for `Functor.map_comp`, `Functor.map_sum` defeq situations arising from `mapHomologicalComplex`; standard pattern, not fragile
- [x] `cechEngineComplexAug_quasiIso` — degree-0 case uses `ShortComplex.quasiIso_iff_isIso_descOpcycles`; positive-degree case uses `quasiIsoAt_iff_exactAt'`; correct
- [x] No excuse-comments
- [x] `private` lemmas correctly scoped; no leaking of internal bookkeeping

---

### `CechAcyclic.lean` (1608 lines)

- [x] Read in full (prior session, two passes)
- [x] `CechAcyclic.affine` (line 75): `sorry` — known gap, L1 categorical→module bridge; strategy comment correctly describes the gap and why it is out of scope
- [x] All other declarations axiom-clean: `CombinatorialCech.*`, `AwayComparison.*`, `CechLocalized.*`, `SectionCechModule.*`, `sectionCech_affine_vanishing`
- [x] No excuse-comments

---

### `AcyclicResolution.lean` (927 lines)

- [x] Read in full (prior session)
- [x] No `sorry` found
- [x] All declarations axiom-clean
- [x] Comment at L164 (`-- Note: Functor.isZero_rightDerived_obj_injective_succ returns...`) — legitimate implementation note, not an excuse-comment
- [x] End-of-file `/-! ### P4 complete — ...` at L924 — accurate status marker
- [x] No excuse-comments

---

### `CechHigherDirectImage.lean` (682 lines)

- [x] Read in full (prior session)
- [x] `cech_computes_higherDirectImage` — has `sorry`; this is the protected target theorem (frozen signature), known gap
- [x] All supporting declarations (`coverArrow`, `coverCechNerve`, `pushPullObj`, `pushPullMap`, `pushPullMap_id`, `pushPullMap_comp`, `pushPullFunctor`, `coverCechNerveOver`, `CechNerve`, `CechComplex`) — axiom-clean
- [x] `-- Dead-end note:` at L347 — legitimate technical note documenting an explored dead-end, not an excuse-comment
- [x] No excuse-comments

---

### `HigherDirectImage.lean` (52 lines)

- [x] Read in full (prior session)
- [x] Single declaration `higherDirectImage` — axiom-clean, no issues

---

### `HigherDirectImagePresheaf.lean` (170 lines)

- [x] Read in full (prior session)
- [x] All declarations axiom-clean: `mapHomologyIso'`, `counitComplexIso`, `homologyIsoSheafify`, `pushforwardResolutionPresheafComplex`, `higherDirectImage_iso_sheafify_presheafHomology`
- [x] Module doc references task result ("see the `## Why I stopped` note") — this is a meta-note in a module docstring, not an excuse-comment in proof code
- [x] No excuse-comments

---

### `PresheafCech.lean` (339 lines)

- [x] Read in full (prior session)
- [x] All declarations axiom-clean: `injective_toPresheafOfModules`, `freeYonedaHomEquiv`, `freeYonedaHomEquiv_apply`, `freeYonedaHomAddEquiv`, `sectionCechCosimplicial`, `sectionCechComplex`
- [x] Large strategy block (lines 33–196) is planner strategy text, not excuse-comments
- [x] No excuse-comments

---

## Must-fix-this-iter

### M1 — Root import missing: `AbsoluteCohomology.lean` orphaned

**File:** `AlgebraicJacobian.lean`  
**Severity:** Must-fix  

`AlgebraicJacobian.lean` does not contain `import AlgebraicJacobian.Cohomology.AbsoluteCohomology`. The 10 declarations in `AbsoluteCohomology.lean` — including `absoluteCohomology`, the three LES wrappers, `absoluteCohomology_eq_zero_of_injective`, and `absoluteCohomologyZeroAddEquiv` — are therefore unreachable from the root build target and will not be picked up by `lake build`.

**Required action:** Add `import AlgebraicJacobian.Cohomology.AbsoluteCohomology` to `AlgebraicJacobian.lean`. The blueprint writer must also register the 10 new declarations (see the separate blueprint-writer task result from this iteration for the full list).

---

## Major

### J1 — Stale combinator in `CechBridge.lean` strategy block

**File:** `CechBridge.lean`, lines 77–119  
**Severity:** Major (factually wrong documentation)

The strategy block for `cechComplex_hom_identification` (Step 3) states:

> "Use `HomologicalComplex.Hom.isoOfComponents` (or equivalent) to combine the per-degree isos"

The actual implementation at line 268 uses:

```lean
(AlgebraicTopology.alternatingCofaceMapComplex Ab.{u}).mapIso (homCechSectionCosimplicialIso 𝒰 F)
```

This is `Functor.mapIso` applied to `alternatingCofaceMapComplex`, not `HomologicalComplex.Hom.isoOfComponents`. (Note: `HomologicalComplex.Hom.isoOfComponents` IS used in `FreePresheafComplex.lean` for `cechFreeEvalEngineIso` — just not here.) The discrepancy will mislead any contributor reading the strategy block to understand `cechComplex_hom_identification`.

**Required action:** Update the strategy block to accurately describe the shipped approach. The description of `(alternatingCofaceMapComplex Ab).mapIso (homCechSectionCosimplicialIso 𝒰 F)` should replace the incorrect `isoOfComponents` claim.

---

### J2 — Stale "gated on Lane-1" language in `CechBridge.lean`

**File:** `CechBridge.lean`, lines 272–283  
**Severity:** Major (stale status description)

The comment block around `injective_cech_acyclic` contains:

> "The injective-acyclicity assembly (`lem:injective_cech_acyclic`, gated on Lane-1's `cechFreeComplex_quasiIso`) needs `homCechComplex 𝒰 F`..."

`injective_cech_acyclic` is now proved and axiom-clean (iter-025). `cechFreeComplex_quasiIso` is also proved and axiom-clean (iter-022/FreePresheafComplex). The "gated on Lane-1" language is no longer accurate and describes a closed dependency as open.

**Required action:** Update the comment to reflect the proved status. Strike or replace the "gated on" language.

---

## Minor

### N1 — `hasExtModules` local-instance scoping undocumented

**File:** `AbsoluteCohomology.lean`, line 25  
**Severity:** Minor

`noncomputable local instance hasExtModules : HasExt.{u + 1, u, u + 1} X.Modules` is correctly `local` to avoid slow `HasSmallLocalizedHom` search (the docstring says so). However, the docstring does not warn downstream importers that they will NOT inherit this instance. Any future file that imports `AbsoluteCohomology.lean` and calls `Ext` on `X.Modules` objects will need its own `HasExt` resolution (via `haveI`, `letI`, or a global instance of their own).

**Required action (optional):** Add one sentence to the docstring: "Downstream importers must supply their own `HasExt` instance on `X.Modules` if needed."

---

### N2 — `erw` in `sheafificationHomAddEquiv` is fragile

**File:** `AbsoluteCohomology.lean`, lines 47–48  
**Severity:** Minor

```lean
erw [Functor.map_add, Preadditive.comp_add]
rfl
```

The `erw` is correct — after `simp only [Equiv.toFun_as_coe, Adjunction.homEquiv_unit]`, the goal contains functor-application forms that don't syntactically match `Functor.map_add`'s LHS, requiring `erw`'s up-to-defeq rewriting. The proof is technically valid. However, `erw` at this position creates a fragility point: Mathlib refactors of `Adjunction.homEquiv_unit` or the sheafification adjunction API could break the `rfl` step. A `congr 1` or a more explicit term could be more robust long-term.

**Required action:** None for this iteration. Flag for revisiting if a future Mathlib bump breaks this proof.

---

## Excuse-comments

**Count: 0**

No excuse-comments were found in any file. All `sorry` occurrences are:
- `CechAcyclic.affine` — known L1 gap, accompanied by an accurate strategy description
- `cech_computes_higherDirectImage` — protected target theorem with frozen signature

All `-- Dead-end note:`, `-- Note:`, and `/-! ### P4 complete`:
- are accurate status markers or legitimate technical notes
- do not apologize for incomplete work or overstate what is proved

The `## Why I stopped` reference in `HigherDirectImagePresheaf.lean` is in a module docstring pointing to a task result, not in proof code.

---

## Severity summary

| Severity | Count | Items |
|----------|-------|-------|
| Must-fix-this-iter | 1 | M1: Root import missing |
| Major | 2 | J1: CechBridge strategy wrong combinator; J2: stale "gated on Lane-1" |
| Minor | 2 | N1: local-instance undocumented; N2: erw fragility |
| Excuse-comments | 0 | — |

---

## Final verdict

**One must-fix**: add `import AlgebraicJacobian.Cohomology.AbsoluteCohomology` to `AlgebraicJacobian.lean` — without it the entire P5b output is orphaned from the build. The `AbsoluteCohomology.lean` code itself is clean: 10 declarations, no `sorry`, no weakening, no excuse-comments. The two major findings are documentation-only (stale strategy text in `CechBridge.lean`) and carry no correctness risk to the proofs. `FreePresheafComplex.lean` is fully axiom-clean with no findings.
