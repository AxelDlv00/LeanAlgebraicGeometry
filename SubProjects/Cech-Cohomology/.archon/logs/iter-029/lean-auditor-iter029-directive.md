# lean-auditor directive — iter-029

Audit the two new Lean files added this iteration. Read them as Lean, with no bias
toward what any strategy claims should be true.

## Files (absolute paths)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Focus areas
- Are the three `AffineSerreVanishing` decls (`affine_faces_mem`,
  `coverOpen_affineOpenCoverOfSpan`, `affine_injective_acyclic`) genuine, non-vacuous
  statements that prove what their names/docstrings claim? In particular
  `affine_injective_acyclic` is stated only for spanning families with
  `Ideal.span (Set.range s) = ⊤` (covers of the whole affine, not arbitrary `D(f)`) —
  confirm the docstring/comment honestly discloses this scope and there is no hidden
  weakening.
- `QcohTildeSections`: `qcoh_iso_tilde_sections` carries `[IsIso F.fromTildeΓ]` rather
  than `[IsQuasicoherent F]`. Confirm this is an honest conditional form (not a vacuity
  trick), that the docstring discloses the gap, and that the `## Handoff` decomposition
  is accurate. Note that this file does `import Mathlib` (whole-library import) — flag if
  that is a build-cost concern worth narrowing.
- Any outdated comments, dead code, suspect defeq tricks, or `change`/`unfold` fragility.

Report a per-file checklist + flagged issues with severity.
