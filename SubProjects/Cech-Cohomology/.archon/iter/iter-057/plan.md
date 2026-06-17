# Iter-057 plan — both iter-056 lanes returned honest PARTIAL; isolated + de-risked 2 genuine builds, effort-broke the Stub-1 wall, cleared the HARD GATE, dispatched 3 parallel mathlib-build lanes

## Entering state (verified from iter-056 prover results)
- **Lane 2 (`AffineSerreVanishing.lean`):** +7 axiom-clean decls — `affineCoverSystemGeneral` + cofinality/
  surjectivity generalizations + reduction tops — reduced general-affine-open Serre vanishing end-to-end to
  ONE isolated hypothesis `htilde` (the change-of-ring section Čech seed). sorry 0→0.
- **Lane 1 (`CechSectionIdentification.lean`):** closed Stub 3 (`pushPull_leg_sections`); **disproved Stubs
  5/6** (consumer needs the AUGMENTED complex `D'_aug`, not non-augmented `D'` — airtight counterexample,
  auditor-confirmed). Stub 1 (`cechBackbone_left_sigma`) blocked, claimed "Mathlib has no scheme
  coproduct/fibre-product distribution (≫150 LOC)". sorry 6→5.
- Inline sorry entering: 5 CSI + 2 frozen + 1 `CechAugmentedResolution:229` + 2 `OpenImmersionPushforward`. Build GREEN.

## What I did this phase
1. Processed both iter-056 prover results → `task_done.md` (prepended iter-056 + the missing iter-055 entry)
   + refreshed `task_pending.md` header; cleared the 5 iter-056 result files (2 prover + 3 review subagents).
2. **Wave 1 — 4 read-only/advisory subagents in parallel:**
   - **progress-critic `iter057` → both CHURNING, but a PROCESS problem** (stale PROGRESS + false Stub-5/6
     specs + glossed seed sketch), NOT wrong direction. Corrective for both = blueprint expansion + PROGRESS
     rewrite; Route 1 also a Mathlib analogy consult on Stub 1. "Dispatching both lanes is correct ONCE fixes land."
   - **strategy-critic `iter057` → SOUND.** Must-fix: P5a-resolution effort honesty (widen/decompose). Non-
     blocking: Need#1 standalone-`Ext` clause; format trims. Adjudicated Need#1 transport SOUND (equivalence,
     not the `j^*` wall) + confirmed no circularity.
   - **blueprint-reviewer `iter057` → chapter partial/partial, HARD GATE BLOCKED.** 4 must-fix: re-spec
     Stubs 5/6 → `D'_aug`; new change-of-ring seed block; clear 7-node coverage debt.
   - **analogist `genaffine-seed` → PROCEED route B1** for the Lane-2 seed (S=Γ(V) via M⊗_R S, per-σ
     base-change localization from `Mathlib.RingTheory.Localization.BaseChange`, co-locate in CechAcyclic).
     Recipe `analogies/genaffine-cech-seed.md`.
3. **Wave 2 — executed the correctives:**
   - **analogist `stub1-coproduct`** (progress-critic's Route-1 corrective) → KEY CORRECTION: `Scheme` IS
     `FinitaryExtensive`; the iter-056 "Mathlib lacks it" was WRONG for the binary case. Only the wide/
     iterated distributivity is a genuine gap. Recipe `analogies/stub1-scheme-coproduct.md`.
   - **blueprint-writer `cech-fixes`** → all 4 must-fix (Stubs 5/6 → `D'_aug` + augmentation-node sheaf-
     equalizer sketch; new `lem:affine_cech_vanishing_general_seed` route B1; 7 coverage-debt blocks +
     wire-ups). leandag lean_aux 8→1 (remaining = the documented dead `CechAcyclic.affine`).
   - **effort-breaker `stub1`** → split `lem:cech_backbone_left_sigma` into 3 sub-lemmas (2 mechanical/
     independent + the hard `coproduct_distrib_fibrePower`) + 5 Mathlib anchors.
   - **blueprint-clean `iter057`** (purity) + **scoped blueprint-reviewer `iter057-recheck`** → chapter
     **complete:true / correct:true, 0 must-fix** → **HARD GATE CLEARS** for all covered files (fast path).
4. Updated STRATEGY.md (P5a-resolution estimate widened ~4–8/~250–450; P5a-consumer row → "seed" status with
   route B1; Need#1 standalone-`Ext` CLARIFICATION clause). Updated PROGRESS.md (3 lanes) + this sidecar.

## Decisions made

### D1 — Respond to both-routes CHURNING with the prescribed correctives, NOT a bare re-dispatch.
The progress-critic was explicit: the CHURNING is a process failure (stale objectives carrying the false
Stub-5/6 specs + a glossed seed sketch), and dispatching both lanes IS correct once the blueprint/PROGRESS
fixes land. I executed every named corrective this phase (blueprint re-spec, seed block, Stub-1 analogy
consult + effort-break, PROGRESS rewrite, gate re-clear). This is the required must-fix response, not
another reworded lane.

### D2 — Lane 1 (seed) = the cleanest foundational build; route B1, co-located in CechAcyclic.lean.
The analogist's PROCEED on route B1 (change base to S=Γ(V) via the algebraic M⊗_R S, NOT the sheaf-level
Γ(V,~M)) reuses the polymorphic private `SectionCechModule`/`SectionCechTilde` core verbatim and the
shipped full-span `sectionCech_affine_vanishing`. The single new ingredient is the per-σ base-change
localization instance (~30–50 LOC, backed by `Mathlib.RingTheory.Localization.BaseChange`). LOC ~230–320,
multi-iter — partial-progress bar set (per-σ iso + spanning lemma + as much ladder as possible).
Reversal signal: if the per-σ base-change instance hits an unbreakable `IsScalarTower`/semiring diamond
beyond the `change`/defeq workaround, reconsider the sheaf-level B2 route (more expensive).

### D3 — Lane 2 (Stub 1): effort-break FIRST (done), then dispatch the prover at the DECOMPOSED pieces.
The Stub-1 analogist disproved the iter-056 "no Mathlib" claim (`Scheme` is `FinitaryExtensive`; binary
distributivity + open-immersion-pullback-as-intersection are off-the-shelf) and recommended effort-breaking
before any prover. I effort-broke into 3 sub-lemmas: the prover this iter closes the 2 mechanical/
independent ones (`cechBackbone_obj_widePullback`, `widePullback_openImm_inter`) and attacks the hard
abstract wide distributivity (`coproduct_distrib_fibrePower`, ~120–200 LOC, a 2–3-cycle build) handing off.
This converts the "≫150 LOC wall" into ready pieces + one isolated hard leaf — the opposite of churn.

### D4 — Added Lane 3 (Need#1 isoSpec Ext transport), an INDEPENDENT third lane.
Need#1 (`modulesIsoSpecExtTransport`) is independent of both the seed (Need#2's residual) and Stub 1; its
blueprint block is sound (reviewer-confirmed) and its Mathlib deps verified (strategy-critic). The progress-
critic assessed only my 2-file proposal; adding an independent, gate-cleared, critical-path lane is a
justified parallelism expansion (standing directive), not a contradiction of the critic. It builds the
whole-scheme module-category equivalence + `Ext.mapExactFunctor` step, leaving the `_acyclic`/`_comp`
assembly (which needs all of Need#1+Need#2) for next iter.

### D5 — Disproved the iter-056 review's "shared foundation" hypothesis.
iter-056 review suggested Lane-1 contractibility and Lane-2 seed are "siblings of one geometry" (change-of-
scheme of the section complex along V≅SpecΓV) worth a shared foundation. On inspection they are NOT the
same: Lane-1's cover `{coverOpen i ⊓ V}` (with `V ≤ coverOpen i₀`) CONTAINS a member `= V`, so its
contractibility is purely COMBINATORIAL (prepend-`i_fix`, no affineness, no change-of-scheme); Lane-2's
cover `{D(gᵢ)}` of a general affine `V` does NOT contain `V`, and vanishing genuinely comes from affineness
via change-of-ring. No shared extraction; sequenced as independent lanes. Recorded so the next planner
doesn't chase a false unification.

## Soundness / disproof checks
- The seed statement (`htilde`) is non-vacuous (auditor iter-056 confirmed; e.g. n=1, g=const f is a real
  instance) and the route B1 is verified end-to-end by the analogist with real Mathlib citations.
- Need#1 soundness adjudicated by the strategy-critic (equivalence, not the `j^*` wall) — no re-derivation
  of the restriction-of-injectives wall, because the transport rides `Scheme.isoSpec` (a genuine iso),
  and the ambient↔concrete bridge stays the 01EO Čech comparison at the section level.

## Subagent skips
- strategy-auditor: not dispatched — strategy-critic (SOUND, deep) + blueprint-reviewer covered the
  reference-alignment surface this iter; no new route was opened that needs PDF-level structural audit.
- dag-walker: not dispatched — the effort-breaker + writer already made the active cone (seed, Stub-1 split,
  Need#1) complete with accurate `\uses{}`; the scoped re-review confirmed 0 unknown_uses.
