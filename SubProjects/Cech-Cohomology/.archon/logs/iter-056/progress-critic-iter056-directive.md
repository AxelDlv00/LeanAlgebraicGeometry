# Progress-critic directive — iter-056 convergence audit

Assess convergence (NOT strategy soundness, NOT math correctness) of the two active prover routes,
using only the per-route signals below. K = 5 iters.

## Route 1 — Sub-brick A / `cechAugmented_exact` resolution input
Files: `CechAugmentedResolution.lean` (consumer) + `CechSectionIdentification.lean` (NEW shared
section-identification chain, scaffolded iter-055).
Strategy: P5a-resolution row. `Iters left` estimate = ~2–3; phase entered ~iter-051.

Signals (per iter):
- iter-051: object layer built; `cechAugmented_exact` PARTIAL. helpers +several.
- iter-052: import-cycle discovered; file relocation needed. PARTIAL. helpers +3 site lemmas.
- iter-053: whole theorem WIRED axiom-clean to ONE residual `hSec`. PARTIAL. helpers +2.
- iter-054: residual sharpened to `Homotopy (𝟙 D) 0`; identified as Sub-brick A (= same L1 wall as
  dead `CechAcyclic.affine`). PARTIAL. helpers +1. **progress-critic iter-054 verdict: CHURNING.**
  Corrective ordered = structural blueprint expansion + extraction.
- iter-055: executed the sanctioned STRUCTURAL corrective — extracted Sub-brick A into the new
  `CechSectionIdentification.lean` with 6 well-decomposed blueprint-faithful stubs; deprivatized the
  `CombinatorialCech.Dependent` engine; built consumer glue `isZero_homology_of_iso_homotopy_id_zero`
  (axiom-clean). PARTIAL. **BUT the scaffold shipped with trivial signature errors → build RED.**
  0 sorry closed; +6 NEW stub sorries (the decomposition) + 1 helper.
- Recurring blocker phrase: "Sub-brick A section identification `Γ(V,pushPullObj F Y)≅∏_σ Γ(U_σ∩V,F)`".

Planner's iter-056 proposal for Route 1: fix the RED build (refactor, plan phase), then dispatch a
prover on `CechSectionIdentification.lean` to CLOSE the 6 stubs bottom-up (Stub 3 LOW, Stub 1 MEDIUM,
Stub 6 MEDIUM, Stub 2 HARD, Stubs 4/5 assembly). This is the convergence follow-through the iter-055
review explicitly demanded ("close sub-stubs, start LOW/MEDIUM, do NOT re-route again").

## Route 2 — open-immersion f_*-acyclicity (`OpenImmersionPushforward.lean`)
Strategy: P5a-consumer row. `Iters left` estimate = ~2–3; phase entered ~iter-053.

Signals (per iter):
- iter-053: `isAffineHom_of_affine_separated` built; both tops reduced to shared bridge (1). PARTIAL. +1.
- iter-054: `_acyclic` wired axiom-clean down to ONE Serre leaf `IsZero ((pushforwardSectionsFunctor j W).rightDerived q).obj H`; `_comp` re-signed `A≅B`. PARTIAL. +4 helpers.
- iter-055: geometric corepresentability half DISCHARGED — sections functor corepresented by
  `jShriekOU(j⁻¹W)`; residual RESHAPED to coyoneda form
  `IsZero ((preadditiveCoyoneda(op (jShriekOU(j⁻¹W)))).rightDerived q).obj H`. PARTIAL. +5 axiom-clean.
  Remaining = (a) coyoneda.rightDerived ≅ Ext^q reindexing (off-the-shelf Mathlib, ~120–180 LOC,
  closeable) + (b) **change-of-scheme Serre vanishing for a general affine open** (the prover flags
  this as the DOMINANT blocker — absent infrastructure; not closeable without new infra).
- 0 sorry closed any iter; residual reshaped (genuinely cleaner) each time.

Planner's iter-056 proposal for Route 2: keep the `OpenImmersionPushforward.lean` lane on Bridge (a)
(coyoneda→Ext reindexing — genuine closeable progress) AND separately set up the change-of-scheme
Serre vanishing wall (b) via blueprint-writer + effort-breaker THIS iter (no prover on it yet — no
decomposition exists). Question for you: is keeping the OpenImmersionPushforward lane productive, or
is reshaping-without-closing a churn signal that should halt the lane until (b)'s infra is built?

## What I need from you
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) + for any CHURNING/STUCK the corrective
TYPE. In particular: is Route 1's iter-056 close-stubs plan the correct convergence step (vs. another
structural round)? And is Route 2's reshape-without-close pattern churn, or honest reduction onto a
named foundation that now needs a dedicated infra lane?
