---
author: sync
content_type: definition
created: '2026-08-28T00:07:20'
decl: StacksPart08.FamilyOfCurves.reindex
docstring: 'Reindex the geometric fibres of a family along a map of indexing types.


  The geometric data of the family (flatness, properness, finite presentation,

  and the nodal and connectedness conditions) is unchanged.  The fibrewise

  invariants are pulled back along `g`.  This is the abstract form of base

  change used by the stability definitions in this file.'
file: StacksPart08Lib/ModuliCurves.lean
generated: lean
lean_status: lean_ok
title: StacksPart08.FamilyOfCurves.reindex
type: lean
updated: '2026-08-28T00:07:20'
---
def FamilyOfCurves.reindex {GeometricFiber : Type u} {J : Type v}
    (f : FamilyOfCurves GeometricFiber) (g : J → GeometricFiber) :
    FamilyOfCurves J where
  isFlat := f.isFlat
  isProper := f.isProper
  isOfFinitePresentation := f.isOfFinitePresentation
  hasRelativeDimensionAtMostOne := f.hasRelativeDimensionAtMostOne
  atWorstNodalOfRelativeDimensionOne := f.atWorstNodalOfRelativeDimensionOne
  pushforwardStructureSheafUniversallyTrivial :=
    f.pushforwardStructureSheafUniversallyTrivial
  genus := fun j => f.genus (g j)
  hasRationalTail := fun j => f.hasRationalTail (g j)
  hasRationalBridge := fun j => f.hasRationalBridge (g j)

@[simp]