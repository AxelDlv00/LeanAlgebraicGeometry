Investigation complete. Report below.

## 1. `relPic` — definition and what its elements are

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/RelPic.lean`

```lean
-- :54   (variables: {k : Type u} [Field k] (C : Over (Spec (.of k))))
def picFromBase (T : Over (Spec (.of k))) : Subgroup ((C ⊗ T).left.CechPic) :=
  (CechPic.map (snd C T).left).range
-- :57
lemma mem_picFromBase_iff {T : Over (Spec (.of k))} {L : (C ⊗ T).left.CechPic} :
    L ∈ picFromBase C T ↔ ∃ N : T.left.CechPic, CechPic.map (snd C T).left N = L
-- :63
def relPic (T : Over (Spec (.of k))) : Type u :=
  (C ⊗ T).left.CechPic ⧸ picFromBase C T
-- :66  instance : CommGroup (relPic C T)   (QuotientGroup)
-- :70
noncomputable def relPicMk (T : Over (Spec (.of k))) :
    (C ⊗ T).left.CechPic →* relPic C T := QuotientGroup.mk' (picFromBase C T)
-- :74  relPicMk_surjective
-- :80  relPicMk_eq_relPicMk_iff : relPicMk C T L = relPicMk C T L' ↔ L / L' ∈ picFromBase C T
-- :86  @[elab_as_elim] relPic.ind
-- :95  picFromBase_le_comap (g : T' ⟶ T)
-- :106 relPicMap (g : T' ⟶ T) : relPic C T →* relPic C T'   (via CechPic.map (C ◁ g).left)
-- :111 @[simp] relPicMap_mk, :115 relPicMap_id, :122 relPicMap_comp
-- :133 relPicFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ CommGrpCat.{u}
-- :160 picFromBase_le_comap_whiskerRight, :171 relPicMapCurveApp, :185 relPicMapCurve
```

So **an element of `relPic C T` is a coset of a `Scheme.CechPic` class** — not a sheaf, not a module. Concretely, unrolling `Picard/Pic.lean` and `Picard/UnitsCocycle.lean`:

`Picard/Pic.lean`
```lean
-- :43  instance cechPicSetoid (X) : Setoid (Σ 𝒰 : X.PointedCover, X.unitsH1 𝒰)
--        r p q := ∃ 𝒲 (h₁ : 𝒲 ≤ p.1) (h₂ : 𝒲 ≤ q.1), unitsRes h₁ p.2 = unitsRes h₂ q.2
-- :60  def CechPic (X : Scheme.{u}) : Type u := Quotient (cechPicSetoid X)
-- :66  def mk (𝒰 : X.PointedCover) (a : X.unitsH1 𝒰) : X.CechPic := ⟦⟨𝒰, a⟩⟧
-- :70  ind, :75 mk_eq_mk_iff, :84 @[simp] mk_unitsRes, :117 CommGroup instance,
-- :156 one_def, :161 mk_mul_mk_inf, :167 mk_one, :171 mk_mul_mk, :178 mk_inv
-- :198 def map (f : X ⟶ Y) : Y.CechPic →* X.CechPic
-- :217 @[simp] map_mk, :223 map_id, :237 map_comp
-- :257 instance subsingleton_of_subsingleton [Subsingleton X] : Subsingleton X.CechPic
-- :268 eq_one_of_subsingleton
```

`Picard/UnitsCocycle.lean`
```lean
-- :94  structure PointedCover (X : Scheme.{u}) : Type u where
--         opens : X → X.Opens ; mem_opens : ∀ x, x ∈ opens x
-- :107 SemilatticeInf (pointwise ⊓, le = ∀ x, 𝒱.opens x ≤ 𝒰.opens x), :119 OrderTop
-- :137 def pullback (f : X ⟶ Y) (𝒰 : Y.PointedCover) : X.PointedCover  (x ↦ f ⁻¹ᵁ 𝒰.opens (f.base x))
-- :155 abbrev unitsCocycle (X) (𝒰) := PresheafOfGroups.OneCocycle (X.unitsPresheaf ⋙ forget₂ CommGrpCat GrpCat) 𝒰.opens
-- :159 abbrev unitsH1   (X) (𝒰) := PresheafOfGroups.H1     (X.unitsPresheaf ⋙ forget₂ CommGrpCat GrpCat) 𝒰.opens
-- :164 def unitsRes {𝒰 𝒱} (h : 𝒱 ≤ 𝒰) : X.unitsH1 𝒰 →* X.unitsH1 𝒱
-- :187 def unitsEvInf (γ : X.unitsCocycle 𝒰) (i j : X) : Γ(X, 𝒰.opens i ⊓ 𝒰.opens j)ˣ
-- :193 abbrev unitsRestrict (X) {U W} (h : W ≤ U) : Γ(X, U)ˣ →* Γ(X, W)ˣ
-- :208 unitsEvInf_trans (cocycle law), :221 res_unitsEvInf
-- :249 Hom.pullbackUnitsCocycle, :345 Hom.pullbackUnitsH1, :361 unitsRes_pullbackUnitsH1
```

Note the index set of a `PointedCover` is *the carrier of `X`* (one open per point). That is the key structural mismatch with a 2-affine cover: a 2-affine cover has to be turned into a pointed cover by a chart selector `X → Fin 2`/`PUnit ⊕ PUnit` (the pattern used by `thetaFieldChartIndex`, below).

`relPicAlgMap` — `AlgebraicJacobian/Picard/RelPicAlgebra.lean`
```lean
-- :44  noncomputable def Over.overSpecMap (f : A →ₐ[k] B) : overSpec k B ⟶ overSpec k A
-- :50 overSpecMap_left, :68 overSpecMap_id, :73 overSpecMap_comp
-- :88
noncomputable def relPicAlgMap (f : A →ₐ[k] B) :
    relPic C (overSpec k A) →* relPic C (overSpec k B) := relPicMap C (Over.overSpecMap f)
-- :93 relPicAlgMap_id, :98 relPicAlgMap_comp
```
`overSpec` is `AlgebraicJacobian/Cohomology/SectionsBaseChange.lean:97`: `noncomputable abbrev overSpec (k) (A) : Over (Spec (.of k)) := Over.mk (Spec.map (CommRingCat.ofHom (algebraMap k A)))`, with `overSpec_left : (overSpec k A).left = Spec (.of A) := rfl` (:101).

**There is no `PicSharp.relPresheaf` in AJCR.** That name is the *sibling* project's (`MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RelPicFunctor.lean:855`, `AddCommGrpCat.{u+1}`-valued, quotient-setoid carrier). AJCR's only mention is a docstring cross-reference at `Tangent/DualNumberTestObject.lean:57`. Do not write against it here.

## 2. The two-affine-cover Čech machinery, and the landed keystone

There is **no `AffineCoverMVSquare`** in AJCR (that is a sibling name). AJCR's analogues:

`AlgebraicJacobian/Picard/AffineTwoCover.lean`
```lean
-- :51
structure Scheme.AffineTwoCover (Y : Scheme.{u}) : Type u where
  V₀ : Y.Opens
  V₁ : Y.Opens
  isAffineOpen₀ : IsAffineOpen V₀
  isAffineOpen₁ : IsAffineOpen V₁
  sup_eq_top : V₀ ⊔ V₁ = ⊤
  isAffineOpen_inf : IsAffineOpen (V₀ ⊓ V₁)
-- :67 inf_le_left, :73 inf_le_right
-- :91 theorem Scheme.AffineTwoCover.nonempty_of_curve : Nonempty C.left.AffineTwoCover
--        [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
-- :118 instance Over.isAffineHom_fst_left {S} (X T : Over S) [IsAffineHom T.hom] : IsAffineHom (fst X T).left
-- :125 instance isAffine_overSpec_left, :131 instance isAffineHom_overSpec_hom
-- :146 noncomputable def Scheme.AffineTwoCover.pullbackProd (D : C.left.AffineTwoCover)
--        (R) [CommRing R] [Algebra k R] : (C ⊗ overSpec k R).left.AffineTwoCover
```

`AlgebraicJacobian/Cohomology/TwoCover.lean` (`namespace AlgebraicGeometry`, then `TwoCover`; vars `(k) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))] (U₀ U₁ : X.Opens)`, `attribute [local instance] Scheme.overModule`)
```lean
-- :68  noncomputable def Scheme.twoCoverSquare (hcov : U₀ ⊔ U₁ = ⊤) :
--         (Opens.grothendieckTopology (X : TopCat)).MayerVietorisSquare
-- :92  noncomputable def Scheme.twoCoverH1LinearEquiv (F : Sheaf … (ModuleCat.{u} k))
--         (hcov) [Subsingleton (Sheaf.HModule' F U₀ 1)] [Subsingleton (Sheaf.HModule' F U₁ 1)] :
--         Sheaf.HModule F 1 ≃ₗ[k] (F.obj.obj (op (U₀ ⊓ U₁)) ⧸ LinearMap.range ((X.twoCoverSquare U₀ U₁ hcov).moduleDiff F))
-- :118 noncomputable def diff : (Γ(X, U₀) × Γ(X, U₁)) →ₗ[k] Γ(X, U₀ ⊓ U₁)
-- :124 diff_apply : diff k X U₀ U₁ t = X.resHom inf_le_left t.1 - X.resHom inf_le_right t.2
-- :130 diff_eq_moduleDiff
-- :138 noncomputable abbrev H1Cok : Type u := Γ(X, U₀ ⊓ U₁) ⧸ LinearMap.range (diff k X U₀ U₁)
-- :142 h1Cok_mk_resHom_left, :148 h1Cok_mk_resHom_right
-- :161 noncomputable def delta : Γ(X, U₀ ⊓ U₁) →ₗ[k] Sheaf.HModule (X.moduleKSheaf k) 1   (needs hcov)
-- :168 delta_diff, :181 delta_resHom_left, :189 delta_resHom_right
-- :201 delta_surjective (needs hU₀ hU₁)
-- :226 noncomputable def h1CokEquiv (hcov : U₀ ⊔ U₁ = ⊤) (hU₀ : IsAffineOpen U₀) (hU₁ : IsAffineOpen U₁) :
--         Sheaf.HModule (X.moduleKSheaf k) 1 ≃ₗ[k] H1Cok k X U₀ U₁
-- :240 h1CokEquiv_delta, :269 h1CokEquiv_symm_mk
```
`X.resHom` is `AlgebraicJacobian/Cohomology/AffineCech.lean:55`; `moduleDiff` / `moduleDelta` / `h1LinearEquiv` are `AlgebraicJacobian/Cohomology/MayerVietoris.lean:161 / :207 / :352` (with `moduleDelta_moduleDiff:219`, `moduleDelta_surjective:319`, `h1LinearEquiv_mk`). **There is no `sectionDiff`** in AJCR — the name is `TwoCover.diff`.

`AlgebraicJacobian/Tangent/TruncExpUnits.lean` (namespace `TruncExpCech`, `open TrivSqZeroExt DualNumber`, `variable {R S T} [CommRing …]`)
```lean
-- :75  def truncExpUnit (b : R) : (R[ε])ˣ := Units.mkOfMulEqOne (1 + inr b) (1 - inr b) …
-- :82 truncExpUnit_val, :86 fst_truncExpUnit, :90 snd_truncExpUnit, :95 truncExpUnit_zero
-- :99 truncExpUnit_add, :108 truncExpUnit_injective
-- :116 def truncExp : Multiplicative R →* (R[ε])ˣ ; :122 truncExp_apply
-- :129 def fstRingHom : R[ε] →+* R ; :137 fstRingHom_apply
-- :142 def inlRingHom : R →+* R[ε]
-- :151 def unitsFst : (R[ε])ˣ →* Rˣ := Units.map fstRingHom.toMonoidHom
-- :159 def unitsInl : Rˣ →* (R[ε])ˣ
-- :169 unitsFst_unitsInl, :174 unitsFst_truncExpUnit
-- :191 truncExp_range_eq_ker_unitsFst : (truncExp (R := R)).range = (unitsFst (R := R)).ker
-- :208 unitsInl_unitsFst_mul_truncExpUnit (u : (R[ε])ˣ) :
--         unitsInl (unitsFst u) * truncExpUnit ((u⁻¹ : (R[ε])ˣ).fst * (u : R[ε]).snd) = u
-- :226 def mapRingHom (f : R →+* S) : R[ε] →+* S[ε]   (x ↦ inl (f x.fst) + inr (f x.snd))
-- :240 fst_mapRingHom, :245 snd_mapRingHom, :250 mapRingHom_id, :254 mapRingHom_comp,
-- :260 mapRingHom_inl, :265 unitsMap_mapRingHom_unitsInl, :272 map_mapRingHom_truncExpUnit,
-- :285 unitsFst_map_mapRingHom
-- :297 def scaleRingHom (a : R) : R[ε] →+* R[ε]  (:301/:305/:309/:314/:319 unitsScale_truncExpUnit, :325 mapRingHom_comp_scaleRingHom)
```

`AlgebraicJacobian/Tangent/TruncExpCech.lean` (namespace `TruncExpCech`; `{A₁ : Type u} {A₂ : Type v} {B : Type w}` all `CommRing`)
```lean
-- :90  def cechCoboundaryUnits (ρ₁ : A₁ →+* B) (ρ₂ : A₂ →+* B) : Subgroup Bˣ :=
--         (Units.map ρ₁.toMonoidHom).range ⊔ (Units.map ρ₂.toMonoidHom).range
-- :96  mem_cechCoboundaryUnits, :111/:116 unitsMap_mem_cechCoboundaryUnits_left/right
-- :126 def cechCoboundaryAdd (ρ₁ ρ₂) : AddSubgroup B := ρ₁.toAddMonoidHom.range ⊔ ρ₂.toAddMonoidHom.range
-- :130 mem_cechCoboundaryAdd, :147 sub_mem_cechCoboundaryAdd, :154 exists_sub_of_mem_cechCoboundaryAdd
-- :171 truncExpUnit_mem_cechCoboundaryUnits_iff (ρ₁ ρ₂) (b : B) :
--         truncExpUnit b ∈ cechCoboundaryUnits (mapRingHom ρ₁) (mapRingHom ρ₂) ↔ b ∈ cechCoboundaryAdd ρ₁ ρ₂
-- :198 cechCoboundaryUnits_le_comap_unitsFst
-- :211 noncomputable def cechUnitsReduction (ρ₁ ρ₂) :
--         ((B[ε])ˣ ⧸ cechCoboundaryUnits (mapRingHom ρ₁) (mapRingHom ρ₂)) →* Bˣ ⧸ cechCoboundaryUnits ρ₁ ρ₂
-- :219 cechUnitsReduction_mk_truncExpUnit, :227 mk_truncExpUnit_eq_one_iff
-- :240 exists_mk_truncExpUnit_of_cechUnitsReduction_eq_one
-- :280 truncExpCechKernelMonoidHom (ρ₁ ρ₂) : Multiplicative B →* (cechUnitsReduction ρ₁ ρ₂).ker
-- :308
noncomputable def truncExpCechKernelAddEquiv (ρ₁ : A₁ →+* B) (ρ₂ : A₂ →+* B) :
    B ⧸ cechCoboundaryAdd ρ₁ ρ₂ ≃+ Additive (cechUnitsReduction ρ₁ ρ₂).ker
-- :338 truncExpCechKernelAddEquiv_apply_mk  ([b] ↦ [1 + bε], rfl)
-- :357 cechCoboundaryUnits_le_comap_unitsScale, :383 unitsScale_mk_truncExpUnit
```

`AlgebraicJacobian/Tangent/TruncExpCechH1.lean` — the geometric assembly (`namespace AlgebraicGeometry.TwoCover`, `open TruncExpCech DualNumber`, `variable (k) [CommRing k] (X : Scheme.{u}) [X.Over (Spec (.of k))] (U₀ U₁ : X.Opens)`, `attribute [local instance] Scheme.overModule`)
```lean
-- :84  TruncExpCech.submoduleQuotientAddEquiv (p : Submodule R M) : (M ⧸ p) ≃+ (M ⧸ p.toAddSubgroup)   (:89 _mk)
-- :111/:118 resHom_overAlgebraMap_left/right (a : k)
-- :133
noncomputable abbrev unitsReduction :
    ((Γ(X, U₀ ⊓ U₁)[ε])ˣ ⧸ cechCoboundaryUnits
        (mapRingHom (X.resHom (inf_le_left : U₀ ⊓ U₁ ≤ U₀)))
        (mapRingHom (X.resHom (inf_le_right : U₀ ⊓ U₁ ≤ U₁)))) →*
      (Γ(X, U₀ ⊓ U₁))ˣ ⧸ cechCoboundaryUnits
        (X.resHom (inf_le_left : U₀ ⊓ U₁ ≤ U₀)) (X.resHom (inf_le_right : U₀ ⊓ U₁ ≤ U₁))
-- :145 unitsReduction_def (rfl)
-- :157 noncomputable def truncExpClass (b : Γ(X, U₀ ⊓ U₁)) : Additive (unitsReduction X U₀ U₁).ker
-- :170 noncomputable def kerVal (y : Additive (unitsReduction X U₀ U₁).ker) : (…[ε])ˣ ⧸ cechCoboundaryUnits …
-- :177 kerVal_eq_coe, :187 truncExpClass_val, :194 truncExpClass_eq_engine,
-- :202 truncExpClass_add, :210 truncExpClass_eq_zero_iff, :219 truncExpClass_surjective
-- :234 range_diff_toAddSubgroup :
--   (LinearMap.range (diff k X U₀ U₁)).toAddSubgroup = cechCoboundaryAdd (X.resHom inf_le_left) (X.resHom inf_le_right)
-- :252 noncomputable def h1CokAddEquivCechQuot :
--   H1Cok k X U₀ U₁ ≃+ Γ(X, U₀ ⊓ U₁) ⧸ cechCoboundaryAdd (X.resHom inf_le_left) (X.resHom inf_le_right)   (:260 _mk)
-- :281  ★ THE LANDED KEYSTONE
noncomputable def h1AddEquivTruncExpCechKernel (hcov : U₀ ⊔ U₁ = ⊤)
    (hU₀ : IsAffineOpen U₀) (hU₁ : IsAffineOpen U₁) :
    Sheaf.HModule (X.moduleKSheaf k) 1 ≃+ Additive (unitsReduction X U₀ U₁).ker
-- :294 h1AddEquivTruncExpCechKernel_delta (s) : … (delta k X U₀ U₁ hcov s) = truncExpClass X U₀ U₁ s
-- :314 smul_delta, :322 h1AddEquivTruncExpCechKernel_smul_delta
-- :334 noncomputable def mumfordScaling (a : k) : Ȟ¹ˣ(B[ε]) →* Ȟ¹ˣ(B[ε])
-- :349 mumfordScaling_mk_truncExpUnit, :364 mumfordScaling_h1AddEquivTruncExpCechKernel_delta
```
So the landed equivalence is exactly the shape you asked about, with `Γ(U₁⊓U₂)/(Γ(U₁)+Γ(U₂))` in the two forms `H1Cok k X U₀ U₁` (`:138` of TwoCover.lean) and `Γ ⧸ cechCoboundaryAdd`, tied by `range_diff_toAddSubgroup`. **Deliberately `≃+` only — no `SMul k` on the kernel side** (documented D6 dodge); the `k`-action is transported pointwise via `mumfordScaling`. Note it is stated for a *general* `X` over `Spec k` with two affine opens; instantiating at `X := relCurve C (k[ε]-free base)` or at `X := C.left` is a matter of choosing `k`, `X`, `U₀`, `U₁`. `Sheaf.HModule (C.left.moduleKSheaf k) 1` is definitionally the carrier of `genus C` (`Challenge.lean:89`).

## 3. Is a kernel element of `relPic` related to a Čech transition unit anywhere? — **No.** This is the open clause.

I searched for every name you listed plus `epsKernel`, `EpsilonKernel`, `cechToPic`, `PicCech`. Findings:

- **Nothing relates `relPic C (overSpec k A)` (or its ε-kernel) to a two-cover transition unit.** `cechCoboundaryUnits` / `cechUnitsReduction` / `truncExpClass` have **exactly two consumers**, `Tangent/TruncExpCech.lean` and `Tangent/TruncExpCechH1.lean` — no file outside `Tangent/` mentions them. `unitsReduction`, `truncExpClass`, `h1AddEquivTruncExpCechKernel` have **zero** consumers. `Tangent/RelPicEpsilonKernel.lean`, `Tangent/EtalePlusEpsilonKernel.lean`, `Tangent/Pic0EpsilonKernel.lean`, `Tangent/DualNumberEtaleCover.lean`, `Descent/AmitsurEqualizerModule.lean` (the T4-a…e file slots of `informal/w5-t4-worksheet.md` §3) **do not exist**.
- The explicit statement of the gap is in the module docstring of `AlgebraicJacobian/Tangent/DualNumberChartTriviality.lean:43-47`: "The two remaining clauses of the middle are the identification `Γ(V ×_k Spec k[ε], 𝒪) ≅ Γ(V, 𝒪)[ε]` — already available as `DualNumber.baseChangeAlgEquiv` — and **the statement that under these identifications a kernel element goes to its transition unit, which is the genuinely cocycle-level step and is still open**." That is your clause (iii), verbatim, and it is unbuilt.

What *does* exist, in both directions, as the raw material:

**`CechPic` → invertible modules (affine dictionary).**
`AlgebraicJacobian/Picard/CechPicToPic.lean`
```lean
-- :45 toPicFun, :53 noncomputable def toPic : X.CechPic →* CommRing.Pic Γ(X, ⊤)   [IsAffine X]
-- :81 @[simp] toPic_mk (𝒰) (γ : X.unitsCocycle 𝒰) (P : 𝒰.BasicRefinement) : toPic X (CechPic.mk 𝒰 γ.class) = P.pic γ
-- :116 toPic_injective
```
`AlgebraicJacobian/Picard/CechPicSurjective.lean`
```lean
-- :54  structure TrivializingFamily (X : Scheme.{u}) (N) [AddCommGroup N] [Module Γ(X, ⊤) N] : Type u where
--         sec : X → Γ(X, ⊤) ; mem_basicOpen : ∀ x, x ∈ X.basicOpen (sec x)
--         triv : ∀ x, (Γ(X, X.basicOpen (sec x)) ⊗[Γ(X, ⊤)] N) ≃ₗ[Γ(X, X.basicOpen (sec x))] Γ(X, X.basicOpen (sec x))
-- :71  nonempty [IsAffine X] [Module.Invertible Γ(X, ⊤) N] : Nonempty (TrivializingFamily X N)
-- :95  def cover : X.PointedCover
-- :109 noncomputable def transition (x y : X) : Γ(X, X.basicOpen (F.sec x * F.sec y))ˣ
-- :172 noncomputable def cocycle : X.unitsCocycle F.cover ; :184 cocycle_unitsEvInf
-- :240 pic_cocycle, :267 toPic_surjective, :275 toPic_bijective
-- :283 noncomputable def Scheme.cechPicEquivPic (X) [IsAffine X] : X.CechPic ≃* CommRing.Pic Γ(X, ⊤)
```
Direction: `CechPic → Pic`, bijective **only for affine `X`**. Both injectivity and surjectivity are proved. `CechPicToPicNaturality.lean:455 toPic_map (g : X ⟶ Y) (L : Y.CechPic) : toPic X (CechPic.map g L) = CommRing.Pic.mapRingHom g.appTop.hom (toPic Y L)`, and `:471 toPic_mapAlgebra`. `Module.transitionUnit` (`Algebra/BaseChangeTrivialization.lean:116`, with `:128 _val`, `:133 _mul_apply`, `:145 _mul_transitionUnit`) is the actual "transition unit of two trivializations".

**Restricted-to-an-affine-open class, and the trivialization extraction.**
`AlgebraicJacobian/Picard/EffectivityMoving.lean`
```lean
-- :83  noncomputable def Opens.cechPicClass (O : Z.Opens) (hO : IsAffineOpen O) (L : Z.CechPic) : CommRing.Pic Γ(Z, O)
-- :101 Opens.cechPicMap_ι_eq_one_of_cechPicClass_eq_one (h : O.cechPicClass hO L = 1) : CechPic.map O.ι L = 1
-- :121 Opens.cechPicClass_of_le, :159 Opens.cechPicClass_basicOpen_eq_one_of_free
```
`AlgebraicJacobian/Picard/EffectivityTrivialization.lean:75` `Scheme.exists_trimmed_trivializing_of_cechPicMap_ι_eq_one (𝒩) (γ) (D : Z.Opens) (h1 : CechPic.map D.ι (CechPic.mk 𝒩 γ.class) = 1) : ∃ t : ∀ b : Z, Γ(Z, 𝒩.opens b ⊓ D)ˣ, …` — this is the "class trivial on an open ⟹ 0-cochain of units on the trimmings" move, i.e. exactly the machine for turning chart-triviality into a transition unit. Plus `Picard/RefinementInjectivity.lean:164 unitsRes_injective`, `:195 CechPic.mk_eq_one_iff {𝒰} {a} : CechPic.mk 𝒰 a = 1 ↔ a = 1`, `:208 mk_injective`.

**Transition-unit family → `CechPic` class (the `mk_` direction), with all the invariance laws.** This is the closest thing to what clause (iii) needs, and it works for an *arbitrary finite/`Type u` index family of opens*:
`AlgebraicJacobian/Cohomology/GluedSheaf.lean:76`
```lean
structure Scheme.IsGluingCocycle {X : Scheme.{u}} {J : Type u} (U : J → X.Opens)
    (g : ∀ i j : J, Γ(X, U i ⊓ U j)ˣ) : Prop where
  unit_self : ∀ i, (g i i : Γ(X, U i ⊓ U i)) = 1
  mul_res : ∀ i j l, X.resHom inf_le_left (g i j : _) * X.resHom (gluedInclCoc U (U i) j l) (g j l : _)
              = X.resHom (gluedInclSnd U (U i) j l) (g i l : _)
-- :87 IsGluingCocycle.mul_res_of_le {O} (hO : O ≤ U i ⊓ U j ⊓ U l)
```
`AlgebraicJacobian/Cohomology/GluedSheafClass.lean` (`{X : Scheme.{u}} {J : Type u} {U : J → X.Opens} {g g' : ∀ i j : J, Γ(X, U i ⊓ U j)ˣ}`)
```lean
-- :65  noncomputable def gluedSubordUnit (g) (𝒲 : X.PointedCover) (σ : X → J) (hσ : ∀ x, 𝒲.opens x ≤ U (σ x)) (x y : X) : Γ(X, 𝒲.opens x ⊓ 𝒲.opens y)ˣ
-- :75  gluedSubordUnit_trans
-- :98  noncomputable def gluedSubordCocycle (hc : IsGluingCocycle U g) (𝒲) (σ) (hσ) : X.unitsCocycle 𝒲
-- :106 @[simp] gluedSubordCocycle_evInf, :116 gluedSubordCocycle_res
-- :130 gluedSubordCocycle_isCohomologous (two selectors σ σ' agree)
-- :164 gluedSubordCocycle_class_eq  (subordination independence of CechPic.mk)
-- :189/:210 …_of_coboundary  (Scheme.IsGluingCoboundary, GluedSheafCongr.lean:46)
```
This is the generic "family of transition units on overlaps ⟹ a `Scheme.CechPic` class, independent of the chart selector" engine. It is *not* specialized to a 2-affine cover: the only 2-piece instantiation in tree is the theta datum, `AlgebraicJacobian/Cohomology/RelCurveCollapse.lean:66 thetaChartCover` (`J₀ = J₁ = PUnit`, `h = a = 1`), `:103 thetaChartUnit` (1 on diagonal blocks, `relThetaCocycle` / its inverse off-diagonal), `:121 isGluingCocycle_thetaChartUnit`, `:137 thetaChartDatum`, `:641 cechPicClass_thetaChartDatum`. A *generic* "two affine opens + one overlap unit ⟹ `CechPic` class" wrapper does not exist, but `thetaChartUnit`/`isGluingCocycle_thetaChartUnit` is a 40-line template to copy (the `rcases i with i|i <;> rcases j …` proof carries over verbatim).

Class ↔ datum, both directions, and naturality:
- `Cohomology/GluedSheafDatum.lean:55 BasicOpenCoverData` (fields `J₀ J₁ : Type u`, `fintype₀/₁`, `h₀ h₁`, `a₀ a₁`, `partition₀/₁`), `:143 BasicOpenCocycleDatum … extends BasicOpenCoverData` with `unit : ∀ i j, Γ(relCurve C B, pieces i ⊓ pieces j)ˣ` and `isGluingCocycle`; `:157 sheaf`.
- `Cohomology/GluedSheafClass.lean:257 pointedCover`, `:269 cechPicClass : (relCurve C B).CechPic`, `:277 cechPicClass_eq_mk`, `:358 cechPicClass_baseChange` (naturality in the test ring along `relCurveMap C B B'`).
- `Cohomology/GluedSheafExtraction.lean:242 cechPicClass_eq_of_anchor`, `:301 exists_cechPicClass_eq (c : (relCurve C B).CechPic) : ∃ D, D.cechPicClass = c` — **every** Čech class is presented by a two-chart-refined datum. This is the surjectivity you'd want in the `CechPic → transition-unit` direction, though its pieces are basic opens of the pinned `fiberTwoCover π`, not an arbitrary `AffineTwoCover`.
- `Cohomology/DatumDescent.lean:525 descent_cechPicClass`, `:547 descentRigidEngine`.

**Base-change of section rings (the other input of clause (iii)).** `AlgebraicJacobian/Cohomology/SectionsBaseChange.lean:287` `Over.sectionsBaseChange (X) (A) (hV : IsCompact …) (hV' : IsQuasiSeparated …) : Γ(X.left, V) ⊗[k] A ≃+* Γ((X ⊗ overSpec k A).left, (fst X (overSpec k A)).left ⁻¹ᵁ V)`, with `:295 …OfIsAffineOpen (hV : IsAffineOpen V)`, `:301/:309/:320 _tmul_one/_one_tmul/_tmul`, `:337 _naturality`; `R`-linear form `Cohomology/RelativeSectionsLinear.lean:99 relSectionsBaseChange`, `:126 _tmul`, `:160 relCurveMap`, `:193 relSectionsMap`. Composed with `TruncExpCech.baseChangeAlgEquiv` (`Tangent/DualNumberBaseChange.lean:119 : A ⊗[k] DualNumber k ≃ₐ[A] DualNumber A`, `:123 _tmul`, `:129 _symm_apply`) this gives `Γ(V_{k[ε]}) ≅ Γ(V)[ε]`. **The composite is not written anywhere** — it is clause (ii) of the same open middle.

**Chart triviality (clause (i)) is landed:** `Tangent/DualNumberChartTriviality.lean:132`
```lean
theorem free_of_cyclic_mod_eps (M) [AddCommGroup M] [Module (DualNumber A) M]
    [Module.Invertible (DualNumber A) M] (m : M)
    (h : ∀ x : M, ∃ r : DualNumber A, x - r • m ∈ Ideal.span {(ε : DualNumber A)} • (⊤ : Submodule (DualNumber A) M)) :
    Module.Free (DualNumber A) M
```
with `:73 augIdeal_mul_self_eq_bot`, `:88 ker_fstHom_eq_span_eps`, `:107 isNilpotent_span_eps`, and the engine `Tangent/NilpotentThickeningFree.lean:124/:143`.

## 4. `JacobianData`

`/home/axel/…/AlgebraicJacobian/Picard/JacobianData.lean`
```lean
-- :87   (variable {k : Type u} [Field k])
structure JacobianData (C : Over (Spec (.of k)))
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    Type (u + 1) where
  J : Over (Spec (.of k))
  rep : ((pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat).RepresentableBy J
  locallyOfFiniteType : LocallyOfFiniteType J.hom
  quasiCompact : QuasiCompact J.hom
-- :113 @[implicit_reducible] noncomputable def grpObj (d) : GrpObj d.J := GrpObj.ofRepresentableBy d.J (pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) d.rep
-- :119 def homEquiv (d) {T} : (T ⟶ d.J) ≃ pic0Subgroup C T := d.rep.homEquiv
-- :126 homEquiv_comp (f : T' ⟶ T) (g : T ⟶ d.J) : d.homEquiv (f ≫ g) = pic0Map C f (d.homEquiv g)
-- :134 uniqueUpToIso (d d') : d.J ≅ d'.J ; :139 homEquiv_uniqueUpToIso_hom
-- :158-184 three η-defeq smoke tests (Over.mk d.J.hom ≡ d.J)
```
`d.rep` types the functor as the **`Type`-valued triple composite** `(pic0Functor C ⋙ forget₂ CommGrpCat GrpCat) ⋙ forget GrpCat`, chosen so `GrpObj.ofRepresentableBy` applies verbatim with `F := pic0Functor C ⋙ forget₂ CommGrpCat GrpCat`; the value at `T` is *definitionally* `↥(pic0Subgroup C T)`, and `homEquiv`/`homEquiv_comp` own that defeq once. `pic0Subgroup`/`pic0Map`/`pic0Functor` are `Picard/Pic0Functor.lean:107 / :132 / :151` (degree zero at every field point, `mem_pic0Subgroup_iff:121`). The consumer that matters for T3/T4 is `Tangent/Pic0TangentSpace.lean:138 tangentSpaceEquivPic0Kernel` → `{a : (pic0Functor C).obj (op (overDualNumber k)) // ((pic0Functor C).map (overDualNumberZero k).op).hom a = 1}`, `:147 cotangentSpaceDual_equiv_pic0Kernel`, `:209 finrank_eq_of_addEquiv_of_bijective_smul` (the semilinear `finrank` bridge, unconditional), `:229`/`:254` the two `hdim`-conditional statements. `overDualNumber` / `overDualNumberZero` are `Tangent/DualNumberTestObject.lean:131 / :138`; note `overDualNumber k := Over.mk (Spec.map (CommRingCat.ofHom (algebraMap k (DualNumber k))))`, which is *not syntactically* `overSpec k (DualNumber k)` (same body, different head — `overSpec` is an `abbrev`, so they should unify, but nothing in tree records it).

## 5. `Pic` ↔ invertible modules over section rings

Yes, for **affine** schemes, and it is the full dictionary — but there is **no `PicAffine`/`picOfInvertible` definition**: `Picard/PicAffine.lean` is the *file* holding `CechPic.toPic` (see §3), and `Picard/PicAffineCover.lean:53` holds `PointedCover.BasicRefinement` (fields `ι`, `[fintype]`, `[decEq]`, `pt : ι → X`, `r : ι → Γ(X, ⊤)`, `basicOpen_le`, `iSup_eq`), `:75 nonempty [IsAffine X]`, `:163 coverCocycle`, `:217 isCoverCocycle`, `:280 pic [IsAffine X] (γ : X.unitsCocycle 𝒰) : CommRing.Pic Γ(X, ⊤)`, `:290 pic_eq_picClass`.

- `Scheme.cechPicEquivPic (X) [IsAffine X] : X.CechPic ≃* CommRing.Pic Γ(X, ⊤)` — `Picard/CechPicSurjective.lean:283`.
- `Module.Invertible` is **mathlib's** class (`Mathlib/RingTheory/PicardGroup.lean`), used throughout: `Descent/InvertibleModule.lean:229 Invertible.of_invertible_tensorProduct_of_faithfullyFlat`, `:298 invertible_descended`; `Algebra/LocalizationTrivialization.lean:199 picClass_trivializationCocycle` (transition cocycle's descent class = `CommRing.Pic.mk A N`), `:133 trivializationCocycle`; `Picard/EffectivityDescentDatum.lean:298 comparisonDescentClass`.
- Consumers of the dictionary: `Picard/EtaleSeparatednessClose.lean:136` (`cechPicEquivPic.symm (picClass v)`), `Picard/EffectivityMoving.lean:83`.

## Bottom line for writing clause (iii)

You have: (a) the algebra engine and its geometric wrapper landed to the exact `≃+` you want (`TruncExpCechH1.lean:281`), general in `X`, `U₀`, `U₁`; (b) `AffineTwoCover` + existence for the curve + `pullbackProd` base change; (c) chart triviality over `k[ε]`; (d) `sectionsBaseChange` and `baseChangeAlgEquiv` separately; (e) a fully general transition-units ⟹ `CechPic` class engine (`gluedSubordCocycle` + `gluedSubordCocycle_class_eq`) and the affine `CechPic ≃* CommRing.Pic Γ` dictionary; (f) `relPic` as a quotient of `CechPic` with `relPicMk_eq_relPicMk_iff` as the exact coset test.

You do not have: any statement connecting (e)+(f) to (a) — no `relPic`-kernel-to-transition-unit map in either direction, no `Γ(V_{k[ε]}) ≅ Γ(V)[ε]` composite, and no 2-open specialization of `IsGluingCocycle`/`cechPicClass` off the pinned `fiberTwoCover π`. The `Tangent/` file slots the ratified worksheet assigns to this work (`RelPicEpsilonKernel`, `EtalePlusEpsilonKernel`, `Pic0EpsilonKernel`, `DualNumberEtaleCover`) are all unwritten. The tree's own record of the gap is `Tangent/DualNumberChartTriviality.lean:43-47`.
