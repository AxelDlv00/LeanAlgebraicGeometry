# Blueprint Review: init-bp
**Iter:** 001

## Top-level summaries

- **Incomplete**: `Picard_RelPicFunctor.tex` (étale-sheafification section is a deliberate placeholder; PicSharp.presheaf + PicSharp.etSheaf bodies not formalized).
- **Correct-partial**: `Picard_TensorObjSubstrate.tex` — `lem:tensorobj_inverse_invertible` proof block says "Infrastructure-blocked / not realizable with currently available infrastructure"; this language is **stale**: the dual-infra chain (`sliceDualTransport` → `sliceDualTransportInv` → `dual_restrict_iso` → `dual_isLocallyTrivial`) is now blueprint-complete and prover-ready. Must update before dispatching provers on TensorObjSubstrate.lean / DualInverse.lean.
- **Bad Lean targets (unmatched `\lean{}`)**: 3 forward-references in `Picard_TensorObjSubstrate.tex` — Lean decls do not yet exist (noted in per-chapter NOTE comments, not stale renames):
  - `lem:pullback_compatible_with_tensorobj` → `AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso`
  - `lem:pullback_tensor_iso_loctriv` → `AlgebraicGeometry.Scheme.Modules.pullbackTensorIsoOfLocallyTrivial`
  - `thm:rel_pic_addcommgroup_via_tensorobj` → `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj`
- **Broken crefs (rendering only, not uses-edges)**: `Picard_LineBundlePullback.tex`: `chap:Jacobian` (×1), `chap:Picard_RelativeSpec` (×4). `Picard_RelPicFunctor.tex`: `chap:Picard_FGAPicRepresentability` (×5), `chap:Picard_RelativeSpec` (×1). `Picard_TensorObjSubstrate.tex`: `chap:Albanese_AlbaneseUP`, `chap:Picard_FGAPicRepresentability`, `chap:Picard_IdentityComponent` (×1 each). All are commentary `\cref{}` to missing chapters; none appear as `\uses{}` edges — no gate impact.
- **Deps/Isolated**: 91 isolated nodes, ALL `lean_aux` type (0 blueprint isolated nodes). No triage required on blueprint side; all lean_aux nodes lack blueprint entries (coverage debt — see below).
- **unknown_uses**: 0 — all `\uses{}` resolve to known labels.
- **Multi-route**: D3′ route — blueprint COMPLETE (all steps present). DUAL route — blueprint COMPLETE. Consumer — blueprint COMPLETE (but gated on both routes landing).
- **Missing `\lean{}` / gaps**: 0 — all 108 blueprint nodes have `\lean{}` hints.

## Unstarted-phase proposals

**None.** All phases in the `## Phases & estimations` table have adequate blueprint coverage (≥3 meaningful declaration blocks per route).

## Per-chapter

### `Picard_LineBundlePullback.tex`
- **Complete**: true
- **Correct**: true
- **Covers**: `AlgebraicJacobian/Picard/LineBundlePullback.lean`
- **Notes**:
  - `lem:IsLocallyTrivial_pullback` proof has 1 narrow sorry on residual chart-iso composition; blueprint notes this as iter-188 target (~30-50 LOC). Blueprint sketch is complete and correct for the prover.
  - Broken `\cref{}` to `chap:Jacobian`, `chap:Picard_RelativeSpec` (×4): rendering-only defect, not `\uses{}` edges.
  - Citation discipline: `% SOURCE:` + `% SOURCE QUOTE:` present and verbatim on all blocks; local file parentheticals reference `references/kleiman-picard-src/kleiman-picard.tex` which exists on disk.

### `Picard_RelPicFunctor.tex`
- **Complete**: partial
- **Correct**: true
- **Covers**: `AlgebraicJacobian/Picard/RelPicFunctor.lean`
- **Notes**:
  - `lem:rel_pic_sharp_groupoid` has `\leanok` on statement but proof uses `lem:pullback_tensor_iso_loctriv` (unmatched lean) and `lem:tensorobj_inverse_invertible` (with sorry). The 4-step proof sketch (Steps 1–4) is mathematically correct and detailed; gate is upstream, not a blueprint defect.
  - `PicSharp` (group-valued presheaf), `PicSharp.presheaf`, `PicSharp.etSheaf`, `PicSharp.etSheaf_group_structure` sections: placeholder Lean bodies are correctly documented with explicit "DO NOT promote to `\leanok`" warnings. Not a blueprint correctness issue; status accurately reflected.
  - `sec:relpic_etale_sheaf`: the étale sheafification section is intentionally thin (correctly gated on upstream Mathlib monoidal gap). The section's Lean encoding is detailed and correct.
  - Broken `\cref{}` to `chap:Picard_FGAPicRepresentability` (×5), `chap:Picard_RelativeSpec` (×1): rendering-only.
  - Citation discipline: verbatim Kleiman quotes present.

### `Picard_TensorObjSubstrate.tex`
- **Complete**: true
- **Correct**: partial
- **Covers**: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`, `TensorObjSubstrate/DualInverse.lean`, `TensorObjSubstrate/StalkTensor.lean`, `TensorObjSubstrate/PresheafInternalHom.lean`, `TensorObjSubstrate/Vestigial.lean`
- **Notes**:
  - **MUST-FIX (correct: partial)**: `lem:tensorobj_inverse_invertible` (exists_tensorObj_inverse) proof block contains stale "Infrastructure-blocked" / "not realizable" language (line ~1414). The dual-infra chain (`sliceDualTransport` → `sliceDualTransportInv` → `dual_restrict_iso` → `dual_isLocallyTrivial`) is now blueprint-complete and all dependencies have `\leanok` on statement or complete blueprints. Writer must update this proof block to: (a) remove the "not realizable" claim, (b) confirm that the route described in Steps 1–3 is now executable given `lem:dual_isLocallyTrivial` has `\leanok`, and (c) flag which sorry in the chain gates it. The proof sketch itself (3 steps) is mathematically correct.
  - **Deferred (not urgent)**: `thm:rel_pic_addcommgroup_via_tensorobj` NOTE says `\uses{}` should be repointed from `lem:tensorobj_isoclass_commgroup` to `thm:pic_commgroup` once the invertibility-carrier group lands. Acknowledged in the NOTE. No gate impact this iter.
  - **3 unmatched `\lean{}` hints** (forward references, correctly documented in per-lemma NOTEs):
    - `lem:pullback_compatible_with_tensorobj`: uses `lem:tensorobj_lift_onproduct` (closed), blueprint proof complete (affine-cover monoidal functor argument). **Blueprint ready; Lean decl needs creation.**
    - `lem:pullback_tensor_iso_loctriv` (D4′): uses many closed lemmas; chart-chase blueprint is detailed (4 steps: base-change coherence + restriction-detects-iso). **Blueprint ready; Lean decl needs creation.**
    - `thm:rel_pic_addcommgroup_via_tensorobj` (consumer): uses `lem:pullback_compatible_with_tensorobj` (not yet done). **Not dispatchable until that unmatched hint is resolved.**
  - **6 open sorries — blueprint quality per sorry**:
    - `pullbackTensorMap_restrict` (`lem:pullback_tensor_map_basechange`, line 3025): `\leanok` on statement; 4-square paste proof sketch. **Complete/correct. Prover-ready.**
    - `sheafificationCompPullback_comp_tail` (`lem:sheafificationcomppullback_comp_tail`, line 5619): NO `\leanok` on statement (not yet started in Lean). 5-step proof sketch (a)–(e) with warning against circularity. **Complete/correct. Ready to formalize (no Lean body yet).** Depends on `lem:sheafification_comp_pullback_eq_leftadjointuniq` (has `\leanok`) and `lem:leftadjointuniq_app_unit_eta_general` (verify `\leanok` before dispatch).
    - `sliceDualTransport` (`lem:slice_dual_transport`, line 4477): `\leanok` on statement; extremely detailed proof (3-item additivity + naturality split). **Complete/correct. Prover-ready.**
    - `sliceDualTransportInv` (`lem:slice_dual_transport_inv`, line 4838): NO `\leanok` on statement (not yet started in Lean). Blueprint proof complete (mirrors forward leg with two changes; depends on `lem:image_preimage_of_le`, `def:dual_unit_ring_swap_hom`, etc., all `\leanok`). **Ready to formalize.**
    - `dual_restrict_iso` (`lem:dual_restrict_iso`, line 4901): `\leanok` on statement; Stage H1 + leg (A)/(B) proof (sliceDualTransport atom). **Complete/correct. Prover-ready** (after sliceDualTransport is closed).
    - `exists_tensorObj_inverse` (`lem:tensorobj_inverse_invertible`, line 1355): `\leanok` on statement; **proof block stale** — see must-fix above. Mathematical route (3 steps) is correct once `dual_isLocallyTrivial` is confirmed realizable.
  - **Broken `\cref{}`**: `chap:Albanese_AlbaneseUP`, `chap:Picard_FGAPicRepresentability`, `chap:Picard_IdentityComponent` — rendering-only.
  - **Citation discipline**: Sources from `references/stacks-modules.tex` and `references/kleiman-picard-src/kleiman-picard.tex` (both exist on disk); `% SOURCE QUOTE:` verbatim present on all externally-sourced blocks. Mathlib source quotes use lake-path file references (OK — not a local `references/` file; these are direct Lean source citations, acceptable for internal-implementation references).

## Coverage check: chapter↔file mapping

`Picard_TensorObjSubstrate.tex` declares `% archon:covers` for all 5 files at lines 2–6:
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`
- `AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean`
- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- `AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean`

**HARD GATE for DualInverse.lean**: gates on `Picard_TensorObjSubstrate.tex` verdict → currently `correct: partial` → BLOCKED until writer fix.

## Frontier-ready nodes (from leandag: `Ready to formalize: 4`)

Based on `\leanok` absence + complete `\uses{}` closure:

| Node | Status | Dispatchable? | Blocker |
|------|--------|---------------|---------|
| `lem:slice_dual_transport_inv` | No `\leanok`, blueprint complete | **YES** (after TensorObjSubstrate gate cleared) | Requires `sliceDualTransport` closed first |
| `lem:sheafificationcomppullback_comp_tail` | No `\leanok`, blueprint complete | **YES** (after gate cleared) | Verify `lem:leftadjointuniq_app_unit_eta_general` has `\leanok` |
| `lem:pullback_compatible_with_tensorobj` | Unmatched `\lean{}`, blueprint complete | **YES** (create Lean decl) | After gate cleared |
| `lem:pullback_tensor_iso_loctriv` | Unmatched `\lean{}`, blueprint complete | **YES** (create Lean decl) | After `pullback_compatible_with_tensorobj` lands (not a \uses dependency, but logical sequencing) |

## HARD GATE verdicts

| File | Chapter | complete | correct | Gate |
|------|---------|----------|---------|------|
| `LineBundlePullback.lean` | `Picard_LineBundlePullback.tex` | true | true | **GREEN** |
| `TensorObjSubstrate.lean` | `Picard_TensorObjSubstrate.tex` | true | partial | **BLOCKED** |
| `DualInverse.lean` | `Picard_TensorObjSubstrate.tex` | true | partial | **BLOCKED** |
| `StalkTensor.lean` | `Picard_TensorObjSubstrate.tex` | true | partial | **BLOCKED** |
| `PresheafInternalHom.lean` | `Picard_TensorObjSubstrate.tex` | true | partial | **BLOCKED** |
| `Vestigial.lean` | `Picard_TensorObjSubstrate.tex` | true | partial | **BLOCKED** |
| `RelPicFunctor.lean` | `Picard_RelPicFunctor.tex` | partial | true | **BLOCKED** |

Fast path available for TensorObjSubstrate.tex: dispatch writer to fix `exists_tensorObj_inverse` proof block → re-review scoped to TensorObjSubstrate.tex → if passes, all 5 files become dispatchable this iter.

## 91 lean_aux nodes: most load-bearing in seed cone

The 91 isolated `lean_aux` nodes (all Lean declarations without blueprint entries) include the prover-facing helpers called by the 6 sorry targets' proof bodies. Most load-bearing to blueprint-author (prioritize for blueprint entry this iter or next):

From `sheafificationCompPullback_comp_tail` `\uses{}`:
- `lem:leftadjointuniq_app_unit_eta_general` → `Modules.leftAdjointUniq_app_unit_eta_general` (step c, load-bearing)
- `lem:pullbackObjUnitToUnit_comp` → `Modules.pullbackObjUnitToUnit_comp`
- `lem:forget_map_pushforward_map` → `Modules.forget_map_pushforward_map`
- `lem:restrictscalarsid_map` → `Modules.restrictScalarsId_map`

From `sliceDualTransport` `\uses{}` + DUAL strategy note:
- `PresheafOfModules.restrictScalarsLaxε` (explicitly named in strategy, needed for naturality step (b) of sliceDualTransport)
- `lem:isiso_eps_restrictscalars_appiso_hom` → `Modules.isIso_ε_restrictScalars_appIso_hom`
- `def:dual_unit_ring_swap_hom` → `Modules.dualUnitRingSwapHom`

These 7 appear in `\uses{}` edges of blueprinted sorry targets but have no blueprint block of their own. Authoring entries for them reduces the 91-node coverage debt in the highest-impact zone.

## Severity summary

- **must-fix**: `Picard_TensorObjSubstrate.tex` — `lem:tensorobj_inverse_invertible` proof block stale "Infrastructure-blocked" claim; blocks correct: true verdict → writer directive required before prover dispatch on TensorObjSubstrate family.
- **must-fix (same-iter fast path available)**: dispatch blueprint writer to fix the single proof block, then re-review scoped to TensorObjSubstrate.tex.
- **soon**: `Picard_RelPicFunctor.tex` complete: partial — étale-sheafification section is a deliberate placeholder pending upstream PicSharp.presheaf body. Not an error; will be resolved when upstream sorries close.
- **soon**: 91 lean_aux nodes with no blueprint entry — author the 7 priority nodes above.
- **info**: broken `\cref{}` to missing chapters (rendering-only, 14 total across 3 chapters) — no gate impact but will render as "??" in compiled blueprint.
- **info**: `thm:rel_pic_addcommgroup_via_tensorobj` `\uses{}` repointing deferred (acknowledged in NOTE).
