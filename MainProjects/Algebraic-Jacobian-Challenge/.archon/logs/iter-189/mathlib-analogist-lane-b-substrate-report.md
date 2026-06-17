# Mathlib Analogist Report

## Mode
api-alignment

## Slug
lane-b-substrate

## Iteration
189

## Question

The iter-188 HARD BAR fired on Lane B: the blueprint substrate
`IsClosedImmersion.lift_iff_range_subset` was verified to be NOT in
Mathlib at b80f227. The iter-189 plan-phase committed Option B
(project-side substrate, ~150-200 LOC over 3-5 iters) as the
USER-SILENT FALLBACK. This consult answers:

1. Does Mathlib have any `lift_iff_range_subset`-style variant?
2. What is the cleanest project-side build, and what is the LOC?
3. What is the status of the tensor-reducedness gap that ALSO blocks
   `gm_geomIrred` and `projGm_isReduced`?
4. Recommended substrate skeleton (file layout + headers).
5. **Hard binary verdict (A / B / C)** with LOC estimate.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (1) `lift_iff_range_subset` is not in Mathlib at b80f227 | NEEDS_MATHLIB_GAP_FILL | critical (Lane B blocker) |
| (2) Tensor reducedness `Away ⊗_kbar GmRing` substrate | NEEDS_MATHLIB_GAP_FILL | critical (blocks 3 sorries) |
| (3) Land both substrates in new `Cross01Substrate.lean` | BUILD_PROJECT_HELPER | informational |

## Section 1: Mathlib `IsClosedImmersion.lift_iff_range_subset` survey

**Result**: NOT shipped at b80f227. Re-verified iter-189 via
`lean_leansearch` ("morphism factors through closed immersion iff
set image contained") and `lean_leanfinder` ("factor scheme morphism
through closed immersion via reducedness and topological image").
The iter-188 verdict stands: only `IsClosedImmersion.lift` with the
kernel-inequality form (`f.ker ≤ g.ker`) is shipped, at
`Mathlib/AlgebraicGeometry/Morphisms/ClosedImmersion.lean:206-214`.

**Mathlib primitives needed for a project-side build (all shipped):**

- `IsClosedImmersion.lift` and `lift_fac` / `lift_fac_assoc`
  (the kernel-inequality form, to apply at the end of the chain).
- `Scheme.Hom.ker` (the ideal-sheaf kernel).
- `Scheme.Hom.ker_apply` (under `[QuasiCompact f]`, `f.ker.ideal U = RingHom.ker (f.app U)`).
- `Scheme.Hom.support_ker` (under `[QuasiCompact f]`, `f.ker.support = closure (Set.range f)`).
- `Scheme.Hom.range_subset_ker_support` (unconditional).
- `IdealSheafData.vanishingIdeal_support` (`= I.radical` — the Galois pin).
- `IdealSheafData.gc` (`GaloisConnection (support ·) (vanishingIdeal ·)`).
- `IdealSheafData.range_subschemeι` (for closed immersion `i`, `range i.base = i.ker.support`).
- `IdealSheafData.radical` (the radical of an ideal sheaf).

These compose into the standard "Stacks-style" Galois-connection
argument: range-containment ⟹ support-containment ⟹ (via radicality
of both kernels when sources are reduced) ⟹ ideal-sheaf containment.
File location: `Mathlib/AlgebraicGeometry/IdealSheaf/Basic.lean` for
all of the ideal-sheaf primitives.

## Section 2: Project-side path to the lift theorem

**Target signature**:

```lean
theorem IsClosedImmersion.lift_iff_range_subset
    {X Y Z : Scheme.{u}} (i : Z ⟶ X) [IsClosedImmersion i] [IsReduced Z]
    (g : Y ⟶ X) [QuasiCompact g] [IsReduced Y] :
    (∃ h : Y ⟶ Z, h ≫ i = g) ↔ Set.range g.base ⊆ Set.range i.base
```

**Proof structure** (full skeleton in `analogies/lane-b-substrate.md`):

1. (⇒) trivial range pushdown.
2. (⇐) Step 1: `range i.base = i.ker.support` (via `range_subschemeι`
   transported through `i = subschemeι (i.ker)` up to iso).
3. Step 2: `g.ker.support = closure (range g) ⊆ i.ker.support` (the
   target side is already closed, so `closure_minimal` applies).
4. Steps 3-4: `Y` reduced ⟹ `g.ker` is radical (and similarly `i.ker`
   from `Z` reduced) — via `ker_apply` reduction to ring kernels.
5. Step 5: Galois-connection chain
   `i.ker = i.ker.radical = vanishingIdeal i.ker.support
     ≤ vanishingIdeal g.ker.support = g.ker.radical = g.ker`.
6. Step 6: apply `IsClosedImmersion.lift`.

**LOC estimate**: ~40-60 LOC.

**Hypothesis requirements** (all satisfied for the iter-188 setup):
- `[IsClosedImmersion i]` — `i = pullback.diagonal PLB.hom` is a
  closed immersion via the already-installed `hΔ` instance.
- `[IsReduced Z]` — `Z = PLB`, already proven axiom-clean
  (`projectiveLineBar_isReduced`, iter-168).
- `[QuasiCompact g]` — `g = s_pair` is from the intersection (which is
  affine, hence `CompactSpace`), so QC holds.
- `[IsReduced Y]` — `Y = intersection`, the OTHER substrate gap
  (see Section 3).

## Section 3: Mathlib `tensor-of-domains-over-alg-closed` survey

**Status at b80f227**: NO direct shipped result of the form
"`R ⊗_k S` is reduced/domain when `R`, `S` are reduced/domain over
algebraically closed `k`". The bug record's "confirmed gap iter-184
→ iter-188" is independently confirmed at iter-189.

**Mathlib bridges that DO exist** (relevant but not directly applicable):
- `Algebra.IsGeometricallyReduced` class
  (`Mathlib/RingTheory/Nilpotent/GeometricallyReduced.lean:47`):
  defined as `IsReduced (AlgebraicClosure k ⊗_k A)`. The file's own
  TODO confirms the field-extension lemma "every K/k extension gives
  `K ⊗_k A` reduced when A is geom-red" is NOT landed for general K.
- `Algebra.instIsReducedTensorProductOfIsAlgebraicOfIsGeometricallyReduced`
  (same file, `:52`): only applies when one factor is an algebraic
  field extension; neither `Away (X_0·X_1)` nor `GmRing kbar` is
  algebraic over kbar.
- `Subalgebra.LinearDisjoint.isDomain_of_injective`
  (`Mathlib/RingTheory/LinearDisjoint.lean`): the abstract
  linear-disjoint-subalgebras-of-a-common-domain route. Would require
  building the LinearDisjoint witness (~30-50 LOC sub-task).
- `IsReduced.tensorProduct_of_flat_of_forall_fg`
  (`Mathlib/RingTheory/Flat/Basic.lean`): a reduction-to-fg-subalgebras
  lemma; doesn't close the concrete case directly.

**The clean project path** (combining shipped Mathlib iso machinery):
- `IsLocalization.Away.tensorRightEquiv`
  (`Mathlib/RingTheory/Localization/BaseChange.lean`):
  `TensorProduct R A S ≃ₐ[S] Localization.Away ((algebraMap R S) r)`
  when `A = Localization.Away r`.
- `MvPolynomial.algebraTensorAlgEquiv`
  (`Mathlib/RingTheory/TensorProduct/MvPolynomial.lean`):
  `TensorProduct R A (MvPolynomial σ R) ≃ₐ[A] MvPolynomial σ A`.

**Chain for `(Away (X_0·X_1)) ⊗_kbar GmRing`**:
1. `GmRing kbar = Localization.Away (X () in kbar[t])`.
2. `Away (X_0·X_1) ⊗_kbar kbar[t] ≃ MvPolynomial Unit (Away (X_0·X_1))`
   via `algebraTensorAlgEquiv`.
3. Pushing localization through tensor via `tensorRightEquiv`
   (or its `tensorEquiv` variant) lifts the `kbar[t] ↪ GmRing`
   localization to a localization in `MvPolynomial Unit (Away (X_0·X_1))`.
4. `MvPolynomial Unit (Away (X_0·X_1))` is a polynomial ring over a
   domain ⟹ a domain.
5. Localization at powers of `X ()` (a non-zero divisor) ⟹ a domain
   via `IsLocalization.isDomain_localization` +
   `powers_le_nonZeroDivisors_of_noZeroDivisors` +
   `MvPolynomial.X_ne_zero` (these are EXACTLY the lemmas already
   used in `projectiveLineBar_isReduced` L734-738).

**LOC estimate**: ~50-80 LOC for a generic substrate parametrized over
the homogeneous generator's degree (so the same lemma applies to
`X_0·X_1` of degree 2 for the cocycle AND to `X_i` of degree 1 for
`projGm_isReduced`'s per-chart reducedness AND to the trivial degree
case for `gm_geomIrred` after base-change).

## Section 4: Recommended substrate skeleton

**File**: new `AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean`
importing `BareScheme`, `ChartIso`, `Points`.

**Declarations**:

```lean
-- Substrate 1 (project-side; Mathlib gap-fill):
theorem AlgebraicGeometry.IsClosedImmersion.lift_iff_range_subset
    {X Y Z : Scheme.{u}} (i : Z ⟶ X) [IsClosedImmersion i] [IsReduced Z]
    (g : Y ⟶ X) [QuasiCompact g] [IsReduced Y] :
    (∃ h : Y ⟶ Z, h ≫ i = g) ↔ Set.range g.base ⊆ Set.range i.base

-- Substrate 2 (project-side; generic in the homogeneous generator):
theorem AlgebraicGeometry.gmRing_tensor_homogeneousAway_isDomain
    (kbar : Type u) [Field kbar] {d : ℕ} (hd : 0 < d)
    (f : MvPolynomial (Fin 2) kbar)
    (hf : f ∈ projectiveLineBarGrading kbar d)
    (hf_ne : f ≠ 0) :
    IsDomain (TensorProduct kbar
      (HomogeneousLocalization.Away (projectiveLineBarGrading kbar) f)
      (GmRing kbar))

-- Corollary instance:
instance ... : IsReduced (Spec (.of (TensorProduct kbar
    (HomogeneousLocalization.Away (projectiveLineBarGrading kbar) f)
    (GmRing kbar))))
```

Why a new file (vs. inline in `GmScaling.lean`):
- The substrate is **generic** (no `gmScalingP1`-specific dependencies).
- Substrate 2 is **reused by 3 sorries** in `GmScaling.lean`
  (`gmScalingP1_chart_agreement_cross01`, `gm_geomIrred`,
  `projGm_isReduced`).
- Substrate 1 is **promotable to Mathlib** as an upstream contribution
  later (matches the natural `lift_iff_range_subset` slot in
  `Mathlib.AlgebraicGeometry.Morphisms.ClosedImmersion`).

**Total LOC** (substrates + applications):

| Sub-task | LOC |
|---|---|
| Substrate 1 (`Cross01Substrate.lean`) | 40–60 |
| Substrate 2 (`Cross01Substrate.lean`) | 50–80 |
| Application: cocycle body (`GmScaling.lean`) | 35–50 |
| Bonus: `projGm_isReduced` + `gm_geomIrred` (`GmScaling.lean`) | 30–55 |
| **Total** | **155–245** |

**Phased delivery** (3-5 iters):
- Iter 189: prover on `Cross01Substrate.lean` → land Substrate 1.
- Iter 190: prover on `Cross01Substrate.lean` → land Substrate 2.
- Iter 191-193: prover on `GmScaling.lean` → close 3 sorries.

## Section 5: HARD BINARY VERDICT

**(B) FEASIBLE at 80-200 LOC.**

Detailed reasoning:

- **(A) is ruled out**: the `lift_iff_range_subset` variant is genuinely
  absent and the alternative (via `lift` with kernel-inequality directly)
  requires the SAME substantive ideal-sheaf containment proof in
  disguise, so there is no <80 LOC path.

- **(B) is the correct verdict**: combining the Mathlib primitives
  (Galois connection `support` ↔ `vanishingIdeal`,
  `support_ker = closure range`, `range_subschemeι`, plus the
  localization-polynomial tensor iso chain), the substrate work lands
  at ~90-140 LOC and the application work at ~65-105 LOC. Central
  estimate ~180-200 LOC, with worst case ~245 LOC.

- **(C) is NOT triggered**: no Mathlib upstream PR is needed; no
  STRUCTURALLY IMPOSSIBLE finding; the path is fully realised by
  existing Mathlib primitives. The user does not need to choose
  between (a) substrate build, (b) wait for upstream, (c) route
  retire — (a) is unambiguously feasible.

**Recommendation to planner**: proceed with the iter-189 Option B
commitment as planned. Dispatch a prover this iter on the new
`Cross01Substrate.lean` for Substrate 1 (the smaller chunk). The
substrate work is bounded, well-scoped, and unblocks three sorries
once both substrates land.

## Persistent file
- `analogies/lane-b-substrate.md` — design-rationale captured for
  future iters (substrate signatures, Mathlib citations, phased
  delivery plan, reversal trigger).

Overall verdict: Lane B substrate is FEASIBLE at 80-200 LOC (Verdict B);
proceed with project-side build of `lift_iff_range_subset` +
tensor-reducedness in a new `Cross01Substrate.lean` over 3-5 iters,
total ~180-200 LOC central estimate.
