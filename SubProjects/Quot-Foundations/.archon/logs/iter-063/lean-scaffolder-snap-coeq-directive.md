Target file: `AlgebraicJacobian/Picard/SectionGradedRing.lean`
Blueprint chapter: `blueprint/src/chapters/Picard_SectionGradedRing.tex`, label `lem:relativeTensor_as_coequalizer`.

## Action
Scaffold ONE new declaration `AlgebraicGeometry.Scheme.Modules.relativeTensorCoequalizerIso`
with a `sorry` body (do NOT prove it). This decl currently exists only in docstrings — it has
never been created, and the prover lane keeps getting dropped because the file is 0-sorry. Your
job is to add the real declaration + a rich planner-strategy comment so the next prover has a
genuine sorry to fill.

## Signature
A presheaf-level (functor-category `(Opens X)ᵒᵖ ⥤ AddCommGrpCat`) coequalizer/`IsColimit`
witness exhibiting the underlying abelian-group presheaf of `P ⊗_{p,O_X} Q` as the coequalizer
of the parallel pair `relTensorActL`, `relTensorActR` (triple presheaf ⇉ ℤ-tensor presheaf) with
cofork leg `relTensorProj`. Read the EXISTING decls `relTensorActL`, `relTensorActR`,
`relTensorProj`, `relTensorTriplePresheaf`, `relTensorDomainPresheaf` already in this file (they
are closed/axiom-clean) and the 22-decl `RelativeTensorCoequalizer.*` API (esp.
`RelativeTensorCoequalizer.isColimitCofork`) to fix the EXACT Lean type. Prefer the shape that the
3-step proof naturally produces — most likely a `CategoryTheory.Limits.IsColimit` of the cofork
`CategoryTheory.Limits.Cofork.ofπ relTensorProj …`, or the coequalizer iso. Use
`AddCommGrpCat` (NOT `AddCommGrp`) as the abelian-group category — verified convention in this file.

## Planner-strategy comment (inject verbatim as `/- Planner strategy: ... -/` above the sorry)
3-step promotion (blueprint `lem:relativeTensor_as_coequalizer` proof):
1. OBJECTWISE — at each `U`, instantiate `RelativeTensorCoequalizer.isColimitCofork` with
   `S = O_X(U)`, `M = P(U)`, `N = Q(U)`. (API DONE axiom-clean.)
2. PROMOTE — the three objectwise families ARE `relTensorActL`/`relTensorActR`/`relTensorProj`
   (already natural). A functor-category cocone is a colimit iff every evaluation is, via
   `CategoryTheory.Limits.evaluationJointlyReflectsColimits` [Mathlib, verify with leansearch].
3. APEX — identify the apex presheaf `U ↦ P(U) ⊗_{O_X(U)} Q(U)` with the underlying Ab-presheaf
   of `P ⊗_p Q` via `PresheafOfModules.Monoidal.tensorObj_obj` (verify the exact Mathlib name with
   leansearch/loogle); transport the colimit along it.
Reusable recipe: the `TensorProduct.ext'`→transport-to-`Ab` idiom from `relTensorProj.naturality`
is the carrier-bookkeeping pattern. `(P ⊗ Q)` in a fresh `have` must be written
`MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q` (bare `⊗` re-resolves to TensorProduct).

## Constraints
- ONE decl only; `sorry` body; do NOT attempt any proof steps.
- Verify every Mathlib name you cite with `lean_leansearch`/`lean_loogle`; do not invent names.
- The file MUST compile (`lake build` green) with the sorry stub. If you cannot land a
  type-correct signature without proving, leave the closest compiling signature and flag the
  uncertainty in your report.
- Do NOT touch any other declaration in the file. Do NOT edit `.tex`.
