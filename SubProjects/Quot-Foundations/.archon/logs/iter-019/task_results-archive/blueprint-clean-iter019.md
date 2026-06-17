# Blueprint-Clean Report — iter-019

**Status:** COMPLETE  
**Date:** 2026-06-06

---

## Chapters cleaned

### 1. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

**Issue 1 — "Archon-original" comment header (line 1611–1616):**  
The section-divider comment before the five step-(iii) atomic-link lemmas contained the phrase "Archon-original adjoint-mate calculus" and "no % SOURCE lines". Removed the "Archon-original" attribution; rephrased as timeless description.

**Issue 2 — `% RECIPE (iter-015, LSP-validated):` block (line ~1940–1960):**  
Removed `(iter-015, LSP-validated)` label and two `iter-014` back-references (`"closed Seam 1 in iter-014"`, `"proven iter-014"`). The RECIPE content and DEAD END guidance are preserved; only the project-history labels were stripped.

**Rendered prose of the five new lemmas:** verified clean — no tactics, no Lean syntax in any rendered text block.

**SOURCE QUOTE blocks:** 17 blocks present and untouched.

---

### 2. `blueprint/src/chapters/Picard_FlatteningStratification.tex`

All `iter-NNN` labels stripped from `%` comment lines (11 occurrences):

| Line | Before | After |
|------|--------|-------|
| 352 | `% NOTE (iter-008 encoding):` | `% NOTE (encoding):` |
| 385 | `% NOTE (resolved iter-006):` | `% NOTE:` |
| 447 | `% NOTE (iter-007 decomposition):` | `% NOTE:` |
| 614 | `% L5b decomposition (iter-009 effort-break of …):` | `% L5b decomposition of …:` |
| 913 | `% NOTE (iter-012 resync, F-3a):` | `% NOTE (F-3a):` |
| 1001 | `-- NOTE (iter-017):` | `-- NOTE:` |
| 1213 | `% NOTE (iter-016): the closed Lean proof DID find…` | `% NOTE: the closed Lean proof DID find…` |
| 1266 | `% NOTE (iter-008 signature):` | `% NOTE (signature):` |
| 1301 | `% LEAN PROOF STRUCTURE (iter-007):` | `% LEAN PROOF STRUCTURE:` |
| 1358 | `% NOTE (iter-016):` | `% NOTE:` |
| 1428 | `% NOTE (re-signed iter-002):` + `"re-signed in iter-002 (the decl is NOT in archon-protected.yaml)"` | `% NOTE (re-signed):` + neutral phrasing |

**Step 3 expansion (3a/3b/3c) of `lem:gf_noether_clear_denominators`:** rendered prose is mathematically clean; no Lean syntax in rendered text.

**SOURCE QUOTE / SOURCE QUOTE PROOF blocks:** 26 blocks present and untouched.

---

### 3. `blueprint/src/chapters/Picard_QuotScheme.tex`

**Issue 1 — `% NOTE` in `lem:gradedHilbertSerre_rational` (lines 405–413):**  
Replaced 9-line verbose block (containing Lean syntax `` `fun n => Naux ⊓ ℳ n` ``, `` `↥p` ``, `` `M ⧸ p` ``, `DirectSum.IsInternal`, `isDefEq`/`whnf`) with a 3-line terse pointer preserving the mathematical intent.

**Issue 2 — `% NOTE` in `subsec:isRatHilb` (lines 501–507):**  
Replaced 7-line verbose listing of private declaration names with a 2-line terse pointer about `private` status and module split.

**New bespoke helper blocks:** verified mathematically clean — no tactics, no Lean syntax in rendered text.

**SOURCE QUOTE blocks:** 19 blocks present and untouched.

---

## Verification

- No `iter-NNN` or `Archon-original` strings remain in any of the three files.
- SOURCE QUOTE counts unchanged: FlatBaseChange 17, FlatteningStratification 26, QuotScheme 19.
- No `\leanok`, `\mathlibok`, `\lean{}`, `\uses{}`, or `\label{}` markers were added or removed.
- No mathematical content was altered.
- The four protected stub blocks in the QuotScheme chapter were not touched.
