# Blueprint Writer Report: gf-fix
**Status:** COMPLETE

## Changes (Picard_FlatteningStratification.tex)
- **Edit 1 (decompose seam-1):** added 3 sub-lemma blocks w/ proofs + TODO `\lean` pins —
  `lem:gf_localGenerators_restrict` (1a), `lem:gf_affine_finite_standard_subcover` (1b),
  `lem:gf_finite_gen_iff_free_epi` (1c). Rewrote `lem:gf_finiteType_affine_finite_cover_generated`
  `\uses{}`+proof to assemble 1a→1b→1c; kept its `\lean` pin + Stacks 01PB SOURCE QUOTE.
- **Edit 3 (free-epi pin):** generalised `lem:gf_qcoh_finite_sections_globally_generated` prose
  to actual decl (any qcoh epi w/ finite source sections); replaced iter-047 NOTE w/ resolved note.
  Added `lem:gf_qcoh_sections_free_epi` `\lean{...gf_qcoh_finite_sections_of_free_epi}`,
  `\uses{lem:gf_qcoh_finite_sections_globally_generated, lem:tilde_adjunction_mathlib}`.
  Repointed G1 (`gf_qcoh_fintype_finite_sections`) base-case edge to the free-epi block (graph accuracy).
- **Edit 2 (G3 proof):** expanded `lem:gf_flat_locality_assembly` proof w/ `[expected]` Mathlib names:
  `Module.Flat.of_free`/`of_projective`, `Module.Flat.of_localization_span`/`flat_of_isLocalized_maximal`,
  `Module.Flat.of_isLocalization`; named localization-cover step explicitly.
- Verified: `leandag build` → 0 unknown_uses, 0 isolated. No `\leanok` added.

## Notes / Strategy
- loogle 502 during session; `[expected]` Mathlib names unverified by me (prover verifies, per directive).
