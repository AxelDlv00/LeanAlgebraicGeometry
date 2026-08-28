## Audit Result

No sibling AJC theorem closes `OrbitsInAffineOpen` for `P.gluedOver` without a new geometric input.

### Reusable Sibling Infrastructure

From `Picard/ProjectiveMorphismBasic.lean` (imports `Picard.ProjectiveSpace`):

```lean
def Scheme.Hom.IsProjective (π : X ⟶ S) : Prop :=
  ∃ n (_ : Finite n) (i : X ⟶ ℙ(n; S)),
    IsClosedImmersion i ∧ i ≫ (ℙ(n; S) ↘ S) = π

def Scheme.Hom.IsHQuasiProjective (π : X ⟶ S) : Prop :=
  ∃ n (_ : Finite n) (i : X ⟶ ℙ(n; S)),
    IsImmersion i ∧ QuasiCompact i ∧ i ≫ (ℙ(n; S) ↘ S) = π
```

Useful closure results include:

```lean
IsProjective.isHQuasiProjective
IsProjective.comp_isClosedImmersion
IsProjective.baseChange
IsHQuasiProjective.comp_isImmersion
IsHQuasiProjective.baseChange
```

From `Picard/QuasiProjectiveFiniteInAffine.lean` (imports `PicEtPointedReduction`, `ProjectiveMorphism`, `CurveProjectivity`, `AmbientPicNotProper`, `StableAffineCover`):

```lean
finiteInAffine_of_isImmersion
  (f : X ⟶ Y) [IsImmersion f]
  (hY : FiniteInAffine Y) : FiniteInAffine X

finiteInAffine_of_isProjective
  [IsAffine S] (h : π.IsProjective) : FiniteInAffine X

finiteInAffine_of_isHQuasiProjective
  [IsAffine S] (h : π.IsHQuasiProjective) : FiniteInAffine X

orbitsInAffineOpen_of_isProjective
  (ρ : SemilinearGalAction K L X f)
  [IsAffine S] (h : π.IsProjective) : ρ.OrbitsInAffineOpen

orbitsInAffineOpen_of_isHQuasiProjective
  (ρ : SemilinearGalAction K L X f)
  [IsAffine S] (h : π.IsHQuasiProjective) : ρ.OrbitsInAffineOpen
```

It also provides `finiteInAffine_sigma`, `finiteInAffine_over_sigma`, and projective/HQP variants. These do not apply to `P.glueData.glued`: that object is a multicoequalizer glue, not a coproduct of components.

From `PicEtPointedReduction.lean`:

```lean
def FiniteInAffine (X : Scheme) : Prop :=
  ∀ s : Set X, s.Finite → ∃ U : X.affineOpens, s ⊆ U.1

orbitsInAffineOpen_of_finiteInAffine
  (ρ : SemilinearGalAction K L X f)
  (h : FiniteInAffine X) : ρ.OrbitsInAffineOpen
```

### Pic0 and Group-Scheme Findings

`Pic0AbelianVariety.lean` exposes, for the sibling’s specific `Pic0Scheme C`:

```lean
Pic0.grpObj :
  Nonempty (GrpObj (Pic0Scheme C))

Pic0.locallyOfFiniteType :
  LocallyOfFiniteType (Pic0Scheme C).hom

Pic0.geometricallyIrreducible :
  GeometricallyIrreducible (Pic0Scheme C).hom

Pic0.isAbelianVariety :
  IsProper ... ∧ Smooth ... ∧ GeometricallyIrreducible ... ∧
    Nonempty (GrpObj (Pic0Scheme C))
```

Crucially, “abelian variety” here does not include `IsProjective`, `IsHQuasiProjective`, or an immersion. Horizon search and declaration inspection found no theorem of any of these shapes for `Pic0Scheme C`. The sibling module itself states at lines 545–551 that no H-quasi-projective witness for the Picard component is produced.

`Albanese/StableAffineCoverGroup.lean` only turns an assumed finite-group `OrbitsInAffineOpen` condition into stable affine neighborhoods. It does not prove the orbit condition from group-scheme structure.

`FiniteMapProjectiveImmersion.lean` gives:

```lean
LaurentChartData.FiniteMapGenerators.isImmersion_toProjectiveSpace
  [IsFinite π.left] : IsImmersion G.toProjectiveSpace

LaurentChartData.isProjective_of_finiteMap
  (D : LaurentChartData Y) (π : C ⟶ Y)
  [IsFinite π.left] [IsProper C.hom] : C.hom.IsProjective
```

This is specialized to a supplied finite map to a Laurent two-chart target. Nothing constructs such a map or its generators for `P.gluedOver`.

### Applicability to `P.gluedOver`

Definitionally:

```lean
P.gluedOver.left = P.glueData.glued
P.gluedOver.hom  = P.gluedMap
```

AJCR already has the optimal consumer:

```lean
pic0FiniteStageFiniteInAffine_of_isImmersion
  (i : P.glueData.glued ⟶ ℙ(n; Spec (.of P.N.1)))
  (hi : IsImmersion i) :
  Scheme.FiniteInAffine P.glueData.glued
```

Thus the smallest useful missing bridge is exactly a finite-dimensional projective-space immersion of `P.glueData.glued`. A direct proof of `Scheme.FiniteInAffine P.glueData.glued` would be even weaker. Proving `P.gluedMap.IsProjective` is strictly stronger than needed.

The group route is not smaller. Once the exact `rep` exists, `GrpObj.ofRepresentableBy` can put a group object on `P.gluedOver`, and AJCR already proves `LocallyOfFiniteType P.gluedMap`. But the current group-affine theorem additionally needs `[IsAlgClosed P.N.1]` and `[IrreducibleSpace P.glueData.glued]`; neither follows from the finite-Galois-level binders. An arbitrary-field group-scheme `FiniteInAffine` theorem plus exact-carrier irreducibility would be substantial new geometry.

No files were edited and no build was run.
