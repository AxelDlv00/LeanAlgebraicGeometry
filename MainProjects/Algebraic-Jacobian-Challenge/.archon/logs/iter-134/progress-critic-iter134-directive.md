# Progress Critic Directive

## Slug
iter134

## Iter
134

## Active routes / files under review

### Route 1: `AlgebraicJacobian/Cotangent/GrpObj.lean` — piece (i.a) `cotangentSpaceAtIdentity` + `…_finrank_eq` (DONE iter-132)

- **Started at iter**: 128
- **Iters audited**: 130, 131, 132, 133

#### Sorry counts per iter (per-file)
- iter-130: 0 (declaration body landed as opaque `Classical.choice (Nonempty.intro X)`)
- iter-131: 0 (body refactored to pure-term `Classical.choose`-chain via refactor-cotangent-grpobj-iter131; `cotangentSpaceAtIdentity_eq_extendScalars` strong acceptance lemma added; closes by `rfl`)
- iter-132: 0 (prover lane closed `cotangentSpaceAtIdentity_finrank_eq` ~40 LOC; kernel-only axioms; piece (i.a) DONE)
- iter-133: 0 (refactor lane: 5 docstring refreshes + 1 style nit `set ... with _def → let`; 285 → 296 LOC; no semantic change)

#### Helpers added per iter (per-file)
- iter-130: body landed (declaration emitted)
- iter-131: refactor — `cotangentSpaceAtIdentity_eq_extendScalars` (~ +20 LOC); body-shape pivot to pure-term form
- iter-132: `cotangentSpaceAtIdentity_finrank_eq` prover lane (+~40 LOC body; ~+65 LOC net file growth 219→284)
- iter-133: refactor lane — docstring + style nit only (+11 LOC; 0 declarations added)

#### Prover statuses per iter (per-file)
- iter-130: COMPLETE — body landed; review-phase flagged structural opacity (must-fix iter-131)
- iter-131: COMPLETE (refactor-only; no prover lane on this file; body reshape) — must-fix opacity resolved
- iter-132: COMPLETE — META-PATTERN TRIPWIRE 5-iter watch passes (2 corrective cycles consumed; iter-131 body shape proved tractable for rank lemma close)
- iter-133: COMPLETE (refactor-only; no prover lane on this file; 5 docstring refreshes + 1 style nit; no semantic change)

#### Recurring blocker phrases
- "opaque past Nonempty (ModuleCat k)" — iter-130 review-phase audits; resolved iter-131 body refactor
- "META-PATTERN TRIPWIRE" — armed iter-130 by progress-critic-iter130 + review130 audits; passed iter-132 acceptance test; remains as a non-promise commitment (no 4th body reshape under any future iter)

#### Planner's current proposal for this iter
- No work on piece (i.a) this iter (DONE iter-132). The iter-134 plan agent is dispatching a piece (i.b) prover lane on the same file `Cotangent/GrpObj.lean` (different declaration, `mulRight_globalises_cotangent`, NOT a body reshape on `cotangentSpaceAtIdentity`).

### Route 2: `AlgebraicJacobian/Jacobian.lean` — `nonempty_jacobianWitness` body + `genusZeroWitness` scaffold (DEFERRED-BY-DESIGN)

- **Started at iter**: 127 (scaffold landed iter-127); body closure scheduled iter-145+ → revised iter-151+ → iter-157+ per current STRATEGY.md
- **Iters audited**: 130, 131, 132, 133

#### Sorry counts per iter (per-file)
- iter-130: 2 (L188 `genusZeroWitness`; L210 `nonempty_jacobianWitness` foundational; both deferred-by-design)
- iter-131: 2 (unchanged; off-limits this iter)
- iter-132: 2 (unchanged; off-limits this iter)
- iter-133: 2 (unchanged; off-limits this iter)

#### Helpers added per iter (per-file)
- iter-130 → iter-133: 0 (file untouched these iters; off-limits per STRATEGY.md decomposition)

#### Prover statuses per iter (per-file)
- iter-130 → iter-133: N/A (off-limits this iter; no prover dispatched)

#### Recurring blocker phrases
- None per-prover-attempt. Blueprint-reviewer iter-132+133 flagged `Jacobian.tex` C.2.a–C.2.e soft drift (over-`k̄` historical scaffolding) `correct: partial`; not a blocker for any active prover route.

#### Planner's current proposal for this iter
- Continue deferring this file per design (gated on M2.a body closure iter-151+ → M2.b body closure iter-153+ → genus-stratified restructure iter-157+). NO prover dispatch.
- OPTIONAL: `positiveGenusWitness` scaffold lane (~20–30 LOC quick refactor to insert a sorry-bodied stub parallel to iter-127 `genusZeroWitness`; M3 stub; unlocks genus-stratified body restructure precondition); may or may not fire this iter depending on iter-134 budget after the piece (i.b) main dispatch.

### Route 3: `AlgebraicJacobian/RigidityKbar.lean` — `rigidity_over_kbar` body (DEFERRED-BY-DESIGN)

- **Started at iter**: 126 (scaffold landed iter-126; over-k commitment confirmed iter-127; rename `kbar → k` deferred iter-129+ cleanup)
- **Iters audited**: 130, 131, 132, 133

#### Sorry counts per iter (per-file)
- iter-130 → iter-133: 1 (unchanged; body gated on shared pile pieces (i.a) DONE iter-132 → (i.b) iter-134+ → (i.c) iter-137+ → (ii) iter-141+ → (iii) iter-144+ → M2.a body iter-151+)

#### Helpers added per iter (per-file)
- iter-130 → iter-133: 0 (file untouched these iters)

#### Prover statuses per iter (per-file)
- iter-130 → iter-133: N/A (off-limits this iter)

#### Recurring blocker phrases
- None for this file directly. The blockers live upstream in `Cotangent/GrpObj.lean` (the shared pile).

#### Planner's current proposal for this iter
- Continue deferring per design. NO prover dispatch.

### Route 4: `AlgebraicJacobian/Cotangent/GrpObj.lean` — piece (i.b) `mulRight_globalises_cotangent` (FRESH, planner correctly analogist-first iter-133)

- **Started at iter**: 134 (this iter, planner is staging the prover lane after iter-133 blueprint hardening + analogist + STRATEGY.md gap inventory expansion)
- **Iters audited**: 131, 132, 133 (preparatory iters)

#### Sorry counts per iter (per-file at the piece (i.b) declaration site)
- iter-131: N/A (declaration doesn't exist; piece (i.b) is iter-134+ work)
- iter-132: N/A (declaration doesn't exist; piece (i.b) is iter-134+ work)
- iter-133: N/A (declaration doesn't exist; iter-133 plan-phase prepared blueprint + analogist verdict)

#### Helpers added per iter
- iter-131 → iter-133: 0 in Lean (this is iter-134+ planned work)

#### Prover statuses per iter
- N/A (no prior prover attempts on this declaration; iter-134 is the first scheduled prover lane)

#### Recurring blocker phrases
- None. iter-133 plan-phase dispatched `mathlib-analogist-mulright-globalises-iter133` which returned PROCEED with iter-131 (B)-body composition + ALIGN_WITH_MATHLIB on sheaf-level RHS (Decision 4) + 2 NEEDS_MATHLIB_GAP_FILL sub-pieces (Decision 1: shear iso ~30–60 LOC; Decision 2: base-change-of-differentials ~150–300 LOC) + REFUTES iter-130 strategy-critic Q2 (B)→(A) bridge worry (Decision 3). Persistent file `analogies/mulright-globalises-cotangent.md`. Piece (i.b) envelope: 210–440 LOC under sheaf-level RHS; trigger (a') does NOT fire under sheaf-level RHS.

#### Planner's current proposal for this iter
- Dispatch a prover lane on `Cotangent/GrpObj.lean` for `mulRight_globalises_cotangent` per the iter-133 blueprint-writer's `lem:GrpObj_mulRight_globalises` hardening + 2 helper sub-lemmas + analogist's sheaf-level RHS recipe. Contingent on iter-134 mandatory blueprint-reviewer flipping `RigidityKbar.tex` § Piece (i.b) to `complete: true` / `correct: true`. Expected envelope: 210–440 LOC over 2–4 iter (i.e., this prover lane is the first iter of a multi-iter close).
- Iter-134 plan agent's pre-commitment: if iter-134+ prover lane chooses value-level-stalk RHS instead of sheaf-level RHS, trigger (a') fires and the over-k vs over-`k̄` decision is formally re-opened (per iter-133 watchpoint). The iter-134 plan agent will hold the prover lane to sheaf-level RHS per the analogist recommendation; the prover's directive will name the sheaf-level RHS as the primary route, and the `change`-rewrite tactic (per MED-C) as the primary close.

## Out of scope

- M1 bridge (EXCISED iter-126; M1.d Mathlib-PR candidate preserved standalone).
- M3 routes A/B (user-escalation pending; both > 5000 LOC).
- All Cohomology files (Phase-A DONE; not active prover lanes).
- `Genus.lean`, `AbelJacobi.lean`, `Rigidity.lean`, `Differentials.lean` (all 0 sorries; stable).

## Planner's question

Re-verify per-route convergence. The iter-133 you (`progress-critic-iter133`) returned 1 CONVERGING (Route 1) + 3 UNCLEAR (Routes 2+3 deferred-by-design; Route 4 fresh, planner correctly analogist-first); 0 CHURNING, 0 STUCK. Iter-134 should:

- Route 1 stays CONVERGING (no work iter-134 unless a piece (i.c) or other consumer needs it).
- Routes 2+3 stay UNCLEAR (deferred-by-design; no signal change expected).
- Route 4 resolves from UNCLEAR to CONVERGING/CHURNING/STUCK based on the iter-134 prover lane outcome — BUT this is iter-134 plan-phase, so the iter-134 prover lane has NOT yet run when you receive this directive. Your verdict on Route 4 this iter is essentially "still UNCLEAR — first prover attempt about to fire" UNLESS you detect a CHURNING risk in the planner's proposal shape (e.g., planner is proposing a prover dispatch on an under-spec'd blueprint, or planner is silently violating the META-PATTERN TRIPWIRE non-promise commitment).

If Route 4 looks healthy (analogist-first preparation, blueprint hardening landed iter-133, sheaf-level RHS recipe documented, helper sub-lemmas decomposed), your verdict should be UNCLEAR-favorable-for-iter-135 — i.e., the planner's iter-134 dispatch is reasonable but iter-135 will need to resolve based on what the prover actually closes.

If you detect any of the following, your verdict on Route 4 escalates:
- The iter-133 analogist recommendation (sheaf-level RHS) is at odds with what the iter-133 blueprint writer actually landed in `RigidityKbar.tex`.
- The piece (i.b) closure chain (a)+(b)+(c)+(d) is not actually decomposable in the order the analogist promised (e.g., (b) cannot be proved without (c)).
- The iter-133 plan agent is showing signs of "let's add more analogist consults" instead of testing the prover lane (a soft CHURNING precursor; the right corrective is to TEST the analogist's recipe with a prover dispatch this iter, not to delay further).
