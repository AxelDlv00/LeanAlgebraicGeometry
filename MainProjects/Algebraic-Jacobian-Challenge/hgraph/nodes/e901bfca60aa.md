---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.freeMap_chartMatrixHom
docstring: '**The `I`-minor of the presenting morphism is the identity** (morphism
  level): the

  `I`-indexed coordinate inclusion composed with `chartMatrixHom` presents the (invertible)

  chart composite against its own inverse, hence is `𝟙`. Project-local — the

  `M^I_I = 1` ingredient of the Nitsure overlap compatibility.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.freeMap_chartMatrixHom
type: lean
updated: '2026-07-24T03:02:11'
---
lemma freeMap_chartMatrixHom {T : Scheme.{0}} {r d : ℕ} (x : RankQuotient r d T)
    (I : Finset (Fin r)) (hI : I.card = d) :
    SheafOfModules.freeMap (R := (chartLocus x I hI).toScheme.ringCatSheaf)
        (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) ≫ chartMatrixHom x I hI
      = 𝟙 (SheafOfModules.free (R := (chartLocus x I hI).toScheme.ringCatSheaf) (Fin d)) := by
  have hcomp := pullback_map_freeMap_pullbackFreeIso (chartLocus x I hI).ι
    (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))
  -- the comparison-naturality, inverted (term-mode; `rw` matching fails across the
  -- `X.Modules` diamond)
  have h1 : SheafOfModules.freeMap (R := (chartLocus x I hI).toScheme.ringCatSheaf)
        (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).inv
      = (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
        (Scheme.Modules.pullback (chartLocus x I hI).ι).map
          (SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))) := calc
    SheafOfModules.freeMap (R := (chartLocus x I hI).toScheme.ringCatSheaf)
        (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).inv
      = 𝟙 _ ≫ SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).inv :=
        (Category.id_comp _).symm
    _ = ((Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).hom) ≫
        SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).inv :=
        congrArg (· ≫ SheafOfModules.freeMap
            (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) ≫
          (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).inv)
          (Iso.inv_hom_id _).symm
    _ = (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
        ((Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).hom ≫
          SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))) ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).inv := by
        simp only [Category.assoc]
    _ = (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
        ((Scheme.Modules.pullback (chartLocus x I hI).ι).map
            (SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))) ≫
          (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).hom) ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).inv :=
        congrArg (fun z => (Scheme.Modules.pullbackFreeIso
            (chartLocus x I hI).ι (Fin d)).inv ≫ z ≫
          (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).inv) hcomp.symm
    _ = (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
        (Scheme.Modules.pullback (chartLocus x I hI).ι).map
          (SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))) ≫
        ((Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).hom ≫
          (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).inv) := by
        simp only [Category.assoc]
    _ = (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
        (Scheme.Modules.pullback (chartLocus x I hI).ι).map
          (SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))) ≫
        𝟙 _ :=
        congrArg (fun z => (Scheme.Modules.pullbackFreeIso
            (chartLocus x I hI).ι (Fin d)).inv ≫
          (Scheme.Modules.pullback (chartLocus x I hI).ι).map
            (SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))) ≫ z)
          (Iso.hom_inv_id _)
    _ = (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
        (Scheme.Modules.pullback (chartLocus x I hI).ι).map
          (SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))) :=
        congrArg ((Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫ ·)
          (Category.comp_id _)
  -- the pulled-back inclusion-then-quotient is the pulled-back chart composite
  have h2 : (Scheme.Modules.pullback (chartLocus x I hI).ι).map
        (SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))) ≫
        (Scheme.Modules.pullback (chartLocus x I hI).ι).map x.q
      = (Scheme.Modules.pullback (chartLocus x I hI).ι).map (chartComposite x I hI) :=
    ((Scheme.Modules.pullback (chartLocus x I hI).ι).map_comp _ _).symm
  calc SheafOfModules.freeMap (R := (chartLocus x I hI).toScheme.ringCatSheaf)
        (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) ≫ chartMatrixHom x I hI
      = (SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) ≫
          (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin r)).inv) ≫
        (Scheme.Modules.pullback (chartLocus x I hI).ι).map x.q ≫
        (@CategoryTheory.inv _ _ _ _
          ((Scheme.Modules.pullback (chartLocus x I hI).ι).map (chartComposite x I hI))
          (isIso_pullback_chartLocus_map x I hI)) ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).hom := by
        simp only [Category.assoc]; rfl
    _ = ((Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
          (Scheme.Modules.pullback (chartLocus x I hI).ι).map
            (SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)))) ≫
        (Scheme.Modules.pullback (chartLocus x I hI).ι).map x.q ≫
        (@CategoryTheory.inv _ _ _ _
          ((Scheme.Modules.pullback (chartLocus x I hI).ι).map (chartComposite x I hI))
          (isIso_pullback_chartLocus_map x I hI)) ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).hom :=
        congrArg (· ≫ (Scheme.Modules.pullback (chartLocus x I hI).ι).map x.q ≫
          (@CategoryTheory.inv _ _ _ _
          ((Scheme.Modules.pullback (chartLocus x I hI).ι).map (chartComposite x I hI))
          (isIso_pullback_chartLocus_map x I hI)) ≫
          (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).hom) h1
    _ = (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
        (((Scheme.Modules.pullback (chartLocus x I hI).ι).map
            (SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))) ≫
          (Scheme.Modules.pullback (chartLocus x I hI).ι).map x.q) ≫
          (@CategoryTheory.inv _ _ _ _
          ((Scheme.Modules.pullback (chartLocus x I hI).ι).map (chartComposite x I hI))
          (isIso_pullback_chartLocus_map x I hI))) ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).hom := by
        simp only [Category.assoc]
    _ = (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
        ((Scheme.Modules.pullback (chartLocus x I hI).ι).map (chartComposite x I hI) ≫
          (@CategoryTheory.inv _ _ _ _
          ((Scheme.Modules.pullback (chartLocus x I hI).ι).map (chartComposite x I hI))
          (isIso_pullback_chartLocus_map x I hI))) ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).hom :=
        congrArg (fun z => (Scheme.Modules.pullbackFreeIso
            (chartLocus x I hI).ι (Fin d)).inv ≫ z ≫
          (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).hom)
          (congrArg (· ≫ (@CategoryTheory.inv _ _ _ _
          ((Scheme.Modules.pullback (chartLocus x I hI).ι).map (chartComposite x I hI))
          (isIso_pullback_chartLocus_map x I hI))) h2)
    _ = (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
        𝟙 _ ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).hom :=
        congrArg (fun z => (Scheme.Modules.pullbackFreeIso
            (chartLocus x I hI).ι (Fin d)).inv ≫ z ≫
          (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).hom)
          (@IsIso.hom_inv_id _ _ _ _
            ((Scheme.Modules.pullback (chartLocus x I hI).ι).map (chartComposite x I hI))
            (isIso_pullback_chartLocus_map x I hI))
    _ = (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫
        (Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).hom :=
        congrArg ((Scheme.Modules.pullbackFreeIso (chartLocus x I hI).ι (Fin d)).inv ≫ ·)
          (Category.id_comp _)
    _ = 𝟙 _ := Iso.inv_hom_id _