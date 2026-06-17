# Iter 003 — Plan (Quot-Foundations)

## TL;DR

Pick-up iter: a prior plan turn (before a context reset) had already run the two
effort-breakers (FBC mate crux, GF dévissage), the strategy-critic, and the blueprint-reviewer
— all four reports were on disk but the sidecar/PROGRESS were unwritten. This turn finalized:
processed those reports, dispatched the two QUOT-side blueprint-writers + blueprint-clean the
reviewer's must-fix backlog demanded, wired the cross-chapter graph edges, recorded the
QUOT-writer's Mathlib-gap finding in STRATEGY, and set the two live prover lanes (FBC-A, GF-alg)
to scaffold + prove the freshly-decomposed sub-lemma chains leaves-first. Blueprint-doctor clean;
frontier = 5 ready leaves + 2 reads. No mechanical gate — both lanes dispatch.

## State at entry

- iter-002 (first prover iter) landed the top-level decls and isolated the two hardest sorries:
  FBC `pushforward_base_change_mate_cancelBaseChange` (mate crux) and GF
  `genericFlatnessAlgebraic` (dévissage residue). `base_change_map_affine_local` fully proved.
- The two effort-breakers (prior turn) decomposed those sorries into `\uses`-linked chains now
  in the blueprints (FBC 4-lemma, GF 5-lemma). blueprint-reviewer `iter003` confirmed both
  chapters `complete + correct` and the chains "ready for prover dispatch."
- Live frontier (`archon dag-query frontier`): 7 nodes = FBC {L1 crux, L2 domain-read}, GF {L1
  torsion, L3 shortExact, L4 noether-clear}, all real `\lean{}` pins NOT yet in the Lean files
  (scaffold-and-prove), plus 2 reads. Coverage debt 0, ∞-gaps 0.

## Critic dispositions

- **strategy-critic (`rewrite-verify`, ran prior turn): CHALLENGE on QUOT — ADDRESSED.** The
  challenge was the cohomological-χ Hilbert-polynomial encoding (needs all Hⁱ, breaks the
  Čech-independent leg) vs. the lighter graded `existsUnique_hilbertPoly` route. STRATEGY.md was
  already pivoted to the graded encoding (the critic's own recommended alternative) — the
  challenge is resolved, not pending. FBC + GF verdicts SOUND. No rebuttal needed; no re-dispatch
  (STRATEGY's QUOT route still reflects the adopted graded pivot, refined this turn — see Decision).
- **blueprint-reviewer (`iter003`, ran prior turn):** FBC + GF clear the HARD GATE. Three
  must-fix items, all QUOT-side with NO active provers: (1) SNAP unblueprinted, (2) GR-cells/glue
  unblueprinted, (3) QUOT chapter `partial` (encoding pivot). Acted on all three this turn (see
  Actions). Two "soon" items: FBC `\uses{lem:gammaPushforwardNatIso}` wire-up (fixed by me) + GF
  Step-4 detail (deferred to GF-geo, NEXT phase).

## Actions taken this turn

1. **2 blueprint-writers (parallel, QUOT-side, clears reviewer must-fix #1/#2/#3):**
   - `quot-graded-snap` → rewrote `def:hilbert_polynomial` to the graded encoding + added the
     SNAP `\section` blocks. **Strategy-modifying finding** (see Decision): `existsUnique_hilbertPoly`
     is only the extraction half; the graded Hilbert–Serre rationality step is Mathlib-ABSENT, so
     the writer added project-own `lem:gradedHilbertSerre_rational`. Also corrected directive item
     3 (the `representableBy` "misnaming" was itself wrong — `representableBy` exists and was correct).
   - `gr-cells-glue` → new chapter `Picard_GrassmannianCells.tex` (GR-cells + GR-glue, 6 decls,
     Nitsure §1 verbatim quotes).
2. **blueprint-clean (`quot-gr`)** on both edited chapters — stripped Lean-encoding/history prose;
   GR-cells already clean.
3. **Graph wiring (mine):** `\input` the new chapter into content.tex; `\uses{def:gr_glued_scheme,
   lem:gr_separated, lem:gr_proper}` into `thm:grassmannian_representable`; `\uses{lem:gammaPushforwardNatIso}`
   into `lem:pullback_spec_tilde_iso` (the reviewer "soon" wire-up); added `\AA`/`\llbracket`/`\rrbracket`
   macros (doctor undefined-macro); resolved the double-`covers` (removed it from GR-cells — those
   decls target their own future `GrassmannianCells.lean` via 1:1 slug). blueprint-doctor now CLEAN.
4. **STRATEGY.md:** refined the QUOT graded-encoding route + SNAP row + Mathlib-gaps bullet to the
   honest two-piece costing (Mathlib extraction + project rationality lemma).
5. **2 prover lanes** (FBC-A, GF-alg) written to PROGRESS, default `prove`, chain scaffold + leaves-first.

## Decision made — graded Hilbert-polynomial encoding depends on a Mathlib-absent rationality lemma

- **Option chosen:** keep the graded encoding (already the adopted route), but record that
  polynomiality is NOT a single Mathlib citation: (a) Mathlib `existsUnique_hilbertPoly` does only
  the rational-series→polynomial extraction; (b) the graded Hilbert–Serre rationality (`dim_κ Mₙ`
  → `p·(1-X)^{-d}` for a f.g. graded module over a Noetherian graded ring) is absent from Mathlib
  and is now the project lemma `lem:gradedHilbertSerre_rational`.
- **Why:** verified directly against `Mathlib/RingTheory/Polynomial/HilbertPoly.lean` by the
  writer (grep for hilbert-series over pinned Mathlib: no hits). The rationality lemma is classical
  and inductive (degree-1 generators), still H⁰-only ⟹ the Čech-independent identity holds.
- **Trade-off:** SNAP grows from "apply a Mathlib lemma" to "+1 project lemma"; re-costed
  ~150–350 → ~180–400 LOC. Far cheaper than the rejected χ route (from-scratch higher coherent
  cohomology). No effect on the live FBC/GF frontier.
- **Cheapest reversal signal:** a Mathlib search pass turning up graded-module length-additivity /
  Hilbert-series infra that subsumes (b). Worth a `mathlib-analogist`/search pass before any SNAP
  prover dispatch — but SNAP is many iters out (gated behind QUOT-defs behind FBC/GF).

## Decision made — do NOT split the chain files this iter (standing file-split directive)

- **Standing directive** favors parallelism via file splitting. I keep 2 lanes (FBC, GF) on the
  existing files this iter rather than splitting the chains into per-leaf files.
- **Why:** (1) the chains are brand-new effort-breaker output — no prover has touched the stubs,
  so I lack the signal to split along the right seams; (2) a `prove` lane scaffolds + proves
  leaves-first with warm file context and can clear several small independent leaves in one session
  (FBC L1/L2, GF L1/L3/L4 are the tractable frontier); (3) the chains are intrinsically serial at
  the top (cores L5/L4 depend on leaves), so splitting bounds parallelism anyway while adding a
  blocking refactor that delays ALL prover work by an iter; (4) the directive's intent is
  throughput — best served here by getting provers onto the fresh decomposition NOW.
- **Reversal signal (next iter):** if a single lane cannot clear its independent leaves in one
  session, split — GF `GenericFreeness` chain → `GenericFreeness.lean` (parent assembled in the
  original file importing it). Recorded in PROGRESS `## Next-iter ramp`.

## Subagent skips

- progress-critic: only ONE iter of prover trajectory exists (iter-002 was the first prover iter;
  iter-001 was plan-only), AND both routes were just structurally re-decomposed by the two
  effort-breakers this iter — i.e. the corrective progress-critic would recommend for an
  over-large monolith (decompose) is precisely what was already executed. No K-iter churn pattern
  to detect yet; verdict would be UNCLEAR. Re-dispatch next iter once the chains have a trajectory.
- strategy-critic: ran this iter (`rewrite-verify`); its sole CHALLENGE (QUOT χ-encoding) is
  ADDRESSED by the graded-encoding pivot already in STRATEGY.md (the critic's own recommended
  alternative). No live challenge remains; STRATEGY's QUOT edits this turn only refine the adopted
  route (two-piece costing), they do not re-open the decision.
- blueprint-reviewer: ran this iter (`iter003`); FBC + GF cleared the gate, the three must-fix
  items (all QUOT-side, no active provers) were acted on via the two writers + clean this turn.
  No re-review needed — QUOT has no provers this iter, so the gate does not block anything; next
  iter's mandatory dispatch re-confirms the rewritten QUOT/GR chapters.
