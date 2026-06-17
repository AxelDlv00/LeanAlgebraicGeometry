# Iter-228 (Archon canonical) — review

## Outcome at a glance

- **The "hard-block fires: the verbatim-mirror C-bridge is empirically a genuine block" iter.**
  The funded Decision-1 sheaf internal-hom build (committed iter-219; on a bounded committed
  runway after the iter-227 terminal-grace tripwire; progress-critic ts228 = **STUCK +
  OVER_BUDGET**). One prover (opus, `mathlib-build`), status **PARTIAL** — but the iter-228
  **sharpened C success bar** (C-bridge must land FULL axiom-clean) was **NOT met**, and the
  pre-committed **hard-block condition fired**.
- **3 new declarations landed axiom-clean** (re-verified first-hand via `lean_verify`, all
  `{propext, Classical.choice, Quot.sound}`): `PresheafOfModules.dualPrecompEquiv` (L1558),
  `PresheafOfModules.dualIsoOfIso` (L1603), `AlgebraicGeometry.Scheme.Modules.dualIsoOfIso`
  (L1698) — the "dual respects isos" ingredient. Per the sharpened bar, these are **helpers,
  not route progress**.
- **C-bridge `dual_isLocallyTrivial` GENUINELY BLOCKED at H2′.** Empirically (via `lean_goal`):
  Steps 1–3 + H1 of the verbatim mirror typecheck; the residual `(pushforward β).obj (dual A) ≅
  dual ((pushforward β).obj A)` does **NOT** close via `restrictScalarsRingIsoDualEquiv`. The
  dual is the **SLICE** internal hom (value = morphism-module over `Over U`), not a sectionwise
  `restrictScalars`-image, so it has no sectionwise strong-monoidal analogue. Closing it needs
  the **Mathlib-absent open-immersion slice-site equivalence (~150–300 LOC)** — NOT a verbatim
  mirror. No sorry pinned (FORBIDDEN constraint honoured).
- **Sorry trajectory:** project **80 → 80** (12th consecutive iter with no project-sorry-elim
  since iter-217); file-local 3 → 3 (unchanged).
- **Build GREEN; blueprint-doctor CLEAN.** `sync_leanok` iter 228, sha `2f21b101`, **+2 / −0**,
  `chapters_touched: [Picard_TensorObjSubstrate.tex]` (the two iter-227-decl blocks added by the
  iter-228 writer; no laundering — the new helpers are not yet `\lean{}`-pinned).

## The defining tension — the cheapest, lowest-risk piece turned out to be a genuine block

iter-228 is the moment the route's remaining cost became *legible and larger*:

- **iter-228 chose C-primary precisely because the blueprint billed it the lower-risk
  deliverable** — a verbatim mirror of the closed `tensorObj_restrict_iso` with H1 reused and
  H2′ (`restrictScalarsRingIsoDualEquiv`) already built. That framing is **empirically
  falsified**: the mirror breaks at H2′ because `dual` is the slice internal hom, not the
  sectionwise tensor. The remaining cost grew (slice-site equivalence ~150–300 LOC **on top of**
  the A-engine ~120–190 LOC), and the frozen ~3–4-piece estimate now understates the truth.
- **What is NOT regressed:** d.2-freeness is intact (the slice reindexing is structural, not a
  stalk), so the deep-math risk stays retired. But "d.2-free" was never the binding cost — build
  size is, and it is materially larger than iter-228 assumed.
- **The pre-commitment binds.** The iter-228 plan wired exactly this: "a *genuine* failure to
  land axiom-clean (a true block, not budget exhaustion) makes the USER escalation bind." The
  prover's report is the textbook hard-block input (route bottoms out at H2′, empirically). So
  the escalation now binds — this is the correct pre-agreed outcome, not a planner error.

This is not a knock on the prover (it ran the decisive probe, diagnosed the slice-vs-sectionwise
mismatch precisely, refused to stub, and localized the genuine missing infra) nor on the
iter-228 planner (banking the lower-risk piece first was the correct convergence play, and the
hard-block was pre-wired). It is an honest read of the **arc**: the route's last "cheap" piece
was not cheap, and the binding cost (build size) is now larger and confirmed.

## Process correctness

- **Prover: textbook.** Decisive empirical probe (`lean_goal` residual), precise blocker
  diagnosis (slice internal-hom vs sectionwise tensor — why H2′ does not lift), refused to stub,
  landed 3 axiom-clean on-path helpers, abandoned (not stubbed) the off-path `dual_unit_iso`,
  honoured every FORBIDDEN constraint. The hard-block report is actionable. No overclaim: the
  task result explicitly states C did NOT land and does NOT count as route progress under the
  sharpened bar.
- **Planner (iter-228): pre-commitment honoured, now triggered.** Accepted the STUCK verdict,
  sharpened the C bar, wired the hard-block, kept the escalation LIVE. The hard-block has now
  fired exactly as specified.
- **Open process question for iter-229 (surfaced, not pre-decided):** the bounded runway's first
  piece (C) failed as a genuine block, so iter-229 cannot "continue building C." The non-idle
  options are (a) scope the slice-site equivalence as a fresh ~150–300 LOC build, or (b) hold the
  route pending the USER fork (lift RR pause → divisor `Pic⁰`). The harness never-idle rule still
  forbids stalling on a user reply, so absent a USER hint the loop must take (a). Both are in
  recommendations.md; the binding decision is the USER's (escalated via TO_USER).

## Review-subagent decisions

- **lean-vs-blueprint-checker** (slug `tensorobj228`): DISPATCHED — `TensorObjSubstrate.lean`
  received prover work; the rule forbids skipping a prover-touched file. Confirms the 3 new
  decls are unpinned (Lean→blueprint gap) and the `lem:dual_isLocallyTrivial` `\lean{}` pin is a
  placeholder (target Lean decl absent). Findings landed in recommendations.md.
- **lean-auditor** (slug `ts228`): DISPATCHED — a `.lean` file was modified this iter (skip
  condition "no .lean modified" not met). Unbiased read of the 3 new decls + accumulated stale
  comments at this escalation juncture. Findings landed in recommendations.md.

## Markers
- Added `% NOTE:` to `lem:dual_isLocallyTrivial` (`Picard_TensorObjSubstrate.tex`) recording the
  empirically-confirmed blueprint error (verbatim-mirror wrong past Step 3/H1). Left the `\lean{}`
  pin in place (target decl does not yet exist; repair is the planner/writer's via prose).
- No `\mathlibok` (the new decls are project-proved, not Mathlib re-exports). No `\leanok` touched.
