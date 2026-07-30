---
author: sync
content_type: theorem
created: '2026-07-31T00:08:48'
decl: AlgebraicGeometry.subsingleton_pic0Subgroup_of_surjective_app
docstring: '**THE CONVERSE: surjectivity FORCES the vanishing.**


  If the chart''s app is surjective at the test `S.left`, then every degree-zero class
  over

  `Over.mk S.hom` — i.e. over `S` itself, since `Over.mk S.hom = S` by `rfl` — is
  the chart

  value of some point, and by the previous lemma''s Σ-component computation that point
  is

  `S.hom` itself.  So the class is determined, and two classes over `S` coincide.


  This is what makes the decision an equivalence rather than a sufficient condition,
  and it is

  the reason this file''s headline is not a weakening: a curve with two distinct degree-zero

  classes at one test has no hope at this chart, whatever `V` one restricts to

  (`not_seamPair_abelSigmaChartZero_of_two_pic0`).'
file: AlgebraicJacobian/Picard/Pic0ChartSeamPairDecided.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.subsingleton_pic0Subgroup_of_surjective_app
type: lean
updated: '2026-07-31T00:08:48'
---
theorem subsingleton_pic0Subgroup_of_surjective_app
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((0 : ℕ) : ℤ))
    (hsurj : ∀ T : Scheme.{u}ᵒᵖ,
      Function.Surjective ((abelSigmaChartZero (C := C) (pi := pi) m Z hdeg).app T))
    (S : Over (Spec (.of k))) :
    Subsingleton (pic0Subgroup C S) := by
  refine ⟨fun x y => ?_⟩
  -- both classes name a Σ-element over `S.left` with structure morphism `S.hom`
  obtain ⟨vx, hvx⟩ := hsurj (op S.left) ⟨S.hom, x⟩
  obtain ⟨vy, hvy⟩ := hsurj (op S.left) ⟨S.hom, y⟩
  -- the Σ-components pin the two points to `S.hom`, hence to each other
  have hx : vx = S.hom := by
    rw [← sigmaComponent_abelSigmaChartZero C pi m Z hdeg S.left vx, hvx]
  have hy : vy = S.hom := by
    rw [← sigmaComponent_abelSigmaChartZero C pi m Z hdeg S.left vy, hvy]
  have : (⟨S.hom, x⟩ : (pic0SigmaSheaf C).1.obj (op S.left)) = ⟨S.hom, y⟩ := by
    rw [← hvx, ← hvy, hx, hy]
  exact eq_of_heq (Sigma.mk.inj this).2