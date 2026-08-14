---
author: sync
content_type: theorem
created: '2026-08-10T10:38:34'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.sectionsMap_tower_probe
file: ScratchSectionsTowerProbe.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.BasicOpenCocycleDatum.sectionsMap_tower_probe
type: lean
updated: '2026-08-14T17:00:22'
---
theorem sectionsMap_tower_probe
    (R'' : Type u) [CommRing R''] [Algebra k R''] [Algebra R R''] [Algebra R' R'']
    [IsScalarTower k R R''] [IsScalarTower k R' R''] [IsScalarTower R R' R'']
    (D : BasicOpenCocycleDatum C R pi)
    {W : (relCurve C R).Opens} {W' : (relCurve C R').Opens}
    {W'' : (relCurve C R'').Opens}
    (hW' : W' ≤ relCurveMap C R R' ⁻¹ᵁ W)
    (hW'' : W'' ≤ relCurveMap C R' R'' ⁻¹ᵁ W')
    (hD : (D.baseChange R').baseChange R'' = D.baseChange R'')
    (s : ↥(gluedSubmodule R D.pieces D.unit W)) :
    let hcomp : W'' ≤ relCurveMap C R R'' ⁻¹ᵁ W := by
      rw [← relCurveMap_comp (C := C) (R := R) (R' := R') (R'' := R''),
        Scheme.Hom.comp_preimage]
      exact hW''.trans (Scheme.Hom.preimage_mono _ hW')
    cast (congrArg (fun E : BasicOpenCocycleDatum C R'' pi =>
      ↥(gluedSubmodule R'' E.pieces E.unit W'')) hD)
        ((D.baseChange R').sectionsMap R'' hW'' (D.sectionsMap R' hW' s)) =
      D.sectionsMap R'' hcomp s := by
  dsimp only
  simp only [hD]
  apply Subtype.ext
  funext j
  simp only [sectionsMap_coe]
  have hmaps := Scheme.Hom.appLE_comp_appLE
    (relCurveMap C R' R'') (relCurveMap C R R')
    (W ⊓ D.pieces j)
    (W' ⊓ (D.baseChange R').pieces j)
    (W'' ⊓ ((D.baseChange R').baseChange R'').pieces j)
    (D.sectionsMap_component_le R' hW' j)
    ((D.baseChange R').sectionsMap_component_le R'' hW'' j)
  rw [← CommRingCat.comp_apply, hmaps]
  exact congr($(appLE_congr_hom_tower
    (relCurveMap_comp (C := C) (R := R) (R' := R') (R'' := R'')) _).hom (s.val j))