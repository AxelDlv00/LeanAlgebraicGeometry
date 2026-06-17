# Iter 011 — Plan (Quot-Foundations)

## TL;DR

First prover iter since iter-010's DAG re-elaboration. Build GREEN (8324 jobs). Dispatched all
three highly-recommended critics (blueprint-reviewer, progress-critic, strategy-critic) in parallel;
all three converged on the same read. **Four lanes gate-cleared and dispatched this iter** — FBC-A
[prove], GF-alg [mathlib-build], QUOT-A [mathlib-build], and GrassmannianCells [mathlib-build]. The
GrassmannianCells lane is back in rotation via the **same-iter fast path**: its `def:gr_transition`
(the 2-iter zero-output STUCK node) was effort-broken this iter into 8 small project blocks + 5
verified Mathlib anchors, blueprint-clean'd, and a scoped re-review CLEARED the gate for a bottom-leaf
scaffold dispatch. Resolved the strategy-critic's SNAP-S1 cohomology-freeness CHALLENGE + format drift
in STRATEGY.md. **Key finding:** the FBC route-swap, GF effort-break, and QUOT-A annihilator path were
all blueprint-only — the Lean still carries the OLD structure — so each lane must CREATE the new decls
to match the blueprint, not merely fill an existing sorry. `def:sectionGradedRing` stays BLOCKED
(missing `% LEAN SIGNATURE`) and is explicitly NOT a target.

## State at entry

- iter-010 = DAG re-elaboration (no prover phase). Blueprint fully elaborated; leandag clean
  (8 ready frontier nodes, 0 ∞-sources, 0 broken `\uses{}`).
- Build GREEN. Real sorries: FBC ~5–6 (incl. the old `map_smul'` zero-branches + the orphan
  `…_generator_trace_eq`), GF 5, QuotScheme 4 (skeleton stubs), GrassmannianCells 0 (only
  `affineChart`; `transitionMap` never built).
- Prior clean blueprint review = iter-009; stale w.r.t. the iter-009 writers + iter-010 dag → fresh
  whole-blueprint review mandatory this iter.

## Critic dispositions

- **blueprint-reviewer `iter011` (HARD GATE):** FBC GREEN; GF GREEN (all 4 chain nodes); QuotScheme
  GREEN on `lem:qcoh_section_localization_basicOpen` / BLOCKED on `def:sectionGradedRing` (no
  `% LEAN SIGNATURE`); GrassmannianCells report-only (effort-break supersedes). 0 unknown_uses,
  0 broken refs, 0 axioms.
- **progress-critic `iter011`:** FBC CONVERGING, GF CONVERGING, QuotScheme UNCLEAR (first real prover
  opportunity, the 2 prior no-prover iters were legitimate structural-setup), GrassmannianCells STUCK
  (2 zero-output dispatches). Must-fix: pair the GrassmannianCells effort-break with a
  blueprint-expansion carrying a concrete decomposition axis + Mathlib anchors. **Satisfied** — my
  effort-breaker directive embedded the full 7-step algebraic axis (localized chart ring, Cramer
  formula, ring-hom verification) with named Mathlib lemmas (`Matrix.nonsing_inv`,
  `IsLocalization.Away.lift`, …). Dispatch proposal SOUND.
- **strategy-critic `iter011`:** FBC SOUND, GF SOUND (every Mathlib prerequisite verified present;
  base-domain-generalizing induction motive confirmed sound, no circularity), QUOT CHALLENGE
  localized to SNAP-S1. Format DRIFTED. Both **resolved this iter** (see ## Decision made).

## Decision made

### 1. Dispatch FBC-A + GF-alg + QUOT-A + GrassmannianCells (4 lanes) this iter
- **Why:** All four gate-clear. FBC/GF GREEN outright; QUOT-A GREEN on the bridge node;
  GrassmannianCells cleared via the fast path after the effort-break. The four files are
  import-independent → genuine parallel progress (standing directive: maximise parallelism).
- **Reversal signal:** any lane producing zero committed edits (esp. GrassmannianCells — a 3rd
  zero-output, now on SMALL targets, would indicate a harness/elaboration wall rather than a math
  blocker, and flips next iter's GrassmannianCells corrective from "decompose" to "diagnose harness").

### 2. GrassmannianCells: fast-path back into prover rotation rather than wait an iter
- **Option chosen:** effort-break `def:gr_transition` → blueprint-clean → scoped re-review → dispatch
  the bottom leaves THIS iter (vs the progress-critic's default "effort-break now, prover next iter").
- **Why:** the fast path is sanctioned precisely to remove the wasted latency iter; the scoped
  re-review returned a fresh GATE-CLEARS verdict on small, concrete leaf targets with verified Mathlib
  anchors, so the gate is genuinely satisfied (not bypassed). The 2-iter zero-output root cause (one
  monolithic `def`) is removed. `affineChart` landed cleanly in iter-007, so the file accepts edits.
- **LOC/risk:** bottom leaves ~80–200 LOC; low risk, high diagnostic value.

### 3. `def:sectionGradedRing` stays BLOCKED — not a QUOT-A target
- The QuotScheme lane targets ONLY the annihilator-predicate path (`qcoh_section_localization_basicOpen`
  → `annihilator`), resolving the progress-critic's "what if the gate doesn't clear SNAP" fragility:
  SNAP-S1/S3 are simply out of scope (no signature; blocked on tensor-powers infra + the S1
  pinning), and the lane has a clear GREEN target regardless.

### 4. Strategy must-fixes resolved in STRATEGY.md
- **SNAP-S1 (CHALLENGE):** pinned the f.g.-graded-module input to the DEFINING graded module
  `M = im(Sᴺ → ⊕ₘΓ(F⊗Lᵐ))` (Noetherian f.g.), with an explicit cohomology-freeness note (sheaf-section
  f.g. would route through `H¹`; pinning to `M` keeps the leg Čech-independent since `Φ_s` depends only
  on `m≫0` and `dim_κ M_m = dim_κ Γ(F⊗Lᵐ)` there). Updated QUOT route + Mathlib gaps (a).
- **Format DRIFTED:** stripped the two `iter-009` per-iter-narrative phrases from the Phases table
  Risks cells; refreshed FBC-A iters-left/LOC (2–3/~120–300 → 1–2/~80–200, post-swap residual is one
  section identity + the affine lemma).

## Lane scoping (Lean ≠ blueprint — all three decompositions are blueprint-only)

Verified by grep against the actual `.lean` files:
- FBC: `base_change_mate_section_identity` absent; `base_change_mate_generator_trace_eq` (the dropped
  orphan) + the old `map_smul'`-bearing `base_change_mate_regroupEquiv` still present. Lane = execute
  the swap in Lean.
- GF: `gf_torsion_annihilator` / `gf_nagata_monic_lastVar` / `gf_mvPolynomial_quotient_finite_monic`
  absent; `gf_torsion_reindex` still an open sorry. Lane = build the 3 sub-lemmas then close the chain.
- QUOT-A: `Scheme.Modules.isLocalizedModule_basicOpen` + `…annihilator` absent (only a comment).
  Lane = build them bottom-up.
The HARD GATE reviews the BLUEPRINT (which has the swap/break) — the prover's job is to make the Lean
match it.

## Subagent skips

(none — all three highly-recommended critics were dispatched: blueprint-reviewer `iter011`,
progress-critic `iter011`, strategy-critic `iter011`. Plus effort-breaker `gr-transition`,
blueprint-clean `gr-cells`, blueprint-reviewer `grcells-rereview` for the fast path.)

## Watch / tripwires for iter-012

- FBC: if `base_change_mate_section_identity` does not close and the sorry count does not drop →
  CHURNING fires with full force on the post-swap route (progress-critic watch condition).
- GF: if fewer than 2 of the 4 effort-broken sub-lemmas close → reassess (chain itself stalling).
- GrassmannianCells: a 3rd zero-output (now on small leaves) → diagnose harness/elaboration wall,
  not further decomposition.
- QUOT-A: first prover data point; UNCLEAR until it lands the bridge lemma.
