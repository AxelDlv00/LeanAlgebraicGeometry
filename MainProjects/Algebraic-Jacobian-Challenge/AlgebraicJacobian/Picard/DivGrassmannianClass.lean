/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivPushforwardFlat
import AlgebraicJacobian.Picard.GrassmannianRepresentability

/-!
# Core divisor-to-Grassmannian classifying objects

This file contains the small representation-facing core of D2: the twisted
divisor sheaf, its evaluation map, and the resulting locally free quotient and
Grassmannian class.  The longer analytic proofs live in
`DivGrassmannianEmbedding`; keeping this core separate lets the D3 universal
candidate import it without recompiling that large module.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

namespace AlgebraicGeometry

namespace Scheme

namespace DivFamily

variable {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S}

/-- The twist of the divisor structure sheaf by a module on the original
family.  For the D2 embedding, `L` is the chosen sufficiently positive
projective twist. -/
noncomputable def twist (L : X.Modules) (x : DivFamily π T) :
    (pullback π T.hom).Modules :=
  Modules.tensorObj ((Modules.pullback (pullback.fst π T.hom)).obj L) x.F

/-- Tensor the divisor quotient `O -> O_D` with the pulled-back twist. -/
noncomputable def twistQuotientMap (L : X.Modules) (x : DivFamily π T) :
    (Modules.pullback (pullback.fst π T.hom)).obj L ⟶ x.twist L :=
  (Modules.tensorObj_right_unitor _).inv ≫
    Modules.tensorObj_functoriality (𝟙 _)
      ((Modules.pullbackUnitIso (pullback.fst π T.hom)).inv ≫ x.q)

/-- The canonical D2 evaluation morphism.  It first base-changes `π_* L`
from `S` to `T`, then pushes forward the twisted divisor quotient along
`X_T -> T`. -/
noncomputable def grassmannianEval (L : X.Modules) (x : DivFamily π T) :
    (Modules.pullback T.hom).obj ((Modules.pushforward π).obj L) ⟶
      (Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L) :=
  (canonicalBaseChangeMap (IsPullback.of_hasPullback π T.hom)).app L ≫
    (Modules.pushforward (pullback.snd π T.hom)).map (x.twistQuotientMap L)

/-- The evaluation map is epi when the pushed divisor quotient is epi.
The canonical base-change factor is an isomorphism by flat base change. -/
theorem grassmannianEval_epi (L : X.Modules) (x : DivFamily π T)
    [QuasiCompact π] [QuasiSeparated π] [Flat T.hom] [L.IsQuasicoherent]
    (hquot : Epi ((Modules.pushforward (pullback.snd π T.hom)).map
      (x.twistQuotientMap L))) :
    Epi (x.grassmannianEval L) := by
  haveI : IsIso ((canonicalBaseChangeMap
      (IsPullback.of_hasPullback π T.hom)).app L) :=
    canonicalBaseChangeMap_isIso (IsPullback.of_hasPullback π T.hom) L
  letI : Epi ((Modules.pushforward (pullback.snd π T.hom)).map
      (x.twistQuotientMap L)) := hquot
  dsimp [grassmannianEval]
  exact epi_comp'
    (inferInstance : Epi ((canonicalBaseChangeMap
      (IsPullback.of_hasPullback π T.hom)).app L))
    (inferInstance : Epi ((Modules.pushforward (pullback.snd π T.hom)).map
      (x.twistQuotientMap L)))

/-- Package the D2 evaluation as a rank-`d` locally free quotient. -/
noncomputable def grassmannianQuotient (L : X.Modules) (x : DivFamily π T)
    [IsLocallyNoetherian S] {d : ℕ} (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    LocallyFreeQuotient ((Modules.pushforward π).obj L) d T := by
  letI := hEpi
  exact {
    F := (Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)
    q := x.grassmannianEval L
    epi := inferInstance
    locFree := hLocFree }

/-- The quotient-class value of the D2 comparison in the relative
Grassmannian functor. -/
noncomputable def grassmannianClass (L : X.Modules) (x : DivFamily π T)
    [IsLocallyNoetherian S] {d : ℕ} (hEpi : Epi (x.grassmannianEval L))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    (Grassmannian ((Modules.pushforward π).obj L) d).obj (Opposite.op T) :=
  Quotient.mk _ (grassmannianQuotient L x hEpi hLocFree)

/-- The componentwise form of `grassmannianClass`: flat base change supplies
the first epi factor, so only the divisor quotient and target rank remain. -/
noncomputable def grassmannianClassOfComponents (L : X.Modules) (x : DivFamily π T)
    [IsLocallyNoetherian S] [QuasiCompact π] [QuasiSeparated π]
    [Flat T.hom] [L.IsQuasicoherent] {d : ℕ}
    (hquot : Epi ((Modules.pushforward (pullback.snd π T.hom)).map
      (x.twistQuotientMap L)))
    (hLocFree : SheafOfModules.IsLocallyFreeOfRank
      ((Modules.pushforward (pullback.snd π T.hom)).obj (x.twist L)) d) :
    (Grassmannian ((Modules.pushforward π).obj L) d).obj (Opposite.op T) :=
  grassmannianClass L x (grassmannianEval_epi L x hquot) hLocFree

end DivFamily

end Scheme

end AlgebraicGeometry
