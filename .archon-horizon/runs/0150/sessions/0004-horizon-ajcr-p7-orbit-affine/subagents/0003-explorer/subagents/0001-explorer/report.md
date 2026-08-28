Read-only investigation complete; no edits or full builds were run.

**Carrier And Charts**

- `P.glueData` is constructed by `pic0FiniteStageAffineRingGlueData` in [Pic0FiniteStageGluePackage.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:97).
- There is no separate project definition `P.glued`; the carrier is `P.glueData.glued`.
- `P.gluedMap : P.glueData.glued ⟶ Spec (.of P.N.1)` is the multicoequalizer descent of the chart structure maps, and `P.gluedOver := Over.mk P.gluedMap`, in [Pic0FiniteStageGluedOver.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:38).
- The finite chart index is the subtype of the chosen atlas, with a `Finite` instance, in [Pic0FiniteStageAffineIntersections.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageAffineIntersections.lean:33).
- Chart and overlap model rings are `Pic0FiniteStageModelRing ... (Sum.inl U)` and `... (Sum.inr (U,V))`, respectively, in [Pic0FiniteStageTripleOverlapRings.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageTripleOverlapRings.lean:336).
- Final chart rings are
  `P.N.1 ⊗[P.M.1] Pic0FiniteStageChartModelRing ... U`; overlaps are the analogous tensor products.
- Each `P.glueData.ι U` is an open immersion, hence an immersion. Its composite with the structure map is exactly the corresponding affine `Spec.map`, by [Pic0FiniteStageChartBaseChange.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageChartBaseChange.lean:37).

**Available Geometry**

No `Pic0FiniteStage*.lean` theorem currently proves `IsProper P.gluedMap`, `QuasiCompact P.gluedMap`, `LocallyOfFiniteType P.gluedMap`, or a global projective-space immersion. The existing `[IsProper C.hom]` assumptions concern the input curve.

Two useful facts are nevertheless directly derivable:

- `LocallyOfFiniteType P.gluedMap`: chart model rings have finite-presentation instances, preserved by both scalar extensions. Apply `IsZariskiLocalAtSource.of_openCover` and rewrite with `glueData_ι_gluedMap`. The exact pattern is [JacobianDataCharts.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataCharts.lean:151).
- `QuasiCompact P.gluedMap`: the chart index is finite and every chart is affine/compact, so `P.glueData.openCover.compactSpace` gives compactness of the glued carrier. The pattern is [JacobianDataCharts.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataCharts.lean:161).

Given the existing `rep`, `GrpObj.ofRepresentableBy` also puts a group-object structure on `P.gluedOver`, after which `isSeparated_of_grpObj` supplies `IsSeparated P.gluedMap`. Properness still lacks the genuinely new `UniversallyClosed` argument.

**Exact P7 Gap**

AJCR’s [finiteInAffine_of_isImmersion](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/QuasiProjectiveFiniteInAffine.lean:43) means p7 needs only an underlying-scheme immersion
```lean
P.glueData.glued ⟶ ℙ(n; Spec (.of P.N.1))
```
for finite `n`. It need not be closed or proper. H-quasi-projectivity is a convenient packaged certificate, not a required port.

To prove `P.gluedMap.IsProjective`, the immersion must additionally be closed; alternatively, [of_isProper_of_immersion](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Projective/ProjectiveMorphism.lean:97) reduces this to properness plus the immersion.

The closest direct group result, `finiteInAffine_of_isAlgClosed_of_irreducible`, requires an algebraically closed base and irreducible carrier, neither available at the finite Galois stage. A general finite-type-group-scheme quasi-projectivity/`FiniteInAffine` theorem is therefore the shortest conceptual bridge.

The base-change files only identify individual charts and overlaps and identify the global pullback with the gluing of pulled-back charts. They do not assemble an isomorphism to the exact Picard carrier; [Pic0CriticalPath.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:284) explicitly records this and orbit/projectivity as missing.

Commit `5ee5a7f349` adds only conditional consumers: `Pic0FiniteStageOrbitAffine` converts a supplied `hproj` to `FiniteInAffine`, and `Pic0FiniteStageStableAffineCover` consumes that result. It adds no projectivity producer.
