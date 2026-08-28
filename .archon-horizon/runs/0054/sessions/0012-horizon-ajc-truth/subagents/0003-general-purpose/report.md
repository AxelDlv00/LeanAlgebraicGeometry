Report relayed to the main conversation (the `ground` address was not reachable; sent to `main` instead). Audit is complete — all seven requested sources read, nothing edited.

## Verdict: leaning

Not chosen, and not presupposed in Lean. What tips it is that the same asymmetry was written into seven venues in one session, always in the same direction, with branch (2)'s advantage stated in none of them — even though older prose in the same repo states it correctly.

## Sentences that lean

Paths relative to `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/`.

1. `README.md:143-148` — "One of the two branches now has a compiled form ... branch (1) costs no mathematics beyond the five obligations already open". Race framing plus build cost inside a paragraph about what the project claims.
2. `README.md:149-150` — "Branch (2) ... is *not* reachable from it". The only thing said about (2) in that paragraph; reads as a viability verdict.
3. `README.md:112-158` — length: ~22 lines for (1) and the k̄ reassurance, ~4 for (2). "Stronger" never appears; (2)'s advantage shows up only inverted, as (1)'s con.
4. `TO_USER.md:18-23` — "One asymmetry you should have ... stated plainly because it could otherwise look like a nudge". Announcing non-nudge does not stop it; it is the last sentence of the first bullet the human reads and points one way.
5. `AlgebraicJacobian/Jacobian.lean:298-301` — "cheap, and proves something strictly weaker ... the full strength, at the cost of a new representability input". Branch (2) described by cost twice. Same wording in the roadmap summary.
6. `AlgebraicJacobian/Jacobian.lean:499-505` — the passage that turns a neutral refactor into a branch artifact. Its real justification (both witnesses are `haveI` specialisations) needs no reference to I-0372 at all.
7. `AlgebraicJacobian/Jacobian.lean:102-106` — file-header index; branch (2) appears only as a negation, where a newcomer forms their model.
8. Sharpest concrete defect, the one-sided inventory. All seven passages say (2) "needs an input nobody has built", but (2) has sorry-free compiled substrate none of them mentions: `Scheme.PicSharp.etSheaf` (`AlgebraicJacobian/Picard/RelPicFunctor.lean:948`), `etSheaf_group_structure` (`:991`), and a `\leanok` blueprint section `sec:relpic_etale_sheaf` (`blueprint/src/chapters/Picard_RelPicFunctor.tex:926-1010`). What (2) lacks is a representability theorem for that functor, not the functor.
9. Strongest quiet pressure, asymmetric precision. `informal/pic-representability-campaign.md:319-330` quantifies (1) to the digit ("five, not four, because..."); (2) is unquantified everywhere. Compounded by `:310`: all 28 milestones keep `[HasRationalPoint C]`, the stated end state is "`HasRationalPoint` remains as an honest hypothesis", and no branch-(2) milestone stub exists. The `:328-330` disclaimer covers only the gate, not the milestone set.
10. `blueprint/src/chapters/Jacobian.tex:170-178` (`rem:pointed_witness_scope`) — closest to neutral, ends well, but still states only (2)'s cost and never what it buys.
11. `AlgebraicJacobian/Jacobian.lean:507-508` — "the general-field one remains the default" is not actually a branch claim ("general-field one" is `picardJacobianWitness`, neither branch), so it is truthful; but "default" lands four lines after "branch (1) costs no new mathematics". Reword, do not delete.
12. Process: the compiled form was reported via README/TO_USER and on I-0391 `C-0012:55`, but not as a comment on I-0372, and the roadmap node summary was not updated. The decision item's own thread is clean while the surrounding prose carries the lean.

## Fairly balanced, do not over-correct

The headline does not carry the hypothesis (no `[HasRationalPoint C]` binder at `Jacobian.lean:554-558`, `:606-609`, `:630-633`; matches `references/challenge.lean:58-60`). `blueprint/src/chapters/Picard_FGAPicRepresentability.tex:76-99` is the best passage in the project and should be the repair template. `Jacobian.tex:307-331` states the branch point with no cost words on either side. `lem:curve_hypothesis_gap` and `Jacobian.lean:307-314` both insist the leaf is false and must be replaced, never proved — the opposite of presupposing (1). `scripts/axiom-frontier.lean:221-224` actively de-steers the word "cheap". The five-not-four discipline removes the strongest false pro-(1) argument, so its repetition works against the lean. I-0372 is genuinely open and unchosen: `status: open`, both comments explicitly decline to choose, roadmap node `blocked` with "it does NOT choose" in its summary. The roadmap CLI ran fine, no hang.

## Minimal repair

Two edits move this to neutral without deleting any true fact: name branch (2)'s Lean substrate wherever branch (1)'s compiled form is named, so the inventory is two-sided; and give branch (2)'s cost a number in the campaign (which of the 28 milestones survive it). Everything else on the list is a word or a clause.
