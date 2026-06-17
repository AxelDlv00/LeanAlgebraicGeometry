# Progress Critic Report

## Slug
iter006

## Iteration
006

## Routes audited

### Route: FBC-A — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 3 → 3 → 4 (iter-002 end → iter-003 end → iter-004 end). Iter-005 was
  dag-only (no prover run); sorry count entering iter-006 is still 4. Net change over the 2-prover-iter
  window (002→004): **+1** (up, not down).
- **Helper accumulation**: iter-003 added `pullbackIsoEquivalenceOfIso`, `pullback_isEquivalence_of_iso`
  + the mate-lemma stub chain (L1/L2/L3 proved axiom-clean). Iter-004 added `base_change_regroup_linearEquiv`,
  `base_change_mate_regroupEquiv` (partial), `base_change_mate_generator_trace_eq` (typed sorry),
  `base_change_mate_generator_trace` (closed), `pushforward_base_change_mate_cancelBaseChange` (closed
  assembly). Iter-006 plan phase added `RegroupHelper.lean` (the refactor that unblocks the
  `map_smul'` one-liner). Total new declarations across 3 prover iters (002–004): ~12; file-level
  sorries went from 3 to 4, not down.
- **Recurring blockers**: (a) **`base_change_mate_regroupEquiv` `map_smul'` instance/carrier wall** —
  appears iter-004 report with the exact phrase "carrier-instance wall"; the fix (split
  `base_change_regroup_linearEquiv` to a separate compiled module) was identified and confirmed in
  iter-004 but NOT deployed until iter-006 plan phase — **2 iter lag on a confirmed fix**. (b)
  **`base_change_mate_generator_trace_eq` adjoint-mate trace** — appears iter-004 as the "genuine
  outstanding crux," still only a typed sorry with informal trace at iter-006 start, no real proof
  attempt yet.
- **Avoidance pattern**: The `map_smul'` one-liner fix (`exact LinearEquiv.toModuleIso
  (base_change_regroup_linearEquiv ↑M)`) was confirmed working end-to-end in a scratch import in
  iter-004. The iter-004 prover explicitly deferred it ("not done this iter to respect single-file
  ownership + 'import only Mathlib' lane invariant"). The plan agent did not schedule the refactor in
  iter-005 (dag-only iter) or as a standalone action; it finally executes in iter-006's plan phase. A
  confirmed sorry-closing one-liner sitting idle for 2 planning cycles is a deferral pattern, not an
  invariant. The refactor has now been executed — the avoidance ended, not still ongoing.
- **Prover status pattern**: PARTIAL (iter-002), PARTIAL (iter-003), PARTIAL (iter-004). **Three
  consecutive PARTIAL statuses.**
- **Throughput**: SLIPPING — 3 prover iters elapsed against a 3–5 iter estimate from iter-002. By
  the lower bound we should be finishing or finished; instead 4 sorries remain with only 1 (the
  `map_smul'` residue) having a confirmed closure path and the next crux (`generator_trace_eq`)
  having had zero real proof attempts.
- **Verdict**: **CHURNING**
  - Triggered by: PARTIAL prover status ×3 (standalone CHURNING criterion, rules §4, met verbatim).
  - Confirming signals: sorry count net +1 over 2 prover iters (up, not down); confirmed 1-liner fix
    sat undeployed for 2 iter cycles.
  - Note: the structural decomposition work (proving L1/L2/L3/L4-a/L4-c axiom-clean each iter) is
    genuine and non-trivial — the 4 remaining sorries are much more isolated than the original 3. The
    CHURNING verdict is about the trajectory pattern and the deferral, not the quality of work done.
- **Primary corrective**: **Execute the confirmed fix now.** The `RegroupHelper.lean` refactor is
  already in place; the prover must close `base_change_mate_regroupEquiv.map_smul'` with the
  one-liner in this iter — treating it as a "candidate for a plan decision" again would be the
  failure mode. Then make a **genuine** first proof attempt at `base_change_mate_generator_trace_eq`
  (the 3-step unit→`f_*`-reindex→transpose), not another informal-trace recording. If it stalls
  after 2–3 focused attempts, the correct escalation is Blueprint expansion (decompose the 3 trace
  steps into separately named sub-lemmas so each is a concrete obligation).
- **Secondary corrective**: Blueprint expansion for `generator_trace_eq` if the iter-006 prover
  returns another typed sorry with no partial proof body — split the trace into (step-1: unit value
  computation, step-2: pseudofunctor reindex, step-3: adjoint transpose) before the next prover iter.

---

### Route: GF-alg — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

- **Sorry trajectory**: 2 → 5 → 4 (iter-002 end → iter-003 end → iter-004 end). Iter-005 was
  dag-only; sorry count entering iter-006 is still 4. Net change over the 2-prover-iter window
  (002→004): **+2** (from 2 to 4, net increase despite closing 5+ individual stubs).
- **Helper accumulation**: iter-003 scaffolded 5 sub-lemma stubs (L1–L5) and proved L1 + L5-base
  axiom-clean. Iter-004 proved the L3 chain (4 lemmas axiom-clean: L3a, L3b, L3c, L3-assembly) and
  the L5 torsion sub-case. Net from iter-003+004: ~8 declarations added, 6 proved axiom-clean, but
  the 2 active residues (L4, L5-generic-rank) remain open and the 2 deferred assemblies remain.
- **Recurring blockers**: (a) **L4 denominator-clearing Step 2** — present iter-003 (new stub),
  iter-004 (only Step 1 proved, Step 2 unresolved). 2 consecutive iters without Step 2 progress.
  (b) **L5 generic-rank dévissage (non-torsion branch)** — present iter-003 (new sorry), iter-004
  (torsion sub-case closed but generic-rank branch still sorry). 2 consecutive iters. The iter-004
  prover noted the current L5 skeleton uses a `cases-split` with **no IH in scope**: "filling it
  requires restructuring to strong induction on d." This structural invalidity has been known for 1
  full iter cycle with no fix applied.
- **Structural invalidity flag (L5)**: The current `exists_free_localizationAway_polynomial` body
  uses `rcases Nat.eq_zero_or_pos d with hd | hd` followed by an attempted induction in the
  `hd : 0 < d` branch. This is NOT a `Nat.rec` with a universally-quantified IH — the IH on the
  torsion quotient `T` (which has a smaller `d`) is simply not in scope. No amount of helper lemma
  accumulation will close this branch; the proof structure must change to `Nat.strongRecOn d (fun d
  ih N ...)` universally quantifying the module `N` for the IH to apply to `T`. This is a
  **correctness blocker**, not a math gap.
- **Avoidance pattern (mild)**: The L5 restructure-to-strong-induction was identified in the
  iter-004 prover result ("restructure as strong induction on d ... the IH on T is available;
  ... fine-break candidate"). Iter-005 was dag-only. Iter-006 directive proposes executing this
  restructure now. That is 1 effective planning cycle of known structural invalidity sitting without
  action — not as severe as the FBC-A instance-wall lag, but the same pattern.
- **Prover status pattern**: PARTIAL (iter-002), PARTIAL (iter-003), PARTIAL (iter-004). **Three
  consecutive PARTIAL statuses.**
- **Throughput**: SLIPPING — 3 prover iters elapsed against a 3–5 iter estimate from iter-002.
  Sorry count net is +2 (from 2 to 4); without L4 or L5 closing, the route cannot converge.
- **Verdict**: **CHURNING**
  - Triggered by: PARTIAL prover status ×3 (standalone CHURNING criterion, met verbatim).
  - Confirming signals: sorry count net +2 over 2 prover iters; L5 structural invalidity known for
    1 iter cycle without remediation; L4 and L5 recurring blockers each 2 iters old.
  - Note: the L3 chain closure (4 axiom-clean lemmas in iter-004) was genuine progress. The churn
    is concentrated in the L4/L5 residues, which have not moved despite 2 prover attempts at them.
- **Primary corrective**: **Structural refactor of L5 before any more helper accumulation.** The
  `exists_free_localizationAway_polynomial` body must be restructured to strong induction on `d`
  (universally quantifying `N`): `Nat.strongRecOn d (fun d ih => fun N ... => ...)` so the IH
  `ih d' (hd' : d' < d) T ...` is in scope for the torsion-quotient sub-case. Until this structural
  fix is in place, the generic-rank dévissage step is impossible to close; adding more sub-lemmas
  around a `cases-split` skeleton will not converge.
- **Secondary corrective**: If after the L5 restructure the iter-006 prover makes no progress on
  L4 Step 2, consider Blueprint expansion for L4 — break the denominator-clearing descent into
  named sub-steps (lift generators from `K[b̄_j]` to `B`, clear finitely many integral-dependence
  coefficients, bound the common denominator) so the prover has a concrete scaffold rather than a
  blank sorry.

---

## Serial-bottleneck question (GF)

**Not demonstrated; single lane is correct.** L4 and L5 are mathematically independent within
the file — L5 does not depend on L4 (the polynomial-ring core `exists_free_localizationAway_polynomial`
only needs `exists_free_localizationAway_of_torsion` / L1 and `exists_free_localizationAway_of_shortExact` / L3).
L4 and L5 feed `genericFlatnessAlgebraic` in sequence (L4 produces module-finiteness over the
polynomial ring, L5 gives generic freeness of that polynomial module), but the two sub-proofs
themselves are independent. The iter-004 prover demonstrated that a single session can work on
both L3 and L4 in sequence without context overflow. The blockers are mathematical/structural —
not file-scope interference. Splitting now would add overhead without addressing the root causes
(L5 invalid structure, L4 Mathlib-absent denominator construction). **Recommendation: maintain
single lane for iter-006. Revisit splitting only if the iter-006 prover returns PARTIAL on both
L4 and L5 with neither making structural progress.**

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (cap: 10)
- **Ready but not dispatched**: none — both active routes are in the iter-006 proposal
- **Over the cap**: no
- **Under-dispatch finding**: no — both ready lanes are dispatched
- **Iter-over-iter trend**: 2 → 2 → 2 (consistent 2-file dispatch since iter-002)
- **Verdict**: OK — 2 files dispatched, both active routes covered, within cap.

---

## Must-fix-this-iter

- **FBC-A: CHURNING — primary corrective: Execute the confirmed fix now.** The `base_change_mate_regroupEquiv.map_smul'`
  sorry has a known one-liner (`exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`)
  that is confirmed working now that `RegroupHelper.lean` is compiled. It MUST close this iter —
  deferring a confirmed closure for a 3rd iter is the churn failure mode this subagent exists to
  prevent. Then the prover must make a genuine proof attempt at `generator_trace_eq` (not just record
  the informal trace again).
- **GF-alg: CHURNING — primary corrective: Structural refactor of L5 before helper accumulation.**
  `exists_free_localizationAway_polynomial` uses a `cases-split` with no IH in scope for the
  `d ≥ 1` branch — the structure is provably incomplete. Restructure to `Nat.strongRecOn` with a
  universally quantified module argument FIRST; only then attempt the generic-rank SES and splice.
- **FBC-A: SLIPPING throughput.** 3 prover iters elapsed; estimate was 3–5; 4 sorries remain with
  only 1 having a confirmed closure path. If `generator_trace_eq` does not close or show real
  partial proof progress in iter-006, escalate to Blueprint expansion (3-step decomposition) before
  iter-007 dispatch.
- **GF-alg: SLIPPING throughput.** 3 prover iters elapsed; estimate was 3–5; 4 sorries remain with
  both active ones (L4, L5) showing recurring blockers for 2 iters. If the L5 restructure + L4
  Step-2 attempt both return PARTIAL in iter-006 with no measurable advance, the route requires
  either Blueprint expansion (L4) + further effort-break (L5 generic-rank SES) before iter-007.

---

## Informational

### FBC-A avoidance resolved
The 2-iter lag on the `map_smul'` confirmed fix (iter-004 prover identified it; only deployed in
iter-006 refactor) is now resolved. No further action on this specific item; but the pattern — a
prover identifies a confirmed closure path and defers it to the plan agent, who does not schedule
it for 2 iterations — is worth noting for process improvement. When a prover confirms a one-liner
fix in its task result, the plan agent should schedule that closure explicitly in the FOLLOWING iter's
PROGRESS.md, not wait until the next effort-break or refactor subagent.

### FBC-A `affineBaseChange_pushforward_iso` scope
The iter-006 proposed objective includes "attempt `affineBaseChange_pushforward_iso` if budget
remains." The iter-004 progress critic already flagged this as "likely ≥1 dedicated iter" and a
"multi-hundred-LOC build" (Mathlib-absent restriction-compatibility of `pushforwardBaseChangeMap`
across affine charts). If the iter-006 prover closes the `map_smul'` sorry and makes partial
progress on `generator_trace_eq`, the remaining budget for `affineBaseChange_pushforward_iso`
will be near zero. This is acceptable; the plan should not overload the objective list. Prepare
a Blueprint expansion for the affine-restriction step as a pre-work for iter-007 (effort-break
the `(pushforwardBaseChangeMap).app U` restriction to the affine model).

### GF-alg L4 scoping
L4's surviving sorry (Step 2, denominator-clearing descent from `K[b̄_j]`-module-finiteness to
`A_g[b_j]`-module-finiteness) is Mathlib-absent and requires genuine mathematical construction. If
the iter-006 prover spends significant context on the L5 restructure (which must happen first), L4
may not receive a real attempt. That is acceptable; the L5 structural fix is higher priority and
must not be rushed. If L5 restructure + partial generic-rank attempt is all iter-006 achieves,
that is a successful iter — as long as the restructure actually makes L5 provable in principle.

---

## Overall verdict

Both routes are **CHURNING** via identical signals: three consecutive PARTIAL prover statuses
(iters 002–004) and sorry counts that have not decreased over the 2-iter prover window (FBC-A: 3→4,
net +1; GF-alg: 2→4, net +2). Both are **SLIPPING** on throughput (3 prover iters elapsed against
a 3–5 iter estimate, 4 sorries remaining in each). The churn is not helper-accumulation-without-payoff
in the worst sense — genuine axiom-clean lemmas were proved each iter — but it manifests as:
(1) a confirmed FBC-A one-liner fix sitting undeployed for 2 iter cycles (now finally resolved by
the iter-006 refactor), and (2) a known L5 structural invalidity (no IH in cases-split) sitting
unaddressed for 1 iter cycle. The must-fix actions for iter-006 are: close the FBC-A `map_smul'`
sorry with the confirmed one-liner (no more deferral), and execute the L5 strong-induction
restructure before attempting the generic-rank SES. If these two structural fixes land, the routes
can re-enter CONVERGING territory in iter-007.
