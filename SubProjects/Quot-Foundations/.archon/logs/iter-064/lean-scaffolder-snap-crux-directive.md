# Lean-scaffolder directive — SNAP crux stubs in SectionGradedRing.lean

Target file: `AlgebraicJacobian/Picard/SectionGradedRing.lean` (currently 0 sorries; the new
stubs make it sorry-bearing so the prover lane cannot be no-op-dropped — that is intentional).

## 1. Create `AlgebraicGeometry.Scheme.Modules.ztensor_whisker_localIso` (sorry body)
Blueprint: `lem:snap_ztensor_whisker_localIso` in `chapters/Picard_SectionGradedRing.tex` (~L604).
Statement: if `f : A ⟶ B` in `(Opens X)ᵒᵖ ⥤ AddCommGrpCat` is a stalkwise isomorphism, then for
any `C` the whiskered ℤ-tensor map `f ⊗_ℤ id_C` (use the file's existing ℤ-tensor presheaf
machinery, cf. `relTensorDomainPresheaf`) is again stalkwise iso, hence a local isomorphism —
membership in `J.W` for the opens topology (the file's `opensTopology`). Pick the Lean phrasing
that the consumer (item 2) can actually feed into the sheafification-inverts-`W` criterion the
chapter's `lem:isIso_sheafification_map_iff` anchor provides — verify with `lean_local_search` /
loogle what form Mathlib's `GrothendieckTopology.W` membership and `TopCat.Presheaf.stalk`
filtered-colimit-commutes-with-`⊗ℤ` API take, and inject the verified paths into the
`/- Planner strategy -/` comment.

## 2. Create `AlgebraicGeometry.Scheme.Modules.isIso_sheafification_whiskerRight_unit` (sorry body)
Blueprint: `lem:isIso_sheafification_whiskerRight_unit` (~L849, the `\lean{}` pin already names
exactly this). Statement: for presheaves of modules `P Q`, the sheafification image of the right
whiskering `η_P ▷ Q` of the sheafification unit is an isomorphism. Inject the chapter's 4-step
proof route as the planner-strategy comment: localization criterion (sheafification inverts
exactly `W`) → relative tensor as coequalizer (`relativeTensorCoequalizerIso`, DONE, L~702) →
abelian sheafification preserves coequalizers (left adjoint) → whiskered units stalkwise iso
(item 1). Name verified Mathlib anchors where you can; flag absences honestly.

## 3. Hygiene (same file, while in there)
- DELETE the stale `NOTE (iter-063)` doubt about `evaluationJointlyReflectsColimits` in the
  planner-strategy comment (~L683): the lemma exists at
  `Mathlib/CategoryTheory/Limits/FunctorCategory/Basic.lean:103` and the proof using it is closed.
- PRUNE the "superseded handoff notes" block (~L763–845) and the stale ITER-052/053 status
  markers in the `tensorPowAdd` planning block (~L847–962): keep still-true mathematical
  content, drop superseded/iter-stamped narrative.

## Constraints
- Only this file. Both new decls compile with `sorry` bodies; `lake build
  AlgebraicJacobian.Picard.SectionGradedRing` must be green before you finish.
- Do not modify any existing proven declaration.
- Universe/category conventions from the file: abelian category is `AddCommGrpCat` (NOT
  `AddCommGrp`); `(P ⊗ Q)` must be written `MonoidalCategory.tensorObj (C := MonoidalPresheaf X)`
  in fresh `have`s.
