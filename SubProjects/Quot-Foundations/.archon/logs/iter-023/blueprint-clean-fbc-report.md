# Blueprint Clean Report — fbc

**Chapter:** `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
**Date:** 2026-06-07

---

## Summary

Four targeted edits applied to the five new/edited blocks introduced by the iter-023 effort-breaker round. All out-of-scope blocks left untouched.

---

## Task 1 — Lean leakage & project-history removal

### Issue 1: `lem:base_change_mate_inner_value_eq` statement (visible prose)
**Removed:** The trailing sentence "It re-derives the content of the retired Seam~2 lemma Lemma~\ref{lem:base_change_mate_fstar_reindex} inline from the proved atoms, with no `\texttt{sorry}`-backed dependency." This contained a project-history reference ("retired Seam~2 lemma") and Lean leakage (`\texttt{sorry}`). The mathematical content of the statement is fully expressed by the preceding sentence.

### Issue 2: `lem:base_change_mate_gstar_counit_transport` proof
**Removed:** The trailing parenthetical "(This is the master counit-transport identity already assembled in the Lean scaffold.)" — a direct Lean-implementation reference with no mathematical content.

---

## Task 2 — Citation discipline

All five new blocks verified against `references/stacks-coherent.tex`:

| Block | Source needed? | `% SOURCE:` | `% SOURCE QUOTE:` | `\textit{Source: …}` | Quote verbatim? |
|---|---|---|---|---|---|
| `lem:base_change_mate_inner_unitReduce` | No (categorical bridge) | — | — | — | n/a |
| `lem:base_change_mate_inner_eCancel` | No (categorical bridge) | — | — | — | n/a |
| `lem:base_change_mate_inner_value_eq` | Yes | ✓ | ✓ | ✓ | ✓ (L927–931) |
| `lem:base_change_mate_gstar_generator_close` | Yes | ✓ | ✓ | ✓ | ✓ (L932–937) |
| `lem:base_change_mate_gstar_counit_transport` | No (categorical bridge) | — | — | — | n/a |

**Quote check — `lem:base_change_mate_inner_value_eq`:** The `% SOURCE QUOTE:` block ("We use Schemes, Lemma \ref{schemes-lemma-widetilde-pullback} to describe pullbacks and pushforwards of $\mathcal{F}$. Namely, $X' = \Spec(R' \otimes_R A)$ and $\mathcal{F}'$ is the quasi-coherent sheaf associated to $(R' \otimes_R A) \otimes_A M$.") matches L927–931 of `references/stacks-coherent.tex` verbatim. ✓

**Quote check — `lem:base_change_mate_gstar_generator_close`:** The `% SOURCE QUOTE:` block ("Thus we see that the lemma boils down to the equality $(R' \otimes_R A) \otimes_A M = R' \otimes_R M$ as $R'$-modules.") matches L932–937 verbatim. ✓

No missing or paraphrased quotes found. No fabricated sources added.

---

## Task 3 — Verbosity trimming

### Duplicated `\textit{Source: …}` in proof bodies
Both `lem:base_change_mate_inner_value_eq` and `lem:base_change_mate_gstar_generator_close` had a `\textit{Source: …}` attribution inside the `\begin{proof}` block that was already present verbatim in the corresponding statement block.

- **Removed** from `lem:base_change_mate_inner_value_eq` proof: `\textit{Source: Stacks Project, Cohomology of Schemes, Lemma ``Affine base change'' (proof, ``describe pullbacks and pushforwards'' step).}`
- **Removed** from `lem:base_change_mate_gstar_generator_close` proof: `\textit{Source: Stacks Project, Cohomology of Schemes, Lemma ``Affine base change'' (proof, ``boils down to the equality'' step).}`

All remaining proof prose is concise and mathematically precise. No further verbosity issues detected in the new blocks.

---

## Task 4 — LaTeX / `\uses{}` / `\label{}` checks

All six affected blocks (five new + one rewritten target) checked:

- **`\label{}`** — all correctly prefixed (`lem:base_change_mate_inner_unitReduce`, etc.). ✓
- **`\uses{}` in statement blocks** — all correct. ✓
- **`\uses{}` in proof blocks** — all entries match the corresponding statement `\uses{}`. ✓
- **No dangling `\ref{}`** introduced in the edited region. ✓
- **Pre-existing `\uses{lem:base_change_regroup_linearEquiv}` in `lem:base_change_mate_regroupEquiv`** — left untouched per directive.

---

## Out-of-scope items confirmed untouched

- `\leanok` / `\mathlibok` markers: not modified.
- Dead blocks `lem:base_change_mate_fstar_reindex` / `_legs` / `_legs_unitExpand` / `_legs_gammaDistribute`: not modified.
- No other chapter touched.

---

## Changes made (4 edits)

1. `lem:base_change_mate_inner_value_eq` **statement**: removed trailing project-history + Lean-leakage sentence.
2. `lem:base_change_mate_inner_value_eq` **proof**: removed duplicated `\textit{Source: …}` line.
3. `lem:base_change_mate_gstar_generator_close` **proof**: removed duplicated `\textit{Source: …}` line.
4. `lem:base_change_mate_gstar_counit_transport` **proof**: removed "Lean scaffold" parenthetical.
