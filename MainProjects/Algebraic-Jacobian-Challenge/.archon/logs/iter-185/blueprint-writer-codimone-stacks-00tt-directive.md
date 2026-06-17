# Blueprint Writer Directive

## Slug
codimone-stacks-00tt

## Chapter to edit
`blueprint/src/chapters/Albanese_CodimOneExtension.tex`

## Strategy context

`Albanese/CodimOneExtension.lean` is the home of Milne's Theorem 3.2 / Lemma 3.3 (the "rational map into a complete group variety extends" theorem). Two sorry-bodied top-level results (`extend_of_codimOneFree_of_smooth`, `indeterminacy_pure_codim_one_into_grpScheme`) remain, plus one structured-proof half-sorry inside `lem:smooth_codim_one_dvr`: the `IsRegularLocalRing` half. Iter-184's Lane M↓ closed the Krull-dim half axiom-clean via the iter-183 bridge `Scheme.ringKrullDim_stalk_eq_coheight` (`Albanese/CoheightBridge.lean`).

The chapter is currently flagged `partial / partial` by iter-185 blueprint-reviewer. Two live must-fix items prevent a future prover from picking up the `IsRegularLocalRing` half and prevent a prover from finding a blueprint home for the iter-179 lemma `mem_domain_iff_exists_partialMap_through_point`. Your job is to land both fixes in one writer pass so the chapter clears `complete + correct` at the next blueprint-reviewer dispatch.

## Required edits — the two MUST-FIXes

### MF-1 — Stacks 00TT bridge for the `IsRegularLocalRing` half

Currently the proof block of `lem:smooth_codim_one_dvr` mentions "by smoothness, $\mathcal O_{X,x}$ is regular for every closed point $x$" but Stacks 00TT is uncited as the actual bridge route. The iter-184 review NOTE at L701–718 (around the Mathlib readiness audit) flags this as a Mathlib gap but does NOT provide a derivation sketch for a prover.

Land a new mini-block — either expand the existing proof block prose for `lem:smooth_codim_one_dvr`, or factor out a separate `\begin{lemma}` block `lem:smooth_to_regular_local_ring` immediately before it. Use whichever shape best preserves the chapter's existing rhythm — your judgement.

The block must contain:

1. **`% SOURCE:`** pointer to **Stacks tag 00TT**, named locally as `references/stacks-algebra.md` if Stacks 00TT lives in `algebra.tex`, or as `references/stacks-varieties.md` if it lives in `varieties.tex` (you must verify which file by reading the appropriate `references/<slug>.md` index card OR by searching the actual `references/stacks-*.tex` files — do NOT guess). Format: `% SOURCE: [Stacks Project], tag 00TT — Jacobian criterion (smooth-implies-regular direction) (read from references/<slug>.<ext>)`.
2. **`% SOURCE QUOTE:`** with the **verbatim text** of Stacks 00TT (or the specific paragraph asserting the implication "smooth morphism of schemes over a field $k$ ⟹ regular at every $k$-rational stalk"). Open the `references/stacks-*.tex` file you cited, locate tag 00TT by searching for `\begin{lemma}\label{lemma-...}` or by `tag-00TT`, and copy the statement verbatim. **DO NOT paraphrase**; the verbatim text on the next line is the discipline check.
3. A **visible `\textit{Source: [Stacks Project], tag 00TT.}`** line as the first line of the block prose (renders in the PDF; satisfies the visible-pointer rule).
4. **Derivation sketch** (textbook-level prose, no Lean tactics) showing how the result the chapter needs (`Smooth X.hom + IsAlgClosed kbar ⟹ IsRegularLocalRing (X.left.presheaf.stalk z)`) follows from the Stacks tag. Three to six sentences naming the Mathlib infrastructure that would be involved (`Algebra.FormallySmooth`, `Module.FormallyEtale`, the codim-1 closed-point selection, etc.) — the writer's `[expected]` Mathlib-name hint format is fine here.
5. **`\uses{...}`** dependency line naming the Stacks tag's prerequisites (typically `def:smooth_morphism`, `def:regular_local_ring`, and the `IsAlgClosed kbar` hypothesis carried through the chapter).
6. A note that **`[IsAlgClosed kbar]` is the load-bearing hypothesis** for the Jacobian-criterion derivation (this is the chapter prose's missing connective tissue per iter-184 lean-vs-blueprint-checker iter184-codimone Q2).

Also, please ensure the prose retains the iter-184 NOTE referencing that the Krull-dim half is closed axiom-clean via `Scheme.ringKrullDim_stalk_eq_coheight` from `Albanese/CoheightBridge.lean` (iter-183/184 work). If that NOTE is already at L708–712, leave it; do not duplicate.

### MF-2 — `lem:mem_domain_partial_map_reshuffle` lemma block

`AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point` exists in the Lean file at L492 but currently has no `\begin{lemma}` block in the chapter. The iter-179 retirement of `extend_iff_order_nonneg` (renamed to the current name) lifted the original `\lean{...}` pin but did not transfer a fresh block. Add a lightweight `\begin{lemma}` block now:

```latex
\begin{lemma}
  \label{lem:mem_domain_partial_map_reshuffle}
  \lean{AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point}
  Informal statement, in the project's notation.
  (One paragraph; this is a definitional reshuffle of `RationalMap.mem_domain`.)
\end{lemma}
\begin{proof}
  Short proof (one to three sentences): the statement unfolds the membership
  predicate on `RationalMap.mem_domain` against the existence form for a
  through-the-point partial map. No external citation; project-bespoke.
\end{proof}
```

Place the block in a natural location in the chapter — ideally in or after the section that introduces `RationalMap.mem_domain` (around the existing iter-179 NOTE that mentions this lemma was promised). Update the chapter's `\section{Lean encoding}` item 6 to reference this new label.

This is an Archon-original / project-bespoke result — **omit the `% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source: ...}` lines entirely** per the writer's source-citation discipline.

### Cosmetic touch-up — informational issue I-3

The iter-185 reviewer noted that `lem:smooth_codim_one_dvr`'s proof block carries `\leanok` while the `IsRegularLocalRing` half is still `sorry`. **Do NOT add/remove any `\leanok` markers yourself** — those are deterministic-sync-managed. But if your prose touches the area, you may add a short `% NOTE (iter-185 writer)` clarifying that the `\leanok` on the proof block reflects the Krull-dim half (Tier-1 axiom-clean iter-184) and the `IsRegularLocalRing` half is tracked separately as the Stacks 00TT gap (the MF-1 derivation sketch you just added). The clarification belongs in the chapter prose, not in a tactic line.

## References for writing

Read these locally before drafting:

- `references/stacks-algebra.md` (and the actual `references/stacks-algebra.tex` if Stacks 00TT lives there) — search for `tag-00TT` or the corresponding `\label{lemma-...}` to locate the statement.
- `references/stacks-varieties.md` (and `references/stacks-varieties.tex`) — secondary candidate location for Stacks 00TT; check both.
- `references/matsumura-commutative-ring-theory.md` (NEW iter-185 reference card) — Ch. 18–19 (regular rings, projective dimension) is the standard textbook source for the smooth-ring ⟹ regular-local-ring implication. Useful as a backup citation if the Stacks tag's wording is too tag-internal to quote stand-alone.
- The existing `Albanese_CoheightBridge.tex` proof of `Scheme.ringKrullDim_stalk_eq_coheight` (closed iter-183) — match its prose rhythm for the new sub-lemma if you factor one out.

If Stacks 00TT genuinely cannot be located in the local Stacks files (`references/stacks-*.tex`), you may dispatch the `reference-retriever` (you have `references/**` in your write_domain via the dispatcher's allowance below) to fetch the relevant Stacks chapter — but only if a local search confirms the tag is absent. **Do NOT fabricate the quote.**

## Out of scope (do NOT change)

- Do NOT add or remove any `\leanok` or `\mathlibok` markers anywhere in the chapter — those are managed deterministically by the `sync_leanok` phase / by the review agent. The chapter prose may DESCRIBE marker status (e.g. "carries `\leanok`") but must not modify any actual markers.
- Do NOT touch the two pre-existing top-level sorry-bodied theorems (`thm:codim_one_extension`, `lem:milne_codim1_indeterminacy`) — their proof sketches are adequate per the iter-185 reviewer; the only issue is the sub-lemma `lem:smooth_codim_one_dvr`'s missing `IsRegularLocalRing` derivation route. Don't rescope the chapter or restructure unrelated blocks.
- Do NOT add new `\lean{...}` pins beyond `lem:mem_domain_partial_map_reshuffle` (which DOES need one — `AlgebraicGeometry.Scheme.RationalMap.mem_domain_iff_exists_partialMap_through_point`).
- Do NOT update `STRATEGY.md` or any file outside `blueprint/src/chapters/Albanese_CodimOneExtension.tex` (other than possibly `references/` via a reference-retriever spawn if the Stacks file is missing — see References for writing).

## Verification before reporting

- Re-read your edits to confirm:
  - The new Stacks 00TT block has `% SOURCE:` + `% SOURCE QUOTE:` (verbatim, original language) + `\textit{Source: ...}` first prose line + `\uses{...}` + the [IsAlgClosed kbar] hypothesis note.
  - `lem:mem_domain_partial_map_reshuffle` is a complete `\begin{lemma}...\end{lemma}` block with `\label`, `\lean{...}`, prose statement, and a `\begin{proof}...\end{proof}` block.
  - The `\section{Lean encoding}` list item 6 references the new label (or, if the encoding-list item already used the correct Lean FQN, the block label is wired into the surrounding `\uses{...}` graph).
- `lake build` is not your concern; the loop runs it. Just ensure the LaTeX compiles cleanly (no unbalanced braces, no missing-arg commands) — you can validate via `latexmk -pdf blueprint/print.tex` if you wish, but it is not required.

Report at `.archon/task_results/blueprint-writer-codimone-stacks-00tt.md`.
