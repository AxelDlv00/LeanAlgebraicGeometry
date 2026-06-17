# Iter 081 — Plan (Quot-Foundations)

## TL;DR
3 real prover lanes, all backed by landed sorry stubs: GR-quot endgame
(`tautologicalQuotient_epi`, last sorry, unblocked), SNAP-S0 graded assembly (9 scaffolded
stubs), FBC-B capstone (`baseChangeGammaPullbackEquiv`, stub landed from an analogist-VERIFIED
signature — kills the iter-080 noop). Strategy-critic's H⁰-vs-χ challenge VERIFIED against the
parent and resolved.

## Resumed partial run
A prior partial plan turn already dispatched the 3 mandatory critics + lean-scaffolder-snap
(landed 9 SNAP stubs) + lean-scaffolder-fbcb (CRASHED — no report, file stayed 0-sorry: died on
the hard `Γ(X',F')` signature, same failure mode as the iter-079 SNAP scaffolder). I resumed from
there.

## Decision made — FBC-B unblocked THIS iter (not deferred)
- Blocker: the FBC-B capstone `baseChangeGammaPullbackEquiv` was unstateable — `Γ(X',F')` is a
  `groundRing X'`-module, not a `B`-module. Re-dispatching the scaffolder verbatim = forbidden churn.
- Corrective (proven on SNAP iter-079→080): dispatched `mathlib-analogist fbcb-sig` (api-alignment).
  It resolved the crux — view RHS via `ModuleCat.restrictScalars` along `pullbackGroundRingAlg B : B →
  groundRing X'` (do NOT chase `groundRing X' = B`, that's the theorem at `F=O_X`) — and VERIFIED the
  full def header elaborates with a sorry body (`lean_run_code`).
- Because the sig was verified, re-dispatched the scaffolder (`fbcb2`) with the drop-in header → stub
  landed, file builds clean (1 sorry). FBC-B is a real lane this iter, no noop.
- LOC/risk: capstone proof ~80–150 LOC, low risk (all inputs DONE, sig verified). Reverses only if the
  per-chart 01I9 fork assembly hits an unforeseen wall — then decompose the assembly, mate route stays
  abandoned regardless. Design persisted: `analogies/fbcb-pullback-equiv-sig.md`.
- The reduction lemma `flatBaseChange_isIso_iff_gammaTensorComparison` left as TODO (its sig needs a
  second analogist pass reconciling the abstract-square vs direct-`B` parametrization) — queued.

## Decision made — QUOT re-scope (strategy-critic H⁰-vs-χ CHALLENGE, VERIFIED)
- Queried the parent: `def:hilbert_polynomial` = `Scheme.hilbertPolynomial` is **χ-semantic**
  (`Φ(m)=χ(F(m))=Σᵢ(-1)ⁱ dim Hⁱ`; Lean docstring confirms graded-Euler-char). The critic was right: an
  H⁰ encoding under that label silently changes the theorem.
- Decision: this i=0 / Čech-independent leg does NOT close `def:hilbert_polynomial`/`def:quot_functor`
  (χ → sibling cohomology leg). It keeps the χ-independent QUOT core (`grassmannian_scheme`/representability
  via rank-d locally-free quotients; the Hilbert condition is constant rank, χ-free). SNAP-S0 `Γ_*(X,L)`
  still needed (Plücker coordinate ring), χ-independent. STRATEGY Goal + Q1 + phase rows updated; memory
  bullet added. No active lane affected.

## Critic responses
- **strategy-critic (2 CHALLENGEs):** (1) H⁰-vs-χ — ADOPTED, verified+resolved above. (2) RelativeSpec
  parallelism — ADOPTED: pulled into its own NEXT phase row, gated on Q4 retrieval, independent of
  GR-quot/SNAP. Format DRIFTED — trimmed the Routes preamble, per-iter prose (iter-044/055/064/078/079
  refs), and long Risks cells. Rebuttal on one item: the critic's quoted stale preamble ("FBC-A … live
  frontier. FBC-B follows FBC-A") and "FBC-A occupies a full active row" are NOT in the current
  STRATEGY.md (it read a stale copy); trimmed regardless.
- **progress-critic:** GR-quot CONVERGING (proceed). FBC-B + SNAP UNCLEAR with mandatory-dispatch-this-iter
  — BOTH satisfied (both have landed stubs + a prover lane), so neither tips to CHURNING.
- **blueprint-reviewer:** all 9 chapters complete+correct; 3 active lanes GATE CLEAR. Acted on its 2 minor
  DAG wire-ups (added `gr_exists_isUnit_submatrix` / `isLocalizedModule_powers_restrictScalars` to the
  statement-level `\uses{}`). Its 4 unstarted-phase proposals (FBC named-leg discharge, mate cleanup,
  RelativeSpec upgrade, SNAP-S1 unblock) are queued/tracked, not dropped.

## Subagent skips
- (none mandatory skipped — blueprint-reviewer, progress-critic, strategy-critic all dispatched this iter
  by the resumed partial run.)
