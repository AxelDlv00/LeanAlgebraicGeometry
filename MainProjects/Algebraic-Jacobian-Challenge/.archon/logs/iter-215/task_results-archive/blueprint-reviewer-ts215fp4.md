# Blueprint-reviewer report — iter-215 fast-path re-review #4 (ts215fp4)

**Scope:** `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` only  
**Question:** Are ALL unqualified claims that `tensorObj_restrict_iso` / `tensorobj_inverse_invertible` is "off the critical path" now resolved?

---

## Verdict: CLEARED

**`complete: true` + `correct: true`, no must-fix.**

---

## Evidence

### Fix #1 confirmed — lines 1349–1356 (`sec:tensorobj_invertibility`)

The section now reads (lines 1349–1356):

> "Under the route~(e) fallback the inverse of an invertible object is carried by the predicate
> itself, so neither the open-immersion restriction-compatibility isomorphism
> `lem:tensorobj_restrict_iso` nor a separate tensor-inverse lemma is needed there. Under the
> PRIMARY locally-trivial route, by contrast, both `lem:tensorobj_restrict_iso` (via the PRIMARY
> proof of `lem:islocallyinjective_whisker_of_W`) and the tensor-inverse lemma
> `lem:tensorobj_inverse_invertible` (supplying inverses to `lem:tensorobj_isoclass_commgroup`)
> are on the critical path."

The route-(e) qualifier is present and the PRIMARY-route status is affirmatively stated. ✓

### Fix #2 confirmed — lines 1187–1192 (`% NOTE:` of `lem:tensorobj_inverse_invertible`)

The note now reads:

> "% NOTE: ON the critical path under the PRIMARY locally-trivial group law (it supplies inverses
> to lem:tensorobj_isoclass_commgroup, in whose uses it sits). Only under the route-(e) fallback
> is it dispensable: there the group law uses the tensor-invertibility predicate IsInvertible
> (def:scheme_modules_isinvertible), which carries the inverse existentially, so no separate
> "a tensor inverse exists" lemma is required."

Affirmatively on-path under PRIMARY; dispensable only under route-(e). ✓

---

## Full audit of all "off the critical path" occurrences

Seven total occurrences of "off the critical path" / "not on the critical path" in the chapter. None refers to `tensorobj_restrict_iso` or `tensorobj_inverse_invertible` as off-path without qualification:

| Line | Subject of claim | Refers to target lemmas? |
|------|-----------------|--------------------------|
| 276  | Parallel Mathlib upstream PR | No |
| 351  | Unitor/associator/braiding coherence data | No |
| 366  | Unitor/associator/braiding coherence data | No |
| 400  | Sectionwise-flatness hypothesis (`lem:flat_whisker_localizer`) | No |
| 475  | `lem:restrictscalars_laxmonoidal` (lax-monoidal supplement); explicitly states it is "NOT an ingredient of `lem:tensorobj_restrict_iso`" | No |
| 658  | Flat whiskering stability data (`lem:flat_whisker_localizer` variants) | No |
| 1751 | `lem:restrictscalars_laxmonoidal`; again explicitly "NOT an ingredient of `lem:tensorobj_restrict_iso`" | No |

All seven correctly describe genuinely auxiliary items. None is an unqualified claim about the two target lemmas.

---

## Summary

Both ts215fp3 must-fixes are present and correctly worded. No remaining sentence claims `tensorObj_restrict_iso` or `tensorobj_inverse_invertible` is off the critical path without the "under route-(e) only" qualifier. Chapter gates: **complete: true, correct: true**.
