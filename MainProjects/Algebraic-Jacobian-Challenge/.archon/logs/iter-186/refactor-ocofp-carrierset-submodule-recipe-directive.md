# refactor · ocofp-carrierset-submodule-recipe (iter-186)

## Problem

`AlgebraicJacobian/RiemannRoch/OCofP.lean` `lineBundleAtClosedPoint`
(L224-233) has been a typed `sorry` body for ~18 iters. The iter-185
`mathlib-analogist ocofp-carrierset-submodule-api` returned **2
ALIGN_WITH_MATHLIB critical** verdicts + 3 major + 2 informational,
with a 5-step recipe (~105-110 LOC, all in-project, no Mathlib PRs)
fully documented at:

`analogies/ocofp-carrierset-submodule-api.md` (Recommendation section,
L225-360).

Iter-186 plan-phase dispatches you (the refactor agent) to execute the
recipe. The plan agent has NOT freelanced the recipe; everything you
need is in the persistent analogy file. Read it FIRST.

## Mathematical Justification

The recipe upgrades:
1. `Scheme.IsRegularInCodimensionOne.out`'s exported field from
   `Ring.KrullDimLE 1` to `IsDiscreteValuationRing`. DVR is strictly
   stronger than `KrullDimLE 1` for the stalks of regular-in-codim-1
   schemes (because at coheight-1 points, the local ring is a regular
   local ring of dimension 1, which Stacks tag `00PD` shows is a DVR).
   This unblocks the three `Submodule` closure proofs (`0`, `+`, `kbar •`)
   on `lineBundleAtClosedPoint.carrierSet`, which require `Ring.ordFrac_add`
   (DVR-shipped) and `Ring.ordFrac_of_isUnit` (DVR-shipped).
   The synthesised instance `Ring.KrullDimLE 1` (from `IsDiscreteValuationRing`
   via `IsDedekindDomain` chain) preserves all existing downstream
   consumers (`principal`, `principal_hom`, `principal_degree_zero`,
   the `globalSections_iff_*` helpers, etc.) without any signature change.

2. The sheaf property of `lineBundleAtClosedPoint.presheaf` is built via
   `Presheaf.isSheaf_iff_isSheaf_forget` (the analogist's Decision 3 —
   ALIGN_WITH_MATHLIB critical), mirroring the existing
   `toModuleKPresheaf_isSheaf` template at
   `Cohomology/StructureSheafModuleK/SheafProperty.lean:32-44`. This
   ~40 LOC route is far cheaper than the iter-183 stalk-gluing plan
   (~100 LOC) and matches the project's existing canonical pattern for
   `Sheaf J (ModuleCat kbar)`-valued sheaves on `IsIntegral` schemes
   (which the chapter `RiemannRoch_OCofP.tex` already requires
   structurally).

## Forbidden alternatives (per the analogist)

DO NOT take any of these paths — each was considered + rejected:
- Do NOT prove the non-archimedean inequality from scratch for
  `Ring.KrullDimLE 1` (this is mathematically false: an arbitrary
  `Ring.KrullDimLE 1` local ring need not be a DVR).
- Do NOT route through `IsDedekindDomain.HeightOneSpectrum.valuation`
  (Decision 4 verdict: PROCEED with project's `Ring.ordFrac`
  granularity, no parallel-API trap).
- Do NOT use stalk-gluing for the sheaf property (Decision 3 verdict:
  switch to `isSheaf_iff_isSheaf_forget` per Mathlib idiom).

## Changes Requested (5 steps)

### Step 1 — Class upgrade
**File**: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:171-186`.
**Old**: `Scheme.IsRegularInCodimensionOne` has a field `out` that
exports `Ring.KrullDimLE 1` for each `Scheme.PrimeDivisor`.
**New**: change `out` to export `IsDiscreteValuationRing
(X.presheaf.stalk Y.point)`. Add a separate `instance` (in the
namespace, NOT a field of the class) synthesising `Ring.KrullDimLE 1`
from `IsDiscreteValuationRing` via Mathlib's existing
`IsDiscreteValuationRing.TFAE` / `IsDedekindDomain` chain (DVR ⟹ PID
⟹ Krull-dim-≤-1). LOC: ~10.

**Verification**: the file `WeilDivisor.lean` continues to compile;
all 7 existing consumers (`principal`, etc.) compile without
signature changes (they consume the class `[Scheme.IsRegularInCodimensionOne X]`
generically, not the specific field type). Use `lean_diagnostic_messages`
on every consumer file to confirm.

**Verify NOT protected**: `Scheme.IsRegularInCodimensionOne` is NOT in
`archon-protected.yaml` per the iter-185 analogist verdict (Decision
2b critical recommendation explicitly noted "not in archon-protected.yaml
— refactor subagent safe"). Re-verify before editing.

### Step 2 — `carrierSubmodule`
**File**: `AlgebraicJacobian/RiemannRoch/OCofP.lean`, new declaration
after `carrierSet_mono` (current L181-192). LOC: ~25.

Match the signature/body shape in
`analogies/ocofp-carrierset-submodule-api.md:262-294` (the "Step 2 —
`carrierSubmodule`" block). The 3 closure proofs (`zero_mem'`,
`add_mem'`, `smul_mem'`) discharge via:
- `zero_mem'`: `Scheme.RationalMap.order` on `0` reduces to
  `WithZero.log_zero` (Mathlib).
- `add_mem'`: case-split on `f + g = 0` (trivial) else
  `Ring.ordFrac_add` (DVR-shipped by Step 1's class upgrade) +
  `WithZero.log` monotonicity on the nonzero part.
- `smul_mem'`: `c = 0` → reduces to `zero_mem'`. `c ≠ 0` →
  `algebraMap kbar (stalk) c` is a unit, `Ring.ordFrac_of_isUnit`
  gives order = 0, `Scheme.RationalMap.order (c • f) = order f`.

Insert any TODO-`sorry` for tactical bookkeeping that doesn't close
immediately — the prover phase will fill them, but the structural
sub-call to each Mathlib lemma should be present.

### Step 3 — Presheaf functor
**File**: `AlgebraicJacobian/RiemannRoch/OCofP.lean`, new declaration
after Step 2. LOC: ~30.

Match the signature/body shape in
`analogies/ocofp-carrierset-submodule-api.md:296-313`. The functor's
`obj U := ModuleCat.of kbar ↥(carrierSubmodule P hPcoh U)`;
`map f` is `ModuleCat.ofHom <| Submodule.inclusion (carrierSet_mono ...)`.
`map_id` and `map_comp` discharge via `ext ⟨x, _⟩; rfl`.

### Step 4 — Sheaf property via `isSheaf_iff_isSheaf_forget`
**File**: `AlgebraicJacobian/RiemannRoch/OCofP.lean`, new declaration
after Step 3. LOC: ~40.

Match the signature/body shape in
`analogies/ocofp-carrierset-submodule-api.md:314-342`. The key step
is `rw [Presheaf.isSheaf_iff_isSheaf_forget _ _
        (CategoryTheory.forget (ModuleCat.{u} kbar))]`, then the
Type-valued goal closes via `IsIntegral C.left → IrreducibleSpace
C.left.toTopCat` + density of nonempty opens for the
"overlap-matching ⟹ same `f ∈ K(C)`" step.

Leave bookkeeping `sorry` if you cannot close immediately — the
prover phase will fill them. The structural call to
`Presheaf.isSheaf_iff_isSheaf_forget` is the load-bearing edit; the
post-rewrite Type-valued sheaf check is mechanical for an
`IrreducibleSpace`-with-density argument.

### Step 5 — Bundle
**File**: `AlgebraicJacobian/RiemannRoch/OCofP.lean:224-233`. LOC: ~5.

Replace the `sorry` body with
`⟨lineBundleAtClosedPoint.presheaf P hPcoh,
  lineBundleAtClosedPoint.presheaf_isSheaf P hPcoh⟩`
(per the analogist's Step 5 template at L343-360).

The class hypotheses already in the namespace section are sufficient
(`[IsIntegral C.left]`, `[IsLocallyNoetherian C.left]`,
`[Scheme.IsRegularInCodimensionOne C.left]`).

## Affected Files

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (Step 1: class
  field upgrade + new synthesised instance; ~10 LOC delta; expected to
  re-compile after the new instance lands. Run
  `lean_diagnostic_messages` on every file under `RiemannRoch/`).
- `AlgebraicJacobian/RiemannRoch/OCofP.lean` (Steps 2-5: ~100 LOC of
  new declarations; ~5 LOC body swap at L224-233).
- Downstream consumers of `Scheme.IsRegularInCodimensionOne` and
  `Ring.ordFrac` (recompile-only, no signature changes expected):
  - `RiemannRoch/RationalCurveIso.lean`
  - `RiemannRoch/RRFormula.lean`
  - `RiemannRoch/OcOfD.lean`
  - Any others discovered via `lean_references` on the touched
    declarations.

## Expected Outcome

- `OCofP.lean` sorry count: 25 → ≤22 (Step 5 closes the
  `lineBundleAtClosedPoint` outer sorry; some bookkeeping inside the
  closure proofs may remain as typed `sorry`s for the prover phase to
  fill — that's expected).
- Project sorry count: 82 → ~78-82 net (file-skeleton +
  partial-close pattern; the structural recipe is the deliverable,
  not minimum-sorry).
- 0 → 0 axioms (kernel discipline preserved).
- `lake build AlgebraicJacobian` GREEN.

## Notes for Plan Agent

If during execution you discover ANY of:
- `Scheme.IsRegularInCodimensionOne` IS in `archon-protected.yaml`
  (analogist may have been wrong);
- The `IsDiscreteValuationRing` ⟹ `Ring.KrullDimLE 1` chain doesn't
  ship at the project's pinned Mathlib commit;
- A consumer file breaks in a non-mechanical way (signature change
  required);
- `Presheaf.isSheaf_iff_isSheaf_forget` doesn't ship at the pinned
  commit or has a different signature than the analogist's L315
  template assumes;

THEN STOP and report in the "Notes for Plan Agent" section of your
task_results report. Do NOT silently work around — the iter-186 plan
agent needs to know if the analogist's recipe is wrong about Mathlib
availability.

If the recipe executes cleanly, report:
- The sorry counts before and after per file.
- The list of inline `sorry`s left for the prover phase to fill (with
  line numbers).
- Any Mathlib lemma names you used that differ from the analogist's
  template (e.g. `Ring.ordFrac_add` vs. `Ring.ordFrac_add_le` —
  Mathlib naming may drift).
- Any unexpected downstream breakage and how you fixed it.

## Report

`.archon/task_results/refactor-ocofp-carrierset-submodule-recipe.md`
