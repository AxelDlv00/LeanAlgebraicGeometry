---
author: sync
content_type: definition
created: '2026-07-17T10:31:28'
decl: AlgebraicGeometry.FinCoverData.baseChange
docstring: '**Base change of the `Fin`-indexed cover data** along `R → R''`: the generators
  and

  partition coefficients push forward through the sections comparison `relSectionsMap`;
  the

  partition witnesses are carried by `map_sum`/`map_mul`/`map_one` (the `Fin`-indexed
  mirror

  of `BasicOpenCoverData.baseChange`).'
file: AlgebraicJacobian/Picard/DivisorFamilyPullback.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.FinCoverData.baseChange
type: lean
updated: '2026-07-29T15:26:35'
---
noncomputable def baseChange : FinCoverData C R' π where
  m₀ := D.m₀
  m₁ := D.m₁
  h₀ j := relSectionsMap C R R' (fiberChart₀ π) (D.h₀ j)
  h₁ j := relSectionsMap C R R' (fiberChart₁ π) (D.h₁ j)
  a₀ j := relSectionsMap C R R' (fiberChart₀ π) (D.a₀ j)
  a₁ j := relSectionsMap C R R' (fiberChart₁ π) (D.a₁ j)
  partition₀ := by
    have h := congrArg (relSectionsMap C R R' (fiberChart₀ π)) D.partition₀
    rw [map_sum, map_one] at h
    rw [← h]
    exact Finset.sum_congr rfl fun j _ => (map_mul _ _ _).symm
  partition₁ := by
    have h := congrArg (relSectionsMap C R R' (fiberChart₁ π)) D.partition₁
    rw [map_sum, map_one] at h
    rw [← h]
    exact Finset.sum_congr rfl fun j _ => (map_mul _ _ _).symm

@[simp]