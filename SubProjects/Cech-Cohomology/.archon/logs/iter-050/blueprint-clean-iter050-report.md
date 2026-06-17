# Blueprint-clean report — iter-050

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
**Region:** 02KG blocks (~lines 6054–6270)

## Source-quote verification

| Block | SOURCE QUOTE | SOURCE QUOTE PROOF | Status |
|---|---|---|---|
| `lem:affine_cech_vanishing_qcoh` | "Finally, condition (3) of the lemma follows from Lemma \ref{lemma-cech-cohomology-quasi-coherent-trivial}." | "Write $U = \Spec(A)$…" (stacks-coherent.tex L55–67) | ✓ match |
| `lem:affine_cech_vanishing_tilde_subcover` | "Let $X$ be a scheme … $\check{H}^p = 0$ for all $p > 0$." (stacks-coherent.tex L46–51) | "Write $U = \Spec(A)$ … the complex $\prod M_{f_{i_0}} \to \ldots$" (L55–67) | ✓ match |
| `lem:cechCohomology_isZero_of_iso` | Project-local (no Stacks cite) | — | ✓ |
| `lem:affine_cover_span_localizationAway` | Project-local | — | ✓ |
| `lem:away_comparison_isLocalizedModule` | Project-local | — | ✓ |

No missing source quotes. All cited quotes verified verbatim against `references/stacks-coherent.tex`.

## Prose edits applied

### 1. `lem:affine_cech_vanishing_qcoh` statement (was lines 6078–6082)
Removed: "and is the 01I8 globalisation of the tilde-case standard-cover vanishing. It is currently formalized in the reduced `\_of\_tildeVanishing` form pending the residual Lemma~…"

Reason: "01I8 globalisation" is project-history jargon; "currently formalized in the reduced form pending" is implementation-status chatter — neither belongs in a timeless mathematical statement.

Replacement: Single clean sentence attributing the result to the tilde-case residual, without status language.

### 2. `lem:away_comparison_isLocalizedModule` statement (was line 6183)
Changed: "This is the change-of-localisation-base **engine**: it builds the degreewise…"
To: "In particular, it yields the degreewise…"

Reason: "engine" is informal project-process phrasing; the sentence is rephrased as a mathematical consequence of the stated transitivity.

### 3. Proof of `lem:affine_cech_vanishing_tilde_subcover` (was line 6262)
Removed Lean identifier: `\(\mathtt{dToCech}\)` → replaced with "the complex differential"

Reason: `dToCech` is a Lean declaration name, not a standard mathematical term.

### 4. Proof of `lem:affine_cech_vanishing_tilde_subcover` (was line 6263)
Removed Lean identifier: `\(\operatorname{Function.Exact}\)` → replaced with "exactness"

Reason: `Function.Exact` is a Lean namespace-qualified predicate name, not standard mathematical notation.

## Wiring unchanged

All `\uses{}`, `\lean{}`, `\label{}` entries in the 02KG region are untouched. No `\leanok` was added or removed.

## `% NOTE` / `% SOURCE` / `% TODO` comments

All such comment lines were left in place (lines 6061–6066, 6067–6071, 6083–6092, 6196–6209, 6219–6226, etc.).

## Pre-existing conventions preserved

`\operatorname{Localization.Away}` and `\operatorname{LocalizedModule}(\operatorname{Submonoid.powers} …)` are a long-standing blueprint convention (used from line 521 onward) and were not touched.

## Outcome

**PASS.** Four prose edits applied; no structural wiring altered; all source quotes verified.
