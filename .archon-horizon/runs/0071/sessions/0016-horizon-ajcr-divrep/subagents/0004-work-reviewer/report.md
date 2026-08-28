Fresh-context audit of ONE session's work. Project: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (Lean 4, Archon Horizon workspace at /home/axel/LeanAlgebraicGeometry-Horizon).

IMPORTANT: file each finding as you reach it via `"$HORIZON_BIN" inbox add --kind issue --to task:ajcr-divrep --body "..."` (HORIZON_BIN=/home/axel/.archon-env/bin/horizon, run from the workspace root; comments/bodies are capped ~1200 chars so keep each short). Do NOT save everything for a final message — previous helpers on this lane stalled before reporting and their work was lost. READ-ONLY on source: do not edit any .lean file, do not commit, do not run lake build.

The four commits to audit (ledger repo: git --git-dir=/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/vcs/workspace.git --work-tree=/home/axel/LeanAlgebraicGeometry-Horizon):
  053897f16, c8a4563af, 127d7cccf, 00144d3cc

New files: AlgebraicJacobian/Picard/JacobianDataAbelEffective.lean and .../JacobianDataAbelEffectivePoint.lean.
Docstring edits: .../JacobianDataAbelSquare.lean, .../JacobianDataAbelImage.lean, informal/w4-rep-critical-path.md §7.14.

The central claims I want adversarially checked — I would rather you refute one than confirm all:

1. VACUITY/SATISFIABILITY. `exists_effective_deg_eq_of_classDeg_eq` assumes `classDeg K L = g` with `χ(𝒪) = 1 − g`. Is it vacuous or trivial? Is `exists_effective_deg_eq_of_classDeg_eq_zero` genuinely a satisfiability witness for it, or does it merely relocate the same hypothesis (note it takes a degree-g divisor `Z` as an argument — is that hypothesis actually satisfiable over an arbitrary field, e.g. a small finite field)? Try to inhabit or refute.

2. THE HEADLINE. I claim "DAT-J's Riemann–Roch half is NOT divRep-gated". Verify by reading `exists_effective_deg_eq_of_pic0_at_point` and its cone: does anything it consumes transitively require `divFunctor`, `DivFamZar`, a certificate, a chart, or a universal family? If yes, my headline is wrong and I want to know.

3. IS THE RESULT USABLE? I state the limit that the divisor lives over the splitting field L, not κ(y), while DAT-J's `hlift` wants Spec κ(y). Is that limit stated honestly, or does it in fact make the theorem unusable for DAT-J (i.e. did I widen a target to dodge work)? Also: does `exists_effective_deg_eq_of_pic0_at_point`'s conclusion mention its own inputs in a way that makes it near-tautological?

4. THE STALENESS CLAIM. I assert in critical-path §7.14.1 that `Picard/DivRepGlobalClassify.lean` fully discharges the L11 row (classifyGlobal :204, both inverse laws :252/:269, toGlobalData :288, representableBy :306) so "nothing below the divisor-representability endpoint remains". Check that file: are those declarations real, sorry-free, and is the module rooted from AlgebraicJacobian.lean? Is my "nothing remains" too strong?

5. Any place where a docstring I wrote asserts something the Lean does not support.

Report each finding with file:line and say explicitly for each of 1-4 whether it is CONFIRMED or REFUTED.
