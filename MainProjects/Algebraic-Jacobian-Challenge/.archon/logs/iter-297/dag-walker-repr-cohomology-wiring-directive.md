# DAG Walker Directive

## Slug
repr-cohomology-wiring

## Seed
def:inst_pic_scheme_group_object (FGA representability of the Picard scheme), and
secondarily thm:rel_pic_etale_sheaf_group_structure (the relative Picard functor).
Walk UP their cones across the Picard-representability and cohomology chapters.

## The problem you are fixing (read carefully)
Every blueprint declaration in these chapters already has a statement and a finite
informal proof (there are NO ∞ blueprint nodes). The defect is **missing `\uses{}`
edges**: the directed dependency graph computed from `\uses{}` has the
representability + cohomology machinery sitting in connected components that are
**not reachable** from the project goal. Concretely, these chapters' apex theorems
(listed below) are used by nothing — they are graph "apexes" with no consumer
edge, and many internal `\uses{}` lists under-declare what the Lean proof actually
invokes. Your job is **edge transcription**: read each consumer's Lean source and
add the `\uses{}` edges it is missing, so each apex is wired to its real consumer
and the whole subsystem becomes one connected sub-DAG flowing upward toward
`thm:pic_zero_dimension_equals_genus` / `def:inst_has_pic_scheme`.

You are NOT rewriting proofs or content. You ADD `\uses{}` edges (and, only if a
genuinely-needed dependency lemma has no block at all, add a minimal block for it).

## Strategy context
The Jacobian is `Pic⁰_{C/k}`. Its construction route (Kleiman/FGA, Route A) is:
relative Picard functor → étale sheafification → FGA representability via the Quot
scheme → flattening stratification + relative Spec → all resting on flat base
change and Čech/higher-direct-image cohomology of quasi-coherent sheaves. Each
layer's apex must `\uses{}` the layer below it; the top layer (FGA representability,
`inst_pic_scheme`) is consumed by the identity-component chapter (which is a
SIBLING walker's chapter — you do NOT edit it; just make your apexes clean so it
can wire to them).

## Depth / scope — WRITE-DOMAIN (these chapters ONLY)
- blueprint/src/chapters/Picard_RelativeSpec.tex
- blueprint/src/chapters/Picard_QuotScheme.tex
- blueprint/src/chapters/Picard_FlatteningStratification.tex
- blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- blueprint/src/chapters/Picard_RelPicFunctor.tex
- blueprint/src/chapters/Picard_LineBundlePullback.tex
- blueprint/src/chapters/Picard_LineBundleCoherence.tex
- blueprint/src/chapters/Picard_SheafOverEquivalence.tex
- blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- blueprint/src/chapters/Cohomology_HigherDirectImage.tex
- blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- blueprint/src/chapters/Cohomology_MayerVietoris.tex
- blueprint/src/chapters/Cohomology_SheafCompose.tex
- blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex

You may `\uses{}` labels defined in OTHER chapters (e.g. the TensorObjSubstrate
chapter, or Differentials) — referencing a label is fine; you just may not EDIT
those other chapters.

## Apex nodes that currently have no consumer (wire each to its real user)
Within your chapters, these are "used by nothing" — find their consumer (often a
higher theorem in the SAME or a sibling chapter) by reading Lean source, and add
the consumer's `\uses{}`:
- FlatBaseChange: thm:flat_base_change_pushforward, lem:gammaPushforwardNatIso,
  lem:base_change_map_affine_local, lem:pushforward_base_change_mate_cancelBaseChange,
  lem:affine_base_change_pushforward, def:pushforward_base_change_map
- HigherDirectImage: thm:flat_base_change_higher, def:higher_direct_image
- CechHigherDirectImage: lem:cech_flat_base_change, def:cech_complex,
  def:cover_cech_nerve, def:push_pull_map, lem:push_pull_unit_mate,
  lem:push_pull_transport_cancel, def:relative_cech_complex_of_nerve,
  def:cech_higher_direct_image
- RelativeSpec: thm:relative_spec_base_change, thm:relative_spec_functorial,
  def:relspec_qcoh_pullback, thm:relative_spec_exists, thm:relative_spec_univ
- QuotScheme: thm:quot_canonical_basechange_isIso, lem:baseMap_pullbackComp_apply,
  lem:baseMap_pullback_comp_apply, lem:baseMap_pullbackCongr_apply,
  lem:baseMap_inv_step3_open_immersion, lem:quot_boundedness,
  lem:quot_valuative_criterion, lem:quot_reduction_to_pi_star_W
- FlatteningStratification: lem:flat_locus_assembly_lean,
  thm:flattening_stratification_universal, lem:flat_locus_open, lem:nonflat_locus_proper
- FGAPicRepresentability: def:inst_has_pic_sharp, def:inst_has_div_functor,
  def:inst_has_abel_map, def:inst_has_smooth_proper_quotient, def:inst_has_pic_scheme,
  def:inst_pic_sharp_representable, def:inst_pic_scheme_group_object
- RelPicFunctor: lem:rel_pic_sharp_unit_loctriv, def:rel_add, def:rel_neg,
  thm:rel_pic_etale_sheaf_group_structure, thm:rel_pic_etale_sheaf_unit_canonical
- SheafOverEquivalence: def:over_equiv_functor_is_continuous, def:phi_over,
  def:psi_over, lem:restrict_functor_eq_pushforward_psi_restrict,
  def:over_forget_nat_iso, def:linebundle_chart_over_iso, def:over_equiv_inverse_is_continuous
- LineBundleCoherence: cor:lbc_isFiniteType, lem:lbc_rank_flat
- LineBundlePullback: lem:OnProduct_isLocallyTrivial

## How to wire (the method)
1. Run `archon dag-query node --node <label> --json` and read the matched `.lean`
   declaration. The facts its proof invokes (project lemmas/defs it calls) are
   exactly what `\uses{}` must list. Add any that are missing.
2. Wire bottom-up: relative-spec/flat-base-change/Čech are the foundation; the
   higher-direct-image and Picard-representability theorems consume them.
3. For an apex with no consumer in your chapters: its consumer is almost always
   the next theorem up (e.g. `relative_spec_exists` consumes
   `relative_spec_affine_base`; `inst_has_pic_scheme` consumes the Quot/flattening
   theorems; `cech_higher_direct_image` consumes the Čech-nerve defs). Read the
   Lean source to confirm the real edge and add it. If the only honest consumer is
   in a sibling chapter you do not own, record it under "Notes for dispatcher".
4. Do NOT invent edges. Every `\uses{}` you add must reflect a dependency the Lean
   proof actually has.

## Out of scope
- Do NOT edit chapters outside the write-domain above.
- Do NOT touch the goal chapters (Jacobian.tex, AbelJacobi.tex, Genus.tex) — they
  are the mathematician's; record any edge they should gain in "Notes for dispatcher".
- Do NOT add `\leanok`. `\mathlibok` only on genuine Mathlib anchors.

## References
- references/kleiman-picard.md (FGA Pic existence, §4–5)
- references/nitsure-hilbert-quot.md (Quot/Hilbert construction)
- references/stacks-coherent.md (02KH flat base change of Rⁱf_*)
- references/stacks-constructions.md (relative Spec)
Only cite a reference on a block you actually add; pure edge additions need no new citation.
