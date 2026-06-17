# Blueprint Writer Report

## Slug
fbc-pullback

## Status
COMPLETE

All three directed edits made. EDIT A required a new source (Stacks Schemes chapter),
fetched via a child reference-retriever before drafting the citation block.

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

- **EDIT A — added lemma** `\lemma`/`\label{lem:pullback_spec_tilde_iso}`/`\lean{AlgebraicGeometry.pullback_spec_tilde_iso}`
  — the pullback companion of `lem:pushforward_spec_tilde_iso`:
  `(Spec φ)^* (M̃) ≅ (R' ⊗_R M)~`, natural in `M`. Placed in a new
  `\subsection{The pullback companion}` immediately before
  `lem:affine_base_change_pushforward`.
  - Citation: full `% SOURCE:` + verbatim `% SOURCE QUOTE:` (statement, both parts of
    the Stacks lemma) + `% SOURCE QUOTE PROOF:` (verbatim) + visible `\textit{Source: …}`,
    all copied character-by-character from `references/stacks-schemes.tex` L1241–1256
    (Tag **01I9**, `lemma-widetilde-pullback`, §"Quasi-coherent sheaves on affines").
  - Proof sketch added: Y — pullback = extension of scalars `− ⊗_R R'`, left adjoint to
    restriction of scalars; global sections of the pullback are `R' ⊗_R M`; comparison =
    base-change unit; plus the standard-open `D(φa)` cross-check. `\uses{lem:pushforward_spec_tilde_iso}`.

- **EDIT B — revised proof of** `lem:affine_base_change_pushforward` — expanded the
  "Identification of the concrete map" closing into two explicit paragraphs:
  1. *Identification of the two sides via the affine dictionaries*: pullback dictionary
     (`lem:pullback_spec_tilde_iso`) identifies `(g')^* F` over the chart as
     `((R'⊗_R A)⊗_A M)~`; pushforward dictionary (`lem:pushforward_spec_tilde_iso`) +
     pullback dictionary identify `g^*(f_* F)` as `(R'⊗_R M)~`. Both sides become the two
     iterated tensor products as `R'`-modules.
  2. *Identification of `Γ(α)` with `cancelBaseChange`*: states that
     `pushforwardBaseChangeMap` is an abstract adjoint mate (transpose under the
     `pullback ⊣ pushforward` adjunctions), and that matching it — through the two
     dictionaries — with the concrete `TensorProduct.AlgebraTensorModule.cancelBaseChange :
     (R'⊗_R A)⊗_A M ≅ R'⊗_R M` is the crux of the remaining Lean work; once made, the affine
     case closes with no flatness.
  - Added `lem:pullback_spec_tilde_iso` to the proof block's `\uses{...}`
    (`lem:pushforward_spec_tilde_iso` was already present).

- **EDIT C — demoted** `lem:gammaPushforwardIsoAt_naturality`:
  - Deleted the standalone `\begin{lemma}[Naturality …]\label{lem:gammaPushforwardIsoAt_naturality}…\end{lemma}`
    block and its proof, and the preceding iter-241 `% NOTE:` comment.
  - Absorbed its content as an unlabelled prose remark ("*Naturality of the family …*")
    inside the proof of `lem:gammaPushforwardIsoAt`, stating the family `{e_U}` is natural
    in the open, each `e_U` a composite of structure-sheaf restriction maps and
    identity-on-carrier `restrictScalars` repackagings.
  - Removed `lem:gammaPushforwardIsoAt_naturality` from the `\uses{}` of
    `lem:pushforward_spec_tilde_iso`'s proof block (only that entry; rest untouched).
  - Repointed the four body `\ref{lem:gammaPushforwardIsoAt_naturality}` occurrences (in
    `lem:pushforward_spec_tilde_iso`'s proof) to refer to the naturality remark in the
    proof of `lem:gammaPushforwardIsoAt`, and updated the `lem:gammaPushforwardIsoAt`
    statement sentence that named the deleted label. Also updated the stale `% NOTE:`
    comment inside `lem:pushforward_spec_tilde_iso`'s statement that named the label.

## Cross-references introduced
- `\uses{lem:pullback_spec_tilde_iso}` added in proof of `lem:affine_base_change_pushforward`
  — target is the new lemma in this same chapter. ✓
- `\uses{lem:pushforward_spec_tilde_iso}` in proof of `lem:pullback_spec_tilde_iso`
  — target exists in this same chapter. ✓
- All `\ref{lem:gammaPushforwardIsoAt_naturality}` removed; no dangling references remain
  (verified by grep). Environment begin/end counts balanced (lemma 14/14, proof 15/15,
  remark 1/1, definition 1/1, theorem 1/1).

## References consulted
- `references/stacks-schemes.tex` — verbatim statement + proof quote for
  `lem:pullback_spec_tilde_iso` (Tag 01I9, L1241–1269). Fetched this session by the child
  reference-retriever below.
- `references/summary.md` — confirmed which Stacks chapters were already present (Schemes
  was absent ⇒ retrieval needed).

## Macros needed (if any)
None. (`\Spec`, `\widetilde`, `\otimes`, `\operatorname` all already in use in the chapter;
the verbatim quote's `\Spec`/`\mathcal` live inside `%`-comments.)

## Reference-retriever dispatches (if any)
- slug `stacks-schemes`: requested the Stacks Project "Schemes" chapter for
  `schemes-lemma-widetilde-pullback`. Status: COMPLETE. Downloaded
  `references/stacks-schemes.tex` (verified LaTeX). Located the lemma at L1241–1256 (Tag
  01I9). Pointer `references/stacks-schemes.md`; registered in `references/summary.md`.

## Notes for Plan Agent
- The new `lem:pullback_spec_tilde_iso` has a `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}`
  hint but no Lean decl yet exists — it is the next FlatBaseChange prover target (the
  pullback companion brick), exactly as the directive frames it. No `\leanok` added (per
  rules); `sync_leanok` will leave it unmarked until the decl lands.
- EDIT B's second paragraph names the two concrete obligations (`pushforwardBaseChangeMap`
  adjoint-mate ↔ `cancelBaseChange`) that the lean-vs-blueprint checker flagged as
  under-specified; the affine proof sketch now states them explicitly. The proof block
  still carries no `\leanok` on its own (the lemma statement block has `\leanok` from a
  prior sync; the proof is in progress per the in-file `% NOTE:`).
- The Stacks lemma 01I9 is a single lemma with two parts; part (2) (pushforward) is the
  classical statement already realized by `lem:pushforward_spec_tilde_iso`, part (1)
  (pullback) is the new block. They could later be cited as one source for both dictionary
  lemmas if desired.

## Strategy-modifying findings
None. The edits are consistent with the existing engine-lane A.2.c strategy; the affine
case reduces to `cancelBaseChange` with no flatness, exactly as STRATEGY assumes.
