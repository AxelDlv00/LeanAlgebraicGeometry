# Strategy Critic Report

## Slug
iter126

## Iteration
126

## Routes audited

### Route: M1 — Presheaf ↔ algebra-Kähler bridge (PARKED, iter-128 hard trigger)

- **Goal-alignment**: PARTIAL — the bridge has zero in-tree consumers (strategy verifies this iter-125). It does not advance the protected `nonempty_jacobianWitness`; its only goal-alignment claim is "PR-extractability." But the strategy itself names the extractable upstream piece as **M1.d** (`KaehlerDifferential.equivOfFormallyUnramified`), which is **already closed in body**. M1.b (`appLE_isLocalization` bijectivity) is "too scheme-morphism-shaped for upstream PR and remains a project-local lemma." Net: closing M1.b yields neither a downstream consumer nor a Mathlib PR — only kills a sorry in a parked declaration.
- **Mathematical soundness**: PASS — the 130–210 LOC closure recipe (filtered-colim bridge + basic-open cofinality + `lift_{inj,surj}_iff`) is concrete and the named Mathlib leverage (`IsLocalization.of_le` `[verified, Mathlib.RingTheory.Localization.Defs]`, `IsAffineOpen.isLocalization_basicOpen` `[verified, Mathlib.AlgebraicGeometry.AffineScheme]`, `FormallyUnramified.of_isLocalization` `[verified, Mathlib.RingTheory.Unramified.Basic]`) is real.
- **Sunk-cost reasoning detected**: yes —
  - `"M1 is parked, not abandoned."` followed by "The residual bijectivity claim has an explicit ~130–210 LOC closure recipe documented in `task_results/AlgebraicJacobian_Differentials.lean.md`" reads as preserving M1 *because the recipe exists*, not because the closure has a downstream consumer.
  - `"… it is parked because the M2.a critical-path work has been deferred ≥3 iters by M1.b churn"` acknowledges churn but the resolution (defer the close-vs-excise decision to iter-128) leaves the open declaration with its sorry on the tree for ≥2 more iters under a "zero inline sorry" end-state directive.
- **Phantom prerequisites**: none new. The M1.b mathlib leverage was spot-checked: `IsLocalization.of_le`, `IsAffineOpen.isLocalization_basicOpen`, `Algebra.FormallyUnramified.of_isLocalization`, `KaehlerDifferential.exact_mapBaseChange_map`, `KaehlerDifferential.map_surjective` all verified.
- **Effort honesty**: reasonable on the close path (130–210 LOC / 1–2 iter aligns with the iter-124 task-result recipe). The excise path (5-LOC delete, zero consumers) is honest.
- **Verdict**: **CHALLENGE**.

**Issue**: The iter-128 hard trigger has *two* exits — "close M1.b" or "excise" — but the strategy's own evidence already favors **excise**:

1. M1.d (the extractable PR) is **already closed in body** and lifts to Mathlib **independently of M1.b**. The presheaf-bridge declaration is not the contribution candidate.
2. The bridge has **zero in-tree consumers** (verified iter-125).
3. M1.b is admitted to be "too scheme-morphism-shaped for upstream PR" — i.e. closing it produces neither a downstream consumer nor a Mathlib PR.
4. Per the iter-126 user hint endorsement of "do the work, no axioms" with "shortest path" qualified by "your role is to fill mathlib gaps": closing a sorry whose closure feeds nothing **is not** "filling a Mathlib gap." Excising 5 LOC of dead code with a documented `analogies/relative-differentials-presheaf-bridge.md` carryover IS the shortest path to filled Mathlib PRs (M1.d already done).

The plan-agent's "defer to iter-128 with user opportunity to weigh in via USER_HINTS.md" framing is itself a form of indefinite-deferral hedge. Iter-128 should not be a "decision iter" if the analysis is already in hand — that's sunk-cost dressed up as caution. **The strategy should commit, in iter-126, to one of: (i) excise the bridge at iter-127 or iter-128, no later; (ii) dispatch the M1.b prerequisite filtered-colim analogist this iter (parallel slot to the cotangent-vanishing analogist), and commit to close-or-excise iter-128 based on the analogist's verdict.** Picking neither and "deciding iter-128" is what the iter-125 critic flagged.

---

### Route: M2.a — Rigidity over `k̄` (iter-126 scaffold deliverable)

- **Goal-alignment**: PASS — `rigidity_over_kbar` is genuinely on the genus-0 critical path (via M2.b's `C(k) ≠ ∅` arm).
- **Mathematical soundness**: PASS — the C.2.a/b/c reduction is standard; C.2.d (positive-dim-image branch) genuinely requires the cotangent-vanishing pile.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none new. `Scheme.Over.ext_of_eqOnOpen` lands iter-125; the C.2.d gate is the cotangent-vanishing pile (handled under M2.d-alt).
- **Effort honesty**: PARTIAL — `~1 iter / 50 LOC for the scaffold-and-named-sorry`. But the iter-126 sequencing-table entry says "C.2.b reduction + C.2.c image-dimension dichotomy CAN sit in the body around the sorry." Real C.2.b + C.2.c work is *not* 50 LOC; the scaffold-with-real-body would be 150–300 LOC of new prover work.
- **Verdict**: **CHALLENGE**.

**Issue 1 (agent classification)**: The iter-126 plan dispatches `m2a-scaffold-iter126` as a **refactor** subagent. A refactor edits existing structure; creating a new file with new mathematical content (C.2.b reduction + C.2.c dichotomy) is **prover** work. The plan-agent should either (a) genuinely scope the deliverable to a 1-line `theorem rigidity_over_kbar : ... := sorry` skeleton (in which case "refactor" is fine but the strategy's "C.2.b/c body around the sorry" claim is dropped), or (b) re-classify as a prover dispatch (in which case it shouldn't be called a "scaffold" iter, it's a substantive prover iter under the wrong label).

**Issue 2 (sorry accounting)**: Net sorry change 2 → 3 with the scaffold, against an end-state directive that says "zero inline sorry." Defensible only if the scaffold *demonstrably* shortens future work. A `rigidity_over_kbar` declaration with a `sorry` body and no in-tree consumer (M2.b is iter-127) is functionally a blueprint marker in `.lean` form. If the deliverable is documentation-of-future-work, it belongs in `blueprint/src/chapters/RigidityKbar.tex` (already written) and/or `analogies/cotangent-vanishing-pile.md` (about to be written) — **not** as a new sorry on the tree.

The strategy should choose: either the scaffold body contains real reduction work (then it's prover work, not refactor, and the LOC estimate is wrong) or it's a documentation marker (then it belongs in the blueprint, not in `.lean`).

---

### Route: M2 — Genus-0 witness `genusZeroWitness`

- **Goal-alignment**: PASS — the case-split (`C(k) ≠ ∅` rigidity arm + `C(k) = ∅` vacuity arm) faithfully handles the protected signature without the false `C ≅ ℙ¹_k` shortcut. Spot-checked: for `C(k) = ∅` (Brauer–Severi), the field `isAlbaneseFor : ∀ (P : 𝟙_ _ ⟶ C), ...` is vacuously true, and `J = Spec k` discharges all four bundle fields (`geometricallyIrreducible_id_Spec` is already closed at `Jacobian.lean:120`).
- **Mathematical soundness**: PASS for the `C(k) = ∅` arm. PARTIAL for the `C(k) ≠ ∅` arm — soundness depends on M2.a (over-k̄) + M2.c (descent) + the shared cotangent-vanishing pile. All three named, none yet built.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: `geomIrred.exists_kalg_pt` (PHANTOM, confirmed iter-124); shared cotangent-vanishing pile components — `AbelianVariety.cotangent_trivial`, `GroupScheme.Omega_trivial`, scheme-level df=0 ⇒ factors-through-Spec-k, `AlgebraicGeometry.AbelianVariety.constant_of_P1_map` (all PHANTOM per iter-124/125 spot-checks; my own quick leansearch confirms no nearby hits). Mathlib does have `Algebra.IsGeometricallyReduced` and `Algebra.FormallyEtale.subsingleton_h1Cotangent` (`Mathlib.RingTheory.Etale.Basic`) but no scheme-level cotangent-triviality-for-group-schemes.
- **Effort honesty**: PARTIAL — the shared-pile estimate was tightened from 10–20 → 8–12 iter "because iter-126 analogist consult lands scoping 4 iters earlier." Scoping work compresses *build clock-time* by reducing dead-ends, but a ~30% compression on a 10-iter window is aggressive. Honest revision: **10–12** with the analogist; **15–20** without.
- **Verdict**: **CHALLENGE** (on the compression estimate only; route itself is sound).

The 8–12 iter window for the shared cotangent-vanishing pile is the largest single-bet in the roadmap and is **not** independently corroborated. Revise to 10–14 pending the iter-126 analogist's actual scoping.

---

### Route: M3 — Positive-genus witness `positiveGenusWitness`

- **Goal-alignment**: PASS — both routes (A: Picard via FGA; B: Sym^n + Stein) target the correct universal property.
- **Mathematical soundness**: PASS — Routes A and B are both standard textbook constructions of the Albanese variety.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: large but honestly catalogued (Hilbert/Quot representability, identity-component `G^0`, Sym^n of schemes, Stein factorisation, Brill–Noether–Riemann–Roch).
- **Effort honesty**: REASONABLE per the iter-123 audit (Route A ~6500 LOC midpoint; Route B ~9000 LOC midpoint). The user-hint absorption ("~6500–9000 LOC may not be that much for an AI") is faithful to the user's actual words.
- **Verdict**: **SOUND**.

The M3 route is off the iter-by-iter critical path (M2 first, M3 after); the user has explicitly endorsed the LOC budget. The honest move is to let M2 close and then pick Route A per the audit's cross-utility tiebreaker.

---

## Alternative routes (suggested)

### Alternative: Resolve "direct over-k rigidity" question BEFORE dispatching the cotangent-vanishing analogist

- **What it looks like**: The iter-125 critic's alternative #1 ("the cotangent-triviality argument is local; left-invariant forms give a global frame over any base field") is flagged for TO_USER.md but **not yet resolved**. The iter-126 plan goes ahead with a cotangent-vanishing analogist that may need to scope different sub-pieces depending on whether the project targets the over-`k̄` variant (with Galois descent) or the direct over-k variant (without). Char-`p` handling in particular may differ between the two variants (over `k̄` is char-`p`-clean for the Frobenius-iteration approach; over `k` may need extra hypotheses or a different argument).
- **Why it might be cheaper or sounder**: If the over-k variant is adopted, M2.c (Galois descent of morphism equality) drops entirely — strategy itself estimates 4–8 iter / 300–500 LOC savings. The cotangent-vanishing analogist should know which target it's scoping; running it on the over-`k̄` variant only to redo on the over-k variant is wasted scoping work.
- **What the current strategy may have rejected**: Not rejected — the over-k alternative is in STRATEGY.md § "Alternative: direct over-k rigidity" with a TO_USER.md flag. The current iter just hasn't sequenced it correctly. The plan-agent's deferral was to "iter-126 review-agent TO_USER.md as a strategic question for the user," which means the user might not see it until the iter-126 review phase completes, well after the iter-126 analogist has already been dispatched.
- **Severity of the omission**: **major** — risks one iter's worth of analogist scoping needing redo.

### Alternative: Dispatch the M1-prerequisite filtered-colim analogist in iter-126 (parallel to cotangent-vanishing analogist)

- **What it looks like**: The iter-125 progress-critic recommended a mathlib-analogist consult on filtered-colim-of-localizations infrastructure as **prerequisite** for the iter-128 M1.b close exit. That consult is currently on no iteration's plan. Iter-126 already has 5 subagents; adding one more analogist costs one parallel dispatch slot but lets the iter-128 close-vs-excise decision be informed by actual filtered-colim feasibility evidence.
- **Why it might be cheaper or sounder**: Either the analogist returns "filtered-colim-of-localizations is well-supported in Mathlib" (tilting iter-128 toward close, with realistic LOC budget), or "no clean Mathlib infra exists" (tilting iter-128 toward excise with strong evidence). Currently iter-128 will be a "decision iter" with no new evidence — same evidence base as today.
- **What the current strategy may have rejected**: The plan-agent's stated reason for not pulling this forward is implicit: "iter-126 already has 5 subagents; the analogist scope is genuinely large." But the cotangent-vanishing analogist's scope is genuinely larger (4 sub-pieces vs. 1) and the plan-agent pulled *that* forward — so the "too many subagents" reason is inconsistent.
- **Severity of the omission**: **minor-to-major** — depends on whether the project commits to one M1.b exit in advance (then no consult needed for excise) or genuinely wants iter-128 to be a decision iter (then consult is needed and should be on iter-126 or iter-127).

### Alternative: Move the M2.a "scaffold" out of `.lean` into the blueprint + analogies

- **What it looks like**: Instead of creating `AlgebraicJacobian/RigidityKbar.lean` with a `theorem rigidity_over_kbar ... := sorry` body (adding a sorry to the tree under a "zero sorry" directive), record the C.2.b reduction + C.2.c dichotomy as a fully detailed proof sketch in `blueprint/src/chapters/RigidityKbar.tex` (already created iter-126) and `analogies/cotangent-vanishing-pile.md` (about to be written iter-126). Then when the cotangent-vanishing pile lands (iter-129–137 per the table), the M2.a declaration is *introduced for the first time as a closed theorem*, not as a sorry-scaffold.
- **Why it might be cheaper or sounder**: Avoids the regression on the project's sorry count under the iter-121 directive. Avoids the agent-classification confusion (refactor vs prover). The C.2.b/c reduction prose belongs in the blueprint anyway. The actual `.lean` declaration is then created in the iter that closes it — one iter, one closed theorem, no scaffold-then-fill churn.
- **What the current strategy may have rejected**: The strategy's "scaffolding is good for forcing concrete API design" intuition has merit, but the scaffold here has *no consumers yet* (M2.b is iter-127, and even M2.b will just call `rigidity_over_kbar`'s name). API design without a consumer is just typing.
- **Severity of the omission**: **major** — directly contradicts the iter-121 "zero inline sorry" end-state directive by adding a sorry now in exchange for documentation that could live elsewhere.

---

## Sunk-cost flags

- `"M1 is parked, not abandoned. Why M1 is parked, not abandoned. The residual bijectivity claim has an explicit ~130–210 LOC closure recipe documented in task_results/AlgebraicJacobian_Differentials.lean.md ..."` — **Why this is sunk-cost**: the framing preserves M1 by emphasizing recipe-completeness, when the substantive question is "does closing M1.b advance the protected goal or produce a Mathlib PR?" The honest answer is **no** to both (M1.d is the PR candidate and is already closed; M1.b has zero in-tree consumers). **Recommendation**: rewrite as "M1 close-or-excise is a one-way door. The recipe exists; the closure produces neither a downstream consumer nor a Mathlib PR candidate beyond M1.d-already-closed. Excise is the shortest path to a clean tree; close is the shortest path to additional unconsumed project-local infrastructure."

- `"deferring to iter-128 with user opportunity to weigh in via USER_HINTS.md if desired before then"` — **Why this is sunk-cost-adjacent**: "iter-128 decision iter" with no new evidence collection planned between now and then makes iter-128 a label-change with no underlying change. **Recommendation**: either (i) collect the M1.b-prerequisite analogist evidence in iter-126 or iter-127 to make iter-128 a *decision based on new evidence*, or (ii) commit the decision now based on the analysis already in hand.

---

## Prerequisite verification

Spot-checked via `lean_loogle` / `lean_leansearch` against the strategy's claimed verifications:

- `Algebra.FormallyUnramified.of_isLocalization`: **VERIFIED** (`Mathlib.RingTheory.Unramified.Basic`).
- `KaehlerDifferential.exact_mapBaseChange_map`: **VERIFIED** (`Mathlib.RingTheory.Kaehler.Basic`).
- `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen`: **VERIFIED** (`Mathlib.AlgebraicGeometry.AffineScheme`).
- `IsLocalization.of_le`: **VERIFIED** (`Mathlib.RingTheory.Localization.Defs`).
- Cotangent-vanishing pile components (`AbelianVariety.cotangent_trivial`, `GroupScheme.Omega_trivial`, `AlgebraicGeometry.AbelianVariety.constant_of_P1_map`): **MISSING** — no nearby hits; PHANTOM status confirmed.
- `geomIrred.exists_kalg_pt`: **MISSING** — `Algebra.IsGeometricallyReduced` exists but no rational-point-witness lemma; PHANTOM status confirmed.
- Adjacent: `Algebra.FormallyEtale.subsingleton_h1Cotangent` (`Mathlib.RingTheory.Etale.Basic`) — exists; potential leverage for the optional M4 converse-with-extra-hypotheses milestone.

---

## Must-fix-this-iter

- **Route M1**: CHALLENGE — strategy should either (a) commit in iter-126 to excise at iter-127 or iter-128 (the analysis already favors excise: zero consumers; the extractable PR M1.d is independent of M1.b), OR (b) dispatch the prerequisite filtered-colim analogist in iter-126 in parallel with the cotangent-vanishing analogist so iter-128 is a decision *based on new evidence*. "Defer to iter-128 to decide later" with no new evidence collection between now and then is sunk-cost-adjacent.
- **Route M2.a**: CHALLENGE — the iter-126 scaffold deliverable conflates "refactor adds a named declaration with sorry body" (correct as documented in plan + strategy) with "the body around the sorry contains real C.2.b reduction + C.2.c dichotomy work" (substantive prover work). Pick one: (i) scaffold-with-bare-sorry → label correctly as a 1-line refactor and move the C.2.b/c prose to `blueprint/src/chapters/RigidityKbar.tex` (already created); (ii) substantive body work → relabel as a **prover** dispatch and revise the LOC estimate from ~50 to 150–300. **Preferred (per the iter-121 "zero inline sorry" end-state)**: drop the scaffold entirely and introduce `rigidity_over_kbar` as a *closed* theorem in the iter that closes its dependency (the cotangent-vanishing pile), not as a sorry-scaffold today.
- **Route M2 effort estimate**: CHALLENGE — the shared cotangent-vanishing pile window was tightened 10–20 → 8–12 iter on the rationale "iter-126 analogist consult lands scoping 4 iters earlier." Honest scoping-time-saved-as-build-time conversion is ≤1:1, not 4 iters saved on a 4-iter scoping event. Revise the lower bound to **10–14 iter pending the analogist's actual report**.
- **Alternative (direct over-k rigidity)**: major — strategy ignored sequencing implications. The iter-126 cotangent-vanishing analogist is being dispatched **before** the over-k-vs-over-`k̄` strategic question is resolved with the user. Planner must either (i) resolve the question this iter by surfacing it via a direct user prompt (not via deferred TO_USER.md), or (ii) explicitly direct the analogist to scope **both** variants so its output isn't redone.
- **Alternative (move M2.a scaffold to blueprint + analogies)**: major — directly contradicts the iter-121 "zero inline sorry" directive by adding a new sorry in exchange for documentation that has a non-`.lean` home already.

---

## Overall verdict

The strategy has substantially converged from prior iterations and the iter-125 critic's CHALLENGES are largely addressed (sunk-cost framing on M1 has been narrowed to the iter-128 hard trigger; double-counting collapsed; iter-ranges honest; M2.a deliverable correctly reframed as scaffold). The mathematical content is sound: the Brauer–Severi `C(k) = ∅` arm via vacuity + the `C(k) ≠ ∅` arm via rigidity is faithful to the protected signature, and the route to `nonempty_jacobianWitness` is correct in principle.

**But the iter-126 plan has two structural decisions that a fresh mathematician would flag as drift from the stated end-state**:

1. **Adding a sorry to "scaffold" M2.a** while under a "zero inline sorry" directive, when the same documentation can live in the existing blueprint chapter (`RigidityKbar.tex`) and analogies note (`cotangent-vanishing-pile.md`). The scaffold's only function is forward-looking API design with no current consumer; that's blueprint work, not Lean work.
2. **Deferring the M1 close-vs-excise decision to iter-128 without collecting new evidence in between**. The plan-agent's own data already favors excise (zero consumers, M1.d-PR-independent); the deferral is indistinguishable from indefinite parking under a different label.

These are not fatal: the routes are sound and the math is real. But they read as the *kind* of sequencing concession that compounds — two consecutive plan-phase-only iters that produce no closed sorries and one new sorry sets a pattern. The plan-agent should answer the four directive questions with sharper commitments: **commit now to the M1 exit, commit now to the M2.a scaffold's true classification, resolve the over-k-vs-over-`k̄` question with the user before the analogist runs**, and only then proceed.

A fresh mathematician's overall: **approve the milestones M1/M2/M3, approve the genus case-split, approve the Brauer–Severi handling — but require the iter-126 plan-agent to address the four issues above before committing the iter's actions.**

---

`iter126: CHALLENGE — 4 routes audited, 3 CHALLENGE verdicts + 2 major alternatives + 1 SOUND verdict.`

Report: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/task_results/strategy-critic-iter126.md`
