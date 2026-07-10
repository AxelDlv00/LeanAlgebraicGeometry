# Mathlib v4.31.0 inventory for the Picard-functor lane (Wave 3)

*2026-07-11, read-only survey of the pinned checkout (`.lake-packages/mathlib`), keyed to
route-decision §1/§3/§4-Wave-3. Line numbers are as of this checkout. This document is the
capability ground truth the Wave-3 design spec must be written against.*

Two headline facts: **there is no `Pic`, no invertible sheaf, no line bundle, and no
monoidal/tensor structure on sheaves of modules anywhere in mathlib** (the only
`Pic`/`Picard` hits are ODE Picard–Lindelöf and prose comments); and
**`Sites/Representability.lean` is Zariski-and-open-immersions only** — there is no étale
representability-by-gluing. Both confirm the route's "build it yourself" posture.

## 1. Étale site over a base + sheafification + subcanonicity

- `Mathlib/AlgebraicGeometry/Sites/Etale.lean` — `Scheme.etalePrecoverage`/`etalePretopology`/
  `etaleTopology : GrothendieckTopology Scheme.{u}` (big étale site; no size/sheafify facts);
  `zariskiTopology_le_etaleTopology`; `Scheme.smallEtaleTopology (X) : GrothendieckTopology X.Etale`
  + `smallEtalePretopology`; `etaleTopology.geometricFiber (Ω) [Field Ω] [IsSepClosed Ω]`
  (fiber functor at a separably closed field; carries
  `set_option backward.isDefEq.respectTransparency false`).
- `Mathlib/AlgebraicGeometry/Sites/AffineEtale.lean` — `Scheme.AffineEtale (S) : Type (u+1)`
  (étale `Spec R ⟶ S`; `deriving Category, HasPullbacks`); `AffineEtale.Spec S : S.AffineEtale ⥤ S.Etale`
  (Full + Faithful + `IsCoverDense`); `AffineEtale.topology S`;
  **`instance : EssentiallySmall.{u} S.AffineEtale`** — the essential-smallness that unlocks
  sheafification; **`instance : HasSheafify (AffineEtale.topology S) A`** and
  **`instance : HasSheafify S.smallEtaleTopology A`** — with the target block
  `[Category.{u} A] [ConcreteCategory.{u} A FA] [PreservesLimits (forget A)] [HasColimits A]
  [HasLimits A] [(forget A).ReflectsIsomorphisms] [PreservesFilteredColimitsOfSize.{u,u} (forget A)]`
  (`Type u`, `AddCommGrp.{u}`, `ModuleCat`, `CommRingCat`, `GrpCat` all qualify);
  `AffineEtale.sheafEquiv : Sheaf (AffineEtale.topology S) A ≌ Sheaf S.smallEtaleTopology A`;
  `isGrothendieckAbelian_sheaf_affineEtaleTopology`/`…smallEtaleTopology` + `Abelian (Sheaf … A)`.
- `Mathlib/AlgebraicGeometry/Sites/Small.lean` — `Scheme.overPretopology`/`overGrothendieckTopology (P) (S)`
  on `Over S` and `smallGrothendieckTopology`/`smallPretopology` on `P.Over ⊤ S` (instantiate
  `P := @Etale`); requires `[P.IsStableUnderBaseChange]`; **no sheafify instance** (`Over S` not
  essentially small).
- Subcanonicity: `CategoryTheory/Sites/Canonical.lean` — `GrothendieckTopology.Subcanonical` (:134),
  `Subcanonical.of_isSheaf_yoneda_obj` (:147), `Subcanonical.isSheaf_of_isRepresentable` (:151),
  `Subcanonical.of_le` (:155). `Sites/BigZariski.lean:57` — `subcanonical_zariskiTopology`.
  `Sites/Fpqc.lean` — `fppfTopology`, `fpqcTopology`, `fppfTopology_le_fpqcTopology`,
  `fpqcTopology.Subcanonical` (:83), `fppfTopology.Subcanonical := .of_le` (:93).
  **No étale-subcanonical instance exists** — derivable via `Subcanonical.of_le` once
  `etaleTopology ≤ fppfTopology` is supplied (étale ⇒ flat + lfp precoverage-monotone; small brick,
  ours). `Sites/Proetale.lean:159` shows the `subcanonical_of_full_of_faithful` pattern.

## 2. Representability tools

- `CategoryTheory/Yoneda.lean` — `Functor.RepresentableBy (F : Cᵒᵖ ⥤ Type v) (Y : C)` (:284;
  `homEquiv` + `homEquiv_comp`); `RepresentableBy.ofIso` (:301); `homEquiv_eq` (:331);
  **`uniqueUpToIso : Y ≅ Y'` (:343, `@[simps!]`)** — the uniqueness-of-representing-object iso that
  `baseChangeIso`/coherences reduce to; `@[ext] RepresentableBy.ext` (:358, equality from value on
  `𝟙 Y`); `homEquivIsoRepresentableBy : F.RepresentableBy Y ≃ (yoneda.obj Y ≅ F)` (:377);
  `RepresentableBy.toIso` (:399); `RepresentableBy.ofIsoObj` (:432) and
  `equivOfIsoObj (e : Y ≅ X) : F.RepresentableBy X ≃ F.RepresentableBy Y` (:449) — transport of the
  pin along an iso of representing objects; `isRepresentable` (:523);
  `representableByUliftFunctorEquiv` (:471) + `equivUliftYonedaIso` (:494) for universe lifts.
- `AlgebraicGeometry/Sites/Representability.lean` — `Scheme.LocalRepresentability.representableBy :
  F.1.RepresentableBy (glueData hf).glued` (:192), `isRepresentable` (:207, `@[stacks 01JJ]`).
  Hypotheses: `F : Sheaf Scheme.zariskiTopology.{u} (Type u)`; `X : ι → Scheme.{u}` (`ι : Type u`);
  `f i : yoneda.obj (X i) ⟶ F.1` with `IsOpenImmersion.presheaf (f i)`;
  `[Presheaf.IsLocallySurjective zariskiTopology (Sigma.desc f)]`. Gives an actual
  `RepresentableBy` **datum** (not `Nonempty`). **Zariski + open-immersion legs only** — no étale
  analogue; Wave-4 cannot reuse directly.
- `CategoryTheory/Monoidal/Cartesian/Grp.lean` — `GrpObj.ofRepresentableBy (X) (F : Cᵒᵖ ⥤ GrpCat.{w})
  (α : (F ⋙ forget _).RepresentableBy X) : GrpObj X` (:35; needs `CartesianMonoidalCategory C`);
  `yonedaGrpObjRepresentableBy` (:85), round-trip (:90), `yonedaGrpObjIsoOfRepresentableBy` (:100),
  `essImage_mapGrp` (Monoidal/Grp:725).
- `CategoryTheory/Monoidal/Grp.lean` — `Functor.mapGrp` (:628), `mapGrpIdIso` (:673),
  `mapGrpCompIso` (:680), `mapGrpNatTrans` (:687), `mapGrpNatIso` (:694), `mapGrpFunctor` (:702),
  `Faithful/Full/FullyFaithful.mapGrp`. `Scheme` is cartesian-monoidal
  (`AlgebraicGeometry/Limits.lean:728`); `Over X` too (`Monoidal/Cartesian/Over.lean:34`).

## 3. Invertible modules / line-bundle vocabulary

- `AlgebraicGeometry/Modules/Sheaf.lean` — `Scheme.Modules (X) := SheafOfModules X.ringCatSheaf`
  (:37); `Abelian X.Modules` (:48), `HasLimits`/`HasColimits`; sections `Γ(M, U)` with
  `Module Γ(X,U) Γ(M,U)`; `pushforward` (:164), `pullback` (:180), `pullbackPushforwardAdjunction`
  (:185), `pullbackId`/`pullbackComp`/`pullbackCongr`, `restrictFunctor` (:334) + `restrictAppIso`.
  **No ⊗, no monoidal, no invertibility predicate, no Pic** across `Modules/` — validates design
  rule 5 (cocycle model).
- `Modules/Presheaf.lean` — `Scheme.ringCatSheaf` (:34), `PresheafOfModules` (:37).
  `Modules/Tilde.lean` — `M̃` on `Spec R` only; **no global `QuasiCoherent` class anywhere**.
- **Cocycle machinery (load-bearing gift):** `CategoryTheory/Sites/NonabelianCohomology/H1.lean` —
  for `G : Cᵒᵖ ⥤ GrpCat.{w}` and any family `U : I → C`: `PresheafOfGroups.ZeroCochain` (:58),
  `OneCochain` (:81), `OneCocycle` (:123), `OneCohomologyRelation`/`IsCohomologous` (:151/:177),
  `H1 := Quot (…)` (:197) with `One (H1 G U)`. Needs neither sheaf condition nor covering — raw
  Čech-1 data on a pinned family, exactly the route's transition-cocycle model. NOT connected to
  line bundles or units; colimit-over-covers is an explicit in-file TODO. The `Pic = H¹(–,𝒪ˣ)`
  bridge is entirely ours.
- `CategoryTheory/Sites/SheafCohomology/Cech.lean` — `cechComplexFunctor` (:65) (abelian Čech
  complex); no Čech-to-derived comparison shipped.
- **Units:** no `Gₘ`/units-of-sections presheaf-of-groups abstraction exists — ours to define and
  feed to `NonabelianCohomology.H1`.
- **Gluing:** `AlgebraicGeometry/Gluing.lean` — `Scheme.GlueData` (:91) with `glued`, `ι`,
  `ι_isOpenImmersion`, `ι_jointly_surjective`, `vPullbackConeIsLimit`, `ι_eq_iff`, `isOpen_iff`.
  `Topology/Sheaves/SheafCondition/UniqueGluing.lean`, `Topology/Sheaves/CommRingCat.lean`.
  `AlgebraicGeometry/Sites/SmallAffineZariski.lean` — `relativeGluingData` (:296),
  `sheafEquiv : Sheaf (grothendieckTopology X) A ≌ TopCat.Sheaf A X` (:204).

## 4. Base-change / test-scheme plumbing

- `CategoryTheory/Comma/Over/Pullback.lean` — `Over.pullback` (:63), `mapPullbackAdj` (:72),
  `pullbackId` (:105), `pullbackComp` (:109). In-tree precedent for base change to `k̄`:
  `AlgebraicGeometry/Group/Abelian.lean:139` uses
  `(Over.pullback (Spec.map (algebraMap K (AlgebraicClosure K)))).obj G`.
- `AlgebraicGeometry/Pullbacks.lean` — **`pullbackSpecIso R S T : pullback … ≅ Spec (.of (S ⊗[R] T))`**
  (:719) with `_inv_fst`/`_fst'`/`_snd` (:733/:738/:749) + `_hom_` companions; mature
  `pullbackSymmetry`/`pullbackAssoc`/`pullback.map` helpers.
- `AlgebraicGeometry/GammaSpecAdjunction.lean` — `Spec.fullyFaithful` (:522), `Spec.full` (:526),
  `Spec.faithful` (:530).
- `AlgebraicGeometry/PointsPi.lean` — `pointsPi` (:100), injective under `[QuasiSeparatedSpace X]`
  (:104), surjective for `IsAffine` (:111) or `[CompactSpace X] [∀ i, IsLocalRing (R i)]` (:119).
- `AlgebraicGeometry/Sites/Affine.lean` — `affineOverMk`, `isCoverDense_toOver_Spec`,
  `isOneHypercoverDense_toOver_Spec`. `Sites/SmallAffineZariski.lean` — `Scheme.AffineZariskiSite`
  (:51), essentially small, `grothendieckTopology` (:116), `sheafEquiv` (:204).
- `AlgebraicGeometry/Morphisms/FlatRank.lean` — `Scheme.Hom.finrank` (:89, `@[stacks 02KA]`),
  `finrank_pullback_fst/_snd` (:169/:156), `finrank_of_isPullback` (:164),
  `finrank_SpecMap_algebraMap` (:134), `finrank_eq_one_of_isIso` (:257).

## 5. Group-valued functor infrastructure

- `CategoryTheory/Sites/CartesianMonoidal.lean:51` — `CartesianMonoidalCategory (Sheaf J A)` **as an
  `example`** (inferable, not named — use `inferInstance`, never `exact?`). Cartesian-closed:
  `Sites/CartesianClosed.lean:28`.
- `CategoryTheory/Sites/Sheafification.lean` — `PreservesFiniteLimits (presheafToSheaf J A)` (:76)
  given `[HasSheafify J A]`; `HasWeakSheafify` (:50). Sheafification left-exactness is what makes a
  group structure survive sheafification.
- "Presheaf-of-Grp → sheaf-of-group-objects" is NOT packaged; assembly is mechanical but ours.
- Verified gifts: `Group/Abelian.lean:133` `isCommMonObj_of_isProper_of_geometricallyIntegral`
  (`@[stacks 0BFD]`, stated for `GeometricallyIntegral`), `:35` `IsClosedImmersion η[G].left`;
  `Group/Smooth.lean:64` `smooth_of_grpObj [GeometricallyReduced f]` via `descendsAlong` over
  `@Surjective ⊓ @Flat ⊓ @QuasiCompact`.

## 6. Descent

- `Morphisms/Descent.lean` — abstract `descendsAlong` (`IsZariskiLocalAtTarget.descendsAlong` :63,
  `of_pullback_fst_Spec_of_codescendsAlong` :94, `IsStableUnderBaseChange.of_pullback_fst_of_isAffine`
  :113, `HasRingHomProperty.descendsAlong`). In-file TODO: affine morphisms descend along
  faithfully-flat is NOT yet proven.
- `Morphisms/FlatDescent.lean` — property descent along `@Surjective ⊓ @Flat ⊓ @QuasiCompact`:
  `universallyClosed` (:46, 02KS), `universallyOpen` (:63, 02KT), `universallyInjective` (:88, 02KW),
  `isomorphisms` (:88, 02L4), `isOpenImmersion` (:127, 02L3), `HasRingHomProperty.descendsAlong_flat`
  (:156).
- `Morphisms/LocalFlatDescent.lean` — `DescendsAlong` for `@LocallyOfFiniteType`,
  `@LocallyOfFinitePresentation`, `@Smooth`, `@FormallyUnramified`, `@Etale` (:35–:47).
- `RingTheory/Flat/FaithfullyFlat/Descent.lean` — `codescendsAlong_injective/surjective/bijective`
  only. `RingTheory/Etale/Descent.lean` — `Etale/Smooth/FormallyUnramified.codescendsAlong_faithfullyFlat`.
- **Effectivity gap:** all of the above is descent of *properties*. NO effective descent of
  modules/quasi-coherent sheaves/objects, no fppf/étale effective descent for sheaves — the
  "descend a line bundle" and Galois-descent-to-`k` legs have no mathlib scaffold.

## Load-bearing absences (Wave 3 must build)

1. `Pic`/invertible sheaf/line bundle — nothing; cocycle model forced.
2. No monoidal/tensor structure on `X.Modules`.
3. No étale representability-by-gluing (Zariski + open immersions only).
4. No étale-subcanonical instance (derivable: prove `etaleTopology ≤ fppfTopology`, then
   `Subcanonical.of_le`).
5. No `QuasiCoherent` notion (only affine `M̃`).
6. No `Gₘ`/units presheaf and no `Pic = H¹(–,𝒪ˣ)` bridge (NonabelianCohomology.H1 gives raw
   pinned-family cocycles; colimit-over-covers is TODO upstream).
7. No Čech-to-derived comparison (as planned: use the MV (0,1)-slice instead).
8. No effective flat/étale descent of modules; no `HasSheafify` on big over-sites — affine-local
   refinement of the test scheme is *mandatory* (essential smallness is the sheafify gate).
9. No sheaf-of-modules local-freeness/rank predicate (`FlatRank` is about morphisms) — Wave-4's
   `q_*L` locally-free-of-rank-χ leg has no landing vocabulary yet.

## Universe landmines

- Essential-smallness gates sheafification: `S.AffineEtale : Type (u+1)`, hom-level `u`,
  `EssentiallySmall.{u}`; `HasSheafify` only for the small (affine) étale site of a fixed `S`, with
  the target concrete at level `u`. Big étale site and `Over (Spec k)` have NO `HasSheafify`.
- `GrpObj.ofRepresentableBy` couples universes: for `C = Scheme.{u}` the Picard functor must be
  `GrpCat.{u}`-valued with its underlying `Type u`-sheaf represented by a `Scheme.{u}`. Keep
  everything at `u`.
- `Scheme.{u} : Type (u+1)`; `Type u`-sheaves on big sites live at `(u+1)`. Use
  `representableByUliftFunctorEquiv`/`equivUliftYonedaIso` if a `max w v` mismatch appears.
- `CartesianMonoidalCategory (Sheaf J A)` is an `example`, not a named instance — `inferInstance`.
