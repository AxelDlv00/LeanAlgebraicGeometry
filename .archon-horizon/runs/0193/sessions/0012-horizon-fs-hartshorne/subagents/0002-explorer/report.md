Survey complete; no files were edited.

**Best bounded unit: degree-zero classes and a splitting**

Extend [Chapter4DegreeClass.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4DegreeClass.lean:39) with:

```lean
noncomputable def degreeZeroDivisorClasses (hzero) :
    AddSubgroup (DivisorClassGroup (k := k) (X := X)) :=
  (degreeClass hzero).ker

noncomputable def pointDivisorClassHom
    (x : {x : X.left // x ≠ genericPoint X.left}) :
    ℤ →+ DivisorClassGroup (k := k) (X := X) :=
  divisorClass.comp (Finsupp.singleAddHom x)

theorem degreeClass_comp_pointDivisorClassHom (hzero) (x) :
    (degreeClass hzero).comp (pointDivisorClassHom x) =
      AddMonoidHom.id ℤ
```

The last proof should be `ext n; simp [pointDivisorClassHom]`, using `degreeClass_divisorClass` at line 61 and `CurveDivisor.degree_single` in [Chapter4Curves.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4Curves.lean:213). Add membership and surjectivity corollaries. This is the best self-contained choice: approximately 20–35 lines, no new geometric substrate, and it gives the degree-zero part plus a split degree map after choosing a non-generic point. It remains honestly conditional on `PrincipalDivisorsHaveDegreeZero`.

**Strongest source-facing unit: rational sections and effective representatives**

Add `HartshorneLib/Chapter4LinearSystems.lean`, importing [Chapter4EffectiveRepresentative.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4EffectiveRepresentative.lean:32):

```lean
def HasNonzeroRationalSection (D : CurveDivisor k X) : Prop :=
  ∃ g : X.left.functionFieldˣ, 0 ≤ principalDivisor g + D

theorem hasNonzeroRationalSection_iff_hasEffectiveRepresentative (D) :
    HasNonzeroRationalSection D ↔ HasEffectiveRepresentative D
```

Forward, take `E = principalDivisor g + D`; backward, extract `D - E = principalDivisor g` using `linearlyEquivalent_iff_exists` in [Chapter4DivisorClass.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4DivisorClass.lean:82) and use `g⁻¹`. Both directions close with `principalDivisor_inv` from [Chapter4PrincipalDivisors.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4PrincipalDivisors.lean:176) and additive algebra. Then restate the existing degree-nonnegative and degree-zero conclusions for nonzero rational sections. This is about 40–70 lines and is the cleanest bridge to Hartshorne IV.1.2’s `l(D) ≠ 0`.

**Chapter II unit: pullback preserves line bundles**

Extend [Chapter2LineBundles.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter2LineBundles.lean:27):

```lean
theorem IsLineBundle.pullback {X Y : Scheme} (f : Y ⟶ X) {M : X.Modules}
    (hM : IsLineBundle M) :
    IsLineBundle ((Scheme.Modules.pullback f).obj M)
```

There is a working chart chase to adapt almost verbatim in [LineBundlePullback.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/LineBundlePullback.lean:162). It uses `restrictFunctorIsoPullback`, `Modules.pullbackComp`, `pullbackCongr`, and `SheafOfModules.pullbackObjUnitToUnit`; add `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree`. Estimated 40–60 lines, with moderate elaboration risk but high Picard reuse.

The project currently has no code `sorry`, `admit`, or `axiom`. The graph has 342 ready nodes; the important high-unlock frontier includes affine morphism criteria, density-determines-morphisms, curve-local-ring incomparability, and exactness on affines. The divisor nodes are ready but currently unlock zero because the blueprint is frozen.

I would not attempt unconditional principal-divisor degree zero this session. The reusable proofs in AJCR’s `RiemannRoch/ChiLedger.lean` and `RiemannRoch/WeilDivisor.lean` depend on divisor sheaves, multiplication isomorphisms, Euler-characteristic dévissage, skyscraper cohomology, and finiteness results. That is a multi-file dependency cone, not a bounded proof unit.
