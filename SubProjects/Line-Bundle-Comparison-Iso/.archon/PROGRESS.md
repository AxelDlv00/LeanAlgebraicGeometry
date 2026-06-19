# Project Progress

## Current Stage

prover

## Stages
- [x] init
- [x] autoformalize
- [ ] prover
- [ ] polish

## End-state overview

**Zero inline `sorry` in the dependency cone of the three seed declarations
+ kernel-only axioms**, for the **Line-Bundle Comparison Iso** subproject
(A.1.c.sub of the Algebraic-Jacobian-Challenge). Seeds:

- `lem:pullback_tensor_iso_loctriv` — `pullbackTensorIsoOfLocallyTrivial` (D4′; body CLOSED; transitively
  sorry only via K1 μ-side — **η CLOSED iter-028**, **μ RHS + comparison-assembly CLOSED iter-029**; sole
  residual = `pushforward_lax_mu_comparison_lhs_tmul`, deferred to iter-031 solo lane).
- `lem:dual_isLocallyTrivial` — `dual_isLocallyTrivial` (DUAL route) — **DELIVERED**.
- `thm:rel_pic_addcommgroup_via_tensorobj` — `PicSharp.addCommGroup_via_tensorObj` (consumer; SCAFFOLD,
  gated on seed-1 + terminal).

## Build state (iter-030 plan turn)

- **Tree is currently RED** from a single iter-029 one-token name-shadow at `DualInverse.lean:219`
  (`← map_smul` resolves to project-local `Scheme.Modules.map_smul` under full imports, not
  `LinearMap.map_smul`). Verified fix `← LinearMap.map_smul` closes the goal (`goals:[]`). This break
  stripped ~29 `\leanok` across DualInverse → TensorObjInverse → RelPicFunctor.
- **iter-029 delivered real math, lost to a parallel-lane build-race** (all 3 lanes ran on the import
  chain `Substrate→DualInverse→TensorObjInverse`; the heavy Substrate μ-lane churned the ROOT all session
  so the two downstream lanes never got a green `lake build` window):
  - **Substrate (root, GREEN, committed):** `pushforward_lax_mu_comparison_rhs_tmul` PROVEN; parent
    `pushforward_lax_mu_comparison` body sorry-free (`hom_ext` delegation). 2 residual sorries: `lhs_tmul`
    (L4353), `mu_appIso_collapse` (L4506).
  - **DualInverse (RED, one token from green):** `presheafDualUnitIso_naturality` WRITTEN + verified
    `goals:[]`; file sorry-free; sole blocker = L219 shadow.
  - **TensorObjInverse (RED, paper-complete):** hN `dualUnitIso_dualIsoOfIso` CLOSED + verified `goals:[]`
    (⇒ `tensorObj_unit_self_duality_collapse` fully sorry-free); cocycle `exists_tensorObj_inverse` full
    iso-algebra reduction DERIVED + written in-code; `trivialisation_restrict_compat` not yet typed. 2
    open sorries (L211, L434).
- **Leaf sorries (true disk state, after the L219 fix lands):** Substrate 2 (`lhs_tmul`,
  `mu_appIso_collapse`); TensorObjInverse 2 (`trivialisation_restrict_compat`, cocycle); DualInverse 0.

## iter-030 decision — break the build-race by sequencing the root-churning lane OUT

Root cause of iter-029's "nothing landed" was the 3-way race, NOT a math stall (progress-critic pc030
confirms: real sorry-elimination verified each iter, blocked only on a green build window). Corrective:

1. **Fix the tree (DualInverse one-token) WITHOUT touching the root.** Substrate stays GREEN/untouched, so
   the fix + the TensorObjInverse work both build against a stable root. This lands the eval-core, hN, and
   `tensorObj_unit_self_duality_collapse`, and restores ~29 markers.
2. **Type the paper-complete TensorObjInverse closures** (`trivialisation_restrict_compat` + cocycle) — now
   that a green window exists. pc030 mandate: close BOTH, NO new helpers; a 3rd PARTIAL → STUCK.
3. **Defer Substrate `lhs_tmul`/`mu_collapse` to iter-031 as a SOLO root-churning lane.** pc030: this 1-iter
   deferral is correct sequencing (not avoidance); a 2nd consecutive deferral trips CHURNING-by-avoidance,
   so iter-031 MUST give `lhs_tmul` its solo lane.

Cheapest reversal signal: if the TensorObjInverse lane still can't get a green window (DualInverse fix
delayed), fall back to DualInverse-fix-alone next iter (deterministic green), then TensorObjInverse solo.

## Gate status (iter-030)

- **blueprint-reviewer: SKIPPED** — rev029 cleared the HARD GATE for `Picard_TensorObjSubstrate.tex`
  (`% archon:covers` Substrate + DualInverse + TensorObjInverse); every this-iter target
  (`presheafdualunitiso_naturality`, `trivialisation_restrict_compat`, `tensorobj_inverse_invertible`, hN
  `dualunitiso_dualisoofiso`) already has a gate-cleared block. No chapter edited this iter; no live must-fix.
  (Rationale in `iter/iter-030/plan.md`.)
- **progress-critic pc030:** Route A (TensorObjInverse) CHURNING but **"planner corrective IS correct"**;
  Route B (DualInverse) fast-track-CONVERGING; Substrate 1-iter deferral OK; **dispatch=OK**. Must-fix:
  close BOTH TensorObjInverse sorries with pre-derived algebra (no new helpers); apply the one-token
  DualInverse fix; iter-031 = `lhs_tmul` solo lane (recorded).
- **strategy-critic: SKIPPED** — STRATEGY.md substantively unchanged (cosmetic estimate refresh; routes /
  decomposition / goal identical to the sc024-SOUND state); no route swap this iter (build-fix + same lanes;
  `lhs_tmul` sequenced, not swapped). (Rationale in `iter/iter-030/plan.md`.)
- lean-auditor iter029 sole must-fix = the L219 build break (= Objective 1). blueprint-doctor clean; leandag
  gaps=0, frontier=5.

## Current Objectives

1. **`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`** — **build-break fix only**,
   `[prover-mode: prove]`. ONE change: at **line 219**, inside `private lemma linearEndo_apply_comm`, change
   the rewrite `← map_smul` to `← LinearMap.map_smul` (under full imports the bare `map_smul` resolves to the
   project-local `Scheme.Modules.map_smul`, whose `ConcreteCategory.hom … • …` pattern does not match the
   goal `g x = x • g 1`; `LinearMap.map_smul` is the intended one). Verified: the corrected line
   `rw [← smul_eq_mul, ← LinearMap.map_smul, smul_eq_mul, mul_one]` yields `goals:[]`. Do NOT add or change
   anything else in this file (it is otherwise sorry-free and complete). Finish ASAP so the import frees for
   the TensorObjInverse lane. This lands `presheafDualUnitIso_naturality` and (via importers) hN
   `dualUnitIso_dualIsoOfIso` + `tensorObj_unit_self_duality_collapse`, restoring ~29 markers. Blueprint:
   `chapters/Picard_TensorObjSubstrate.tex` (`lem:presheafdualunitiso_naturality`).

2. **`AlgebraicJacobian/Picard/TensorObjInverse.lean`** — close the two remaining cocycle-A residuals,
   `[prover-mode: prove]`. **pc030 must-fix: close BOTH using the pre-derived algebra — add NO new helpers;
   a 3rd PARTIAL on this route → STUCK.** Both proofs were paper-validated iter-029 but never typed (the
   build-race denied a green window — which the Objective-1 fix now provides). Build the file with `lake
   build`/LSP only AFTER the DualInverse import resolves green; reference `presheafDualUnitIso_naturality` by
   its frozen signature (robust to edits).
   - **`trivialisation_restrict_compat` (L183, sorry@L211)** — restriction-functor naturality of the
     trivialisation iso-chain, per-index `image_preimage_of_le` eqToHom bookkeeping. MIRROR proved
     `restrictIsoUnitOfLE` (TensorObjSubstrate L424; `analogies/cocycle-a.md` §A). Memory
     [[restrictfunctor-glued-morphism-pattern]]: `SheafOfModules.Hom.ext` before `PresheafOfModules.hom_ext`;
     conjugate `eqToHom` flanks via `eqToHom_comp_iff` + `exact`-matched naturality; forward `rw [naturality]`
     fails on the X-vs-restrict defeq (use `erw`/`exact`).
   - **Cocycle `exists_tensorObj_inverse` (L302, sorry@L434)** — type the in-code `/- Planner strategy -/`
     reduction (paper-validated iter-029): `erw [trivialisation_restrict_compat …]` reduces both overlap legs
     to one `t`; `dualIsoOfIso_trans` (order flips) + insert `dual_unit_iso ≪≫ dual_unit_iso.symm = 𝟙` give
     `dualLeg eMj = dualLeg eMi ≪≫ sConj`; `tensorObjIsoOfIso_trans` factors the RHS; then
     `tensorObjIsoOfIso t sConj ≪≫ tensorObj_unit_iso = tensorObj_unit_iso` is EXACTLY
     `tensorObj_unit_self_duality_collapse t` (now sorry-free). The sectionwise goal lifts to this iso
     equation by `congrArg` on the shared wrapper. NEVER sheafify-the-eval (d.2 dead-end).
   Closing both closes the terminal (the decoupled half of the cone). Blueprint:
   `chapters/Picard_TensorObjSubstrate.tex` (`lem:trivialisation_restrict_compat`,
   `lem:dualunitiso_dualisoofiso`, `lem:tensorobj_inverse_invertible`).

(Substrate `lhs_tmul`/`mu_collapse` DEFERRED to iter-031 solo lane — see Build state. RelPicFunctor seed-3
BLOCKED on seed-1 K1.)

## Standing deferrals

- **Seed-1 μ-side `lhs_tmul` + `mu_appIso_collapse` — DEFERRED iter-030, MANDATORY iter-031 solo lane.**
  Must run as the ONLY root-churning (Substrate-editing) lane that iter to avoid the build-race. Recipe in
  `task_pending.md` Seed-1. pc030: a 2nd consecutive deferral = CHURNING-by-avoidance.
- **Scaffold target (decl does not exist yet — NOT fill-sorry):** `PicSharp.addCommGroup_via_tensorObj`
  (seed 3, `RelPicFunctor.lean`); gated on seed-1 (K1 collapse lemmas) + the terminal. Stays BLOCKED on the
  critical path (`map_add` rides the seed-1 comparison iso).
- **Doc-refresh debt (non-blocking):** stale headers/in-proof comments in `TensorObjSubstrate.lean`
  (L46–47 sorry-location, L162), `DualInverse.lean` (L19/L44 reference a `dual_restrict_iso` Step-4 sorry
  that no longer exists), premature "closed" comments while RED (lean-auditor iter029). `Vestigial.lean` +
  dead `section PullbackLanDecomposition`. Fix opportunistically.
- **Coverage / file-split debt (deferred phase):** ~99 `lean_aux` decls unmatched (bulk pre-existing);
  `TensorObjSubstrate.lean` (>3600 LOC) split. `linearEndo_apply_comm` is `private` (leaves the scan; no
  blueprint entry owed). Scheduled `Coverage + file-split` phase; defer until a seed lane lands.
- **AJC Lan-decomposition block** (`extendScalars`/`pullback0`/`pullbackLanDecomposition`) — NOT ported
  (dead code; not in any seed cone).
- **Extraction note:** module names, file paths, blueprint labels unchanged from the parent so proved seeds
  merge back cleanly. Sibling extracts (Cech-Cohomology, Quot-Foundations) cover disjoint cones.
