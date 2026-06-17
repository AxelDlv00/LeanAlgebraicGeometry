# Blueprint-Clean Report — iter078

**Target:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Changes Applied

### 1. `lem:isQuasicoherent_pullback_opens` — statement (~L11658)

- **Removed** `\textit{Project-local.}` (project-history annotation).
- **Replaced** `\mathcal{F}.\operatorname{restrict}\iota` (Lean dot notation) with `the restriction of \(\mathcal{F}\) to \(U\)` in the equivalence parenthetical.

### 2. `lem:isQuasicoherent_pullback_opens` — proof (~L11667–11683)

Complete rewrite removing all Lean-name and dot-notation leakage:

| Removed | Replaced with |
|---------|---------------|
| "general-open-immersion **port**" | "general-open-immersion **analogue**" |
| `\operatorname{of\_coversTop}` | "cover-to-top criterion" |
| `\operatorname{modulesOverOpensEquivalence}` | "site-theoretic equivalence between O_U-modules and sheaves over the localized slice category (Opens X)/U" |
| `(\operatorname{Opens} X).\operatorname{over} U` | `(\operatorname{Opens} X)/U` |
| `\mathcal{F}.\operatorname{over} U`, `\operatorname{presentationOverOpens}` | "over-presentation of F over U" |
| `\operatorname{presentationRestrictSliceOfOver}` | "slice by slice" |
| `\mathcal{F}.\operatorname{restrict}\iota` | `\mathcal{F}|_U` |
| `\operatorname{overOpensIsoRestrict}`, `\operatorname{overOpensFunctorUnitIso}`, `\operatorname{overOpensInverseUnitIso}`, `\operatorname{restrictIsoUnitIso}` | "the canonical isomorphism … together with coherence of the relevant unit maps" |

Mathematical content preserved verbatim (locality argument, affine-chart reduction, site equivalence, unit-coherence transport, Lemma `lem:restrictFunctorIsoPullback_mathlib`).

### 3. `lem:cech_term_pushforward_acyclic` — statement display equation (~L11721–11724)

- Replaced `(f_*).\mathrm{rightDerived}\,k\,(\mathcal{C}^p) = 0` with `R^k f_*(\mathcal{C}^p) = 0` (standard math notation for the derived functor).

### 4. `lem:cech_term_pushforward_acyclic` — proof display equation (~L11784–11789)

- Replaced `(f_*).\mathrm{rightDerived}\,k\,\bigl((j_s)_*(\mathcal{F}|_{U_s})\bigr)` with `R^k f_*\bigl((j_s)_*(\mathcal{F}|_{U_s})\bigr)`, making both sides of the isomorphism use standard `R^k` notation.

### 5. `lem:cech_computes_cohomology_affineCover` — proof (~L12104)

- Removed `(\(\operatorname{Nonempty}\))` from "its existence (Nonempty) form" — `Nonempty` is a Lean propositional-truncation type, not a math term. Now reads "its existence form."

## SOURCE / SOURCE QUOTE Verification

All `% SOURCE` and `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks checked:

- `lem:cech_term_pushforward_acyclic` statement: `% SOURCE` + `% SOURCE QUOTE` intact (L11700–11706).
- `lem:cech_term_pushforward_acyclic` proof: `% SOURCE QUOTE PROOF` intact (L11741–11751).
- `lem:cech_computes_cohomology_affineCover` statement: `% SOURCE` + `% SOURCE QUOTE` intact (L12028–12040), verbatim Stacks quote preserved.
- Tag 01SG referenced as prose cross-reference only (no verbatim quote required per directive) — confirmed present at two points in the Stacks reasoning paragraphs.

No citation gaps found; no reference-retriever spawn needed.

## Invariants

- `\leanok` markers: **not touched** (L11803 `\leanok` in `lem:cech_computes_cohomology` statement preserved).
- `\lean{}` declaration lists: untouched (Lean names in `\lean{}` are specification metadata, not prose).
- Mathematical content: unchanged throughout (hypotheses, formulas, lemma references all preserved).
- LaTeX environments: balanced (verified by reading all opened `\begin{lemma}` / `\begin{proof}` pairs in scope).

## Status

PASS — all three focus areas are now math-only prose. No spawned subagents required.
