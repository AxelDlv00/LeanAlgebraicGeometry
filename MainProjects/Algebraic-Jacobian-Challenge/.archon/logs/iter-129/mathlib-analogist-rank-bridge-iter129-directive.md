# Mathlib Analogist Directive

## Slug
lieAlgebra-rank-bridge-iter129

## Topic

The bridge between the iter-128 `AlgebraicGeometry.GrpObj.lieAlgebra` (to be renamed `cotangentSpaceAtIdentity` per iter-129 refactor) body and the iter-130+ rank lemma `cotangentSpaceAtIdentity_finrank_eq`.

## Project context

`AlgebraicJacobian/Cotangent/GrpObj.lean` defines (post-iter-129 rename):

```lean
noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    ModuleCat k :=
  let ηleft : Spec (.of k) ⟶ G.left := CategoryTheory.CommaMorphism.left η[G]
  let ψ : Γ(G.left, ⊤) ⟶ CommRingCat.of k :=
    ηleft.appTop ≫ (Scheme.ΓSpecIso (.of k)).hom
  let M := Scheme.relativeDifferentialsPresheaf G.hom
  (ModuleCat.extendScalars ψ.hom).obj (M.obj (op ⊤))
```

Semantically this is `k ⊗_{Γ(G.left, ⊤)} Ω_{G/k}(⊤)`. The project needs to prove

```
Module.finrank k (cotangentSpaceAtIdentity G) = n
```

where `n` comes from `[SmoothOfRelativeDimension n G.hom]`.

## The strategy-critic-iter129 challenge

`strategy-critic-iter129` flagged that:

1. **The body construction may have a hidden presheaf-vs-sheaf bridge cost.** For a *proper non-affine* group scheme `G`, the global sections of `relativeDifferentialsPresheaf G.hom` (a `PresheafOfModules`) at the top open may differ from the global sections of its sheafification. The strategy-critic's concern is that the rank lemma asserts `finrank lieAlgebra = n` but the iter-128 body computes the presheaf-side global sections, not the sheaf-side; the bridge to the geometric pullback `η_G^* Ω_{G/k}` (which is what should have rank `= n` by smoothness) may require sheafification.

2. **The bridge to the cotangent space `𝔪_{η_G} / 𝔪_{η_G}^2`** is the alternative target for the rank lemma. Mathlib supplies `Ideal.IsLocalRing.CotangentSpace` (verified) for the cotangent of a local ring. The challenge is whether the iter-128 evaluate-then-extend-scalars body is canonically isomorphic to this stalk-side cotangent for a proper geometrically-irreducible group scheme, and whether that isomorphism is tractable to formalise in the project's existing infrastructure.

## What I want from you

A **PROCEED vs ALIGN_WITH_MATHLIB** verdict on:

A. **The iter-128 body's rank correctness.** For `G : Over (Spec k)` smooth proper geometrically-irreducible, is the iter-128 body `k ⊗_{Γ(G, \top)} Ω_{G/k}(\top)` canonically of `k`-rank `n` (the relative dimension)? Or does this presentation need an intermediate "presheaf-vs-sheaf coincidence theorem" before the rank claim is provable?

   Specifically:
   - Does Mathlib `b80f227` ship a theorem connecting `(relativeDifferentialsPresheaf G.hom).obj (op ⊤)` with `H^0(G, Ω_{G/k})` (the sheafified global sections)?
   - For proper geometrically-irreducible `G` over `k`, is `H^0(G, \mathcal{O}_G) = k` (which would make `H^0(G, Ω_{G/k})` a `k`-module that base-changes correctly under `ψ : Γ(G, \top) → k`)?
   - Is the chain `cotangentSpaceAtIdentity G → 𝔪/𝔪² of stalk at η_G → free k^n` realisable directly via the project's existing `relativeDifferentialsPresheaf` + Mathlib's `Ideal.IsLocalRing.CotangentSpace`, OR does the project need a new "scheme-level cotangent sheaf" intermediate?

B. **The standalone scheme-level cotangent sheaf alternative.** The iter-127 strategy named iter-129 as the formal re-evaluation trigger for unbundling a standalone `AlgebraicGeometry.Scheme.Omega` (sheaf, not presheaf) from piece (i)'s bundled budget. Your verdict on (A) decides this:
   - **PROCEED on (A)** ⇒ the bundled path is viable; iter-130+ rank lemma can build directly on the iter-128 body without a sheafification intermediate. Strategy retains the bundled 800–1500 LOC piece (i) estimate.
   - **ALIGN_WITH_MATHLIB on (A)** ⇒ the bundled path requires sheafification infrastructure that doesn't yet exist; the project should detour through a standalone `Scheme.Omega` sheaf (~500–1000 LOC added scope) BEFORE building the rank lemma. Strategy revises piece (i) estimate up to ~1300–2500 LOC.

C. **The iter-130+ rank-lemma closure path.** Whichever verdict you return, sketch the closure path the iter-130+ rank-lemma prover lane would take. Name the specific Mathlib lemmas (`[verified]` if confirmed via `lean_local_search` / `lean_leansearch`, `[expected]` if you have not verified, `[gap]` if confirmed missing).

   Candidates from prior project work:
   - `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` — consumed in `Differentials.lean smooth_locally_free_omega` for `Ω` rank claims.
   - `Ideal.IsLocalRing.CotangentSpace` — verified in `b80f227` for the local-ring side.
   - `Module.finrank_extendScalars` or similar — for tensor-product-preserves-rank.
   - `KaehlerDifferential.map` family — for the residue / quotient bridge.

## Reference material

If you need to verify Mathlib idioms, use:
- `lean_local_search` / `lean_leansearch` — primary tools.
- `lean_hover_info` — to inspect signatures of candidate Mathlib declarations.
- `lean_loogle` — for type-pattern queries (e.g. `Module.finrank _ (_ ⊗[_] _)`).

Prior persistent files at `analogies/` that you may consume if they're relevant:
- `analogies/cotangent-presheaf-design.md` (iter-126 analogist's piece (i) decomposition).
- `analogies/cotangent-vanishing-pile.md` (iter-126).
- `analogies/cotangent-vanishing-pile-over-k.md` (iter-127).
- `analogies/relative-differentials-presheaf-bridge.md` (M1 PR candidate).

Do NOT consume `STRATEGY.md`, `PROGRESS.md`, `task_pending.md`, or iter sidecars.

## Output format

Per the standard `mathlib-analogist` output:
- **PROCEED / ALIGN_WITH_MATHLIB / PIVOT** verdict.
- One paragraph rationale (why this verdict).
- The specific Mathlib lemma chain the iter-130+ rank-lemma prover lane should consume (with `[verified]` / `[expected]` / `[gap]` tags).
- A persistent design file at `analogies/lieAlgebra-rank-bridge.md` (NEW; ~80–200 lines) that future iters can read for the rationale. This file documents:
  - The chosen presentation (evaluate-then-extend-scalars vs stalk-side cotangent).
  - The bridge lemmas needed (named or, where missing, scoped as Mathlib gaps).
  - The presheaf-vs-sheaf coincidence theorem (or its absence).
  - The expected LOC and iter cost for the iter-130+ rank-lemma closure.

## Constraints

- Your write domain is `task_results/**` and `analogies/**`. You may write the new `analogies/lieAlgebra-rank-bridge.md` and your report.
- Do NOT edit `STRATEGY.md`, `PROGRESS.md`, `.lean` files, or any blueprint chapter.
- Be brutally honest about phantom Mathlib names. The `strategy-critic-iter129` already flagged `IsRegularLocalRing.cotangentSpace` as a phantom (correct name is `Ideal.IsLocalRing.CotangentSpace`); apply the same skepticism to any name in this directive that you have not personally verified.

## Why this matters

The iter-130 prover lane on the rank lemma is the next active critical-path piece. Without your verdict, the plan-agent would dispatch a prover lane blind to the presheaf-vs-sheaf issue, risking a PARTIAL/INCOMPLETE close that the iter-128 progress-critic warned would flip the meta-pattern from CONVERGING to UNCLEAR. Your verdict de-risks the iter-130 lane.
