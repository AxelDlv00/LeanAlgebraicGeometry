# Blueprint Review: gate7
**Iter:** 007

## Top-level summaries

- **Unmatched \lean{}**: `Picard_TensorObjSubstrate.tex` — 3 forward-ref pins (all confirmed by in-line NOTE as expected; not defects):
  - `lem:pullback_compatible_with_tensorobj` → `LineBundle.OnProduct.pullback_tensorObj_iso` (not yet formalized)
  - `lem:pullback_tensor_iso_loctriv` → `Modules.pullbackTensorIsoOfLocallyTrivial` (D4′ live target)
  - `thm:rel_pic_addcommgroup_via_tensorobj` → `PicSharp.addCommGroup_via_tensorObj` (consumer, gated)
- **With sorry (blueprint nodes)**: `lem:slice_dual_transport` (3 sorrys: naturality L544, left\_inv L646, right\_inv L648) and `lem:slice_dual_transport_inv` (1 sorry: naturality L407) in `DualInverse.lean`; `lem:tensorobj_inverse_invertible` (L712) and `lem:pullback_tensor_map_basechange` (L3144) in `TensorObjSubstrate.lean`. Open target for DUAL lane: ε-naturality of `restrictScalars` along open-immersion ring iso; recipe in `analogies/dualnat006.md`.
- **22 nodes need `\leanok`**: sync_leanok backlog — not a blueprint error, will be resolved by next sync run.
- **Isolated (93 lean_aux)**: all prover-created helpers with no blueprint entry (keep — coverage debt; noted in STRATEGY.md).
- **Rendering**: clean — blueprint-doctor reports no malformed_refs, no broken refs, no orphan chapters.
- **DAG integrity**: 0 unknown\_uses (no broken `\uses{}` edges). 0 blueprint gaps (all 113 nodes have `\lean{}` hints).

---

## !! HARD GATE VERDICT: DualInverse.lean CLEAR !!

`Picard_TensorObjSubstrate.tex` is **complete: true** and **correct: true** for all four DUAL declarations.
No must-fix finding touches any of the four DUAL labels.
**A prover may be dispatched to `DualInverse.lean` this iter.**

DUAL declaration status per blueprints (all four present, well-specified, `\lean{}` pins exist in `DualInverse.lean`):

| Label | Lean decl | Blueprint | Lean current state |
|-------|-----------|-----------|-------------------|
| `lem:slice_dual_transport_inv` | `sliceDualTransportInv` | complete, correct | PARTIAL: sorry at naturality field (L407) — the `sliceDualTransportInv.naturality` ε-naturality; this IS the open prover target |
| `lem:slice_dual_transport` | `sliceDualTransport` | complete, correct | PARTIAL: 3 sorrys (naturality L544, left_inv L646, right_inv L648); all blocked on `sliceDualTransportInv.naturality` |
| `lem:dual_restrict_iso` | `dual_restrict_iso` | complete, correct | Transitively partial via `sliceDualTransport`; H1 + isoMk assembled at L799 (`subsingleton` closes naturality) |
| `lem:dual_isLocallyTrivial` | `dual_isLocallyTrivial` | complete, correct | Transitively partial via `dual_restrict_iso` |

**Root sorry**: `sliceDualTransportInv.naturality` (DualInverse.lean L407). Blueprint proof sketch correctly identifies the fix: ε-naturality of `PresheafOfModules.restrictScalarsLaxε` — `NatTrans` naturality field settling module-map equation after thin-poset `Subsingleton.elim` pins base morphisms. Recipe: `analogies/dualnat006.md`.

---

## Per-chapter

### `Picard_LineBundlePullback.tex`
- **Complete**: true
- **Correct**: true
- 5 declaration blocks, all `\leanok`. 0 unknown\_uses. `def:IsLocallyTrivial` and helpers axiom-clean. `lem:IsLocallyTrivial.pullback` has narrow named typed sorry noted in % NOTE (iter-188); iter-188+ closure ~30-50 LOC.

### `Picard_RelPicFunctor.tex`
- **Complete**: partial (abelian-group instance `lem:rel_pic_sharp_groupoid` is `\leanok`; étale sheafification blocks are forward-referenced scaffolding)
- **Correct**: true
- `lem:rel_pic_sharp_groupoid` proof `\uses{}` includes `lem:pullback_tensor_iso_loctriv` (D3′ deferred concurrent input) — correctly characterized as a deferred target, not a blueprint error. The 5 Lean-encoding items beyond `lem:rel_pic_sharp_groupoid` have no `\lean{}` pins but carry clear prose descriptions; they are intentional scaffolding, gated on both routes.
- % NOTE at line 127 (carrier note) and at lines 263-296 (Lean encoding notes re constant-functor placeholder): do NOT `\leanok` `PicSharp.presheaf` or `PicSharp.etSheaf` until the body is replaced with mathematically correct construction. ← **plan agent should ensure sync_leanok respects these notes.**

### `Picard_TensorObjSubstrate.tex`
- **Complete**: partial (open prover targets `pullbackTensorMap_restrict` Sq1/Sq4, `sliceDualTransport` ε-naturality, `exists_tensorObj_inverse` A-bridge; all other 109 blocks adequately detailed)
- **Correct**: true
- **DUAL cluster** (gate focus): complete + correct (see Hard Gate section above)
- **D3′ cluster**: `lem:pullback_tensor_map_basechange` has `\leanok` on statement (decl exists) but sorry at L3144 (Sq1+Sq4 residual). Blueprint proof of Sq1 (`sheafificationCompPullback_comp` via `leftAdjointUniq` mate calculus) and Sq4 (corollary of Sq1 via `pullbackValIso` factorisation) is detailed and adequate for a prover. Recipe: `analogies/d3cocycle006.md`.
- **Consumer cluster**: `thm:rel_pic_addcommgroup_via_tensorobj` and `lem:pullback_compatible_with_tensorobj` are forward-referenced (no Lean decl yet). Proof strategy described correctly (4-step construction). `\uses{}` note in blueprint: carries TODO to repoint from `lem:tensorobj_isoclass_commgroup` to `thm:pic_commgroup` once invertibility-carrier group lands — annotated in blueprint comment.
- **`lem:tensorobj_inverse_invertible`**: sorry (exists_tensorObj_inverse L712). Blueprint correctly describes 3-part route: (C) `dual_isLocallyTrivial` chain, (A) local-eval gluing + `isIso_of_isIso_restrict`.

## Isolated nodes

All 93 isolated nodes are `lean_aux` type (prover-created helpers with no blueprint entry). Disposition: **keep** for all — they are the ~91-decl coverage debt noted in STRATEGY.md `## Open strategic questions`. No blueprint nodes are isolated. No wire-up or remove actions required.

## Cross-chapter notes

- `lem:slice_dual_transport` (TensorObjSubstrate) has `\uses{..., lem:slice_dual_transport_inv, ...}` — this is CORRECT: `sliceDualTransport.invFun` calls `sliceDualTransportInv` (verified at DualInverse.lean L647). Topological order is: prove `lem:slice_dual_transport_inv` first.
- `Picard_RelPicFunctor.tex` `lem:rel_pic_sharp_groupoid` `\uses{..., lem:pullback_tensor_iso_loctriv}` — this label is in TensorObjSubstrate.tex (unformalized). The blueprint prose correctly identifies it as a concurrently-built deferred input for pullback-additivity (Step 2). No circular dependency; the consumer chapter correctly gates on both routes closing.

## Severity summary

- **must-fix**: none
- **warn**: `PicSharp.presheaf` / `PicSharp.etSheaf` % NOTE comments request sync_leanok suppression until carrier is correct — plan agent should confirm sync_leanok config respects these notes; otherwise these placeholder bodies may receive spurious `\leanok`.
- **soon**: 22 nodes need `\leanok` — sync_leanok backlog, not a blueprint error. Resolve with next sync run.
- **info**: 93 lean_aux coverage debt (STRATEGY.md known item, not blocking).

## Unstarted-phase proposals

All three strategy phases (D3′, DUAL, Consumer) have adequate blueprint coverage (≥3 meaningful declaration blocks each). No unstarted-phase proposals.
