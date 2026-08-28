## Mathlib location note

Mathlib is **not** at `<project>/.lake/packages/` — it's at:
`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/`

This is a **post-`Cover`-refactor mathlib** (`Cover = Precoverage.ZeroHypercover`). The index field is `I₀` (not `J`), the objects are `X`, the maps are `f`, and there is a `mem₀` proof field instead of `covers`. `𝒰.covers`/`𝒰.idx` are now *derived* lemmas.

---

## 1. Gluing: `Scheme.Cover.glueMorphisms`, `hom_ext`, `ι_glueMorphisms`

All in `namespace AlgebraicGeometry.Scheme.Cover` in
`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Gluing.lean`

**`Gluing.lean:439`** — full name `AlgebraicGeometry.Scheme.Cover.glueMorphisms`
```lean
def glueMorphisms (𝒰 : OpenCover.{v} X) {Y : Scheme.{u}} (f : ∀ x, 𝒰.X x ⟶ Y)
    (hf : ∀ x y, pullback.fst (𝒰.f x) (𝒰.f y) ≫ f x = pullback.snd _ _ ≫ f y) :
    X ⟶ Y
```
The agreement hypothesis is stated on the **categorical pullback** `pullback (𝒰.f x) (𝒰.f y)`, not on opens intersections.

**`Gluing.lean:451`** — `AlgebraicGeometry.Scheme.Cover.hom_ext` (this is your uniqueness lemma)
```lean
theorem hom_ext (𝒰 : OpenCover.{v} X) {Y : Scheme} (f₁ f₂ : X ⟶ Y)
    (h : ∀ x, 𝒰.f x ≫ f₁ = 𝒰.f x ≫ f₂) : f₁ = f₂
```

**`Gluing.lean:462`** — `AlgebraicGeometry.Scheme.Cover.ι_glueMorphisms`, tagged `@[reassoc (attr := simp)]` (so `ι_glueMorphisms_assoc` exists and it fires by `simp`)
```lean
theorem ι_glueMorphisms (𝒰 : OpenCover.{v} X) {Y : Scheme} (f : ∀ x, 𝒰.X x ⟶ Y)
    (hf : ∀ x y, pullback.fst (𝒰.f x) (𝒰.f y) ≫ f x = pullback.snd _ _ ≫ f y)
    (x : 𝒰.I₀) : 𝒰.f x ≫ 𝒰.glueMorphisms f hf = f x
```

Note `𝒰 : OpenCover X` is required (`abbrev OpenCover X := Cover.{v} (precoverage @IsOpenImmersion) X`), so `[HasPullback ...]` is automatic.

---

## 2. `affineCover`, `affineOpenCover`, `AffineOpenCover`

File: `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Cover/Open.lean`

- **`Cover/Open.lean:40`** `abbrev OpenCover (X : Scheme.{u}) : Type _ := Cover.{v} (precoverage @IsOpenImmersion) X`
- **`Cover/Open.lean:49`** `def affineCover (X : Scheme.{u}) : OpenCover X` — **index type `I₀ := X` (the underlying point set!)**, `X x := Spec (R x)`, `f x := ⟨(e x).inv ≫ X.toLocallyRingedSpace.ofRestrict _⟩`.
- **`Cover/Open.lean:118`** `abbrev AffineOpenCover (X : Scheme.{u}) : Type _ := AffineCover.{v} @IsOpenImmersion X`
- **`Cover/Open.lean:128`** `@[simps! I₀ X f] def AffineOpenCover.openCover {X : Scheme.{u}} (𝒰 : X.AffineOpenCover) : X.OpenCover := AffineCover.cover 𝒰`
- **`Cover/Open.lean:136`** `@[simps] def affineOpenCover (X : Scheme.{u}) : X.AffineOpenCover` with `I₀ := X.affineCover.I₀` (= `X`), `f := X.affineCover.f`, `idx x := ...`, `covers x := ...`
- **`Cover/Open.lean:144`** `@[simp] lemma openCover_affineOpenCover (X : Scheme.{u}) : X.affineOpenCover.openCover = X.affineCover := rfl`
- **`Cover/Open.lean:202`** `@[simps] def affineOpenCoverOfSpanRangeEqTop {R : CommRingCat} {ι : Type*} (s : ι → R) (hs : Ideal.span (Set.range s) = ⊤) : (Spec R).AffineOpenCover` — this is the one your project already uses heavily.

**The `Cover` structure** (`Cover/MorphismProperty.lean:50`, via `PreZeroHypercover` at `Mathlib/CategoryTheory/Sites/Hypercover/Zero.lean:35`):
```lean
abbrev Cover (K : Precoverage Scheme.{u}) := Precoverage.ZeroHypercover.{v} K
-- fields: I₀ : Type w, X (i : I₀) : Scheme, f (i : I₀) : X i ⟶ S, mem₀ : presieve₀ ∈ K S
```
Derived API (`Cover/MorphismProperty.lean`):
- `:55` `Cover.exists_eq [JointlySurjective K] (𝒰 : X.Cover K) (x : X) : ∃ i y, 𝒰.f i y = x`
- `:61` `Cover.idx`, `:65` `Cover.covers (𝒰) (x) : x ∈ Set.range (𝒰.f (𝒰.idx x))`
- `:88` `Cover.map_prop (𝒰 : X.Cover (precoverage P)) (i : 𝒰.I₀) : P (𝒰.f i)`
- `:83` `presieve₀_mem_precoverage_iff (E : PreZeroHypercover X) : E.presieve₀ ∈ precoverage P X ↔ (∀ x, ∃ i, x ∈ Set.range (E.f i)) ∧ ∀ i, P (E.f i)`

**`AffineCover` structure** — `Cover/MorphismProperty.lean:192`
```lean
structure AffineCover (P : MorphismProperty Scheme.{u}) (S : Scheme.{u}) where
  I₀ : Type v
  X (j : I₀) : CommRingCat.{u}
  f (j : I₀) : Spec (X j) ⟶ S
  idx (x : S) : I₀
  covers (x : S) : x ∈ Set.range (f (idx x))
  map_prop (j : I₀) : P (f j) := by infer_instance
```
with `AffineCover.cover` at `:208`.

### Cover indexed by `X.affineOpens` — YES, it exists

**`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Cover/Directed.lean:308`**
```lean
@[simps I₀ X f]
def directedAffineCover : X.OpenCover where
  I₀ := X.affineOpens
  X U := U
  f U := U.1.ι
  mem₀ := ...
```
i.e. `AlgebraicGeometry.Scheme.directedAffineCover (X : Scheme) : X.OpenCover`, with `I₀ = X.affineOpens`, `X U = ↥(U : X.Opens)`, `f U = U.1.ι`. It also carries `Preorder` (`:318`) and `Cover.LocallyDirected` (`:321`) instances, and `directedAffineCover_trans` at `:326`.

Also available:
- **`Restrict.lean:179`** `@[simps! I₀ X f] def Scheme.openCoverOfIsOpenCover {s : Type*} (X : Scheme.{u}) (U : s → X.Opens) (hU : IsOpenCover U) : X.OpenCover` with `I₀ := s`, `X i := U i`, `f i := (U i).ι`.
  - `TopologicalSpace.IsOpenCover u` is `def ... : Prop := iSup u = ⊤` (`Mathlib/Topology/Sets/OpenCover.lean:25`), so `iSup_affineOpens_eq_top X` is *directly* usable: mathlib writes `X.openCoverOfIsOpenCover _ (iSup_affineOpens_eq_top X)` (e.g. `IdealSheaf/Subscheme.lean:503,680,692`).
- **`AffineScheme.lean:311`** `theorem iSup_affineOpens_eq_top (X : Scheme) : ⨆ i : X.affineOpens, (i : X.Opens) = ⊤`
- **`AffineScheme.lean:255`** `def Scheme.affineOpens (X : Scheme) : Set X.Opens := {U | IsAffineOpen U}`; `AffineScheme.lean:258` gives `instance (U : Y.affineOpens) : IsAffine U`.
- **`Restrict.lean:316`** `def Scheme.Opens.iSupOpenCover {J : Type*} {X : Scheme} (U : J → X.Opens) : (⨆ i, U i).toScheme.OpenCover`
- **`Cover/Open.lean:277`** `def affineBasisCover (X : Scheme.{u}) : OpenCover X`

---

## 3. Ext lemmas ("agree on a cover ⇒ equal")

- **Primary: `Gluing.lean:451` `Scheme.Cover.hom_ext`** (signature above). This is what you want.
- **`Gluing.lean:474`** — a very convenient pointwise version, no cover needed:
```lean
lemma Scheme.hom_ext_of_forall {X Y : Scheme} (f g : X ⟶ Y)
    (H : ∀ x : X, ∃ U : X.Opens, x ∈ U ∧ U.ι ≫ f = U.ι ≫ g) : f = g
```
(its proof builds the cover with `I₀ := X` via `presieve₀_mem_precoverage_iff` — a good template if you need a bespoke cover.)
- **`Cover/Open.lean:225`** sections version: `lemma Scheme.OpenCover.ext_elem {X : Scheme.{u}} {U : X.Opens} (f g : Γ(X, U)) (𝒰 : X.OpenCover) (h : ∀ i : 𝒰.I₀, (𝒰.f i).app U f = (𝒰.f i).app U g) : f = g`
- **`Scheme.lean:250`** low-level: `protected lemma Scheme.Hom.ext' {f g : X ⟶ Y} (h : f.toLRSHom = g.toLRSHom) : f = g`
- Separatedness-flavoured ext (not cover-based): `Morphisms/Separated.lean:287` `ext_of_isDominant_of_isSeparated`, `:321` `ext_of_isDominant_of_isSeparated'`, `:373` `ext_of_isDominant`.

---

## 4. `IsAffineOpen.fromSpec`

File: `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineScheme.lean`, in section with `variable {X : Scheme} {U : X.Opens} (hU : IsAffineOpen U)`.

- **`:422`**
```lean
def fromSpec : Spec Γ(X, U) ⟶ X :=
  haveI : IsAffine U := hU
  hU.isoSpec.inv ≫ U.ι
```
- **`:427`** `instance isOpenImmersion_fromSpec : IsOpenImmersion hU.fromSpec`
- **`:433`** `@[reassoc (attr := simp)] lemma isoSpec_inv_ι : hU.isoSpec.inv ≫ U.ι = hU.fromSpec := rfl` ← **the `Scheme.Opens.ι` / `ofRestrict` link** (`Scheme.Opens.ι : ↑U ⟶ X := X.ofRestrict _`, `Restrict.lean:52`)
- **`:436`** `@[reassoc (attr := simp)] lemma toSpecΓ_fromSpec : U.toSpecΓ ≫ hU.fromSpec = U.ι`
- **`:441`** `@[simp] theorem range_fromSpec : Set.range hU.fromSpec = U` (this is the "`fromSpec_range`" you were looking for — it's named `range_fromSpec`)
- **`:456`** `@[simp] theorem opensRange_fromSpec : hU.fromSpec.opensRange = U`
- **`:460`** `@[reassoc (attr := simp)] theorem map_fromSpec {V : X.Opens} (hV : IsAffineOpen V) (f : op U ⟶ op V) : Spec.map (X.presheaf.map f) ≫ hU.fromSpec = hV.fromSpec`
- **`:473`** `lemma SpecMap_appLE_fromSpec (f : X ⟶ Y) {V : X.Opens} {U : Y.Opens} (hU : IsAffineOpen U) (hV : IsAffineOpen V) (i : V ≤ f ⁻¹ᵁ U) : Spec.map (f.appLE U V i) ≫ hU.fromSpec = hV.fromSpec ≫ f` ← **key for the compatibility/agreement hypothesis**
- **`:485`** `lemma fromSpec_top [IsAffine X] : (isAffineOpen_top X).fromSpec = X.isoSpec.inv`
- **`:558`** `theorem fromSpec_preimage_self : hU.fromSpec ⁻¹ᵁ U = ⊤`
- **`:490`** `fromSpec_app_of_le`, **`:569`** `fromSpec_app_self`, **`:579/583`** `fromSpec_preimage_basicOpen` / `fromSpec_image_basicOpen`
- There is **no** `fromSpec_image_top`; use `range_fromSpec` / `opensRange_fromSpec`.

---

## 5. Building a cover from `{ W.2.fromSpec | W : X.affineOpens }`

- **`Cover/MorphismProperty.lean:97`** — `@[simps!]`
```lean
def Cover.mkOfCovers (J : Type*) (obj : J → Scheme.{u}) (map : (j : J) → obj j ⟶ X)
    (covers : ∀ x, ∃ j y, map j y = x)
    (map_prop : ∀ j, P (map j) := by infer_instance) : X.Cover (precoverage P)
```
(full name `AlgebraicGeometry.Scheme.Cover.mkOfCovers`; your project already uses it at `AlgebraicJacobian/Curve/GeometricallyReduced.lean:123`.)

For the `fromSpec` family specifically, the cleanest route is an `AffineOpenCover` literal (mathlib does exactly this in `IdealSheaf/Subscheme.lean:499` and `Cover/QuasiCompact.lean:190`):
```lean
def X.affineOpensCover : X.AffineOpenCover where
  I₀ := X.affineOpens
  X U := Γ(X, U.1)          -- CommRingCat
  f U := U.2.fromSpec
  idx x := ⟨W x, hW x⟩       -- from X.isBasis_affineOpens / iSup_affineOpens_eq_top
  covers x := by rw [IsAffineOpen.range_fromSpec] ...   -- membership in U
```
`Cover/QuasiCompact.lean:195-201` is a working template for the `covers` field with `fromSpec`:
```lean
f i := (hV _).fromSpec ≫ 𝒰.f (f _)
covers s := by
  use (hV _).isoSpec.hom.base ⟨x s, hmem s⟩
  rw [← Scheme.Hom.comp_apply, ← IsAffineOpen.isoSpec_inv_ι, Category.assoc, Iso.hom_inv_id_assoc]
  simp [hx]
```
Alternatively, since `𝒰.f U = U.1.ι` in `directedAffineCover` and `U.2.isoSpec.inv ≫ U.1.ι = U.2.fromSpec`, you can get a `fromSpec`-cover from `directedAffineCover` by `Cover.copy` (`Cover/MorphismProperty.lean:~130`, `def Cover.copy [P.RespectsIso] (𝒰) (J) (obj) (map) (e₁ : J ≃ 𝒰.I₀) (e₂ : ∀ i, obj i ≅ 𝒰.X (e₁ i)) (h : ∀ i, map i = (e₂ i).hom ≫ 𝒰.f (e₁ i)) : X.Cover (precoverage P)`) with `e₂ U := U.2.isoSpec.symm`.

---

## 6. Project uses

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/`

**`Picard/Pic0SigmaSheaf.lean` (the file you flagged)** — this is the closest existing template to what you want:
- `:94` `obtain ⟨𝓤, rfl⟩ := Scheme.exists_cover_of_mem_pretopology hS` — turns a pretopology member into an `OpenCover` (mathlib: `Sites/Pretopology.lean:78`, alias of `mem_pretopology_iff`).
- `:99-103` `hpair : ∀ i j, pullback.fst (𝓤.f i) (𝓤.f j) ≫ (x i).1 = pullback.snd (𝓤.f i) (𝓤.f j) ≫ (x j).1` — builds the agreement hypothesis from a `Presieve` compatibility `hx`, via `congrArg Sigma.fst`.
- **`:104-105`** the glue itself:
  ```lean
  ⟨𝓤.glueMorphisms (fun i => (x i).1) hpair,
    fun i => 𝓤.ι_glueMorphisms (fun i => (x i).1) hpair i⟩
  ```
  producing `∃ aY : Y ⟶ Spec (.of k), ∀ i, 𝓤.f i ≫ aY = (x i).1`.
- `:107` uses `𝓤.map_prop i` to get `IsOpenImmersion` of an `Over.homMk` left leg.
- `:113` uses `𝓤.exists_eq p` for surjectivity of the induced slice cover.
- **`:136`** uniqueness: `obtain rfl : aY = a' := 𝓤.hom_ext aY a' fun i => ...` — exactly the "two morphisms agreeing on a cover are equal" pattern.

**Other sites:**
- `Picard/DivRepClassifyZar.lean:140-147` — builds `hglue` (the `pullback.fst ≫ v p = pullback.snd ≫ v q` agreement) for the cover `(Scheme.affineOpenCoverOfSpanRangeEqTop (R := CommRingCat.of S) r hspan).openCover`.
- `Picard/DivRepClassifyZar.lean:148` — `... .openCover.glueMorphisms v hglue` constructs the classifying morphism `Spec S ⟶ DivScheme ...`.
- `Picard/DivRepClassifyZar.lean:150-157` — `Scheme.Cover.hom_ext` on `... .openCover.pullback₁ (Spec.map ...)`, then `pullback.condition` + `Scheme.Cover.ι_glueMorphisms_assoc` to verify the glued morphism satisfies the clause after base change.
- `Picard/DivRepClassifyZar.lean:178-181` — `isDivRepClassify_unique`: `Scheme.Cover.hom_ext` on the affine cover, per-piece by `divScheme_hom_ext`.
- `Picard/DivRepClassifyZarKit.lean:315-318` — `Scheme.Cover.hom_ext` on `... .openCover.pullback₁ (Spec.map (CommRingCat.ofHom (algebraMap S T)))` (tower/base-change version).
- `Picard/DivSchemeKeyChart.lean:433-435` — `apply Scheme.Cover.hom_ext ((Scheme.affineOpenCoverOfSpanRangeEqTop (R := CommRingCat.of S) f hf).openCover)` to check a triangle over `Spec k`.
- `Picard/Separatedness.lean:61-67` — `X.affineCover` fed to `IsZariskiLocalAtSource.iff_of_openCover (P := @Flat)`; uses `X.affineCover.f i ≫ f` and `Spec.preimage`.
- `Curve/GeometricallyReduced.lean:123-124` — `Scheme.Cover.mkOfCovers X (fun x ↦ (V x).toScheme) (fun x ↦ (V x).ι) (fun x ↦ ⟨x, ⟨x, hxV x⟩, rfl⟩) (fun x ↦ inferInstance)` builds an `X.OpenCover` from a chosen affine open at each point — **the closest existing template for "cover from a family of opens"**.
- `Curve/SeparablyClosedPoints.lean:113-125` — `hV.fromSpec` composed with `Spec.map`; uses `IsAffineOpen.SpecMap_appLE_fromSpec` and `IsAffineOpen.fromSpec_top`.
- `Curve/StalksDVR.lean:82-96` — `hV.fromSpec_primeIdealOf`, `hV.fromSpec.isOpenEmbedding.isInducing`, `genericPoint_eq_of_isOpenImmersion hV.fromSpec`.
- `Curve/GraphFibre.lean:62` — `hom_ext` here is `CartesianMonoidalCategory.hom_ext` (product ext), **not** cover ext.
- `Picard/GrassmannianPairCompare.lean:60`, `Albanese/Milne33Diagonal.lean:84,187,249`, `Albanese/Milne33RowSection.lean:193,221` — `Limits.pullback.hom_ext`, unrelated.

---

## Recommended shape for your task

```lean
-- glue
noncomputable def myHom : X ⟶ Y :=
  X.directedAffineCover.glueMorphisms (fun U => g U) hcompat
-- where hcompat : ∀ U V, pullback.fst (U.1.ι) (V.1.ι) ≫ g U = pullback.snd _ _ ≫ g V

-- restriction property
example (U) : X.directedAffineCover.f U ≫ myHom = g U :=
  X.directedAffineCover.ι_glueMorphisms _ _ U   -- also a `simp` lemma

-- uniqueness
example (f₁ f₂ : X ⟶ Y) (h : ∀ U : X.affineOpens, U.1.ι ≫ f₁ = U.1.ι ≫ f₂) : f₁ = f₂ :=
  X.directedAffineCover.hom_ext f₁ f₂ h
```
If you'd rather index by `fromSpec`, use `Scheme.Cover.mkOfCovers X.affineOpens (fun U => Spec Γ(X, U.1)) (fun U => U.2.fromSpec) covers` with `covers` discharged from `IsAffineOpen.range_fromSpec` + `iSup_affineOpens_eq_top`/`isBasis_affineOpens`; `map_prop` is `inferInstance` via `IsAffineOpen.isOpenImmersion_fromSpec`. Then `U.2.fromSpec ≫ f₁ = U.2.fromSpec ≫ f₂ ↔ U.1.ι ≫ f₁ = U.1.ι ≫ f₂` via `IsAffineOpen.isoSpec_inv_ι` and `cancel_epi`/`Iso` cancellation.
