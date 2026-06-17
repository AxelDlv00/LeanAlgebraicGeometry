# lean-vs-blueprint-checker directive (iter-240) — TensorObjSubstrate

Bidirectionally verify ONE Lean file against ONE blueprint chapter.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Context
This iter added two axiom-clean declarations:
- `AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp` (~L882)
- `AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp` (~L923) — described by
  the prover as THE "genuinely-new ingredient" for the chapter's `lem:pullback_unit_iso`.

The chapter section `sec:tensorobj_pullback_monoidality` was rewritten this iter to
"Route Z" (local-chart finality). `pullbackUnitIso` / `pullbackTensorIso` /
`IsInvertible.pullback` are NOT yet formalized (blocked on an instance-synthesis quirk);
the Lean file carries HANDOFF comments instead.

## What to report
- Lean → blueprint: do the two new decls' signatures match what the chapter describes?
  Is the chapter's `lem:pullback_unit_iso` proof sketch consistent with the
  `pullbackObjUnitToUnit_comp` composition-coherence statement the Lean now provides?
  Are there `\lean{...}` pins pointing at decls that don't exist, or NEW decls that the
  chapter should pin but doesn't?
- Blueprint → Lean: is the rewritten `sec:tensorobj_pullback_monoidality` detailed
  enough to guide formalizing the still-open `pullbackUnitIso`/`pullbackTensorIso`, or
  is it too thin / does it still describe the dead sectionwise-`extendScalars` route?
- Flag any must-fix-this-iter discrepancy (fake/placeholder statement, signature
  mismatch with a `\leanok` pin, stale route description).
