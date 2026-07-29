import AlgebraicJacobian.Picard.Pic0ThetaAssembly
import AlgebraicJacobian.Picard.Pic0Pullback

set_option autoImplicit false
universe u
open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

section Identity

variable (k : Type u) [Field k]
variable (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

noncomputable def mIdσ :
    Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k))) ≅ 𝟭 (Over (Spec (.of k))) :=
  eqToIso (by rw [show Spec.map (CommRingCat.ofHom (algebraMap k k)) = 𝟙 _ by
    rw [Algebra.algebraMap_self, CommRingCat.ofHom_id, Spec.map_id]]) ≪≫ Over.mapId _

/-- THE ATOM as the file states it (the scheme identity fed to picEtAffHom_congr):
`(crossBaseAffineIso k k C B).inv = ((baseChange.idIso k).app C).inv ▷ overSpec k B).left`.
Test 1: does it even typecheck? -/
example (B : Type u) [CommRing B] [Algebra k B] : True := by
  let _lhs := (crossBaseAffineIso k k C B).inv
  trivial

/-- Test 2: the two projections of the claimed atom, as the file's plan describes them. -/
example (B : Type u) [CommRing B] [Algebra k B] :
    (crossBaseAffineIso k k C B).inv ≫ (snd ((baseChange k k).obj C) (overSpec k B)).left
      = (snd C (overSpec k B)).left :=
  crossBaseAffineIso_inv_snd k k C B

/-- Test 3: is the whole `mIdσ` component the carrier identity, as the plan asserts? -/
example (T : Over (Spec (.of k))) : ((mIdσ k).hom.app T).left = eqToHom (by rw [show
    Spec.map (CommRingCat.ofHom (algebraMap k k)) = 𝟙 _ by
      rw [Algebra.algebraMap_self, CommRingCat.ofHom_id, Spec.map_id]]) := by
  sorry

end Identity

end AlgebraicGeometry
