## Progress

Read-only audit complete. The intended chain is:

```lean
let ρ := pic0SemilinearGalActionOfRepresentableBy C d.rep
letI : GrpObj d.J := d.grpObj
have hfin : Scheme.FiniteInAffine d.J.left := ...
exact Scheme.orbitsInAffineOpen_of_finiteInAffine ρ hfin
```

Key APIs:

- `Pic0GaloisAction.lean:374`: constructs the canonical semilinear action.
- `PicRepDatum.lean:108`: recovers `GrpObj` from the pinned representation.
- `FiniteInAffine.lean:64`: converts `FiniteInAffine` into `OrbitsInAffineOpen`.
- `GroupAffineOpen.lean:160`: proves `FiniteInAffine`, but only with `[IsAlgClosed L] [IrreducibleSpace d.J.left]`.

## Issues

The finite Galois stage is generally not algebraically closed, and the pinned carrier has no `IrreducibleSpace`, identity-component, component-finiteness, projectivity, or quasi-projectivity certificate. LFT, QC, and `GrpObj` do not currently synthesize `FiniteInAffine`.

The pullback-action instance in `GaloisQuotientNonVacuity.lean:124` is circular here: it applies after a scheme over the base field already exists.

## Why I Stopped

The precise first missing geometric output is:

```lean
Scheme.FiniteInAffine d.J.left
```

No existing theorem in the AJCR import graph derives it for this carrier.

## Next

Formalize either finite-type group-scheme quasi-projectivity/`FiniteInAffine`, or the roadmap’s arbitrary-field identity-component, finite-component assembly, and descent argument. The sibling project’s `QuasiProjectiveFiniteInAffine.lean:484` can consume an `IsHQuasiProjective` witness, but no such witness is landed for the pinned Pic0 carrier.
