---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.dualUnitIso_dualIsoOfIso
docstring: '**B1: conjugating `dualIsoOfIso s` by `dual_unit_iso` recovers `s`** (the
  degenerate

  `rightAdjointMate_id`-style identity).  For a unit automorphism `s : 𝒪_V ≅ 𝒪_V`,

  `dual_unit_iso.symm ≪≫ dualIsoOfIso s ≪≫ dual_unit_iso = s`.


  `dual_unit_iso = sheafification.mapIso presheafDualUnitIso ≪≫ counit`, and

  `dualIsoOfIso s = sheafification.mapIso (PresheafOfModules.dualIsoOfIso (forget
  s))`, so the

  three `mapIso` legs compose to `sheafification.mapIso (presheafDualUnitIso.symm
  ≪≫

  PresheafOfModules.dualIsoOfIso (forget s) ≪≫ presheafDualUnitIso)`.  The presheaf
  core

  (★) `presheafDualUnitIso.symm ≪≫ PresheafOfModules.dualIsoOfIso ŝ ≪≫ presheafDualUnitIso
  = ŝ`

  is the eval-at-`1` semantics of `dualUnitIsoGen`; the residual is the counit-naturality

  conjugation, which returns `s`.'
file: AlgebraicJacobian/Picard/TensorObjInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.dualUnitIso_dualIsoOfIso
type: lean
updated: '2026-07-16T21:14:28'
---
lemma dualUnitIso_dualIsoOfIso {V : Scheme.{u}}
    (s : SheafOfModules.unit V.ringCatSheaf ≅ SheafOfModules.unit V.ringCatSheaf) :
    dual_unit_iso.symm ≪≫ dualIsoOfIso s ≪≫ dual_unit_iso = s := by
  -- B1 follows by pure iso-algebra from the single naturality square (N):
  --   `dualIsoOfIso s ≪≫ dual_unit_iso = dual_unit_iso ≪≫ s`.
  -- (N) is the naturality of `dual_unit_iso : dual 𝒪_V ≅ 𝒪_V` with respect to the unit
  -- automorphism `s`, acting contravariantly via `dualIsoOfIso s` on the source.  It
  -- decomposes as the presheaf eval-core naturality (★')
  --   `PresheafOfModules.dualIsoOfIso ŝ ≪≫ presheafDualUnitIso = presheafDualUnitIso ≪≫ ŝ`
  -- transported under `sheafification.mapIso` and composed with the sheafification-counit
  -- naturality `sheafification.mapIso (forget.mapIso s) ≪≫ counit = counit ≪≫ s`.
  have hN : dualIsoOfIso s ≪≫ dual_unit_iso = dual_unit_iso ≪≫ s := by
    apply Iso.ext
    unfold dualIsoOfIso dual_unit_iso
    simp only [Iso.trans_hom, Functor.mapIso_hom, Category.assoc]
    -- The presheaf eval-core (★') at hom level: `dŝ.hom ≫ p.hom = p.hom ≫ ŝ.hom`.
    have hcore := congrArg Iso.hom (presheafDualUnitIso_naturality (Y := V)
      ((SheafOfModules.forget V.ringCatSheaf).mapIso s))
    simp only [Iso.trans_hom] at hcore
    -- Push `hcore` through `sheafification` (the two `S.map` legs differ only by defeq
    -- instances, so the combine/split must use `erw`), then close with the
    -- sheafification-counit naturality at `s`.
    rw [← Category.assoc]
    erw [← Functor.map_comp, hcore, Functor.map_comp, Category.assoc]
    erw [(PresheafOfModules.sheafificationAdjunction
      (𝟙 V.ringCatSheaf.val)).counit.naturality s.hom]
    rfl
  rw [hN, ← Iso.trans_assoc, Iso.symm_self_id, Iso.refl_trans]