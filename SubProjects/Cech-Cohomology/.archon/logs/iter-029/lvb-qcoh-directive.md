# lean-vs-blueprint-checker directive — QcohTildeSections (iter-029)

Bidirectionally verify ONE Lean file against its blueprint chapter.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated; this chapter `% archon:covers` QcohTildeSections.lean; relevant block
`lem:qcoh_iso_tilde_sections` at ~L3417, plus prose L580--592 documenting the 01I8 gap).

## What to check
- Lean → blueprint: the block `lem:qcoh_iso_tilde_sections` states the UNCONDITIONAL
  quasi-coherent structure theorem, but the Lean decl `qcoh_iso_tilde_sections` carries
  `[IsIso F.fromTildeΓ]` (conditional form). A review `% NOTE:` was added flagging this.
  Confirm the divergence is correctly disclosed and the `\leanok` (sync-added) is on the
  conditional decl, not the qcoh statement. The 3 helpers
  (`qcoh_iso_tilde_sections_of_presentation`, `_hom`, `_inv`) lack their own blocks
  (coverage debt) — note that.
- Blueprint → Lean: is the chapter's account of the 01I8 gap accurate vs the file's
  `## Handoff` decomposition (global generation → presentation → counit-iso instance)?
- Report any signature mismatch, overclaim, or blueprint inadequacy.
