# Lean Auditor Report — iter-017

**Date:** 2026-06-06  
**Auditor:** lean-auditor subagent  
**Project:** Quot-Foundations  
**Scope:** All `.lean` source files under `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/`  
**Focus files:** `FlatBaseChange.lean`, `FlatteningStratification.lean`, `QuotScheme.lean`

---

## Per-file checklists

### 1. `AlgebraicJacobian.lean` (6 lines)

| Check | Result |
|-------|--------|
| Imports only, no declarations | PASS |
| No `sorry`, no `axiom` | PASS |
| No excuse-comments | PASS |

**Verdict:** Clean import spine. No issues.

---

### 2. `AlgebraicJacobian/Cohomology/RegroupHelper.lean`

| Check | Result |
|-------|--------|
| No `sorry` | PASS |
| No `axiom` | PASS |
| No excuse-comments | PASS |
| `base_change_regroup_linearEquiv` body is genuine | PASS — full proof via `TensorProduct.induction_on` |
| Instance-diamond isolation rationale present | PASS — standalone module to avoid cross-import diamond |

**Verdict:** Clean. Axiom-free. Full proofs.

---

### 3. `AlgebraicJacobian/Picard/RelativeSpec.lean`

| Check | Result |
|-------|--------|
| No `sorry` bodies (not in comments) | PASS — `grep -n '^\s*sorry\b'` returns empty |
| No `axiom` | PASS |
| No excuse-comments | PASS |
| History comments in module doc are informational, not excuse-comments | PASS — provenance narrative describes iter-173–179 evolution; no live declaration has a "this would be X but..." comment |

**Verdict:** Clean. All declarations (`QcohAlgebra`, `RelativeSpec`, `structureMorphism`, `UniversalProperty`, etc.) have genuine bodies from iter-179 Block A.

---

### 4. `AlgebraicJacobian/Picard/GrassmannianCells.lean`

| Check | Result |
|-------|--------|
| No `sorry` | PASS |
| No `axiom` | PASS |
| No excuse-comments | PASS |
| `affineChart`, `universalMatrix`, `minorDet`, etc. have genuine bodies | PASS |
| `cocycleCondition` (line ~604) fully proved | PASS — non-trivial proof present |

**Verdict:** Clean. All 635 lines are fully proved.

---

### 5. `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (1626 lines) — FOCUS FILE

#### 5a. Iter-017 new/modified items

**`base_change_mate_codomain_read` body refactor (line ~773)**

The `obtain` pattern has been replaced by `.1`/`.2` projections:
```lean
have hfst := (Iso.inv_comp_eq e).mp (pullback_fst_snd_specMap_tensor ψ φ).1
have hsnd := (Iso.inv_comp_eq e).mp (pullback_fst_snd_specMap_tensor ψ φ).2
```
The accompanying comment explains this avoids a stuck `And.casesOn` in downstream `exact` unifications. **This is a genuine refactor, not a weakening.** The type of `base_change_mate_codomain_read` is unchanged.

**New private lemmas**

| Lemma | Line | Body |
|-------|------|------|
| `gammaMap_pushforwardComp_hom_eq_id` | ~1174 | `rfl` + `(moduleSpecΓFunctor R).map_id _`. Genuine. |
| `gammaMap_pushforwardComp_inv_eq_id` | ~1182 | Same pattern. Genuine. |
| `gammaMap_pushforwardCongr_hom` | ~1193 | `subst hfg` + `simp`. Genuine. |
| `base_change_mate_codomain_read_legs` | ~1210 | Variable-legs abstraction; full proof body (no sorry). Genuine. |
| `base_change_mate_fstar_reindex_legs` | ~1270 | Steps (i)–(ii) proved; step (iii) has one honest sorry (see below). |

**`base_change_mate_fstar_reindex` (line ~1338)**  
Top-level body is `exact base_change_mate_fstar_reindex_legs ψ φ M _ _ hfst hsnd ...`. No sorry in the top-level body itself. The sorry lives in `_legs`; its location is accurately documented in STATUS.

#### 5b. `set_option maxHeartbeats` audit

| Location | Value | Justification in comment |
|----------|-------|--------------------------|
| Line ~979 | `4000000` | `base_change_mate_unit_value`: chains several `erw` defeq-unifications and a `simp` closure that exceed the default budget. |
| Line ~1260 | `1600000` | `base_change_mate_fstar_reindex_legs`: `subst`-heavy motive dissolution. |
| Line ~1328 | `1600000` | `base_change_mate_fstar_reindex`: `exact`-onto-`_legs` reduction unfolds two large change-of-rings dictionaries. |

All three bumps are accompanied by explanatory comments. None of the values are suspiciously large (≤4M). No infinite-loop masking pattern detected.

#### 5c. Sorry inventory

| Line | Declaration | Classification |
|------|-------------|----------------|
| 1324 | `base_change_mate_fstar_reindex_legs` | **Seam-2 crux** — mate-unwinding coherence over generic pullback square; Mathlib-absent (known, honest). |
| 1428 | `base_change_mate_gstar_transpose` | **Seam-3** remaining (known, honest). |
| 1601 | `affineBaseChange_pushforward_iso` | Affine-reduction obligation (known, honest). |
| 1623 | `flatBaseChange_pushforward_isIso` | FBC-B (known, honest). |

Total: 4 sorries. All accounted for by prior-iter STATUS documentation. None are new.

#### 5d. Excuse-comments / stale STATUS blocks

Lines ~184–247 contain multi-paragraph STATUS blocks labeling iter-234/236/240/241 provenance. These are stale iteration numbers (this is iter-017 of the extracted sub-project; the numbers are from the parent repo). This is a known issue first noted in iter-011. The comments are provenance noise, not excuse-comments (they do not apologize for a broken body or claim a sorry will be fixed "next iter"). **Minor, pre-existing.**

**Verdict:** All iter-017 changes verified. 4 honest sorries (all known). No fake bodies. No axioms. No excuse-comments. Heartbeat bumps justified.

---

### 6. `AlgebraicJacobian/Picard/FlatteningStratification.lean` (1628 lines) — FOCUS FILE

#### 6a. `gf_torsion_reindex` signature change (line ~1026)

**Before (pre-017):** 7 existentials including a redundant `∃ (_ : Module A_g T_g)` binder that created an `OreLocalization` instance-presentation diamond.

**After (iter-017):** 6 existentials. The redundant `Module A_g T_g` binder has been dropped. The comment at line ~1452 explains: "the redundant `Module A_g T_g` existential was dropped, so the `A_g`-action the IH and `free_localizationAway_of_away_tower` synthesise is exactly the one `htower` refers to. This dissolves the former `OreLocalization` instance-presentation diamond."

**This is a simplification, not a weakening.** The conclusion (`Module.Finite (MvPolynomial (Fin m') (Localization.Away g)) (LocalizedModule (Submonoid.powers g) T)`) is unchanged. The dropped binder was redundant (synthesizable from the retained hypotheses). Callers of `gf_torsion_reindex` no longer need to supply the redundant `Module` witness.

#### 6b. `exists_free_localizationAway_polynomial` (L5, line ~1391) — CLOSED

- `grep -n '^\s*sorry\b'` returns no match in this function's span.
- Body uses strong induction on `d`, with:
  - Base case `d = 0`: delegates to `exists_free_localizationAway_of_finite`.
  - Inductive step (torsion branch): calls `gf_torsion_reindex`, IH, `free_localizationAway_of_away_tower`, `exists_free_localizationAway_of_shortExact`.
  - Inductive step (non-torsion branch): calls `gf_generic_rank_ses` and IH.
- **L5 is genuinely closed (no sorry).**

Note: L4 (`exists_localizationAway_finite_mvPolynomial`, line ~486) still has a sorry at line ~516 ("Mathlib-absent residue: denominator clearing"). L5 does **not** depend on L4 directly. L4 is consumed only by `genericFlatnessAlgebraic`'s surviving-residue branch.

#### 6c. Sorry inventory

| Line | Declaration | Classification |
|------|-------------|----------------|
| 516  | `exists_localizationAway_finite_mvPolynomial` (L4) | Mathlib-absent denominator-clearing lemma (known, honest). |
| 1558 | `genericFlatnessAlgebraic` | Surviving-residue branch; depends on L4 (known, honest). |
| 1625 | `genericFlatness` | GF-geo (known, honest). |

Total: 3 sorries. All pre-existing. No new sorries introduced.

#### 6d. Heartbeat / synthInstance settings

| Location | Setting | Value | Justification |
|----------|---------|-------|---------------|
| Lines ~1015, ~1253, ~1374 | `synthInstance.maxHeartbeats` | `1000000` | Deep instance search in doubly-indexed polynomial ring localisations. |
| Line ~1018 | `maxHeartbeats` | `4000000` | Elaboration of `Module.Finite Qf Tg'` localisation chain. |

All justified. No masking pattern.

**Verdict:** Signature simplification confirmed (not weakening). L5 genuinely closed. 3 honest pre-existing sorries. No axioms.

---

### 7. `AlgebraicJacobian/Picard/QuotScheme.lean` (898 lines) — FOCUS FILE

#### 7a. New declarations — `namespace AlgebraicGeometry.GradedModule section Subquotient`

13 declarations added (lines ~691–892). Full inventory:

| # | Name | Kind | Line | Body |
|---|------|------|------|------|
| 1 | `RaisesDegree` | def | ~700 | `∀ n, (ℳ n).map x ≤ ℳ (n + 1)`. Definitional. |
| 2 | `RaisesDegree.mem` | lemma | ~703 | `omit [DirectSum.Decomposition ℳ]`; membership form. Genuine proof. |
| 3 | `subquotientHilb` | def | ~711 | `(dim(N ⊓ ℳ n) - dim(N' ⊓ ℳ n) : ℤ) : ℚ`. Definitional. |
| 4 | `decompose_raisesDegree` | lemma | ~719 | Degree-shift commutation; genuine proof. |
| 5 | `comap_isHomogeneous` | lemma | ~735 | Preimage of homogeneous submodule; genuine proof. |
| 6 | `decompose_raisesDegree_zero` | lemma | ~743 | Degree-zero component is zero; genuine proof. |
| 7 | `map_isHomogeneous` | lemma | ~755 | Image of homogeneous submodule; genuine proof. |
| 8 | `map_inf_degree_eq` | lemma | ~767 | `N.map x ⊓ ℳ (n+1) = (N ⊓ ℳ n).map x`; genuine proof via `le_antisymm`. |
| 9 | `sup_inf_degree_eq` | lemma | ~783 | Distributive law for graded pieces; genuine proof. |
| 10 | `inf_isHomogeneous` | lemma | ~803 | Intersection of homogeneous submodules; genuine proof. |
| 11 | `sup_isHomogeneous` | lemma | ~812 | Sum of homogeneous submodules; genuine proof. |
| 12 | `finrank_comap_subtype` | private lemma | ~827 | `finrank(comap p.subtype S) = finrank(p ⊓ S)`; genuine proof. |
| 13 | `subquotient_degreewise_diff` | lemma | ~840 | D6 — degreewise difference identity; genuine proof via `omega`. |

**No `axiom` usage** found in any of these declarations.  
**No fake/tautological bodies**: tactics used include `omega`, `le_antisymm`, `iSup_le`, `inf_le_right`, `Submodule.map_comap_eq_of_le`, etc.  
**`omit [DirectSum.Decomposition ℳ]`** at lines ~698 and ~706: legitimate Lean 4 syntax to suppress an unused variable-block instance for `lt_up` and `RaisesDegree.mem`. Standard pattern.  
**Ambient-M formulation**: all bodies are stated in `M` (not `↥p`), consistent with the `graded-quotient-module-isdefeq-pathology` memory record avoiding elaborator loops.

#### 7b. Pre-existing sorry stubs (unchanged)

| Line | Declaration | Classification |
|------|-------------|----------------|
| 126  | `hilbertPolynomial` | Protected scaffold — file-skeleton typed sorry (iter-176). |
| 165  | `QuotFunctor` | Protected scaffold — file-skeleton typed sorry (iter-176). |
| 201  | `Grassmannian` | Protected scaffold — file-skeleton typed sorry (iter-176). |
| 228  | `Grassmannian.representable` | Protected scaffold — file-skeleton typed sorry (iter-176). |

All 4 are pre-existing and documented with explicit "file-skeleton" comments.

#### 7c. Other declarations (pre-existing, spot-checked)

- `SheafOfModules.IsLocallyFreeOfRank` (line ~253): Clean.
- `Scheme.Modules.annihilator` (line ~298): Clean.
- `annihilator_isLocalizedModule_eq_map` (line ~362): Full proof, no sorry.
- Hilbert-Serre rationality lemmas (`coeff_invOneSubPow_one_mul`, `rationalHilbert_antidiff`, `IsRatHilb.*`, `IsRatHilb.ofDiffEq`): All private, all fully proved.
- `GradedModule.G1.*` lemmas: Full proofs.
- `GradedModule.degreewise_finrank_diff` (D5): Full proof via `omega`.

**Verdict:** 13 new Subquotient declarations are all genuine. No axioms. No fake bodies. `omit` usage legitimate. 4 pre-existing protected sorry stubs unchanged.

---

## Must-fix-this-iter

**None.**

No declaration has a fake/weakened body. No axiom is used. No sorry was introduced outside of known, documented scaffolding locations.

---

## Major

**None.**

The stale STATUS blocks in `FlatBaseChange.lean` (lines ~184–247, iter-234/236/240/241 numbers) are provenance noise previously classified as pre-existing in iter-011. They remain unchanged this iteration. They are not excuse-comments (no live declaration has a "this body is wrong because..." comment). No escalation needed.

---

## Minor

1. **`FlatBaseChange.lean` stale STATUS comments** (lines ~184–247): Iteration numbers reference the parent repo numbering (iter-234 etc.) rather than the sub-project numbering (iter-017). Cosmetically confusing but harmless. Pre-existing since iter-011. Low priority cleanup.

2. **`FlatBaseChange.lean` Seam-2 sorry still open** (line ~1324, `base_change_mate_fstar_reindex_legs`): Iter-017 made structural progress (introduced `_legs` and dissolved the motive wall via `subst`), but the mate-unwinding crux at step (iii) remains. This is the expected outcome per the directive. Not a regression.

---

## Excuse-comments

**None found.**

No declaration in any file contains a comment that apologizes for an incorrect body, promises a fix in the next iteration without providing it, or describes a sorry as "temporary" without a documented technical blocker.

---

## Severity summary

| Severity | Count | Items |
|----------|-------|-------|
| Must-fix | 0 | — |
| Major | 0 | — |
| Minor | 2 | Stale STATUS numbers (pre-existing); Seam-2 open (expected) |
| Excuse-comments | 0 | — |

---

## Overall verdict

**PASS — no blocking issues.**

All iter-017 changes are structurally sound:

- The `.1`/`.2` refactor in `base_change_mate_codomain_read` is genuine and necessary for downstream definitional equality.
- The 5 new private lemmas in `FlatBaseChange.lean` are axiom-free with genuine proofs (one honest sorry in `_legs` step-iii, correctly labeled).
- `gf_torsion_reindex` signature simplification is a correct narrowing of the existential package, not a weakening.
- `exists_free_localizationAway_polynomial` (L5) is genuinely closed — no sorry.
- The 13 new `GradedModule.Subquotient` declarations in `QuotScheme.lean` all have genuine proofs; `omit` usage is legitimate.
- Sorry count across the project: FlatBaseChange 4, FlatteningStratification 3, QuotScheme 4 (protected scaffolds). All 11 are documented honest scaffolding. Zero new sorries introduced this iteration.
- Heartbeat bumps in all three focus files have justified explanatory comments and are within reasonable bounds.

The project is in good structural health for iter-017 handoff.
