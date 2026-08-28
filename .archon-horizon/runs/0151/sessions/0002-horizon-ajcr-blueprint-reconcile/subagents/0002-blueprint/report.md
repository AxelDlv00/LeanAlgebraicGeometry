## Findings

- `thm:rankOneAbel_isOpenImmersion` is stale. [DivisorScheme.tex:1521](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/DivisorScheme.tex:1521) says `\notready`, but `AlgebraicGeometry.rankOneAbel_isOpenImmersion` is checked and root-reachable at [Pic0SepClosedRepresentable.lean:205](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:205). Add the Lean label and `\leanok`, while making its explicit openness hypothesis visible or binding the concrete application jointly.

- `def:pic0TranslatedRankOneOpen`, `thm:pic0TranslatedRankOneOpen_representable`, and `thm:rankOne_translate_cover_sepClosed` are stale API descriptions, not genuinely absent mathematics. They correspond respectively to `picRankOneTranslatedChart`, `picRankOneTranslatedChart_isOpenImmersion`, and `exists_picRankOneTranslatedChart_fieldFactorization`/`picRankOneTranslatedChart_pointwiseCoverage`. Rephrase them in the actual chart/index language, add those labels, and mark them checked. Do not claim the present `U_M` subfunctor declaration is literally a Lean definition unless it is retained as a planned wrapper.

- `def:pic0_sepClosed_representableBy` has the correct Lean label and statement. Its `\leanok` is nevertheless dependency-inconsistent while the three implemented preceding nodes remain `\notready`. The same implemented cone also contains LFT, QC, LFP, `picRepDatumSepClosed`, and `jacobianDataSepClosed`; these deserve small nodes rather than the next broad package.

- `def:pic0SepClosedDescentInput` and `thm:pic0SepClosedDescentInput_exists` are truthfully `\notready` but too broad. Current Lean packages only representation + LFT + QC into `PicRepDatum`/`JacobianData`; it does not package properness and geometric irreducibility here. Split the checked sep-closed wrappers from planned proper/projective/geometrically irreducible certificates. The existing proof also uses Abel surjectivity, separatedness, and proper-image arguments absent from its `\uses`.

- `thm:pic0DescentCompatibility` remains a planned contract. Its proof is not complete: preservation of effective descent and filtered compatibility through quotienting and etale sheafification is asserted rather than proved. The checked finite-Galois fixed-point results (`pic0GaloisInvariantEquiv` and the equivariant-over comparison) should be separate `\leanok` nodes; they do not establish the broad theorem.

- `thm:pic0FiniteGaloisStage` remains planned and currently conflates four distinct obligations: finite-stage spreading/gluing, comparison with the sep-closed representer and universal class, semilinear action, and orbit-affineness. The finite-stage package is partly implemented, but the universal comparison is not certified at the critical root and orbit-affineness is only available conditionally from projectivity.

- `lem:finiteGalois_stableAffineCover` has no honest current Lean mapping. The sibling/Rebuild quotient engine proves a stronger norm/basic-open refinement from orbit-affineness without separatedness. Either retain the present separated custom lemma as `\notready`, or rewrite it to the stronger checked theorem before binding `hasStableAffineCover_of_orbitsInAffineOpen`.

- `thm:finiteGalois_schemeDescent` has a proof defect: its proof invokes separatedness to make intersections affine, but the statement does not assume separatedness. The checked quotient engine avoids that assumption via invariant basic opens and gluing. Rewrite the proof and bind `StableAffineOpen.isGaloisQuotient_glued`/the quotient-existence declarations; do not mark the present proof complete.

- `thm:representableBy_of_finiteGalois_baseChange` is more general than current Lean. `pic0RepresentableBy_finiteGaloisDescent` is checked only for `Pic^0`, given an explicit representer over `L` and an `OrbitsInAffineOpen` instance. Split off that specialized conditional theorem as `\leanok`; leave the generic sheaf theorem planned.

- `def:pic0_representableBy` and `def:jacobianData` are correctly `\notready`. Neither may be relabelled with the conditional declarations. The checked endpoint is precisely:
  `rep over L + orbit-affine -> pic0RepresentableBy_finiteGaloisDescent -> picRepDatum_finiteGaloisDescent -> jacobianData_finiteGaloisDescent`,
  with explicit LFT and QC inputs. The projective finite-stage variants are also conditional.

- The immediate Phase-8 interface nodes `def:jacobian_data`, `def:jacobian_data_grp`, `lem:jacobian_data_homEquiv`, and `def:jacobian_data_unique` truthfully match the checked `JacobianData` structure and accessors. They are parametric consumers of `d : JacobianData C`, not evidence that the arbitrary-field producer exists. The same caveat applies to separatedness, translation, base-change, and Abel-source geometry consumers: mark their conditional generic implementations independently, never as consequences of the missing concrete `def:jacobianData`.

## Recommended Cone

1. Checked rank-one Abel open immersion.
2. Checked translated charts and their open-immersion theorem.
3. Checked field-factorization and pointwise coverage.
4. Checked sep-closed representer, LFT/QC/LFP, `PicRepDatum`, and `JacobianData`.
5. Planned finite-stage spread package.
6. Planned universal representer/base-change comparison.
7. Checked generic semilinear action and quotient engine.
8. Planned projectivity/orbit-affineness for the actual finite-stage carrier.
9. Checked conditional Pic0 representability, LFT/QC descent, `PicRepDatum`, and `JacobianData`.
10. Planned unconditional `pic0_representableBy` and `jacobianData`.
11. Checked generic Phase-8 consumers.

The `FaceReflection` dependent-elaboration timeout belongs in an hgraph comment/roadmap entry as implementation risk. It must not appear in mathematical prose. Separately, universal Picard-equivalence descent and orbit-affineness/projectivity are genuine missing mathematical inputs.

All these nodes are currently tagged `CUSTOM`. The classical quotient, projectivity-of-proper-group-scheme, and ample-complement arguments need real source anchors after the cited material is retrieved and read; no anchor should be invented from memory. No files were changed.
