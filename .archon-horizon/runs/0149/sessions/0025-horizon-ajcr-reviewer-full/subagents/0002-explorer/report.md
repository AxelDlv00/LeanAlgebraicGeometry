## Critical Path

- `canonicalRankOneAbelIso` is complete and root-reachable at [Pic0RankOneCanonicalEvaluation.lean:259](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean:259).
- It already feeds the honest separably closed endpoint `pic0_sepClosed_representableBy` at [Pic0SepClosedRepresentable.lean:426](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:426), then `jacobianDataSepClosed` at [Pic0SepClosedJacobianData.lean:146](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:146).
- The commits `625eb6c7d9..8999773f93` add genuine finite-stage algebra, cover, class, datum, atlas, and colimit substrate. They do not produce an arbitrary-field representer.

The smallest useful next atomic theorem is finite-stage descent of algebra maps between already-descended finitely presented algebra models, preferably for a finite family:

```lean
Given L ⊆ K, fp L-algebras A₀, B₀, and
  φ : K ⊗[L] A₀ →ₐ[K] K ⊗[L] B₀,
find M ⊇ L and φM over M whose K-base change is φ.
```

The finite-family form must synchronize inverse and cocycle equalities. The existing tensor preimage/equality lemmas at [TensorFiniteSubextension.lean:74](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/TensorFiniteSubextension.lean:74) and [line 173](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/TensorFiniteSubextension.lean:173) are the correct substrate.

The next milestone theorem should then produce a finite-stage Picard representative:

```lean
∃ L : FinSubext k Ks, ∃ J_L,
  (pic0TypeFunctor ((baseChange k L.1).obj C)).RepresentableBy J_L ∧
  Nonempty ((baseChange L.1 Ks).obj J_L ≅ J_s)
```

with locally-finite-presentation and quasi-compactness certificates. Here `J_s` is the exact separably closed representer. [Pic0FiniteStageAtlas.lean:93](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageAtlas.lean:93) currently records chart rings and overlap pieces, but no descended restriction maps, transition maps, or cocycles. Object descent alone is insufficient: the finite-stage `RepresentableBy` equivalence must also be produced.

## Orbit Gate

`GroupAffineOpen` does not close the finite-level orbit condition. Its theorem at [GroupAffineOpen.lean:162](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:162) assumes `[IsAlgClosed L]`, unavailable at a general finite Galois stage.

The existing usable chain is:

```text
J.hom.IsProjective
→ Scheme.finiteInAffine_of_isProjective
→ orbitsInAffineOpen_of_finiteInAffine
→ pic0RepresentableBy_finiteGaloisDescent
```

The links are present at [QuasiProjectiveFiniteInAffine.lean:64](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/QuasiProjectiveFiniteInAffine.lean:64), [FiniteInAffine.lean:66](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/FiniteInAffine.lean:66), and [Pic0FiniteGaloisRepresentable.lean:35](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisRepresentable.lean:35). Projectivity is not yet produced. A genuine alternative is an arbitrary-field theorem that finite subsets of a geometrically irreducible, locally finite type group scheme lie in an affine open.

## Headline Assembly

Once arbitrary-field `rep`, `LocallyOfFiniteType`, and `QuasiCompact` exist, the shortest consumer is `JacobianData.ofRepresentableBy` at [JacobianDataCharts.lean:71](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataCharts.lean:71). Equivalently, construct `PicRepDatum` and call `toJacobianData` at [JacobianDataFromPicRepDatum.lean:83](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataFromPicRepDatum.lean:83). Raw representability alone is insufficient.

Two misleading shortcuts must be rejected:

- `pic0PreservesFilteredBaseColimit_of_representableBy` assumes the representer, so using it to claim the representer is circular.
- Re-exporting `jacobianDataSepClosed` as the arbitrary-field headline merely shifts the hypothesis to `[IsSepClosed k]`.

Finally, [Challenge.lean:96](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:96) cannot simply import the completed rank-one producer: that cone uses `Challenge.genus` transitively. Replacing its placeholders requires splitting foundational definitions such as `genus`/base change into a pre-headline module, or an equivalent import-DAG refactor. No files were edited.
