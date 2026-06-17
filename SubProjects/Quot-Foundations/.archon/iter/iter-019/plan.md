# Iter 019 — Plan (Quot-Foundations)

## TL;DR

A **blueprint-round-then-dispatch** iter executing two STUCK correctives. Entry: iter-018's three
lanes left FBC step-(iii) unmoved for a 5th iter ("literal-form lock"), GF L4 PARTIAL (foundation
F1–F6 landed, single isolated assembly residue), and QUOT +20 axiom-clean foundation decls with the
induction body still unwritten. The progress-critic returned **FBC STUCK**, **QUOT STUCK**, **GF
CONVERGING**. I ran the critic's named correctives as a blueprint round BEFORE any prover: an
**effort-breaker** split FBC's step-(iii) crux into a 5-link atomic sub-lemma chain (the
"decompose, don't re-attempt" corrective); a **blueprint-writer** expanded GF L4 Step-3 (resolving the
iter-018 lean-vs-blueprint MUST-FIX); a **blueprint-writer** cleared QUOT's 20-node coverage debt
(leandag 21→1) + fixed M2/M3/M4. Then **blueprint-clean** + a same-iter fast-path **blueprint-reviewer**
re-cleared the HARD GATE for all three chapters (complete+correct, 0 must-fix). Dispatched all three
lanes with the correctives baked into the directives: FBC fine-grained on the 5 atomic pieces
(whole-goal attempts prohibited), GF prove-and-close L4, QUOT **top-down** induction body first (do not
add more foundation; success bar = `gradedModule_hilbertSeries_rational`).

## State at entry (iter-018 outcomes, verified)

- **FBC 4→4** — `base_change_mate_fstar_reindex` sorry-free (reduces to `…_legs`); step-(iii) sorry in
  `…_legs` UNMOVED (5th iter, 014–018). iter-018 added only a comment + one `rw [he,hinclA] at key`
  scaffolding line; documented the literal-form lock + a 5-step ~150-LOC telescoping recipe. Seam 3 /
  affine / FBC-B untouched (gated).
- **GF 3→3** — L4 `exists_localizationAway_finite_mvPolynomial` PARTIAL: F1–F6 foundation landed, single
  honest assembly `sorry` (injectivity + finiteness coupled through witness g). `genericFlatnessAlgebraic`,
  `genericFlatness` untouched (gated on L4).
- **QUOT 4→4 (+20 axiom-clean)** — Route-2 foundation complete (poly-module + datum + ker/coker calculus
  + base-case finiteness); no isDefEq pathology fired. Induction body not started. 4 protected stubs
  unchanged.
- Build: all 3 modules GREEN (iter-018 prover + lean-auditor). No Lean changes iter-019 (blueprint-only).

## Subagents dispatched (6; all returned)

- **progress-critic `iter019`** — FBC **STUCK** (sorry flat 4 iters + step-iii unmoved 5 iters + helpers
  w/o closure; corrective = structural decomposition, whole-goal prohibited), QUOT **STUCK** (36
  axiom-clean helpers/3 iters, 0 keystone closures; corrective = top-down induction skeleton first), GF
  **CONVERGING** (−2 sorries/K=4, no recurring blocker). FBC/GF OVER_BUDGET (administrative). Dispatch
  sanity OK (3 files).
- **effort-breaker `fbc-step3`** — COMPLETE. Split `lem:base_change_mate_fstar_reindex_legs` step-(iii)
  into 5 `\uses`-linked atomic lemmas (`_unitExpand`/`_gammaDistribute`/`_eCancel`/`_affineUnit`/
  `_innerMatch`), `_eCancel` load-bearing (3 cancellation pairs, re-break candidate if it resists). 0
  broken `\uses`. New `\lean{}` names listed for the fine-grained prover.
- **blueprint-writer `gf-l4step3`** — COMPLETE. Expanded L4 Step 3 into 3a (comparison map ν), 3b
  (injectivity via algebraic-independence descent K→A_g), 3c (module-finiteness via integral-dependence
  pushforward). Resolves the iter-018 MUST-FIX. 0 new broken `\uses`.
- **blueprint-writer `quot-coverage`** — COMPLETE. 18 new bespoke helper blocks + 2 multi-pins; M2 prose
  (N/N' finiteness), M3 (dropped broken `subquotient_ker_coker` pin + wired 8 components), M4
  (`SubquotientDatum`/`.hilb` pins), M1 (`% NOTE` on private IsRatHilb). leandag `lean_aux`/isolated
  21→1. **Mechanism note: leandag reads only statement-level `\uses{}`, not proof-level** — folded into
  guidance.
- **blueprint-clean `iter019`** — COMPLETE. Stripped "Archon-original"/`iter-NNN` history labels from all
  3 chapters; de-Leaned 2 QUOT `% NOTE`s; SOURCE QUOTE blocks intact; markers untouched.
- **blueprint-reviewer `iter019` (fast path)** — all 3 chapters **complete+correct, GATE OPEN, 0
  must-fix**. FBC chain adequate (`_eCancel` no finer break needed); GF L4 must-fix resolved; QUOT
  helpers correct. Non-blocking: FINDING-Q1 (minor missing `\uses` edge), FINDING-G1 (GR-cells `\leanok`
  gap — address before QUOT-repr), FINDING-R1 (RelativeSpec, deferred). Unstarted-phase proposals:
  FBC-B, GF-geo, SNAP-S1/S3, QUOT-repr (deferral rationale below).

## Decision made

### 1. FBC STUCK → effort-break + fine-grained (decomposition-first), not another whole-goal prove
The critic's primary corrective is **Refactor: decompose the lemma into independently-provable atomic
sub-lemmas; whole-goal attempts prohibited.** Executed exactly: the effort-breaker wrote the 5-link
blueprint chain; the prover lane is fine-grained on those 5 pieces with an explicit prohibition on
re-attempting the whole goal. The literal-form lock (legs `subst`'d inside the single lemma) is
dissolved by proving each piece as a standalone decl where the legs are not opaque. Reversal signal: if
`_eCancel` resists even isolated, re-break it one-lemma-per-cancellation-pair (already scoped) — NOT a
verbatim re-dispatch.

### 2. QUOT STUCK → top-down induction body, mode `prove` (skeleton with sorries allowed), not mathlib-build
The critic's corrective is **change the working strategy from bottom-up infrastructure assembly to
top-down induction-body drafting** — write the skeleton first, connecting the chain, intermediate
sorries permitted. I switched the QUOT lane from `mathlib-build` (whose "no-sorry + stop-when-blocked"
invariant is precisely what produced 3 iters of foundation-without-assembly) to `prove`, with a
directive mandating the assembly order (ker/coker constructors → `subquotient_finite_transfer` →
induction → `(⊤,⊥)` bridge) and forbidding new foundation. New sorries here are the induction
scaffolding that has been missing, not regression. Trade-off: QUOT's sorry count may rise from 4
(protected) by a few — accepted as the price of breaking the STUCK pattern; the alternative
(mathlib-build leaving no committed partial skeleton if blocked mid-assembly) loses the top-down
structure the critic explicitly wants committed.

### 3. Rebuttal — the critic's "connect a protected stub" metric is wrong for QUOT's dependency shape
The progress-critic measures QUOT success as "protected-stub closure" and calls 0 closures STUCK. I
**partially rebut**: the 4 protected stubs (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`,
`representable`) sit several phases DOWNSTREAM of the induction body — `hilbertPolynomial` is gated on
SNAP-S1 (Serre correspondence) + S3 (extraction), which themselves consume
`gradedModule_hilbertSeries_rational`. Connecting the induction directly to a protected stub this iter
is not possible without the intervening SNAP phases. The genuine QUOT progress metric is closing the
keystone `gradedModule_hilbertSeries_rational` (SNAP-S2). I ACCEPT the underlying corrective (write the
induction body top-down — that is exactly what was missing) and reject only the literal stub-connection
acceptance test, substituting the keystone as the success bar. Recorded so the next planner does not
chase a protected-stub closure that the dependency graph forbids.

## Subagent skips

- **strategy-critic**: no route/decomposition change this iter — the FBC effort-break and the QUOT
  top-down pivot are tactical correctives WITHIN the existing ACTIVE routes (FBC-A, QUOT Route-2), not
  route swaps or phase reorders; the only STRATEGY edits were FBC-A / GF-alg estimate-cell refreshes
  (progress-critic OVER_BUDGET). Last strategy-critic verdict (iter-016) was SOUND with no live
  CHALLENGE/REJECT. (Judgment call: STRATEGY SHA changed via the two estimate cells, but nothing
  strategic is open to re-evaluate; dispatching would be a hollow template-fill.)

## Unstarted-phase proposal dispositions (from blueprint-reviewer)

- **FBC-B / GF-geo (Proposals 1–2)** — DEFERRED with rationale: both are NEXT phases whose Lean targets
  already exist as blueprinted sorry-stubs (`flatBaseChange_pushforward_isIso`, `genericFlatness`), gated
  on the ACTIVE phases (FBC-A, GF-alg) closing. Their merge-back signatures depend on how FBC-A/GF-alg
  resolve; expanding their blueprints now is premature. Due the iter their gating phase closes (noted in
  PROGRESS Next-iter ramp).
- **SNAP-S1/S3 (Proposal 3)** — DEFERRED: lower-priority alternative Hilbert-Serre routes; the primary
  SNAP-S2 route (`gradedModule_hilbertSeries_rational`) is the active QUOT work. Revisit after S2 lands.
- **QUOT-repr (Proposal 4)** — DEFERRED: deepest target, gated on FINDING-G1 + FINDING-R1 + SNAP-S2;
  many iters out.

## Disproof / soundness checks

No new hard-or-recurring target was committed without prior soundness: GF L4, FBC step-(iii), and the
QUOT induction are all established in their references (Nitsure §4; the project's own mate calculus over
proved tilde dictionaries; Stacks 00K1) and were SOUND in prior strategy-critic passes. No statement is
suspected false — the FBC/QUOT stalls are mechanical (literal-form lock; bottom-up-vs-top-down working
strategy), not unsound statements.
