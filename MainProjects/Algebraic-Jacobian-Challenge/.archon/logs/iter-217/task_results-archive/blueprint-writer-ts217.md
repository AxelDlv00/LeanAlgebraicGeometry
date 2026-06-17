# Blueprint Writer Report

## Slug
ts217

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### MUST-FIX 1 — `lem:tensorobj_restrict_iso` proof block
- **Deleted** the `% NOTE (review iter-216): ...` comment at the top of the proof
  block (the 10-line note flagging the refuted free-cover guidance).
- **Deleted in full** the trailing `\emph{The make-or-break: only the free-cover case
  is on the critical path.}` paragraph, including its "fallback / revert to route (e)"
  closing sentence. The free-cover-avoids-H1 narrative is entirely removed.
- **Elevated Step 3** to the definitive, sole remaining obligation. Rewrote the
  closing two paragraphs so the proof now ends by stating (a) the residual is the
  presheaf-level `pushforward β ≅ pullback φ` via `Adjunction.leftAdjointUniq`, built
  from a presheaf-level `pushforward β ⊣ pushforward φ`, the presheaf analogue of
  the sheaf-level `SheafOfModules.pushforwardPushforwardAdj`, needing the
  Mathlib-absent presheaf `pushforwardNatTrans` / `pushforwardCongr` (presheaf
  `pushforwardId` / `pushforwardComp` already exist); (b) that it is being built
  **directly** (Mathlib-gradient build), **not deferred to an upstream PR**; (c) that
  because the sole consumer commutes the restriction past the *sheafified* tensor
  before any trivialisation enters, H1 is genuinely on the critical path and no
  free-cover shortcut exists; (d) that route-(e) survives only as a named last-resort
  fallback.
- **Added** a `% SOURCE:` + `% SOURCE QUOTE:` citation (verbatim, from
  `references/stacks-modules.tex`, L252–273) for the pullback ⊣ pushforward
  adjunction `(f^*, f_*)` of O-modules, plus a visible `\textit{Source: ...}` line.
  The Mathlib template `SheafOfModules.pushforwardPushforwardAdj` is cited as a code
  reference (file path), not as a `% SOURCE QUOTE`.

### MUST-FIX 2 — `lem:tensorobj_assoc_iso` proof block
- **Deleted** the `% NOTE (review iter-216): ...` comment at the top.
- **Deleted in full** the trailing `\emph{The free-cover make-or-break.}` paragraph
  (free-cover ⇒ no-H1 + route-(e) fallback).
- **Rewrote** the proof to be honest about current vs. target:
  - **Current realization first** (matches the Lean): associator obtained by
    transporting the presheaf associator `α` through sheafification, pulling the inner
    sheafification out of the nested `(M⊗N)⊗P` via `W_whiskerRight_of_W` /
    `W_whiskerLeft_of_W` (`lem:whisker_of_W`) + `isIso_sheafification_map_of_W`, and
    explicitly noting this route is transitively gated on the open sorry
    `isLocallyInjective_whiskerLeft_of_W` (`lem:islocallyinjective_whisker_of_W`).
  - **Planned re-route as target** (not yet realized): once
    `lem:tensorobj_restrict_iso` is closed via H1, the associator is re-built by
    gluing the local isos `((M⊗N)⊗P)|_U ≅ (M|⊗N|)⊗P| ≅ M|⊗(N|⊗P|) ≅ (M⊗(N⊗P))|_U`
    (two `tensorobj_restrict_iso` + presheaf `α`), agreeing on overlaps by naturality,
    glued via "Hom-of-sheaves is a sheaf". Kept the accurate overlap-naturality /
    global-data paragraph (stronger than the pointwise
    `lem:tensorobj_preserves_locally_trivial`). Stated that after the re-route the
    vestigial whiskering / `(J.W).IsMonoidal` / stalk apparatus is deleted.
  - Updated the `\uses{...}` of the proof to add `lem:whisker_of_W,
    lem:islocallyinjective_whisker_of_W` (now genuinely referenced).

### MAJOR — pinned the 5 iter-216 H2 declarations
- **Added a companion lemma block** `lem:restrictscalars_ringiso_strongmonoidal`
  immediately after `lem:restrictscalars_ringiso_tensorequiv`, with a multi-name
  `\lean{...}` pin for all five: `restrictScalars_isIso_μ`, `restrictScalars_isIso_ε`,
  `restrictScalarsMonoidalOfRingEquiv`, `restrictScalars_isIso_μ_of_bijective`,
  `restrictScalars_isIso_ε_of_bijective`. The body gives one-sentence descriptions of
  each, explains they constitute the ModuleCat-level H2 ("strong restrictScalars along
  a ring iso commutes with ⊗"), and that the *remaining* H2 step is the bounded,
  no-Mathlib-gap PRESHEAF lift (`(PresheafOfModules.restrictScalars α).Monoidal` via
  `Functor.Monoidal.ofLaxMonoidal` + CommRingCat-iso→Bijective bridge +
  PresheafOfModules iso-iff-app-iso reflection), after which `pushforward β` is
  monoidal — the sole genuinely Mathlib-absent piece being H1.
- Verified all five names exist at top level (bare, in `section
  RestrictScalarsRingIsoTensor`, no enclosing namespace) in
  `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:219,237,253,266,275`, matching the
  bare-name convention of the existing `restrictScalarsRingIsoTensorEquiv` pin.

## Cross-references introduced
- `\uses{lem:whisker_of_W, lem:islocallyinjective_whisker_of_W}` added to the
  `lem:tensorobj_assoc_iso` proof — both labels exist in this chapter (L1230, L1077).
- `\uses{lem:restrictscalars_ringiso_tensorequiv}` in the new
  `lem:restrictscalars_ringiso_strongmonoidal` block — label exists in this chapter.
- New label `lem:restrictscalars_ringiso_strongmonoidal` (L714).
- In-proof `\cref{lem:jw_ismonoidal}` (route-(e) fallback) — label exists (L1279).

## References consulted
- `references/stacks-modules.tex` (Stacks ch.17 "Modules on Ringed Spaces"),
  Lemma `lemma-exactness-pushforward-pullback`, L252–273 — verbatim `% SOURCE QUOTE`
  for the `(f^*, f_*)` adjoint pair of O-modules used in the `tensorobj_restrict_iso`
  comparison.
- `references/summary.md` — index, to confirm `stacks-modules.tex` is the local
  source holding the adjunction.

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None — the adjunction was available locally in `references/stacks-modules.tex`.

## Notes for Plan Agent
- The current realization of `lem:tensorobj_assoc_iso` (whiskering route) and the
  planned target (direct gluing via `tensorobj_restrict_iso`) are now both documented
  and clearly labelled "current" vs. "planned". The blueprint sketch matches the Lean
  as it stands; when the prover closes H1 and re-routes the associator, the "Current
  realization" paragraph and the whiskering `\uses` should be retired by a follow-up
  blueprint edit.
- The off-path route-(e) blocks (`lem:jw_ismonoidal`, `lem:whisker_of_W`,
  `lem:islocallyinjective_whisker_of_W`, `lem:flat_whisker_localizer`) remain
  documented as superseded; I did not promote any of them. They are still referenced
  by the now-honest current-realization paragraph because the Lean genuinely depends
  on them today.

## Strategy-modifying findings
None. The prose corrections are fully consistent with the H1-build plan: H1
(presheaf-level pushforward adjunction) is the single open substrate obligation, being
built directly; the ModuleCat-level H2 core is closed; the presheaf H2 lift is bounded
and Mathlib-gap-free. Nothing surfaced that contradicts building H1.
