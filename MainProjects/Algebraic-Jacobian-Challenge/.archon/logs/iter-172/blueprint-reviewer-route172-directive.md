# Blueprint reviewer directive (iter-172)

## Slug
route172

## Audit scope

Whole-blueprint audit. Per descriptor (`.archon/subagents/blueprint-reviewer.md`) you always read every chapter — do NOT scope this.

## Read

- All files under `blueprint/src/chapters/*.tex`.
- `blueprint/src/content.tex` for the `\input` order.

## Iter-172 active prover lanes

The planner is considering three prover lanes this iter; your HARD GATE verdict on the corresponding chapters gates each:

1. **`AlgebraicJacobian/Genus0BaseObjects.lean`** — Lane A continuation. Blueprint: `AbelianVarietyRigidity.tex` (covers G0BO via `% archon:covers`). iter-171 review NOTE updates already landed (def:gaTranslationP1 + lem:gmScaling_fixes_zero).
2. **`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`** — NEW file-skeleton Lane C. Blueprint: `RiemannRoch_WeilDivisor.tex` (NEW iter-171 via `blueprint-writer rr-bridge-subbuild`; 445 LOC; 9 `\lean{...}` pins).
3. **`AlgebraicJacobian/Picard/RelativeSpec.lean`** — NEW file-skeleton Lane B. Blueprint: `Picard_RelativeSpec.tex` — **DOES NOT EXIST ON DISK** (iter-171 writer failed twice). Re-dispatched this iter as `blueprint-writer route-a1-retry2`; you may not see it landed by the time you read. Report the chapter as "missing — gated on writer landing this iter" if the file isn't there.

## Iter-171 reviews to incorporate

- lean-vs-blueprint-checker `g0bo171`: PASS. 1 MAJOR finding — `mvPolyToHomogeneousLocalizationAway_surjective` (new iter-171 substantive `sorry`) is NOT `\lean{...}`-pinned in `AbelianVarietyRigidity.tex`. **This iter** a `blueprint-writer surjective-pin` is being dispatched to add the pin. Verify in your audit.
- lean-auditor `iter171`: 1 CRITICAL excuse-comment in `Jacobian.lean` (Lean-side, NOT blueprint-side). This iter a `refactor jacobian-purge-excuse` is being dispatched to handle that. NOT your concern.

## Asks per chapter

Standard descriptor format: completeness (yes / partial / no), correctness (yes / partial / no), must-fix-this-iter findings, recommended writer dispatches.

Specific things to check this iter:

- `AbelianVarietyRigidity.tex`: does the iter-171 NOTE refresh (def:gaTranslationP1 L1147-1156, lem:gmScaling_fixes_zero L1206) match the current Lean state? Is the iter-171 NOTE at def:proj_chart_ring_iso L1091-94 still stale per the lean-vs-blueprint-checker minor finding? Is the new pin for `mvPolyToHomogeneousLocalizationAway_surjective` (writer landing this iter) sufficient?
- `RiemannRoch_WeilDivisor.tex`: HARD GATE — complete + correct enough for a file-skeleton prover to scaffold from? 9 declarations pinned. Are the citations source-verbatim with `% SOURCE QUOTE:` (Hartshorne II.6 / Stacks 02RW / 02ME / 0BE0 / 0BE3)?
- `Picard_RelativeSpec.tex` (if landed by writer this iter): HARD GATE — complete + correct enough for file-skeleton?

## Unstarted-phase blueprint proposals

Identify any STRATEGY.md phase with no blueprint coverage. Currently flagged:
- Route A.2 (Hilbert/Quot + FGA Pic representability) — no chapter, decomposed in Jacobian.tex § Route A only at section level. User hint 3 requests further per-file decomposition (sub-chapters under ~1000 LOC each).
- Route A.3 (`Pic⁰` identity + degree map) — no chapter.
- Route A.4 (Albanese UP) — no chapter; A.4 has open strategic question on Thm 3.2 dependency.
- RR.2 / RR.3 / RR.4 — no chapters (sub-phases serial after RR.1).

For each unstarted phase, propose chapter outline if dispatch is wise THIS or NEXT iter.
