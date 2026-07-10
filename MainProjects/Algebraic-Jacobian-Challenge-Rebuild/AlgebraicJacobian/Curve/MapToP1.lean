/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Curve.P1Charts

/-!
# A finite morphism from the curve to the projective line

For the smooth, proper, geometrically irreducible curve `C` over `k`, this file is about the
existence and the basic consequences of a **finite** `k`-morphism `π : C ⟶ ℙ¹`.

## Contents

* `AlgebraicGeometry.IsFinite.of_locallyQuasiFinite_of_comp` — the general Zariski-main-theorem
  reduction: a locally quasi-finite morphism which is proper over a separated base is finite.
* `AlgebraicGeometry.isFinite_toP1_of_locallyQuasiFinite` — the specialization: a locally
  quasi-finite `k`-morphism from the proper curve `C` to `ℙ¹` is finite.
* `AlgebraicGeometry.exists_isFinite_toP1_of_locallyQuasiFinite` — the same, in existential
  form: to produce a finite `π : C ⟶ ℙ¹` over `k` it suffices to produce a locally
  quasi-finite one.
* Preimage bookkeeping for a finite `π`, consumed by the two-lattice finiteness argument for
  `H¹(C, 𝒪_C)`: the preimages of the two standard charts are affine opens covering `C`
  (`isAffineOpen_preimage_chartOpen`, `preimage_chartOpen_sup`), and the section ring of each
  preimage is module-finite over the section ring of the chart (`finite_app_chartOpen`).
* `AlgebraicGeometry.exists_isFinite_toP1` — the **existence** of a finite `π : C ⟶ ℙ¹` over
  `k`. This is the one remaining `sorry` of this file; see its docstring for the intended
  proof route.
-/

set_option autoImplicit false

universe u

open CategoryTheory MvPolynomial

namespace AlgebraicGeometry

/-- **Zariski's main theorem, cancellation form**: a locally quasi-finite morphism `π` such
that `π ≫ g` is proper and `g` is separated is finite. (Properness of `π` follows by
cancellation, and a proper locally quasi-finite morphism is finite.) -/
theorem IsFinite.of_locallyQuasiFinite_of_comp {X Y S : Scheme.{u}}
    (π : X ⟶ Y) (g : Y ⟶ S) [LocallyQuasiFinite π] [IsSeparated g] [IsProper (π ≫ g)] :
    IsFinite π :=
  have : IsProper π := IsProper.of_comp π g
  IsFinite.of_isProper_of_locallyQuasiFinite π

variable {k : Type u} [Field k]

section ZMT

variable {X : Scheme.{u}}

/-- A locally quasi-finite `k`-morphism from a scheme which is proper over `k` to the
projective line is finite. This is the Zariski-main-theorem half of the construction of the
finite map `C ⟶ ℙ¹`: it reduces finiteness to local quasi-finiteness. -/
theorem isFinite_toP1_of_locallyQuasiFinite (f : X ⟶ Spec (.of k)) [IsProper f]
    (π : X ⟶ P1 k) [LocallyQuasiFinite π] (hπ : π ≫ P1.structureMap k = f) :
    IsFinite π :=
  have : IsProper (π ≫ P1.structureMap k) := hπ ▸ inferInstance
  IsFinite.of_locallyQuasiFinite_of_comp π (P1.structureMap k)

end ZMT

/-- To produce a finite `k`-morphism `C ⟶ ℙ¹` it suffices to produce a locally quasi-finite
one; Zariski's main theorem upgrades it. -/
theorem exists_isFinite_toP1_of_locallyQuasiFinite {C : Over (Spec (.of k))} [IsProper C.hom]
    (h : ∃ π : C.left ⟶ P1 k, LocallyQuasiFinite π ∧ π ≫ P1.structureMap k = C.hom) :
    ∃ π : C.left ⟶ P1 k, IsFinite π ∧ π ≫ P1.structureMap k = C.hom := by
  obtain ⟨π, hqf, hcomp⟩ := h
  exact ⟨π, isFinite_toP1_of_locallyQuasiFinite C.hom π hcomp, hcomp⟩

variable {C : Over (Spec (.of k))}
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- **Existence of a finite map to the projective line**: on the smooth, proper,
geometrically irreducible curve `C/k` there is a finite `k`-morphism `π : C ⟶ ℙ¹`.

This is the keystone the two-lattice finiteness argument for `H¹(C, 𝒪_C)` consumes.

Intended proof route (see `informal/route-decision.md`, Wave 1 item 4):
1. produce a rational function on `C` transcendental over `k` (an affine chart of the
   relative-dimension-1 smooth curve has a section ring of Krull dimension 1, which cannot be
   algebraic over `k`); this consumes `GeometricallyReduced C.hom`/integrality of `C`, which
   another Wave-1 lane derives from smoothness;
2. extend the rational function to a morphism `π : C ⟶ ℙ¹` over `k` using that the local
   rings of `C` at codimension-one points are valuation rings (DVRs): at each point either
   `f` or `1/f` is regular, giving maps to the two charts of `P1 k` which glue;
3. `π` is nonconstant, hence (fibers are proper closed subschemes of the curve not equal to
   it) has finite fibers, hence is locally quasi-finite;
4. conclude with `exists_isFinite_toP1_of_locallyQuasiFinite` (Zariski's main theorem).

Only steps 1–3 remain. -/
theorem exists_isFinite_toP1 :
    ∃ π : C.left ⟶ P1 k, IsFinite π ∧ π ≫ P1.structureMap k = C.hom := by
  sorry

/-! ### Preimage bookkeeping for a finite morphism to the projective line

The next wave feeds these to the two-lattice/Mayer–Vietoris finiteness argument: the
preimages of the two standard charts form an affine cover of `C`, with section rings
module-finite over `k[t]`. Everything here only needs `π` finite (indeed mostly just
affine), not how it was constructed. -/

section Preimages

variable {Y : Scheme.{u}} (π : Y ⟶ P1 k)

/-- The preimage of each standard chart of `ℙ¹` under an affine (e.g. finite) morphism is an
affine open. -/
theorem isAffineOpen_preimage_chartOpen [IsAffineHom π] (i : Fin 2) :
    IsAffineOpen (π ⁻¹ᵁ P1.chartOpen k i) :=
  (P1.isAffineOpen_chartOpen k i).preimage π

/-- The preimages of the two standard charts of `ℙ¹` cover the source. -/
theorem preimage_chartOpen_sup :
    π ⁻¹ᵁ P1.chartOpen k 0 ⊔ π ⁻¹ᵁ P1.chartOpen k 1 = ⊤ := by
  refine le_antisymm le_top fun x _ => ?_
  have h : π.base x ∈ P1.chartOpen k 0 ⊔ P1.chartOpen k 1 := by
    rw [P1.chartOpen_sup]
    trivial
  rw [TopologicalSpace.Opens.mem_sup] at h ⊢
  exact h

/-- For a finite morphism `π : X ⟶ ℙ¹`, the section ring of the preimage of a standard chart
is module-finite over the section ring of the chart (that is, over `k[t]`, via
`P1.chartSectionsEquiv₀`/`₁`). -/
theorem finite_app_chartOpen [IsFinite π] (i : Fin 2) :
    RingHom.Finite (π.app (P1.chartOpen k i)).hom :=
  π.finite_app _ (P1.isAffineOpen_chartOpen k i)

/-- For a finite morphism `π : X ⟶ ℙ¹`, the section ring of the preimage of the chart
overlap is module-finite over the section ring of the overlap (that is, over the Laurent
polynomial ring, via `P1.overlapSectionsEquiv`). -/
theorem finite_app_overlap [IsFinite π] :
    RingHom.Finite (π.app (Proj.basicOpen (homogeneousSubmodule (Fin 2) k)
      (X 0 * X 1))).hom :=
  π.finite_app _ (P1.isAffineOpen_overlap k)

end Preimages

end AlgebraicGeometry
