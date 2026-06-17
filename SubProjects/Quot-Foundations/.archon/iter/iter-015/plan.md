# Iter 015 — Plan (Quot-Foundations)

## TL;DR

**Resumed after a mid-plan context reset** (like iter-009/012). The prior partial run had prepared the
3 critic directives and dispatched the blueprint-reviewer (slug `iter015`) — but that reviewer was
interrupted *before persisting its report* (its 683 KB transcript survives; the report file does not).
On resume I (1) recovered the lost reviewer's favorable per-chapter read from its transcript but did
NOT cite it as a gate (no persisted verdict = no fabricated verification); (2) cleared the **coverage
debt** (5 unmatched GF helpers) via a blueprint-writer + blueprint-clean round; (3) dispatched the
two remaining critics + a FRESH full blueprint-reviewer (slug `iter015b`) for a clean persisted gate;
(4) addressed both strategy-critic CHALLENGEs in STRATEGY.md. Outcome: both iter-014 must-close targets
landed axiom-clean, all 3 hard gates OPEN, and **3 import-independent prover lanes** dispatched (FBC
Seam 2 cascade [prove]; GF L5 assembly [prove]; QUOT graded-API [mathlib-build], the unconditional
commitment + progress-critic STUCK corrective).

## State at entry

- iter-014 = 2-lane hard-must-close prover iter; BOTH landed: FBC Seam 1 `base_change_mate_unit_value`
  + GF `gf_torsion_reindex`, axiom-clean. Sorries: FBC 5→4, GF 5→4, QUOT 4, GR 0.
- Active sorries (verified by grep this iter): FBC 1170/1215/1388/1410 (Seam2/Seam3/affine/FBC-B);
  GF 516/1337/1404/1471 (L4/L5/genFlatAlg/genFlat); QUOT 126/165/201/228 (4 downstream stubs); GR 0.
- Partial iter-015 artifacts on disk from the reset: 3 critic directives + the interrupted
  blueprint-reviewer `iter015` transcript (no persisted report).

## Subagents dispatched (6; all returned)

- **blueprint-writer `gf-helpers`** (write GF chapter) — expanded `lem:gf_torsion_reindex`'s
  "Localisation transport" sub-step (the two-localisation `MC` vs `powers g` strategy, `ebar` via
  `ringEquivOfRingEquiv`, the OreLocalization action-diamond, `extendScalarsOfIsLocalization`) + added
  3 helper blocks / 5 `\lean{}` pins (`lem:gf_pullback_module_transport`,
  `…_finite_of_quotient_ringequiv`, `…_islocalizedmodule_restrictscalars`). leandag `lean_aux_nodes: 0`.
- **blueprint-clean `gf`** — 7 purity fixes (Lean-name leakage moved to comments), all markers + SOURCE
  quotes preserved.
- **progress-critic `iter015`** — FBC CONVERGING, GF CONVERGING, QUOT **STUCK** (helper-without-sorry-
  elimination, K=3 SNAP-S2; root cause architectural = downstream stubs wait on G1–G5, NOT proof-search
  failure). Must-fix: the QUOT G1→G5 lane must execute without displacement. dispatch-sanity OK (3/10).
- **strategy-critic `iter015`** — GF SOUND; FBC + QUOT CHALLENGE (see Decisions). Format DRIFTED.
- **blueprint-reviewer `iter015b`** (fresh full pass) — **all 3 hard gates OPEN** (`complete: true,
  correct: true`), 0 must-fix; leandag clean (0 isolated, 40 unmatched all triaged); one soon-severity
  (`thm:grassmannian_representable` weakened pin, 6–12 iters out); 3 unstarted-phase proposals
  (SNAP-S1/S3, FBC-B H⁰-equalizer, QUOT-repr tautological-quotient + Plücker).

## Decision made

### 1. Re-dispatch the blueprint-reviewer fresh rather than cite the lost transcript
- **Why:** the prior reviewer (`iter015`) did a full favorable analysis but was interrupted before
  writing its report. The HARD GATE needs a *persisted* complete+correct verdict; citing a verdict
  recovered from a transcript would be a synthesized verification (anti-fabrication rule). Re-ran it as
  `iter015b` (12.5 min) — and it ALSO validated the new GF helper blocks the writer added this iter,
  which the lost run never saw. Clean gate for all 3 lanes.

### 2. FBC CHALLENGE — resolved the open question NOW (canonical-map seed)
- strategy-critic: the FBC "∃-iso escape / merge-back necessity" should not be deferred behind a stall
  gate — the seed is already `IsIso (canonical map)`. **Verified** in Lean: `affineBaseChange_pushforward_iso`
  (line 1357) `: IsIso (pushforwardBaseChangeMap …)`. Since `archon-protected.yaml` is empty and the
  goal requires names/signatures to match the parent for merge-back, that signature IS the merge-back
  signature ⟹ the mate computation (Seams 2–3) is unavoidable. **STRATEGY.md updated:** the FBC open
  question is RESOLVED (seams proceed; ∃-iso escape rejected — it would re-sign the frozen seed).
- Note: the strategy-critic quoted several STRATEGY.md phrases that are NOT in the file ("Decision
  (iter-014): STRENGTHEN route", "∃-iso escape … revisit if stall ≥2 iters", "no H¹ re-enters",
  "dim M_m = dim Γ"). Those appear to be confabulated/conflated specifics — verified by grep, they are
  absent from the current STRATEGY.md. I acted on the *underlying valid concerns* (which map to real
  artifacts: the line-1357 seed signature, and the QUOT chapter's χ-via-Serre-vanishing remark), not
  the exact quotes.

### 3. QUOT CHALLENGE — reconciled the encoding; χ-equality is a non-load-bearing remark
- **Verified** the `hilbertPolynomial` Lean stub docstring (QuotScheme.lean lines 107–122): it DOES
  document cohomological χ (`Σ_i (-1)^i dim H^i`) with a stale parent "iter-177+" comment — the
  strategy-critic's concern #1 is real. The QUOT chapter (Picard_QuotScheme.tex) defines Φ via the
  graded Hilbert function `dim Γ(F⊗L^m)` (line 110) and *remarks* it equals χ for m≫0 by Serre
  vanishing (lines 122–128). **STRATEGY.md updated:** added an open question — the graded route fills
  the SAME `S → Polynomial ℚ` stub; the stale χ docstring is to be updated when the QUOT-defs lane
  re-signs the stub; the χ-equality is explicitly a non-load-bearing remark (no closure sorry uses it),
  so the leg stays Čech-free and merge-back is signature-safe. This is NOT a this-iter blocker (the
  QUOT lane builds `GradedModule.*`, not the stub).

### 4. QUOT lane goes into QuotScheme.lean (not a new file) this iter — file-split deferred
- The standing user directive prefers file-splitting for parallelism. But the graded-API decls don't
  exist yet (the prover CREATES them), the power-series engine they extend already lives in
  QuotScheme.lean, and the progress-critic requires the QUOT lane to execute without displacement.
  Splitting now = a refactor detour (new file + import wiring + removing decls from the stub file,
  risking the build) that could jeopardize the unconditional commitment. **Decision:** build into
  QuotScheme.lean this iter; queue a refactor to split the graded Hilbert–Serre content into
  `GradedHilbertSerre.lean` once G1–G5 land (recorded in task_pending + PROGRESS next-iter ramp).
  Cheapest reversal signal: if QuotScheme.lean compile times balloon, split sooner.

## Rebuttals to critic findings

- progress-critic QUOT **STUCK** — NOT rebutted; I agree and act on it exactly: the corrective IS the
  graded-API lane, dispatched this iter as the unconditional commitment (lane 3), undisplaced.
- strategy-critic confabulated-quote specifics (see Decision 2) — the exact phrases are absent from
  STRATEGY.md; I addressed the genuine underlying concerns rather than the literal (non-existent)
  quotes. Recorded so the next planner doesn't hunt for phantom text.

## Why 3 lanes (dispatch load)

FBC (CONVERGING, Seam 2 ready, recipe in hand), GF (CONVERGING, chapter expanded this iter, L5 recipe
ready), QUOT (STUCK-corrective, gate open, must run). All import-independent, distinct files, within
the cap of 10. progress-critic dispatch-sanity = OK. No deep lane is overloaded (each lane has one
deep target + mechanical cascade/continuation).
