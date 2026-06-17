# Blueprint Writer Report

## Slug
comp-iter066

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### TASK 2 — split part (1) into its own block
- **Added lemma** `\label{lem:open_immersion_pushforward_acyclic}` /
  `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic,
  AlgebraicGeometry.isAffineHom_of_affine_separated}` — part (1) (R^q j_* = 0 for an affine
  open immersion j of an affine U into a separated X, H quasi-coherent). This is the former
  combined block, re-headed and re-labelled; the genuine Ext-transport proof route
  (presheaf-description + corepresentability + whole-scheme `isoSpec` Ext-transport +
  general-affine-open Serre vanishing + locally-zero⇒zero-sheafification) moved here and was
  reworded to be purely about `j` / `j⁻¹V` (dropped the part-(2) "respectively U∩f⁻¹V"
  mentions, the `f`/`G`/`S` symbols, and the now-irrelevant part-(2) resolution paragraphs).
  - `\lean{}`: dropped `higherDirectImage_openImmersion_comp` (now its own block); kept
    `isAffineHom_of_affine_separated` pinned here (used by both blocks; part (2) `\uses` this
    block).
  - `\uses{}` (statement & proof, identical): `lem:affine_serre_vanishing,
    lem:higher_direct_image_presheaf, lem:sheafify_kills_locally_zero,
    lem:isZero_presheafToSheaf_of_locally_isZero, lem:ext_homcomplex_mathlib,
    lem:isZero_presheafToSheaf_of_sections_locally_zero, lem:pushforward_sections_functor,
    lem:rightDerivedNatIso, lem:sectionsFunctorCorepIso,
    lem:affine_serre_vanishing_general_open, lem:modules_isoSpec_ext_transport,
    lem:isoSpec_scheme_mathlib, lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero,
    lem:ext_jShriekOU_eq_zero_of_specIso}`. Removed `lem:acyclic_resolution_computes_derived`
    (was for the part-(2) conclusion, not used by part (1)) and the vestigial
    `lem:pushforwardPushforwardEquivalence_mathlib`; ADDED `lem:isoSpec_scheme_mathlib` (the
    proof's (2b) references it but it was previously a missing edge).
  - Kept the Stacks `lemma-relative-affine-vanishing` SOURCE / SOURCE QUOTE / SOURCE QUOTE
    PROOF and visible `\textit{Source: ...}` (verbatim, re-verified against
    `references/stacks-coherent.tex` L180–199 / L187–198).

### TASK 1 — rewrite the part-(2) proof on the cleaner categorical route
- **Added lemma** `\label{lem:open_immersion_pushforward_comp}` /
  `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` — part (2)
  (R^k f_*(j_* H) ≅ R^k g_* H). DELETED the flawed argument (the "Each j_*I^n is f_*-acyclic …
  H^k(U∩f⁻¹V)=0 by Serre vanishing" paragraph and the part-(2) Ext-over-`U∩f⁻¹V` detail),
  whose error was claiming `U∩f⁻¹V` is an affine open of `U` (false: `f⁻¹V` is open but not
  affine in `X`). Replaced with the actual four-obligation Lean route, clearly labelled:
  - **(b) hacyc** — each `j_* I^n` is `f_*`-acyclic: `pushforward j` preserves injectives (right
    adjoint of `pullback j ⊣ pushforward j`, whose left adjoint preserves monos via
    `restrictFunctor j ≅ pullback j` + exactness of restriction), by `lem:injective_of_adjoint`;
    injectives are right-`G`-acyclic for any additive `G`
    (`lem:right_derived_vanishes_injective` / `def:right_acyclic`). Restriction-of-injectives
    wall explicitly avoided (noted in prose).
  - **(a) hexact** — `H^k(j_* I•) ≅ R^k j_* H` (`lem:right_derived_injective_resolution`),
    vanishing for k≥1 by `lem:open_immersion_pushforward_acyclic`; so `K` exact in positive
    degrees.
  - **eRes** — augmentation `j_* H ≅ K.cycles 0` via `j_*` left exact (right adjoint) ⇒
    `R^0 j_* ≅ j_*` (`lem:right_derived_zero_iso_self`).
  - **transport** — `H^k(f_*(K)) ≅ R^k g_* H` via `pushforwardComp j f`
    (`lem:scheme_pushforwardComp_mathlib`) + `lem:right_derived_injective_resolution`.
  - Then `lem:acyclic_resolution_computes_derived` (G = f_*) composed with transport.
  - Prose notes the categorical route is an equivalent, cleaner alternative to Stacks'
    presheaf-description argument. Block is Archon-original (categorical reorganization), so no
    SOURCE lines — the Stacks citation stays on part (1).
  - `\uses{}` (statement & proof, identical): `lem:open_immersion_pushforward_acyclic,
    lem:injective_of_adjoint, def:right_acyclic, lem:right_derived_vanishes_injective,
    lem:acyclic_resolution_computes_derived, lem:right_derived_injective_resolution,
    lem:right_derived_zero_iso_self, lem:scheme_pullbackPushforwardAdjunction_mathlib,
    lem:restrictFunctorIsoPullback_mathlib, lem:scheme_pushforwardComp_mathlib}`.

### TASK 1 — Mathlib dependency anchors added (`\mathlibok`)
- **Added** `\label{lem:scheme_pullbackPushforwardAdjunction_mathlib}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.pullbackPushforwardAdjunction}` `\mathlibok` —
  `pullback f ⊣ pushforward f` for modules on schemes (verified in
  `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:172`). Distinct from the pre-existing
  `lem:pullbackPushforwardAdjunction_mathlib` (the `SheafOfModules.…` version used by the slice
  route).
- **Added** `\label{lem:scheme_pushforwardComp_mathlib}` /
  `\lean{AlgebraicGeometry.Scheme.Modules.pushforwardComp}` `\mathlibok` —
  `pushforward f ⋙ pushforward g ≅ pushforward (f≫g)` (verified at `Sheaf.lean:210`).
- `restrictFunctorIsoPullback` and `injective_of_adjoint` anchors already existed
  (`lem:restrictFunctorIsoPullback_mathlib`, `lem:injective_of_adjoint`) — reused, no new anchor.

### TASK 3 — φ'' proof sketch corrected
- **Revised** proof of `lem:slice_reverse_ring_map` (statement + `\lean{}` unchanged). Replaced
  the "Part (a) continuity + Part (b) object-relabel iso" two-part codomain-bridge description
  (which the Lean never builds) with the actual argument: φ'' is
  `sliceStructureSheafHom φ.symm (φ.inv⁻¹ᵁ Uᵢ)` retyped along the defeq corrected-inverse
  codomain, the bridge being absorbed by definitional equality because both
  `Functor.sheafPushforwardContinuousComp` (= `Iso.refl`) and `Over.mapForget`
  (`map g ⋙ forget = forget`, `rfl`) are definitional.

### TASK 4 — cleanup
- **Coverage**: added `AlgebraicGeometry.isZero_modules_of_isEmpty` to the `\lean{}` of
  `lem:pushPull_coprod_prod_empty` (the empty/initial-scheme zero-object helper its proof
  already describes).
- The `% NOTE` on `lem:pushPull_coprod_prod` (~line 8477) is **already** current — it reads
  "NOTE (review iter-065): CLOSED axiom-clean", correctly describing `pushPull_coprod_prod_empty`
  and `coprodToProd_isIso_of_equiv` as closed and the cascade (Stubs 2/4) as axiom-clean. No
  stale iter-064 note remains in the chapter (grep for `iter-064` is empty). Nothing to change.

### Downstream consumer fix
- **Revised** the `lem:cech_term_pushforward_acyclic` proof prose: the now-stale
  "By Lemma~\ref{lem:open_immersion_pushforward_comp} part (2)" became a plain reference to the
  (single-statement) comp lemma, and the `R^q (j_s)_*` vanishing now cites
  `lem:open_immersion_pushforward_acyclic`. Added `lem:open_immersion_pushforward_acyclic` to
  that block's statement & proof `\uses{}`.

## Cross-references introduced
- `lem:open_immersion_pushforward_comp` `\uses{lem:open_immersion_pushforward_acyclic}` (new
  split dependency) — both labels live in this chapter.
- `lem:open_immersion_pushforward_comp` `\uses{def:right_acyclic,
  lem:right_derived_vanishes_injective, lem:right_derived_injective_resolution,
  lem:right_derived_zero_iso_self, lem:acyclic_resolution_computes_derived}` — all in
  `Cohomology_AcyclicResolution.tex` (verified present).
- `lem:open_immersion_pushforward_comp` `\uses{lem:injective_of_adjoint,
  lem:restrictFunctorIsoPullback_mathlib, lem:scheme_pullbackPushforwardAdjunction_mathlib,
  lem:scheme_pushforwardComp_mathlib}` — all in this chapter.
- `leandag build --json`: `unknown_uses: []`, `conflicts: []`. No isolated nodes in this
  chapter (`leandag query --isolated --chapter Cohomology_CechHigherDirectImage` → none).

## References consulted
- `references/stacks-coherent.tex` (L180–199) — re-verified verbatim Stacks
  `lemma-relative-affine-vanishing` statement + proof quote retained on the part-(1) acyclic
  block. (No new citation blocks authored; part (2) is Archon-original.)
- Mathlib source `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean` (L172, L210) — confirmed the two
  new `\mathlibok` anchor targets (`Scheme.Modules.pullbackPushforwardAdjunction`,
  `Scheme.Modules.pushforwardComp`) exist with the stated signatures before marking `\mathlibok`.

## Notes for Plan Agent
- Pre-existing isolated node (NOT introduced this round, out of directive scope):
  `lem:pullbackObjUnitToUnit_mathlib` — a `\mathlibok` anchor whose own prose (~line 10656)
  explicitly says it "is not used". Consider wiring or removing in a future cleanup; the
  directive did not list it.
- The part-(2) block carries no `% SOURCE` (Archon-original categorical reorganization). If the
  mathematician prefers a citation, Stacks `lemma-relative-affine-cohomology` (the Leray
  degeneration, `references/stacks-coherent.tex` L201–211) is the closest source, but its
  statement (H^i(X,F)=H^i(S,f_*F)) is the global, not the relative-sheaf, degeneration — I did
  not cite it to avoid an inexact SOURCE QUOTE.

## Strategy-modifying findings
None. The rewrite confirms the recorded strategy: part (2)'s `f_*`-acyclicity goes through the
adjoint-preserves-injectives route, and the flawed `U∩f⁻¹V`-affineness claim (which would have
re-entered the restriction-of-injectives wall) is removed.
