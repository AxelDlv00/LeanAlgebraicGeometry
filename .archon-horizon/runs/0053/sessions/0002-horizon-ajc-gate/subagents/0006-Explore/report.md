Findings below. Headline: **no lemma named `fromSpecResidueField_appTop` (or `fromSpecResidueField_app`) exists** anywhere in Mathlib, in `Algebraic-Jacobian-Challenge`, in the sibling `MainProjects`, or in `SubProjects`. What exists are all the ingredients, listed with verbatim signatures.

## 1. The affine specialisation you asked for (closest existing lemma)

`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/ResidueField.lean:280-311`, in section `Spec` with `variable (R : CommRingCat) (x : Spec R)`, namespace `AlgebraicGeometry.Scheme`:

```lean
/-- The residue fields of `Spec R` are isomorphic to `Ideal.ResidueField`. -/
noncomputable
def Spec.residueFieldIso :
    (Spec R).residueField x ≅ .of x.asIdeal.ResidueField :=          -- L286-289

@[reassoc (attr := simp)]
lemma Spec.algebraMap_residueFieldIso_inv :
    CommRingCat.ofHom (algebraMap R _) ≫ (residueFieldIso R x).inv =
      (Scheme.ΓSpecIso R).inv ≫ (Spec R).presheaf.germ ⊤ x trivial ≫ (Spec R).residue x  -- L292-294

@[reassoc (attr := simp)]
lemma Spec.residue_residueFieldIso_hom :
    (Spec R).residue x ≫ (residueFieldIso R x).hom =
      (Spec.stalkIso R x).hom ≫ CommRingCat.ofHom (algebraMap _ _) := rfl  -- L298-300

@[reassoc (attr := simp)]
lemma Spec.map_residueFieldIso_inv_eq_fromSpecResidueField :
    Spec.map (residueFieldIso _ _).inv ≫
      Spec.map (CommRingCat.ofHom (algebraMap R x.asIdeal.ResidueField)) =
    (Spec R).fromSpecResidueField x                                   -- L303-306
```

Fully qualified: `AlgebraicGeometry.Scheme.Spec.residueFieldIso`, `AlgebraicGeometry.Scheme.Spec.algebraMap_residueFieldIso_inv`, `AlgebraicGeometry.Scheme.Spec.residue_residueFieldIso_hom`, `AlgebraicGeometry.Scheme.Spec.map_residueFieldIso_inv_eq_fromSpecResidueField` (all inside `namespace AlgebraicGeometry.Scheme`, so `Scheme.Spec.residueFieldIso` etc. — note the confusing `Scheme.Spec.` prefix, which is how the projects reference it).

`Spec.algebraMap_residueFieldIso_inv` is exactly the "global-sections" statement modulo `ΓSpecIso`: its RHS is `(ΓSpecIso R).inv ≫ (Spec R).Γevaluation x` (since `Γevaluation x = germ ⊤ x trivial ≫ residue x`, `ResidueField.lean:96-104`).

## 2. How to derive `appTop` (the lemma does not exist; assemble from these)

```
((Spec R).fromSpecResidueField x).appTop
  = (Spec R).Γevaluation x ≫ (Scheme.ΓSpecIso ((Spec R).residueField x)).inv
  = (Scheme.ΓSpecIso R).hom ≫ CommRingCat.ofHom (algebraMap R x.asIdeal.ResidueField)
      ≫ (Scheme.Spec.residueFieldIso R x).inv ≫ (Scheme.ΓSpecIso _).inv
```

Ingredients, verbatim:

- `AlgebraicGeometry.Scheme.Hom.appTop` — `/home/.../Mathlib/AlgebraicGeometry/Scheme.lean:182-185`: `abbrev appTop : Γ(Y, ⊤) ⟶ Γ(X, ⊤) := f.app ⊤`
- `AlgebraicGeometry.Scheme.comp_appTop` — `Scheme.lean:389-392`: `theorem comp_appTop {X Y Z : Scheme} (f : X ⟶ Y) (g : Y ⟶ Z) : (f ≫ g).appTop = g.appTop ≫ f.appTop := rfl` (`@[simp, reassoc]`)
- `AlgebraicGeometry.Scheme.ΓSpecIso` — `Scheme.lean:621`: `def ΓSpecIso : Γ(Spec R, ⊤) ≅ R`
- `AlgebraicGeometry.Scheme.ΓSpecIso_naturality` — `Scheme.lean:627-629` (`@[reassoc (attr := simp)]`): `(Spec.map f).appTop ≫ (ΓSpecIso S).hom = (ΓSpecIso R).hom ≫ f`
- `AlgebraicGeometry.Scheme.ΓSpecIso_inv_naturality` — `Scheme.lean:633-635`: `f ≫ (ΓSpecIso S).inv = (ΓSpecIso R).inv ≫ (Spec.map f).appTop`
- `AlgebraicGeometry.Scheme.ΓSpecIso_inv` — `Scheme.lean:638`: `(ΓSpecIso R).inv = CommRingCat.ofHom (algebraMap _ _)` (deliberately not `simp`)

## 3. `fromSpecResidueField` and neighbours (`ResidueField.lean`)

File `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/ResidueField.lean`, namespace `AlgebraicGeometry.Scheme`:

- L45-46 `def residueField (x : X) : CommRingCat := CommRingCat.of <| IsLocalRing.ResidueField (X.presheaf.stalk x)`
- L54-55 `def residue (X : Scheme.{u}) (x) : X.presheaf.stalk x ⟶ X.residueField x := CommRingCat.ofHom (IsLocalRing.residue (X.presheaf.stalk x))`
- L70-71 `lemma residue_surjective (X : Scheme.{u}) (x) : Function.Surjective (X.residue x) := Ideal.Quotient.mk_surjective`  → `AlgebraicGeometry.Scheme.residue_surjective`
- L73-74 `instance (X : Scheme.{u}) (x) : Epi (X.residue x)`
- L66-68 `@[simp] lemma SpecMap_residue_apply (x : X) (s : Spec (X.residueField x)) : Spec.map (X.residue x) s = closedPoint (X.presheaf.stalk x)`
- L78-81 `def descResidueField {K : Type u} [Field K] {X : Scheme.{u}} {x : X} (f : X.presheaf.stalk x ⟶ .of K) [IsLocalHom f.hom] : X.residueField x ⟶ .of K := CommRingCat.ofHom (IsLocalRing.ResidueField.lift (S := K) f.hom)`
- L83-87 `@[reassoc (attr := simp)] lemma residue_descResidueField … : X.residue x ≫ X.descResidueField f = f`
- L96-97 `def evaluation (U : X.Opens) (x : X) (hx : x ∈ U) : Γ(X, U) ⟶ X.residueField x := X.presheaf.germ U x hx ≫ X.residue _`
- L99-100 `@[reassoc] lemma germ_residue (x hx) : X.presheaf.germ U x hx ≫ X.residue x = X.evaluation U x hx := rfl`
- L102-104 `abbrev Γevaluation (x : X) : Γ(X, ⊤) ⟶ X.residueField x := X.evaluation ⊤ x trivial`
- L106-113 `evaluation_eq_zero_iff_notMem_basicOpen`, `evaluation_ne_zero_iff_mem_basicOpen`
- L123-125 `def Hom.residueFieldMap (f : X ⟶ Y) (x : X) : Y.residueField (f x) ⟶ X.residueField x`
- L143-147 `@[reassoc] lemma evaluation_naturality {V : Opens Y} (x : X) (hx : f x ∈ V) : Y.evaluation V (f x) hx ≫ f.residueFieldMap x = f.app V ≫ X.evaluation (f ⁻¹ᵁ V) x hx`
- L154-157 `@[reassoc] lemma Γevaluation_naturality (x : X) : Y.Γevaluation (f x) ≫ f.residueFieldMap x = f.appTop ≫ X.Γevaluation x`
- L159-161 `Γevaluation_naturality_apply`
- L171-173 `def residueFieldCongr {x y : X} (h : x = y) : X.residueField x ≅ X.residueField y := eqToIso (by subst h; rfl)`
- L200-205 `@[reassoc] lemma residue_residueFieldCongr (X : Scheme) {x y : X} (h : x = y) : X.residue x ≫ (X.residueFieldCongr h).hom = (X.presheaf.stalkCongr (.of_eq h)).hom ≫ X.residue y`
- **L222-225** `def fromSpecResidueField (X : Scheme) (x : X) : Spec (X.residueField x) ⟶ X := Spec.map (X.residue x) ≫ X.fromSpecStalk x`
- L238-242 `@[reassoc (attr := simp)] lemma residueFieldCongr_fromSpecResidueField {x y : X} (h : x = y) : Spec.map (X.residueFieldCongr h).hom ≫ X.fromSpecResidueField _ = X.fromSpecResidueField _`
- L246-249 `@[reassoc (attr := simp)] lemma Hom.SpecMap_residueFieldMap_fromSpecResidueField (x : X) : Spec.map (f.residueFieldMap x) ≫ Y.fromSpecResidueField _ = X.fromSpecResidueField x ≫ f`
- L257-260 `@[simp] lemma fromSpecResidueField_apply (x : X.carrier) (s : Spec (X.residueField x)) : X.fromSpecResidueField x s = x`
- L262-263 `lemma range_fromSpecResidueField (x : X.carrier) : Set.range (X.fromSpecResidueField x) = {x}`
- L266-269 `lemma descResidueField_fromSpecResidueField {K} [Field K] (X : Scheme) {x} (f : X.presheaf.stalk x ⟶ .of K) [IsLocalHom f.hom] : Spec.map (X.descResidueField f) ≫ X.fromSpecResidueField x = Spec.map f ≫ X.fromSpecStalk x`
- L272-275 `lemma descResidueField_stalkClosedPointTo_fromSpecResidueField (K : Type u) [Field K] (X : Scheme.{u}) (f : Spec (.of K) ⟶ X) : Spec.map (descResidueField (Scheme.stalkClosedPointTo f)) ≫ X.fromSpecResidueField (f (closedPoint K)) = f`
- L325-333 `def SpecToEquivOfField (K : Type u) [Field K] (X : Scheme.{u}) : (Spec (.of K) ⟶ X) ≃ Σ x, X.residueField x ⟶ .of K` (`invFun xf := Spec.map xf.2 ≫ X.fromSpecResidueField xf.1`)

## 4. Stalk-level `appTop` lemma (the model for the missing one)

`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Stalk.lean`:

- L106-110 `lemma Scheme.fromSpecStalk_app {x : X} (hxU : x ∈ U) : (X.fromSpecStalk x).app U = X.presheaf.germ U x hxU ≫ (ΓSpecIso (X.presheaf.stalk x)).inv ≫ (Spec (X.presheaf.stalk x)).presheaf.map (homOfLE le_top).op`
- **L117-122** `lemma Scheme.fromSpecStalk_appTop {x : X} : (X.fromSpecStalk x).appTop = X.presheaf.germ ⊤ x trivial ≫ (ΓSpecIso (X.presheaf.stalk x)).inv ≫ (Spec (X.presheaf.stalk x)).presheaf.map (homOfLE le_top).op := fromSpecStalk_app ..`
- L205-207 `lemma Spec.fromSpecStalk_eq : (Spec R).fromSpecStalk x = Spec.map ((Scheme.ΓSpecIso R).inv ≫ (Spec R).presheaf.germ ⊤ x trivial)` (this is the key rewrite used in the proof of `Spec.map_residueFieldIso_inv_eq_fromSpecResidueField`)
- L214-215 `lemma Spec.fromSpecStalk_eq' : (Spec R).fromSpecStalk x = Spec.map (StructureSheaf.toStalk R _)`
- L180-184 `@[reassoc] lemma Scheme.fromSpecStalk_toSpecΓ (X : Scheme.{u}) (x : X) : X.fromSpecStalk x ≫ X.toSpecΓ = Spec.map (X.presheaf.germ ⊤ x trivial)`

Combining `Scheme.fromSpecStalk_appTop` with `ΓSpecIso_naturality` applied to `X.residue x` gives the general (non-affine) form: `(X.fromSpecResidueField x).appTop = X.Γevaluation x ≫ (ΓSpecIso (X.residueField x)).inv` (up to the `presheaf.map (homOfLE le_top).op` identity).

## 5. `Spec.stalkIso` (used to define `Spec.residueFieldIso`)

`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineScheme.lean:1274-1318`:

- L1278-1283 `noncomputable def Spec.stalkIso : (Spec R).presheaf.stalk x ≅ .of (Localization.AtPrime x.asIdeal) := (StructureSheaf.stalkIso ..).toCommRingCatIso.symm`
- L1285-1288 `@[reassoc (attr := simp)] lemma Spec.algebraMap_stalkIso_inv : CommRingCat.ofHom (algebraMap R _) ≫ (stalkIso R x).inv = (Scheme.ΓSpecIso R).inv ≫ (Spec R).presheaf.germ ⊤ x trivial`
- L1292-1295 `@[reassoc (attr := simp)] lemma Spec.germ_stalkMapIso_hom : (Spec R).presheaf.germ ⊤ _ trivial ≫ (stalkIso R x).hom = (Scheme.ΓSpecIso R).hom ≫ CommRingCat.ofHom (algebraMap _ _)`
- L1299-1305 `Scheme.localRingHom_comp_stalkIso`, L1310-1316 `Scheme.arrowStalkMapSpecIso`

So `(Spec R).residueField x` is *definitionally* `IsLocalRing.ResidueField ((Spec R).presheaf.stalk x)`, and `x.asIdeal.ResidueField` is `IsLocalRing.ResidueField (Localization.AtPrime x.asIdeal)`; `Spec.residueFieldIso` is `ResidueField.mapEquiv` of `Spec.stalkIso` — they are isomorphic but not defeq.

## 6. Algebraic residue field: `Ideal.ResidueField`

`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/RingTheory/LocalRing/ResidueField/Ideal.lean` (variables `(I : Ideal R) [I.IsPrime]`):

- L33-34 `abbrev Ideal.ResidueField : Type _ := IsLocalRing.ResidueField (Localization.AtPrime I)`
- L72-77 `@[simp high] lemma Ideal.algebraMap_residueField_eq_zero {x} : algebraMap R I.ResidueField x = 0 ↔ x ∈ I`
- **L79-82** `@[simp high] lemma Ideal.ker_algebraMap_residueField : RingHom.ker (algebraMap R I.ResidueField) = I := Ideal.ext fun _ ↦ Ideal.algebraMap_residueField_eq_zero`
- L137-140 `lemma Ideal.bijective_algebraMap_quotient_residueField (I : Ideal R) [I.IsMaximal] : Function.Bijective (algebraMap (R ⧸ I) I.ResidueField)`
- **L142-145** `lemma Ideal.algebraMap_residueField_surjective (I : Ideal R) [I.IsMaximal] : Function.Surjective (algebraMap R I.ResidueField)` — note the `[I.IsMaximal]` hypothesis (not just `IsPrime`)
- L103-108 `lemma Ideal.injective_algebraMap_quotient_residueField : Function.Injective (algebraMap (R ⧸ I) I.ResidueField)`
- L110 `instance : IsFractionRing (R ⧸ I) I.ResidueField`
- L163-166 `lemma Ideal.surjectiveOnStalks_residueField (I : Ideal R) [I.IsPrime] : (algebraMap R I.ResidueField).SurjectiveOnStalks`
- L152-156 `noncomputable def Ideal.algEquivResidueFieldOfField {k} [Field k] (p : Ideal k) [p.IsPrime] : k ≃ₐ[k] p.ResidueField`
- L209-213 `Ideal.ResidueField.lift`, L215-220 `Ideal.ResidueField.lift_algebraMap`, L240-243 `@[ext high] Ideal.ResidueField.ringHom_ext {f g : I.ResidueField →+* S} (H : f.comp (algebraMap R _) = g.comp (algebraMap R _)) : f = g` — this `ext` lemma is the practical way to prove appTop-type equalities into `κ(x)`
- L38-40 `Ideal.ResidueField.map`, L42-48 `Ideal.ResidueField.map_algebraMap`

`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/RingTheory/LocalRing/ResidueField/Basic.lean`:
- L44-46 `lemma IsLocalRing.residue_surjective : Function.Surjective (IsLocalRing.residue R) := Ideal.Quotient.mk_surjective`
- L34-35 `lemma IsLocalRing.ker_residue : RingHom.ker (residue R) = maximalIdeal R`
- L37-39 `@[simp] lemma IsLocalRing.residue_eq_zero_iff (x : R) : residue R x = 0 ↔ x ∈ maximalIdeal R`
- L59-61 `@[simp] theorem IsLocalRing.ResidueField.algebraMap_eq : algebraMap R (ResidueField R) = residue R := rfl`
- `IsLocalRing.residue` itself: `.../ResidueField/Defs.lean:36`

There is **no** `residue_eq` lemma in Mathlib (only `residue_def`, `Basic.lean:32`).

## 7. Function field / germToFunctionField

`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/FunctionField.lean`:
- L37 `noncomputable abbrev Scheme.functionField [IrreducibleSpace X] : CommRingCat`
- L41-42 `noncomputable abbrev Scheme.germToFunctionField [IrreducibleSpace X] (U : X.Opens) [h : Nonempty U] : Γ(X, U) ⟶ X.functionField`
- L65-66 `theorem Scheme.germToFunctionField_injective [IsIntegral X] (U : X.Opens) [Nonempty U] : Function.Injective (X.germToFunctionField U)`
- L109-110 `instance functionField_isFractionRing_of_affine (R : CommRingCat.{u}) [IsDomain R] : IsFractionRing R (Spec R).functionField`

Not directly about `fromSpecResidueField`.

## 8. Other relevant Mathlib sites

- `AlgebraicGeometry.residueFieldIsoBase` — `/home/.../Mathlib/AlgebraicGeometry/AlgClosed/Basic.lean:31-43`: `def residueFieldIsoBase : X.residueField x ≅ .of K` (for `f : X ⟶ Spec (.of K)`, `[LocallyOfFiniteType f]`, `K` alg. closed, `hx : IsClosed {x}`), plus L45-48 `@[simp, reassoc] lemma SpecMap_residueFieldIsoBase_inv : Spec.map (residueFieldIsoBase f x hx).inv = X.fromSpecResidueField x ≫ f` and L50-53 `def pointOfClosedPoint`. Used by `AlgebraicJacobian/RigidityLemma.lean:295`.
- `AlgebraicGeometry.Spec.fiberToSpecResidueFieldIso` — `Fiber.lean:71-86`: `Arrow.mk ((Spec.map (CommRingCat.ofHom <| algebraMap R S)).fiberToSpecResidueField p) ≅ Arrow.mk (Spec.map <| CommRingCat.ofHom <| algebraMap p.asIdeal.ResidueField (p.asIdeal.Fiber S))` — this is the canonical example of "translate `fromSpecResidueField` on an affine into `algebraMap R κ(p)`", and its proof (L80-85) is the template: `pullback.congrHom (Scheme.Spec.map_residueFieldIso_inv_eq_fromSpecResidueField (.of R) p).symm rfl`.
- `Scheme.Hom.fiber` / `fiberι` / `fiberToSpecResidueField` — `Fiber.lean:38, 142-146`.

## 9. Project usages (existing precedent for this exact manipulation)

- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeFibrePoint.lean:46-55, 70-79, 94-98` — the idiom `rw [← Scheme.Spec.map_residueFieldIso_inv_eq_fromSpecResidueField]; simp only [Category.assoc, ← Spec.map_comp]; rfl` to turn `(Spec R).fromSpecResidueField p` into `Spec.map (ofHom (algebraMap R p.asIdeal.ResidueField))` precomposed with `Spec.map e.hom`. Line 95-98 is the cleanest:
  ```lean
  have hfac : Spec.map (CommRingCat.ofHom (algebraMap R K)) =
      Spec.map e.hom ≫ (Spec (CommRingCat.of R)).fromSpecResidueField p
  ```
  where `e := Scheme.Spec.residueFieldIso (CommRingCat.of R) p`, `K := p.asIdeal.ResidueField`.
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0AbelianVariety.lean:276-296` — `theorem residueFieldIso_of_section_over_field`, built as `Scheme.Spec.residueFieldIso (.of k) default ≪≫ ?_`.
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/HilbertPolynomial.lean:89` — the only place in your project that composes `ΓSpecIso` with a residue-field morphism's `appTop`: `(Scheme.ΓSpecIso (S.residueField s)).inv ≫ (π.fiberToSpecResidueField s).appTop`. This is the closest existing shape to what you want.
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/CurveMorphismDichotomy.lean:99` `theorem Scheme.Hom.ker_fromSpecResidueField_le` and `:142` `theorem Scheme.Hom.exists_comp_fromSpecResidueField_eq` — project-local additions about `fromSpecResidueField`, worth reading if you need kernel statements.
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/GeometricallyConnectedSection.lean:318-352` — uses `descResidueField_stalkClosedPointTo_fromSpecResidueField` and `Spec.map_surjective` to invert `fromSpecResidueField ≫ f`.

## Bottom line

You will have to state and prove the `appTop` lemma yourself. The one-line proof is:

```lean
rw [← Scheme.Spec.map_residueFieldIso_inv_eq_fromSpecResidueField, Scheme.comp_appTop]
simp [Scheme.ΓSpecIso_naturality]   -- or: ← Scheme.Spec.algebraMap_residueFieldIso_inv
```

giving `((Spec R).fromSpecResidueField x).appTop = (Scheme.ΓSpecIso R).hom ≫ CommRingCat.ofHom (algebraMap R x.asIdeal.ResidueField) ≫ (Scheme.Spec.residueFieldIso R x).inv ≫ (Scheme.ΓSpecIso ((Spec R).residueField x)).inv`, which by `Scheme.Spec.algebraMap_residueFieldIso_inv` (`ResidueField.lean:292`) collapses to `(Spec R).Γevaluation x ≫ (Scheme.ΓSpecIso _).inv`.
