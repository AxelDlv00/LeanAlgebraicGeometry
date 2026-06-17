# Progress Critic Report

## Slug
ts211

## Iteration
211

## Routes audited

### Route: Lane TS — `Picard/TensorObjSubstrate.lean` (A.1.c.SubT, ⊗-group law)

- **Sorry trajectory**: 3 → 3 → 3 → 3 → 3 → 3 across iters 205–210. The count
  entered this window at 3 (the one 4→3 step in iter-206 was dead-code removal,
  not a critical-path closure). The three sorries that remain — `tensorObj_restrict_iso`
  (L399), `exists_tensorObj_inverse` (L442), `addCommGroup_via_tensorObj` (L481) —
  are unchanged. **No Lean edits were made in iters 209 or 210** (the NO-PROVER
  restructuring iters); the flat count is therefore partly an artifact of deliberate
  hold, not purely prover failure.

- **Helper accumulation**: iters 205–208: ~7 Lean declarations added (transport
  lemmas, `restrictScalars*` helpers, `mapIso` reductions), 0 critical-path
  sorry-eliminations — payoff ratio 0/7. iters 209–210: no Lean additions; only
  blueprint rewrites (⊗-invertibility predicate, flat-whiskering associator, monoid/
  units assembly, off-path demotion of `restrict_iso` / `exists_inverse`). The
  blueprint is now fully rewritten to the new construction; `IsInvertible` and
  `W_whiskerLeft_of_flat` are **absent from the Lean file** (to be scaffolded in
  iter-211).

- **Prover dispatch pattern**: single-lane by USER mandate throughout. iters 205–208:
  1 prover round each; iters 209–210: 0 prover rounds (deliberate). Not an
  under-dispatch finding — all other lanes are held by standing USER directives.

- **Recurring blockers**:
  - `(PresheafOfModules.pullback φ).Monoidal` absent — appears in iters 205, 206, 207, 208
    under names "MonoidalClosed wall" / "comparison map absent" / "ring-layer mismatch /
    pullback.Monoidal" / "opaque pullback, 4 absent ingredients." Four iters, one gap.
  - "premise DISPROVEN / reversal pre-commitment FIRED" — iters 206, 207, 208. Three
    consecutive.
  - **Current status of these blockers**: both have been REMOVED FROM THE CRITICAL PATH
    by the ⊗-invertibility pivot (iter-209 analogist confirmed: under `IsInvertible`,
    `tensorObj_restrict_iso` and `exists_tensorObj_inverse` are not needed for the
    group law; the new construction does not touch `pullback.Monoidal`). They are
    historical blockers, not current ones.

- **Avoidance patterns**:
  - 2 consecutive NO-PROVER iters (209, 210). Below the CHURNING plan-phase-only
    threshold (requires ≥3). Not a finding by itself.
  - No "off-critical-path" reclassification, no persistent deferral language.

- **Prover status pattern (last 5 iters)**: PARTIAL, PARTIAL, PARTIAL, NO_PROVER,
  NO_PROVER. CHURNING trigger fires: PARTIAL ≥3 of last K iters. See verdict
  discussion below.

- **Throughput**: SLIPPING. Strategy estimate at phase-entry (iter-209): ~3–6 iters.
  Elapsed in current phase: 2 iters (both NO-PROVER restructuring). The lower bound
  of the estimate (3 iters) has not yet been exceeded, but zero sorry-eliminations
  have landed in 2 elapsed iters; the first prover dispatch has not yet happened. If
  iter-211 closes ≥1 sorry, the route stays within range. SLIPPING rather than
  ON_SCHEDULE is the honest read.

- **Verdict**: **CONVERGING**

  **Mechanical trigger analysis and why it does not control:**

  Two triggers fire on the K=5 trailing window:
  1. *CHURNING — PARTIAL ≥3*: iters 206, 207, 208 are PARTIAL. Fires.
  2. *STUCK — recurring blocker phrase across ≥3 iters* (combined with unchanged sorry
     count): the absent `pullback.Monoidal` / `MonoidalClosed` blocker appears in iters
     205–208. Fires.

  Both triggers apply to the **old construction** (abstract δ-mate / sectionwise
  restrict-iso route). That construction was **structurally abandoned** in iter-209 —
  not reframed, but replaced by a materially different set of obligations. The CHURNING
  and STUCK rules are designed to detect "the same approach iterated K times without
  progress." Their implicit premise — "same approach being iterated" — is violated here:

  - The iter-209 analogist (tsconstruct209) confirmed: the group-law construction was
    built on the wrong carrier predicate (`IsLocallyTrivial`), which is what forced
    `tensorObj_restrict_iso` and `exists_tensorObj_inverse` onto the critical path.
    Under `IsInvertible` (the project's own documented iter-174 intent), both sorries
    dissolve from the critical path. This is not a rename.
  - The iter-210 analogist (ts-assoc-gate210) verified that the one remaining
    non-trivial ingredient — the flat-whiskering localizer `J.W g ⇒ J.W (P ◁ g)` for
    flat P — uses PRESENT Mathlib: `Module.Flat.lTensor_preserves_injective_linearMap`
    (local injectivity), `Module.Invertible ⇒ Projective ⇒ Flat` (flatness free),
    `J.WEqualsLocallyBijective` / `IsLocallySurjective` from right-exactness (local
    surjectivity). The local-trivialization realization was explicitly rejected as a
    renamed wall (it reduces back to `tensorObj_restrict_iso`); only the
    flat-whiskering realization was cleared.
  - The blueprint was rewritten in iters 209–210 to reflect the new construction
    (IsInvertible predicate, flat-whiskering associator, monoid on iso-classes of
    invertibles, `W_whiskerLeft_of_flat` as the sole non-trivial ingredient). This
    rewrite is a complete change of proof obligations, not cosmetic renaming.

  The blocker from iters 205–208 (`pullback.Monoidal` / `MonoidalClosed`) is not the
  same gap as the new construction's only open ingredient (`W_whiskerLeft_of_flat`).
  The former required absent monoidal structure on the abstract adjoint functor; the
  latter uses flat-module exactness, a constructive and present ingredient.

  The corrective actions prescribed by CHURNING/STUCK (Mathlib analogy consult; route
  pivot) were both completed in iters 209–210. Giving CHURNING/STUCK with those
  correctives now would prescribe actions already taken. The iter-211 dispatch is not
  "another helper round on the old construction" — it is the **first prover dispatch
  on the new construction**, which has never been tested in Lean.

  **Pivot assessment: GENUINE.**
  The 209/210 pivot is not rotation churn. The test: do the new construction's
  ingredients overlap with the old construction's Mathlib gap? They do not. Old: needed
  `(PresheafOfModules.pullback φ).Monoidal` and `MonoidalClosed (PresheafOfModules R₀)`
  — both absent, both verified-absent by four independent prover attempts.
  New: needs `W_whiskerLeft_of_flat` (flat-exactness bridge, ~30–80 LOC,
  ingredients present), unitors/braiding (~15 LOC each, `sheafification.mapIso`
  pattern), `IsInvertible` predicate (internal, trivial). The only ingredient that
  could conceivably collapse back to the old gap is `W_whiskerLeft_of_flat` if the
  flat-exactness path turns out to need `MonoidalClosed` after all — the iter-210
  analogist explicitly flagged this as the "reversal trigger" and assessed it as
  unlikely given the locally-bijective framing. It has not been tested in Lean yet.

  **On the proposed scope (6 declarations, single combined lane):**
  The scope is appropriate given the analogist clearance, with one structural
  recommendation: the prover should establish `W_whiskerLeft_of_flat` **first** within
  the lane, before scaffolding the CommMonoid assembly and the full group structure.
  Reason: `W_whiskerLeft_of_flat` is the sole ingredient whose Lean proof has not been
  tested; every other piece (unitors, braiding, `IsInvertible`, CommMonoid via `Units`)
  depends on or chains through it, and its failure would invalidate the full scaffold
  plan. If it closes, the remaining ~5 declarations are low-risk (~15 LOC each or
  trivial). The combined lane is not over-scoped, but internally ordering `W_whiskerLeft_of_flat`
  first eliminates a planning risk.

---

## PROGRESS.md dispatch sanity

Verdict: OK — file count 1 within cap 10. Only one lane available by USER
mandate. No under-dispatch finding. No bloat pattern.

---

## Informational

**Reversal trigger caveat.** If `W_whiskerLeft_of_flat` fails in iter-211 (i.e., the
flat-exactness path turns out to require `MonoidalClosed` after all), this is the
iter-210 analogist's named "reversal trigger." At that point the route hits STUCK with
no further structural avenue: both the abstract-adjoint path (iters 205–208) and the
flat-exactness path (iter-211) will have been exhausted. User escalation would be
required — the planner should be prepared to write the `TO_USER.md` entry rather than
pivoting a third time to a new construction name.

**Throughput watch.** The ~3–6 iter estimate for the current phase was set at
iter-209; 2 iters have elapsed with 0 sorry-eliminations. Iter-211 must close ≥1
sorry (most likely `addCommGroup_via_tensorObj` L481, which is the immediate consumer
of the new group structure) to keep the project within the estimate's lower bound.
Closing all 3 sorries in iter-211 is optimistic but not impossible if `W_whiskerLeft_of_flat`
is clean and the CommMonoid assembly proceeds without incident.

**Note on sorry count vs. the `sorry` token count.** The file contains 16 occurrences
of the token "sorry" (from `grep -c`), but only 3 are proof-body `sorry` terms (L399,
L442, L481). The others are in comment blocks and historical remarks. The signal is 3
open proof obligations.

---

## Overall verdict

1 route audited; **CONVERGING**. 0 avoidance findings. Dispatch = OK.

The mechanical CHURNING and STUCK triggers fire on the K-iter trailing window, but
both apply to the OLD construction (abstract δ-mate / restrict-iso route) that was
structurally abandoned in iter-209, not to the current construction being dispatched.
The 209/210 pivot is genuine: the old blockers (`pullback.Monoidal`, `MonoidalClosed`)
have been confirmed off the critical path; the new construction uses verified-present
Mathlib ingredients (`Module.Flat.lTensor_preserves_injective_linearMap`,
`WEqualsLocallyBijective`). The corrective actions that CHURNING/STUCK would
prescribe (Mathlib analogy consult, route pivot) were completed in iters 209–210.

Resuming prover dispatch in iter-211 on the pivoted construction is **justified**. The
single-lane dispatch covering 6 declarations is appropriately scoped given the
analogist clearance, provided `W_whiskerLeft_of_flat` is proved first within the lane
as the load-bearing gate. If that one ingredient fails, the planner should escalate to
the user rather than pivoting again.
