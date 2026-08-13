The missing bridge is slicewise surjectivity, not uniqueness:

```lean
theorem rankOneAbelRepresented_app_surjective
    (hpi : ...)
    (Z : Over (Spec (.of k))) :
    Function.Surjective ((rankOneAbelRepresented pi).app (op Z))
```

No theorem of this shape currently exists.

Construction:

```lean
let L := (PicRankOneOpen pi).toFunctor
let R := (divRankOnePresentationPreimageRepresenter pi).toFunctor

-- For lam : L.obj (op Z)
let lamU (U : Z.left.affineOpens) :=
  L.map (Over.fromSpecAffine Z U).op lam

let s : divFamZarAff C (genus C) Z :=
  ⟨fun U => canonicalRankOneDivisorOfMem pi hpi (lamU U).property,
    fun U V h => by
      -- uniqueness after base change
      apply canonicalRankOneDivisorOfMem_unique pi hpi (lamU U).property
      rw [← abelDivAffPlus_mapAlgHom,
        canonicalRankOneDivisorOfMem_abel,
        ← picEtAffineEquiv_naturality]
      -- lamV restricted to U is lamU
      congr 1
      simpa [lamU, ← Functor.map_comp_apply, ← op_comp]
        using congrArg (fun z => z.1.1)
          (show L.map (Over.overSpecMap (Over.resAlgHom Z h)).op (lamU V) = lamU U by
            rw [lamU, lamU, ← Functor.map_comp_apply, ← op_comp,
              Over.fromSpecAffine_resAlgHom h])⟩
```

Then prove:

```lean
have hsAbel :
    (abelDivAffTrans C (genus C)).app (op Z) s = lam.1 := by
  apply Subtype.ext
  apply picEt.ext
  intro U
  rw [abelDivAff'_val, canonicalRankOneDivisorOfMem_abel]
  -- collapse restriction along fromSpecAffine back to lam.1.1 U
```

The final collapse has no named theorem, but existing lemmas suffice:

```lean
lemma picEtAffineEquiv_map_fromSpecAffine
    (Z) (U : Z.left.affineOpens) (x : picEt C Z) :
    picEtAffineEquiv C Γ(Z.left, U.1)
      (picEtMap C (Over.fromSpecAffine Z U) x) = x.1 U := by
  rw [picEtAffineEquiv_apply, picEtMap_val,
    picEtMapVal_eq_mapAlg C (Over.fromSpecAffine Z U) x
      (top_le_preimage_fromSpecAffine Z U),
    ← PicEtAff.mapAlg_comp,
    fromSpecAffine_ΓTop_comp_appLEAlgHom,
    PicEtAff.mapAlg_id]
```

Relevant APIs are [Pic0RankOneCanonicalDivisorFree.lean:394](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalDivisorFree.lean:394), [DivisorFamilyAffAbel.lean:125](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyAffAbel.lean:125), [PicEtMap.lean:354](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicEtMap.lean:354), and [Pic0RigidityAffineReduction.lean:120](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RigidityAffineReduction.lean:120).

Classify `s` through the representer:

```lean
let rep := divFunctorAff_genus_representableBy C
let q : Z ⟶ divRepAffGenusScheme C := rep.homEquiv.symm s

let d : R.obj (op Z) :=
  ⟨q, by
    change (abelDivAffTrans C (genus C)).app (op Z) (rep.homEquiv q)
      ∈ (PicRankOneOpen pi).obj (op Z)
    rw [show rep.homEquiv q = s by simp [q], hsAbel]
    exact lam.property⟩

refine ⟨d, ?_⟩
apply Subtype.ext
change (abelDivAffTrans C (genus C)).app (op Z) (rep.homEquiv q) = lam.1
simpa [q] using hsAbel
```

This is exactly how the two preimages unwind: `divRankOnePresentationPreimageRepresenter` first applies `rep.toIso.hom`, obtaining the vehicle `s`, then tests whether `abelDivAffTrans.app s` lies in `PicRankOneOpen`; see [Pic0RankOneLocus.lean:226](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneLocus.lean:226).

After slicewise surjectivity, choice and existing injectivity provide the natural inverse:

```lean
noncomputable def rankOneEvaluationSlice : L ⟶ R where
  app Z lam := (rankOneAbelRepresented_app_surjective pi hpi Z.unop lam).choose
  naturality X Y f := by
    funext lam
    apply rankOneAbelRepresented_app_injective pi Y.unop
    -- naturality of rankOneAbelRepresented + choose_spec on both sides
```

No separate deep naturality theorem is needed here; [Pic0RankOneAbelInverse.lean:119](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneAbelInverse.lean:119) supplies the cancellation.

Finally:

```lean
noncomputable def evaluationData :
    PicRankOneEvaluationDivisorData pi where
  divisor := Over.sigmaExtensionNat (rankOneEvaluationSlice pi hpi)
  divisor_abel := by
    ext Y v
    rcases v with ⟨a, lam⟩
    exact congrArg (Sigma.mk a)
      (rankOneAbelRepresented_app_surjective pi hpi (Over.mk a) lam).choose_spec
```

On a Sigma component, `divisor` is literally

```lean
⟨a, lam⟩ ↦ ⟨a, (rankOneEvaluationSlice pi hpi).app (op (Over.mk a)) lam⟩
```

by [Pic0AtlasFromDivRep.lean:95](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0AtlasFromDivRep.lean:95). This matches the structure fields at [Pic0RankOneFibrePresentedProducer.lean:76](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducer.lean:76).

Bottom line: existing uniqueness, affine naturality, representability, Sigma-extension, and injectivity APIs suffice. The genuinely new producer is `rankOneAbelRepresented_app_surjective` or an equivalent arbitrary-test canonical vehicle theorem; `canonicalRankOneDivisorOfMem_mapAlgHom` and `picEtAffineEquiv_map_fromSpecAffine` are useful missing helper names but can be proved inline.
