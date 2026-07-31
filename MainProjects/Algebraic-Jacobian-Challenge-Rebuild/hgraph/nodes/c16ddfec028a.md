---
author: sync
content_type: theorem
created: '2026-07-31T04:42:48'
decl: AlgebraicGeometry.sectionsAlgebra_mapSelf_eq
docstring: 'At the identity extension, the section algebra of a pushed test is the
  original

  section algebra.'
file: AlgebraicJacobian/Picard/Pic0ThetaCocycleIdentity.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.sectionsAlgebra_mapSelf_eq
type: lean
updated: '2026-07-31T20:14:50'
---
theorem sectionsAlgebra_mapSelf_eq (T : Over (Spec (.of k))) (U : T.left.Opens) :
    Over.sectionsAlgebra
        ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).obj T) U =
      Over.sectionsAlgebra T U := by
  exact algebra_eq_of_self_tower k
    (Over.sectionsAlgebra T U)
    (Over.sectionsAlgebra
      ((Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k)))).obj T) U)
    (Over.isScalarTower_sections_map k k T U)

set_option linter.overlappingInstances false in
-- The transport core intentionally records the domain, codomain, and tower algebra slots.