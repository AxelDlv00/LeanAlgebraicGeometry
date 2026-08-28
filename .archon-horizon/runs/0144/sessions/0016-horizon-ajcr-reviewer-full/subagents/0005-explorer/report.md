The identity test produces

```lean
P : PicRankOneLocalPresentation pi
  ((picDegLayerFunctor C (genus C : ℤ)).map
    (𝟙 (overSpec k A)).op lam)
```

not literally `PicRankOneLocalPresentation pi lam`. Only the underlying Picard value is identified by

```lean
have e :
    ((picDegLayerFunctor C (genus C : ℤ)).map
      (𝟙 (overSpec k A)).op lam).1 = lam.1 :=
  picEtMap_id C lam.1
```

The smallest useful split is a method generic in the presentation’s own index:

```lean
theorem PicRankOneLocalPresentation.exists_cover_abel_divisor
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (P : PicRankOneLocalPresentation pi lam)
    (hpi : pi ≫ P1.structureMap k = C.hom) :
    ∃ F' : DivFamZarAff C P.cover.Carrier (genus C),
      abelDivAffPlus C P.cover.Carrier F' =
        PicEtAff.unit C P.cover.Carrier
          (P.representative :
            relPic C (overSpec k P.cover.Carrier)) := by
  ...
```

Move current lines 132-231 into this proof. Finish it directly with:

```lean
  refine ⟨F', ?_⟩
  calc
    abelDivAffPlus C P.cover.Carrier F' =
        PicEtAff.unit C P.cover.Carrier
          (relPicMk C (overSpec k P.cover.Carrier) F'.picClass) := rfl
    _ = PicEtAff.unit C P.cover.Carrier
          (relPicMk C (overSpec k P.cover.Carrier)
            P.datum.cechPicClass) := by rw [hrelB]
    _ = PicEtAff.unit C P.cover.Carrier
          (P.representative :
            relPic C (overSpec k P.cover.Carrier)) := by
      rw [← P.datum_class]
```

Thus steps 1-5 use only `P.datum`, `P.datum_class`, `P.h1_vanishing`, `P.h0_rank_one`, `P.cover`, and `hpi`. They do not use `P.represents`, the outer `hlam`, or the identity transport `e`.

The outer theorem becomes:

```lean
  obtain ⟨P⟩ :=
    (mem_picRankOneOpen_iff pi lam).mp hlam A (𝟙 (overSpec k A))
  have e := picEtMap_id C lam.1
  obtain ⟨F', hunit⟩ :=
    PicRankOneLocalPresentation.exists_cover_abel_divisor
      (pi := pi) P hpi
  have hrep :
      PicEtAff.mk C P.cover P.representative =
        picEtAffineEquiv C A lam.1 := by
    rw [← e]
    exact P.represents
  have htarget :
      PicEtAff.mapAlg C
          ((Algebra.ofId A P.cover.Carrier).restrictScalars k)
          (picEtAffineEquiv C A lam.1) =
        PicEtAff.unit C P.cover.Carrier
          (P.representative :
            relPic C (overSpec k P.cover.Carrier)) := by
    rw [← hrep, PicEtAff.mapAlg_mk_eq_unit_self]
  exact existsUnique_abel_divFamZarAff_of_etale_witness pi
    (rankOneDivisorUniqueness pi) lam hlam P.cover F'
    (hunit.trans htarget.symm)
```

For a separate helper file, retain the local degree/base-change instances currently at lines 71-104; they are file-local and steps 3-4 need them. The helper can import `Pic0RankOneCanonicalDivisorDegree` plus the three Mathlib rank/topology modules. The thin consumer imports that helper and `Pic0RankOneUniquenessDischarge`.

No files were edited. I could not complete an LSP snippet check because the existing candidate’s long elaboration occupied the server, but the signature matches the exact existing structure and theorem result types.
