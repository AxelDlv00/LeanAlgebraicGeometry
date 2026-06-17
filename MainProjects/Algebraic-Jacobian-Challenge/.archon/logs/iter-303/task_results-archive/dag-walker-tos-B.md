# DAG Walker Report

## Slug
tos-B

## Seed
lem:tensorobj_inverse_invertible (`AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse`)

## Status
COMPLETE — every targeted helper now has a registered blueprint node and is wired into a present consumer; no helper is isolated; no broken `\uses` edges introduced.

## Cone before → after
- Isolated lean-aux helpers in cluster B (change-of-rings / lax-μ / extendScalars / Pic-quotient): 15 → 0
- broken \uses: 0 → 0
- blocks added: 15;  \uses edges added: 15 internal (within the new blocks) + 11 edges into existing consumers

All edits confined to `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (within write-domain). No `.lean`, no protected chapter, no sheafification/pullback (cluster A) or `DualInverse.lean` blocks touched.

## Blocks added / proofs written
All 15 are sorry-free in Lean; each gets a `\begin{lemma/definition}` + `\label` + `\lean` + `\uses` (read off the Lean body) + a one-line "Proved directly in Lean — <shape>" proof note. Placed in two new subsections at the end of `sec:tensorobj_substrate_helpers`:

**Subsection `subsec:tensorobj_changeofrings_helpers`:**
- `lem:restrictscalars_is_right_adjoint` → `restrictScalarsIsRightAdjoint` (inferInstanceAs; dep=0)
- `lem:pushforward0_is_right_adjoint` → `pushforward₀IsRightAdjoint` (inferInstanceAs; dep=0)
- `def:extend_scalars` → `extendScalars` (leftAdjoint of restrictScalars; uses lem:restrictscalars_is_right_adjoint)
- `def:extend_scalars_adjunction` → `extendScalarsAdjunction` (ofIsRightAdjoint; uses def:extend_scalars, lem:restrictscalars_is_right_adjoint)
- `lem:restrictscalarsid_map` → `restrictScalarsId_map` (rfl; dep=0)
- `lem:restrictscalars_mu_app` → `restrictScalars_μ_app` (rfl; uses def:restrict_scalars_lax_mu)
- `lem:forget2_restrictscalars_mu_hom_tmul` → `forget₂_restrictScalars_μ_hom_tmul` (Mathlib restrictScalars_μ_tmul; dep=0)
- `lem:restrictscalars_mu_app_tmul` → `restrictScalars_μ_app_tmul` (uses lem:restrictscalars_mu_app)
- `lem:pushforward_map_restrictscalars_mu_app_tmul` → `pushforward_map_restrictScalars_μ_app_tmul` (uses lem:restrictscalars_mu_app_tmul)
- `lem:pushforward_mu_eq` → `pushforward_μ_eq` (rfl; uses lem:presheaf_pushforward_laxmonoidal, def:restrict_scalars_lax_mu)
- `lem:pushforwardcomp_lax_mu` → `pushforwardComp_lax_μ` (sectionwise pure-tensor collapse; uses lem:pushforward_mu_eq, lem:restrictscalars_mu_app, lem:forget2_restrictscalars_mu_hom_tmul, lem:pushforward_map_restrictscalars_mu_app_tmul)
- `lem:forget_map_pushforward_map` → `forget_map_pushforward_map` (rfl; dep=0)

**Subsection `subsec:tensorobj_pic_quotient_helpers`:**
- `def:pic_setoid` → `picSetoid` (iso setoid; uses def:scheme_modules_isinvertible)
- `def:pic_mul` → `picMul` (Quotient.lift₂; uses def:pic_setoid, def:pic_carrier, def:tensorobjisoofiso, lem:isinvertible_tensor)
- `def:pic_inv` → `picInv` (Quotient.lift; uses def:pic_setoid, def:pic_carrier, lem:isinvertible_inverse_welldef, lem:tensorobj_comm_iso)

## \uses edges added/fixed (the completeness fixes — into existing consumers)
- `lem:pullbackcomp_delta` now `\uses{… , lem:pushforwardcomp_lax_mu}` — the in-Lean proof of `pullbackComp_δ` reduces, by its own documented mate calculus, to `pushforwardComp_lax_μ` as its sole genuine residual; the edge was missing (dep 2 → 3).
- `def:pic_carrier` (PicGroup) now `\uses{… , def:pic_setoid}` — `PicGroup := Quotient (picSetoid X)`.
- `thm:pic_commgroup` (picCommGroup) now `\uses{… , def:pic_mul, def:pic_inv}` — `picCommGroup.mul := picMul`, `.inv := picInv`.
- `lem:tensorobj_isoclass_commgroup` (the **first/registered** block pinning `PicGroup`+`picCommGroup`) now `\uses{… , def:pic_setoid, def:pic_mul, def:pic_inv}` — guarantees the pic helpers attach to the actually-registered graph node for those decls.
- `lem:pullback_lan_decomposition` now `\uses{… , def:extend_scalars, def:extend_scalars_adjunction}` — `pullbackLanDecomposition` is built from `extendScalarsAdjunction` (Lean L1313–1314).
- `def:pullback0` now `\uses{lem:pushforward0_is_right_adjoint}` (Lean L1282).
- `def:pullback0_adjunction` now `\uses{… , lem:pushforward0_is_right_adjoint}` (Lean L1296), statement + proof.
- `lem:sheafificationcomppullback_comp_tail` now `\uses{… , lem:restrictscalarsid_map, lem:forget_map_pushforward_map}` (Lean L2598, L2605), statement + proof.
- `lem:eta_bridge_unit_square` now `\uses{… , lem:restrictscalarsid_map}` (Lean L1884, inside `pullbackEtaUnitSquare`).
- `lem:sheafify_tensor_unit_iso_natural` now `\uses{… , lem:restrictscalarsid_map}` (Lean L2022/L2030, inside `sheafifyTensorUnitIso_hom_natural`).

## Verification
- `archon dag-query node` confirms all 15 new labels registered with the correct `\lean` decl and `dep_count` matching the authored `\uses`; every new node has `rdep_count ≥ 1` (none isolated).
- `lem:pullbackcomp_delta` dep_count 2 → 3 after wiring `pushforwardcomp_lax_mu`.
- All 8 pre-existing labels I reference resolve (each `\label` present exactly once).
- LaTeX environments balanced in the appended region (lemma 10/10, definition 5/5, proof matched). The global `\begin{lemma}`/`\end{lemma}` 150/149 count is **pre-existing** (a verbatim `% SOURCE QUOTE` comment containing `\begin{lemma}`); not introduced here.
- `proved: false` on the new nodes is expected — these are sorry-free Lean and will earn `\leanok` from the deterministic `sync_leanok` phase (not the walker's to add).

## Could not complete (genuine gaps)
None. All 15 targets are sorry-free project-local helpers with finite, directly-stated proofs.

## References consulted
None required — all 15 are internal categorical constructions ("Proved directly in Lean"), as the directive anticipated. No external source quote needed; no reference-retriever spawned.

## Notes for dispatcher
- `picSetoid`/`picMul`/`picInv` have their natural high-level home in this chapter (`PicGroup`/`picCommGroup` live here), so all wiring stayed in-chapter; no cross-chapter edge into `Picard_RelPicFunctor`/`Picard_IdentityComponent` was needed.
- Registration note for the graph: `PicGroup` and `picCommGroup` are each pinned by THREE blocks (`lem:tensorobj_isoclass_commgroup` L2728, `def:pic_carrier` L4966, `thm:pic_commgroup` L5177). leandag registers each decl to the FIRST block (`lem:tensorobj_isoclass_commgroup`); I therefore wired the pic helpers into all three so the edge lands on whichever node the graph treats as canonical. Not an error, but the mathematician may wish to deduplicate those pins someday.
- The pre-existing `\begin{lemma}`/`\end{lemma}` off-by-one (commented SOURCE QUOTE) is harmless but could be tidied if a future doctor flags it.
