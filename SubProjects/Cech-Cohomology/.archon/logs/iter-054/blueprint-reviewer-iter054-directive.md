# Blueprint-reviewer directive — iter-054

Whole-blueprint audit (read every chapter; the cross-chapter view is the point). Produce your standard
per-chapter completeness+correctness checklist + the HARD-GATE verdict.

## Focus for this iter's gate decision
The two files about to receive provers are `CechAugmentedResolution.lean` and `OpenImmersionPushforward.lean`,
both covered by the CONSOLIDATED chapter `Cohomology_CechHigherDirectImage.tex` (one `% archon:covers`
chapter; its single verdict gates both). This iter the writer expanded that chapter:
- `lem:cech_augmented_resolution` Step 3 now names the Lean homotopy⟹IsZero mechanism (3-lemma combo:
  `Homotopy.homologyMap_eq` + `homologyMap_id` + `homologyMap_zero` + `IsZero.iff_id_eq_zero`), the
  concrete section-complex identification, `combHomotopy`/`combHomotopy_spec`, and the ExtraDegeneracy
  dead-end (wrong variance).
- Two new public-helper blocks: `isZero_of_faithful_preservesZeroMorphisms`,
  `isZero_presheafToSheaf_of_locally_isZero`.
- `lem:open_immersion_pushforward_comp` proof now names Bridges (1)–(3) with Mathlib decls
  (`InjectiveResolution.extAddEquivCohomologyClass`, `homologyAddEquiv`, `jShriekOU_homEquiv`,
  `cochainComplexXIso`, `isoRightDerivedObj`; Serre-transport via `isoSpec`; the module-sheafification
  site lemma via the `sheafificationCompToSheaf` square).
- An optional `\mathlibok` Ext↔Hom-complex anchor `lem:ext_homcomplex_mathlib`.

Assess specifically: is `Cohomology_CechHigherDirectImage.tex` now `complete:true` AND `correct:true`
for these two targets, with the proof sketches detailed enough to formalize (the prior iter's lvb
checkers flagged the Step-3 mechanism and the open-immersion bridges as under-specified — confirm that
gap is now closed), and no must-fix-this-iter finding touching this chapter? Report any remaining
must-fix.
