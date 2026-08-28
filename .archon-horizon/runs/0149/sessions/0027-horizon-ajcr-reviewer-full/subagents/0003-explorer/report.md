Read-only audit sent to `/root`.

Bottom line: AJCR’s usable interface is the underlying Type-valued `pic0TypeFunctor` representation plus `LocallyOfFiniteType` and `QuasiCompact` certificates. That packages into `JacobianData` via the already verified `PicRepDatum.toJacobianData`; it does not close the AJC Jacobian headline’s smoothness/properness/Albanese/base-change obligations.

The live sibling AJC has no on-disk `JacobianData.lean` or `Challenge.lean`; its actual headline remains [`Jacobian.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean). Keep any AJCR consumer downstream of `Challenge.lean`: importing `JacobianData` into it would form a dependency cycle.
