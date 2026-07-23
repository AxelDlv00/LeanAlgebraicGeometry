---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.ZariskiDescent.GluedPoint.res
docstring: 'Functoriality of glued points: restriction along `b : V ⟶ T`.'
file: AlgebraicJacobian/Picard/ZariskiDescentRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ZariskiDescent.GluedPoint.res
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable def GluedPoint.res {V T : Scheme.{0}} (b : V ⟶ T)
    (p : GluedPoint F Y R T) : GluedPoint F Y R V where
  a := b ≫ p.a
  γ i := restrictHom U b p.a i ≫ p.γ i
  compat i j := by
    rw [classify_restrictHom, classify_restrictHom,
      ← Functor.map_comp_apply, ← Functor.map_comp_apply,
      ← op_comp, ← op_comp]
    have hsq : ∀ (k : ι) (hk : pre U (b ≫ p.a) i ⊓ pre U (b ≫ p.a) j ≤ pre U (b ≫ p.a) k)
        (hk' : pre U p.a i ⊓ pre U p.a j ≤ pre U p.a k),
        overResLE (Over.mk (b ≫ p.a)) hk ≫ overResRestrict U b p.a k
          = (Over.homMk (b.resLE (pre U p.a i ⊓ pre U p.a j)
                (pre U (b ≫ p.a) i ⊓ pre U (b ≫ p.a) j) le_rfl)
              (by simp [overRes]) :
              overRes (Over.mk (b ≫ p.a)) (pre U (b ≫ p.a) i ⊓ pre U (b ≫ p.a) j) ⟶
                overRes (Over.mk p.a) (pre U p.a i ⊓ pre U p.a j))
            ≫ overResLE (Over.mk p.a) hk' := by
      intro k hk hk'
      apply CommaMorphism.ext
      · simp only [overResLE, overResRestrict, Over.comp_left, Over.homMk_left,
          Scheme.Hom.map_resLE]
        exact (Scheme.Hom.resLE_map _ _ _).symm
      · apply Subsingleton.elim
    rw [hsq i inf_le_left inf_le_left, hsq j inf_le_right inf_le_right,
      op_comp, op_comp, Functor.map_comp_apply,
      Functor.map_comp_apply, p.compat i j]