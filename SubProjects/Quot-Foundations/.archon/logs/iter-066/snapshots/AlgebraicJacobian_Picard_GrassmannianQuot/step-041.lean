import AlgebraicJacobian.Picard.GrassmannianCells
import AlgebraicJacobian.Picard.QuotScheme

/-!
# The tautological quotient and the universal property of `Gr(r,d)`

This file adds, on top of the Grassmannian scheme `Gr(d,r)` built in
`GrassmannianCells.lean`, the tautological rank-`d` quotient
`u : O^r ↠ U` and the universal property making `Gr(d,r)` the fine moduli
space of rank-`d` locally free quotients of `O^r`.

Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (Nitsure §1).
-/

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry.Grassmannian

/-! ## Project-local Mathlib supplement — scalar endomorphisms of the structure sheaf

To realise a matrix of regular functions as a morphism of free sheaves of modules we
need to turn a global section `a ∈ Γ(X, ⊤)` of the structure sheaf into a scalar
endomorphism of `O_X` (= `SheafOfModules.unit X.ringCatSheaf`). On the affine chart
`U^I = Spec R^I` the matrix entries of the universal matrix `X^I` live in `R^I`, and we
inject them into the global sections via `Scheme.ΓSpecIso`.

These helpers are project-local: Mathlib has no ready-made "matrix ↦ morphism of free
sheaves" primitive. -/

variable {X : Scheme.{u}}

/-- The global section of the structure sheaf `O_X` (as a sheaf of modules over itself)
determined by a section `a ∈ Γ(X, ⊤)` over the whole space, by restriction to every open.
Project-local helper for building scalar endomorphisms. -/
noncomputable def globalUnitSection (a : Γ(X, ⊤)) :
    (SheafOfModules.unit X.ringCatSheaf).sections :=
  PresheafOfModules.sectionsMk
    (fun Y => (X.ringCatSheaf.obj.map (homOfLE le_top).op a : X.ringCatSheaf.obj.obj Y))
    (by
      intro Y Z f
      change (X.ringCatSheaf.obj.map f) (X.ringCatSheaf.obj.map (homOfLE le_top).op a)
        = X.ringCatSheaf.obj.map (homOfLE le_top).op a
      rw [← CategoryTheory.comp_apply, ← X.ringCatSheaf.obj.map_comp]
      congr 1)

/-- The scalar endomorphism of `O_X` given by a global section `a ∈ Γ(X, ⊤)`:
multiplication by `a`. Project-local helper. -/
noncomputable def scalarEnd (a : Γ(X, ⊤)) :
    SheafOfModules.unit X.ringCatSheaf ⟶ SheafOfModules.unit X.ringCatSheaf :=
  (SheafOfModules.unit X.ringCatSheaf).unitHomEquiv.symm (globalUnitSection a)

/-- `scalarEnd 1` is the identity endomorphism of `O_X`. Project-local helper for
identifying the diagonal entries of the chart quotient. -/
lemma scalarEnd_one : scalarEnd (1 : Γ(X, ⊤)) = 𝟙 (SheafOfModules.unit X.ringCatSheaf) := by
  rw [scalarEnd, Equiv.symm_apply_eq]
  ext Y
  change X.ringCatSheaf.obj.map (homOfLE le_top).op (1 : Γ(X, ⊤))
      = (SheafOfModules.Hom.val (𝟙 (SheafOfModules.unit X.ringCatSheaf))).app Y
          (1 : X.ringCatSheaf.obj.obj Y)
  rw [SheafOfModules.id_val, PresheafOfModules.id_app]
  exact map_one _

/-- `scalarEnd 0` is the zero endomorphism of `O_X`. Project-local helper for identifying
the off-diagonal entries of the chart quotient. -/
lemma scalarEnd_zero : scalarEnd (0 : Γ(X, ⊤)) = 0 := by
  rw [scalarEnd, Equiv.symm_apply_eq]
  ext Y
  change X.ringCatSheaf.obj.map (homOfLE le_top).op (0 : Γ(X, ⊤))
      = (SheafOfModules.Hom.val
          (0 : SheafOfModules.unit X.ringCatSheaf ⟶ SheafOfModules.unit X.ringCatSheaf)).app Y
          (1 : X.ringCatSheaf.obj.obj Y)
  refine (map_zero _).trans ?_
  rfl

/-- The value of the scalar endomorphism `scalarEnd a` on a section `x` over `Y` is
multiplication by the restriction of `a`: `(scalarEnd a)(x) = x · a|_Y`. Project-local
helper, the computational heart of the `scalarEnd` ring-hom identities below. -/
lemma scalarEnd_val_app (a : Γ(X, ⊤)) (Y : (TopologicalSpace.Opens (X : TopCat))ᵒᵖ)
    (x : X.ringCatSheaf.obj.obj Y) :
    (scalarEnd a).val.app Y x = x * X.ringCatSheaf.obj.map (homOfLE le_top).op a := by
  rfl

/-- `scalarEnd c` corresponds to the global section `c` under `unitHomEquiv`. -/
lemma unitHomEquiv_scalarEnd (c : Γ(X, ⊤)) :
    (SheafOfModules.unit X.ringCatSheaf).unitHomEquiv (scalarEnd c) = globalUnitSection c := by
  rw [scalarEnd, Equiv.apply_symm_apply]

/-- The scalar endomorphism `scalarEnd a` sends the unit section `1` to `a|_Y`. -/
lemma scalarEnd_val_app_one (a : Γ(X, ⊤)) (Y : (TopologicalSpace.Opens (X : TopCat))ᵒᵖ) :
    (scalarEnd a).val.app Y (1 : X.ringCatSheaf.obj.obj Y)
      = X.ringCatSheaf.obj.map (homOfLE le_top).op a := by
  exact one_smul _ _

/-- Composition of scalar endomorphisms is multiplication: `scalarEnd a ≫ scalarEnd b =
scalarEnd (a * b)`. Project-local; underlies `matrixEnd` multiplicativity. -/
lemma scalarEnd_comp (a b : Γ(X, ⊤)) :
    scalarEnd a ≫ scalarEnd b = scalarEnd (a * b) := by
  apply (SheafOfModules.unit X.ringCatSheaf).unitHomEquiv.injective
  change SheafOfModules.sectionsMap (scalarEnd b)
        ((SheafOfModules.unit X.ringCatSheaf).unitHomEquiv (scalarEnd a))
      = (SheafOfModules.unit X.ringCatSheaf).unitHomEquiv (scalarEnd (a * b))
  rw [unitHomEquiv_scalarEnd, unitHomEquiv_scalarEnd]
  refine PresheafOfModules.sections_ext _ _ (fun Y => ?_)
  change (scalarEnd b).val.app Y (X.ringCatSheaf.obj.map (homOfLE le_top).op a)
      = X.ringCatSheaf.obj.map (homOfLE le_top).op (a * b)
  exact (RingHom.map_mul (X.ringCatSheaf.obj.map (homOfLE le_top).op).hom a b).symm

/-- `scalarEnd` is additive: `scalarEnd (a + b) = scalarEnd a + scalarEnd b`.
Project-local; underlies `matrixEnd` matrix-multiplication identity. -/
lemma scalarEnd_add (a b : Γ(X, ⊤)) :
    scalarEnd (a + b) = scalarEnd a + scalarEnd b := by
  conv_lhs => rw [scalarEnd]
  rw [Equiv.symm_apply_eq]
  refine PresheafOfModules.sections_ext _ _ (fun Y => ?_)
  change X.ringCatSheaf.obj.map (homOfLE le_top).op (a + b)
      = (scalarEnd a).val.app Y (1 : X.ringCatSheaf.obj.obj Y)
        + (scalarEnd b).val.app Y (1 : X.ringCatSheaf.obj.obj Y)
  rw [scalarEnd_val_app_one, scalarEnd_val_app_one]
  exact RingHom.map_add (X.ringCatSheaf.obj.map (homOfLE le_top).op).hom a b

/-- `scalarEnd` of a finite sum is the sum of the `scalarEnd`s. Project-local. -/
lemma scalarEnd_sum {ι : Type*} (s : Finset ι) (f : ι → Γ(X, ⊤)) :
    scalarEnd (∑ i ∈ s, f i) = ∑ i ∈ s, scalarEnd (f i) := by
  classical
  induction s using Finset.induction with
  | empty => simp [scalarEnd_zero]
  | insert a s ha ih => rw [Finset.sum_insert ha, Finset.sum_insert ha, scalarEnd_add, ih]

/-! ## Matrix automorphisms of the free sheaf

To realise the `GL_d` bundle transitions we promote an (invertible) `d × d` matrix of
global sections to an automorphism of the free rank-`d` sheaf `O_S^d`, exactly as
`chartQuotientMap` realises the universal matrix. The two key algebraic facts — that
`matrixEnd` turns matrix multiplication into composition and the identity matrix into the
identity — follow from the `scalarEnd` ring-hom identities above. -/

/-- `SheafOfModules` over `O_S` has finite biproducts (it has finite products). -/
instance hasFiniteBiproducts_modules (S : Scheme.{0}) :
    HasFiniteBiproducts (SheafOfModules S.ringCatSheaf) :=
  HasFiniteBiproducts.of_hasFiniteProducts

/-- A `d × d` matrix of global sections of `O_S` realised as an endomorphism of the free
rank-`d` sheaf `O_S^d`: the `(p,q)`-entry acts as `scalarEnd`, assembled over the rank-`d`
biproduct (mirrors `chartQuotientMap`). Project-local. -/
noncomputable def matrixEnd {S : Scheme.{0}} {d : ℕ} (M : Matrix (Fin d) (Fin d) Γ(S, ⊤)) :
    SheafOfModules.free (R := S.ringCatSheaf) (Fin d) ⟶
      SheafOfModules.free (R := S.ringCatSheaf) (Fin d) :=
  (biproduct.isoCoproduct (fun _ : Fin d => SheafOfModules.unit S.ringCatSheaf)).symm.hom ≫
    biproduct.matrix (fun i p => scalarEnd (M p i)) ≫
    (biproduct.isoCoproduct (fun _ : Fin d => SheafOfModules.unit S.ringCatSheaf)).hom

/-- Composition of two `biproduct.matrix` morphisms is the matrix of pointwise sums of
composites — the categorical matrix product. Project-local helper for `matrixEnd_comp`. -/
private lemma biproduct_matrix_comp {S : Scheme.{0}} {d : ℕ}
    (mM mN : Fin d → Fin d →
      (SheafOfModules.unit S.ringCatSheaf ⟶ SheafOfModules.unit S.ringCatSheaf)) :
    biproduct.matrix (f := fun _ : Fin d => SheafOfModules.unit S.ringCatSheaf)
        (g := fun _ : Fin d => SheafOfModules.unit S.ringCatSheaf) mM ≫ biproduct.matrix mN
      = biproduct.matrix (fun i q => ∑ p, mM i p ≫ mN p q) := by
  refine biproduct.hom_ext' _ _ (fun i => biproduct.hom_ext _ _ (fun q => ?_))
  simp only [Category.assoc, biproduct.ι_matrix_assoc, biproduct.matrix_π, biproduct.lift_desc,
    biproduct.ι_matrix, biproduct.lift_π]

/-- `matrixEnd` turns matrix multiplication into composition (with the order reversed by
the contravariance of the column/component indexing): `matrixEnd M ≫ matrixEnd N =
matrixEnd (N * M)`. Project-local. -/
lemma matrixEnd_comp {S : Scheme.{0}} {d : ℕ} (M N : Matrix (Fin d) (Fin d) Γ(S, ⊤)) :
    matrixEnd M ≫ matrixEnd N = matrixEnd (N * M) := by
  rw [matrixEnd, matrixEnd, matrixEnd]
  have hcomp : biproduct.matrix (fun i p => scalarEnd (M p i))
        ≫ biproduct.matrix (fun i p => scalarEnd (N p i))
      = biproduct.matrix (fun i p => scalarEnd ((N * M) p i)) := by
    rw [biproduct_matrix_comp]
    congr 1
    funext i q
    simp_rw [scalarEnd_comp]
    rw [← scalarEnd_sum, Matrix.mul_apply]
    exact congrArg scalarEnd (Finset.sum_congr rfl (fun p _ => mul_comm _ _))
  simp only [Category.assoc, Iso.symm_hom, Iso.hom_inv_id_assoc]
  rw [← Category.assoc (biproduct.matrix (fun i p => scalarEnd (M p i))), hcomp]

/-- `matrixEnd` of the identity matrix is the identity. Project-local. -/
lemma matrixEnd_one {S : Scheme.{0}} {d : ℕ} :
    matrixEnd (1 : Matrix (Fin d) (Fin d) Γ(S, ⊤)) = 𝟙 _ := by
  rw [matrixEnd]
  have hmat : biproduct.matrix
        (fun i p => scalarEnd ((1 : Matrix (Fin d) (Fin d) Γ(S, ⊤)) p i))
      = 𝟙 (⨁ fun _ : Fin d => SheafOfModules.unit S.ringCatSheaf) := by
    refine biproduct.hom_ext' _ _ (fun i => biproduct.hom_ext _ _ (fun p => ?_))
    simp only [Category.assoc, Category.id_comp, biproduct.ι_matrix_assoc, biproduct.lift_π]
    rw [Matrix.one_apply]
    by_cases h : p = i
    · subst h; rw [if_pos rfl, scalarEnd_one, biproduct.ι_π_self]
    · rw [if_neg h, scalarEnd_zero, biproduct.ι_π_ne _ (Ne.symm h)]
  rw [hmat, Category.id_comp, Iso.symm_hom, Iso.inv_hom_id]

/-- An invertible `d × d` matrix of global sections induces an automorphism of the free
rank-`d` sheaf `O_S^d`. Project-local — the `GL_d` data underlying the bundle transitions. -/
noncomputable def matrixToFreeIso {S : Scheme.{0}} {d : ℕ}
    (M N : Matrix (Fin d) (Fin d) Γ(S, ⊤)) (hMN : M * N = 1) (hNM : N * M = 1) :
    SheafOfModules.free (R := S.ringCatSheaf) (Fin d) ≅
      SheafOfModules.free (R := S.ringCatSheaf) (Fin d) where
  hom := matrixEnd M
  inv := matrixEnd N
  hom_inv_id := by rw [matrixEnd_comp, hNM, matrixEnd_one]
  inv_hom_id := by rw [matrixEnd_comp, hMN, matrixEnd_one]

@[simp] lemma matrixToFreeIso_hom {S : Scheme.{0}} {d : ℕ}
    (M N : Matrix (Fin d) (Fin d) Γ(S, ⊤)) (hMN : M * N = 1) (hNM : N * M = 1) :
    (matrixToFreeIso M N hMN hNM).hom = matrixEnd M := rfl

/-- **Matrix automorphisms compose multiplicatively** (`lem:gr_matrixToFreeIso_mul`): the
forward maps of two matrix automorphisms compose to `matrixEnd` of the matrix product (with
the order reversed by the column/component contravariance). This is the linkage that turns
the matrix-level Cramer-inverse cocycle into a composition identity of sheaf-of-module
isomorphisms. Project-local. -/
lemma matrixToFreeIso_mul {S : Scheme.{0}} {d : ℕ}
    (A A' B B' : Matrix (Fin d) (Fin d) Γ(S, ⊤))
    (hAA' : A * A' = 1) (hA'A : A' * A = 1) (hBB' : B * B' = 1) (hB'B : B' * B = 1) :
    (matrixToFreeIso A A' hAA' hA'A).hom ≫ (matrixToFreeIso B B' hBB' hB'B).hom
      = matrixEnd (B * A) := by
  rw [matrixToFreeIso_hom, matrixToFreeIso_hom, matrixEnd_comp]

@[simp] lemma matrixToFreeIso_inv {S : Scheme.{0}} {d : ℕ}
    (M N : Matrix (Fin d) (Fin d) Γ(S, ⊤)) (hMN : M * N = 1) (hNM : N * M = 1) :
    (matrixToFreeIso M N hMN hNM).inv = matrixEnd N := rfl

/-! ## The rectangular matrix homomorphism of free sheaves

The chart quotient `u^I` is "left multiplication by the `d × r` universal matrix `X^I`";
to manipulate it under pullback and against the square `GL_d` transitions we generalise
the square `matrixEnd` API to rectangular matrices (`def:gr_matrixEndRect`,
`lem:gr_matrixEndRect_comp`; the pullback naturality `lem:gr_matrixEndRect_pullback` comes
after the scalar atom below). -/

/-- A `d × r` matrix of global sections of `O_S` realised as a morphism of free sheaves
`O_S^r ⟶ O_S^d` (`def:gr_matrixEndRect`): the `(p,q)`-entry acts as `scalarEnd`, assembled
over the two biproducts exactly as the square `matrixEnd` and the chart quotient
`chartQuotientMap` (which is by construction `matrixEndRect` of the injected universal
matrix). Project-local. -/
noncomputable def matrixEndRect {S : Scheme.{0}} {d r : ℕ}
    (M : Matrix (Fin d) (Fin r) Γ(S, ⊤)) :
    SheafOfModules.free (R := S.ringCatSheaf) (Fin r) ⟶
      SheafOfModules.free (R := S.ringCatSheaf) (Fin d) :=
  (biproduct.isoCoproduct (fun _ : Fin r => SheafOfModules.unit S.ringCatSheaf)).symm.hom ≫
    biproduct.matrix (fun i p => scalarEnd (M p i)) ≫
    (biproduct.isoCoproduct (fun _ : Fin d => SheafOfModules.unit S.ringCatSheaf)).hom

/-- Composition of two `biproduct.matrix` morphisms with a rectangular first factor —
the categorical matrix product. Project-local helper for `matrixEndRect_comp`. -/
private lemma biproduct_matrix_comp_rect {S : Scheme.{0}} {d r : ℕ}
    (mM : Fin r → Fin d →
      (SheafOfModules.unit S.ringCatSheaf ⟶ SheafOfModules.unit S.ringCatSheaf))
    (mN : Fin d → Fin d →
      (SheafOfModules.unit S.ringCatSheaf ⟶ SheafOfModules.unit S.ringCatSheaf)) :
    biproduct.matrix (f := fun _ : Fin r => SheafOfModules.unit S.ringCatSheaf)
        (g := fun _ : Fin d => SheafOfModules.unit S.ringCatSheaf) mM ≫ biproduct.matrix mN
      = biproduct.matrix (fun i q => ∑ p, mM i p ≫ mN p q) := by
  refine biproduct.hom_ext' _ _ (fun i => biproduct.hom_ext _ _ (fun q => ?_))
  simp only [Category.assoc, biproduct.ι_matrix_assoc, biproduct.matrix_π, biproduct.lift_desc,
    biproduct.ι_matrix, biproduct.lift_π]

/-- **Square-after-rectangular composition law** (`lem:gr_matrixEndRect_comp`):
`matrixEndRect M ≫ matrixEnd N = matrixEndRect (N * M)` for `M : d × r`, `N : d × d` —
the matrix product, with the order reversed by the contravariance of the column/component
indexing exactly as in `matrixEnd_comp`. Project-local. -/
@[reassoc]
lemma matrixEndRect_comp {S : Scheme.{0}} {d r : ℕ}
    (M : Matrix (Fin d) (Fin r) Γ(S, ⊤)) (N : Matrix (Fin d) (Fin d) Γ(S, ⊤)) :
    matrixEndRect M ≫ matrixEnd N = matrixEndRect (N * M) := by
  rw [matrixEndRect, matrixEnd, matrixEndRect]
  have hcomp : biproduct.matrix (fun (i : Fin r) (p : Fin d) => scalarEnd (M p i))
        ≫ biproduct.matrix (fun (i : Fin d) (p : Fin d) => scalarEnd (N p i))
      = biproduct.matrix (fun (i : Fin r) (p : Fin d) => scalarEnd ((N * M) p i)) := by
    rw [biproduct_matrix_comp_rect]
    congr 1
    funext i q
    simp_rw [scalarEnd_comp]
    rw [← scalarEnd_sum, Matrix.mul_apply]
    exact congrArg scalarEnd (Finset.sum_congr rfl (fun p _ => mul_comm _ _))
  simp only [Category.assoc, Iso.symm_hom, Iso.hom_inv_id_assoc]
  rw [← Category.assoc (biproduct.matrix (fun (i : Fin r) (p : Fin d) => scalarEnd (M p i))),
    hcomp]

/-! ## The tautological quotient on the charts -/

/-- The **chart quotient** `u^I : O_{U^I}^r → O_{U^I}^d` (`def:gr_chart_quotient`):
left multiplication by the universal matrix `X^I` (`universalMatrix`). It is realised as
the morphism of free sheaves of modules whose matrix of components, in the standard bases
`(e_{i'})_{i' : Fin r}` and `(e_p)_{p : Fin d}`, is the universal matrix `X^I` injected
into the structure sheaf via `Scheme.ΓSpecIso`. Since the `I`-minor of `X^I` is the
identity, `u^I` is a split surjection onto the free rank-`d` sheaf.

Project-local: Mathlib has no "matrix ↦ morphism of free sheaves" primitive. -/
noncomputable def chartQuotientMap (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    SheafOfModules.free (R := (affineChart d r I).ringCatSheaf) (Fin r) ⟶
      SheafOfModules.free (R := (affineChart d r I).ringCatSheaf) (Fin d) :=
  let A := CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
  let R := (affineChart d r I).ringCatSheaf
  haveI : HasFiniteBiproducts (SheafOfModules R) :=
    HasFiniteBiproducts.of_hasFiniteProducts
  let M : ∀ (_ : Fin r) (_ : Fin d), SheafOfModules.unit R ⟶ SheafOfModules.unit R :=
    fun i' p => scalarEnd ((Scheme.ΓSpecIso A).inv.hom ((universalMatrix d r I hI) p i'))
  (biproduct.isoCoproduct (fun _ : Fin r => SheafOfModules.unit R)).symm.hom ≫
    biproduct.matrix M ≫
    (biproduct.isoCoproduct (fun _ : Fin d => SheafOfModules.unit R)).hom

/-- The chart quotient `u^I` sends the `(I.orderIsoOfFin k)`-th basis section of
`O_{U^I}^r` to the `k`-th basis section of `O_{U^I}^d`. Project-local: the column-`I`
restriction of `u^I` is the identity, the matrix-level content of `lem:gr_chartQuotientMap_epi`. -/
private lemma chartQuotientMap_ιFree (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d)
    (k : Fin d) :
    SheafOfModules.ιFree (R := (affineChart d r I).ringCatSheaf)
        ((I.orderIsoOfFin hI k : Fin r)) ≫ chartQuotientMap d r I hI
      = SheafOfModules.ιFree k := by
  set A := CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ) with hA
  set S := AlgebraicGeometry.Spec A with hS
  haveI : HasFiniteBiproducts (SheafOfModules S.ringCatSheaf) :=
    HasFiniteBiproducts.of_hasFiniteProducts
  change SheafOfModules.ιFree (↑((I.orderIsoOfFin hI) k)) ≫
      ((biproduct.isoCoproduct
            (fun _ : Fin r => SheafOfModules.unit S.ringCatSheaf)).symm.hom ≫
        biproduct.matrix (fun (i' : Fin r) (p : Fin d) => scalarEnd
          ((Scheme.ΓSpecIso A).inv.hom (universalMatrix d r I hI p i'))) ≫
        (biproduct.isoCoproduct
            (fun _ : Fin d => SheafOfModules.unit S.ringCatSheaf)).hom)
      = SheafOfModules.ιFree k
  rw [Iso.symm_hom, SheafOfModules.ιFree, biproduct.isoCoproduct_inv]
  erw [Sigma.ι_desc_assoc]
  rw [biproduct.ι_matrix_assoc, biproduct.isoCoproduct_hom]
  have h1 : (CommRingCat.Hom.hom (Scheme.ΓSpecIso A).inv) (1 : A) = 1 := map_one _
  have h0 : (CommRingCat.Hom.hom (Scheme.ΓSpecIso A).inv) (0 : A) = 0 := map_zero _
  have hsub := universalMatrix_submatrix_self d r I hI
  have lift_eq :
      (biproduct.lift fun p : Fin d => scalarEnd
          ((Scheme.ΓSpecIso A).inv.hom (universalMatrix d r I hI p (↑((I.orderIsoOfFin hI) k)))))
        = biproduct.ι (fun _ : Fin d => SheafOfModules.unit S.ringCatSheaf) k := by
    refine biproduct.hom_ext _ _ (fun p => ?_)
    rw [biproduct.lift_π]
    have hentry : universalMatrix d r I hI p (↑((I.orderIsoOfFin hI) k))
        = (1 : Matrix (Fin d) (Fin d) A) p k :=
      congrFun (congrFun hsub p) k
    rw [hentry, Matrix.one_apply]
    by_cases hpk : p = k
    · rw [if_pos hpk, h1, scalarEnd_one, hpk, biproduct.ι_π_self]
    · rw [if_neg hpk, h0, scalarEnd_zero, biproduct.ι_π_ne _ (Ne.symm hpk)]
  rw [lift_eq, biproduct.ι_desc]
  rfl

/-- **The chart quotient is an epimorphism** (`lem:gr_chartQuotientMap_epi`): `u^I` is split
by the coordinate inclusion `s_I` of the `I`-indexed columns, hence is a (split) epimorphism
of sheaves of modules. -/
lemma chartQuotientMap_epi (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    Epi (chartQuotientMap d r I hI) := by
  have hsplit : SheafOfModules.freeMap (R := (affineChart d r I).ringCatSheaf)
        (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) ≫ chartQuotientMap d r I hI
      = 𝟙 (SheafOfModules.free (R := (affineChart d r I).ringCatSheaf) (Fin d)) := by
    refine Cofan.IsColimit.hom_ext (SheafOfModules.isColimitFreeCofan (Fin d)) _ _ (fun k => ?_)
    have key : SheafOfModules.ιFree (R := (affineChart d r I).ringCatSheaf) k ≫
          (SheafOfModules.freeMap (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) ≫
            chartQuotientMap d r I hI)
        = SheafOfModules.ιFree k :=
      (SheafOfModules.ιFree_freeMap_assoc (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) k
        (chartQuotientMap d r I hI)).trans (chartQuotientMap_ιFree d r I hI k)
    exact key.trans (Category.comp_id _).symm
  exact (IsSplitEpi.mk' ⟨_, hsplit⟩).epi

end AlgebraicGeometry.Grassmannian

/-! ## Gluing a sheaf of modules along a scheme glue datum

`Scheme.Modules.glue` descends a sheaf of modules from per-chart data plus a transition
cocycle over a `Scheme.GlueData`. Mathlib carries no turn-key module descent over a
scheme glue datum (confirmed), so this is an Archon-original construction.

Construction (blueprint `def:scheme_modules_glue`): the glued sheaf is built directly as a
categorical limit — an **equalizer of pushforwards** — rather than a hand-built presheaf of
compatible families. Concretely, `glue` forms the two parallel maps
`∏ᵢ (ιᵢ)_* Mᵢ ⇉ ∏_{i,j} (ιᵢ ≫ f_ij)_* (f_ij^* Mᵢ)` (one leg the adjunction unit composed
with the pushforward-composition comparison, the other transported across the inverse
transition `(g_ij)⁻¹`), and takes their equalizer inside `Scheme.Modules D.glued`. The
self-identity (C1) and triple-overlap multiplicativity (C2) hypotheses `_hC1`/`_hC2` on the
family `g` are NOT consumed in forming the equalizer object (the limit exists for any family
of transition maps); they are the descent conditions pinned down downstream when the
restriction isomorphisms are produced. The body below and the `_hC1`/`_hC2` signature are
complete (axiom-clean since iter-056). -/

namespace AlgebraicGeometry.Scheme.Modules

/-! ### Base-change transport of a transition isomorphism to a triple overlap

To state the triple-overlap multiplicativity (C2) of a module descent datum we must
transport each transition isomorphism `g_ij`, living on the overlap `V_ij`, to the common
triple overlap `V_ijk = V_ij ×_{U_i} V_ik`. The transport pulls `g_ij` back along a
projection `p : V_ijk ⟶ V_ij` and reassociates the iterated pullbacks via the pseudofunctor
comparison `Scheme.Modules.pullbackComp`. The three scheme-level `glueData_bridge_*`
identities below (consequences of `t_fac`, `pullback.condition` and `cocycle`) line up the
endpoints of the three transports so that the cocycle equation is well typed. -/

/-- **Base-change transport of a transition isomorphism along a morphism**
(`lem:modules_pullback_basechange_transport`). Given a transition isomorphism
`g : a^*Mᵢ ≅ b^*Mⱼ` over `V` and a morphism `p : W ⟶ V`, transport it to `W` as an
isomorphism `(p ≫ a)^*Mᵢ ≅ (p ≫ b)^*Mⱼ`, by pulling `g` back along `p` and reassociating
the iterated pullbacks through `Scheme.Modules.pullbackComp`.

Project-local: this is the pullback-pseudofunctor packaging that lets the three transition
isomorphisms attached to a triple of charts be compared on a single triple overlap; Mathlib
has no descent-of-modules-over-a-scheme-glue-datum API. -/
noncomputable def pullbackBaseChangeTransport {W V : Scheme.{u}} (p : W ⟶ V)
    {Yi Yj : Scheme.{u}} (a : V ⟶ Yi) (b : V ⟶ Yj)
    {Mi : Yi.Modules} {Mj : Yj.Modules}
    (g : (Scheme.Modules.pullback a).obj Mi ≅ (Scheme.Modules.pullback b).obj Mj) :
    (Scheme.Modules.pullback (p ≫ a)).obj Mi ≅ (Scheme.Modules.pullback (p ≫ b)).obj Mj :=
  (Scheme.Modules.pullbackComp p a).symm.app Mi ≪≫
    (Scheme.Modules.pullback p).mapIso g ≪≫
    (Scheme.Modules.pullbackComp p b).app Mj

/-- Triple-overlap bridge (source): on `V_ijk = V_ij ×_{U_i} V_ik` the two projections to
`V_ij` and `V_ik` followed by the overlap immersions `f_ij`, `f_ik` agree as morphisms to
`U_i`. This is the pullback condition; it identifies the sources of the `ij`- and
`ik`-transports. Project-local helper for the module cocycle (C2). -/
theorem glueData_bridge_src (D : Scheme.GlueData.{u}) (i j k : D.J) :
    pullback.fst (D.f i j) (D.f i k) ≫ D.f i j
      = pullback.snd (D.f i j) (D.f i k) ≫ D.f i k := pullback.condition

/-- Triple-overlap bridge (middle): the `ij`-transition's target leg
`p^{ij} ≫ (t_ij ≫ f_ji)` to `U_j` coincides with the `jk`-transition's source leg
`(t'_ijk ≫ p^{jk}) ≫ f_jk`. Follows from `t_fac` and the pullback condition; it identifies
the target of the `ij`-transport with the source of the `jk`-transport. Project-local helper
for the module cocycle (C2). -/
theorem glueData_bridge_mid (D : Scheme.GlueData.{u}) (i j k : D.J) :
    pullback.fst (D.f i j) (D.f i k) ≫ (D.t i j ≫ D.f j i)
      = (D.t' i j k ≫ pullback.fst (D.f j k) (D.f j i)) ≫ D.f j k := by
  rw [Category.assoc, pullback.condition, ← Category.assoc, ← Category.assoc, D.t_fac i j k,
    Category.assoc]

/-- Triple-overlap bridge (target): the `jk`-transition's target leg
`(t'_ijk ≫ p^{jk}) ≫ (t_jk ≫ f_kj)` to `U_k` coincides with the `ik`-transition's target
leg `p^{ik} ≫ (t_ik ≫ f_ki)`. This is the heart of the cocycle, derived from `t_fac`, the
pullback condition, `t_inv` and `cocycle`; it identifies the target of the composite
`jk`-after-`ij` transport with the target of the `ik`-transport. Project-local helper for
the module cocycle (C2). -/
theorem glueData_bridge_tgt (D : Scheme.GlueData.{u}) (i j k : D.J) :
    (D.t' i j k ≫ pullback.fst (D.f j k) (D.f j i)) ≫ (D.t j k ≫ D.f k j)
      = pullback.snd (D.f i j) (D.f i k) ≫ (D.t i k ≫ D.f k i) := by
  have key : pullback.fst (D.f k i) (D.f k j) ≫ D.f k i
      = D.t' k i j ≫ pullback.snd (D.f i j) (D.f i k) ≫ D.t i k ≫ D.f k i := by
    rw [D.t_fac_assoc k i j, ← Category.assoc (D.t k i) (D.t i k), D.t_inv, Category.id_comp]
  rw [Category.assoc, ← D.t_fac_assoc j k i,
    ← @pullback.condition _ _ _ _ _ (D.f k i) (D.f k j) _, key, D.cocycle_assoc i j k]

/-- **Gluing a sheaf of modules along an open cover given by a scheme glue datum**
(`def:scheme_modules_glue`). From a glue datum `D`, per-chart sheaves of modules `M i`,
and transition isomorphisms `g i j` comparing the two charts' sheaves over the overlap
`V (i,j)` (after pullback), produces a glued sheaf of `O_{D.glued}`-modules.

Project-local: Mathlib has no module descent over a scheme glue datum. -/
noncomputable def glue (D : Scheme.GlueData)
    (M : ∀ i, (D.U i).Modules)
    (g : ∀ i j, (Scheme.Modules.pullback (D.f i j)).obj (M i) ≅
        (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j))
    -- (C1) self-identity: over the diagonal overlap `V (i,i)` (where `t i i = 𝟙`) the
    -- transition isomorphism is the identity, i.e. the canonical isomorphism induced by
    -- `f i i = t i i ≫ f i i` (blueprint `def:scheme_modules_glue` (C1)).
    (_hC1 : ∀ i, g i i = eqToIso (congrArg (fun φ => (Scheme.Modules.pullback φ).obj (M i))
        (show D.f i i = D.t i i ≫ D.f i i by rw [D.t_id i, Category.id_comp])))
    -- (C2) triple-overlap multiplicativity: over each triple overlap
    -- `V_ijk = V_ij ×_{U_i} V_ik` the base-change transports
    -- (`pullbackBaseChangeTransport`) of the three transition isomorphisms `g_ij`, `g_jk`,
    -- `g_ik` satisfy `ĝ_jk ∘ ĝ_ij = ĝ_ik`. The three `glueData_bridge_*` identities, applied
    -- through `pullbackCongr`, line up the endpoints so the equation is well typed
    -- (blueprint `def:scheme_modules_glue` (C2), `lem:modules_pullback_basechange_transport`).
    (_hC2 : ∀ i j k,
        pullbackBaseChangeTransport (pullback.fst (D.f i j) (D.f i k))
            (D.f i j) (D.t i j ≫ D.f j i) (g i j) ≪≫
          (Scheme.Modules.pullbackCongr (glueData_bridge_mid D i j k)).app (M j) ≪≫
          pullbackBaseChangeTransport (D.t' i j k ≫ pullback.fst (D.f j k) (D.f j i))
            (D.f j k) (D.t j k ≫ D.f k j) (g j k) ≪≫
          (Scheme.Modules.pullbackCongr (glueData_bridge_tgt D i j k)).app (M k)
        = (Scheme.Modules.pullbackCongr (glueData_bridge_src D i j k)).app (M i) ≪≫
          pullbackBaseChangeTransport (pullback.snd (D.f i j) (D.f i k))
            (D.f i k) (D.t i k ≫ D.f k i) (g i k)) :
    D.glued.Modules :=
  -- **Effective descent as an equalizer of pushforwards.** The glued sheaf is the
  -- equalizer of the two canonical maps `∏ᵢ (ιᵢ)_* Mᵢ ⇉ ∏_{ij} (j_ij)_* (f_ij^* Mᵢ)`
  -- (`j_ij = f_ij ≫ ιᵢ : V_ij ↪ X`): the first map restricts the `i`-th chart section to
  -- `V_ij`, the second restricts the `j`-th and transports it across the transition `g_ij`,
  -- using the glue condition `(t_ij ≫ f_ji) ≫ ιⱼ = f_ij ≫ ιᵢ`. The cocycle hypotheses
  -- `_hC1`/`_hC2` are not needed to *construct* the object (they pin down the chart
  -- restriction isomorphisms `glueRestrictionIso`, built downstream). Pushforward preserves
  -- the sheaf condition and limits, so this equalizer of sheaves of modules is again a sheaf.
  let Qfun : D.J × D.J → D.glued.Modules := fun p =>
    (Scheme.Modules.pushforward (D.f p.1 p.2 ≫ D.ι p.1)).obj
      ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1))
  let P : D.glued.Modules := ∏ᶜ fun i => (Scheme.Modules.pushforward (D.ι i)).obj (M i)
  -- first leg: restrict the `p.1`-chart section to the overlap `V (p.1, p.2)`
  let aComp : ∀ p : D.J × D.J,
      (Scheme.Modules.pushforward (D.ι p.1)).obj (M p.1) ⟶ Qfun p := fun p =>
    (Scheme.Modules.pushforward (D.ι p.1)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction (D.f p.1 p.2)).unit.app (M p.1)) ≫
      (Scheme.Modules.pushforwardComp (D.f p.1 p.2) (D.ι p.1)).hom.app
        ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1))
  -- second leg: restrict the `p.2`-chart section, transport it across `g`, and reindex
  -- the immersion via the glue condition
  let bComp : ∀ p : D.J × D.J,
      (Scheme.Modules.pushforward (D.ι p.2)).obj (M p.2) ⟶ Qfun p := fun p =>
    (Scheme.Modules.pushforward (D.ι p.2)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction
          (D.t p.1 p.2 ≫ D.f p.2 p.1)).unit.app (M p.2)) ≫
      (Scheme.Modules.pushforwardComp (D.t p.1 p.2 ≫ D.f p.2 p.1) (D.ι p.2)).hom.app
        ((Scheme.Modules.pullback (D.t p.1 p.2 ≫ D.f p.2 p.1)).obj (M p.2)) ≫
      (Scheme.Modules.pushforward
        ((D.t p.1 p.2 ≫ D.f p.2 p.1) ≫ D.ι p.2)).map (g p.1 p.2).inv ≫
      (Scheme.Modules.pushforwardCongr
        (show (D.t p.1 p.2 ≫ D.f p.2 p.1) ≫ D.ι p.2 = D.f p.1 p.2 ≫ D.ι p.1 by
          rw [Category.assoc]; exact D.glue_condition p.1 p.2)).hom.app
        ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1))
  let a : P ⟶ ∏ᶜ Qfun := Pi.lift fun p => Pi.π _ p.1 ≫ aComp p
  let b : P ⟶ ∏ᶜ Qfun := Pi.lift fun p => Pi.π _ p.2 ≫ bComp p
  equalizer a b

/-- **Lift into the glued sheaf** (`def:gr_modules_glueHom`-adjacent primitive): a family of
morphisms `k i : W ⟶ (ι_i)_* M_i` whose two overlap restrictions agree (the hypothesis
`hk`, stated against the two legs of the descent equalizer) lifts to a morphism
`W ⟶ glue D M g _ _`. This is `equalizer.lift` for the descent equalizer of pushforwards;
it is the vehicle by which the tautological quotient is assembled from the chart
quotients. Project-local. -/
noncomputable def glueLift (D : Scheme.GlueData)
    (M : ∀ i, (D.U i).Modules)
    (g : ∀ i j, (Scheme.Modules.pullback (D.f i j)).obj (M i) ≅
        (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j))
    (_hC1 : ∀ i, g i i = eqToIso (congrArg (fun φ => (Scheme.Modules.pullback φ).obj (M i))
        (show D.f i i = D.t i i ≫ D.f i i by rw [D.t_id i, Category.id_comp])))
    (_hC2 : ∀ i j k,
        pullbackBaseChangeTransport (pullback.fst (D.f i j) (D.f i k))
            (D.f i j) (D.t i j ≫ D.f j i) (g i j) ≪≫
          (Scheme.Modules.pullbackCongr (glueData_bridge_mid D i j k)).app (M j) ≪≫
          pullbackBaseChangeTransport (D.t' i j k ≫ pullback.fst (D.f j k) (D.f j i))
            (D.f j k) (D.t j k ≫ D.f k j) (g j k) ≪≫
          (Scheme.Modules.pullbackCongr (glueData_bridge_tgt D i j k)).app (M k)
        = (Scheme.Modules.pullbackCongr (glueData_bridge_src D i j k)).app (M i) ≪≫
          pullbackBaseChangeTransport (pullback.snd (D.f i j) (D.f i k))
            (D.f i k) (D.t i k ≫ D.f k i) (g i k))
    {W : D.glued.Modules}
    (k : ∀ i, W ⟶ (Scheme.Modules.pushforward (D.ι i)).obj (M i))
    (hk : ∀ p : D.J × D.J,
      k p.1 ≫
          ((Scheme.Modules.pushforward (D.ι p.1)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction (D.f p.1 p.2)).unit.app (M p.1)) ≫
          (Scheme.Modules.pushforwardComp (D.f p.1 p.2) (D.ι p.1)).hom.app
            ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1)))
        = k p.2 ≫
          ((Scheme.Modules.pushforward (D.ι p.2)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction
              (D.t p.1 p.2 ≫ D.f p.2 p.1)).unit.app (M p.2)) ≫
          (Scheme.Modules.pushforwardComp (D.t p.1 p.2 ≫ D.f p.2 p.1) (D.ι p.2)).hom.app
            ((Scheme.Modules.pullback (D.t p.1 p.2 ≫ D.f p.2 p.1)).obj (M p.2)) ≫
          (Scheme.Modules.pushforward
            ((D.t p.1 p.2 ≫ D.f p.2 p.1) ≫ D.ι p.2)).map (g p.1 p.2).inv ≫
          (Scheme.Modules.pushforwardCongr
            (show (D.t p.1 p.2 ≫ D.f p.2 p.1) ≫ D.ι p.2 = D.f p.1 p.2 ≫ D.ι p.1 by
              rw [Category.assoc]; exact D.glue_condition p.1 p.2)).hom.app
            ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1)))) :
    W ⟶ glue D M g _hC1 _hC2 :=
  equalizer.lift (Pi.lift k) (by
    apply Pi.hom_ext
    intro p
    simp only [Category.assoc, Limits.Pi.lift_π, Limits.Pi.lift_π_assoc]
    exact hk p)

/-! ### Pullback of free sheaves along an arbitrary scheme morphism

The functor of points (`AlgebraicGeometry.Grassmannian.functor`) acts on morphisms by
pullback, and for that one needs `f^* (O^n) ≅ O^n` for an *arbitrary* scheme morphism
`f`. Mathlib's `SheafOfModules.pullbackObjFreeIso` supplies this only when the underlying
site functor `Opens.map f.base` is `Final`; the previous chapters discharged that `Final`
hypothesis only for open immersions and isomorphisms. The first lemma below removes the
restriction entirely: `Opens.map f.base` is `Final` for *every* scheme morphism, because
the structured-arrow category over any open `V` has a terminal object (the whole space
`⊤`). With that in hand, `pullbackFreeIso` and `pullback_isLocallyFreeOfRank` hold for all
morphisms. -/

/-- For an arbitrary scheme morphism `φ`, the site functor `Opens.map φ.base` is `Final`:
over any open `V` of the target the structured-arrow category `{U : V ≤ φ⁻¹ U}` has the
terminal object `U = ⊤`, hence is connected. This is the missing ingredient that makes
`SheafOfModules.pullbackObjUnitToUnit`/`pullbackObjFreeIso` applicable to *every* morphism,
not just to open immersions. Project-local. -/
lemma opensMap_final {T' T : Scheme.{u}} (φ : T' ⟶ T) :
    (TopologicalSpace.Opens.map φ.base).Final := by
  constructor
  intro V
  set top : StructuredArrow V (TopologicalSpace.Opens.map φ.base) :=
    StructuredArrow.mk (Y := (⊤ : T.Opens)) (homOfLE le_top)
  haveI : Nonempty (StructuredArrow V (TopologicalSpace.Opens.map φ.base)) := ⟨top⟩
  apply zigzag_isConnected
  intro s t
  have hs : s ⟶ top := StructuredArrow.homMk (homOfLE le_top) (Subsingleton.elim _ _)
  have ht : t ⟶ top := StructuredArrow.homMk (homOfLE le_top) (Subsingleton.elim _ _)
  exact Relation.ReflTransGen.trans
    (Relation.ReflTransGen.single (Or.inl ⟨hs⟩))
    (Relation.ReflTransGen.single (Or.inr ⟨ht⟩))

/-- **Pullback of a free sheaf of modules is free, for any scheme morphism**: for
`φ : T' ⟶ T` and an index type `I`, `φ^*(O_T^{⊕I}) ≅ O_{T'}^{⊕I}`. Built from
`SheafOfModules.pullbackObjFreeIso` once `opensMap_final` supplies the `Final` instance.
Project-local. -/
noncomputable def pullbackFreeIso {T' T : Scheme.{u}} (φ : T' ⟶ T) (I : Type u) :
    (Scheme.Modules.pullback φ).obj (SheafOfModules.free (R := T.ringCatSheaf) I)
      ≅ SheafOfModules.free (R := T'.ringCatSheaf) I := by
  haveI := opensMap_final φ
  exact SheafOfModules.pullbackObjFreeIso φ.toRingCatSheafHom I

/-- The free-pullback comparison is natural in the base morphism: equal morphisms give
`pullbackFreeIso`s related by the `eqToHom` transport of their (differing) sources.
Project-local — used for the bundle-transition self-identity. -/
lemma pullbackFreeIso_eqToHom {T' T : Scheme.{u}} {φ ψ : T' ⟶ T} (h : φ = ψ) (I : Type u) :
    eqToHom (congrArg
        (fun α => (Scheme.Modules.pullback α).obj (SheafOfModules.free (R := T.ringCatSheaf) I)) h)
        ≫ (pullbackFreeIso ψ I).hom
      = (pullbackFreeIso φ I).hom := by
  subst h; simp

/-- Iso-level free-pullback cancellation: for equal base morphisms `φ = ψ`, the composite
`pullbackFreeIso φ ≪≫ (pullbackFreeIso ψ).symm` is the `eqToIso` transport between the
(differing) pullback sources. Proved generically (`φ`, `ψ` variables, `subst`), so applying
it never forces the kernel to whnf a concrete immersion — the leaner replacement for the
`.hom`-level cast chain in `bundleTransition_self`. Project-local. -/
lemma pullbackFreeIso_trans_symm_eqToIso {T' T : Scheme.{u}} {φ ψ : T' ⟶ T} (h : φ = ψ)
    (I : Type u) :
    pullbackFreeIso φ I ≪≫ (pullbackFreeIso ψ I).symm
      = eqToIso (congrArg
          (fun α => (Scheme.Modules.pullback α).obj (SheafOfModules.free (R := T.ringCatSheaf) I))
          h) := by
  subst h; simp

/-- **Pullback preserves rank-`d` local freeness.** If `M` is locally free of rank `d` on
`T`, then `φ^* M` is locally free of rank `d` on `T'`, for any scheme morphism `φ`. The
chart cover `{U i}` of `T` trivialising `M` pulls back to the cover `{φ⁻¹ U i}` of `T'`;
on each member the restriction of `φ^* M` is identified with the pulled-back chart-free
sheaf via the pseudofunctor comparison `pullbackComp`, the factorisation
`φ ∘ (φ⁻¹ U i).ι = (φ ∣_ U i) ≫ (U i).ι` (`morphismRestrict_ι`), and `pullbackFreeIso`.
Project-local. -/
lemma pullback_isLocallyFreeOfRank {T' T : Scheme.{u}} (φ : T' ⟶ T) {M : T.Modules}
    {d : ℕ} (h : SheafOfModules.IsLocallyFreeOfRank M d) :
    SheafOfModules.IsLocallyFreeOfRank ((Scheme.Modules.pullback φ).obj M) d := by
  obtain ⟨ι, U, hcover, hloc⟩ := h
  refine ⟨ι, fun i => φ ⁻¹ᵁ (U i), Scheme.Hom.iSup_preimage_eq_top φ hcover, ?_⟩
  intro i
  obtain ⟨e⟩ := hloc i
  exact ⟨(Scheme.Modules.pullbackComp (φ ⁻¹ᵁ (U i)).ι φ).app M ≪≫
    (Scheme.Modules.pullbackCongr (morphismRestrict_ι φ (U i)).symm).app M ≪≫
    ((Scheme.Modules.pullbackComp (φ ∣_ (U i)) (U i).ι).app M).symm ≪≫
    (Scheme.Modules.pullback (φ ∣_ (U i))).mapIso e ≪≫
    pullbackFreeIso (φ ∣_ (U i)) (ULift.{u} (Fin d))⟩

end AlgebraicGeometry.Scheme.Modules

namespace AlgebraicGeometry.Grassmannian

/-! ## The GL_d bundle transition cocycle

The universal quotient `U` is glued from the per-chart free rank-`d` sheaves `O_{U^I}^d`
along the bundle transitions `g_{I,J} = (X^I_J)⁻¹`, realised as matrix automorphisms via
`matrixToFreeIso` and conjugated to the overlap pullbacks by `pullbackFreeIso`. This section
constructs `bundleTransition` and proves its self-identity (C1); the triple-overlap
multiplicativity (C2) is the matrix cocycle of `lem:gr_cocycle` transported to the common
overlap by `pullbackBaseChangeTransport`/`glueData_bridge_*`. -/

/-- The Cramer inverse of the self-minor `X^I_I` is the identity: since `X^I_I = 1`
(`universalMatrix_submatrix_self`) its inverse is `1`. Project-local; underlies C1. -/
lemma universalMinorInv_self (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    universalMinorInv d r I I hI hI = 1 := by
  have hmin : universalMinor d r I I hI hI = 1 := by
    rw [universalMinor, universalMatrix_submatrix_self, Matrix.map_one _ (map_zero _) (map_one _)]
  rw [universalMinorInv, hmin, inv_one]

/-- The injected Cramer inverse and minor matrices over the overlap structure sheaf are
mutually inverse — the `GL_d` invertibility hypotheses for `matrixToFreeIso`. Project-local. -/
private lemma bundleMatrix_cancel (d r : ℕ) (I J : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) :
    ((Scheme.ΓSpecIso
        (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ)))).inv.hom.mapMatrix
        (universalMinorInv d r I J hI hJ)) *
      ((Scheme.ΓSpecIso
        (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ)))).inv.hom.mapMatrix
        (universalMinor d r I J hI hJ)) = 1 ∧
    ((Scheme.ΓSpecIso
        (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ)))).inv.hom.mapMatrix
        (universalMinor d r I J hI hJ)) *
      ((Scheme.ΓSpecIso
        (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ)))).inv.hom.mapMatrix
        (universalMinorInv d r I J hI hJ)) = 1 := by
  refine ⟨?_, ?_⟩
  · rw [← map_mul, (universalMinorInv_mul_cancel d r I J hI hJ).1, map_one]
  · rw [← map_mul, (universalMinorInv_mul_cancel d r I J hI hJ).2, map_one]

/-- The **bundle transition** `g_{I,J}` (`def:gr_bundleTransition`): the isomorphism of
sheaves of modules on the overlap `U^I_J` induced by the invertible matrix
`(X^I_J)⁻¹ = universalMinorInv d r I J`. It identifies the pullback of `O_{U^I}^d` along
`f_{IJ}` with the pullback of `O_{U^J}^d` along `t_{IJ} ≫ f_{JI}`, by conjugating the
matrix automorphism `matrixToFreeIso (X^I_J)⁻¹` (built like `chartQuotientMap`) by the
free-pullback comparisons `pullbackFreeIso`. -/
noncomputable def bundleTransition (d r : ℕ) (I J : Finset (Fin r))
    (hI : I.card = d) (hJ : J.card = d) :
    (Scheme.Modules.pullback (chartIncl d r I J hI hJ)).obj
        (SheafOfModules.free (R := (affineChart d r I).ringCatSheaf) (Fin d)) ≅
      (Scheme.Modules.pullback (chartTransition d r I J hI hJ ≫ chartIncl d r J I hJ hI)).obj
        (SheafOfModules.free (R := (affineChart d r J).ringCatSheaf) (Fin d)) :=
  Scheme.Modules.pullbackFreeIso (chartIncl d r I J hI hJ) (Fin d) ≪≫
    matrixToFreeIso
      ((Scheme.ΓSpecIso
          (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ)))).inv.hom.mapMatrix
        (universalMinorInv d r I J hI hJ))
      ((Scheme.ΓSpecIso
          (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ)))).inv.hom.mapMatrix
        (universalMinor d r I J hI hJ))
      (bundleMatrix_cancel d r I J hI hJ).1
      (bundleMatrix_cancel d r I J hI hJ).2 ≪≫
    (Scheme.Modules.pullbackFreeIso
      (chartTransition d r I J hI hJ ≫ chartIncl d r J I hJ hI) (Fin d)).symm

/-- **Self-identity of the bundle transition (C1)** (`lem:gr_bundleCocycle_id`): on the
diagonal overlap `U^I_I` (where `t_{II} = 𝟙`) the bundle transition is the identity, in the
form required by the gluing primitive `Scheme.Modules.glue`. The matrix part is the identity
since `(X^I_I)⁻¹ = 1` (`universalMinorInv_self`), so `matrixEnd 1 = 𝟙` (`matrixEnd_one`); the
two free-pullback comparisons then cancel into the `eqToIso` transport.

Resource note (iter-060): the former `set_option maxHeartbeats 1000000 in` override is
removed and the proof rebuilt as a *leaner term* that the kernel checks within the default
budget (the earlier `.hom`-level cast chain hit a `(kernel) deterministic timeout` at default
heartbeats and an OOM ceiling on cold builds at `1000000`). The new term works at the **iso
level**: the matrix automorphism is collapsed to `Iso.refl` in the lightweight single-overlap
context (`hB`, free sheaves only — no pullback), and the two free-pullback comparisons cancel
through the *generic* lemma `pullbackFreeIso_trans_symm_eqToIso` (proved by `subst` on
variable morphisms), so the kernel never whnfs the concrete immersions `chartIncl` /
`chartTransition`. -/
theorem bundleTransition_self (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    bundleTransition d r I I hI hI
      = eqToIso (congrArg
          (fun φ => (Scheme.Modules.pullback φ).obj
            (SheafOfModules.free (R := (affineChart d r I).ringCatSheaf) (Fin d)))
          (show chartIncl d r I I hI hI
              = chartTransition d r I I hI hI ≫ chartIncl d r I I hI hI from by
            rw [chartTransition_self, Category.id_comp])) := by
  have hφ : chartIncl d r I I hI hI
      = chartTransition d r I I hI hI ≫ chartIncl d r I I hI hI := by
    rw [chartTransition_self, Category.id_comp]
  -- The matrix automorphism is the identity iso: `(X^I_I)⁻¹` injects to the identity matrix,
  -- so its `matrixEnd` is `𝟙`. Proved here over the single overlap chart (no pullback types).
  have hB : matrixToFreeIso
        ((Scheme.ΓSpecIso
            (CommRingCat.of (Localization.Away (minorDet d r I I hI hI)))).inv.hom.mapMatrix
          (universalMinorInv d r I I hI hI))
        ((Scheme.ΓSpecIso
            (CommRingCat.of (Localization.Away (minorDet d r I I hI hI)))).inv.hom.mapMatrix
          (universalMinor d r I I hI hI))
        (bundleMatrix_cancel d r I I hI hI).1
        (bundleMatrix_cancel d r I I hI hI).2
      = Iso.refl _ := by
    apply Iso.ext
    rw [matrixToFreeIso_hom, Iso.refl_hom, universalMinorInv_self, map_one, matrixEnd_one]
  -- Unfold the transition, collapse the identity matrix factor (`erw` to bridge the
  -- `chartOverlap`/`Spec` defeq on the inferred base scheme), and cancel the comparisons.
  simp only [bundleTransition]
  erw [hB, Iso.refl_trans]
  exact Scheme.Modules.pullbackFreeIso_trans_symm_eqToIso hφ (Fin d)

/-- The bundle transition data packaged over the Grassmannian glue datum, ready to feed the
gluing primitive `Scheme.Modules.glue`. Project-local. -/
noncomputable def bundleTransitionData (d r : ℕ) :
    ∀ (I J : (theGlueData d r).J),
      (Scheme.Modules.pullback ((theGlueData d r).f I J)).obj
          (SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d)) ≅
        (Scheme.Modules.pullback ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)).obj
          (SheafOfModules.free (R := ((theGlueData d r).U J).ringCatSheaf) (Fin d)) :=
  fun I J => bundleTransition d r I.1 J.1 I.2 J.2

/-! ### The matrix-level Cramer-inverse cocycle (L1)

The matrix-algebra core of (C2) is the Cramer-inverse cocycle
`(X^J_K)⁻¹ (X^I_J)⁻¹ = (X^I_K)⁻¹` over the triple-overlap ring `S_I = R^I[1/(P^I_J P^I_K)]`.
Its proof reduces to the image-matrix cocycle `cocycle_imageMatrix_eq` of
`GrassmannianCells` by taking the `I`-minor. That lemma and the matrix helpers it depends on
are `private` in `GrassmannianCells.lean`, so they are reproduced here as project-local
helpers (the proofs are verbatim ports of the known-good originals). -/

/-- Port of `GrassmannianCells.mul_submatrix_col` (private there). -/
private lemma mul_submatrix_col' {d r : ℕ} {R : Type*} [CommRing R]
    (A : Matrix (Fin d) (Fin d) R) (B : Matrix (Fin d) (Fin r) R) (g : Fin d → Fin r) :
    (A * B).submatrix id g = A * B.submatrix id g := by
  ext i j; simp [Matrix.mul_apply, Matrix.submatrix_apply]

/-- Port of `GrassmannianCells.map_nonsing_inv` (private there). -/
private lemma map_nonsing_inv' {n : ℕ} {R S : Type*} [CommRing R] [CommRing S] (f : R →+* S)
    (A : Matrix (Fin n) (Fin n) R) (h : IsUnit A.det) :
    (A.map f)⁻¹ = A⁻¹.map f := by
  have hmul : (A.map f) * (A⁻¹.map f) = 1 := by
    rw [← Matrix.map_mul, Matrix.mul_nonsing_inv A h, Matrix.map_one f (map_zero f) (map_one f)]
  exact Matrix.inv_eq_right_inv hmul

/-- Port of `GrassmannianCells.map_map_eq_of_comp` (private there). -/
private lemma map_map_eq_of_comp' {m n : ℕ} {R A D : Type*}
    [CommRing R] [CommRing A] [CommRing D]
    (M : Matrix (Fin m) (Fin n) R) (f : R →+* A) (g : A →+* D) (h : R →+* D)
    (hcomp : g.comp f = h) : (M.map f).map g = M.map h := by
  rw [Matrix.map_map, ← RingHom.coe_comp, hcomp]

/-- Port of `GrassmannianCells.isUnit_algebraMap_away_left` (private there). -/
private lemma isUnit_algebraMap_away_left' {R : Type*} [CommRing R] (x y : R) :
    IsUnit (algebraMap R (Localization.Away (x * y)) x) := by
  have h : IsUnit (algebraMap R (Localization.Away (x * y)) (x * y)) :=
    IsLocalization.Away.algebraMap_isUnit _
  rw [map_mul] at h
  exact isUnit_of_mul_isUnit_left h

/-- Port of `GrassmannianCells.inv_mul_inv_mul_cancel` (private there). -/
private lemma inv_mul_inv_mul_cancel' {d e : ℕ} {R : Type*} [CommRing R]
    (A B : Matrix (Fin d) (Fin d) R) (M : Matrix (Fin d) (Fin e) R) (hA : IsUnit A.det) :
    (B⁻¹ * A) * (A⁻¹ * M) = B⁻¹ * M := by
  rw [Matrix.mul_assoc B⁻¹ A (A⁻¹ * M), ← Matrix.mul_assoc A A⁻¹ M,
    Matrix.mul_nonsing_inv A hA, Matrix.one_mul]

/-- Port of `GrassmannianCells.imageMatrix_map_eq` (private there). -/
private lemma imageMatrix_map_eq' (d r : ℕ) (I X : Finset (Fin r)) (hI : I.card = d)
    (hX : X.card = d) {D : Type*} [CommRing D]
    [Algebra (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ) D]
    (incl : Localization.Away (minorDet d r I X hI hX) →+* D)
    (hincl : incl.comp (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
        (Localization.Away (minorDet d r I X hI hX)))
        = algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ) D) :
    (imageMatrix d r I X hI hX).map incl
      = (((universalMatrix d r I hI).map
            (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ) D)).submatrix id
          (fun j : Fin d => (X.orderIsoOfFin hX j : Fin r)))⁻¹ *
        (universalMatrix d r I hI).map
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ) D) := by
  have hmm : (imageMatrix d r I X hI hX).map incl
      = (universalMinorInv d r I X hI hX).map incl
        * ((universalMatrix d r I hI).map
            (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
              (Localization.Away (minorDet d r I X hI hX)))).map incl := by
    rw [imageMatrix]; exact Matrix.map_mul
  rw [hmm, map_map_eq_of_comp' _ _ _ _ hincl, universalMinorInv,
    ← map_nonsing_inv' incl (universalMinor d r I X hI hX)
        (isUnit_det_universalMinor d r I X hI hX)]
  congr 1
  rw [universalMinor, map_map_eq_of_comp' _ _ _ _ hincl, ← Matrix.submatrix_map]

/-- Port of `GrassmannianCells.cocycle_imageMatrix_eq` (private there): over the triple
overlap `S_I`, the image matrix `(X^I_K)⁻¹ X^I` of `θ_{I,K}` equals `θ_{I,J}` applied
entrywise to the image matrix `(X^J_K)⁻¹ X^J` of `θ_{J,K}`. -/
private lemma cocycle_imageMatrix_eq' (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (imageMatrix d r I K hI hK).map
        (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
      = (imageMatrix d r J K hJ hK).map
          ((cocycleΘIJ d r I J K hI hJ hK).comp
            (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))) := by
  have hLHS := imageMatrix_map_eq' d r I K hI hK
    (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
    (awayInclRight_comp_algebraMap _ _)
  have hMJimg := imageMatrix_map_eq' d r I J hI hJ
    (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
    (awayInclLeft_comp_algebraMap _ _)
  set Y := (universalMatrix d r I hI).map
      (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
        (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK))) with hY
  have hYJ : IsUnit (Y.submatrix id (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))).det := by
    have e : (Y.submatrix id (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r))).det
        = algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)
            (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK))
            (minorDet d r I J hI hJ) := by
      rw [hY, Matrix.submatrix_map]
      exact (RingHom.map_det _ _).symm
    rw [e]; exact isUnit_algebraMap_away_left' _ _
  have hχ : ((cocycleΘIJ d r I J K hI hJ hK).comp
        (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))).comp
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ)
            (Localization.Away (minorDet d r J K hJ hK)))
      = (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
          (transitionPreMap d r I J hI hJ).toRingHom := by
    rw [RingHom.comp_assoc, awayInclRight_comp_algebraMap, cocycleΘIJ]
    exact IsLocalization.Away.lift_comp _ _
  have hMJ : (universalMatrix d r J hJ).map
        ((awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
          (transitionPreMap d r I J hI hJ).toRingHom)
      = (Y.submatrix id (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r)))⁻¹ * Y := by
    have e1 : (universalMatrix d r J hJ).map
          ((awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
            (transitionPreMap d r I J hI hJ).toRingHom)
        = (imageMatrix d r I J hI hJ).map
            (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) := by
      rw [← map_map_eq_of_comp' (universalMatrix d r J hJ)
          (transitionPreMap d r I J hI hJ).toRingHom
          (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) _ rfl]
      congr 1
      exact universalMatrix_map_transitionPreMap d r I J hI hJ
    rw [e1, hMJimg]
  have hRHS : (imageMatrix d r J K hJ hK).map
        ((cocycleΘIJ d r I J K hI hJ hK).comp
          (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))
      = (Y.submatrix id (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r)))⁻¹ * Y := by
    have hmm : (imageMatrix d r J K hJ hK).map
          ((cocycleΘIJ d r I J K hI hJ hK).comp
            (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))
        = (universalMinorInv d r J K hJ hK).map
            ((cocycleΘIJ d r I J K hI hJ hK).comp
              (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))
          * ((universalMatrix d r J hJ).map
              (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ)
                (Localization.Away (minorDet d r J K hJ hK)))).map
                  ((cocycleΘIJ d r I J K hI hJ hK).comp
                    (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))) := by
      rw [imageMatrix]; exact Matrix.map_mul
    rw [hmm, map_map_eq_of_comp' _ _ _ _ hχ, hMJ, universalMinorInv,
      ← map_nonsing_inv' _ _ (isUnit_det_universalMinor d r J K hJ hK), universalMinor,
      map_map_eq_of_comp' _ _ _ _ hχ, ← Matrix.submatrix_map, hMJ,
      mul_submatrix_col' (Y.submatrix id (fun j : Fin d => (J.orderIsoOfFin hJ j : Fin r)))⁻¹ Y
        (fun j : Fin d => (K.orderIsoOfFin hK j : Fin r)),
      Matrix.mul_inv_rev, Matrix.nonsing_inv_nonsing_inv _ hYJ,
      inv_mul_inv_mul_cancel' _ _ _ hYJ]
  rw [hLHS, hRHS]

/-- **Cramer-inverse cocycle on the triple overlap (L1)** (`lem:gr_bundleCocycle_matrix`):
over the triple-overlap ring `S_I = R^I[1/(P^I_J P^I_K)]` the base-changed Cramer inverses of
the localised minors satisfy the multiplicative cocycle identity
`(X^J_K)⁻¹ (X^I_J)⁻¹ = (X^I_K)⁻¹`. This is the pure matrix-algebra core of (C2), independent
of any sheaf data. Project-local. -/
theorem bundleTransition_cocycle_matrix (d r : ℕ) (I J K : Finset (Fin r))
    (hI : I.card = d) (hJ : J.card = d) (hK : K.card = d) :
    (universalMinorInv d r J K hJ hK).map
        ((cocycleΘIJ d r I J K hI hJ hK).comp
          (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))
      * (universalMinorInv d r I J hI hJ).map
          (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))
      = (universalMinorInv d r I K hI hK).map
          (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) := by
  -- Take the `I`-minor (columns indexed by `I`) of the image-matrix cocycle.
  have hcol := congrArg
    (fun M : Matrix (Fin d) (Fin r) (Localization.Away
        (minorDet d r I J hI hJ * minorDet d r I K hI hK)) =>
      M.submatrix id (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)))
    (cocycle_imageMatrix_eq' d r I J K hI hJ hK)
  simp only at hcol
  -- LHS of `hcol` is `(X^I_K)⁻¹` over `S_I`.
  rw [Matrix.submatrix_map, imageMatrix_submatrix_I] at hcol
  -- RHS of `hcol`: push the `I`-minor through the outer map.
  rw [Matrix.submatrix_map] at hcol
  -- `imageMatrix J K = (X^J_K)⁻¹ * X^J`, so its `I`-minor splits off the inverse factor;
  -- the second factor is `X^J` (over `R^J[1/P^J_K]`) restricted to the `I`-columns.
  have hsplit : (imageMatrix d r J K hJ hK).submatrix id
        (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))
      = universalMinorInv d r J K hJ hK *
        ((universalMatrix d r J hJ).map
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ)
            (Localization.Away (minorDet d r J K hJ hK)))).submatrix id
          (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r)) := by
    rw [imageMatrix]; exact mul_submatrix_col' _ _ _
  rw [hsplit, Matrix.map_mul] at hcol
  -- The comp identity `θ_{I,J}` realises the cross-localisation map on `R^J`.
  have hχ : ((cocycleΘIJ d r I J K hI hJ hK).comp
        (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))).comp
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ)
            (Localization.Away (minorDet d r J K hJ hK)))
      = (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
          (transitionPreMap d r I J hI hJ).toRingHom := by
    rw [RingHom.comp_assoc, awayInclRight_comp_algebraMap, cocycleΘIJ]
    exact IsLocalization.Away.lift_comp _ _
  have e1 : (universalMatrix d r J hJ).map
        ((awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).comp
          (transitionPreMap d r I J hI hJ).toRingHom)
      = (imageMatrix d r I J hI hJ).map
          (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) := by
    rw [← map_map_eq_of_comp' (universalMatrix d r J hJ)
        (transitionPreMap d r I J hI hJ).toRingHom
        (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) _ rfl]
    congr 1
    exact universalMatrix_map_transitionPreMap d r I J hI hJ
  -- The base change of `X^J|_I` over `θ_{I,J}` is `(X^I_J)⁻¹` over `S_I`.
  have hXJI : (((universalMatrix d r J hJ).map
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ J}) ℤ)
            (Localization.Away (minorDet d r J K hJ hK)))).submatrix id
          (fun j : Fin d => (I.orderIsoOfFin hI j : Fin r))).map
          ((cocycleΘIJ d r I J K hI hJ hK).comp
            (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))
      = (universalMinorInv d r I J hI hJ).map
          (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) := by
    rw [Matrix.submatrix_map, map_map_eq_of_comp' _ _ _ _ hχ, ← Matrix.submatrix_map, e1,
      Matrix.submatrix_map, imageMatrix_submatrix_I]
  rw [hXJI] at hcol
  exact hcol.symm

/-! ### L3 transport: `scalarEnd`/`matrixEnd` naturality under pullback

The substantive new infrastructure for (C2). The atom is `scalarEnd_pullback`: pulling back a
scalar endomorphism `scalarEnd a` along a scheme morphism `p` is, after the unit-pullback
comparison `pullbackObjUnitToUnit`, the scalar endomorphism of the base-changed function
`p.appTop a`. Its proof transposes the naturality square under the pullback-pushforward
adjunction to a `unit`-level identity, which holds by naturality of the comorphism `p.c`. -/

/-- The reduced (transposed) form of the scalar-naturality atom: on the unit sheaf,
multiplication by `a` followed by the comorphism `unitToPushforwardObjUnit` equals the
comorphism followed by the pushforward of multiplication by `p.appTop a`. Project-local
helper for `scalarEnd_pullback`. -/
lemma unitToPushforward_scalarEnd_comm {T S : Scheme.{0}} (p : T ⟶ S) (a : Γ(S, ⊤)) :
    scalarEnd a ≫ SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom p)
      = SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom p) ≫
        (Scheme.Modules.pushforward p).map (scalarEnd (p.appTop a)) := by
  apply ((Scheme.Modules.pushforward p).obj
    (SheafOfModules.unit T.ringCatSheaf)).unitHomEquiv.injective
  refine PresheafOfModules.sections_ext _ _ (fun Y => ?_)
  -- Both `.val Y` are nested applications (no morphism composite) up to defeq, since
  -- `unitHomEquiv (f ≫ p) = sectionsMap p (unitHomEquiv f)` and `sectionsMap`/`unitHomEquiv`
  -- are `rfl`/`sectionsMk`-defined; rewrite into that form via `change`.
  change (SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom p)).val.app Y
        ((scalarEnd a).val.app Y (1 : S.ringCatSheaf.obj.obj Y))
      = ((Scheme.Modules.pushforward p).map
            (scalarEnd ((Scheme.Hom.appTop p) a))).val.app Y
        ((SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom p)).val.app Y
          (1 : S.ringCatSheaf.obj.obj Y))
  rw [scalarEnd_val_app_one, SheafOfModules.unitToPushforwardObjUnit_val_app_apply,
    SheafOfModules.unitToPushforwardObjUnit_val_app_apply, map_one]
  -- Goal: `φ.hom.app Y (a|_Y) = ((pushforward p).map (scalarEnd (p.appTop a))).val.app Y 1`.
  -- RHS reduces (defeq, the pushforward's `map`-application is `rfl` + `scalarEnd_val_app_one`)
  -- to `T.ringCatSheaf.obj.map (homOfLE le_top).op (p.appTop a)`; LHS rewrites to the same by
  -- naturality of the comorphism `(toRingCatSheafHom p).hom` at `(homOfLE le_top).op : op ⊤ ⟶ Y`.
  have hnat := ConcreteCategory.congr_hom
    ((Scheme.Hom.toRingCatSheafHom p).hom.naturality (homOfLE (le_top : Y.unop ≤ ⊤)).op) a
  rw [CategoryTheory.comp_apply, CategoryTheory.comp_apply] at hnat
  rw [hnat]
  -- The RHS pushforward (its `map`-application is `rfl` on sections) evaluates the
  -- scalar endomorphism `scalarEnd (p.appTop a)` at `1` over the preimage open; both sides are
  -- then `T.ringCatSheaf.obj.map (homOfLE le_top).op (p.appTop a)` (the `homOfLE`s agree by
  -- proof irrelevance, the comorphism by `forget₂`-on-elements), so `scalarEnd_val_app_one` closes.
  exact (scalarEnd_val_app_one ((Scheme.Hom.appTop p) a)
    (Opposite.op ((TopologicalSpace.Opens.map p.base).obj (Opposite.unop Y)))).symm

/-- **ATOM: scalar endomorphism naturality under pullback** (`lem:gr_scalarEnd_pullback`).
For `p : T ⟶ S` and `a ∈ Γ(S,⊤)`, pulling back the scalar endomorphism `scalarEnd a` is,
after the unit-pullback comparison `q = pullbackObjUnitToUnit`, the scalar endomorphism of the
base-changed function `p.appTop a`:
`(pullback p).map (scalarEnd a) ≫ q = q ≫ scalarEnd (p.appTop a)`.
Proved by transposing under the pullback-pushforward adjunction to
`unitToPushforward_scalarEnd_comm`.
Project-local — the single irreducible new claim underlying `matrixEnd_pullback`. -/
lemma scalarEnd_pullback {T S : Scheme.{0}} (p : T ⟶ S) (a : Γ(S, ⊤)) :
    (Scheme.Modules.pullback p).map (scalarEnd a) ≫
        SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom p)
      = SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom p) ≫
        scalarEnd (p.appTop a) := by
  apply (Scheme.Modules.pullbackPushforwardAdjunction p).homEquiv
    (SheafOfModules.unit S.ringCatSheaf) (SheafOfModules.unit T.ringCatSheaf) |>.injective
  -- `homEquiv_naturality_left` collapses the LHS transpose; the RHS transpose
  -- (`homEquiv_naturality_right`) is supplied as a term because positional `rw` cannot match
  -- the identical-printing `homEquiv` under the `X.Modules` diamond (memory
  -- `grquot-functor-dropped-termmode`).
  -- `hq` is the lemma `..._homEquiv_pullbackObjUnitToUnit` restated in the `Scheme.Modules`
  -- adjunction form (defeq to the `SheafOfModules` form), so `rw`/`congrArg` match syntactically.
  have hq : (Scheme.Modules.pullbackPushforwardAdjunction p).homEquiv
        (SheafOfModules.unit S.ringCatSheaf) (SheafOfModules.unit T.ringCatSheaf)
        (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom p))
      = SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom p) :=
    SheafOfModules.pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit _
  rw [Adjunction.homEquiv_naturality_left, hq]
  refine (unitToPushforward_scalarEnd_comm p a).trans ?_
  exact (((Scheme.Modules.pullbackPushforwardAdjunction p).homEquiv_naturality_right
        (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom p))
        (scalarEnd (p.appTop a))).trans
      (congrArg (· ≫ (Scheme.Modules.pushforward p).map (scalarEnd (p.appTop a))) hq)).symm

/-- The action of `matrixEnd M` on the `j`-th free injection: `ιFree j ≫ matrixEnd M`
expands as the sum over rows `∑ k, scalarEnd (M k j) ≫ ιFree k`. Project-local helper
for `matrixEnd_pullback`. -/
lemma ιFree_matrixEnd {S : Scheme.{0}} {d : ℕ} (M : Matrix (Fin d) (Fin d) Γ(S, ⊤))
    (j : Fin d) :
    SheafOfModules.ιFree (R := S.ringCatSheaf) j ≫ matrixEnd M
      = ∑ k, scalarEnd (M k j) ≫ SheafOfModules.ιFree (R := S.ringCatSheaf) k := by
  rw [matrixEnd, SheafOfModules.ιFree]
  simp only [SheafOfModules.free]
  rw [Iso.symm_hom, biproduct.isoCoproduct_inv, biproduct.isoCoproduct_hom,
    ← Category.assoc, Sigma.ι_desc, biproduct.ι_matrix_assoc, biproduct.lift_desc]
  rfl

/-- **(a) Matrix endomorphism naturality under pullback** (`lem:gr_matrixEnd_pullback`).
For `p : T ⟶ S` and `M : Matrix (Fin d) (Fin d) Γ(S,⊤)`, the pullback of the matrix
endomorphism `matrixEnd M` is, after the free-pullback comparison `Q = pullbackFreeIso p (Fin d)`,
the matrix endomorphism of the base-changed matrix `p.appTop • M` (entrywise comorphism):
`(pullback p).map (matrixEnd M) = Q.hom ≫ matrixEnd (p.appTop.mapMatrix M) ≫ Q.inv`.
Reduces, on each one-element biproduct component, to the scalar atom `scalarEnd_pullback`.
Project-local. -/
lemma matrixEnd_pullback {T S : Scheme.{0}} (p : T ⟶ S) {d : ℕ}
    (M : Matrix (Fin d) (Fin d) Γ(S, ⊤)) :
    (Scheme.Modules.pullback p).map (matrixEnd M)
      = (Scheme.Modules.pullbackFreeIso p (Fin d)).hom ≫
        matrixEnd ((CommRingCat.Hom.hom (Scheme.Hom.appTop p)).mapMatrix M) ≫
        (Scheme.Modules.pullbackFreeIso p (Fin d)).inv := by
  haveI := Scheme.Modules.opensMap_final p
  -- Reduce to the naturality square (cancel the trailing `Q.inv`).
  rw [← Category.assoc, Iso.eq_comp_inv]
  -- Check the two maps out of the coproduct `(pullback p).obj (free (Fin d))` agree on each
  -- free injection `(pullback p).map (ιFree i)` (the cofan of the preserved colimit).
  refine Cofan.IsColimit.hom_ext
    (isColimitCofanMkObjOfIsColimit (Scheme.Modules.pullback p) _ _
      (SheafOfModules.isColimitFreeCofan (Fin d))) _ _ (fun i => ?_)
  simp only [cofan_mk_inj, Cofan.mk_pt]
  -- `Q.hom` is, by construction of `pullbackFreeIso`, the Mathlib free-pullback comparison.
  have hQhom : (Scheme.Modules.pullbackFreeIso p (Fin d)).hom
      = (SheafOfModules.pullbackObjFreeIso (Scheme.Hom.toRingCatSheafHom p) (Fin d)).hom := rfl
  -- The free injection cancels against `Q.hom` into the unit-pullback comparison
  -- (`pullbackObjUnitToUnit`), which is where `scalarEnd_pullback` lives.
  have key : ∀ k : Fin d,
      (Scheme.Modules.pullback p).map (SheafOfModules.ιFree k)
          ≫ (Scheme.Modules.pullbackFreeIso p (Fin d)).hom
        = SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom p)
            ≫ SheafOfModules.ιFree k := by
    intro k
    rw [hQhom]
    exact SheafOfModules.pullback_map_ιFree_comp_pullbackObjFreeIso_hom _ k
  -- LHS: `map (ιFree i) ≫ map (matrixEnd M)` collapses to `map (ιFree i ≫ matrixEnd M)`,
  -- then `ιFree_matrixEnd` turns it into a row sum, distributed by additivity of the pullback.
  rw [← Category.assoc ((Scheme.Modules.pullback p).map (SheafOfModules.ιFree i))
        ((Scheme.Modules.pullback p).map (matrixEnd M)),
    ← Functor.map_comp]
  -- `erw` (defeq matching) is needed to see `ιFree i ≫ matrixEnd M` under `(pullback p).map`.
  erw [ιFree_matrixEnd M i]
  erw [Functor.map_sum]
  rw [Preadditive.sum_comp]
  -- RHS: cancel `map (ιFree i) ≫ Q.hom` into `pullbackObjUnitToUnit ≫ ιFree i`, then expand.
  rw [← Category.assoc ((Scheme.Modules.pullback p).map (SheafOfModules.ιFree i))
        (Scheme.Modules.pullbackFreeIso p (Fin d)).hom,
    key i]
  erw [Category.assoc]
  erw [ιFree_matrixEnd ((CommRingCat.Hom.hom (Scheme.Hom.appTop p)).mapMatrix M) i]
  erw [Preadditive.comp_sum]
  -- Match term by term: each entry reduces to the scalar atom `scalarEnd_pullback`.
  refine Finset.sum_congr rfl (fun k _ => ?_)
  erw [Functor.map_comp]
  rw [Category.assoc, key k]
  erw [reassoc_of% scalarEnd_pullback p (M k i)]
  erw [Category.assoc]

/-- The action of `matrixEndRect M` on the `j`-th free injection: `ιFree j ≫ matrixEndRect M`
expands as the sum over rows `∑ k, scalarEnd (M k j) ≫ ιFree k`. Project-local helper
for `matrixEndRect_pullback` (rectangular analogue of `ιFree_matrixEnd`). -/
lemma ιFree_matrixEndRect {S : Scheme.{0}} {d r : ℕ} (M : Matrix (Fin d) (Fin r) Γ(S, ⊤))
    (j : Fin r) :
    SheafOfModules.ιFree (R := S.ringCatSheaf) j ≫ matrixEndRect M
      = ∑ k, scalarEnd (M k j) ≫ SheafOfModules.ιFree (R := S.ringCatSheaf) k := by
  rw [matrixEndRect, SheafOfModules.ιFree]
  simp only [SheafOfModules.free]
  rw [Iso.symm_hom, biproduct.isoCoproduct_inv, biproduct.isoCoproduct_hom,
    ← Category.assoc, Sigma.ι_desc, biproduct.ι_matrix_assoc, biproduct.lift_desc]
  rfl

/-- **Rectangular matrix homomorphism naturality under pullback**
(`lem:gr_matrixEndRect_pullback`). For `p : T ⟶ S` and a `d × r` matrix `M` of global
sections, the pullback of `matrixEndRect M` is, after the free-pullback comparisons
`Q_r = pullbackFreeIso p (Fin r)` and `Q_d = pullbackFreeIso p (Fin d)`, the rectangular
homomorphism of the base-changed matrix `p^♯ M`:
`(pullback p).map (matrixEndRect M) = Q_r.hom ≫ matrixEndRect (p^♯ M) ≫ Q_d.inv`.
Identical skeleton to the square `matrixEnd_pullback`, reducing on each one-element
biproduct component to the scalar atom `scalarEnd_pullback`. Project-local. -/
lemma matrixEndRect_pullback {T S : Scheme.{0}} (p : T ⟶ S) {d r : ℕ}
    (M : Matrix (Fin d) (Fin r) Γ(S, ⊤)) :
    (Scheme.Modules.pullback p).map (matrixEndRect M)
      = (Scheme.Modules.pullbackFreeIso p (Fin r)).hom ≫
        matrixEndRect (M.map ⇑(CommRingCat.Hom.hom (Scheme.Hom.appTop p))) ≫
        (Scheme.Modules.pullbackFreeIso p (Fin d)).inv := by
  haveI := Scheme.Modules.opensMap_final p
  -- Reduce to the naturality square (cancel the trailing `Q_d.inv`).
  rw [← Category.assoc, Iso.eq_comp_inv]
  -- Check the two maps out of the coproduct `(pullback p).obj (free (Fin r))` agree on each
  -- free injection (the cofan of the preserved colimit).
  refine Cofan.IsColimit.hom_ext
    (isColimitCofanMkObjOfIsColimit (Scheme.Modules.pullback p) _ _
      (SheafOfModules.isColimitFreeCofan (Fin r))) _ _ (fun i => ?_)
  simp only [cofan_mk_inj, Cofan.mk_pt]
  -- the source/target free-pullback comparisons in their Mathlib form
  have hQr : (Scheme.Modules.pullbackFreeIso p (Fin r)).hom
      = (SheafOfModules.pullbackObjFreeIso (Scheme.Hom.toRingCatSheafHom p) (Fin r)).hom := rfl
  have hQd : (Scheme.Modules.pullbackFreeIso p (Fin d)).hom
      = (SheafOfModules.pullbackObjFreeIso (Scheme.Hom.toRingCatSheafHom p) (Fin d)).hom := rfl
  have key_r : ∀ k : Fin r,
      (Scheme.Modules.pullback p).map (SheafOfModules.ιFree k)
          ≫ (Scheme.Modules.pullbackFreeIso p (Fin r)).hom
        = SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom p)
            ≫ SheafOfModules.ιFree k := by
    intro k
    rw [hQr]
    exact SheafOfModules.pullback_map_ιFree_comp_pullbackObjFreeIso_hom _ k
  have key_d : ∀ k : Fin d,
      (Scheme.Modules.pullback p).map (SheafOfModules.ιFree k)
          ≫ (Scheme.Modules.pullbackFreeIso p (Fin d)).hom
        = SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom p)
            ≫ SheafOfModules.ιFree k := by
    intro k
    rw [hQd]
    exact SheafOfModules.pullback_map_ιFree_comp_pullbackObjFreeIso_hom _ k
  -- LHS: collapse to a row sum via `ιFree_matrixEndRect`, distributed by additivity.
  rw [← Category.assoc ((Scheme.Modules.pullback p).map (SheafOfModules.ιFree i))
        ((Scheme.Modules.pullback p).map (matrixEndRect M)),
    ← Functor.map_comp]
  erw [ιFree_matrixEndRect M i]
  erw [Functor.map_sum]
  rw [Preadditive.sum_comp]
  -- RHS: cancel `map (ιFree i) ≫ Q_r.hom` into `pullbackObjUnitToUnit ≫ ιFree i`, expand.
  rw [← Category.assoc ((Scheme.Modules.pullback p).map (SheafOfModules.ιFree i))
        (Scheme.Modules.pullbackFreeIso p (Fin r)).hom,
    key_r i]
  erw [Category.assoc]
  erw [ιFree_matrixEndRect (M.map ⇑(CommRingCat.Hom.hom (Scheme.Hom.appTop p))) i]
  erw [Preadditive.comp_sum]
  -- Match term by term: each entry reduces to the scalar atom `scalarEnd_pullback`.
  refine Finset.sum_congr rfl (fun k _ => ?_)
  erw [Functor.map_comp]
  rw [Category.assoc, key_d k]
  erw [reassoc_of% scalarEnd_pullback p (M k i)]
  erw [Category.assoc]

/-- The chart quotient is, definitionally, the rectangular matrix homomorphism of the
injected universal matrix: `u^I = matrixEndRect ((ΓSpecIso R^I).inv X^I)`. Project-local —
the bridge between `chartQuotientMap` and the `matrixEndRect` API. -/
lemma chartQuotientMap_eq_matrixEndRect (d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) :
    chartQuotientMap d r I hI
      = matrixEndRect ((universalMatrix d r I hI).map
          ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso
            (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))).inv)) := rfl

end AlgebraicGeometry.Grassmannian

namespace AlgebraicGeometry.Scheme.Modules

/-- **Unit coherence (`map_id` keystone, `lem:gr_pullbackObjUnitToUnit_id`).** The
Mathlib free-pullback comparison `SheafOfModules.pullbackObjUnitToUnit` at the identity
morphism agrees, on the unit sheaf, with the scheme-level pseudofunctor identity
`Scheme.Modules.pullbackId`. Project-local: bridges `pullbackObjFreeIso` to the
pseudofunctor `pullbackId`. -/
lemma pullbackObjUnitToUnit_id {T : Scheme.{u}} :
    SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom (𝟙 T))
      = (Scheme.Modules.pullbackId T).hom.app (SheafOfModules.unit T.ringCatSheaf) := by
  rw [← SheafOfModules.pullbackPushforwardAdjunction_homEquiv_symm_unitToPushforwardObjUnit,
    Equiv.symm_apply_eq, Adjunction.homEquiv_unit]
  have h := CategoryTheory.unit_conjugateEquiv Adjunction.id
    (SheafOfModules.pullbackPushforwardAdjunction (Scheme.Hom.toRingCatSheafHom (𝟙 T)))
    (Scheme.Modules.pullbackId T).hom (SheafOfModules.unit T.ringCatSheaf)
  simp only [Adjunction.id_unit, NatTrans.id_app, Functor.id_obj] at h
  rw [← h]
  -- term-mode `id_comp` (positional `rw [Category.id_comp]` hits the `T.Modules` instance diamond)
  refine Eq.trans ?_ (Category.id_comp _).symm
  -- the `conjugateEquiv` term sits in unfolded `SheafOfModules` form; bridge to the
  -- scheme-level pseudofunctor coherence by defeq, then it equals `(pushforwardId).inv`.
  have key : (CategoryTheory.conjugateEquiv Adjunction.id
        (SheafOfModules.pullbackPushforwardAdjunction (Scheme.Hom.toRingCatSheafHom (𝟙 T)))
        (Scheme.Modules.pullbackId T).hom)
      = (Scheme.Modules.pushforwardId T).inv :=
    Scheme.Modules.conjugateEquiv_pullbackId_hom T
  rw [key]
  ext Y
  -- both sides evaluate the unit section `1` through identity-like maps
  rfl

/-- **Free coherence (`map_id`).** `pullbackFreeIso (𝟙 T) I` agrees, on the free sheaf,
with the pseudofunctor identity `pullbackId`. Reduces to `pullbackObjUnitToUnit_id` by
coproduct extensionality (`free = ∐ unit`). Project-local. -/
lemma pullbackFreeIso_id {T : Scheme.{u}} (I : Type u) :
    (Scheme.Modules.pullbackFreeIso (𝟙 T) I).hom
      = (Scheme.Modules.pullbackId T).hom.app (SheafOfModules.free (R := T.ringCatSheaf) I) := by
  haveI := Scheme.Modules.opensMap_final (𝟙 T)
  -- Use the `SheafOfModules.pullback` form in the cofan: the `Scheme.Modules.pullback` wrapper
  -- triggers a universe-polymorphism trap in the `PreservesColimit` instance search
  -- (memory `gf-seam1-1b1c-done`); the two forms are defeq, bridged by the explicit-type `have`s.
  refine Cofan.IsColimit.hom_ext (isColimitCofanMkObjOfIsColimit
    (SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom (𝟙 T))) _ _
    (SheafOfModules.isColimitFreeCofan (R := T.ringCatSheaf) I)) _ _ (fun i => ?_)
  simp only [cofan_mk_inj]
  -- Pure term-mode chain (positional `rw`/`simp` fail under the `SheafOfModules`/`X.Modules`
  -- instance diamond — they cannot match identical-printing terms with different implicit
  -- instance arguments; `exact`/`Eq.trans` unify up to defeq, which is what is needed here).
  -- LHS: free-pullback comparison.  Then transport the unit coherence through `· ≫ ιFree i`,
  -- and finally undo by naturality of `pullbackId.hom` (RHS).
  exact (SheafOfModules.pullback_map_ιFree_comp_pullbackObjFreeIso_hom
        (Scheme.Hom.toRingCatSheafHom (𝟙 T)) i).trans
      ((congrArg (· ≫ SheafOfModules.ιFree (R := T.ringCatSheaf) i) pullbackObjUnitToUnit_id).trans
        ((Scheme.Modules.pullbackId T).hom.naturality
          (SheafOfModules.ιFree (R := T.ringCatSheaf) i)).symm)

/-- **Mate compatibility of `homEquiv`.** For adjunctions `adj₁ : L₁ ⊣ R₁`, `adj₂ : L₂ ⊣ R₂`
and a natural transformation `α : L₂ ⟶ L₁`, transposing `α.app c ≫ f` under `adj₂` equals
transposing `f` under `adj₁` post-composed with the conjugate transformation
(`CategoryTheory.conjugateEquiv adj₁ adj₂ α`) evaluated at `d`. Project-local; derived from
`CategoryTheory.unit_conjugateEquiv` + naturality of the conjugate transformation. -/
lemma homEquiv_conjugateEquiv_app {𝒞 𝒟 : Type*} [CategoryTheory.Category 𝒞]
    [CategoryTheory.Category 𝒟] {L₁ L₂ : 𝒞 ⥤ 𝒟} {R₁ R₂ : 𝒟 ⥤ 𝒞}
    (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂) (α : L₂ ⟶ L₁) {c : 𝒞} {d : 𝒟}
    (f : L₁.obj c ⟶ d) :
    adj₂.homEquiv c d (α.app c ≫ f)
      = adj₁.homEquiv c d f ≫ (CategoryTheory.conjugateEquiv adj₁ adj₂ α).app d := by
  -- `rw` is unreliable at locating these right-associated sub-composites, so we assemble the
  -- proof entirely from term-mode whiskering equalities and chain them with `.trans`.
  have h1 := CategoryTheory.unit_conjugateEquiv adj₁ adj₂ α c
  -- the two `homEquiv_unit` expansions, with all implicits fixed by the stated types.
  have huA : adj₂.homEquiv c d (α.app c ≫ f)
      = adj₂.unit.app c ≫ R₂.map (α.app c ≫ f) :=
    Adjunction.homEquiv_unit adj₂ c d (α.app c ≫ f)
  have huB : adj₁.homEquiv c d f = adj₁.unit.app c ≫ R₁.map f :=
    Adjunction.homEquiv_unit adj₁ c d f
  -- LHS transpose, in left-bracketed shape.
  have e1 : adj₂.homEquiv c d (α.app c ≫ f)
      = (adj₂.unit.app c ≫ R₂.map (α.app c)) ≫ R₂.map f :=
    huA.trans <| (CategoryTheory.whisker_eq (adj₂.unit.app c) (R₂.map_comp (α.app c) f)).trans
      (Category.assoc _ _ _).symm
  -- RHS transpose, in the same left-bracketed shape.
  have e2 : adj₁.homEquiv c d f ≫ (CategoryTheory.conjugateEquiv adj₁ adj₂ α).app d
      = (adj₁.unit.app c ≫ (CategoryTheory.conjugateEquiv adj₁ adj₂ α).app (L₁.obj c))
          ≫ R₂.map f :=
    (CategoryTheory.eq_whisker huB
        ((CategoryTheory.conjugateEquiv adj₁ adj₂ α).app d)).trans <|
      (Category.assoc _ _ _).trans <|
        (CategoryTheory.whisker_eq (adj₁.unit.app c)
          ((CategoryTheory.conjugateEquiv adj₁ adj₂ α).naturality f)).trans
          (Category.assoc _ _ _).symm
  exact e1.trans ((CategoryTheory.eq_whisker h1.symm (R₂.map f)).trans e2.symm)

/-- **Unit coherence (`map_comp` keystone, `lem:gr_pullbackObjUnitToUnit_comp`).** The composite
analogue of `pullbackObjUnitToUnit_id`: the Mathlib free-pullback comparison at a composite
morphism `b ∘ a` factors through the pseudofunctor composition `pullbackComp`. Project-local.

Transposing both sides under the composite pullback-pushforward adjunction: the LHS collapses
by `homEquiv_conjugateEquiv_app` to `uTPU (b ≫ a) ≫ (conjugate of pullbackComp.hom)`, the
conjugate is `(pushforwardComp).inv` via `conjugateEquiv_pullbackComp_inv` + `conjugateEquiv_comm`,
and the RHS collapses by `homEquiv` naturality to `uTPU a ≫ pushforward a (uTPU b)`;
both reduce to the unit-section identity (`pushforwardComp_inv_app_app = 𝟙`). -/
lemma pullbackObjUnitToUnit_comp {Tx Ty Tz : Scheme.{u}} (a : Ty ⟶ Tx) (b : Tz ⟶ Ty) :
    (Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.unit Tx.ringCatSheaf) ≫
        SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom (b ≫ a))
      = (Scheme.Modules.pullback b).map
          (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫
        SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom b) := by
  -- Work with the Scheme-level adjunctions so `conjugateEquiv_pullbackComp_inv` lines up.
  apply ((Scheme.Modules.pullbackPushforwardAdjunction a).comp
      (Scheme.Modules.pullbackPushforwardAdjunction b)).homEquiv _ _ |>.injective
  -- abbreviations
  set adjA := Scheme.Modules.pullbackPushforwardAdjunction a
  set adjB := Scheme.Modules.pullbackPushforwardAdjunction b
  set adjBA := Scheme.Modules.pullbackPushforwardAdjunction (b ≫ a)
  -- LHS: collapse via the mate-compatibility helper (term-mode `.trans`, so `pullbackComp`
  -- stays OPAQUE and matching is up to defeq rather than syntactic `rw`).
  have hL := homEquiv_conjugateEquiv_app adjBA (adjA.comp adjB)
      (Scheme.Modules.pullbackComp b a).hom
      (f := SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom (b ≫ a)))
  -- transpose of `pullbackObjUnitToUnit` is `unitToPushforwardObjUnit` (used via defeq).
  have hL2 : adjBA.homEquiv _ _
        (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom (b ≫ a)))
      = SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom (b ≫ a)) :=
    SheafOfModules.pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit
      (Scheme.Hom.toRingCatSheafHom (b ≫ a))
  have huA : adjA.homEquiv _ _
        (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a))
      = SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom a) :=
    SheafOfModules.pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit
      (Scheme.Hom.toRingCatSheafHom a)
  have huB : adjB.homEquiv _ _
        (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom b))
      = SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom b) :=
    SheafOfModules.pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit
      (Scheme.Hom.toRingCatSheafHom b)
  -- the conjugate of `pullbackComp.hom` is `(pushforwardComp).inv`.
  have hcomm := CategoryTheory.conjugateEquiv_comm (adj₁ := adjA.comp adjB) (adj₂ := adjBA)
    (show (Scheme.Modules.pullbackComp b a).hom ≫ (Scheme.Modules.pullbackComp b a).inv = 𝟙 _
      from (Scheme.Modules.pullbackComp b a).hom_inv_id)
  rw [Scheme.Modules.conjugateEquiv_pullbackComp_inv] at hcomm
  have hConj : CategoryTheory.conjugateEquiv adjBA (adjA.comp adjB)
        (Scheme.Modules.pullbackComp b a).hom
      = (Scheme.Modules.pushforwardComp b a).inv :=
    (CategoryTheory.Iso.hom_comp_eq_id _).mp hcomm
  -- RHS computation, term-mode (so the Scheme/SheafOfModules `pullback` defeq is bridged).
  have hR : (adjA.comp adjB).homEquiv _ _
        ((Scheme.Modules.pullback b).map
          (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫
          SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom b))
      = SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom a) ≫
        (Scheme.Modules.pushforward a).map
          (SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom b)) := by
    rw [Adjunction.comp_homEquiv]
    change adjA.homEquiv _ _ (adjB.homEquiv _ _ (_ ≫ _)) = _
    rw [Adjunction.homEquiv_naturality_left, huB, Adjunction.homEquiv_naturality_right, huA]
    rfl
  -- the section-level identity: `(pushforwardComp).inv.app` is the identity on sections.
  have hMid : SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom (b ≫ a)) ≫
        (Scheme.Modules.pushforwardComp b a).inv.app (SheafOfModules.unit Tz.ringCatSheaf)
      = SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom a) ≫
        (Scheme.Modules.pushforward a).map
          (SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom b)) := by
    -- definitional: `unitToPushforwardObjUnit` sections are `φ.hom.app`,
    -- `pushforwardComp_inv_app_app = 𝟙`, and `(b ≫ a)⁻¹ U = b⁻¹(a⁻¹ U)`.
    rfl
  -- assemble in steps to avoid a single large `isDefEq` over the opaque `pullbackComp`.
  have e1 := hL.trans (congrArg
    (· ≫ (CategoryTheory.conjugateEquiv adjBA (adjA.comp adjB)
            (Scheme.Modules.pullbackComp b a).hom).app (SheafOfModules.unit Tz.ringCatSheaf)) hL2)
  have e2 := congrArg
    (SheafOfModules.unitToPushforwardObjUnit (Scheme.Hom.toRingCatSheafHom (b ≫ a)) ≫
      NatTrans.app · (SheafOfModules.unit Tz.ringCatSheaf)) hConj
  exact e1.trans (e2.trans (hMid.trans hR.symm))

/-- **Free coherence (`map_comp`).** Composite analogue of `pullbackFreeIso_id`: the
free-pullback isomorphism at a composite `b ∘ a` factors through the pseudofunctor composition
`pullbackComp`. Reduces, by coproduct extensionality (`free = ∐ unit`), to the unit coherence
`pullbackObjUnitToUnit_comp`. Project-local. -/
lemma pullbackFreeIso_comp {Tx Ty Tz : Scheme.{u}} (a : Ty ⟶ Tx) (b : Tz ⟶ Ty) (I : Type u) :
    (Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.free (R := Tx.ringCatSheaf) I) ≫
        (pullbackFreeIso (b ≫ a) I).hom
      = (Scheme.Modules.pullback b).map (pullbackFreeIso a I).hom ≫
        (pullbackFreeIso b I).hom := by
  haveI := opensMap_final (b ≫ a)
  haveI := opensMap_final a
  haveI := opensMap_final b
  refine Cofan.IsColimit.hom_ext (isColimitCofanMkObjOfIsColimit
    (SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom a) ⋙
      SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom b)) _ _
    (SheafOfModules.isColimitFreeCofan (R := Tx.ringCatSheaf) I)) _ _ (fun i => ?_)
  simp only [cofan_mk_inj]
  -- Pure term-mode (positional `rw`/`simp` fail under the `SheafOfModules`/`X.Modules` diamond).
  -- Both injections reduce, via `pullbackComp.hom` naturality and the free-cofan comparison
  -- `pullback_map_ιFree_comp_pullbackObjFreeIso_hom`, to `pullbackObjUnitToUnit_comp` whiskered.
  -- the free-cofan comparison, restated in `pullbackFreeIso` form (defeq) so `congrArg` matches.
  -- each pullback changes the base ring sheaf: `Tx ↝ Ty ↝ Tz`.
  have key_ba : (Scheme.Modules.pullback (b ≫ a)).map
          (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i) ≫
        (pullbackFreeIso (b ≫ a) I).hom
      = SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom (b ≫ a)) ≫
        SheafOfModules.ιFree (R := Tz.ringCatSheaf) i :=
    SheafOfModules.pullback_map_ιFree_comp_pullbackObjFreeIso_hom
      (Scheme.Hom.toRingCatSheafHom (b ≫ a)) (I := I) i
  have key_a : (Scheme.Modules.pullback a).map (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i) ≫
        (pullbackFreeIso a I).hom
      = SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a) ≫
        SheafOfModules.ιFree (R := Ty.ringCatSheaf) i :=
    SheafOfModules.pullback_map_ιFree_comp_pullbackObjFreeIso_hom
      (Scheme.Hom.toRingCatSheafHom a) (I := I) i
  have key_b : (Scheme.Modules.pullback b).map (SheafOfModules.ιFree (R := Ty.ringCatSheaf) i) ≫
        (pullbackFreeIso b I).hom
      = SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom b) ≫
        SheafOfModules.ιFree (R := Tz.ringCatSheaf) i :=
    SheafOfModules.pullback_map_ιFree_comp_pullbackObjFreeIso_hom
      (Scheme.Hom.toRingCatSheafHom b) (I := I) i
  -- LHS: naturality of `pullbackComp.hom` + free-cofan comparison at `b ≫ a`.
  have hLHS :
      (SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom a) ⋙
          SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom b)).map
            (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i) ≫
        (Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.free (R := Tx.ringCatSheaf) I) ≫
          (pullbackFreeIso (b ≫ a) I).hom
      = ((Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.unit Tx.ringCatSheaf) ≫
          SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom (b ≫ a))) ≫
            (SheafOfModules.ιFree (R := Tz.ringCatSheaf) i) :=
    calc (SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom a) ⋙
            SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom b)).map
            (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i) ≫
          (Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.free (R := Tx.ringCatSheaf) I) ≫
            (pullbackFreeIso (b ≫ a) I).hom
        = ((SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom a) ⋙
              SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom b)).map
              (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i) ≫
            (Scheme.Modules.pullbackComp b a).hom.app
              (SheafOfModules.free (R := Tx.ringCatSheaf) I)) ≫
            (pullbackFreeIso (b ≫ a) I).hom := (Category.assoc _ _ _).symm
      _ = ((Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.unit Tx.ringCatSheaf) ≫
            (Scheme.Modules.pullback (b ≫ a)).map (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i)) ≫
            (pullbackFreeIso (b ≫ a) I).hom :=
          congrArg (· ≫ (pullbackFreeIso (b ≫ a) I).hom)
            ((Scheme.Modules.pullbackComp b a).hom.naturality
              (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i))
      _ = (Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.unit Tx.ringCatSheaf) ≫
            (Scheme.Modules.pullback (b ≫ a)).map (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i) ≫
              (pullbackFreeIso (b ≫ a) I).hom := Category.assoc _ _ _
      _ = (Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.unit Tx.ringCatSheaf) ≫
            SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom (b ≫ a)) ≫
              (SheafOfModules.ιFree (R := Tz.ringCatSheaf) i) :=
          congrArg ((Scheme.Modules.pullbackComp b a).hom.app
            (SheafOfModules.unit Tx.ringCatSheaf) ≫ ·) key_ba
      _ = ((Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.unit Tx.ringCatSheaf) ≫
            SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom (b ≫ a))) ≫
              (SheafOfModules.ιFree (R := Tz.ringCatSheaf) i) := (Category.assoc _ _ _).symm
  -- RHS: split the composite functor, free-cofan comparison at `a` then at `b`.
  have hmid :
      (SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom a) ⋙
          SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom b)).map
            (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i) ≫
        (Scheme.Modules.pullback b).map (pullbackFreeIso a I).hom
      = (Scheme.Modules.pullback b).map
            (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫
          (Scheme.Modules.pullback b).map (SheafOfModules.ιFree (R := Ty.ringCatSheaf) i) :=
    ((Scheme.Modules.pullback b).map_comp
        ((Scheme.Modules.pullback a).map (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i))
        (pullbackFreeIso a I).hom).symm.trans
      ((congrArg (Scheme.Modules.pullback b).map key_a).trans
        ((Scheme.Modules.pullback b).map_comp
          (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a))
          (SheafOfModules.ιFree (R := Ty.ringCatSheaf) i)))
  have hRHS :
      (SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom a) ⋙
          SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom b)).map
            (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i) ≫
        (Scheme.Modules.pullback b).map (pullbackFreeIso a I).hom ≫ (pullbackFreeIso b I).hom
      = ((Scheme.Modules.pullback b).map
            (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫
          SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom b)) ≫
            (SheafOfModules.ιFree (R := Tz.ringCatSheaf) i) :=
    calc (SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom a) ⋙
            SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom b)).map
            (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i) ≫
          (Scheme.Modules.pullback b).map (pullbackFreeIso a I).hom ≫ (pullbackFreeIso b I).hom
        = ((SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom a) ⋙
              SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom b)).map
              (SheafOfModules.ιFree (R := Tx.ringCatSheaf) i) ≫
            (Scheme.Modules.pullback b).map (pullbackFreeIso a I).hom) ≫
            (pullbackFreeIso b I).hom := (Category.assoc _ _ _).symm
      _ = ((Scheme.Modules.pullback b).map
              (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫
            (Scheme.Modules.pullback b).map (SheafOfModules.ιFree (R := Ty.ringCatSheaf) i)) ≫
            (pullbackFreeIso b I).hom := congrArg (· ≫ (pullbackFreeIso b I).hom) hmid
      _ = (Scheme.Modules.pullback b).map
              (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫
            (Scheme.Modules.pullback b).map (SheafOfModules.ιFree (R := Ty.ringCatSheaf) i) ≫
              (pullbackFreeIso b I).hom := Category.assoc _ _ _
      _ = (Scheme.Modules.pullback b).map
              (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫
            SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom b) ≫
              (SheafOfModules.ιFree (R := Tz.ringCatSheaf) i) :=
          congrArg ((Scheme.Modules.pullback b).map
            (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫ ·) key_b
      _ = ((Scheme.Modules.pullback b).map
              (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫
            SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom b)) ≫
              (SheafOfModules.ιFree (R := Tz.ringCatSheaf) i) := (Category.assoc _ _ _).symm
  exact hLHS.trans ((congrArg (· ≫ (SheafOfModules.ιFree (R := Tz.ringCatSheaf) i))
    (pullbackObjUnitToUnit_comp a b)).trans hRHS.symm)

/-! ### Cast-collapse of `pullbackCongr` against the free-pullback comparisons

The three transports of the bundle cocycle are interleaved with `pullbackCongr` casts
(the `glueData_bridge_*` endpoint alignments). The next three lemmas collapse those casts
against the free-pullback comparisons `pullbackFreeIso`. Each is generic in the (equal)
base morphisms and proved by `subst`, so applying them never forces the kernel to whnf a
concrete immersion (the `pullbackFreeIso_trans_symm_eqToIso` discipline). -/

/-- Closed zig-zag: `Q_φ⁻¹ ≫ pullbackCongr(h).app ≫ Q_ψ = 𝟙` for equal base morphisms
`φ = ψ`. Project-local helper for the C2 endpoint alignment. -/
@[reassoc]
lemma pullbackFreeIso_inv_congr_hom {T' T : Scheme.{u}} {φ ψ : T' ⟶ T} (h : φ = ψ)
    (I : Type u) :
    (pullbackFreeIso φ I).inv ≫
        ((Scheme.Modules.pullbackCongr h).app
          (SheafOfModules.free (R := T.ringCatSheaf) I)).hom ≫
        (pullbackFreeIso ψ I).hom
      = 𝟙 _ := by
  subst h
  simp [Scheme.Modules.pullbackCongr]

/-- Left absorption: `pullbackCongr(h).app ≫ Q_ψ = Q_φ` for equal base morphisms `φ = ψ`.
Project-local helper for the C2 endpoint alignment (source bridge). -/
@[reassoc]
lemma pullbackCongr_hom_app_free {T' T : Scheme.{u}} {φ ψ : T' ⟶ T} (h : φ = ψ)
    (I : Type u) :
    ((Scheme.Modules.pullbackCongr h).app
        (SheafOfModules.free (R := T.ringCatSheaf) I)).hom ≫
        (pullbackFreeIso ψ I).hom
      = (pullbackFreeIso φ I).hom := by
  subst h
  simp [Scheme.Modules.pullbackCongr]

/-- Right absorption: `Q_φ⁻¹ ≫ pullbackCongr(h).app = Q_ψ⁻¹` for equal base morphisms
`φ = ψ`. Project-local helper for the C2 endpoint alignment (target bridge). -/
@[reassoc]
lemma pullbackFreeIso_inv_congr {T' T : Scheme.{u}} {φ ψ : T' ⟶ T} (h : φ = ψ)
    (I : Type u) :
    (pullbackFreeIso φ I).inv ≫
        ((Scheme.Modules.pullbackCongr h).app
          (SheafOfModules.free (R := T.ringCatSheaf) I)).hom
      = (pullbackFreeIso ψ I).inv := by
  subst h
  simp [Scheme.Modules.pullbackCongr]

/-- Inverse-side absorption of the congruence cast against the free-pullback comparison:
`pullbackCongr(h).inv.app ≫ Q_φ = Q_ψ` for equal base morphisms `φ = ψ`. Generic-`subst`
companion of `pullbackCongr_hom_app_free`. Project-local helper for the tautological
quotient overlap. -/
@[reassoc]
lemma pullbackCongr_inv_app_free {T' T : Scheme.{u}} {φ ψ : T' ⟶ T} (h : φ = ψ)
    (I : Type u) :
    (Scheme.Modules.pullbackCongr h).inv.app
        (SheafOfModules.free (R := T.ringCatSheaf) I) ≫
        (pullbackFreeIso φ I).hom
      = (pullbackFreeIso ψ I).hom := by
  subst h
  simp [Scheme.Modules.pullbackCongr]

/-- Cancellation of the pseudofunctor-composition cast against the pulled-back source
comparison: `(pullbackComp b a).inv.app (free) ≫ (pullback b).map Q_a = Q_{b≫a} ≫ Q_b⁻¹`.
Direct consequence of the free coherence `pullbackFreeIso_comp`. Project-local helper for
the tautological quotient overlap. -/
@[reassoc]
lemma pullbackComp_inv_app_free_map {V U X : Scheme.{u}} (b : V ⟶ U) (a : U ⟶ X)
    (I : Type u) :
    (Scheme.Modules.pullbackComp b a).inv.app
        (SheafOfModules.free (R := X.ringCatSheaf) I) ≫
        (Scheme.Modules.pullback b).map (pullbackFreeIso a I).hom
      = (pullbackFreeIso (b ≫ a) I).hom ≫ (pullbackFreeIso b I).inv := by
  rw [Iso.eq_comp_inv, Category.assoc]
  -- `erw` (defeq matching) to fire the free coherence through the `X.Modules` diamond
  erw [← pullbackFreeIso_comp a b I]
  exact Iso.inv_hom_id_app_assoc (Scheme.Modules.pullbackComp b a) _ _

/-! ### Adjunction transposition of the descent-equalizer legs

The overlap condition consumed by `glueLift` is an equation between composites of adjoint
transposes along the chart immersions. The next two lemmas transpose each leg back across
the pullback–pushforward adjunction of the *composite* overlap immersion, exposing the
pullback-level identity `g_{ij} ∘ f_ij^* u^i = (t_ij ≫ f_ji)^* u^j` that the matrix
computation closes. The first handles the unit/`pushforwardComp` factor pair, the second
the trailing `pushforwardCongr` reindexing cast. -/

/-- **Leg transpose** (`lem:gr_tautologicalQuotientComponent_transpose` engine): for
`b : V ⟶ U`, `a : U ⟶ X` and `c : a^* W ⟶ M`, the descent-equalizer leg
`homEquiv_a(c) ≫ (a_* unit_b) ≫ pushforwardComp` is the transpose along the composite
`b ≫ a` of the pullback of `c` to `V` (through the pseudofunctor comparison
`pullbackComp`). Combines `homEquiv_conjugateEquiv_app` with Mathlib's
`conjugateEquiv_pullbackComp_inv`. Project-local. -/
lemma homEquiv_comp_unit_pushforwardComp {V U X : Scheme.{u}} (b : V ⟶ U) (a : U ⟶ X)
    {W : X.Modules} {M : U.Modules} (c : (Scheme.Modules.pullback a).obj W ⟶ M) :
    (Scheme.Modules.pullbackPushforwardAdjunction a).homEquiv W M c ≫
        ((Scheme.Modules.pushforward a).map
          ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.app M) ≫
        (Scheme.Modules.pushforwardComp b a).hom.app ((Scheme.Modules.pullback b).obj M))
      = (Scheme.Modules.pullbackPushforwardAdjunction (b ≫ a)).homEquiv W
          ((Scheme.Modules.pullback b).obj M)
          ((Scheme.Modules.pullbackComp b a).inv.app W ≫ (Scheme.Modules.pullback b).map c) := by
  -- inner transpose: `c ≫ unit_b` is the `b`-transpose of `(pullback b).map c`
  have h2 : (Scheme.Modules.pullbackPushforwardAdjunction b).homEquiv
        ((Scheme.Modules.pullback a).obj W) ((Scheme.Modules.pullback b).obj M)
        ((Scheme.Modules.pullback b).map c)
      = c ≫ (Scheme.Modules.pullbackPushforwardAdjunction b).unit.app M := by
    rw [Adjunction.homEquiv_unit]
    exact ((Scheme.Modules.pullbackPushforwardAdjunction b).unit.naturality c).symm
  -- composite-adjunction transpose factors through the two single transposes
  have h3 : ((Scheme.Modules.pullbackPushforwardAdjunction a).comp
        (Scheme.Modules.pullbackPushforwardAdjunction b)).homEquiv W
        ((Scheme.Modules.pullback b).obj M) ((Scheme.Modules.pullback b).map c)
      = (Scheme.Modules.pullbackPushforwardAdjunction a).homEquiv _ _
          ((Scheme.Modules.pullbackPushforwardAdjunction b).homEquiv _ _
            ((Scheme.Modules.pullback b).map c)) := by
    rw [Adjunction.comp_homEquiv]
    rfl
  -- mate compatibility: precomposing with `pullbackComp.inv` is postcomposition by the
  -- conjugate, which Mathlib identifies as `pushforwardComp.hom`
  have h4 := homEquiv_conjugateEquiv_app
      ((Scheme.Modules.pullbackPushforwardAdjunction a).comp
        (Scheme.Modules.pullbackPushforwardAdjunction b))
      (Scheme.Modules.pullbackPushforwardAdjunction (b ≫ a))
      (Scheme.Modules.pullbackComp b a).inv
      (f := (Scheme.Modules.pullback b).map c)
  rw [Scheme.Modules.conjugateEquiv_pullbackComp_inv] at h4
  rw [h4, h3, h2]
  -- regroup and fold the unit factor back into the transpose (term-mode: a positional
  -- `rw [homEquiv_naturality_right]` matches inside the wrong `homEquiv` argument)
  exact (Category.assoc _ _ _).symm.trans
    (congrArg (· ≫ (Scheme.Modules.pushforwardComp b a).hom.app
        ((Scheme.Modules.pullback b).obj M))
      (Adjunction.homEquiv_naturality_right _ _ _).symm)

/-- **Congruence-cast transpose**: postcomposing a transpose along `e` with the
`pushforwardCongr` cast of an equality `e = e'` is the transpose along `e'` of the
`pullbackCongr`-reindexed morphism. Generic `subst` lemma. Project-local. -/
lemma homEquiv_comp_pushforwardCongr {V X : Scheme.{u}} {e e' : V ⟶ X} (h : e = e')
    {W : X.Modules} {N : V.Modules} (y : (Scheme.Modules.pullback e).obj W ⟶ N) :
    (Scheme.Modules.pullbackPushforwardAdjunction e).homEquiv W N y ≫
        (Scheme.Modules.pushforwardCongr h).hom.app N
      = (Scheme.Modules.pullbackPushforwardAdjunction e').homEquiv W N
          ((Scheme.Modules.pullbackCongr h).inv.app W ≫ y) := by
  subst h
  have h1 : (Scheme.Modules.pushforwardCongr (rfl : e = e)).hom.app N = 𝟙 _ := by
    ext U
    simp
  have h2 : (Scheme.Modules.pullbackCongr (rfl : e = e)).inv.app W = 𝟙 _ := by
    simp [Scheme.Modules.pullbackCongr]
  rw [h1, h2, Category.comp_id, Category.id_comp]

/-- **Transposed form of the `glueLift` overlap condition**: the `(i,j)`-component of the
equalizing hypothesis consumed by `glueLift` holds iff the pullback-level identity
`f_ij^* (c i) = congr ∘ (t_ij ≫ f_ji)^* (c j) ∘ g_ij⁻¹` does (all comparisons through the
pseudofunctor casts). Both legs are transposed along the composite overlap immersion via
`homEquiv_comp_unit_pushforwardComp` / `homEquiv_comp_pushforwardCongr`, and the
hom-equivalence is injective. Project-local. -/
lemma glueLift_cond_iff (D : Scheme.GlueData.{u})
    (M : ∀ i, (D.U i).Modules)
    (g : ∀ i j, (Scheme.Modules.pullback (D.f i j)).obj (M i) ≅
        (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j))
    {W : D.glued.Modules}
    (c : ∀ i, (Scheme.Modules.pullback (D.ι i)).obj W ⟶ M i) (i j : D.J) :
    ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).homEquiv W (M i) (c i) ≫
        ((Scheme.Modules.pushforward (D.ι i)).map
          ((Scheme.Modules.pullbackPushforwardAdjunction (D.f i j)).unit.app (M i)) ≫
        (Scheme.Modules.pushforwardComp (D.f i j) (D.ι i)).hom.app
          ((Scheme.Modules.pullback (D.f i j)).obj (M i)))
      = (Scheme.Modules.pullbackPushforwardAdjunction (D.ι j)).homEquiv W (M j) (c j) ≫
        ((Scheme.Modules.pushforward (D.ι j)).map
          ((Scheme.Modules.pullbackPushforwardAdjunction
            (D.t i j ≫ D.f j i)).unit.app (M j)) ≫
        (Scheme.Modules.pushforwardComp (D.t i j ≫ D.f j i) (D.ι j)).hom.app
          ((Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j)) ≫
        (Scheme.Modules.pushforward
          ((D.t i j ≫ D.f j i) ≫ D.ι j)).map (g i j).inv ≫
        (Scheme.Modules.pushforwardCongr
          (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
            rw [Category.assoc]; exact D.glue_condition i j)).hom.app
          ((Scheme.Modules.pullback (D.f i j)).obj (M i))))
    ↔ ((Scheme.Modules.pullbackComp (D.f i j) (D.ι i)).inv.app W ≫
          (Scheme.Modules.pullback (D.f i j)).map (c i)
      = (Scheme.Modules.pullbackCongr
            (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
              rw [Category.assoc]; exact D.glue_condition i j)).inv.app W ≫
          (Scheme.Modules.pullbackComp (D.t i j ≫ D.f j i) (D.ι j)).inv.app W ≫
          (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).map (c j) ≫ (g i j).inv) := by
  -- transpose the left leg
  rw [homEquiv_comp_unit_pushforwardComp (D.f i j) (D.ι i) (c i)]
  -- transpose the right leg: regroup, fire the leg transpose, absorb `(g i j).inv`
  -- into the transpose, then fire the congruence-cast transpose
  have hR : (Scheme.Modules.pullbackPushforwardAdjunction (D.ι j)).homEquiv W (M j) (c j) ≫
        ((Scheme.Modules.pushforward (D.ι j)).map
          ((Scheme.Modules.pullbackPushforwardAdjunction
            (D.t i j ≫ D.f j i)).unit.app (M j)) ≫
        (Scheme.Modules.pushforwardComp (D.t i j ≫ D.f j i) (D.ι j)).hom.app
          ((Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j)) ≫
        (Scheme.Modules.pushforward
          ((D.t i j ≫ D.f j i) ≫ D.ι j)).map (g i j).inv ≫
        (Scheme.Modules.pushforwardCongr
          (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
            rw [Category.assoc]; exact D.glue_condition i j)).hom.app
          ((Scheme.Modules.pullback (D.f i j)).obj (M i)))
      = (Scheme.Modules.pullbackPushforwardAdjunction (D.f i j ≫ D.ι i)).homEquiv W
          ((Scheme.Modules.pullback (D.f i j)).obj (M i))
          ((Scheme.Modules.pullbackCongr
              (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
                rw [Category.assoc]; exact D.glue_condition i j)).inv.app W ≫
            (((Scheme.Modules.pullbackComp (D.t i j ≫ D.f j i) (D.ι j)).inv.app W ≫
              (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).map (c j)) ≫ (g i j).inv)) := by
    calc (Scheme.Modules.pullbackPushforwardAdjunction (D.ι j)).homEquiv W (M j) (c j) ≫
          ((Scheme.Modules.pushforward (D.ι j)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction
              (D.t i j ≫ D.f j i)).unit.app (M j)) ≫
          (Scheme.Modules.pushforwardComp (D.t i j ≫ D.f j i) (D.ι j)).hom.app
            ((Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j)) ≫
          (Scheme.Modules.pushforward
            ((D.t i j ≫ D.f j i) ≫ D.ι j)).map (g i j).inv ≫
          (Scheme.Modules.pushforwardCongr
            (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
              rw [Category.assoc]; exact D.glue_condition i j)).hom.app
            ((Scheme.Modules.pullback (D.f i j)).obj (M i)))
        = (((Scheme.Modules.pullbackPushforwardAdjunction (D.ι j)).homEquiv W (M j) (c j) ≫
            ((Scheme.Modules.pushforward (D.ι j)).map
              ((Scheme.Modules.pullbackPushforwardAdjunction
                (D.t i j ≫ D.f j i)).unit.app (M j)) ≫
            (Scheme.Modules.pushforwardComp (D.t i j ≫ D.f j i) (D.ι j)).hom.app
              ((Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j)))) ≫
          (Scheme.Modules.pushforward
            ((D.t i j ≫ D.f j i) ≫ D.ι j)).map (g i j).inv) ≫
          (Scheme.Modules.pushforwardCongr
            (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
              rw [Category.assoc]; exact D.glue_condition i j)).hom.app
            ((Scheme.Modules.pullback (D.f i j)).obj (M i)) := by
          simp only [Category.assoc]
      _ = (((Scheme.Modules.pullbackPushforwardAdjunction
              ((D.t i j ≫ D.f j i) ≫ D.ι j)).homEquiv W
              ((Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j))
              ((Scheme.Modules.pullbackComp (D.t i j ≫ D.f j i) (D.ι j)).inv.app W ≫
                (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).map (c j))) ≫
            (Scheme.Modules.pushforward
              ((D.t i j ≫ D.f j i) ≫ D.ι j)).map (g i j).inv) ≫
          (Scheme.Modules.pushforwardCongr
            (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
              rw [Category.assoc]; exact D.glue_condition i j)).hom.app
            ((Scheme.Modules.pullback (D.f i j)).obj (M i)) :=
          congrArg (fun m => (m ≫ (Scheme.Modules.pushforward
              ((D.t i j ≫ D.f j i) ≫ D.ι j)).map (g i j).inv) ≫
            (Scheme.Modules.pushforwardCongr
              (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
                rw [Category.assoc]; exact D.glue_condition i j)).hom.app
              ((Scheme.Modules.pullback (D.f i j)).obj (M i)))
            (homEquiv_comp_unit_pushforwardComp (D.t i j ≫ D.f j i) (D.ι j) (c j))
      _ = ((Scheme.Modules.pullbackPushforwardAdjunction
              ((D.t i j ≫ D.f j i) ≫ D.ι j)).homEquiv W
              ((Scheme.Modules.pullback (D.f i j)).obj (M i))
              ((((Scheme.Modules.pullbackComp (D.t i j ≫ D.f j i) (D.ι j)).inv.app W ≫
                (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).map (c j))) ≫ (g i j).inv)) ≫
          (Scheme.Modules.pushforwardCongr
            (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
              rw [Category.assoc]; exact D.glue_condition i j)).hom.app
            ((Scheme.Modules.pullback (D.f i j)).obj (M i)) :=
          congrArg (· ≫ (Scheme.Modules.pushforwardCongr
              (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
                rw [Category.assoc]; exact D.glue_condition i j)).hom.app
              ((Scheme.Modules.pullback (D.f i j)).obj (M i)))
            (Adjunction.homEquiv_naturality_right _ _ _).symm
      _ = (Scheme.Modules.pullbackPushforwardAdjunction (D.f i j ≫ D.ι i)).homEquiv W
            ((Scheme.Modules.pullback (D.f i j)).obj (M i))
            ((Scheme.Modules.pullbackCongr
                (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
                  rw [Category.assoc]; exact D.glue_condition i j)).inv.app W ≫
              (((Scheme.Modules.pullbackComp (D.t i j ≫ D.f j i) (D.ι j)).inv.app W ≫
                (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).map (c j)) ≫ (g i j).inv)) :=
          homEquiv_comp_pushforwardCongr _ _
  rw [hR, Equiv.apply_eq_iff_eq]
  simp only [Category.assoc]

/-! ### Restriction of the glued sheaf to a chart (`def:gr_modules_glueRestrictionIso`)

The glued sheaf is the descent equalizer `eq(a, b) ⊆ ∏ᵢ (ιᵢ)_* Mᵢ`. This section
re-exposes the two legs of that equalizer as standalone declarations
(`glueLegA`/`glueLegB`), records that `glue` *is* their equalizer (`glueIsoEqualizer`,
definitional), and produces the canonical projection `glueProj i` of the glued sheaf
onto the `i`-th pushforward factor together with its compatibility with `glueLift`.
The adjoint transpose of `glueProj i` along the chart immersion `D.ι i` is the
*restriction morphism* `glueRestrictionHom i : ιᵢ^* (glue …) ⟶ M i`; effective descent
(consuming the cocycle hypotheses C1/C2) makes it an isomorphism — the restriction
isomorphism `glueRestrictionIso` of `def:gr_modules_glueRestrictionIso`. The
limit-preservation engine is `restrictFunctor`: pullback along an open immersion is
naturally isomorphic to a site-level pushforward, which is a right adjoint, hence
preserves the descent equalizer and the pushforward product. -/

/-- `restrictFunctor f` along an open immersion is a right adjoint: it is a site-level
pushforward of sheaves of modules, whose left adjoint (the site-level pullback) exists
by the presheaf-pullback + sheafification construction. Project-local instance. -/
instance restrictFunctor_isRightAdjoint {X Y : Scheme.{u}} (f : X ⟶ Y) [IsOpenImmersion f] :
    (restrictFunctor f).IsRightAdjoint := by
  delta restrictFunctor
  -- bare `infer_instance` fails on the outer search; the explicit presheaf-pullback +
  -- sheafification construction elaborates (its three instance hypotheses all resolve)
  exact (SheafOfModules.PullbackConstruction.adjunction _).isRightAdjoint

/-- `restrictFunctor f` along an open immersion preserves limits (it is a right
adjoint). Project-local. -/
noncomputable instance restrictFunctor_preservesLimits.{w, w'} {X Y : Scheme.{u}}
    (f : X ⟶ Y) [IsOpenImmersion f] :
    PreservesLimitsOfSize.{w, w'} (restrictFunctor f) :=
  (Adjunction.ofIsRightAdjoint (restrictFunctor f)).rightAdjoint_preservesLimits

/-- **Pullback of sheaves of modules along an open immersion preserves limits**: it is
naturally isomorphic to `restrictFunctor f`, a site-level pushforward and right
adjoint. This is the engine that lets the chart restriction commute with the descent
equalizer. Project-local. -/
instance pullback_preservesLimits_of_isOpenImmersion.{w, w'} {X Y : Scheme.{u}}
    (f : X ⟶ Y) [IsOpenImmersion f] :
    PreservesLimitsOfSize.{w, w'} (Scheme.Modules.pullback f) :=
  preservesLimits_of_natIso (restrictFunctorIsoPullback f)

section GlueRestriction

-- NOTE: `glue`/`glueLift` elaborated universe-monomorphic at `Scheme.GlueData.{0}`
-- (their universe was pinned during elaboration); the restriction layer follows suit.
variable (D : Scheme.GlueData.{0}) (M : ∀ i, (D.U i).Modules)

/-- The product of pushforwards `∏ᵢ (ιᵢ)_* Mᵢ` into which the glued sheaf embeds.
Project-local helper re-exposing the `P` of `glue`. -/
noncomputable def glueProd : D.glued.Modules :=
  ∏ᶜ fun i => (Scheme.Modules.pushforward (D.ι i)).obj (M i)

/-- The overlap product `∏_{(i,j)} (f_ij ≫ ιᵢ)_* (f_ij^* Mᵢ)` receiving the two descent
legs. Project-local helper re-exposing the `Qfun`-product of `glue`. -/
noncomputable def glueOverlapProd : D.glued.Modules :=
  ∏ᶜ fun p : D.J × D.J =>
    (Scheme.Modules.pushforward (D.f p.1 p.2 ≫ D.ι p.1)).obj
      ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1))

/-- First descent leg (`a` of `glue`): on the `(i,j)`-component, restrict the `i`-th
chart section to the overlap `V (i,j)` via the unit of the pullback–pushforward
adjunction along `f_ij` and the pushforward-composition comparison. Project-local. -/
noncomputable def glueLegA : glueProd D M ⟶ glueOverlapProd D M :=
  Pi.lift fun p => Pi.π _ p.1 ≫
    ((Scheme.Modules.pushforward (D.ι p.1)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction (D.f p.1 p.2)).unit.app (M p.1)) ≫
      (Scheme.Modules.pushforwardComp (D.f p.1 p.2) (D.ι p.1)).hom.app
        ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1)))

/-- Second descent leg (`b` of `glue`): on the `(i,j)`-component, restrict the `j`-th
chart section, transport it across the transition isomorphism `g_ij`, and reindex the
immersion via the glue condition. Project-local. -/
noncomputable def glueLegB
    (g : ∀ i j, (Scheme.Modules.pullback (D.f i j)).obj (M i) ≅
        (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j)) :
    glueProd D M ⟶ glueOverlapProd D M :=
  Pi.lift fun p => Pi.π _ p.2 ≫
    ((Scheme.Modules.pushforward (D.ι p.2)).map
        ((Scheme.Modules.pullbackPushforwardAdjunction
          (D.t p.1 p.2 ≫ D.f p.2 p.1)).unit.app (M p.2)) ≫
      (Scheme.Modules.pushforwardComp (D.t p.1 p.2 ≫ D.f p.2 p.1) (D.ι p.2)).hom.app
        ((Scheme.Modules.pullback (D.t p.1 p.2 ≫ D.f p.2 p.1)).obj (M p.2)) ≫
      (Scheme.Modules.pushforward
        ((D.t p.1 p.2 ≫ D.f p.2 p.1) ≫ D.ι p.2)).map (g p.1 p.2).inv ≫
      (Scheme.Modules.pushforwardCongr
        (show (D.t p.1 p.2 ≫ D.f p.2 p.1) ≫ D.ι p.2 = D.f p.1 p.2 ≫ D.ι p.1 by
          rw [Category.assoc]; exact D.glue_condition p.1 p.2)).hom.app
        ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1)))

variable (g : ∀ i j, (Scheme.Modules.pullback (D.f i j)).obj (M i) ≅
      (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j))
  (hC1 : ∀ i, g i i = eqToIso (congrArg (fun φ => (Scheme.Modules.pullback φ).obj (M i))
      (show D.f i i = D.t i i ≫ D.f i i by rw [D.t_id i, Category.id_comp])))
  (hC2 : ∀ i j k,
      pullbackBaseChangeTransport (pullback.fst (D.f i j) (D.f i k))
          (D.f i j) (D.t i j ≫ D.f j i) (g i j) ≪≫
        (Scheme.Modules.pullbackCongr (glueData_bridge_mid D i j k)).app (M j) ≪≫
        pullbackBaseChangeTransport (D.t' i j k ≫ pullback.fst (D.f j k) (D.f j i))
          (D.f j k) (D.t j k ≫ D.f k j) (g j k) ≪≫
        (Scheme.Modules.pullbackCongr (glueData_bridge_tgt D i j k)).app (M k)
      = (Scheme.Modules.pullbackCongr (glueData_bridge_src D i j k)).app (M i) ≪≫
        pullbackBaseChangeTransport (pullback.snd (D.f i j) (D.f i k))
          (D.f i k) (D.t i k ≫ D.f k i) (g i k))

/-- The glued sheaf *is* the equalizer of the two (re-exposed) descent legs. The
isomorphism is definitional (`Iso.refl`); it exists to let the equalizer API fire
syntactically on `glue`. Project-local. -/
noncomputable def glueIsoEqualizer :
    glue D M g hC1 hC2 ≅ equalizer (glueLegA D M) (glueLegB D M g) :=
  Iso.refl _

/-- Projection of the glued sheaf onto the `i`-th pushforward factor `(ιᵢ)_* Mᵢ`:
the equalizer inclusion followed by the product projection. Project-local. -/
noncomputable def glueProj (i : D.J) :
    glue D M g hC1 hC2 ⟶ (Scheme.Modules.pushforward (D.ι i)).obj (M i) :=
  (glueIsoEqualizer D M g hC1 hC2).hom ≫ equalizer.ι (glueLegA D M) (glueLegB D M g) ≫
    Pi.π _ i

/-- `glueLift` followed by the `i`-th projection recovers the `i`-th component of the
lifted family. Project-local. -/
@[reassoc]
lemma glueLift_glueProj {W : D.glued.Modules}
    (k : ∀ i, W ⟶ (Scheme.Modules.pushforward (D.ι i)).obj (M i))
    (hk : ∀ p : D.J × D.J,
      k p.1 ≫
          ((Scheme.Modules.pushforward (D.ι p.1)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction (D.f p.1 p.2)).unit.app (M p.1)) ≫
          (Scheme.Modules.pushforwardComp (D.f p.1 p.2) (D.ι p.1)).hom.app
            ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1)))
        = k p.2 ≫
          ((Scheme.Modules.pushforward (D.ι p.2)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction
              (D.t p.1 p.2 ≫ D.f p.2 p.1)).unit.app (M p.2)) ≫
          (Scheme.Modules.pushforwardComp (D.t p.1 p.2 ≫ D.f p.2 p.1) (D.ι p.2)).hom.app
            ((Scheme.Modules.pullback (D.t p.1 p.2 ≫ D.f p.2 p.1)).obj (M p.2)) ≫
          (Scheme.Modules.pushforward
            ((D.t p.1 p.2 ≫ D.f p.2 p.1) ≫ D.ι p.2)).map (g p.1 p.2).inv ≫
          (Scheme.Modules.pushforwardCongr
            (show (D.t p.1 p.2 ≫ D.f p.2 p.1) ≫ D.ι p.2 = D.f p.1 p.2 ≫ D.ι p.1 by
              rw [Category.assoc]; exact D.glue_condition p.1 p.2)).hom.app
            ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1)))) (i : D.J) :
    glueLift D M g hC1 hC2 k hk ≫ glueProj D M g hC1 hC2 i = k i := by
  dsimp only [glueLift, glueProj, glueIsoEqualizer, Iso.refl_hom]
  -- term-mode: the mixed-provenance comp nodes block positional `rw [Category.id_comp]`
  exact (congrArg (equalizer.lift (Pi.lift k) _ ≫ ·) (Category.id_comp _)).trans
    ((Category.assoc _ _ _).symm.trans
      ((congrArg (· ≫ Pi.π _ i) (equalizer.lift_ι _ _)).trans (Limits.Pi.lift_π _ _)))

/-- **The restriction morphism of the glued sheaf** to the `i`-th chart: the adjoint
transpose, along the chart immersion `ιᵢ`, of the `i`-th projection `glueProj i`.
Effective descent (`isIso_glueRestrictionHom`) makes it an isomorphism. Project-local. -/
noncomputable def glueRestrictionHom (i : D.J) :
    (Scheme.Modules.pullback (D.ι i)).obj (glue D M g hC1 hC2) ⟶ M i :=
  ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).homEquiv _ _).symm
    (glueProj D M g hC1 hC2 i)

/-- **The chart restriction of the glued sheaf is the equalizer of the restricted
descent legs**: the chart pullback preserves the descent equalizer
(`pullback_preservesLimits_of_isOpenImmersion`). First reduction step of
`isIso_glueRestrictionHom`. Project-local. -/
noncomputable def glueRestrictEqualizerIso (i : D.J) :
    (Scheme.Modules.pullback (D.ι i)).obj (glue D M g hC1 hC2)
      ≅ equalizer ((Scheme.Modules.pullback (D.ι i)).map (glueLegA D M))
          ((Scheme.Modules.pullback (D.ι i)).map (glueLegB D M g)) :=
  (Scheme.Modules.pullback (D.ι i)).mapIso (glueIsoEqualizer D M g hC1 hC2) ≪≫
    PreservesEqualizer.iso (Scheme.Modules.pullback (D.ι i)) _ _

/-- **The chart restriction of the pushforward product is the product of the
restrictions**: the chart pullback preserves the product
(`pullback_preservesLimits_of_isOpenImmersion`). Second reduction step of
`isIso_glueRestrictionHom`: the factors `ι_i^* ((ι_j)_* M_j)` are then identified with
`(f_ij)_* ((t_ij ≫ f_ji)^* M_j)` by the overlap base change of the cartesian chart
square (`glueData_preimage_image_eq`). Project-local. -/
noncomputable def glueRestrictProdIso (i : D.J) :
    (Scheme.Modules.pullback (D.ι i)).obj (glueProd D M)
      ≅ ∏ᶜ fun j => (Scheme.Modules.pullback (D.ι i)).obj
          ((Scheme.Modules.pushforward (D.ι j)).obj (M j)) :=
  PreservesProduct.iso (Scheme.Modules.pullback (D.ι i)) _

/-- **Chart restriction of a lifted morphism**: pulling a `glueLift` back to the `i`-th
chart and composing with the restriction morphism recovers the adjoint transpose of the
`i`-th component of the lifted family. This is `glueLift_glueProj` transposed along the
chart immersion; it is what identifies `ι_I^* (tautologicalQuotient)` with the chart
quotient downstream. Project-local. -/
lemma pullback_map_glueLift_glueRestrictionHom {W : D.glued.Modules}
    (k : ∀ i, W ⟶ (Scheme.Modules.pushforward (D.ι i)).obj (M i))
    (hk : ∀ p : D.J × D.J,
      k p.1 ≫
          ((Scheme.Modules.pushforward (D.ι p.1)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction (D.f p.1 p.2)).unit.app (M p.1)) ≫
          (Scheme.Modules.pushforwardComp (D.f p.1 p.2) (D.ι p.1)).hom.app
            ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1)))
        = k p.2 ≫
          ((Scheme.Modules.pushforward (D.ι p.2)).map
            ((Scheme.Modules.pullbackPushforwardAdjunction
              (D.t p.1 p.2 ≫ D.f p.2 p.1)).unit.app (M p.2)) ≫
          (Scheme.Modules.pushforwardComp (D.t p.1 p.2 ≫ D.f p.2 p.1) (D.ι p.2)).hom.app
            ((Scheme.Modules.pullback (D.t p.1 p.2 ≫ D.f p.2 p.1)).obj (M p.2)) ≫
          (Scheme.Modules.pushforward
            ((D.t p.1 p.2 ≫ D.f p.2 p.1) ≫ D.ι p.2)).map (g p.1 p.2).inv ≫
          (Scheme.Modules.pushforwardCongr
            (show (D.t p.1 p.2 ≫ D.f p.2 p.1) ≫ D.ι p.2 = D.f p.1 p.2 ≫ D.ι p.1 by
              rw [Category.assoc]; exact D.glue_condition p.1 p.2)).hom.app
            ((Scheme.Modules.pullback (D.f p.1 p.2)).obj (M p.1)))) (i : D.J) :
    (Scheme.Modules.pullback (D.ι i)).map (glueLift D M g hC1 hC2 k hk) ≫
        glueRestrictionHom D M g hC1 hC2 i
      = ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).homEquiv _ _).symm (k i) := by
  rw [glueRestrictionHom, ← Adjunction.homEquiv_naturality_left_symm,
    glueLift_glueProj]

end GlueRestriction

/-- **Overlap-square opens identity**: for an open `V` of the `i`-th chart of a scheme
glue datum, the preimage under `ι_j` of its image in the glued scheme coincides with
the image, under the `j`-side overlap immersion `t_ij ≫ f_ji`, of its preimage under
`f_ij`. This is the underlying-opens form of the cartesianness of the chart-overlap
square (`vPullbackCone`); it is the site-level input identifying the two composite
restriction functors of the overlap square. Project-local. -/
lemma glueData_preimage_image_eq (D : Scheme.GlueData.{0}) (i j : D.J)
    (V : (D.U i).Opens) :
    (D.ι j) ⁻¹ᵁ ((D.ι i) ''ᵁ V) = (D.t i j ≫ D.f j i) ''ᵁ ((D.f i j) ⁻¹ᵁ V) := by
  ext x
  constructor
  · intro hx
    -- a point of `U_j` mapping into `ι_i(V)` comes from the overlap via the glue relation
    obtain ⟨y, hyV, hyx⟩ := hx
    obtain ⟨w, hw1, hw2⟩ := (D.ι_eq_iff i j y x).mp hyx
    exact ⟨w, show (D.f i j) w ∈ V from (show (D.f i j) w = y from hw1) ▸ hyV, hw2⟩
  · rintro ⟨w, hwV, rfl⟩
    refine ⟨D.f i j w, hwV, ?_⟩
    -- `ι_i (f_ij w) = ι_j ((t_ij ≫ f_ji) w)`: the glue condition at the point `w`
    have h := congrArg (fun m : D.V (i, j) ⟶ D.glued => m w)
      ((D.glue_condition i j).symm.trans (Category.assoc _ _ _).symm)
    exact h

/-- **The two composite opens functors of the chart-overlap square are equal**: going
"into the glued scheme along `ι_i` and back down to `U_j`" is the same site functor as
"down to the overlap along `f_ij` and into `U_j` along `t_ij ≫ f_ji`". Object-level
content is `glueData_preimage_image_eq`; morphisms are proof-irrelevant in the opens
preorder. This is the site-level heart of the overlap base-change comparison
`ι_i^* ∘ (ι_j)_* ≅ (f_ij)_* ∘ (t_ij ≫ f_ji)^*` consumed by
`isIso_glueRestrictionHom`. Project-local. -/
lemma glueData_overlap_opensFunctor_eq (D : Scheme.GlueData.{0}) (i j : D.J) :
    (D.ι i).opensFunctor ⋙ TopologicalSpace.Opens.map (D.ι j).base
      = TopologicalSpace.Opens.map (D.f i j).base ⋙ (D.t i j ≫ D.f j i).opensFunctor :=
  CategoryTheory.Functor.ext (fun V => glueData_preimage_image_eq D i j V)
    (fun _ _ _ => Subsingleton.elim _ _)

/-- **Overlap base change of the chart square** (`β_ij`): restricting a pushforward
`(ι_j)_* N` to the chart `U_i` is the same as restricting `N` to the overlap `V_ij`
(along `t_ij ≫ f_ji`) and pushing forward along `f_ij`. All four functors are
site-level pushforwards; both composites are pushforwards along the SAME opens functor
(`glueData_overlap_opensFunctor_eq`), so the comparison is
`pushforwardComp ≪≫ pushforwardNatIso (eqToIso components) ≪≫ pushforwardCongr ≪≫
pushforwardComp.symm` — the `restrictFunctorComp` pattern of Mathlib. This is the
factor-wise identification of the restricted descent product consumed by
`isIso_glueRestrictionHom`. Project-local. -/
noncomputable def glueOverlapBaseChangeIso (D : Scheme.GlueData.{0}) (i j : D.J) :
    Scheme.Modules.pushforward (D.ι j) ⋙ restrictFunctor (D.ι i)
      ≅ restrictFunctor (D.t i j ≫ D.f j i) ⋙ Scheme.Modules.pushforward (D.f i j) :=
  haveI h₁ : Functor.IsContinuous
      ((D.ι i).opensFunctor ⋙ TopologicalSpace.Opens.map (D.ι j).base)
      (Opens.grothendieckTopology ↥(D.U i))
      (Opens.grothendieckTopology ↥(D.U j)) :=
    Functor.isContinuous_comp _ _ _
      (Opens.grothendieckTopology ↥(D.glued)) _
  haveI h₂ : Functor.IsContinuous
      (TopologicalSpace.Opens.map (D.f i j).base ⋙ (D.t i j ≫ D.f j i).opensFunctor)
      (Opens.grothendieckTopology ↥(D.U i))
      (Opens.grothendieckTopology ↥(D.U j)) :=
    Functor.isContinuous_comp _ _ _
      (Opens.grothendieckTopology ↥(D.V (i, j))) _
  SheafOfModules.pushforwardComp _ _ ≪≫
    SheafOfModules.pushforwardNatIso _
      (NatIso.ofComponents
        (fun V => eqToIso (glueData_preimage_image_eq D i j V))
        (fun _ => Subsingleton.elim _ _)) ≪≫
    SheafOfModules.pushforwardCongr (by
      ext V : 3
      sorry) ≪≫
    (SheafOfModules.pushforwardComp _ _).symm

/-- **Effective descent: the chart restriction morphism of the glued sheaf is an
isomorphism** (`def:gr_modules_glueRestrictionIso`). This is where the cocycle
hypotheses (C1)/(C2) are consumed.

PROOF ROUTE (scoped iter-066, partially built): the chart pullback `ι_i^*` preserves
limits (`pullback_preservesLimits_of_isOpenImmersion` — it is isomorphic to the
site-level pushforward `restrictFunctor`), so `ι_i^* (glue …)` is the equalizer of the
restricted legs `ι_i^* (glueLegA)`, `ι_i^* (glueLegB)` and the restricted product
embeds into `∏_j ι_i^* ((ι_j)_* M_j)`. The candidate inverse `M i ⟶ ι_i^* (glue …)`
is the equalizer lift of the family whose `j`-component transports a section of `M i`
to the overlap: `unit_{f_ij} ≫ (f_ij)_* (g_ij-conjugate) ≫ β_ij⁻¹`, where
`β_ij : ι_i^* ((ι_j)_* M_j) ≅ (f_ij)_* ((t_ij ≫ f_ji)^* M_j)` is the open-cover base
change of the cartesian overlap square (site-level: both composites are pushforwards
along the SAME opens functor, by `glueData_preimage_image_eq`). The equalizing
condition of that family is (C2) in transported form; the two triangle identities
reduce to (C1) and the counit triangle. Remaining work: construct `β_ij` (via
`restrictFunctor` + `SheafOfModules.pushforwardComp`/`pushforwardCongr` +
`glueData_preimage_image_eq`) and verify the three conditions. -/
theorem isIso_glueRestrictionHom (D : Scheme.GlueData.{0}) (M : ∀ i, (D.U i).Modules)
    (g : ∀ i j, (Scheme.Modules.pullback (D.f i j)).obj (M i) ≅
        (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j))
    (hC1 : ∀ i, g i i = eqToIso (congrArg (fun φ => (Scheme.Modules.pullback φ).obj (M i))
        (show D.f i i = D.t i i ≫ D.f i i by rw [D.t_id i, Category.id_comp])))
    (hC2 : ∀ i j k,
        pullbackBaseChangeTransport (pullback.fst (D.f i j) (D.f i k))
            (D.f i j) (D.t i j ≫ D.f j i) (g i j) ≪≫
          (Scheme.Modules.pullbackCongr (glueData_bridge_mid D i j k)).app (M j) ≪≫
          pullbackBaseChangeTransport (D.t' i j k ≫ pullback.fst (D.f j k) (D.f j i))
            (D.f j k) (D.t j k ≫ D.f k j) (g j k) ≪≫
          (Scheme.Modules.pullbackCongr (glueData_bridge_tgt D i j k)).app (M k)
        = (Scheme.Modules.pullbackCongr (glueData_bridge_src D i j k)).app (M i) ≪≫
          pullbackBaseChangeTransport (pullback.snd (D.f i j) (D.f i k))
            (D.f i k) (D.t i k ≫ D.f k i) (g i k)) (i : D.J) :
    IsIso (glueRestrictionHom D M g hC1 hC2 i) := by
  sorry

/-- **The restriction isomorphism of the glued sheaf**
(`def:gr_modules_glueRestrictionIso`): the canonical identification
`ι_i^* (glue D M g …) ≅ M i` of the chart restriction of the glued sheaf with the
`i`-th input sheaf, with underlying morphism the adjoint transpose of the `i`-th
descent-equalizer projection. Project-local. -/
noncomputable def glueRestrictionIso (D : Scheme.GlueData.{0}) (M : ∀ i, (D.U i).Modules)
    (g : ∀ i j, (Scheme.Modules.pullback (D.f i j)).obj (M i) ≅
        (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j))
    (hC1 : ∀ i, g i i = eqToIso (congrArg (fun φ => (Scheme.Modules.pullback φ).obj (M i))
        (show D.f i i = D.t i i ≫ D.f i i by rw [D.t_id i, Category.id_comp])))
    (hC2 : ∀ i j k,
        pullbackBaseChangeTransport (pullback.fst (D.f i j) (D.f i k))
            (D.f i j) (D.t i j ≫ D.f j i) (g i j) ≪≫
          (Scheme.Modules.pullbackCongr (glueData_bridge_mid D i j k)).app (M j) ≪≫
          pullbackBaseChangeTransport (D.t' i j k ≫ pullback.fst (D.f j k) (D.f j i))
            (D.f j k) (D.t j k ≫ D.f k j) (g j k) ≪≫
          (Scheme.Modules.pullbackCongr (glueData_bridge_tgt D i j k)).app (M k)
        = (Scheme.Modules.pullbackCongr (glueData_bridge_src D i j k)).app (M i) ≪≫
          pullbackBaseChangeTransport (pullback.snd (D.f i j) (D.f i k))
            (D.f i k) (D.t i k ≫ D.f k i) (g i k)) (i : D.J) :
    (Scheme.Modules.pullback (D.ι i)).obj (glue D M g hC1 hC2) ≅ M i :=
  haveI := isIso_glueRestrictionHom D M g hC1 hC2 i
  asIso (glueRestrictionHom D M g hC1 hC2 i)

end AlgebraicGeometry.Scheme.Modules

namespace AlgebraicGeometry.Grassmannian

/-- **Transport of a matrix automorphism through `pullbackBaseChangeTransport`** — the
reusable (a)→(c) bridge for the bundle cocycle (`lem:gr_matrixToFreeIso_transport`). A
transition isomorphism of the bundle-transition shape
`pullbackFreeIso a ≪≫ matrixToFreeIso M N ≪≫ (pullbackFreeIso b).symm` (a `GL_d` matrix
automorphism conjugated to the overlap pullbacks) transports along `p : W ⟶ V` to the same
shape over `p ≫ a` / `p ≫ b`, with the matrix base-changed entrywise by the comorphism
`p.appTop`. Combines the matrix-naturality atom `matrixEnd_pullback` with the free-pullback
pseudofunctor coherence `Scheme.Modules.pullbackFreeIso_comp`. Project-local — this is the
abstract core of the bundle cocycle transport, independent of the Grassmannian charts. -/
lemma pullbackBaseChangeTransport_matrixToFreeIso {W V : Scheme.{0}} (p : W ⟶ V)
    {Yi Yj : Scheme.{0}} (a : V ⟶ Yi) (b : V ⟶ Yj) {d : ℕ}
    (M N : Matrix (Fin d) (Fin d) Γ(V, ⊤)) (hMN : M * N = 1) (hNM : N * M = 1) :
    (Scheme.Modules.pullbackBaseChangeTransport p a b
        (Scheme.Modules.pullbackFreeIso a (Fin d) ≪≫ matrixToFreeIso M N hMN hNM ≪≫
          (Scheme.Modules.pullbackFreeIso b (Fin d)).symm)).hom
      = (Scheme.Modules.pullbackFreeIso (p ≫ a) (Fin d)).hom ≫
        matrixEnd ((CommRingCat.Hom.hom (Scheme.Hom.appTop p)).mapMatrix M) ≫
        (Scheme.Modules.pullbackFreeIso (p ≫ b) (Fin d)).inv := by
  simp only [Scheme.Modules.pullbackBaseChangeTransport, Iso.trans_hom, Functor.mapIso_hom,
    Iso.symm_hom, matrixToFreeIso_hom]
  -- Front coherence: the `pullbackComp` cast + the `a`-leg comparison assemble into the
  -- composite free-pullback comparison `Q_{p≫a}` (pseudofunctoriality, `pullbackFreeIso_comp`).
  have hfront : ((Scheme.Modules.pullbackComp p a).symm.app
          (SheafOfModules.free (Fin d))).hom ≫
        (Scheme.Modules.pullback p).map (Scheme.Modules.pullbackFreeIso a (Fin d)).hom ≫
          (Scheme.Modules.pullbackFreeIso p (Fin d)).hom
      = (Scheme.Modules.pullbackFreeIso (p ≫ a) (Fin d)).hom := by
    erw [← Scheme.Modules.pullbackFreeIso_comp a p (Fin d)]
    simp only [Iso.app_hom, Iso.symm_hom]
    rw [Iso.inv_hom_id_app_assoc]
  -- Back coherence: the inverse `b`-leg comparison + the `pullbackComp` cast assemble into the
  -- inverse composite comparison `Q_{p≫b}⁻¹`. Derived by inverting the `b`-leg coherence iso.
  have hback : (Scheme.Modules.pullbackFreeIso p (Fin d)).inv ≫
        (Scheme.Modules.pullback p).map (Scheme.Modules.pullbackFreeIso b (Fin d)).inv ≫
          ((Scheme.Modules.pullbackComp p b).app (SheafOfModules.free (Fin d))).hom
      = (Scheme.Modules.pullbackFreeIso (p ≫ b) (Fin d)).inv := by
    have hiso : (Scheme.Modules.pullbackComp p b).app (SheafOfModules.free (Fin d)) ≪≫
          Scheme.Modules.pullbackFreeIso (p ≫ b) (Fin d)
        = (Scheme.Modules.pullback p).mapIso (Scheme.Modules.pullbackFreeIso b (Fin d)) ≪≫
          Scheme.Modules.pullbackFreeIso p (Fin d) := by
      apply Iso.ext
      simpa using Scheme.Modules.pullbackFreeIso_comp b p (Fin d)
    have hinv := congrArg Iso.inv hiso
    simp only [Iso.trans_inv, Functor.mapIso_inv, Iso.app_inv] at hinv
    -- hinv : Q_{p≫b}.inv ≫ Cpb.inv.app free = Q_p.inv ≫ (pullback p).map Q_b.inv
    rw [← Category.assoc, ← hinv, Iso.app_hom]
    erw [Category.assoc, Iso.inv_hom_id_app]
    rw [Category.comp_id]
  -- Distribute `pullback p` over the conjugated matrix automorphism and apply the matrix atom.
  rw [Functor.map_comp, Functor.map_comp, matrixEnd_pullback]
  -- Expand both comparison legs of the target via the coherences `hfront`/`hback`; the two sides
  -- then coincide up to the (here definitional) associativity of the composite.
  rw [← hfront, ← hback]
  rfl

/-! ### The base-change bridge (b): geometric comorphisms = localised cocycle ring homs

The three scheme-pullback base-change maps `Γ(U^I_J,⊤) ⟶ Γ(V_IJK,⊤)` — induced by the two
pullback projections and the triple transition `t'` — are identified, through the affine
global-sections isomorphism `ΓSpecIso` and the away-pullback identification
`V_IJK ≅ Spec S_I` (`awayPullbackIso`), with the ring homomorphisms `awayInclLeft`,
`awayInclRight` and `cocycleΘIJ ∘ awayInclRight` over which the matrix cocycle L1
(`bundleTransition_cocycle_matrix`) is stated. -/

/-- **Affine global-sections comorphism is the inducing ring homomorphism**
(`lem:gr_baseChange_bridge_gammaSpec`): for a ring homomorphism `φ : A ⟶ B`, the
global-sections comorphism of `Spec.map φ`, conjugated through the counit isomorphisms
`ΓSpecIso`, is `φ` itself. Pure `Γ ⊣ Spec` naturality; project-local packaging. -/
lemma baseChange_bridge_gammaSpec {A B : CommRingCat.{0}} (φ : A ⟶ B) :
    (Scheme.ΓSpecIso A).inv ≫ Scheme.Hom.appTop (Spec.map φ)
      = φ ≫ (Scheme.ΓSpecIso B).inv := by
  rw [Iso.inv_comp_eq, ← Category.assoc, ← Scheme.ΓSpecIso_naturality, Category.assoc,
    Iso.hom_inv_id, Category.comp_id]

/-- The global-sections identification of the triple overlap: the ring map from the
triple-overlap coordinate ring `S_I = R^I[1/(P^I_J P^I_K)]` to the global sections of the
scheme-level triple overlap `V_IJK = U^I_J ×_{U^I} U^I_K`, namely the affine identification
`ΓSpecIso` transported through the away-pullback identification `awayPullbackIso`. It is the
common codomain conjugation of the three base-change bridges below. Project-local. -/
noncomputable def tripleOverlapSections (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    CommRingCat.of (Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK)) ⟶
      Γ(Limits.pullback (chartIncl d r I J hI hJ) (chartIncl d r I K hI hK), ⊤) :=
  (Scheme.ΓSpecIso _).inv ≫
    Scheme.Hom.appTop
      (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom

/-- **First-projection bridge to `awayInclLeft`** (`lem:gr_baseChange_bridge_left`): the
global-sections base-change map of the first projection `p^{IJ}_{IJK} : V_IJK ⟶ U^I_J`,
transported through the affine identifications, is the ring homomorphism
`awayInclLeft (P^I_J) (P^I_K)`. Project-local. -/
lemma baseChange_bridge_left (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ)))).inv ≫
        Scheme.Hom.appTop
          (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ))))
          (Limits.pullback.fst (chartIncl d r I J hI hJ) (chartIncl d r I K hI hK))
      = CommRingCat.ofHom (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) ≫
        tripleOverlapSections d r I J K hI hJ hK := by
  have hfst : (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).inv ≫
        Limits.pullback.fst (chartIncl d r I J hI hJ) (chartIncl d r I K hI hK)
      = Spec.map (CommRingCat.ofHom
          (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))) :=
    awayPullbackIso_inv_fst _ _
  have hp : Limits.pullback.fst (chartIncl d r I J hI hJ) (chartIncl d r I K hI hK)
      = (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom ≫
        Spec.map (CommRingCat.ofHom
          (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))) :=
    (Iso.inv_comp_eq _).mp hfst
  rw [hp, Scheme.Hom.comp_appTop]
  -- term-mode reassociation (positional `rw [← Category.assoc]` misses the comp node: the
  -- middle-object representation differs across the `pullback (chartIncl …)` defeq)
  exact (Category.assoc _ _ _).symm.trans ((congrArg
    (· ≫ Scheme.Hom.appTop
      (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom)
    (baseChange_bridge_gammaSpec (CommRingCat.ofHom
      (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))))).trans
    (Category.assoc _ _ _))

/-- **Second-projection bridge to `awayInclRight`** (`lem:gr_baseChange_bridge_right`): the
global-sections base-change map of the second projection `p^{IK}_{IJK} : V_IJK ⟶ U^I_K`,
transported through the affine identifications, is the ring homomorphism
`awayInclRight (P^I_J) (P^I_K)`. Project-local. -/
lemma baseChange_bridge_right (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away (minorDet d r I K hI hK)))).inv ≫
        Scheme.Hom.appTop
          (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I K hI hK))))
          (Limits.pullback.snd (chartIncl d r I J hI hJ) (chartIncl d r I K hI hK))
      = CommRingCat.ofHom (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK)) ≫
        tripleOverlapSections d r I J K hI hJ hK := by
  have hsnd : (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).inv ≫
        Limits.pullback.snd (chartIncl d r I J hI hJ) (chartIncl d r I K hI hK)
      = Spec.map (CommRingCat.ofHom
          (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))) :=
    awayPullbackIso_inv_snd _ _
  have hp : Limits.pullback.snd (chartIncl d r I J hI hJ) (chartIncl d r I K hI hK)
      = (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom ≫
        Spec.map (CommRingCat.ofHom
          (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))) :=
    (Iso.inv_comp_eq _).mp hsnd
  rw [hp, Scheme.Hom.comp_appTop]
  -- term-mode reassociation (see `baseChange_bridge_left`)
  exact (Category.assoc _ _ _).symm.trans ((congrArg
    (· ≫ Scheme.Hom.appTop
      (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom)
    (baseChange_bridge_gammaSpec (CommRingCat.ofHom
      (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))))).trans
    (Category.assoc _ _ _))

/-- **Triple-transition bridge to `Θ_{IJ}`** (`lem:gr_baseChange_bridge_transition`): the
global-sections base-change map of the composite `t'_{IJK} ≫ p^{JK}_{JKI} : V_IJK ⟶ U^J_K`,
transported through the affine identifications, is the localised cocycle homomorphism
`Θ_{IJ} ∘ awayInclRight (P^J_I) (P^J_K)` — exactly the composite over which the matrix
cocycle L1 (`bundleTransition_cocycle_matrix`) takes the `(J,K)`-Cramer inverse. The
order-swap `awayMulCommEquiv` of `chartTransition'` is absorbed by
`awayMulCommEquiv_comp_awayInclLeft`. Project-local. -/
lemma baseChange_bridge_transition (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away (minorDet d r J K hJ hK)))).inv ≫
        Scheme.Hom.appTop
          (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r J K hJ hK))))
          (chartTransition' d r I J K hI hJ hK ≫
            Limits.pullback.fst (chartIncl d r J K hJ hK) (chartIncl d r J I hJ hI))
      = CommRingCat.ofHom ((cocycleΘIJ d r I J K hI hJ hK).comp
          (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))) ≫
        tripleOverlapSections d r I J K hI hJ hK := by
  have hfst : (awayPullbackIso (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).inv ≫
        Limits.pullback.fst (chartIncl d r J K hJ hK) (chartIncl d r J I hJ hI)
      = Spec.map (CommRingCat.ofHom
          (awayInclLeft (minorDet d r J K hJ hK) (minorDet d r J I hJ hI))) :=
    awayPullbackIso_inv_fst _ _
  have hp : chartTransition' d r I J K hI hJ hK ≫
        Limits.pullback.fst (chartIncl d r J K hJ hK) (chartIncl d r J I hJ hI)
      = (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom ≫
        Spec.map (CommRingCat.ofHom ((cocycleΘIJ d r I J K hI hJ hK).comp
          (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))) := by
    rw [chartTransition']
    simp only [Category.assoc]
    -- `erw` (defeq matching) to fire the fst-leg lemma through the `HasPullback` instance
    -- diamond on the heavy localisation objects (the Cells `chartTransition'_fac` precedent)
    erw [hfst]
    -- collapse the three `Spec.map`s in a fresh homogeneous `have` (positional `rw` cannot
    -- see the `Spec.map ≫ Spec.map` nodes after the erw), then transport by `congrArg`
    have htail : Spec.map (CommRingCat.ofHom (cocycleΘIJ d r I J K hI hJ hK)) ≫
          Spec.map (CommRingCat.ofHom
            (awayMulCommEquiv (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)).toRingHom) ≫
          Spec.map (CommRingCat.ofHom
            (awayInclLeft (minorDet d r J K hJ hK) (minorDet d r J I hJ hI)))
        = Spec.map (CommRingCat.ofHom ((cocycleΘIJ d r I J K hI hJ hK).comp
            (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))) := by
      rw [← Spec.map_comp, ← Spec.map_comp, ← CommRingCat.ofHom_comp,
        ← CommRingCat.ofHom_comp, awayMulCommEquiv_comp_awayInclLeft]
    exact congrArg
      ((awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom ≫ ·) htail
  -- `rw [hp]` cannot find the composite under `appTop` (comp-node instance mismatch);
  -- transport by `congrArg` instead, then proceed as in `baseChange_bridge_left`.
  refine (congrArg (fun m => (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
    (minorDet d r J K hJ hK)))).inv ≫ Scheme.Hom.appTop m) hp).trans ?_
  rw [Scheme.Hom.comp_appTop]
  -- term-mode reassociation (see `baseChange_bridge_left`)
  exact (Category.assoc _ _ _).symm.trans ((congrArg
    (· ≫ Scheme.Hom.appTop
      (awayPullbackIso (minorDet d r I J hI hJ) (minorDet d r I K hI hK)).hom)
    (baseChange_bridge_gammaSpec (CommRingCat.ofHom ((cocycleΘIJ d r I J K hI hJ hK).comp
      (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))))).trans
    (Category.assoc _ _ _))

/-- **Base-change bridge to the localised cocycle, matrix form** (`lem:gr_baseChange_bridge`):
over the triple overlap `V_IJK` the three geometrically base-changed Cramer inverses satisfy
the multiplicative cocycle. The three projection bridges rewrite each base-changed matrix as
the σ-image (`tripleOverlapSections`) of the corresponding L1 matrix, and the matrix-level
cocycle `bundleTransition_cocycle_matrix` transports along the ring homomorphism σ.
Project-local — this is the (b)-step of the bundle cocycle. -/
theorem baseChange_bridge (d r : ℕ) (I J K : Finset (Fin r)) (hI : I.card = d)
    (hJ : J.card = d) (hK : K.card = d) :
    (CommRingCat.Hom.hom (Scheme.Hom.appTop
          (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r J K hJ hK))))
          (chartTransition' d r I J K hI hJ hK ≫
            Limits.pullback.fst (chartIncl d r J K hJ hK) (chartIncl d r J I hJ hI)))).mapMatrix
        ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
            (minorDet d r J K hJ hK)))).inv.hom.mapMatrix (universalMinorInv d r J K hJ hK))
      * (CommRingCat.Hom.hom (Scheme.Hom.appTop
            (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I J hI hJ))))
            (Limits.pullback.fst (chartIncl d r I J hI hJ)
              (chartIncl d r I K hI hK)))).mapMatrix
          ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
              (minorDet d r I J hI hJ)))).inv.hom.mapMatrix (universalMinorInv d r I J hI hJ))
      = (CommRingCat.Hom.hom (Scheme.Hom.appTop
            (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I K hI hK))))
            (Limits.pullback.snd (chartIncl d r I J hI hJ)
              (chartIncl d r I K hI hK)))).mapMatrix
          ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
              (minorDet d r I K hI hK)))).inv.hom.mapMatrix
            (universalMinorInv d r I K hI hK)) := by
  have hL := congrArg CommRingCat.Hom.hom (baseChange_bridge_left d r I J K hI hJ hK)
  have hR := congrArg CommRingCat.Hom.hom (baseChange_bridge_right d r I J K hI hJ hK)
  have hT := congrArg CommRingCat.Hom.hom (baseChange_bridge_transition d r I J K hI hJ hK)
  simp only [CommRingCat.hom_comp, CommRingCat.hom_ofHom] at hL hR hT
  -- collapse the iterated `mapMatrix`s into single `Matrix.map`s along composite ring homs,
  -- rewrite the composites through the three bridges, and split off the σ-factor
  simp only [RingHom.mapMatrix_apply, Matrix.map_map, ← RingHom.coe_comp, hL, hR, hT]
  -- split off exactly the outer σ-layer of each factor, recombine the product under σ, and
  -- close by the matrix cocycle L1; a `calc` keeps every sub-goal freshly elaborated (the
  -- carrier representations `↥(of R)` vs `R` block positional `rw` on the simp-produced goal)
  calc (universalMinorInv d r J K hJ hK).map
          ⇑((CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)).comp
            ((cocycleΘIJ d r I J K hI hJ hK).comp
              (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))) *
        (universalMinorInv d r I J hI hJ).map
          ⇑((CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)).comp
            (awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK)))
      = ((universalMinorInv d r J K hJ hK).map
            ⇑((cocycleΘIJ d r I J K hI hJ hK).comp
              (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK)))).map
            ⇑(CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)) *
        ((universalMinorInv d r I J hI hJ).map
            ⇑(awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))).map
            ⇑(CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)) := by
        simp only [RingHom.coe_comp, Matrix.map_map]
    _ = ((universalMinorInv d r J K hJ hK).map
            ⇑((cocycleΘIJ d r I J K hI hJ hK).comp
              (awayInclRight (minorDet d r J I hJ hI) (minorDet d r J K hJ hK))) *
          (universalMinorInv d r I J hI hJ).map
            ⇑(awayInclLeft (minorDet d r I J hI hJ) (minorDet d r I K hI hK))).map
            ⇑(CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)) :=
        Matrix.map_mul.symm
    _ = ((universalMinorInv d r I K hI hK).map
            ⇑(awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))).map
            ⇑(CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)) :=
        congrArg (fun N => N.map
            ⇑(CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)))
          (bundleTransition_cocycle_matrix d r I J K hI hJ hK)
    _ = (universalMinorInv d r I K hI hK).map
          ⇑((CommRingCat.Hom.hom (tripleOverlapSections d r I J K hI hJ hK)).comp
            (awayInclRight (minorDet d r I J hI hJ) (minorDet d r I K hI hK))) := by
        simp only [RingHom.coe_comp, Matrix.map_map]

set_option maxHeartbeats 1600000 in
-- The endpoint-cast collapses rewrite under the `X.Modules` diamond on the heavy
-- triple-overlap localisation objects; the raised limit covers the `isDefEq` cost
-- (the Cells `chartTransition'_fac` precedent).
/-- **Transport and endpoint alignment of the bundle transitions (the hom-level C2)**
(`lem:gr_bundleCocycle_transport`): the underlying-morphism form of the triple-overlap
multiplicativity. Each of the three base-change transports expands, via the abstract core
`pullbackBaseChangeTransport_matrixToFreeIso`, into `Q ≫ matrixEnd(base-changed Cramer
inverse) ≫ Q⁻¹`; the `pullbackCongr` endpoint casts collapse against the free-pullback
comparisons (`pullbackFreeIso_inv_congr_hom` etc., all generic-`subst` lemmas), the two
matrix endomorphisms fuse by `matrixEnd_comp`, and the resulting matrix identity is
exactly the base-change bridge `baseChange_bridge` (b), i.e. the σ-image of the matrix
cocycle L1. -/
theorem bundleTransition_cocycle_transport (d r : ℕ) (I J K : (theGlueData d r).J) :
    (Scheme.Modules.pullbackBaseChangeTransport
        (Limits.pullback.fst ((theGlueData d r).f I J) ((theGlueData d r).f I K))
        ((theGlueData d r).f I J) ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)
        (bundleTransitionData d r I J)).hom ≫
      ((Scheme.Modules.pullbackCongr
          (Scheme.Modules.glueData_bridge_mid (theGlueData d r) I J K)).app
        (SheafOfModules.free (R := ((theGlueData d r).U J).ringCatSheaf) (Fin d))).hom ≫
      (Scheme.Modules.pullbackBaseChangeTransport
        ((theGlueData d r).t' I J K ≫
          Limits.pullback.fst ((theGlueData d r).f J K) ((theGlueData d r).f J I))
        ((theGlueData d r).f J K) ((theGlueData d r).t J K ≫ (theGlueData d r).f K J)
        (bundleTransitionData d r J K)).hom ≫
      ((Scheme.Modules.pullbackCongr
          (Scheme.Modules.glueData_bridge_tgt (theGlueData d r) I J K)).app
        (SheafOfModules.free (R := ((theGlueData d r).U K).ringCatSheaf) (Fin d))).hom
    = ((Scheme.Modules.pullbackCongr
          (Scheme.Modules.glueData_bridge_src (theGlueData d r) I J K)).app
        (SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d))).hom ≫
      (Scheme.Modules.pullbackBaseChangeTransport
        (Limits.pullback.snd ((theGlueData d r).f I J) ((theGlueData d r).f I K))
        ((theGlueData d r).f I K) ((theGlueData d r).t I K ≫ (theGlueData d r).f K I)
        (bundleTransitionData d r I K)).hom := by
  -- (1) expand the three transports via the abstract core (term-mode `have`s; the `g`-argument
  -- `bundleTransitionData` is defeq to the `pullbackFreeIso ≪≫ matrixToFreeIso ≪≫ symm` shape)
  have eIJ : (Scheme.Modules.pullbackBaseChangeTransport
        (Limits.pullback.fst ((theGlueData d r).f I J) ((theGlueData d r).f I K))
        ((theGlueData d r).f I J) ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)
        (bundleTransitionData d r I J)).hom
      = (Scheme.Modules.pullbackFreeIso (Limits.pullback.fst ((theGlueData d r).f I J)
            ((theGlueData d r).f I K) ≫ (theGlueData d r).f I J) (Fin d)).hom ≫
        matrixEnd ((CommRingCat.Hom.hom (Scheme.Hom.appTop
            (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
            (Limits.pullback.fst ((theGlueData d r).f I J)
              ((theGlueData d r).f I K)))).mapMatrix
          ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
              (minorDet d r I.1 J.1 I.2 J.2)))).inv.hom.mapMatrix
            (universalMinorInv d r I.1 J.1 I.2 J.2))) ≫
        (Scheme.Modules.pullbackFreeIso (Limits.pullback.fst ((theGlueData d r).f I J)
            ((theGlueData d r).f I K) ≫ ((theGlueData d r).t I J ≫ (theGlueData d r).f J I))
            (Fin d)).inv :=
    pullbackBaseChangeTransport_matrixToFreeIso _ _ _ _ _ _ _
  have eJK : (Scheme.Modules.pullbackBaseChangeTransport
        ((theGlueData d r).t' I J K ≫
          Limits.pullback.fst ((theGlueData d r).f J K) ((theGlueData d r).f J I))
        ((theGlueData d r).f J K) ((theGlueData d r).t J K ≫ (theGlueData d r).f K J)
        (bundleTransitionData d r J K)).hom
      = (Scheme.Modules.pullbackFreeIso (((theGlueData d r).t' I J K ≫
            Limits.pullback.fst ((theGlueData d r).f J K) ((theGlueData d r).f J I)) ≫
            (theGlueData d r).f J K) (Fin d)).hom ≫
        matrixEnd ((CommRingCat.Hom.hom (Scheme.Hom.appTop
            (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r J.1 K.1 J.2 K.2))))
            ((theGlueData d r).t' I J K ≫
              Limits.pullback.fst ((theGlueData d r).f J K)
                ((theGlueData d r).f J I)))).mapMatrix
          ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
              (minorDet d r J.1 K.1 J.2 K.2)))).inv.hom.mapMatrix
            (universalMinorInv d r J.1 K.1 J.2 K.2))) ≫
        (Scheme.Modules.pullbackFreeIso (((theGlueData d r).t' I J K ≫
            Limits.pullback.fst ((theGlueData d r).f J K) ((theGlueData d r).f J I)) ≫
            ((theGlueData d r).t J K ≫ (theGlueData d r).f K J)) (Fin d)).inv :=
    pullbackBaseChangeTransport_matrixToFreeIso _ _ _ _ _ _ _
  have eIK : (Scheme.Modules.pullbackBaseChangeTransport
        (Limits.pullback.snd ((theGlueData d r).f I J) ((theGlueData d r).f I K))
        ((theGlueData d r).f I K) ((theGlueData d r).t I K ≫ (theGlueData d r).f K I)
        (bundleTransitionData d r I K)).hom
      = (Scheme.Modules.pullbackFreeIso (Limits.pullback.snd ((theGlueData d r).f I J)
            ((theGlueData d r).f I K) ≫ (theGlueData d r).f I K) (Fin d)).hom ≫
        matrixEnd ((CommRingCat.Hom.hom (Scheme.Hom.appTop
            (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 K.1 I.2 K.2))))
            (Limits.pullback.snd ((theGlueData d r).f I J)
              ((theGlueData d r).f I K)))).mapMatrix
          ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
              (minorDet d r I.1 K.1 I.2 K.2)))).inv.hom.mapMatrix
            (universalMinorInv d r I.1 K.1 I.2 K.2))) ≫
        (Scheme.Modules.pullbackFreeIso (Limits.pullback.snd ((theGlueData d r).f I J)
            ((theGlueData d r).f I K) ≫ ((theGlueData d r).t I K ≫ (theGlueData d r).f K I))
            (Fin d)).inv :=
    pullbackBaseChangeTransport_matrixToFreeIso _ _ _ _ _ _ _
  -- (2) the base-change bridge (b), restated over the glue-datum phrasing (defeq)
  have hbridge : (CommRingCat.Hom.hom (Scheme.Hom.appTop
          (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r J.1 K.1 J.2 K.2))))
          ((theGlueData d r).t' I J K ≫
            Limits.pullback.fst ((theGlueData d r).f J K)
              ((theGlueData d r).f J I)))).mapMatrix
        ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
            (minorDet d r J.1 K.1 J.2 K.2)))).inv.hom.mapMatrix
          (universalMinorInv d r J.1 K.1 J.2 K.2))
      * (CommRingCat.Hom.hom (Scheme.Hom.appTop
            (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
            (Limits.pullback.fst ((theGlueData d r).f I J)
              ((theGlueData d r).f I K)))).mapMatrix
          ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
              (minorDet d r I.1 J.1 I.2 J.2)))).inv.hom.mapMatrix
            (universalMinorInv d r I.1 J.1 I.2 J.2))
      = (CommRingCat.Hom.hom (Scheme.Hom.appTop
            (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 K.1 I.2 K.2))))
            (Limits.pullback.snd ((theGlueData d r).f I J)
              ((theGlueData d r).f I K)))).mapMatrix
          ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
              (minorDet d r I.1 K.1 I.2 K.2)))).inv.hom.mapMatrix
            (universalMinorInv d r I.1 K.1 I.2 K.2)) :=
    baseChange_bridge d r I.1 J.1 K.1 I.2 J.2 K.2
  -- (3) expand, collapse the endpoint casts, fuse the matrix endomorphisms, apply (b)
  rw [eIJ, eJK, eIK]
  simp only [Category.assoc]
  rw [Scheme.Modules.pullbackFreeIso_inv_congr_hom_assoc
      (Scheme.Modules.glueData_bridge_mid (theGlueData d r) I J K) (Fin d),
    Scheme.Modules.pullbackCongr_hom_app_free_assoc
      (Scheme.Modules.glueData_bridge_src (theGlueData d r) I J K) (Fin d),
    Scheme.Modules.pullbackFreeIso_inv_congr
      (Scheme.Modules.glueData_bridge_tgt (theGlueData d r) I J K) (Fin d)]
  -- (4) fuse the two matrix endomorphisms and apply the bridge, in a fresh `have` (the
  -- mixed-provenance comp nodes block positional `rw` with `matrixEnd_comp` on the main goal)
  have hfuse : matrixEnd ((CommRingCat.Hom.hom (Scheme.Hom.appTop
          (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
          (Limits.pullback.fst ((theGlueData d r).f I J)
            ((theGlueData d r).f I K)))).mapMatrix
        ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
            (minorDet d r I.1 J.1 I.2 J.2)))).inv.hom.mapMatrix
          (universalMinorInv d r I.1 J.1 I.2 J.2))) ≫
      matrixEnd ((CommRingCat.Hom.hom (Scheme.Hom.appTop
          (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r J.1 K.1 J.2 K.2))))
          ((theGlueData d r).t' I J K ≫
            Limits.pullback.fst ((theGlueData d r).f J K)
              ((theGlueData d r).f J I)))).mapMatrix
        ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
            (minorDet d r J.1 K.1 J.2 K.2)))).inv.hom.mapMatrix
          (universalMinorInv d r J.1 K.1 J.2 K.2))) ≫
      (Scheme.Modules.pullbackFreeIso (Limits.pullback.snd ((theGlueData d r).f I J)
          ((theGlueData d r).f I K) ≫ ((theGlueData d r).t I K ≫ (theGlueData d r).f K I))
          (Fin d)).inv
    = matrixEnd ((CommRingCat.Hom.hom (Scheme.Hom.appTop
          (Y := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 K.1 I.2 K.2))))
          (Limits.pullback.snd ((theGlueData d r).f I J)
            ((theGlueData d r).f I K)))).mapMatrix
        ((Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
            (minorDet d r I.1 K.1 I.2 K.2)))).inv.hom.mapMatrix
          (universalMinorInv d r I.1 K.1 I.2 K.2))) ≫
      (Scheme.Modules.pullbackFreeIso (Limits.pullback.snd ((theGlueData d r).f I J)
          ((theGlueData d r).f I K) ≫ ((theGlueData d r).t I K ≫ (theGlueData d r).f K I))
          (Fin d)).inv :=
    -- term-mode: positional `rw [← Category.assoc]` grabs the scheme-level composite inside
    -- `pullbackFreeIso`'s argument instead of the Modules-level chain
    (Category.assoc _ _ _).symm.trans
      (congrArg (· ≫ (Scheme.Modules.pullbackFreeIso
          (Limits.pullback.snd ((theGlueData d r).f I J) ((theGlueData d r).f I K) ≫
            ((theGlueData d r).t I K ≫ (theGlueData d r).f K I)) (Fin d)).inv)
        ((matrixEnd_comp _ _).trans (congrArg matrixEnd hbridge)))
  exact congrArg ((Scheme.Modules.pullbackFreeIso (Limits.pullback.fst ((theGlueData d r).f I J)
    ((theGlueData d r).f I K) ≫ (theGlueData d r).f I J) (Fin d)).hom ≫ ·) hfuse

set_option maxHeartbeats 1600000 in
-- the `Iso.ext`-reduction unifies the inferred `.app _` instances with the transport
-- statement across the `X.Modules` diamond; the raised limit covers the `whnf` cost
/-- **Triple-overlap multiplicativity of the bundle transition (C2)**
(`lem:gr_bundleCocycle_mul`): over each triple overlap the base-change transports of the
three bundle transitions satisfy `ĝ_{JK} ∘ ĝ_{IJ} = ĝ_{IK}`, in the form required by
`Scheme.Modules.glue` — the exact `_hC2` hypothesis instantiated at `theGlueData d r` and
`bundleTransitionData`. At the matrix level this is the Cramer-inverse cocycle
`(X^J_K)⁻¹ (X^I_J)⁻¹ = (X^I_K)⁻¹` (`bundleTransition_cocycle_matrix`); the transport to the
common triple overlap and the endpoint alignment are `bundleTransition_cocycle_transport`. -/
theorem bundleTransition_cocycle (d r : ℕ) (I J K : (theGlueData d r).J) :
    Scheme.Modules.pullbackBaseChangeTransport
        (Limits.pullback.fst ((theGlueData d r).f I J) ((theGlueData d r).f I K))
        ((theGlueData d r).f I J) ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)
        (bundleTransitionData d r I J) ≪≫
      (Scheme.Modules.pullbackCongr
          (Scheme.Modules.glueData_bridge_mid (theGlueData d r) I J K)).app _ ≪≫
      Scheme.Modules.pullbackBaseChangeTransport
        ((theGlueData d r).t' I J K ≫
          Limits.pullback.fst ((theGlueData d r).f J K) ((theGlueData d r).f J I))
        ((theGlueData d r).f J K) ((theGlueData d r).t J K ≫ (theGlueData d r).f K J)
        (bundleTransitionData d r J K) ≪≫
      (Scheme.Modules.pullbackCongr
          (Scheme.Modules.glueData_bridge_tgt (theGlueData d r) I J K)).app _
    = (Scheme.Modules.pullbackCongr
          (Scheme.Modules.glueData_bridge_src (theGlueData d r) I J K)).app _ ≪≫
      Scheme.Modules.pullbackBaseChangeTransport
        (Limits.pullback.snd ((theGlueData d r).f I J) ((theGlueData d r).f I K))
        ((theGlueData d r).f I K) ((theGlueData d r).t I K ≫ (theGlueData d r).f K I)
        (bundleTransitionData d r I K) := by
  -- Reduce the iso-level cocycle to the underlying morphism equality of free sheaves over
  -- the triple overlap `V_IJK`; that equality is `bundleTransition_cocycle_transport`.
  apply Iso.ext
  simp only [Iso.trans_hom]
  exact bundleTransition_cocycle_transport d r I J K

/-! ## The universal quotient sheaf and the tautological quotient -/

/-- The **universal quotient sheaf** `U` on `Gr(d,r)` (`def:gr_universal_quotient_sheaf`):
the rank-`d` locally free sheaf obtained by gluing the free rank-`d` chart sheaves
`O_{U^I}^d` along the bundle transition cocycle `g_{I,J} = (X^I_J)⁻¹`, via the descent
equalizer `Scheme.Modules.glue`. The (C1) self-identity is `bundleTransition_self` and the
(C2) triple-overlap multiplicativity is `bundleTransition_cocycle`. -/
noncomputable def universalQuotient (d r : ℕ) : (scheme d r).Modules :=
  Scheme.Modules.glue (theGlueData d r)
    (fun I => SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d))
    (bundleTransitionData d r)
    (fun I => bundleTransition_self d r I.1 I.2)
    (fun I J K => bundleTransition_cocycle d r I J K)

/-- The per-chart component of the tautological quotient: the adjoint transpose, along the
chart immersion `ι_I`, of the chart quotient `u^I` (`chartQuotientMap`) precomposed with
the free-pullback comparison `pullbackFreeIso (ι_I)`. Project-local helper for
`tautologicalQuotient`. -/
noncomputable def tautologicalQuotientComponent (d r : ℕ) (I : (theGlueData d r).J) :
    SheafOfModules.free (R := (scheme d r).ringCatSheaf) (Fin r) ⟶
      (Scheme.Modules.pushforward ((theGlueData d r).ι I)).obj
        (SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d)) :=
  (Scheme.Modules.pullbackPushforwardAdjunction ((theGlueData d r).ι I)).homEquiv _ _
    ((Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι I) (Fin r)).hom ≫
      chartQuotientMap d r I.1 I.2)

set_option maxHeartbeats 1600000 in
-- The `Q`-cancellation rewrites and the final matrix comparison run under the
-- `X.Modules` diamond on the heavy localisation objects; the raised limit covers the
-- `isDefEq` cost (the `bundleTransition_cocycle_transport` precedent).
/-- **Overlap compatibility of the tautological quotient**
(`lem:gr_tautologicalQuotient_overlap`): the pullback-level identity
`g_{I,J} ∘ f_{IJ}^* u^I = (t_{IJ} ≫ f_{JI})^* u^J` on the overlap `U^I_J`, in the exact
transposed form produced by `tautologicalQuotientComponent_transpose`. Both sides reduce,
through the free-pullback comparisons (`pullbackComp_inv_app_free_map`,
`pullbackCongr_inv_app_free`) and the rectangular base-change naturality
(`matrixEndRect_pullback`), to `Q ≫ matrixEndRect(—) ≫ Q⁻¹` normal forms; the
square-after-rectangular fusion `matrixEndRect_comp` and the matrix identity
`X^I_J · ((X^I_J)⁻¹ X^I) = X^I` (`universalMinorInv_mul_cancel`, with
`X^J ↦ (X^I_J)⁻¹ X^I` provided by `universalMatrix_map_transitionPreMap`) close the
comparison. -/
theorem tautologicalQuotient_overlap (d r : ℕ) (I J : (theGlueData d r).J) :
    (Scheme.Modules.pullbackComp ((theGlueData d r).f I J) ((theGlueData d r).ι I)).inv.app
        (SheafOfModules.free (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫
      (Scheme.Modules.pullback ((theGlueData d r).f I J)).map
        ((Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι I) (Fin r)).hom ≫
          chartQuotientMap d r I.1 I.2)
    = (Scheme.Modules.pullbackCongr
          (show ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) ≫ (theGlueData d r).ι J
              = (theGlueData d r).f I J ≫ (theGlueData d r).ι I by
            rw [Category.assoc]; exact (theGlueData d r).glue_condition I J)).inv.app
        (SheafOfModules.free (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫
      (Scheme.Modules.pullbackComp ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)
        ((theGlueData d r).ι J)).inv.app
        (SheafOfModules.free (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫
      (Scheme.Modules.pullback ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)).map
        ((Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι J) (Fin r)).hom ≫
          chartQuotientMap d r J.1 J.2) ≫
      (bundleTransitionData d r I J).inv := by
  -- (1) ring-hom collapse of the scheme-level transition composite:
  -- `t_{IJ} ≫ f_{JI} = Spec.map θ̃_{I,J}` (the pre-localisation hom)
  have hcomp_ring : (transitionMap d r I.1 J.1 I.2 J.2).comp
        (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ)
          (Localization.Away (minorDet d r J.1 I.1 J.2 I.2)))
      = (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom := by
    rw [transitionMap]
    exact IsLocalization.Away.lift_comp _ _
  have heq : (theGlueData d r).t I J ≫ (theGlueData d r).f J I
      = Spec.map (CommRingCat.ofHom (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom) := by
    -- re-type the composite at the `Spec`-spelled objects so `Spec.map_comp` can match
    -- (the native `chartOverlap` middle object blocks the pattern)
    change Spec.map (CommRingCat.ofHom (transitionMap d r I.1 J.1 I.2 J.2)) ≫
        Spec.map (CommRingCat.ofHom
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ)
            (Localization.Away (minorDet d r J.1 I.1 J.2 I.2)))) = _
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp, hcomp_ring]
  -- (2) the two global-sections bridges; the `X :=`/`Y :=` Spec-ascriptions pin the affine
  -- representations (iter-064 load-bearing trick: without them the print-identical defeq
  -- carriers block the `Matrix.map_map` fusions below)
  have hbb : (Scheme.ΓSpecIso (CommRingCat.of
        (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ))).inv ≫
        Scheme.Hom.appTop
          (X := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
          (Y := Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)))
          ((theGlueData d r).f I J)
      = CommRingCat.ofHom (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
          (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))) ≫
        (Scheme.ΓSpecIso (CommRingCat.of
          (Localization.Away (minorDet d r I.1 J.1 I.2 J.2)))).inv :=
    baseChange_bridge_gammaSpec _
  have hbe : (Scheme.ΓSpecIso (CommRingCat.of
        (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ))).inv ≫
        Scheme.Hom.appTop
          (X := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
          (Y := Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ)))
          ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)
      = CommRingCat.ofHom (transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom ≫
        (Scheme.ΓSpecIso (CommRingCat.of
          (Localization.Away (minorDet d r I.1 J.1 I.2 J.2)))).inv := by
    refine (congrArg (fun m => (Scheme.ΓSpecIso (CommRingCat.of
        (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ))).inv ≫
        Scheme.Hom.appTop
          (X := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
          (Y := Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ)))
          m) heq).trans ?_
    exact baseChange_bridge_gammaSpec _
  -- (3) matrix forms of the two bridges
  have hBmat : ((universalMatrix d r I.1 I.2).map
        ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
          (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ))).inv)).map
        ⇑(CommRingCat.Hom.hom (Scheme.Hom.appTop
          (X := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
          (Y := Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)))
          ((theGlueData d r).f I J)))
      = ((universalMatrix d r I.1 I.2).map
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
            (Localization.Away (minorDet d r I.1 J.1 I.2 J.2)))).map
        ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
          (Localization.Away (minorDet d r I.1 J.1 I.2 J.2)))).inv) := by
    have h := congrArg CommRingCat.Hom.hom hbb
    simp only [CommRingCat.hom_comp, CommRingCat.hom_ofHom] at h
    rw [Matrix.map_map, Matrix.map_map, ← RingHom.coe_comp, ← RingHom.coe_comp, h]
  have hEmat : ((universalMatrix d r J.1 J.2).map
        ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
          (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ))).inv)).map
        ⇑(CommRingCat.Hom.hom (Scheme.Hom.appTop
          (X := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
          (Y := Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ)))
          ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)))
      = (imageMatrix d r I.1 J.1 I.2 J.2).map
        ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
          (Localization.Away (minorDet d r I.1 J.1 I.2 J.2)))).inv) := by
    have h := congrArg CommRingCat.Hom.hom hbe
    simp only [CommRingCat.hom_comp, CommRingCat.hom_ofHom] at h
    -- the Cells identity, restated with the `RingHom`-coercion of the `AlgHom` (defeq,
    -- absorbed by the `have` check — the `⇑↑f` coercion bridge blocks a positional rw)
    have hXJ : (universalMatrix d r J.1 J.2).map
          ⇑(transitionPreMap d r I.1 J.1 I.2 J.2).toRingHom
        = imageMatrix d r I.1 J.1 I.2 J.2 :=
      universalMatrix_map_transitionPreMap d r I.1 J.1 I.2 J.2
    rw [Matrix.map_map, ← RingHom.coe_comp, h, RingHom.coe_comp, ← Matrix.map_map, hXJ]
  -- (4) the matrix-level overlap identity `X^I_J · ((X^I_J)⁻¹ X^I) = X^I` over `R^I_J`,
  -- σ-transported to the overlap's global sections
  have hmin_img : universalMinor d r I.1 J.1 I.2 J.2 * imageMatrix d r I.1 J.1 I.2 J.2
      = (universalMatrix d r I.1 I.2).map
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
            (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))) := by
    rw [imageMatrix]
    -- term-mode reassociation (the heterogeneous rectangular `HMul` blocks a
    -- positional `rw [← Matrix.mul_assoc]`)
    calc universalMinor d r I.1 J.1 I.2 J.2 * (universalMinorInv d r I.1 J.1 I.2 J.2 *
          (universalMatrix d r I.1 I.2).map
            (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
              (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
        = (universalMinor d r I.1 J.1 I.2 J.2 * universalMinorInv d r I.1 J.1 I.2 J.2) *
          (universalMatrix d r I.1 I.2).map
            (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
              (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))) :=
          (Matrix.mul_assoc _ _ _).symm
      _ = (universalMatrix d r I.1 I.2).map
            (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
              (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))) := by
          rw [(universalMinorInv_mul_cancel d r I.1 J.1 I.2 J.2).2, Matrix.one_mul]
  have hmat : (CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
        (minorDet d r I.1 J.1 I.2 J.2)))).inv).mapMatrix (universalMinor d r I.1 J.1 I.2 J.2)
      * (imageMatrix d r I.1 J.1 I.2 J.2).map
        ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
          (minorDet d r I.1 J.1 I.2 J.2)))).inv)
      = ((universalMatrix d r I.1 I.2).map
          (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
            (Localization.Away (minorDet d r I.1 J.1 I.2 J.2)))).map
        ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
          (minorDet d r I.1 J.1 I.2 J.2)))).inv) := by
    rw [RingHom.mapMatrix_apply, ← Matrix.map_mul, hmin_img]
  -- (5) per-chart pullback expansions (`matrixEndRect_pullback` in glue-datum phrasing;
  -- the chartIncl↔`(theGlueData).f` defeq is absorbed by the `have` checks)
  have h2 : (Scheme.Modules.pullback ((theGlueData d r).f I J)).map
        (chartQuotientMap d r I.1 I.2)
      = (Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin r)).hom ≫
        matrixEndRect (((universalMatrix d r I.1 I.2).map
            ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
              (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ))).inv)).map
          ⇑(CommRingCat.Hom.hom (Scheme.Hom.appTop
            (X := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
            (Y := Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)))
            ((theGlueData d r).f I J)))) ≫
        (Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin d)).inv := by
    rw [chartQuotientMap_eq_matrixEndRect]
    exact matrixEndRect_pullback _ _
  have h5 : (Scheme.Modules.pullback ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)).map
        (chartQuotientMap d r J.1 J.2)
      = (Scheme.Modules.pullbackFreeIso
          ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) (Fin r)).hom ≫
        matrixEndRect (((universalMatrix d r J.1 J.2).map
            ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
              (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ))).inv)).map
          ⇑(CommRingCat.Hom.hom (Scheme.Hom.appTop
            (X := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
            (Y := Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ)))
            ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)))) ≫
        (Scheme.Modules.pullbackFreeIso
          ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) (Fin d)).inv := by
    rw [chartQuotientMap_eq_matrixEndRect]
    exact matrixEndRect_pullback _ _
  -- (6) the bundle transition's inverse, in `Q ≫ matrixEnd ≫ Q⁻¹` form
  have h6 : (bundleTransitionData d r I J).inv
      = (Scheme.Modules.pullbackFreeIso
          ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) (Fin d)).hom ≫
        matrixEnd ((CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
          (minorDet d r I.1 J.1 I.2 J.2)))).inv).mapMatrix
          (universalMinor d r I.1 J.1 I.2 J.2)) ≫
        (Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin d)).inv := by
    change (bundleTransition d r I.1 J.1 I.2 J.2).inv = _
    simp only [bundleTransition, Iso.trans_inv, Iso.symm_inv, matrixToFreeIso_inv,
      Category.assoc]
    rfl
  -- (7) collapse each side's `Q⁻¹ ≫ (chart pullback) ≫ …` core to the common
  -- `matrixEndRect(σ X^I-loc) ≫ Q_d⁻¹` normal form (fresh goals — the rewrites fire on
  -- the haves' own spellings, away from the statement's mixed-provenance comp nodes)
  have hLfin : (Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin r)).inv ≫
        ((Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin r)).hom ≫
          matrixEndRect (((universalMatrix d r I.1 I.2).map
              ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
                (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ))).inv)).map
            ⇑(CommRingCat.Hom.hom (Scheme.Hom.appTop
              (X := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
              (Y := Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)))
              ((theGlueData d r).f I J)))) ≫
          (Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin d)).inv)
      = matrixEndRect (((universalMatrix d r I.1 I.2).map
            (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
              (Localization.Away (minorDet d r I.1 J.1 I.2 J.2)))).map
          ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
            (minorDet d r I.1 J.1 I.2 J.2)))).inv)) ≫
        (Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin d)).inv := by
    -- term-mode: the `Matrix.map` carrier implicit differs between elaboration contexts,
    -- so a positional `rw [hBmat]` cannot match; `congrArg` absorbs it by defeq
    refine (Iso.inv_hom_id_assoc _ _).trans ?_
    exact congrArg (fun m => matrixEndRect m ≫
      (Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin d)).inv) hBmat
  have hRfin : (Scheme.Modules.pullbackFreeIso
        ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) (Fin r)).inv ≫
        (((Scheme.Modules.pullbackFreeIso
            ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) (Fin r)).hom ≫
          matrixEndRect (((universalMatrix d r J.1 J.2).map
              ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
                (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ))).inv)).map
            ⇑(CommRingCat.Hom.hom (Scheme.Hom.appTop
              (X := Spec (CommRingCat.of (Localization.Away (minorDet d r I.1 J.1 I.2 J.2))))
              (Y := Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ J.1}) ℤ)))
              ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)))) ≫
          (Scheme.Modules.pullbackFreeIso
            ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) (Fin d)).inv) ≫
        ((Scheme.Modules.pullbackFreeIso
            ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) (Fin d)).hom ≫
          matrixEnd ((CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
            (minorDet d r I.1 J.1 I.2 J.2)))).inv).mapMatrix
            (universalMinor d r I.1 J.1 I.2 J.2)) ≫
          (Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin d)).inv))
      = matrixEndRect (((universalMatrix d r I.1 I.2).map
            (algebraMap (MvPolynomial (Fin d × {q : Fin r // q ∉ I.1}) ℤ)
              (Localization.Away (minorDet d r I.1 J.1 I.2 J.2)))).map
          ⇑(CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of (Localization.Away
            (minorDet d r I.1 J.1 I.2 J.2)))).inv)) ≫
        (Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin d)).inv := by
    simp only [Category.assoc, Iso.inv_hom_id_assoc]
    -- term-mode matrix comparison (the `Matrix.map` carrier implicit blocks positional rw)
    refine (matrixEndRect_comp_assoc _ _ _).trans ?_
    exact congrArg (fun m => matrixEndRect m ≫
      (Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin d)).inv)
      ((congrArg (fun m => (CommRingCat.Hom.hom (Scheme.ΓSpecIso (CommRingCat.of
          (Localization.Away (minorDet d r I.1 J.1 I.2 J.2)))).inv).mapMatrix
          (universalMinor d r I.1 J.1 I.2 J.2) * m) hEmat).trans hmat)
  -- (8) assemble in pure term-mode (positional `rw`/`simp` cannot reassociate the
  -- statement's mixed-provenance comp nodes under the `X.Modules` diamond)
  have hglue' : ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) ≫ (theGlueData d r).ι J
      = (theGlueData d r).f I J ≫ (theGlueData d r).ι I := by
    rw [Category.assoc]; exact (theGlueData d r).glue_condition I J
  exact ((congrArg ((Scheme.Modules.pullbackComp ((theGlueData d r).f I J)
        ((theGlueData d r).ι I)).inv.app (SheafOfModules.free
          (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫ ·)
        ((Scheme.Modules.pullback ((theGlueData d r).f I J)).map_comp
          (Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι I) (Fin r)).hom
          (chartQuotientMap d r I.1 I.2))).trans <|
    (Scheme.Modules.pullbackComp_inv_app_free_map_assoc
        ((theGlueData d r).f I J) ((theGlueData d r).ι I) (Fin r)
        ((Scheme.Modules.pullback ((theGlueData d r).f I J)).map
          (chartQuotientMap d r I.1 I.2))).trans <|
    (congrArg (fun m => (Scheme.Modules.pullbackFreeIso
        ((theGlueData d r).f I J ≫ (theGlueData d r).ι I) (Fin r)).hom ≫
        (Scheme.Modules.pullbackFreeIso ((theGlueData d r).f I J) (Fin r)).inv ≫ m)
      h2).trans <|
    congrArg ((Scheme.Modules.pullbackFreeIso
        ((theGlueData d r).f I J ≫ (theGlueData d r).ι I) (Fin r)).hom ≫ ·) hLfin).trans
    ((congrArg (fun m => (Scheme.Modules.pullbackCongr hglue').inv.app
          (SheafOfModules.free (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫
          (Scheme.Modules.pullbackComp ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)
            ((theGlueData d r).ι J)).inv.app (SheafOfModules.free
              (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫ m ≫
          (bundleTransitionData d r I J).inv)
        ((Scheme.Modules.pullback ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)).map_comp
          (Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι J) (Fin r)).hom
          (chartQuotientMap d r J.1 J.2))).trans <|
      (congrArg (fun m => (Scheme.Modules.pullbackCongr hglue').inv.app
          (SheafOfModules.free (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫
          (Scheme.Modules.pullbackComp ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)
            ((theGlueData d r).ι J)).inv.app (SheafOfModules.free
              (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫ m)
        (Category.assoc
          ((Scheme.Modules.pullback ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)).map
            (Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι J) (Fin r)).hom)
          ((Scheme.Modules.pullback ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)).map
            (chartQuotientMap d r J.1 J.2))
          (bundleTransitionData d r I J).inv)).trans <|
      (congrArg ((Scheme.Modules.pullbackCongr hglue').inv.app
          (SheafOfModules.free (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫ ·)
        (Scheme.Modules.pullbackComp_inv_app_free_map_assoc
          ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) ((theGlueData d r).ι J) (Fin r)
          ((Scheme.Modules.pullback ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)).map
              (chartQuotientMap d r J.1 J.2) ≫
            (bundleTransitionData d r I J).inv))).trans <|
      (Scheme.Modules.pullbackCongr_inv_app_free_assoc hglue' (Fin r)
        ((Scheme.Modules.pullbackFreeIso
            ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) (Fin r)).inv ≫
          (Scheme.Modules.pullback ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)).map
            (chartQuotientMap d r J.1 J.2) ≫
          (bundleTransitionData d r I J).inv)).trans <|
      (congrArg (fun m => (Scheme.Modules.pullbackFreeIso
          ((theGlueData d r).f I J ≫ (theGlueData d r).ι I) (Fin r)).hom ≫
          (Scheme.Modules.pullbackFreeIso
            ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) (Fin r)).inv ≫ m)
        (congrArg₂ (· ≫ ·) h5 h6)).trans <|
      congrArg ((Scheme.Modules.pullbackFreeIso
          ((theGlueData d r).f I J ≫ (theGlueData d r).ι I) (Fin r)).hom ≫ ·) hRfin).symm

/-- **Adjunction transpose of the chart-overlap condition**
(`lem:gr_tautologicalQuotientComponent_transpose`): the `(I,J)`-component of the descent
(equalizing) condition consumed by `glueLift` for the family of chart-quotient transposes
`tautologicalQuotientComponent` holds iff the pullback-level identity
`g_{I,J} ∘ f_{IJ}^* u^I = (t_{IJ} ≫ f_{JI})^* u^J` does (all comparisons through the
pseudofunctor casts) — the statement of `tautologicalQuotient_overlap`. Instance of the
generic `Scheme.Modules.glueLift_cond_iff`. -/
theorem tautologicalQuotientComponent_transpose (d r : ℕ) (I J : (theGlueData d r).J) :
    (tautologicalQuotientComponent d r I ≫
        ((Scheme.Modules.pushforward ((theGlueData d r).ι I)).map
          ((Scheme.Modules.pullbackPushforwardAdjunction ((theGlueData d r).f I J)).unit.app
            (SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d))) ≫
        (Scheme.Modules.pushforwardComp ((theGlueData d r).f I J)
          ((theGlueData d r).ι I)).hom.app
          ((Scheme.Modules.pullback ((theGlueData d r).f I J)).obj
            (SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d))))
      = tautologicalQuotientComponent d r J ≫
        ((Scheme.Modules.pushforward ((theGlueData d r).ι J)).map
          ((Scheme.Modules.pullbackPushforwardAdjunction
            ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)).unit.app
            (SheafOfModules.free (R := ((theGlueData d r).U J).ringCatSheaf) (Fin d))) ≫
        (Scheme.Modules.pushforwardComp ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)
          ((theGlueData d r).ι J)).hom.app
          ((Scheme.Modules.pullback ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)).obj
            (SheafOfModules.free (R := ((theGlueData d r).U J).ringCatSheaf) (Fin d))) ≫
        (Scheme.Modules.pushforward
          (((theGlueData d r).t I J ≫ (theGlueData d r).f J I) ≫ (theGlueData d r).ι J)).map
          (bundleTransitionData d r I J).inv ≫
        (Scheme.Modules.pushforwardCongr
          (show ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) ≫ (theGlueData d r).ι J
              = (theGlueData d r).f I J ≫ (theGlueData d r).ι I by
            rw [Category.assoc]; exact (theGlueData d r).glue_condition I J)).hom.app
          ((Scheme.Modules.pullback ((theGlueData d r).f I J)).obj
            (SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d)))))
    ↔ ((Scheme.Modules.pullbackComp ((theGlueData d r).f I J) ((theGlueData d r).ι I)).inv.app
          (SheafOfModules.free (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫
        (Scheme.Modules.pullback ((theGlueData d r).f I J)).map
          ((Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι I) (Fin r)).hom ≫
            chartQuotientMap d r I.1 I.2)
      = (Scheme.Modules.pullbackCongr
            (show ((theGlueData d r).t I J ≫ (theGlueData d r).f J I) ≫ (theGlueData d r).ι J
                = (theGlueData d r).f I J ≫ (theGlueData d r).ι I by
              rw [Category.assoc]; exact (theGlueData d r).glue_condition I J)).inv.app
          (SheafOfModules.free (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫
        (Scheme.Modules.pullbackComp ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)
          ((theGlueData d r).ι J)).inv.app
          (SheafOfModules.free (R := ((theGlueData d r).glued).ringCatSheaf) (Fin r)) ≫
        (Scheme.Modules.pullback ((theGlueData d r).t I J ≫ (theGlueData d r).f J I)).map
          ((Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι J) (Fin r)).hom ≫
            chartQuotientMap d r J.1 J.2) ≫
        (bundleTransitionData d r I J).inv) :=
  Scheme.Modules.glueLift_cond_iff (theGlueData d r)
    (fun K => SheafOfModules.free (R := ((theGlueData d r).U K).ringCatSheaf) (Fin d))
    (bundleTransitionData d r)
    (fun K => (Scheme.Modules.pullbackFreeIso ((theGlueData d r).ι K) (Fin r)).hom ≫
      chartQuotientMap d r K.1 K.2) I J

/-- The **tautological quotient** `u : O^r ↠ U` (`def:tautological_quotient`): the global
surjection assembled from the chart quotients `u^I` (`chartQuotientMap`), compatible with
the bundle gluing of `universalQuotient`. Since `universalQuotient` is the descent
equalizer of pushforwards, the morphism is `glueLift` of the per-chart adjoint
transposes (`tautologicalQuotientComponent`); the equalizing condition — the chart
compatibility `g_{IJ} ∘ f_{IJ}^* u^I = (t_{IJ} ≫ f_{JI})^* u^J`, whose matrix content is
`X^J = (X^I_J)⁻¹ X^I` (`universalMatrix_map_transitionPreMap` / `imageMatrix`) — is
`tautologicalQuotient_overlap`, transposed through the adjunction by
`tautologicalQuotientComponent_transpose`. -/
noncomputable def tautologicalQuotient (d r : ℕ) :
    SheafOfModules.free (R := (scheme d r).ringCatSheaf) (Fin r) ⟶ universalQuotient d r :=
  Scheme.Modules.glueLift (theGlueData d r)
    (fun I => SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d))
    (bundleTransitionData d r)
    (fun I => bundleTransition_self d r I.1 I.2)
    (fun I J K => bundleTransition_cocycle d r I J K)
    (fun I => tautologicalQuotientComponent d r I)
    (fun p => (tautologicalQuotientComponent_transpose d r p.1 p.2).mpr
      (tautologicalQuotient_overlap d r p.1 p.2))

/-! ## The functor of points and the universal property

The Grassmannian functor sends a scheme `T` to the set of *equivalence classes* of
rank-`d` quotients `q : O_T^r ↠ F` with `F` locally free of rank `d`. We encode a single
such quotient as the structure `RankQuotient r d T`, the equivalence as `RankQuotient.Rel`
(an isomorphism of the targets commuting with the quotient maps), and the functor's value
at `T` as the quotient `Quotient (rqSetoid r d T)`. The pullback action `rqPullback`
together with `pullbackFreeIso`/`pullback_isLocallyFreeOfRank` (and the fact that the
pullback functor preserves epimorphisms, being a left adjoint) realise functoriality.

Because a sheaf of modules `F : T.Modules` is a large object, this quotient lives in
`Type 1` (not `Type 0` as the original scaffold signature stated); the corrected universe
is the only change to the pinned signature, and it is forced — the substantive content is
unchanged. -/

/-- A **rank-`d` quotient of `O_T^r`** on a scheme `T`: a sheaf of modules `F` on `T`,
locally free of rank `d`, together with an epimorphism `q : O_T^r ↠ F`. This is the
unbundled datum whose equivalence classes form the value of the Grassmannian functor. -/
structure RankQuotient (r d : ℕ) (T : Scheme.{0}) where
  /-- The quotient sheaf. -/
  F : T.Modules
  /-- The quotient map out of the trivial rank-`r` bundle. -/
  q : SheafOfModules.free (R := T.ringCatSheaf) (Fin r) ⟶ F
  /-- The quotient map is an epimorphism (surjective). -/
  epi : Epi q
  /-- The quotient sheaf is locally free of rank `d`. -/
  locFree : SheafOfModules.IsLocallyFreeOfRank F d

/-- Two rank-`d` quotients are **equivalent** when there is an isomorphism of the targets
commuting with the quotient maps (equivalently, when the kernels of the quotient maps
coincide). -/
def RankQuotient.Rel {r d : ℕ} {T : Scheme.{0}} (x y : RankQuotient r d T) : Prop :=
  ∃ f : x.F ≅ y.F, x.q ≫ f.hom = y.q

lemma RankQuotient.rel_refl {r d : ℕ} {T : Scheme.{0}} (x : RankQuotient r d T) : x.Rel x :=
  ⟨Iso.refl _, Category.comp_id _⟩

lemma RankQuotient.rel_symm {r d : ℕ} {T : Scheme.{0}} {x y : RankQuotient r d T}
    (h : x.Rel y) : y.Rel x := by
  obtain ⟨f, hf⟩ := h
  exact ⟨f.symm, by rw [Iso.symm_hom, Iso.comp_inv_eq]; exact hf.symm⟩

lemma RankQuotient.rel_trans {r d : ℕ} {T : Scheme.{0}} {x y z : RankQuotient r d T}
    (h1 : x.Rel y) (h2 : y.Rel z) : x.Rel z := by
  obtain ⟨f, hf⟩ := h1; obtain ⟨g, hg⟩ := h2
  -- term-mode (the `T.Modules` def-diamond blocks positional category `rw`)
  exact ⟨f ≪≫ g,
    (congrArg (x.q ≫ ·) (Iso.trans_hom f g)).trans <|
      (Category.assoc x.q f.hom g.hom).symm.trans <|
        (congrArg (· ≫ g.hom) hf).trans hg⟩

/-- The equivalence-of-quotients setoid on `RankQuotient r d T`. -/
instance rqSetoid (r d : ℕ) (T : Scheme.{0}) : Setoid (RankQuotient r d T) where
  r := RankQuotient.Rel
  iseqv := ⟨RankQuotient.rel_refl, RankQuotient.rel_symm, RankQuotient.rel_trans⟩

/-- The **pullback action** on a rank-`d` quotient: pull the target sheaf and quotient map
back along `ψ`, re-presenting the source as the trivial bundle via `pullbackFreeIso`. The
result is again an epimorphism (pullback preserves epis) onto a rank-`d` locally free sheaf
(`pullback_isLocallyFreeOfRank`). -/
noncomputable def rqPullback {r d : ℕ} {T' T : Scheme.{0}} (ψ : T' ⟶ T)
    (x : RankQuotient r d T) : RankQuotient r d T' where
  F := (Scheme.Modules.pullback ψ).obj x.F
  q := (Scheme.Modules.pullbackFreeIso ψ (Fin r)).inv ≫ (Scheme.Modules.pullback ψ).map x.q
  epi :=
    -- fully explicit: the def-diamond on `T.Modules` blocks `Epi`-instance search, so
    -- `x.epi` is threaded through `map_epi`/`epi_comp` by hand
    @CategoryTheory.epi_comp _ _ _ _ _
      (Scheme.Modules.pullbackFreeIso ψ (Fin r)).inv inferInstance
      ((Scheme.Modules.pullback ψ).map x.q)
      (@CategoryTheory.Functor.map_epi _ _ _ _ (Scheme.Modules.pullback ψ) inferInstance _ _
        x.q x.epi)
  locFree := Scheme.Modules.pullback_isLocallyFreeOfRank ψ x.locFree

/-- The pullback action respects the equivalence relation, hence descends to quotients. -/
lemma rqPullback_rel {r d : ℕ} {T' T : Scheme.{0}} (ψ : T' ⟶ T)
    {x y : RankQuotient r d T} (h : x.Rel y) :
    (rqPullback ψ x).Rel (rqPullback ψ y) := by
  obtain ⟨f, hf⟩ := h
  refine ⟨(Scheme.Modules.pullback ψ).mapIso f, ?_⟩
  change ((Scheme.Modules.pullbackFreeIso ψ (Fin r)).inv ≫ (Scheme.Modules.pullback ψ).map x.q) ≫
      (Scheme.Modules.pullback ψ).map f.hom
    = (Scheme.Modules.pullbackFreeIso ψ (Fin r)).inv ≫ (Scheme.Modules.pullback ψ).map y.q
  rw [Category.assoc, ← (Scheme.Modules.pullback ψ).map_comp]
  exact congrArg
    (fun m => (Scheme.Modules.pullbackFreeIso ψ (Fin r)).inv ≫ (Scheme.Modules.pullback ψ).map m) hf

end AlgebraicGeometry.Grassmannian

namespace AlgebraicGeometry.Grassmannian

/-- The **Grassmannian functor** `Grass(r,d)` (`def:grassmannian_functor`): the
contravariant functor from schemes to sets sending `T` to the set of equivalence classes
of rank-`d` locally free quotients `q : O_T^r ↠ F`, acting on morphisms by pullback.

The object and morphism assignments are complete; the functoriality laws (`map_id`,
`map_comp`) are discharged — via the naturality of the pseudofunctor comparison isomorphisms
`pullbackId`/`pullbackComp` of `Scheme.Modules.pullback` — through the free-sheaf coherences
`pullbackFreeIso_id`/`pullbackFreeIso_comp`, which reduce by coproduct extensionality to the
unit-level coherences `pullbackObjUnitToUnit_id`/`pullbackObjUnitToUnit_comp`. Fully proved. -/
noncomputable def functor (d r : ℕ) : Scheme.{0}ᵒᵖ ⥤ Type 1 where
  obj T := Quotient (rqSetoid r d T.unop)
  map {X Y} g := TypeCat.ofHom (Quotient.map (rqPullback (r := r) (d := d) g.unop)
    (fun _ _ h => rqPullback_rel g.unop h))
  map_id X := by
    -- reduce to the equivalence relation on representatives
    ext z
    induction z using Quotient.ind with
    | _ x =>
      change Quotient.mk _ (rqPullback (𝟙 X).unop x) = Quotient.mk _ x
      -- the canonical iso `(𝟙)^* x.F ≅ x.F` is `pullbackId`; the quotient-map equation it
      -- must satisfy reduces, by naturality of `pullbackId.hom`, to the free coherence
      -- `pullbackFreeIso (𝟙) = (pullbackId).app (free _)`, hence to the unit-level identity
      -- `pullbackObjUnitToUnit (𝟙) = (pullbackId).app unit`. That coherence between
      -- `SheafOfModules.pullbackObjFreeIso` and Mathlib's `pullbackId` is the open obstacle.
      refine Quotient.sound ⟨(Scheme.Modules.pullbackId X.unop).app x.F, ?_⟩
      -- unfold `(rqPullback (𝟙) x).q` and `(pullbackId.app x.F).hom` (defeq)
      change ((Scheme.Modules.pullbackFreeIso (𝟙 X.unop) (Fin r)).inv ≫
          (Scheme.Modules.pullback (𝟙 X.unop)).map x.q) ≫
          (Scheme.Modules.pullbackId X.unop).hom.app x.F = x.q
      rw [Category.assoc, (Scheme.Modules.pullbackId X.unop).hom.naturality x.q,
        ← Scheme.Modules.pullbackFreeIso_id]
      -- `(𝟭).map x.q = x.q` is only defeq, so close by term (rw can't see through it)
      exact Iso.inv_hom_id_assoc _ _
  map_comp {X Y Z} f g := by
    ext z
    induction z using Quotient.ind with
    | _ x =>
      change Quotient.mk _ (rqPullback (f ≫ g).unop x)
        = Quotient.mk _ (rqPullback g.unop (rqPullback f.unop x))
      -- the canonical iso `(g.unop ≫ f.unop)^* x.F ≅ g.unop^*(f.unop^* x.F)` is `pullbackComp`;
      -- the quotient-map equation reduces, by naturality, to the composite free coherence
      -- relating `pullbackFreeIso (g.unop ≫ f.unop)` to `pullbackFreeIso g.unop`/`f.unop`
      -- through `pullbackComp` — the composite analogue of the `map_id` obstacle.
      refine Quotient.sound ⟨((Scheme.Modules.pullbackComp g.unop f.unop).app x.F).symm, ?_⟩
      -- unfold `(rqPullback (g∘f) x).q` and `(pullbackComp.app x.F).symm.hom` (defeq), writing
      -- the composite as `g.unop ≫ f.unop` so the `pullbackComp` naturality matches syntactically
      change ((Scheme.Modules.pullbackFreeIso (g.unop ≫ f.unop) (Fin r)).inv ≫
          (Scheme.Modules.pullback (g.unop ≫ f.unop)).map x.q) ≫
          (Scheme.Modules.pullbackComp g.unop f.unop).inv.app x.F
        = (rqPullback g.unop (rqPullback f.unop x)).q
      -- expose the `pullbackComp.inv` naturality square (mirrors the `map_id` reduction)
      rw [Category.assoc, (Scheme.Modules.pullbackComp g.unop f.unop).inv.naturality x.q]
      -- the composite free coherence (`pullbackFreeIso_comp`) in inverse form: invert both
      -- sides of the iso equation `pullbackComp.hom.app free ≫ pfba.hom = (pullback g).map pfa.hom
      -- ≫ pfb.hom`.
      have hstar : (Scheme.Modules.pullbackFreeIso (g.unop ≫ f.unop) (Fin r)).inv ≫
            (Scheme.Modules.pullbackComp g.unop f.unop).inv.app (SheafOfModules.free (Fin r))
          = (Scheme.Modules.pullbackFreeIso g.unop (Fin r)).inv ≫
            (Scheme.Modules.pullback g.unop).map
              (Scheme.Modules.pullbackFreeIso f.unop (Fin r)).inv := by
        have hH := Scheme.Modules.pullbackFreeIso_comp f.unop g.unop (Fin r)
        rw [← cancel_epi ((Scheme.Modules.pullbackComp g.unop f.unop).hom.app
          (SheafOfModules.free (Fin r)) ≫
          (Scheme.Modules.pullbackFreeIso (g.unop ≫ f.unop) (Fin r)).hom)]
        trans (𝟙 _)
        · rw [Category.assoc, Iso.hom_inv_id_assoc]
          exact (Scheme.Modules.pullbackComp g.unop f.unop).hom_inv_id_app _
        · rw [hH]; simp
      -- whisker `hstar` by `≫ (pullback f ⋙ pullback g).map x.q` and refold the RHS via
      -- `map_comp` into `(rqPullback g (rqPullback f x)).q`.
      exact (Category.assoc _ _ _).symm.trans
        ((congrArg (· ≫ (Scheme.Modules.pullback f.unop ⋙
              Scheme.Modules.pullback g.unop).map x.q) hstar).trans
          ((Category.assoc _ _ _).trans
            (congrArg ((Scheme.Modules.pullbackFreeIso g.unop (Fin r)).inv ≫ ·)
              ((Scheme.Modules.pullback g.unop).map_comp
                (Scheme.Modules.pullbackFreeIso f.unop (Fin r)).inv
                ((Scheme.Modules.pullback f.unop).map x.q)).symm)))

/-- **Chart restriction of the universal quotient sheaf**: over the `I`-th chart, the
universal bundle `U` restricts to the free rank-`d` sheaf — the instantiation of the
descent restriction isomorphism `Scheme.Modules.glueRestrictionIso` at the Grassmannian
glue data. (Its underlying morphism is the adjoint transpose of the `I`-th
descent-equalizer projection; iso-ness rides on
`Scheme.Modules.isIso_glueRestrictionHom`.) -/
noncomputable def universalQuotient_restrictionIso (d r : ℕ) (I : (theGlueData d r).J) :
    (Scheme.Modules.pullback ((theGlueData d r).ι I)).obj (universalQuotient d r)
      ≅ SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d) :=
  Scheme.Modules.glueRestrictionIso (theGlueData d r)
    (fun I => SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d))
    (bundleTransitionData d r)
    (fun I => bundleTransition_self d r I.1 I.2)
    (fun I J K => bundleTransition_cocycle d r I J K) I

/-- **The universal quotient sheaf is locally free of rank `d`**
(`thm:grassmannian_universal_property`, first ingredient): the chart images
`{ι_I(U^I)}` cover the glued scheme, and on each member the restriction of
`universalQuotient` is identified with `O^d` by transporting the descent restriction
isomorphism `universalQuotient_restrictionIso` along the factorization
`ι_I = isoOpensRange.hom ≫ opensRange.ι`. -/
theorem universalQuotient_isLocallyFreeOfRank (d r : ℕ) :
    SheafOfModules.IsLocallyFreeOfRank (universalQuotient d r) d := by
  refine ⟨(theGlueData d r).J, fun I => ((theGlueData d r).ι I).opensRange, ?_, fun I => ?_⟩
  · rw [eq_top_iff]
    intro x _
    obtain ⟨I, y, rfl⟩ := (theGlueData d r).ι_jointly_surjective x
    exact TopologicalSpace.Opens.mem_iSup.mpr ⟨I, y, rfl⟩
  · -- transport the chart restriction iso along `ι_I = isoOpensRange.hom ≫ opensRange.ι`,
    -- inverting the chart-parametrization iso via the pullback pseudofunctor
    refine ⟨?_⟩
    letI ι := (theGlueData d r).ι I
    letI e := ι.isoOpensRange
    exact (Scheme.Modules.pullbackId _).symm.app _ ≪≫
      (Scheme.Modules.pullbackCongr (Iso.inv_hom_id e).symm).app _ ≪≫
      ((Scheme.Modules.pullbackComp e.inv e.hom).app _).symm ≪≫
      (Scheme.Modules.pullback e.inv).mapIso
        ((Scheme.Modules.pullbackComp e.hom ι.opensRange.ι).app (universalQuotient d r) ≪≫
          (Scheme.Modules.pullbackCongr (ι.isoOpensRange_hom_ι)).app (universalQuotient d r) ≪≫
          universalQuotient_restrictionIso d r I) ≪≫
      Scheme.Modules.pullbackFreeIso e.inv (Fin d) ≪≫
      SheafOfModules.freeFunctor.mapIso (Equiv.ulift.symm.toIso)

/-- **The tautological quotient is an epimorphism**
(`thm:grassmannian_universal_property`, second ingredient).

ROUTE (scoped iter-066, not yet formalized): epi-ness is chart-local. Transposing
`glueLift_glueProj` along the chart immersion shows
`ι_I^* (tautologicalQuotient) ≫ glueRestrictionHom I` equals (up to the free-pullback
comparison `pullbackFreeIso`) the chart quotient `chartQuotientMap d r I.1 I.2`, which
is a (split) epi (`chartQuotientMap_epi`). A family of morphisms out of the glued
sheaf is jointly reflected by the chart restrictions (the separation half of the sheaf
condition of the descent equalizer), so `q ≫ u = q ≫ v → u = v` follows once all chart
restrictions of `q` are epi. The joint-reflection lemma is the missing ingredient —
it shares its proof skeleton with `isIso_glueRestrictionHom` (mono-ness of
`E ⟶ ∏ (ι_I)_* M_I`). -/
theorem tautologicalQuotient_epi (d r : ℕ) : Epi (tautologicalQuotient d r) := by
  sorry

/-- **The tautological point of the Grassmannian**: the rank-`d` locally free quotient
`u : O^r ↠ U` on `Gr(d,r)` itself, packaged as a `RankQuotient`. Pulling it back along
`ψ : T ⟶ Gr(d,r)` realizes the forward direction of the universal property. -/
noncomputable def tautologicalRankQuotient (d r : ℕ) : RankQuotient r d (scheme d r) where
  F := universalQuotient d r
  q := tautologicalQuotient d r
  epi := tautologicalQuotient_epi d r
  locFree := universalQuotient_isLocallyFreeOfRank d r

/-- **The local-to-global inverse of the universal property** (Nitsure §1): a rank-`d`
locally free quotient `q : O_T^r ↠ F` determines a morphism `T ⟶ Gr(d,r)`.

ROUTE (scoped iter-066, not yet formalized): for each chart index `I` (a `d`-element
subset of `Fin r`), the locus `T_I ⊆ T` where the composite `O_T^d ⟶ O_T^r ↠ F` of the
`I`-th coordinate inclusion with `q` is an isomorphism is open, and the `T_I` cover `T`
(local freeness + linear algebra: some `d×d` minor of a presenting matrix is invertible
near each point). On `T_I` the composite `O^r ↠ F ≅ O^d` is a `d×r` matrix of global
sections whose `I`-minor is `1`; its complementary entries define a ring map
`R^I ⟶ Γ(T_I, O)`, i.e. `T_I ⟶ U^I = Spec R^I`, compatible on overlaps by the
transition identity `X^J = (X^I_J)⁻¹ X^I` (`universalMatrix_map_transitionPreMap`).
These glue to `T ⟶ Gr(d,r)` by the openCover universal property
(`Scheme.GlueData.glueMorphisms` along the pullback cover `{T_I}`). -/
noncomputable def grPointOfRankQuotient {T : Scheme.{0}} (d r : ℕ)
    (x : RankQuotient r d T) : T ⟶ scheme d r :=
  sorry

/-- The inverse construction is constant on equivalence classes of quotients (an
isomorphism of targets commuting with the quotient maps induces the same chart loci,
the same matrices of sections, hence the same glued morphism). Not yet formalized;
rides on the route of `grPointOfRankQuotient`. -/
lemma grPointOfRankQuotient_rel {T : Scheme.{0}} (d r : ℕ)
    {x y : RankQuotient r d T} (h : x.Rel y) :
    grPointOfRankQuotient d r x = grPointOfRankQuotient d r y := by
  sorry

/-- **`Gr(d,r)` represents the Grassmannian functor** (`thm:grassmannian_universal_property`):
the tautological quotient `⟨U, u⟩` exhibits `Gr(d,r)` as the fine moduli space of rank-`d`
quotients of `O^r`, i.e. `Hom(T, Gr(d,r)) ≅ Grass(r,d)(T)` naturally in `T`.

The forward map sends `ψ : T ⟶ Gr(d,r)` to the pullback `ψ^*(U, u)` of the tautological
pair (`tautologicalRankQuotient`); naturality (`homEquiv_comp`) is the already-proven
pseudofunctoriality `(functor d r).map_comp` evaluated at the tautological point. The
inverse is the chart-by-chart construction `grPointOfRankQuotient`; the two inverse laws
are the remaining content (they consume the chart restriction isomorphisms
`universalQuotient_restrictionIso` and the glued-scheme universal property). -/
noncomputable def represents (d r : ℕ) (hd : 1 ≤ d) (hdr : d ≤ r) :
    (functor d r).RepresentableBy (scheme d r) where
  homEquiv {T} :=
    { toFun := fun ψ => Quotient.mk _ (rqPullback ψ (tautologicalRankQuotient d r))
      invFun := Quotient.lift (grPointOfRankQuotient d r)
        (fun _ _ h => grPointOfRankQuotient_rel d r h)
      left_inv := fun ψ => by
        -- `grPointOfRankQuotient (ψ^* (U, u)) = ψ`: chart-locally, the pulled-back
        -- matrix of sections is the `ψ`-image of the universal one, so the glued
        -- morphism is `ψ` by uniqueness in the glueMorphisms universal property.
        sorry
      right_inv := fun q => by
        -- `(grPointOfRankQuotient x)^* (U, u) ~ x`: the chart restriction isomorphisms
        -- identify the pullback of the universal pair with `x` chart by chart; the
        -- identifications agree on overlaps, hence glue (sheaf-condition of `Hom`).
        sorry }
  homEquiv_comp {T T'} f g := by
    -- pseudofunctoriality of `rqPullback` at the tautological point — this is
    -- `(functor d r).map_comp` evaluated at `⟦(U, u)⟧`
    have h := congrArg (fun m => m (Quotient.mk _ (tautologicalRankQuotient d r)))
      ((functor d r).map_comp g.op f.op)
    exact h

end AlgebraicGeometry.Grassmannian
