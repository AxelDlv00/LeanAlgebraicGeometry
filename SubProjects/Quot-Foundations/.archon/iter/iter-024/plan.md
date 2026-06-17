# Iter 024 — Plan (Quot-Foundations)

## TL;DR

A **corrective-then-dispatch + strategic-retarget** iter. A prior partial run this iter (before a context
reset) had already dispatched the two read-only critics (progress-critic, strategy-critic) and the two
write-capable correctives (effort-breaker `fbc-ecancel`, blueprint-writer `gf-g1g3` + reference-retriever
`stacks-properties`), and updated STRATEGY.md. I picked up after those returned, executed the remaining
mandatory gate (blueprint-clean → blueprint-reviewer), and then made the iter's load-bearing call: the
GF-geo lane's real blocker is the **shared keystone `isLocalizedModule_basicOpen`**, which has no Lean
decl and sits in the QuotScheme namespace, so I **retarget the GF-enabling work to build that keystone
once in QuotScheme.lean** (mathlib-build) rather than send a GF prover into a known wall. Dispatch: FBC
fine-grained (the now-decomposed `inner_eCancel` atoms — payoff of the STUCK corrective) + QUOT keystone
mathlib-build. GF-geo G1/G3 deferred one iter (blocker being cleared this iter).

## State at entry (iter-023 outcomes, verified)

- **FBC** — `gstar_transpose` 5-lemma chain: Seam C (`gstar_counit_transport`) CLOSED axiom-clean; Seam A
  (`inner_value_eq` @1577) + Seam B (`gstar_generator_close` @1532) PARTIAL (hard categorical step closed,
  residual named). The wall was the single ~150-LOC `inner_eCancel` telescoping.
- **GF** — `genericFlatness` re-signed `[QuasiCompact p]` (correctness fix; was false); instances
  discharged; sorry @2173 bottoms at G1/G3 (Mathlib-absent). `genericFlatnessAlgebraic` axiom-clean.
- Build GREEN all modules.

## Subagents this iter (6; all returned)

- **progress-critic `iter024`** — FBC **STUCK** (deferral phrase ≥2 iters; PARTIAL×4; throughput SLIPPING
  4 vs 2–3) but route advancing (Seam C closed); corrective = **second-pass effort-breaker on
  `inner_eCancel`** (explicitly NOT a pivot). GF-geo **UNCLEAR** (1 iter data; proceed/watch). Dispatch
  sanity OK (2 lanes).
- **strategy-critic `iter024`** — FBC SOUND; GF **CHALLENGE** (re-estimate; name G1/G3; confirm base
  integrality); QUOT canonicity Serre **CHALLENGE** (gate before S1). Process note: its pasted STRATEGY
  was stale — it audited the live file and found the format/GF-reconcile worries already fixed.
- **effort-breaker `fbc-ecancel`** (FBC STUCK corrective) — split `lem:base_change_mate_inner_eCancel`
  (effort 1254) into three frontier-ready atoms `_eUnit`(366)/`_pushforwardComp`(443)/`_pullbackComp`(615),
  all deps proved. (Report write was cut off by the context reset, but the chapter edits + its own
  dag-query validation landed; I re-verified the three atoms are present with concrete `% theorem`
  signatures and registered as frontier after `archon dag`.)
- **blueprint-writer `gf-g1g3`** — added G1 `lem:gf_qcoh_fintype_finite_sections` (Stacks 01PB verbatim,
  freshly retrieved) + G3 `lem:gf_flat_locality_assembly`; de-staled `thm:generic_flatness` header.
- **blueprint-clean `fbc-gf`** — 4 rendered-prose history/leakage scrubs across both edited chapters;
  preserved all `% LEAN SIGNATURE`/`% SOURCE`/`% NOTE` comment scaffolding; confirmed citations.
- **blueprint-reviewer `iter024`** (mandatory, whole blueprint) — **both active chapters clear the HARD
  GATE**: HG-1 FBC-A PASS (3 atoms well-formed, sound, frontier-ready); HG-2 GF-geo CONDITIONAL_PASS (G1
  honest; its dep `isLocalizedModule_basicOpen` confirmed to have NO Lean decl). blueprint-doctor CLEAN.
  Flagged stale dag (rebuilt) + UP-2 (the keystone) as the load-bearing frontier.

## Decision made

### Retarget GF-enabling work to the shared keystone `isLocalizedModule_basicOpen` (QuotScheme), defer GF-geo G1 one iter

- **Option chosen:** build `isLocalizedModule_basicOpen` (`lem:qcoh_section_localization_basicOpen`) once
  in **QuotScheme.lean** via `mathlib-build`, rather than dispatch a GF-geo prover on G1 in
  FlatteningStratification.lean.
- **Why:** Three independently-verified facts force this. (1) G1 (`gf_qcoh_fintype_finite_sections`)
  `\uses{lem:qcoh_section_localization_basicOpen}`, and that node has **no Lean declaration** (grep:
  docstring mentions only) — a GF-geo G1 prover would immediately rediscover this wall. (2) The keystone's
  `\lean{}` pin is `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen` (QuotScheme home), and a
  live QUOT consumer (`def:modules_annihilator` reverse direction ⊇) also bottoms at it — so it is genuinely
  shared, and the blueprint-reviewer's UP-2 names it the single most load-bearing frontier. (3)
  FlatteningStratification does NOT import QuotScheme, so building a *self-contained* G1 copy there (the old
  STRATEGY Open-question plan) would create the exact parallel API the standing PARALLELISM directive and
  the strategy warn against. Building the keystone once, in its namespace home, unblocks BOTH routes.
- **LOC/risk trade-off:** the keystone is real qcoh infrastructure (part 2: transport `Γ(D(f),Ñ)=N_f` to a
  general quasi-coherent sheaf via `U ≅ Spec Γ(X,U)`). mathlib-build is the right mode — go bottom-up
  axiom-clean, hand off a decomposition if blocked. Part (1) is a verified Mathlib anchor; part (2) has the
  verified `ModuleCat.Tilde.*` machinery. Cost of deferring GF-geo one iter = ~1 iter latency; cost of
  sending GF into the wall = a wasted prover iter + a duplicated keystone. The retarget strictly dominates.
- **Cheapest signal to reverse:** if the keystone mathlib-build reveals the qcoh↔tilde affine identification
  is a multi-iter build, reconsider whether GF-geo needs the full keystone or a weaker affine-only finite-
  module fact; and decide shared-extraction vs the QuotScheme import for FlatteningStratification then.

### FBC STUCK — honored via the named corrective (effort-breaker), pivot rebutted

The progress-critic's STUCK fires on the mechanical rules (deferral phrase ≥2 iters; PARTIAL×4) but its
own report says no pivot is warranted (Seam C closed axiom-clean iter-023 — first sorry-elimination in the
K-window). Its named corrective is a **second-pass effort-breaker on `inner_eCancel`**, which was executed
(`fbc-ecancel`, splitting the 1254-effort monolith into three ≤615 frontier-ready atoms). The FBC prover
this iter is therefore NOT a reworded re-dispatch of the wall — it formalizes three small independently-
checkable atoms the prior attempts did not have, then assembles up. This is the sanctioned "execute the
corrective, then dispatch" response. I rebut only any STUCK→pivot reading, on the same signals the critic
itself cites.

### strategy-critic GF/QUOT CHALLENGEs — addressed (not silently ignored)

- **GF re-estimate + G1/G3 naming:** STRATEGY GF-geo row revised to 2–4 iters with the "G1/G3 are real
  Mathlib-absent plumbing" rationale; G1/G3 named explicitly in `## Mathlib gaps`.
- **GF base-integrality hyp:** verified directly — `genericFlatness` carries `[IsIntegral S]
  [IsLocallyNoetherian S]` (FlatteningStratification.lean:2173). Concern satisfied; STRATEGY records "base
  `[IsIntegral S]` present (✓)".
- **QUOT canonicity Serre:** remains gated in STRATEGY Open questions; **no S1 prover dispatched** this
  iter, so the gate is not crossed. The keystone lane targets `isLocalizedModule_basicOpen` only (a defs-
  level qcoh fact), NOT the Serre-gated `def:sectionGradedRing`/S1 input — so it does not touch the
  unresolved canonicity question.

## Subagent skips

- (none) — all three plan-mandatory subagents dispatched this iter: blueprint-reviewer `iter024`,
  progress-critic `iter024`, strategy-critic `iter024`. blueprint-clean + effort-breaker + blueprint-writer
  + reference-retriever also ran.

## Disproof / soundness checks
- `genericFlatness` base-integrality: confirmed the signature carries `[IsIntegral S]` (else the statement
  is false over a non-reduced/reducible base, per the strategy-critic and the iter-023 `⊔ᵢSpec ℤ` analysis).
- The keystone statement is the standard Stacks 020J §7 item (4) (`Γ(D(f),Ñ)=N_f`) — a true, classical
  fact; no disproof concern.

## What shaped iter-025
1. FBC: the three atoms are high-confidence closes (small frontier nodes) → `inner_value_eq` de-sorry →
   `gstar_transpose` → cascade. If `gstar_transpose` closes, FBC-A nears done; then dead-code refactor +
   affine/FBC-B.
2. GF: once the keystone lands, decide shared-extraction (mathlib-analogist API-alignment), then build G1
   → G3 → close `genericFlatness`.
3. QUOT: keystone also unblocks the annihilator reverse direction; SNAP-S1 still gated on Serre canonicity.
4. GR (UP-3): self-contained `Grassmannian.scheme` gluing lane, openable in parallel when budget allows.
