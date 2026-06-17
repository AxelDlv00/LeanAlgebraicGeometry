# Blueprint Writer Report: capstone-fix
**Status:** COMPLETE

## Changes (chapter Cohomology_CechHigherDirectImage.tex only)
- `lem:cech_term_pushforward_acyclic`: dropped stale iter-077 `% NOTE`; statement now requires both `X` and `S` separated + `hres` (per-intersection injective resolutions); prose explains S-separated necessity (Tag 01SG, doubled-origin). Proof rerouted via affine-morphism vanishing (g_s=f∘j_s affine since U_s affine, S separated) instead of `lem:open_immersion_pushforward_acyclic`/`_comp`. `\uses{}` → `affine_serre_vanishing, cech_nerve, higher_direct_image_presheaf, isQuasicoherent_pullback_opens, pushPull_sigma_iso, rightAcyclic_finite_prod`. Bundled 9 helpers into `\lean{}`.
- New `lem:isQuasicoherent_pullback_opens` (before cech_term): pullback of qcoh along open incl. is qcoh; proof = general-opens port of restrict–over bridge, `of_coversTop`. `\uses{isQuasicoherent_restrict_basicOpen, restrict_over_compat, restrictFunctorIsoPullback_mathlib}`; 19-name `\lean{}` bundle.
- `lem:cech_computes_cohomology_affineCover`: dropped stale `% NOTE`; added S-separated + hres to statement.
- `lem:pushforward_mapHC_cechComplexOnX`: appended `mapAlternatingCofaceMapComplexIso` to `\lean{}`.
- `lem:cechAugmented_to_acyclicResolutionInput`: untouched (note kept, item C).

## Verification
- `archon dag-query unmatched` → 0 of 0. New block wired (deps 3, used-by 1), none isolated. LaTeX envs balanced; `\leanok` count unchanged (not touched).

## Notes / Strategy
- Tag 01SG referenced inline only (prose cross-ref); no verbatim `% SOURCE QUOTE` added — exact statement not in local references/, so no fabricated citation.

## References consulted
- references/stacks-coherent.tex, references/stacks-schemes.tex (existing SOURCE blocks preserved).
