# Mathlib Analogist Directive

## Slug
lane-b-substrate

## Mode
api-alignment

## Context

Lane B (`Genus0BaseObjects/GmScaling.lean`) is the genus-0 rigidity
chart-bridge cross01 lane. iter-188 HARD BAR fired: the blueprint
substrate `IsClosedImmersion.lift_iff_range_subset` was empirically
VERIFIED to be NOT in Mathlib at b80f227 (lean_leansearch × 2
queries: "morphism factors through closed immersion iff range subset"
and "IsClosedImmersion lift range subset" — only the kernel-inequality
form `IsClosedImmersion.lift` and structural `.mk` / `.iff_isPreimmersion`
constructors return).

iter-189 plan-phase committed Option B (project-side substrate build,
~150-200 LOC over 3-5 iters) as the USER-SILENT FALLBACK after
TO_USER.md notice on Lane B with no user reply received.

The substrate has TWO project-side build targets:

1. **`IsClosedImmersion.lift_iff_range_subset`** (the substantive
   substrate). The intended target signature:
   ```
   theorem IsClosedImmersion.lift_iff_range_subset
     {X Y Z : Scheme} (i : Z ⟶ X) [IsClosedImmersion i]
     (f : Y ⟶ X) [IsReduced Y] :
     (∃ g : Y ⟶ Z, g ≫ i = f) ↔ Set.range f.base ⊆ Set.range i.base
   ```
   The reduced-source hypothesis is what reduces the ideal-sheaf
   kernel-inequality to a set-level range-containment.

2. **`IsReduced (Spec ((Away (X_0·X_1)) ⊗_kbar GmRing))`** — the
   intersection scheme is `Spec (B)` where `B = (Away (X_0·X_1))
   ⊗_kbar (GmRing kbar)`. Both factors are domains: `Away (X_0·X_1)`
   via `projectiveLineBar_isReduced` chain (Mathlib `IsLocalization.IsField`
   + degree-0 graded localization machinery); `GmRing kbar` as
   localization of polynomials. The tensor over alg-closed `kbar` is a
   domain — but Mathlib's bridge
   `Algebra.IsGeometricallyReduced` requires `[IsAlgClosed kbar]` in
   the signature (which the project does have on `kbar`, but the
   bridge itself may not exist in Mathlib at b80f227).

The SAME tensor-of-domains-over-alg-closed-field gap ALSO blocks two
other off-target sorries in `GmScaling.lean`:
- `gm_geomIrred` (`GmRing kbar` is geometrically irreducible)
- `projGm_isReduced` (`Spec (kbar[t, t⁻¹])` is reduced)

So **closing this gap unblocks 3 sorries together** — high leverage.

## Question (api-alignment mode)

Look at Mathlib at b80f227 and report:

1. **Does Mathlib have `IsClosedImmersion.lift_iff_range_subset` in any form?**
   Specifically:
   - Is there a result of the form "morphism `f : Y ⟶ X` factors through
     closed immersion `i : Z ⟶ X` iff `range f.base ⊆ range i.base`"
     under any reasonable reduced-source hypothesis (`IsReduced Y`,
     `IsIntegral Y`, etc.)?
   - If not, what is the cleanest variant Mathlib DOES have? The
     iter-188 forensics found only `IsClosedImmersion.lift` requiring
     the kernel-inequality form (ideal sheaf containment `f.ker ≤
     g.ker`).

2. **What is the cleanest path to `IsClosedImmersion.lift_iff_range_subset`
   project-side?** Specifically:
   - Should we use the underlying topological characterization
     (`IsClosed (Set.range i.base)` + `IsClosedImmersion.range_eq_zeroLocus`
     + reduced-implies-ideal-zero on set-level zero-locus)?
   - Or the ring-level characterization (`IsLocalization.ker_le_ker`
     + Nullstellensatz / domain extension)?
   - Estimate the LOC.

3. **What is Mathlib's current status on
   `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` / equivalent
   tensor-of-domains-over-alg-closed result?** Project bug records
   say "confirmed gap iter-184 → iter-188." Verify at b80f227:
   - Is there an `Algebra.IsGeometricallyReduced` instance for
     `R ⊗_k S` when `[IsAlgClosed k]` and both `R`, `S` are integral
     domains over `k`?
   - Is there an `IsDomain` instance for tensor of domains over an
     algebraically closed field?
   - If neither: name the closest available Mathlib infrastructure
     and estimate the LOC to bridge.

4. **Recommend a project-side substrate skeleton** (file layout +
   declaration headers). Where should `IsClosedImmersion.lift_iff_range_subset`
   live (likely a new helper in `Genus0BaseObjects/Cross01Substrate.lean`
   or similar)? What dependencies? Estimate the LOC.

5. **Hard binary verdict** required per iter-189 progress-critic:
   - **(A) FEASIBLE at <80 LOC**: Mathlib has the right substrate;
     name the LOC estimate.
   - **(B) FEASIBLE at 80-200 LOC**: substantive project-side work
     but bounded; name the dependencies.
   - **(C) NOT FEASIBLE at <200 LOC**: USER ESCALATION required;
     route pivot recommended (Lane B retire + Cor 1.5 re-route).

## Dead ends ruled out

Do NOT recommend:
- Path (III.a) / (III.b): both BLOCKED at Mathlib b80f227 per iter-184
  → iter-187 verification (4-5 iter CHURNING).
- `IsClosedImmersion.lift` with the kernel-inequality form: iter-188
  verified this requires the SAME substantive work in disguise (need
  to bridge range-containment to ideal-sheaf-containment via
  reduced-source hypothesis, which is the same gap).
- Mathlib upstream PR with unbounded timeline (Option A): committed
  as backup only.

## Expected report sections

- Section 1: Mathlib `IsClosedImmersion.lift_iff_range_subset` survey at b80f227.
- Section 2: Project-side path to the lift theorem (with LOC estimate).
- Section 3: Mathlib `tensor-of-domains-over-alg-closed` survey at b80f227.
- Section 4: Recommended substrate skeleton file + declarations.
- Section 5: STRICT binary verdict A / B / C with LOC estimate.

## Project-side declarations to consider

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` — Lane B cross01.
- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` — `ProjectiveLineBar`
  ambient definitions.
- `AlgebraicJacobian/Genus0BaseObjects/Points.lean` — `onePt` /
  k-rational point characterizations.
- `references/stacks-varieties.md` — geom-reduced material (Stacks tags
  035U, 04QM, 056T, 0BUG).
- `references/stacks-algebra.md` — tensor product / domain material.
