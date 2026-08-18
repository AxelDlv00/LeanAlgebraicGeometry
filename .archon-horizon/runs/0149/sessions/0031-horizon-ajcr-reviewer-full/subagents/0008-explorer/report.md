## Audit Result

No concrete Scheme-stack theorem exists in Mathlib or the project for fpqc, fppf, étale, Zariski, finite faithfully flat, or finite Galois descent. A Lean synthesis probe confirmed failure for:

```lean
(Over.pullbackPseudofunctor (C := Scheme)).IsStack Scheme.fpqcTopology
```

### What Exists

- The abstract stack API is complete:
  - `Pseudofunctor.IsStack` requires essential surjectivity of `toDescentData`: [IsStack.lean:49](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Sites/Descent/IsStack.lean:49).
  - `isEquivalence_toDescentData` exposes the resulting equivalence for a covering family: [IsStack.lean:70](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Sites/Descent/IsStack.lean:70).
  - `IsStack.of_precoverage` reduces proving a stack to covers in a precoverage: [Precoverage.lean:408](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Sites/Descent/Precoverage.lean:408).

- The project’s pseudofunctor is correctly defined:
  [OverPullbackPseudofunctor.lean:114](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/OverPullbackPseudofunctor.lean:114).

- `pic0RepresentabilityDescentData` has exactly the right chosen-pullback descent-data type:
  [Pic0RepresentabilityDescentData.lean:397](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentabilityDescentData.lean:397), [line 412](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentabilityDescentData.lean:412).

- Mathlib converts that `DescentData'` to ordinary `DescentData`, and indeed gives an equivalence of categories:
  [DescentDataPrime.lean:263](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Sites/Descent/DescentDataPrime.lean:263), [line 322](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Sites/Descent/DescentDataPrime.lean:322).

- The field-extension map is an fpqc cover:
  [Pic0ChartFiniteExtension.lean:132](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartFiniteExtension.lean:132), [line 143](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartFiniteExtension.lean:143).

The descent-data file imports `DescentDataPrime`, but not `IsStack` or `Sites.Fpqc`; a consumer would need both imports explicitly.

If a Scheme-stack instance existed, the exact consumption route would be:

1. Convert `pic0RepresentabilityDescentData rep` using `DescentData'.descentData`.
2. Apply `isEquivalence_toDescentData` to the singleton fpqc cover.
3. Use `Functor.objPreimage` and `objObjPreimageIso` to obtain `J₀ : Over (Spec k)` and an isomorphism between its pullback and the local `J`.

That would descend only the scheme object. It would not by itself prove `(pic0TypeFunctor C).RepresentableBy J₀`.

### What Is Missing

- No `IsStack` or even concrete `IsPrestack` instance for the Scheme over-category pseudofunctor.
- `Scheme.fpqcTopology.Subcanonical` only says representable type-valued presheaves are sheaves: [Fpqc.lean:71](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Sites/Fpqc.lean:71). It is not effective descent of schemes.
- The flat-descent files descend morphism properties, not scheme objects.
- Picard zero is proved to be a Zariski and étale sheaf, not an fpqc sheaf: [Pic0SigmaSheaf.lean:90](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:90), [Pic0SigmaEtaleSheaf.lean:229](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SigmaEtaleSheaf.lean:229).
- A cocycle and a descended scheme do not descend the universal Picard natural equivalence. `RepresentableBy` requires natural bijections on every test object: [Yoneda.lean:284](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Yoneda.lean:284).

### Shortest Honest Route

Do not build the full Scheme fpqc stack. The finite-stage code already constructs the object:

- An inhabited finite-stage glue package: [Pic0FiniteStageGluePackage.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:39), [line 113](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:113).
- Its scheme over the finite field: [Pic0FiniteStageGluedOver.lean:38](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:38), [line 84](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:84).
- Chartwise and overlap base-change isomorphisms: [Pic0FiniteStageGluingBaseChange.lean:36](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean:36), [line 51](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean:51), [line 65](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean:65).

The shortest remaining route is:

1. Assemble the chartwise comparisons into a global isomorphism from the scalar extension of `P.gluedOver` to the separably closed representer. Mathlib already proves an open cover’s glued scheme is canonically isomorphic to the original scheme via `Cover.fromGlued`: [Gluing.lean:331](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Gluing.lean:331), [line 423](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Gluing.lean:423).

2. Descend the finite chart universal Picard classes/maps, not merely their rings and transition maps. This must produce finite-level transformations
   `yoneda.obj Xᵢ ⟶ pic0SigmaSheaf C_N`
   compatible on overlaps.

3. Prove those transformations are relatively representable open immersions and jointly Zariski-locally surjective.

4. Apply the existing endpoint directly:
   `pic0RepresentableByOfCharts`, [Pic0SigmaSheaf.lean:161](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:161).
   It invokes Mathlib’s local representability theorem [Representability.lean:191](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Sites/Representability.lean:191) and then `RepresentableBy.overSlice`.

This avoids both the absent Scheme-stack theorem and the unavailable fpqc sheaf theorem for Picard zero. The current finite-stage package contains only rings, maps, and gluing equations; it does not contain the finite model of the curve or the universal Picard transformations. `BasicOpenCocycleDatum.exists_finSubext_tensorStage` is relevant substrate but currently has no consumer tying it to the glued finite-stage scheme: [Pic0FiniteStageDatum.lean:31](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageDatum.lean:31).

Once a finite-Galois-level `rep` is available, the project can descend it further conditionally using `pic0RepresentableBy_finiteGaloisDescent`; it still requires `OrbitsInAffineOpen`: [Pic0FiniteGaloisRepresentable.lean:35](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisRepresentable.lean:35). It consumes a finite-level representation; it does not manufacture one from the separably closed representation.

No files were edited or committed.
