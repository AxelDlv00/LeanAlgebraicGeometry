# Blueprint Writer Report

## Slug
fbc-reconcile

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made
- **Merged L1+L2 → one block** `\label{lem:base_change_mate_fstar_reindex_legs_link_distributeCollapse}`,
  `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse}` — replaced the two
  former blocks `..._link_distribute` (was @~1693) and `..._link_collapseComp` (was @~1733), which pinned
  non-existent Lean decls. The merged statement is stated at the **single composite functor**
  \(F := (\operatorname{Spec}\varphi)_{*}\circ\Gamma_R\), exactly matching the existing axiom-clean Lean decl
  (FlatBaseChange.lean L1333–1367): the \(F\)-image of the \((b\circ a)\)-unit at \(N\) distributes (via
  `gammaDistribute`) and the transparent middle `pushforwardComp` factor collapses (its section value is
  `𝟙`, `F` carries `𝟙↦𝟙`), giving the three-factor result `F(η^b) ≫ F(b_* η^a) ≫ F((b∘a)_* pullbackComp.hom)`.
  - `\uses{}` = union of old L1+L2: `unitExpand`, `gammaDistribute`, `base_change_mate_inner_eCancel_pushforwardComp`,
    `gammaMap_pushforwardComp_hom_eq_id`. Informal proof states both sides at the one instance `F`, applies
    `gammaDistribute`, collapses factor 3, reassociates.
- **Revised** `lem:...link_cancelEUnit` (L3) — statement now references the merged
  `..._link_distributeCollapse`; `\uses{}` gains `lem:...link_distributeCollapse`. Proof sharpened to a
  precise term-mode recipe: the η^e factor (factor 2) cancels against the inverse baked into the unfolded
  `codomain_read_legs` via the atom `base_change_mate_inner_eCancel_eUnit`, grafted by **whiskering**
  (congruence on left/right neighbours, transitivity-chained, closed by the definitional bridge across the
  `gammaPushforwardIso ψ`/middle-collapse transport layer) — not a keyed in-place rewrite (dead vs the
  `X.Modules` instance diamond).
- **Revised** `lem:...link_cancelPullbackComp` (L4) — `\uses{}` gains `lem:...link_cancelEUnit`. Same
  whiskering recipe, factor 3 (`pullbackComp.hom`), canceller atom `base_change_mate_inner_eCancel_pullbackComp`.
- **Revised** `lem:...link_survivor` (L5) — `\uses{}` gains `lem:...link_cancelPullbackComp` (kept
  `unit_value`, `pushforward_spec_tilde_iso`, `def:...inner_value`). Proof sharpened: evaluate the lone affine
  `(Spec ιA)`-unit via Seam 1 (`base_change_mate_unit_value`) → ring transport along ψ with
  `ιA∘φ = ιR'∘ψ` → ρ (`def:base_change_mate_inner_value`); notes this closes `_legs`.
- **Fixed dependencies** `lem:base_change_mate_fstar_reindex_legs` — both `\uses{}` lists (statement + proof)
  now name the single `..._link_distributeCollapse` in place of the old `..._link_distribute, ..._link_collapseComp`
  pair. Prose `enumerate` reduced from five to four links; composite line now `L_1·L_2·L_3·L_4`; first item
  describes the fused distribute+collapse step.

## Cross-references introduced
- `\uses{lem:base_change_mate_fstar_reindex_legs_link_distributeCollapse}` in L3, L4 and in `_legs` — target
  is the new merged block in THIS chapter.
- `\uses{lem:...link_cancelEUnit}` in L4, `\uses{lem:...link_cancelPullbackComp}` in L5 — chain the wrappers
  (all in this chapter).
- All atom/def targets (`base_change_mate_inner_eCancel_*`, `gammaMap_pushforwardComp_hom_eq_id`,
  `base_change_mate_unit_value`, `pushforward_spec_tilde_iso`, `base_change_mate_codomain_read_legs`,
  `def:base_change_mate_inner_value`) verified present in this chapter.

## References consulted
None — this was a reconciliation/proof-detail edit of Archon-original (project-bespoke) blocks; no external
citation blocks were written or touched. Verified the merged block against the existing Lean decl
`AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse` (FlatBaseChange.lean L1333–1367).

## Verification
- `grep "_link_distribute\b\|_link_collapseComp"` → **empty** (old separate names fully gone).
- `..._link_distributeCollapse` appears once as `\label`, once as `\lean` (matches the real Lean decl), plus
  the expected `\uses`/`\ref` sites.
- `leandag build --json`: 0 link-related `unknown_uses`; the merged block is now MATCHED (no longer
  `unmatched_lean`). The only remaining link `unmatched_lean` entries are the three forward-reference pins
  `..._link_cancelEUnit / _cancelPullbackComp / _survivor` — these are the iter-031 prover's targets and are
  acceptable per the directive (forward references, not errors). No link-related isolated nodes or conflicts.

## Macros needed
None.

## Notes for Plan Agent
- The merged `distributeCollapse` block is now stated abstractly in the legs `a,b` (matching the Lean decl's
  signature `(a : X₁ ⟶ X₂) (b : X₂ ⟶ Spec A)`), with the application `a = e`, `b = Spec ιA`, `N = M̃` noted
  inline. The downstream wrapper blocks (L3–L5) still narrate in the concrete `e / Spec ιA` notation; this is
  consistent (they describe the instantiated composite) but if a future pass wants uniform notation, the
  wrappers could be re-stated in `a,b` form too.
- L3/L4/L5 Lean decls do not yet exist (forward references). blueprint-doctor will still flag their `\lean`
  pins as dangling until the iter-031 prover builds them; that is expected this iter.

## Strategy-modifying findings
None.
