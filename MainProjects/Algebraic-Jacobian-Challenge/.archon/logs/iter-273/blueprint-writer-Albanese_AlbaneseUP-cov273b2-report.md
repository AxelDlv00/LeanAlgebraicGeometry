# Blueprint Writer Report

## Slug
Albanese_AlbaneseUP-cov273b2

## Status
COMPLETE — all 8 uncovered declarations now have a single `\lean{}`-pinned block, each wired into the chapter cone; no isolated nodes, no broken `\uses{}`.

## Target chapter
blueprint/src/chapters/Albanese_AlbaneseUP.tex

## Changes Made

### New section `\section{File-internal placeholder for \Pic^0_{C/k}}` (before the Abel–Jacobi section)
- **Added definition** `def:pic0_bundle` / `\lean{AlgebraicGeometry.Pic0.Bundle}` — the bundled Pic⁰ scheme + its four abelian-variety structural attributes. `\uses{def:pic_scheme}`.
- **Added definition** `def:pic0_bundle_carrier` / `\lean{AlgebraicGeometry.Pic0.bundle}` — the carrier producing a Pic⁰ bundle for each curve. `\uses{def:pic0_bundle}`.
- **Added definition** `def:jacobian_scheme` / `\lean{AlgebraicGeometry.Pic0.jacobianScheme}` — the underlying scheme `J := Pic⁰`. `\uses{def:pic0_bundle_carrier}`.
- **Added lemma** `lem:jacobian_scheme_grpObj` / `\lean{AlgebraicGeometry.Pic0.jacobianScheme_grpObj}` — group-object structure on `J`. `\uses{def:jacobian_scheme}`.
- **Added lemma** `lem:jacobian_scheme_isProper` / `\lean{AlgebraicGeometry.Pic0.jacobianScheme_isProper}` — properness of `J`. `\uses{def:jacobian_scheme}`.
- **Added lemma** `lem:jacobian_scheme_smooth` / `\lean{AlgebraicGeometry.Pic0.jacobianScheme_smooth}` — smoothness of `J`. `\uses{def:jacobian_scheme}`.
- **Added lemma** `lem:jacobian_scheme_geomIrred` / `\lean{AlgebraicGeometry.Pic0.jacobianScheme_geomIrred}` — geometric irreducibility of `J`. `\uses{def:jacobian_scheme}`.

### New section `\section{Connecting the two factorisation forms}` (before the proof section)
- **Added lemma** `lem:albanese_eq_iff_symmetricPower_eq` / `\lean{AlgebraicGeometry.Pic0.albanese_eq_iff_symmetricPower_eq}` — biconditional identifying the Albanese-form factorisation `φ = ψ ∘ ι_{P₀}` with the symmetric-power form `Sym^g φ = ψ ∘ f^{(g)}`. `\uses{lem:abel_jacobi_morphism, lem:symmetric_product_av_map, lem:symmetric_product_to_jacobian}`.

All lemma blocks carry `\begin{proof} Proved directly in Lean. \end{proof}`; definition blocks carry no proof env. No external `% SOURCE` (all are internal helpers).

## Cross-references introduced (statement-level `\uses{}` edges)
- `lem:abel_jacobi_morphism`: added `def:jacobian_scheme` (its target is `jacobianScheme C`) → was `\uses{def:pic_scheme}`, now `\uses{def:pic_scheme, def:jacobian_scheme}`.
- `lem:symmetric_product_to_jacobian`: added `def:jacobian_scheme, lem:jacobian_scheme_grpObj, lem:jacobian_scheme_isProper, lem:jacobian_scheme_smooth, lem:jacobian_scheme_geomIrred` (it specialises `symmetricPowerAVMap` to `A := jacobianScheme C`, consuming all four instances). This is the wiring that pulls the four instances into the main-theorem cone.
- `thm:albanese_universal_property`: added `lem:albanese_eq_iff_symmetricPower_eq` (the Lean proof body calls it directly); also collapsed the multi-line `\uses{}` to a single line per the leandag edge rule.

Resulting cone: `thm:albanese_universal_property` → `lem:symmetric_product_to_jacobian` → {`def:jacobian_scheme`, four `lem:jacobian_scheme_*`} → ... → `def:pic0_bundle_carrier` → `def:pic0_bundle`; and `thm:albanese_universal_property` → `lem:albanese_eq_iff_symmetricPower_eq`. Every new helper is transitively under the chapter goal.

## REF fixes
None needed — `grep` for literal `REF`/`Theorem~REF` etc. returned nothing.

## Verification
- `leandag build`: no errors, no `unknown_uses`/`unmatched` for this chapter.
- `leandag query --isolated --chapter Albanese_AlbaneseUP`: 0 results.
- All 8 target `\lean{}` pins present exactly once each in the chapter; confirmed none pinned elsewhere project-wide.

## References consulted
None (all 8 blocks are internal helper declarations; no external citation blocks were written).

## Notes for Plan Agent
- The four `jacobianScheme_*` instances and the `albanese_eq_iff_symmetricPower_eq` biconditional carry `sorry` in Lean (via the `bundle` carrier / the biconditional body); their blueprint proof text is the boilerplate "Proved directly in Lean." The deterministic `sync_leanok` phase will set/clear `\leanok` based on actual sorry status.
