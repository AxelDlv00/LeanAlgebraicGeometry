# Blueprint-writer directive — slug `ocofp-leanrecipes`

## Chapter

`blueprint/src/chapters/RiemannRoch_OCofP.tex`

## Strategy context

Lane A (OCofP) is **CHURNING** per iter-196 progress-critic. 3 iters,
0 closures. The chapter has solid coverage of the high-level theorems
(`dim_eq_two_of_genusZero`, `exists_nonconstant_genusZero`) but the 3
residual sub-claims (a), (b), (c) in the substrate helper
`exists_nonconstant_rational_from_dim_eq_two` (file
`AlgebraicJacobian/RiemannRoch/OCofP.lean:1421-1440`) lack explicit
Lean-level proof recipes.

The progress-critic's primary corrective is **blueprint expansion**:
convert the 3 named sub-claims into explicit proof sketches with
Lean-level intermediate goals.

## What you must add

In the existing `\section{The dimension formula in genus zero}` section
(or in a new `\subsection{Iter-195 substrate substeps for the
non-constant-rational corollary}` placed at the end of that section),
add:

### Three new `\lemma` blocks for the (a), (b), (c) sub-claims

Each carries a `\lean{...}` pin to a NEW project-side substrate
declaration the iter-196 prover will introduce, and a precise proof
sketch in textbook prose. The 3 sub-claims, mirroring the iter-195
prover's in-file documentation at OCofP.lean:1421-1440, are:

#### (a) — `toFunctionField` injectivity gives `f ≠ 0`

Suggested `\lean{...}` pin:
`AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField_injective`
(or, if a slightly weaker form serves, `..._toFunctionField_ne_zero_of_ne_zero`).

Proof sketch (in prose, NO Lean tactics):

The `toFunctionField` map factors as the composition of four
project-/Mathlib-side maps each of which is injective on the integral
scheme `C`:

1. `HModule_zero_linearEquiv` :
   `Scheme.HModule kbar 𝓛 0 ≃ Hom_{Sh}(𝟙, 𝓛)` for `𝓛` a sheaf of
   `kbar`-modules on `C`. This is the project's existing `HModule_zero_linearEquiv`
   bridge (defined in `Cohomology/StructureSheafModuleK.lean`).

2. `sheafToPresheaf.map` : `Hom_{Sh}(𝟙, 𝓛) → Hom_{Psh}(𝟙_psh, 𝓛.val)`,
   fully faithful (Mathlib `Sheaf.fullyFaithfulSheafToPresheaf`).

3. `constantSheafAdj.homEquiv` :
   `Hom_{Psh}(𝟙_psh, 𝓛.val) ≃ Hom_{ModuleCat kbar}(kbar, 𝓛.val(⊤))`
   (Mathlib's constant-sheaf adjunction).

4. Evaluation at `1 : kbar` : `Hom_{ModuleCat kbar}(kbar, M) ≃ M`
   (Mathlib `LinearMap.applyOneEquiv` or equivalent).

5. `Subtype.val` : `↥(carrierSubmoduleSheaf ⊤) → K(C)`, injective on
   the integral scheme `C`.

Composing the four LinearEquivs + the final `Subtype.val` injection
gives `toFunctionField` as a `kbar`-linear injection
`Scheme.HModule kbar 𝓛 0 ↪ K(C)`.

Lean-level intermediate goals for the iter-196 prover:
- Step a.1: build `LinearEquiv` for layer 1 via `HModule_zero_linearEquiv`.
- Step a.2: build `LinearEquiv` for layer 2 via `Sheaf.fullyFaithfulSheafToPresheaf`.
- Step a.3: build `LinearEquiv` for layer 3 via `constantSheafAdj.homEquiv`.
- Step a.4: build `LinearEquiv` for layer 4 via `LinearMap.applyOneEquiv`
  (or hand-roll if the Mathlib name differs at the pinned commit).
- Step a.5: derive `f ≠ 0` from `s ≠ 0` + the composition's injectivity.

Estimated LOC: ~30–50 (the 4 LinearEquivs each ~5–10 LOC, plus the
composition + nonzero-transfer step).

#### (b) — Order conditions via `globalSections_iff_mpr`

Suggested `\lean{...}` pin (if the lemma does not already exist):
`AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.order_conditions_of_globalSection`.

Proof sketch:

Once `f ≠ 0` is in hand from sub-claim (a), invoke
`globalSections_iff_mpr` (an existing or to-be-introduced equivalence
characterising `f ∈ image of toFunctionField` by the order
conditions). Specifically: the existing definition of `H^0(C, 𝒪_C(P))`
in the project's notation is the subspace of `K(C)` cut out by
`ord_Q(f) ≥ -⟨[P], Q⟩` for every prime divisor `Q`. The hypothesis
`hf_def : f = toFunctionField s` provides the witness; the forward
direction of `globalSections_iff` extracts the two order conditions:
`ord_P(f) ≥ -1` (allowing a simple pole at `P`) and `ord_Q(f) ≥ 0`
for `Q ≠ P`.

If `globalSections_iff_mpr` does not yet exist as a named lemma,
the iter-196 prover lands it inline first (~10-20 LOC); else this
sub-claim is a one-line `exact globalSections_iff_mpr ⟨s, hf_def.symm⟩`.

Estimated LOC: ~10-30 (depending on whether the iff exists).

#### (c) — `principal f hf ≠ 0` via the contrapositive (Stacks 02P0)

Suggested `\lean{...}` pin (NEW project-side helper):
`AlgebraicGeometry.Scheme.WeilDivisor.principal_ne_zero_of_nonconstant`
(or `..._of_not_mem_constants`).

Proof sketch (contrapositive):

If `principal f hf = 0` (i.e. `ord_Q(f) = 0` for every prime divisor
`Q`), then `f` has no zeros and no poles. On a complete (proper)
geometrically irreducible curve over an algebraically closed field
`kbar`, this forces `f ∈ Γ(C, 𝒪_C^×) = kbar^×` (the global sections
of `𝒪_C` are just the constants — this is Hartshorne I.3.4 / Stacks
01XU; the units-of-global-sections refinement is Stacks 02P0).

Combining:
- Step c.1: `f - c ≠ 0` for every `c : kbar`. Use `f = toFunctionField s`
  and `kbar`-linearity of `toFunctionField` (`htF_smul` + `htF_zero`,
  already in scope): `f - c · 1 = toFunctionField (s - c • s₁)` where
  the `kbar`-linear combination `s - c • s₁` is nonzero because `s ∉
  span kbar {s₁}` (which is exactly the iter-195 hypothesis `hs_not_const`).
- Step c.2: Mathematically, the assumption "f has no poles" contradicts
  the fact that `f - c` is non-constant in `K(C)` for some `c` (we
  picked `s ∉ kbar · s₁`, so `f ∉ kbar`).
- Step c.3: invoke the global-units-are-constants property and derive
  a contradiction.

The Mathlib substrate for "global sections of 𝒪_C on a complete
integral curve over an algebraically closed field = kbar" lives at
[the project's Stacks 01XU / 02P0 path; identify in the chapter if a
specific project-side lemma exists, e.g.
`Scheme.functionField_of_complete_curve_const`].

Estimated LOC: ~30-50 (the contrapositive setup + the
non-constancy derivation + the contradiction).

### Source citations

This material is from Hartshorne IV §1 Exercise 1.1 (already cited in
the chapter) and Stacks 02P0 (cite). No NEW external sources needed;
no reference-retriever dispatch required.

## What you must NOT do

- Do NOT add or remove any `\leanok` or `\mathlibok` markers. Those
  are handled by the `sync_leanok` phase and review agent.
- Do NOT modify any Lean file.
- Do NOT touch other chapters.
- Do NOT speculate beyond the 3 sub-claims (a), (b), (c). The
  chapter's existing coverage of `dim_eq_two_of_genusZero`,
  `exists_nonconstant_genusZero`, and the surrounding RR.3 material
  is fine.

## Verification step

The blueprint should compile and the 3 new `\lemma` blocks should
have valid `\lean{...}` pins (the iter-196 prover will land these as
named substrate helpers).

## Report shape

In `task_results/blueprint-writer-ocofp-leanrecipes.md`:
- LOC delta of the chapter (one number).
- The 3 new `\lean{...}` pins introduced.
- One paragraph per sub-claim describing the proof recipe shape and
  Mathlib substrate it consumes.

Out-of-scope items reported under `## Strategy-modifying findings`
ONLY if the rewrite surfaces a strategic issue.
