# Blueprint Writer Report

## Slug
jacobian-iter144

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made

- **Revised** the proof body of `def:positiveGenusWitness` (now `Jacobian.tex` ~L428–440). Replaced the stale "off-critical-path / user-escalation-pending / iter-126 user-hint endorsement" framing with the iter-144 disposition: "M3 is **committed to Route A — Picard scheme via FGA**" (per STRATEGY.md § M3 iter-144 disposition; ~6500 LOC midpoint per the iter-123 audit). The "PR-and-wait + do-the-work" framing is dropped: in-tree implementation IS the do-the-work path; upstream PR extraction is an OPTIONAL downstream lift, not a project deliverable. The bullet that previously listed Route A ($\alpha$) and Route B ($\beta$) as parallel "Mathlib-prerequisite routes" is now a single Route A bullet (with the four-step A.1–A.4 decomposition reference and the `RelativeSpec` smallest-entry-point pointer). Route B is cited as "historical alternative not pursued" in a single sentence. Added the M3-after-M2 scheduling clause + the existing iter-150 mathlib-analogist trigger (cumulative M2.body-pile LOC > 925 LOC without piece (i.b) closing, OR M2.a body closure not landed by iter-160).

- **Revised** § Route B header inside the proof of `thm:nonempty_jacobianWitness` (now `Jacobian.tex` ~L286–287). Header re-titled "Route B — Symmetric powers and Stein factorisation (historical alternative; not pursued)". Inserted a header NOTE paragraph: "**Iter-144 disposition.** Route B is a historical alternative *not pursued* by the project … Route A — Picard scheme via FGA — is the committed M3 route per STRATEGY.md § M3 iter-144 disposition. The decomposition, gating Mathlib pieces, and midpoint LOC figure (~9000 LOC) recorded below are the iter-123 audit values; the chapter does not re-cost Route B under current Mathlib snapshots." The B.1–B.3 mathematical content and the "Mathlib status for Route B" bullets are **preserved verbatim** below the NOTE (no mathematical content deleted), per directive instruction.

- **Revised** the subsection preamble at `sec:positiveGenusWitness` (now `Jacobian.tex` ~L419). The previous prose "either Route A (...) or Route B (...) of `thm:nonempty_jacobianWitness`" was the same stale parallel-routes framing the directive asked to drop. Updated to "via Route A (Picard scheme via FGA — Hilbert/Quot infrastructure plus FGA representability) of `thm:nonempty_jacobianWitness`, which is the committed M3 route per the iter-144 disposition in STRATEGY.md § M3. Route B (symmetric powers + Stein factorisation) is a historical alternative not pursued by the project." Strictly speaking the directive listed only the proof body for Edit 1 and the § Route B header for Edit 2, but this preamble is the subsection-opener immediately containing the `def:positiveGenusWitness` theorem and reads as continuation of the proof-body framing; leaving "either Route A or Route B" here would have contradicted the iter-144 disposition the proof body now states.

- **Revised** the trailing "Iter-135 body restructure" paragraph at end of the `thm:nonempty_jacobianWitness` proof (now `Jacobian.tex` ~L379). Replaced the parenthetical "(positive-genus arm, `sorry` body closing M3 --- currently off-critical-path)" with "(positive-genus arm, `sorry` body closing M3 --- M3 is committed to Route A per the iter-144 disposition in STRATEGY.md § M3; sits behind M2 critical-path during the M2 wait window)". Same "off-critical-path" stale framing the directive flagged for Edit 1; same iter-144 reframing applies.

## Cross-references introduced
No new `\uses{...}` cross-references introduced; existing `\uses{def:JacobianWitness, def:genus, def:IsAlbanese, thm:nonempty_jacobianWitness}` on `def:positiveGenusWitness` proof preserved.

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None. STRATEGY.md and `analogies/m3-route-audit.md` provided all the citation material needed; no new source required.

## Notes for Plan Agent

- **Mathlib infrastructure summary at end of `thm:nonempty_jacobianWitness` proof (~L370–377) still presents Route A ($\alpha$) and Route B ($\beta$) as parallel "Mathlib build-outs each unlock[ing] one route".** The (β) bullet says "unlocks Route B"; the trailing summary at L377 says "discharged by any one of the three routes above". This is the same parallel-route framing the directive asked us to drop, but the directive's line citations targeted only L286–311 (the § Route B section proper) and L429–438 (the `def:positiveGenusWitness` proof body), not this summary. The mathematical content of the (β) bullet is technically correct — Route B IS a valid Mathlib build-out that would unlock the construction — so I have left it untouched to stay strictly within the directive's listed scope. If the planner wants full chapter consistency under iter-144, a follow-up writer pass could re-frame the (α)+(β)+(γ) summary to flag (β) as "historical alternative (β)" parallel to the § Route B header change.

- **`def:positiveGenusWitness` theorem statement at L425 still says "supplied by the chosen construction (Route A or Route B per `thm:nonempty_jacobianWitness`)".** This is the theorem statement, not the proof body. The directive said "DO NOT delete the Route B mathematical content"; the statement is a passive description of the witness data and is technically still correct (mathematically a Route B construction WOULD supply the data, even if the project no longer pursues it). I left it untouched. The planner may wish to tighten it to "supplied by the chosen construction (Route A per the iter-144 disposition; see `thm:nonempty_jacobianWitness`)" in a follow-up pass.

- **Stale `\notready` markers (PROGRESS.md iter-143 watch criterion #9).** Confirmed no `\notready` matches anywhere in `Jacobian.tex`. The chapter ships clean on this dimension per Edit 3.

- **`def:positiveGenusWitness` scaffold-status block** (Edit 4 optional refresh). The block correctly identifies the Lean target `AlgebraicGeometry.positiveGenusWitness` (scaffold landed iter-134 with `sorry` body; M3 work, now committed to Route A per iter-144). No content change made; the directive's "no content change unless the existing prose is mathematically inaccurate" criterion was satisfied — the existing prose was accurate, only the framing of M3 status was stale and is now updated as part of Edit 1.

## Strategy-modifying findings
None. The directive's intent was to bring the chapter into alignment with the iter-144 STRATEGY.md disposition; no new strategy-level issues were surfaced. The edits faithfully reflect the binding iter-144 user-hint absorption recorded in STRATEGY.md § "Iter-144 user-hint M3 disposition (binding)" and § Off-critical-path "M3 (positive-genus witness): iter-144 disposition".
