Audit complete; no files changed.

- `rankOneAbelIso` is landed at `Picard/Pic0RankOneAbelInverse.lean:181`, kernel-clean.
- `pic0_sepClosed_representableBy`, `jacobianDataSepClosed`, and `PicRepDatum.toJacobianData` are also kernel-clean.
- No `pic0_representableBy` declaration exists. The finite-Galois conditional producer requires `[OrbitsInAffineOpen]`.
- `Challenge.lean` remains sorry-backed: Jacobian object, group, geometry, Abel map, universal property, and base-change coherence all depend on `sorryAx`.
- The datum bridge cannot simply be imported into `Challenge.lean`: `JacobianData -> Pic0Functor -> ... -> ChiCurve -> Challenge` forms an import cycle.

Minimal eventual wiring: split the shared Curve/genus/base-change prerequisites into an acyclic core, retarget `ChiCurve` and its Picard dependencies to it, then put the actual Jacobian headline in a late module consuming the final datum. Even then, only the group and pointed Abel law follow immediately; geometry, Albanese universal property, functor, and base-change require separate completed inputs.
