# Mathlib Analogist Report

## Slug
lieAlgebra-rank-bridge-iter129

## Iteration
129

## Question

For the iter-128 body of `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`
(presheaf-evaluation-at-⊤ + extendScalars-to-k along the identity-section
ring map), does the iter-130+ rank lemma `cotangentSpaceAtIdentity_finrank_eq`
admit a tractable closure through Mathlib b80f227, or does the
presheaf-vs-sheaf coincidence cost flagged by `strategy-critic-iter129`
require a presentation change first?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Iter-128 body's rank correctness (A in directive) | **ALIGN_WITH_MATHLIB** | **critical / must-fix** |
| Standalone scheme-level cotangent sheaf alternative (B in directive) | **PROCEED** (do not pursue Replacement C this iter) | informational |
| Iter-130+ rank-lemma closure path (C in directive) | **PROCEED** with Replacement (B) — affine-chart base change | major |

## Overall verdict

**ALIGN_WITH_MATHLIB — must replace the iter-128 body before stating the rank lemma.**

The iter-128 body of `cotangentSpaceAtIdentity` computes the **zero `k`-module**
for every smooth proper geometrically irreducible group scheme `G/k` with
relative dimension `n ≥ 1` (i.e. for every consumer in the target class).
The rank lemma `finrank cotangentSpaceAtIdentity = n` is therefore
**provably FALSE as stated** against this body for `n ≥ 1`.

The strategy-critic-iter129 was correct: the presheaf-side global
sections on a non-affine `G` differ from the sheaf-side, and the
divergence cannot be bridged without infrastructure that does not exist
in Mathlib b80f227.

## Must-fix-this-iter

**`AlgebraicJacobian/Cotangent/GrpObj.lean:102-116` — replace the body of
`cotangentSpaceAtIdentity`** before iter-130 dispatches a rank-lemma
prover lane. The current body is divergent-and-wrong (not merely
divergent-with-cost): it produces zero, not a rank-`n` module.

Concrete fix path (**Replacement (B): affine-chart base change**):

1. Extract via `smooth_locally_free_omega` an affine chart
   `V ⊆ G.left` containing the identity-section image `η(pt)`, with
   `Algebra.IsStandardSmoothOfRelativeDimension n Γ(Spec k, U) Γ(G, V)`.
2. Build `ψ_V : Γ(G, V) ⟶ k` from the identity section restricted to V,
   composed with `Scheme.ΓSpecIso`.
3. Define the body as
   `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V) ⁄ Γ(Spec k, U)])`.

This replaces the presheaf-at-⊤ evaluation with a chart-base-change
evaluation, dropping the canonical/sheaf-side claim but enabling the
rank lemma to close in 50-100 LOC against Mathlib's already-shipped
`Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
and the project's already-shipped `smooth_locally_free_omega`.

**Tradeoff acknowledged**: Replacement (B) is non-canonical (depends
on chart choice via `Classical.choice`). Document with a `% NOTE` in
the docstring. For the rigidity-over-`k̄` consumer (the only live
consumer), the existence statement is all that matters; canonicity
would only be needed if a future Lie-algebra-bracket consumer
emerges, in which case Replacement (A) — stalk-side cotangent — would
need to be undertaken (estimated 500-1000 LOC).

## Major

- **Strategy LOC envelope under the corrected approach**: piece (i)
  stays at the bundled 800-1500 LOC estimate. The strategy-critic-iter129's
  upper-bound revision to 1300-2500 LOC (for Replacement C = sheafified Ω)
  is **NOT** triggered.
- **Iter cost for the rank lemma under Replacement (B)**: 1-2 prover iters.

## Informational

- **Replacement (A) (stalk-side `IsLocalRing.CotangentSpace`)** is the
  canonical mathematical object but requires bridging "standard smooth
  over a field at a prime ⇒ `IsRegularLocalRing` of dim n", which is
  a confirmed Mathlib gap (~300-600 LOC bridge cost). Out of scope
  this iter; document for future generality.
- **Replacement (C) (sheafified scheme-level `Ω`)** is the full
  Mathlib-aligned construction; defer indefinitely (~800-2000 LOC) unless
  a downstream non-rigidity consumer emerges. The iter-127 strategy's
  "iter-129 unbundling re-evaluation" trigger is **NOT** activated:
  Replacement (B) gives the same rank lemma at much lower cost.

## Mathlib lemma chain (closure path under Replacement B)

| Step | Lemma | Status |
|---|---|---|
| 1 | `AlgebraicGeometry.IsSmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension` | [verified] |
| 2 | `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth` | [verified] |
| 3 | `Algebra.IsStandardSmooth.free_kaehlerDifferential` | [verified] |
| 4 | `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` (`Module.rank Γ(V) Ω[Γ(V)/k] = n`) | [verified] |
| 5a | `Module.Free.tensorProduct` (base change preserves Free) | [expected — Mathlib has this pattern] |
| 5b | `Module.finrank_tensorProduct` / `Module.finrank_baseChange` | [expected — Mathlib has the pattern] |
| 6 | `Module.finrank_eq_rank'` (`finrank` ↔ `rank` under `FiniteDimensional`) | [verified] |
| 7 | `Scheme.ΓSpecIso` for the `ψ_V : Γ(G, V) → k` identification | [verified] |
| 8 | Auxiliary: `KaehlerDifferential.subsingleton_of_surjective` (used in Decision 1 to PROVE the iter-128 body is zero — diagnostic only) | [verified] |
| 9 | Auxiliary: `IsRegularLocalRing.iff_finrank_cotangentSpace` (used in Replacement A; not needed under B) | [verified] |
| 10 | Auxiliary: `AlgebraicGeometry.isField_of_universallyClosed` (proves `Γ(G, ⊤)` is a field for proper geo-integral G; diagnostic for Decision 1) | [verified] |

**No Mathlib gaps under Replacement (B).** Every step is consumable
from Mathlib b80f227.

## Why the iter-128 body collapses (diagnostic for the record)

Step-by-step proof that the iter-128 body equals the zero `k`-module
for the target class:

1. `(relativeDifferentialsPresheaf G.hom).obj (op ⊤) =
   CommRingCat.KaehlerDifferential (φ'.app (op ⊤))` by
   `relativeDifferentials'_obj` (rfl).

2. `φ'.app (op ⊤)` has domain
   `((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (op ⊤)`,
   computed as the left Kan extension colimit
   `colim_{V : Opens(Spec k), f.base(⊤_{G.left}) ⊆ V} Γ(Spec k, V)`.
   Since `Spec k` is single-point, the indexing cone is `{V = ⊤}`,
   so the colimit collapses to `Γ(Spec k, ⊤) ≅ k`.

3. The codomain is `Γ(G.left, ⊤)`. Smooth ⇒ geometrically reduced;
   smooth proper geometrically irreducible ⇒ geometrically integral.
   For proper geometrically integral `G/k`, `Γ(G, ⊤) = k`
   (Stacks 0BUG; Hartshorne III.10.7; in Mathlib as
   `AlgebraicGeometry.isField_of_universallyClosed` + finite-extension
   + geometric-irreducibility argument).

4. So `φ'.app (op ⊤) : k → k`, which is the structure map (i.e.
   identity up to canonical iso). By
   `KaehlerDifferential.subsingleton_of_surjective`,
   `CommRingCat.KaehlerDifferential (id_k) ≅ 0`.

5. `(ModuleCat.extendScalars ψ.hom).obj (0_{Γ(G,⊤)-module}) = 0_{k-module}`.

This is exactly the presheaf-vs-sheaf collapse that strategy-critic-iter129
warned about. The strategy-critic's concern was concrete and correct.

## Persistent file

- `analogies/lieAlgebra-rank-bridge.md` — full design-rationale captured
  for future iters. Documents:
  - Why the iter-128 body collapses (the 5-step diagnostic above).
  - The three replacement options (A: stalk-side, B: affine-chart, C:
    sheafified) with LOC estimates and Mathlib-coverage analysis.
  - The chosen replacement (B) and its closure-path bridge lemma list.
  - The presheaf-vs-sheaf coincidence theorem (absence) and why
    replacement (B) sidesteps it.

## Reviewer's note for the plan agent

Iter-130's rank-lemma prover lane should **NOT** be dispatched against
the current iter-128 body. The plan agent should first either:

(a) **Direct a prover lane to refactor `AlgebraicJacobian/Cotangent/GrpObj.lean`**
to Replacement (B): swap the body to chart-base-change, keeping the
signature (which is already in `archon-protected.yaml` per the iter-129
rename, if applicable — verify). The rename to `cotangentSpaceAtIdentity`
is preserved; only the body changes.

(b) **Or queue a combined refactor+rank lemma in a single iter-130 lane** —
the refactor is small (~50 LOC body swap) and the rank lemma is short
(~50-100 LOC); both fit in one prover iter.

Either way, the iter-128 body **must** be replaced before the rank
claim can compile (let alone be true). Skipping this step would push
the project into a CHURNING regime as the iter-130 prover lane
discovers the body is zero and bounces.
