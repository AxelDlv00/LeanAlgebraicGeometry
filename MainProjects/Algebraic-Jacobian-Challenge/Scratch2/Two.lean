import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme

universe u

namespace Probe

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']
  [Algebra.IsSeparable k k'] [Module.Finite k k']

/-- Does the ∀-over-all-pairs compatibility follow from the TWO CANONICAL
projections of the self-pullback of `coverMap`? That is the standard reduction
(`Presieve.isSheafFor_singleton` via `Equalizer.Presieve.isSheafFor_singleton_iff`)
and it is what makes the hypothesis checkable. -/
example (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (x : (picEt C).obj (Opposite.op ((restrictTest k k').obj (baseTest (k' := k') T))))
    (h2 : (picEt C).map (pullback.fst (coverMap (k := k) (k' := k') T)
              (coverMap (k := k) (k' := k') T)).op x
        = (picEt C).map (pullback.snd (coverMap (k := k) (k' := k') T)
              (coverMap (k := k) (k' := k') T)).op x) :
    ∀ {W : Over (Spec (CommRingCat.of k))}
      (p₁ p₂ : W ⟶ (restrictTest k k').obj (baseTest (k' := k') T)),
      p₁ ≫ coverMap (k' := k') T = p₂ ≫ coverMap (k' := k') T →
      (picEt C).map p₁.op x = (picEt C).map p₂.op x := by
  intro W p₁ p₂ hp
  -- `p₁`, `p₂` factor through the self-pullback by its universal property
  set l := pullback.lift (f := coverMap (k := k) (k' := k') T)
    (g := coverMap (k := k) (k' := k') T) p₁ p₂ hp with hl
  have h1 : l ≫ pullback.fst (coverMap (k := k) (k' := k') T)
      (coverMap (k := k) (k' := k') T) = p₁ := pullback.lift_fst _ _ _
  have h2' : l ≫ pullback.snd (coverMap (k := k) (k' := k') T)
      (coverMap (k := k) (k' := k') T) = p₂ := pullback.lift_snd _ _ _
  calc (picEt C).map p₁.op x
      = (picEt C).map (l ≫ pullback.fst (coverMap (k := k) (k' := k') T)
          (coverMap (k := k) (k' := k') T)).op x := by rw [h1]
    _ = (picEt C).map l.op ((picEt C).map (pullback.fst
          (coverMap (k := k) (k' := k') T) (coverMap (k := k) (k' := k') T)).op x) := by
          simp only [op_comp, Functor.map_comp, CategoryTheory.comp_apply]
    _ = (picEt C).map l.op ((picEt C).map (pullback.snd
          (coverMap (k := k) (k' := k') T) (coverMap (k := k) (k' := k') T)).op x) := by
          rw [h2]
    _ = (picEt C).map (l ≫ pullback.snd (coverMap (k := k) (k' := k') T)
          (coverMap (k := k) (k' := k') T)).op x := by
          simp only [op_comp, Functor.map_comp, CategoryTheory.comp_apply]
    _ = (picEt C).map p₂.op x := by rw [h2']

end Probe
