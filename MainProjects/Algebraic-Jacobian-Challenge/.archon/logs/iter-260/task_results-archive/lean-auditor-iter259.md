# Lean Audit Report

## Slug
iter259

## Iteration
259

## Scope
- files audited: 4
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/SheafOverEquivalence.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L22 (module header, §3 "Engine corollary" strategy block): "**Next iter**: redirect `LineBundleCoherence.chartOverIso` to this declaration, closing the last open sorry in the coherence engine." — this action was completed this same iter (`LineBundleCoherence.lean:220` already delegates via `Scheme.Modules.chartOverIso U M e`). Stale directive; will mislead the next planner.
  - `set_option backward.isDefEq.respectTransparency false in` on `restrictOverIso` (L256): scope is tightly constrained to the single declaration. The justification is documented in the accompanying comment (discrimination-tree mismatch between `↥(↑U : Scheme)` and `↥U` carrier forms). The two `haveI` calls inside explicitly call `inferInstance` and rely on this option; the `@Functor.isContinuous_comp` call is explicit and does not. The ring-equality goal `pushforwardCongr ?heq` is closed by `simp/erw/simp` without any suspect `rfl` claim. The option is justified and not masking deeper fragility.
  - `restrictFunctor_eq_pushforward_psiRestrict` (L245–246): claims `rfl` (definitional equality) between `restrictFunctor U.ι` and `SheafOfModules.pushforward (psiRestrict U)`. The `psiRestrict` def is constructed verbatim from the internals of `restrictFunctor` (as documented), so `rfl` is plausible; this is not a suspect body.
  - Private helpers `psiRestrict`, `overForgetNatIso` are clean and purpose-built; no near-duplicates of existing Mathlib declarations found.
  - `overEquivInverseIsContinuous` / `overEquivFunctorIsContinuous` (L105–118): instance-bridging declarations using `change` to the `↥U` form. These are not near-Mathlib duplicates; they exist specifically because the scheme-carrier form `↥(↑U : Scheme)` is not found by the instance discrimination tree.
  - No `sorry`s in this file.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Module header status note** (L43–45): states "There is now ONE tracked typed-`sorry` residual: the deferred `⊗`-inverse lane (`exists_tensorObj_inverse`, ~L690…)". As of this iter there are **three** `sorry`s in this file: `exists_tensorObj_inverse` (L715), `pushforwardComp_lax_μ` (L2169), and `pullbackTensorMap_restrict` (L2399). The count is wrong and will mislead the next plan agent about progress. This is a major stale-comment finding.
  - **`pushforwardComp_lax_μ` body comment** (L2167): "(Informal agent unavailable this iter: MOONSHOT key rejected with 401; no other key set.)" — This is a tooling-workflow note embedded in a mathematical proof comment. It is not relevant to the code and will become stale immediately. Should be removed.
  - `pushforwardComp_lax_μ` (L2143–2169): `sorry` is accurately documented in the docstring ("**Status (iter-259): NOT closed.**") and the body comment ("GENUINE GAP…"). The claim "NOT rfl" is stated with justification. The `ext W x; sorry` structure correctly identifies the sectionwise residual. No excuse-comment issues.
  - `pullbackComp_δ` (L2185–2304): proven (no `sorry` in its body). It calls `pushforwardComp_lax_μ` at L2283, so it is NOT axiom-clean (it transitively depends on a `sorry`). The docstring says "reduces Sq2b to `pushforwardComp_lax_μ`" which correctly documents this dependency. The long strategy-roadmap comment at L2204–2240 is detailed but not dead — it explains the mate-calculus proof structure and accurately describes what each step does. No dead/commented scratch.
  - `toRingCatSheafHom_comp_hom_reconcile` (L2121–2125): `rfl`, axiom-clean. The claim "DEFINITIONAL" in its enclosing comment (L2379) is confirmed by the `rfl` body.
  - `pullbackTensorMap_restrict` (L2327–2399): `sorry` at L2399. The ITER-257/258/259 scaffolding comment at L2358–2397 is detailed and accurate. The sorry is at the end of the declaration, matching the "typed `sorry` retained at the intended signature" convention. No excuse-comment.
  - The `set_option maxHeartbeats` bumps at L1701, L1743, L1902, L1939, L2002 are accompanied by comments explaining the source of heartbeat pressure (sheafification-laden composites, `erw` defeq matching). None appear to be masking proof incorrectness.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`dual_restrict_iso` STATUS NOTE** (L300–314, the iter-259 update): states "GATED: `restrictOverIso`/`unitOverIso` are not yet green (in-flight in the parallel SheafOverEquivalence lane); adding `import …SheafOverEquivalence` now re-introduces the iter-257 cross-lane compile race. Close NEXT iter once the shared root is fully green + stable." — **As of iter-259, both `restrictOverIso` and `unitOverIso` are fully proven in `SheafOverEquivalence.lean` (no `sorry`s).** The gating condition has been removed. This stale claim will mislead the next plan agent: route (1), the "consumer one-liner", is no longer gated and can be attempted immediately. This is a major stale-comment finding.
  - `sliceDualTransport` (L184–235): `sorry` at L235. Docstring says STATUS (iter-258, HELD) with a clear construction plan. The claim in the STATUS NOTE that the probe confirms `refine LinearEquiv.toModuleIso ?_` reduces the goal to a `𝒪_Y(V)`-linear equivalence is specific and verifiable. No excuse-comment; the sorry is correctly held awaiting the shared root.
  - `dual_restrict_iso` (L237–360): Two `sorry`s — the first is inside `sliceDualTransport` (transitively), the second at L360 is the naturality assembly residual (`PresheafOfModules.isoMk` naturality for `sliceDualTransport`). The comment at L356 ("it is left as the assembly residual, per the planner bar") is appropriate.
  - `dual_isLocallyTrivial` (L436–445): no `sorry` of its own; transitively inherits from `dual_restrict_iso`. The file header at L38–39 says "TRANSITIVELY PARTIAL (depends on `dual_restrict_iso` Step-4 sorry at ~L254)" — this is accurate.
  - `homOfLocalCompat` (L617–786): no `sorry`. The extensive docstring (the `/-...‑/` planner strategy block at L563–615) is retained for navigation but is not dead or misleading. The `set_option backward.isDefEq.respectTransparency false in` at L545 is scoped to one declaration with the same justification as in `SheafOverEquivalence.lean`.
  - `presheafDualUnitIso`, `dual_unit_iso`, `unitDualSectionEquiv`, `dualUnitIsoGen`: all axiom-clean, no `sorry`s.

---

### AlgebraicJacobian/Picard/LineBundleCoherence.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Module header at L63: "Once those three close, this engine becomes fully axiom-clean with no further edits here." — The three isos referred to (`overEquivalence`, `restrictOverIso`, `unitOverIso`) **were all closed this iter** in `SheafOverEquivalence.lean`. The comment now reads as a conditional that has been satisfied but not acknowledged. Minor stale framing.
  - `chartOverIso` (L217–220): correctly delegates to `Scheme.Modules.chartOverIso U M e`. No `sorry`. The delegation is the correct shared-root approach.
  - `chartPresentation`, `isFinitePresentation`, `isFiniteType`, `chart_free_rank_one`: all `sorry`-free, axiom-clean. Proofs are straightforward.
  - `freeUnitIso`, `unitPresentation`, `unitGenerators`: clean constructions. The `Presentation.IsFinite` instance at L187–189 is correct.
  - No `sorry`s in this file. The `#check` probes mentioned in the module header (L97) are not present in the actual file; they were likely removed after the de-risk was confirmed.

---

## Must-fix-this-iter

None. No excuse-comments, no weakened-wrong definitions, no parallel Mathlib APIs, no suspect bodies, no unauthorized axioms found in the four audited files.

---

## Major

- `TensorObjSubstrate.lean:43–45` — Module header status note claims "ONE tracked typed-`sorry` residual" but there are currently THREE `sorry`s in this file (`exists_tensorObj_inverse` L715, `pushforwardComp_lax_μ` L2169, `pullbackTensorMap_restrict` L2399). The count is factually wrong and will mislead the plan agent about progress.
- `TensorObjSubstrate/DualInverse.lean:303–308` — STATUS NOTE in `dual_restrict_iso` claims `restrictOverIso`/`unitOverIso` are "not yet green (in-flight in the parallel SheafOverEquivalence lane)". Both are fully proven in `SheafOverEquivalence.lean` as of iter-259; route (1) (the "consumer one-liner") is no longer gated. Stale claim directly relevant to planning.
- `SheafOverEquivalence.lean:22` (§3 strategy block) — "**Next iter**: redirect `LineBundleCoherence.chartOverIso` to this declaration" — the redirect was already done this iter. Stale directive.

---

## Minor

- `TensorObjSubstrate.lean:2167` — "(Informal agent unavailable this iter: MOONSHOT key rejected with 401; no other key set.)" embedded in `pushforwardComp_lax_μ`'s proof comment. Tooling-workflow note unrelated to the mathematical content; will become stale immediately.
- `TensorObjSubstrate/DualInverse.lean:222` — `sliceDualTransport` STATUS says "iter-258, HELD" but the iter-259 findings (SheafOverEquivalence fully proven) should update this to reflect the current state.
- `LineBundleCoherence.lean:63` — "Once those three close, this engine becomes fully axiom-clean" — the three isos did close this iter; phrasing implies a future action that has already occurred.

---

## Excuse-comments (always called out separately)

None found. No declarations in any of the four files carry comments admitting that the code is temporarily wrong, placeholder, or to-be-replaced.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: All four files are structurally sound with no excuse-comments or wrong definitions; the three major findings are stale status claims about (1) the sorry count in `TensorObjSubstrate.lean`, (2) the gating status of `restrictOverIso`/`unitOverIso` in `DualInverse.lean`, and (3) a completed redirect directive left in `SheafOverEquivalence.lean` — all require one-line updates to keep the plan agent accurately informed.
