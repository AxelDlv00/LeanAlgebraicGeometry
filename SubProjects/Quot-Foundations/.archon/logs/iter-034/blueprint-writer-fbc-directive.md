# blueprint-writer directive — Cohomology_FlatBaseChange.tex (iter-034)

Chapter: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (consolidated:
`% archon:covers AlgebraicJacobian/Cohomology/FlatBaseChange.lean AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean`).
You edit ONLY this chapter. Three scoped parts. Do NOT add `\leanok` (deterministic sync owns it);
you MAY add `\mathlibok` ONLY on genuine Mathlib dependency anchors named below.

## Strategy context
The affine i=0 flat base-change comparison `g^* f_* F ⟶ f'_* g'^* F` (Stacks 02KH part 2). Its
iso-ness is ALREADY established as the conjugate of `gammaPushforwardNatIso` (`pullback_spec_tilde_iso`
= `conjugateIsoEquiv adjL adjR`). The remaining work is a COHERENCE identity (`_legs` / `gstar_transpose`)
identifying that abstract conjugate with the concrete sheaf assembly. The project has DECIDED (Open Q2)
to ABANDON the direct-on-sections explicit-factor approach and re-encode the coherence on the conjugate
side. Full rationale + Mathlib API map: `analogies/fbc-mate-reencode.md` (READ THIS FIRST).

## PART A — Re-encode the `_legs` / `codomain_read_legs` / `gstar_transpose` proof route

The current chapter (labels around lines 1180–2700) describes the ABANDONED direct-on-sections route as
a long chain of granular wrapper lemmas:
`lem:base_change_mate_codomain_read_legs`, `lem:base_change_mate_fstar_reindex_legs_unitExpand`,
`…_gammaDistribute`, `…_link_distributeCollapse`, `…_link_cancelEUnit`, `…_link_cancelPullbackComp`,
`…_link_survivor`, `lem:base_change_mate_fstar_reindex_legs`, then the `inner_eCancel_*` family and
`lem:base_change_mate_gstar_transpose`.

Rewrite the PROOF strategy of this section (keep the top-level statements
`lem:base_change_mate_fstar_reindex_legs`, `lem:base_change_mate_gstar_transpose`,
`lem:base_change_mate_codomain_read_legs`, and the consumers
`lem:base_change_mate_section_identity` / `lem:affine_base_change_pushforward` intact — they are the
load-bearing pins) to the conjugate-side mate calculus:

1. **Re-cut `base_change_mate_codomain_read_legs` proof-free.** Restate it so the codomain-read
   comparison object is built from `Scheme.Modules.leftAdjointCompIso` of the FREE morphisms `e.hom`
   and `Spec.map inclA` (the pasted square enters via `pushforwardCongr comm` / `pushforwardComp`),
   carrying NO `hfst/hsnd` equality proofs. Cite Mathlib
   `CategoryTheory.Adjunction.leftAdjointCompIso` and `conjugateEquiv_leftAdjointCompIso_inv`
   (`Mathlib/CategoryTheory/Adjunction/CompositionIso.lean`).
2. **Restate `_legs` at the explicit composite** `e.hom ≫ Spec.map inclA` (not at the abstract
   projection legs).
3. **Prove the coherence on the conjugate side.** The informal proof body must describe: apply
   `(Scheme.Modules.conjugateEquiv …).injective`; replace each locked nat-trans on the right-adjoint
   side by a free variable via `(conjugateEquiv …).surjective …` (`obtain ⟨τ, rfl⟩`); discharge with the
   reassoc conjugate simp set (`conjugateEquiv_comp`, `conjugateEquiv_symm_comp`,
   `conjugateEquiv_whiskerLeft`/`_whiskerRight`, `conjugateEquiv_associator_hom`) plus the project's
   `conjugateEquiv_pullbackComp_inv` and the pushforward-side collapses
   (`gammaMap_pushforwardComp_*`, `gammaMap_pushforwardCongr_hom`). The cross-layer naturality of
   `gammaPushforwardIso ψ` enters as `unit_conjugateEquiv_symm` (the Seam-1 tool) composed one functor
   layer up via `conjugateEquiv_comp` — NOT as a positional naturality rewrite.
4. **Mark the now-superseded granular direct-on-sections wrapper lemmas.** The deep `_legs_link_*`
   chain (`unitExpand`, `gammaDistribute`, `link_distributeCollapse`, `link_cancelEUnit`,
   `link_cancelPullbackComp`, `link_survivor`) and the `inner_eCancel_*` family described the abandoned
   route. For each, either (a) repurpose it as a sub-step of the new conjugate-side proof if it still
   serves, or (b) add a `% NOTE: superseded by the conjugate-side re-encoding (Open Q2)` comment and
   remove its `\uses{}` edges into the live `_legs` proof so the DAG no longer treats it as a live
   dependency. Do NOT delete the Lean pins (the decls still exist in the file pending the iter-035
   refactor); just make the blueprint reflect that the LIVE proof route is the conjugate-side one.

Add Mathlib dependency anchor blocks (with `\lean{}` + `\mathlibok`) for the genuine Mathlib hooks:
`CategoryTheory.Adjunction.leftAdjointCompIso`, `CategoryTheory.conjugateEquiv_leftAdjointCompIso_inv`,
`CategoryTheory.iterated_mateEquiv_conjugateEquiv`, `CategoryTheory.conjugateIsoEquiv`,
`CategoryTheory.unit_conjugateEquiv_symm` (verify each name/signature against the analogies file).

## PART B — Coverage block for the FBC-B consolidation corollary

Add a blueprint block for the unmatched Lean decl
`AlgebraicGeometry.Modules.exists_finite_affineCover_isLimit_sheafConditionFork`
(FlatBaseChangeGlobal.lean:78). It consolidates `lem:finite_affine_cover_qcqs` +
`lem:gamma_finite_equalizer`: for a QCQS scheme `X` and `M : X.Modules`, there is a finite affine cover
(ι finite, all affine, ⨆=⊤, QC overlaps) whose sheaf-condition fork of `M.presheaf` is a limit.
Give it a `\label` (suggest `lem:gamma_finite_equalizer_cover`), `\lean{}`,
`\uses{lem:finite_affine_cover_qcqs, lem:gamma_finite_equalizer}`, one-line informal proof.

## PART C — Blueprint blocks for the FBC-B `eqLocus` build-ahead sub-lane

The FBC-B globalization expresses `Γ(X,M)` as `LinearMap.eqLocus leftRes rightRes` over `A = Γ(X,⊤)`
and applies Mathlib's `LinearMap.tensorEqLocusEquiv` (VERIFIED to exist in
`Mathlib.RingTheory.Flat.Equalizer`: `[Module.Flat R M] : M ⊗[R] (f.eqLocus g) ≃ₗ[S] (lTensor S M f).eqLocus (lTensor S M g)`)
to show flat base change preserves it. This sub-lane is INDEPENDENT of the affine sorry. Add blueprint
blocks (statement + `\label` + `\lean{}` placeholder pins for the to-be-built decls + `\uses` +
informal proof) for the three ingredients (from the FBC-B prover handoff):
1. **A-module structures on `Γ(M,Uᵢ)`, `Γ(M,Uᵢⱼ)`** via restriction of scalars along
   `A = Γ(X,⊤) → Γ(X,Uᵢ)` (the maps are `Γ(X,·)`-semilinear over the restriction ring maps).
2. **A-linear `leftRes`/`rightRes` product maps** (the `SheafConditionEqualizerProducts.leftRes/rightRes`
   read in `ModuleCat A`).
3. **An A-linear iso `Γ(M,⊤) ≅ LinearMap.eqLocus leftRes rightRes`** derived from the Ab-`IsLimit` of
   `lem:gamma_finite_equalizer` (categorical fork-limit in Ab → set-level equalizer = eqLocus → upgrade
   to A-linear via `forget₂ (ModuleCat A) Ab` reflecting limits).
Add a Mathlib anchor block for `LinearMap.tensorEqLocusEquiv` (`\lean{LinearMap.tensorEqLocusEquiv}`,
`\mathlibok`, the verified signature above). Suggested labels: `lem:gamma_amodule_restriction`,
`lem:gamma_alinear_res_maps`, `lem:gamma_eqLocus_iso`, `lem:tensor_eqLocus_equiv_mathlib`.

## Citation discipline
Stacks 02KH is the FBC source; quote verbatim where the existing chapter already does. For the new
Mathlib anchors, the `\lean{}` name + signature suffices (no external prose source needed). Authorize a
child reference-retriever only if you need Stacks 02KH text not already in the chapter.

## Out of scope
Do not touch QUOT / GR chapters. Do not add `\leanok`. Do not rename existing live pins
(`lem:affine_base_change_pushforward`, `lem:base_change_mate_fstar_reindex_legs`,
`lem:base_change_mate_gstar_transpose`).
