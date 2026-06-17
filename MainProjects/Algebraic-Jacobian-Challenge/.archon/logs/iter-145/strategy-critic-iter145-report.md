# Strategy-critic — iter-145 (fresh-context audit)

Slug: `iter145`. Scope: per-route SOUND / CHALLENGE / REJECT, with the iter-141 sunk-cost-shape audit re-run on iter-144's chart-algebra-pivot edits.

Read this audit: only `STRATEGY.md`, `references/summary.md`, and the 11 blueprint chapter heads.

---

## Headline verdicts

| Route / pre-committed question | Verdict |
|---|---|
| (1) Chart-algebra pivot internal consistency | **SOUND** — the pivot prose itself is honestly committed, but with one **CHALLENGE** on the in-tree disposition of bundled-route artefacts (Q7 below). |
| (2) Zero-sorry PROVISIONAL end-state under chart-algebra | **CHALLENGE** — gap inventory (§ "Mathlib gap inventory") does NOT list the new chart-algebra (α)+(β) Mathlib pieces that the pivot disposition introduces; the "zero-sorry preserved at the lower envelope" claim is not pinned to a fully named gap set. |
| (3) M2.a `df = 0` derivation chain | **CHALLENGE** — internal contradiction in the three-layer bullet (lines 442–445). The bullet says both "a global-section-vanishing argument on Ω_{C/k} follows from this chart-local fact + glueing" AND "Vanishing-of-global-section-of-Ω_{C/k} is NOT invoked." These can't both be true. |
| (4) M3 Route A commitment hygiene | **CHALLENGE (mild)** — surface-level honest (no PR-and-wait residue), but Mathlib-dependency list is incomplete. The iter-145 audit refresh dispatched in parallel must explicitly add the missing items (fppf topology, Picard pre-functor sheafification, flattening stratification as a standalone piece, coherent-sheaf-of-finite-type infrastructure). |
| (5) STRATEGY.md size | **SOUND (flagged)** — 666 lines vs ~250 bound; not load-bearing past iter-130-ish; compaction directive recommended for planner. |
| (6) Iter-150 over-k vs over-`k̄` guardrail | **CHALLENGE** — well-intentioned, but the question framing ("would the choice still be made?") is a soft trigger that defaults to "keep." Should be reframed as "What route is correct on current empirical data?" |
| (7) Reverse burden on ~600 LOC bundled-route Lean artefacts kept as "auditable record" | **CHALLENGE** — "auditable record" is a fig-leaf; git history is the real audit. Deletion is the iter-141-discipline-consistent call. |

---

## Q1 — Chart-algebra pivot internal consistency

**Verdict: SOUND on the prose-level commitment.**

§ "Iter-144 chart-algebra pivot — COMMITTED" (lines 607–618) and § "Iter-145+ chart-algebra obligations" (lines 620–625) read as a clean commitment. Specifically:

- Line 609: "PIVOT TO CHART-ALGEBRA."
- Line 611: piece (i.b) Step 2 d_app + IsIso + Main "DESCOPED from critical-path iter-145+. The named declarations remain in-tree (sorry-bodied) as auditable record of the bundled route; they are NOT iter-145+ prover targets under chart-algebra."
- Line 612: piece (i.c.1/2/3) "DESCOPED."
- Line 614: piece (iii) scheme-Frobenius "DESCOPED."

These are unambiguous commitments. There is no "parallel option" language; bundled-route artefacts are clearly removed from the critical path. The iter-141 anti-pattern of preserving the bundled framing as a silent option is, **at the prose level**, not recurring.

**However**: the *in-tree disposition* (sorry-bodied artefacts staying in the file) is itself a soft option-preservation. See Q7 below.

**Rebuttal-or-update item**: none required at the strategy prose level. (Disposition concern is logged as Q7 CHALLENGE separately.)

---

## Q2 — Zero-sorry PROVISIONAL end-state under chart-algebra

**Verdict: CHALLENGE.**

Line 616: "End-state PROVISIONAL relaxed: zero-sorry PROVISIONAL end-state preserved at the lower envelope under chart-algebra (no residual named-gap on piece (iii); chart-algebra route closes piece (iii) substantively at ring-level)."

Cross-check against § "Mathlib gap inventory (live, iter-127)" (lines 466–491):

- The inventory is dated **iter-127** and lists pre-pivot gaps.
- The iter-144 pivot introduces two new Mathlib helpers explicitly named at line 613 and line 442: chart-algebra **(α)** `Algebra.IsPushout`-from-affine-product helper (~80–150 LOC), and chart-algebra **(β)** per-chart translation-invariance argument (~150–300 LOC).
- Neither (α) nor (β) appears in the § "Mathlib gap inventory" list.
- Additionally, line 442's "(1) Char-0 chart-local derivation argument" depends on `Algebra.IsStandardSmoothOfRelativeDimension n k`-tractable charts being **simultaneously available for all affine charts** with **smooth-locally-free-omega**-style chart selection; the Lean tractability of this multi-chart simultaneous selection is not pinned to a gap entry.
- Line 443's "(2) Char-p Frobenius-iteration patch" depends on `RingHom.iterateFrobenius_comm` from `Mathlib.Algebra.CharP.Frobenius` composing with the chart-local argument; the composition itself (which is a new piece of glueing infrastructure) is not in the gap inventory.

The "zero-sorry preserved at the lower envelope" claim is not fully accounted for. Either (a) the new chart-algebra pieces are not Mathlib gaps but are bundled into the piece (ii) PIN-path-(b) envelope (~600–1050 LOC, line 613); or (b) they are real Mathlib gaps that need named entries. The strategy must clarify.

**Rebuttal-or-update items**:

1. § "Mathlib gap inventory" must be re-dated iter-145 and updated to list chart-algebra (α) and (β) explicitly, with each item's status (already-in-Mathlib / NEEDS_MATHLIB_GAP_FILL / bundled-into-piece-(ii)).
2. § "What ships unconditionally" should explicitly say "modulo the chart-algebra (α)+(β) helpers landing at the ~600–1050 LOC piece (ii) envelope" or similar — the end-state claim is incomplete without it.

---

## Q3 — M2.a `df = 0` derivation chain

**Verdict: CHALLENGE.**

The three-layer bullet on lines 441–445 has an **internal contradiction**:

- Line 442 (layer 1, char-0): "the derivation vanishes when restricted to constants and on the `n` cotangent generators (where it lands in `Γ(V, Ω_{V/k})`); **a global-section-vanishing argument on `Ω_{C/k}` follows from this chart-local fact + glueing**."
- Line 444 (layer 3): "**Vanishing-of-global-section-of-`Ω_{C/k}` is NOT invoked.** Specifically, `H^0(C, Ω_C) = 0` is a Serre-duality-flavored fact that the project's deferred piece (iv) would establish; under chart-algebra the argument is chart-local + Frobenius-iteration, with no global-cohomology-of-`Ω_C` step."

Layer 1 says the proof flows through "a global-section-vanishing argument on `Ω_{C/k}`" via glueing; layer 3 says vanishing of `H^0(C, Ω_C)` is NOT invoked. These statements name the same mathematical object — the global section module of `Ω_{C/k}` — yet assert opposite uses.

Mathematically, the classical Mumford rigidity argument **does** need `H^0(C, Ω_C) = 0` (over a genus-0 curve, equivalent via Serre duality to `H^1(C, O_C) = 0`, the definition of genus 0). Pullback of the n-dim cotangent at the identity of A to C gives a global section of `Ω_{C/k}^{⊕n}`, which vanishes iff `H^0(C, Ω_C) = 0`. The chart-algebra approach as described:

- Layer 1's "chart-local + glueing" sketch tacitly invokes a Čech-vanishing-style argument for `H^0(C, Ω_{C/k}^{⊕n})`. That is mathematically equivalent to `H^0(C, Ω_C) = 0` even if not invoked by name — a 2-chart Čech complex of a genus-0 curve computes that group.
- Layer 3 then disclaims using `H^0(C, Ω_C) = 0`. But the global-section-vanishing on `Ω_{C/k}` in layer 1 IS that fact, regardless of whether Serre duality is invoked as the named theorem.

The "without Serre duality" disclaimer is a name-of-theorem disclaimer, not a content disclaimer. The strategy is conflating "I do not call Serre duality the theorem" with "I do not use the fact `H^0(C, Ω_C) = 0`."

**This is a mathematical-soundness concern**, not just a prose concern. If chart-algebra genuinely closes piece (ii) without an `H^0(C, Ω_C)` vanishing input, the strategy needs to articulate what does the work — currently the bullet does not.

**Rebuttal-or-update items**:

1. The three-layer bullet must be rewritten to honestly disclose **what `H^0(C, Ω_C) = 0`-equivalent content is being invoked**, even if not via Serre duality. Candidate honest framings:
   - "We invoke `H^0(C, Ω_C) = 0` directly via a 2-chart Čech argument on `Ω_C`, not via Serre duality. The Čech argument is `O_{P^1}(-2)`-explicit on each branch of genus-0."
   - "We invoke a chart-pair Mayer–Vietoris-style argument that computes `H^0(C, Ω_C) = 0` from the (chart-local) Kähler data, avoiding the Serre duality NAMED THEOREM but using the same underlying cohomological vanishing."
   - "The chart-algebra (β) helper does NOT need `H^0(C, Ω_C) = 0`; instead it uses [some unnamed alternative]."
2. If the chart-algebra path turns out to **need** Čech-style `H^0(C, Ω_C) = 0` content, the gap inventory must list this as a sub-piece of the chart-algebra (β) helper, and the end-state claim ("zero-sorry preserved at the lower envelope") must be re-priced.
3. The `RigidityKbar.tex` blueprint mandatory iter-145 writer dispatch (line 622) must articulate this chain honestly; the current STRATEGY.md prose is not a blueprint-ready argument.

---

## Q4 — M3 Route A commitment hygiene

**Verdict: CHALLENGE (mild).**

Surface-level surveys (lines 247–356, 638–656) read honest: no "PR-and-wait" residue, no TO_USER escalation gate, in-tree-write-the-material framing is consistent.

But the Mathlib-dependency list at lines 300–319 names only the **top-3 gating pieces** (Hilbert, Quot, identity-component). Comparing to the actual prerequisite chain for `Pic_{C/k}` representability:

| Piece named in STRATEGY.md | Piece NOT named in STRATEGY.md |
|---|---|
| Hilbert scheme representability | fppf / étale topology on schemes (needed to sheafify the pre-Picard functor) |
| Quot scheme representability | Picard pre-functor `(Sch/k)^op → AbGroups` itself as a functor (definition + group structure) |
| Identity-component construction | Grothendieck's flattening stratification (mentioned at line 308 but only as a sub-step of Hilbert representability; this is itself ~700–1500 LOC of standalone Mathlib infrastructure) |
| | Coherent-sheaf-of-finite-type infrastructure (mentioned at line 313 as "partially in Mathlib"; not LOC-estimated) |
| | Étale-locally-trivial line-bundle / Brauer-group-of-curve machinery (downstream of Picard, but consumed by the identity-component-of-Pic_{C/k} argument) |

The iter-145 mandatory M3 Route A audit refresh dispatched in parallel with this critic (line 627) should pick these up. **Independent of the refresh outcome**, the current strategy's "~6500 LOC midpoint per iter-123 audit" framing carries the risk that the audit-refresh re-prices substantially upward; if that happens, the iter-144 user-hint commitment to Route A becomes a less obviously dominant choice over Route B (Symⁿ + Stein, ~9000 LOC midpoint per iter-123, also potentially under-priced).

**Rebuttal-or-update items**:

1. The audit-refresh result (when it lands) must explicitly verify that the dependency list at lines 300–319 is complete or augment it.
2. The "Route A preferred on cross-utility (Hilbert/Quot/identity-component are top-tier Mathlib infrastructure)" framing (lines 270–272) is **not falsifiable** as currently stated — every Mathlib piece in this LOC range claims top-tier cross-utility. The route-pick rationale should explicitly compare A-side cross-utility vs B-side (symmetric powers also have cross-utility for representation theory, stack constructions, intersection theory). If both routes have top-tier cross-utility, the LOC-midpoint comparison is doing the load-bearing work, and the LOC-midpoint comparison is the thing being audit-refreshed iter-145 — the conclusion "Route A is right" should be **provisional on the audit refresh**, not pre-committed.
3. Recommend: STRATEGY.md add a one-line "If the iter-145 M3 Route A audit refresh returns Route A re-priced to within 30% of Route B (or above), the route-pick decision re-opens." This makes the commitment audit-conditioned rather than user-hint-locked.

---

## Q5 — STRATEGY.md size and structure

**Verdict: SOUND (with flag).**

666 lines vs the canonical ~250 / ~12 KB bound is 2.6× over. Content audit:

- Lines 1–60 (project goal + end-state): load-bearing.
- Lines 61–160 (decomposition + inventory + roadmap M1 EXCISED): mostly load-bearing; M1 EXCISED context could be ~30% shorter.
- Lines 161–236 (roadmap M2 + sub-step table + standalone alternatives): load-bearing for current planning.
- Lines 237–378 (roadmap M3 + Route A + Route B history): Route B detail (~30 lines) is purely historical post-iter-144 commitment.
- Lines 379–410 (what ships): load-bearing.
- Lines 411–465 (soundness rules): load-bearing; iter-138/141/143 LOC-arm renormalisation rule (line 431) is dense; M2.a derivation chain (lines 441–445) has the Q3 contradiction.
- Lines 466–491 (Mathlib gap inventory): load-bearing but **stale** (iter-127 dated; see Q2).
- Lines 492–605 (sequencing + parallel lanes table + decision history blocks): **substantial historical accumulation**. Lines 537–605 are 14 named "iter-N decision blocks" preserved for traceability. Of these, only iter-138 reframing (lines 560+), iter-141 decoupling correction (lines 564+), and the iter-144 pivot itself are currently load-bearing; the rest is iter-127→iter-136 decision history.
- Lines 606–666 (iter-144 pivot + iter-145+ obligations + off-critical-path): load-bearing.

**Estimated compaction yield**: ~180–250 lines (lines 537–605 historical decision blocks + line 320–342 Route B detail + ~40 lines of redundant LOC-arm renormalisation prose). Post-compaction: ~400–450 lines, still over canonical, but closer.

**Rebuttal-or-update items**:

1. Recommend iter-145 planner absorb a compaction directive: move "decision history blocks" lines 537–605 (excluding iter-138 + iter-141 + iter-144 current-load-bearing items) and Route B historical detail (lines 320–342) to a new `STRATEGY-history.md` archive file; cross-reference from STRATEGY.md.
2. The Mathlib gap inventory (lines 466–491) needs re-dating iter-145 and updating per Q2.
3. Following compaction, the canonical bound should be re-flagged: a re-baseline target of "~400 lines" is honest given the multi-year roadmap's accumulated decision context, but the planner should not allow further drift.

---

## Q6 — Iter-150 over-k vs over-`k̄` sunk-cost guardrail

**Verdict: CHALLENGE.**

Line 629: "the iter-150 plan agent dispatches a fresh strategy-critic with one question: 'If a fresh mathematician audited the over-k vs over-`k̄` choice with iter-150 empirical data ... would the choice still be made?'"

The framing is **default-keep biased**:

- "Would the choice still be made?" asks the critic to **second-guess** the prior decision — i.e., the burden is on the critic to demonstrate the prior decision is wrong.
- A correct guardrail asks: "Given iter-150 empirical data, what is the right route forward?" — i.e., the question is symmetric, independent of which choice was prior.
- The pre-commitment text at line 629 explicitly says "Answer NO → revert; Answer YES → over-k confirmed" — the default position is "YES," and a fresh mathematician answering "I don't know" or "borderline" maps to YES under this framing.

This is sunk-cost-shaped. The iter-141 strategy-critic flagged exactly this pattern in a different context. The iter-150 trigger as written will reliably default to "keep over-k" except under decisive contrary evidence.

Additionally: the framing pins the question to a single moment (iter-150) rather than as a rolling check. If iter-149 empirical data is sufficient to flip, the strategy as written would not re-evaluate until iter-150.

**Rebuttal-or-update items**:

1. Reframe the iter-150 question to: "Given iter-150 empirical data (cumulative chart-algebra (α)+(β) costs, piece (ii) PIN-path-(b) closure status, remaining pile residual, and any new analogist verdicts on alternative routes), what is the empirically-best route forward at this point in the project's life?" — symmetric, fresh-context, not framed against the prior decision.
2. Add a rolling trigger: "Any iter where cumulative chart-algebra (α)+(β) costs exceed envelope upper bound (~1050 LOC for piece (ii)) WITHOUT closing OR a fresh prover lane returns INCOMPLETE on a base-dependent sub-goal triggers an immediate mid-iter strategy-critic re-evaluation, not waiting for iter-150."
3. Document the pre-commitment in the audit log so a future strategy-critic does not have to derive the "soft trigger" structure from first principles.

---

## Q7 — Reverse burden on bundled-route artefact preservation

**Verdict: CHALLENGE.**

The iter-144 pivot disposition (line 611) keeps the named declarations `basechange_along_proj_two_inv_app_isIso`, `mulRight_globalises_cotangent`, and the piece (i.c) `omega_free`/`omega_rank_eq_dim` assembly **in-tree as sorry-bodied "auditable record."** ~600 LOC of scaffolding (per directive Q7 framing).

Apply the iter-141 strategy-critic precedent: **don't preserve bundled framing as a silent option**. Is "auditable record" a legitimate disposition, or is it the same sunk-cost pattern in a new costume?

Arguments for deletion:

1. **Git history IS the audit record.** "Auditable record" implies a future reader wants to see the bundled-route shape; that reader can `git log` / `git show` to recover any past commit. Keeping sorry-bodied scaffolding in-tree adds no audit content beyond git, but adds project-cost (sorry-analyzer noise, `\leanok`-sync noise, downstream consumer temptation).
2. **The iter-143 "sorry-must-be-named-declaration" rule (line 429) tightens the audit invariant.** Each named sorry must be traceable to an active prover target. Sorry-bodied declarations that are NOT active prover targets violate the spirit (if not the letter) of that rule: the named sorries no longer correspond to an iter-N+ closure target.
3. **The iter-141 anti-pattern recurs at the in-tree-disposition level.** If the chart-algebra route encounters mid-iter friction, the temptation to "re-activate the bundled scaffolding because it's already there" is real. Deletion enforces the commitment.
4. **Mathematical incoherence**: the iter-143 rule says sorry-bodied declarations must be top-level. ~600 LOC of top-level sorries representing a descoped approach is a project-debt artifact. A clean tree should have sorries only for active prover targets.

Arguments against deletion:

1. **Revert cost**: if iter-150 over-k vs over-`k̄` guardrail or some other check decides to revert to bundled, recovering from git adds friction.
2. **Educational value**: a future contributor reading the file structure sees how the project considered the bundled route; deletion loses this in-context narrative.

**On balance**: the iter-141 discipline argues for deletion. The revert-cost argument is git-recoverable; the educational-value argument is met by the `analogies/` design notes (already preserved per iter-144 pivot prose at line 618 et seq.). "Auditable record" reads as a fig-leaf for option-preservation reluctance.

**Rebuttal-or-update items**:

1. Recommend iter-145+ refactor dispatch (`refactor-bundled-route-excise-iter145+` or similar) to **delete** the descoped sorry-bodied declarations: `basechange_along_proj_two_inv_app_isIso`, `mulRight_globalises_cotangent`, piece (i.c) `omega_free`/`omega_rank_eq_dim` assembly. Drop project sorry-count by ~3–5; tighten the `\leanok` audit signal.
2. Retain `analogies/mulright-globalises-cotangent.md`, `analogies/kaehler-tensorequiv-presheafpullback.md`, `analogies/cotangent-body-shape.md` as the design-context audit record. These are append-only and don't carry project-cost.
3. If iter-145+ planner believes "auditable record" is the right disposition despite this challenge, the planner should write down a **concrete falsification criterion**: "We keep the sorry-bodied scaffolding because [named future use]." If no such concrete use exists, deletion is the disciplined call.

---

## Summary: rebuttal-or-update items per CHALLENGE

1. **Q2**: re-date and augment § "Mathlib gap inventory" to list chart-algebra (α)+(β) gaps + clarify whether they are bundled into piece (ii) envelope or stand-alone.
2. **Q3**: rewrite the M2.a `df = 0` three-layer bullet to resolve the "global-section-vanishing follows" vs "Vanishing-of-global-section is NOT invoked" contradiction; honestly disclose what `H^0(C, Ω_C) = 0`-equivalent content is invoked by chart-algebra and whether Serre duality is just being un-named-or-actually-not-used.
3. **Q4**: explicitly add or rebut the missing M3 dependencies (fppf topology, Picard pre-functor, flattening stratification standalone, coherent-sheaf-of-finite-type); add audit-refresh-conditional re-open clause; verify Route B cross-utility for honest comparison.
4. **Q5** (size flag, not strict CHALLENGE): compaction directive — relocate iter-127→iter-136 decision blocks (lines 537–605, excluding load-bearing iter-138/141/144 items) + Route B historical detail (lines 320–342) to a `STRATEGY-history.md` archive.
5. **Q6**: reframe the iter-150 question symmetrically ("what's the right route at this point?" not "would the past choice still be made?"); add a rolling mid-iter trigger.
6. **Q7**: dispatch an iter-145+ refactor to delete the descoped sorry-bodied bundled-route scaffolding from `Cotangent/GrpObj.lean` and adjacent files; keep `analogies/` design notes as the design-context audit record.

---

## Closing note (iter-141 sunk-cost re-audit)

The iter-141 critic missed the "preservation-of-bundled-framing" sunk-cost. This audit's verdict:

- **At the prose level**, the iter-144 chart-algebra pivot is honestly committed (Q1 SOUND). The pivot is not silently undercut in the strategy text.
- **At the in-tree-disposition level** (~600 LOC kept as "auditable record," Q7), the iter-141 pattern recurs in a softer form: not preservation-of-framing-in-prose but preservation-of-artefacts-in-tree. CHALLENGE on Q7 surfaces this.
- **At the mathematical-content level** (Q3 internal contradiction on `df = 0` derivation chain), there is a separate concern that predates the iter-144 pivot. The chain articulation was added iter-144 per `strategy-critic-iter144` Must-fix #2, but the layer-1/layer-3 contradiction was either present at landing or introduced by the iter-144 edit. CHALLENGE on Q3 must be addressed before iter-146+ piece (ii) prover scaffolding starts, OR the iter-145 blueprint-writer (mandatory per line 622) must articulate a non-contradictory replacement chain.

Three CHALLENGE items (Q2, Q3, Q7) are **must-fix-this-iter** if the iter-145 plan agent dispatches piece (ii) PIN-path-(b) blueprint-writer or scaffolding work; an inconsistent chain or unlisted gap inventory entering iter-146+ scaffolding risks the iter-134 placeholder-pattern mistake recurring on the chart-algebra route.
