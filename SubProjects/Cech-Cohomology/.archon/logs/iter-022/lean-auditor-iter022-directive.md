# lean-auditor directive — iter-022

Audit the two `.lean` files that received prover work this iteration, as Lean code,
with no bias toward what any strategy claims should be true.

## Files to read (absolute paths)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/FreePresheafComplex.lean

## Focus areas
- The new `section SectionCechTilde` in CechAcyclic.lean (roughly lines ~1340–1620):
  several `set_option maxHeartbeats` raises (800000 / 1000000 / 2000000) with
  `clear_value`/abstract-`g` workarounds — assess whether the heartbeat raises and
  the opaque-map abstraction are genuinely necessary or mask a fragile proof, and
  whether any comment overstates what was proved.
- The new engine-complex block in FreePresheafComplex.lean (roughly lines ~720–990):
  `cechEngineComplex`, `cechEngineD_comp`, `cechEnginePrepend_spec`, `cechEngineD_exact`,
  and the trailing comment block where `cechFreeEvalEngineIso` is described but NOT
  defined. Check the trailing comment is an honest "not built" note and not a disguised
  axiom/placeholder. Check `open Classical`/`by classical exact dite` usage in
  `cechFreeEvalDropZeros` is sound.
- Any module-level docstrings that now overstate completeness.
- `#print axioms`-cleanliness is already confirmed for the new decls; you do not need to
  re-verify axioms, but flag any `opaque`/`sorry`/`admit`/`native_decide` you find.

## Output
Per-file checklist (outdated comments, suspect definitions, dead-end proofs, bad Lean
practices, excuse-comments) plus a flagged-issues block with severities. Write your
report to task_results/.
