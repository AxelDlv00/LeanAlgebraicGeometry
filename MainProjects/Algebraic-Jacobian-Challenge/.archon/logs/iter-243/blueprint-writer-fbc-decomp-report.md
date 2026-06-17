# Blueprint Writer Report

## Slug
fbc-decomp

## Status
COMPLETE — all three required edits made; chapter remains valid LaTeX (env balance verified).

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:gammaPushforwardNatIso}`/`\lean{AlgebraicGeometry.gammaPushforwardNatIso}`
  — pin block for the substantive supporting declaration that had no `\lean{}` block. States the
  natural isomorphism of functors `(Spec φ)_* ⋙ Γ_R ≅ Γ_{R'} ⋙ restr_φ` packaging the per-object
  `gammaPushforwardIso` comparison; notes naturality is pointwise-identity and that it is the
  right-adjoint natural iso driving the uniqueness-of-left-adjoints proof of
  `lem:pullback_spec_tilde_iso`. Placed in the pullback-companion subsection, immediately BEFORE
  `lem:pullback_spec_tilde_iso`. `\uses{lem:gammaPushforwardIso}`. Archon-local — no external
  SOURCE QUOTE.
  - Proof sketch added: Y (components from `lem:gammaPushforwardIso`; naturality on the nose because
    every constituent is identity-on-carrier).
- **Added lemma** `\lemma`/`\label{lem:base_change_map_affine_local}` — Obligation 1, the affine
  reduction: `pushforwardBaseChangeMap` is compatible with restriction to affine opens of `S'`, so
  `IsIso` over arbitrary `(S,S',X,X')` reduces via `lem:modules_isIso_iff_affineOpens` to the
  affine-affine case. Prose flags the base-change-of-the-base-change-map naturality as Mathlib-absent.
  `% SOURCE` + verbatim `% SOURCE QUOTE` from the Stacks `lemma-affine-base-change` proof
  ("local on $S$ and $S'$" step). No `\lean{}` (not yet a separate Lean declaration → unformalized block).
  - Proof sketch added: Y.
- **Added lemma** `\lemma`/`\label{lem:pushforward_base_change_mate_cancelBaseChange}` — Obligation 2,
  the affine-affine crux: `Γ(α)` transported through the four dictionary isos
  (`lem:pushforward_spec_tilde_iso`, `lem:pullback_spec_tilde_iso`) equals
  `TensorProduct.AlgebraTensorModule.cancelBaseChange` `((r'⊗a)⊗m ↦ r'⊗(a·m))`; closes the affine case
  since `cancelBaseChange` needs no flatness. Prose flags it as the genuine crux (adjoint-mate
  coherence, the content a `#37189`-style Mathlib bridge would supply). `% SOURCE` + verbatim
  `% SOURCE QUOTE` ("boils down to the equality" step). No `\lean{}`.
  - Proof sketch added: Y.
  - Both obligation blocks grouped under a new subsection
    `\subsection{The affine base-change lemma and its remaining obligations}` that also now heads
    `lem:affine_base_change_pushforward` (its consumer).
- **Revised** proof of `lem:affine_base_change_pushforward` — added
  `lem:base_change_map_affine_local, lem:pushforward_base_change_mate_cancelBaseChange` to the proof
  `\uses{}`. Existing proof prose and the `% NOTE (updated iter-242)` left fully intact.

## Cross-references introduced
- `\uses{lem:gammaPushforwardIso}` in `lem:gammaPushforwardNatIso` (and its proof) — `lem:gammaPushforwardIso` exists in this chapter (L201).
- `\uses{def:pushforward_base_change_map, lem:modules_isIso_iff_affineOpens}` in `lem:base_change_map_affine_local` — both exist in this chapter.
- `\uses{def:pushforward_base_change_map, lem:pushforward_spec_tilde_iso, lem:pullback_spec_tilde_iso}` in `lem:pushforward_base_change_mate_cancelBaseChange` — all exist in this chapter.
- `\uses{..., lem:base_change_map_affine_local, lem:pushforward_base_change_mate_cancelBaseChange}` added to proof of `lem:affine_base_change_pushforward` — both new labels defined in this same chapter, immediately above.

## References consulted
- `references/stacks-coherent.tex` (L905–938) — verbatim `% SOURCE QUOTE` text for both obligation
  blocks: the "local on $S$ and $S'$" fragment (L923–926) for `lem:base_change_map_affine_local`, and
  the "boils down to the equality" fragment (L927–937) for
  `lem:pushforward_base_change_mate_cancelBaseChange`. Both copied character-for-character.
- Lean source `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (L656–693, L701–730) — read (not a
  reference file) to confirm `gammaPushforwardNatIso`'s exact functor signature and its role in
  `pullback_spec_tilde_iso`, and to confirm the two-obligation framing in the in-file sorry comment.

## Macros needed (if any)
- None. All commands used (`\Spec`, `\widetilde`, `\operatorname`, `\mathcal`, `\xrightarrow`) already in use throughout the chapter.

## Reference-retriever dispatches (if any)
- None. The required verbatim source was already present in `references/stacks-coherent.tex`.

## Notes for Plan Agent
- The two obligation blocks deliberately carry NO `\lean{}` (no separate Lean declaration exists yet
  for either; the blocker currently lives inside the `affineBaseChange_pushforward_iso` sorry body).
  They are therefore unmarked (unformalized) blocks — `sync_leanok`/`blueprint-doctor` will see them
  as `\lean`-less lemmas. That is intentional: they are named handles for the prover. If the next
  prover round formalizes one as a standalone declaration, the corresponding `\lean{...}` hint should
  be added then.
- Structural note: the affine base-change lemma now sits under the new subsection
  `The affine base-change lemma and its remaining obligations` (previously it trailed under
  `The pullback companion`). The grouping reads naturally — obligations stated first, consumer lemma
  after.
- Out-of-scope items (`thm:flat_base_change_pushforward`, the two closed dictionary lemmas) were not
  touched; the `lem:pullback_spec_tilde_iso` proof was left as-is (its `\uses` was NOT extended to the
  new `lem:gammaPushforwardNatIso`, per the do-not-alter-its-proof instruction — the new pin block
  documents the dependency in prose instead).

## Strategy-modifying findings
None. The decomposition matches the existing in-file/in-blueprint framing of the two Mathlib-absent
obligations; no strategy-level inconsistency surfaced.
