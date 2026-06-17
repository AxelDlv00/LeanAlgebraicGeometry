# Blueprint Review Report

## Slug
ts215fp3

## Iteration
215

## Scope
Scoped re-review of `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` only — fast-path gate-clearing pass #3.

## Gate Verdict: NOT-CLEARED

Two residual unqualified off-path claims survive the five plan-agent fixes. Both must be corrected before the gate clears.

---

## Residual must-fix items

### Must-fix A — visible text, lines 1349–1351 (`sec:tensorobj_invertibility`)

**Exact text:**

> "The inverse of an invertible object is carried by the predicate itself, so neither the open-immersion restriction-compatibility isomorphism \cref{lem:tensorobj_restrict_iso} nor a separate tensor-inverse lemma is on the critical path."

**Problem:** This sentence is unqualified — it does not carry the "under route~(e) only" qualifier. Under the PRIMARY locally-trivial route `restrict_iso` IS on the critical path (consumed by the PRIMARY proof of `lem:islocallyinjective_whisker_of_W`), and `lem:tensorobj_inverse_invertible` IS in the `\uses` of `lem:tensorobj_isoclass_commgroup` (confirmed at consistency-check lines 1800–1803, which correctly say both are on the critical path). The intro paragraph of `sec:tensorobj_invertibility` therefore directly contradicts both the consistency-check section already fixed in ts215fp2 and the `sec:tensorobj_onproduct_lift` intro already fixed in ts215fp2 (must-fix 1 of that round). This location was NOT in the five fix locations applied by the plan agent and is still stale.

**Required fix:** Add "Under route~(e)," (or equivalent "under the route-(e) fallback,") before the claim, so it reads as route-(e)-scoped. The sentence should also acknowledge that under the PRIMARY route both are on the critical path, consistent with lines 1800–1803.

---

### Must-fix B — `% NOTE:` comment, line 1187 (`lem:tensorobj_inverse_invertible`)

**Exact text:**

```
% NOTE: off the critical path for the relative Picard group law. The group
% law uses the tensor-invertibility predicate IsInvertible
% (def:scheme_modules_isinvertible), which carries the inverse existentially,
% so no separate ``a tensor inverse exists'' lemma is required. Retained only
% as a supplement on the geometric line-bundle subcategory.
```

**Problem:** This `% NOTE:` states `lem:tensorobj_inverse_invertible` is "off the critical path for the relative Picard group law" — unqualified, no route-(e) scope. The consistency-check section (lines 1800–1803), which fix #5 from the plan agent addressed, now correctly says the opposite: `lem:tensorobj_inverse_invertible` (in the `\uses` of `lem:tensorobj_isoclass_commgroup`) IS on the critical path under the PRIMARY route. The `% NOTE:` was not updated as part of fix #5 (which targeted the consistency-check section around line 1795–1801, not this comment block). The `% NOTE:` therefore contradicts both the `\uses` list at lines 1185–1186 (which already lists `lem:tensorobj_restrict_iso`) and the consistency check.

**Required fix:** Update the `% NOTE:` to qualify the off-path claim to route~(e) only, and acknowledge that under the PRIMARY route `lem:tensorobj_inverse_invertible` is on the critical path (supplying inverses to `lem:tensorobj_isoclass_commgroup`).

---

## Confirmed as correct (no residual issue)

The following locations, flagged or edited in prior rounds, are now correctly worded:

- **Lines 130–134** (`sec:tensorobj_motivation`): "Under route~(e), … `restrict_iso` is not needed for that path … under the PRIMARY locally-trivial route, by contrast, it is on the critical path." ✓
- **Lines 413–417** (`rem:scheme_modules_monoidal_off_path`): "under route~(e) none of them is built from the restriction-compatibility isomorphism … (which is instead on the critical path of the PRIMARY locally-trivial route…)." ✓
- **Lines 440–443** (`sec:tensorobj_onproduct_lift` intro): "`restrict_iso` is on the critical path of the PRIMARY locally-trivial group law … it is dispensable only under the route~(e) stalkwise fallback." ✓
- **Lines 1800–1803** (`sec:tensorobj_consistency_check`): "Under the PRIMARY locally-trivial group law, `restrict_iso` … and `inverse_invertible` … are ON the critical path." ✓
- **Lines 657–668** (`lem:flat_whisker_localizer`): flat-whisker lemmas correctly described as "off the critical path" — these are the W_whisker*_of_flat lemmas the directive explicitly exempts. ✓
- **Lines 474–479** (`lem:restrictscalars_laxmonoidal`): "off the critical path for the tensor group law" refers to the lax-monoidal supplement, not to `restrict_iso`. ✓
- **Lines 276, 1719**: "not on the critical path" refers to Mathlib upstream PRs, not to `restrict_iso`. ✓

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - must-fix (visible text) — lines 1349–1351, `sec:tensorobj_invertibility`: unqualified "neither `restrict_iso` nor a separate tensor-inverse lemma is on the critical path" — missing "under route~(e) only" qualifier; contradicts PRIMARY route (consistency check lines 1800–1803 and onproduct_lift intro lines 440–443).
  - must-fix (`% NOTE:` comment) — line 1187, `lem:tensorobj_inverse_invertible`: "off the critical path for the relative Picard group law" — unqualified; contradicts consistency check (lines 1800–1803) which correctly places `inverse_invertible` on the PRIMARY critical path.

## Severity summary

- **must-fix-this-iter**: 2 (Must-fix A at lines 1349–1351; Must-fix B at line 1187)
- **soon**: 0
- **informational**: 0

Overall verdict: Gate NOT-CLEARED — two residual unqualified off-path sentences survive the five plan-agent fixes: one in visible text at `sec:tensorobj_invertibility` lines 1349–1351 and one in the `% NOTE:` of `lem:tensorobj_inverse_invertible` line 1187. Both must be qualified to "under route~(e) only" before the chapter is `correct: true`.
