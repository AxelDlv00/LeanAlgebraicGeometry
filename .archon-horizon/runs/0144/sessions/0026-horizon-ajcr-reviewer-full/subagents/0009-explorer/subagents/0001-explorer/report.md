Read-only audit complete at HEAD `cb14d34eea9fb41ffc722b5535d2a67b4e041e65` (`AJCR: expose PicRepDatum group bridge`, 2026-08-14 03:17:56 +08:00). No files, git state, or Horizon state were changed.

**Exact carrier**

- [`pic0_sepClosed_representableBy`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:426) assumes `[Field k] [IsSepClosed k]`, plus proper, smooth relative dimension one, and geometrically irreducible `C`.
- Its result is `Σ J, (pic0TypeFunctor C).RepresentableBy J`. Thus for
  `Jsc := (pic0_sepClosed_representableBy (C := C)).1`, the representation is exactly `.2`.
- Unfolding [`pic0_sepClosed_representableBy_of_isOpen`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:412) and [`pic0RepresentableByOfCharts`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean:161), `Jsc.left` is definitionally the 01JJ glued scheme for `picRankOneTranslatedChart`; its index is [`PicRankOneTranslatorIndex`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:159), the subtype of base Čech-Picard classes of degree `genus C`.
- The LFT field is already proved by [`locallyOfFiniteType_pic0_sepClosed_representableBy`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:433).
- No declaration currently proves `QuasiCompact Jsc.hom`.

**Applicable QC criteria**

- [`JacobianData.ofRepresentableBy`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataCharts.lean:71): `rep` and `hlft` instantiate exactly; only `QuasiCompact Jsc.hom` is missing.
- [`quasiCompact_of_pic0_class_surjective`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataQcFromRep.lean:230): applies to `Jsc` once given one fixed divisor scheme, one `lam`, and the residue-field-pinned class lift `hcl`.
- [`quasiCompact_of_extensionTolerant_lift`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataQcFromRep.lean:293): also applies to `Jsc`; its remaining input is
  `∀ y, ∃ T, Nonempty T.left, e : T ⟶ overSpec k κ(y), q : T ⟶ DivScheme, pic0Map C q lam = rep.homEquiv (e ≫ testPoint y)`.
- [`extensionTolerant_of_kappaPinned`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataQcFromRep.lean:307) only converts the stronger pinned hypothesis into that form.
- [`quasiCompact_of_divRep_of_lift`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataQcFromRep.lean:374) produces `lam` from the old `divFunctor C π n` carrier, but the present construction uses widened `divFunctorAff`. It is not the route to revive under protection I-0492 and still leaves `hcl`.
- [`quasiCompact_of_finite_family_pic0_class`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataQcFiniteFamily.lean:155) requires a finite family and pinned lifts. It does not supply an extension-tolerant finite-family variant.
- [`quasiCompact_of_surjective`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/CompactImageQc.lean:60) is the cleanest criterion: a compact source and a point-surjective scheme morphism to `Jsc`.
- The specialized forms [`quasiCompact_of_surjective_from_divScheme`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataAbelImage.lean:93) and [`quasiCompact_of_forall_residueField_lift_from_divScheme`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataAbelSurj.lean:118) apply but demand the same point-surjectivity or the stronger pinned lifts.
- [`quasiCompact_gluedHom`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataCharts.lean:164) is definitionally about the exact glued carrier, but needs `[Finite PicRankOneTranslatorIndex]` and compact charts. No such finite instance exists, and that index is not expected to be finite.
- [`compactSpace_glued_iff_quasiCompact`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0AtlasCompactFromClass.lean:320) applies definitionally but is only an equivalence, not a producer.

**Fresh HEAD commit**

[`PicRepDatum.toJacobianData`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataFromPicRepDatum.lean:83) is the newly landed theorem. `Jsc`, its `.2` representation, and the LFT theorem trivially form `PicRepDatum k k C`, but `toJacobianData` still takes `hqc`. [`toJacobianDataOfAbelLifts`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataFromPicRepDatum.lean:140) still takes residue-field-pinned Abel lifts. The commit is packaging, not a QC producer.

**FiniteInAffine**

- [`FiniteInAffine`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/FiniteInAffine.lean:32) only says every finite subset lies in an affine open.
- The affine, isomorphism, and affine-morphism criteria are at lines 36, 41, and 51; none applies to `Jsc`.
- [`finiteInAffine_of_isAlgClosed_of_irreducible`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:162) can use the group object derived from `Jsc`’s representation and the known LFT theorem, but additionally requires `[IsAlgClosed k]` and `[IrreducibleSpace Jsc.left]`. Neither follows from the current `[IsSepClosed k]` endpoint.
- Even if obtained, `FiniteInAffine` does not imply quasi-compactness; its consumer is the Galois orbit condition at [`orbitsInAffineOpen_of_finiteInAffine`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/FiniteInAffine.lean:66).

**Smallest honest missing lemma**

The strongest existing input is already landed:

- [`isLocallySurjective_abelSigmaChartAffAdmissible`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0AdmissibleAbelEtaleSurjective.lean:72): the admissible Abel map from `D := divRepAffAdmissibleScheme C` is étale-locally surjective.
- [`quasiCompact_divRepAffAdmissibleScheme`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0AdmissibleDivisorQuasiProjective.lean:315): `D` is quasi-compact, hence `D.left` is compact.
- [`representableBySigmaIso`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:63) turns `Jsc`’s representation into
  `yoneda.obj Jsc.left ≅ pic0SigmaSheaf C`.

Compose the admissible Abel map with that inverse to obtain an étale-locally-surjective map
`yoneda.obj D.left ⟶ yoneda.obj Jsc.left`. The missing generic bridge is:

```lean
theorem surjective_yonedaEquiv_of_isLocallySurjective_etale
    {X Y : Scheme} (φ : yoneda.obj X ⟶ yoneda.obj Y)
    [Presheaf.IsLocallySurjective Scheme.etaleTopology φ] :
    Function.Surjective (yonedaEquiv φ).base
```

No project or mathlib declaration with this content exists. Mathlib’s `Scheme.geometricFiber` supplies the proof mechanism: apply its `jointly_surjective` field to the image sieve and a geometric point above each `y`. Once this bridge lands, `quasiCompact_of_surjective` immediately proves `QuasiCompact Jsc.hom`, and the already landed representation plus LFT theorem package the exact carrier into `JacobianData C`.
