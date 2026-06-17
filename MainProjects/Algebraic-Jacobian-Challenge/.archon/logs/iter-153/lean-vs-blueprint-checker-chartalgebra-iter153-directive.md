# lean-vs-blueprint-checker — ChartAlgebra ↔ RigidityKbar (iter-153)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file

/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean

## Blueprint chapter

/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex

(The chart-algebra lemmas `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
and `constants_integral_over_base_field` are declared in this Lean file and
described in `RigidityKbar.tex` under `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
and `\lem:constants_integral_over_base_field`.)

## What changed this iter

- `constants_integral_over_base_field` proof body was CLOSED (axiom-clean:
  `propext`, `Classical.choice`, `Quot.sound`; no `sorryAx`). Its signature
  carries `[IsAlgClosed k]`, `[Smooth]`, `[IsProper]`, `[IsReduced X]`,
  `[GeometricallyIrreducible]`. Verify the blueprint proof block for
  `\lem:constants_integral_over_base_field` matches the actual three-step
  Lean proof (integral X → Γ field; properness → Γ finite/integral over k;
  `IsAlgClosed.algebraMap_bijective_of_isIntegral` → range = ⊤).
- The KDM lemma `mem_range_algebraMap_of_D_eq_zero` still has an open
  `sorry` (the FT.3 Mathlib gap). Verify the blueprint reflects this as an
  open obligation, with the correct `[IsAlgClosed k]`+`[IsDomain B]`+
  `[CharZero k]` hypotheses on both sides.

## Report

Bidirectional: (a) Lean follows blueprint? (signature/`\lean{...}` match,
no fake/placeholder, proof not divergent); (b) blueprint detailed enough to
have guided this Lean? Flag must-fix items explicitly. Also flag any stale
proof-block `\leanok` or stale prose describing an abandoned recipe.
