The required Mathlib API exists and compiles:

- `descendsAlong_isOpenImmersion_surjective_inf_flat_inf_quasicompact'`
- `MorphismProperty.of_isPullback_of_descendsAlong`
- `isPullback_SpecMap_of_isPushout`
- `flat_and_surjective_SpecMap_iff`
- `Algebra.IsPushout.tensorProduct_tensorProduct`

Imports:

```lean
import Mathlib.AlgebraicGeometry.Morphisms.FlatDescent
import Mathlib.AlgebraicGeometry.Pullbacks
```

No finite-presentation, finite-extension, or separability hypothesis is needed. Any field extension supplies the faithfully flat cover. Algebra equivalences and reversed tensor orientation are manageable via `IsPushout.of_iso`, `AlgEquiv.toCommRingCatIso`, morphism-property iso cancellation, and `Algebra.TensorProduct.comm`.

The smallest honest next unit is the generic `isOpenImmersion_of_fpqc_pushout` helper reported to the parent, followed by the compiled field-extension wrapper. The only remaining issue is project-specific commuting-square glue around its chosen algebra equivalences, not a missing descent theorem. No files were changed.
