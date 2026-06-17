import Mathlib
import AlgebraicJacobian.Picard.QuotScheme

/-!
# Glue-datum descent for sheaves of modules over a scheme

Generic `AlgebraicGeometry.Scheme.Modules` glue-datum / descent layer:
`glue` (equalizer-of-pushforwards construction), `glueLift`, and the full
restriction isomorphism tower that makes the descent effective.

Blueprint: `blueprint/src/chapters/Picard_GlueDescent.tex`.
-/

universe u

open CategoryTheory Limits Opposite

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

/-- `appLE` transport along an equality of morphisms: for equal `f = g` the induced
section maps `Γ(B, U) ⟶ Γ(A, W)` agree (the open-inequality witnesses are
proof-irrelevant). Generic `subst` helper for the overlap structure-sheaf
compatibility. Project-local. -/
lemma appLE_congr_mor {A B : Scheme.{u}} {f g : A ⟶ B} (h : f = g) (U : B.Opens)
    (W : A.Opens) (e : W ≤ f ⁻¹ᵁ U) (e' : W ≤ g ⁻¹ᵁ U) :
    f.appLE U W e = g.appLE U W e' := by
  subst h; rfl

/-- **Structure-sheaf compatibility of the chart-overlap square**: the two composite
section maps `Γ(U_i, V) ⟶ Γ(U_j, (t_ij ≫ f_ji) '' (f_ij⁻¹ V))` of the overlap square —
"through the glued scheme" (via `(ι_i.appIso V)⁻¹`, `ι_j.app`, and the opens identity
`glueData_preimage_image_eq`) and "through the overlap" (via `f_ij.app` and
`((t_ij ≫ f_ji).appIso)⁻¹`) — coincide. Both sides are the `appLE` of the two (equal)
composites `(t_ij ≫ f_ji) ≫ ι_j = f_ij ≫ ι_i` of the square; this is the
`pushforwardCongr` coherence consumed by `glueOverlapBaseChangeIso`. Project-local. -/
lemma glueData_overlap_appIso_compat (D : Scheme.GlueData.{0}) (i j : D.J)
    (V : (D.U i).Opens) :
    ((D.ι i).appIso V).inv ≫ (D.ι j).app ((D.ι i) ''ᵁ V) ≫
        (D.U j).presheaf.map (eqToHom (glueData_preimage_image_eq D i j V).symm).op
      = (D.f i j).app V ≫ ((D.t i j ≫ D.f j i).appIso ((D.f i j) ⁻¹ᵁ V)).inv := by
  have hsq : (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i := by
    rw [Category.assoc]; exact D.glue_condition i j
  rw [Iso.eq_comp_inv]
  simp only [Category.assoc]
  rw [Iso.inv_comp_eq]
  simp only [Scheme.Hom.appIso_hom', Scheme.Hom.app_eq_appLE,
    Scheme.Hom.appLE_map_assoc, Scheme.Hom.appLE_comp_appLE]
  exact appLE_congr_mor hsq _ _ _ _

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
        (fun V => eqToIso (glueData_preimage_image_eq D i j V).symm)
        (fun _ => Subsingleton.elim _ _)) ≪≫
    SheafOfModules.pushforwardCongr (by
      ext V x
      exact congr($(glueData_overlap_appIso_compat D i j (unop V)) x)) ≪≫
    (SheafOfModules.pushforwardComp _ _).symm

/-! ### The candidate inverse of the chart restriction morphism

The inverse `σ_i : M i ⟶ ι_i^* (glue …)` is assembled as an equalizer lift: the chart
pullback preserves the descent equalizer (`glueRestrictEqualizerIso`) and the
pushforward product (`glueRestrictProdIso`), so a map into `ι_i^* (glue …)` is a
family of maps into the factors `ι_i^* ((ι_j)_* M_j)` equalizing the restricted legs.
The `j`-th component (`glueChartComponent`) transports a section of `M i` to the
overlap: the unit along `f_ij`, the transition isomorphism `g_ij`, then the inverse of
the overlap base change `β_ij` (`glueOverlapBaseChangeIso`, in pullback form
`glueOverlapFactorIso`). The three named obligations consuming the cocycle hypotheses
are `glueChartFamily_equalizes` (C2 transported), `glueChartComponent_self_counit`
(C1 + the counit triangle), and `glueRestrictionHom_glueChartComponent` (the
pair-`(i,j)` equalizer condition transposed). -/

section GlueRestrictionInverse

variable (D : Scheme.GlueData.{0}) (M : ∀ i, (D.U i).Modules)

/-- **Object-level overlap base change in pullback form**: the `β_ij` of
`glueOverlapBaseChangeIso`, evaluated at `M j` and conjugated through
`restrictFunctorIsoPullback` on both sides, identifying
`ι_i^* ((ι_j)_* M_j) ≅ (f_ij)_* ((t_ij ≫ f_ji)^* M_j)` with the geometric pullback
functors. Project-local. -/
noncomputable def glueOverlapFactorIso (i j : D.J) :
    (Scheme.Modules.pullback (D.ι i)).obj ((Scheme.Modules.pushforward (D.ι j)).obj (M j))
      ≅ (Scheme.Modules.pushforward (D.f i j)).obj
          ((Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j)) :=
  (restrictFunctorIsoPullback (D.ι i)).symm.app
      ((Scheme.Modules.pushforward (D.ι j)).obj (M j)) ≪≫
    (glueOverlapBaseChangeIso D i j).app (M j) ≪≫
    (Scheme.Modules.pushforward (D.f i j)).mapIso
      ((restrictFunctorIsoPullback (D.t i j ≫ D.f j i)).app (M j))

variable (g : ∀ i j, (Scheme.Modules.pullback (D.f i j)).obj (M i) ≅
      (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j))

/-- **The `j`-th component of the candidate inverse** `σ_i`: transport a section of
`M i` to the overlap `V_ij` (the unit of the pullback–pushforward adjunction along
`f_ij`), across the transition isomorphism `g_ij`, and back up through the inverse of
the overlap base change `β_ij`. Project-local. -/
noncomputable def glueChartComponent (i j : D.J) :
    M i ⟶ (Scheme.Modules.pullback (D.ι i)).obj
      ((Scheme.Modules.pushforward (D.ι j)).obj (M j)) :=
  (Scheme.Modules.pullbackPushforwardAdjunction (D.f i j)).unit.app (M i) ≫
    (Scheme.Modules.pushforward (D.f i j)).map (g i j).hom ≫
    (glueOverlapFactorIso D M i j).inv

/-- **The candidate-inverse family into the restricted pushforward product**: the
`glueChartComponent`s assembled through the product-preservation comparison
`glueRestrictProdIso`. Project-local. -/
noncomputable def glueChartFamily (i : D.J) :
    M i ⟶ (Scheme.Modules.pullback (D.ι i)).obj (glueProd D M) :=
  Pi.lift (glueChartComponent D M g i) ≫ (glueRestrictProdIso D M i).inv

variable (hC1 : ∀ i, g i i = eqToIso (congrArg (fun φ => (Scheme.Modules.pullback φ).obj (M i))
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

include hC1 hC2 in
/-- **The candidate-inverse family equalizes the restricted descent legs**
(C2 transported): the `(p,q)`-component of the equalizing condition is the
triple-overlap multiplicativity (C2) at the triple `(i,p,q)`, transported through the
overlap base changes `β`. Obligation 1 of `isIso_glueRestrictionHom`. Project-local. -/
lemma glueChartFamily_equalizes (i : D.J) :
    glueChartFamily D M g i ≫ (Scheme.Modules.pullback (D.ι i)).map (glueLegA D M)
      = glueChartFamily D M g i ≫ (Scheme.Modules.pullback (D.ι i)).map (glueLegB D M g) := by
  sorry

/-- **The candidate inverse** `σ_i : M i ⟶ ι_i^* (glue …)`: the equalizer lift of
`glueChartFamily` through the limit-preservation comparison
`glueRestrictEqualizerIso`. Project-local. -/
noncomputable def glueRestrictionInv (i : D.J) :
    M i ⟶ (Scheme.Modules.pullback (D.ι i)).obj (glue D M g hC1 hC2) :=
  equalizer.lift (glueChartFamily D M g i) (glueChartFamily_equalizes D M g hC1 hC2 i) ≫
    (glueRestrictEqualizerIso D M g hC1 hC2 i).inv

/-- **Comparison compatibility**: through the equalizer- and product-preservation
comparisons, the restricted equalizer inclusion followed by the `j`-th product
projection is the chart pullback of `glueProj j`. Pure limit-API bookkeeping shared by
the lift computation and the joint-detection lemma. Project-local. -/
@[reassoc]
lemma glueRestrict_proj_compat (i j : D.J) :
    (glueRestrictEqualizerIso D M g hC1 hC2 i).hom ≫
        equalizer.ι ((Scheme.Modules.pullback (D.ι i)).map (glueLegA D M))
          ((Scheme.Modules.pullback (D.ι i)).map (glueLegB D M g)) ≫
        (glueRestrictProdIso D M i).hom ≫ Pi.π _ j
      = (Scheme.Modules.pullback (D.ι i)).map (glueProj D M g hC1 hC2 j) := by
  have hπ : (glueRestrictProdIso D M i).hom ≫ Pi.π _ j
      = (Scheme.Modules.pullback (D.ι i)).map (Pi.π _ j) :=
    piComparison_comp_π _ _ _
  have hι : (glueRestrictEqualizerIso D M g hC1 hC2 i).hom ≫
        equalizer.ι ((Scheme.Modules.pullback (D.ι i)).map (glueLegA D M))
          ((Scheme.Modules.pullback (D.ι i)).map (glueLegB D M g))
      = (Scheme.Modules.pullback (D.ι i)).map (𝟙 (glue D M g hC1 hC2)) ≫
        (Scheme.Modules.pullback (D.ι i)).map
          (equalizer.ι (glueLegA D M) (glueLegB D M g)) :=
    (Category.assoc _ _ _).trans
      (congrArg ((Scheme.Modules.pullback (D.ι i)).map (𝟙 _) ≫ ·)
        (equalizerComparison_comp_π _ _ _))
  rw [reassoc_of% hι, hπ]
  -- term-mode `map_comp` folding (positional `rw [← Functor.map_comp]` fails to match
  -- under the `X.Modules` instance diamond)
  exact (congrArg ((Scheme.Modules.pullback (D.ι i)).map (𝟙 _) ≫ ·)
      ((Scheme.Modules.pullback (D.ι i)).map_comp _ _).symm).trans
    ((Scheme.Modules.pullback (D.ι i)).map_comp _ _).symm

/-- The candidate inverse followed by the restricted `j`-th projection recovers the
`j`-th component of the family: the equalizer/product preservation comparisons cancel
against the lift. Project-local. -/
@[reassoc]
lemma glueRestrictionInv_pullback_map_glueProj (i j : D.J) :
    glueRestrictionInv D M g hC1 hC2 i ≫
        (Scheme.Modules.pullback (D.ι i)).map (glueProj D M g hC1 hC2 j)
      = glueChartComponent D M g i j := by
  rw [glueRestrictionInv, Category.assoc,
    ← glueRestrict_proj_compat D M g hC1 hC2 i j, Iso.inv_hom_id_assoc,
    equalizer.lift_ι_assoc, glueChartFamily, Category.assoc, Iso.inv_hom_id_assoc]
  exact Limits.Pi.lift_π _ _

/-- **Joint detection of morphisms into the restricted glued sheaf**: two morphisms
into `ι_i^* (glue …)` agreeing after every restricted projection
`ι_i^* (glueProj j)` agree. The restricted equalizer inclusion is a monomorphism and
the restricted product projections are jointly monic through the preservation
comparisons. Project-local. -/
lemma glueRestrict_hom_ext {i : D.J} {Z : (D.U i).Modules}
    {u v : Z ⟶ (Scheme.Modules.pullback (D.ι i)).obj (glue D M g hC1 hC2)}
    (h : ∀ j, u ≫ (Scheme.Modules.pullback (D.ι i)).map (glueProj D M g hC1 hC2 j)
        = v ≫ (Scheme.Modules.pullback (D.ι i)).map (glueProj D M g hC1 hC2 j)) :
    u = v := by
  rw [← Iso.cancel_iso_hom_right u v (glueRestrictEqualizerIso D M g hC1 hC2 i)]
  apply equalizer.hom_ext
  simp only [Category.assoc]
  rw [← Iso.cancel_iso_hom_right _ _ (glueRestrictProdIso D M i)]
  apply Limits.Pi.hom_ext
  intro j
  simp only [Category.assoc]
  rw [glueRestrict_proj_compat D M g hC1 hC2 i j]
  exact h j

/-- **Triangle (C1 + counit): the self-component collapses to the identity**. The
`(i,i)`-component of the candidate inverse, transposed back along the chart immersion
(the counit), is the identity of `M i`: the transition `g_ii` is the canonical cast
(C1), `f_ii` is an isomorphism, and the unit/counit cancel by the triangle identity.
Obligation 2 of `isIso_glueRestrictionHom`. Project-local. -/
lemma glueChartComponent_self_counit (i : D.J) :
    glueChartComponent D M g i i ≫
        (Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).counit.app (M i)
      = 𝟙 (M i) := by
  sorry

/-- **The restriction morphism followed by a component of the candidate inverse is the
restricted projection** (the pair-`(i,j)` equalizer condition transposed along the
chart immersion). Obligation 3 of `isIso_glueRestrictionHom`. Project-local. -/
lemma glueRestrictionHom_glueChartComponent (i j : D.J) :
    glueRestrictionHom D M g hC1 hC2 i ≫ glueChartComponent D M g i j
      = (Scheme.Modules.pullback (D.ι i)).map (glueProj D M g hC1 hC2 j) := by
  sorry

end GlueRestrictionInverse

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
  -- the restriction morphism in unit–counit form
  have hr : glueRestrictionHom D M g hC1 hC2 i
      = (Scheme.Modules.pullback (D.ι i)).map (glueProj D M g hC1 hC2 i) ≫
        (Scheme.Modules.pullbackPushforwardAdjunction (D.ι i)).counit.app (M i) :=
    Adjunction.homEquiv_counit _ _ _ _
  refine ⟨glueRestrictionInv D M g hC1 hC2 i, ?_, ?_⟩
  · -- `r_i ≫ σ_i = 𝟙`: joint detection by the restricted projections; the `j`-th
    -- component is the transposed pair-`(i,j)` equalizer condition (obligation 3)
    apply glueRestrict_hom_ext D M g hC1 hC2
    intro j
    rw [Category.assoc, glueRestrictionInv_pullback_map_glueProj,
      glueRestrictionHom_glueChartComponent]
    exact (Category.id_comp _).symm
  · -- `σ_i ≫ r_i = 𝟙`: the self-component collapses by (C1) + the counit triangle
    -- (obligation 2)
    -- term-mode regrouping (mixed-provenance comp nodes block positional `rw`)
    exact (whisker_eq _ hr).trans ((Category.assoc _ _ _).symm.trans
      ((eq_whisker (glueRestrictionInv_pullback_map_glueProj D M g hC1 hC2 i i) _).trans
        (glueChartComponent_self_counit D M g i)))

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

