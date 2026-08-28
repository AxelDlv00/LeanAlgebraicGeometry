Current state:

- `Analytic.lean` has only set-level finiteness theorems at lines 56–66 and 77–89; subgroup cardinality wrappers exist at 344–368.
- `Uniformization.lean` already provides the typeclass-level theorem `zsmulTorsion_finite_of_uniformization` at lines 179–186.

The safest small additive API is a carrier wrapper, avoiding brittle `Set.Finite`-to-subtype-instance conversion:

```lean
theorem productTorus_torsionSubgroup_carrier_finite
    {d : Type*} [Finite d] {n : ℕ} (hn : 0 < n) :
    ((productTorus_torsionSubgroup d n : AddSubgroup (ProductTorus d)) :
      Set (ProductTorus d)).Finite := by
  simpa [productTorus_torsionSubgroup] using
    (productTorus_torsion_finite (d := d) hn)
```

Integer analogue:

```lean
theorem productTorus_zsmul_torsionSubgroup_carrier_finite
    {d : Type*} [Finite d] {n : ℤ} (hn : n ≠ 0) :
    ((productTorus_zsmul_torsionSubgroup d n : AddSubgroup (ProductTorus d)) :
      Set (ProductTorus d)).Finite := by
  simpa [productTorus_zsmul_torsionSubgroup] using
    (productTorus_zsmul_torsion_finite (d := d) hn)
```

These require only `[Finite d]`; the existing cardinality wrappers require `[Fintype d]`.
