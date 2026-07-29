---
author: sync
content_type: theorem
created: '2026-07-30T00:50:57'
decl: AlgebraicGeometry.Scheme.Pic0Et.valuativeCriterion_existence_of_specializingMap
docstring: '**A purely topological route to the properness residue.**

  `ValuativeCriterion.Existence.of_specializingMap`: universal specialization-lifting
  of

  the underlying continuous map suffices. Recorded because it needs no valuation rings
  and

  no invertible-sheaf extension argument — it is a statement about the topology of

  `Pic⁰_{C/k}` — and is therefore a genuinely different attack on the same obligation.'
file: AlgebraicJacobian/Picard/Pic0EtStructure.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0Et.valuativeCriterion_existence_of_specializingMap
type: lean
updated: '2026-07-30T00:50:57'
---
theorem valuativeCriterion_existence_of_specializingMap
    (h : (topologically @SpecializingMap).universally (Pic0SchemeEt C).hom) :
    ValuativeCriterion.Existence (Pic0SchemeEt C).hom :=
  ValuativeCriterion.Existence.of_specializingMap _ h