---
author: sync
content_type: theorem
created: '2026-07-30T19:30:12'
decl: AlgebraicGeometry.Scheme.PicScheme.gen_descentClass_natural
file: zzaudit_r2.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.PicScheme.gen_descentClass_natural
type: lean
updated: '2026-07-30T20:01:19'
---
theorem gen_descentClass_natural {T T' : Over (Spec (CommRingCat.of k))}
    (f : T ⟶ T') (g : T' ⟶ Y) :
    gen_descentClass rep e he Φ T (f ≫ g)
      = ((coverFunctor (k := k) (k' := k')).op ⋙ G).map f.op
          (gen_descentClass rep e he Φ T' g) := by
  have hstep : rep.homEquiv (gen_descentMor e he T (f ≫ g))
      = F.map ((Over.pullback (specMapAlgebra k k')).map f).op
          (rep.homEquiv (gen_descentMor e he T' g)) :=
    (congrArg rep.homEquiv (gen_descentMor_comp e he f g)).trans
      (rep.homEquiv_comp _ _)
  change Φ.hom.app (op (baseTest (k' := k') T))
      (rep.homEquiv (gen_descentMor e he T (f ≫ g))) = _
  rw [hstep]
  exact NatTrans.naturality_apply Φ.hom
    (X := op (baseTest (k' := k') T')) (Y := op (baseTest (k' := k') T))
    ((Over.pullback (specMapAlgebra k k')).map f).op
    (rep.homEquiv (gen_descentMor e he T' g))

end Generic

-- ===== CHOICE PROBE: data-valued form WITHOUT the Nonempty wrapper =====
section ChoiceProbe
variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']
  [Algebra.IsSeparable k k'] [Module.Finite k k']
  {C : Over (Spec (CommRingCat.of k))}
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  {X' : Over (Spec (CommRingCat.of k'))}
  (rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X')
  (ρ : SemilinearGalAction k k' X'.left X'.hom)
  {Y : Over (Spec (CommRingCat.of k))}