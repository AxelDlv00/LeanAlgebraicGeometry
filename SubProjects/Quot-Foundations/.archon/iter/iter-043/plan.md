# Iter 043 — Plan (Quot-Foundations)

## TL;DR
2 import-independent prover lanes: **FBC tilde-transport** (mandatory pivot, `sections_direct` +
re-prove `cancelBaseChange`) and **QUOT close gap2** (Piece A QC-pullback + Piece B bridge). Blueprint:
writer+clean+fast-path re-review cleared the gap2 gate (4 helper blocks + Piece A `lem:qcoh_pullback_fromSpec`).
GF-G1 DEFERRED to iter-044 (verified gap2-gated, not G1-core).

## Decision made — 2 lanes (not 3); GF-G1 deferred
- **Chosen:** FBC + QUOT-gap2 this iter; GF-G1 iter-044.
- **Why GF-G1 deferred (rebuts progress-critic's "GF-G1 ready"):** I read `lem:gf_qcoh_fintype_finite_sections`
  — its statement is over an affine OPEN `W ⊆ X` of a general scheme and its proof `\uses{lem:qcoh_section_localization_basicOpen}`
  = **gap2**, NOT G1-core (the Spec R corollary). gap2 is not yet in Lean (it is THIS iter's QUOT target).
  Dispatching GF-G1 now = a guaranteed-blocked lane (prover can't load `isLocalizedModule_basicOpen`). The
  critic's GF "corrective already applied" rested on my own imprecise directive framing ("G1-core application");
  corrected here + in STRATEGY/PROGRESS. GF-G1 becomes ready the iter after gap2 commits. Not avoidance — a
  genuine Lean dep the critic itself acknowledged.
- **FBC scope:** deliverable = `sections_direct` (NEW, axiom-clean) + `cancelBaseChange` re-proven axiom-clean
  off `gstar_transpose`. The 2 dead conjugate sorries (1848/2315) are entangled (13 refs) → removal is a
  follow-up cleanup, NOT this lane. Escalation gate (progress-critic): `sections_direct` landing axiom-clean =
  route progress; if the direct Γ(α) computation re-derives the mate → bypass illusory → escalate.
- **No effort-breaker on Piece A:** the writer's Piece A block decomposes the route into its 2 real steps and
  `quot-recheck` confirmed the 5-item `\uses` cone is complete — not under-declared. mathlib-build prover goes
  bottom-up, flags if a sub-step resists (progress-critic watch).
- **Reversal signals:** FBC — illusory bypass → escalate. QUOT — Piece A resists → flag the precise sub-step
  immediately (no silent 2nd-iter defer; the gap1 arc over-ran by deferring blockers).

## Critic dispositions
- **progress-critic `iter043`:** QUOT CONVERGING (watch Piece A) / FBC UNCLEAR (escalation gate armed) / GF
  CHURNING-by-meta. ACCEPTED; GF corrective = defer (gap2-gated, see Decision). 2-lane dispatch OK.
- **blueprint-reviewer `iter043` + `quot-recheck`:** gap2 4 CRITICAL defects → writer-patched → re-cleared
  same iter (fast path). FBC-A1 + GF-G1 chapters complete+correct.

## Subagent skips
- strategy-critic: prior verdict (iter-042) SOUND with must-fixes addressed, no live CHALLENGE. The only
  STRATEGY edits this iter are bookkeeping within the already-SOUND routes — (a) correcting GF-G1's dependency
  from "G1-core" to "gap2" (factual fix), (b) registering Piece A (`isQuasicoherent_pullback_fromSpec`) as the
  QC-pullback sub-build of the SOUND QUOT-consumers route. No route swap / phase reorder / >30% re-estimate →
  no strategic change for the critic to assess.
