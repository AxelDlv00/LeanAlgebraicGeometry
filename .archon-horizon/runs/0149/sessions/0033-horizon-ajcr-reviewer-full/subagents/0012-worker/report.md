## Progress

- Removed the four explicit local `CommRing` / `Algebra P.N.1` instances.
- Kept the typed restriction map, unfolded overlap target, explicit `hι`/`hf`, and literal chart tensor carrier.
- Pre/post LSP checks timed out with no diagnostics; stale overlap LSP worker was terminated.

## Issues

The sole kernel build exited `1` after 430 seconds. At line 120, `Spec.map_comp` cannot rewrite because the restriction map source remains expressed through `Pic0FiniteStageModelRing ... MapSource`, while `chartMap` uses the literal chart tensor carrier. Lean reports the target is not type-correct under instance transparency.

No axiom check ran because compilation failed. The draft is frozen with no further edits, commit, or Horizon-state changes.
