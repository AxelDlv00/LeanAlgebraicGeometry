Best next small theorem: `schemes-lemma-standard-open-affine` (Tag 01I3), blueprint [`ch01-schemes.tex`]( /home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part02_Schemes/blueprint/src/ch01-schemes.tex:962).

Exact wrapper:

```lean
theorem standardOpen_isAffine {X : Scheme.{u}} [IsAffine X]
    (f : Γ(X, ⊤)) : IsAffine (X.basicOpen f) := by
  infer_instance
```

Mathlib already provides this instance in `AlgebraicGeometry/AffineScheme.lean:610-611`:

```lean
instance [IsAffine X] (r : Γ(X, ⊤)) : IsAffine (X.basicOpen r)
```

A stronger generic variant is also immediate:

```lean
theorem standardOpen_isAffineOpen {X : Scheme.{u}}
    {U : X.Opens} (hU : IsAffineOpen U) (f : Γ(X, U)) :
    IsAffineOpen (X.basicOpen f) := by
  exact hU.basicOpen f
```

I sent these recommendations to the Part02 task. Note that [`AffineBasics.lean`]( /home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part02_Schemes/StacksPart02Lib/AffineBasics.lean:69) currently has concurrent uncommitted additions, so it should not be touched without coordination.
