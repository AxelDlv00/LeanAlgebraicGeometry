Probe complete; no production files were edited.

Initial `ProbeSndTypes.lean` failed at:

- `r`: `failed to synthesize Semiring (A W)`
- induced algebra: `failed to synthesize CommSemiring (A W)`

A minimal viable local setup is the following, in this order:

```lean
letI : ∀ W, CommRing (A W) := fun W => by
  dsimp [A]
  infer_instance
letI : ∀ W Z, CommRing (B W Z) := fun W Z => by
  dsimp [B]
  infer_instance
letI : ∀ W, Algebra P.N.1 (A W) := fun W => by
  dsimp [A]
  infer_instance
letI : ∀ W Z, Algebra P.N.1 (B W Z) := fun W Z => by
  dsimp [B]
  infer_instance
```

With those four instances, followed by the existing `r`, `Algebra (A W) (B W Z)`, and `IsScalarTower` locals, the theorem elaborates successfully using the original implicit:

```lean
apply pullback.hom_ext
```

No explicit `(f := ...)` or `(g := ...)` arguments are needed. The temporary probe was cleaned up.
