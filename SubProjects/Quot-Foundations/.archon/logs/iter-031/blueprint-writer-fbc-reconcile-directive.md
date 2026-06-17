# Blueprint-writer directive — chapter `Cohomology_FlatBaseChange.tex` — slug `fbc-reconcile`

## Scope
ONE chapter: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`. This is a **reconciliation +
proof-detail** edit of the five "link" sub-lemma blocks of `lem:base_change_mate_fstar_reindex_legs`.
Do NOT touch any other block. Do NOT add `\leanok` (the deterministic sync handles it).

## Background (why this edit)
The iter-030 prover decomposed the `_legs` crux proof differently from the blueprint's 5-link plan. The
lean-vs-blueprint checker found:
- The Lean file has a real axiom-clean theorem
  `AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse` (lines ~1333–1367) that
  **fuses the content of blueprint L1 (`link_distribute`) + L2 (`link_collapseComp`)** into one lemma. It
  is spliced into `_legs` in term mode but has **no blueprint block** (coverage debt — appears in
  `dag-query unmatched`).
- The five blueprint blocks `..._link_distribute`, `..._link_collapseComp`, `..._link_cancelEUnit`,
  `..._link_cancelPullbackComp`, `..._link_survivor` have `\lean{}` pins to Lean decls that **do not exist**
  (dangling — blueprint-doctor flags them as broken `\lean`).

## Required edits (Path B — merge; planner-chosen, lower risk)

### 1. Merge L1+L2 into one block pinning the existing fused Lean decl
Replace the two blocks `lem:base_change_mate_fstar_reindex_legs_link_distribute` (label/lean at ~1693) and
`lem:base_change_mate_fstar_reindex_legs_link_collapseComp` (~1733) with a SINGLE lemma block:
- `\label{lem:base_change_mate_fstar_reindex_legs_link_distributeCollapse}`
- `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse}`
- Statement: state both sides at the **single composite functor** `(Spec φ)_* ⋙ Γ_R` form (this is the
  key — at one functor `F` there is one instance, so `Functor.map_comp`/`gammaDistribute` apply with no
  diamond). It distributes the composed-adjunction unit through the `Γ`-image functor into a product of
  factors AND collapses the two transparent `pushforwardComp` hom-coherence factors (the L1+L2 content
  fused). Keep the math precise but in project notation; this matches the iter-030 task_result description.
- `\uses{...}`: union of what L1 and L2 used, reflecting what the Lean proof actually needs
  (`gammaDistribute` / `base_change_mate_fstar_reindex_legs_gammaDistribute`, the `pushforwardComp`
  hom-coherence atoms `gammaMap_pushforwardComp_hom_eq_id`, `Functor.map_id`). Drop nothing the proof uses.
- Informal proof: state both sides at `F := (Spec φ)_* ⋙ Γ_R`; apply `gammaDistribute` (fires at one
  instance); collapse factor 3 via the `pushforwardComp` hom-coherence (`Γ(F)(coherence)=id`) + reassoc.
  This is what the existing Lean decl proves axiom-clean.

### 2. Keep L3/L4/L5 as forward-reference blocks for the legs-context wrapper lemmas (built iter-031)
The iter-031 prover will build three standalone clean-term lemmas:
- `base_change_mate_fstar_reindex_legs_link_cancelEUnit`
- `base_change_mate_fstar_reindex_legs_link_cancelPullbackComp`
- `base_change_mate_fstar_reindex_legs_link_survivor`
Keep their three blocks (`lem:..._link_cancelEUnit` @~1765, `lem:..._link_cancelPullbackComp` @~1794,
`lem:..._link_survivor` @~1822) with their existing `\lean{}` pins (these are forward references the prover
honours this iter — acceptable; they are NOT errors). For EACH, sharpen the informal proof to a precise,
formalizable recipe so a fine-grained prover can build it:
- **cancelEUnit**: in the distributed legs-context form, the `e`-unit factor (`η^e`, factor 2) cancels
  against the corresponding factor of the **unfolded** `base_change_mate_codomain_read_legs`. The canceller
  is the atomic lemma `base_change_mate_inner_eCancel_eUnit` (Lean line ~1538); the wrapper splices it in
  TERM mode (`congrArg (·≫_)`/`(_≫·)`, `.trans`-chained, `exact`-closed) across the
  `gammaPushforwardIso ψ`/`MidColl` transport layer — NOT keyed `rw`/`simp`/`erw` (conclusively dead vs the
  `X.Modules` instance diamond). State its `\uses{}` to include `lem:..._link_distributeCollapse` and the
  eCancel-eUnit atom block.
- **cancelPullbackComp**: same shape, factor 3 (`pullbackComp.hom`), canceller atom
  `base_change_mate_inner_eCancel_pullbackComp` (Lean ~1567). `\uses{}` the cancelEUnit block + that atom.
- **survivor**: the surviving factor 1 is the lone affine `(Spec ιA)`-unit; evaluate it via Seam 1
  (`base_change_mate_unit_value`) → ring transport → `base_change_mate_inner_value` (= ρ). This is the
  final step that closes `_legs`. `\uses{}` the cancelPullbackComp block + `lem:base_change_mate_unit_value`
  + `def:base_change_mate_inner_value`.

### 3. Fix every `\uses{}` / `\ref{}` that named the now-removed L1/L2 labels
Several narrative/assembly blocks list all five links (search the chapter for
`link_distribute` and `link_collapseComp` — at least the `\uses{...}` lists near lines ~1856–1860,
~1889–1893 and the prose `\ref{}`s near ~1914–1923). Replace every
`lem:..._link_distribute, lem:..._link_collapseComp` pair with the single
`lem:..._link_distributeCollapse`. Leave the cancelEUnit/cancelPullbackComp/survivor refs intact. After the
edit, NO `\ref`/`\uses`/`\label`/`\lean` in the chapter may mention `_link_distribute` or
`_link_collapseComp` (the old separate names) — only `_link_distributeCollapse`.

## Out of scope
Everything else in the chapter. Do not rewrite the gstar/affine/FBC-B blocks. Do not add `\leanok`.

## Verification before you finish
- `grep -n "_link_distribute\b\|_link_collapseComp"` returns nothing (old names fully gone).
- Exactly one block pins `...link_distributeCollapse`, and it is the existing Lean decl name.
- The three wrapper blocks each have a precise term-mode informal proof and accurate `\uses{}`.
