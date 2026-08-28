Filed as I-0485 (issue) and I-0486 (memory).

## Report

**The retraction is correct. I found one thing that is off, and it is in the same paragraph as the retraction.**

### 1. What I re-measured, and the numbers I got

I built a fully independent domain: my own TeX tokenizer (stack-matched `begin`/`end` pairing, a comment stripper honouring backslash escapes, statement → next-top-level-env attribution) and a Lean metaprogram using `Lean.collectAxioms` rather than `#print axioms`. No shared code with the published recipe.

| quantity | session claims | I measured |
|---|---|---|
| proof-level marked nodes | 998 | 998 |
| distinct pins | 1073 | 1073 |
| probed / private | 930 + 143 | 930 + 143 |
| dishonest proof-level marks | 0 | **0** |
| private concentration | 36 / 21 / 21 | 36 / 21 / 21 exactly |

Baselines confirmed rather than assumed: `lake build AlgebraicJacobian` green at **8746 jobs**; probe at **126 probed / 84 clean / 42 sorryAx**, exactly; reachability **98 of 187** with **0 unrooted**; README's 187 modules / 26 sorries / 11 modules all correct.

Domain completeness (the thing the session says is the whole game): 1000 top-level proof envs carry `\leanok`, 998 attributed, **zero orphans**, zero nested-proof marks, zero proof envs containing `\lean{}`. The two unattributable ones are statements with `\label` but no `\lean` — `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_FGAPicRepresentability.tex:463` and `Picard_RelPicFunctor.tex:775`. The statement/proof gap is blank in all 1803 lean+label nodes, so the "452 skipped pairs" is a fact about the old regex, not a live gap.

### 2. The retraction is not itself an error

`thm:pic0_smooth` and `thm:pic0_proper` carry `\lean{}` but no `\leanok` in either position — I verified by extracting the full statement-through-first-`\end{proof}` span of each. Commit `b61d416e9`'s convention reading is sound and its claim is literally true. ZERO is right. This is not a repeat of the I-0449/I-0471 pattern.

### 3. Leaf C retraction verified

`AlgebraicGeometry.instGeometricallyIrreducibleOfGeometricallyIntegral` exists, `inferInstance` discharges it in one step, and the theorem elaborates verbatim with `[GeometricallyIrreducible C.hom]` deleted at identical axioms `[propext, sorryAx, Classical.choice, Quot.sound]`. Commit `745c121d3` is correct.

### 4. What is off — the same bug, one paragraph later

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/scripts/axiom-frontier.lean:231`:

> `A **statement**-level \leanok on a `sorry` carrier is legitimate and there are eleven`

Measured over every statement-level mark: **1560 pins = 1371 public + 189 private, 34 carry sorryAx**, across 34 nodes, none of which also carries a proof-level mark.

Eleven is not stale — **eleven is exactly the intersection of the sorryAx statement pins with the probe's own 126-declaration output.** I computed that intersection and it is precisely 11, same list. That is the identical defect the session spent four commits retracting ("the join must be over every mark, not over this file's output"), fixed for proof-level marks and left standing for statement-level marks in the same paragraph. 23 of the 34 were never examinable by the published route. The sentence is the load-bearing justification for "do not fix these", so a reader reconciling 11 against 34 concludes 23 are unaccounted for — the exact harm I-0473 C-0002 warns about. It also grows: 20 of the 34 are in `Picard_QuotScheme.tex` and `Cohomology_CechHigherDirectImage.tex`, chapters other teams are landing into. Same text is in `TO_USER.md:31`.

Secondary: the 143-private figure is published as "a bound on the method". It is a bound on `#print axioms`, not on the method. `Lean.collectAxioms` runs against `env.setExporting false`, so private constants are reachable via a `privateToUserName` reverse lookup — I probed all 143, zero carry sorryAx. The honest claim is **stronger** than published: 1073 of 1073 decided. Positive control that this isn't vacuous: the same probe finds exactly one private project declaration that *does* carry sorryAx, `Scheme.RationalMap.av_indeterminacyLocus_eq_empty`, correctly pinned statement-level only, and it is among my 34.

### 5. Objective status, not crediting this session for predecessors

Genuinely done (sessions 0002–0012): axiom frontier published and reproducible; `Jacobian.lean` wired (8 → 98 reachable modules); Milne–Kollár re-aim landed in README, campaign doc, and the FGA chapter with the Quot route explicitly retained-but-off-path; I-0372 visible in `TO_USER.md` with both branches and no choice made. `AJC.jacobian.reachability` is `done` and I agree.

Remaining: `AJC.picrep.rational-point` is `blocked` on the human, correctly. `AJC.maintenance.blueprint` is `pending` with three open children (`print`, `prose.residual-journals`, `pins.remaining-contracts`). hgraph reports **22 stale nodes** and **reviewed: 0** across 6632 nodes — not this session's doing, but it is the one place where graph and source may disagree and nobody has checked. A roadmap warning is live: `AJC.jacobian.assembly` has all sub-items done but is itself `pending`.

### 6. Could not verify

I did not confirm the "no `\leanok` was added or removed" claim by diffing every blueprint chapter against the pre-session tree — the session touched no `.tex` file per `git show --stat`, which I take as sufficient. I also did not rebuild the blueprint PDF, so the "620 pages, zero unresolved references" figure from `b61d416e9` is unverified by me.

### Highest-value next action

Re-measure the "eleven" sentence over all statement-level marks and publish it as the same reconciled triple the proof-level count now uses (`pins = public + private`, asserted in code). The recipe already extracts statement-level marks; it needs the identity applied to them. That closes the class of bug rather than the instance — and it is a prose-only edit inside the ajc-truth write set.
