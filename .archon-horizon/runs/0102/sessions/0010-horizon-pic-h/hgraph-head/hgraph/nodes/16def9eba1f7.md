---
author: sync
content_type: theorem
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.Scheme.ordZ_support_finite
docstring: '**Finite support of the order.**  For a unit `g` of the function field,
  the closed points

  where the order of `g` is nontrivial form a finite set: `g` is represented by a
  section `s` on a

  nonempty open `U ∋ η`, and every closed point of `X.basicOpen s` has trivial order,
  so the

  nontrivial locus lies in the closed set `(X.basicOpen s)ᶜ`, which avoids `η` and
  is finite on

  the Noetherian curve.'
file: AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.ordZ_support_finite
type: lean
updated: '2026-08-01T09:44:18'
---
theorem Scheme.ordZ_support_finite (f : X ⟶ Spec (CommRingCat.of K))
    [SmoothOfRelativeDimension 1 f] [IsIntegral X] [LocallyOfFiniteType f] [QuasiCompact f]
    (g : X.functionFieldˣ) :
    {p : {x : X // x ≠ genericPoint X} | Scheme.ordZ f p.2 g ≠ 1}.Finite := by
  haveI : IsLocallyNoetherian X := LocallyOfFiniteType.isLocallyNoetherian f
  haveI : CompactSpace X := QuasiCompact.compactSpace_of_compactSpace f
  haveI : IsNoetherian X := ⟨⟩
  obtain ⟨U, hηU, s, hs⟩ := X.presheaf.exists_germ_eq (g : X.functionField)
  have hη_basic : genericPoint X ∈ X.basicOpen s := by
    rw [X.mem_basicOpen s (genericPoint X) hηU, hs]
    exact g.isUnit
  have hZ : ((X.basicOpen s : Set X)ᶜ).Finite := by
    refine Scheme.finite_of_isClosed_of_notMem_genericPoint
      (fun _ _ h => SmoothOfRelativeDimension.specializes_eq_genericPoint_or_eq f h)
      (X.basicOpen s).isOpen.isClosed_compl ?_
    simpa using hη_basic
  refine (hZ.preimage (Subtype.val_injective.injOn)).subset ?_
  intro p hp
  rw [Set.mem_preimage, Set.mem_compl_iff]
  intro hmem
  apply hp
  rw [Scheme.ordZ_eq_one_iff, ← hs]
  exact Scheme.ord_eq_one_of_mem_basicOpen f p.2 s hηU hmem