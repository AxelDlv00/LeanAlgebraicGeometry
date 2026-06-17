# Lean ↔ Blueprint — FlatteningStratification (iter049)

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_FlatteningStratification.tex

## Scope
New decls this iter: `gf_affine_finite_standard_subcover` (lem:gf_affine_finite_standard_subcover,
seam 1b), `gf_finite_gen_iff_free_epi` (lem:gf_finite_gen_iff_free_epi, seam 1c).
NOT added (blocked): `gf_localGenerators_restrict` (seam 1a), `gf_finiteType_affine_finite_cover_generated`.

## Check
(a) Lean→blueprint: do the 2 added decls match their `\lean{...}` blocks (statement + signature)?
(b) blueprint→Lean: are the 1a/1b/1c/assembly blocks detailed enough? Any prose-vs-Lean
generality mismatch (e.g. seam 1c stated in abstract `SheafOfModules.{u} R` generality)?
Report bidirectionally with must-fix tags.
