# Blueprint Writer Report

## Slug
need1-coverage

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### TASK 1 — Decompose the Need#1 jShriekOU transport (Route-3 corrective)
Inserted six new blocks immediately before `lem:modules_isoSpec_ext_transport`, then rewrote that
lemma's statement `\lean{}`, `\uses{}`, and proof prose.

- **Added lemma** `\label{lem:pushforward_commutes_free}` / `\lean{AlgebraicGeometry.pushforward_commutes_free}`
  — pushforward along an iso commutes with the free functor (left-adjoint / mate argument).
  `\uses{def:jshriek_ou}`. Marked `% NOTE: build target`.
- **Added lemma** `\label{lem:pushforward_commutes_sheafify}` / `\lean{AlgebraicGeometry.pushforward_commutes_sheafify}`
  — pushforward along an iso commutes with sheafification (site equivalence / left adjoints).
  `\uses{lem:mod_pmod_adjunction}`. `% NOTE: build target`.
- **Added lemma** `\label{lem:yoneda_transport_along_homeo}` / `\lean{AlgebraicGeometry.yoneda_transport_along_homeo}`
  — representable transports to the representable on the image open (open-image order-iso). `% NOTE: build target`.
- **Added lemma** `\label{lem:jshriek_transport_along_iso}` / `\lean{AlgebraicGeometry.jShriekOU_transport_along_iso}`
  — assembly: `Φ(j_!O_V) ≅ j_!O_{φ''V}` by chaining sheafify→free→Yoneda commutations.
  `\uses{def:jshriek_ou, lem:pushforward_commutes_free, lem:pushforward_commutes_sheafify, lem:yoneda_transport_along_homeo}`. `% NOTE: build target`.
- **Added lemma** `\label{lem:pushforward_iso_preserves_qcoh}` / `\lean{AlgebraicGeometry.pushforward_iso_preserves_qcoh}`
  — pushforward along an iso preserves quasi-coherence (transport of local presentation along
  `ringCatSheaf` iso). `% NOTE: build target`.
- **Added Mathlib anchor** `\label{lem:isAffineOpen_image_of_iso_mathlib}` /
  `\lean{AlgebraicGeometry.Scheme.Hom.isAffineOpen_iff_of_isOpenImmersion}` `\mathlibok`
  — image of an affine open under an open immersion (a fortiori iso) is affine.
- **Revised** `lem:modules_isoSpec_ext_transport`:
  - `\lean{}` now bundles the three construction internals
    `AlgebraicGeometry.Scheme.Modules.pushforwardEquivOfIso`,
    `AlgebraicGeometry.pushforwardEquivOfIso_functor_additive`,
    `AlgebraicGeometry.Scheme.Modules.pushforwardExtAddEquiv` alongside `modulesIsoSpecExtTransport`.
  - `\uses{}` (statement + proof): dropped stale `lem:jshriek_corepr`; added
    `lem:jshriek_transport_along_iso, lem:pushforward_iso_preserves_qcoh, lem:isAffineOpen_image_of_iso_mathlib`.
  - Proof prose rewritten: the single "Yoneda corepresentability carries along" sentence is replaced by
    explicit appeals to `\ref{lem:jshriek_transport_along_iso}` (object transport),
    `\ref{lem:isAffineOpen_image_of_iso_mathlib}` (affineness of `V'`), and
    `\ref{lem:pushforward_iso_preserves_qcoh}` (qcoh preservation); the prose now names the
    `pushforwardEquivOfIso` / `pushforwardExtAddEquiv` / `mapExt_bijective_of_preservesInjectiveObjects`
    internals.

### TASK 2 — Clear coverage debt
**CechAcyclic change-of-ring chain** (inserted before the seed block `lem:affine_cech_vanishing_general_seed`):
- **Added lemma** `\label{lem:isLocalizedModule_baseChange_away}` /
  `\lean{AlgebraicGeometry.isLocalizedModule_baseChange_away}` — the genuinely-new Mathlib ingredient
  (TensorProduct.isBaseChange + isLocalizedModule_iff_isBaseChange + IsBaseChange.comp).
  `\uses{lem:isLocalizedModule_comp_away}`.
- **Added lemma** `\label{lem:section_cech_module_exact_of_affineCover}` —
  `\lean{AlgebraicGeometry.SectionCechModule.dDiff_exact_of_affineCover, AlgebraicGeometry.sectionCechAbExact_affine}`
  (private helper `sectionCechAbExact_affine` bundled in, per directive). Mirror of
  `lem:section_cech_module_exact_of_localizationAway`.
  `\uses{lem:section_cech_module_exact, lem:isLocalizedModule_baseChange_away}`.
- **Added lemma** `\label{lem:sectionCech_homology_exact_of_affineCover}` /
  `\lean{AlgebraicGeometry.sectionCech_homology_exact_of_affineCover}`. Mirror of
  `lem:affine_cech_vanishing_tilde_subcover`.
  `\uses{lem:section_cech_module_exact_of_affineCover, lem:section_cech_ab_exact, lem:section_cech_homology_exact}`
  (the latter two carry `sectionCech_isZero_homology_of_objD_exact`).
- **Revised** the seed block `lem:affine_cech_vanishing_general_seed`: confirmed its `\lean{}` already
  points at `AlgebraicGeometry.sectionCech_homology_exact_of_affineOpen` (the repoint was already in
  place); bundled the private helper `AlgebraicGeometry.basicOpen_algMap_section` into its `\lean{}`;
  added `lem:sectionCech_homology_exact_of_affineCover, lem:isLocalizedModule_baseChange_away` to both
  `\uses{}` lists; updated the stale `% NOTE` (was "is to be built") to reflect it is co-located/built;
  amended the Conclusion paragraph to cite the two new core lemmas.

**CechSectionIdentification coproduct leaf** (inserted after `lem:cech_backbone_left_sigma`):
- **Added lemma** `\label{lem:coverArrow_over_sigma}` —
  `\lean{AlgebraicGeometry.coverArrowOverSigmaIso, AlgebraicGeometry.coverArrowOverCofan, AlgebraicGeometry.coverArrowOverIsColimit}`
  (the two cofan/colimit helpers bundled as implementation details). The cover arrow `Over.mk(Sigma.desc 𝒰.f)`
  is the coproduct of member arrows in `Over X`. `\uses{def:cover_cech_nerve}`; prose names
  mkCofanColimit / coproductIsCoproduct / Sigma.{ι_desc,hom_ext} / Over.{homMk,w}.

**OpenImmersionPushforward transport core** — the three names
`pushforwardEquivOfIso`, `pushforwardEquivOfIso_functor_additive`, `pushforwardExtAddEquiv` were bundled
into `lem:modules_isoSpec_ext_transport`'s `\lean{}` (see TASK 1 revision above) and are mentioned in
its proof prose.

### TASK 3 — Repoint the Need#2 consumer pin
- **Revised** `lem:affine_serre_vanishing_general_open`: `\lean{}` repointed from
  `...affine_serre_vanishing_general_open_TODO` to the real
  `AlgebraicGeometry.affine_serre_vanishing_general_open`; removed the `% NOTE: build target … does not
  exist yet` comment. Existing seed wiring (`lem:affine_cech_vanishing_general_seed`) left intact.

## Cross-references introduced
- All new `\uses{}` targets verified present in this chapter via `leandag build` → `unknown_uses: []`
  (every reference resolves). New labels: `lem:pushforward_commutes_free/_sheafify`,
  `lem:yoneda_transport_along_homeo`, `lem:jshriek_transport_along_iso`,
  `lem:pushforward_iso_preserves_qcoh`, `lem:isAffineOpen_image_of_iso_mathlib`,
  `lem:isLocalizedModule_baseChange_away`, `lem:section_cech_module_exact_of_affineCover`,
  `lem:sectionCech_homology_exact_of_affineCover`, `lem:coverArrow_over_sigma`.

## Verification (leandag)
- `unknown_uses: []` — no dangling references.
- `isolated: 3` — all three are `lean_aux` nodes (unchanged from before; none are my new blocks).
- Coverage-debt names now bound to blueprint nodes (matched): `isLocalizedModule_baseChange_away`,
  `dDiff_exact_of_affineCover`, `sectionCech_homology_exact_of_affineCover`, `sectionCechAbExact_affine`,
  `basicOpen_algMap_section`, `coverArrowOverSigmaIso`, `coverArrowOverCofan`, `coverArrowOverIsColimit`,
  `pushforwardEquivOfIso`, `pushforwardEquivOfIso_functor_additive`, `pushforwardExtAddEquiv`,
  `sectionCech_homology_exact_of_affineOpen`.
- The five Task-1 build targets (`jShriekOU_transport_along_iso`, `pushforward_commutes_free/_sheafify`,
  `yoneda_transport_along_homeo`, `pushforward_iso_preserves_qcoh`) and
  `affine_serre_vanishing_general_open` appear in `unmatched_lean` *with their blueprint `node` bound* —
  i.e. blueprint entry present, Lean declaration pending. This is the expected build-target state.
- LaTeX balance: `\begin{lemma}`=`\end{lemma}`=195; `\begin{proof}`=`\end{proof}`=147. Blueprint parsed
  cleanly (250 declarations).

## References consulted
None — all edited/added blocks are Archon-original categorical/sheaf infrastructure or Mathlib
dependency anchors (whose `\lean{}` target is the citation). No external `% SOURCE` quote blocks were
authored. (The two pre-existing `% SOURCE` blocks I touched — the seed block's Stacks quotes and the
modules-transport block — were left verbatim; I edited only `\uses{}`/`\lean{}`/prose, not the quotes.)

## Notes for Plan Agent
- **Minor directive label fix.** The directive specified `lem:jshriek_transport_along_iso` should
  `\uses{def:absolute_cohomology (for jShriekOU), …}`. The actual blueprint node for the `jShriekOU`
  object is `def:jshriek_ou` (`def:absolute_cohomology` is the Ext realization, a different node), so I
  wired `\uses{def:jshriek_ou, …}`. This is the mathematically correct dependency and resolves cleanly.
- **Seed repoint was already in place.** `lem:affine_cech_vanishing_general_seed` already pointed at
  `sectionCech_homology_exact_of_affineOpen` on disk (the directive described it as still a placeholder);
  no repoint was needed, only the bundling/`\uses`/NOTE updates described above.
- **`affine_serre_vanishing_general_open` Lean decl** currently shows in `unmatched_lean` (build target).
  The repoint is correct; it will bind once the Lane-1 prover lands the declaration this iter. If the
  prover instead names it differently, the `\lean{}` here will need a follow-up correction.

## Strategy-modifying findings
None.
