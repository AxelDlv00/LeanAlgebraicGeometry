# Blueprint Review Report

## Slug
fastpath-tos271

## Iteration
271

## Scope note
Fast-path re-review focused on `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Full multi-chapter audit was performed in iter-270; this pass re-adjudicates the hard gate specifically for the two active prover lanes (`sliceDualTransport.invFun` + round-trips in DualInverse.lean; `sheafificationCompPullback_comp_tail` R1/R5 recovery in TensorObjSubstrate.lean) and evaluates whether the 9 forward-reference pins (now annotated) are the only residual.

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **[must-fix, DualInverse.lean lane]** Prose error in `lem:slice_dual_transport` proof, lines 5914–5923: the invFun codomain swap is described as `ε(restrictScalars β_{W''}) itself (not inv ε)`, where β = (f.appIso W'').inv — but the Lean implementation (DualInverse.lean:249–256, confirmed axiom-clean) uses `dualUnitRingSwapHom = inv(ε(restrictScalars (f.appIso W'').hom.hom))`, i.e., the *inverse* of ε in the *.hom*-direction, not ε itself in the *.inv*-direction. A NOTE at lines 5907–5913 from the review agent in iter-265 flags this error explicitly and names the correct construction, but the prose itself was never corrected. A prover following the prose (ignoring the NOTE) would build a morphism with the wrong type. The NOTE also requests two `\lean{}` pins (`AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom` and `AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso_hom`) that are still absent from the blueprint.
  - **[gate clear, TensorObjSubstrate.lean lane]** `lem:pullback_tensor_map_basechange` Sq1-tail description (steps a–e at lines 4150–4175, binding obligation at 4177–4191) is sound, well-specified, and directly consistent with the Lean source structure. The R1/R5 recovery recipe (step c: `leftAdjointUniqUnitEta_app`; step d: `pushforwardComp` naturality; step e: `comp_unit_app` + `unit_naturality`) mirrors the already-closed `pullbackObjUnitToUnit_comp`, and the binding obligation (the `forget ∘ pushforward^sheaf = pushforward^pre ∘ forget` compatibility) is correctly identified as the one non-mechanical piece. The circularity warning at lines 4199–4202 is accurate and consistent with the Lean comments (TensorObjSubstrate.lean:2594). No correctness errors for this lane.
  - **[not a defect]** The 9 `\lean{}` pins annotated with `% NOTE: \lean{} pin target absent from Lean source as of iter-271 (verified by grep)` are correctly classified as expected unformalized forward references (per the iter-271 writer's pass), not stale renames. Two are intentionally abandoned general-pullback targets (`lem:pullback_tensor_iso`, `lem:pullback0_tensor_iso`) and one is the vestigial route-(e) target (`lem:jw_ismonoidal`); the remainder are live D4'/downstream targets not yet formalized. These are treated identically to the accepted TODO pins in Picard_FlatteningStratification, Picard_QuotScheme, and Cohomology_FlatBaseChange. They are NOT the `correct: partial` finding above.

---

## Top-level summaries

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:slice_dual_transport` (proof, invFun block, lines 5914–5923): the invFun codomain swap direction is wrong (says ε of .inv-direction β; should be inv ε of .hom-direction). The NOTE at 5907–5913 gives the correct description but the prose was never rewritten. Lean pins for `dualUnitRingSwapHom` and `isIso_ε_restrictScalars_appIso_hom` also missing from the blueprint.

---

## Severity summary

- **must-fix-this-iter**:
  - `Picard_TensorObjSubstrate.tex` / `lem:slice_dual_transport` invFun prose: correct the ε direction at lines 5915–5918 per NOTE at 5907–5913 ("`ε(restrictScalars β_{W''}) itself (not inv ε)`" → "`inv(ε(restrictScalars (f.appIso W'').hom.hom))` = `dualUnitRingSwapHom`"), and add `\lean{}` pins for `AlgebraicGeometry.Scheme.Modules.dualUnitRingSwapHom` and `AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso_hom`. This is a **small, well-scoped fix** (one sentence + two lean pins). The NOTE at 5907–5913 gives everything the writer needs verbatim.

---

## Gate adjudication

**Are the 9 forward-reference pins the ONLY residual?** No. There is one additional pre-existing residual: the prose error in the invFun description (lines 5915–5918), flagged by the review agent in iter-265 but not corrected by the iter-271 repin271 pass. This is independent of the 9 forward-reference pins.

**DualInverse.lean lane (`sliceDualTransport.invFun` + round-trips):** Gate NOT satisfied. The prose for invFun contains an incorrect ε-direction statement that would mislead a prover filling `sliceDualTransport.invFun`. A blueprint-writer must correct lines 5915–5918 (one sentence rewrite + two `\lean{}` pins) before this lane proceeds. This is a minor, fast fix.

**TensorObjSubstrate.lean lane (`sheafificationCompPullback_comp_tail` R1/R5):** Gate SATISFIED. The Sq1-tail prose (steps a–e, binding obligation) is sound and detailed enough to formalize. The recipe is correct, consistent with the Lean source structure, and mirrors the already-closed analog.

---

Overall verdict: `Picard_TensorObjSubstrate.tex` has `correct: partial` due to one pre-existing prose error (invFun ε-direction, lines 5915–5918) that is separate from the 9 forward-reference pins; the DualInverse.lean gate is blocked pending a minor writer fix (one sentence + two lean pins), while the TensorObjSubstrate.lean Sq1-tail gate is clear.
