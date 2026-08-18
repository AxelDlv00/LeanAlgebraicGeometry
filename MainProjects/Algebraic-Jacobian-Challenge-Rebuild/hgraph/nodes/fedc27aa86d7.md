---
author: sync
content_type: definition
created: '2026-08-14T14:17:16'
decl: AlgebraicJacobian.GaloisDescent.GaloisQuotientWitness.overHomEquiv
docstring: 'A finite-Galois quotient witness represents equivariant maps after base

  change, with no affineness assumption on the test object.'
file: AlgebraicJacobian/Picard/Pic0FiniteGaloisDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.GaloisQuotientWitness.overHomEquiv
type: lean
updated: '2026-08-18T20:51:05'
---
noncomputable def overHomEquiv (w : GaloisQuotientWitness rho Y g)
    (T : Over (Spec (CommRingCat.of K))) :
    (T ⟶ Over.mk g) ≃ GaloisEquivariantOver rho T where
  toFun a :=
    { hom := pullbackBaseChange K L g T.hom a.left a.w ≫ w.e.hom
      commutes := by
        rw [Category.assoc, w.over, pullbackBaseChange_snd]
      equivariant := SemilinearGalAction.isEquivariant_pullbackBaseChange_comp
        g T.hom rho w.equivariant a.left a.w }
  invFun h :=
    Over.homMk
      (w.universal T.left T.hom h.hom h.commutes h.equivariant).choose.1
      (w.universal T.left T.hom h.hom h.commutes h.equivariant).choose.2
  left_inv a := by
    apply Over.OverMorphism.ext
    let h := pullbackBaseChange K L g T.hom a.left a.w ≫ w.e.hom
    let hw := w.universal T.left T.hom h
      (by
        dsimp [h]
        rw [Category.assoc, w.over, pullbackBaseChange_snd])
      (by
        dsimp [h]
        exact SemilinearGalAction.isEquivariant_pullbackBaseChange_comp
          g T.hom rho w.equivariant a.left a.w)
    have ha : pullbackBaseChange K L g T.hom a.left a.w ≫ w.e.hom = h := rfl
    have heq : hw.choose = ⟨a.left, a.w⟩ :=
      hw.unique hw.choose_spec.1 ha
    exact congrArg Subtype.val heq
  right_inv h := by
    apply GaloisEquivariantOver.ext rho
    exact (w.universal T.left T.hom h.hom h.commutes h.equivariant).choose_spec.1