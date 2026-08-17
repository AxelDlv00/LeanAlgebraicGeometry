## Progress

Read-only audit complete. The next theorem should use the fixed index association

```lean
abbrev Pic0FiniteStageTripleTransitionIndex (C) :=
  Pic0FiniteStageChartIndex C ×
    (Pic0FiniteStageChartIndex C × Pic0FiniteStageChartIndex C)
```

For `p = (U, (V, W))`, use:

- source model: `TripleModel ... V W U`
- target model: `TripleModel ... U V W`
- exact map: `pic0FiniteStageTripleTransition C U V W`
- source exact comparison: `Qe V W U`
- target exact comparison: `Qe U V W`

Define the transported exact map by

```lean
def pic0FiniteStageTripleTransitionTransported ... (p) :=
  (Qe p.1 p.2.1 p.2.2).symm.toAlgHom.comp
    ((pic0FiniteStageTripleTransition C p.1 p.2.1 p.2.2).comp
      (Qe p.2.1 p.2.2 p.1).toAlgHom)
```

Then the direct finite descent theorem is:

```lean
theorem exists_finSubext_pic0FiniteStageTripleTransition_models_of_equiv
    ...
    (Qe : ∀ U V W,
      k ⊗[M.1] Pic0FiniteStageTripleModelRing C L n m relation M mapM U V W ≃ₐ[k]
        Pic0FiniteStageTripleRing C U V W) :
    ∃ (N : DatG0.FinSubext M.1 k)
      (thetaN : ∀ p : Pic0FiniteStageTripleTransitionIndex C,
        N.1 ⊗[M.1] Pic0FiniteStageTripleModelRing C L n m relation M mapM
            p.2.1 p.2.2 p.1 →ₐ[N.1]
          N.1 ⊗[M.1] Pic0FiniteStageTripleModelRing C L n m relation M mapM
            p.1 p.2.1 p.2.2),
      ∀ p,
        (Algebra.TensorProduct.map N.1.val
            (AlgHom.id M.1
              (Pic0FiniteStageTripleModelRing C L n m relation M mapM
                p.1 p.2.1 p.2.2))).comp
            ((thetaN p).restrictScalars M.1) =
          ((pic0FiniteStageTripleTransitionTransported ... Qe p).restrictScalars M.1).comp
            (Algebra.TensorProduct.map N.1.val
              (AlgHom.id M.1
                (Pic0FiniteStageTripleModelRing C L n m relation M mapM
                  p.2.1 p.2.2 p.1)))
```

The proof is one application of
`DatG0.exists_finSubext_tensorProduct_algHom_finite_of_models`, with:

```lean
A p := TripleModel ... p.2.1 p.2.2 p.1
B p := TripleModel ... p.1 p.2.1 p.2.2
A' p := TripleRing C p.2.1 p.2.2 p.1
B' p := TripleRing C p.1 p.2.1 p.2.2
eA p := Qe p.2.1 p.2.2 p.1
eB p := Qe p.1 p.2.1 p.2.2
phi p := pic0FiniteStageTripleTransition C p.1 p.2.1 p.2.2
```

The finite-type obligation is discharged directly by
`finiteType_pic0FiniteStageTripleModelRing`; the product index has a `Finite`
instance from the chart index.

For subsequent equation reflection, retain scalar-extended old models at `N`:

```lean
def pairN (q) :=
  AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := N.1) (mapM q)

def thetaFaceLeftN U V W :=
  AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := N.1) (tripleFaceLeftM U V W)
```

and similarly `thetaFaceRightN`. The desired reflected face equation is

```lean
(thetaN (U, (V, W))).comp (thetaFaceRightN V W U) =
  (thetaFaceLeftN U V W).comp (pairN (Sum.inr (U, V)))
```

The cocycle is

```lean
(thetaN (U, (V, W))).comp
  ((thetaN (V, (W, U))).comp (thetaN (W, (U, V)))) =
  AlgHom.id N.1 _
```

Both should be proved with
`DatG0.tensorProduct_algHom_eq_of_map_comp_eq N`, not by trying to force
the more specialized composition helper. Postcompose with the `N -> k` tensor
map, then apply the target `Qe` injectivity:

- use the descended `hthetaN` square;
- use `Qe` left/right face formulas;
- use `pic0FiniteStageModelBaseChangeEquiv_naturality` for
  `mapM (Sum.inr (U,V))`;
- close the face equation with
  `pic0FiniteStageTripleTransition_fac`;
- close the cocycle with
  `pic0FiniteStageTripleTransition_cocycle`.

## Issues

The comparison module needs these APIs in addition to `Qe`:

```lean
tripleFaceLeftM :
  OverlapModel ... U V →ₐ[M.1] TripleModel ... U V W

tripleFaceRightM :
  OverlapModel ... U W →ₐ[M.1] TripleModel ... U V W
```

and the two formulas

```lean
Qe U V W ∘ ext_Mk (tripleFaceLeftM U V W) =
  exactLeft U V W ∘ E (Sum.inr (U,V))

Qe U V W ∘ ext_Mk (tripleFaceRightM U V W) =
  exactRight U V W ∘ E (Sum.inr (U,W))
```

A small generic field-tower naturality lemma is also missing:

```lean
map_LK (id B) ∘ scalarExtensionMapOfAlgHom (R:=F) (K:=L) f =
  scalarExtensionMapOfAlgHom (R:=F) (K:=K) f ∘ map_LK (id A)
```

where `F -> L -> K` is a scalar tower. Prove it by tensor induction; it supplies
the base-change compatibility for `pairN` and both face maps.

If later code insists that triples at `N` be literal tensor pushouts constructed
from `pairN`, transport `thetaN` through
`pic0FiniteStageTripleModelBaseChange (K := N.1)`. That requires one additional
bridge identifying its `scalarExtensionMap` restriction legs with
`scalarExtensionMapOfAlgHom (mapM q)`.

A separate GlueData requirement is currently absent: pair inverse laws do not
imply `mapM (Sum.inr (U,U)) = id`. Prove this directly by reflecting
`pic0FiniteStageTransition_self` through the component comparison (or through
`DatG0.tensorProduct_algHom_eq_of_map_comp_eq`).
