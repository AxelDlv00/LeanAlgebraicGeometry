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
scheme glue datum (confirmed), so this is an Archon-original construction. The
construction path (blueprint `def:scheme_modules_glue`): restrict to a chart through the
open-immersion pullback equivalence (`Scheme.Modules.overRestrictPullbackIso`) and glue
the local sections by locality of sections (`existsUnique_gluing'`).

NOTE (scaffold): the body and the module-cocycle hypotheses on `g` are still to be filled;
the transition data `g` (per-overlap pullback isos) is recorded in the signature, the
multiplicative cocycle conditions remain to be added before the construction is closed. -/

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
  sorry

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

/-! ## The universal quotient sheaf and the tautological quotient -/

/-- The **universal quotient sheaf** `U` on `Gr(d,r)` (`def:gr_universal_quotient_sheaf`):
the rank-`d` locally free sheaf obtained by gluing the free rank-`d` chart sheaves
`O_{U^I}^d` along the bundle transition cocycle `g_{I,J} = (X^I_J)⁻¹`.

NOTE (scaffold): rides on `Scheme.Modules.glue`; body to be filled once `glue` lands. -/
noncomputable def universalQuotient (d r : ℕ) : (scheme d r).Modules :=
  sorry

/-- The **tautological quotient** `u : O^r ↠ U` (`def:tautological_quotient`): the global
surjection assembled from the chart quotients `u^I` (`chartQuotientMap`), compatible with
the bundle gluing of `universalQuotient`.

NOTE (scaffold): rides on `Scheme.Modules.glue`; body to be filled once `glue` lands. -/
noncomputable def tautologicalQuotient (d r : ℕ) :
    SheafOfModules.free (R := (scheme d r).ringCatSheaf) (Fin r) ⟶ universalQuotient d r :=
  sorry

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
  have huA : adj₂.homEquiv c d (α.app c ≫ f) = adj₂.unit.app c ≫ R₂.map (α.app c ≫ f) :=
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
    (CategoryTheory.eq_whisker huB ((CategoryTheory.conjugateEquiv adj₁ adj₂ α).app d)).trans <|
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
      = (Scheme.Modules.pullback b).map (pullbackFreeIso a I).hom ≫ (pullbackFreeIso b I).hom := by
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
  set ιi := SheafOfModules.ιFree (R := Tx.ringCatSheaf) i with hιi
  have key_ba := SheafOfModules.pullback_map_ιFree_comp_pullbackObjFreeIso_hom
    (Scheme.Hom.toRingCatSheafHom (b ≫ a)) (I := I) i
  have key_a := SheafOfModules.pullback_map_ιFree_comp_pullbackObjFreeIso_hom
    (Scheme.Hom.toRingCatSheafHom a) (I := I) i
  have key_b := SheafOfModules.pullback_map_ιFree_comp_pullbackObjFreeIso_hom
    (Scheme.Hom.toRingCatSheafHom b) (I := I) i
  -- LHS: naturality of `pullbackComp.hom` + free-cofan comparison at `b ≫ a`.
  have hLHS :
      (SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom a) ⋙
          SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom b)).map ιi ≫
        (Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.free I) ≫
          (pullbackFreeIso (b ≫ a) I).hom
      = ((Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.unit Tx.ringCatSheaf) ≫
          SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom (b ≫ a))) ≫ ιi :=
    (Category.assoc _ _ _).symm.trans
      ((congrArg (· ≫ (pullbackFreeIso (b ≫ a) I).hom)
          ((Scheme.Modules.pullbackComp b a).hom.naturality ιi)).trans
        ((Category.assoc _ _ _).trans
          ((congrArg
              ((Scheme.Modules.pullbackComp b a).hom.app (SheafOfModules.unit Tx.ringCatSheaf) ≫ ·)
              key_ba).trans (Category.assoc _ _ _).symm)))
  -- RHS: split the composite functor, free-cofan comparison at `a` then at `b`.
  have hmid :
      (SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom a) ⋙
          SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom b)).map ιi ≫
        (Scheme.Modules.pullback b).map (pullbackFreeIso a I).hom
      = (Scheme.Modules.pullback b).map
            (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫
          (Scheme.Modules.pullback b).map ιi :=
    ((Scheme.Modules.pullback b).map_comp ((Scheme.Modules.pullback a).map ιi)
        (pullbackFreeIso a I).hom).symm.trans
      ((congrArg (Scheme.Modules.pullback b).map key_a).trans
        ((Scheme.Modules.pullback b).map_comp _ ιi))
  have hRHS :
      (SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom a) ⋙
          SheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom b)).map ιi ≫
        (Scheme.Modules.pullback b).map (pullbackFreeIso a I).hom ≫ (pullbackFreeIso b I).hom
      = ((Scheme.Modules.pullback b).map
            (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫
          SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom b)) ≫ ιi :=
    (Category.assoc _ _ _).symm.trans
      ((congrArg (· ≫ (pullbackFreeIso b I).hom) hmid).trans
        ((Category.assoc _ _ _).trans
          ((congrArg
              ((Scheme.Modules.pullback b).map
                  (SheafOfModules.pullbackObjUnitToUnit (Scheme.Hom.toRingCatSheafHom a)) ≫ ·)
              key_b).trans (Category.assoc _ _ _).symm)))
  exact hLHS.trans ((congrArg (· ≫ ιi) (pullbackObjUnitToUnit_comp a b)).trans hRHS.symm)

end AlgebraicGeometry.Scheme.Modules

namespace AlgebraicGeometry.Grassmannian

/-- The **Grassmannian functor** `Grass(r,d)` (`def:grassmannian_functor`): the
contravariant functor from schemes to sets sending `T` to the set of equivalence classes
of rank-`d` locally free quotients `q : O_T^r ↠ F`, acting on morphisms by pullback.

The object and morphism assignments are complete; the functoriality laws (`map_id`,
`map_comp`) are reduced — via the naturality of the pseudofunctor comparison isomorphisms
`pullbackId`/`pullbackComp` of `Scheme.Modules.pullback` — to the free-sheaf coherences
`pullbackFreeIso (𝟙 T) = (pullbackId T).app (free _)` and the analogue for a composite,
which in turn reduce to the unit-level identity `pullbackObjUnitToUnit (𝟙) =
(pullbackId).app unit` (and its composite analogue). These remaining coherences between
`SheafOfModules.pullbackObjFreeIso` and Mathlib's `pullbackId`/`pullbackComp` are
`whnf`-heavy and left as the sole open obstacle. -/
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
      -- Remaining: the composite free coherence (analogue of `pullbackFreeIso_id`)
      --   `pullbackFreeIso (g.unop ≫ f.unop) |>.inv ≫ (pullbackComp g.unop f.unop).inv.app free
      --      = pullbackFreeIso g.unop |>.inv ≫ (pullback g.unop).map (pullbackFreeIso f.unop).inv`
      -- which reduces, by the free cofan, to the unit coherence `pullbackObjUnitToUnit_comp`
      --   `comp.hom.app unit ≫ pbuu (g.unop ≫ f.unop)
      --      = (pullback g.unop).map (pbuu f.unop) ≫ pbuu g.unop`.
      -- That unit coherence must be discharged through `conjugateEquiv_pullbackComp_inv`
      -- (= `(pushforwardComp …).hom`) via `unit_conjugateEquiv`, keeping `pullbackComp` OPAQUE
      -- (the `leftAdjointCompIso` body whnf-times-out; `Iso.eq_inv_comp` and
      -- `simp [pullbackComp]` are both dead ends).
      sorry

/-- **`Gr(d,r)` represents the Grassmannian functor** (`thm:grassmannian_universal_property`):
the tautological quotient `⟨U, u⟩` exhibits `Gr(d,r)` as the fine moduli space of rank-`d`
quotients of `O^r`, i.e. `Hom(T, Gr(d,r)) ≅ Grass(r,d)(T)` naturally in `T`.

NOTE (scaffold): body (the local-to-global inverse construction of Nitsure §1) to be
filled once `functor`, `tautologicalQuotient`, and `Scheme.Modules.glue` land. -/
noncomputable def represents (d r : ℕ) (hd : 1 ≤ d) (hdr : d ≤ r) :
    (functor d r).RepresentableBy (scheme d r) :=
  sorry

end AlgebraicGeometry.Grassmannian
