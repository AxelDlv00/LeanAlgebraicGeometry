# Blueprint Writer Report

## Slug
ts-engine210b

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Added lemma** `\begin{lemma}` / `\label{lem:flat_whisker_localizer}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.W_whiskerLeft_of_flat}` — the
  flat-whiskering bridge: for a flat presheaf-of-modules `F` and a morphism `g`
  in the sheafification localizer class `J.W`, the left-whiskered `F ◁ g` is
  again in `J.W` (and, by symmetry of `⊗`, the right-whiskered `g ▷ F`).
  - Proof sketch added: Y. Via the locally-bijective characterisation of `J.W`
    (`WEqualsLocallyBijective`) — local surjectivity from right-exactness of `⊗`
    (no hypothesis on `F`), local injectivity from flatness sectionwise
    (`Module.Flat.lTensor_preserves_injective_linearMap`). The right-whiskered
    case follows by conjugating with the symmetric braiding.
  - `\uses{def:scheme_modules_tensorobj}`.

- **Rewrote the proof** of `\label{lem:tensorobj_assoc_iso}` (statement
  unchanged: invertible `M,N,P`; `(M⊗N)⊗P ≅ M⊗(N⊗P)`) from the old
  local-trivialization/gluing argument to the **flat-exactness whiskerLeft
  3-step composite** (realization 2 of `analogies/ts-assoc-gate210.md`):
  1. absorb the inner left sheafification by `a(η ▷ P)` (P flat → bridge);
  2. transport the presheaf associator `α` via `a.mapIso α`;
  3. restore the inner right sheafification by `a(M ◁ η)` (M flat → bridge).
  Notation set up explicitly: `a = PresheafOfModules.sheafification`,
  `η = toSheafify` (in `J.W` by `instIsLocallyInjectiveToSheafify`), `M^♭` the
  underlying presheaf, `⊗ᵖ` the presheaf tensor. Flatness shown free
  (`Module.Invertible ⇒ Projective ⇒ Flat`, `Module.Flat.of_projective`).
  Closing paragraph states explicitly: no `MonoidalClosed`, no
  `tensorObj_restrict_iso`, no per-object local trivialisation / gluing cocycle.
  - Added `lem:flat_whisker_localizer` to both the statement-block and
    proof-block `\uses{}`.

- **Revised** motivation `\section` paragraph (`sec:tensorobj_motivation`) —
  replaced "associator … by local trivialisation on a common affine cover" with
  the three-step flat-whiskering composite description.

- **Revised** API-survey "The gap" paragraph (`sec:tensorobj_api_survey`) —
  replaced the local-trivialisation associator clause with the three-step
  composite + the flat-whiskering bridge as the sole non-formal input; corrected
  the "Neither route uses … absorption isomorphism" sentence (the route DOES use
  specific absorption-iso instances, just not via `MonoidalClosed` / a bundled
  `MorphismProperty.IsMonoidal`).

- **Revised** the off-path remark (`rem:scheme_modules_monoidal_off_path`) —
  added a paragraph contrasting the arbitrary-`F` whiskerLeft stability (needs
  `MonoidalClosed`) with the flat-`F` version (the bridge
  `lem:flat_whisker_localizer`, elementary), and corrected the sentence that
  claimed the coherence isos are "each assembled from the restriction-
  compatibility isomorphism `lem:tensorobj_restrict_iso`" — they are not; the
  associator now comes from flat-whiskering, the unitors/braiding from
  `sheafification.mapIso`.

- **Revised** the internal-consistency-check bullet
  (`sec:tensorobj_consistency_check`) describing the associator — replaced the
  local-trivialization description with the flat-whiskering composite, and added
  a new bullet recording `lem:flat_whisker_localizer` and its single-ingredient
  role.

## Cross-references introduced
- `\uses{lem:flat_whisker_localizer}` added in statement + proof of
  `lem:tensorobj_assoc_iso` — target is the new lemma in **this same chapter**.
- `lem:flat_whisker_localizer` `\uses{def:scheme_modules_tensorobj}` — target in
  this chapter.
- The new lemma is now referenced from the API-survey, the off-path remark, and
  the consistency-check section (all in this chapter).

## References consulted
- `references/summary.md` — confirmed `stacks-modules.tex` (tags 01CS/0B8K/01CX)
  backs the invertible-object statements already cited in the chapter. No new
  citation block was added: the bridge lemma and the associator are
  project-bespoke infrastructure (no external source named for them in the
  directive), so they stand on their proof sketches alone — consistent with the
  pre-existing uncited associator block.

## Macros needed (if any)
- None. The rewrite uses only `\triangleleft`, `\triangleright`, `\flat`,
  `\otimes`, `\cref`, and existing project macros (`\Scheme`, `\MonoidalCategory`,
  `\Spec`, `\Pic`) already defined and in use.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- LaTeX balance verified: real `lemma` 12/12, `proof` 13/13, `enumerate` 4/4.
  The aggregate `\begin`/`\end` counts differ by one (45/44) solely because of a
  truncated verbatim `% "\begin{lemma}` inside the `lem:tensorobj_inverse_invertible`
  SOURCE QUOTE (line ~798) — a LaTeX comment, pre-existing, no compilation effect.
- The off-path remark `rem:scheme_modules_monoidal_off_path` and the
  `lem:tensorobj_restrict_iso` block remain accurate and were left structurally
  intact per the directive's out-of-scope list (only the now-inaccurate
  "assembled from restrict_iso" sentence in the remark was corrected, since it
  mis-described the associator).
- `lem:flat_whisker_localizer`'s Lean name `AlgebraicGeometry.Scheme.Modules.W_whiskerLeft_of_flat`
  follows the chapter's namespace convention; the scaffolder/prover will need to
  place it in `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`. Per the
  analogy, the prover risk is bounded (~30–80 LOC over the
  `WEqualsLocallyBijective` / `IsLocallyInjective`+`IsLocallySurjective` API).

## Strategy-modifying findings
None. The re-scoping to invertible `M,N,P` (already in the statement from the
prior round) and the flat-whiskering proof route are consistent with the
strategy; the change is purely a proof-method correction backed by present
Mathlib, as established in `analogies/ts-assoc-gate210.md`.
