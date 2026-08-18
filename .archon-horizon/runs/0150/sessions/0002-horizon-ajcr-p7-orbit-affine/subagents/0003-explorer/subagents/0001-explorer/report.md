Highest-signal findings:

- [IdentityComponent.lean:768](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/IdentityComponent.lean:768):
  ```lean
  theorem IdentityComponent.isSubgroupHomomorphism
      (G : Over (Spec (.of k))) [GrpObj G] [LocallyOfFiniteType G.hom] :
      Nonempty (GrpObj (IdentityComponent G))
  ```
- [IdentityComponent.lean:1374](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/IdentityComponent.lean:1374):
  ```lean
  theorem IdentityComponent.isFiniteTypeGeometricallyIrreducible
      (G : Over (Spec (.of k))) [GrpObj G] [LocallyOfFiniteType G.hom] :
      LocallyOfFiniteType (IdentityComponent G).hom ∧
      QuasiCompact (IdentityComponent G).hom ∧
      GeometricallyIrreducible (IdentityComponent G).hom
  ```
  These only apply after exhibiting the finite-stage glue as an `IdentityComponent`; no such identification exists.

- [Pic0Et.lean:100](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0Et.lean:100), [Pic0Et.lean:113](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0Et.lean:113), and [Pic0Et.lean:123](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0Et.lean:123) give respectively:
  ```lean
  Nonempty (GrpObj (Pic0SchemeEt C))
  GeometricallyIrreducible (Pic0SchemeEt C).hom
  LocallyOfFiniteType (Pic0SchemeEt C).hom
  ```
  They are object-specific and do not transport to `P.gluedOver` without an over-category iso.

- General group transport is available at [Grp.lean:237](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Monoidal/Grp.lean:237):
  ```lean
  CategoryTheory.GrpObj.ofIso (e : G ≅ X) : GrpObj X
  ```
  Thus an iso in `Over (Spec (.of P.N.1))` would solve the `GrpObj` slot. A raw scheme iso is insufficient.

- Alternatively, once a representation
  ```lean
  (pic0TypeFunctor ...).RepresentableBy P.gluedOver
  ```
  exists, [PicRepDatum.lean:113](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepDatum.lean:113) shows the direct construction:
  ```lean
  GrpObj.ofRepresentableBy d.J
    (pic0Functor C' ⋙ forget₂ CommGrpCat GrpCat) d.rep
  ```
  This avoids descending a group law.

Current finite-stage comparison is not enough:

- [Pic0FiniteStageGluedOver.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:39) defines only `P.gluedMap`; line 85 defines `P.gluedOver`.
- [Pic0FiniteStageGluingBaseChange.lean:37](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean:37) gives an iso from the base change of `P.glueData.glued` to the locally base-changed gluing.
- Line 52 gives chartwise isos to the exact Pic0 atlas. There is no landed global iso from that gluing to the exact representer. Mathlib’s final target is [Gluing.lean:350](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Gluing.lean:350), `OpenCover.fromGlued`, once the glue diagrams are compared.

`GroupAffineOpen` is circular for the requested structures:

- [GroupAffineOpen.lean:96](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean:96) and line 162 require
  ```lean
  [GrpObj G] [LocallyOfFiniteType G.hom] [IrreducibleSpace G.left]
  ```
  and only conclude affine-open containment/`Scheme.FiniteInAffine`. They produce none of those hypotheses.

Projective route:

- [Pic0FiniteStageOrbitAffine.lean:44](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:44) converts
  ```lean
  hproj : P.gluedMap.IsProjective
  ```
  into the required orbit-affineness.
- Its lines 17–19 explicitly record that no producer of `P.gluedMap.IsProjective` exists.
- No sibling declaration gives Pic0, the finite-stage glue, or an isomorphic model a projective/quasi-projective structure. The sibling also explicitly notes that its mathlib version has no quasi-projectivity vocabulary.

For plain irreducibility/connectedness, scheme isomorphisms transport the topological instances via [Properties.lean:62](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Properties.lean:62). Geometric irreducibility still needs an over-base comparison or a genuine descent proof; no finite-stage wrapper was found.

No files were edited.
