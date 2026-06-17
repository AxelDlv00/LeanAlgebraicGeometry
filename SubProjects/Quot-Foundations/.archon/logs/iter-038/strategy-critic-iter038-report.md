# Strategy Critic Report

## Slug
iter038

## Iteration
038

## Routes audited

### Route: FBC

- **Goal-alignment**: PASS — closing `IsIso pushforwardBaseChangeMap` (affine) + the locality globalization is exactly `lem:affine_base_change_pushforward` / `thm:flat_base_change_pushforward`.
- **Mathematical soundness**: PASS — module content is `regroupEquiv` (DONE); iso-ness "free as conjugate of `gammaPushforwardNatIso`" is correct, and the residual is genuinely just the IDENTIFICATION of the abstract conjugate with the defined map.
- **Sunk-cost reasoning detected**: yes — see Sunk-cost flags. The conjugate vehicle is justified partly by the already-assembled `huce` scaffold, not purely on merits.
- **Infrastructure-deferral detected**: no (for FBC itself; the consult is a decision checkpoint, not a deferral of a required construction).
- **Phantom prerequisites**: none — `CategoryTheory.conjugateEquiv` and the full Mates API (`unit_conjugateEquiv`, `conjugateEquiv_symm_apply_app`, `conjugateEquiv_comp`) are present in `Mathlib.CategoryTheory.Adjunction.Mates`. No scheme-level flat-base-change iso exists in Mathlib (`Module.Flat.isBaseChange` is ring-level only), so the bespoke build is correctly justified.
- **Effort honesty**: reasonable — A1 1–4 / A2 3–6 / B 2–4 are honest for a Mathlib-absent multi-hundred-LOC build.
- **Parallelism under-exploited**: yes — the consult and the already-prescribed re-cut spike are serialized when they could run together (see Must-fix).
- **Verdict**: CHALLENGE

### Route: GF

- **Verdict**: SOUND — algebraic core DONE; geometric wrapper is a clean cover/localisation argument bottoming at gap1 (shared with QUOT), correctly gated.

### Route: QUOT (gap1 / QUOT-defs)

- **Goal-alignment**: PASS — gap1 (`IsQuasicoherent M → IsIso M.fromTildeΓ`) is the verified-necessary bridge for the forward annihilator characterization; source-grep already ruled out stalk/local shortcuts.
- **Mathematical soundness**: PASS — (C)+(P1)+(D cover)+`gammaPullbackTopIso`+bridges (I)/(II) DONE; the remaining `σ_V` + semilinearity-of-`gammaPullbackImageIso.hom` is a standard transport-of-localization-iso-along-a-restriction-ring-iso obligation, bounded and well-posed.
- **Infrastructure-deferral detected**: no for gap1 itself.
- **Phantom prerequisites**: none flagged at strategy level.
- **Effort honesty**: reasonable — `σ_V` semilinearity is a nested sub-build folded into QUOT-defs 3–6; within range but see note.
- **Verdict**: SOUND

### Route: QUOT-repr / GR-proper

- **Verdict**: SOUND — decomposition (cells/glue/sep DONE → proper via valuative E4 frontier → quot → repr) is honest; 6–12 iters / ~400–1000+ LOC range is appropriately wide for the deepest target.

### Route: SNAP-S1/S3

- **Goal-alignment**: PARTIAL — `def:hilbert_polynomial` is in `## Goal`; it requires `def:sectionGradedRing`, which requires SheafOfModules tensor powers + lax-monoidal Γ, described as "owed regardless" with no sub-decomposition.
- **Infrastructure-deferral detected**: yes — see Infrastructure-deferral findings.
- **Verdict**: CHALLENGE

## Format compliance

- **Size**: 148 lines / ~11 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — e.g. `tripwire fired @037`, `iter-038: sharpened mathlib-analogist`, `Q2 — … (LIVE @038)`, `the re-cut was never executed`, `analogies/fbc-mate-reencode.md (iter-034) already prescribes`. These iter-tagged phrases in the Phases `Risks` cell, `## Routes` prose, and `## Open strategic questions` are per-iter history that belongs in `iter/iter-NNN/plan.md`.
- **Accumulation detected**: no — completed phases are in `## Completed` (7 rows, within bound); active table is clean.
- **Table discipline**: FAIL (minor) — the FBC-A1 `Status` cell `STUCK (tripwire fired @037 — continue-vs-pivot consult)` is prose, not a short inline tag; should be `STUCK` with the narrative moved to the sidecar.
- **Format verdict**: DRIFTED

## Infrastructure-deferral findings

### Deferred: `def:sectionGradedRing` — SheafOfModules tensor powers `L_s^{⊗m}` + lax-monoidal Γ

- **Required by goal**: yes — `def:hilbert_polynomial` (named in `## Goal`) is defined via the graded ring `⊕_m Γ(X_s, F_s ⊗ L_s^m)`; the tensor powers are needed to even state it.
- **Current plan for building it**: bundled into the BLOCKED SNAP-S1/S3 row (3–6 iters) as "owed regardless"; no sub-decomposition, no standalone estimate, gated behind Open Q1.
- **Timeline**: vague — folded into a blocked phase with no concrete sub-phases.
- **Mitigant the strategy understates**: Mathlib DOES carry `PresheafOfModules.monoidalCategory` and `CategoryTheory.Sheaf.monoidalCategory` (verified). So the build is NOT "Mathlib-absent" wholesale — the monoidal structure exists; only iterated tensor POWERS and lax-monoidal Γ are bespoke. The "Mathlib-gradient sub-build absent" framing overstates the gap.
- **Verdict**: CHALLENGE — decompose into concrete sub-phases (reuse `PresheafOfModules.monoidalCategory`; isolate the lax-monoidal-Γ obligation) with its own estimate, rather than carrying it as "owed regardless."

## Sunk-cost flags

- `the re-cut was never executed (risky cascade through gstar_transpose)` — Why this is sunk-cost: the cure for the 5+-iter blocker was prescribed at iter-034 (re-cut `codomain_read_legs` PROOF-FREE so `_legs` becomes a `conjugateEquiv.injective` identity, "Mathlib API sufficient, no gap-fill") but is being held back to protect the existing assembled `huce` scaffold. Recommendation: judge the re-cut on its merits — the scaffold is a cost already paid, and protecting it is what has produced 5 flat-sorry iters. Run the re-cut as an isolated spike on a scratch copy this iter (cascade risk is contained to the copy) IN PARALLEL with the consult, instead of gating it behind another consult verdict.

## Prerequisite verification

- `CategoryTheory.conjugateEquiv` (+ `unit_conjugateEquiv`, `conjugateEquiv_symm_apply_app`, `conjugateEquiv_comp`): VERIFIED — `Mathlib.CategoryTheory.Adjunction.Mates`.
- Scheme-level flat-base-change-of-pushforward iso: MISSING in Mathlib (only `Module.Flat.isBaseChange`, ring-level) — bespoke build correctly justified, no phantom.
- `PresheafOfModules.monoidalCategory` / `CategoryTheory.Sheaf.monoidalCategory`: VERIFIED — relevant to the SNAP tensor-powers deferral above.

## Must-fix-this-iter

- Route FBC: CHALLENGE — the directive's floated alternative ("prove the affine i=0 iso at the module level via `regroupEquiv`, never form the categorical mate") does NOT escape the wall: identifying the *defined* `pushforwardBaseChangeMap` with `regroupEquiv` at the section level requires unfolding the same `(g'^*⊣g'_*)` counit transpose that `gstar_transpose` encodes, and the element-level normal form of that counit is already a documented dead end (`FlatBaseChange.lean:2097`). This is a "pivot that renames the problem one layer deeper," not an escape — the planner must NOT pivot to it expecting relief. The genuine choice is: (a) execute the prescribed proof-free re-cut of `codomain_read_legs` (collapses `_legs` to `conjugateEquiv.injective`), or (b) the consult surfaces a Mathlib-precedented iso-transfer that proves the SPECIFIC map iso without the identification. Run (a) as an isolated scratch-copy spike this iter in parallel with the consult rather than serializing consult → decide → execute.
- Route SNAP-S1/S3: infrastructure-deferral CHALLENGE — `def:sectionGradedRing` tensor-powers + lax-monoidal Γ is required by `def:hilbert_polynomial` in `## Goal` but carried as "owed regardless" with no sub-decomposition or standalone estimate. Decompose it (reusing the now-verified `PresheafOfModules.monoidalCategory`) and give it a concrete estimate.
- Format: DRIFTED — strip iter-tagged narrative (`@037`, `iter-038`, `LIVE @038`, `iter-034`, "the re-cut was never executed") from the Phases `Risks` cell, `## Routes`, and `## Open strategic questions` into `iter/iter-NNN/plan.md`; reduce the FBC-A1 `Status` cell to a bare tag (`STUCK`).

## Overall verdict

The strategy is mathematically sound and built on verified Mathlib infrastructure — no phantom prerequisites, and the bespoke FBC build is correctly justified because Mathlib carries no scheme-level flat-base-change-of-pushforward iso. The single biggest concern is process, not math: the FBC blocker's cure was prescribed at iter-034 and remains unexecuted to protect the assembled `huce` scaffold, and iter-038 commissions yet another consult rather than spiking the prescribed re-cut — that is deferral-by-consult plus parallelism under-exploitation. Critically, the directive's tempting alternative (prove the affine iso at the module level via `regroupEquiv` and never form the mate) is the same coherence one layer deeper, since the element-level counit normal form is already dead — the planner should not treat it as an escape. Separately, **the strategy defers `def:sectionGradedRing` (SheafOfModules tensor powers + lax-monoidal Γ), which is required for the stated goal `def:hilbert_polynomial`**, carrying it as "owed regardless" with no decomposition; this needs a concrete sub-phase plan (eased by the verified `PresheafOfModules.monoidalCategory`). QUOT gap1, GF, and QUOT-repr are SOUND. Format is DRIFTED on per-iter narrative leaking into prose cells.
