# blueprint-reviewer directive — iter-239, slug `ts239`

Run your standard whole-blueprint audit (per-chapter completeness + correctness checklist + the
incomplete-parts / proof-depth / Lean-target-wellformedness summaries + unstarted-phase proposals).
Do NOT restrict to a subset — the cross-chapter view is the point.

## Chapters under active prover dispatch THIS iter (your verdict gates these)
1. `Picard_TensorObjSubstrate.tex` — NEW section `sec:tensorobj_pullback_monoidality` added this iter
   (`lem:pullback_tensor_iso`, `lem:pullback_unit_iso`, `lem:isinvertible_pullback`) — the substrate for
   re-basing the relative-Picard functor onto the `IsInvertible` carrier. A prover lane [mathlib-build]
   targets these three. Gate: are the three blocks complete + correct, with proof sketches adequate for
   hand formalization, and `\uses{}` DAG sound? (Also confirm the plan-agent fix to `lem:tensorobj_assoc_iso`
   — title "(unconditional)", stale `IsLocallyTrivial`-hypothesis note removed — is now consistent.)
2. `Cohomology_FlatBaseChange.tex` — the engine lane re-engages on `lem:pushforward_spec_tilde_iso`
   (element-free `D(a)`-transport, expanded last iter). Gate: confirm the expanded proof sketch
   (`e_{D(a)}` linear equiv + `D(a)` ring equation + `IsLocalizedModule.of_linearEquiv`/
   `powers_restrictScalars` transport ⇒ `hloc`) is complete + correct and the `\uses{}` resolve.
   NOTE a plan-agent fix this iter relocated a malformed `\uses{\leanok …}` (the `\leanok` is now on its
   own line before the `\uses{}`); confirm it parses.

## Report the per-chapter verdict (complete / correct booleans + must-fix-this-iter) for both, plus your
usual whole-blueprint findings and any unstarted-phase proposals.
