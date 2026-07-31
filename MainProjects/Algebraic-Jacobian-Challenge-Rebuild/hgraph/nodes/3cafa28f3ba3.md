---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.Scheme.divisorPresheaf
docstring: The presheaf `U ↦ 𝒪(D)(U)` of `K`-modules on the small Zariski site of
  `X`.
file: AlgebraicJacobian/RiemannRoch/DivisorSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.divisorPresheaf
type: lean
updated: '2026-07-31T20:15:29'
---
noncomputable def divisorPresheaf (D : X.CurveDivisor) : (X.Opens)ᵒᵖ ⥤ ModuleCat.{u} K where
  obj U := ModuleCat.of K (divisorSections K D U.unop)
  map {U V} i := ModuleCat.ofHom (divisorSectionsRes K D (leOfHom i.unop))
  map_id U := by
    apply ModuleCat.hom_ext
    simp only [ModuleCat.hom_ofHom, ModuleCat.hom_id, divisorSectionsRes_id K (leOfHom (𝟙 U.unop))]
  map_comp {U V W} i j := by
    apply ModuleCat.hom_ext
    have hcomp : divisorSectionsRes K D (leOfHom (i ≫ j).unop) =
          (divisorSectionsRes K D (leOfHom j.unop)).comp
            (divisorSectionsRes K D (leOfHom i.unop)) :=
      divisorSectionsRes_comp K (leOfHom j.unop) (leOfHom i.unop)
    simp only [ModuleCat.hom_ofHom, ModuleCat.hom_comp, hcomp]