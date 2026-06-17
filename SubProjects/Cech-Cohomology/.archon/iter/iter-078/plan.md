# iter-078 plan — producer DONE; consumer signature-thread the ONLY residual; 1 lane

## Situation
- Prior incarnation of this session already executed the iter-078 subagent wave. Reconciled ground truth:
  **producer `CechTermAcyclic.lean` = DONE** (0 real sorries, green-verified; auditor's iter-077
  "2 of_iso direction bugs" were FALSE POSITIVES per strategy-critic `capstone-iter078`). **Consumer
  `CechToHigherDirectImage.lean` = full assembly written, 0 `sorry`, but does NOT compile**: line-207
  call to `cechTerm_pushforward_acyclic` is ill-typed vs the producer's correct sig (now `[S.IsSeparated]`
  + `hres`). Project real sorries: only the frozen `CechHigherDirectImage:780` (user-owned).
- Verified producer sig first-hand: `CechTermAcyclic.lean:699–705` carries `[X.IsSeparated][S.IsSeparated]`
  + `hres : ∀ σ:Fin(p+1)→𝒰.I₀, HasInjectiveResolutions (coverInterOpen 𝒰 σ).toScheme.Modules`.

## Actions this phase
- Addressed strategy-critic `capstone-iter078` CHALLENGE (must-fix): (a) `[X.IsSeparated]` REDUNDANT given
  `[IsSeparated f]`+`[S.IsSeparated]` → consumer instructed to DROP it + derive internally (recipe with
  [verified] constituents `Scheme.isSeparated_iff`, `.isSeparated_terminal_from`, `terminal.hom_ext`);
  (b) scope = `X`-separated specialization of 02KE (not unconditional) — both now stated in STRATEGY §P5b,
  removing the false "each forced" claim. Format must-fix: STRATEGY.md trimmed 20KB→8.5KB (done-route
  subsections → tombstones; 1-line table cells; producer row moved to `## Completed`).
- PROGRESS.md: ONE lane (`CechToHigherDirectImage.lean`), `prove` mode, exact 4-step edit recipe + verify.
- task_pending/task_done updated; TO_USER unchanged (frozen-decl notice still true).

## Decision made
- **ONE consumer lane, `prove` mode.** Producer is frozen-done (not dispatchable); the residual is pure
  signature threading + one internal `haveI` — all math is written. No parallelism (the iter-077
  mis-convergence was producer/consumer concurrency mid-sig-change; single lane is the applied lesson).
  Trade-off: none real — there is exactly one file with work. Reversal signal: if the `[X.IsSeparated]`
  derivation won't compile, fall back to keeping it in the sig (sanctioned alternative; challenge stays
  addressed via STRATEGY prose). Either way add `[S.IsSeparated]`+`hres` (mathematically required).
- **No prover at CHDI:780** — unprovable as signed; a prover would thrash the protected frozen sorry.

## Prior critique status
- strategy-critic `capstone-iter078` CHALLENGE: **ADDRESSED** — redundancy (drop+derive `[X.IsSeparated]`),
  scope (X-sep specialization stated), format (STRATEGY trimmed). Recorded in STRATEGY §P5b + PROGRESS.

## Subagent skips
- strategy-critic: already dispatched THIS iter (`capstone-iter078`) by the prior incarnation; CHALLENGE
  addressed above (not silently overridden). Re-dispatch would re-bless an already-audited, now-corrected
  strategy — hollow.
- progress-critic: already dispatched THIS iter (`capstone-iter078`) = CONVERGING, dispatch=OK, 0 must-fix.
  No new prover trajectory since.
- blueprint-reviewer: already dispatched THIS iter (`gate078`) = HARD GATE CLEARED for the consumer file,
  0 must-fix; chapter unchanged since (writer+clean ran before it). Skip per fast-path: gate is current.
- blueprint-writer/clean: already ran THIS iter (`capstone-fix`/`iter078`); chapter now complete+correct.
