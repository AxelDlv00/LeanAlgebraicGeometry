# Blueprint Writer Report

## Slug
jacobian-iter118

## Status
COMPLETE

All three must-fix items from the directive (Fix 1, Fix 2, Fix 3) are
addressed; no proof-block content of `thm:nonempty_jacobianWitness` and
no protected-instance theorem block were modified.

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made

- **Fix 1 — Revised** `thm:IsAlbanese_unique` (statement block, replacing
  the iter-117 "uniquely isomorphic by an isomorphism" prose). New prose
  introduces named morphisms $\iota_i := h_i.\mathtt{ofCurve}$ and states
  the conclusion as "there is a unique morphism $e \colon J_1 \to J_2$
  satisfying $\iota_2 = \iota_1 \circ e$", matching the Lean signature
  `∃! (e : J₁ ⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e` exactly. Prose
  acknowledges that $e$ is an isomorphism but flags that the iso content
  is not exposed in the conclusion. `\uses{}` augmented with
  `def:IsAlbanese_ofCurve`.

- **Fix 1 (companion) — Added remark** `rem:IsAlbanese_unique_iso`. One-paragraph
  remark immediately after `thm:IsAlbanese_unique` documenting that the Lean
  proof internally computes the inverse morphism `h` and verifies
  `g ≫ h = 𝟙 J₁`, `h ≫ g = 𝟙 J₂` (Lean lines 104, 113) before returning
  only the morphism-and-uniqueness triple. Names the natural strengthening
  `∃! (e : J₁ ≅ J₂), ...` and labels this as a Lean-side refactor candidate
  out of iter-118 scope, with a note that downstream consumers in the
  protected `AbelJacobi.Jacobian.*` interface use only the morphism content.

- **Fix 2 — Added new `\subsection`** "The Albanese witness bundle" inside
  Section "Existence of an Albanese variety", placed before
  `thm:nonempty_jacobianWitness`. Contains three new blocks:
  - **Added definition** `\definition`/`\label{def:JacobianWitness}`/`\lean{AlgebraicGeometry.JacobianWitness}` —
    enumerates all seven fields of the structure: `J`, `grpObj`, `proper`,
    `smooth`, `geomIrred`, `smoothGenus` (with note that it refines `smooth`),
    `isAlbaneseFor : ∀ P, IsAlbanese C P J`.
  - **Added remark** `\label{rem:JacobianWitness_quantifier_order}` — design-choice
    remark explaining the $\exists J, \forall P$ vs classical $\forall P, \exists J$
    quantifier reversal, with mathematical justification (translation by a point is
    an automorphism, so $J$ is intrinsic) and pragmatic justification (clean
    per-$P$ projection in `AbelJacobi.Jacobian.*`).
  - **Added remark** `\label{rem:JacobianWitness_smooth_redundancy}` — the optional
    one-line remark on `smooth` vs `smoothGenus` redundancy, citing Mathlib's
    `SmoothOfRelativeDimension.smooth` and explaining that both fields are kept
    for projection-site convenience.

- **Fix 2 (companion) — Revised** `thm:nonempty_jacobianWitness` statement block
  only: appended one sentence ("Equivalently, the type of Albanese witnesses for $C$
  ... is non-empty.") tying the prose statement to `def:JacobianWitness`, and added
  `def:JacobianWitness` to its `\uses{}` list. The proof block (lines 239+) was
  NOT touched.

- **Fix 3 — Added new `\subsection`** "Extracting the universal morphism" inside
  Section "The Albanese construction", placed between `rem:IsAlbanese_typeclasses`
  and `thm:IsAlbanese_unique`. Contains a 2-sentence narrative paragraph plus three
  new blocks:
  - **Added definition** `\label{def:IsAlbanese_ofCurve}`/`\lean{AlgebraicGeometry.IsAlbanese.ofCurve}` —
    defines $\iota := h.\mathtt{ofCurve} : C \to J$ via `Classical.choose`.
  - **Added lemma** `\label{lem:IsAlbanese_comp_ofCurve}`/`\lean{AlgebraicGeometry.IsAlbanese.comp_ofCurve}` —
    states $P \circ h.\mathtt{ofCurve} = \eta_J$.
  - **Added lemma** `\label{lem:IsAlbanese_exists_unique_ofCurve_comp}`/`\lean{AlgebraicGeometry.IsAlbanese.exists_unique_ofCurve_comp}` —
    states the universal-factorisation property.

  Followed by a closing paragraph naming the protected `Jacobian.ofCurve`,
  `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` of
  Chapter~\ref{chap:AbelJacobi} as the consumers of this extraction API.

- **Revised** `def:Jacobian` (definition block): added `def:JacobianWitness` to its
  `\uses{}` line for dependency-graph accuracy. Definition body untouched.

## Cross-references introduced

- `\uses{def:IsAlbanese_ofCurve}` in `thm:IsAlbanese_unique` — verify
  `def:IsAlbanese_ofCurve` exists. **PRESENT** (added in this iter, line 44 of new chapter).
- `\uses{thm:IsAlbanese_unique}` in `rem:IsAlbanese_unique_iso` — verify
  `thm:IsAlbanese_unique` exists. **PRESENT** (existing, line 77).
- `\uses{def:IsAlbanese}` in `def:IsAlbanese_ofCurve` — verify
  `def:IsAlbanese` exists. **PRESENT** (existing, line 27).
- `\uses{def:IsAlbanese_ofCurve}` in both new lemma blocks — verify
  `def:IsAlbanese_ofCurve` exists. **PRESENT** (added in this iter).
- `\uses{def:IsAlbanese, def:genus}` in `def:JacobianWitness` — both
  exist (`def:IsAlbanese` line 27 of new chapter; `def:genus` in
  `chapters/Genus.tex`).
- `\uses{def:JacobianWitness}` in `rem:JacobianWitness_quantifier_order`,
  `rem:JacobianWitness_smooth_redundancy`, in updated `def:Jacobian`'s
  `\uses{}`, and in updated `thm:nonempty_jacobianWitness`'s `\uses{}`
  — verify `def:JacobianWitness` exists. **PRESENT** (added in this iter,
  line 195 of new chapter).
- `\ref{rem:IsAlbanese_unique_iso}` inside `thm:IsAlbanese_unique`'s body
  prose — verify `rem:IsAlbanese_unique_iso` exists. **PRESENT** (added in
  this iter, line 84).
- `\ref{rem:JacobianWitness_quantifier_order}` inside the new subsection's
  narrative — verify it exists. **PRESENT** (added in this iter, line 212).
- `\ref{rem:JacobianWitness_smooth_redundancy}` inside the
  `def:JacobianWitness` body's bullet on `smoothGenus` — verify it exists.
  **PRESENT** (added in this iter, line 226).
- `\ref{def:JacobianWitness}` inside `thm:nonempty_jacobianWitness`
  statement-prose tail and inside the closing paragraph of the
  "Extracting the universal morphism" subsection — verify
  `def:JacobianWitness` exists. **PRESENT** (added in this iter).
- `\ref{def:IsAlbanese_ofCurve}`, `\ref{lem:IsAlbanese_comp_ofCurve}`,
  `\ref{lem:IsAlbanese_exists_unique_ofCurve_comp}` inside
  `rem:JacobianWitness_quantifier_order` — verify all three exist.
  **PRESENT** (all added in this iter).

LaTeX balance verified: 31 `\begin{...}` / 31 `\end{...}` (post-edit).

## Macros needed (if any)

None. All math symbols and macros (`\Spec`, `\Jac`, `\Pic`, `\Sym`,
`\genus`, `\Hom`, `\mathtt`, `\texttt`, `\colon`, `\eta`, etc.) used in
the new content are either already in use in this chapter or are
standard LaTeX/AMS.

## Reference-retriever dispatches (if any)

None. The edits are documentation-side cleanup tied to the existing
Lean signatures in `AlgebraicJacobian/Jacobian.lean`; no external
reference material was needed beyond the existing
`references/challenge.lean` (which was consulted only to confirm
protected-signature stability via `archon-protected.yaml`).

## Notes for Plan Agent

- **No new `\leanok` markers added.** Per the rules (CLAUDE.md and the
  subagent prompt body), all `\leanok` / `\mathlibok` markers are managed
  by the deterministic `sync_leanok` phase or by the review agent. The
  three new declaration blocks (`def:IsAlbanese_ofCurve`,
  `lem:IsAlbanese_comp_ofCurve`,
  `lem:IsAlbanese_exists_unique_ofCurve_comp`) and the one new structure
  block (`def:JacobianWitness`) currently carry no `\leanok` marker; the
  next `sync_leanok` run should add `\leanok` to all four of them, since
  their Lean targets (`AlgebraicGeometry.IsAlbanese.ofCurve`,
  `.comp_ofCurve`, `.exists_unique_ofCurve_comp`, and
  `AlgebraicGeometry.JacobianWitness`) are all `sorry`-free in
  `AlgebraicJacobian/Jacobian.lean` (lines 67, 72, 78, 143 respectively).
  The two new `\begin{remark}` blocks don't take `\leanok` (remarks are
  prose, not formalised claims).
- **The in-proof `\leanok` on `thm:nonempty_jacobianWitness`** (now at
  line 241 of the post-edit chapter, line 148 of the iter-117 chapter)
  is unchanged by this iter — the directive flagged this as a
  `sync_leanok` concern, not a writer concern. The proof block is still
  marked `\leanok` despite the Lean body being `:= sorry`. The next
  `sync_leanok` should strip it; flag if it doesn't.
- **No conflicts with `archon-protected.yaml`.** Verified that
  `IsAlbanese.unique`, `IsAlbanese.ofCurve`, `IsAlbanese.comp_ofCurve`,
  `IsAlbanese.exists_unique_ofCurve_comp`, and `JacobianWitness` are NOT
  protected (only the five `Jacobian.*` items in `Jacobian.lean` and the
  three protected `AbelJacobi.Jacobian.*` items are). Adding blueprint
  references to these non-protected Lean declarations is in scope for
  the writer.
- **Potential cross-chapter note (optional, not acted on):** The
  `def:JacobianWitness` block introduces a public anchor that
  `chapters/Modules_Monoidal.tex` could now `\uses{}`-link when it
  informally mentions `JacobianWitness`. This is out of this writer's
  write-domain; flagging for the plan agent if cross-chapter dependency
  graph polish is desired in a later iter.

## Strategy-modifying findings

None. The edits clarify the existing prose/Lean correspondence and add
blueprint anchors for already-existing Lean declarations; no
strategy-level concern was surfaced by the writing.
