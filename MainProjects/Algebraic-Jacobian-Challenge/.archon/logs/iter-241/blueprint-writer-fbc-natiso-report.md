# Blueprint Writer Report

## Slug
fbc-natiso

## Status
COMPLETE — added the `gammaPushforwardIsoAt` open-naturality block and rewrote the
`lem:pushforward_spec_tilde_iso` proof sketch so the single remaining obligation
(`hloc(a)` from ⊤-level localization + open-naturality) is precisely specified; the
stale "carrier wall" framing is removed.

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

- **Added lemma** `\lemma`/`\label{lem:gammaPushforwardIsoAt_naturality}` (UNPINNED — no
  `\lean{...}`, no external citation; bespoke). States that the open-indexed family
  `{e_U}_U` of `lem:gammaPushforwardIsoAt` is a **natural isomorphism** between two
  presheaves of `R`-modules on `Spec R`:
  - source presheaf `P : U ↦ Γ((Spec φ)_* N, U)` with the pushforward's structure-sheaf
    restriction maps;
  - target presheaf `Q : U ↦ restr_φ(Γ(N, (Spec φ)^{-1}U))` with `N`'s restriction maps
    transported through `(Spec φ)^{-1}` and read by restriction of scalars along `φ`.
  - The naturality square for `U' ⊆ U` (with `V=(Spec φ)^{-1}U`, `V'=(Spec φ)^{-1}U'`) is
    drawn explicitly and asserted commuting.
  - Proof sketch added (Y): every constituent of `e_U` is either a structure-sheaf
    restriction map or conjugation by a *fixed* (open-independent) ring map; both commute
    with further restriction, so the square is the paste of the three component-naturality
    squares (inverse-naturality of the `restrictScalarsComp'` reconciliation,
    `eqToHom`-naturality of the top-open ring equation, hom-naturality of the
    `restrictScalarsComp'` for `φ`). Left the realization route open (e.g. `NatIso` of the
    per-open `e_U`) without prescribing a Lean name, as directed.

- **Revised** `lem:gammaPushforwardIsoAt` prose — its in-line "natural in the open" sentence
  now points to the new standalone `lem:gammaPushforwardIsoAt_naturality`.

- **Revised** the `% NOTE` on `lem:pushforward_spec_tilde_iso` (former lines ~432–440):
  removed the "UNDER-SPECIFIED — a blueprint-writer must add…" / "carrier wall is the sole
  difficulty" wording; replaced with a short pointer recording the carrier wall as resolved
  (restriction-of-scalars / scalar-tower instances feeding `lem:powers_restrictScalars`;
  `lem:tildeRestriction_isLocalizedModule` supplies the `R'`-side localization) and naming
  the single remaining obligation (open-naturality, now `lem:gammaPushforwardIsoAt_naturality`).

- **Revised** the `lem:pushforward_spec_tilde_iso` proof sketch:
  - "explicit formalization route over `D(a)`" intro: dropped the stale "naive section-level
    identity does not present itself" carrier-wall framing; added that the `R`-action on
    `Γ(N, D(a))` is the honest restriction-of-scalars/scalar-tower structure against which
    `lem:powers_restrictScalars` applies directly, and that `hloc(a)` is obtained by
    transporting the `R'`-side localization (`lem:tildeRestriction_isLocalizedModule`) across
    the section comparison *using its open-naturality* (`lem:gammaPushforwardIsoAt_naturality`).
  - movement (1): reframed `e_{D(a)}` as the *component at `U=D(a)`* of the open-indexed
    family of `lem:gammaPushforwardIsoAt` (no fresh `D(a)`-level construction).
  - movement (2): replaced the hand-derived "`D(a)`-level ring equation" with the
    *open-naturality square* of `lem:gammaPushforwardIsoAt_naturality` at `D(a) ⊆ ⊤`
    (drawn explicitly), available uniformly in `a` — no per-`a` section identity.
  - movement (3): now cites `lem:tildeRestriction_isLocalizedModule` for the `R'`-side
    localization, has `lem:powers_restrictScalars` convert it to the `R`-side localization
    (scalar-tower hypotheses from restriction of scalars along `φ`), and transports across
    the movement-(2) naturality square; states explicitly that no per-`a` section-level
    computation is performed.
  - "Naturality in the open drives the transport" paragraph: cross-referenced
    `lem:gammaPushforwardIsoAt_naturality` and recorded that this single naturality square is
    THE remaining obligation, the carrier being the restriction-of-scalars structure.
  - `\uses{}` updated to include `lem:gammaPushforwardIsoAt_naturality` (and
    `lem:gammaPushforwardIso`, now referenced as `e_⊤`).

## Cross-references introduced
- `\uses{lem:gammaPushforwardIsoAt, lem:globalSectionsIso_hom_comp_specMap_appTop}` in the
  proof of the new `lem:gammaPushforwardIsoAt_naturality` — both exist in this chapter.
- `\uses{... lem:gammaPushforwardIsoAt_naturality ...}` added to proof of
  `lem:pushforward_spec_tilde_iso` — the new label is defined in this same chapter.
- `lem:gammaPushforwardIso` added to that same `\uses` — exists in this chapter.
- In-prose `\ref{lem:gammaPushforwardIsoAt_naturality}` from `lem:gammaPushforwardIsoAt`.

## References consulted
None — this was a specification-tightening pass on project-bespoke infrastructure. No new
external source was needed; no `% SOURCE:`/`% SOURCE QUOTE:` lines were added (the new and
revised blocks are Archon-original and stand on their proof sketches). All existing
Stacks/EGA source-quote comments were left byte-intact.

## Macros needed (if any)
None. The new block uses only `\operatorname`, `\Gamma`, `\widetilde`, `array`, `xrightarrow`,
`mathrm`, `restr_φ` notation already used elsewhere in the chapter.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The new lemma `lem:gammaPushforwardIsoAt_naturality` is intentionally UNPINNED (no
  `\lean{...}`). The prover is expected to add the Lean declaration (e.g. realize
  `gammaPushforwardIsoAt` as a `NatIso` via `NatIso.ofComponents` of the per-open `e_U`) and a
  later sync/review pass will attach the `\lean{...}` hint + `\leanok`. If the prover names the
  decl, the `\lean{...}` hint can be added then.
- Out-of-scope blocks (`lem:pushforward_spec_tilde_iso_conditional`,
  `lem:powers_restrictScalars`, `lem:tildeRestriction_isLocalizedModule`,
  `lem:affine_base_change_pushforward`, `thm:flat_base_change_pushforward`) were not modified
  except as cross-references required (none of their statements changed).

## Strategy-modifying findings
None. The revision tightens the proof sketch to match the prover's recommended NatIso route;
no strategy-level issue surfaced.
