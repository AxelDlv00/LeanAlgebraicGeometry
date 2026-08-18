Read-only probe complete. No files or Horizon state changed.

- Rebuild has no unqualified `pic0_representableBy` today. The strongest real endpoint is `pic0_sepClosed_representableBy` at `Picard/Pic0SepClosedRepresentable.lean:426`, and it packages as `jacobianDataSepClosed` at `Picard/Pic0SepClosedJacobianData.lean:146`, under `[IsSepClosed k]`. Fresh axiom probes show both are clean: only `propext`, `Classical.choice`, `Quot.sound`.
- `JacobianData` is the correct integration interface: fields are representation, local finite type, and quasi-compactness at `Picard/JacobianData.lean:87`. The shortest general assembly is `JacobianData.ofRepresentableBy` (`JacobianDataCharts.lean:71`) or `ofPic0ClassSurjective` (`JacobianDataQcFromRep.lean:394`), but a bare representation alone is insufficient: it still needs LFT and QC.
- Once an arbitrary-field producer supplies `Σ J, (pic0TypeFunctor C).RepresentableBy J` plus LFT/QC, define a canonical `jacobianData C` using `ofRepresentableBy`. This legitimately discharges Rebuild `Challenge.lean`’s:
  - `Jacobian` and `instGrpObj` via `d.J` / `d.grpObj`;
  - Abel map and pointing law via `JacobianData.ofCurve` / `comp_ofCurve` (`JacobianDataAbel.lean:62`, `:85`);
  - contravariant functor map/laws via `pullbackHom`, `_id`, `_comp` (`Pic0PullbackGrp.lean:77`, `:105`, `:127`).
- It does not close Rebuild’s smooth-relative-dimension, properness, geometric irreducibility, Albanese universal property, or base-change compatibility. The first three still need an `AbelSourceData` plus reducedness/relative-dimension input (`AbelianVariety/JacobianAbelianVariety.lean:86`, `:100`, `:130`); the universal property has no general datum-level producer. Base-change isomorphism is available datum-level (`JacobianDataBaseChange.lean:227`), but Abel compatibility still needs `abelCrossBaseCechCore` (`JacobianDataBaseChangeAbelCore.lean:173`).

Import constraint: `Challenge.lean` must import only the datum-level closure needed for each replacement. It cannot import the full `JacobianData*` fan-out: several descendants reach `AlgebraicJacobian.Challenge` through cohomology/Riemann–Roch, creating the intended cycle. `JacobianData`, `JacobianDataAbel`, and `Pic0PullbackGrp` themselves do not import `Challenge`.

Sibling project facts:

- There is no sibling `AlgebraicJacobian/Challenge.lean`; its actual headline is `AlgebraicJacobian/Jacobian.lean:848`, rooted by `AlgebraicJacobian.lean:62`.
- Headline dependency chain:
  `Jacobian.lean` -> `Pic0Et.lean` -> `FGAPicRepresentability.lean`.
  The five true unresolved obligations are:
  `Scheme.fgaPicardRepresentability` (`FGAPicRepresentability.lean:955`),
  `Pic0Et.geometricallyReduced` (`Pic0Et.lean:170`),
  `Pic0Et.universallyClosed` (`:223`),
  `smoothOfRelativeDimension_genus_pic0Et` (`Jacobian.lean:548`), and
  `isAlbanese_pic0Et` (`:690`).
- Fresh `#print axioms` confirms each and `picardJacobianWitness` has exactly `[propext, sorryAx, Classical.choice, Quot.sound]`.
- The pointed counterparts at `Jacobian.lean:447` and `:640` are not headline routes. Do not use rational-point assumptions or `picSharp` to close the unconditional endpoint.
- The projects both declare the same Lake package/library name, `AlgebraicJacobian`; Rebuild results cannot be added as a normal dependency of the sibling without a package/module collision. Integration requires porting the minimal proved interface, not cross-importing the project.

The only endpoint presently closable without artificial assumptions is the separably closed Rebuild `jacobianDataSepClosed`; it is not the arbitrary-field challenge headline.
