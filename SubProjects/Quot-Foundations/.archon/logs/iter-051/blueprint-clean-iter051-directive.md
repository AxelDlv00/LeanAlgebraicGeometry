Action: post-write purity gate on the three chapters edited this iter. Strip any Lean tactic syntax / project-history (iter numbers) / verbosity that leaked in; validate `\uses{}` resolve; ensure project-bespoke blocks have no fabricated source quotes (these new blocks are Archon-original — they should carry NO `% SOURCE`/`% SOURCE QUOTE` lines, not invented ones).

Chapters:
- blueprint/src/chapters/Picard_FlatteningStratification.tex (new: lem:gf_qcoh_finite_sections_of_genSections + GeneratingSections.map engine blocks; edited gf_localGenerators_restrict, gf_finiteType_affine_finite_cover_generated)
- blueprint/src/chapters/Picard_GrassmannianQuot.tex (new: lem:gr_chartQuotientMap_epi, globalUnitSection/scalarEnd infra; edited def:scheme_modules_glue cocycle hyps)
- blueprint/src/chapters/Picard_SectionGradedRing.tex (10 new tensor/sheafification helper blocks)

Constraints: do NOT touch `\leanok`. Math-only prose.
