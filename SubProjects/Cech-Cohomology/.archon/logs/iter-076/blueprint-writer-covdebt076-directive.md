# Blueprint coverage-debt clearance — iter-076

Target: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter).

## Action
`archon dag-query unmatched` lists **41 Lean `lean_aux` helper decls with NO blueprint entry**
(all proved, 0 sorry — prover-created during the CSI/Leg/Base build). Clear ALL of them so
`unmatched` → 0, per the project policy: **cover each helper by bundling its `AlgebraicGeometry.<name>`
into the `\lean{...}` list of the semantically-related parent block already in the chapter** (do NOT
author a separate full block per helper — bundling carries the dependency edge, which is the point).

## How to map each helper → parent block
For each name below, grep the Lean source (`AlgebraicJacobian/Cohomology/*.lean`) for where it is
USED, find the public lemma/def whose proof consumes it, locate that lemma's `\lean{}` block in the
chapter, and append the helper name to that block's `\lean{...}` comma list. When several helpers feed
one parent, add them all to that parent's list.

The 41 helpers (grouped by likely origin — VERIFY via grep before bundling):
- **Leg file, feeding `pushPull_interLegHom_sections` / `coreIso_comm_leg`** (`lem:pushPull_interLegHom_sections`, `lem:coreIso_comm_leg`):
  unit_pushforward_rFIP_inv, restrict_unit_comp, inner_beta_chain, pullbackComp_rFIP_compat,
  pushPull_toRestrict_comm, thin_resid5, pls_eq, pushPullLegIso, unit_pushPull_leg_sections,
  stubEqToHomRestr, map_op_eqToHom_swap, over_hom_ext_mono, overSigmaHomEq, abHom_finsetSum_apply,
  pushPull_sigma_iso_π_incl, rawPushPullMap_unit.
- **Base / CechHigherDirectImage distributivity & nerve helpers** (parents: the Stub-1 distributivity
  blocks `lem:cechBackbone_left_sigma` / `widePullback_coproduct_iso` / `overProd_coproduct_distrib`,
  and the nerve/augmentation blocks): prodFinSuccIso_hom_fst, prodFinSuccIso_hom_snd_π,
  prodFinSuccIso_inv_π_succ, prodFinSuccIso_inv_π_zero, wpEqProd_hom_π, wpEqProd_inv_overWPproj,
  overWPproj, overDescIncl, coverArrowIncl, coverReindexHom, piMapIso_hom_π, cf_hom_snd, ι_cf_hom,
  cechNervePointIso_inv_eq_unit, cechAugmentation_pushPullMap, entry_chain, glue_chain,
  ι_fibrePower_reindex_inv, ι_overProd_distrib_inv, ι_overProd_distrib_right_inv,
  ι_overSigmaDescIso_hom, ι_reindex_wpci_inv_overWPproj, ι_sigmaMapIso_inv, ι_whiskerEquiv_inv,
  ι_wpci_inv_overWPproj.

## Constraints
- Bundle into EXISTING `\lean{}` lists; only create a fresh 1-line block if no plausible parent exists.
- Do NOT add/remove `\leanok` (sync_leanok owns it).
- Do NOT touch any proof sketch content or statement prose beyond the `\lean{}` lists.
- Verify the helper name resolves (real Lean decl, `AlgebraicGeometry.` namespace) before adding.
