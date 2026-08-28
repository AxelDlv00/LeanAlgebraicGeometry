Audit complete, source-only.

The cone is honest through `canonicalRankOneAbelIso`, separably closed `pic0_sepClosed_representableBy`, and `jacobianDataSepClosed`, with the expected kernel-clean axiom set from prior root checks.

`finiteStageBaseChangeIso` is currently unrooted and only a raw scheme isomorphism. The remaining hard gates are:

1. Produce the finite-stage `RepresentableBy` datum.
2. Enlarge to a finite Galois stage.
3. Prove orbit-in-affine-open or projectivity there.
4. Define arbitrary-field `pic0_representableBy`.
5. Transfer finite-type/quasi-compact geometry into `PicRepDatum`/`JacobianData`.
6. Refactor the confirmed `JacobianData -> ... -> ChiCurve -> Challenge` import cycle before implementing the Challenge headline.

The sibling project additionally retains independent FGA representability, smooth-dimension, universal-closedness, and Albanese obligations. No files were changed and no build result was claimed.
