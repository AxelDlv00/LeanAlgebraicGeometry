Dependency table sent to parent. The first missing proposition is exactly:

```lean
PicRankOneOpen.IsOpen (C := C) (divRepAffP1Map C)
```

The canonical Abel isomorphism supplies the evaluator, but not the arbitrary-family pullback data required by the existing openness constructor. Downstream gaps are the translated atlas/local-surjectivity upgrade, finite-stage spreading, non-affine Galois representability descent, quasi-compactness, and the final `Challenge.lean` refactor.
