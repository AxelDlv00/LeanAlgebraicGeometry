# Blueprint Writer Report

## Slug
ts-stalk215

## Status
COMPLETE — all four directive items applied to `Picard_TensorObjSubstrate.tex`.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Item 1 — corrected the stale "no stalk infrastructure" paragraph** (in
  `\paragraph{The gap and route~(e).}` of `sec:tensorobj_api_survey`). Removed the
  iter-214 review `% NOTE:` block entirely and rewrote the following clause. The
  prose no longer claims "no `PresheafOfModules` stalk/fiber/point infrastructure".
  It now states that the **stalk module structure is already present in Mathlib**
  (`Mathlib.Algebra.Category.ModuleCat.Stalk`: the `R.stalk x`-module structure on
  `stalk M.presheaf x` and `germ_smul`), and that what was Mathlib-absent is only
  the **linearity packaging** of the induced stalk map — now built project-side as
  the four declarations of the new `\cref{lem:stalk_linear_map}` (the linearity
  half of ingredient (d.1)) — plus the two residual ingredients (d.1-bridge) and
  (d.2). Mathlib file named in prose only (software reference; no `% SOURCE QUOTE`,
  per directive).

- **Item 2 — added the `\lean{...}`-pinned d.1-core block** under
  `sec:tensorobj_route_e`, placed immediately before
  `lem:islocallyinjective_whisker_of_W`:
  - `\begin{lemma}` `\label{lem:stalk_linear_map}`
  - `\lean{PresheafOfModules.stalkLinearMap, PresheafOfModules.stalkLinearMap_germ, PresheafOfModules.stalkLinearMap_bijective_of_isIso, PresheafOfModules.stalkLinearEquivOfIsIso}`
  - `\uses{def:scheme_modules_tensorobj}`
  - Describes mathematically: the `R.stalk x`-linear map on stalks induced by a
    morphism of presheaves of modules, characterised on germs, bijective when the
    underlying `Ab`-stalk map is an iso, bundled as a linear equivalence. States
    these are the **(d.1)-partial implementation** consumed by the `id ⊗ g_x` step
    of `lem:islocallyinjective_whisker_of_W`.
  - Added a short proof sketch block (filtered-colimit-of-section-maps argument).
  - Project-original result → no external `% SOURCE` citation (per directive).

- **Item 3 — split d.1 in the proof sketch of
  `lem:islocallyinjective_whisker_of_W`.** (Applied on the second attempt: the
  first `old_string` was reconstructed from a stale view and did not match the live
  text, whose (d.2) phrasing used the `tensorLeft`/`tensorRight` filtered-colimit
  wording and a different closing sentence. Re-matched against the exact on-disk
  text and applied.) The two-item `enumerate` (old (d.1)/(d.2), both labelled
  "Mathlib-absent") is now three items:
  - **(d.1-done)**: the `R.stalk x`-linear stalk-map packaging
    (`stalkLinearMap` & co.), built project-side, axiom-clean; cites
    `\cref{lem:stalk_linear_map}`.
  - **(d.1-bridge) (remaining)**: the site-`J.W` ⟺ stalkwise-iso characterisation
    on `Opens X`, with the concrete Mathlib assembly route named
    (`WEqualsLocallyBijective` + local-injective⟺injective-on-stalks /
    local-surjective⟺surjective-on-stalks, bridging
    `Presheaf.IsLocallyInjective/IsLocallySurjective` to the `TopCat.Presheaf`
    stalk versions).
  - **(d.2) (remaining)**: the stalk ⊗ commutation over a varying ring, with
    `(F ◁ g)_x` identified as `lTensor F_x (g_x) = id_{F_x} ⊗ g_x`; flagged as the
    largest remaining piece. The concluding paragraph now states that once (d.2)
    lands, `stalkLinearMap_bijective_of_isIso` + the linear-equivalence `lTensor`
    finish the proof flatness-free. Also removed the duplicated trailing
    sentences that were in the prior conclusion.

- **Item 4 — named the `WEqualsLocallyBijective` hypothesis** in the *statement*
  of `lem:islocallyinjective_whisker_of_W`: added prose that the site carries the
  `WEqualsLocallyBijective` property for `Ab`, so `J.W` is the class of locally
  bijective morphisms, recorded as a typeclass hypothesis
  `[J.WEqualsLocallyBijective Ab]` on the statement.

- **Cross-ref plumbing**: added `lem:stalk_linear_map` to the `\uses{...}` of the
  proof of `lem:islocallyinjective_whisker_of_W`.

## Cross-references introduced
- `\cref{lem:stalk_linear_map}` referenced from the corrected `sec:tensorobj_api_survey`
  paragraph and from the (d.1-done) item — target is the new block added this round
  (same chapter), so the reference resolves.
- `\uses{lem:stalk_linear_map}` added to the proof of
  `lem:islocallyinjective_whisker_of_W` — target in this same chapter.
- New block's `\uses{def:scheme_modules_tensorobj}` — `def:scheme_modules_tensorobj`
  exists in this chapter.

## References consulted
- None. Item 1 names a Mathlib *file* in prose (software reference, no verbatim
  literature quote required per directive); Item 2 is a project-original
  (Archon-bespoke) result requiring no external citation. No new reference material
  was needed, so no reference-retriever was dispatched.

## Macros needed (if any)
- None. All commands used (`\mathtt`, `\emph`, `\cref`, `\xrightarrow`,
  `\Longleftrightarrow`, `\mathrm`, `\otimes`, `\triangleleft`) are already in use
  throughout the chapter.

## Verification note
- All edits verified on disk. Item 1 (corrected paragraph, NOTE removed — 0
  remaining `STALE/FACTUALLY WRONG` markers), Item 2 (`lem:stalk_linear_map` block
  + proof, with the four `\lean{...}` pins), Item 3 (the three-item
  (d.1-done)/(d.1-bridge)/(d.2) `enumerate`, confirmed at lines 857/864/883), and
  Item 4 (`WEqualsLocallyBijective` prose in the statement, lines 813–816; and
  `\uses{..., lem:stalk_linear_map}` in the proof, line 836) are all present.
- The four `\lean{...}` declaration names were cross-checked against the Lean
  source and all exist in `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`:
  `stalkLinearMap` (L535), `stalkLinearMap_germ` (L576),
  `stalkLinearMap_bijective_of_isIso` (L597), `stalkLinearEquivOfIsIso` (L610);
  and `isLocallyInjective_whiskerLeft_of_W` (L411) carries
  `[J.WEqualsLocallyBijective Ab.{u}]`, matching the prose added in Item 4.
- LaTeX environment balance verified (see Notes for Plan Agent): real `lemma`
  17/17, `proof` 18/18, `enumerate` 4/4. The Item 3 first attempt missed (stale
  `old_string`) and was re-applied against the exact on-disk text.
- (Session aside: the sandbox delivered `Bash`/`Grep` stdout in delayed batches
  this session, so some checks appeared empty inline before arriving together
  later; all were ultimately confirmed.)

## Notes for Plan Agent
- **`\begin{lemma}`/`\end{lemma}` raw count asymmetry — confirmed BENIGN, no
  LaTeX error.** A raw `grep -c` reports 20 `\begin{lemma}` vs 19 `\end{lemma}`,
  but the surplus is entirely from `\begin{lemma}` / `\end{lemma}` lines that sit
  *inside* `% SOURCE QUOTE:` comment blocks (lines 1110, 1289, 1341 commented
  begins; 1302, 1354 commented ends) — verbatim quoted Lean/LaTeX snippets, not
  live environments. Restricting to non-comment lines, the real `lemma`
  environments are balanced 17/17 (and `proof` 18/18, `enumerate` 4/4,
  `definition` 5/5, `remark`/`theorem` balanced). LaTeX ignores comment lines, so
  the chapter compiles cleanly; nothing to fix. (A naive bracket-stack checker
  that ignores comments will falsely flag line 1090 — that is the checker's
  artifact, not a real unclosed environment.)
- I did not add or remove any `\leanok`/`\mathlibok` markers. The new
  `lem:stalk_linear_map` block carries no marker; the deterministic `sync_leanok`
  phase should pick it up from its `\lean{...}` declarations (all four landed
  axiom-clean in iter-214 per the directive).
- The (d.1-bridge) and (d.2) prose now describe concrete Mathlib assembly routes
  but introduce no new `\lean{...}` pins (those declarations are not yet built).
  If/when the prover lands them, they will want their own pinned blocks.

## Strategy-modifying findings
None. The route, substrate, and all statement signatures are unchanged; this was a
targeted freshness pass as directed.
