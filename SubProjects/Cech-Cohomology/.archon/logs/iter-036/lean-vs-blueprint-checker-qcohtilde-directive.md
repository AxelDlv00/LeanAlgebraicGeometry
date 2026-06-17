# Lean ↔ blueprint check — QcohTildeSections (iter-036)

Verify bidirectionally one Lean file against its blueprint chapter.

- Lean file: `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint chapter: `/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (this chapter declares `% archon:covers AlgebraicJacobian/Cohomology/QcohTildeSections.lean`).

This iter the prover added three new lemmas to the Lean file:
- `tilde_section_isLocalizedModule` (~L408)
- `section_isLocalizedModule_of_isIso_fromTildeΓ` (~L441)
- `section_isLocalizedModule_of_presentation` (~L498)

and did NOT create the keystone `AlgebraicGeometry.qcoh_section_isLocalizedModule`
(blueprint `lem:qcoh_section_isLocalizedModule`, ~L3927 of the chapter), which remains a frontier
to-build node.

Report:
1. Lean → blueprint: do the three new lemmas faithfully realize blueprint statements? They currently
   have NO dedicated blueprint blocks (coverage debt). Confirm whether the chapter's
   `lem:qcoh_section_isLocalizedModule` proof sketch (~L3957) accurately reflects the route the Lean
   bricks take (transport via `tilde.toOpen` localization + naturality of `fromTildeΓ` counit /
   `qcoh_iso_tilde_sections`), or whether the sketch describes a different route than the Lean code.
2. Blueprint → Lean: is the keystone's blueprint sketch detailed enough to formalize the remaining
   step (the unconditional `[IsQuasicoherent F]` case)? The prover reported the gap is a geometric
   `.over`→affine base-change bridge absent from Mathlib — does the blueprint name that gap, or does
   it gloss over it?
3. Any fake/placeholder statements, signature mismatches, or `\lean{}` pins naming a non-existent
   declaration.
