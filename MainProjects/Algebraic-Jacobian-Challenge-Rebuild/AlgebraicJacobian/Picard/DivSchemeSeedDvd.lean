/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivSchemeSeed
import AlgebraicJacobian.Picard.DivSchemeRelDivisor

/-!
# DD-4 — the `hdvd` reduction: divisibility from fibre vanishing (links 1+3 assembled)

The divisor-first `hdvd` (`IsGenerator.dvd`, the Nakayama-neighbourhood clause) reduced to
its single honest input — **link 2**, the fibre-vanishing `N ⊗ κ(p) = 0` at every base
point.  Everything else (the germwise closer, the local-ring unit descent) is discharged
here from landed engines:

* `Scheme.mem_span_singleton_of_forall_germ` (`Picard/DivisorStalkIdeal.lean`) reduces the
  global membership on the piece to a germ-level membership at every point;
* at a point `y` the germ lands in the **local ring** stalk `𝒪_y`, so the
  `Picard/DivSchemeRelDivisor.lean` stalk-form consumer
  `mem_span_singleton_map_of_subsingleton_tmul_residueField_localRing` discharges the germ
  from the fibre vanishing at the base point `basePrime (germ_y)` — no structure-map
  geometry, the local ring supplies the unit descent (link 3);
* germ regularity of the equation (the germ closer's `hb`) is the seed's fibre-regularity
  law, supplied as `hreg` (the P-fib nonvanishing route of `isGenerator_of_fibre_ne_zero`).

The submodule `N z = sideColengthSubmodule` is the honest **image of the `K`-side
components** in the colength `Γ(D(h z)) ⧸ (eqn z)`; `hdvd` says it is the zero submodule,
which the Nakayama neighbourhood delivers from `N z ⊗ κ(p) = 0` at every base point.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k} [IsFinite π] {a : ℕ}
variable {K : Submodule R (relThetaSections C R π a)}

namespace ThetaGeneratorSeed

variable (D : ThetaGeneratorSeed C R π a K)

/-- The `R`-linear map sending a global theta section to the class of its side component
in the colength `Γ(D(h z)) ⧸ (eqn z)`. -/
noncomputable def kColengthMap (z : relCurve C R) :
    relThetaSections C R π a →ₗ[R]
      (Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z}) :=
  (Ideal.Quotient.mkₐ R (Ideal.span {D.eqn z})).toLinearMap.comp
    (relThetaResSide a (D.side z) (D.piece_le z))

/-- **The `K`-side-component submodule `N z`** of the colength: the image of `K` under the
map "side component, then mod `eqn z`".  `hdvd` at `z` is exactly `N z = 0`. -/
noncomputable def sideColengthSubmodule (z : relCurve C R) :
    Submodule R (Γ(relCurve C R, D.piece z) ⧸ Ideal.span {D.eqn z}) :=
  Submodule.map (D.kColengthMap z) K

lemma mk_relThetaResSide_mem_sideColengthSubmodule (z : relCurve C R)
    {ψ : relThetaSections C R π a} (hψ : ψ ∈ K) :
    Ideal.Quotient.mk (Ideal.span {D.eqn z})
        (relThetaResSide a (D.side z) (D.piece_le z) ψ) ∈ D.sideColengthSubmodule z :=
  ⟨ψ, hψ, rfl⟩

/-- **The `hdvd` reduction**: the seed satisfies its divisibility clause as soon as, at
every point `y` of every piece `D(h z)`,
* `hreg` — the germ of the equation is a nonzerodivisor (the fibre-regularity law), and
* `hfib` — the fibre `N z ⊗ κ(basePrime germ_y) = 0` vanishes (**link 2**), with `N z`
  finite over `R` (**link 1**, `hfin`).

The germ closer glues the pointwise memberships; each is the stalk-form Nakayama descent. -/
theorem dvd_of_forall_subsingleton_tmul_residueField
    (hreg : ∀ (z : relCurve C R) (y : relCurve C R) (hy : y ∈ D.piece z),
      ((relCurve C R).presheaf.germ (D.piece z) y hy).hom (D.eqn z)
        ∈ nonZeroDivisors ((relCurve C R).presheaf.stalk y))
    (hfin : ∀ z : relCurve C R, Module.Finite R (D.sideColengthSubmodule z))
    (hfib : ∀ (z : relCurve C R) (y : relCurve C R) (hy : y ∈ D.piece z),
      Subsingleton (↥(D.sideColengthSubmodule z) ⊗[R]
        (basePrime (R := R)
          ((relCurve C R).presheaf.germ (D.piece z) y hy).hom).asIdeal.ResidueField)) :
    ∀ (z : relCurve C R) ⦃ψ : relThetaSections C R π a⦄, ψ ∈ K →
      relThetaResSide a (D.side z) (D.piece_le z) ψ ∈ Ideal.span {D.eqn z} := by
  intro z ψ hψ
  refine Scheme.mem_span_singleton_of_forall_germ (fun y hy => hreg z y hy)
    (fun y hy => ?_)
  haveI := hfin z
  exact mem_span_singleton_map_of_subsingleton_tmul_residueField_localRing
    ((relCurve C R).presheaf.germ (D.piece z) y hy).hom (D.sideColengthSubmodule z)
    (hfib z y hy) (D.mk_relThetaResSide_mem_sideColengthSubmodule z hψ)

end ThetaGeneratorSeed

end AlgebraicGeometry
