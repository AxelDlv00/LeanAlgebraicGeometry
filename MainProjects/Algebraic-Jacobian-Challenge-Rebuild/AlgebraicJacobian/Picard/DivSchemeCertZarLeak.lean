/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Picard.DivSchemeCertZarSep

/-!
# No-leak over a shrunken base, with no fibre hypothesis

The certificate assemblers consume, per piece `j`, the fibrewise clause

`∀ s, (fibre over s) ∩ closure (supp ∩ pieces j) ⊆ pieces j`

(`isCertified_of_noLeak_kernel_spanning`), equivalently emptiness of the **leak locus**
`supportLeak (pieces j) = closure (supp ∩ pieces j) \ pieces j`
(`Scheme.LocalEquations.isClosed_supportLocus_inter_iff_supportLeak_eq_empty`).

The `tube-fibre` leaf of the DD-R lane tried to obtain this by putting the whole support
inside a single piece.  That shape is refuted — `DivSchemeCertZarSep.lean`,
`not_exists_unique_support_piece`: both pinned charts carry a partition of unity, so a
support point of `V₀ ⊓ V₁` always lies in two distinct pieces.

This file gets the clause a different way, and **without any fibre analysis**.  The leak
locus is closed, and under a universally closed structure morphism its base image is closed
too (`isClosed_image_supportLeak`).  So:

* over the *open complement* of that base image, nothing leaks;
* that complement is a Zariski neighbourhood of every base point it contains, refinable to a
  basic open — the `Localization.Away` shape the pointwise gate consumes.

The leak locus is a genuine obstruction only over its own base image, which is a **closed**
subset of `Spec R`. So the no-leak clause is available on a Zariski-dense open of the base
for free; what a fibre analysis is still needed for is the base points *inside* that closed
image.

## Main declarations

* `AlgebraicGeometry.Scheme.LocalEquations.exists_basicOpen_supportLeak_eq_empty` — a basic
  open around any base point outside the leak's image, over which nothing leaks.
* `Scheme.LocalEquations.forall_fibre_closure_subset_of_supportLeak_inter_eq_empty` —
  leak-freeness over an open of the base gives the assembler's fibrewise clause there.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

namespace Scheme.LocalEquations

variable {X : Scheme.{u}} {R : Type u} [CommRing R] (d : X.LocalEquations)

/-- **A leak-free basic open around any base point outside the leak's image.** The leak
locus is closed and its base image is closed under a universally closed morphism, so the
complement is open; refining it to a basic open (`PrimeSpectrum.isTopologicalBasis_basic_opens`)
gives the `Localization.Away` shape the pointwise certificate gate consumes. -/
theorem exists_basicOpen_supportLeak_eq_empty (f : X ⟶ Spec (CommRingCat.of R))
    [UniversallyClosed f] (U : X.Opens) {p : PrimeSpectrum R}
    (hp : (p : Spec (CommRingCat.of R)) ∉ f.base '' d.supportLeak U) :
    ∃ r : R, r ∉ p.asIdeal ∧
      f.base ⁻¹' (PrimeSpectrum.basicOpen r : Set (PrimeSpectrum R))
        ∩ d.supportLeak U = ∅ := by
  classical
  have hopen : IsOpen ((f.base '' d.supportLeak U)ᶜ) :=
    (d.isClosed_image_supportLeak f U).isOpen_compl
  obtain ⟨W, hWmem, hpW, hWsub⟩ :=
    PrimeSpectrum.isTopologicalBasis_basic_opens.exists_subset_of_mem_open
      (a := p) hp hopen
  obtain ⟨r, rfl⟩ := hWmem
  refine ⟨r, (PrimeSpectrum.mem_basicOpen r p).mp hpW, ?_⟩
  rw [Set.eq_empty_iff_forall_notMem]
  rintro x ⟨hxb, hxl⟩
  exact hWsub hxb ⟨x, hxl, rfl⟩

/-- **Leak-freeness over a base open gives the assembler's fibrewise clause there.** If no
point over the base set `V` leaks out of `U`, then for every base point `s ∈ V` the fibre of
the closure of the *restricted* trace stays in `U`.

This is the bridge from the closed-image mechanism to the shape
`finite_colength_of_forall_fibre_closure_subset` consumes: the closure is taken of the trace
restricted over `V`, which only shrinks it, so a leak would have to be a leak of the
unrestricted trace. -/
theorem forall_fibre_closure_subset_of_supportLeak_inter_eq_empty
    (f : X ⟶ Spec (CommRingCat.of R)) (U : X.Opens) {V : Set (Spec (CommRingCat.of R))}
    (hV : f.base ⁻¹' V ∩ d.supportLeak U = ∅) :
    ∀ s ∈ V, f.base ⁻¹' {s}
        ∩ closure (d.supportLocus ∩ (U : Set X) ∩ f.base ⁻¹' V)
      ⊆ (U : Set X) := by
  intro s hs x hx
  by_contra hxU
  -- `x` is in the closure of the full trace, and outside `U`, hence a leak
  have hcl : x ∈ closure (d.supportLocus ∩ (U : Set X)) :=
    closure_mono Set.inter_subset_left hx.2
  have hxV : x ∈ f.base ⁻¹' V := by
    have : f.base x = s := hx.1
    rw [Set.mem_preimage, this]; exact hs
  exact Set.eq_empty_iff_forall_notMem.mp hV x ⟨hxV, hcl, hxU⟩

end Scheme.LocalEquations

end AlgebraicGeometry
