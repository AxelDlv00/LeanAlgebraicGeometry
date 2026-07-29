---
author: sync
content_type: theorem
created: '2026-07-30T03:33:55'
decl: AlgebraicGeometry.Scheme.Pic0Et.universallyClosed_of_universally_specializing
docstring: 'Universal closedness from specialization-lifting on **every** base change.


  This is `ValuativeCriterion.Existence.eq` composed with the free `QuasiCompact`

  (`Pic0Et.quasiCompact`), so it needs no valuation rings. It is **not** a

  reduction — see `universally_specializing_of_universallyClosed` for the converse,

  which makes the pair an equivalence.'
file: AlgebraicJacobian/Picard/Pic0EtProperImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0Et.universallyClosed_of_universally_specializing
type: lean
updated: '2026-07-30T03:33:55'
---
theorem universallyClosed_of_universally_specializing
    (h : ∀ {T : Scheme.{u}} (g : T ⟶ Spec (.of k)),
      SpecializingMap (pullback.fst g (Pic0SchemeEt C).hom).base) :
    UniversallyClosed (Pic0SchemeEt C).hom := by
  haveI := quasiCompact C
  refine UniversallyClosed.of_valuativeCriterion _ ?_
  rw [ValuativeCriterion.Existence.eq]
  exact MorphismProperty.universally_mk' _ _ (fun {T} g _ => h g)