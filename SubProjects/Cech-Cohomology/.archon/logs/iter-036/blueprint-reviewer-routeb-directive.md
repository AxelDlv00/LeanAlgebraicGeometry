# Blueprint Reviewer Directive — iter-036 fast-path (Route B)

Whole-blueprint audit as usual, but this dispatch is a **same-iter fast-path re-review**: the
chapter `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` was **rewritten this iter**
(after the earlier `blueprint-reviewer-iter036` ran) to pivot the 01I8 affine lemma from the old
"Route P / global generation + tilde base-change" to the new **Route B (section-localization)**.
The earlier iter036 verdict (partial/partial) predates that rewrite and its must-fixes were about
the now-dormant old route — re-assess against the CURRENT text.

## Primary question (gate decision)
Is the new **Route B** section of `Cohomology_CechHigherDirectImage.tex` (the
`\section{Route B: ...}` block, roughly lines 3852–4140) **complete** and **correct** enough to
dispatch a prover at its keystone? Specifically:

- `lem:qcoh_section_isLocalizedModule` (Lean `AlgebraicGeometry.qcoh_section_isLocalizedModule`) —
  the Route B P1 keystone: for quasi-coherent `F` on `Spec R` and `f∈R`, the section-restriction
  `ρ_f : Γ(X,F) → Γ(D(f),F)` is `IsLocalizedModule (.powers f)`. Is the proof sketch rigorous and
  formalizable (finite-cover refinement → local presentation → free-piece section-localization +
  standard-cover Čech acyclicity → `isLocalizedModule_of_span_cover` descent)? Are its `\uses`
  accurate and all deps already done (`lem:isLocalizedModule_of_span_cover`,
  `lem:exists_finite_basicOpen_subcover`, `lem:free_isQuasicoherent`, `lem:cech_acyclic_affine`)?
- `lem:qcoh_isIso_fromTildeGamma` (Lean `AlgebraicGeometry.isIso_fromTildeΓ_of_quasicoherent`) —
  the assembly: keystone + Mathlib anchors (`lem:fromTildeGamma_mathlib`,
  `lem:isIso_fromTildeGamma_iff_mathlib`, `lem:forget_reflectsIso_mathlib`,
  `lem:isLocalizedModule_linearEquiv_mathlib`) ⟹ `IsIso fromTildeΓ`. Sound, no circularity with
  02KG affine vanishing it ultimately feeds?
- The four `\mathlibok` anchor blocks — do their `\lean{}` pins name genuine Mathlib declarations
  and do the statements match what Mathlib provides?

## Secondary
- Confirm the now-dormant Route-A blocks (`lem:tilde_preserves_kernels`,
  `lem:tilde_restrict_basicOpen`, `lem:presentation_restrict_basicOpen`,
  `lem:isQuasicoherent_restrict_basicOpen`, `lem:qcoh_global_generation`,
  `lem:isIso_fromTildeGamma_of_genSections`) are clearly marked dormant/fallback and do NOT
  create false frontier readiness for the live Route B path.
- Confirm `% archon:covers AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` header is now
  present.
- Note any remaining coverage debt (the 4 TildeExactness helpers `stalkMapₗ`, `stalkMapₗ_eq`,
  `stalkMapₗ_injective`, `tilde_germ_algebraMap_smul` are dormant-route helpers the planner will
  wire into `lem:tilde_preserves_kernels`'s `\lean{}` this iter).

## Output
Per-chapter complete/correct verdict as usual, with an explicit GATE line for
`lem:qcoh_section_isLocalizedModule` / `lem:qcoh_isIso_fromTildeGamma`: PASS (dispatch) or the
specific must-fix that blocks dispatch.
