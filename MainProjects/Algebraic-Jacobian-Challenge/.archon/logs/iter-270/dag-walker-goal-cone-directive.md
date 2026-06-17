# DAG Walker Directive

## Slug
goal-cone

## Seed
thm:exists_unique_ofCurve_comp
(also walk the Jacobian goal family: thm:Jacobian_proper, thm:Jacobian_smooth_genus,
 thm:Jacobian_geomIrred, thm:nonempty_jacobianWitness, thm:albanese_universal_property,
 thm:IsAlbanese_unique)

## Strategy context
These are the project's GOAL declarations: the Albanese/Jacobian object uniform
over the `k`-rational pointing of a smooth proper geometrically irreducible curve
`C/k`, with `J := Pic⁰_{C/k}`. The full mathematical roadmap must be ONE cone
rooted at these goals, every dependency transcribed into `\uses{}`. Several real
dependencies of this cone are currently graph-isolated — their incoming edges
were never transcribed — and several decomposition lemmas in the cone carry no
`\lean{}` pin.

## Depth / scope
Walk UP the goal cone. Your two jobs (dependency transcription + pinning), NOT
new mathematics:

**(1) Wire these graph-isolated blocks into the cone.** Each is mathematically a
dependency of some block already in the goal cone, but its incoming `\uses{}`
edge was never written. Find the consuming block (read its proof prose) and add
the `\uses{}`; also complete each isolated block's own outgoing `\uses{}`:

- `lem:rational_map_to_av_extends` (AbelianVarietyRigidity.tex) — used by the
  rational-map-to-abelian-variety extension / Albanese argument.
- `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable`,
  `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange` (RigidityKbar.tex)
  — separability/purely-inseparable steps of the rigidity-over-`k̄` argument.
- `lem:mem_domain_partial_map_reshuffle` (Albanese_CodimOneExtension.tex) —
  domain-of-definition step of the codim-1 rational-map extension.
- `lem:isiso_sheafification_map_of_W`, `lem:pullback_val_iso_natural`,
  `def:scheme_modules_homMk` (Picard_TensorObjSubstrate.tex) — line-bundle
  pullback comparison-iso substrate.
- `lem:smooth_proper_curve_projective` (Picard_FlatteningStratification.tex).
- `lem:pushforward_isQuasicoherent` (Picard_QuotScheme.tex).

**(2) Pin every unpinned non-remark declaration in the cone with `\lean{}`**
(integrity rule 1). If the source already has a real Lean declaration, use that
exact name (namespace included); otherwise add a placeholder
`\lean{AlgebraicGeometry.TODO.<name>}`. The known unpinned non-remark targets in
this cone are:

- `thm:rel_pic_etale_sheaf_unit_canonical` (Picard_RelPicFunctor.tex)
- `lem:flat_whisker_localizer`, `lem:stalk_linear_map`,
  `lem:islocallyinjective_whisker_of_W`, `lem:whisker_of_W`, `lem:jw_ismonoidal`,
  `lem:stalk_tensor_commutation_naturality_right` (Picard_TensorObjSubstrate.tex)
- `thm:generic_flatness_algebraic`, `cor:flattening_stratification_curve`
  (Picard_FlatteningStratification.tex)
- `lem:quot_reduction_to_pi_star_W`, `lem:quot_alpha_injective`,
  `lem:quot_valuative_criterion` (Picard_QuotScheme.tex)
- `lem:stage6_regular_stalk_assembly` (Picard chapter — locate via grep)
- `lem:smooth_proper_curve_projective` (also in (1))

For `lem:stalk_linear_map` specifically: the source `Vestigial.lean` provides
several closely-related decls (`stalkLinearMap`, `stalkLinearMap_germ`,
`stalkLinearMap_bijective_of_isIso`, `stalkLinearEquivOfIsIso`). Pin `\lean{}` at
the primary one (`AlgebraicGeometry.Scheme.Modules.stalkLinearMap` or the
namespace you confirm by grep); do not invent a name.

**Remarks (`rem:`/`rmk:`) are exempt** from both pinning and connectivity — leave
them as-is unless wiring one is trivially correct.

**Out of scope:** the `Cohomology_StructureSheafModuleK` / `Cohomology_FlatBaseChange`
finiteness island (a sibling walker `cohomology-island` owns those — do not edit
those two files). Do NOT add `\leanok`. Do NOT rewrite existing proof prose.

## References
- Milne, *Abelian Varieties* — rigidity Thm 1.1, Thm 3.2/Prop 3.10
  (`references/abelian-varieties.md`) for the rational-map-extension / rigidity
  lemmas.
- Stacks tags 035U/04QM/056T (geom-reduced/regular), 09HD/030K
  (purely-inseparable factorisation) — `references/stacks-varieties.md`,
  `references/stacks-fields.md` — for the S3 separability steps.
- Cite verbatim from the local file only if you add or restate an
  externally-sourced block; pure `\uses{}` transcription and `\lean{}` pinning
  need no new citation.
