---
author: sync
content_type: lemma
created: '2026-08-13T10:39:11'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.germ_component_smul_mem_nonZeroDivisors
docstring: Germ-regularity of the components transfers to unit multiples of a glued
  section.
file: AlgebraicJacobian/Picard/DivisorDatumSectionOfClass.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.germ_component_smul_mem_nonZeroDivisors
type: lean
updated: '2026-08-18T20:51:00'
---
lemma germ_component_smul_mem_nonZeroDivisors (v : Bˣ)
    (s : ↥(gluedSubmodule B D.pieces D.unit ⊤))
    (hreg : ∀ (j : D.index) (y : relCurve C B) (hy : y ∈ D.pieces j),
      ((relCurve C B).presheaf.germ (D.pieces j) y hy).hom (D.component s j)
        ∈ nonZeroDivisors ((relCurve C B).presheaf.stalk y))
    (j : D.index) (y : relCurve C B) (hy : y ∈ D.pieces j) :
    ((relCurve C B).presheaf.germ (D.pieces j) y hy).hom
        (D.component ((v : B) • s) j)
      ∈ nonZeroDivisors ((relCurve C B).presheaf.stalk y) := by
  rw [D.component_smul, Scheme.overModule_smul_def, map_mul]
  exact mul_mem
    ((v.isUnit.map ((relCurve C B).overAlgebraMap B (D.pieces j))).map
      ((relCurve C B).presheaf.germ (D.pieces j) y hy).hom).mem_nonZeroDivisors
    (hreg j y hy)