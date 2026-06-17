Scope: three chapters edited this iter. Clean each for blueprint purity
(strip Lean syntax/tactics, remove project-history/iter-narrative verbosity,
validate that `% SOURCE QUOTE` blocks carry verbatim source text; insert missing
quotes from `references/` if a cited block lacks one).

Chapters:
  - blueprint/src/chapters/Picard_GrassmannianQuot.tex (NEW — Nitsure §1/§5)
  - blueprint/src/chapters/Picard_FlatteningStratification.tex (G3 block rewritten)
  - blueprint/src/chapters/Picard_SectionGradedRing.tex (tensorPowAdd construction
    paragraph augmented)

Constraints:
  - Do NOT change mathematical content, statements, `\label`/`\lean{}`/`\uses{}`.
  - Do NOT touch `\leanok` (deterministic sync owns it).
  - Preserve the reviewed-correct blocks `def:sectionMul`, seam-1
    `lem:gf_finiteType_affine_finite_cover_generated`,
    `lem:gf_qcoh_finite_sections_globally_generated`,
    `lem:gf_qcoh_sections_free_epi` verbatim (purity-only touch-ups OK, no
    restructuring).
  - You have `references/**` to spawn reference-retriever only if a citation block
    is missing its verbatim quote.
