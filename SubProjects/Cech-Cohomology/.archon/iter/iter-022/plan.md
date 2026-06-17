# Iter-022 plan — fix the noop trap, execute both correctives (analogist-armed), dispatch 2 lanes

## Entering state (verified)
iter-021 ran only CechAcyclic (+5 axiom-clean decls = the *abstract* homology bridge c1–c3; blocked on
the tilde F-bridge). **FreePresheafComplex was NOOP-DROPPED for the SECOND consecutive iter** (scaffold
keyword on the line after the `.lean` path → plan-validate dropped it), so the iter-021 CHURNING corrective
never ran. Project sorry = 2 (superseded relative-form `CechAcyclic.affine` ~line 110; frozen P5b
`CechHigherDirectImage.lean:679`). lean-auditor `iter021`: 0 must-fix, 1 major (module-doc overstatement),
2 minor. lean-vs-blueprint-checker: 0 must-fix, chapter adequacy major (coface match not decomposed).

## What I did this iter (plan phase)
1. Processed iter-021 results (task_done/task_pending updated; CechAcyclic + lean-auditor + lvb consumed).
2. **progress-critic `iter022`** (first): Route 1 CONVERGING (HIGH-WATCH — last iter before OVER_BUDGET,
   close c-concrete + d); Route 2 **CHURNING** (must-fix corrective = mathlib-analogist BEFORE prover, then
   dispatch on the never-attempted `cechFreeEvalEngineIso` with the noop bug fixed).
3. **mathlib-analogist `tilde-bridge`** (api-alignment, Route 1 blocker): **HEADLINE — the blocker is
   `rfl`**. Accessors (1) `toPresheafOfModules`-Ab and (2) `modulesSpecToSheaf`/`tilde.toOpen` are
   definitionally equal (carrier + additive structure + restriction maps); φ_σ is a one-line
   `IsLocalizedModule.iso`. Keep the Ab complex (do NOT rebuild on ModuleCat). 3 `lean_run_code` checks
   confirm. → `analogies/tilde-section-bridge.md`.
4. **blueprint-writer `cofacematch`**: decomposed `lem:section_cech_coface_match` into abstract
   (`lem:section_cech_objd_apply`) + tilde-bridge layers, recast `lem:section_cech_ab_exact` to
   precursor+ladder form, cleared coverage debt 5→0 (verified `unmatched`=0). (Ran concurrently with 2+3.)
5. **mathlib-analogist `freeeval`** (api-alignment, Route 2 CHURNING corrective — the progress-critic's
   required pre-prover consult): `cechFreeEvalEngineIso` via `isoOfComponents`+`cechFreeEval_X`(=
   `PreservesCoproduct.iso`)+hand-built drop-zeros+`Sigma.whiskerEquiv`; **QuasiIso via Route B**
   (`combDifferential_exact`→`quasiIso_of_arrow_mk_iso`, NOT Homotopy repackaging); engine route confirmed
   (Q4 ExtraDegeneracy DIVERGE_INTENTIONALLY, twice-rejected). Real bottleneck = chain-vs-cochain
   differential variance on `Sigma.ι`. → `analogies/free-eval-engine-iso.md`.
6. **blueprint-clean `iter022`**: purity pass (4 edits stripping project-progress/Lean-type leakage from
   the new coface-match blocks). Citation discipline OK.
7. **blueprint-reviewer `iter022`** (whole blueprint, HARD GATE): **0 must-fix, CLEARS both lanes**, 0
   unstarted-phase proposals.
8. Wrote PROGRESS.md (2 lanes, keyword ON the path line for both), task ledgers, this sidecar.

## Decision made

### D1 — Fix the noop trap definitively (root cause of the lost iter-021 Route-2 corrective).
Both objective lines place a scaffold keyword (`scaffold` + `do not yet exist`) ON THE SAME PHYSICAL LINE
as the `.lean` path. iter-020 and iter-021 BOTH lost the FreePresheafComplex corrective to this trap
(keyword present but on the next line). This is the single highest-leverage fix this iter. Recorded as a
CRITICAL standing note in PROGRESS.md `## Deferred` and verified in the objective text.

### D2 — Execute Route 2's CHURNING corrective in the critic-mandated order (analogist → prover).
The progress-critic was explicit: do NOT dispatch the prover cold on `cechFreeEvalEngineIso`; run the
mathlib-analogist FIRST. Done (step 5). The analogist returned a complete verified-lemma skeleton AND the
key strategic simplification (Route B QuasiIso skips the Homotopy repackaging entirely by reusing the
already-proven `combDifferential_exact`). The prover now attacks the genuine bottleneck (the differential
variance match) with the packaging pre-solved. Cheapest reversal signal: a 3rd setup-only return (engine-iso
not past the variance match) ⇒ structural refactor of the combinatorial differential derivation (queued in
PROGRESS Next-iter #3).

### D3 — Route 1: trust the `rfl` finding; close c-concrete + d this iter (HIGH-WATCH).
The analogist reduced the "genuinely new infrastructure" tilde-bridge to a one-line `IsLocalizedModule.iso`
(carriers defeq). Combined with the blueprint decomposition, the entire A/B/d assembly is now mechanical:
φ_σ (one line) + naturality square (`qcohRestriction_eq_comparison`) + ladder transport
(`Function.Exact.of_ladder_addEquiv_of_exact`) feeding the proven `dDiff_exact` + decl 5. This is the
last iter before P3 OVER_BUDGET; the lane is loaded to close both c-concrete and d. If the prover returns
inconclusive, that is the OVER_BUDGET signal (Next-iter #4), not a reason to keep grinding the same lane.

## Subagent skips
- strategy-critic: STRATEGY.md SHA unchanged from iter-021 (no route/phase/decomposition change this iter
  — only estimate-window watch, which is not a strategy edit); prior verdict SOUND with the sole iter-019
  CHALLENGE (P5a re-sign relocates rather than removes the absolute-cohomology obligation) already ACCEPTED
  and recorded in STRATEGY `## Open strategic questions`. No live challenge.

## Tool substitutions
- none (no external-LLM tool was needed; both consults used the in-catalog mathlib-analogist).
