Fresh-context adversarial review of ONE session's work, in the Lean 4 project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (module root `AlgebraicJacobian`). READ-ONLY on source: do not edit Lean files.

CONTEXT. This workspace just ran an audit that refuted 99 of 101 sampled "representability" claims: 67 were sorry-reachable, 17 VACUOUS, 12 proved something adjacent to what they claimed, 3 did not exist. So the bar is: sorry-free is necessary but NOT sufficient; a class whose statement does not mention the object it is about is a vacuity; discharging an obligation by projecting your own binder is `P → P`.

WHAT TO REVIEW. Two commits in the workspace ledger (use `"$HORIZON_GIT" show <sha>`, where HORIZON_GIT=/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/bin/hgit):
  fe937438c  feat(AJCR): the fibre criterion at the RESTRICTED chart, and the V-coupled atlas assembly
  5439077ad  docs(AJCR): record that RestrictedChartFibre has NO satisfiability witness
They add `AlgebraicJacobian/Picard/Pic0ChartRestrictedFibre.lean` (5 declarations) and one import line.

THE SESSION'S CLAIMS, which you should try to REFUTE rather than confirm:
1. That `IsChartUniv` (Pic0ChartPair.lean:173) had exactly TWO routes in the tree and both pass through the UNRESTRICTED certificate — `isChartUniv_of_unrestricted` (Pic0ChartPair.lean:191) and `isChartUniv_of_isChartLocusFibre` (Pic0ChartUnivReduce.lean:170). Check the "exactly two" claim independently: grep for every declaration whose conclusion is `IsChartUniv`.
2. That `RestrictedChartFibre` is a genuine repair and not a relabelling. Read its statement. Does it mention the curve, the chart and V? Is `isChartUniv_of_restrictedChartFibre` circular — i.e. is it `P → P` in disguise, or does it do real work?
3. That `necessity_of_restrictedChartFibre` keeps the weakening honest. Verify it is not vacuous.
4. That `pic0RepresentableBy_of_restrictedChartFibre` genuinely COUPLES the two antecedents via a shared `V`, rather than just taking both as unrelated hypotheses. Is the sharing real (same `V i` in both binders) or cosmetic?
5. The session's OWN stated limits — check they are accurate and not understated: (a) no satisfiability witness for `RestrictedChartFibre` at any V; (b) `IsChartLocusFibre → RestrictedChartFibre` NOT proved; (c) rep/huniv/hcov all unproduced; (d) unsatisfiability of the old route is CONDITIONAL because the Abel chart's non-injectivity is asserted in three headers and proved nowhere.

SPECIFICALLY HUNT FOR: (i) any `sorry` reachable from the new declarations; (ii) whether the new class is VACUOUS or trivially inhabited in a way that would make the "repair" worthless; (iii) whether the module docstring OVERSTATES anything, or names any declaration that does not exist (grep every declaration the docstring cites — this project has a repeated failure mode of docstrings citing absent declarations); (iv) whether the new file duplicates `Pic0ChartAtlasCoupling.lean` or `Pic0ChartLocusFibreGuard.lean`, which two OTHER lanes landed the same hour.

Verify with `lake env lean` on a scratch file if useful (do not edit project files), and `#print axioms` with a CONTROL declaration that is known to report sorryAx (e.g. `AlgebraicGeometry.Jacobian`) so you know the probe is live. Report defects with verbatim Lean and file:line, and state plainly which of the five claims survive and which do not.
