---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.Scheme.moduleToDivisorZeroPresheaf
docstring: '**The presheaf morphism `𝒪_X → 𝒪(0)`** of `K`-modules, section-wise `s
  ↦ germ_η s`.'
file: AlgebraicJacobian/RiemannRoch/DivisorSheafZero.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.moduleToDivisorZeroPresheaf
type: lean
updated: '2026-07-31T20:15:29'
---
noncomputable def moduleToDivisorZeroPresheaf :
    X.moduleKPresheaf K ⟶ divisorPresheaf K 0 where
  app U := ModuleCat.ofHom (moduleToDivisorZeroPresheafApp K U.unop)
  naturality {U V} i := by
    apply ModuleCat.hom_ext
    apply LinearMap.ext
    intro s
    by_cases hV : (V.unop : Set X).Nonempty
    · have hU : (U.unop : Set X).Nonempty := hV.mono (leOfHom i.unop)
      apply Subtype.ext
      change ((moduleToDivisorZeroPresheafApp K V.unop ((X.presheaf.map i).hom s) :
              divisorSections K 0 V.unop) : X.functionField)
          = ((divisorSectionsRes K 0 (leOfHom i.unop)
              (moduleToDivisorZeroPresheafApp K U.unop s) : divisorSections K 0 V.unop) :
              X.functionField)
      rw [moduleToDivisorZeroPresheafApp_coe_of_nonempty K hV,
        divisorSectionsRes_coe K (leOfHom i.unop) hV,
        moduleToDivisorZeroPresheafApp_coe_of_nonempty K hU]
      have hgr := X.presheaf.germ_res_apply i.unop (genericPoint X)
        (genericPoint_mem_of_nonempty hV) s
      simpa using hgr
    · haveI := divisorPresheaf_obj_subsingleton K (D := 0) (W := V.unop) hV
      exact Subsingleton.elim _ _