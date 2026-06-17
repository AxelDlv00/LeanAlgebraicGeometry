# Mathlib Analogist Report

## Mode
api-alignment

## Slug
rrbridge

## Iteration
168

## Question

The progress-critic iter-168 dispatch CHALLENGE: is `genusZero_curve_iso_P1`
(`AlgebraicJacobian/AbelianVarietyRigidity.lean:1135`) — the Riemann–Roch
bridge for "genus-0 curve over `k̄` ≅ ℙ¹" — dispatchable as a parallel
Lane B prover lane this iter? If not, what upstream chapter expansion or
Mathlib infrastructure must the planner schedule, and in what order?

Sub-questions:
- Q1: Does Mathlib have a Riemann–Roch theorem for curves?
- Q2: Does Mathlib have Weil/Cartier divisors, `Pic → ℤ` degree, `Mor(C, ℙ¹)`
  classification, Hurwitz/Castelnuovo at scheme level?
- Q3: Of Hartshorne IV.1.3.5's four pieces (divisor of a point, RR dimension
  formula, linear equivalence, "rational ⟹ ≅ ℙ¹"), what is in Mathlib?
- Q4: What upstream work must the planner schedule if NOT dispatchable?
- Q5: Is `Nonempty (C ≅ ProjectiveLineBar kbar)` the right Lean shape?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| RR theorem for curves (Q1) | NEEDS_MATHLIB_GAP_FILL | critical |
| Divisor / Pic / degree / Mor(C,ℙ¹) machinery (Q2) | NEEDS_MATHLIB_GAP_FILL | critical |
| Hartshorne pieces (i)–(iv) (Q3) | NEEDS_MATHLIB_GAP_FILL | critical |
| Cheapest Mathlib-supportable variant (Q4) | NEEDS_MATHLIB_GAP_FILL | critical |
| Lean signature shape `Nonempty (C ≅ ProjectiveLineBar)` (Q5) | PROCEED | informational |

## Headline answer

**`genusZero_curve_iso_P1` is NOT dispatchable as a Lane B prover lane this
iter**, and dispatching one would burn iters with no closable goal. Mathlib's
gap is total at the level Hartshorne IV.1.3.5 needs: no scheme-level
Riemann–Roch, no Weil/Cartier divisors, no Picard group of a scheme
(`CommRing.Pic` is ring-level only), no degree map, no `Mor(C, ℙ¹)`
classification, and no "complete nonsingular rational curve ⟹ ≅ ℙ¹" packaged
result. The correct planner action is option **(2) Defer to upstream
Mathlib** and keep the gap as the project's *named* RR gap (already
captured in the blueprint `rmk:genusZero_iso_subbuild`); the dispatch
CHALLENGE should be closed with "named gap, no Lane B this iter". The
signature shape (Q5) is correct and should NOT be refactored.

## Informational

### Q1 — Riemann–Roch for curves

**ABSENT.** LSP confirms:
- `lean_leansearch "Riemann-Roch theorem for curves"` returns only
  Weierstrass-curve polynomial-degree results.
- `lean_loogle "RiemannRoch"` returns no hits.
- The only `divisor` in Mathlib is `MeromorphicOn.divisor`
  (`Mathlib.Analysis.Meromorphic.Divisor`) — analytic, in a normed field,
  *not* an algebraic divisor on a scheme.
- `WeierstrassCurve.*` results in `Mathlib.AlgebraicGeometry.EllipticCurve.*`
  are about elliptic-curve division polynomials, not curve genera.

Closest existing piece: nothing close enough to leverage. The project's own
`Scheme.HModule k F i` cohomology (`AlgebraicJacobian.Cohomology.StructureSheafModuleK`)
is the project-side `ModuleCat k`-flavoured analogue of `H^i`, but no RR
theorem is built on top of it.

### Q2 — Divisor / Pic / degree / Mor(C,ℙ¹) machinery

All four pieces ABSENT at scheme level:

- **Weil/Cartier divisors on a scheme**: ABSENT. `lean_loogle "Divisor"`
  returns no hits.
- **Picard group of a scheme**: ABSENT. `CommRing.Pic R`
  (`Mathlib.RingTheory.PicardGroup`) is ring-level only. The
  abandoned `.archon/lanes/*/AlgebraicJacobian/Picard/LineBundle.lean`
  scaffolds are *project-internal experimental code*, never landed
  (per the M3 route audit at `analogies/m3-route-audit.md`).
- **Degree map `Pic → ℤ`**: ABSENT (precondition missing).
- **`Mor(C, ℙ¹)` classification**: ABSENT. Mathlib has
  `AlgebraicGeometry.Proj.fromOfGlobalSections`
  (`Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic`) — "compatible
  graded global sections give a map into `Proj 𝒜`" — and the project
  already uses it for ℙ¹-points (`Genus0BaseObjects.{zeroPt,onePt,inftyPt}`).
  This packages the *target* side of the classification but not the
  *source* side (line bundle on C → sections → map to ℙ¹).
- **Hurwitz / Castelnuovo**: ABSENT.

Present and adjacent (but insufficient on their own):
- `AlgebraicGeometry.Scheme.functionField`
  (`Mathlib.AlgebraicGeometry.FunctionField`) — function field of an
  irreducible scheme.
- `AlgebraicGeometry.Scheme.RationalMap`
  (`Mathlib.AlgebraicGeometry.Birational.RationalMap`) — rational maps
  between schemes; `RationalMap.toPartialMap` over reduced source /
  separated target.
- `OnePoint.equivProjectivization`
  (`Mathlib.Topology.Compactification.OnePoint.ProjectiveLine`) and
  `Matrix.ProjectiveSpecialLinearGroup` — but these are topological /
  matrix-level, NOT the scheme `ProjectiveLineBar kbar` the project uses.

### Q3 — Per-Hartshorne-piece audit

| Hartshorne IV.1.3.5 ingredient | Mathlib status |
|---|---|
| (i) Divisor `P − Q` of two closed points | ABSENT — no `WeilDivisor`/`CartierDivisor`. |
| (ii) RR formula `l(D) − l(K − D) = deg D + 1 − g` | ABSENT. |
| (iii) Linear equivalence `D ∼ D'` | ABSENT (divisors missing). |
| (iv) "X rational ⟹ X ≅ ℙ¹" (Hartshorne II.6.10.1 / I.6.12) | ABSENT — `RationalMap` exists but the classification is not packaged. |

Estimated multi-iter sub-build to formalize the full Hartshorne chain
from scratch in the project: 30–60 iters minimum (divisor stack ~15–25,
RR proof ~10–20, function-field-of-genus-0 classification ~5–15).
This sub-build *was* abandoned at iter-163 in favour of Route C; see
`[[route-c-cube-not-needed-iter163]]` for the rationale.

**Cheapest Mathlib-supportable variant of "genus-0 ⟹ ≅ ℙ¹" TODAY**:
none. The project's `genus C = 0` does (via `Scheme.HModule`)
unfold to "`H¹(C, O_C) = 0` as a `k`-vector space", but every route
from there to `C ≅ ℙ¹` is blocked:
- Divisor-theoretic: blocked by (i)–(iv).
- `Proj.fromOfGlobalSections` direct: needs sections from a line
  bundle on C — line bundles on C absent.
- Function-field / valuation route: needs "smooth proper curve over k̄
  ↔ finitely-generated trdeg-1 extension" — absent.
- Pic⁰ group scheme route: this IS Route A — deliberately deferred.
- Albanese route: circular (this lemma feeds the Albanese witness).

### Q4 — Upstream work the planner should schedule

Four options ordered by my recommendation strength:

1. **(Recommended) Defer to upstream Mathlib**: do NOT open a Lane B
   prover lane this iter; keep `genusZero_curve_iso_P1` as the
   project's named RR gap (`rmk:genusZero_iso_subbuild` in the
   blueprint already says exactly this). Continue shipping the
   rest of the chain as axiom-clean modulo this lemma. *Cost*:
   leaves `rigidity_genus0_curve_to_grpScheme` and the genus-0
   Albanese witness carrying propagated `sorryAx`. *Benefit*:
   no project-internal iters lost on an unbounded sub-build.

2. **Schedule a blueprint-writer expansion** of `prop:genusZero_curve_iso_P1`
   into divisor-theoretic sub-lemmas (a new chapter section
   `\section{Riemann–Roch on a curve, genus-0 case}`). Makes the
   gap concretely divisible, but the resulting sub-build is 30–60
   iters — exactly what Route A was, and the project committed
   *off* Route A at iter-163. Do this *only* if the user
   re-authorises a Route-A-style RR sub-build.

3. **Sidestep via a non-ℙ¹-reducing proof**. Investigated: Mathlib's
   `rigidity_lemma` / `ext_of_eqOnOpen` / `Proj.fromOfGlobalSections`
   only let us *consume* a ℙ¹-iso, not *produce* one. The
   𝔾ₘ-scaling shortcut intrinsically uses ℙ¹'s scaling
   automorphism. The differential `df = 0` route is char-0 only,
   contradicting the chapter's char-free commitment. No known
   char-free sidestep.

4. **User-authorised `axiom`** declaration with the Hartshorne
   IV.1.3.5 citation. Closes the chain logically but violates
   the project's axiom-clean target. Should only be invoked by
   explicit user authorisation.

### Q5 — Signature shape

The current `Nonempty (C ≅ ProjectiveLineBar kbar)` is idiomatic and the
correct shape. The only consumer (`rigidity_genus0_curve_to_grpScheme`,
`AlgebraicJacobian/AbelianVarietyRigidity.lean:1174`) destructs
`Nonempty`, extracts the iso, and transports `f` along it; the choice
of iso is irrelevant downstream. Alternative shapes considered
(pointed iso carrying a `k̄`-point, sum-typed genus-stratified iso,
or folding the whole consumer into a single direct lemma) yield no
meaningful simplification; folding into a direct lemma does NOT
avoid the mathematical content. **PROCEED, no refactor.**

## Persistent file
- `analogies/rrbridge-survey.md` — full per-decision audit captured for
  future iters.

Overall verdict: `genusZero_curve_iso_P1` is NOT dispatchable as a Lane B
prover lane this iter; the four-piece Hartshorne-IV.1.3.5 dependency stack
is *totally absent* from Mathlib at scheme level; the recommended planner
action is option (2) "defer to upstream Mathlib and keep as named gap",
NOT scheduling a Lane B or a blueprint expansion this iter.
