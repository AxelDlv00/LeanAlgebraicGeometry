# Blueprint Writer Report

## Slug
tile-residual

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:modulesSpecToSheaf_smul_eq}`/`\lean{AlgebraicGeometry.modulesSpecToSheaf_smul_eq}`
  — project-bespoke `rfl` bridge: the native `R`-action of the global-ring section functor
  `Γ_R(-,F)` on a section over `W` equals the structure-sheaf action of the restricted
  global-sections image `ρ^W(θ_R(r))` on the unchanged carrier. One-line proof (definitional unfold;
  restriction of scalars along the global-sections identification). No external source (omitted SOURCE
  lines). `\uses{}` left empty — there is no `modulesSpecToSheaf` definition block in the chapter to
  anchor to, and the block is non-isolated because `lem:tile_section_comparison` now uses it.
- **Added lemma** `\lemma`/`\label{lem:modulesRestrictBasicOpen_smul_eq}`/`\lean{AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq}`
  — project-bespoke `rfl` bridge: the tile (`R_g`) action transports through the two open-immersion
  global-sections ring isomorphisms `β_g` (affine identification `Spec R_g ≅ D(g)`) and `α_g`
  (inclusion `D(g) ↪ Spec R`) to `F`'s ambient structure-sheaf action on the iterated-image open `W`.
  One-line proof (definitional unfold; restriction = pushforward with the inverse ring map).
  `\uses{lem:tile_image_opens_identities}` (statement and proof).
- **Revised** `lem:tile_section_comparison` (proof body) — replaced the stale "~100–150 LOC /
  genuinely non-definitional / not the same type" prose and the stale `% NOTE` lines with the accurate
  decomposition: (1) carriers coincide definitionally via `lem:restrict_obj_mathlib` when `W` is kept in
  iterated-image form, only the bundled `ModuleCat R_g` vs `ModuleCat R` packaging differs at the
  category level; scalar actions on both sides are definitional via the two new bridge lemmas; (2) the
  sole residual is one structure-sheaf ring identity, displayed in project notation
  (`ρ^{D(g)}(θ_R(r)) = β_g^{-1}(θ_{R_g}(r̄))`), expressing "sections over `D(g)` are the localisation
  `R_g`, compatibly with `R → R_g`"; (3) the two closure routes — (A) geometric via Γ–Spec naturality
  of `Spec(R → R_g)`, (B) algebraic via `IsLocalization.Away` uniqueness. Honest residual estimate
  (single focused structure-sheaf sub-proof) folded into prose; stale review `% NOTE` lines removed.
- **Fixed dependencies** `lem:tile_section_comparison` — added
  `lem:modulesSpecToSheaf_smul_eq, lem:modulesRestrictBasicOpen_smul_eq` to BOTH the statement `\uses{}`
  and the proof `\uses{}` (existing `lem:presentation_modulesRestrictBasicOpen, lem:restrict_obj_mathlib,
  lem:tile_image_opens_identities` retained).

## Cross-references introduced
- `\uses{lem:modulesSpecToSheaf_smul_eq}`, `\uses{lem:modulesRestrictBasicOpen_smul_eq}` added in both
  the statement and proof of `lem:tile_section_comparison` — both targets are the two new blocks in this
  same chapter.
- `\uses{lem:tile_image_opens_identities}` added in `lem:modulesRestrictBasicOpen_smul_eq` (statement +
  proof) — target is `lem:tile_image_opens_identities` in this same chapter (pinned, done).

## leandag verification
`leandag build --json`: 0 unknown_uses project-wide (none naming the new labels or
`lem:tile_section_comparison`). `leandag query --isolated --chapter Cohomology_CechHigherDirectImage`:
neither new block is isolated (each has the incoming/outgoing edges above).

## References consulted
None — all content is project-internal Lean reconciliation. No external source was needed or cited; no
`% SOURCE:` blocks were written. (Read `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` lines
720–849 to capture the exact Lean statements of the two new decls and the residual ring identity — that
is a project Lean file, not a `references/` source.)

## Macros needed (if any)
None. All notation used (`\Spec`, `\Gamma`, `\mathcal{O}`, `\mathcal{F}`, `\theta`, `\rho`, `\beta`,
`\alpha`) is either standard or already in use elsewhere in the chapter.

## Notes for Plan Agent
- The two new bridge lemmas carry `\lean{}` pins to real, kernel-verified decls
  (`AlgebraicGeometry.modulesSpecToSheaf_smul_eq`, `AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq`
  in `QcohTildeSections.lean`), so the deterministic `sync_leanok` phase should mark both `\leanok` on
  the statement (and proof, since both are `rfl`/axiom-clean). I did not add `\leanok` (per descriptor).
- `lem:tile_section_comparison` still has no `\lean{}` pin (the `% NOTE` deferring it is unchanged and
  left in place): the Lean decl `tile_section_comparison` is still PARTIAL. The proof note now matches
  the real residual, so a prover re-dispatch should target only the single structure-sheaf ring identity
  (~30–50 LOC), via route (A) ΓSpec naturality of `specAwayToSpec g = Spec.map (algebraMap R R_g)` or
  route (B) `IsLocalization.Away` uniqueness.

## Strategy-modifying findings
None. The rewrite narrows the residual obstruction (now one structure-sheaf ring identity, not a
~100–150 LOC non-definitional construction) but does not alter the Route-B keystone strategy for `01I8`.
