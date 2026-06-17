# Lean ↔ blueprint check — iter-075

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter — declares `% archon:covers` for the CSI split files)

## Check
- The target `pushPull_interLegHom_sections` (Lean line ~1416) against blueprint
  `lem:pushPull_interLegHom_sections` (~line 8845) — does the Lean proof realize the (a)–(d) sketch?
  Is the statement signature faithful (no placeholder / weakened form)?
- Also `pushPull_leg_coherence` (`lem:pushPull_leg_coherence`) and `coreIso_comm_leg`.
- Bidirectional: flag (i) any Lean statement that is fake/weakened vs blueprint, and (ii) whether the
  blueprint is now adequate to have guided this formalization, or still too thin.
- Note the new private helpers added this iter that lack any blueprint entry (coverage debt).

## Output
Bidirectional report; must-fix findings flagged explicitly.
