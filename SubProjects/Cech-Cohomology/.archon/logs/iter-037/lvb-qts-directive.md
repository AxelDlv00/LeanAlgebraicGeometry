# Lean ↔ Blueprint Checker — QcohTildeSections.lean (iter-037)

Verify ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(consolidated chapter; the relevant block is `lem:qcoh_finite_presentation_cover` (Route B step B1)
and the surrounding B0–B6 keystone chain.)

## What to check
- Does `qcoh_finite_presentation_cover` faithfully realize `lem:qcoh_finite_presentation_cover` (B1)?
  Statement: from `[F.IsQuasicoherent]` produce a finite family `g : Fin n → R` with
  `span (range g) = ⊤` and `φ : Fin n → q.I` with `D(g j) ≤ q.X (φ j)`, where `q` is a
  `QuasicoherentData F`. Check the existential's universe pin `QuasicoherentData.{u,u,u,u}` does not
  weaken the statement.
- The private helper `coversTop_iSup_eq_top` has NO blueprint block. Report as coverage debt; the
  prover suggested bundling its name into `lem:qcoh_finite_presentation_cover`'s `\lean{...}` list.
  Assess whether that is the right home.
- The keystone `qcoh_section_isLocalizedModule` is still absent (gated to a future iter pending the
  B3/B4 import). Confirm the chapter does not falsely mark it complete and that its proof
  sketch/`\uses` honestly reflect the still-open B3 dependency.
- Flag any `\lean{...}` pin mismatch, fake/placeholder statement, or signature divergence.

Report bidirectionally. Read-only; write only your report.
