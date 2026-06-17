# Blueprint Writer Directive — CodimOneExtension Stage 5/6 pins + Stacks 00TT note + weil_divisor_obstruction (WD-2)

## Slug

codimoneext-stage6-pins

## Chapter

`blueprint/src/chapters/Albanese_CodimOneExtension.tex`

## Problem

The iter-194 blueprint-reviewer flagged Lane M↓ (Stage 6) HARD GATE
FAIL with three independent blockers in this chapter:

**M-1**: `lem:smooth_to_regular_local_ring` (Stacks 00TT) has **no
`\leanok`** because the Lean body is still a sorry. The chapter prose
is present but the gap is not explicitly documented.

**M-2**: Stage 5/6 Kähler-localisation helpers from iter-193 are
**absent from the blueprint** — no `\lemma` blocks, no `\lean{...}`
pins for the iter-191/192/193 substrate additions:
- `Flat.stalkMap` re-export (Stage 1)
- `Smooth.exists_isStandardSmooth` re-export (Stage 2)
- `exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth`
  (Stage 3, iter-192)
- `module_free_kaehlerDifferential_of_isStandardSmooth` (Stage 4, iter-192)
- `module_free_kaehlerDifferential_localization` (Stage 5a, iter-193)
- `rank_kaehlerDifferential_localization_eq_relativeDimension` (Stage 5b, iter-193)

**M-3**: `thm:weil_divisor_obstruction` has **no `\lean{...}` pin**
(detached iter-179). The prose is present but the Lean name is absent
in the blueprint; `lean-vs-blueprint` tracking cannot follow it.

## Scope

Three independent edits to `blueprint/src/chapters/Albanese_CodimOneExtension.tex`:

### Edit 1 (M-1): Document Stacks 00TT gap on `lem:smooth_to_regular_local_ring`

Find the block for `lem:smooth_to_regular_local_ring` (grep
`smooth_to_regular_local_ring`). Add a NOTE comment in the prose body
documenting:

```latex
  % NOTE (iter-194 reviewer): the Lean body of
  % `isRegularLocalRing_stalk_of_smooth` is currently a typed sorry
  % gated on the Stacks 00OE (smooth-algebra dimension formula) +
  % Stacks 02JK (cotangent ↔ Kähler over a field) Mathlib gaps.
  % Iter-193 prover landed Stages 5a + 5b axiom-clean
  % (`module_free_kaehlerDifferential_localization` +
  % `rank_kaehlerDifferential_localization_eq_relativeDimension`)
  % which set up the Kähler-differential chain. Stage 6 closure
  % depends on the 00OE + 02JK bridges; both are tracked iter-200+
  % mathlib-analogist sweep targets.
```

Do NOT add `\leanok` (the Lean body is still sorry; `sync_leanok` will
correctly NOT mark it).

### Edit 2 (M-2): Add Stage 5/6 Kähler-localisation `\lemma` blocks

Add a new subsection `\subsection{Stage 5/6: Kähler localisation
substrate}` near where the existing Stage 5/6 prose lives (use the
existing section structure for placement — likely after the discussion
of `isRegularLocalRing_stalk_of_smooth`).

Inside the subsection, add **two `\lemma` blocks** for the iter-193
Kähler-localisation helpers:

```latex
\begin{lemma}
[Kähler differentials are free under localisation of a smooth algebra]
  \label{lem:module_free_kaehler_localization}
  \lean{AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_localization}
  % <verify the exact namespace by reading the Lean declaration>
  \uses{lem:kaehler_isLocalizedModule_map}
  Let $R \to S$ be a ring homomorphism with $\Omega_{S/R}$ free over
  $S$, and let $M \subseteq S$ be a multiplicative submonoid. Then
  $\Omega_{S_M / R}$ is free over $S_M$.
\end{lemma}

\begin{lemma}
[Rank of Kähler differentials under localisation equals relative dimension]
  \label{lem:rank_kaehler_localization_eq_relative_dim}
  \lean{AlgebraicGeometry.Scheme.rank_kaehlerDifferential_localization_eq_relativeDimension}
  % <verify the exact namespace by reading the Lean declaration>
  \uses{lem:module_free_kaehler_localization}
  Under the hypotheses of \cref{lem:module_free_kaehler_localization},
  the rank of $\Omega_{S_M / R}$ over $S_M$ equals the relative
  dimension of the smooth algebra $R \to S$.
\end{lemma>
```

**Verify the Lean namespaces by reading the actual declarations**
(grep for the declaration names in
`AlgebraicJacobian/Albanese/CodimOneExtension.lean` to find them).

Place these BEFORE the iter-194 NOTE you added in Edit 1, so the chain
reads: Stages 1-2 (existing prose) → Stages 3-4 (existing prose) →
Stage 5a/5b (NEW blocks) → Stage 6 (NOTE on the open gap).

### Edit 3 (M-3): Restore `\lean{...}` pin on `thm:weil_divisor_obstruction`

Find the block for `thm:weil_divisor_obstruction` (grep
`thm:weil_divisor_obstruction`). It should currently lack a `\lean{...}`
field. Read the Lean file `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
to find the corresponding Lean theorem (search for "weil divisor
obstruction" in docstrings, or check the theorem closest to the prose
content). Add:

```latex
  \lean{<exact Lean namespace>.<exact Lean theorem name>}
```

If the corresponding Lean declaration genuinely does not exist (i.e.
the iter-179 detach was structural, not just a `\lean{...}` typo),
report this back in your task report and leave the chapter block with
a `% NOTE (iter-194 writer): no corresponding Lean declaration found
in CodimOneExtension.lean — iter-195 must either rename to match an
existing decl or add a new Lean stub.`

### Out of scope

- Do NOT add `\leanok` markers (managed by `sync_leanok`).
- Do NOT modify the proof body of `lem:smooth_to_regular_local_ring`
  beyond the NOTE block.
- Do NOT touch existing `\lean{...}` pins that already match Lean
  declarations.
- Do NOT add Stage 1-4 helper blocks — those are pre-existing prose
  and shouldn't need pinning at the `\lemma`-block level (verify by
  inspection; if any Stage 1-4 helpers landed iter-191/192 as Lean
  declarations without blueprint pins, document but do NOT pin them
  in this directive's scope — iter-195+ work).

## References

- Stacks 00OE (smooth-algebra dimension formula).
- Stacks 02JK (cotangent ↔ Kähler over a field).
- Stacks 00TT (smooth → regular local ring, iff direction at codim 1).
- Lean source: `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
  (grep for the declaration names).

## Verification

After your edits, `lake build AlgebraicJacobian.Albanese.CodimOneExtension`
should still exit 0 (your blueprint edits don't affect Lean). The
deterministic `sync_leanok` phase will check that the new `\lean{...}`
pins match actual Lean declarations.

## Expected outcome

After this writer dispatch, the CodimOneExtension chapter:
1. Has a NOTE block documenting the Stacks 00TT gap on
   `lem:smooth_to_regular_local_ring`.
2. Has 2 new `\lemma` blocks for the iter-193 Kähler-localisation
   helpers.
3. Has a restored `\lean{...}` pin on `thm:weil_divisor_obstruction`
   (or a documented gap if no Lean correspondent exists).

The iter-194 blueprint-reviewer HARD GATE blocker for Lane M↓ is
resolved (M-1, M-2, M-3 addressed). Iter-195 mandatory blueprint-reviewer
will confirm.

If the same-iter fast path is exercised this iter (additional
blueprint-reviewer scoped to this chapter), Lane M↓ may be added
back to iter-194 prover dispatch. Otherwise Lane M↓ is auto-released
for iter-195.
