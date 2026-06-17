# Blueprint Writer Report

## Slug
openimm-correct

## Status
COMPLETE — Tasks A, B, C executed. The WALL transport route is removed and replaced by the sound
two-need split. `leandag build --json`: `unknown_uses = []`, `conflicts = []`, no new isolated
blueprint nodes; the two project targets and three Mathlib anchors register as expected
(`unmatched_lean` = TODO build-targets + Mathlib pointers outside the project scan).

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Task A — REWROTE Proof detail (2) of `lem:open_immersion_pushforward_comp`
- Replaced the round-1 `(2a)/(2b)/(2c)` chain (which transported along the OPEN-SUBSCHEME iso
  `j⁻¹V ≅ Spec Γ(j⁻¹V)` via `lem:sectionsFunctor_isoSpec_transport`) with the sound route:
  - **(2a)** `j` affine (`isAffineHom_of_affine_separated`) ⇒ `j⁻¹V` (resp. `U ∩ f⁻¹V`) is an affine
    open of the abstract affine scheme `U`; after reduction to the right-derived sections functor
    (presheaf description + `lem:sectionsFunctorCorepIso` + `lem:rightDerivedNatIso`) the residual is
    `Ext^q_U(j_!O_{j⁻¹V}, H) = 0`, `q ≥ 1`, ambient in `U.Modules`.
  - **(2b) Need #1**: transport along the WHOLE-SCHEME iso `U ≅ Spec Γ(U)` (`Scheme.isoSpec`) via
    `lem:modules_isoSpec_ext_transport`, carrying the residual to
    `Ext^q_{Spec Γ U}(j_!O_{V'}, H') = 0` over `Spec Γ(U)`, `V'` the image affine open.
  - **(2c) Need #2**: over `Spec Γ(U)`, `V'` is a general affine open, killed by
    `lem:affine_serre_vanishing_general_open` (enlarged-basis cover-system vanishing via
    `lem:cech_to_cohomology_on_basis`).
- **Added a visible `\textit{Remark (a rejected route).}`** recording the DEAD END: transporting along
  the open-subscheme iso forces a restriction functor whose derived comparison is
  restriction-preserves-injectives; the Form-B development was adopted precisely to avoid that, so
  `isoSpec` is used only on the whole affine `U`.

### Task B — REPLACED the WALL lemma and re-pointed anchors
- **DELETED** `lem:sectionsFunctor_isoSpec_transport` (statement + proof; the
  `sectionsFunctorIsoSpecTransport_TODO` pin) — it encoded the wall.
- **Re-pointed** the Mathlib anchor: renamed `lem:isoSpec_mathlib` → `lem:isoSpec_scheme_mathlib`,
  `\lean{}` now `AlgebraicGeometry.Scheme.isoSpec` (the WHOLE-SCHEME affine iso for `[IsAffine U]`),
  `\mathlibok`. (The old anchor pinned `IsAffineOpen.isoSpec`, the wrong open-subscheme vehicle.)
- **Added Mathlib anchor** `lem:ext_mapExactFunctor_mathlib` / `\lean{CategoryTheory.Abelian.Ext.mapExactFunctor}`
  `\mathlibok` — Ext transports along an exact functor.
- **Added Mathlib anchor** `lem:modules_pushforward_mathlib` / `\lean{AlgebraicGeometry.Scheme.Modules.pushforward}`
  `\mathlibok` — pushforward of sheaves of modules + its coherences (for assembling the equivalence).
- **Added project target** `lem:affine_serre_vanishing_general_open` (Need #2, **no marker**, TODO pin
  `AlgebraicGeometry.affine_serre_vanishing_general_open_TODO`): `Ext^q(j_!O_V, H)=0` for ANY affine
  open `V` of `Spec R`, `q ≥ 1`. `\uses{lem:cech_to_cohomology_on_basis, lem:affine_surj_of_vanishing,
  lem:standard_cover_cofinal, def:affine_cover_system, lem:affine_faces_mem, lem:injective_cech_acyclic,
  def:absolute_cohomology}`. Proof: enlarge basis `B` to all affine opens; `faces_mem` already covered,
  `injective_acyclic` cover-agnostic, only `surj_of_vanishing`/`standard_cover_cofinal` need the
  quasi-compactness swap (`isCompact_basicOpen → IsAffineOpen.isCompact`).
- **Added project target** `lem:modules_isoSpec_ext_transport` (Need #1, **no marker**, TODO pin
  `AlgebraicGeometry.modulesIsoSpecExtTransport_TODO`): the whole-scheme iso `U ≅ Spec Γ(U)` induces
  `Ext^q_U(j_!O_V, H) ≅ Ext^q_{Spec Γ U}(j_!O_{V'}, H')`. `\uses{lem:isoSpec_scheme_mathlib,
  lem:ext_mapExactFunctor_mathlib, lem:modules_pushforward_mathlib, lem:jshriek_corepr}`. Proof:
  assemble `Φ : U.Modules ≌ (Spec Γ U).Modules` from `pushforward φ.hom/.inv` + coherences; transport
  Ext via `Ext.mapExactFunctor`; identify `j_!O` and quasi-coherence under the iso.
- **Updated `\uses`** of `lem:open_immersion_pushforward_comp` (statement + proof) to replace
  `lem:sectionsFunctor_isoSpec_transport` with `lem:affine_serre_vanishing_general_open,
  lem:modules_isoSpec_ext_transport` (kept `lem:rightDerivedNatIso, lem:sectionsFunctorCorepIso`).

### Task C — round-1 Tasks 3/4/5 kept as-is
- `lem:toPresheafOfModules_additive`, `lem:sectionsFunctor_additive`, `lem:sectionsFunctorCorepIso`,
  `lem:isZero_homology_of_iso_homotopy_id_zero`, the stale-prose deletion, and the `dep*`-`\uses`
  clarification are untouched.
- The new (2a/2b/2c) prose no longer over-claims `rightDerivedNatIso` as the change-of-scheme vehicle:
  `rightDerivedNatIso`/`sectionsFunctorCorepIso` remain (correctly) the corepresentability→derived
  bridge in (2a), while the change-of-scheme transport in (2b) is carried by `Ext.mapExactFunctor`.

## Cross-references introduced
- `lem:open_immersion_pushforward_comp` (stmt+proof) → `lem:affine_serre_vanishing_general_open`,
  `lem:modules_isoSpec_ext_transport` (both in this chapter).
- `lem:affine_serre_vanishing_general_open` → `lem:cech_to_cohomology_on_basis,
  lem:affine_surj_of_vanishing, lem:standard_cover_cofinal, def:affine_cover_system,
  lem:affine_faces_mem, lem:injective_cech_acyclic, def:absolute_cohomology` — all exist in chapter.
- `lem:modules_isoSpec_ext_transport` → `lem:isoSpec_scheme_mathlib, lem:ext_mapExactFunctor_mathlib,
  lem:modules_pushforward_mathlib, lem:jshriek_corepr` — all exist in chapter (three are the new
  anchors). `leandag`: `unknown_uses = []`.

## References consulted
- `analogies/change-of-scheme-cohomology.md` — read in full; the WALL diagnosis and the verified
  Mathlib names (`Scheme.isoSpec`, `IsAffineOpen.isCompact`, `Scheme.Modules.pushforward` + coherences,
  `Ext.mapExactFunctor`) and the two-need recipe drove the entire rewrite.
- (Existing in-chapter `% SOURCE`/`% SOURCE QUOTE` blocks were left untouched; no new external
  citation blocks were written — the new blocks are Archon-original / Mathlib anchors.)

## Macros needed (if any)
None. All new prose uses existing macros / standard `\operatorname`.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **Two TODO build targets surfaced** (both NO marker, intentional):
  - `lem:affine_serre_vanishing_general_open` (`affine_serre_vanishing_general_open_TODO`) — Need #2.
    Lean home: `AffineSerreVanishing.lean`. Per the analogist, ~40–80 LOC, low risk: generalize
    `affine_surj_of_vanishing` (`:233`) and `standard_cover_cofinal` (`:167`) from `D f` to a general
    affine open by swapping `PrimeSpectrum.isCompact_basicOpen f` → `IsAffineOpen.isCompact`, then set
    `affineCoverSystem`'s basis `B := {affine opens}`.
  - `lem:modules_isoSpec_ext_transport` (`modulesIsoSpecExtTransport_TODO`) — Need #1. ~60–120 LOC,
    low–medium risk: assemble `Φ : U.Modules ≌ (Spec Γ U).Modules` from `Scheme.Modules.pushforward`
    coherences + transport `Ext` via `Ext.mapExactFunctor`; plus `j_!O`/quasi-coherence naturality.
  Both replace the single deleted `sectionsFunctorIsoSpecTransport_TODO`. Scaffolding both decls
  (lean-scaffolder) next iter, then re-pointing the `\lean{}`, is the natural follow-up.
- The `affine_serre_vanishing` blueprint statement still reads "Let `U` be an affine scheme" while its
  Lean decl is pinned to `⊤` on `Spec R`; the new `lem:affine_serre_vanishing_general_open` is the
  intended sibling that covers general affine opens. No change to the existing statement (out of scope).

## Strategy-modifying findings
None. The two-need split is the sound, Form-B-native discharge already endorsed by the mathlib-analogist
audit; it introduces no new Mathlib gaps (the rejected open-subscheme route did).
