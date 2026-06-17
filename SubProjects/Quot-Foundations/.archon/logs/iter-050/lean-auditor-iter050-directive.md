# Audit directive

Audit these two Lean files as Lean (no strategy context):

- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean

Focus areas:
- New decls in FlatteningStratification: `SheafOfModules.GeneratingSections.map`, `map_I`,
  `map_isFiniteType`, `gf_localGenerators_restrict`, `gf_finiteType_affine_finite_cover_generated`.
  Check for: vacuous/non-genuine statements, dropped hypotheses (a `[F.IsQuasicoherent]` was
  intentionally removed from `gf_finiteType_affine_finite_cover_generated` — confirm it is genuinely
  unused, not a soundness hole), excuse-comments, dead-end proofs, the single remaining `sorry`
  (`genericFlatness`) being honest.
- GrassmannianQuot (NEW FILE): `globalUnitSection`, `scalarEnd`, `chartQuotientMap` (should be
  axiom-clean) vs 5 scaffold `sorry` decls (`Scheme.Modules.glue`, `universalQuotient`,
  `tautologicalQuotient`, `functor`, `represents`). Check the scaffold signatures are not fake/parallel
  APIs and that `Scheme.Modules.glue` lacking module cocycle hypotheses on `_g` is flagged in-file.

Report per-file checklist + flagged issues.
