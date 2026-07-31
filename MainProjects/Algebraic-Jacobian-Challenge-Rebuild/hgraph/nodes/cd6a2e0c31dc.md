---
author: sync
content_type: theorem
created: '2026-07-31T11:59:12'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.rigidEngine_of_genus_zero
docstring: '**The rigid engine at genus `0` on a fibrewise-trivial class**: `H¹(C_B,
  F_D) = 0` and

  `H⁰(C_B, F_D)` finite projective over `B`, with the fibrewise clause discharged
  by the

  genus hypothesis rather than assumed.'
file: AlgebraicJacobian/Picard/Pic0RingDatumEngine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.rigidEngine_of_genus_zero
type: lean
updated: '2026-07-31T11:59:12'
---
theorem rigidEngine_of_genus_zero (D : BasicOpenCocycleDatum C B π) [IsNoetherianRing B]
    (hπ : π ≫ P1.structureMap k = C.hom) (hg : genus C = 0)
    (htriv : ∀ p : PrimeSpectrum B,
      (D.baseChange p.asIdeal.ResidueField).cechPicClass = 1) :
    Subsingleton (Sheaf.HModule D.sheaf 1) ∧
      Module.Finite B (Sheaf.HModule D.sheaf 0) ∧
      Module.Projective B (Sheaf.HModule D.sheaf 0) :=
  datumRigidEngine D hπ fun p =>
    D.subsingleton_h1_residueField_tensor_of_genus_zero hg p (htriv p)