Added the finite-family theorem `exists_finSubext_relPic_tensorStage_finite` to `AlgebraicJacobian/Picard/RelPicTensorStageFiniteStage.lean`.

It chooses one common finite subextension using `DatG0.directed_finSubext`, transports each per-index class along the tensor inclusion, and proves compatibility via `relPicAlgMap_comp`. Narrow `lake env lean` verification passes; no `sorry`, `admit`, or new axioms.
