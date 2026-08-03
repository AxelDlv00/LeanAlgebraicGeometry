---
author: sync
content_type: definition
created: '2026-08-03T14:01:22'
decl: AlgebraicGeometry.Grassmannian.PluckerIndex
docstring: The Plucker coordinates, indexed by the `d`-subsets of `Fin r`.
file: AlgebraicJacobian/Projective/GrassmannianPlucker.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.PluckerIndex
type: lean
updated: '2026-08-03T14:01:22'
---
abbrev PluckerIndex (d r : ℕ) := {I : Finset (Fin r) // I.card = d}