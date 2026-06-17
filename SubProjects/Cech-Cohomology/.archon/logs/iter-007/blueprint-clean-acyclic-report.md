# blueprint-clean — Cohomology_AcyclicResolution.tex

**Summary:** Stripped 6 process-history `% NOTE (iter-...)` blocks; all source quotes in the new staircase lemmas validated verbatim-faithful against `references/homological-acyclic-derived.tex`.

## Stripped blocks (process-history leakage removed)

| Lemma | Block removed |
|---|---|
| `lem:horseshoe_twist` | `% NOTE (iter-005 review)` — Lean name correction history, `recommendations.md (session_5)` reference |
| `lem:horseshoe_dComp` | `% NOTE (iter-005 review)` — Lean name correction history, `TwistedBiprod` planner note, `recommendations.md (session_5)` reference |
| `lem:horseshoe_chainMap` | `% NOTE (iter-005 review)` — Lean name correction history, `recommendations.md (session_5)` reference |
| `lem:horseshoe_resolvesMiddle` | `% NOTE (iter-006 review)` — "ABSENT from Mathlib (only quasiIso_τ₃ existed)", "iter-005 'must be built first' framing is obsolete", `lean_aux` note |
| `lem:injective_resolution_of_ses` | `% NOTE (iter-006 review)` — "CLOSED", axiom-clean SHA, "iter-004 FALSE-DONE NOTE" history |
| `lem:acyclic_dimension_shift` | `% NOTE (iter-007 effort-breaker)` — block-split rationale, "iter-006 PARTIAL COVERAGE concern is thereby resolved" |

## Source quote validation (new staircase blocks)

All `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` texts in the five staircase lemmas were compared against the cited line ranges in `references/homological-acyclic-derived.tex`. Results:

| Lemma | Tag / Lines | Status |
|---|---|---|
| `lem:acyclic_dimension_shift` | 015D L5619–5654 | **Faithful** — verbatim match of lemma statement and proof opening |
| `lem:acyclic_one_iso_coker` | 015D L5619–5654 | **Faithful** — statement and proof quote (`$0 \to F(A) \to F(B) \to F(C) \to R^1F(A) \to \ldots$`) verbatim; displayed-vs-inline math rendering difference is cosmetic |
| `lem:applied_cosyzygy_cycles` | 015D L5619–5654 | **Faithful** — same proof quote, correctly attributed to the left-exact initial segment |
| `lem:cosyzygy_ses` | 05TA L5785–5838 | **Faithful** — `Setting $J^n = \Im(d^n)$ we break...` verbatim (L5832–5834) |
| `lem:cohomology_of_applied_resolution` | 05TA L5785–5838 and 015D L5619–5654 | **Faithful** — same cosyzygy break passage, correctly attributed to both tags |
| `lem:acyclic_resolution_computes_derived` | 015E L5692–5705, 05TA L5785–5811 | **Faithful** — Leray statement verbatim (footnote omitted by `...`, acceptable); proof quote uses `...` to elide the $H_k$ induction and the `(\ref{equation-long-exact-cohomology-sequence-D})` cross-ref, otherwise verbatim |

No source quote drift found; no fixes required.

## Project-bespoke blocks (no SOURCE block expected)

- `lem:quasiIso_tau2` — confirmed bespoke (homology four-lemma, companion to Mathlib's `quasiIso_τ₃`); no `% SOURCE` block added.
- `lem:right_derived_shift_split_resolution` — confirmed bespoke (δ-iso from the homology LES under acyclic middle term); no `% SOURCE` block added.

## Invariants preserved

- All `\leanok`, `\mathlibok` markers left untouched.
- All `% SOURCE`, `% SOURCE QUOTE`, `% SOURCE QUOTE PROOF`, `\textit{Source: …}`, `\lean{}`, `\uses{}`, `\label{}` lines preserved verbatim.
- No statements, `\lean{}` targets, or `\uses{}` dependency sets modified.
