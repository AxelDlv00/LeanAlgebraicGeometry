---
name: genus-split-removed-uniform-pic0
description: The genus=0 vs genus>0 split was removed (2026-06-23); the Jacobian is now built uniformly as Pic⁰_{C/k}
metadata:
  type: project
---

On 2026-06-23 the genus `= 0` / genus `> 0` strategic split was **removed** from the
Jacobian construction. Rationale: the separate genus-0 lane was a *pre-FGA local
optimisation* (set `J = Spec k` and prove rigidity directly), adopted only because the
positive-genus FGA route was escalated/deferred. Once `Pic⁰_{C/k}` is built, the
construction is uniform: genus 0 is the automatic degenerate case `Pic⁰ = Spec k`
(since `H¹(C,𝒪_C) = 0`), not a separate construction.

**Lean changes** (project builds clean after):
- `Jacobian.lean`: `genusZeroWitness` + `positiveGenusWitness` + the `by_cases genus C = 0`
  collapsed into one `picardJacobianWitness` (`J = Pic⁰`, single `sorry`).
  `nonempty_jacobianWitness := ⟨picardJacobianWitness C⟩`. Two sorries → one.
- **Deleted** (genus-0 lane, was orphaned from the spine): `RigidityKbar`,
  `AbelianVarietyRigidity`, `Rigidity` (Mumford §4 scheme-level), `Differentials`,
  `Cotangent/*`, `Genus0BaseObjects/*`, and `RiemannRoch/{RationalCurveIso, RRFormula,
  H1Vanishing, OCofP, OcOfD}`.
- **Kept**: `RigidityLemma.lean` (general Milne §I.1 rigidity lemma — consumed by the
  positive-genus Albanese UP) and `RiemannRoch/WeilDivisor.lean` (general divisor/
  `PrimeDivisor`/`RationalMap.order` theory used by `Albanese/CodimOneExtension`).
  WeilDivisor had its trailing `projectiveLineBar` ℙ¹ block surgically excised + its
  `Genus0BaseObjects` import dropped.

**Blueprint**: matching changes — 10 genus-0 chapters removed from `content.tex`;
`AbelianVarietyRigidity.tex` truncated to the general rigidity-lemma chain and retitled
"The rigidity lemma and its Milne §I.1–I.3 corollaries"; `Jacobian.tex` rewritten to the
uniform Pic⁰ narrative (label `def:picardJacobianWitness`); WeilDivisor.tex ℙ¹ block
removed; prose asides in `AbelJacobi/AlbaneseUP/Thm32/CodimOneExtension` dewired. Verified:
0 dangling `\cref/\ref/\uses` to removed labels, 0 new undefined refs vs the pre-refactor
backup.

The single remaining path to the Jacobian is now the FGA route: `Picard.*`
(representability of `Pic_{C/k}`, `Pic⁰` as abelian variety) + `Albanese.*` (Abel–Jacobi
universal property via Milne III.6 symmetric powers). See [[commring-pic-is-skeleton-route]].

NB: some STRATEGY.md-derived "M2 critical-path / M2 wait window" prose in `Jacobian.tex`
is now stale (M2 *was* the deleted genus-0 rigidity lane) — left for the user since it
ties to STRATEGY.md, which was not in scope.
