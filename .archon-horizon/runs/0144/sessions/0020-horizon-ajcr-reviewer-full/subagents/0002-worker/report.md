Completed and reported to root.

Committed `cb14d34` with the root-imported conditional bridge plus `PicRepDatum.toJacobianData_grpObj`, exposing the preserved group structure after packaging into `JacobianData`.

Checks passed:
- LSP diagnostics: clean
- `lake env lean AlgebraicJacobian/Picard/JacobianDataFromPicRepDatum.lean`
- Axiom probe: only `propext`, `Classical.choice`, `Quot.sound`

The unconditional Challenge headline remains blocked by the still-sorried `Jacobian` definition and missing unconditional `PicRepDatum k k C` plus quasi-compactness producer.
