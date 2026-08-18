**Verdict**

The finite-stage glue does not currently contain enough geometry to prove either `P.gluedMap.IsProjective` or `FiniteInAffine`. Commit `5ee5a7f` is genuinely conditional.

**Exact Carrier**

- [`Pic0FiniteStageGluePackage`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:39) contains finite-presentation ring models, descended restriction/transition maps, and local open-immersion certificates. It has no properness or global immersion field.
- The scheme is exactly `P.glueData.glued`; [`P.gluedMap`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:39) is a `Multicoequalizer.desc` to `Spec (.of P.N.1)`, and `P.gluedOver = Over.mk P.gluedMap`.
- Charts are indexed by the finite subtype in [`Pic0FiniteStageAffineIntersections.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageAffineIntersections.lean:33). Their rings are
  `P.N.1 ⊗[P.M.1] Pic0FiniteStageChartModelRing ... U`.
- The exact chart equation is [`P.glueData.ι U ≫ P.gluedMap = Spec.map (algebraMap P.N.1 A_U)`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageChartBaseChange.lean:39).
- Every occurrence of `[IsProper C.hom]` concerns the input curve, not `P.gluedMap`.

**What Can Be Added Without New Mathematics**

Two carrier-specific lemmas should be routine:

1. `LocallyOfFiniteType P.gluedMap`: finite-presentation chart models survive both scalar extensions. Apply `IsZariskiLocalAtSource.of_openCover` and rewrite using `glueData_ι_gluedMap`. The matching proof pattern is [`locallyOfFiniteType_gluedHom`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataCharts.lean:154).

2. `QuasiCompact P.gluedMap`: the chart type is finite, every chart is an affine `Spec`, and `P.glueData.openCover.compactSpace` makes the glued carrier compact. The matching pattern is [`quasiCompact_gluedHom`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataCharts.lean:164).

Given the `rep` already passed to the orbit theorem, `GrpObj.ofRepresentableBy` supplies `GrpObj P.gluedOver`; then [`isSeparated_of_grpObj`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/AbelianVariety/GroupSeparated.lean:108) gives separatedness. Thus QC + LFT + separatedness are obtainable. Properness still needs a new `UniversallyClosed` proof.

**Minimal P7 Proof Design**

For `FiniteInAffine`, projectivity is stronger than necessary. Once one has any immersion
```lean
i : P.glueData.glued ⟶ ℙ(n; Spec (.of P.N.1))
```
apply [`finiteInAffine_of_isImmersion`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/QuasiProjectiveFiniteInAffine.lean:44) to `i` and `finiteInAffine_projectiveSpace`, then feed the result directly to `orbitsInAffineOpen_of_finiteInAffine`. No closedness, properness, or factorization equation is needed for this goal.

For `P.gluedMap.IsProjective`, additionally provide `IsProper P.gluedMap` and
`i ≫ (ℙ(n; Spec (.of P.N.1)) ↘ _) = P.gluedMap`; then use [`IsProjective.of_isProper_of_immersion`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Projective/ProjectiveMorphism.lean:99).

The unavoidable missing theorem is therefore a global projective-space immersion/quasi-projectivity theorem for this exact Pic0 carrier. Projectivity additionally needs universal closedness/properness.

**Other Routes**

- The closest group result, [`finiteInAffine_of_isAlgClosed_of_irreducible`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:162), requires an algebraically closed base and irreducible carrier. Neither is available over finite Galois `P.N.1`. A theorem that finite-type group schemes over arbitrary fields are quasi-projective/`FiniteInAffine` is likely the shortest conceptual P7 bridge.
- [`Pic0FiniteStageGluingBaseChange.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean:37) only compares the pullback with the gluing of pulled-back charts. There is no assembled global isomorphism to the exact separably closed Pic0 representer, which itself currently has QC/LFP/quasi-separatedness but no projectivity certificate.
- AJC has reusable definitions and lemmas in [`ProjectiveMorphismBasic.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/ProjectiveMorphismBasic.lean:42), [`QuasiProjectiveFiniteInAffine.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuasiProjectiveFiniteInAffine.lean:477), and its Plücker work. However, AJC explicitly records that it has no Pic0 H-quasi-projectivity producer. The two projects are separate Lake packages with the same library name, so this infrastructure must be ported rather than directly imported.
- AJCR’s divisor-to-Grassmannian-pair embedding does not solve the target problem: the pair lacks Plücker/Segre projective-space infrastructure in AJCR, and the Abel map to Pic0 is surjective rather than an immersion.

No files, protected run-0149 artifacts, or ledger state were changed; no build was needed for this read-only trace.
