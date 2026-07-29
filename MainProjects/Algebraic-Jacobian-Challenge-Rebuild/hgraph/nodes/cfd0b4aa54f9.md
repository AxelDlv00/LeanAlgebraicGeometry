---
author: sync
content_type: lemma
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.Scheme.RationalMap.prod_fromFunctionField
file: AlgebraicJacobian/Albanese/RationalMapProd.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.RationalMap.prod_fromFunctionField
type: lean
updated: '2026-07-29T15:31:33'
---
lemma prod_fromFunctionField (sX : X ⟶ S) (sY : Y ⟶ S) (sZ : Z ⟶ S)
    [IsIntegral X] [LocallyOfFiniteType sY] [LocallyOfFiniteType sZ]
    (a : X ⤏ Y) (b : X ⤏ Z)
    (ha : a.compHom sY = sX.toRationalMap) (hb : b.compHom sZ = sX.toRationalMap) :
    (prod sX sY sZ a b ha hb).fromFunctionField
      = pullback.lift a.fromFunctionField b.fromFunctionField
        ((fromFunctionField_comp_structure a sX sY ha).trans
          (fromFunctionField_comp_structure b sX sZ hb).symm) := by
  haveI : LocallyOfFiniteType (pullback.fst sY sZ ≫ sY) :=
    MorphismProperty.comp_mem _ _ _ inferInstance inferInstance
  exact fromFunctionField_ofFunctionField _ _ _ _