`QuasiCompact` is available for the exact carrier after one small generic bridge; `FiniteInAffine` is not.

For
```lean
J := (pic0_sepClosed_representableBy (C := C)).1
rep := (pic0_sepClosed_representableBy (C := C)).2
```
use:

- [`representableBySigmaIso`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:63)
- [`isLocallySurjective_abelSigmaChartAffAdmissible`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0AdmissibleAbelEtaleSurjective.lean:72)
- [`quasiCompact_divRepAffAdmissibleScheme`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0AdmissibleDivisorQuasiProjective.lean:315)
- [`quasiCompact_of_surjective`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/CompactImageQc.lean:60)

Define
```lean
φ := abelSigmaChartAffAdmissible C ≫ (representableBySigmaIso rep).inv
f := Yoneda.fullyFaithful.preimage φ
```
Then `φ`, hence `yoneda.map f`, is étale-locally surjective. The smallest missing lemma is:

```lean
theorem surjective_of_isLocallySurjective_yoneda_map
    {X Y : Scheme} (f : X ⟶ Y)
    (h : Presheaf.IsLocallySurjective Scheme.etaleTopology (yoneda.map f)) :
    Function.Surjective f.base
```

I Lean-checked this lemma and the complete QC proof against HEAD `cb14d34`. Its proof applies `h.imageSieve_mem` to `Y.fromSpecResidueField y`, extracts a cover with `Scheme.mem_grothendieckTopology_iff`, chooses a point above the residue-field closed point using `Cover.exists_eq`, and evaluates the resulting factorization. No residue-field descent is required, matching [`surjective_of_extensionTolerant_lift`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataQcFromRep.lean:272).

After installing compactness of the admissible source from its quasi-compact structure morphism, `quasiCompact_of_surjective f J.hom` proves the desired exact result. Together with [`locallyOfFiniteType_pic0_sepClosed_representableBy`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:433), this supports packaging `PicRepDatum` and immediately closing `JacobianData` via [`PicRepDatum.toJacobianData`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataFromPicRepDatum.lean:83).

`FiniteInAffine` remains unavailable: [`finiteInAffine_of_isAlgClosed_of_irreducible`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:162) needs both `[IsAlgClosed k]` and `[IrreducibleSpace J.left]`, neither supplied by the separably closed endpoint. No old `divFunctor` or `divSchemeOver` construction is needed for the QC route.

No files, commits, or Horizon state were changed.
