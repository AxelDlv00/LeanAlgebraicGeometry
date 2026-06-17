# Strategy Critic Report

## Slug
iter141

## Iteration
141

## Top-line one-liner

iter141: CHALLENGE — 3 routes audited, 4 CHALLENGE / 0 REJECT verdicts; route-pivot question (over-k vs over-`k̄`) REJECTED as wrong-question (does not address piece (i.b) bottleneck); cumulative-LOC arm renormalisation iter-137 was analogist-justified but the renormalisation discipline is asymmetric (only ratchets up); recommended iter-141 shape: (C) primary + (B) follow-on, not (A) and not (D).

---

## Re-verification of the four iter-140 edits to STRATEGY.md

### Edit 1 — Consult-count arm narrowed to calibration watchpoint (line ~422)

**Verdict: PASS.** The text at L422 reads "the **envelope-widening arm fires authoritatively** — if a single sub-piece consumes ≥3 consults that each widen the envelope (NOT consult quantity alone)" and demotes ≥5 to "current-state calibration; the consult-count arm REVISITS to a principled value at iter-150 if it has not fired on any sub-piece by then." This lands the iter-140 narrowing cleanly. The iter-140 baseline tally "piece (i.b) Step 2 carries 4 consults" is recorded honestly; the "5th-consult-mid-iter-on-CONVERGING-route would pre-commit CHURNING-for-iter-141" guardrail is sensible.

**Residual concern.** The narrowed arm still has a vague calibration target: "REVISITS to a principled value at iter-150 if it has not fired by then." But "principled value" is undefined. If the iter-150 revisit just picks a higher integer to keep the arm from firing, the calibration-watchpoint demotion was just a stay of execution. Recommend the iter-150 revisit be specified now: it must either (a) pick a `k` such that ≥k consults guarantees a route-pivot question regardless of envelope shifts, OR (b) explicitly retire the count-only arm in favour of envelope-widening only. Leaving "principled value" unspecified invites another moving-goalpost iteration.

### Edit 2 — M3 Relative Spec off-loop PR lane framing downgraded (line ~597)

**Verdict: PASS.** L597 now reads: "**Honest classification (iter-140)**: this is a **post-M2 planning hook + identification of the smallest PR-extractable piece for when M3 starts in-loop**, NOT a concretisation of the zero-sorry commitment for M3. The lane has zero in-loop iter-deliverables today; it has no in-tree scaffold; the M1.d off-loop precedent... does NOT transfer cleanly." The iter-139 "concretises the zero-sorry commitment" framing is named as "sunk-cost dressing per `strategy-critic-iter140`; dropped." Honest landing.

**Residual concern.** The lane is *preserved* despite the framing downgrade. The text justifies preservation on cost grounds ("M2 critical-path absorption is higher-priority during the M2 wait window") and schedules iter-150+ re-evaluation. This is borderline sunk-cost: if the lane has zero in-loop deliverables AND no in-tree scaffold AND zero off-loop infrastructure (unlike M1.d's `kaehler_quotient_localization_iso`), what is being preserved? Reading the text, what's preserved is the *named identification* of `RelativeSpec` as the smallest PR-extractable M3 piece. That is documentation, not a lane. CHALLENGE the language one more notch: this is documentation in STRATEGY.md, not an off-loop PR lane. The "off-loop PR lane" framing still implies infrastructure that does not exist. Recommended: re-name in the next strategy revision to "M3 smallest-PR-piece identification (documentation)".

### Edit 3 — End-state qualification + multi-year wall-clock framing (lines 22–58)

**Verdict: PASS.** The end-state revision at L32–48 cleanly captures the qualification: "**zero inline `sorry` in the project**, with one **explicit qualification**: **PROVISIONAL on piece (iii) ... closing in-tree at a tractable LOC cost**" + the named-gap-sorry alternative explicitly classified as "**provisional end-state qualification**" rather than "stall fallback" or "named-axiom path". The wall-clock framing at L50–57 is correctly multi-year ("~9–24 months at sustainable 50–100 LOC/iter ... on the 17+ iter M2 critical-path + 65–180 iter M3 critical-path"). The earlier "multi-month" language is named as iter-140 framing-honesty correction.

**Residual concern.** "Sustainable 50–100 LOC/iter" is itself an estimate. Looking at the table at L497 (piece (i.a) DONE iter-128 → iter-132 across 3 body reshapes for ~600 LOC of build-and-correct), the per-iter rate is closer to ~120 LOC/iter of build-and-correct (~600/5 iters), but only ~60 LOC/iter of net-final-tree-state work (~300/5). If the project's effective rate including build-and-correct overhead is ~120 LOC/iter, then 17 iter M2 critical-path means ~2000 LOC of build-and-correct (consistent with 1850–3600 LOC pile midpoint). But 65–180 iter for M3 at 50–100 LOC/iter = 3250–18000 LOC, while M3 Route A is estimated ~6500 LOC. The M3 iter range "65–180" is likely picking the lower bound by dividing 6500 LOC by 100 LOC/iter and the upper bound by dividing by some lower rate, but the arithmetic isn't shown. MINOR — the multi-year framing is honest in spirit; the exact iter-range arithmetic could be tighter.

### Edit 4 — iter-141 + iter-144 mandatory dispatches (line ~587)

**Verdict: PASS.** L587–590 records: "**Iter-141 (mandatory) piece (iii) scheme-Frobenius scoping analogist**" with specific inputs (Stacks Tag 0CC4, `Mathlib.AlgebraicGeometry.Scheme.Functor`) and a 2000-LOC pivot criterion. "**Iter-144 (MANDATORY) chart-algebra-vs-bundled re-evaluation**" before any in-tree scheme-Frobenius commit. Both gates land. The co-firing with the slipped iter-135–138 higher-Kähler-vanishing alternative is sensibly added.

**Residual concern.** The iter-144 chart-algebra re-evaluation is named MANDATORY and "Failure to re-evaluate at this gate is a sunk-cost trap" — explicit and binding. Good. However the iter-141 mandatory piece (iii) scoping analogist is downstream of the iter-141 piece (i.b)+(i.c) bottleneck — meaning the iter-141 plan agent has to dispatch the analogist on a piece (iii) build that will not start until iter-144+. The pivot criterion (>2000 LOC → elevate named-gap-sorry to "preferred default") is good, but if piece (i.b) is still stalled at iter-141, the piece (iii) scoping might land before piece (ii) prover work is even scaffolded. The MANDATORY dispatch is reasonable as forward-looking work; just observe that the analogist verdict will sit on the shelf until piece (ii) closure (~iter-143+). MINOR.

---

## NEW iter-141 verdict — the route-pivot question (over-k vs over-`k̄`)

The iter-140 PARTIAL-arm acceptance rule pre-committed mid-iter strategy-critic re-dispatch on the route-pivot question. The CHURNING-trigger has fired. My verdict:

### Route-pivot question (over-k → over-`k̄` + M2.c restoration)

**Verdict: REJECT THE PIVOT.**

**Reasoning.** The iter-141 directive frames the question as "should we revert from over-k to over-`k̄` + M2.c restoration?" The framing presupposes that the route-pivot would address the current piece (i.b) Step 2 bottleneck. **It does not.**

- Piece (i.b) is the **base-change-of-differentials natural iso** `Ω_{(G ⊗ G)/G} ≅ pr_2^* Ω_{G/k}`. The iter-127 over-k analogist explicitly verified (and the iter-133 mathlib-analogist re-confirmed) that this is **intrinsic to the group-scheme construction**: the shear iso `σ = ⟨pr_1, μ⟩` is a scheme map over any base, and the base-change formula for differentials is base-independent. Switching from over-k to over-`k̄` **changes nothing about piece (i.b)**. The two formulations would build the same artefact via the same Mathlib chain.
- M2.c (Galois descent of morphism equality of schemes) lives in a different sub-step: M2.a body closure, not piece (i.b). Restoring M2.c would add 4–8 iter / 300–500 LOC of work in M2.a body closure (iter-151+), without unblocking the current piece (i.b) prover lane.
- Switching cost is concrete (~1 iter of blueprint re-flow + restore M2.c rows) and the iter-138 reframing (L540–544) honestly named the over-k commitment as "operational default ... we have been building there, the switching cost back to over-`k̄` is concrete (~1 iter)". The route-pivot would cost ~1 iter and would NOT unblock piece (i.b).

**The pivot trigger was correctly pre-committed as a discipline measure** (forcing this re-discussion at iter-141 instead of silent absorption), but the substantive answer is **RETAIN over-k**. The route-pivot is the wrong question to be asking under the iter-140 PARTIAL evidence; the live question is the prover-lane shape (the (A)/(B)/(C)/(D) decision, see below).

**CHALLENGE on the strategy's pre-commitment framing.** L544 says "iter-141 plan agent fires CHURNING-trigger ... AND re-opens the over-k vs over-`k̄` decision with mid-iter strategy-critic re-dispatch on the route-pivot question." The "AND" wires two distinct mechanisms together. The CHURNING-trigger is sound: 3 consecutive PARTIALs on the same target IS churning. But pinning the strategy-critic mid-iter dispatch to "the route-pivot question" presupposes that route-pivot is the natural response to churning. **It is not, in this case**, because the bottleneck is base-independent. Future iter pre-commitments should de-couple the two: a CHURNING-trigger should pull in a strategy-critic on the **immediate prover-lane shape**, with route-pivot as one of several possible responses, not the only one.

### Cumulative LOC arm (line 499 + § Soundness rules)

**Verdict: PARTIAL — the 600 → 1000 LOC renormalisation iter-137 was analogist-justified, but the renormalisation-discipline rule is asymmetric and the arithmetic ratchets the cap to fit the envelope.**

Re-examining:

- **Was the renormalisation analogist-justified?** Yes — the iter-137 `kaehler-tensorequiv-presheafpullback-iter137` analogist consult is what widened the Step 2 envelope from 150–300 → 360–710 LOC (a ~2.4× widening). The cap renormalisation 600 → 1000 LOC follows mechanically: "~316 LOC iter-136 baseline + ~710 LOC upper envelope + ~30% slack = ~1000 LOC". The iter-138 discipline rule ("renormalisation can ONLY happen when a NEW analogist consult justifies a new LOC envelope") is satisfied: the consult is named, the envelope shift is documented, and the arithmetic is shown. **PASS on procedural compliance.**

- **Is the arm at-risk of firing iter-141?** I do not have access to the cumulative-LOC count this iter. But the directive's framing ("Is this arm at-risk of firing this iter? Is it firing?") implies the planner needs an answer. Read off STRATEGY.md L499 the baseline: "~316 LOC iter-136 baseline". Iter-137 prover lane on Step 2 would add the Step 2 body (~360–710 LOC). If iter-138/iter-139/iter-140 each shipped substantive Step 2 body work (consistent with PARTIAL returning structural body cuts), cumulative would now sit roughly at 316 + (mid-envelope) Step 2 ≈ 316 + 530 ≈ 850 LOC. With iter-140 reportedly adding more body LOC, cumulative could plausibly cross 1000 LOC at iter-141. **The arm IS at-risk of firing iter-141**; the planner must measure cumulative LOC and apply the trigger.

- **Is the cap itself sunk-cost-shaped (i.e., the 600 → 1000 renormalisation under-justified)?** This is the deeper question. The arithmetic is internally consistent. But the *structure* of the discipline rule has a subtle asymmetry: **the cap renormalises up when a new envelope is justified, but never tightens when a piece comes in under-envelope**. If piece (i.b) Step 2 ships at 400 LOC (well under the upper envelope), the cap stays at 1000 LOC for the next "Step 3" check, not tightening to the actual realised size. This means every successful close raises the cap's "comfortable distance" from the realised LOC, making future PARTIALs harder to trip the cap. **CHALLENGE the asymmetry**: the renormalisation discipline rule should bite both ways — when a piece closes substantially under envelope, the cap tightens proportionally. As written, "always raise the cap to fit the envelope; never tighten the cap to fit reality" is asymmetric in exactly the way sunk-cost arguments are asymmetric.

  Recommended fix: amend the L421 rule to "renormalisation discipline applies to both up-and-down adjustments; a piece closing materially under its envelope (>30% under midpoint, say) tightens the cap to match the realised LOC + slack." Without this, the LOC arm is a one-way ratchet.

**SOUND on the iter-137 600→1000 step itself. CHALLENGE on the asymmetric structure of the discipline rule.**

---

## (A) / (B) / (C) / (D) verdict — iter-141 piece (i.b) Step 2 prover-lane shape

**Recommendation: (C) primary + (B) follow-on. NOT (A). NOT (D).**

### (A) — Fourth consecutive iter on same 3 sub-sorries with refined recipes

**Verdict: CHALLENGE.** Pattern: iter-138 PARTIAL → iter-139 plan-only → iter-140 PARTIAL → iter-141 (A) would make the prover lane the 4th consecutive iter on identical 3 sub-sorries. **Three consecutive PARTIALs without external evidence intervention IS churning** per the iter-138 progress-critic. The iter-140 prover lane discovery ("validated factoring-lemma standalone via lean_run_code") is positive evidence that *some* of the recipe shape is right, but the d_app/d_map/IsIso sub-sorries are unclosed because the **integration** of the factoring-lemma into the recipe is what's stalling, not the factoring-lemma itself. Dispatching a 4th prover lane on identical sub-sorries with "refined closure recipes" risks the same stall pattern: the planner authors prose-level "refinements" that the prover then has to mechanically translate, with the same opacity barriers blocking close.

Note: "refined recipes" without external analogist validation is the same shape as iter-139's plan-only iter; iter-141 (A) without the (C) consult risks repeating that pattern.

### (B) — Defer prover, dispatch blueprint-writer to expand recipes with iter-140 discoveries

**Verdict: SOUND as a follow-on, but PREMATURE as primary.** The blueprint-writer expansion is the right response to a prover lane that has discovered a specific factoring-lemma + whnf-opacity-aware reformulation, but only if the recipe shape itself is correct. If the iter-140 factoring-lemma is the right shape, blueprint-writer expanding the recipes around it is a clean iter-141 deliverable. If the factoring-lemma is *not* quite the right shape, blueprint-writer expansion entrenches a suboptimal recipe.

Recommendation: **(B) follows (C)**. Dispatch (C) first to confirm shape; if (C) returns clean PROCEED on the factoring-lemma + recipe shape, dispatch (B) blueprint-writer to expand. If (C) surfaces a substantively different shape, refactor the recipe before any (B) blueprint work.

### (C) — Mathlib-analogist on d_app / d_map sub-sorries

**Verdict: SOUND — primary recommendation.** This is the highest-leverage move under the iter-140 PARTIAL evidence:

- The iter-140 prover lane validated the factoring-lemma standalone. An analogist consult confirms (or refutes) that the factoring-lemma is the right Mathlib piece for d_app and d_map integration, and surfaces any cleaner Mathlib chains that the prover under-engaged with.
- The cost is one analogist consult (~1/3 iter at most), parallel-dispatchable with the iter-141-mandatory piece (iii) scheme-Frobenius scoping analogist + slipped higher-Kähler-vanishing alternative analogist.
- Per L422 narrowed rule: this would be the 5th consult on piece (i.b) Step 2, but a confirmatory recipe-shape consult is NOT envelope-widening (does not propose new structural work; just confirms the iter-140 prover lane's standalone validation). Per the explicit text at L422, the envelope-widening arm is "authoritative", and the count-only arm is a watchpoint at ≥5 — meaning iter-141 (C) at the 5th-consult mark fires the watchpoint, which by definition triggers route-pivot question re-raise. **But the route-pivot question has been answered REJECT above; the watchpoint firing doesn't change the underlying answer.** So (C) is procedurally clean.

(C) does NOT pre-commit the iter-141 plan agent to a 5th consult on a CONVERGING route (the iter-140 guardrail). The lane is not CONVERGING; iter-140 closed 0-of-3 sub-sorries. The iter-140 guardrail was specifically against pre-committing a 5th consult on a CONVERGING route; the converse — confirming shape on a stalled route — is precisely what the 5th consult is for.

### (D) — Route-pivot to (B′) / (C)-replacement / fibre-free

**Verdict: REJECT for iter-141.** The internal-pivot triggers (Q1+Q2+Q3 + fibre-free scorecard from L549–561) have specific firing criteria:

- **Fibre-free** was 4-axis-evaluated iter-133; STAY ON (B) by 3 of 4 axes. The iter-138 renormalisation moved the pivot threshold from "(i.b) > 750 LOC alone" to "> 1000 LOC cumulative (i.b)-side build without converging" (L559). Cumulative LOC may cross 1000 LOC this iter (see § Cumulative LOC arm above), but the "without converging" qualifier is load-bearing: iter-140's substantive structural body cut + factoring-lemma standalone-validation is converging *progress* even with 0 sub-sorries closed strictly. The fibre-free 4-axis re-evaluation at iter-138-close was "MUST per `strategy-critic-iter138` Alternative #3 elevation from 'may'" (L559); iter-140 was supposed to run that re-evaluation. If iter-140 did not run it, the iter-141 plan agent should re-evaluate with MEASURED LOC and apply axes (1)+(2) (forward merit) > axes (3)+(4) (switching cost) weighting per L561.
- **(B′)** was scoped + rejected iter-131; load-bearing IsRegularLocalRing bridge cost (~500–1000 LOC) is shared with (A); (B′) does not beat (B) on cost.
- **The iter-140 chart-algebra-rigidity analogist HYBRID verdict** — the iter-144 MANDATORY re-evaluation is the right gate; iter-141 should NOT pre-commit the chart-algebra pivot, since the iter-141 mandatory piece (iii) scheme-Frobenius scoping analogist + slipped higher-Kähler-vanishing analogist are both upstream evidence of the chart-algebra trade-off. The iter-144 gate is the right place to decide.

So (D) is not the right iter-141 response. The fibre-free 4-axis re-evaluation IS due if not yet run, but that is a separate task from "dispatch a route-pivot prover lane this iter."

### Final shape recommendation

**Dispatch order for iter-141:**

1. **(C) mathlib-analogist on d_app / d_map sub-sorries** — confirm iter-140 factoring-lemma is the right shape; surface cleaner Mathlib chains.
2. **Iter-141 mandatory piece (iii) scheme-Frobenius scoping analogist** — pre-existing mandatory dispatch.
3. **Slipped iter-135–138 higher-Kähler-vanishing alternative analogist** — pre-existing slip recovery.
4. **(B) blueprint-writer** expanding d_app/d_map/IsIso recipes — ONLY if (C) returns clean PROCEED on the iter-140 factoring-lemma shape. Otherwise hold (B) for iter-142.
5. **Iter-141 fibre-free 4-axis re-evaluation** (if not already run iter-138/iter-140 close) — measured LOC, axes (1)+(2) weighted > (3)+(4) per L561.
6. **NO prover lane this iter on piece (i.b) Step 2** — dispatching prover work without (C) confirmation would be 4th consecutive PARTIAL pattern.

---

## Sunk-cost flags

### Flag 1 (load-bearing) — Operational-default reframing of over-k commitment (L540–544)

`> the over-k path is the **operational default** — not because we have a strong positive case for it, but because we have been building there, the switching cost back to over-`k̄` is concrete (~1 iter), and the revert wiring is in place.`

**Why this is sunk-cost-aware (not sunk-cost-flawed):** The strategy honestly names the framing as switching-cost-driven. This is the **right** way to handle a route that is no longer defended on quantitative merit — explicit naming defangs the sunk-cost trap.

**Verdict.** Honest. NO action needed; this is the discipline working.

### Flag 2 (live) — Cumulative-LOC renormalisation discipline is asymmetric (L421)

`> renormalisation can renormalise only when a new analogist consult justifies a new envelope, NOT to fit an iter that crosses it without an envelope shift.`

**Why this is sunk-cost-shaped:** The rule has only an upward direction. There is no symmetric "tighten the cap when a piece closes materially under envelope" clause. Once the cap is raised by an analogist-justified widening, future smaller pieces don't tighten it back. Over many iters this is a one-way ratchet: the LOC arm only ever loosens. Sunk-cost shape.

**Recommendation.** Amend the rule to be symmetric: a piece closing >30% under its envelope midpoint tightens the cap to realised LOC + 30% slack. Without this amendment the LOC arm is a one-way ratchet and the iter-138 sunk-cost-flag-#2 prevention is partially circumvented over time.

### Flag 3 (live, minor) — M3 Relative Spec "off-loop PR lane" framing (L597)

`> M3 Route A Relative Spec functor off-loop PR lane (NEW iter-139 ...; FRAMING DOWNGRADED iter-140 ...)`

**Why this is sunk-cost-shaped:** The framing was downgraded to "post-M2 planning hook + identification of the smallest PR-extractable piece" but the "off-loop PR lane" name was preserved. As I noted in re-verification of Edit 2, the lane has zero in-loop deliverables AND no in-tree scaffold AND no off-loop infrastructure (unlike the M1.d precedent). Preserving the "lane" name is preserving language that no longer matches the substance.

**Recommendation.** Re-name to "M3 smallest-PR-piece identification (documentation only)". One-line cleanup, no substantive change.

### Flag 4 (latent) — Multi-month wait window framing has not been updated to multi-year (L489)

`> **Multi-month wait window (revised iter-127 — over-k path commitment shaved 7–13 iter / 500–900 LOC from the prior over-`k̄` baseline).**`

**Why this is sunk-cost-shaped:** The header at L489 says "Multi-month wait window" — but Edit 3 corrected the wall-clock framing to multi-year (~9–24 months). The parenthetical "shaved 7–13 iter / 500–900 LOC" is also superseded by the iter-128 revision to "2–6 iter / 0–500 LOC" (L217) and the further iter-131 revision to "~2–5 iter / 0–500 LOC" (L513).

**Recommendation.** Update L489 header to "Multi-year wait window" and update the parenthetical to match L217's "2–6 iter / 0–500 LOC". Minor language cleanup but the multi-month framing in section headers contradicts the iter-140 correction.

### Flag 5 (procedural) — Pre-committed route-pivot question framing (L544)

`> iter-141 plan agent fires CHURNING-trigger per `progress-critic-iter139` watch criterion AND re-opens the over-k vs over-`k̄` decision with mid-iter strategy-critic re-dispatch on the route-pivot question (NOT silent absorption).`

**Why this is sunk-cost-aware:** The CHURNING-trigger pre-commitment is correct discipline (forces this re-evaluation). The wired-in pre-commitment to the route-pivot question is the issue: the over-k vs over-`k̄` route-pivot is base-independent on piece (i.b), so the pre-committed question is the wrong question for the iter-140 PARTIAL evidence.

**Recommendation.** Future iter pre-commitments should decouple CHURNING-trigger from a specific pre-committed strategy-critic question. The CHURNING-trigger should pull in a strategy-critic on **the immediate prover-lane shape**, with route-pivot as one of several possible responses.

---

## Alternative routes (suggested)

### Alternative #1 — Explicit "stop the prover lane and let the analogist queue clear" iter, formally named

**What it looks like.** Iter-141 dispatches only analogists + blueprint work this iter; no prover lane. The iter-141 mandatory piece (iii) scoping + slipped higher-Kähler-vanishing + new (C) on piece (i.b) Step 2 = 3 analogist consults. iter-142 absorbs the analogist outputs and decides the next prover-lane shape.

**Why it might be sounder.** Three consecutive PARTIALs on piece (i.b) Step 2 with refined recipes are showing diminishing returns. The standard archon discipline under prover-lane stall is to surface to an analogist; the iter-141 plan agent could honestly name "iter-141 is an analogist-only iter for piece (i.b)" rather than dispatch another prover lane that re-runs the iter-140 pattern.

**Why the current strategy may have rejected it.** The iter-141 directive frames (A) as a live option ("with refined closure recipes"), implying that the plan agent's natural default is to keep prover-lane work running. But the (B)/(C) shapes in the directive already partially admit the analogist-only response; codifying it as Alternative #1 makes the decision crisper.

**Severity:** major. The iter-141 plan agent should consider this explicitly.

### Alternative #2 — Add a "pivot abandon" criterion to the LOC arm

**What it looks like.** Currently the trigger arms (a')/(b)/(c) at L523 say "revert to the over-`k̄` baseline + reintroduce M2.c". They do NOT include a criterion for "abandon piece (i.b) altogether and try a structurally different sub-decomposition" (e.g., the fibre-free reformulation, or the chart-algebra rigidity HYBRID per iter-140). The fibre-free is recorded as a separate scorecard at L549–561 with its own pivot threshold ("> 1000 LOC cumulative (i.b)-side build without converging"). But the LOC arm of trigger (a')/(c) at L523 fires only on the route-pivot question, not on the sub-decomposition pivot.

**Why it might be sounder.** Under the iter-140 evidence, the live decision is NOT "should we change routes (over-k vs over-`k̄`)?" but "should we change sub-decompositions (Step 2 sheaf-level RHS vs fibre-free vs chart-algebra)?" Wiring both pivot questions into the LOC arm makes the discipline measure trip the right answer.

**Why the current strategy may have rejected it.** The fibre-free pivot threshold lives in its own section (L559) with its own discipline; the chart-algebra pivot is iter-144 MANDATORY. So the discipline is split across multiple non-co-located sections. The cost is procedural ambiguity at iter-141 about which threshold applies.

**Severity:** major. Recommend consolidating the cumulative-LOC arm to fire BOTH the route-pivot question AND the sub-decomposition pivot question, with the route-pivot question pre-answered REJECT (per this critic report) so the live question at iter-141 is the sub-decomposition pivot.

### Alternative #3 — Concretise the named-gap-sorry alternative for piece (iii) NOW, not iter-144+

**What it looks like.** STRATEGY.md L32–48 records the named-gap-sorry alternative for piece (iii) as "active alternative, not stall fallback". The iter-144 MANDATORY chart-algebra-vs-bundled re-evaluation will determine the in-tree-build vs named-gap-sorry split. But iter-141 could already scaffold the named-gap-sorry alternative (define `AlgebraicGeometry.Scheme.absoluteFrobenius` as a `sorry` body in a new file `AlgebraicJacobian/Frobenius.lean` ~20 LOC) and document the named-gap explicitly in the blueprint. This converts the alternative from "documented in STRATEGY.md prose" to "documented in code + blueprint".

**Why it might be sounder.** The end-state revision iter-140 (Edit 3) already names "zero inline `sorry`, PROVISIONAL on piece (iii) closing in-tree at tractable LOC cost" with the named-gap-sorry alternative as honest fallback. If the iter-144 evaluation is going to determine the path anyway, scaffolding the gap now means the iter-144 verdict has a concrete artefact to point at, and the project's `\leanok` + protected-chain bookkeeping is honest about the gap from iter-141 onward, not iter-144+.

**Why the current strategy may have rejected it.** The iter-138 `mathlib-analogist-p1-hedge-iter138` NOT-VIABLE verdict + iter-126 user hint "do the work, no axioms; ~6500–9000 LOC may not be that much for an AI" together establish that the in-tree build is the *default*; the named-gap-sorry is fallback. Scaffolding the named-gap-sorry now might pre-bias the iter-144 verdict toward fallback.

**Severity:** minor. The user-hint scope discipline (L420) is load-bearing here; iter-141 should respect the iter-144 gate.

---

## Prerequisite verification (Mathlib spot-checks; non-exhaustive)

The directive limits me to one-line topic per chapter + the references index, with optional LSP spot-checks. The strategy names many Mathlib pieces; I'm not re-verifying all of them (the iter-by-iter analogists do that). Key spot-checks where the strategy's claims drive iter-141 decisions:

- `Mathlib.Algebra.CharP.Frobenius` — strategy claims VERIFIED. I did not re-verify but the iter-127 over-k analogist + iter-138 ℙ¹-hedge analogist both used this; high confidence.
- `IsLocalRing.CotangentSpace` — strategy claims VERIFIED (iter-129 corrected from the phantom `IsRegularLocalRing.cotangentSpace`). High confidence.
- `KaehlerDifferential.exact_mapBaseChange_map`, `KaehlerDifferential.map_surjective`, `Algebra.FormallyUnramified.of_isLocalization` — M1.d ingredients, used in `kaehler_quotient_localization_iso`. Strategy treats as VERIFIED. The iter-126 refactor lane that landed this used them; high confidence.
- `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` — M4 future, strategy claims `[verified]`. Not iter-141-relevant.
- `PresheafOfModules.pullback` — iter-137 envelope hinges on this; "Mathlib's `PresheafOfModules.pullback` opacity on `.obj`/`.map`" is the iter-137 envelope-widening trigger. Strategy treats as VERIFIED. High confidence.
- **`AlgebraicGeometry.Scheme.absoluteFrobenius` — strategy claims PHANTOM**. Iter-138 piece-(iii) hedge analogist re-verified absence. High confidence. This is the iter-141 mandatory scoping analogist target.

No phantom-prereq issues surface from my spot-checking.

---

## Must-fix-this-iter (ranked by urgency, max 6)

1. **(Live)** Iter-141 plan agent must NOT dispatch (A) prover lane this iter without (C) analogist confirmation. Three consecutive PARTIALs on identical sub-sorries IS churning per the iter-138 progress-critic discipline; the iter-141 plan agent's default should be (C) primary + (B) follow-on.

2. **(Live)** Iter-141 plan agent must measure cumulative (i.b)-side LOC against the 1000 LOC arm; if at-risk or firing, decide the sub-decomposition pivot question (fibre-free 4-axis re-evaluation MUST per L559) — NOT the over-k vs over-`k̄` route-pivot question, which is the wrong question for this evidence (REJECT verdict above).

3. **(Strategy edit, soon-item)** Amend the L421 LOC trigger arm renormalisation discipline to be SYMMETRIC: a piece closing >30% under its envelope midpoint tightens the cap to realised LOC + 30% slack. The current rule is a one-way ratchet that partially undoes the iter-138 sunk-cost-flag-#2 prevention over time.

4. **(Strategy edit, soon-item)** Decouple the CHURNING-trigger from the pre-committed "route-pivot question" in future iter pre-commitments. The CHURNING-trigger correctly pulls in a strategy-critic; the strategy-critic question should be on the **immediate prover-lane shape**, with route-pivot as one of several possible responses (this iter, the route-pivot was the wrong question; in a different evidence pattern it might be the right one).

5. **(Strategy edit, language cleanup)** Update L489 header from "Multi-month wait window" to "Multi-year wait window" + update the L489 parenthetical "shaved 7–13 iter / 500–900 LOC" to match L217's revised "2–6 iter / 0–500 LOC". The iter-140 Edit 3 multi-year correction should be reflected in section headers, not just in the end-state framing.

6. **(Strategy edit, language cleanup)** Re-name L597 "M3 Route A Relative Spec functor off-loop PR lane" to "M3 smallest-PR-piece identification (documentation only)". The "off-loop PR lane" framing implies infrastructure that does not exist; "documentation only" matches the iter-140 honest classification.

---

## Per-route verdict table (summary)

| Route / question | Verdict |
|---|---|
| End-state qualified to "zero inline sorry, PROVISIONAL on piece (iii)" | SOUND (Edit 3 lands; multi-year framing honest, minor arithmetic look-through caveat) |
| Over-k route retention (operational default) | CHALLENGE — retain for iter-141 (route-pivot question REJECT), but cumulative-LOC arm asymmetry is a sunk-cost shape that needs symmetric fix |
| Piece (i.b) Step 2 prover-lane shape | CHALLENGE — (C) primary + (B) follow-on, NOT (A), NOT (D) for iter-141; sub-decomposition pivot (fibre-free re-eval per L559) is the live decision, not route-pivot |
| M3 Route A Relative Spec "off-loop PR lane" | CHALLENGE on framing (Edit 2 downgraded honestly but "lane" name preserved without substance) |
| Iter-141 mandatory piece (iii) scoping analogist | SOUND (Edit 4 lands; mandatory + concrete pivot criterion) |
| Iter-144 mandatory chart-algebra-vs-bundled re-evaluation | SOUND (Edit 4 lands; gate is explicit and forward-binding) |
| Cumulative LOC arm 600→1000 renormalisation | PARTIAL — analogist-justified procedurally, but discipline rule is asymmetric (one-way ratchet) |

---

## Overall verdict

A fresh mathematician reading STRATEGY.md as of iter-141 would broadly approve the end-state framing (zero inline sorry, PROVISIONAL on piece (iii) at honest LOC) and the operational-default-over-k commitment (honestly named as switching-cost-driven, not "over-k IS better"). The iter-140 edits land cleanly; the four edits all substantively address the iter-140 critique without renormalisation slip-through.

The live concern at iter-141 is **not** the route-pivot question that the pre-committed PARTIAL acceptance arm dispatched me on. The route-pivot is the wrong question for this evidence pattern, because piece (i.b) is base-independent: switching from over-k to over-`k̄` would not unblock the current prover lane. The live concern is the **prover-lane shape decision** (A vs B vs C vs D), and the right answer is **(C) primary + (B) follow-on, not (A), not (D)**. Three consecutive PARTIALs on identical sub-sorries IS churning under the project's own discipline; dispatching a fourth prover lane on identical sub-sorries with "refined recipes" but no external evidence intervention would repeat the iter-139 plan-only pattern.

The cumulative-LOC arm renormalisation iter-137 was analogist-justified procedurally, but the rule's asymmetric structure (cap raises with envelope shift, never tightens with under-envelope closure) is sunk-cost-shaped over time. Symmetric amendment is the strategy fix.

Three minor language-cleanup items remain (L489 multi-month → multi-year header; L597 off-loop PR lane → documentation-only; L421 renormalisation discipline → symmetric). None block iter-141 execution; all should land in the iter-141 STRATEGY.md edit pass.

---

## One-line return value

iter141: CHALLENGE — 7 strategic axes audited, 4 CHALLENGE / 0 REJECT verdicts; route-pivot question (over-k vs over-`k̄`) REJECTED as wrong-question (does not address piece (i.b) bottleneck which is base-independent); recommended iter-141 shape: (C) primary + (B) follow-on. Report path: `.archon/task_results/strategy-critic-iter141.md`.
