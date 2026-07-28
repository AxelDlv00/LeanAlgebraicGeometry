---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.gMul_mul_apply
docstring: 'Definitional unfolding of the graded multiplication, as a clean rewrite
  handle for the

  coherence proofs: `a · b = Γ(μ_{i,j})(sectionsMul (a ⊗ₜ b))`.'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.Modules.gMul_mul_apply
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma gMul_mul_apply (L : X.Modules) {i j : ℕ}
    (a : sectionDeg L i) (b : sectionDeg L j) :
    (GradedMonoid.GMul.mul a b : sectionDeg L (i + j))
      = ((tensorPowAdd L i j).hom.val.app (Opposite.op ⊤)).hom
          ((sectionsMul (tensorPow L i) (tensorPow L j)).hom
            (a ⊗ₜ[(X.sheaf.obj ⋙ forget₂ CommRingCat RingCat).obj (Opposite.op ⊤)] b)) :=
  rfl