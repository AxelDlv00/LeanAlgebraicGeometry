The next declaration should be:

```lean
noncomputable def Pic0FiniteStageGluePackage.gluedMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    P.glueData.glued ⟶ Spec (.of P.N.1)
```

Put it in a new `Picard/Pic0FiniteStageGluedOver.lean`, importing [Pic0FiniteStageGluePackage.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:98).

Build it with `Multicoequalizer.desc`. The chart maps are:

```lean
Spec.map (CommRingCat.ofHom
  (algebraMap P.N.1
    (Pic0FiniteStageChartBaseChangeRing
      C P.L P.n P.m P.relation P.M P.N U)))
```

On each overlap, unfold through `glueData`/`pic0FiniteStageAffineRingGlueData`, rewrite `Spec.map_comp` and `CommRingCat.ofHom_comp`, then use `ext x <;> simp`; both composites are the `P.N.1`-algebra structure map into the overlap ring. The exact working template is [gluedQuotientMap](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean:1255).

Land the same verified unit with its immediate consumers:

```lean
@[reassoc] theorem glueData_ι_gluedMap (P) (U) :
    P.glueData.ι U ≫ P.gluedMap = P.chartMap U :=
  Multicoequalizer.π_desc _ _ _ _ _

noncomputable def gluedOver (P) : Over (Spec (.of P.N.1)) :=
  Over.mk P.gluedMap
```

This is the first non-wrapper object-descent edge: current HEAD only produces a bare `Scheme.GlueData`, so the finite-stage scheme cannot yet be base-changed as an `Over` object.

The immediate next algebraic helper is:

```lean
k ⊗[P.N.1]
    (P.N.1 ⊗[P.M.1]
      Pic0FiniteStageModelRing C P.L P.n P.m P.relation P.M j)
  ≃ₐ[k] Pic0FiniteStageRing C j
```

defined as `cancelBaseChange ...` followed by [pic0FiniteStageModelBaseChangeEquiv](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageTripleModelComparison.lean:45); its naturality follows from `cancelBaseChange_naturality`. Those local comparisons feed the later glued base-change isomorphism.

Ledger HEAD is `b1ea7c12e9`; `03045d6eab` is its integrated payload parent. The hgraph nodes for `glueData` and `exists_pic0FiniteStageGluePackage` are `lean_ok`. No files, roadmap, inbox, or git state were changed.
