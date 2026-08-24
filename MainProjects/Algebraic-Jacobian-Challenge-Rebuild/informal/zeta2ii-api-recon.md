# ζ2·ii (pi-assembly) — full API recon

*Read-only reconnaissance, 2026-07-13. All paths absolute from the project root
`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/`.
Mathlib v4.31.0 lives at the WORKSPACE root
`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/` (NOT under the subproject).
Signatures below are copied verbatim from source; `:NNN` is the 1-based line of the
declaration head.*

## The ζ2·ii target (restated from the structure that feeds it)

`CoherentCechWitness k A B 𝒩 γ` (structure, `AlgebraicJacobian/Picard/CoherentWitness.lean:255`)
packages, for a tower `k → A → B` (`[Field k] [CommRing A] [CommRing B] [Algebra k A]
[Algebra k B] [Algebra A B] [IsScalarTower k A B]`):
* `cover : ((overSpec k (B ⊗[A] B)).left).PointedCover`
* `le_pullbackInl : cover ≤ 𝒩.pullback q₁`, `le_pullbackInr : cover ≤ 𝒩.pullback q₂`
  (`q₁ = (Over.overSpecMap tensorInl).left`, `q₂ = (Over.overSpecMap tensorInr).left`)
* `θ : ∀ x : (overSpec k (B ⊗[A] B)).left, Γ((overSpec k (B ⊗[A] B)).left, cover.opens x)ˣ`
* `witness :` θ cobounds the comparison of `q₁^♯ γ` and `q₂^♯ γ` (full statement at
  `CoherentWitness.lean:267-280`, in `unitsAppLE`/`unitsRestrict` normal form)
* `coherent :` the Amitsur relation `(f₂₃^♯ θ) ⋅ (f₁₂^♯ θ) = f₁₃^♯ θ` on `amitsurCover cover`
  (`CoherentWitness.lean:283-289`).

`Over.exists_coherentCechWitness` (`AlgebraicJacobian/Picard/CoherentWitnessExists.lean:165`)
produces `Nonempty (CoherentCechWitness k A B 𝒩 γ)` **modulo one `sorry`** at
`CoherentWitnessExists.lean:521` (the final `hglob`-to-coherence assembly; steps A–G are
complete).

ζ2·ii must consume a `θ' : CoherentCechWitness …` (or its extracted `θ`, `cover`, `witness`,
`coherent`) plus a basic cover of `Spec B` trivialising `N`, and produce
`v : (P ⊗[A] P)ˣ` (`P := ∀ i, S i`) with `Module.IsDescentCocycle v` and
`tensorCollapse v = cocycleUnit c`.

Notation used below (as in the source, via `overSpec_left : (overSpec k A).left = Spec (.of A)`
which is `rfl`, `SectionsBaseChange.lean:101`): the descent **base ring** for `Spec B` is
`R_B := Γ((overSpec k B).left, ⊤) = Γ(Spec (.of B), ⊤)`, canonically `≅ B` via
`Scheme.ΓSpecIso (CommRingCat.of B)` (mathlib). Section rings on basic opens are used
DIRECTLY as `Away` models (see §3), so no separate localization type is introduced.

---

## 1. Dictionary machinery (N / γ ⟶ basic cover, trivializing family, cover cocycle c,
##    cocycleUnit, pic_eq_picClass / toPic / cechPicEquivPic)

There are TWO on-ramps into the cover cocycle, both landing on the same
`IsLocalization.AwayCover` data. ζ2·ii is handed `f : ι → B`, `S i`, `c`, `cocycleUnit c`,
so the **BasicRefinement on-ramp** (1A) is the relevant one; the **TrivializingFamily
on-ramp** (1B) is how a bare invertible module / `CechPic` class produces that data, and
its `picClass_trivializationCocycle` is the identity `picClass(cocycleUnit c) = mk B N` you
need to tie `c` back to `N`.

### 1A. BasicRefinement ⟶ cover cocycle ⟶ cocycleUnit ⟶ pic

File `AlgebraicJacobian/Picard/PicAffineCover.lean`.

```
-- :53
structure PointedCover.BasicRefinement (𝒰 : X.PointedCover) : Type (u + 1) where
  ι : Type u
  [fintype : Fintype ι]
  [decEq : DecidableEq ι]
  pt : ι → X
  r : ι → Γ(X, ⊤)
  basicOpen_le : ∀ i, X.basicOpen (r i) ≤ 𝒰.opens (pt i)
  iSup_eq : (⨆ i, X.basicOpen (r i)) = ⊤

-- :75
theorem PointedCover.BasicRefinement.nonempty [IsAffine X] (𝒰 : X.PointedCover) :
    Nonempty 𝒰.BasicRefinement

-- :163  (the cover cocycle `c := P.coverCocycle γ`)
noncomputable def PointedCover.BasicRefinement.coverCocycle (γ : X.unitsCocycle 𝒰) (i j : P.ι) :
    Γ(X, X.basicOpen (P.r i * P.r j))ˣ :=
  X.unitsRestrict (P.overlap_le i j) (unitsEvInf γ (P.pt i) (P.pt j))

-- :217  (c is a cover cocycle)
theorem PointedCover.BasicRefinement.isCoverCocycle [IsAffine X] (γ : X.unitsCocycle 𝒰) :
    IsLocalization.AwayCover.IsCoverCocycle (A := Γ(X, ⊤)) (f := P.r)
      (S := fun i ↦ Γ(X, X.basicOpen (P.r i)))
      (T := fun i j ↦ Γ(X, X.basicOpen (P.r i * P.r j)))
      (W := fun i j k ↦ Γ(X, X.basicOpen (P.r i * (P.r j * P.r k))))
      (P.coverCocycle γ)

-- :266
theorem PointedCover.BasicRefinement.span_eq_top [IsAffine X] : Ideal.span (Set.range P.r) = ⊤
-- :273
theorem PointedCover.BasicRefinement.faithfullyFlat [IsAffine X] :
    Module.FaithfullyFlat Γ(X, ⊤) (∀ i, Γ(X, X.basicOpen (P.r i)))

-- :280  (the descent Picard class)
noncomputable def PointedCover.BasicRefinement.pic [IsAffine X] (γ : X.unitsCocycle 𝒰) :
    CommRing.Pic Γ(X, ⊤) :=
  haveI := P.faithfullyFlat
  (IsLocalization.AwayCover.isDescentCocycle_cocycleUnit (A := Γ(X, ⊤))
    (f := P.r) (S := fun i ↦ Γ(X, X.basicOpen (P.r i)))
    (T := fun i j ↦ Γ(X, X.basicOpen (P.r i * P.r j)))
    (W := fun i j k ↦ Γ(X, X.basicOpen (P.r i * (P.r j * P.r k))))
    (P.isCoverCocycle γ)).picClass

-- :290  (the interface equation)
lemma PointedCover.BasicRefinement.pic_eq_picClass [IsAffine X] (γ : X.unitsCocycle 𝒰) :
    P.pic γ = @Module.IsDescentCocycle.picClass _ _ _ _ _ P.faithfullyFlat _
        (IsLocalization.AwayCover.isDescentCocycle_cocycleUnit … (P.isCoverCocycle γ)) := rfl
```

Overlap/triple containment helpers (used to build the `≤` proofs): `overlap_le :114`,
`basicOpen_le_mul_self :118`, `basicOpen_le_of_dvd :122`, `mul_le_left :127`,
`mul_le_right :131`, `triple_le₁₂ :136`, `triple_le₂₃ :142`, `triple_le₁₃ :147`,
`triple_le :153`. Merge/refinement lifting: `inter :95` (points of second),
`interFst` (points of first, `PicAffine.lean:73`), `ofLE` (`PicAffine.lean:61`).

The canonical restriction maps between localised section rings are identified with sheaf
restriction (`PicAffineCover.lean`): `diag_eq_basicRes :173`, `inclLeft_eq_basicRes :180`,
`inclRight_eq_basicRes :187`, `face₁₂/₁₃/₂₃_eq_basicRes :194/201/208`, all
`= X.basicRes _ _ hle` via `Scheme.basicOpen_algHom_ext`.

### The `IsLocalization.AwayCover` layer (c ⟶ cocycleUnit)

File `AlgebraicJacobian/Algebra/LocalizationCocycle.lean`. Fixed context:
`{A} [CommRing A] {ι} [Fintype ι] [DecidableEq ι] (f : ι → A)`,
`(S : ι → Type u) [∀ i, CommRing (S i)] [∀ i, Algebra A (S i)] [∀ i, IsLocalization.Away (f i) (S i)]`,
`(T : ι → ι → Type u) … [∀ i j, IsLocalization.Away (f i * f j) (T i j)]`,
`(W : ι → ι → ι → Type u) … [∀ i j k, IsLocalization.Away (f i * (f j * f k)) (W i j k)]`.

```
-- :121
structure IsCoverCocycle (γ : ∀ i j, (T i j)ˣ) : Prop where
  diag_eq_one : ∀ i, diag f S T i (γ i i).val = 1
  cocycle : ∀ i j k,
    face₂₃ f T W i j k (γ j k).val * face₁₂ f T W i j k (γ i j).val
      = face₁₃ f T W i j k (γ i k).val

-- restriction maps  (all `A`-algebra maps, unique by IsLocalization.algHom_subsingleton)
-- :85 inclLeft (i j) : S i →ₐ[A] T i j        -- algHomOfDvd (dvd_mul_right)
-- :89 inclRight (i j): S j →ₐ[A] T i j        -- algHomOfDvd (dvd_mul_left)
-- :93 diag (i)       : T i i →ₐ[A] S i
-- :100 face₁₂ (i j k): T i j →ₐ[A] W i j k
-- :105 face₁₃ (i j k): T i k →ₐ[A] W i j k
-- :110 face₂₃ (i j k): T j k →ₐ[A] W i j k

-- :133  the tensor-square identification of the cover algebra  B := ∀ i, S i
noncomputable def piDoubleEquiv :
    ((∀ i, S i) ⊗[A] ∀ i, S i) ≃ₐ[A] ∀ p : ι × ι, T p.1 p.2
-- :141
noncomputable def piTripleEquiv :
    ((∀ i, S i) ⊗[A] ((∀ i, S i) ⊗[A] ∀ i, S i)) ≃ₐ[A] ∀ t : ι × ι × ι, W t.1 t.2.1 t.2.2

-- :160 piUnit (γ) : (∀ p : ι × ι, T p.1 p.2)ˣ
-- :169  THE DESCENT UNIT  (this is `cocycleUnit c`)
noncomputable def cocycleUnit (γ : ∀ i j, (T i j)ˣ) : ((∀ i, S i) ⊗[A] ∀ i, S i)ˣ :=
  Units.map ((piDoubleEquiv f S T).symm : …).toAlgHom.toRingHom.toMonoidHom (piUnit T γ)
-- :173 cocycleUnit_val : (cocycleUnit f S T γ).val = (piDoubleEquiv f S T).symm (piUnit T γ).val
-- :177 piDoubleEquiv_cocycleUnit_val : piDoubleEquiv f S T (cocycleUnit f S T γ).val
--                                        = fun p => (γ p.1 p.2).val
-- :183 cocycleUnit_mul : cocycleUnit (fun i j => γ i j * γ' i j) = cocycleUnit γ * cocycleUnit γ'

-- transport of the simplicial maps (proved by AlgHom.ext_of_isLocalization_pi):
-- :262 lmul'_piDoubleEquiv_symm
-- :290 piTripleEquiv_descentFace₂₃   w ↦ (t ↦ w(t₂,t₃)) restricted (via face₂₃)
-- :322 piTripleEquiv_descentFace₁₂   w ↦ (t ↦ w(t₁,t₂)) restricted
-- :355 piTripleEquiv_descentFace₁₃   w ↦ (t ↦ w(t₁,t₃)) restricted
-- :388 piDoubleEquiv_descentIncl₁    Module.descentIncl₁ ↦ inclLeft
-- :409 piDoubleEquiv_descentIncl₂    Module.descentIncl₂ ↦ inclRight

-- :433  THE CONVERSION
theorem isDescentCocycle_cocycleUnit {γ : ∀ i j, (T i j)ˣ}
    (hγ : IsCoverCocycle (f := f) (S := S) (W := W) γ) :
    Module.IsDescentCocycle (cocycleUnit f S T γ)
```

Also in this namespace: `algHomOfIsUnit (f) (h : IsUnit (algebraMap A T f)) : S →ₐ[A] T`
(`LocalizationCocycle.lean:60`); the base-change layer
(`AlgebraicJacobian/Algebra/LocalizationCocycleBaseChange.lean`): `mapAway :74`,
`mapOverlap :80`, `mapTriple :87`, `IsCoverCocycle.baseChange :143`, `piMapAway :165`,
`piBaseChangeLift :178`, `cocycleUnit_baseChange :191` (keystone),
`span_range_algebraMap_eq_top :243`, `faithfullyFlat_tensor :254`, `pic_baseChange :267`.

`exists_units_of_cocycleUnit_eq_descentCoboundary` and `picClass_map_refine`,
`picClass_eq_of_coboundary` are in `Algebra/LocalizationCocycleRefine.lean` (referenced from
`PicAffine.lean:158,206`; not re-read here — signatures inferable from those call sites).

### The pi-ext / faithful-flatness primitives (base of the whole cover layer)

File `AlgebraicJacobian/Algebra/PiLocalization.lean`.
```
-- :62 THE PI-EXT LEMMA
theorem AlgHom.ext_of_isLocalization_pi (M : ι → Submonoid A) [∀ i, IsLocalization (M i) (S i)]
    {φ ψ : (∀ i, S i) →ₐ[A] C} (h : ∀ i, φ (Pi.single i 1) = ψ (Pi.single i 1)) : φ = ψ
-- :150
theorem Module.FaithfullyFlat.pi_of_span_eq_top (f : ι → A) [∀ i, IsLocalization.Away (f i) (S i)]
    (hspan : Ideal.span (Set.range f) = ⊤) : Module.FaithfullyFlat A (∀ i, S i)
-- :209 piRightAlgEquiv : (N ⊗[A] ∀ i, S i) ≃ₐ[A] ∀ i, N ⊗[A] S i
-- :237 piLeftAlgEquiv  : ((∀ i, S i) ⊗[A] N) ≃ₐ[A] ∀ i, S i ⊗[A] N
-- :262 piPiAlgEquiv    : ((∀ i, S i) ⊗[A] ∀ j, T j) ≃ₐ[A] ∀ p : ι × κ, S p.1 ⊗[A] T p.2
--       (:270 piPiAlgEquiv_tmul : … (s ⊗ₜ t) = fun p => s p.1 ⊗ₜ t p.2)
-- :284 IsLocalization.Away.algHomOfDvd (h : f ∣ g) : S →ₐ[A] T
-- :301 IsLocalization.Away.tensor' [Away f S] [Away g T] : IsLocalization.Away (f*g) (S ⊗[A] T)
-- :311 IsLocalization.Away.tensorEquiv' (C) [Away f S] [Away g T] [Away (f*g) C] : (S ⊗[A] T) ≃ₐ[A] C
```
**Note the crucial scope of `tensor'`/`tensorEquiv'`:** they need `S = Away f` and
`T = Away g` **over the SAME base `A`** and give `Away (f*g)` over `A`. This is exactly what
makes `piDoubleEquiv` work over the base `A`. It is NOT what ζ2·ii needs for
`S_i ⊗[A] S_j` (there `S_i, S_j` are `Away` over `B`, tensored over `A`) — see §3/§5.

### 1B. TrivializingFamily ⟶ transition cocycle ⟶ pic (= class of N), and the dictionary

Files `AlgebraicJacobian/Picard/CechPicSurjective.lean`,
`AlgebraicJacobian/Algebra/LocalizationTrivialization.lean`.

```
-- CechPicSurjective.lean:54
structure TrivializingFamily (X : Scheme.{u}) (N : Type u) [AddCommGroup N] [Module Γ(X, ⊤) N] where
  sec : X → Γ(X, ⊤)
  mem_basicOpen : ∀ x, x ∈ X.basicOpen (sec x)
  triv : ∀ x, (Γ(X, X.basicOpen (sec x)) ⊗[Γ(X, ⊤)] N) ≃ₗ[Γ(X, X.basicOpen (sec x))] Γ(X, X.basicOpen (sec x))
-- :71 nonempty [IsAffine X] [Module.Invertible Γ(X,⊤) N] : Nonempty (TrivializingFamily X N)
-- :95 cover : X.PointedCover  (opens x := X.basicOpen (F.sec x))
-- :109 transition (x y) : Γ(X, X.basicOpen (F.sec x * F.sec y))ˣ  := trivializationCocycle …
-- :116 isCoverCocycle_transition
-- :172 cocycle : X.unitsCocycle F.cover
-- :193 refTriv (P : F.cover.BasicRefinement) (i) — pushforward trivialisations to a basic refinement
-- :200 coverCocycle_eq : P.coverCocycle F.cocycle i j = trivializationCocycle P.r … (F.refTriv P) i j
-- :240 pic_cocycle [Module.Invertible Γ(X,⊤) N] (P) : P.pic F.cocycle = CommRing.Pic.mk Γ(X,⊤) N

-- LocalizationTrivialization.lean:133
noncomputable def trivializationCocycle (i j : ι) : (T i j)ˣ :=
  transitionUnit (trivializationPush (inclLeft f S T i j) (e i)) (trivializationPush (inclRight f S T i j) (e j))
-- :148 isCoverCocycle_trivializationCocycle : IsCoverCocycle (trivializationCocycle f S T e)
-- :199  THE DESCENT IDENTIFICATION
theorem picClass_trivializationCocycle [Module.Invertible A N] [Module.FaithfullyFlat A (∀ i, S i)] :
    (isDescentCocycle_cocycleUnit f S T W (isCoverCocycle_trivializationCocycle f S T W e)).picClass
      = CommRing.Pic.mk A N
```
(`transitionUnit`, `trivializationPush`, `map_transitionUnit`,
`trivializationPush_trivializationPush`, `piTrivialization` are in
`Algebra/BaseChangeTrivialization.lean` / `LocalizationTrivialization.lean:77`; read
`LocalizationTrivialization.lean:130-251` for the exact calculus. `Module.Invertible`,
`Module.transitionUnit` are project/mathlib respectively.)

### The Čech Picard group and its dictionary (toPic / cechPicEquivPic)

Files `AlgebraicJacobian/Picard/Pic.lean`, `CechPicToPic.lean`, `CechPicSurjective.lean`.
```
-- Pic.lean:64  def CechPic (X) : Type u := Quotient (cechPicSetoid X)
-- Pic.lean:67  def CechPic.mk (𝒰 : X.PointedCover) (a : X.unitsH1 𝒰) : X.CechPic := ⟦⟨𝒰, a⟩⟧
-- Pic.lean:71  CechPic.ind (elab_as_elim)
-- Pic.lean:75  CechPic.mk_eq_mk_iff : mk 𝒰 a = mk 𝒱 b ↔ ∃ 𝒲 (h₁ : 𝒲 ≤ 𝒰)(h₂ : 𝒲 ≤ 𝒱), unitsRes h₁ a = unitsRes h₂ b
-- Pic.lean:86  CechPic.mk_unitsRes
-- CechPicToPic.lean:82  toPic (X) [IsAffine X] : X.CechPic →* CommRing.Pic Γ(X, ⊤)
-- CechPicToPic.lean:64/110  toPicFun_mk / toPic_mk : toPic X (CechPic.mk 𝒰 γ.class) = P.pic γ  (any BasicRefinement P)
-- CechPicToPic.lean:116  toPic_injective
-- CechPicSurjective.lean:267 toPic_surjective ; :275 toPic_bijective
-- CechPicSurjective.lean:283  cechPicEquivPic (X) [IsAffine X] : X.CechPic ≃* CommRing.Pic Γ(X, ⊤)
-- CechPicSurjective.lean:288  cechPicEquivPic_apply : cechPicEquivPic X c = CechPic.toPic X c
```
`Scheme.CechPic.map (f : X ⟶ Y) : Y.CechPic →* X.CechPic` (pullback of Čech classes, with
`CechPic.map_mk` computing it via `Hom.pullbackUnitsH1`) and its naturality are used at
`EtaleSeparatedness.lean:125` (ζ1) and throughout `CoherentWitnessExists.lean`; defined in
`Pic.lean` / `CechPicToPicNaturality.lean` (not re-read; call sites at
`CoherentWitnessExists.lean:169-171,177-178,212`).

The choice-independence lemmas that ζ2·ii's `pic`-equalities rest on (all in
`PicAffine.lean`): `pic_ofLE :92`, `pic_eq_of_isCohomologous :109`, `pic_interFst :169`,
`pic_inter :220`, `pic_interFst_eq_inter :272`, `pic_eq_pic :330`, `pic_congr :339`,
`pic_one :355`, `pic_mul :373`, `class_eq_one_of_pic_eq_one :393`.

---

## 2. Descent layer (IsDescentCocycle, picClass, tensorCollapse, collapse,
##    descendedCollapseEquiv, picClass_collapse) — with exact typeclass assumptions

File `AlgebraicJacobian/Descent/UnitDescent.lean`. Context:
`(A B : Type u) [CommRing A] [CommRing B] [Algebra A B]`.

```
-- :48  descentIncl₁ : B →ₐ[A] B ⊗[A] B  (= includeLeft, b ↦ b⊗1)
-- :51  descentIncl₂ : B →ₐ[A] B ⊗[A] B  (= includeRight, b ↦ 1⊗b)
-- :55  descentFace₁₂ : B ⊗[A] B →ₐ[A] B ⊗[A] (B ⊗[A] B)   x⊗y ↦ x⊗(y⊗1)
-- :60  descentFace₁₃ : …                                   x⊗y ↦ x⊗(1⊗y)
-- :65  descentFace₂₃ : … (= includeRight)                  w ↦ 1⊗w

-- :91  THE DESCENT-COCYCLE CONDITION
structure IsDescentCocycle (u : (B ⊗[A] B)ˣ) : Prop where
  lmul'_eq_one : Algebra.TensorProduct.lmul' A (S := B) u.val = 1
  cocycle : descentFace₂₃ A B u.val * descentFace₁₂ A B u.val = descentFace₁₃ A B u.val
-- :98  IsDescentCocycle.one
-- :103 IsDescentCocycle.mul {u v} (hu)(hv) : IsDescentCocycle (u * v)
-- :122 unitCoaction (u) : B →ₗ[B] B ⊗[A] B  (x ↦ u.val * x⊗1)
-- :164 DescentDatum.ofUnit (u) (hu : IsDescentCocycle u) : DescentDatum A B B
-- :181 IsDescentCocycle.descended (hu) : Submodule A B
-- :185 IsDescentCocycle.mem_descended : m ∈ hu.descended ↔ u.val * m⊗1 = 1⊗m

section picClass  -- variable [Module.FaithfullyFlat A B]
-- :197 instance IsDescentCocycle.invertible_descended : Module.Invertible A hu.descended
-- :203 noncomputable def IsDescentCocycle.picClass (hu) : CommRing.Pic A := CommRing.Pic.mk A hu.descended
-- :227 IsDescentCocycle.picClass_one  : (one).picClass = 1
-- :288 IsDescentCocycle.picClass_mul  : (hu.mul hv).picClass = hu.picClass * hv.picClass
end
-- :301 descentCoboundary (β : Bˣ) : (B ⊗[A] B)ˣ  = (1⊗β)*(β⁻¹⊗1)
-- :309 isDescentCocycle_descentCoboundary (β) : IsDescentCocycle (descentCoboundary A B β)
section picClass  -- variable [Module.FaithfullyFlat A B]
-- :390 picClass_descentCoboundary_mul (β)(hu) : ((coboundary β).mul hu).picClass = hu.picClass
-- :397 eq_descentCoboundary_of_equiv (hu)(e : hu.descended ≃ₗ[A] A) : ∃ β, u = descentCoboundary A B β
-- :429 picClass_congr (hu)(hv)(huv : u = v) : hu.picClass = hv.picClass
-- :435 picClass_eq_one_iff (hu) : hu.picClass = 1 ↔ ∃ β : Bˣ, u = descentCoboundary A B β
end
```

**Base change of a cocycle** (`AlgebraicJacobian/Descent/UnitDescentMap.lean`,
`UnitDescentBaseChange.lean`):
```
-- UnitDescentMap.lean:35 IsDescentCocycle.map (h : B →ₐ[A] B') (hu) : IsDescentCocycle (Units.map (map h h) u)
-- UnitDescentMap.lean:147 picClass_map [FF A B][FF A B'] : (hu.map h).picClass = hu.picClass
-- UnitDescentBaseChange.lean:48 tensorSqBaseChange : B ⊗[A] B →ₐ[A] (A'⊗[A]B) ⊗[A'] (A'⊗[A]B)   x⊗y ↦ (1⊗x)⊗(1⊗y)
-- UnitDescentBaseChange.lean:60  tensorSqBaseChange_tmul
-- UnitDescentBaseChange.lean:97  IsDescentCocycle.baseChange (hu) : IsDescentCocycle (Units.map tensorSqBaseChange u)
-- UnitDescentBaseChange.lean:153 descendedBaseChangeEquiv [FF A B] : (A'⊗[A] hu.descended) ≃ₗ[A'] (hu.baseChange).descended
-- UnitDescentBaseChange.lean:236 picClass_baseChange [FF A B][FF A' (A'⊗[A]B)] :
--        (hu.baseChange).picClass = CommRing.Pic.mapAlgebra A A' hu.picClass
```

**THE COLLAPSE (ε2)** — `AlgebraicJacobian/Descent/UnitDescentComposite.lean`. Context:
`{A B P : Type u} [CommRing A] [CommRing B] [CommRing P] [Algebra A B] [Algebra A P]
[Algebra B P] [IsScalarTower A B P]`.
```
-- :61
noncomputable def tensorCollapse : P ⊗[A] P →ₐ[A] P ⊗[B] P   -- x⊗y ↦ x⊗y
-- :68  tensorCollapse_tmul (x y) : tensorCollapse A B P (x ⊗ₜ[A] y) = x ⊗ₜ[B] y
-- :75  tensorCubeCollapse : P ⊗[A] (P ⊗[A] P) →ₐ[A] P ⊗[B] (P ⊗[B] P)   (:87 _tmul)
-- :94  THE B-DESCENT COCYCLE FROM AN A-DESCENT COCYCLE
theorem IsDescentCocycle.collapse {v : (P ⊗[A] P)ˣ} (hv : IsDescentCocycle v) :
    IsDescentCocycle (Units.map (tensorCollapse A B P).toRingHom.toMonoidHom v)
-- :140
theorem descended_le_descended_collapse {v} (hv) :
    hv.descended ≤ (hv.collapse (B := B)).descended.restrictScalars A

section faithfullyFlat  -- :158
variable [Module.FaithfullyFlat A B] [Module.FaithfullyFlat B P] [Module.FaithfullyFlat A P]
-- :163
noncomputable def descendedCollapseEquiv {v} (hv) :
    (B ⊗[A] hv.descended) ≃ₗ[B] (hv.collapse (B := B)).descended        -- b⊗m ↦ b•m
-- :206  THE NATURALITY OF picClass UNDER STAGED DESCENT
theorem IsDescentCocycle.picClass_collapse {v} (hv) :
    (hv.collapse (B := B)).picClass = CommRing.Pic.mapAlgebra A B hv.picClass
end
```
**Typeclass note:** `collapse` and `descended_le_descended_collapse` need NO flatness.
`descendedCollapseEquiv` / `picClass_collapse` need all THREE of `FaithfullyFlat A B`,
`FaithfullyFlat B P`, `FaithfullyFlat A P` (the third is derivable via
`Module.FaithfullyFlat.trans A B P` but is required explicitly because it appears in the
TYPE `hv.picClass : CommRing.Pic A`; see the source comment `UnitDescentComposite.lean:153-158`).

**Mathlib `CommRing.Pic` API** (`…/.lake-packages/mathlib/Mathlib/RingTheory/PicardGroup.lean`):
```
-- :430 CommRing.Pic.mk (R) (M) [Module.Invertible R M] : Pic R
-- :439 mk.linearEquiv (R M) : Pic.mk R M ≃ₗ[R] M
-- :450 mk_eq_self {M : Pic R} : Pic.mk R M = M
-- :455 mk_eq_mk_iff : Pic.mk R M = Pic.mk R N ↔ Nonempty (M ≃ₗ[R] N)
-- :462 mk_eq_one_iff : Pic.mk R M = 1 ↔ Nonempty (M ≃ₗ[R] R)
-- :473 mk_tensor : Pic.mk R (M ⊗[R] N) = Pic.mk R M * Pic.mk R N
-- :521 @[simps] mapAlgebra (R)(A) [Algebra R A] : Pic R →* Pic A,  mapAlgebra_apply M = Pic.mk A (A ⊗[R] M)
--       mapAlgebra_mapAlgebra, mapAlgebra_comp_mapAlgebra, mapAlgebra_self_apply
```
(The project spelling `CommRing.Pic.mapAlgebra A B` means `mapAlgebra` with `R := A`,
`A := B`, i.e. `Pic A →* Pic B`.)

---

## 3. Section rings of basic opens = localizations, and the tensor / Away interplay

### The section-ring-as-localization dictionary (mathlib)

* `Γ(X, U)` has a canonical `Γ(X, ⊤)`-algebra via restriction:
  `AlgebraicGeometry.Scheme.algebra_section_section_basicOpen`
  (`…/mathlib/Mathlib/AlgebraicGeometry/Scheme.lean:739`):
  `instance {X}{U}(f : Γ(X, U)) : Algebra Γ(X, U) Γ(X, X.basicOpen f)`.
* For affine `X`, this algebra IS the `Away f` localization:
  `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen`
  (`…/mathlib/Mathlib/AlgebraicGeometry/AffineScheme.lean:659`):
  `theorem isLocalization_basicOpen (hU : IsAffineOpen U)(f) : IsLocalization.Away f Γ(X, X.basicOpen f)`,
  and the top-level `instance isLocalization_away_of_isAffine [IsAffine X] (r : Γ(X, ⊤)) :
  IsLocalization.Away r Γ(X, X.basicOpen r)` (`AffineScheme.lean:673`).
* `X.basicOpen (r * s) = X.basicOpen r ⊓ X.basicOpen s` : mathlib `Scheme.basicOpen_mul`
  (used everywhere as `X.basicOpen_mul`).
* This is why the project uses **the section ring `Γ(X, X.basicOpen g)` DIRECTLY as the
  `Away g` model** (no separate localization type). Consequently, a **unit section on a
  basic open literally IS a ring unit of the localization** — see §4.

Restriction as an algebra map, and its uniqueness (project,
`AlgebraicJacobian/Picard/SectionsAlgebra.lean`):
```
-- :43  basicRes (g h)(hle : X.basicOpen h ≤ X.basicOpen g) : Γ(X, X.basicOpen g) →ₐ[Γ(X,⊤)] Γ(X, X.basicOpen h)
-- :52  basicRes_apply
-- :59  coe_unitsRestrict_basicOpen : (X.unitsRestrict hle u : …) = basicRes g h hle u.val
-- :66  basicOpen_algHom_ext [IsAffine X](g){C}[Algebra Γ(X,⊤) C] (φ ψ : Γ(X, X.basicOpen g) →ₐ C) : φ = ψ
-- :74  unitsRestrict_unitsEvInf_self
```

### `S_i ⊗[A] S_j` as an `Away` model over `B ⊗[A] B` — WHAT EXISTS

Mathlib primitives (`…/mathlib/Mathlib/RingTheory/Localization/`):
* `IsLocalization.Away.tensor` (`Localization/BaseChange.lean:447`), with context
  `[Algebra R S][Algebra R A][IsLocalization.Away r A]`:
  `instance tensor : IsLocalization.Away (algebraMap R S r) (S ⊗[R] A)`.
  (Base change of an `Away r`-over-`R` localization along `R → S` is `Away (r's image)`
  over `S`.) Also `tensorRight : IsLocalization.Away (algebraMap R S r) (A ⊗[R] S)`
  (`:460`), and `tensorEquiv`/`tensorRightEquiv : S ⊗[R] A ≃ₐ[S] Localization.Away (algebraMap R S r)`.
* `IsLocalization.Away.mul` / `mul'` (`Localization/Away/Basic.lean:258,288`), context
  `[Algebra S T][Algebra R T][IsScalarTower R S T][Away x S][Away (algebraMap R S y) T]`:
  `lemma mul' (T)(x y) : IsLocalization.Away (x * y) T` (localize a localization → single Away).
* `IsLocalization.Away.mapₐ` (`Away/Basic.lean:231`),
  `map` (`:183`) — canonical maps between Away localizations.

Project primitives (`Algebra/PiLocalization.lean`, see §1): `tensor' :301`,
`tensorEquiv' :311` — **`A`-relative only** (both factors `Away`-over-`A`).

**What does NOT exist:** a lemma/instance presenting `S_i ⊗[A] S_j`, where
`S_i = Away(r_i)` over `B` and `S_j = Away(r_j)` over `B`, as
`IsLocalization.Away ((tensorInl r_i) * (tensorInr r_j)) (S_i ⊗[A] S_j)` over `B ⊗[A] B`
(equivalently: identifying `S_i ⊗[A] S_j` with the section ring
`Γ(Spec (B⊗[A]B), basicOpen ((r_i⊗1)(1⊗r_j)))`). It IS constructible from the mathlib
primitives above in two steps —
  (1) `(B ⊗[A] B) ⊗[B] S_i` is `Away (r_i ⊗ 1)` over `B ⊗[A] B` by `Away.tensor`
      (`R := B`, `S := B ⊗[A] B` via `tensorInl`/`includeLeft`, `A := S_i`, `r := r_i`);
      and `(B ⊗[A] B) ⊗[B] S_i ≅ S_i ⊗[A] B` by base-change associativity;
  (2) localize again at `1 ⊗ r_j` via `S_j` and `Away.mul'` to land on
      `Away ((r_i⊗1)(1⊗r_j))`, the carrier being `S_i ⊗[A] S_j`
— but **no single project/mathlib declaration does it**. This is the central §5 gap.

`tensorInl`/`tensorInr : B →ₐ[k] B ⊗[A] B` (`AlgebraicJacobian/Picard/EtaleSeparatedness.lean:87,93`;
`tensorInl = includeLeft`, `tensorInr = includeRight.restrictScalars k`); the diagonal
coincidence `tensorInl_comp_ofId :100`.

---

## 4. The θ-to-units bridge (scheme unit sections ⟷ ring units of localizations)

### Unit sections and their pullback (`AlgebraicJacobian/Picard/UnitsPresheaf.lean`)
```
-- :95  Scheme.Hom.unitsAppLE (f : X ⟶ Y)(V : Y.Opens)(U : X.Opens)(e : U ≤ f ⁻¹ᵁ V) : Γ(Y,V)ˣ →* Γ(X,U)ˣ
--        := Units.map (f.appLE V U e).hom
-- :100 coe_unitsAppLE : (f.unitsAppLE V U e u : Γ(X,U)) = f.appLE V U e u
-- :106 unitsAppLE_map : Units.map (X.presheaf.map i).hom (f.unitsAppLE V U e u) = f.unitsAppLE V U' _ u
-- :115 map_unitsAppLE : f.unitsAppLE V U e (Units.map (Y.presheaf.map i).hom u) = f.unitsAppLE V' U _ u
-- :126 unitsAppLE_unitsAppLE : f.unitsAppLE _ _ _ (g.unitsAppLE _ _ _ u) = (f ≫ g).unitsAppLE _ _ _ u
-- :136 id_unitsAppLE
```
### Cocycle-level unit interface (`AlgebraicJacobian/Picard/UnitsCocycle.lean`)
```
-- :94  structure PointedCover (X) : opens : X → X.Opens ; mem_opens
-- :137 PointedCover.pullback (f : X ⟶ Y)(𝒰) : X.PointedCover  (x ↦ f ⁻¹ᵁ 𝒰.opens (f.base x))
-- :155 unitsCocycle (X)(𝒰) := OneCocycle (X.unitsPresheaf ⋙ forget₂ …) 𝒰.opens
-- :159 unitsH1 (X)(𝒰)
-- :164 unitsRes (h : 𝒱 ≤ 𝒰) : X.unitsH1 𝒰 →* X.unitsH1 𝒱
-- :187 unitsEvInf (γ)(i j) : Γ(X, 𝒰.opens i ⊓ 𝒰.opens j)ˣ  := γ.evInf i j
-- :193 unitsRestrict (X){U W}(h : W ≤ U) : Γ(X,U)ˣ →* Γ(X,W)ˣ := Units.map (X.presheaf.map (homOfLE h).op).hom
-- :208 unitsEvInf_trans ; :221 res_unitsEvInf
-- :249 Hom.pullbackUnitsCocycle ; :271 pullbackUnitsCocycle_unitsEvInf ; :345 pullbackUnitsH1 ; :356 pullbackUnitsH1_class
```
### The projection-descent equivalence ε1 (`AlgebraicJacobian/Picard/ProjectionUnits.lean`)
Context `(C T : Over (Spec (.of k))) [IsProper C.hom][GeometricallyIrreducible C.hom][GeometricallyReduced C.hom]`.
```
-- :62  Scheme.Hom.unitsAppLE_congr_hom (hf : f = f') : f.unitsAppLE V U e u = f'.unitsAppLE V U e' u
-- :81  unitsSndEquiv (hV : IsAffineOpen V) : Γ(T.left, V)ˣ ≃* Γ((C ⊗ T).left, (snd C T).left ⁻¹ᵁ V)ˣ
-- :87  unitsSndEquiv_apply ; :97 _symm_apply_eq_iff ; :105 _symm_unitsAppLE ; :113 unitsAppLE_unitsSndEquiv_symm
-- :122 unitsSndEquiv_symm_eq_of_unitsAppLE  (uniqueness of descended unit)
-- :133 unitsSndEquiv_unitsRestrict ; :144 _symm_unitsRestrict
-- :166 snd_left_naturality (g : T' ⟶ T) : (C ◁ g).left ≫ (snd C T).left = (snd C T').left ≫ g.left
-- :172 snd_left_preimage_naturality ; :191 unitsSndEquiv_naturality
```
### Global units across p (`AlgebraicJacobian/Picard/AmitsurCochain.lean`)
```
-- :69  exists_global_unit_of_compatible (β : ∀ x, Γ(X,𝒰.opens x)ˣ)(hβ) : ∃ w : Γ(X,⊤)ˣ, ∀ x, unitsRestrict le_top w = β x
-- :79  global_unit_ext
-- :90  Scheme.Hom.unitsAppLE_top (f)(u) : f.unitsAppLE ⊤ (f ⁻¹ᵁ ⊤) le_rfl u = Units.map f.appTop.hom.toMonoidHom u
-- :107-118 tensorFace₁₂/₁₃/₂₃ : B ⊗[A] B →ₐ[k] B ⊗[A] (B ⊗[A] B)  (= descentFaceᵢⱼ.restrictScalars k)
-- :122/129/136 tensorFace₁₂_comp_tensorInl / _tensorInr / tensorFace₁₃_comp_tensorInr   (simplicial identities)
-- :153 Over.unitsSndTopEquiv (R) : Γ((overSpec k R).left,⊤)ˣ ≃* Γ((C ⊗ overSpec k R).left,⊤)ˣ
-- :160 unitsSndTopEquiv_apply  (= Units.map (snd …).left.appTop …)
-- :169 appTop_units_surjective ; :178 appTop_units_injective ; :190 unitsSndTopEquiv_naturality
```

### How the surjectivity proof crosses the bridge in the OTHER direction (the model to imitate)

`CechPicSurjective.lean` builds, FROM ring units, a scheme cocycle: `TrivializingFamily.triv`
are `S_i`-linear equivs `S_i ⊗ N ≃ S_i` (ring level); `transitionUnit` yields ring units
`transition x y ∈ Γ(X, X.basicOpen(sec x * sec y))ˣ` (`:109`), which are then reinterpreted as
scheme unit-cocycle values by `X.unitsRestrict` in `TrivializingFamily.cocycle` (`:172`,
`cocycle_unitsEvInf :184`). The identity `coverCocycle_eq :200` shows the scheme-side
`P.coverCocycle F.cocycle` equals the ring-side `trivializationCocycle P.r … (refTriv P)` — the
same object viewed as (a) a `unitsEvInf` restricted and (b) a `(T i j)ˣ`. This works with NO
tensor-identification because `T i j = Γ(X, X.basicOpen(r_i r_j))` IS the `Away` model.

**ζ2·ii runs this bridge in reverse:** θ (a unit section on `cover.opens x` of
`Spec (B⊗[A]B)`) is restricted via `unitsAppLE`/`unitsRestrict` to
`basicOpen ((r_i⊗1)(1⊗r_j))`, giving a unit of the section ring
`T_{ij} := Γ(Spec (B⊗[A]B), basicOpen ((r_i⊗1)(1⊗r_j)))` — which is `Away ((r_i⊗1)(1⊗r_j))`
over `Γ(Spec (B⊗[A]B),⊤) ≅ B⊗[A]B`. Getting the component `v_{ij} ∈ (S_i ⊗[A] S_j)ˣ` then
requires the identification `S_i ⊗[A] S_j ≅ T_{ij}` of §3 (the gap). Everything else in the
bridge (restriction calculus, `coe_unitsRestrict_basicOpen`, `basicOpen_algHom_ext`) is present.

`overSpec` bookkeeping: `overSpec k A : Over (Spec (.of k))` (`SectionsBaseChange.lean:97`),
`overSpec_left : (overSpec k A).left = Spec (.of A)` is `rfl` (`:101`),
`isAffineOpen_top_overSpec :109`. So `Γ((overSpec k A).left, ⊤) = Γ(Spec (.of A), ⊤) ≅ A`
via `Scheme.ΓSpecIso (CommRingCat.of A)` (mathlib; used in `Curve/StalksDVR.lean`). Every
place ζ2·ii talks about "`r_i ∈ B`" vs "`r_i ∈ Γ((overSpec k B).left,⊤)`" carries a
`ΓSpecIso` transport — see §5.

---

## 5. GAP LIST for ζ2·ii — candidate new declarations, in dependency order

Legend: **[ALG]** pure algebra, **[SCH]** needs the scheme/section-ring layer,
**[BK]** ΓSpecIso / algebra-structure bookkeeping.

**G1 [ALG] — `S_i ⊗[A] S_j` is an `Away` model over `B ⊗[A] B` (THE keystone gap).**
No declaration exists (§3). Suggested:
```
instance /-or theorem-/ isLocalization_away_tensor
    {A B : Type u}[CommRing A][CommRing B][Algebra A B]
    (r s : B) (Si Sj : Type u)[CommRing Si][CommRing Sj][Algebra B Si][Algebra B Sj]
    [IsLocalization.Away r Si][IsLocalization.Away s Sj] :
    IsLocalization.Away
      ((Algebra.TensorProduct.includeLeft r) * (Algebra.TensorProduct.includeRight s) : B ⊗[A] B)
      (Si ⊗[A] Sj)
-- with the canonical equiv to any other model:
noncomputable def tensorAwayEquiv (Tij)[…][IsLocalization.Away (…) Tij] :
    (Si ⊗[A] Sj) ≃ₐ[B ⊗[A] B] Tij := IsLocalization.algEquiv (Submonoid.powers _) _ _
```
Build via `IsLocalization.Away.tensor` (base change `B → B⊗[A]B` of `S_i`) then
`IsLocalization.Away.mul'` (localize at `1⊗s`); needs `Algebra (B⊗[A]B) (Si ⊗[A] Sj)` and the
associativity iso `(B⊗[A]B) ⊗[B] Si ≅ Si ⊗[A] B`. Mirrors project `tensor'`
(`PiLocalization.lean:301`) but with the tensor base `A` distinct from the localization base `B`.

**G2 [ALG] — pi-double / pi-triple identifications for the A-tower with section-ring
components.** The `piDoubleEquiv`/`piTripleEquiv` of `LocalizationCocycle.lean:133,141`
require components `T i j` to be `Away`-over-`A`; here the components `S_i ⊗[A] S_j` are
`Away`-over-`B⊗[A]B`. Need the analogues built from `piPiAlgEquiv A S S`
(`PiLocalization.lean:262`, exists) composed with G1's `tensorAwayEquiv` per component:
```
noncomputable def piDoubleEquivA :
    ((∀ i, S i) ⊗[A] ∀ j, S j) ≃ₐ[A] ∀ p : ι × ι, T p.1 p.2
    := (Algebra.TensorProduct.piPiAlgEquiv A S S).trans (AlgEquiv.piCongrRight fun p => tensorAwayEquiv …)
-- and its triple analogue on  (∀ i, S i) ⊗[A] ((∀ i, S i) ⊗[A] ∀ i, S i)  ≃  ∀ t, W_{ijk}
```
(A ready-made `piPiPiAlgEquiv` for the cube does NOT exist; compose `piPiAlgEquiv` twice.)

**G3 [ALG] — transport of `descentFace₁₂/₁₃/₂₃` (A-tower) through G2.** Analogue of
`piTripleEquiv_descentFace₂₃/₁₂/₁₃` (`LocalizationCocycle.lean:290/322/355`) and of
`piDoubleEquiv_descentIncl₁/₂` / `lmul'_piDoubleEquiv_symm`. These CANNOT be proved by
`AlgHom.ext_of_isLocalization_pi` over `A` (components are not `Away`-over-`A`); prove instead
by `ext_of_isLocalization_pi` over the base `B ⊗[A] B` (the components ARE `Away` there) after
noting the descent faces are `B⊗[A]B`-algebra maps once G1 is in place, OR by
`piPiAlgEquiv_tmul` + pure-tensor computation. Deliverables:
```
lemma piDoubleEquivA_descentIncl₁ / ₂        -- Module.descentIncl_i (A-tower) ↦ index-wise T-restriction
lemma piTripleEquivA_descentFace₁₂/₁₃/₂₃      -- Module.descentFace_ij (A-tower) ↦ index-wise W-restriction
lemma lmul'_piDoubleEquivA_symm               -- the A-multiplication ↦ diagonal
```

**G4 [ALG] — assemble the component units into `v : (P ⊗[A] P)ˣ`.** With
`P := ∀ i, S i` and `piDoubleEquivA` (G2), define `v := Units.map (piDoubleEquivA).symm (piUnit T v_ij)`
(mirror `cocycleUnit`, `LocalizationCocycle.lean:169`) where `v_ij : (S_i ⊗[A] S_j)ˣ` come from θ'
(via §4 + G1). Then `IsDescentCocycle v` by G3 + θ'-`coherent` + `witness`, mirroring
`isDescentCocycle_cocycleUnit` (`:433`). Suggested:
```
noncomputable def piAssemblyUnit (v_ij : ∀ i j, (S_i ⊗[A] S_j)ˣ) : (P ⊗[A] P)ˣ
theorem isDescentCocycle_piAssemblyUnit (…coherence/witness of v_ij…) : Module.IsDescentCocycle (piAssemblyUnit v_ij)
```

**G5 [SCH+BK] — the θ ⟶ v_ij extraction.** Restrict `θ' x` (unit section on `cover.opens x`
of `Spec (B⊗[A]B)`) to `basicOpen ((r_i⊗1)(1⊗r_j))` via `unitsAppLE`/`unitsRestrict`
(present, §4), obtaining a unit of `T_{ij} = Γ(Spec (B⊗[A]B), basicOpen(…))`; then transport
to `(S_i ⊗[A] S_j)ˣ` via G1's `tensorAwayEquiv`. This is where `CoherentCechWitness.witness`
(the coboundary relation) and `coherent` (Amitsur) become, respectively, the pi-double
diagonal/normalisation and the pi-triple cocycle identity of G4 — via `Scheme.unitsEvInf`,
`coverCocycle`, and `unitsRestrict_unitsEvInf_self` (`SectionsAlgebra.lean:74`). Suggested:
```
noncomputable def witnessComponent (θ' : CoherentCechWitness …)(i j) : (S_i ⊗[A] S_j)ˣ
lemma witnessComponent_coherent : /- the pi-triple cocycle relation for `witnessComponent` -/
```
Needs the ΓSpecIso identification `Γ((overSpec k (B⊗[A]B)).left,⊤) ≅ B⊗[A]B` [BK] to match
`(r_i⊗1)(1⊗r_j) ∈ B⊗[A]B` with the scheme's `basicOpen` argument, and the identification of
`S_i` with `Γ((overSpec k B).left, basicOpen r_i)`.

**G6 [ALG] — `tensorCollapse v = cocycleUnit c` on the diagonal.** With `B` = the base ring
`R_B ≅ B`, `c := P.coverCocycle γ` (the Zariski cover cocycle, §1A), and `cocycleUnit c`
the `B`-descent unit (`LocalizationCocycle.lean:169`, base `R_B`), show
`Units.map (tensorCollapse A R_B P) v = cocycleUnit R_B S T c`. Both are units of
`(P ⊗[R_B] P)ˣ`; compare after `piDoubleEquiv` (over `R_B`, exists): componentwise the
collapse `S_i ⊗[A] S_j ↠ S_i ⊗[R_B] S_j = T_{ij}` sends `v_ij` to `c_{ij}` (the θ'-`witness`
relation restricted to the diagonal cover cocycle = c-telescoping). Suggested:
```
theorem tensorCollapse_piAssemblyUnit :
    Units.map (Module.tensorCollapse A B P).toRingHom.toMonoidHom (piAssemblyUnit v_ij)
      = IsLocalization.AwayCover.cocycleUnit (A := B) f S T c
```
Then ε2 (`picClass_collapse`, `UnitDescentComposite.lean:206`) gives
`picClass(cocycleUnit c) = mapAlgebra A B (picClass v)` for free — the ζ3 hand-off.

**G7 [BK] — faithful-flatness instances for the collapse tower `A → R_B → P`.**
`picClass_collapse` needs `[FaithfullyFlat A R_B] [FaithfullyFlat R_B P] [FaithfullyFlat A P]`.
`FaithfullyFlat R_B P` is `BasicRefinement.faithfullyFlat` (`PicAffineCover.lean:273`, after
`R_B ≅ B` transport). `FaithfullyFlat A R_B` is the étale-cover hypothesis (`A → B` f.f.).
`FaithfullyFlat A P` via `Module.FaithfullyFlat.trans`. All plumbing, but must be assembled;
none packaged for this specific tower.

### Gap headline count: **7 candidate new declarations/bundles** (G1–G7).
The single hard, non-bookkeeping mathematical gap is **G1** (tensor-of-`Away`-over-`B`
as `Away`-over-`B⊗[A]B`); **G2–G4, G6** are the pi-ext/assembly analogues of the existing
`LocalizationCocycle` machinery (mechanical once G1 lands); **G5** is the θ-extraction bridge
(all its scheme-side tools exist, §4); **G7** is flatness plumbing.

### grep patterns tried for a possibly-existing mathlib lemma (G1), all negative:
```
grep -rn "Away.tensor\|instance tensor\|def tensor\b" .../mathlib/Mathlib/RingTheory/Localization/**   → only Away.tensor/tensorRight (Localization/BaseChange.lean:447/460), R-base not A-vs-B
grep -rn "isLocalization.*tensorProduct\|tensorProduct.*Away\|Away.*baseChange" .../mathlib/Mathlib/RingTheory/  → none matching S⊗[A]T over B⊗[A]B
grep -rn "def mapAway\|tensorEquiv'\|tensor'" AlgebraicJacobian/  → only the A-relative project versions
```
No mathlib declaration presents `(Away_B r) ⊗[A] (Away_B s)` as `Away_{B⊗[A]B}((r⊗1)(1⊗s))`;
it must be assembled from `IsLocalization.Away.tensor` + `.mul'` (G1).
