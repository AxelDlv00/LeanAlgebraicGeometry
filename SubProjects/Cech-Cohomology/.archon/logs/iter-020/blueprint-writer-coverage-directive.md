# Blueprint-writer directive — clear the 1-to-1 coverage debt (iter-020)

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the single consolidated chapter;
`% archon:covers` lists all the Čech files). Edit ONLY this chapter.

## Goal
Restore the Lean↔blueprint 1-to-1 correspondence: every prover-created helper below currently has NO
blueprint entry (`archon dag-query unmatched` lists 27 after the effort-breaker gave
`quasiIso_of_evaluation` a home). Give each a blueprint home — either a dedicated block (statement,
`\label`, `\lean`, accurate `\uses`, one-line informal proof) or, for pure helpers, bundle the name
into the `\lean{...}` list of the related block. The entry is what carries the dependency edges.

Do NOT add `\leanok` (deterministic sync owns it). Do NOT touch the protected
`cech_computes_higherDirectImage`. Do NOT re-decompose `lem:cech_free_complex_quasi_iso` — the
effort-breaker just split it; leave its 6-link chain intact.

## Work item 1 — the un-localised section Čech module complex `D•` (CechAcyclic.lean, P3 L1 step (a))
This is the genuine algebraic core of `lem:cech_acyclic_affine` (section form). It deserves real
blocks, not just bundling. Create two new blocks, placed near `def:qcoh_sections_localized` /
`lem:section_cech_homology_exact` (which already exist in the chapter):

(1a) **`\begin{definition}` `\label{def:section_cech_module_complex}`** — the un-localised section
Čech module complex `D• = ∏_σ M_{s_σ}` over `Spec R` with `M = Γ(Spec R, F)` and `s : ι → R` a finite
spanning family (`Ideal.span (Set.range s) = ⊤`): degree-`p` term `D^p(σ) = LocalizedModule (.powers (∏_k s_{σ k})) M`,
alternating-signed coface differential. Bundle into its `\lean{...}` list ALL of these helper decls
(they are the construction + its localisation comparison machinery):
`AlgebraicGeometry.SectionCechModule.dCoeff`, `.dCoface`, `.dDiff`, `.dDiff_apply`, `.dToCech`,
`.dToCech_isLocalizedModule`, `.cechCoface_dToCech`, `.dToCech_comm`, `.cechCofaceLin`,
`.cechCoface_apply`, `.locDiff`, `.locDiff_apply`, `.locDiff_eq_depDiff`, `.locDiff_exact`,
`.fLoc`, `.fLoc_apply`, `.fLoc_isLocalizedModule`, `.locDiff_fLoc`, `.map_dDiff_eq_locDiff`,
and the localisation-transitivity keystone `AlgebraicGeometry.AwayComparison.comparison_isLocalizedModule`,
`AlgebraicGeometry.AwayComparison.Inverts.smul_pow_cancel`.
`\uses{}`: the already-present localised-exactness content of `lem:cech_acyclic_affine`'s proof
(the `CombinatorialCech.*` dependent-coefficient exactness `depDiff_exact`, which the localised
differential's exactness is transported from). One-line informal proof: the differential is the
alternating sum of localisation-comparison maps `M_{s_σ} → M_{s_r s_σ}`; localising `D•` at a spanning
element `s_r` (`IsLocalizedModule.Away`) reproduces the localised Čech complex via the transitivity
`M_a[1/b] = M_{ab}` (`comparison_isLocalizedModule`).

(1b) **`\begin{lemma}` `\label{lem:section_cech_module_exact}`** — `\lean{AlgebraicGeometry.SectionCechModule.dDiff_exact}`
— **P3 L1 step (a)**: positive-degree exactness `Function.Exact (dDiff (p+1)) (dDiff (p+2))` of `D•`.
`\uses{def:section_cech_module_complex}` (and the localised-exactness chain it transports from).
Informal proof: by `exact_of_isLocalized_span (Set.range s)` (the spanning hypothesis), it suffices to
check exactness after localising at each `s_r`; `map_dDiff_eq_locDiff` identifies the localised
differential with the proven localised Čech differential, whose exactness is
`CechLocalized.cechLocalized_exact` / `locDiff_exact`. Wire `lem:section_cech_homology_exact`'s `\uses`
to include `lem:section_cech_module_exact` (step (c) consumes step (a) — make that edge explicit).
The private helpers `SectionCechModule.spanIdx`, `.spanIdx_spec` need no node (they are
implementation-detail `Exists.choose` wrappers); leave them out (they will still show in `unmatched`
unless bundled — bundle them into `def:section_cech_module_complex`'s `\lean{}` list to keep the count
at 0).

## Work item 2 — CechBridge helper
Bundle `AlgebraicGeometry.homCechSectionCosimplicialIso` into the `\lean{...}` list of the existing
`lem:cech_complex_hom_identification` block (it is the cosimplicial natural iso underlying the
hom-identification; `cechComplex_hom_identification := (alternatingCofaceMapComplex Ab).mapIso` of it).

## Work item 3 — FreePresheafComplex helpers
Bundle `AlgebraicGeometry.isIso_Fmap_homologyMap` and `AlgebraicGeometry.isIso_of_evaluation` (the two
private helpers of `quasiIso_of_evaluation`) into the `\lean{...}` list of the new
`lem:quasiIso_of_evaluation` block the effort-breaker just created.

## Verification
After editing, the intent is `archon dag-query unmatched` → 0. Keep LaTeX balanced. Use project
notation, no Lean tactics in proofs. Authorize a reference-retriever only if you find you need a source
you lack (you should not — reuse the chapter's existing Stacks 01HV / localisation quotes for the D•
blocks; if the D• blocks need a localisation citation, the chapter already cites Stacks Schemes 01HV).
