# Blueprint-clean report — iter-027

## Scope
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — full purity pass,
focused on the new regions introduced this iteration.

---

## What was stripped

**Two instances of Lean identifier leakage in `lem:absolute_cohomology_zero_natural`:**

1. **Statement prose** — the phrase
   `\(H^0(U, g) = (\operatorname{mk}_0 g) \circ (-)\)`
   used the Lean constructor name `mk_0` as if it were mathematical notation.
   Replaced with:
   `\(H^0(U, g)\), the functorial action of \(g\) on \(\operatorname{Ext}^0\) in the second variable`.

2. **Proof body** — the phrase
   `post-composition by the Ext class \(\operatorname{mk}_0 g\)`
   again used the Lean name `mk_0`.
   Replaced with:
   `post-composition by the degree-zero Ext class of \(g\)`.

Both edits are in the prose/explanation layer only; the mathematical claim (the
commutative square and its commutativity) is unchanged.

No other Lean syntax, tactic strings, or project-history verbosity was found anywhere
in the file.

---

## SOURCE QUOTE fragment verification

All `% SOURCE QUOTE` and `% SOURCE QUOTE PROOF` fragments in the newly added blocks
were verified against `references/stacks-cohomology.tex` L1695–1776
(`\begin{lemma}\label{lemma-cech-vanish-basis}` … `\end{proof}`):

| Block | Fragment | Verdict |
|---|---|---|
| `lem:cech_ses_of_basis` | "By Lemma \ref{lemma-ses-cech-h1} … by assumption (1)." | **Verbatim** (source L1729–1743) |
| `lem:quotient_vanishing_cech` | "In particular we have a long exact sequence … for all $\mathcal{U} \in \text{Cov}$." | **Verbatim** (source L1744–1748) |
| `lem:absolute_cohomology_one_vanishing` | "Next, we look at the long exact cohomology sequence $$ \ldots $$ … hence $H^1(U, \mathcal{F}) = 0$." | **Verbatim**; the `$$ \ldots $$` placeholder legitimately abbreviates the `\xymatrix` diagram (source L1751–1770) |
| `lem:absolute_cohomology_pos_vanishing` | "Since $\mathcal{F}$ was an arbitrary … And so on and so forth." | **Verbatim** (source L1771–1775) |
| `lem:cech_to_cohomology_on_basis` (statement quote) | "(Variant of Lemma …) Let $X$ be a ringed space … any $U \in \mathcal{B}$." | **Verbatim** (source L1697–1713) |
| `lem:cech_to_cohomology_on_basis` (proof quote) | "Let $\mathcal{F}$ and $\text{Cov}$ … And so on and so forth." | **Verbatim** (source L1717–1775) |

The five project-wrapper blocks (`lem:absolute_cohomology_zero`,
`lem:absolute_cohomology_zero_natural`, `lem:absolute_cohomology_injective_vanishing`,
`lem:absolute_cohomology_covariant_les`, and the bundled `sheafificationHomAddEquiv` in
`lem:jshriek_corepr`) carry **no** `% SOURCE` lines, correctly reflecting that they are
project-bespoke specializations with no external-source obligation.

---

## Marker / pin / uses confirmation

- **No `\leanok` or `\mathlibok` markers were added or removed.**
- **No `\lean{...}` pins were changed.**
- **No `\uses{...}` sets were changed.**

All edits were purity-only: two prose/explanation replacements of a Lean identifier
(`mk_0`) with standard mathematical language.
