# Lean ↔ blueprint check — FreePresheafComplex.lean

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(this consolidated chapter blueprints the free Čech resolution; relevant area around the
`cechFreeSimplicial` / `cechFreeComplex_quasiIso` / `coverStructurePresheaf` /
`lem:injective_cech_acyclic` labels and the `FreeCechEngine` NOTE near line ~1799).

## What to check
- This iter added a parallel `section FamilyParameterized` with ~50 `…Fam` declarations that
  mirror the existing `X.OpenCover`-indexed chain over a raw finite family
  `{ι : Type u} [Finite ι] (U : ι → Opens ↥X)`, culminating in `cechFreeComplex_quasiIsoFam`.
  These new `…Fam` decls currently have **no blueprint blocks** (coverage gap). Confirm they are
  faithful family-form mirrors of the already-blueprinted `X.OpenCover` statements (same
  mathematical content, no covering hypothesis), and report the coverage gap.
- Check that the existing `X.OpenCover`-indexed decls were left byte-identical (the plan required
  CechBridge to stay green) — i.e. the Lean still matches the blueprint `\lean{...}` pins it had.
- Report bidirectionally: does the blueprint adequately describe the cover-agnostic
  re-parameterization, or does the chapter need a writer pass to add the family-form blocks?
