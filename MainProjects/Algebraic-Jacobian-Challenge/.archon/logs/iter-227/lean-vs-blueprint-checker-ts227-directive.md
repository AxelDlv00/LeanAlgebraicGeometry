# lean-vs-blueprint-checker directive — iter-227

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

Context for this iter: the prover added three axiom-clean declarations —
`restrictScalarsRingIsoDualEquiv` (~L306), `AlgebraicGeometry.Scheme.Modules.homMk`
(~L2034), `AlgebraicGeometry.Scheme.Modules.toPresheaf_map_homMk` (~L2042) — as part
of the "A-bridge / C-build" descent re-route for `exists_tensorObj_inverse`. The
PRIMARY target `homOfLocalCompat` (blueprint `lem:sheafofmodules_hom_of_local_compat`,
chapter ~L2814) did NOT land and remains an unformalized forward pin.

Report bidirectionally:
- Lean → blueprint: do the three new Lean decls have correct `\lean{...}` pins (or is
  a pin missing)? Are any blueprint `\lean{...}` targets pointing at names that don't
  exist / were renamed? Note: `restrictScalarsRingIsoDualEquiv` and `homMk` may have
  no blueprint pin yet — flag as a gap if so, with the section where it belongs
  (`sec:tensorobj_dual_infra`).
- blueprint → Lean: is the chapter detailed enough to guide formalization of the
  still-open `homOfLocalCompat` gluing engine, or is the blueprint too thin where the
  Lean clearly needs more (the prover reports the gluing engine is ~120–190 LOC, far
  larger than prior estimates)?
- Any fake/placeholder statements or signature mismatches.

Flag any must-fix-this-iter findings explicitly.
Write your report to `task_results/lean-vs-blueprint-checker-ts227.md`.
