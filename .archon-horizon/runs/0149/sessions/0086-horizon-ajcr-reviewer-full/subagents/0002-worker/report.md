No commit made.

Found a valid small bridge in the shared untracked `Pic0SepClosedJacobianData.lean`:

```lean
@[simp] theorem jacobianDataSepClosed_homEquiv ... :
  (jacobianDataSepClosed C).homEquiv =
    (pic0_sepClosed_representableBy (C := C)).2.homEquiv := rfl
```

It is sep-closed only, inherits only standard axioms, and `lake build AlgebraicJacobian.Picard.Pic0SepClosedJacobianData` passed. I reverted the prototype because the entire target module is absent from `HEAD` and currently shared/untracked, so committing it would capture unrelated work.

The arbitrary-field blocker remains the finite-stage Galois descent path, specifically its required `OrbitsInAffineOpen` input.
