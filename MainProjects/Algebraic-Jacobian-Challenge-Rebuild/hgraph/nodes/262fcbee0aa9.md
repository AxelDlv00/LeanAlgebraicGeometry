---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.resInv_mul
docstring: Multiplicativity of the restricted `ΓSpecIso`-avatar.
file: AlgebraicJacobian/Picard/DescentSectionEval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.resInv_mul
type: lean
updated: '2026-07-30T15:46:01'
---
lemma resInv_mul (U : (SB).Opens) (b b' : B) :
    ((SB).presheaf.map (homOfLE (le_top : U ≤ ⊤)).op).hom
        ((Scheme.ΓSpecIso (.of B)).inv.hom (b * b'))
      = ((SB).presheaf.map (homOfLE (le_top : U ≤ ⊤)).op).hom
          ((Scheme.ΓSpecIso (.of B)).inv.hom b)
        * ((SB).presheaf.map (homOfLE (le_top : U ≤ ⊤)).op).hom
          ((Scheme.ΓSpecIso (.of B)).inv.hom b') := by
  rw [map_mul]
  exact map_mul _ _ _