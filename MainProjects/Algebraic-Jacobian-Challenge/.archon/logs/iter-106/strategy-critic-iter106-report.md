# Strategy Critic Report

## Slug
iter106

## Iteration
106

## Routes audited

### Route: Phase A — close `cechCofaceMap_pi_smul` trailing sorry via "option 3"

- **Goal-alignment**: PASS — closure of the L1120 sorry advances Phase A (Čech acyclicity) which is on the critical path to `Genus` / `Jacobian` content. Fine.
- **Mathematical soundness**: PARTIAL — the named-family R-linearity lemma (`cechCofaceMap_summand_family_R_linear`, L502) is fully proved and the R-linearity statement is the right one. The blocker is purely tactical: `whnf` reduction on the anonymous-closure `Pi.lift` codomain. That is an *encoding* obstruction, not a math obstruction. After 6+ failed prover attempts (iters 099 / 100 / 101 / 103 / 105 / 106 + iter-107 option 3 per the directive), the route as stated is empirically not converging.
- **Sunk-cost reasoning detected**: yes — the route's continuation in iter-107 / iter-108 is justified by accumulated infrastructure ("wrapper helpers ... remain as inert infrastructure (fully proved, ~120 LOC)", "iter-104 named-family R-linearity ... is applied DIRECTLY"). Eight prover iterations on the *same line of code* with the same root cause is a textbook sunk-cost pattern.
- **Phantom prerequisites**: none — the iter-104 R-linearity statement is genuinely there at L502 and proved.
- **Effort honesty**: under-counted — the table says "~4–7 iters / ~80 LOC remaining" for the whole Phase A. The L1120 slot alone has already burnt 8 prover dispatches and the per-attempt cost (extracted scaffolding + dead helpers) is well over 200 LOC of staging that ended up inert. Honest count of *remaining* effort assuming the current decomposition: unbounded — every attempted decomposition has hit the same `whnf` ceiling on anonymous-closure `Pi.lift` codomains.
- **Verdict**: **CHALLENGE**

The iter-108 "abort policy" inside STRATEGY.md lists three "acceptable shapes": (a) refactor `cechCofaceMap_pi_smul`'s body to use a different decomposition, (b) re-dispatch `strategy-critic` mid-iter, (c) user escalation. Items (b) and (c) are deflection, not strategy. Item (a) is **wrapper engineering by a different name** — same lemma body, same `Pi.lift`-codomain blocker, same probability of stalling. The strategy's own abort policy stipulates "do NOT continue wrapper engineering or scalar-extraction tactic budgets"; option (a) violates the spirit of that abort. The honest read: the abort policy *did not actually pre-commit* to a substantive pivot — it pre-committed to "let's try a slight variation, or punt".

### Route: Phase A — promotion trigger for C1

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: **CHALLENGE** — *the trigger has fired and is being ignored.* STRATEGY.md states: "if Phase A stalls a 7th iter (i.e. iter-107 option 3 ALSO fails AND no refactor breakthrough), promote C1 ahead of further A work — Phase A residuals would be queued and C1 refactor begins." Per the directive, iter-107 option 3 dispatched 6 distinct attempts, **all failed**. That is the 7th stall. The trigger condition is met. The strategy text now needs to either (i) execute the promotion, or (ii) revise the trigger threshold with an honest reason; "let's try iter-108 first" with no new substantive route is not (ii), it is silent trigger drift.

### Route: Phase B — Differentials non-`h_exact` closures

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: `serre_duality_genus` will require a section / pairing that may not be in Mathlib at the curve level; the strategy is silent on whether Mathlib's `Module.Dual` / `ModuleCat` Serre-duality infra suffices. Flag for investigation, not a phantom claim today.
- **Effort honesty**: reasonable (8–12 iters / ~250 LOC for 4 non-deferred sorries).
- **Verdict**: **SOUND**. *Note*: any of the four non-deferred Phase B sorries is a candidate for parallel substantive work while Phase A is unstuck.

### Route: Phase C0 — Monoidal `X.Modules` (deferred)

- **Goal-alignment**: PASS (downstream is gated only on C3 witness, not on C0).
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none claimed.
- **Effort honesty**: 0 iters / 0 LOC — consistent with deferral.
- **Verdict**: **SOUND**.

### Route: Phase C1 — `LineBundle` refactor

- **Goal-alignment**: PASS — strategy correctly identifies that the current `LineBundle X := CommRing.Pic Γ(X, ⊤)` definition is admitted-wrong on non-affine schemes, so a substantive Jacobian *must* refactor to `MonoidalCategory.Invertible (X.Modules)`.
- **Mathematical soundness**: PASS — the iter-105 estimate revision (5–8 iters / 200–300 LOC) is now realistic. The comm-group structure on `Invertible (X.Modules)` is well-known mathematically; the formalization cost is the right order of magnitude.
- **Sunk-cost reasoning detected**: no — the refactor *removes* prior sunk cost (the wrong def) rather than building on it.
- **Phantom prerequisites**: `MonoidalCategory.Invertible` exists in Mathlib; verified by inspection of strategy text + project file structure. The relevant tensor-inverse uniqueness lemma may need to be added, which is the strategy's own caveat.
- **Effort honesty**: reasonable.
- **Verdict**: **SOUND** — and ready to be promoted per the existing trigger.

### Route: Phase C2 — `PicardFunctor` re-derivation

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: étale sheafification API in Mathlib — the strategy assumes this is available. Not verified here; spot-check next iter.
- **Effort honesty**: revised 4–6 iters / ~150 LOC looks reasonable for re-routing the existing functor-level proof through the new `LineBundle` def.
- **Verdict**: **SOUND**.

### Route: Phase C3 exit policy — `JacobianWitness` deferral

- **Goal-alignment**: **PARTIAL** — this is the most delicate verdict. The project goal (per the challenge prose) is to *construct* the Jacobian; the protected signatures are deliverables in the sense that they are filled with non-`sorry` bodies. Under the `JacobianWitness` exit policy, the protected `Jacobian C`, `ofCurve`, instances, etc. compile against a `Nonempty (JacobianWitness C)` witness whose existence sorry lives at `Jacobian.lean:179`. This is **structurally honest** (the gap is named, surfaced, on a real Mathlib gap), but the project no longer *constructs* the Jacobian — it constructs a *framework conditional on existence*. A fresh mathematician asked "did you build the Jacobian?" must answer "no, we built everything around the assumption that the Jacobian exists." That is materially different from the stated goal.

  This is not a REJECT, because the policy is the soundness-rule-compliant treatment of an unbounded gap and the strategy explicitly acknowledges the partial-delivery framing ("BLOCKED-ON-C3-WITNESS"). But a fresh reader should be told plainly: **the project's `archon-protected.yaml` signatures will compile with zero `axiom`s, but the mathematical content of "Jacobian of a smooth proper curve" is reduced to the named gap `nonempty_jacobianWitness`.** Make sure this is communicated in the project README / blueprint conclusion when the autonomous loop terminates.
- **Mathematical soundness**: PASS — `JacobianWitness` is well-defined as a structure of "any group object with the universal property", and `Nonempty (JacobianWitness C)` is a clean witness type. The downstream instances routed through it are mathematically valid *given the witness*.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: Hilbert / Quot schemes and finite-group scheme quotients are indeed absent from Mathlib b80f227 (verified by strategy text + iter-105 audit; consistent with the public Mathlib state). The exit policy is built on this fact.
- **Effort honesty**: PASS (REJECT-accepted from prior critique; original 10–15 iter estimate corrected to 50–150 iter / 5,000–15,000 LOC, which led to the defer-via-witness decision).
- **Verdict**: **CHALLENGE on goal-alignment communication, SOUND on policy structure**. The planner must add explicit language to STRATEGY.md's "End-state" section that the protected signatures compile but the mathematical content terminates at `nonempty_jacobianWitness`. Today's "End-state" paragraph hints at it but doesn't say it plainly.

### Route: Phases D / E — BLOCKED-ON-C3-WITNESS framing

- **Goal-alignment**: PASS — correctly re-statused from "closed iter-073" to "BLOCKED-ON-C3-WITNESS".
- **Mathematical soundness**: PASS.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable.
- **Verdict**: **SOUND**.

## Alternative routes (suggested)

### Alternative: Attack `h_loc_exact` at BasicOpenCech.lean L1783 instead of `cechCofaceMap_pi_smul` L1120

- **What it looks like**: The `h_loc_exact` sorry at L1783 is also in Phase A's critical path (it sits inside the iter-064 `exact_of_isLocalized_span` scaffold for `h_K₀_exact`). The strategy itself flags it: "BasicOpenCech.lean's `h_loc_exact` (`IsLocalizedModule.Away f.1` on finite products, ~80 LOC Mathlib gap-fill — TRACTABLE within scope, will be closed during Phase A)". The closure recipe is straightforward: combine `IsLocalizedModule.map` with `Function.Exact.of_isLocalizedModule` (or `LocalizedModule.map_exact` if it exists) and project out the per-component exactness from `h_a₀_fun f` plus the slice-cover identification scaffolded by the surrounding `hf_eq` / `hg_eq`. It is structurally independent of `cechCofaceMap_pi_smul` — no anonymous-closure `Pi.lift` codomain to negotiate.
- **Why it might be cheaper or sounder**: 80 LOC of bounded difficulty against named Mathlib infra (`IsLocalizedModule.Away`, `Function.Exact`, `LocalizedModule.map`). It is a different kind of work than the `cechCofaceMap_pi_smul` thrash — different file region, different math, different Mathlib lemmas. A successful closure here delivers a real Phase A net-sorry decrement and breaks the 8-iter "same slot" pattern.
- **What the current strategy may have rejected**: It is not rejected; it is *queued* ("tractable iter-108+"). The strategy is just not running it because the lane was monopolized by L1120. After 8 stalls on L1120, the queue order should flip.
- **Severity of the omission**: **critical** — this is exactly the kind of pivot the iter-108 abort policy was supposed to enable. Naming it as the iter-108 substantive shape (instead of "refactor L1120 body with a different decomposition") is the honest application of the abort.

### Alternative: Attack the L1536 sorry (LES diagram chase / Step 4 of `h_K_exact`)

- **What it looks like**: L1536 is the second-to-last open sorry in the `K₀ → K` exactness scaffold and is described in-line as "a direct diagram-chase argument (or `HomologicalComplex.homologyMap`)". It is downstream of the iter-064 short exact sequence of complexes. The closure runs through Mathlib's `Abelian.SnakeLemma` / `HomologicalComplex.homologyMap` machinery.
- **Why it might be cheaper or sounder**: SnakeLemma / `HomologicalComplex` API is well-developed in Mathlib (Joël Riou's work). The chase has no `Pi.lift`-codomain pathology. Bounded at ~60–100 LOC.
- **What the current strategy may have rejected**: unclear; the strategy assumes Phase A is single-lane on L1120 and doesn't enumerate sequencing options for the other Phase A sorries.
- **Severity of the omission**: **major** — second-string pivot if `h_loc_exact` turns out to need new Mathlib helpers.

### Alternative: Fire the C1 promotion trigger now and run the LineBundle refactor in parallel

- **What it looks like**: The strategy's own promotion trigger says "if iter-107 + iter-108 both stall on Phase A residuals, promote C1 ahead of further A work". The iter-107 stall is on the record (per directive). Running the C1 refactor in iter-108 — in parallel with a Phase A pivot to `h_loc_exact` — uses the project's most senior backlog work (the wrong-definition `LineBundle`) productively while the Phase A bottleneck is being re-decomposed.
- **Why it might be cheaper or sounder**: C1 is on the critical path for C2 which is on the critical path for `nonempty_jacobianWitness` framing. C1's wrongness (admitted in the docstring) is a substantive *mathematical* error in the project today, not just a TODO; closing C1 removes that error.
- **What the current strategy may have rejected**: not rejected; the trigger exists. It is simply not being fired despite the condition being met.
- **Severity of the omission**: **critical** — the strategy contradicts itself by stating a trigger and then planning iter-108 actions that ignore it.

### Alternative: Pivot to Phase B `relativeDifferentialsPresheaf_isSheaf` (Differentials.lean L113)

- **What it looks like**: One of the four non-deferred Phase B sorries. Sheaf-of-modules sheafification check for the relative differentials presheaf. Self-contained; uses Mathlib's `Presheaf.IsSheaf` API.
- **Why it might be cheaper or sounder**: Different file, different math, different prover lane. A productive substantive lane while Phase A is being re-decomposed.
- **What the current strategy may have rejected**: implicitly sequenced after Phase A; no explicit reason given for the sequencing.
- **Severity of the omission**: **minor** — useful diversification but not the strongest substitute lane.

## Sunk-cost flags

- "**wrapper helpers** `cechCofaceMap_summand_family'` + `_R_linear` (iter-105, fully proved) **kept as inert infrastructure** but NOT load-bearing for L1145 closure" — Why this is sunk-cost: it openly admits the iter-105 effort (≈120 LOC, two fully-proved theorems) is no longer load-bearing, yet the planning prose still anchors decisions around it. Recommendation: garbage-collect inert helpers as part of the iter-108 refactor commitment, or accept they will be deleted; do not let their existence inform routing.

- "Iter-107 commits to option 3 (per progress-critic primary corrective + strategy-critic-iter105 alternative #3)" — Why this is sunk-cost: per the directive, option 3 has now empirically failed in iter-107 with 6 distinct attempts at the same root cause. Continuing in iter-108 with a "refactor of `cechCofaceMap_pi_smul`'s body to use a different decomposition" is a re-skinned option 3 (same lemma, same `Pi.lift` codomain). Recommendation: stop framing future attempts on L1120 as "the substantive route" — declare it queued, pivot to one of the alternatives above.

- "iter-104 named-family R-linearity `cechCofaceMap_summand_family_R_linear` (also fully proved) is applied DIRECTLY at the per-summand discharge" — Why this is sunk-cost: the iter-104 lemma is unquestionably proved, but its existence is no longer evidence that L1120 will close — six attempts to *apply* it have failed at the elaborator level. Recommendation: treat `cechCofaceMap_summand_family_R_linear` as a generic R-linearity statement that may be useful in *other* contexts (e.g. when refactoring `cechCofaceMap_pi_smul`'s caller chain), and stop treating its existence as a forward indicator.

- "**Iter-108 commitment**: if iter-107 option 3 also stalls, escalate to refactor of `cechCofaceMap_pi_smul` body OR re-dispatch `strategy-critic` mid-iter on a revised Phase A strategy" — Why this is sunk-cost: by the time this critique is read, iter-107 option 3 has stalled. The pre-committed "refactor of `cechCofaceMap_pi_smul` body" alternative is *the same kind of work* under a slightly different name; the pre-commitment papers over the substantive pivot the abort was meant to enable. Recommendation: the iter-108 substantive route should be a *different sorry* (e.g. `h_loc_exact`), or a *different phase* (C1 refactor per trigger).

## Prerequisite verification

- `IsLocalizedModule.Away`: VERIFIED (used in the file already, e.g. at L1767–L1775).
- `Function.Exact` / `exact_of_localized_span`: VERIFIED (used at L1786).
- `LocalizedModule.map`: VERIFIED (used at L1782–L1783).
- `MonoidalCategory.Invertible`: VERIFIED (referenced in `Picard/LineBundle.lean` per strategy text; the Mathlib API for invertible objects in a monoidal category is well-established).
- `HomologicalComplex.homologyMap` (for L1536 SnakeLemma chase): VERIFIED (Mathlib has `CategoryTheory.Abelian.SnakeLemma` and `HomologicalComplex` machinery).
- `MonoidalCategory.Invertible (X.Modules)` comm-group structure: PARTIAL — basic monoidal-invertible API exists; whether tensor-inverse uniqueness up to iso is a one-liner or requires new lemmas is genuinely uncertain (strategy text already flags this as the reason for the 200–300 LOC estimate).
- Hilbert / Quot schemes (C3 deferred): MISSING — consistent with the strategy's deferral.
- Finite-group scheme quotients (C3 deferred): MISSING — consistent with the strategy's deferral.
- Étale sheafification API (C2 prerequisite): not spot-checked this iter; planner should verify before C2 dispatch.

## Must-fix-this-iter

- **Route Phase A — option 3 continuation: CHALLENGE.** The iter-107 / iter-108 framing as "option 3 substantive lane + iter-108 refactor-body fallback" is sunk-cost. The iter-108 plan must either (i) execute the C1 promotion trigger (per the strategy's own rule, since the 7th-stall condition is met), or (ii) pivot the Phase A lane to a different sorry (`h_loc_exact` at L1783 is the strongest candidate; L1536 SnakeLemma chase is a second-string substitute). "Refactor L1120 body to a different decomposition" is **not** an acceptable substitute — it is the same lemma, the same blocker, in re-skinned form.

- **Route Phase A — C1 promotion trigger: CHALLENGE.** The strategy committed to fire C1 promotion if Phase A stalls a 7th iter. Per the directive, iter-107 option 3 (the 7th attempt) failed. The trigger has fired. STRATEGY.md must either execute the promotion or be revised with a documented reason for delaying it (not "let's try iter-108 first").

- **Route Phase C3 exit policy — goal-alignment communication: CHALLENGE.** The "End-state" section of STRATEGY.md must explicitly state that the project ships with the `Jacobian` signatures compiling against a `Nonempty (JacobianWitness C)` witness whose existence is the named gap `nonempty_jacobianWitness`. A fresh reader of STRATEGY.md must not be left thinking the Jacobian has been *constructed* in any sense beyond the framework — it has been *framed*, conditional on the witness. The current "honest accounting" prose hints at this but does not say it plainly enough.

- **Alternative `h_loc_exact`: critical.** Strategy did not consider running it as a substantive Phase A lane in lieu of `cechCofaceMap_pi_smul` L1120. After 8 stalls, this is the obvious pivot. Planner must address.

- **Alternative C1 promotion now: critical.** Strategy contradicts itself by stating a 7-iter trigger and then planning iter-108 actions that ignore it. Planner must reconcile.

## Overall verdict

A fresh mathematician reads STRATEGY.md and sees a coherent end-state plan (Phases A–E with the Phase C3 exit policy documented) but a tactically incoherent iter-107/iter-108 commitment: the project has been monopolizing the `cechCofaceMap_pi_smul` L1120 prover lane for 8 iterations on the same root cause (anonymous-closure `Pi.lift` codomain + `whnf` discrim-tree pattern unification), the strategy's own promotion trigger ("if Phase A stalls a 7th iter, promote C1 ahead of further A work") has fired, and the iter-108 "abort policy" pre-commits to alternatives ((a) refactor body, (b) re-dispatch me, (c) user escalation) that are either wrapper engineering by another name or deflection. The honest fresh-reader interpretation is: **the strategy needs to either fire the C1 promotion trigger or pivot the Phase A lane to a *different sorry* (`h_loc_exact` at L1783 is sitting there as the obvious substitute). Continuing on L1120 with a re-skinned decomposition is sunk cost.** Separately, the Phase C3 `JacobianWitness` exit policy is structurally honest but its goal-alignment story needs to be written in plain language in the End-state — "Jacobian framework conditional on `nonempty_jacobianWitness`" is not the same as "Jacobian", and STRATEGY.md should be unambiguous about that.

