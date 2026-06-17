# Iter 079 — Plan (Quot-Foundations)

## TL;DR
Two frontier prover lanes (GlueDescent, GrassmannianQuot) re-dispatched, gate-cleared. Major
strategy action: **FBC route swap** — un-parked the goal-required FBC leg onto the DIRECT
H⁰-equalizer route, abandoning the dead mate keystone.

## Decision made — FBC route swap (reversal signal: direct assembly proves impossible)
- Strategy-critic CHALLENGE (vindicated by inspection): the two named goal legs
  `affineBaseChange_pushforward_iso`@2566 + `flatBaseChange_pushforward_isIso`@2606 were parked on the
  dead mate keystone `_legs_conj`@1802 / `_gstar_transpose`@2291 (4 sorries, FlatBaseChange.lean).
- **Found:** `FlatBaseChangeGlobal.lean` already executes the critic's direct route 0-sorry through
  `baseChangeGammaEquiv` (B⊗_A Γ ≅ eqLocus of base-changed legs) + `gammaTopEquivEqLocus` + finite cover.
  The mate keystone is NOT on this route.
- **Action:** STRATEGY.md — FBC-B now ACTIVE/primary (2–4 iters), FBC-A mate keystone OFF-PATH. Dispatched
  blueprint-writer `fbc-b-direct` → added `thm:fbcb_global_direct` (scopes the remaining assembly
  `baseChangeGammaPullbackEquiv`; cites 02KH.2 + 01I9). Bodies of the two frozen named targets get filled
  from it; the `base_change_mate_*` apparatus is dead-code to delete in a cleanup lane.
- LOC/risk: ~150–350 LOC, low risk (all hard inputs DONE). Reverses only if the per-chart 01I9 assembly
  hits an unforeseen wall — then re-evaluate, but the mate keystone stays abandoned regardless.

## Critic responses
- **strategy-critic FBC CHALLENGE:** ADOPTED (above). Q2 marked RESOLVED-by-swap.
- **strategy-critic QUOT-χ CHALLENGE:** rebuttal — current STRATEGY never claimed χ/Snapper (the quoted
  phase cell is stale); Routes already commit to H⁰ Φ_s. Tightened Q1 to LIVE + explicit "no cohomology
  engine ⇒ χ unreachable ⇒ H⁰ is the only route." No χ string remains.
- **strategy-critic format DRIFTED:** trimmed the FBC cells of per-iter narrative during the swap; deeper
  trim deferred (structurally compliant, under 250 lines).
- **progress-critic (both UNCLEAR, on schedule):** proceed. Encoded its WATCH into PROGRESS — GlueDescent
  MUST close ≥1 sorry (L1679 prioritized, the no-new-math one) or it upgrades to CHURNING next iter.
- **blueprint-reviewer (all 3 active lanes PROCEED):** acted on its writer queue — `grquot-debt` cleared
  the 15-helper coverage debt + chartLocus_isOpenCover prose. Minor `\uses`/`\mathlibok` items tracked in
  PROGRESS (non-blocking).

## Scaffolder failure — SNAP deferred
`lean-scaffolder snap-coherent` DIED mid-run (no report, no decl) struggling to STATE
`sectionsMul_assoc_unit` (signature shape vs `DirectSum.GCommSemiring` fields — a design problem, not a
proof one). Did NOT blind re-dispatch. SectionGradedRing stays 0-sorry (no-op filtered). Next iter:
mathlib-analogist api-alignment on the graded-mul field shapes → concrete-signature scaffold.

## Subagent skips
- (none — blueprint-reviewer, progress-critic, strategy-critic all dispatched this iter.)
