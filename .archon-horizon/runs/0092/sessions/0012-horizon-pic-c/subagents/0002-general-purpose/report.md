You are inspecting the Lean project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild (AJCR). READ ONLY — do not edit or commit anything.

QUESTION: how far is this tree from proving `∀ T : Over (Spec (.of k)), Subsingleton (pic0Subgroup (P1.asOver k) T)` — i.e. the vanishing of the degree-zero relative Picard group of the projective line over an arbitrary test object?

Relevant definitions to read first:
- `pic0Subgroup` and `degAt` : AlgebraicJacobian/Picard/Pic0Functor.lean:107 and :56
- `picEt`, `picEtSubgroup` : AlgebraicJacobian/Picard/PicEt.lean:105
- `PicEtAff` (étale plus of relPic on affine tests) : AlgebraicJacobian/Picard/PicEtAff.lean:218, `descentClasses` :76
- `relPic C T = CechPic (C ⊗ T).left / picFromBase` : AlgebraicJacobian/Picard/RelPic.lean:63
- `Scheme.CechPic` (Čech H¹ of units on pointed covers) : AlgebraicJacobian/Picard/Pic.lean:60
- `PicEtAff.degAff` : AlgebraicJacobian/Picard/DegreeZero.lean:263
- pic-g's new curve: AlgebraicJacobian/Curve/P1Curve.lean, P1H1Vanishing.lean (proves genus (P1.asOver k) = 0), and AlgebraicJacobian/Curve/P1Charts.lean, P1.lean.

Report:
1. The exact chain of reductions needed: from `Subsingleton (pic0Subgroup C T)` down to a statement about Čech classes on the two-chart cover of P1 over a ring. Name the existing lemmas in the tree that perform each step (e.g. affine-open componentwise reduction, the affine comparison `picEtAffineEquiv`, plus-class representatives, the coset relation). Give file:line.
2. What substrate already exists about the Picard group / units / line bundles of P1 or of a two-chart cover: search for lemmas about `unitsH1`, `PointedCover`, Laurent units, `CechPic` triviality criteria, `cechPicEquivPic`, any Mayer–Vietoris or two-chart H¹ computation (AlgebraicJacobian/Picard/*, AlgebraicJacobian/Cohomology/*, AlgebraicJacobian/Curve/P1*). Name what is there with file:line.
3. Your honest estimate of the missing mathematics, itemized: what theorems would have to be built (e.g. "units of A[t,t⁻¹] modulo units of A[t] and A[t⁻¹] is ℤ", "every Čech class on a pointed cover of P1_A refines to the 2-chart cover", the étale-plus and degAt bookkeeping), and for each: is any of it already in mathlib (check with `/home/axel/.archon-env/bin/horizon search "<words>" --json`, which spans mathlib too)?
4. A verdict: is a proof of the vanishing at P1 for ALL tests T reachable in one long session, or is it multi-session? What is the largest genuinely reusable sub-piece that IS closable and how would it be stated in Lean (give a candidate signature)?

Be concrete with names and file:line. Your final message is the return value — compact structured report, no preamble.
