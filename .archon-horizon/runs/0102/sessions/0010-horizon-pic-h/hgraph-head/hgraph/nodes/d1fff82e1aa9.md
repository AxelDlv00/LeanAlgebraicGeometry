---
author: sync
content_type: lemma
created: '2026-08-01T09:44:10'
decl: CategoryTheory.Pseudofunctor.pullHom'_hom_self_of_comp
docstring: 'An invertible overlap morphism satisfying the triple cocycle restricts
  to

  the identity on every diagonal.'
file: AlgebraicJacobian/Descent/DescentDataNormalization.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Pseudofunctor.pullHom'_hom_self_of_comp
type: lean
updated: '2026-08-01T09:44:10'
---
lemma pullHom'_hom_self_of_comp
    {obj : ∀ i, F.obj (.mk (op (X i)))}
    (hom : ∀ i j, (F.map (sq i j).p₁.op.toLoc).toFunctor.obj (obj i) ⟶
      (F.map (sq i j).p₂.op.toLoc).toFunctor.obj (obj j))
    (homIso : ∀ i j, IsIso (hom i j))
    (hom_comp : ∀ i₁ i₂ i₃,
      pullHom' hom (sq₃ i₁ i₂ i₃).p (sq₃ i₁ i₂ i₃).p₁ (sq₃ i₁ i₂ i₃).p₂ ≫
      pullHom' hom (sq₃ i₁ i₂ i₃).p (sq₃ i₁ i₂ i₃).p₂ (sq₃ i₁ i₂ i₃).p₃ =
      pullHom' hom (sq₃ i₁ i₂ i₃).p (sq₃ i₁ i₂ i₃).p₁ (sq₃ i₁ i₂ i₃).p₃) :
    ∀ i, pullHom' hom (f i) (𝟙 (X i)) (𝟙 (X i)) = 𝟙 _ := by
  intro i
  let d := pullHom' hom (f i) (𝟙 (X i)) (𝟙 (X i))
  have hd : d ≫ d = d := by
    dsimp only [d]
    exact comp_pullHom'' hom hom_comp (f i)
      (𝟙 (X i)) (𝟙 (X i)) (𝟙 (X i))
      (by simp) (by simp) (by simp)
  letI := homIso i i
  haveI : IsIso d := by
    dsimp only [d, pullHom']
    infer_instance
  apply (cancel_mono d).1
  rw [hd]
  simp