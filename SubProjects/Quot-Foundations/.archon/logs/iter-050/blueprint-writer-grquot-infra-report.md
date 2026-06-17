# Blueprint Writer Report: grquot-infra
**Status:** COMPLETE

## Changes
- New section `sec:grquot_infra` in `Picard_GrassmannianQuot.tex`.
- Add `def:is_locally_free_of_rank` (`...Scheme.Modules.IsLocallyFreeOfRank`): cover + local iso `M|_{U_i} ≅ O^d`, modeled on QuasicoherentData shape. Project-bespoke (no source).
- Add `def:scheme_modules_glue` (`...Scheme.Modules.glue`): descent of object+Hom over a `Scheme.GlueData` from per-chart `M_i` + GL_d cocycle `g_{ij}`, restriction iso `ρ_i`, uniqueness. `\uses{def:gr_the_glue_data}`. Project-bespoke (no source).
- Wire `\uses`: `gr_universal_quotient_sheaf`+`tautological_quotient`→`scheme_modules_glue` (former also→`is_locally_free_of_rank`); `grassmannian_functor`→`is_locally_free_of_rank`,`quot_functor` (new `\uses` line).
- Existing 5 blocks' statements intact. No `\leanok`/`\mathlibok`.
- leandag: 0 unknown_uses, 0 conflicts, new blocks non-isolated (10 isolated are pre-existing lean_aux).

## Notes / Strategy
- None.
