---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.ZariskiDescent.isSheafFor_opens
docstring: '**The glued functor satisfies the sheaf condition at covers by opens.**'
file: AlgebraicJacobian/Picard/ZariskiDescentRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ZariskiDescent.isSheafFor_opens
type: lean
updated: '2026-07-24T03:02:12'
---
lemma isSheafFor_opens (T : Scheme.{0}) {κ : Type} (W : κ → T.Opens)
    (hW : ⨆ k, W k = ⊤) :
    Presieve.IsSheafFor (gluedFunctor F Y R)
      (Presieve.ofArrows (fun k => (W k).toScheme) (fun k => (W k).ι)) := by
  rw [Presieve.isSheafFor_arrows_iff]
  intro x hx
  -- Glue the base morphisms.
  have hcompat : ∀ k l : κ,
      pullback.fst ((W k).ι) ((W l).ι) ≫ (x k).a
        = pullback.snd ((W k).ι) ((W l).ι) ≫ (x l).a := fun k l =>
    congrArg GluedPoint.a
      (hx k l (pullback ((W k).ι) ((W l).ι)) (pullback.fst _ _)
        (pullback.snd _ _) pullback.condition)
  obtain ⟨a, ha⟩ : ∃ a : T ⟶ S, ∀ k, (W k).ι ≫ a = (x k).a :=
    ⟨(opensCover T W hW).glueMorphisms (fun k => (x k).a) hcompat, fun k =>
      (opensCover T W hW).ι_glueMorphisms (fun k => (x k).a) hcompat k⟩
  have hOb : ∀ k, overRes (Over.mk a) (W k) = Over.mk ((x k).a) :=
    fun k => congrArg Over.mk (ha k)
  -- The compatibility of the family of restrictions on the overlaps.
  have hres : ∀ k l, GluedPoint.res R (T.homOfLE
        (inf_le_left : W k ⊓ W l ≤ W k)) (x k)
      = GluedPoint.res R (T.homOfLE inf_le_right) (x l) := by
    intro k l
    refine hx k l ((W k ⊓ W l).toScheme) (T.homOfLE inf_le_left)
      (T.homOfLE inf_le_right) ?_
    rw [Scheme.homOfLE_ι, Scheme.homOfLE_ι]
  have hq : ∀ (k l m : κ) (hm : W k ⊓ W l ≤ W m),
      overRes (Over.mk a) (W k ⊓ W l) = Over.mk (T.homOfLE hm ≫ (x m).a) :=
    fun k l m hm => congrArg Over.mk
      (show (W k ⊓ W l).ι ≫ a = T.homOfLE hm ≫ (x m).a by
        rw [← ha m, ← Category.assoc, Scheme.homOfLE_ι])
  -- Glue the `F`-sections via the sheaf axiom of `F`.
  have hsheaf := hF (Over.mk a) W (by change ⨆ k, W k = ⊤; exact hW)
    (fun k => F.map (eqToHom (hOb k)).op ((x k).sect hF hU))
    (by
      intro k l
      calc F.map (overResLE (Over.mk a)
            (inf_le_left : W k ⊓ W l ≤ W k)).op
              (F.map (eqToHom (hOb k)).op ((x k).sect hF hU))
          = F.map (eqToHom (hq k l k inf_le_left)).op
              ((GluedPoint.res R (T.homOfLE inf_le_left) (x k)).sect hF hU) :=
            sect_overResLE hF hU a inf_le_left (x k) (hOb k) _
        _ = F.map (eqToHom (hq k l k inf_le_left)).op
              (F.map (eqToHom (congrArg (fun p => Over.mk p.a) (hres k l))).op
                ((GluedPoint.res R (T.homOfLE inf_le_right) (x l)).sect hF hU)) :=
            congrArg (fun z => F.map (eqToHom (hq k l k inf_le_left)).op z)
              (sect_congr hF hU (hres k l))
        _ = F.map (eqToHom ((hq k l k inf_le_left).trans
              (congrArg (fun p => Over.mk p.a) (hres k l)))).op
              ((GluedPoint.res R (T.homOfLE inf_le_right) (x l)).sect hF hU) :=
            map_eqToHom_trans _ _ _
        _ = F.map (eqToHom (hq k l l inf_le_right)).op
              ((GluedPoint.res R (T.homOfLE inf_le_right) (x l)).sect hF hU) :=
            rfl
        _ = F.map (overResLE (Over.mk a)
            (inf_le_right : W k ⊓ W l ≤ W l)).op
              (F.map (eqToHom (hOb l)).op ((x l).sect hF hU)) :=
            (sect_overResLE hF hU a inf_le_right (x l) (hOb l) _).symm)
  obtain ⟨x₀, hx₀, hx₀uniq⟩ := hsheaf
  refine ⟨ofSect Y R a x₀, fun k => ?_, fun t' ht' => ?_⟩
  · -- The amalgamation restricts to the given family.
    change GluedPoint.res R ((W k).ι) (ofSect Y R a x₀) = x k
    rw [res_ofSect hF hU]
    have : F.map (resSecHom ((W k).ι) a).op x₀
        = F.map (eqToHom (by rw [ha k] :
            Over.mk ((W k).ι ≫ a) = Over.mk ((x k).a))).op
          ((x k).sect hF hU) := hx₀ k
    rw [this]
    exact (ofSect_congr (ha k) _).trans (ofSect_sect hF hU (x k))
  · -- Uniqueness.
    have haT : t'.a = a := by
      refine (opensCover T W hW).hom_ext _ _ fun k => ?_
      change (W k).ι ≫ t'.a = (W k).ι ≫ a
      rw [ha k]
      exact congrArg GluedPoint.a (ht' k)
    have hz : F.map (eqToHom (congrArg Over.mk haT.symm :
        Over.mk a = Over.mk t'.a)).op (t'.sect hF hU) = x₀ := by
      refine hx₀uniq _ fun k => ?_
      have hOb' : overRes (Over.mk a) (W k) = Over.mk ((W k).ι ≫ t'.a) :=
        congrArg Over.mk (show (W k).ι ≫ a = (W k).ι ≫ t'.a by rw [haT])
      calc F.map (overResHom (Over.mk a) (W k)).op
            (F.map (eqToHom (congrArg Over.mk haT.symm :
              Over.mk a = Over.mk t'.a)).op (t'.sect hF hU))
          = F.map (eqToHom hOb').op
              (F.map (resSecHom ((W k).ι) t'.a).op (t'.sect hF hU)) := by
            rw [map_map, map_map]
            refine map_congr (homMk_eqToHom_square hOb'
              (congrArg Over.mk haT.symm) (overResHom (Over.mk a) (W k))
              (resSecHom ((W k).ι) t'.a) (heq_of_eq ?_)) _
            simp only [overResHom, resSecHom, Over.homMk_left]
        _ = F.map (eqToHom hOb').op
              ((GluedPoint.res R ((W k).ι) t').sect hF hU) :=
            congrArg (fun z => F.map (eqToHom hOb').op z)
              (sect_res hF hU _ _).symm
        _ = F.map (eqToHom hOb').op
              (F.map (eqToHom (congrArg (fun p => Over.mk p.a) (ht' k))).op
                ((x k).sect hF hU)) :=
            congrArg (fun z => F.map (eqToHom hOb').op z)
              (sect_congr hF hU (ht' k))
        _ = F.map (eqToHom (hOb k)).op ((x k).sect hF hU) :=
            map_eqToHom_trans _ _ _
    calc t' = ofSect Y R t'.a (t'.sect hF hU) := (ofSect_sect hF hU t').symm
      _ = ofSect Y R a x₀ := by
          rw [← hz]
          exact (ofSect_congr haT.symm (t'.sect hF hU)).symm

set_option backward.isDefEq.respectTransparency false in
include hF hU in