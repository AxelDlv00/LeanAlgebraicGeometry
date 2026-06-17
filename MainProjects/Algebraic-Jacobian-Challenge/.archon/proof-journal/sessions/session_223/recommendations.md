# Recommendations — for the iter-224 plan agent

## TOP PRIORITY — the reversal tripwire is TRIPPED: escalate, do NOT re-dispatch the same approach

The iter-223 planner pre-committed a reversal signal: *"iter-223 returns with the whnf bomb STILL
present and none of routes #2/#1/#3 closing the sorry → iter-224 runs the mathlib-analogist consult
BEFORE any further dispatch."* That is exactly the iter-223 outcome (sorry 81→81, all three routes
bomb). **Honour it.**

1. **Run a `mathlib-analogist` consult in `cross-domain-inspiration` mode FIRST, before any prover
   dispatch.** Frame the structural problem precisely:
   - *Structural problem:* discharge the naturality square of a `PresheafOfModules.Hom` whose
     **codomain is the monoidal unit `𝟙_`**, without `kabstract`/`isDefEq` ever forcing a `whnf` of
     `PresheafOfModules.Monoidal.tensorUnit`.
   - *Failed approaches:* `rw`/`erw`/`simp` (all `kabstract` the unit → `whnf` bomb); `rfl`-show to
     `PresheafOfModules.unit`; `local irreducible` on project defs (toxicity is upstream in Mathlib).
   - *Search radius:* `narrow` (same general area — `PresheafOfModules` / `ModuleCat` presheaf API),
     then `wide` if narrow is dry.
   - *Candidate directions to ask it to confirm/refute* (from the prover handoff):
     (a) a `PresheafOfModules.Hom.mk`/`Hom.ext`-style **app-wise builder** whose naturality
     obligation is stated in already-reduced form (no `kabstract` over the unit);
     (b) build the morphism through a **`tensorUnit ≅ unit` iso** (`PresheafOfModules.unit` is the
     `rfl`-equal but `whnf`-cheap form) so the toxic `𝟙_` never appears in the proof goal;
     (c) **reducible-transparency rewriting** — `rw (config := { transparency := .reducible })` or
     `Lean.MVarId.rewrite` at reducible transparency — to stop `kabstract` from `whnf`-ing the unit;
     (d) `conv`-localization to the RHS subterm before rewriting.
2. **Only after the analogist returns a concrete technique**, dispatch one `prove` prover to apply it
   to the recorded six-step reduction (preserved in-source above the `sorry`). The math is done; the
   only missing ingredient is a `whnf`-free assembly technique.
3. **Do NOT** re-dispatch any of the iter-222 routes #1/#2/#3 verbatim, do NOT add a 4th eval helper,
   and do NOT brute-force `maxHeartbeats` (forbidden; cost is exponential, not budget-bound).

## Fallback if the analogist finds no `whnf`-free technique

If no technique exists, the stubbed `internalHomEval` is the project's only sorry NOT closeable on a
known recipe and it sits one notch from the iter-214 anti-pattern. Consider **reverting
`internalHomEval` to ABSENT** (restoring project sorry **81→80**, the iter-219–221 no-stub invariant),
keeping the worked six-step reduction in a comment and re-pinning the blueprint block as
`% NOTE:`-only (target name reserved). `internalHomEval` is NOT load-bearing in the code-graph
(iter-222 auditor: nothing downstream consumes it yet), so reverting it costs no other proof. This
keeps the funded build honest while the eval counit waits on the Mathlib-API gap.

## Sub-step / route accounting (for the progress-critic directive next iter)
- Sub-step 3 (the eval counit) has now spanned **iters 221 → 223 (3 iters)**: 221 = dual built +
  per-object eval, naturality ABSENT; 222 = coherence solved, morphism assembled with stubbed
  naturality (sorry 80→81); 223 = naturality NOT closed, obstacle re-characterized (sorry 81→81).
- The whole funded block is ~6–12 iters (elapsed 5). Sub-steps 4–5 (sheafify → inverse → group law)
  are still ahead and the eval counit is a prerequisite for the sheaf-level eval.
- **This is STUCK on the naturality sub-goal** (no sorry-elimination or structural advance in the
  last iter on this target; the counter has not moved down across the whole sub-step). The corrective
  is the analogist consult above (a structural / API-shape change), NOT another same-shape prover
  round. If the analogist consult also dead-ends, that is the signal to take the fallback revert
  and/or re-examine whether the presheaf-level `𝟙_`-codomain construction needs reshaping.

## Reusable patterns / KB
- **`lean_multi_attempt` gives FALSE POSITIVES on heartbeat-cost obstacles.** It verified each of the
  six worked steps with empty diagnostics, but the full `lake env lean` compile bombs — `multi_attempt`
  does not reproduce full-elaboration heartbeat accounting. Trust `lake` exit codes for `whnf`/timeout
  obstacles. (Added to PROJECT_STATUS Knowledge Base.)
- **Monoidal-unit `𝟙_` codomain ⇒ `kabstract` `whnf` bomb.** A goal whose codomain is the
  `PresheafOfModules` monoidal unit, saturated with `dual M = internalHom M 𝟙_`, makes `rw`/`erw`/`simp`
  bomb on the first rewrite (the unit's `whnf` normal form is ~exponential). `local irreducible` on
  project defs does not help — the toxic term is Mathlib's. (Added to KB.)

## Subagent findings (this iter) — both 0 must-fix

- **lean-auditor ts223** (`logs/iter-223/lean-auditor-ts223-report.md`) — 1 file, 5 issues
  (3 major / 2 minor / **0 must-fix**). **Both focus areas PASS:** no over-optimistic language
  ("sorry 4→3", "RETIRED") survived the prover's revert; the file-header sorry count (4) is accurate
  (bodies at L644, L1498, L1930, L1974). Majors (all MEDIUM — stale-docstring cleanup, fold into a
  future polish ride-along, not blocking):
  (1) L1644 `tensorObj_assoc_iso` docstring still says "iter-212 status (typed `sorry`)" though the
  body has been complete since iter-212 (sorry-transitive only via `isLocallyInjective_whiskerLeft_of_W`);
  (2) L1937 `tensorObjOnProduct` docstring claims "typed `sorry`" but the body is a complete non-sorry def;
  (3) L1926–1927 `exists_tensorObj_inverse` comment says "no internal-hom on `PresheafOfModules`" — now
  false (the file defines `InternalHom.internalHom` + `dual`); should read "no *SheafOfModules*-level".
- **lean-vs-blueprint-checker ts223** (`logs/iter-223/lean-vs-blueprint-checker-ts223-report.md`) —
  27 blocks, 5 major / 3 minor / **0 must-fix**. **`internalHomEval` PASSES:** statement `\leanok`
  present (decl exists w/ naturality sorry), proof `\leanok` correctly absent, `% NOTE:` acknowledges
  the per-object/assembly split, `\lean{...}` pin correct, statement faithful — no overclaim.
  Majors (MEDIUM, mostly the known vestigial-apparatus / `sync_leanok` multi-pin gap — standing
  deferral, non-blocking):
  (1–3) three blocks (`lem:presheaf_pushforward_adj_substrate`, `lem:restrictscalars_ringiso_strongmonoidal`,
  `lem:tensorobj_unit_iso`) lack `\leanok` despite axiom-clean decls — a `sync_leanok` multi-declaration
  `\lean{...}`-block parse gap (recorded as standing deferral since iter-221/222; pending the dedicated
  polish pass);
  (4) `PresheafOfModules.internalHomEvalApp` (the completed per-object building block) has no dedicated
  `\lean{...}` pin — a plan-agent blueprint-writer micro-task if desired;
  (5) stale file-header docstring lists the removed `monoidalCategory` instance as decl #3 (overlaps
  lean-auditor's stale-docstring theme).

**Action for the plan agent:** none of the 8 majors block the iter-224 escalation. Bundle the
stale-docstring fixes (auditor 1–3, checker 5) + the missing pins (checker 4) into the future polish
pass already deferred for the `Sheaf.val` deprecation migration — do NOT destabilize the lane mid-build
to chase them. The `sync_leanok` multi-pin gap (checker 1–3) is a tooling issue, not a content issue.
