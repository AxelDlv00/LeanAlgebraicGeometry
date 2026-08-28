Cross-project search is complete; no files were edited.

Useful reusable APIs for a small Hartshorne II.1 unit:

- `TopCat.Presheaf.isSheaf_iff_isSheafEqualizerProducts` and `IsSheafEqualizerProducts` for equalizer-style sheaf conditions.
- `TopCat.Presheaf.isSheaf_iff_isSheafUniqueGluing`, `TopCat.Sheaf.existsUnique_gluing'`, and `eq_of_locally_eq'` for ring-valued gluing proofs.
- Stalkwise criteria: `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso`, `isIso_of_stalkFunctor_map_iso`, `app_bijective_of_stalkFunctor_map_bijective`, `stalk_hom_ext`.
- Sheafification: `sheafifyLift`, `toSheafify_sheafifyLift`, `sheafify_hom_ext`, `isoSheafify`, `sheafificationAdjunction_unit_app`, and `isIso_sheafificationAdjunction_counit`.
- Stalk sheafification: `TopCat.Presheaf.sheafifyStalkIso`, `stalkToFiber`, and `stalkFunctor_map_unit_toSheafify_isIso`.
- Existing affine structure-sheaf wrappers are concentrated in [`Chapter2.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter2.lean), including global sections, basic-open localization, stalk localization, and affine Spec map naturality.
- Stacks/Milne/MainProjects provide useful patterns for restriction transitivity (`presheaf_res_res`, `Scheme.basicRes`), open-subscheme restrictions (`Scheme.basicOpen_restrict`, `Scheme.restrictStalkNatIso`), and affine module sheaf global sections/stalk isomorphisms.

The current Horizon frontier for “Presheaf and sheaf (definition)” is graph node `14dc29bea2bb`, still without a Lean binding.
