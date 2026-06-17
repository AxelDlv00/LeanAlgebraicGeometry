# Blueprint Writer Report

## Slug
fbcdax

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:powers_restrictScalars}`/`\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` — the ring-change converse of `IsLocalizedModule.of_restrictScalars`: an `A`-linear localization at the image submonoid `algMap_A(S)` is, as an `R`-linear map, a localization at `S`; specialized to `A = R'`, `S = powers(a)` it gives `algMap_{R'}(powers a) = powers(φ a)`. Archon-original (no `% SOURCE`). Proof sketch added (3-conditions verification + scalar-tower).
- **Added lemma** `\lemma`/`\label{lem:fromTildeGamma_app_isIso_of_localized}`/`\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` — section-level engine: if the structure-sheaf restriction `Γ(N,⊤)→Γ(N,D(a))` is `IsLocalizedModule (powers a)`, the counit `fromTildeΓ N` is iso on `D(a)`. Proof sketch added (triangle identity `L∘j=ρ`, both localizations of `Γ(N,⊤)`, uniqueness forces `L=e`).
- **Added lemma** `\lemma`/`\label{lem:pushforward_spec_tilde_iso_conditional}`/`\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` — route-iii assembly taking `hloc` as hypothesis, producing the object iso via basis-locality + `gammaPushforwardTildeIso`. Proof sketch added. `\uses{lem:modules_isIso_of_isBasis, lem:gammaPushforwardTildeIso, lem:fromTildeGamma_app_isIso_of_localized}`.
- **Revised** `lem:pushforward_spec_tilde_iso` proof — expanded the `\emph{The computation over $D(a)$}` paragraph with an explicit 3-movement element-free formalization route mirroring `lem:gammaPushforwardIso`: (1) the `D(a)`-level linear equivalence `e_{D(a)}` via two `restrictScalarsComp'`-style reconciliations + `eqToIso`; (2) the explicit `D(a)`-level ring equation (`D(a)`-shadow of `globalSectionsIso_hom_comp_specMap_appTop`); (3) discharging `hloc` by transporting the Mathlib `M[1/φa]` localization instance through `lem:powers_restrictScalars` and across `e_{D(a)}`, then feeding the family to the conditional form. Kept the existing "two localizations agree" prose intact ahead of the new route.
- **Revised** `lem:pushforward_spec_tilde_iso` proof `\uses` — added `lem:pushforward_spec_tilde_iso_conditional`, `lem:powers_restrictScalars`.
- **Revised** the stale `% NOTE:` above `lem:pushforward_spec_tilde_iso` — now records that the three helper blocks exist with pins; the dangling-pin note for the unconditional decl itself stays until the prover closes it.

## Cross-references introduced
- `\uses{lem:powers_restrictScalars}` (new label, defined this chapter) — OK.
- `\uses{lem:fromTildeGamma_app_isIso_of_localized}` (new label, defined this chapter) — OK.
- `\uses{lem:pushforward_spec_tilde_iso_conditional}` (new label, defined this chapter) — OK.
- All other referenced labels (`lem:modules_isIso_of_isBasis`, `lem:gammaPushforwardTildeIso`, `lem:gammaPushforwardIso`, `lem:globalSectionsIso_hom_comp_specMap_appTop`) pre-exist in this same chapter.

## References consulted
None — all three added blocks are Archon-original / project-bespoke Lean glue and an internal element-free recipe, per the directive; no external source required and none cited. (Lean signatures confirmed by reading `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` L320–438 to ensure pins, namespace `AlgebraicGeometry`, and hypothesis shapes match.)

## Macros needed (if any)
None. Used only existing notation (`\widetilde`, `\operatorname`, `\mathrm`, `\sharp`).

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The three new pins resolve under `namespace AlgebraicGeometry` (verified in the Lean file), so the qualified names in the directive match the actual decls.
- LaTeX environments balance (11 `lemma`/11, 12 `proof`/12).
- The only remaining dangling pin in this chapter is the unconditional `lem:pushforward_spec_tilde_iso` itself (the open `hloc` obligation), exactly as intended — the proof now spells out the element-free `D(a)`-specialization route for the next prover round.

## Strategy-modifying findings
None.
