# Blueprint Writer Report

## Slug
fbc-natopen

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

### (A) Two new `\lean{}`-pinned Archon-original blocks
Both inserted in the Γ-fragment cluster, immediately after
`lem:gammaPushforwardTildeIso` (so they sit near `lem:gammaPushforwardIso` as
directed) and before the "three further bespoke supports" paragraph. No external
`% SOURCE` (affine tilde-dictionary infrastructure, same provenance as the
existing `lem:gammaPushforwardIso`).

- **Added lemma** `\lemma`/`\label{lem:gammaPushforwardIsoAt}`/`\lean{AlgebraicGeometry.gammaPushforwardIsoAt}`
  — the open-indexed generalization of `lem:gammaPushforwardIso`: for any open `U`
  of `Spec R` with preimage `V = (Spec φ)⁻¹U`, an `R`-linear iso
  `Γ((Spec φ)_* N, U) ≅ restr_φ(Γ(N, V))`, natural in the open. States it is the
  `e_{D(a)}` of movement (1) for `U = D(a)`. Proof sketch added: Y — copies
  `gammaPushforwardIso` with `⊤` replaced by `U`; `\uses{lem:globalSectionsIso_hom_comp_specMap_appTop}`.
- **Added lemma** `\lemma`/`\label{lem:tildeRestriction_isLocalizedModule}`/`\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}`
  — the `R'`-side localization input: the tilde restriction
  `Γ(M^~, ⊤) → Γ(M^~, D(b))` (as `R'`-modules) is an `IsLocalizedModule (powers b)`
  localization; identifies it as the fact transported in movement (3). Proof
  sketch added: Y — `toOpen ⊤` is the trivial-submonoid (`powers 1`) localization
  hence bijective; the triangle identity to the basic-open localization exhibits
  the restriction as the `powers b` localization.

### (B) "Natural in the open" prose in the `lem:pushforward_spec_tilde_iso` proof
- **Revised** proof of `lem:pushforward_spec_tilde_iso` — added a `\medskip`
  paragraph "Naturality in the open drives the transport" after movement (3),
  recording that `(Spec φ)_* ∘ (-)^~ ≅ (-)^~ ∘ restr_φ` is natural in both the
  module and the open, and that open-naturality (the family `{e_U}` of
  `lem:gammaPushforwardIsoAt` commuting with restrictions) drives `hloc(a)`
  uniformly from the `⊤`-level localization (`lem:tildeRestriction_isLocalizedModule`)
  plus the `D(a) ↪ ⊤` naturality square, instead of a per-`a` hand-proved
  section-level square. A second paragraph states plainly that the `R`-module
  structure on the `R'`-side sections used by `lem:powers_restrictScalars` is the
  honest restriction-of-scalars structure (`R` acting through `φ`, the
  `Algebra R R'` / scalar-tower structure of `φ`), NOT an ad-hoc recursive scalar
  action — the structure under which `lem:powers_restrictScalars` is stated.
  Math-level only; no Lean tactic names.

### (C) Upstream-alignment note
- **Revised** proof of `lem:pushforward_spec_tilde_iso` — added a `% NOTE:`
  comment just before the "Quasi-coherence as a corollary" paragraph recording
  that this lemma is the affine case of "the pushforward of a quasi-coherent sheaf
  along an affine morphism is quasi-coherent", which in current Mathlib master is
  the `IsLocalizing`/`fromTildeΓ` characterization
  (`AlgebraicGeometry.isIso_fromTildeΓ_pushforward`); it post-dates the project's
  pinned Mathlib, so the project proves it in-tree, and the in-tree proof remains
  valid under a future bump. Placed as a `% NOTE:` (not rendered prose) because it
  references Mathlib identifiers, keeping the typeset proof math-only; the
  directive explicitly authorized either form.

## Cross-references introduced
- `\uses{lem:globalSectionsIso_hom_comp_specMap_appTop}` in `lem:gammaPushforwardIsoAt`
  (statement + proof) — target exists in this chapter (L170).
- `\uses{lem:gammaPushforwardIsoAt, lem:tildeRestriction_isLocalizedModule}` added
  to the proof of `lem:pushforward_spec_tilde_iso` — both targets are the new
  blocks added in this same chapter, so the DAG now reflects the two iter-239
  bricks feeding movements (1) and (3).

## References consulted
None — both new blocks are Archon-original affine-tilde-dictionary infrastructure
(directive: no external `% SOURCE` needed; same provenance as the existing
`lem:gammaPushforwardIso`). I wrote zero new citation blocks. I did read the Lean
source `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (decls
`gammaPushforwardIsoAt` L328 and `tildeRestriction_isLocalizedModule` L480) and
`analogies/fbc-qc.md` to ground the statements and the open-naturality framing.

## Macros needed (if any)
None. All commands used (`\operatorname`, `\widetilde`, `\Gamma`, etc.) are
standard and already used elsewhere in the chapter.

## Notes for Plan Agent
- `analogies/fbc-qc.md` recommends a larger pivot than this additive round
  covers: it argues `pushforward_spec_tilde_iso`'s open `hloc` should be closed by
  either (1) bumping Mathlib past PR #37189 to use `isIso_fromTildeΓ_pushforward`
  directly, or (2) porting the short `IsLocalizing` chain and swapping the
  `Module.compHom` carrier mechanism for an honest `Algebra`/scalar-tower action.
  The blueprint additions here are consistent with route (2) (the open-naturality
  + honest-restriction-of-scalars framing is exactly what that route formalizes)
  and the `% NOTE:` records the route-(1) upstream alignment. This is a
  strategy/prover-lane decision, not a blueprint-content issue, so it is flagged
  here rather than under "Strategy-modifying findings".
- The unconditional `lem:pushforward_spec_tilde_iso` proof remains the one open
  obligation in this chapter (its `\lean` pin is on the still-open decl); the new
  blocks are the two axiom-clean inputs it consumes.

## Strategy-modifying findings
None. The additions are faithful to the existing route and do not surface a
strategy-level contradiction; the larger pivot suggested by `fbc-qc.md` is a
prover-lane / Mathlib-pin decision, noted above for the plan agent.
