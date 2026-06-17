# Blueprint Writer Report

## Slug
coverage

## Status
COMPLETE — all 27 previously-unmatched Lean helpers now have a blueprint home;
`archon dag-query unmatched` → 0, `unknown_uses: []`, DAG acyclic, LaTeX balanced (79/79).

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Work item 1 — the un-localised section Čech module complex `D•` (two new blocks)
- **Added definition** `\definition`/`\label{def:section_cech_module_complex}` — the
  un-localised section Čech module complex `D• = ∏_σ M_{s_σ}` over `Spec R` with
  `M = Γ(Spec R, F)`, degree-`p` term `LocalizedModule (.powers (∏_k s_{σ k})) M`,
  alternating-signed coface differential. `\uses{def:standard_affine_cover, def:qcoh_sections_localized}`.
  Bundled into its `\lean{...}` list all of the construction + localisation-comparison
  helpers named in the directive: `SectionCechModule.{dCoeff, dCoface, dDiff, dDiff_apply,
  dToCech, dToCech_isLocalizedModule, cechCoface_dToCech, dToCech_comm, cechCofaceLin,
  cechCoface_apply, locDiff, locDiff_apply, locDiff_eq_depDiff, locDiff_exact, fLoc,
  fLoc_apply, fLoc_isLocalizedModule, locDiff_fLoc, map_dDiff_eq_locDiff, spanIdx,
  spanIdx_spec}` plus the localisation-transitivity keystones
  `AwayComparison.comparison_isLocalizedModule` and `AwayComparison.Inverts.smul_pow_cancel`.
  The private `spanIdx`/`spanIdx_spec` are bundled here (no dedicated node), as directed.
- **Added lemma** `\lemma`/`\label{lem:section_cech_module_exact}`/`\lean{...dDiff_exact}` —
  P3 L1 step (a): positive-degree exactness `Function.Exact (dDiff (p+1)) (dDiff (p+2))`.
  `\uses{def:section_cech_module_complex}`.
  - Proof sketch added: Y — `exact_of_isLocalized_span (range s)` reduces to per-`s_r`
    localisations; `map_dDiff_eq_locDiff` identifies the localised differential with the
    proven localised Čech differential, whose exactness is `locDiff_exact` (transported
    from the dependent combinatorial port via `locDiff_eq_depDiff`).
- **Revised** `lem:section_cech_homology_exact` — added `lem:section_cech_module_exact`
  to its `\uses` (step (c) consumes step (a), made explicit per directive).

### Work item 2 — CechBridge helper
- **Revised** `lem:cech_complex_hom_identification` — bundled
  `AlgebraicGeometry.homCechSectionCosimplicialIso` into its `\lean{...}` list (the
  cosimplicial natural iso underlying the hom-identification).

### Work item 3 — FreePresheafComplex helpers
- **Revised** `lem:quasiIso_of_evaluation` — bundled
  `AlgebraicGeometry.isIso_Fmap_homologyMap` and `AlgebraicGeometry.isIso_of_evaluation`
  (the two private helpers of `quasiIso_of_evaluation`) into its `\lean{...}` list.

## Cross-references introduced
- `\uses{def:standard_affine_cover, def:qcoh_sections_localized}` in
  `def:section_cech_module_complex` — both exist in this chapter; resolve (verified, unknown_uses=[]).
- `\uses{def:section_cech_module_complex}` in `lem:section_cech_module_exact` (block + proof) — resolves.
- `\uses{lem:section_cech_module_exact}` added to `lem:section_cech_homology_exact` — resolves.

## References consulted
None opened this session. The two new `D•` blocks are project-bespoke construction
results (an explicit Lean module complex and its exactness transported from internal
combinatorial content); per citation discipline, bespoke blocks omit `% SOURCE` lines
and stand on the proof sketch. No new verbatim quotes were written, so no `references/`
files needed reading. The existing Stacks 01HV / localisation citations already present
on the neighbouring `def:qcoh_sections_localized` and `lem:section_cech_homology_exact`
blocks carry the external grounding for the localisation facts these new blocks reuse.

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **`depDiff_exact` provenance / deliberate edge choice (avoids a DAG cycle).** The
  directive suggested pointing `def:section_cech_module_complex`'s `\uses` at "the
  localised-exactness content of `lem:cech_acyclic_affine`'s proof (`depDiff_exact`)".
  `depDiff_exact` is bundled in the `\lean{}` list of `lem:cech_acyclic_affine` (the
  ROOT of this sub-tree), and that lemma's proof already `\uses{lem:section_cech_homology_exact}`
  (line 789). Adding `def:section_cech_module_complex → lem:cech_acyclic_affine` would
  therefore create the 4-cycle
  `cech_acyclic_affine → section_cech_homology_exact → section_cech_module_exact → def → cech_acyclic_affine`.
  I instead wired the def DOWNWARD to its genuine, acyclic foundations
  (`def:standard_affine_cover`, `def:qcoh_sections_localized`) and described the
  `depDiff_exact` transport in prose. The mathematical dependency on the combinatorial
  exactness is still carried transitively: the def bundles `locDiff_exact`/`locDiff_eq_depDiff`,
  whose exactness IS the dependent-port `depDiff_exact` (bundled in `lem:cech_acyclic_affine`).
  If you want that edge first-class without a cycle, the clean fix is to give
  `CombinatorialCech.depDiff_exact` its OWN leaf node (split it out of the
  `lem:cech_acyclic_affine` bundle) and have both `def:section_cech_module_complex` and
  `lem:cech_acyclic_affine` `\uses` that leaf. That is a (small) re-decomposition I left
  alone since the directive said not to re-decompose the chain and the cycle-free wiring
  already achieves coverage 0.
- `leandag build` reports `unmatched_lean: 28` — this is the *inverse* (blueprint-node →
  Lean-name) metric for nodes leandag can't match to a compiled declaration; it is
  pre-existing and unrelated to the 1-to-1 coverage debt. The directive's metric,
  `archon dag-query unmatched` (Lean decls with no blueprint entry), is now 0.
