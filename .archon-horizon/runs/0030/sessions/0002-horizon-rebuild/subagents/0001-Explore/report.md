Now let me compile the complete reconnaissance report with all the details.

## COMPREHENSIVE MATHLIB SOURCE RECONNAISSANCE REPORT

### 1. CommRing.Pic and Module.Invertible (File: /home/Axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/RingTheory/PicardGroup.lean)

**Type definition:**
```lean
def CommRing.Pic (R : Type u) [CommSemiring R] : Type u :=
  Shrink (Skeleton <| SemimoduleCat.{u} R)ˣ
```
(Line 400-401: Picard group defined as the unit group of the skeleton of invertible R-modules)

**CommGroup structure:**
```lean
noncomputable instance : CommGroup (Pic R) := fast_instance% (equivShrink _).symm.commGroup
```
(Line 405)

**Module.Invertible definition:**
```lean
protected class Invertible : Prop where
  bijective : Function.Bijective (contractLeft R M)
```
(Lines 77-78: An R-module M is invertible if the contraction map Mᵛ ⊗[R] M → R is bijective)

**Key API and theorems:**
- Line 82-84: `noncomputable def linearEquiv : Module.Dual R M ⊗[R] M ≃ₗ[R] R := .ofBijective _ Invertible.bijective` — the linear equivalence for invertible modules
- Lines 430-434: `protected noncomputable def mk : Pic R` — constructor for Pic.mk that embeds invertible modules into Pic R
- Line 439-441: `noncomputable def mk.linearEquiv : Pic.mk R M ≃ₗ[R] M` — isomorphism between Pic.mk R M and M
- Lines 445-448: `theorem mk_eq_iff {N : Pic R} : Pic.mk R M = N ↔ Nonempty (M ≃ₗ[R] N)` — characterization of equality in Pic
- Line 450: `theorem mk_eq_self {M : Pic R} : Pic.mk R M = M`
- Lines 462-463: `theorem mk_eq_one_iff : Pic.mk R M = 1 ↔ Nonempty (M ≃ₗ[R] R)` — trivial class iff free rank 1

**Surjectivity/induction principle:**
- Line 452-453: `theorem ext_iff {M N : Pic R} : M = N ↔ Nonempty (M ≃ₗ[R] N)` — every element is determined by its isomorphism class via `Pic.mk`

**Functoriality:**
- Lines 521-528: `@[simps] noncomputable def mapAlgebra : Pic R →* Pic A` — ring homomorphism induces monoid homomorphism on Picard groups along algebra structure
- Lines 547-549: `noncomputable def mapRingHom : Pic R →* Pic S` — general ring homomorphism induction
- Lines 555-562: `theorem mapRingHom_comp_mapRingHom` and `theorem mapRingHom_mapRingHom` — functoriality properties

**RingEquiv transport:**
- Line 163-164: `protected theorem congr (e : M ≃ₗ[R] N) : Module.Invertible R N := .right (e.symm.lTensor _ ≪≫ₗ linearEquiv R M)` — transport via linear equivalence

**Full declaration list for PicardGroup.lean:**
- `Module.Invertible` class (77-78)
- `Module.Invertible.linearEquiv` (82-84)
- `Module.Invertible.leftCancelEquiv` (94-95)
- `Module.Invertible.rightCancelEquiv` (99-100)
- `Module.Invertible.leftCancelEquiv_comp_lTensor_comp_symm` (103-105)
- `Module.Invertible.rightCancelEquiv_comp_rTensor_comp_symm` (108-110)
- `Module.Invertible.rTensorInv` (113-115)
- `Module.Invertible.rTensorInv_leftInverse` (117-121)
- `Module.Invertible.rTensorInv_injective` (123-124)
- `Module.Invertible.rTensorEquiv` (128-132)
- `Module.Invertible.bijective_curry` (137-142)
- `Module.Invertible.linearEquivDual` (145)
- `Module.Invertible.right` (149-153)
- `Module.Invertible.left` (155)
- `Module.Invertible.congr` (163-164)
- `Module.Invertible.free_iff_linearEquiv` (236-246)
- `Module.Invertible.finrank_eq_one` (248-249)
- `Module.Invertible.rank_eq_one` (251-252)
- `Module.Invertible.toModuleEnd_bijective` (255-259)
- `Module.Invertible.lTensor_injective_iff` (202-206)
- `Module.Invertible.rTensor_injective_iff` (208-210)
- `Module.Invertible.lTensor_surjective_iff` (212-216)
- `Module.Invertible.rTensor_surjective_iff` (218-220)
- `Module.Invertible.lTensor_bijective_iff` (222-224)
- `Module.Invertible.rTensor_bijective_iff` (226-228)
- `Module.Invertible.bijective_of_surjective` (276-279)
- `Module.Invertible.linearEquivOfLeftInverse` (301-302)
- `Module.Invertible.linearEquivOfRightInverse` (313-314)
- `Module.Invertible.algEquivOfRing` (333-342)
- `CommRing.Pic` (400-401)
- `CommRing.Pic.AsModule` (416)
- `CommRing.Pic.mk` (430-434)
- `CommRing.Pic.mk.linearEquiv` (439-441)
- `CommRing.Pic.mk_eq_iff` (445-448)
- `CommRing.Pic.mk_eq_self` (450)
- `CommRing.Pic.ext_iff` (452-453)
- `CommRing.Pic.mk_eq_mk_iff` (455-457)
- `CommRing.Pic.mk_self` (459-460)
- `CommRing.Pic.mk_eq_one_iff` (462-463)
- `CommRing.Pic.mk_eq_one_iff_free` (465-466)
- `CommRing.Pic.mk_tensor` (473-478)
- `CommRing.Pic.mk_dual` (480-483)
- `CommRing.Pic.inv_eq_dual` (485-486)
- `CommRing.Pic.mul_eq_tensor` (488-489)
- `CommRing.Pic.mapAlgebra` (521-528)
- `CommRing.Pic.mapRingHom` (547-549)
- `CommRing.Pic.functor` (572-576)

---

### 2. Faithfully Flat Descent of Bijectivity/Injectivity/Surjectivity
(File: /home/Axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/RingTheory/Flat/FaithfullyFlat/Basic.lean)

**Exact signatures:**

```lean
@[simp]
lemma lTensor_injective_iff_injective [Module.FaithfullyFlat R M] :
    Function.Injective (f.lTensor M) ↔ Function.Injective f := by
  rw [← LinearMap.exact_zero_iff_injective (M ⊗[R] Unit), ← LinearMap.exact_zero_iff_injective Unit]
  conv_rhs => rw [← lTensor_exact_iff_exact R M]
  simp
```
(Lines 385-389)

```lean
@[simp]
lemma lTensor_surjective_iff_surjective [Module.FaithfullyFlat R M] :
    Function.Surjective (f.lTensor M) ↔ Function.Surjective f := by
  rw [← LinearMap.exact_zero_iff_surjective (M ⊗[R] Unit),
    ← LinearMap.exact_zero_iff_surjective Unit]
  conv_rhs => rw [← lTensor_exact_iff_exact R M]
  simp
```
(Lines 391-397)

```lean
@[simp]
lemma lTensor_bijective_iff_bijective [Module.FaithfullyFlat R M] :
    Function.Bijective (f.lTensor M) ↔ Function.Bijective f := by
  simp [Function.Bijective]
```
(Lines 399-402)

**Zero form lemmas:**

```lean
lemma zero_iff_lTensor_zero [h : FaithfullyFlat R M]
    {N : Type*} [AddCommGroup N] [Module R N]
    {N' : Type*} [AddCommGroup N'] [Module R N'] (f : N →ₗ[R] N') :
    f = 0 ↔ LinearMap.lTensor M f = 0 :=
  ⟨fun hf => hf.symm ▸ LinearMap.lTensor_zero M, fun hf => by
    have := lTensor_reflects_exact R M f LinearMap.id (by
      rw [LinearMap.exact_iff, hf, LinearMap.range_zero, LinearMap.ker_eq_bot]
      apply Module.Flat.lTensor_preserves_injective_linearMap
      exact fun _ _ h => h)
    ext x; simpa using this (f x)⟩
```
(Lines 454-463)

```lean
lemma zero_iff_rTensor_zero [h: FaithfullyFlat R M]
    {N : Type*} [AddCommGroup N] [Module R N]
    {N' : Type*} [AddCommGroup N'] [Module R N']
    (f : N →ₗ[R] N') :
    f = 0 ↔ LinearMap.rTensor M f = 0 :=
  zero_iff_lTensor_zero R M f |>.trans
  ⟨fun h => by ext n m; exact (TensorProduct.comm R N' M).injective <|
    (by simpa using congr($h (m ⊗ₜ n))), fun h => by
    ext m n; exact (TensorProduct.comm R M N').injective <| (by simpa using congr($h (n ⊗ₜ m)))⟩
```
(Lines 469-477)

**Corresponding rTensor versions:**
- Lines 369-372: `@[simp] lemma rTensor_exact_iff_exact [FaithfullyFlat R M]`
- Lines 374-377: `@[simp] lemma lTensor_exact_iff_exact [FaithfullyFlat R M]`
- Lines 318-321: `lemma rTensor_reflects_exact [fl : FaithfullyFlat R M]`
- Lines 362-367: `lemma lTensor_reflects_exact [fl : FaithfullyFlat R M]`

---

### 3. Kernels/Equalizers Commute with Flat Base Change
(Files: /home/Axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/RingTheory/Flat/Basic.lean and Mathlib/LinearAlgebra/TensorProduct/Tower.lean)

**Module.Flat preservation of injectivity:**

```lean
theorem rTensor_preserves_injective_linearMap [Flat R M] (f : N →ₗ[R] P)
    (hf : Function.Injective f) : Function.Injective (f.rTensor M) := by
  refine rTensor_injective_of_fg fun N P Nfg Pfg le ↦ ?_
  rw [← Finite.iff_fg] at Nfg Pfg
  have := Finite.small R P
  let se := (Shrink.linearEquiv R P).symm
  have := Module.Finite.equiv se
  rw [rTensor_injective_iff_subtype (fun _ _ ↦ (Subtype.ext <| hf <| Subtype.ext_iff.mp ·)) se]
  exact (flat_iff R M).mp ‹_› _ (Finite.iff_fg.mp inferInstance)
```
(Lines 120-128 in Flat/Basic.lean)

```lean
theorem lTensor_preserves_injective_linearMap [Flat R M] (f : N →ₗ[R] P)
    (hf : Function.Injective f) : Function.Injective (f.lTensor M) :=
  (f.lTensor_inj_iff_rTensor_inj M).2 (rTensor_preserves_injective_linearMap f hf)
```
(Lines 131-133 in Flat/Basic.lean)

**Kernel baseChange lemma:**

```lean
lemma ker_baseChange_comp_cancelBaseChange_symm (f : (A ⊗[R] M) →ₗ[A] N) :
    (f.baseChange A ∘ₗ (cancelBaseChange R A A A M).symm).ker = f.ker := by
  rw [baseChange_comp_cancelBaseChange_symm_self, LinearMap.ker_comp,
    LinearEquiv.ker, Submodule.comap_bot]
```
(Lines 898-901 in LinearAlgebra/TensorProduct/Tower.lean)

---

### 4. Intersections of Affine Opens
(File: /home/Axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Morphisms/Affine.lean and Separated.lean)

**Key lemma:**

```lean
/-- If `X ⟶ Spec ℤ` has affine diagonal (in particular when `X` is separated), then intersections
of affine opens of `X` are also affine. -/
lemma IsAffineOpen.inf [IsAffineHom (pullback.diagonal (terminal.from X))]
    {U V : X.Opens} (hU : IsAffineOpen U) (hV : IsAffineOpen V) : IsAffineOpen (U ⊓ V) :=
  isAffineHom_diagonal_iff.mp ‹_› ⊤ (isAffineOpen_top _) U (by simp) V (by simp) hU hV
```
(Lines 327-329 in Morphisms/Affine.lean)

**Separated schemes definition:**

```lean
protected class IsSeparated (X : Scheme.{u}) : Prop where
  isSeparated_terminal_from : IsSeparated (terminal.from X)

attribute [instance] IsSeparated.isSeparated_terminal_from
```
(Lines 330-332 in Morphisms/Separated.lean)

**Characterization:**
```lean
theorem isSeparated_iff (X : Scheme.{u}) :
    X.IsSeparated ↔ IsClosedImmersion (prod.lift (𝟙 X) (𝟙 X)) := by
  rw [Scheme.IsSeparated]; exact isSeparated_iff _
```
(Lines 336-337 in Morphisms/Separated.lean)

**Key connection:**
```lean
instance [X.IsSeparated] : IsClosedImmersion (prod.lift (𝟙 X) (𝟙 X)) := by
  apply +allowSynthFailures @IsSeparated.of_comp (g := terminal.from Y)
  sorry
```
(Line 343 in Morphisms/Separated.lean)

---

### 5. Module.Invertible
(File: /home/Axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/RingTheory/PicardGroup.lean)

**Definition:**
```lean
protected class Invertible : Prop where
  bijective : Function.Bijective (contractLeft R M)
```
(Lines 77-78)

**Key API:**
- Line 82-84: `noncomputable def linearEquiv : Module.Dual R M ⊗[R] M ≃ₗ[R] R`
- Line 163-164: `protected theorem congr (e : M ≃ₗ[R] N) : Module.Invertible R N` — transport via linear equivalence
- Line 168: `instance : Module.Invertible R (Dual R M)` — dual is invertible
- Line 170-172: `instance [Module.Invertible R N] : Module.Invertible R (M ⊗[R] N)` — tensor of invertibles is invertible
- Line 194: `instance : Module.Finite R M` — invertible modules are finite
- Line 195: `instance : Projective R M` — invertible modules are projective
- Line 196: `example : IsReflexive R M` — invertible modules are reflexive

**Relationship to Pic:**
- The `Module.Invertible` hypothesis is what allows an R-module to be embedded into `Pic R` via the `Pic.mk` constructor (lines 430-434)

---

### 6. Units of Tensor/Localization Plumbing
(File: /home/Axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/RingTheory/TensorProduct/Basic.lean and Maps.lean)

**includeLeft/includeRight declarations:**

```lean
/-- The ring morphism `A →+* A ⊗[R] B` sending `a` to `a ⊗ₜ 1`. -/
@[simps!]
def includeLeftRingHom : A →+* A ⊗[R] B where
  __ := (AlgebraTensorModule.mk R R A B).flip 1 |>.toAddMonoidHom
  map_one' := rfl
  map_mul' := by simp
```
(Lines 272-276)

```lean
/-- The `R`-algebra morphism `A →ₐ[R] A ⊗[R] B` sending `a` to `a ⊗ₜ 1`. -/
def includeLeft [SMulCommClass R S A] : A →ₐ[S] A ⊗[R] B :=
  { includeLeftRingHom with commutes' := by simp }
```
(Lines 311-312)

```lean
/-- The algebra morphism `B →ₐ[R] A ⊗[R] B` sending `b` to `1 ⊗ₜ b`. -/
def includeRight : B →ₐ[R] A ⊗[R] B where
  __ := AlgebraTensorModule.mk R R A B 1 |>.toAddMonoidHom
  map_one' := rfl
  map_mul' := by simp
  commutes' r := by simp [algebraMap_eq_smul_one', smul_tmul]
```
(Lines 323-327)

**Map for algebra homomorphisms:**

```lean
/-- The tensor product of a pair of algebra morphisms. -/
def map (f : A →ₐ[S] C) (g : B →ₐ[R] D) : A ⊗[R] B →ₐ[S] C ⊗[R] D :=
  algHomOfLinearMapTensorProduct (AlgebraTensorModule.map f.toLinearMap g.toLinearMap) (by simp)
    (by simp [one_def])
```
(Lines 478-480 in Maps.lean)

**Key theorems:**
- Line 486: `@[simp] theorem map_tmul (f : A →ₐ[S] C) (g : B →ₐ[R] D) (a : A) (b : B) : map f g (a ⊗ₜ b) = f a ⊗ₜ g b`
- Line 490: `@[simp] theorem map_id : map (.id S A) (.id R B) = .id S _`
- Lines 493-496: `theorem map_comp` — functoriality
- Lines 508-510: `theorem map_comp_includeLeft (f : A →ₐ[S] C) (g : B →ₐ[R] D) : (map f g).comp includeLeft = includeLeft.comp f`
- Lines 513-514: `theorem map_restrictScalars_comp_includeRight`

---

**End of Reconnaissance Report**
