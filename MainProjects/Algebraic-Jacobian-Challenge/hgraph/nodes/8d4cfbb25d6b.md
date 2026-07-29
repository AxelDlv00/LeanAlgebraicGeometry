---
author: sync
content_type: theorem
created: '2026-07-29T23:31:11'
decl: AlgebraicGeometry.Scheme.Pic0Et.isAbelianVariety_of_baseChange
docstring: '**`Pic⁰_{C/k}` is an abelian variety, from two single-scheme inputs over
  `k̄`.**


  The étale counterpart of `Scheme.Pic0.isAbelianVariety`, which is stated under

  `[HasPicScheme C]` — a class with no instance, hence about no curve. This version
  is

  stated on `Pic0SchemeEt C`, the object `picardJacobianWitness` uses.


  Two of the four conjuncts (`GeometricallyIrreducible`, `Nonempty (GrpObj …)`) are

  unconditional theorems of `Pic0Et.lean`. The other two are supplied by the two

  hypotheses, which are exactly the residues isolated above:


  * `hred : IsReduced (Pic⁰ ×_{Spec k} Spec k̄)` — Kleiman §5 `cor:sm`;

  * `huc : UniversallyClosed (Pic⁰ ×_{Spec k} Spec k̄)` — Kleiman §5 `th:qpp&p`.


  Both are **hypotheses**: this is the assembly, not a discharge, and no curve is

  exhibited for which either holds.'
file: AlgebraicJacobian/Picard/Pic0EtStructure.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0Et.isAbelianVariety_of_baseChange
type: lean
updated: '2026-07-29T23:31:11'
---
theorem isAbelianVariety_of_baseChange
    (hred : IsReduced (Limits.pullback (Pic0SchemeEt C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k))))))
    (huc : UniversallyClosed (Limits.pullback.snd (Pic0SchemeEt C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k)))))) :
    IsProper (Pic0SchemeEt C).hom ∧ Smooth (Pic0SchemeEt C).hom ∧
      GeometricallyIrreducible (Pic0SchemeEt C).hom ∧
      Nonempty (GrpObj (Pic0SchemeEt C)) :=
  ⟨proper_of_baseChange C huc, smooth_of_isReduced_algebraicClosureBaseChange C hred,
    geometricallyIrreducible C, grpObj C⟩