# Iter 030 — Plan (Quot-Foundations)

## TL;DR

Processed the iter-029 prover round (FBC 4→4 with a *definitive negative diagnosis* + compiling riders;
QUOT +1 axiom-clean finite-cover front; GR no-output). The progress-critic returned **two must-fix
verdicts** — FBC **CHURNING** and QUOT **STUCK** — and for each I executed the named structural corrective
THIS iter (not a reworded re-dispatch):

1. **FBC CHURNING → effort-breaker decomposition.** The iter-029 prover *conclusively* proved the entire
   keyed-rewriting family (rw/simp/erw/conv/set/dsimp) is dead against the `X.Modules` instance diamond —
   even `rw` of a `rfl`-true copy of the goal's own printed factor fails. The monolithic "build the ~150-LOC
   `exact` term" dispatch has failed 4 rounds. Corrective: dispatched **effort-breaker `fbc-legs`**, which
   split `lem:base_change_mate_fstar_reindex_legs` into **5 `\uses`-linked clean-term link sub-lemmas**
   (each stated on freshly-elaborated terms → one instance in scope → no diamond → ≤30 LOC each), with the
   target reduced to one closing `exact (L1.trans (L2.trans …))` that crosses the diamond by defeq. This is
   structurally different from prior rounds: progress is now testable link-by-link and each piece is
   diamond-free. FBC gets a **fine-grained** prover this iter (per the critic's recommendation).
2. **QUOT STUCK → mathlib-analogist consult BEFORE any transport prover.** 4 helpers added across 3 rounds,
   zero gap1 progress; the `q.presentation i` slice synthInstance *timeout* signalled a wrong-API-shape, not
   a one-lemma gap. Corrective: dispatched **mathlib-analogist `quot-transport`** (api-alignment), which
   returned **PROCEED on a corrected decomposition**: (a) the obstacle "no restriction functor on
   `(Spec R).Modules`" is FALSE — `Scheme.Modules.restrictFunctor`/`pullback` exist; (b) the slice
   `over`-route is canonical and its timeout is *tameable* via `set_option
   backward.isDefEq.respectTransparency false` (the `QuasicoherentData.bind` template proves this); (c) the
   two genuinely-missing lemmas are **C `overRestrictIso`** (`M.over U ≅ M.restrict U.ι`, the one
   slice-touching bridge) and **D `section_localization_descent`** (Stacks 01HA). A blueprint-writer
   (`quot-gap1`) rewrote the entire gap1 cone to this decomposition (6 mathlib anchors + C + D + transport +
   the gap1 keystone). QUOT gets a **mathlib-build** prover with the corrected build order.
3. **GR UNCLEAR → sharpened re-dispatch.** Only K=2 rounds (1 productive, 1 no-output); below the pattern
   threshold. Re-dispatch with a sharpened directive: prove the cocycle ring identity `Φ=id` as a STANDALONE
   named lemma FIRST (pure ring, no scheme content / no diamond), then assemble `GlueData` + glued scheme.
   If R3 also no-outputs, escalate to STUCK next iter.

STRATEGY.md revised (FBC-A over-budget estimate + escalation note; GR-glue elevated to its own ACTIVE row;
QUOT-defs gap1 4-step decomposition; gap1 added as its own Mathlib-gap with C/D). blueprint-clean +
whole-blueprint blueprint-reviewer (HARD GATE) + strategy-critic all run this iter.

## State at entry (verified from iter-029 task_results + leandag)

- **FBC** 4 sorries: `_legs` @1335 (root crux, now decomposed), `gstar_transpose` @1695 (gated on `_legs`),
  affine @1968, FBC-B @2008. Riders landed: dead `hpfc` removed; 3 atoms de-privated; 2 docstrings fixed.
- **QUOT** 4 protected stubs + the new axiom-clean `exists_finite_basicOpen_cover_le_quasicoherentData`
  (finite-cover front). gap1 cone rewritten in the blueprint per the corrected decomposition.
- **GR** 0 sorries (target decls are new work). cocycle reduces to the ring identity `Φ=id`.
- **GF** 1 sorry (geo, gated on gap1). Coverage debt: 1 unmatched `lean_aux` (the QUOT finite-cover helper).

## Subagents this iter (dispatched by the prior context window + this one)

- **progress-critic `iter030`** — FBC CHURNING (must-fix; corrective = effort-breaker), QUOT STUCK
  (must-fix; corrective = analogist consult first), GR UNCLEAR. Dispatch sanity OK (3 files).
- **mathlib-analogist `quot-transport`** (api-alignment) — PROCEED, corrected decomposition; restriction
  functor exists; C + D are the gaps; slice timeout tameable. `analogies/quot-gap1-transport.md`.
- **effort-breaker `fbc-legs`** — split `_legs` into 5 clean-term link sub-lemmas in the FBC chapter; target
  proof rewritten to chain them; cone `∞`-effort-free, no broken `\uses`.
- **blueprint-writer `quot-gap1`** — rewrote the QUOT gap1 cone (mathlib anchors + C `over_restrict_iso` +
  D `section_localization_descent` + transport + keystone `qcoh_affine_isIso_fromTildeΓ`). NOTE: this writer
  completed its edits but was killed before writing its task_results report (parent context ended); its
  on-disk chapter edits are intact and were cleaned + are under blueprint-review this iter.
- **blueprint-clean `iter030`** — purity pass on FBC + QUOT chapters: 3 FBC prose fixes (stripped Lean
  jargon), 5 QUOT prose fixes + added the missing `% SOURCE QUOTE:` for `lem:qcoh_affine_section_localization`
  (Stacks `lemma-invert-f-sections`, properties.tex L2152–2170). No marker/`\uses` changes.
- **blueprint-reviewer `iter030`** (whole, HARD GATE) — running; gates the 3 prover chapters.
- **strategy-critic `iter030`** — running on the revised STRATEGY.

## Decision made

### FBC — fine-grained over the 5 link sub-lemmas (NOT another monolithic `exact` attempt)
- **Chosen:** effort-breaker decomposition (done) + a fine-grained prover that scaffolds and fills each of
  the 5 links in isolation, then assembles. **Why:** the CHURNING gate guards against re-dispatching the
  same monolithic task with cosmetic variation; the decomposition makes each step diamond-free (single
  instance) and progress link-testable — categorically different. **Reverse signal:** if a *single* link
  still resists (most likely L3/L4 against the unfolded codomain read), re-break that one link
  (unfold-`Θ_tgt` vs hom–inv-cancel) — the recipe in `analogies/fbc-functorimage-diamond.md` applies.
- **OVER_BUDGET acknowledged:** FBC-A entered iter-018, ~12 elapsed vs the old 2–4 estimate. STRATEGY now
  carries an explicit escalation trigger — if the effort-breaker + fine-grained assembly does not close the
  `_legs`→`gstar_transpose` cascade by **iter-032**, escalate to the user via TO_USER.md (project's oldest
  open stall). Not escalating yet: the corrective is genuinely new and unattempted.

### QUOT — build C → P1 → D → assemble; do NOT hand-roll a restriction functor
- **Chosen:** the analogist's corrected build order, mathlib-build mode, starting at `overRestrictIso` (C).
  **Why:** the prior 3 rounds collided with a wrong API shape (hand-rolling slice transport); the analogist
  established the restriction functor already exists and isolated the two real gaps. **Reverse signal:** if
  C (`overRestrictIso`) cannot be stated even with `respectTransparency false`, the slice-site approach is
  structurally wrong — re-consult before more building.

## Prior critique status (iter-029 strategy-critic CHALLENGE×2)
Both were recorded ADDRESSED in iter-029 (FBC merge-back resolved by the frozen `IsIso(pushforwardBaseChangeMap)`
signature; SNAP Q1 given a concrete defer-until-gap1 trigger). The revised STRATEGY this iter preserves both
resolutions (Open Q1 SNAP decision deferred-until-gap1 with the reference-retriever trigger; FBC route note
unchanged). The fresh strategy-critic `iter030` re-verifies against the revised file.

## Subagent skips
- (none — all three highly-recommended plan-phase subagents dispatched: progress-critic, blueprint-reviewer,
  strategy-critic.)
