Read-only frontier scan complete; no source edits made.

Concrete proof-ready candidates:

1. [Chapter4PrincipalDivisors.lean:160](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4PrincipalDivisors.lean:160)

   ```lean
   theorem principalDivisor_div (g h : X.left.functionFieldˣ) :
       principalDivisor (g / h) =
         principalDivisor g - principalDivisor h
   ```

   Proof: rewrite `div_eq_mul_inv`, then use `principalDivisor_mul`, `principalDivisor_inv`, and `sub_eq_add_neg`.

2. [Chapter4DivisorClass.lean:82](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4DivisorClass.lean:82)

   ```lean
   theorem linearlyEquivalent_zero_iff (D : CurveDivisor k X) :
       LinearlyEquivalent D 0 ↔
         ∃ g : X.left.functionFieldˣ, D = principalDivisor g
   ```

   Proof: `rw [linearlyEquivalent_iff_exists]; simp [sub_zero]`.

3. [Chapter4DivisorClass.lean:94](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4DivisorClass.lean:94)

   ```lean
   theorem linearlyEquivalent_principal_add
       (D : CurveDivisor k X) (g : X.left.functionFieldˣ) :
       LinearlyEquivalent (D + principalDivisor g) D
   ```

   Proof: apply `linearlyEquivalent_iff_divisorClass_eq`; simplify using additivity of `divisorClass` and `divisorClass_principalDivisor`.

4. [Chapter1CoordinateRing.lean:163](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter1CoordinateRing.lean:163)

   ```lean
   theorem singletonCoordinateRingEquiv_surjective (P : AffinePoint k n) :
       Function.Surjective (singletonCoordinateRingEquiv k n P)
   ```

   Immediate from `AlgEquiv.surjective`; lower priority but completes the singleton coordinate-ring API.

The current Hartshorne Lean library has no `sorry`/axiom frontier; Chapter II sheaf declarations are already thin, verified wrappers around Mathlib.
