# Refactor directive — split the generic glue-descent layer out of GrassmannianQuot.lean

Target: `AlgebraicJacobian/Picard/GrassmannianQuot.lean` (3352 lines, 7 sorries).
Action: create NEW file `AlgebraicJacobian/Picard/GlueDescent.lean` containing the generic
`AlgebraicGeometry.Scheme.Modules` glue-datum/descent layer, currently the two namespace blocks
at **L390–658** (pullbackBaseChangeTransport, glueData_bridge_src/mid/tgt, glue, glueLift) and
**L1233–2160** (glueLift_cond_iff, restrictFunctor_isRightAdjoint/_preservesLimits,
pullback_preservesLimits_of_isOpenImmersion, section GlueRestriction, glueData_preimage_image_eq,
glueData_overlap_opensFunctor_eq, glueOverlapBaseChangeIso [HAS an inline sorry — preserve
verbatim], isIso_glueRestrictionHom [sorry — preserve verbatim], glueRestrictionIso).
`GrassmannianQuot.lean` keeps every `AlgebraicGeometry.Grassmannian` block and imports
`AlgebraicJacobian.Picard.GlueDescent`.

Purpose: two independent prover lanes next round — descent keystone (GlueDescent) vs the
Nitsure §5 inverse construction (GrassmannianQuot).

Constraints:
- Names, signatures, universe annotations VERBATIM — especially the `Scheme.GlueData.{0}`
  monomorphic pins (see iter-066 trap note: `glue`/`glueLift` are universe-pinned at `{0}`).
- ALL 7 sorries preserved exactly: 2 move to GlueDescent (inside `glueOverlapBaseChangeIso`
  ~L2097 and `isIso_glueRestrictionHom` ~L2134), 5 stay in GrassmannianQuot (L3282, L3308,
  L3317, L3339, L3344). No proof bodies edited, no new sorries.
- If the moved blocks need generic helpers currently in a `Grassmannian` namespace block (e.g.
  `hasFiniteBiproducts_modules` at L140, or Scheme.Modules helpers earlier in the file), move
  them too, keeping their namespace wrappers so fully-qualified names are unchanged.
- If a genuine cyclic dependency emerges (glue layer referencing Grassmannian-specific decls),
  ABORT and report — do not force a split.
- Add `import AlgebraicJacobian.Picard.GlueDescent` where needed and register the new file in
  root `AlgebraicJacobian.lean`.
- Verify with a real `lake build AlgebraicJacobian` (green, kernel-validated). Report the new
  file's line numbers for the 2 moved sorries and the final sorry inventory of both files.
- Do NOT touch blueprint .tex files (planner handles the `% archon:covers` line).
