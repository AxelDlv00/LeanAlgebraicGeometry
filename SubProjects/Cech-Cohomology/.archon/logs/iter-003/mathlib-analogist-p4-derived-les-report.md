# Mathlib Analogist Report

## Mode
api-alignment

## Slug
p4-derived-les

## Iteration
003

## Question
To build the abstract "an acyclic resolution computes the right-derived functor"
theorem (Leray 015E) at the level of `CategoryTheory.Functor.rightDerived n`, the
kernel is a dimension shift across a SES `0 → A → J → Z → 0` (J right-G-acyclic)
giving `(R^k G)(Z) ≅ (R^{k+1} G)(A)` (k ≥ 1) and `(R^1 G)(A) ≅ coker(G J → G Z)`.
Is the explicit horseshoe (`InjectiveResolution.ofShortExact`) the cheapest Mathlib-
aligned path, or does Mathlib already provide SES → LES of derived functors another
way (derived-category triangle, snake on a single resolution, or an Ext-level LES
that specializes to `rightDerived`)? Is the horseshoe the right gap or a detour?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| How to obtain SES → LES of `rightDerived n G` | NEEDS_MATHLIB_GAP_FILL (horseshoe is the right gap) | informational (gap is upstream) |
| Shape of `IsRightAcyclic` | PROCEED | informational |

## Bottom line

**Build the horseshoe. It is the right, necessary, self-contained project-side gap,
not a detour.** Both shortcut alternatives are strictly worse:

- **Ext LES is unusable here.** `Mathlib/Algebra/Homology/DerivedCategory/Ext/ExactSequences.lean`
  (`covariantSequence`, `covariant_sequence_exact₁/₂/₃`, and the contravariant duals)
  is the LES of `Abelian.Ext` = **derived Hom**, built by feeding `triangleOfSES`'s
  homology sequence through the cohomological functors `preadditiveCoyoneda` /
  `preadditiveYoneda`. It is intrinsically Hom-shaped. The project's
  `G = f_*` is not a Hom-functor, so there is no specialization of this LES to it.

- **The derived-category triangulated route needs a bridge that Mathlib explicitly
  defers.** `triangleOfSES` + `triangleOfSES_distinguished`
  (`Mathlib/Algebra/Homology/DerivedCategory/ShortExact.lean:72–94`) plus
  `Pretriangulated.homologySequence_exact₁/₂/₃` give a full LES — but for a
  triangulated functor on `DerivedCategory`. To connect `Functor.rightDerived n G`
  (defined via the homotopy category of injective resolutions, NOT the derived
  category) you need
  `F.rightDerived n ≅ Hⁿ(F.rightDerivedFunctorPlus(Q(–)))`. The module docstring of
  `Mathlib/CategoryTheory/Abelian/RightDerived.lean:40–47` lists this as an open
  TODO: *"refactor `Functor.rightDerived` … when the necessary material enters
  mathlib: derived categories, injective/projective derivability structures,
  existence of derived functors … Eventually … redefined using
  `F.rightDerivedFunctorPlus`."* No `rightDerivedFunctorPlus` exists; no bridge
  exists; `Abelian/RightDerived.lean` imports no derived-category/triangulated
  machinery. Building this bridge means standing up the injective derivability
  structure and the existence-of-derived-functors theorem — dramatically more than
  the horseshoe.

- **No snake-on-a-single-resolution shortcut for the acyclic-middle case.** The
  injective-*middle* dimension shift (`0 → A → Q → A' → 0`, `Q` injective) is cheap —
  it is a re-indexing of one injective resolution of `A` and uses only
  `isoRightDerivedObj` + `isZero_rightDerived_obj_injective_succ`, no horseshoe. But
  the theorem's cosyzygy SESs `0 → Z^m → J^m → Z^{m+1} → 0` have `J^m` merely
  *acyclic*, not injective, and there is no way to manufacture their connecting
  isomorphisms without a genuine SES → LES; the comparison map to an injective-middle
  SES is not an isomorphism. So the horseshoe (or the derived-category route) is
  unavoidable, and the horseshoe is the smaller of the two.

The needed downstream blocks are all present: `ShortComplex.ShortExact.δ` /
`homology_exact₁/₂/₃` over `HomologicalComplex`
(`Mathlib/Algebra/Homology/HomologySequence.lean:282–314`),
`InjectiveResolution.isoRightDerivedObj`, `rightDerivedZeroIsoSelf`,
`isZero_rightDerived_obj_injective_succ`. The only missing piece is the horseshoe.

## Informational

**`IsRightAcyclic` shape — PROCEED.** Mirror Mathlib's vanishing predicates
(`Injective`, `Projective` are `class … : Prop`). Define
`class Functor.IsRightAcyclic (G) (J) : Prop` as
`∀ k, IsZero ((G.rightDerived (k+1)).obj J)` — the index-shifted quantifier that
matches `isZero_rightDerived_obj_injective_succ` exactly — and add an `instance` for
`[Injective J]` from that lemma for free. The blueprint's `def:right_acyclic`
already adopts this shifted form; keep it.

**Scaffolding guidance for the prover (the horseshoe is the dominant P4 risk).**
1. `InjectiveResolution.ofShortExact`: build `I_B` degreewise as
   `I_A.cocomplex.X n ⊞ I_C.cocomplex.X n` (biproduct of injectives ⇒ injective),
   with the **twisted** differential `[[d_A, τ],[0, d_C]]`; the off-diagonal `τ` and
   the augmentation `B → I_B^0` come from the injective lifting property
   (`Injective.factorThru` against monos), built stage-by-stage. Model the recursion
   on `InjectiveResolution.ofCocomplex` / `exact_f_d` / `ofCocomplex_exactAt_succ`
   (`Mathlib/CategoryTheory/Abelian/Injective/Resolution.lean:270–352`). Output a
   degreewise-split `ShortComplex (CochainComplex C ℕ)` that is `.ShortExact`, with
   `I_B` proven to resolve `B`.
2. **Split this into its own prover objective** — the dependent ℕ-recursion for `τ`,
   the chain-map laws, and the exactness of `I_B` are the genuine difficulty. Scaffold
   it as a lemma chain (per-degree `τ`; `d ∘ d = 0`; vertical maps are chain maps;
   split-exact per degree; `I_B` exact), not one monolithic `def`.
3. `rightDerivedShiftIsoOfAcyclic`: apply `G` to the split SES of complexes (additive
   `G` preserves split SES — use the per-degree `ShortComplex.Splitting` mapped by
   `G`), get `ShortExact` of `CochainComplex D ℕ`, run `HomologySequence.δ` +
   `homology_exact₁/₂/₃`, transport `Hⁿ(G(I_•)) ≅ (Rⁿ G)(•)` via `isoRightDerivedObj`,
   then collapse using acyclicity of `J` and `rightDerivedZeroIsoSelf` at the bottom.
4. Optional cheap warm-up: prove the injective-middle shift first (single resolution,
   re-indexing) to nail the base degree of
   `rightDerivedIsoOfAcyclicResolution` before tackling the horseshoe.

## Persistent file
- `analogies/p4-derived-les.md` — design rationale + scaffold guidance for future iters.

Overall verdict: the horseshoe (`InjectiveResolution.ofShortExact`) is the cheapest
Mathlib-aligned route and the correct project-side gap — the Ext LES is the wrong
generality and the derived-category route depends on an explicitly-deferred Mathlib
TODO (`rightDerivedFunctorPlus`) that is far larger than the horseshoe itself.
