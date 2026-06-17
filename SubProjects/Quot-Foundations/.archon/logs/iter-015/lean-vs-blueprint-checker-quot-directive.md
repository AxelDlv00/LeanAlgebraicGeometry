# Lean ↔ blueprint check — QuotScheme (iter-015)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

This iter the prover began the graded-module API (Stacks 00K1 inductive step). It landed
3 axiom-clean declarations in `namespace AlgebraicGeometry.GradedModule`:
- `degreewise_finrank_diff` (D5) — should already have a blueprint pin;
- `homogeneousSubmodule_inf_iSupIndep` (G1(a)) — NEW, no blueprint entry yet;
- `homogeneousSubmodule_iSup_inf_eq` (G1 helper, private) — NEW, no blueprint entry yet.
The full G1 (`homogeneousSubmodule_isInternal`) and G2–G5 were BLOCKED by a Mathlib
elaborator `isDefEq`/`whnf` heartbeat runaway over `DirectSum.IsInternal` / `Submodule.map_iSup`
on subtype `↥p` / quotient `M⧸p` carriers. The 4 public skeleton stubs (the `representable`
/ Hilbert-poly theorems) remain `sorry`.

Report: (a) does the Lean follow the chapter — are the 3 new decls statement-faithful to the
blueprint's G1/D5 prose, any signature mismatch with `\lean{...}` pins, placeholder
statements; (b) is the chapter detailed enough — does it carry G1(a)/G1 and D5 at a level
that could guide formalization? Flag the missing blueprint coverage for the 2 new G1 decls.
List coverage.
