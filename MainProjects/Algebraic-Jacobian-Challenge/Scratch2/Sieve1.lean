import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentAssembly

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme

universe u

namespace Probe

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']

/-- The slice-generated singleton sieve on `coverMap` EQUALS the `overEquiv`-pullback
of the scheme-level generated sieve on `pullback.fst`. -/
example (T : Over (Spec (CommRingCat.of k))) :
    Sieve.generate (Presieve.singleton (coverMap (k := k) (k' := k') T)) =
      (Sieve.overEquiv T).symm
        (Sieve.generate (Presieve.singleton
          (pullback.fst T.hom (specMapAlgebra k k')))) := by
  ext W g
  constructor
  · rintro ⟨Z, a, b, hb, hfac⟩
    cases hb
    rw [Sieve.overEquiv_symm_iff]
    refine ⟨_, a.left, _, Presieve.singleton.mk, ?_⟩
    rw [← hfac]
    rfl
  · intro hg
    rw [Sieve.overEquiv_symm_iff] at hg
    obtain ⟨Z, a, b, hb, hfac⟩ := hg
    cases hb
    refine ⟨_, Over.homMk a (by
      rw [← Over.w g]
      simp only [restrictTest, Over.map_obj_hom, baseTest, Over.mk_hom, ← hfac]
      rw [Category.assoc]
      exact congrArg (a ≫ ·) pullback.condition.symm), coverMap (k' := k') T,
      Presieve.singleton.mk, ?_⟩
    apply Over.OverMorphism.ext
    change a ≫ pullback.fst T.hom (specMapAlgebra k k') = Over.Hom.left g
    exact hfac

end Probe
