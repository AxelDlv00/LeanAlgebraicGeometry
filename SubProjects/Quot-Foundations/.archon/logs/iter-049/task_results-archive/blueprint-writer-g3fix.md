# Blueprint Writer Report: g3fix
**Status:** COMPLETE

## Changes
- Rewrote proof of `lem:gf_flat_locality_assembly` (G3). Removed ERROR 1 (source patches `W_j` as a covering family of base ring `A_f`) and ERROR 2 (`Γ(S,U)` a localization of `A_f` for general affine `U`; misuse of `gf_qcoh_fintype_finite_sections` as a localization identity).
- New route: base-ring locality. Step1 free⟹flat; Step2 pointwise/stalk flatness of `F_x` over `O_{S,p(x)}` on `p⁻¹(V)` via qcoh (stalk = localization of patch `(M_j)_f`); Step3 reduce `Γ(F,W)` flat over `Γ(S,U)` to base maximals `𝔭` (`R_𝔭=O_{S,x}`, a localization of `A_f` since `x∈D(f)`), then source-side stalk check + `Flat.trans` along generization.
- `\uses{}` (statement+proof): kept `lem:gf_qcoh_fintype_finite_sections` (now honest use: patch `M_j` finite), ADDED `lem:qcoh_section_localization_basicOpen`. leandag: 0 unknown_uses.
- Verified Mathlib anchors named in `% LEAN STATUS` + prose, all `[verified]` in source: `Module.flat_of_localized_maximal`, `Module.flat_iff_of_isLocalization`, `Module.Flat.of_free`, `IsLocalization.flat`, `Module.Flat.trans` (RingTheory.Flat.Localization/.Stability/.Basic).

## Notes / Strategy
- Directive's candidate names `Module.Flat.of_localizationSpan` / `of_localization_span` do NOT exist; real names are `Module.flat_of_localized_maximal` / `flat_of_isLocalized_span` — used those. Source-side step (flatness over local base checked at maximals of R-algebra `B=Γ(X,W)`) has NO single Mathlib lemma; flagged as project-built glue in the block comment.
