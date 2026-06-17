# Iter 012 — Plan (Quot-Foundations)

## TL;DR

**Resumed plan after a mid-plan context reset** (like iter-009). The prior partial run had already
dispatched all 3 highly-recommended critics (strategy-critic, progress-critic, blueprint-reviewer
`iter012`) + 2 blueprint-writers (gr-cocycle for F-4a/F-4b, snap-s2 to decouple the rationality
lemma) and reconciled STRATEGY.md's content CHALLENGES (the `(strategy-critic iter-012)` citations
are its fingerprints). On resume I (1) fixed F-3a (resync the `gf_mvPolynomial_quotient_finite_monic`
`% LEAN SIGNATURE` to the landed `RingHom.Finite` encoding), (2) compressed the two DRIFTED STRATEGY
table Risks cells, and (3) ran a **fast-path blueprint re-review** (`iter012-rereview`) to clear the
gates the two writers had addressed. The re-review returned **PROCEED, 0 must-fix, all 6 chapters
`correct: true`** — and surfaced the iter's decisive finding: **the FBC chapter already carries the 3
decomposed seam lemmas with elaboration-checked signatures, so FBC-A is prover-ready (no
effort-break needed).** Dispatching **4 import-independent prover lanes**: FBC-A [prove], GF [prove]
(CHURNING must-close), SNAP-S2 [mathlib-build], GR-cells [mathlib-build].

## State at entry

- iter-011 = 4-lane prover iter, build GREEN, 0 must-fix across 5 review subagents. Sorry deltas:
  FBC 5→3, GF 5→5 (+3 axiom-clean Nagata sub-lemmas), GR 0→0 (+16 decls), QUOT 4→4 (+5 predicate
  decls). Two multi-iter walls broken (FBC `map_smul'`; GR `gr_transition` monolith).
- Partial iter-012 artifacts already on disk: strategy-critic + progress-critic + blueprint-reviewer
  `iter012` reports; blueprint-writer gr-cocycle + snap-s2 reports; STRATEGY.md content-reconciled.
- Current sorries (verified by grep): FBC section_identity ~1011 + affine ~1142 + flat ~1164 (FBC-B);
  GF gf_torsion_reindex ~949 + L5 ~1034 + L4 ~516 + genericFlatnessAlgebraic ~1101 + genericFlatness
  ~1168 (GF-geo); QUOT 4 skeleton stubs; GR 0.

## Critic dispositions (prior partial run + my re-review)

- **blueprint-reviewer `iter012` (first run):** FlatteningStratification → gf_torsion_reindex PASS;
  GrassmannianCells → gr_cocycle **BLOCKED** (F-4a missing signature); 3 must-fix (F-3a/F-4a/F-4b).
  Did an OVERVIEW pass on the 2250-line FBC chapter — listed section_identity as one sorry node and
  **did not detect the 3 seam lemmas** that already exist deeper in the chapter.
- **blueprint-reviewer `iter012-rereview` (my fast-path):** **PROCEED**, 0 must-fix. Cleared
  F-4a/F-4b (gr-cocycle writer pinned the cocycle signature over the doubly-localised triple-overlap
  rings + removed the orphan anchor), F-5a (snap-s2 writer decoupled the rationality lemma to a clean
  frontier), F-3a (my resync). **Full read of the FBC chapter found the 3 seams** (`unit_value` L1379,
  `fstar_reindex` L1435, `gstar_transpose` L1514) — each with a complete proof sketch + elaboration-
  checked `% LEAN SIGNATURE` + correct `\uses{}`. FBC-A gate PASS.
- **progress-critic `iter012`:** FBC CONVERGING; **GF CHURNING** (raw rule fires: helpers in 2/4
  iters, sorry flat at 5, no structural pivot since the iter-009 effort-break) → corrective = dispatch
  the `gf_torsion_reindex` assembly prover, must-close (the plan already does this; CHURNING makes it
  a hard obligation, not best-effort); GR CONVERGING; QUOT UNCLEAR (warned the 3-iter zero-dispatch
  tolerance is SPENT — iter-013 must have a QUOT prover). Dispatch-sanity OK for the 2-lane plan it saw.
- **strategy-critic `iter012`:** FBC CHALLENGE (reconcile "tower dropped" vs "tower is the residual")
  + QUOT CHALLENGE (name the forward-char consumer) + format DRIFTED — **all addressed**: STRATEGY.md
  already states "tower RELOCATED, not eliminated" with the cheaper-on-merits justification (i/ii) and
  names the consumer (QUOT-repr support check, off critical path); I compressed the DRIFTED cells.

## Decision made

### 1. Dispatch 4 prover lanes (FBC-A + GF + SNAP-S2 + GR-cells), not 2
- **Why:** the fast-path re-review changed the gate premise the progress-critic graded against. At
  its read FBC needed an effort-break and SNAP-S2/cocycle were blocked → 2-lane plan. The re-review
  found FBC seams already authored (prover-ready), SNAP-S2 decoupled to a clean frontier, and the GR
  cocycle gate cleared. All 4 files are import-independent → genuine parallel progress (standing
  directive: maximise parallelism). This is NEW gate information, not a rebuttal of the critic — its
  dispatch-sanity check was correct for the inputs it had.
- **GF is the CHURNING must-close** — lane 2 is the exact corrective the progress-critic named. If
  `gf_torsion_reindex` does not close this iter, iter-013 escalates to a mathlib-analogist consult on
  the localization-module transport (instance-diamond identification). Recorded as a hard obligation.
- **SNAP-S2 honors the QUOT zero-dispatch warning** — the progress-critic flagged QUOT's tolerance as
  spent; SNAP-S2 is now genuinely ready (snap-s2 writer made it a clean frontier), so QUOT gets a real
  prover lane this iter rather than another deferral.
- **Reversal signal:** any lane producing zero committed edits. Specifically: a GR cocycle zero-output
  (3rd consecutive on that file, now on small atoms with a pinned signature) flips next iter's GR
  corrective from "build" to "diagnose harness"; a GF non-close escalates per above.

### 2. No FBC effort-breaker this iter (the seams already exist)
- **Option chosen:** dispatch the FBC-A prover directly on the 3 seam lemmas, vs. the partial run's
  emerging "FBC → effort-breaker" intent.
- **Why:** the re-review's full read confirmed the seams (`unit_value`/`fstar_reindex`/`gstar_transpose`)
  are already authored in the blueprint with elaboration-checked signatures and a `\uses`-linked chain
  down to `section_identity`. Re-running an effort-breaker would re-author work that exists. The iter-011
  review's "FBC needs a writer round first" recommendation was satisfied in an earlier FBC blueprint
  expansion; the first `iter012` reviewer simply missed it on its overview pass.

## Prior critique status

- strategy-critic FBC CHALLENGE — **addressed** (STRATEGY.md "RELOCATED, not eliminated" + justification).
- strategy-critic QUOT CHALLENGE — **addressed** (consumer named: QUOT-repr support check, off path).
- strategy-critic format DRIFTED — **addressed** (compressed the FBC-A + QUOT-defs Risks cells).
- progress-critic GF CHURNING — **addressed** (GF prover lane = the named corrective, must-close).
- blueprint-reviewer F-3a/F-4a/F-4b/F-5a — **all cleared** by the fast-path re-review.

## Subagent skips

- strategy-critic / progress-critic / blueprint-reviewer: NOT skipped — all three were dispatched by
  the prior partial run; I additionally ran a fast-path blueprint re-review (`iter012-rereview`) on
  resume to clear the post-writer gates.
- effort-breaker (FBC): deliberately NOT dispatched — the 3 FBC seam lemmas already exist in the
  blueprint with elaboration-checked signatures (re-review confirmed); an effort-break would duplicate
  existing work.

## Tool substitutions

- None. (No LLM API key in env; no external-source verification was attempted this iter — all
  citations rest on locally-read reference files from prior iters.)
