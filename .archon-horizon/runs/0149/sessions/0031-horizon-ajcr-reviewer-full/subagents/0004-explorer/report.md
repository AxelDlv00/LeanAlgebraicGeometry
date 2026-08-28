Read-only audit complete; no files edited.

The exact generic comparison API is:

```lean
CategoryTheory.NatIso.ofComponents
  (app : ∀ X, F.obj X ≅ G.obj X)
  (naturality :
    ∀ {X Y} (f : X ⟶ Y),
      F.map f ≫ (app Y).hom = (app X).hom ≫ G.map f := by cat_disch) :
  F ≅ G

CategoryTheory.Limits.HasColimit.isoOfNatIso
  (w : F ≅ G) :
  colimit F ≅ colimit G

IsColimit.coconePointsIsoOfNatIso
  (P : IsColimit s) (Q : IsColimit t) (w : F ≅ G) :
  s.pt ≅ t.pt
```

The relevant case split is demonstrated by `CategoryTheory.GlueData.diagramIso` in [GlueData.lean](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/GlueData.lean:238):

```lean
NatIso.ofComponents
  (fun x =>
    match x with
    | WalkingMultispan.left _  => overlapIso ...
    | WalkingMultispan.right _ => chartIso ...)
  (by
    rintro (⟨_, _⟩ | _) _ (_ | _ |_) <;> ...)
```

The two surviving naturality obligations are precisely the multispan legs `f` and `t ≫ f`. After constructing `α`:

```lean
HasColimit.isoOfNatIso α :
  Db.glued ≅ De.glued
```

because `GlueData.glued` is the colimit of `diagram.multispan`.

The smallest fully checked next theorem is the canonical base-change-to-pullback-gluing comparison:

```lean
noncomputable def baseChangeGluingIso
    (P : Pic0FiniteStageGluePackage C F) :
    pullback P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k))) ≅
      (Scheme.Pullback.gluing P.glueData.openCover P.gluedMap
        (Spec.map (CommRingCat.ofHom (algebraMap P.N.1 k)))).glued :=
  limit.isoLimitCone
    ⟨PullbackCone.mk
        (Scheme.Pullback.p1 P.glueData.openCover P.gluedMap _)
        (Scheme.Pullback.p2 P.glueData.openCover P.gluedMap _)
        (Scheme.Pullback.p_comm P.glueData.openCover P.gluedMap _),
      Scheme.Pullback.gluedIsLimit P.glueData.openCover P.gluedMap _⟩
```

I Lean-checked this successfully. The supporting declarations are in [Pullbacks.lean](/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Pullbacks.lean:197): `Scheme.Pullback.gluing`, `p1`, `p2`, `p_comm`, `pullbackP1Iso`, and `gluedIsLimit`.

For diagram components:

- Right/chart component:

```lean
pullback.congrHom (P.glueData_ι_gluedMap U) rfl ≪≫
  P.chartBaseChangeIso U
```

- The affine overlap base-change component also Lean-checks:

```lean
pullbackSymmetry _ _ ≪≫
  pullbackSpecIso P.N.1 k
    (Pic0FiniteStageOverlapBaseChangeRing ... U V) ≪≫
  Scheme.Spec.mapIso
    (pic0FiniteStageFinalBaseChangeEquiv ... (Sum.inr (U, V)))
      .symm.toRingEquiv.toCommRingCatIso.op ≪≫
  (pic0FiniteStageAffineOverlap C U V).2.isoSpec.symm ≪≫
  (isPullback_opens_inf U.1.1 V.1.1).isoPullback
```

The remaining categorical step is real: `Scheme.Pullback.gluing ... .V (U,V)` is a nested pullback, not definitionally the affine overlap base change. Its left component must first be flattened using `pullbackAssoc`/`pullbackSymmetry` together with `P.glueData.vPullbackConeIsLimit`, then composed with the overlap iso above. `pullbackRightPullbackFstIso`, `pullbackLeftPullbackSndIso`, and `IsPullback.isoPullback` are the relevant helpers.

There is no ready-made arbitrary `GlueData ≅ GlueData` constructor. `GlueData.mapGlueData`, `diagramIso`, and `gluedIso` compare one glue datum with its image under a functor, so they do not directly discharge this base-change comparison. The verified route is therefore:

```text
base change of gluedOver
  ≅ Pullback.gluing.glued
  ≅ sepClosedAtlasGlueData.glued
  ≅ Pic0
```

with the middle isomorphism obtained from `NatIso.ofComponents` after flattening the nested overlap pullbacks.
