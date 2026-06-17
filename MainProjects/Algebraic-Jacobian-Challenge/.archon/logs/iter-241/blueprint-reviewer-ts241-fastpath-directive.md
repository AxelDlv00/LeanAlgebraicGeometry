# blueprint-reviewer directive — iter-241 (same-iter fast path)

You always audit the WHOLE blueprint; produce your usual per-chapter checklist. This dispatch is the
HARD-GATE fast-path re-review for two chapters that received blueprint-writer passes THIS iter. Pay
particular attention to them and return an explicit complete/correct verdict for each:

## Chapter 1 — `Picard_TensorObjSubstrate.tex` (Lane A, critical path)
Writer `tensorobj-pins` added two pinned coherence sub-lemmas before `lem:pullback_unit_iso`:
- `lem:unitToPushforwardObjUnit_comp` (`\lean{AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp}`)
- `lem:pullbackObjUnitToUnit_comp` (`\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}`)
and revised the `lem:pullback_unit_iso` proof sketch to use them and to name the sole remaining step.
Prior gate status (ts240-pullbackz): this chapter was complete+correct, must-fix NONE. Confirm the two
new blocks are well-formed (statement matches the Lean decls, proof sketch is faithful and
formalizable), and that `sec:tensorobj_pullback_monoidality` remains complete+correct.

## Chapter 2 — `Cohomology_FlatBaseChange.tex` (Lane B, engine) — the must-fix being cleared
The prior per-file checker (lean-vs-blueprint ts240-fbc) flagged a MUST-FIX: the
`lem:pushforward_spec_tilde_iso` proof sketch was UNDER-SPECIFIED for its single open obligation (the
`gammaPushforwardIsoAt` open-naturality square / `hsq`). Writer `fbc-natiso` addressed it:
- added `lem:gammaPushforwardIsoAt_naturality` (UNPINNED by design — no `\lean{}` yet; the prover will
  add the `NatIso` decl) stating the open-indexed family `{e_U}` is a natural isomorphism of the two
  presheaves, with the naturality square drawn and proved;
- rewrote the `lem:pushforward_spec_tilde_iso` proof (movements 1–3) so `hloc(a)` follows from the
  ⊤-level localization + open-naturality, with the stale "carrier wall" framing removed.
Verify the must-fix is now resolved: is the proof sketch now SUFFICIENTLY specified to formalize the
`NatIso` route, and is `lem:gammaPushforwardIsoAt_naturality` a faithful, formalizable statement?

## What I need
For EACH of the two chapters above: `complete: true|false`, `correct: true|false`, and any
must-fix-this-iter finding. If both return complete+correct with no must-fix, both lanes' gates are
satisfied and the planner dispatches provers this iter. Also give your normal whole-blueprint checklist
and any unstarted-phase proposals (the planner acts on them or records a deferral).

Note: `lem:gammaPushforwardIsoAt_naturality` being intentionally unpinned (no `\lean{}`) is correct —
do not flag it as an error; the prover adds the Lean decl next.
