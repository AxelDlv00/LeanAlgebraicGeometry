# Progress Critic Report

## Slug
iter057

## Iteration
057

## Routes audited

### Route 1 — `CechSectionIdentification.lean` (P5a-resolution Sub-brick A)

- **Sorry trajectory**: iter-053 baseline (N), iter-054 N+0, iter-055 N+6 (scaffold), iter-056 N+5 (Stub 3 closed). Net: higher than iter-053 baseline. Within the stubs phase (iter-055→056): 6 → 5 open sorries; 1 of 6 stubs closed. PROGRESS.md says "6 in CechSectionIdentification" but the iter-056 review enumerates exactly 5 open sorry lines (`:76/:125/:212/:301/:366`, Stubs 1,2,4,5,6). The PROGRESS.md sorry count is stale by 1.
- **Helper accumulation**: iter-053: +0; iter-054: +1; iter-055: +1 (engine de-privatization) + 6 scaffold stubs; iter-056: +1 (Stub 3). Total ~3 helpers over 4 iters, 1 stub closed. Sorry count has not strictly decreased over the 4-iter window.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL (4 consecutive).
- **Recurring blockers**:
  - "Stub 1 needs scheme coproduct over fibre product — Mathlib lacks it" (iter-056, implicit in iter-055 scaffold design) — 2+ iters. Prover report confirms: "Mathlib has no coproduct-distributes-over-(iterated)-fibre-product for Scheme… a genuine from-scratch extensive-category build (≫150 LOC). NOT a one-session item."
  - "Stubs 5/6 false-spec → re-state to augmented complex" (iter-056) — provably false finding with an airtight counterexample.
- **Avoidance patterns**: none detected.
- **Throughput**: SLIPPING — strategy estimates ~3–5 iters for the stubs phase (entered iter-055); 2 iters elapsed, 1 of 5 remaining stubs closable (Stub 3 closed; Stubs 5/6 need re-spec; Stub 1 blocked on Mathlib gap).
- **Critical PROGRESS.md inconsistency (must fix before dispatch)**:
  - Objective lists **Stub 3** as first target — it is already closed axiom-clean in iter-056.
  - Objectives for **Stub 5** and **Stub 6** still carry the **FALSE specifications** (`D ≅ D'` and `Homotopy (𝟙 D') 0` for the non-augmented complex). The iter-056 prover report proves these are unprovable; the review independently confirmed via lean-auditor and lvb-csi. If the prover follows these descriptions, it will spend the iter attempting false statements.
  - Dispatching without correcting these descriptions is the same pattern that caused Route 1 to churn for 5+ iters (as the review itself diagnoses: "the decomposition target itself was unprovable").
- **Verdict**: **CHURNING**
  - Triggers met: (1) PARTIAL prover status ≥3 of last K iters (4 consecutive); (2) helpers added in ≥2 of K iters, sorry count net unchanged over the 4-iter window.
- **Primary corrective**: **Blueprint expansion** — write the corrected proof sketches for Stubs 5/6 (augmented complex `D ≅ D'.augment ε hε`, `Homotopy (𝟙 D'_aug) 0` with augmentation-node sheaf-equalizer) into the blueprint chapter AND update the PROGRESS.md objective to remove the false Stub 5/6 descriptions BEFORE any prover dispatch. The 5-iter churn root cause was a blueprint-level false spec; dispatching again without the correction is replaying that churn.
- **Secondary corrective**: **Mathlib analogy consult** on Stub 1 (scheme-level coproduct distributing over iterated fibre products in `Over X`) before the prover targets Stub 1. The recurring "Mathlib lacks it" signal across 2+ iter reports is the fingerprint that needs analogy work, not a prover round. Dispatching a prover at Stub 1 without a confirmed Lean API risks a 5th PARTIAL on that stub alone.

---

### Route 2 — `AffineSerreVanishing.lean` (P5a-consumer Need#2)

- **Sorry trajectory**: iter-053 to iter-056: sorry count in AffineSerreVanishing = 0 throughout. The residual has been parametrized as a hypothesis (`htilde`) rather than closed. No sorry has been eliminated in 4 iters by Route 2 prover work.
- **Helper accumulation**: +0 (iter-053), +1 (iter-054), +5 (iter-055), +7 (iter-056) = **14 helpers over 4 iters**. Sorry count (in the file) = 0 throughout. Net sorry closure = 0.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL (4 consecutive).
- **Recurring blockers**: The core seed (general-affine-open change-of-scheme Čech vanishing) has been the unproved residual across all 4 iters. The framing evolved (Ext transport → two-need split → htilde hypothesis) but the fundamental gap is the same: the route cannot close without a ~150–300 LOC change-of-scheme proof.
- **Avoidance patterns**: none detected (route was structurally corrected in iter-056, not avoided).
- **Throughput**: ON_SCHEDULE for the "split" phase entered at iter-056 (1 iter elapsed, 3–5 estimated). But when viewed across the full 4-iter window, the sorry closure rate is 0.
- **Critical PROGRESS.md inconsistency (must fix before dispatch)**:
  - The PROGRESS.md Lane 2 objective reads: "scaffold + prove the Need#2 declarations for general-affine-open Serre vanishing that **do not yet exist**." It then lists building `affineCoverSystemGeneral`, `standard_cover_cofinal_affine`, `affine_surj_of_vanishing_affine`, etc. and estimates "~40–80 LOC, low risk, NO new Mathlib gap."
  - **All 7 of these declarations were built and verified axiom-clean in iter-056.** The iter-056 review confirms "+8 axiom-clean decls (7 AffineSerreVanishing + 1 CSI Stub 3)" with `lake env lean` exit 0. The prover dispatched against the current PROGRESS.md will find this work already done.
  - The **actual remaining residual** is the `htilde` seed — `IsZero (cechCohomology … p)` for a general affine open V of Spec R. The iter-056 prover report gives a precise statement plus the sound route (V ≅ Spec Γ(V), identify section Čech complex with standard cover of Spec Γ(V), apply existing vanishing). It estimates **~150–300 LOC**, comparable in scope to the `QcohTildeSections` build. This is a **multi-iter** item, not the 40–80 LOC single-session estimate still in PROGRESS.md.
  - The "Off-limits" block still says "Lane-2 ASSEMBLY waits on Need#2 (Lane 2 above)" — this should now read "waits on the htilde seed."
- **Verdict**: **CHURNING**
  - Triggers met: (1) PARTIAL prover status ≥3 of last K iters (4 consecutive); (2) helpers added in ≥2 of K iters AND sorry count net unchanged over 4-iter window.
  - Mitigating factor: iter-056 made a genuine structural correction (the restriction-of-injectives wall was definitively ruled out; the basis-enlargement route has no new Mathlib gap). This is real progress, but does not change the CHURNING verdict.
- **Primary corrective**: **Blueprint expansion** — expand the htilde section of the blueprint with a complete, step-by-step proof sketch for the 150–300 LOC change-of-scheme build (V ≅ Spec Γ(V) → section complex identification → apply existing `sectionCech_affine_vanishing` over Γ(V)) before dispatch. The analogist's "no new gap" estimate was wrong (it missed the `HasVanishingHigherCech` consumer of the seed); the plan agent requires a detailed blueprint scaffold — not a one-liner — before a prover can close 150–300 LOC in one session. Concurrently, update PROGRESS.md Lane 2 to state the actual residual and scope.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (cap: 10)
- **Over the cap**: no
- **Ready but not dispatched**: none identified (OpenImmersionPushforward correctly deferred pending htilde; CechAugmentedResolution correctly deferred pending Sub-brick A; all other files 0-sorry or frozen)
- **Under-dispatch finding**: no
- **Stale objectives finding**: BOTH lanes have stale PROGRESS.md content that will mislead the prover:
  - Lane 1: lists closed Stub 3 as a target; carries FALSE specifications for Stubs 5/6 (the root cause of 5-iter churn per the review)
  - Lane 2: describes 7 already-built declarations as the objective; understates the residual scope by 3–7×
- **Verdict**: **STALE_OBJECTIVES** — PROGRESS.md must be updated for both lanes before prover dispatch. Dispatching against the current PROGRESS.md will cause one or both provers to work on already-completed or unprovable targets.

---

## Must-fix this iter

- **Route 1**: CHURNING — primary corrective: **Blueprint expansion**. Re-spec Stubs 5/6 in the blueprint chapter with the corrected augmented-complex targets (`D ≅ D'.augment ε hε`; `Homotopy (𝟙 D'_aug) 0` with augmentation-node sheaf-equalizer). Update the PROGRESS.md objective to remove closed Stub 3 and replace the false Stub 5/6 descriptions before dispatch. Without this, the prover will attempt provably-false statements — the same pattern responsible for 5 iters of churn.
- **Route 2**: CHURNING — primary corrective: **Blueprint expansion**. Expand the blueprint's htilde section with a detailed (~step-by-step) proof sketch for the 150–300 LOC change-of-scheme seed. Update PROGRESS.md Lane 2 to state the actual residual (htilde seed, ~150–300 LOC) and remove the description of already-completed work. The 40–80 LOC estimate is wrong by 3–7×; dispatching without correcting it sets the prover up for another PARTIAL.
- **Dispatch**: STALE_OBJECTIVES — update PROGRESS.md for both lanes before any prover is dispatched this iter.

---

## Informational

**On the question "is dispatching provers at these isolated builds genuine convergence?"**

Route 2 dispatch (htilde seed): directionally correct once PROGRESS.md is fixed, but the 150–300 LOC scope comparable to QcohTildeSections makes another PARTIAL likely in a single iter. Setting an explicit partial-progress success criterion (e.g., "close the section-complex identification step or escalate") is recommended to avoid an open-ended PARTIAL.

Route 1 dispatch (Stub 1): premature without the blueprint correction of Stubs 5/6 and a Mathlib analogy consult on the scheme coproduct primitive. Dispatching Stub 1 when the prover would also see false Stub 5/6 descriptions in the PROGRESS.md is a recipe for wasted effort. Recommended ordering: (1) blueprint expansion for Stubs 5/6 + Stub 6' proof sketch; (2) Mathlib analogy consult for Stub 1; (3) then dispatch.

**The two lanes are converging on the same object** (change-of-scheme of the section Čech complex along V ≅ Spec Γ(V)), as the iter-056 review notes. A shared-foundation analysis before dispatching two independent provers at related 150–300 LOC builds might save a full iter.

---

## Overall verdict

Both routes are **CHURNING** (4 consecutive PARTIAL statuses each; sorry net unchanged over the 4-iter window). Neither CHURNING verdict is due to a wrong strategic direction — both routes have isolated genuine residuals and the proposed execution steps are directionally correct. The CHURNING label captures a real process problem: the PROGRESS.md has not been updated to reflect iter-056's completed work, carrying false stub specifications (Route 1) and a stale 7-decl objective (Route 2) that will mislead provers into working on already-completed or provably-false targets. The plan agent must update PROGRESS.md and expand the blueprint for both lanes before dispatch. For Route 1, a Mathlib analogy consult on the scheme coproduct primitive is also needed before the Stub 1 prover round. Once those fixes land, dispatching both lanes in iter-057 is the correct move — but the fixes must come first.
