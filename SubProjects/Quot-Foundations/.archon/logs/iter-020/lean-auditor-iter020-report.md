# Lean Auditor Report — iter-020

**Project:** Quot-Foundations  
**Date:** 2026-06-06  
**Auditor:** lean-auditor subagent  
**Scope:** All 7 `.lean` source files under `AlgebraicJacobian/` (excluding `.lake/` and `.archon/`)

---

## Per-file checklist

### 1. `AlgebraicJacobian.lean` (5 lines) — ✅ CLEAN

Five top-level `import` lines. No declarations, no `sorry`, no comments. No issues.

---

### 2. `AlgebraicJacobian/Cohomology/RegroupHelper.lean` (99 lines) — ✅ CLEAN

Single export: `base_change_regroup_linearEquiv` — the `R'`-linear equivalence
`(A ⊗[R] R') ⊗[A] M ≃ₗ[R'] R' ⊗[R] M`. Proof is complete
(`TensorProduct.induction_on` + `cancelBaseChange` composite). No `sorry`. Axiom-clean
(`propext`, `Quot.sound` only). Docstring accurately describes the construction.

---

### 3. `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (1723 lines) — ✅ HONEST SCAFFOLDING

**Fully read.** Four `sorry` nodes, all in the mate-unwinding crux chain. All four carry
detailed, actionable, honest scaffolding comments.

| Lines | Declaration | Sorry? | Comment quality |
|-------|-------------|--------|-----------------|
| ~1–778 | `pushforwardBaseChangeMap`, locality lemmas, `pullback/pushforward_spec_tilde_iso`, `gammaPushforward*` | No | Complete, correct |
| 779–826 | `base_change_mate_codomain_read` | No | Complete |
| 827–964 | `base_change_mate_regroupEquiv` | No | Status comment line 845 says "fully proved, no sorry" — matches reality ✓ |
| 965–1093 | `base_change_mate_unit_value` | No | Complete; long conjugate-unit proof, no sorry |
| 1095–1133 | `base_change_mate_inner_value` | No | Complete |
| 1135–1161 | `pullbackPushforward_unit_comp` | No | Complete |
| 1163–1200 | `gammaMap_pushforwardComp_*`, `gammaMap_pushforwardCongr_hom` | No | Complete |
| 1202–1258 | `base_change_mate_codomain_read_legs` | No | Complete |
| 1260–1321 | `base_change_mate_fstar_reindex_legs_unitExpand`, `…_gammaDistribute` | No | Complete (new iter-019 standalone lemmas) |
| **1333–1421** | **`base_change_mate_fstar_reindex_legs`** | **Yes (line 1421)** | Honest: iter-019 UPDATE names the new lemmas and explains the "literal-form lock" BLOCKER preventing their use after `subst`. Specifies the exact refactor needed. |
| 1423–1480 | `base_change_mate_fstar_reindex` | No (delegates to `…_legs`) | Accurately describes the structure; notes crux is in the legs version |
| **1490–1525** | **`base_change_mate_gstar_transpose`** | **Yes (line 1525)** | Honest: "REMAINING — the pullback-dictionary coherence" with `pullback_spec_tilde_iso ψ` / counit naturality named. |
| 1527–1567 | `base_change_mate_section_identity` | No (propagates gstar sorry) | Docstring says "With it discharged, `base_change_mate_generator_trace` is a one-line corollary" — correctly implies sorry present |
| 1569–1641 | `base_change_mate_generator_trace`, `pushforward_base_change_mate_cancelBaseChange` | No (propagate chain) | Accurate |
| **1655–1698** | **`affineBaseChange_pushforward_iso`** | **Yes (line 1698)** | Honest: "WHAT REMAINS HERE" block names the affine-restriction compatibility step with precise Mathlib gap. |
| **1700–1720** | **`flatBaseChange_pushforward_isIso`** | **Yes (line 1720)** | Honest: describes Čech-cohomology infrastructure gap, deferred to later iteration. |

**No stale comments. All sorry-bearing blocks have honest scaffolding.**

---

### 4. `AlgebraicJacobian/Picard/FlatteningStratification.lean` (1901 lines) — ✅ HONEST SCAFFOLDING

**Fully read.** Three `sorry` nodes:

| Lines | Declaration | Sorry? | Comment quality |
|-------|-------------|--------|-----------------|
| 1–753 | GenericFreeness ladder L1–L3, L4a, L4 body | Mostly complete | — |
| **754** | **`exists_localizationAway_finite_mvPolynomial` (L4 finiteness leaf)** | **Yes** | Honest: comment 739–754 says "FINITENESS (remaining leaf)" and describes exact missing piece. *Known per directive — not re-flagged.* |
| 755–1629 | Nagata normalisation, `mvPolynomial_quotient_finite_of_monic_lastVar`, splice lemmas, `exists_free_localizationAway_polynomial` | No | Complete |
| **1810** | **`genericFlatnessAlgebraic` — `N ≅ B/𝔭` branch** | **Yes** | Honest: comment 1803–1806 names L4+L5 as the outstanding pieces and says "L4 finiteness leaf open, so this node stays sorry". Docstring 1758–1766 also accurate. |
| **1898** | **`genericFlatness` (GF-geo)** | **Yes** | Honest: comment 1871–1897 gives a multi-step assembly plan naming `genericFlatnessAlgebraic`, quasi-compactness cover, product-localisation witness, and `Module.Flat.of_free`. *Known open per directive — not re-flagged.* |

**No stale comments. All sorry-bearing blocks have honest scaffolding.**

---

### 5. `AlgebraicJacobian/Picard/QuotScheme.lean` (1696 lines) — ⚠️ 1 MAJOR STALE COMMENT

**Fully read** (lines 1–1696).

**Known skeleton stubs at lines ~126/165/201/228** (`hilbertPolynomial`, `QuotFunctor`,
`Grassmannian`, `Grassmannian.representable` — all `:= sorry`). Not re-flagged per directive.

**New this iter:**

- `iSupIndep_map_of_mem_ker_sup` (lines 1462–1479) — private helper, **complete**. Proof via
  `iSupIndep_def` / `Submodule.disjoint_def`. No `sorry`. Correct.

- `subquotient_base_eventuallyZero` (lines 1486–1611) — **complete, no sorry anywhere**.
  Proof uses the new helper at `hindep` (line 1520), then drives the full induction through a
  detailed membership argument (lines 1521–1589). Closes cleanly.

**MAJOR STALE COMMENT — lines 1510–1519** (inside `subquotient_base_eventuallyZero`, before
`have hindep`):

```lean
-- (RESIDUAL LEAF — the only `sorry` in the QUOT keystone chain). For each `n`,
-- `Disjoint (range (ψ n)) (⨆ j ≠ n, range (ψ j))`: the degree-`n` projection ...
-- OBSTRUCTION: building the κ-linear `Φ` *out of* the `MvPolynomial (Fin 0) κ`-quotient `Q`
-- via `Submodule.liftQ` clashes on the scalar ring (S = `MvPolynomial (Fin 0) κ` vs κ); the
-- math is complete, only the `restrictScalars`/quotient-ring plumbing remains.
```

This comment is **factually wrong**:
- The proof at line 1520 onward is complete; there is no `sorry` here.
- The leaf is not "residual"; it was closed this iter by `iSupIndep_map_of_mem_ker_sup` via
  ROUTE (b) (the helper maps through the ambient `M` rather than the quotient `Q`, bypassing
  the scalar-ring mismatch the comment calls an "OBSTRUCTION").
- The phrase "the only sorry in the QUOT keystone chain" is now false.

**Recommended fix:** delete lines 1510–1519 (the entire stale comment block). The proof below
is self-documenting.

**Remaining declarations** (lines 1613–1694):

- `subquotient_hilbertSeries_rational` — complete induction, no sorry. ✓
- `gradedModule_hilbertSeries_rational` — complete. ✓

---

### 6. `AlgebraicJacobian/Picard/RelativeSpec.lean` (~293 lines) — ✅ CLEAN

`QcohAlgebra`, `RelativeSpec`, `RelativeSpec.structureMorphism`, `RelativeSpec.UniversalProperty`,
`RelativeSpec.affine_base_iff` — all complete, no `sorry`. Historical comment at line 22 (iter-177
block-A fix) is accurate narrative. No issues.

---

### 7. `AlgebraicJacobian/Picard/GrassmannianCells.lean` (~635 lines) — ✅ CLEAN

`affineChart`, `universalMatrix`, `minorDet`, `universalMinor`, `isUnit_det_universalMinor`,
`universalMinorInv`, `universalMinorInv_mul_cancel`, `imageMatrix`, `transitionPreMap`,
`transitionMap`, `transitionMap_self`, `cocycleΘIJ`, `cocycleΘJK`, `cocycleΘIK`,
`cocycleCondition` — all complete, no `sorry`. Well-structured. No issues.

---

## Must-fix (correct but unsound / blocks downstream)

**None.**

---

## Major issues

### M-1 — Stale "RESIDUAL LEAF / OBSTRUCTION" comment in QuotScheme.lean

**File:** `AlgebraicJacobian/Picard/QuotScheme.lean`  
**Lines:** 1510–1519  
**Declaration context:** `subquotient_base_eventuallyZero` proof body, before `have hindep`

The comment describes a `sorry` that no longer exists. The leaf was closed this iter by
`iSupIndep_map_of_mem_ker_sup` (route b). The "OBSTRUCTION" paragraph describes a problem that was
circumvented. The phrase "the only sorry in the QUOT keystone chain" is false.

**Impact:** Any reader or future prover landing on this comment will believe there is an open goal
when there is not. If a future iter's directive targets "close the QUOT keystone residual leaf" it
will waste time looking for a sorry that doesn't exist.

**Fix:** Delete lines 1510–1519.

---

## Minor issues

**None.**

---

## Excuse-comments

**None found.** Every sorry in the codebase carries a comment that:
1. Names the specific missing mathematical or Lean infrastructure;
2. Identifies the relevant Mathlib lemma or construction that would close it (or explains why it
   is absent from Mathlib); and
3. Either names the next step concretely or defers the node explicitly to a later iteration.

---

## New work this iter — verification

| Item | Status | Notes |
|------|--------|-------|
| `iSupIndep_map_of_mem_ker_sup` (QuotScheme.lean:1462–1479) | ✅ Complete | Clean private helper using `iSupIndep_def` + `Submodule.disjoint_def` |
| `subquotient_base_eventuallyZero` base-case leaf closure | ✅ Complete | No sorry, proof closes via the new helper |
| `genericFlatnessAlgebraic` dévissage motive + subsingleton + short-exact obligations | ✅ 2 of 3 closed | `N ≅ B/𝔭` node remains sorry (known, per directive) |
| `base_change_mate_fstar_reindex_legs_unitExpand` | ✅ Complete | New iter-019/020 standalone lemma, no sorry |
| `base_change_mate_fstar_reindex_legs_gammaDistribute` | ✅ Complete | New iter-019/020 standalone lemma, no sorry |

---

## Severity summary

| Severity | Count | Items |
|----------|-------|-------|
| Must-fix | 0 | — |
| Major | 1 | QuotScheme.lean:1510–1519 stale "RESIDUAL LEAF/OBSTRUCTION" comment |
| Minor | 0 | — |
| Excuse-comments | 0 | — |

---

iter020: sound with 1 stale comment — 7 files audited (all fully), 1 issue (critical/major/minor: 0/1/0)
