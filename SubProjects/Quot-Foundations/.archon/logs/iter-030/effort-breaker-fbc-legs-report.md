# Effort Breaker Report

## Slug
fbc-legs

## Target
`lem:base_change_mate_fstar_reindex_legs` (Lean `AlgebraicGeometry.base_change_mate_fstar_reindex_legs`)

## Status
COMPLETE — the step-(iii) mate-unwinding crux is re-expressed as a `.trans`-chain of five
clean-term sub-lemmas, each a single mathematical move, and the target's proof is rewritten to chain
them and cross the instance diamond at one closing identification.

## Effort before → after
- target `effort_local`: 3317 → 3373 (essentially unchanged; see note below)
- target `effort_total`: 6962 → 6481
- sub-lemmas added: 5 (each `effort_local` ≈ 538–645)

NOTE on `effort_local`: this metric is derived from the **Lean declaration's source length**, which
an effort-breaker (blueprint-only write domain) does not touch. It will not drop until the prover
replaces the ~150-LOC sorry-body of `base_change_mate_fstar_reindex_legs` with the short `.trans`
chain and creates the five new small Lean decls. The structural win — five independently-provable
clean-term links, each ≤~30 LOC, with the diamond absent from each statement — is realised in the
blueprint now and visible as the five new low-effort frontier nodes.

## Chain added (target ← L5 ← L4 ← L3 ← L2 ← L1)
All five are NEW lemmas the prover will create (clean-term equalities, no `X.Modules` diamond in the
statement), inserted between `…_gammaDistribute` and the target in
`chapters/Cohomology_FlatBaseChange.tex`:

- `\label{lem:base_change_mate_fstar_reindex_legs_link_distribute}`
  `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distribute}`
  — L1: expand the `(g')`-unit and distribute through `(Spec φ)_* ⋙ Γ` into five Γ-image factors.
  `\uses{…_unitExpand, …_gammaDistribute}` (effort ≈ 538).
- `\label{lem:base_change_mate_fstar_reindex_legs_link_collapseComp}`
  `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_collapseComp}`
  — L2: the two `pushforwardComp.hom` Γ-factors (F3 inner, F5 surviving) are `𝟙`; delete both.
  `\uses{…_inner_eCancel_pushforwardComp, …_gammaMap_pushforwardComp_hom_eq_id}` (effort ≈ 641).
- `\label{lem:base_change_mate_fstar_reindex_legs_link_cancelEUnit}`
  `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_cancelEUnit}`
  — L3: the `e`-unit factor cancels the inverse `e`-unit baked into the codomain read (`η^e` is iso).
  `\uses{…_inner_eCancel_eUnit, …_codomain_read_legs}` (effort ≈ 645).
- `\label{lem:base_change_mate_fstar_reindex_legs_link_cancelPullbackComp}`
  `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_cancelPullbackComp}`
  — L4 (G4): the trailing `pullbackComp.hom` cancels its inverse inside `iso_g` of the codomain read.
  `\uses{…_inner_eCancel_pullbackComp, …_codomain_read_legs}` (effort ≈ 640).
- `\label{lem:base_change_mate_fstar_reindex_legs_link_survivor}`
  `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_survivor}`
  — L5: the lone survivor (affine `(Spec ιA)`-unit, conjugated by the tilde/Γ dictionaries) = `ρ`.
  `\uses{…_unit_value, …_pushforward_spec_tilde_iso, def:…_inner_value}` (effort ≈ 644).

- Target `lem:base_change_mate_fstar_reindex_legs` proof rewritten: step (i) subst legs, step (ii)
  Γ-collapse of the inv/congr coherences, step (iii) = expand the unit then chain
  `L1 · L2 · L3 · L4 · L5` by transitivity, closed by one defeq identification. Statement and proof
  `\uses{}` updated to list the five links (dropping `…_inner_eCancel_assemble`,
  `pullbackPushforward_unit_comp`, `gammaMap_pushforwardComp_hom_eq_id`, `unit_value`, which are now
  cited transitively through the links). Verified: all five appear as ancestors of the target; graph
  rebuild clean (0 ∞-effort nodes, no broken `\uses`).

## Mapping to the directive's seams
1 (distribution) → L1; 2 (factor-2 collapse) → L2; 3 (eUnit cancel) → L3; 4 (pullbackComp/G4) → L4;
5 (survivor value) → L5; 6 (final assembly) → the rewritten target proof. The `defeq map`
(F3/F5 rfl-trivial; G1/G2/G4 genuine isos) is honoured: L2 handles the rfl-trivial collapses, L3/L4
the genuine-iso cancellations, L5 the genuine-iso survivor.

## Stale `% NOTE:` removal (directive item)
The directive asked to remove a stale `% NOTE:` (~blueprint L1541–1546) claiming the three
`gammaMap_*` atoms are `private`/mangled. **No such NOTE exists in the current chapter** — `grep` for
`private|mangled|de-privat|pin.*resolve` over the chapter returns nothing, and the three `gammaMap_*`
blocks (chapter L1535–1598) are clean. It was already removed in a prior iter; nothing to do.

## Still hard (re-break candidates)
- None at the blueprint level. Each link is now one mathematical move. If the prover finds a single
  link still resists (most likely L3/L4, where the cancellation is against the **unfolded** codomain
  read), re-dispatch the breaker on that one link to split the "unfold `Θ_tgt`" step from the
  "hom–inv cancel" step. The recipe in `analogies/fbc-functorimage-diamond.md` (term-mode
  `congrArg (·≫_)` / `(_≫·)` / `Functor.congr_map`, `.trans`-chained, `exact`-closed) applies to each
  link's ≤30-LOC proof.

## Could not decompose (strategy items)
- None.

## References consulted
- `analogies/fbc-functorimage-diamond.md` — the conclusive diamond diagnosis and the term-mode
  congruence recipe; used to phrase the links and the "single closing identification" of the target.
- No external SOURCE QUOTE needed (Archon-original categorical bookkeeping, per directive).

## Notes for dispatcher
- `\lean{}` names assigned by convention (prover must scaffold these five NEW decls):
  `base_change_mate_fstar_reindex_legs_link_{distribute,collapseComp,cancelEUnit,cancelPullbackComp,survivor}`.
- Each link is intended to be stated/proved on **freshly elaborated clean terms** so the
  `X.Modules` instance diamond is absent in its statement; the target then bridges the diamond by
  defeq at the single closing `exact (L1.trans (L2.trans (L3.trans (L4.trans L5))))`.
- The wrapped genuine-content helpers (`…_inner_eCancel_{eUnit,pushforwardComp,pullbackComp}`,
  `…_gammaDistribute`, `…_unitExpand`, `…_unit_value`, `base_change_mate_inner_value`) all already
  exist and are proven in-file — the links are thin composable wrappers around them.
- No new macros needed.
