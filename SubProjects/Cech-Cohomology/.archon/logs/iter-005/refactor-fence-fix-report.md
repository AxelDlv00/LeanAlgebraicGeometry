# Refactor Report

## Slug
fence-fix

## Status
COMPLETE

## Directive

### Problem
`AlgebraicJacobian/Cohomology/AcyclicResolution.lean` contained a `/-! ... -/` strategy
documentation comment whose body included a backtick-fenced "suggested output type" code
block (around lines 281–287). The `sync_leanok` declaration matcher read the fenced
`def InjectiveResolution.ofShortExact ...` as a real, sorry-free declaration, producing
a false `\leanok` on blueprint lemma `lem:injective_resolution_of_ses`.

### Changes Requested
Remove the backtick fences around the `def InjectiveResolution.ofShortExact` signature
and reformat so no line begins with `def InjectiveResolution.ofShortExact`. Preserve the
informational content. Scan the whole strategy comment for any other problematic fences.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`
- **What:** Removed the ` ``` ` fences at lines 282 and 287 (old numbering) and prefixed
  each line of the signature block with `-- `. The opening label was changed from
  `Output type (suggested):` to `Suggested output type (NOT yet defined):` to make the
  not-yet-built status explicit. The closing prose line ("or equivalently expose the SES
  directly as a field.") was preserved unchanged.
- **Why:** The matcher was treating the bare `def InjectiveResolution.ofShortExact` line
  as a real Lean declaration, poisoning the DAG with a false `\leanok`.
- **Cascading:** None — change is confined to a doc comment.

**Second fence scan:** The other backtick fence pair in the file (lines 75–77) contains
only mathematical notation `(Rᵏ⁺¹ G)(J) = 0   for all k : ℕ.` — no declaration keyword —
so it was left untouched.

## New Sorries Introduced
None.

## Compilation Status
- `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`: compiles, zero errors.

## Notes for Plan Agent
None. Change is purely cosmetic within a doc comment; no proof obligations or blueprint
markers were touched. After the next `sync_leanok` run, the false `\leanok` on
`lem:injective_resolution_of_ses` should be removed automatically.
