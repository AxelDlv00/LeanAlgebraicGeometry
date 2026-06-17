# Blueprint-clean directive — iter-054

Three chapters were edited this iter (effort-breaker + 2 writers). Clean them: strip any Lean tactic
syntax / impl leakage, project-history verbosity, iter labels; validate LaTeX env balance; ensure each new
block has \label + \lean + \uses; insert missing SOURCE quotes only where a block genuinely cites an external
source (the new GF/GR/SNAP blocks are Archon-original / standard-fact restatements — no verbatim port needed,
matching surrounding unsourced blocks).

## Edited chapters
- `blueprint/src/chapters/Picard_FlatteningStratification.tex` — new B2 chain
  (`gf_crossChart_basicOpen_eq`, `gf_section_localization_twoleg`, `gf_base_localization_comparison`,
  `gf_crossChart_spanning_cover`) + Mathlib anchor `Scheme.basicOpen_res`.
- `blueprint/src/chapters/Picard_GrassmannianQuot.tex` — coverage blocks (`gr_opensMap_final`,
  `gr_pullbackFreeIso`, `gr_pullback_isLocallyFreeOfRank`, `def:gr_rankQuotient`) + planned coherence blocks
  (`gr_pullbackObjUnitToUnit_id`/`_comp`).
- `blueprint/src/chapters/Picard_SectionGradedRing.tex` — `lem:relativeTensor_objectwise_coequalizer` +
  3 `\mathlibok` anchors + rewritten `relativeTensor_as_coequalizer` proof.

## Constraints
- Do NOT remove `\mathlibok` from the genuine Mathlib anchors. Do NOT add/remove `\leanok`.
- Do NOT alter mathematical content or \lean{} pins; cleanup only.
- `references/**` in write-domain for a fallback reference-retriever only.
