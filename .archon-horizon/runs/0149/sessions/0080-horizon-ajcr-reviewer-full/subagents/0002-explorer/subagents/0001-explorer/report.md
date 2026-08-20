## Grounded Result

The requested file does not exist:

`MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Challenge.lean`

A workspace-wide search found `Challenge.lean` only in the rebuild project and a `.phase0-pre-*` rebuild snapshot. Neither is evidence for the legacy path.

## Current Legacy Surface

The legacy project now splits the challenge declarations across:

- `AlgebraicJacobian/Genus.lean`
- `AlgebraicJacobian/Jacobian.lean`
- `AlgebraicJacobian/AbelJacobi.lean`

Under the shared curve assumptions
```lean
{k : Type u} [Field k] {C : Over (Spec (.of k))}
[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
[GeometricallyIrreducible C.hom]
```
the current public declarations are:

- `Jacobian.lean:922`: `Jacobian C : Over (Spec (.of k))`
- `Jacobian.lean:933`: `Jacobian.instGrpObj : GrpObj (Jacobian C)`
- `Jacobian.lean:937`: `Jacobian.smoothOfRelativeDimension_genus :
  SmoothOfRelativeDimension (genus C) (Jacobian C).hom`
- `Jacobian.lean:941`: `Jacobian.instIsProper : IsProper (Jacobian C).hom`
- `Jacobian.lean:944`: `Jacobian.instGeometricallyIrreducible :
  GeometricallyIrreducible (Jacobian C).hom`
- `AbelJacobi.lean:60`: `Jacobian.ofCurve
  (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) : C ⟶ Jacobian C`
- `AbelJacobi.lean:71`: `Jacobian.comp_ofCurve ... :
  P ≫ ofCurve P = η[Jacobian C]`
- `AbelJacobi.lean:91`: `Jacobian.exists_unique_ofCurve_comp ... :
  ∃! (g : Jacobian C ⟶ A), f = ofCurve P ≫ g`

None has a literal `sorry` body. All are transitively sorry-backed through
`Jacobian.lean:848` `picardJacobianWitness`.

## Five Headline Leaves

The source explicitly identifies exactly five open obligations in that dependency path:

1. `Picard/FGAPicRepresentability.lean:955`, `sorry` at line 963:
```lean
Scheme.fgaPicardRepresentability (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIntegral C.hom] :
  (∃ X, Nonempty ((PicScheme.picEt C).RepresentableBy X) ∧
      LocallyOfFiniteType X.hom ∧ IsSeparated X.hom) ∧
    (HasRationalPoint C → IsIso (PicScheme.picEtComparison C))
```

2. `Picard/Pic0Et.lean:170`, `sorry` at line 175:
```lean
Scheme.Pic0Et.geometricallyReduced (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :
  GeometricallyReduced (Pic0SchemeEt C).hom
```

3. `Picard/Pic0Et.lean:223`, `sorry` at line 228:
```lean
Scheme.Pic0Et.universallyClosed (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIntegral C.hom] [HasPicSchemeEt C] :
  UniversallyClosed (Pic0SchemeEt C).hom
```

4. `Jacobian.lean:548`, `sorry` at line 551:
```lean
smoothOfRelativeDimension_genus_pic0Et (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIntegral C.hom] :
  SmoothOfRelativeDimension (genus C) (Scheme.Pic0SchemeEt C).hom
```

5. `Jacobian.lean:690`, `sorry` at line 697:
```lean
isAlbanese_pic0Et (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIntegral C.hom]
  (grp : GrpObj (Scheme.Pic0SchemeEt C))
  (pr : IsProper (Scheme.Pic0SchemeEt C).hom)
  (sm : Smooth (Scheme.Pic0SchemeEt C).hom)
  (gi : GeometricallyIrreducible (Scheme.Pic0SchemeEt C).hom)
  (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) :
  @IsAlbanese k _ C P (Scheme.Pic0SchemeEt C) grp pr sm gi
```

`Jacobian.lean` also has two literal sorries at lines 447 and 648 for the conditional `picSharp` route. Lines 330-333 and 451-457 explicitly state that these do not feed the headline witness.

`Genus.lean:41-44` has a concrete definition. Its project-local `StructureSheafModuleK` import cone contains no literal `sorry` or `axiom`.

## Root Imports

No current legacy `.lean` file imports `AlgebraicJacobian.Challenge`.

The umbrella root re-exports the replacement surface directly:

- `AlgebraicJacobian.lean:53`: `import AlgebraicJacobian.Genus`
- `AlgebraicJacobian.lean:62`: `import AlgebraicJacobian.Jacobian`
- `AlgebraicJacobian.lean:63`: `import AlgebraicJacobian.AbelJacobi`

The canonical original statement remains at `references/challenge.lean`; it imports only `Mathlib` and has literal sorries at lines 54, 60, 69, 74, 78, 82, 89, 95, and 107. It is a reference file, not the missing legacy module.

No files were edited and no build was run.
