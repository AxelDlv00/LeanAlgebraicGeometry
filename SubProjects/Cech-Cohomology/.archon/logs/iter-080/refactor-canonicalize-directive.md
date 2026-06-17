# Refactor: canonicalize cech_computes_higherDirectImage (protection lifted)

The protected freeze on `AlgebraicGeometry.cech_computes_higherDirectImage` was removed by the
mathematician. Its general signature (no affine-cover, no `[X.IsSeparated]`) is mathematically FALSE
(single-element cover {𝟙 X} on ℙ¹, F=O(-2): Hⁱ(Čech)=0 but R¹f_*F≠0). The correct, fully-proved
theorem already exists as `cech_computes_higherDirectImage_of_affineCover`. Unify them under the
canonical name.

## Action
1. `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`: DELETE the theorem
   `cech_computes_higherDirectImage` (the `sorry` at ~L780) together with its immediately-preceding
   `/-- ... -/` docstring (starts ~L749 `**The Čech complex computes the higher direct images**`).
   Keep `cechAugmentedComplex` (just above) and `end AlgebraicGeometry`. Update/remove the module-doc
   bullet (~L45) that references the deleted theorem (note the result now lives in
   `CechToHigherDirectImage.lean`).
2. `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean`: RENAME the theorem
   `cech_computes_higherDirectImage_of_affineCover` (~L198) to `cech_computes_higherDirectImage`
   (signature and proof body UNCHANGED). Update the file module docstring (L13–27) and the decl
   docstring (~L185–197) to drop the now-obsolete "frozen / left as a sorry / escalated" framing —
   this IS the canonical theorem now (correct hypotheses: `[X.IsSeparated] [S.IsSeparated]`,
   `h𝒰 : ∀ i, IsAffine (𝒰.X i)`, `hres`).
3. `AlgebraicJacobian/Cohomology/CechTermAcyclic.lean` (~L29): update the comment mention of
   `cech_computes_higherDirectImage_of_affineCover` to the new name `cech_computes_higherDirectImage`.

## Verify (REQUIRED — this also confirms the long-unverified capstone)
- Build both touched files; confirm 0 errors / 0 sorries.
- `#print axioms AlgebraicGeometry.cech_computes_higherDirectImage` — must be kernel-only
  (propext/Classical.choice/Quot.sound), NO `sorryAx`, NO project axioms. Report the axiom list verbatim.

## Constraints
- No proof changes; rename + delete + comment edits only. Insert NO `sorry`.
- Do not touch any other declaration or file.
