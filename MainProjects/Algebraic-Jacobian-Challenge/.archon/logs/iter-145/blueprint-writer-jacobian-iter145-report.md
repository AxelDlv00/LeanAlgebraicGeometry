# Blueprint Writer Report

## Slug
jacobian-iter145

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made

### Edit 1 (MUST-FIX) — L369–L377 Mathlib infrastructure summary, route-disposition reconciliation
- **Revised** the `\paragraph{Mathlib infrastructure summary.}` block.
  - Replaced the opening "Three independent Mathlib build-outs each unlock one route of the proof" framing with: "Per the iter-144 M3 disposition (STRATEGY.md §~M3), the project commits to Route A for the positive-genus arm and treats Route B as a historical alternative not pursued. The Mathlib build-outs gating the two surviving arms are therefore:".
  - Item ($\alpha$) (Hilbert/Quot + FGA representability) now carries the parenthetical "(COMMITTED M3 infrastructure --- iter-144 disposition)" and is explicitly identified as the build-out that discharges the positive-genus arm.
  - Item ($\beta$) (symmetric powers + Stein factorisation) is now demarcated `($\beta$, historical only --- not pursued)`, kept as a brief paragraph cross-referencing Route B in `thm:nonempty_jacobianWitness`, and explicitly tagged as not part of the project's discharge path. The earlier route-unlocking framing for ($\beta$) is dropped.
  - Item ($\gamma$) (rigidity over $k$) wording is reworded: "prerequisite of the genus-$0$ sub-case under either Route A or Route B" → "prerequisite of the genus-$0$ sub-case under Route A"; "remains gated on Route A ($\alpha$) or Route B ($\beta$)" → "is gated on Route A ($\alpha$)"; "Independently of ($\alpha$) and ($\beta$)" → "Independently of ($\alpha$)".
  - Reordered so ($\beta$) appears last after ($\alpha$) and ($\gamma$) to visually emphasise that ($\beta$) is a historical entry attached at the end of an otherwise-two-item active list, rather than sitting between the two active items.
  - Updated the closing `In sum:` sentence: "Mathlib currently contains none of the three infrastructure builds" → "Mathlib currently contains neither of the two active infrastructure builds (($\alpha$) and ($\gamma$))"; "discharged by any one of the three routes" → "discharged once ($\alpha$) and ($\gamma$) both land"; appended a sentence clarifying ($\beta$) is preserved for scholarly context only.

### Edit 2 (MUST-FIX) — L425 `def:positiveGenusWitness` theorem statement
- **Revised** the trailing clause of the theorem statement.
  - Old: "supplied by the chosen construction (Route A or Route B per `\cref{thm:nonempty_jacobianWitness}`)".
  - New: "supplied by the Route A construction (per `\cref{thm:nonempty_jacobianWitness}` Route A; Route B is documented as a historical alternative not pursued)".
- The statement now matches the body's Route A-only commitment (the body at L433–L441 enumerates Route A as the committed route and explicitly tags Route B as the historical alternative not pursued).

### Edit 3 (SOON) — L414 `def:genusZeroWitness` body-closure iter estimate refresh + L379 companion cross-consistency
- **Revised** L414 body-closure status paragraph of `\def:genusZeroWitness`.
  - Replaced the trailing sentence "Earliest realistic body-closure iteration: iter-138+." with: an expanded sentence noting the iter-144 chart-algebra pivot trajectory (iter-146+ chart-algebra piece (ii) sub-piece prover lane; iter-149+ M2.a body closure (`thm:rigidity_over_kbar`); iter-151+ M2.b body closure (`def:genusZeroWitness`)) plus the revised earliest-realistic iteration "**iter-151+ (revised iter-145; under the iter-144 chart-algebra pivot)**".
  - Also removed the stale phrase "landing in iter-129+" from earlier in the same sentence (the iter-129+ figure was inherited from the same stale slate as iter-138+ and would have remained inconsistent with the revised iter-146+ chart-algebra piece (ii) gate). Re-wording: "landing in iter-129+." is now part of the deleted suffix and is replaced by the chart-algebra-pivot trajectory sentence.
- **Revised** L379 `\paragraph{Iter-135 body restructure.}` for cross-consistency. The genus-$0$ arm marker "sorry body closing iter-138+" was updated to "sorry body closing iter-151+ under the iter-144 chart-algebra pivot --- see `\cref{def:genusZeroWitness}` body closure status, revised iter-145". The positive-genus arm marker is unchanged (still: "sorry body closing M3 --- M3 is committed to Route A per the iter-144 disposition in STRATEGY.md §~M3; sits behind M2 critical-path during the M2 wait window").

## Cross-references introduced
- No new `\uses{...}` cross-references introduced (revisions are prose-only and stay within already-cited labels: `def:genusZeroWitness`, `def:positiveGenusWitness`, `thm:nonempty_jacobianWitness`, `thm:rigidity_over_kbar`, `sec:RigidityKbar_shared_pile`).

## Macros needed (if any)
- None. All edits use existing macros and standard LaTeX constructs already in active use in the chapter.

## Reference-retriever dispatches (if any)
- None. The directive's edits are purely a reconciliation pass against the iter-144 disposition recorded elsewhere in the chapter (L286–L287 Route B header HISTORICAL, L420 positive-genus arm prose, L433–L441 positive-genus arm proof body). No external source material was needed.

## Notes for Plan Agent

- **Sanity-check on iter-numbering propagation.** The iter-144 chart-algebra pivot trajectory (iter-146+ piece (ii) → iter-149+ M2.a → iter-151+ M2.b) is sourced from the directive's "iter-145 Wave 2 chart-algebra envelope" framing. The numbers are inserted as written; the plan agent should verify they match the live trajectory in STRATEGY.md before iter-146 prover dispatches. If the live trajectory has shifted forward, both the L414 paragraph and the L379 companion sentence will need a refresh.
- **No `\leanok` / `\mathlibok` changes.** Per the writer's descriptor and the directive's "Boundaries" section, all three edits are prose-only. No marker was added or removed. The existing `\leanok` markers on `def:genusZeroWitness`, `def:positiveGenusWitness`, and `thm:nonempty_jacobianWitness` (statement and proof blocks both) are untouched.
- **Sibling chapter cross-consistency to monitor.** Did NOT verify (out of scope) whether sibling chapters (e.g. `AbelJacobi.tex`, `RigidityKbar.tex`, `Genus.tex`) reference the obsolete "iter-138+" genus-0 body-closure estimate or the "Route A or Route B" framing of `def:positiveGenusWitness`. If they do, those would benefit from a writer dispatch next iter (one writer per sibling chapter). The iter-145 blueprint-reviewer is the natural place to flag any such residual cross-chapter staleness.
- **L370 framing language.** I chose to keep the (α)/(β)/(γ) item labels rather than re-letter to drop (β). Rationale: the alphabet labels are referenced elsewhere in the chapter (notably the iter-127 over-k inventory in C.2.g and at L286–L287); re-lettering would have rippled through and exceeded the directive's scope. The (β) item is demoted in place to "historical only --- not pursued" instead.

## Strategy-modifying findings
None. The edits implement an already-committed strategic decision (the iter-144 Route A commitment on M3 with Route B dropped to historical alternative) and do not surface any new strategy-level concern.
