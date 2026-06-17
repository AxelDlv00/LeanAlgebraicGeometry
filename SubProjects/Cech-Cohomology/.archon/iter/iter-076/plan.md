# iter-076 plan — CSI route CLOSED; P5a-resolution down to one plumbing sorry; coverage debt 41→0

## Situation
- iter-075 prover CLOSED the last CSI leaf `pushPull_interLegHom_sections` (Leg). Reconciled actual state:
  the "1 sorry" the loop counts in Leg/CSI are **stale docstring comments** — both files are genuinely
  0-sorry (lean-auditor `iter075`: 0 sorry/0 axioms, full chain wired; lean-vs-blueprint-checker `leg`:
  all proofs complete). **CSI/Base/Leg all 0-sorry ⟹ Sub-brick A DONE.**
- Project-wide real sorries now TWO: `CechAugmentedResolution:229` (hSec) + frozen `CechHigherDirectImage:780`.

## Actions this phase
- blueprint-reviewer `gate076` (whole blueprint) = **HARD GATE SATISFIED** for `CechAugmentedResolution.lean`
  (0 must-fix; `lem:cechSection_isZero_homology` present, correct `\uses`/sketch, 3 deps 0-sorry; the close
  is spelled out at `CechAugmentedResolution.lean:220–222`).
- progress-critic `iter076` = **CONVERGING**, dispatch=OK.
- blueprint-writer `covdebt076` cleared the leandag coverage debt: 41 `lean_aux` helpers bundled into 7
  parent `\lean{}` lists ⟹ `unmatched` 41→0, unknown_uses 0, isolated 0.
- Updated STRATEGY (P5a-resolution row → "closing", residual = hSec wiring; added a Completed row for the
  Sub-brick A / CSI sub-route, 075·~9, ~3550 LOC), task_done (iter-075 closure), task_pending (top block +
  P5a bullet), PROGRESS (1 lane).

## Decision made
- **ONE focused lane (`CechAugmentedResolution.lean` hSec), not parallel.** hSec is the project's critical
  path; closing it finishes P5a-resolution. P5b (line-780) is genuinely BLOCKED on it (can't dispatch — a
  prover there would thrash the frozen sorry). The EnoughInjectives connector is NOT blocked, but it is
  speculative P5b-prereq work with no file/scaffold yet — adding it risks scope creep off the single
  critical path (same call as iter-075). Trade-off: forgo parallelism for a clean finish of P5a-resolution.
  Cheapest reversal: if hSec closes trivially, next iter opens connector + P5b as parallel lanes.
- **`prove` mode, not fine-grained/mathlib-build:** the residual is pure consumer-glue (import CSI, wrap the
  two proved CSI lemmas in `cechSection_isZero_homology`, `exact` at 229). All math is proved.
- **Did not block on the inline `lake build` of the Leg module** (still running at finalize): CSI green is
  triple-confirmed (auditor + checker + grep); the authoritative `sync_leanok` build runs between prover and
  review regardless.

## Subagent skips
- strategy-critic: STRATEGY.md route + decomposition UNCHANGED (Route A acyclic-resolution comparison); this
  iter's edits are a within-phase status refresh (CSI sub-route → Completed; P5a-resolution row → "closing")
  — no route swap / phase reorder / new gap. Prior verdict SOUND, no live CHALLENGE. Re-blessing the
  identical route is the hollow-dispatch failure mode.
- blueprint-clean: the only blueprint edit this iter (`covdebt076`) added `\lean{}` pin names to existing
  lists — no prose / Lean-syntax leakage in any body for the purity gate to strip.
