---
author: sync
content_type: theorem
created: '2026-07-25T21:02:32'
decl: AlgebraicGeometry.Scheme.LocalEquations.forall_fibre_closure_subset_of_supportLeak_inter_eq_empty
docstring: '**Leak-freeness over a base open gives the assembler''s fibrewise clause
  there.** If no

  point over the base set `V` leaks out of `U`, then for every base point `s ∈ V`
  the fibre of

  the closure of the *restricted* trace stays in `U`.


  This is the bridge from the closed-image mechanism to the shape

  `finite_colength_of_forall_fibre_closure_subset` consumes: the closure is taken
  of the trace

  restricted over `V`, which only shrinks it, so a leak would have to be a leak of
  the

  unrestricted trace.'
file: AlgebraicJacobian/Picard/DivSchemeCertZarLeak.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.LocalEquations.forall_fibre_closure_subset_of_supportLeak_inter_eq_empty
type: lean
updated: '2026-07-30T15:27:58'
---
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

/-! ## No-leak IS the Z-clopen condition

The recorded design constraint of this project (memory I-0209, "the Z-clopen certificate
principle") says a piece carries an `R`-finite colength exactly when its trace on the divisor
scheme is *clopen* in that scheme.  The following two lemmas identify that principle with the
leak locus, so the two vocabularies are the same statement:

the piece trace `supp ∩ U` is always **open** in the subspace `supp` (as `U` is open), so it
is clopen there precisely when it is closed in the ambient space — precisely when nothing
leaks. -/