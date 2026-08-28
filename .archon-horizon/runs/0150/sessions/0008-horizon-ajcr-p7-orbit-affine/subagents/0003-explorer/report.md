## Finding

No existing AJC or pinned Mathlib theorem closes arbitrary-field `FiniteInAffine` from `GrpObj + LocallyOfFiniteType + QuasiCompact`.

### Reusable AJC Infrastructure

- [ProjectiveMorphismBasic.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/ProjectiveMorphismBasic.lean:44):
  ```lean
  def Scheme.Hom.IsHQuasiProjective (pi : X ⟶ S) : Prop :=
    ∃ n (_ : Finite n) (i : X ⟶ ℙ(n; S)),
      IsImmersion i ∧ QuasiCompact i ∧ i ≫ (ℙ(n; S) ↘ S) = pi
  ```
  It has genuine proofs of `locallyOfFiniteType` at line 128, `quasiCompact` at 136, `isSeparated` at 145, and base-change stability at 173. Base change is ascent only; no descent theorem exists.

- [QuasiProjectiveFiniteInAffine.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuasiProjectiveFiniteInAffine.lean:484):
  ```lean
  theorem Scheme.finiteInAffine_of_isHQuasiProjective
      [IsAffine S] (h : π.IsHQuasiProjective) : FiniteInAffine X
  ```
  This and `finiteInAffine_of_isProjective` at line 471 are axiom-clean. The module explicitly states at lines 57-65 that it produces no H-quasi-projective witness for `Pic⁰`.

- [PicEtSeparated.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/PicEtSeparated.lean:170):
  ```lean
  instance isSeparated_of_grpObj
      (G : Over (Spec (.of K))) [GrpObj G] : IsSeparated G.hom
  ```
  This is directly reusable group-scheme substrate.

- [IdentityComponent.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/IdentityComponent.lean:1147) gives `IdentityComponent.baseChangeIso` for every field extension. At line 1374:
  ```lean
  theorem IdentityComponent.isFiniteTypeGeometricallyIrreducible
      (G : Over (Spec (.of k))) [GrpObj G] [LocallyOfFiniteType G.hom] :
      LocallyOfFiniteType (IdentityComponent G).hom ∧
      QuasiCompact (IdentityComponent G).hom ∧
      GeometricallyIrreducible (IdentityComponent G).hom
  ```
  This is a genuine arbitrary-field, axiom-clean theorem, but it proves neither H-quasi-projectivity nor `FiniteInAffine`.

### Descent Endpoint

- [FiniteGaloisQuotient.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FiniteGaloisQuotient.lean:200) defines the substantive `OrbitsInAffineOpen` condition; `HasStableAffineCover` at line 231 is conditional on actual stable affine neighborhoods.
- [StableAffineCover.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/StableAffineCover.lean:282) genuinely derives `HasStableAffineCover` from finite Galois plus `OrbitsInAffineOpen`.
- [GaloisQuotientOverlap.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/GaloisDescent/GaloisQuotientOverlap.lean:1626) constructs the quotient; line 1635 installs it from `OrbitsInAffineOpen`.
- The pullback-action orbit instance in [GaloisQuotientNonVacuity.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/GaloisQuotientNonVacuity.lean:131) presupposes a descended scheme `Y`; using it here would be circular.
- `PointedPicSharpRepProjective` is explicitly refuted for the intended ambient Picard scheme at [QuasiProjectiveFiniteInAffine.lean:77](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/QuasiProjectiveFiniteInAffine.lean:77). It must not be used as an inhabitable producer.

### Exact AJCR Gap

AJCR already supplies the desired hypotheses:

- [Pic0FiniteStageGeometry.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGeometry.lean:39): `LocallyOfFiniteType P.gluedMap`.
- Same file at line 58: `QuasiCompact P.gluedMap`.
- [Pic0FiniteStageOrbitAffine.lean:43](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:43): representation produces `GrpObj P.gluedOver`.

The current theorem at line 56 additionally assumes `[IsAlgClosed P.N.1] [IrreducibleSpace P.glueData.glued]`. It is axiom-clean but only conditional; neither assumption has a general finite-stage producer, and an algebraically closed finite Galois stage is unavailable for a general base field. The immersion route at line 87 is likewise genuine but lacks its immersion producer.

### Narrowest Route

The missing geometric theorem is precisely:

```lean
theorem GroupScheme.finiteInAffine_of_finiteType
    (G : Over (Spec (.of K))) [GrpObj G]
    [LocallyOfFiniteType G.hom] [QuasiCompact G.hom] :
    Scheme.FiniteInAffine G.left
```

Equivalently, prove finite-type group schemes H-quasi-projective, then consume AJC’s theorem above. This is the standard quasi-projectivity theorem for finite-type group schemes, but it is absent from Mathlib v4.31 and AJC. Porting AJC’s H-quasi-projective definitions would be straightforward; producing the group-scheme immersion is the substantive blocker. Identity-component base-change infrastructure does not by itself bridge it.

All cited candidate endpoints were checked with `#print axioms`; they use only `propext`, `Classical.choice`, and `Quot.sound`. No source files were edited. Horizon required one coordination acknowledgment on `I-2007`.
