# Recommendations — after iter-080 (project content-complete; 0 sorries)

## HIGH — the one outstanding gate
1. **Confirm the full-build / axiom-clean gate is green.** Review launched
   `lake build AlgebraicJacobian.Cohomology.CechToHigherDirectImage` (capstone olean was absent at review
   start because the user's edit to `CechHigherDirectImage.lean` invalidated the downstream chain).
   **Build result this iter: INCONCLUSIVE — still running at review close (~45 min in, recompiling the
   memory-heavy `CechSectionIdentificationLeg.lean` dep; capstone olean still absent). Verdict CARRIED to
   iter-081, NOT failed. Re-run the build first thing next iter (consider killing the 4 redundant stale
   `lean` workers first to free memory).**
   - If GREEN: also run `#print axioms AlgebraicGeometry.cech_computes_higherDirectImage` and confirm
     kernel-only `{propext, Classical.choice, Quot.sound}`. Then the deliverable is fully verified →
     advance stage prover→polish.
   - If RED: dispatch the **`refactor`** subagent (NOT a `prove` lane — the file is 0-sorry) with the exact
     diagnostic. Do not advance stage. This is the planner's pre-stated reversal signal.

## MEDIUM — polish (cosmetic, do NOT block "complete")
2. **STRATEGY.md format DRIFTED** (strategy-critic `finish`): trim iter-078/079/080 per-iter narrative from
   §Goal/§Phases/§Routes prose to present-tense one-liners; the "user dropped the frozen sibling" history
   belongs in the iter sidecar. Plan-agent domain.
3. **Labeling** (strategy-critic `finish`, non-blocking): describe the deliverable as the "**separated case
   of the relative form of** Tag 02KE" (it generalizes 02KE in the relative `Rⁱf_*` direction, specializes
   in the hypothesis direction). The blueprint scope note already says this; ensure STRATEGY §Goal matches.
4. **Stale docstrings**: `CechSectionIdentificationLeg.lean:15` and `CechSectionIdentification.lean:20` each
   say "Carries the residual sorry …" but the referenced decls are sorry-free (strategy-critic read
   `coreIso_comm_leg`, Leg:1544–1609, complete). User-owned `.lean` edit; flag in TO_USER, do not block.
5. **Blueprint textual ordering** (blueprint-reviewer, optional): `lem:pushforward_mapHC_cechComplexOnX`
   (L11957) and `lem:cechAugmented_to_acyclicResolutionInput` (L12000) appear after their consumer
   `lem:cech_computes_cohomology` (L11801). DAG is correct; reader-order only.

## Coverage / DAG (clean — no action)
- `archon dag-query unmatched` = **0** lean_aux nodes. No coverage debt.
- `archon dag-query gaps` = **0** ∞ holes. blueprint-doctor: clean (no orphans, no broken refs, no axioms).
- 3 frontier nodes are `\lean{}`-less subsumed blueprint lemmas (pre-existing); not prover work.

## Do NOT
- Do NOT re-assign the dropped general `cech_computes_higherDirectImage` (general `X.OpenCover`, only
  `[IsSeparated f]`) — it is mathematically FALSE (ℙ¹/`𝒰={𝟙 X}`/O(−2)), not merely unproven.
- Do NOT send a `prove` lane at any 0-sorry file (plan-validate's noop-trap drops it; the prover thrashes).
  Any structural fix on a 0-sorry file goes to `refactor`.
