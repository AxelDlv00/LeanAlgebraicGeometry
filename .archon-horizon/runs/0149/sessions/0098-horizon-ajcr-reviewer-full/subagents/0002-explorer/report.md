Read-only audit complete. No files or Horizon state were changed.

**Verdict**

The separably closed cone is genuinely landed:

- `canonicalRankOneAbelIso` in [Pic0RankOneCanonicalEvaluation.lean:259](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean:259)
- `pic0_sepClosed_representableBy` in [Pic0SepClosedRepresentable.lean:443](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:443)
- `picRepDatumSepClosed` and `jacobianDataSepClosed` in [Pic0SepClosedJacobianData.lean:138](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:138)

The first genuinely missing theorem is finite-stage descent of the **universal Picard element and its Yoneda equivalence**:
```lean
(pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver
```
for an appropriately chosen/refined `Pic0FiniteStageGluePackage`. It must include the tower comparison between `(C_{P.N.1})_ks` and `C_ks`. It cannot be derived from the carrier isomorphism alone.

[Pic0FiniteStageGluedComparison.lean:284](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedComparison.lean:284) only proves
`finiteStageBaseChangeIso`, an object isomorphism after scalar extension.  
[Pic0RepresentableByTransport.lean:75](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentableByTransport.lean:75) transports a representation forward from the base field; it does not descend one.  
[Pic0RepresentabilityDescentData.lean:398](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentabilityDescentData.lean:398) packages the overlap cocycle but supplies no effective scheme or universal-class descent.

**Best Next Unit**

The highest-value non-tautological unit is a `Pic0FiniteStageUniversalPackage` extending the glue package with:

- finite-stage Picard classes on each finite affine chart;
- equality on the finite overlap family;
- a base-change equation identifying those classes with restrictions of
  `rep.homEquiv (𝟙 Jks)`;
- an existence theorem choosing the glue and universal data over one common finite subextension.

It should return a newly enlarged package, not claim the universal class descends to every preselected `P`.

The practical proof route is chartwise:

1. Descend the universal class on the finite atlas from [Pic0FiniteStageAtlas.lean:94](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageAtlas.lean:94).
2. Descend the finite overlap equalities simultaneously.
3. Reconstruct chart transformations into `pic0SigmaSheaf`.
4. Prove relative open-immersion and local-surjectivity properties.
5. Invoke Mathlib’s `Scheme.LocalRepresentability.representableBy`.

The missing lower-level API is descent of a `PicEtAff`/Picard class over a finitely presented chart algebra. [PicEtAffFiniteStage.lean:34](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicEtAffFiniteStage.lean:34) explicitly descends only the étale cover, not its descent class. `exists_finSubext_relPic_model` handles field-valued tests only.

No existing Mathlib theorem closes this. `LocalRepresentability` only performs Zariski gluing after chart transformations exist; `EffectiveEpi` descends morphisms but not schemes or Picard classes; the categorical stack API has no Scheme-valued stack instance; project `AlgebraDescent` is affine-algebra effectivity only.

`Pic0PreservesFilteredBaseColimit` at [PicRepColimitCompat.lean:136](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepColimitCompat.lean:136) is another unproved route. Its only producer, [Pic0RepresentableColimit.lean:28](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentableColimit.lean:28), assumes the desired arbitrary-field representer and is circular here.

**After Universal Descent**

[Pic0FiniteGaloisRepresentable.lean:35](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisRepresentable.lean:35) and [Pic0FiniteGaloisJacobianData.lean:78](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisJacobianData.lean:78) can finish representability and datum packaging once supplied:

- the finite-stage `RepresentableBy`;
- `OrbitsInAffineOpen`.

Orbit-affineness is a second independent mathematical block. [Pic0FiniteStageOrbitAffine.lean:56](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:56) requires an algebraically closed stage plus irreducibility/connectedness, or an explicit immersion/projectivity proof. No unconditional producer exists.

**Challenge Boundary**

The import cycle is:
`Pic0CriticalPath -> Picard.DivRepAffChallenge -> RiemannRoch.ChiCurve -> Challenge`.

Therefore `Challenge.lean` cannot import the current endpoint cone. A downstream bridge compiles but leaves `sorryAx` in the protected declarations. Cleaning them requires extracting at least the low-level `genus`/curve interface from `Challenge`, retargeting `ChiCurve`, then importing the implementation back into `Challenge`.

The 13 sorry-bearing Rebuild declarations are:

- `Jacobian`, `Jacobian.instGrpObj`
- `smoothOfRelativeDimension_genus`
- anonymous `IsProper`, anonymous `GeometricallyIrreducible`
- `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`
- `Jacobian.functor` with `map`, `map_id`, `map_comp`
- `baseChangeIso`, `baseChangeIso_id`, `baseChangeIso_comp`
- `baseChange_ofCurve`

Even an arbitrary-field `JacobianData` closes only the carrier/representation handoff. Properness, smooth relative dimension/genus, Abel-Albanese, functoriality, and base-change coherence remain separate leaves.

In sibling AJC, the direct open seam is `fgaPicardRepresentability` at [FGAPicRepresentability.lean:955](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean:955). `Jacobian.lean` retains four direct leaves: `smoothOfRelativeDimension_genus_pic0`, its `pic0Et` version, `isAlbanese_pic0`, and its `pic0Et` version. `picardJacobianWitness` has no local `sorry`, but inherits those plus FGA, geometric reducedness, and universal closedness.
