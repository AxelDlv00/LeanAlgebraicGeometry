# blueprint-clean report — iter-031

**Scope:** Three chapters edited this iteration:
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
- `blueprint/src/chapters/Picard_GrassmannianCells.tex`
- `blueprint/src/chapters/Picard_QuotScheme.tex`

**Verdict: PASS — all chapters are now purity-clean.**

---

## Summary of findings and fixes

### Picard_QuotScheme.tex

**1 fix applied.**

| Location | Issue | Fix |
|----------|-------|-----|
| Line 407 (`% NOTE` comment) | Text read "As of iter-020 the present theorem IS a closed, axiom-clean Lean…" — project history reference. | Removed `iter-020`; rewritten: "the present theorem is a closed, axiom-clean Lean declaration". |

**New 6-block over-site/open-subspace sheaf equivalence sub-section** (lines ~2875–3007, bridge C topological layer): all labels and cross-references verified clean. Labels present:
`lem:opens_overEquivalence_mathlib`, `lem:equivalence_sheafCongr_mathlib`, `lem:pushforwardPushforwardEquivalence_mathlib`, `lem:overEquivalence_functor_isCocontinuous`, `lem:overEquivalence_inverse_isCocontinuous`, `lem:overEquivalence_inverse_isDenseSubsite`, `lem:overEquivalence_functor_isContinuous`, `lem:overEquivalence_inverse_isContinuous`, `def:overEquivalence_sheafCongr`, `lem:over_restrict_iso`. No dangling `\ref{}`/`\cref{}` in prose.

Apparent "missing" refs (`lemma-graded-module-fg`, `lemma-numerical-polynomial`, `schemes-lemma-f-open`) are exclusively inside `%` Stacks source-quote comment lines — not real broken references. ✓

---

### Cohomology_FlatBaseChange.tex

**6 fixes applied.**

**Old-name check:** Strings `_link_distribute` and `_link_collapseComp` do NOT appear anywhere in this chapter. The merged name `_link_distributeCollapse` (`lem:base_change_mate_fstar_reindex_legs_link_distributeCollapse`) is present and correct. ✓

| # | Location | Issue | Fix |
|---|----------|-------|-----|
| 1 | Lines 1678–1689 (plain `%` comment block) | Unlabeled bare `%` comment describing Lean instance-diamond mechanics; contained raw tactic names (`rw`, `simp`, `erw`, `conv`, `set`) in prose position. | Converted to `% NOTE:` block; removed raw tactic names; retained implementation-intent content. |
| 2 | Lines ~2330–2339 (`% LEAN INTERNAL:` comment) | Non-standard comment label `% LEAN INTERNAL:` not in the allowed vocabulary. | Converted to `% NOTE:` block. |
| 3 | Proof of `lem:base_change_mate_fstar_reindex_legs_link_cancelEUnit` (~lines 1770–1779) | Proof prose: "The cancellation cannot be performed by an in-place rewrite", "no keyed rewrite of factor 2 fires" — prover-implementation language. | Removed these clauses; retained the mathematical description of whiskering/congruence. |
| 4 | Proof of `lem:base_change_mate_fstar_reindex_legs_link_cancelPullbackComp` (~line 1804) | Proof prose: "the same transport layer forbids a keyed rewrite of factor 3, so the atom is grafted in by whiskering:". | Removed the "forbids a keyed rewrite" clause; retained "The atom is grafted in by whiskering:". |
| 5 | Proof of `lem:base_change_mate_fstar_reindex` (~lines 2300–2310) | Proof prose: "(the factors agree mathematically but differ in hidden index data, so head-symbol matching fails)" and "rather than by matching its head symbol". | Removed both parenthetical and head-symbol clause; rewritten to say "against which the atoms are inapplicable". |
| 6 | Proof of `lem:base_change_mate_inner_eCancel_assemble` (~lines 2372–2402) | Two paragraphs with heavy Lean leakage: "head-symbol cancellation", "definitional-equality-tolerant cancellation exhausts the reduction budget", "single-factor surgery in term mode", "goal's Γ∘(Spec φ)_* form". | Rewrote as **"The residual object-form diamond"** (nested-image vs composed-functor object presentations are definitionally but not syntactically equal) and **"The resolution: congruence lifting"** (factor identities promoted one neighbour at a time by congruence, chained, closed on the definitional bridge). Mathematical content fully preserved. |

Cross-reference validation: all apparent "missing" refs (`cohomology-lemma-base-change-map-flat-case`, `equation-base-change-diagram`, etc.) are exclusively inside `%` Stacks source-quote comment lines — not real broken references. All 60 `\label{}` definitions properly used. ✓

All existing `% SOURCE` blocks have their `% SOURCE QUOTE:` verbatim text. ✓

---

### Picard_GrassmannianCells.tex

**0 fixes needed. Chapter is clean.**

- `lem:gr_cocycle_phi_id` (line 1457): present, correctly labeled, content is the rotated triple-overlap ring cocycle identity Φ=id. Its `\uses{}` (`def:gr_cocycle_theta_ij`, `def:gr_away_mul_comm_equiv`, `lem:gr_cocycle_imageMatrix_eq`, `lem:gr_cocycle`) — all labels present in this file. ✓
- `def:gr_glued_scheme` (line 1494): `\uses{}` includes `lem:gr_cocycle_phi_id`. ✓
- Lines 1430–1432: `% NOTE` comment containing `erw`/`exact` — already properly labeled as `% NOTE`, acceptable. ✓
- No Lean tactic leakage in proof prose. ✓
- No old names present. ✓
- Zero dangling `\ref{}`/`\cref{}` in prose. ✓

---

## Global checks

| Check | Result |
|-------|--------|
| Old names `_link_distribute` / `_link_collapseComp` in FlatBaseChange | ABSENT ✓ |
| All `\ref{}`/`\cref{}` in prose resolve to `\label{}` | PASS ✓ |
| All `% SOURCE` blocks have `% SOURCE QUOTE:` | PASS ✓ |
| `\leanok` not added or removed | CONFIRMED ✓ |
| Mathematical statements not altered | CONFIRMED ✓ |
| Project/iteration history strings (`iter-NNN`, "this iter") | REMOVED ✓ |
| Lean tactic names in proof prose (outside `% NOTE`) | REMOVED ✓ |
