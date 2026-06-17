# progress-critic — iter-236

Assess convergence of the two routes the planner is considering for prover dispatch
this iter. Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR).

## Route 1 — d.2 stalk-tensor commutation (`Picard/TensorObjSubstrate/StalkTensor.lean`)

Strategy `Iters left` for this phase: ~4–7. Route entered its current phase (d.2 staged
build) at iter-233. Elapsed: iters 233, 234, 235 (this is the 4th, iter-236).

Per-iter signals (K=3):
- iter-233: stage (i)–(ii) FORWARD map `stalkTensorDesc` + 6 helpers. +7 decls, all axiom-clean, 0 sorry. Status COMPLETE-for-stage. Blocker handed off: stage (iii) carrier-duality (CommRingCat/RingCat).
- iter-234: stage (iii) `stalkTensorLinearMap` + 3 helpers. +4 decls, axiom-clean, 0 sorry. Status COMPLETE-for-stage. Named carrier-duality risk identified AND retired (via `erw`/defeq recipe). Blocker handed off: stage (iv) reverse map (nested colimit, ~150–250 LOC, no Mathlib shortcut).
- iter-235: stage (iv) reverse DESCENT — 10 axiom-clean `private` decls (revInnerLeg/revInner/germ_revInner/revInner_germ/revOuterLeg/revBihom/germ_revBihom/revBihom_germ_tmul). +10 decls, 0 sorry. Status PARTIAL: the whole double-colimit descent landed, but the SOLE residual `revBihom_balanced` (the R_x-balancing condition) is NOT landed — documented as an in-file comment, NOT a sorry. lean-auditor ts235 confirmed all 10 decls genuine non-vacuous constructions (no helper-churn).
- Recurring blocker phrase: "CommRingCat/RingCat carrier-duality" / "restrictScalars wall". Appeared iter-234 (resolved at stage iii) and resurfaced iter-235 at the balancing (extra `restrictScalars` wrapper from `map_smul`). The prover handed off a precise NEXT route: prove balancing at the STALK level `revBihom (r•a) b = r•(revBihom a b)` via the T-presheaf `germ_smul` (scalar stays at R_x, no RingCat/restrictScalars carrier) — the same site where stage-(iii) smuls succeeded.

Planner's proposal this iter: ONE prover lane (mathlib-build), close `revBihom_balanced` (route 2 = stalk-level) → `stalkTensorRev` (`TensorProduct.liftAddHom`) → stage (v) `stalkTensorIso` (the bundle: fwd=stalkTensorLinearMap DONE, rev=stalkTensorRev, two inversion identities on germs). The unit is the whole balancing→rev→iso, NOT more sub-helpers.

Key question: is this still CONVERGING (3 consecutive named-stage completions, now at the FINAL balancing+bundle), or is the resurfacing carrier-duality wall a churning signal?

## Route 2 — FlatBaseChange (`Cohomology/FlatBaseChange.lean`)

Strategy `Iters left` for the engine phase: ~30–60 (this is the first ungated sub-lane). Route entered current phase iter-233.

Per-iter signals (K=3):
- iter-233: +3 axiom-clean iso-locality criteria (stalk/basis/affine-open). 0 sorry eliminated (2 deep sorries remain). Status PARTIAL.
- iter-234: Γ-fragment `moduleSpecΓFunctor_pushforward_tilde_iso` attempted; hit a typeclass-instance wall; 0 decls committed, 0 sorry change. Status INCOMPLETE/zero-commit.
- iter-235: YOU (progress-critic ts235) ruled this lane STUCK (4 helpers / 3 iters, 0 sorry eliminated, iter-234 zero-commit on an instance wall the prover called both blocking AND insufficient). Per your must-fix corrective, NO prover ran; the slot was replaced by a mathlib-analogist consult. The consult: (a) found a SOUNDNESS defect — both theorems were FALSE as typed (missing `[F.IsQuasicoherent]`), fixed by a refactor adding the hypothesis (build green, no new sorry); (b) dissolved the instance wall as wrong-altitude (tilde is fully faithful ⇒ `IsIso α ↔ IsIso (moduleSpecΓ α)` for QC modules, reducing to `IsIso` of a concrete `ModuleCat` map via `cancelBaseChange`); (c) reduced the entire affine lane to ONE Mathlib-absent brick `pushforward(Spec.map φ)(tilde M) ≅ tilde(restrictScalars φ M)` (`lem:pushforward_spec_tilde_iso`). The blueprint chapter was reframed around tilde full-faithfulness + this single brick (blueprint-clean PASS).

Planner's proposal this iter: re-engage with ONE prover lane (mathlib-build) on the NEW well-scoped target `lem:pushforward_spec_tilde_iso`, then close `affineBaseChange_pushforward_iso` via the full-faithfulness reframe + `cancelBaseChange`. The deep `flatBaseChange_pushforward_isIso` (Čech+flatness) stays a documented sorry.

Key question: given the STUCK corrective executed (soundness fix + reframe + reduction to a single named brick — a materially different, well-scoped target, NOT cosmetic recipe variation), is re-engaging the lane this iter justified, or should it stay parked?

## PROGRESS.md `## Current Objectives` proposal this iter (2 files)
1. `Picard/TensorObjSubstrate/StalkTensor.lean` — d.2 balancing → rev → iso [mathlib-build]
2. `Cohomology/FlatBaseChange.lean` — build `lem:pushforward_spec_tilde_iso` brick [mathlib-build]
