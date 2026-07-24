---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechSectionHomotopyComp_coord
docstring: 'Coordinatewise value of the homotopy component: the `τ`-coordinate of
  `h(t)` is the

  engine prepend map applied to the `(i_fix :: τ)`-coordinate of `t`.'
file: AlgebraicJacobian/Cohomology/CechSectionContractibilityCore.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechSectionHomotopyComp_coord
type: lean
updated: '2026-07-24T10:02:45'
---
lemma cechSectionHomotopyComp_coord (m : ℕ)
    (t : ToType ((sectionCechComplexV 𝒰 F V).X (m + 1))) (τ : Fin (m + 1) → 𝒰.I₀) :
    sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
        ((SheafOfModules.forget X.ringCatSheaf).obj F) m
        (ConcreteCategory.hom (cechSectionHomotopyComp 𝒰 F V i_fix hiV m) t) τ
      = cechSectionPrepend 𝒰 F V i_fix hiV (m + 1) τ
          (sectionCechProductEquiv (fun a => coverOpen 𝒰 a ⊓ V)
            ((SheafOfModules.forget X.ringCatSheaf).obj F) (m + 1) t (Fin.cons i_fix τ)) := by
  refine Eq.trans (sectionCechProductEquiv_apply (fun a => coverOpen 𝒰 a ⊓ V)
    ((SheafOfModules.forget X.ringCatSheaf).obj F) m _ τ) ?_
  refine Eq.trans (ConcreteCategory.comp_apply
    (cechSectionHomotopyComp 𝒰 F V i_fix hiV m) (Pi.π _ τ) t).symm ?_
  refine Eq.trans (ConcreteCategory.congr_hom (Pi.lift_π _ τ) t) ?_
  refine Eq.trans (ConcreteCategory.comp_apply _ _ t) ?_
  exact DFunLike.congr_arg (cechSectionPrepend 𝒰 F V i_fix hiV (m + 1) τ)
    (sectionCechProductEquiv_apply (fun a => coverOpen 𝒰 a ⊓ V)
      ((SheafOfModules.forget X.ringCatSheaf).obj F) (m + 1) t (Fin.cons i_fix τ)).symm