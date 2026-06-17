# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
df-zero-production

## Iteration
155

## Structural problem

Produce the vanishing `df = 0` of `df : f^*Ω_{A/k̄} → Ω_{C/k̄}` for `f : C → A`
(`C` genus-0 curve, `A` abelian variety over alg-closed char-0 `k̄`), as the
keystone input to the already-built converse `df=0 ⟹ f` constant. Abstractly: a
morphism out of a globally trivial source `f^*Ω_A ≅ O_C^{⊕g}` into a target with
`H^0(C,Ω_C)=0` is zero — but realised on **global sections of sheaves over a
proper base**, not pointwise on one module.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `Submodule.linearMap_eq_zero_iff_of_span_eq_top` / `LinearMap.ker_eq_top` | linear algebra | low | ANALOGUE_FOUND (glue only) |
| `Geometry.Manifold.GroupLieAlgebra` (`addInvariantVectorField`, `mpullback_addInvariantVectorField`) | diff. geometry / Lie | high (= excised approach) | PARTIAL_ANALOGUE |
| `Module.rankAtStalk_eq_zero_iff_subsingleton` | comm. algebra | low-med | PARTIAL_ANALOGUE |
| `H^0(C,Ω_C)=0` from genus 0 (Serre duality) | alg. geometry | — | NO_USEFUL_ANALOGUE (absent / deferred) |
| group-scheme `Ω` triviality (Q1, alg. geom.) | alg. geometry | — | NO_USEFUL_ANALOGUE (absent) |
| AV rigidity / rational-curve-constant (Q4 sidestep) | alg. geometry | — | NO_USEFUL_ANALOGUE (absent) |

## Critical structural finding

`df = 0` is **irreducibly a global-sections statement** and factors *exactly* into
the project's two already-deferred gaps:

> `df ∈ H^0(C, Hom(f^*Ω_A, Ω_C))`; with `f^*Ω_A ≅ O_C^{⊕g}` (gap i = the EXCISED
> globalisation) this is `H^0(C, Ω_C^{⊕g}) = (H^0(C,Ω_C))^{⊕g}`, so
> **`df = 0 ⟺ H^0(C,Ω_C) = 0`** (gap ii = Serre duality on a curve).

On an affine chart `V`, `Ω_C(V)` is *free of rank 1* (nonzero), so the
chart-by-chart KDM stack the project already built **cannot detect `df=0`** — the
vanishing only materialises on global sections. This is precisely why the iter-144
chart-algebra pivot could build the converse but not `df=0`. **No minimal in-tree
assembly exists**; the directive's hoped-for "lighter route" is not present in
`b80f227`.

## Answers to the ranked questions

1. **Group-scheme/group-object cotangent triviality — Q1**: the ONLY Mathlib idiom
   for "(co)tangent of a group is trivial / translation-invariant" is the
   smooth-manifold stack `Mathlib.Geometry.Manifold.GroupLieAlgebra`
   (`addInvariantVectorField` builds a global frame from one identity vector;
   `mpullback_addInvariantVectorField` is its translation-invariance) and
   `Mathlib.Geometry.Manifold.Algebra.LeftInvariantDerivation`
   (`left_invariant`, `instLieAlgebra`). It is structurally identical to the
   excised `shearMulRight`/`mulRight_globalises_cotangent`, but built on
   `ChartedSpace`/`TangentSpace`/`VectorField.mpullback`/`LieAddGroup` with no
   scheme-side API — porting = rebuilding the excised presheaf globalisation.
   In **algebraic geometry**: ABSENT (`loogle "GrpObj, KaehlerDifferential"` → no
   results), confirming `cotangent-vanishing-pile.md` (iter-126).
   → **Mathlib has nothing portable; reuse only as a design template.**

2. **`H^0(C, Ω_C)=0` for genus 0 — Q2**: ABSENT, and this is the true bottleneck.
   The link `dim H^0(Ω) = dim H^1(O)` *is* Serre duality. No Serre duality, no
   dualizing/canonical sheaf, no Riemann–Roch in `b80f227` (reaffirms
   `serre-duality.md` iter-110, ~3000–8000 LOC). The project's `Cohomology/*`
   stack computes `H^1(O_C)` but (verified) has **no H⁰-vanishing lemma, no
   direct-sum lemma, and no genus↔Ω bridge**. The genus-0 hypothesis
   (`H^1(O_C)=0`, per `Genus.lean`) does NOT give `H^0(Ω_C)=0` without the
   duality. → **Mathlib has nothing — must route through the (deferred) Serre
   duality, or via a `C ≅ ℙ¹` chart identification that `p1-hedge-...md` ruled
   NOT-VIABLE.**

3. **"Map out of trivial bundle into no-sections sheaf is zero" — Q3**: PRESENT and
   cheap at the **module level**: `Submodule.linearMap_eq_zero_iff_of_span_eq_top`
   (`f=0 ↔ f` kills a spanning set), `LinearMap.ker_eq_top`,
   `AlternatingMap.map_basis_eq_zero_iff`; at the sheaf-Hom level
   `Scheme.Modules.Hom.zero_app`. This is genuinely portable (~5–20 LOC) but is
   **only the final glue** — it presupposes gaps (i) and (ii) already closed and
   contributes nothing to the hard content.

4. **Sidestep check — Q4**: every candidate is ABSENT in `b80f227`:
   - scheme-level rigidity of morphisms to group schemes / abelian varieties —
     ABSENT;
   - "rational curve on an abelian variety is constant" — ABSENT;
   - Mumford Rigidity Lemma — ABSENT;
   - "morphism from proper geom-connected to affine/separated is constant" — not
     packaged (only `Scheme.RationalMap`, `FormallyUnramified`, affine-morphism
     plumbing surface). Moreover the classical proof of "genus-0 → AV constant"
     *itself* routes through `H^0(Ω_C)=0` (or Albanese, also absent), so **no
     sidestep eliminates the Q2 dependence.** Confirmed: no phantoms to chase.

## Top suggestion

`df=0` cannot be produced cheaply: it equals {excised global cotangent triviality
of `A`} + {Serre-duality `H^0(C,Ω_C)=0`}, both already-deferred multi-thousand-LOC
gaps. The planner should **not** open a "produce `df=0`" prover lane. Recommended
disposition (consistent with `serre-duality.md` and `p1-hedge-iter138.md`): keep
`AlgebraicGeometry.rigidity_over_kbar` (`AlgebraicJacobian/RigidityKbar.lean:75`)
as a **named-gap `sorry`**, and have the blueprint disclose `df=0` as gated on the
two structural gaps. The single portable, cheap analogue
(`Submodule.linearMap_eq_zero_iff_of_span_eq_top`) is the trivial closing glue and
is inert until both gaps are filled. If globalisation (gap i) is ever rebuilt, use
`Mathlib.Geometry.Manifold.GroupLieAlgebra` as the *design template* (frame from
identity + translation-invariance), not as an importable dependency.

## Discarded
- **Mumford Rigidity Lemma as a differential-free sidestep**: not in Mathlib, and
  it is a different theorem (commutativity / hom-up-to-translation of AVs), not the
  tool for "rational curve is constant"; that still needs `H^0(Ω_C)=0` or Albanese.
- **`C ≅ ℙ¹` explicit-chart Čech computation of `H^0(Ω)=0`**: mathematically valid
  but needs the genus-0→ℙ¹ identification, ruled NOT-VIABLE in
  `p1-hedge-iter138.md` (no `ProjectiveSpace`, no Riemann–Roch).

## Persistent file
- `analogies/df-zero-production-iter155.md` — analogue list + the global-sections
  decomposition captured for future iters.

Overall verdict: `df=0` is a global-sections fact equal to {excised gap i} +
{Serre-duality gap ii}; Mathlib offers only trivial linear-algebra glue and a
non-portable smooth-manifold template — keep `rigidity_over_kbar` a named gap.
