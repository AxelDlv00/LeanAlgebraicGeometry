# Lean ↔ Blueprint Checker Directive

## Slug

cotangent-grpobj-review135

## Iteration

135

## Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean`

## Blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex`

(There is also an auxiliary one-file pointer chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`
that mirrors the Lean file structure. Cross-check `\lean{...}` hints
appear consistently in both, but treat `RigidityKbar.tex` as the
canonical mathematical chapter and the auxiliary as a per-Lean-file
pointer.)

## Known issues (do NOT re-report)

- **Iter-134 placeholder convention is RESOLVED iter-135.** The 3
  prior `Nonempty (X ≅ X) := ⟨Iso.refl _⟩` placeholders were refactored
  to `noncomputable def ... := sorry` with intended sheaf-level RHS
  signatures using `PresheafOfModules.pullback
  (Scheme.Hom.toRingCatSheafHom <morphism>).hom`. The 3 sorries are
  honest scaffolds per the project's iter-127-onward convention
  (`genusZeroWitness`, `positiveGenusWitness`, `nonempty_jacobianWitness`,
  `rigidity_over_kbar`). DO NOT classify these `sorry`-bodied
  intended-type scaffolds as must-fix — they are the explicitly-adopted
  pattern for multi-iter NEEDS_MATHLIB_GAP_FILL work.
- Bridge `cotangentSpaceAtIdentity_eq_extendScalars` and rank lemma
  `cotangentSpaceAtIdentity_finrank_eq` are both fully closed
  iter-131 / iter-132 (no `sorry`). Skip.
- Three NEW honest-scaffold declarations at
  `Cotangent/GrpObj.lean:468 / :496 / :560`:
  - `relativeDifferentialsPresheaf_basechange_along_proj_two`
  - `relativeDifferentialsPresheaf_restrict_along_identity_section`
  - `mulRight_globalises_cotangent`
  Their intended types are spelled out in the blueprint chapter
  `RigidityKbar.tex` § Piece (i.b) with `\notready` markers on the
  proof blocks (the deterministic `sync_leanok` should NOT have a
  `\leanok` on those proof blocks post iter-135).
- The 27-line iter-134 "placeholder-apology" docstring block at L421
  was REWRITTEN to a ~17-line iter-135 honest-scaffold docstring
  pointing at the `Scheme.Hom.toRingCatSheafHom` idiom and contrasting
  it with the in-file `schemeHomRingCompatibility` adjunction-transpose
  helper.

## What's new this iter

Iter-135 (NO prover lane) plan-phase refactor:

1. 3 placeholder theorems → 3 honest sorry-bodied scaffolds (signatures
   per iter-135 mathlib-analogist (B1)/(B2)/(B3) intended types).
2. `schemeHomRingCompatibility` docstring addendum (clarifies it is NOT
   the φ for `PresheafOfModules.pullback`).
3. Section docstring at L421 rewritten.
4. File-header stale Lean-line anchors de-pinned (declaration names).
5. New import `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`.

## Authoritative paths

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean`
- Blueprint chapter (canonical): `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex`
- Blueprint chapter (auxiliary pointer): `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`
