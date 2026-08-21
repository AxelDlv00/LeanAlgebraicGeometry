Read both binding PDFs, roadmap nodes, and post-0149 reports. Evidence map:

- Binding route: `Div^g represented -> DivRankOneOpen -> rankOneAbelIso -> PicRankOneOpen -> translated cover -> pic0_sepClosed_representableBy -> finite-Galois descent -> pic0_representableBy -> JacobianData`.
- Required endpoint declarations:
  - `pic0_representableBy : Sigma fun J : Scheme => (pic0Functor C).RepresentableBy J`
  - shared descent theorem `representableBy_of_finiteGalois_baseChange`
  - `jacobianData : JacobianData C`, immediately consuming the same pinned Pic^0 representation.
- Descent acceptance:
  - Package `Pic0SepClosedDescentInput` with representative, `RepresentableBy`, finite type, properness, group structure, geometric irreducibility, and universal element.
  - Descend universal Picard class/equivalence to a finite Galois extension; prove semilinear action and cocycle.
  - Produce Galois-stable affine cover, orbit-in-affine data, affine invariant quotients, overlap compatibility, gluing, and descended Yoneda equivalence.
  - Return the descended scheme and its `RepresentableBy` certificate; consume it immediately in `pic0_representableBy`.
  - Reuse/shared AJC descent infrastructure, not a duplicate stack.
- Jacobian acceptance:
  - Construct `PicRepDatum` from arbitrary-field `pic0_representableBy`.
  - Feed it through `PicRepDatum.toJacobianData` / `JacobianDataHandoff.lean`.
  - Final `jacobianData` must derive group object, identity component, universal element, base change, and coherence from that same representation.
  - Remaining independent geometry gates: finite type, properness, smoothness, dimension `g`, geometric irreducibility, Abel-Jacobi, Albanese universal property, field-base-change/cocycle coherence, and protected Challenge declarations.
  - Require root reachability, narrow/full builds, no project axioms/sorries, and `#print axioms` limited to `[propext, Classical.choice, Quot.sound]`.

Current roadmap state:

- `AJCR.review-plan.p7-galois-descent`: blocked; only finite-glue is done.
- p7 blockers: finite-stage universal Picard equivalence/`RepresentableBy`, global glued-scheme base change, arbitrary-field finite-Galois producer, and unconditional orbit-affine/projectivity.
- `AJCR.review-plan.p8-jacobian`: blocked; interfaces and geometry-consumers are done.
- p8 blockers: arbitrary-field Pic^0 producer/PicRepDatum, then independent Jacobian geometry/Abel/Albanese/functoriality/headline obligations. `AlgebraicJacobian/Challenge.lean` also has an import-cycle/API mismatch and existing sorry-backed geometry.

Newly landed after run 0149:

- `042292a818`: axiom-clean `finiteInAffine_sigma` in `AlgebraicJacobian/Descent/FiniteInAffine.lean`.
- `50453c8ea9`: conditional finite-stage `GrpObj`, `FiniteInAffine`, and orbit-affine producers in `Pic0FiniteStageOrbitAffine.lean`; stable-cover/descent consumers in `Pic0FiniteStageStableAffineCover.lean`.
- These remain conditional on algebraically closed/irreducible or projective/immersion hypotheses. The missing unconditional primitive is effectively `GroupScheme.finiteInAffine_of_finiteType` (Stacks 39.8.7); no lawful producer currently exists.
- Existing latest p7 packaging at `3914ddcd7d` (`FiniteGaloisQuotientGeometry.lean`, `Pic0FiniteGaloisJacobianData.lean`) is only conditional packaging; it does not produce arbitrary-field `pic0_representableBy`.
- Existing p8 handoff declarations are in `PicRepDatum.lean` and `JacobianDataHandoff.lean`, but have no genuine arbitrary-field input yet.

No source or metadata was edited.
