## Architecture Result

The shortest route is `WalkingMultispan.functorExt`, not a raw `NatIso.ofComponents`. Mathlib already packages exactly the two diagram squares needed.

Let

```lean
D₁ := Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
  (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))
D₂ := pic0SepClosedAtlasGlueData C
```

The orientations are:

| Component | `D₁` | `D₂` |
|---|---|---|
| right `U` | base-changed finite chart | exact atlas chart |
| left `(U,V)` | nested pullback overlap | `pullback U.ι V.ι` |
| `fst` | `D₁.f U V` | `D₂.f U V` |
| `snd` | `D₁.t U V ≫ D₁.f V U` | `D₂.t U V ≫ D₂.f V U` |

This follows from `GlueData.diagram` at `Mathlib/CategoryTheory/GlueData.lean:137-149`.

The current shared overlap draft’s `gluingOverlapBaseChangeIso` maps only to the affine intersection, not yet to `D₂.V`:

```lean
noncomputable def atlasOverlapPullbackIso (U V) :
    (pic0FiniteStageAffineOverlap C U V).1.toScheme ≅
      (pic0SepClosedAtlasGlueData C).V (U, V) := by
  change (U.1.1 ⊓ V.1.1).toScheme ≅ pullback U.1.1.ι V.1.1.ι
  exact (isPullback_opens_inf U.1.1 V.1.1).isoPullback

noncomputable def gluingDiagramOverlapIso (P) (U V) :=
  gluingOverlapBaseChangeIso C P U V ≪≫ atlasOverlapPullbackIso C U V
```

`isPullback_opens_inf` is at `Mathlib/AlgebraicGeometry/Restrict.lean:573`; `isoPullback` and its projection simp lemmas are at `.../IsPullback/Defs.lean:194-218`.

The two exact naturality equations are:

```lean
theorem gluingDiagram_fst_naturality (P) (U V) :
    D₁.f U V ≫ (gluingChartIso C P U).hom =
      (gluingDiagramOverlapIso C P U V).hom ≫ D₂.f U V := by
  ...

theorem gluingDiagram_snd_naturality (P) (U V) :
    (D₁.t U V ≫ D₁.f V U) ≫ (gluingChartIso C P V).hom =
      (gluingDiagramOverlapIso C P U V).hom ≫
        (D₂.t U V ≫ D₂.f V U) := by
  ...
```

Then the diagram and glued isomorphisms are only:

```lean
noncomputable def gluingDiagramIso (P) :
    D₁.diagram.multispan ≅ D₂.diagram.multispan :=
  WalkingMultispan.functorExt
    (fun p => gluingDiagramOverlapIso C P p.1 p.2)
    (fun U => gluingChartIso C P U)
    (fun p => gluingDiagram_fst_naturality C P p.1 p.2)
    (fun p => gluingDiagram_snd_naturality C P p.1 p.2)

noncomputable def gluingGluedIso (P) : D₁.glued ≅ D₂.glued :=
  HasColimit.isoOfNatIso (gluingDiagramIso C P)

noncomputable def finiteStageBaseChangeIsoPic0 (P) :
    pullback P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      (pic0_sepClosed_representableBy (C := C)).1.left :=
  baseChangeGluingIso C P ≪≫
    gluingGluedIso C P ≪≫
    asIso (pic0SepClosedAtlasOpenCover C).fromGlued
```

Relevant APIs:

- `WalkingMultispan.functorExt`: `Mathlib/CategoryTheory/Limits/Shapes/Multiequalizer.lean:223-235`
- `HasColimit.isoOfNatIso`: `Mathlib/CategoryTheory/Limits/HasLimits.lean:879-889`
- `Cover.fromGlued` and its `IsIso`: `Mathlib/AlgebraicGeometry/Gluing.lean:348-350,423-429`
- Existing components: `Pic0FiniteStageGluingBaseChange.lean:37-85`
- Shared flattening component: `Pic0FiniteStageOverlapBaseChange.lean:112-125`

## Missing Second Leg

`restrictionFinalBaseChangeEquiv_naturality` proves only the left/fst ring square. It cannot discharge `snd`.

The shortest missing ring theorem should compare the actual right leg, namely transition after the reversed left restriction:

```lean
rightBaseChangeAlgHom P U V :=
  (pic0FiniteStageTransitionBaseChange
    C P.L P.n P.m P.relation P.M P.mapM P.N U V).comp
      (restrictionBaseChangeAlgHom C P V U)

exactRightRestrictionAlgHom C U V :=
  pic0FiniteStageMap C (Sum.inl (Sum.inr (U, V)))

theorem rightRestrictionFinalBaseChangeEquiv_naturality :
    (overlapFinalBaseChangeEquiv C P U V).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := P.N.1) (K := k) (rightBaseChangeAlgHom C P U V)) =
      (exactRightRestrictionAlgHom C U V).comp
        (chartFinalBaseChangeEquiv C P V).toAlgHom := by
  ...
```

It follows by composing existing all-map naturality at:

```lean
Sum.inl (Sum.inl (V, U))  -- reversed left restriction
Sum.inr (U, V)            -- transition
```

using `scalarExtensionMapOfAlgHom_comp`, plus the exact identity

```lean
(pic0FiniteStageTransition C (U, V)).comp
    (pic0FiniteStageRestrictionLeft C V U) =
  pic0FiniteStageRestrictionRight C U V
```

Two flattening projection lemmas are also required: its hom must intertwine the source `f` with base change of `a`, and source `t ≫ f` with base change of `b`. Without those, neither diagram equation connects the nested overlap to the affine naturality maps.

Finally, the displayed result is a Scheme isomorphism. An `Over (Spec k)` isomorphism additionally needs

```lean
(finiteStageBaseChangeIsoPic0 C P).hom ≫
    (pic0_sepClosed_representableBy (C := C)).1.hom =
  pullback.snd P.gluedMap
    (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))
```

before applying `Over.isoMk`.
