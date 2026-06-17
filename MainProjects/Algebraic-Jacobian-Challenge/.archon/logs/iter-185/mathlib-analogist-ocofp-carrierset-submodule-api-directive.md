# Mathlib Analogist Directive

## Slug
ocofp-carrierset-submodule-api

## Mode: api-alignment

## Project file in scope
`AlgebraicJacobian/RiemannRoch/OCofP.lean` — Hartshorne-subsheaf-of-`K_C` direct construction of `lineBundleAtClosedPoint`.

## Context

The project is constructing `lineBundleAtClosedPoint P hP : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar)` for a closed point `P` on a smooth proper geometrically irreducible curve `C / k̄`. The chosen pattern (per iter-181 analogist `ocofp-sheaf-internalhom.md` Decision 3 `ALIGN_WITH_MATHLIB`) is the Hartshorne sub-presheaf-of-`K_C` direct construction:

- iter-183 landed `carrierSet : Set K(C)` per open (the rational functions satisfying order conditions), plus `carrierSet_mono` (the substantive monotonicity proof). Both axiom-clean.
- iter-183 deferred the **`carrierSet → Submodule kbar K(C)` upgrade** to a future iter; the upgrade has been the route's primary blocker for **18 elapsed iters** (Lane A entered iter-167; iter-185 progress-critic verdict: **CHURNING + OVER_BUDGET**, 7 sorries flat across iters 181-184; helpers added in 2 of 4 K-iters but zero sorry-elimination).

The route also produced a chain of NOT_DISPATCHED iters (planValidate attrition + rate-limit). When dispatched, every iter loops back to the same two recurring blocker phrases:

- `"carrierSet → Submodule upgrade gated"` — appeared iters 181, 183.
- `"sheaf-property pin stays typed-sorry"` — appeared iter 183.

The progress-critic's **must-fix-this-iter** corrective names this analogist consult **explicitly**: "Mathlib analogy consult on `carrierSet` / `Submodule` API before dispatching another prover round. The route is using the wrong Submodule API entry point. A focused Mathlib-idiom analysis on `carrierSet` / `Submodule` upgrade in the sheaf-theoretic context is required before any further prover round."

This is a **proactive design-shape consult**, not a missing-lemma question — the planner suspects the route's `Set → Submodule → presheaf functor → sheaf` decomposition shape is the bottleneck, not the proofs around it.

## The exact upgrade in question

Currently (iter-183, axiom-clean):

```
private noncomputable def lineBundleAtClosedPoint.carrierSet
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (P : C.left) (hPcoh : Order.coheight P = 1)
    (U : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ) :
    Set C.left.functionField := by
  let Phat : C.left.PrimeDivisor := ⟨P, hPcoh⟩
  haveI : Ring.KrullDimLE 1 (C.left.presheaf.stalk Phat.point) :=
    Scheme.IsRegularInCodimensionOne.out Phat
  exact { f | (∀ Q : C.left.PrimeDivisor, Q.point ∈ U.unop.1 → Q.point ≠ P →
              0 ≤ Scheme.RationalMap.order Q f) ∧
              (P ∈ U.unop.1 → (-1 : ℤ) ≤ Scheme.RationalMap.order Phat f) }

private lemma lineBundleAtClosedPoint.carrierSet_mono ...   -- axiom-clean monotonicity
```

Wanted (Hartshorne subsheaf-of-`K_C` direct construction, full body):

```
-- Step 1: upgrade carrierSet U to a kbar-submodule of K(C)
lineBundleAtClosedPoint.carrierSubmodule P hPcoh U : Submodule kbar (C.left.functionField)

-- Step 2: presheaf functor on Opensᵒᵖ → ModuleCat kbar,
--   identity-on-K(C) restrictions via carrierSet_mono
lineBundleAtClosedPoint.presheaf P hPcoh : (Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat kbar

-- Step 3: sheaf property
lineBundleAtClosedPoint.presheaf_isSheaf : Presheaf.IsSheaf ...

-- Final: bundle as Sheaf
lineBundleAtClosedPoint P hP : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat kbar)
```

## Specific questions for the analogist

The critic's diagnosis is that the project may be using the wrong Mathlib API entry point. **Please answer each of these:**

### Q1 — Is there a Mathlib idiom for "subsheaf of `K(C)` cut out by an order condition"?

Hartshorne's classical pattern (II §6 p.144 / §6 around Prop 6.13(a)) constructs `ℒ(D)` for a Cartier / Weil divisor `D` as a subsheaf of the constant sheaf of rational functions. Is there a Mathlib pattern for this — perhaps:

- (a) `Sheaf.subsheafOfHom` / `Subpresheaf` / `Subsheaf` machinery (does `Mathlib/CategoryTheory/Sites/Subsheaf.lean` ship a usable API for `Subsheaf F` given a global section family that satisfies the sheaf condition? Concretely, given the constant `K(C)`-presheaf (a sheaf since constant) and a per-open submodule `carrierSubmodule U`, is there a direct `Subpresheaf.toSheaf` route?);
- (b) `Module.LocallyConstant` or some `Module.localised` API that already packages "submodule cut out by valuation conditions";
- (c) A Mathlib-shipped `LinearMap.range`-style presheaf-of-submodules functor that the project should pivot to;
- (d) No idiom exists — the project's stepwise build (`Set → Submodule → presheaf → sheaf`) IS the correct shape, and the question is purely about how to make Step 1 (`Submodule` upgrade) lightweight.

If a Mathlib idiom exists, **the project should ALIGN_WITH_MATHLIB** — name it, name the cost of pivoting (LOC budget, helper budget), and give a 3-step recipe (or shorter).

### Q2 — `Submodule` upgrade granularity

The current `carrierSet` is a `Set K(C)`. To upgrade to `Submodule kbar K(C)`, the project needs:
- `0 ∈ carrierSet U` (zero closure) — requires `Scheme.RationalMap.order Q 0 ≥ 0` (or `≥ -1`) for every relevant `Q`.
- `f + g ∈ carrierSet U` (addition closure) — requires the non-archimedean inequality on `RationalMap.order` of `f + g`.
- `c • f ∈ carrierSet U` for `c : kbar` (kbar-scalar closure) — requires order of a constant times a rational function.

**Question**: which of these closure proofs are already available in Mathlib via `Mathlib/RingTheory/Valuation/` or `Mathlib/AlgebraicGeometry/` or `Mathlib/FieldTheory/` infrastructure? Specifically:

- Does `Scheme.RationalMap.order` (the project's name) align with Mathlib's `Valuation.toFun` / `IsDedekindDomain.HeightOneSpectrum.valuation` / `multiplicity`-style API? If so, name the alignment and the closure-proof lemmas Mathlib already ships (`Valuation.map_zero`, `Valuation.map_add`, `Valuation.map_smul`, etc.).
- If `Scheme.RationalMap.order` is parallel to a Mathlib API rather than aligned to it, that's a separate finding — flag it.

Recipe target: ≤30 LOC for `carrierSubmodule` (4-7 LOC per closure proof × 3 closures + ~6 LOC the structure).

### Q3 — Sheaf property: gluing-by-stalks vs the constant-sheaf adjunction

The iter-183 docstring's plan for the sheaf property:

> close the sheaf property via the gluing-by-stalks principle (stalk-locality of the order conditions at each prime divisor)

is one route. An alternative the project may not have considered:

- **Constant-sheaf-restriction route**: `K(C)` is a constant sheaf (since `K(C)` is a single field, no descent). A `Subsheaf` of a constant sheaf cut out by *locally checkable* conditions (per-stalk order ≥ k) is automatically a sheaf. Does Mathlib's `Sheaf.subsheafOfHom` / `Subpresheaf.IsSheaf` shipping give this for free, sidestepping a manual stalk-gluing chase?

**Question**: which route does Mathlib's idiom favor, and what's the LOC cost of each? If the constant-sheaf-restriction route is materially cheaper, the project should switch to it.

### Q4 — Project parallel-API risk

Does `Scheme.RationalMap.order` (the project's name) represent a parallel API to Mathlib's existing `IsDedekindDomain.HeightOneSpectrum.valuation` or `Scheme.PrimeDivisor.valuation` (if shipped at b80f227)? If a parallel API exists, the right corrective is to **align the project's `order` with the Mathlib name** before proceeding with the Submodule upgrade — otherwise every closure proof bridges between two parallel APIs.

A parallel-API finding here is `critical` per your descriptor, even if the project's current path "works."

## Project files to read

- `AlgebraicJacobian/RiemannRoch/OCofP.lean` (the full file; ~700 LOC including OCofP-skeleton, `carrierSet`, `carrierSet_mono`, `lineBundleAtClosedPoint` body sketch, `globalSections_iff_*` consumer block at L300+).
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (the `Scheme.RationalMap.order` definition — needed to assess Q4).

## Mathlib files / namespaces to consider for analogues

- `Mathlib/CategoryTheory/Sites/Subsheaf.lean` — `Subpresheaf`, `Subsheaf` (for Q1, Q3).
- `Mathlib/Algebra/Module/Submodule/*` — submodule construction patterns (for Q2).
- `Mathlib/RingTheory/Valuation/*` — Mathlib's valuation API (for Q4 + closure proofs).
- `Mathlib/RingTheory/DiscreteValuationRing/*` — DVR-specific valuation lemmas (for Q2 closure proofs).
- `Mathlib/AlgebraicGeometry/PrimeSpectrum/*` and `Mathlib/AlgebraicGeometry/Properties/*` — prime divisor + height-one spectrum API.
- `Mathlib/AlgebraicGeometry/FunctionField.lean` (if shipped) — `Scheme.functionField`-related infrastructure.

## Persistent analogy file

Per your descriptor, on completion write a persistent analysis at:
`analogies/ocofp-carrierset-submodule-api.md`

It must contain (per the file template):
- Q1–Q4 verdicts (BUILD_PROJECT_HELPER / ALIGN_WITH_MATHLIB / NEEDS_MATHLIB_GAP_FILL / PROCEED).
- For ALIGN_WITH_MATHLIB findings: the Mathlib name, the cost of alignment, the cost of NOT aligning (parallel-API tax).
- A concrete 3-5-step recipe the prover can execute iter-186 to close the `carrierSet → Submodule → presheaf → sheaf` chain.
- LOC budget estimate per step.

## Expected outcome

This consult **gates Lane A's iter-186 re-dispatch** — Lane A is deferred this iter pending your verdict. The iter-185 progress-critic says: "Do not add more helpers until the API question is resolved."

If your verdict is BUILD_PROJECT_HELPER + a clean recipe: iter-186 Lane A fires with the recipe and an explicit "no new helpers beyond the recipe" cap.

If your verdict is ALIGN_WITH_MATHLIB: iter-186 plan-phase dispatches a refactor subagent to pivot the OCofP carrierSet/presheaf chain to the Mathlib idiom, then Lane A fires later.

If your verdict is NEEDS_MATHLIB_GAP_FILL: iter-186 plan-phase decides between filling the Mathlib gap project-side (multi-iter) or rerouting OCofP entirely.

Report at `.archon/task_results/mathlib-analogist-ocofp-carrierset-submodule-api.md`.
