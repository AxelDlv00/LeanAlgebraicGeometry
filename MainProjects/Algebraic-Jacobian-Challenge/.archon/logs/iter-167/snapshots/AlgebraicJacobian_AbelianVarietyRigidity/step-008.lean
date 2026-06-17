/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus
import AlgebraicJacobian.Genus0BaseObjects

/-!
# Abelian-variety rigidity: morphisms from a genus-`0` curve into an abelian variety are constant

This file scaffolds the project's **committed characteristic-free** genus-`0` route
(route (c)): the abelian-variety rigidity stack. It sits **upstream** of
`AlgebraicJacobian.Jacobian` (it imports only `AlgebraicJacobian.Genus`), breaking the
`RigidityKbar → Rigidity → Jacobian` import cycle so that `genusZeroWitness` can consume the
genus-`0` rigidity keystone directly.

The headline `rigidity_genus0_curve_to_grpScheme` is the char-free replacement (no
`[CharZero kbar]`) for `AlgebraicGeometry.rigidity_over_kbar` of `AlgebraicJacobian.RigidityKbar`
(which remains in tree as the fallback route (a) artifact and still carries `[CharZero]`).

The minimal chain has four links:

1. `rigidity_lemma` — the Rigidity Lemma (Mumford, Form I): the cube-free, cohomology-free
   properness/closed-map entry point. **PROVEN axiom-clean** (iters 157–162). The whole chain is
   `sorry`-free: bridge 1 is `snd_left_isClosedMap`; bridge 2
   (`rigidity_eqOn_saturated_open_to_affine`, the slice-constancy / affine-constancy equation) is
   assembled from Step 2 `morphism_eq_of_eqAt_closedPoints` and Step 1
   `rigidity_eqAt_closedPoint_of_proper_into_affine`, whose deep *algebraic* content is
   `eq_comp_of_isAffine_of_properIntegral` and whose *geometric* slice/section assembly (the
   `IsIntegral X.left` retract argument, `isIntegral_of_retract`) is also closed.
2. `morphism_P1_to_grpScheme_const` — every morphism `ℙ¹ → A` into an abelian variety is
   constant. Proved (route resolved iter-164) by the **𝔾ₘ-scaling shortcut**: the total scaling
   action `σ_× : ℙ¹ × 𝔾ₘ → ℙ¹`, `(x, λ) ↦ λx`, feeds the proven Cor 1.5
   (`hom_additive_decomp_of_rigidity`) — NO theorem of the cube, NO Milne Thm 3.2, NO
   `Hom(𝔾ₐ, A) = 0`, char-general. (Still a scaffold `sorry` pending the concrete ℙ¹/𝔾ₘ/σ_× infra.)
3. `genusZero_curve_iso_P1` — a smooth proper geom-irred genus-`0` curve over `k̄` is
   isomorphic to `ℙ¹` (blocked on Riemann–Roch).
4. `rigidity_genus0_curve_to_grpScheme` — THE HEADLINE consumed by `genusZeroWitness`.

See `blueprint/src/chapters/AbelianVarietyRigidity.tex` for the informal sketches and sources
(Mumford, *Abelian Varieties*, Ch. II §4, §6; Milne, *Abelian Varieties*, Prop. 3.10;
Hartshorne, *Algebraic Geometry*, Example IV.1.3.5).

## Encoding notes (iter-157 scaffold)

Mathlib `b80f227` packages no `ℙ¹` as a `Scheme`, so — following the established project idiom
(see `AlgebraicJacobian.RigidityKbar`) — the projective line is encoded by its abstract
characterisation: a smooth proper geometrically irreducible `Over (Spec (.of kbar))` of relative
dimension `1` with `genus = 0`. The signatures of declarations 1–3 are **provisional**
(`SCAFFOLD` comments mark them); the prover may refine the encoding when the bodies are filled.
Declaration 4 is pinned verbatim to `rigidity_over_kbar`'s signature minus `[CharZero kbar]`,
because it is the exact signature the consumer (`genusZeroWitness.key`) needs.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

variable {kbar : Type u} [Field kbar]

/-- **Cartesian-monoidal identity (skeleton step of the Rigidity Lemma).** Post-composing the
second projection `snd : X ⊗ Y ⟶ Y` with the slice section `y ↦ (x₀, y)` is the "collapse the
`X`-axis onto `x₀`" endomorphism `(x, y) ↦ (x₀, y)` of `X ⊗ Y`:
`snd ≫ lift (toUnit Y ≫ x₀) (𝟙 Y) = lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y)`.

Pure cartesian-monoidal algebra (no geometry): `comp_lift` distributes the `snd`, the
`𝟙 Y` component simplifies by `Category.comp_id`, and the `toUnit Y` component collapses by
uniqueness of maps into the terminal object. -/
theorem rigidity_snd_lift
    {X Y : Over (Spec (.of kbar))}
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X) :
    snd X Y ≫ lift (toUnit Y ≫ x₀) (𝟙 Y) =
      lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) := by
  ext1 <;> simp

/-- **Bridge 1 of the Rigidity Lemma (closed-map step), PROVEN.** When `X` is complete (proper)
over `k̄`, the second monoidal projection `snd : X ⊗ Y ⟶ Y` has, on underlying schemes, a
*closed* base map. This is Mumford's "completeness of `X` makes `p₂` a closed map" (Abelian
Varieties, Ch. II §4, p. 43).

Proof: the underlying scheme morphism `(snd X Y).left` is the pullback projection
`Limits.pullback.snd X.hom Y.hom` (`Over.snd_left`), i.e. the base change of `X.hom` along
`Y.hom`. `IsProper X.hom ⟹ UniversallyClosed X.hom` (`IsProper.toUniversallyClosed`), and
`UniversallyClosed` is stable under base change
(`universallyClosed_isStableUnderBaseChange.of_isPullback` on the canonical pullback square), so
`(snd X Y).left` is universally closed and hence its base map is closed
(`Scheme.Hom.isClosedMap`). Char-free; no theorem of the cube, no cohomology. -/
theorem snd_left_isClosedMap
    {X Y : Over (Spec (.of kbar))} [IsProper X.hom] :
    IsClosedMap (snd X Y).left.base := by
  haveI hp : UniversallyClosed X.hom := IsProper.toUniversallyClosed
  haveI : UniversallyClosed (snd X Y).left := by
    rw [Over.snd_left]
    exact universallyClosed_isStableUnderBaseChange.of_isPullback
      (IsPullback.of_hasPullback X.hom Y.hom) hp
  exact Scheme.Hom.isClosedMap _

/-- **Dense-closed-points hom-extensionality (the bespoke globalisation connective, PROVEN).**
Two morphisms `g₁ g₂ : W ⟶ Z` out of a *reduced* scheme `W` whose closed points are *dense*
(`[JacobsonSpace W]` — e.g. when `W` is locally of finite type over a field) into a *separated*
scheme `Z` are equal as soon as they agree at every closed point `x ∈ closedPoints W` after the
canonical residue-field probe `W.fromSpecResidueField x : Spec κ(x) ⟶ W`.

This is the one connective the iter-159 `mathlib-analogist` flagged that Mathlib does **not**
package directly: Mathlib supplies only the single-dominant-morphism `ext_of_isDominant`. Here we
assemble all the closed points into one dominant probe — the coproduct
`∐_{x ∈ closedPoints W} Spec κ(x) ⟶ W`, whose topological range is exactly the (dense) set of
closed points — and feed it to `ext_of_isDominant`. It is `Step 2` of bridge 2's route B
(cohomology-free) and is fully proven here, reusable independently of the rigidity context. -/
theorem morphism_eq_of_eqAt_closedPoints
    {W Z : Scheme.{u}} [IsReduced W] [JacobsonSpace W] [Z.IsSeparated]
    {g₁ g₂ : W ⟶ Z}
    (h : ∀ x ∈ closedPoints W,
      W.fromSpecResidueField x ≫ g₁ = W.fromSpecResidueField x ≫ g₂) :
    g₁ = g₂ := by
  -- The dominant probe: the coproduct of the residue-field `Spec`s over the closed points.
  let F : closedPoints W → Scheme.{u} := fun x => Spec (W.residueField x.1)
  let probe : (∐ F) ⟶ W := Sigma.desc fun x => W.fromSpecResidueField x.1
  -- Its topological range contains every closed point, hence (Jacobson) is dense.
  haveI : IsDominant probe := by
    refine ⟨(dense_iff_closure_eq.mpr (closure_closedPoints (X := W))).mono ?_⟩
    intro x hx
    obtain ⟨pt⟩ : Nonempty (Spec (W.residueField x)) := inferInstance
    refine ⟨(Sigma.ι F ⟨x, hx⟩).base pt, ?_⟩
    have hcomp : Sigma.ι F ⟨x, hx⟩ ≫ probe = W.fromSpecResidueField x := Sigma.ι_desc _ _
    have e1 : probe.base ((Sigma.ι F ⟨x, hx⟩).base pt) = (W.fromSpecResidueField x).base pt := by
      rw [← Scheme.Hom.comp_apply, hcomp]
    rw [e1]
    exact Set.eq_of_mem_singleton (Scheme.range_fromSpecResidueField x ▸ Set.mem_range_self pt)
  -- Componentwise the probe equalises `g₁` and `g₂`; dominance then forces `g₁ = g₂`.
  refine ext_of_isDominant probe (Sigma.hom_ext _ _ fun x => ?_)
  rw [← Category.assoc, ← Category.assoc, Sigma.ι_desc]
  exact h x.1 x.2

/-- **A proper integral `k̄`-scheme mapping into an affine is constant on `k̄`-points (the deep
algebraic content of Step 1, PROVEN).** Over an algebraically closed field `k̄`, let `W` be an
integral scheme that is universally closed and locally of finite type over `Spec k̄` (e.g. a proper
integral slice `X_y`), and let `g : W ⟶ V` be a morphism into an *affine* scheme `V`. Then `g`
takes the same value on any two `k̄`-points (sections `a`, `b` of the structure map `wk`):
`a ≫ wk = 𝟙` and `b ≫ wk = 𝟙` force `a ≫ g = b ≫ g`.

This is the cohomology-free realisation of "a global regular function on a proper integral
`k̄`-variety is constant". The global sections `Γ(W, ⊤)` form a field
(`isField_of_universallyClosed`) that is module-finite over `k̄`
(`finite_appTop_of_universallyClosed`, hence the structure map is integral on `Γ`); algebraic
closedness collapses the finite extension (`IsAlgClosed.ringHom_bijective_of_isIntegral`), so the
structure map's global-sections map `wk.appTop` is an isomorphism. Both sections `a`, `b` are
left inverses of `wk.appTop` on `Γ`, hence have equal `appTop`; and a morphism into the affine `V`
is pinned by its `appTop` (`ext_of_isAffine`). No coherent cohomology, no relative Stein
factorisation. -/
theorem eq_comp_of_isAffine_of_properIntegral
    [IsAlgClosed kbar]
    {W : Scheme.{u}} [IsIntegral W] (wk : W ⟶ Spec (CommRingCat.of kbar))
    [UniversallyClosed wk] [LocallyOfFiniteType wk]
    {V : Scheme.{u}} [IsAffine V] (g : W ⟶ V)
    (a b : Spec (CommRingCat.of kbar) ⟶ W)
    (ha : a ≫ wk = 𝟙 _) (hb : b ≫ wk = 𝟙 _) :
    a ≫ g = b ≫ g := by
  -- `Γ(W)` is a field (proper integral over `k̄`).
  letI : Field Γ(W, ⊤) := (isField_of_universallyClosed (CommRingCat.of kbar) wk).toField
  -- `F : k̄ ⟶ Γ(W)` (the structure ring map up to `ΓSpecIso`) is integral, hence — `k̄` alg-closed,
  -- `Γ(W)` a domain — bijective, so an iso.
  set F : CommRingCat.of kbar ⟶ Γ(W, ⊤) :=
    (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv ≫ wk.appTop with hF
  have hint : F.hom.IsIntegral := by
    apply RingHom.isIntegral_respectsIso.2 (e := (Scheme.ΓSpecIso _).symm.commRingCatIsoToRingEquiv)
    exact isIntegral_appTop_of_universallyClosed wk
  haveI : IsIso F := (ConcreteCategory.isIso_iff_bijective F).mpr
    (IsAlgClosed.ringHom_bijective_of_isIntegral F.hom hint)
  -- Hence `wk.appTop = ΓSpecIso.hom ≫ F` is an iso.
  haveI : IsIso wk.appTop := by
    have heq : wk.appTop = (Scheme.ΓSpecIso (CommRingCat.of kbar)).hom ≫ F := by
      rw [hF]; simp
    rw [heq]; infer_instance
  -- Both sections invert `wk.appTop` on global sections, so they have equal `appTop`.
  have haa : wk.appTop ≫ a.appTop = 𝟙 _ := by rw [← Scheme.Hom.comp_appTop, ha]; simp
  have hbb : wk.appTop ≫ b.appTop = 𝟙 _ := by rw [← Scheme.Hom.comp_appTop, hb]; simp
  have hab : a.appTop = b.appTop := by rw [← cancel_epi wk.appTop, haa, hbb]
  -- A map into the affine `V` is pinned by `appTop`.
  apply ext_of_isAffine
  rw [Scheme.Hom.comp_appTop, Scheme.Hom.comp_appTop, hab]

/-- **Integrality descends to a retract (blueprint `lem:isIntegral_of_retract_of_integral`).**
If `T` is an integral scheme and `S` is a *retract* of `T` — i.e. there are `r : S ⟶ T` and
`pr : T ⟶ S` with `r ≫ pr = 𝟙 S` — then `S` is integral.

Two halves, both elementary (no cohomology):
* *Irreducible.* `pr` is a continuous surjection (it has the section `r`, so `pr.base ∘ r.base =
  id`), and the continuous surjective image of the irreducible `T` is irreducible.
* *Reduced.* For each `x : S`, the stalk map `pr.stalkMap (r x) : 𝒪_{S,x} ⟶ 𝒪_{T, r x}` is split
  injective: composing with `r.stalkMap x` gives `(r ≫ pr).stalkMap x`, an isomorphism (since
  `r ≫ pr = 𝟙`). Hence `𝒪_{S,x}` embeds into the reduced stalk `𝒪_{T, r x}`
  (`isReduced_of_injective`), so every stalk of `S` is reduced (`isReduced_of_isReduced_stalk`).

Reduced and irreducible together give `IsIntegral S`
(`isIntegral_of_irreducibleSpace_of_isReduced`). This feeds the Step-1 geometric assembly, where
the proper slice `X_y ≅ X` must be presented as proper *integral*. -/
theorem isIntegral_of_retract {S T : Scheme.{u}} [IsIntegral T]
    (r : S ⟶ T) (pr : T ⟶ S) (hrp : r ≫ pr = 𝟙 S) : IsIntegral S := by
  -- `pr.base` is surjective: `r.base` is a section of it.
  have hsurj : Function.Surjective pr.base := by
    intro x
    refine ⟨r.base x, ?_⟩
    have h := congrArg (fun m => m.base x) hrp
    simpa using h
  -- Irreducibility: continuous surjective image of the irreducible `T`.
  haveI : IrreducibleSpace S := by
    rw [irreducibleSpace_def]
    have h := (IrreducibleSpace.isIrreducible_univ T).image pr.base
      pr.base.hom.continuous.continuousOn
    rwa [Set.image_univ, hsurj.range_eq] at h
  -- Reducedness: each stalk of `S` embeds into the corresponding reduced stalk of `T`.
  haveI hstalk : ∀ x : S, _root_.IsReduced (S.presheaf.stalk x) := by
    intro x
    -- `(r ≫ pr).stalkMap x` is an isomorphism (`r ≫ pr = 𝟙`), equal to
    -- `pr.stalkMap (r x) ≫ r.stalkMap x`, so the first factor is injective.
    haveI hiso : IsIso ((r ≫ pr).stalkMap x) := by
      rw [Scheme.Hom.stalkMap_congr_hom (r ≫ pr) (𝟙 S) hrp x, Scheme.Hom.stalkMap_id]
      exact inferInstanceAs (IsIso ((S.presheaf.stalkCongr _).hom ≫ 𝟙 _))
    rw [Scheme.Hom.stalkMap_comp] at hiso
    have hbij := (ConcreteCategory.isIso_iff_bijective
      (pr.stalkMap (r.base x) ≫ r.stalkMap x)).1 hiso
    have hinj : Function.Injective (pr.stalkMap (r.base x)).hom := by
      intro a b hab
      apply hbij.injective
      rw [ConcreteCategory.comp_apply, ConcreteCategory.comp_apply]
      exact congrArg (r.stalkMap x) hab
    have hb : pr.base (r.base x) = x := by
      have h := congrArg (fun m => m.base x) hrp
      simpa using h
    have hred : _root_.IsReduced (S.presheaf.stalk (pr.base (r.base x))) :=
      isReduced_of_injective (pr.stalkMap (r.base x)).hom hinj
    rwa [hb] at hred
  haveI : IsReduced S := isReduced_of_isReduced_stalk S
  exact isIntegral_of_irreducibleSpace_of_isReduced S

/-- **Per-closed-slice constancy (Step 1 of bridge 2's route B), the residual deep geometry.**
With the data of `rigidity_eqOn_saturated_open_to_affine`, fix a *closed* point `x` of the
`p₂`-saturated open `U ⊆ X ⊗ Y` on which `f` lands in the affine `U₀`. Then `f` and the collapsed
map `retract ≫ f` (`retract := lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y)`, i.e. `(x,y) ↦ (x₀,y)`)
agree at `x` after the residue-field probe `U.fromSpecResidueField x`.

Mumford's "for each `y ∈ V`, the complete slice `X × {y}` maps into the affine, hence to a single
point" step, realised cohomology-FREE. The intended proof (analogist route B, `analogies/
rigidity-affineconst.md`): the closed point `x` lies over a closed point `y = p₂(x) ∈ Vset` with
`κ(y) = k̄` (`[IsAlgClosed kbar]`, finite type); saturation `_hUV` puts the whole proper integral
slice `X_y ≅ X` inside `U`, so `f` maps `X_y` into the affine `U₀`. By
`isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` + alg-closedness,
`Γ(X_y) = k̄`, so `f|X_y` factors through a single `k̄`-point of `U₀` (`ext_of_isAffine`) —
necessarily `f(x₀, y)`, which is exactly `(retract ≫ f)(x)`. The relative Stein / `f_*𝒪 = 𝒪`
framing is a confirmed Mathlib gap and is deliberately avoided.

**Status (iter-162): PROVEN axiom-clean.** It is the per-point input that
`morphism_eq_of_eqAt_closedPoints` globalises over the dense closed points. Extracted as a named
top-level obligation per the route-B decomposition; the geometric slice/section assembly is closed
via the `IsIntegral X.left` retract argument (`isIntegral_of_retract`). -/
theorem rigidity_eqAt_closedPoint_of_proper_into_affine
    [IsAlgClosed kbar]
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
    [LocallyOfFiniteType (X ⊗ Y).hom]
    [IsReduced (X ⊗ Y).left]
    [IsSeparated Z.hom]
    (f : (X ⊗ Y) ⟶ Z)
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X)
    (U : (X ⊗ Y).left.Opens)
    (Vset : Set Y.left)
    (_hUV : (U : Set (X ⊗ Y).left) = (snd X Y).left.base ⁻¹' Vset)
    (U₀ : Z.left.Opens) (_hU₀ : IsAffineOpen U₀)
    (_hfU : ∀ u ∈ (U : Set (X ⊗ Y).left), f.left.base u ∈ U₀)
    (x : (U : (X ⊗ Y).left.Opens).toScheme)
    (_hx : x ∈ closedPoints (U : (X ⊗ Y).left.Opens).toScheme) :
    (U : (X ⊗ Y).left.Opens).toScheme.fromSpecResidueField x ≫
        ((U.ι : (U : (X ⊗ Y).left.Opens).toScheme ⟶ (X ⊗ Y).left) ≫ f.left) =
      (U : (X ⊗ Y).left.Opens).toScheme.fromSpecResidueField x ≫
        ((U.ι : (U : (X ⊗ Y).left.Opens).toScheme ⟶ (X ⊗ Y).left) ≫
          (lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f).left) := by
  -- `x` is a closed point of the locally-of-finite-type `k̄`-scheme `U`, so (alg-closedness) it is
  -- a `k̄`-rational point: `pointOfClosedPoint` packages the residue-field probe as a `k̄`-point
  -- `px : Spec k̄ ⟶ U` with `Spec.map (residueFieldIsoBase …).hom ≫ U.fromSpecResidueField x = px`.
  have hxc : IsClosed {x} := _hx
  set wU : (U : (X ⊗ Y).left.Opens).toScheme ⟶ Spec (CommRingCat.of kbar) :=
    U.ι ≫ (X ⊗ Y).hom with hwU
  set px : Spec (CommRingCat.of kbar) ⟶ (U : (X ⊗ Y).left.Opens).toScheme :=
    pointOfClosedPoint wU x hxc with hpx
  -- Reduce the residue-field-probe goal to the `k̄`-point statement by cancelling the iso
  -- `e := Spec.map (residueFieldIsoBase …).hom` on the left (`e ≫ U.fromSpecResidueField x = px`).
  rw [← cancel_epi (Spec.map (residueFieldIsoBase wU x hxc).hom)]
  suffices h : px ≫ U.ι ≫ Over.Hom.left f =
      px ≫ U.ι ≫ Over.Hom.left (lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f) by
    rw [hpx] at h
    simpa only [pointOfClosedPoint, Category.assoc] using h
  -- `q := px ≫ U.ι : Spec k̄ ⟶ (X ⊗ Y).left` is the `k̄`-rational point at the closed point `x`;
  -- it is a *section* of the structure map `(X ⊗ Y).hom` (a genuine `k̄`-point of `X ⊗ Y`).
  set q : Spec (CommRingCat.of kbar) ⟶ (X ⊗ Y).left := px ≫ U.ι with hq
  have hqsec : q ≫ (X ⊗ Y).hom = 𝟙 _ := by
    rw [hq, Category.assoc]; exact pointOfClosedPoint_comp wU x hxc
  -- Rewrite the collapsed side `(retract ≫ f).left = retract.left ≫ f.left`.
  rw [Over.comp_left]
  -- It remains to prove the `k̄`-point slice-constancy
  --   `q ≫ f.left = q ≫ retract.left ≫ f.left`,
  -- i.e. `f` agrees at the `k̄`-point `q = (x_X, y)` and its `X`-collapse `retract(q) = (x₀, y)`.
  -- Both points lie on the proper integral slice `X_y` over the `k̄`-point `y := q ≫ p₂`, which
  -- (saturation `_hUV`) lies entirely inside `U`, hence (`_hfU`) maps under `f` into the affine
  -- `U₀`. The deep content "a proper integral `k̄`-scheme into an affine is constant on
  -- `k̄`-points" is now-proven as `eq_comp_of_isAffine_of_properIntegral`: realising the slice
  -- as `X` via the section `s := lift (𝟙 X) (toUnit X ≫ ŷ)` over the `k̄`-point `ŷ : 𝟙_ ⟶ Y`
  -- lifting `y`, one
  -- corestricts `(s ≫ f).left : X.left → Z.left` to `U₀.toScheme` and applies the sub-lemma to the
  -- two `k̄`-points (the `X`-coordinate of `q`, and its `X`-collapse) of the proper integral `X`.
  -- Name the collapse endomorphism `retract := (x, y) ↦ (x₀, y)`.
  set retract : X ⊗ Y ⟶ X ⊗ Y := lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) with hretract
  -- `(toUnit X).left = X.hom`.
  have htoUnit : (toUnit X).left = X.hom := by simp
  -- Lift `q` to a genuine `k̄`-point `q̂ : 𝟙_ ⟶ X ⊗ Y` of the product (a section of `(X⊗Y).hom`),
  -- working in `Over (Spec k̄)` where the cartesian-monoidal algebra is clean.
  set qhat : 𝟙_ (Over (Spec (CommRingCat.of kbar))) ⟶ X ⊗ Y := Over.homMk q hqsec with hqhat
  have hqhatL : qhat.left = q := rfl
  -- Its `X`- and `Y`-coordinates, and the slice section `sec : X ⟶ X ⊗ Y`, `x ↦ (x, ŷ)`.
  set yhat : 𝟙_ (Over (Spec (CommRingCat.of kbar))) ⟶ Y := qhat ≫ snd X Y with hyhat
  set xq : 𝟙_ (Over (Spec (CommRingCat.of kbar))) ⟶ X := qhat ≫ fst X Y with hxq
  set sec : X ⟶ X ⊗ Y := lift (𝟙 X) (toUnit X ≫ yhat) with hsecdef
  clear_value qhat xq yhat
  -- Slice identities in `Over (Spec k̄)`: `q̂ = xq ≫ sec` and `q̂ ≫ retract = x₀ ≫ sec`.
  have hIover : qhat = xq ≫ sec := by
    apply CartesianMonoidalCategory.hom_ext
    · rw [Category.assoc, hsecdef, lift_fst, Category.comp_id]; exact hxq.symm
    · rw [Category.assoc, hsecdef, lift_snd, ← Category.assoc,
        toUnit_unique (xq ≫ toUnit X) (𝟙 _), Category.id_comp]; exact hyhat.symm
  have hIIover : qhat ≫ retract = x₀ ≫ sec := by
    apply CartesianMonoidalCategory.hom_ext
    · rw [hretract, hsecdef, Category.assoc, lift_fst, ← Category.assoc,
        toUnit_unique (qhat ≫ toUnit (X ⊗ Y)) (𝟙 _), Category.id_comp, Category.assoc, lift_fst,
        Category.comp_id]
    · rw [hretract, hsecdef, Category.assoc, lift_snd, Category.assoc, lift_snd, ← Category.assoc,
        toUnit_unique (x₀ ≫ toUnit X) (𝟙 _), Category.id_comp, hyhat]
  -- `sec.left` is a section of the first projection, exhibiting `X.left` as a retract.
  have hsecLfst : sec.left ≫ (fst X Y).left = 𝟙 X.left := by
    rw [← Over.comp_left, hsecdef, lift_fst, Over.id_left]
  have hyhatL : yhat.left = q ≫ (snd X Y).left := by
    rw [hyhat, Over.comp_left]; exact congrArg (· ≫ Over.Hom.left (snd X Y)) hqhatL
  have hsecLsnd : sec.left ≫ (snd X Y).left = X.hom ≫ q ≫ (snd X Y).left := by
    rw [← Over.comp_left, hsecdef, lift_snd, ← hyhatL]; simp [htoUnit]
  -- `IsIntegral X.left`: `X.left` is a retract of the integral product via the section `sec.left`.
  haveI : IsIntegral (X ⊗ Y).left := by
    haveI : IrreducibleSpace (X ⊗ Y).left :=
      GeometricallyIrreducible.irreducibleSpace_of_subsingleton (X ⊗ Y).hom
    exact isIntegral_of_irreducibleSpace_of_isReduced _
  haveI : IsIntegral X.left := isIntegral_of_retract sec.left (fst X Y).left hsecLfst
  -- `sec ≫ f` maps the slice into the affine `U₀`; corestrict to `U₀.toScheme`.
  haveI : IsAffine U₀.toScheme := _hU₀
  -- The slice `sec.left` lands in the saturated open `U` (the fibre over `ŷ ∈ Vset`).
  have hsecU : ∀ t : X.left, sec.left.base t ∈ (↑U : Set (X ⊗ Y).left) := by
    intro t
    rw [_hUV, Set.mem_preimage]
    have e1 : (snd X Y).left.base (sec.left.base t)
        = (snd X Y).left.base (q.base (X.hom.base t)) := by
      have h2 := congrArg (fun m : X.left ⟶ Y.left => m.base t) hsecLsnd
      simpa only [Scheme.Hom.comp_apply] using h2
    rw [e1]
    have hqmem : q.base (X.hom.base t) ∈ (↑U : Set (X ⊗ Y).left) := by
      rw [hq, Scheme.Hom.comp_apply, pointOfClosedPoint_apply, ← Scheme.Opens.range_ι]
      exact Set.mem_range_self x
    rw [_hUV, Set.mem_preimage] at hqmem
    exact hqmem
  have hrange : Set.range ((sec ≫ f).left).base ⊆ Set.range U₀.ι.base := by
    rw [Scheme.Opens.range_ι]
    rintro _ ⟨t, rfl⟩
    have hfin := _hfU (sec.left.base t) (hsecU t)
    rw [Over.comp_left, Scheme.Hom.comp_apply]
    exact hfin
  set g : X.left ⟶ U₀.toScheme := IsOpenImmersion.lift U₀.ι (sec ≫ f).left hrange with hgdef
  have hgfac : g ≫ U₀.ι = (sec ≫ f).left := IsOpenImmersion.lift_fac _ _ hrange
  -- Deep algebra: the two `k̄`-points `xq`, `x₀` of the proper integral slice agree under `sec≫f`.
  have key : xq.left ≫ g = x₀.left ≫ g :=
    eq_comp_of_isAffine_of_properIntegral X.hom g xq.left x₀.left (Over.w xq) (Over.w x₀)
  -- Over-level: `q̂ ≫ f = xq ≫ sec ≫ f` and `q̂ ≫ retract ≫ f = x₀ ≫ sec ≫ f`.
  have hqf : qhat ≫ f = xq ≫ sec ≫ f := by rw [← Category.assoc, ← hIover]
  have hqrf : qhat ≫ retract ≫ f = x₀ ≫ sec ≫ f := by
    rw [← Category.assoc, hIIover, Category.assoc]
  -- Translate to the `q`-form of the goal.
  have hxqf : q ≫ f.left = xq.left ≫ (sec ≫ f).left := by
    simpa only [Over.comp_left, hqhatL] using congrArg Over.Hom.left hqf
  have hx₀f : q ≫ retract.left ≫ f.left = x₀.left ≫ (sec ≫ f).left := by
    simpa only [Over.comp_left, hqhatL] using congrArg Over.Hom.left hqrf
  -- The two `k̄`-points have the same image under `sec ≫ f` (corestricted via `key`).
  have hbridge : xq.left ≫ (sec ≫ f).left = x₀.left ≫ (sec ≫ f).left := by
    rw [← hgfac, ← Category.assoc, ← Category.assoc]
    exact congrArg (· ≫ U₀.ι) key
  have hgoalq : q ≫ f.left = q ≫ retract.left ≫ f.left :=
    hxqf.trans (hbridge.trans hx₀f.symm)
  rw [hq] at hgoalq
  simpa only [Category.assoc] using hgoalq

/-- **Bridge 2 of the Rigidity Lemma (slice-constancy / the agreement equation), the residual
geometric input.** Let `X` be complete (proper) over an algebraically closed `k̄`, `x₀` a
`k̄`-point of `X`, and `f : X ⊗ Y ⟶ Z` into a separated `Z`. Let `U = p₂⁻¹(V)` be a `p₂`-saturated
open of `X ⊗ Y` (the preimage of a set `Vset ⊆ Y`) on which `f` lands inside a single **affine**
open `U₀ ⊆ Z`. Then `f` agrees on `U` with the collapsed map `retract ≫ f`
(`retract := lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y)`, i.e. `(x, y) ↦ (x₀, y)`):

  `U.ι ≫ f.left = U.ι ≫ (retract ≫ f).left`.

This is the cohomology-free **route B** of the iter-159 `mathlib-analogist` consult
(`analogies/rigidity-affineconst.md`); it was the genuinely-deep residual of the Rigidity-Lemma
chain and is now **PROVEN axiom-clean** (iter-162), assembled here as a named top-level obligation
from Step 2 (`morphism_eq_of_eqAt_closedPoints`) over the per-slice Step 1
(`rigidity_eqAt_closedPoint_of_proper_into_affine`). The relative Stein-factorisation /
proper-pushforward `f_*𝒪 = 𝒪` framing is a confirmed Mathlib gap and is **deliberately avoided**.

The intended proof (no coherent cohomology):
1. *Per closed slice.* For each closed point `y ∈ Vset`, `κ(y) = k̄` (`[IsAlgClosed kbar]`, finite
   type). Saturation puts the whole fibre `X_y` inside `U`, so `f` maps the proper integral slice
   `X_y ≅ X` into the affine `U₀`. By `isField_of_universallyClosed` +
   `finite_appTop_of_universallyClosed` + alg-closedness, `Γ(X_y) = k̄`, so the slice maps to a
   single `k̄`-point of `U₀`
   (`ext_of_isAffine`); that point is `f(x₀, y)`, since `(x₀, y) ∈ X_y`. Hence `f` and `retract ≫ f`
   agree at every closed point of `U`.
2. *Globalise.* Closed points are dense in the locally-of-finite-type `k̄`-scheme `U`
   (`closure_closedPoints`, the Jacobson-space property). Turning "agrees at each closed point"
   into one dominant probe (the coproduct `∐_{x∈closedPoints U} Spec κ(x) ⟶ U`, dense range) and
   feeding it to `ext_of_isDominant_of_isSeparated'` (the reduced-source / separated-target rigidity
   `rigidity_core` already uses) yields the morphism equality on all of `U`. This last
   "dense-closed-points ⟹ hom-ext" connective is the one piece Mathlib does not package directly. -/
theorem rigidity_eqOn_saturated_open_to_affine
    [IsAlgClosed kbar]
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
    [LocallyOfFiniteType (X ⊗ Y).hom]
    [IsReduced (X ⊗ Y).left]
    [IsSeparated Z.hom]
    (f : (X ⊗ Y) ⟶ Z)
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X)
    (U : (X ⊗ Y).left.Opens)
    (Vset : Set Y.left)
    (_hUV : (U : Set (X ⊗ Y).left) = (snd X Y).left.base ⁻¹' Vset)
    (U₀ : Z.left.Opens) (_hU₀ : IsAffineOpen U₀)
    (_hfU : ∀ u ∈ (U : Set (X ⊗ Y).left), f.left.base u ∈ U₀) :
    (U.ι : (U : (X ⊗ Y).left.Opens).toScheme ⟶ (X ⊗ Y).left) ≫ f.left =
      (U.ι : (U : (X ⊗ Y).left.Opens).toScheme ⟶ (X ⊗ Y).left) ≫
        (lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f).left := by
  -- Target separatedness (absolute), from `IsSeparated Z.hom` and the affine base `Spec k̄`:
  -- `terminal.from Z.left = Z.hom ≫ terminal.from (Spec k̄)`, a composite of separated maps.
  haveI : Z.left.IsSeparated := by
    rw [Scheme.isSeparated_iff]
    have heq : terminal.from Z.left = Z.hom ≫ terminal.from (Spec (CommRingCat.of kbar)) :=
      terminal.hom_ext _ _
    rw [heq]; infer_instance
  -- JACOBSON DERIVATION (iter-161: now a routine instance discharge, NOT an as-typed gap).
  -- The route-B globalisation of the per-closed-slice constancy needs the closed points of `U` to
  -- be DENSE, i.e. `U` to be a Jacobson space. The chain now carries
  -- `[LocallyOfFiniteType (X ⊗ Y).hom]` as a hypothesis of this lemma, so `JacobsonSpace U` is
  -- derivable: `Spec k̄` is a Jacobson space (a field is an `IsJacobsonRing`,
  -- `PrimeSpectrum.instJacobsonSpaceOfIsJacobsonRing`); `LocallyOfFiniteType.jacobsonSpace` then
  -- transports it to `(X ⊗ Y).left`; and `JacobsonSpace.of_isOpenEmbedding` inherits it onto the
  -- open subscheme `U`. This `sorry` is therefore the assembly of those three Mathlib facts, left
  -- for the prover phase — it is no longer an as-typed-unprovability.
  haveI : JacobsonSpace ((U : (X ⊗ Y).left.Opens).toScheme) := by
    -- `Spec k̄` is Jacobson (a field is `IsArtinianRing`, hence `IsJacobsonRing`); transport
    -- across the locally-of-finite-type structure map to `(X ⊗ Y).left`; then inherit onto the
    -- open subscheme `U` along the open embedding `U.ι`.
    haveI : JacobsonSpace (X ⊗ Y).left :=
      LocallyOfFiniteType.jacobsonSpace (X ⊗ Y).hom
    exact JacobsonSpace.of_isOpenEmbedding U.ι.isOpenEmbedding
  -- Globalise the per-closed-point slice-constancy (Step 1,
  -- `rigidity_eqAt_closedPoint_of_proper_into_affine`) over the dense closed points (Step 2,
  -- `morphism_eq_of_eqAt_closedPoints`). This wires bridge 2's route B end to end.
  exact morphism_eq_of_eqAt_closedPoints fun x hx =>
    rigidity_eqAt_closedPoint_of_proper_into_affine f x₀ U Vset _hUV U₀ _hU₀ _hfU x hx

/-- **The dense-open agreement (the genuine geometric content).** Mumford's open
`X × V` together with the slice-constancy `f(x, y) = f(x₀, y)` on it, packaged as the single
existential that `rigidity_core`'s gluing step consumes: there is a non-empty open `U` of
`(X ⊗ Y).left` on which `f` and the collapsed map `retract ≫ f` agree as scheme morphisms.

**Status (iter-159): this lemma is now `sorry`-free in its own body.** The construction of the
non-empty open `U = X × V` (closed-map bridge 1, `snd_left_isClosedMap`) and its non-emptiness
(`y₀ ∉ G` via the collapse hypothesis `_hf`, using the pullback-fibre fact `hfib` over the
`k̄`-point `y₀`) are discharged here. The one remaining geometric input — slice-constancy on `U`
(bridge 2) — is delegated to the named helper `rigidity_eqOn_saturated_open_to_affine`, now
assembled from the proven Step 2 (`morphism_eq_of_eqAt_closedPoints`) over the per-slice Step 1
(`rigidity_eqAt_closedPoint_of_proper_into_affine`); its affine-containment hypothesis is read off
the definition of `G` inside this proof. The whole chain — including Step 1's geometric
slice/section assembly — is now PROVEN axiom-clean (iter-162).

This lemma carries the **collapse hypothesis** `_hf : f(X × {y₀}) = {z₀}` (encoded
`lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀`), which is exactly what makes Mumford's open
`V := Y ∖ G` non-empty (`y₀ ∉ G`, since the rigidified slice `f(X × {y₀}) = {z₀} ⊆ U` lands in
the affine `U`, so its image under `snd` avoids `G = snd '' (f ⁻¹ F)`). Without `_hf` the lemma
is **false** (e.g. `f := fst : X ⊗ Y ⟶ X = Z` has no open of agreement). The full instance set
(`GeometricallyIrreducible`, `IsReduced`, `IsSeparated`) and `_hf` only strengthen the
antecedent.

Of the two char-free Mathlib bridges of `rigidity_core`'s docstring, **bridge 1** (the closed-map
argument, `IsProper.toUniversallyClosed` ⟹ the projection is closed) is discharged here — it
produces the non-empty open `U = X × V`. **Bridge 2** (the affine-constancy argument,
`isField_of_universallyClosed` on each proper integral slice mapping to an affine, supplying the
scheme-level equality on `U`) is the residual content, isolated in the named helper
`rigidity_eqOn_saturated_open_to_affine`. -/
theorem rigidity_eqOn_dense_open
    [IsAlgClosed kbar]
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
    [LocallyOfFiniteType (X ⊗ Y).hom]
    [IsReduced (X ⊗ Y).left]
    [IsSeparated Z.hom]
    (f : (X ⊗ Y) ⟶ Z)
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X)
    (y₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Y)
    (z₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Z)
    (_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀) :
    ∃ U : (X ⊗ Y).left.Opens, (U : Set (X ⊗ Y).left).Nonempty ∧
      (U.ι : (U : (X ⊗ Y).left.Opens).toScheme ⟶ (X ⊗ Y).left) ≫ f.left =
        (U.ι : (U : (X ⊗ Y).left.Opens).toScheme ⟶ (X ⊗ Y).left) ≫
          (lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f).left := by
  -- Mumford's construction of the open `U = X × V`, `V = Y - G`, `G = p₂(f⁻¹(Z - U₀))`.
  -- Bridge 1 (`snd_left_isClosedMap`) makes `G` closed; the collapse hypothesis `_hf` makes
  -- `y₀ ∉ G` so `V` (hence `U`) is non-empty; bridge 2 (affine-constancy) is the agreement.
  have hclosed : IsClosedMap (snd X Y).left.base := snd_left_isClosedMap
  -- `Spec k̄` is a single point; transport the instance to the monoidal unit's underlying scheme.
  haveI hsub : Subsingleton (↥(𝟙_ (Over (Spec (CommRingCat.of kbar)))).left) :=
    inferInstanceAs (Subsingleton (Spec (CommRingCat.of kbar)))
  -- The chosen `k̄`-point of `Spec k̄` (`= (𝟙_).left`).
  have ptk : (𝟙_ (Over (Spec (CommRingCat.of kbar)))).left :=
    (inferInstance : Inhabited (Spec (CommRingCat.of kbar))).default
  -- The image point `z₀` in `Z` and an affine open neighbourhood `U₀ ∋ z₀`.
  let z₀pt : Z.left := z₀.left.base ptk
  obtain ⟨U₀, _hU₀aff, hz₀U₀, -⟩ := exists_isAffineOpen_mem_and_subset (X := Z.left)
    (x := z₀pt) (U := ⊤) trivial
  -- `G = p₂(f⁻¹(Z - U₀))` is closed (image of a closed set under the closed map `p₂`).
  set Gset := (snd X Y).left.base '' (f.left.base ⁻¹' (U₀ : Set Z.left)ᶜ) with hGdef
  have hG : IsClosed Gset := hclosed _ (U₀.isOpen.isClosed_compl.preimage f.left.base.hom.2)
  -- `U = p₂⁻¹(Y - G)` (Mumford's `X × V`) is open.
  have hUopen : IsOpen ((snd X Y).left.base ⁻¹' Gsetᶜ) :=
    (hG.isOpen_compl).preimage (snd X Y).left.base.hom.2
  -- The slice section `s : X → X ⊗ Y`, `x ↦ (x, y₀)`, and the points `y₀`, `x₀`.
  let s := (lift (𝟙 X) (toUnit X ≫ y₀)).left
  let y₀pt : Y.left := y₀.left.base ptk
  let x₀pt : X.left := x₀.left.base ptk
  -- Every point of the slice `p₂⁻¹{y₀}` lies in the image of the section `s`. True because `y₀`
  -- is a `k̄`-point: the slice section `s : X → X ⊗ Y` exhibits `X.left` as the fibre of the
  -- pullback projection `p₂` over `y₀`. We paste the identity (iso) outer square for `s` against
  -- the canonical pullback square and read the fibre off the coarse `PullbackCarrier` layer
  -- (`Scheme.image_preimage_eq_of_isPullback`); no residue fields / `Triplet` machinery.
  have hfib : (snd X Y).left.base ⁻¹' {y₀pt} ⊆ Set.range s.base := by
    set p₁ := pullback.fst X.hom Y.hom with hp₁def
    set p₂ := pullback.snd X.hom Y.hom with hp₂def
    -- `(toUnit X).left = X.hom`: the structure map of the unit is `𝟙`, and `Over.w` collapses.
    have htoUnit : (toUnit X).left = X.hom := by simp
    -- Triangle identities of the slice section `s = (x ↦ (x, y₀)).left`.
    have hsp1 : s ≫ p₁ = 𝟙 X.left := by
      rw [hp₁def, ← Over.fst_left, ← Over.comp_left, lift_fst, Over.id_left]
    have hsp2 : s ≫ p₂ = X.hom ≫ y₀.left := by
      rw [hp₂def, ← Over.snd_left, ← Over.comp_left, lift_snd, Over.comp_left]
      exact congrArg (· ≫ y₀.left) htoUnit
    -- `y₀` is a section of `Y.hom` (it is a `k̄`-point of `Y`).
    have hsec : y₀.left ≫ Y.hom = 𝟙 (Spec (.of kbar)) := by simpa using Over.w y₀
    -- The outer square `(s ≫ p₁ ; X.hom) = (X.hom ; y₀.left ≫ Y.hom)` is a pullback: both
    -- horizontal legs are identities (isos).
    have houter : IsPullback (s ≫ p₁) X.hom X.hom (y₀.left ≫ Y.hom) := by
      have hiso : IsPullback (𝟙 X.left) X.hom X.hom (𝟙 (Spec (.of kbar))) :=
        IsPullback.of_horiz_isIso ⟨by simp⟩
      rwa [← hsp1, ← hsec] at hiso
    -- Paste off the canonical right pullback square to recover the left square `hL`.
    have hL : IsPullback s X.hom p₂ y₀.left :=
      IsPullback.of_right houter hsp2 (IsPullback.of_hasPullback X.hom Y.hom)
    -- Range of `s` = fibre of `p₂` over `range y₀.left`, via the coarse pullback-carrier lemma.
    have hrange : Set.range s.base = p₂.base ⁻¹' Set.range y₀.left.base := by
      simpa [Set.image_univ, Set.preimage_univ] using
        AlgebraicGeometry.Scheme.image_preimage_eq_of_isPullback hL.flip Set.univ
    rw [Over.snd_left, ← hp₂def, hrange]
    exact Set.preimage_mono (Set.singleton_subset_iff.mpr ⟨ptk, rfl⟩)
  -- `y₀ ∉ G`: any point over `y₀` is `s x`, and `_hf` collapses `f (s x) = z₀ ∈ U₀`.
  have hy₀ : y₀pt ∉ Gset := by
    rintro ⟨q, hq, hsndq⟩
    obtain ⟨x, rfl⟩ := hfib (by simpa using hsndq)
    apply hq
    have hcomp : s ≫ f.left = (toUnit X ≫ z₀).left := by
      rw [← Over.comp_left]; exact congrArg Over.Hom.left _hf
    have hfx : f.left.base (s.base x) = z₀pt := by
      rw [← Scheme.Hom.comp_apply, hcomp, Over.comp_left, Scheme.Hom.comp_apply]
      change z₀.left.base ((toUnit X).left.base x) = z₀.left.base ptk
      congr 1; exact Subsingleton.elim _ _
    rw [hfx]; exact hz₀U₀
  -- Assemble `U`, witness its non-emptiness by `s x₀` (which lies over `y₀ ∈ V`).
  refine ⟨⟨_, hUopen⟩, ⟨s.base x₀pt, ?_⟩, ?_⟩
  · change (snd X Y).left.base (s.base x₀pt) ∈ Gsetᶜ
    have hsnd : (snd X Y).left.base (s.base x₀pt) = y₀pt := by
      have hcomp : s ≫ (snd X Y).left = (toUnit X ≫ y₀).left := by
        rw [← Over.comp_left]; exact congrArg Over.Hom.left (lift_snd (𝟙 X) (toUnit X ≫ y₀))
      rw [← Scheme.Hom.comp_apply, hcomp, Over.comp_left, Scheme.Hom.comp_apply]
      change y₀.left.base ((toUnit X).left.base x₀pt) = y₀.left.base ptk
      congr 1; exact Subsingleton.elim _ _
    rw [Set.mem_compl_iff, hsnd]; exact hy₀
  · -- Bridge 2 (affine-constancy): on `U = X × V` (saturated: `U = p₂⁻¹ Gsetᶜ`) `f` lands in the
    -- affine `U₀`, so each proper slice maps to a single point `f(x₀, y)` and `f` agrees with
    -- `retract ≫ f` on `U`. The affine-containment `hfU` is read off the definition of `Gset`;
    -- the slice-constancy + dense-closed-points globalisation is the residual `route B`, isolated
    -- as the named helper `rigidity_eqOn_saturated_open_to_affine` (cohomology-free, ≈1–2 iter).
    have hfU : ∀ u ∈ ((⟨_, hUopen⟩ : (X ⊗ Y).left.Opens) : Set (X ⊗ Y).left),
        f.left.base u ∈ U₀ := by
      intro u hu
      by_contra hcon
      -- `u ∈ U` means `p₂ u ∉ Gset`; but `f u ∉ U₀` puts `p₂ u` into `Gset = p₂ '' (f⁻¹ U₀ᶜ)`.
      exact hu ⟨u, hcon, rfl⟩
    exact rigidity_eqOn_saturated_open_to_affine f x₀ ⟨_, hUopen⟩ Gsetᶜ rfl U₀ _hU₀aff hfU

/-- **Geometric core of the Rigidity Lemma (PROVEN axiom-clean, iter-162).** With
`X` complete (proper) and `x₀ : 𝟙_ ⟶ X` a `k̄`-point, the morphism `f : X ⊗ Y ⟶ Z` is invariant
under the "collapse-the-`X`-axis-onto-`x₀`" endomorphism
`retract := lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y)`:

  `f = retract ≫ f`,

i.e. `f(x, y) = f(x₀, y)` for all `(x, y)` — `f` depends only on the `Y`-coordinate. This is
the entirety of the *geometric* content of Mumford's Rigidity Lemma (Form I); the rest of
`rigidity_lemma` is the cartesian-monoidal algebra discharged by `rigidity_snd_lift`.

This core is now **proven** by the project's scheme-level rigidity (replicated inline from
Mathlib's `ext_of_isDominant_of_isSeparated'`, since the wrapper `Scheme.Over.ext_of_eqOnOpen`
lives in the downstream `AlgebraicJacobian.Rigidity`): two maps out of the geometrically
irreducible reduced `X ⊗ Y` into the separated `Z` that agree on a non-empty open agree
everywhere. The existence of that non-empty open together with the agreement on it —
`rigidity_eqOn_dense_open`, the actual geometry below — is now itself PROVEN axiom-clean.

This core carries the **collapse hypothesis** `_hf : f(X × {y₀}) = {z₀}` (encoded
`lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀`), passed straight through to
`rigidity_eqOn_dense_open`: it is exactly what makes Mumford's open `V := Y ∖ G` non-empty
(`y₀ ∉ G`). Without it the core statement is **false** (`f := fst` is not collapse-invariant).

## Mumford's proof of `rigidity_eqOn_dense_open` (Abelian Varieties, Ch. II §4, p. 43)

Set `g(y) = f(x₀, y)` (so `retract ≫ f` is exactly `(x, y) ↦ g(y)`). The open `V` is produced as
follows: let `U` be an affine open neighbourhood of a chosen point in `Z`, `F = Z ∖ U`, and
`G = (snd X Y) '' (f ⁻¹ F)`. Then for each `y ∈ V := Y ∖ G`, the slice `f(X × {y}) ⊆ U`, and `f`
agrees with `retract ≫ f` on the non-empty open `X × V`.

This rests on **two char-free Mathlib bridges** (the cube-free heart); bridge 1 is **built**,
bridge 2 (`rigidity_eqOn_saturated_open_to_affine`) is **decomposed and assembled** — Step 2
proven (`morphism_eq_of_eqAt_closedPoints`), Step 1's deep algebra proven
(`eq_comp_of_isAffine_of_properIntegral`), Step 1's geometric slice/section assembly
(`rigidity_eqAt_closedPoint_of_proper_into_affine`) also proven via `isIntegral_of_retract`:

  1. **Properness ⇒ the projection is a closed map — BUILT** (`snd_left_isClosedMap`, iter-158).
     `IsProper X.hom` is universally closed (`AlgebraicGeometry.IsProper.toUniversallyClosed`), and
     `snd X Y` is the base change of `X.hom` along `Y.hom`, hence universally closed, hence a closed
     map. The glue identifying the monoidal `snd X Y` in `Over (Spec k̄)` with the scheme-theoretic
     pullback projection `Limits.pullback.snd X.hom Y.hom` is the exact rewrite `Over.snd_left`, and
     `IsClosedMap` is transported across the canonical pullback square via
     `universallyClosed_isStableUnderBaseChange`. So `G = snd '' (closed)` is closed, `V` open.

  2. **A proper connected variety mapping to an affine has image a single point.** For `y ∈ V`,
     the proper connected slice `X × {y}` maps under `f` into the affine `U`; a global regular
     function on a proper integral `k̄`-scheme is constant. Mathlib *has* the key fact:
     `AlgebraicGeometry.isField_of_universallyClosed` — for `X` integral and `f : X ⟶ Spec K`
     universally closed (`K` a field), `Γ(X, ⊤)` is a field. Combined with `Γ(affine U) → Γ(X×{y})`
     being a `k̄`-algebra map into a field that is finite over `k̄`
     (`AlgebraicGeometry.finite_appTop_of_universallyClosed` under `LocallyOfFiniteType`) and
     `k̄` algebraically closed, the map `X × {y} → U` factors through a single point. This is the
     "global-sections-constant" argument; assembling it into "image is one point" is the
     remaining work.

These are exactly the "two Mathlib bridges to find/build" flagged in `PROGRESS.md`. Both bridges
are char-free (no theorem of the cube, no cohomology beyond `H⁰`). Bridge 1 is built
(`snd_left_isClosedMap`) and the non-emptiness fibre fact (`hfib`) is closed, so
`rigidity_eqOn_dense_open` is `sorry`-free; bridge 2 (slice-constancy) is decomposed and
assembled (Steps 1–2), with Step 1's geometric slice/section assembly
(`rigidity_eqAt_closedPoint_of_proper_into_affine`) now PROVEN. The categorical reduction
(`rigidity_lemma`, `rigidity_snd_lift`) and the scheme-level gluing (`rigidity_core`) are closed —
the entire chain is axiom-clean (iter-162). -/
theorem rigidity_core
    [IsAlgClosed kbar]
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
    [LocallyOfFiniteType (X ⊗ Y).hom]
    [IsReduced (X ⊗ Y).left]
    [IsSeparated Z.hom]
    (f : (X ⊗ Y) ⟶ Z)
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X)
    (y₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Y)
    (z₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Z)
    (_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀) :
    f = lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f := by
  -- The gluing step is scheme-level rigidity: two maps out of a geometrically irreducible reduced
  -- source into a separated target that agree on a non-empty open agree everywhere. We replicate
  -- the argument of `AlgebraicJacobian.Rigidity`'s `Scheme.Over.ext_of_eqOnOpen` inline (that
  -- file is *downstream* of this one, so its wrapper is unavailable here) directly from Mathlib's
  -- `ext_of_isDominant_of_isSeparated'`. The non-empty open and the agreement on it are the
  -- genuine geometric content, isolated in `rigidity_eqOn_dense_open`.
  obtain ⟨U, hU, h⟩ := rigidity_eqOn_dense_open f x₀ y₀ z₀ _hf
  -- `Spec k̄` is a single point, so geometric irreducibility makes `(X ⊗ Y).left` irreducible.
  haveI : IrreducibleSpace (X ⊗ Y).left :=
    GeometricallyIrreducible.irreducibleSpace_of_subsingleton (X ⊗ Y).hom
  -- A non-empty open of an irreducible space is dense, so its inclusion is dominant.
  haveI : IsDominant (U.ι : (U : (X ⊗ Y).left.Opens).toScheme ⟶ (X ⊗ Y).left) :=
    Scheme.PartialMap.Opens.isDominant_ι (IsOpen.dense U.isOpen hU)
  -- Provide separatedness of `Z.left` over `Spec k̄` in the `OverClass.fromOver` form.
  haveI : IsSeparated (Z.left ↘ Spec (CommRingCat.of kbar)) := ‹IsSeparated Z.hom›
  -- Promote the underlying-scheme equality to an `Over (Spec k̄)` equality.
  refine Over.OverMorphism.ext ?_
  exact ext_of_isDominant_of_isSeparated' (S := Spec (.of kbar))
    (X := (X ⊗ Y).left) (Y := Z.left) (f := f.left)
    (g := (lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f).left) U.ι h

/-- **Rigidity Lemma (Mumford, Form I).** Let `X` be a complete (proper) variety and `Y`, `Z`
any varieties over `k̄`. If `f : X ⊗ Y ⟶ Z` collapses the slice `X × {y₀}` to a single point
`z₀` (encoded as `lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀`), then `f` factors through
the second projection `snd : X ⊗ Y ⟶ Y`, i.e. there is `g : Y ⟶ Z` with `f = snd ≫ g`.

This is the cube-free, cohomology-free entry point of the chain: its only inputs are that
completeness of `X` makes the projection a closed map, and that a proper connected variety has
no nonconstant map to an affine variety. Valid in arbitrary characteristic.

SCAFFOLD: signature refined by the iter-157 prover; see blueprint `thm:rigidity_lemma`
(Mumford, *Abelian Varieties*, Ch. II §4, p. 43).

## iter-157 signature correction (the scaffold was false as stated)

The iter-157 scaffold carried only `[IsProper X.hom]`. **That statement is false**: take `X` =
two disjoint reduced `k̄`-points (proper but disconnected), `Y` = two points, `Z = X`, and
`f : X ⊗ Y ⟶ Z` collapsing the `y₀`-fibre to one point while separating the other fibre. Then
`_hf` holds yet `f` does not factor through `snd`. Mumford's hypothesis is that `X` is a complete
**variety** (irreducible) and `Y`, `Z` are **varieties**; the formal statement therefore needs
`X ⊗ Y` geometrically irreducible and reduced (so the dense-open rigidity glue applies) and `Z`
separated (so agreement on a dense open propagates). These three instances are added; they are
exactly what `Scheme.Over.ext_of_eqOnOpen` (the gluing step) consumes, and what Milne's Rigidity
Theorem 1.1 lists ("`V` complete, `V × W` geometrically irreducible, `Z` separated").

## iter-157 prover progress

The categorical *skeleton* is fully discharged here; only the single geometric core
remains. Concretely, Mumford "chooses any point `x₀ ∈ X`" and sets `g(y) = f(x₀, y)`. We
make this explicit by adding a `k̄`-point `x₀ : 𝟙_ ⟶ X` to the hypotheses (Mumford's
"complete variety `X`" is nonempty, so over `k̄` such a point exists; the downstream
consumer `morphism_P1_to_grpScheme_const` supplies it from `ℙ¹`). The witness is then

  `g := lift (toUnit Y ≫ x₀) (𝟙 Y) ≫ f`   (the section `y ↦ (x₀, y)` post-composed with `f`).

The goal `f = snd X Y ≫ g` rewrites — by pure cartesian-monoidal algebra (`comp_lift`,
`toUnit` uniqueness, `Category.comp_id`) — to

  `f = retract ≫ f`,   where   `retract := lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y)`

is the endomorphism `(x, y) ↦ (x₀, y)` of `X ⊗ Y` that collapses the `X`-axis onto `x₀`.
This reduction (lemma `rigidity_snd_lift`, then one `rw`) is closed below. The
remaining `f = retract ≫ f` is the genuine geometric heart (`rigidity_core`): `f` depends
only on the `Y`-coordinate. Its proof is Mumford's properness/closed-map/affine-constant
argument — see `rigidity_core` for the full decomposition into the two char-free bridges.

**Status (iter-162)**: PROVEN axiom-clean. Categorical reduction (`rigidity_snd_lift`) and
scheme-level gluing (`rigidity_core`, `rigidity_eqOn_dense_open`) all closed; bridge 2
(`rigidity_eqOn_saturated_open_to_affine`) decomposed and assembled — Step 2, Step 1's deep
algebra (`eq_comp_of_isAffine_of_properIntegral`), and Step 1's geometric slice/section assembly
(`rigidity_eqAt_closedPoint_of_proper_into_affine`, via `isIntegral_of_retract`) all PROVEN. The
whole Rigidity-Lemma chain is `sorry`-free. -/
theorem rigidity_lemma
    [IsAlgClosed kbar]
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
    [LocallyOfFiniteType (X ⊗ Y).hom]
    [IsReduced (X ⊗ Y).left]
    [IsSeparated Z.hom]
    (f : (X ⊗ Y) ⟶ Z)
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X)
    (y₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Y)
    (z₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ Z)
    (_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀) :
    ∃ g : Y ⟶ Z, f = snd X Y ≫ g := by
  -- Mumford's witness: `g(y) = f(x₀, y)`, i.e. restrict `f` to the slice `{x₀} × Y`.
  refine ⟨lift (toUnit Y ≫ x₀) (𝟙 Y) ≫ f, ?_⟩
  -- Reassociate and collapse the projection-then-section composite.
  rw [← Category.assoc, rigidity_snd_lift]
  -- Goal is now the geometric core `f = retract ≫ f`.
  exact rigidity_core f x₀ y₀ z₀ _hf

/-! ## The Milne §I.3 chain: additivity and homomorphisms

From the proven `rigidity_lemma` we derive the two additive-structure corollaries of Milne §I.1
that feed the genus-`0` base case (Route C): the additive decomposition of a morphism out of a
product (Corollary 1.5) and the fact that a pointed regular map of abelian varieties is a group
homomorphism (Corollary 1.2). Both are cube-free and cohomology-free — pure consequences of the
Rigidity Lemma and the `GrpObj`-induced group structure on hom-sets
(`CategoryTheory.MonObj.Hom.group`/`Hom.monoid`: `u * v = lift u v ≫ μ`, `u⁻¹ = u ≫ ι`,
`(1 : X ⟶ A) = toUnit X ≫ η`). -/

/-- **Additive decomposition over a product (Milne Corollary 1.5).** Let `V` be complete (proper)
and `V ⊗ W` a variety (geometrically irreducible, reduced, locally of finite type) over an
algebraically closed `k̄`, and let `A` be an abelian variety. Then any morphism `h : V ⊗ W ⟶ A`
based at the identity (`h(v₀, w₀) = η[A]`, encoded `lift v₀ w₀ ≫ h = η[A]`) decomposes — in the
`GrpObj`-induced group on `Hom(V ⊗ W, A)` — as the product of its two axis-restrictions pulled back
along the projections:

  `h = (p ≫ f) · (q ≫ g)`,

where `p = fst V W`, `q = snd V W`, `f = (v ↦ (v, w₀)) ≫ h` is `h|_{V × {w₀}}`, and
`g = (w ↦ (v₀, w)) ≫ h` is `h|_{{v₀} × W}`. The operation `·` is the hom-group multiplication
(`u * v = lift u v ≫ μ`); the statement does **not** assume `A` commutative.

PROOF (Milne, Cor 1.5, §I.1). Form the group difference `φ := h / ((p ≫ f) · (q ≫ g))`. A direct
hom-group computation shows `φ` collapses the complete `V`-axis `V × {w₀}` to the identity (this is
exactly the `_hf` collapse hypothesis of `rigidity_lemma`, using `h(v₀, w₀) = η[A]`), so by the
Rigidity Lemma `φ = q ≫ g'` factors through the second projection; `φ` also vanishes on the
section `{v₀} × W` of `q`, forcing `g' = 1`, hence `φ = 1` and `h = (p ≫ f) · (q ≫ g)`. -/
theorem hom_additive_decomp_of_rigidity
    [IsAlgClosed kbar]
    {V W : Over (Spec (.of kbar))}
    [IsProper V.hom]
    [GeometricallyIrreducible (V ⊗ W).hom]
    [LocallyOfFiniteType (V ⊗ W).hom]
    [IsReduced (V ⊗ W).left]
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom]
    (v₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ V)
    (w₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ W)
    (h : V ⊗ W ⟶ A)
    (hh : lift v₀ w₀ ≫ h = η[A]) :
    h = (fst V W ≫ (lift (𝟙 V) (toUnit V ≫ w₀) ≫ h)) *
        (snd V W ≫ (lift (toUnit W ≫ v₀) (𝟙 W) ≫ h)) := by
  haveI : IsSeparated A.hom := inferInstance
  -- Name the two axis-restrictions (folding the goal's RHS).
  set f : V ⟶ A := lift (𝟙 V) (toUnit V ≫ w₀) ≫ h with hf
  set g : W ⟶ A := lift (toUnit W ≫ v₀) (𝟙 W) ≫ h with hg
  -- Projection/section identities for the two slice sections.
  have hsVfst : lift (𝟙 V) (toUnit V ≫ w₀) ≫ fst V W = 𝟙 V := by simp
  have hsVsnd : lift (𝟙 V) (toUnit V ≫ w₀) ≫ snd V W = toUnit V ≫ w₀ := by simp
  have hsWfst : lift (toUnit W ≫ v₀) (𝟙 W) ≫ fst V W = toUnit W ≫ v₀ := by simp
  have hsWsnd : lift (toUnit W ≫ v₀) (𝟙 W) ≫ snd V W = 𝟙 W := by simp
  -- The cross-restrictions of `h` are the identity, because `h(v₀, w₀) = η[A]`.
  have hwsW : w₀ ≫ lift (toUnit W ≫ v₀) (𝟙 W) = lift v₀ w₀ := by
    rw [comp_lift, Category.comp_id, ← Category.assoc,
      toUnit_unique (w₀ ≫ toUnit W) (𝟙 _), Category.id_comp]
  have hvsV : v₀ ≫ lift (𝟙 V) (toUnit V ≫ w₀) = lift v₀ w₀ := by
    rw [comp_lift, Category.comp_id, ← Category.assoc,
      toUnit_unique (v₀ ≫ toUnit V) (𝟙 _), Category.id_comp]
  have hwg : w₀ ≫ g = η[A] := by rw [hg, ← Category.assoc, hwsW, hh]
  have hvf : v₀ ≫ f = η[A] := by rw [hf, ← Category.assoc, hvsV, hh]
  -- The group difference `φ = h / (f∘p · g∘q)`.
  set φ : V ⊗ W ⟶ A := h / ((fst V W ≫ f) * (snd V W ≫ g)) with hφ
  -- `φ` collapses the complete `V`-axis `V × {w₀}` to the identity.
  have hcolV : lift (𝟙 V) (toUnit V ≫ w₀) ≫ φ = toUnit V ≫ η[A] := by
    rw [← Hom.one_def, hφ, GrpObj.comp_div, ← hf, MonObj.comp_mul,
      ← Category.assoc, hsVfst, Category.id_comp,
      ← Category.assoc, hsVsnd, Category.assoc, hwg, ← Hom.one_def, _root_.mul_one, div_self']
  -- `φ` vanishes on the `{v₀} × W` section of the second projection.
  have hcolW : lift (toUnit W ≫ v₀) (𝟙 W) ≫ φ = (1 : W ⟶ A) := by
    rw [hφ, GrpObj.comp_div, ← hg, MonObj.comp_mul,
      ← Category.assoc, hsWfst, Category.assoc, hvf, ← Hom.one_def,
      ← Category.assoc, hsWsnd, Category.id_comp, _root_.one_mul, div_self']
  -- Rigidity: `φ` factors through the second projection.
  obtain ⟨g', hg'⟩ := rigidity_lemma φ v₀ w₀ η[A] hcolV
  -- The factor is the identity, read off the `{v₀} × W` section.
  have hg'1 : g' = 1 := by
    have hsec : lift (toUnit W ≫ v₀) (𝟙 W) ≫ φ = g' := by
      rw [hg', ← Category.assoc, hsWsnd, Category.id_comp]
    rw [← hsec, hcolW]
  have hφ1 : φ = 1 := by rw [hg', hg'1, MonObj.comp_one]
  -- Conclude `h = f∘p · g∘q`.
  have hdiv : h / ((fst V W ≫ f) * (snd V W ≫ g)) = 1 := by rw [← hφ]; exact hφ1
  exact div_eq_one.mp hdiv

/-- **A pointed regular map of abelian varieties is a homomorphism (Milne Corollary 1.2).** Let
`A`, `B` be abelian varieties over an algebraically closed `k̄` (with `A ⊗ A` a variety —
geometrically irreducible, reduced, locally of finite type, the hypotheses
`hom_additive_decomp_of_rigidity` consumes with `V = W = A`). If a regular map `α : A ⟶ B` sends the
identity to the identity (`η[A] ≫ α = η[B]`), then `α` is a monoid (hence group) homomorphism:
`IsMonHom α`, i.e. `α(a · a') = α(a) · α(a')`.

PROOF (Milne, Cor 1.2, §I.1). Apply the additive decomposition `hom_additive_decomp_of_rigidity`
(Cor 1.5) to `h := μ[A] ≫ α : A ⊗ A ⟶ B`, based at `η[A]` (the hypothesis `h(η, η) = η[B]` is
`η[A] ≫ α = η[B]` since `η[A]` is the hom-group identity). The two axis-restrictions of `h` both
collapse to `α` (by the monoid unit laws `lift_comp_one_right`/`left`: `(a, η) ↦ a` and
`(η, a) ↦ a`), so the decomposition reads `μ[A] ≫ α = (fst ≫ α) · (snd ≫ α) = (α ⊗ α) ≫ μ[B]`,
which is exactly the `mul_hom` axiom; `one_hom` is the pointed hypothesis. -/
theorem av_regularMap_isHom_of_zero
    [IsAlgClosed kbar]
    {A B : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    [GeometricallyIrreducible (A ⊗ A).hom]
    [LocallyOfFiniteType (A ⊗ A).hom]
    [IsReduced (A ⊗ A).left]
    [GrpObj B] [IsProper B.hom]
    (α : A ⟶ B) (hα : η[A] ≫ α = η[B]) :
    IsMonHom α := by
  -- `η[A]` is the identity of the hom-group `Hom(𝟙_, A)`, so `η[A] · η[A] = η[A]`.
  have h1 : (η[A] : 𝟙_ (Over (Spec (.of kbar))) ⟶ A) = 1 := by
    rw [Hom.one_def, toUnit_unique (toUnit _) (𝟙 _), Category.id_comp]
  have hbase : lift η[A] η[A] ≫ μ[A] = η[A] := by
    rw [← Hom.mul_def, h1, _root_.mul_one]
  -- Corollary 1.5 applied to `h := μ[A] ≫ α` with `V = W = A`, based at `η[A]`.
  have key := hom_additive_decomp_of_rigidity (V := A) (W := A) (A := B)
    η[A] η[A] (μ[A] ≫ α) (by rw [← Category.assoc, hbase, hα])
  -- Both axis-restrictions of `μ[A] ≫ α` reduce to `α` (monoid unit laws).
  rw [show lift (𝟙 A) (toUnit A ≫ η[A]) ≫ μ[A] ≫ α = α by
        rw [← Category.assoc, lift_comp_one_right, Category.id_comp],
      show lift (toUnit A ≫ η[A]) (𝟙 A) ≫ μ[A] ≫ α = α by
        rw [← Category.assoc, lift_comp_one_left, Category.id_comp]] at key
  -- `key : μ[A] ≫ α = (fst A A ≫ α) · (snd A A ≫ α)`; package as `IsMonHom`.
  exact { one_hom := hα, mul_hom := by rw [key, Hom.mul_def, lift_fst_comp_snd_comp] }

/-! ### Iter-167 dominance bridge for the canonical `Gm ↪ ℙ¹` map

The four product / Proj instances `morphism_P1_to_grpScheme_const_aux` needs
(`GeometricallyIrreducible`, `LocallyOfFiniteType`, `IsReduced` of the product, and
`IsReduced (ProjectiveLineBar kbar).left`) all ship from Lane A
(`AlgebraicJacobian.Genus0BaseObjects`) as the instances `projGm_geomIrred`,
`projGm_locallyOfFiniteType`, `projGm_isReduced`, and `projectiveLineBar_isReduced`. The
helper resolves them all by `infer_instance`.

The one remaining bridge — dominance of the canonical inclusion `ι : Gm ⟶ ℙ¹` — is
file-local because its proof depends on the concrete chartwise body of `gmScalingP1` (still
a Lane A scaffold sorry through iter-167). It is exposed here as a named top-level lemma
`iotaGm_isDominant` so the helper carries no inline `sorry`. -/

/-- **The canonical `Gm ↪ ℙ¹` inclusion `ι : Gm ⟶ ℙ¹` is dominant.** Here `ι` is the
"specialise the scaling action at `x = 1`" map `lift (toUnit Gm ≫ onePt) (𝟙 Gm) ≫ gmScalingP1`.
Once Lane A ships the concrete `gmScalingP1` body (chartwise glue), this becomes the standard
open immersion `Gm = Spec k̄[t, t⁻¹] ↪ ℙ¹` (sending `λ` to `[λ : 1]`), which is dense in the
irreducible `ℙ¹`.

Project-side bridge pending Lane A's concrete `gmScalingP1` body. -/
private lemma iotaGm_isDominant [IsAlgClosed kbar] :
    IsDominant (lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
      ≫ gmScalingP1 kbar).left :=
  sorry

/-- **Helper (pointed case): a morphism `f : ℙ¹ → A` killing `0 ∈ ℙ¹` is the constant `1`.**
Over an algebraically closed field `k̄`, if `f : ProjectiveLineBar kbar ⟶ A` satisfies
`ProjectiveLineBar.zeroPt kbar ≫ f = η[A]`, then `f = (1 : ProjectiveLineBar kbar ⟶ A)`
(equivalently `f = toUnit ProjectiveLineBar ≫ η[A]`).

This is the pointed core of the `𝔾ₘ`-scaling shortcut: form `h := gmScalingP1 ≫ f`, feed it
to Cor 1.5 (`hom_additive_decomp_of_rigidity`) with `V = ProjectiveLineBar`, `W = Gm`, base
points `zeroPt`, `onePt`. The `W`-axis collapses by `gmScalingP1_collapse_at_zero`, leaving
`h = fst ≫ fV` (the relation `f(λx) = fV(x)`). Specialising at `x = 1` (via the canonical
inclusion `Gm ↪ ℙ¹` given by `λ ↦ σ×(1, λ) = λ`) and using density of `Gm ⊆ ℙ¹` plus
separatedness of `A` (via `ext_of_isDominant_of_isSeparated'`, the same Mathlib bridge
`rigidity_core` uses inline), we conclude `f = toUnit ℙ¹ ≫ (onePt ≫ fV)`. The basepoint
hypothesis then pins `onePt ≫ fV = η[A]`.

**Status (iter-167):** body fully refactored — all five in-line product/Proj `sorry`s have
been eliminated. Four of them (`GeometricallyIrreducible`, `LocallyOfFiniteType`, `IsReduced`
of the product, and `IsReduced (ProjectiveLineBar kbar).left`) ship from Lane A
(`AlgebraicJacobian.Genus0BaseObjects` instances `projGm_geomIrred`,
`projGm_locallyOfFiniteType`, `projGm_isReduced`, `projectiveLineBar_isReduced`) and resolve
by `infer_instance` in scope. The fifth — dominance of the canonical `Gm ↪ ℙ¹` map — is
exposed as the named top-level bridge `iotaGm_isDominant` above (a single `sorry` pending
Lane A's `gmScalingP1` body). The helper itself contains no `sorry`. -/
private theorem morphism_P1_to_grpScheme_const_aux
    [IsAlgClosed kbar]
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : ProjectiveLineBar kbar ⟶ A)
    (hf0 : ProjectiveLineBar.zeroPt kbar ≫ f = η[A]) :
    f = (1 : ProjectiveLineBar kbar ⟶ A) := by
  -- W-axis collapse via `gmScalingP1_collapse_at_zero`, precomposed with `onePt`:
  -- `lift zeroPt onePt ≫ gmScalingP1 = zeroPt`.
  have hcollapse :
      lift (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar) ≫ gmScalingP1 kbar
        = ProjectiveLineBar.zeroPt kbar := by
    have hbase := gmScalingP1_collapse_at_zero kbar
    -- Rewrite `lift zeroPt onePt = onePt ≫ lift (toUnit Gm ≫ zeroPt) (𝟙 Gm)`.
    have hreshape :
        lift (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar)
          = Gm.onePt kbar ≫
            lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) := by
      rw [comp_lift, Category.comp_id]
      congr 1
      rw [← Category.assoc,
        toUnit_unique (Gm.onePt kbar ≫ toUnit (Gm kbar)) (𝟙 _), Category.id_comp]
    rw [hreshape, Category.assoc, hbase, ← Category.assoc,
      toUnit_unique (Gm.onePt kbar ≫ toUnit (Gm kbar)) (𝟙 _), Category.id_comp]
  -- The Cor 1.5 basepoint hypothesis `lift v₀ w₀ ≫ (σ ≫ f) = η[A]`.
  have hcorhyp :
      lift (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar)
        ≫ (gmScalingP1 kbar ≫ f) = η[A] := by
    rw [← Category.assoc, hcollapse]; exact hf0
  -- Apply Cor 1.5.
  have key := hom_additive_decomp_of_rigidity
    (V := ProjectiveLineBar kbar) (W := Gm kbar)
    (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar)
    (gmScalingP1 kbar ≫ f) hcorhyp
  -- W-axis restriction: `lift (toUnit Gm ≫ zeroPt) (𝟙 Gm) ≫ σ ≫ f = (1 : Gm ⟶ A)`.
  have hfW :
      lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar))
        ≫ (gmScalingP1 kbar ≫ f) = (1 : Gm kbar ⟶ A) := by
    rw [← Category.assoc, gmScalingP1_collapse_at_zero, Category.assoc, hf0]
    exact Hom.one_def.symm
  -- `snd ≫ fW = snd ≫ 1 = 1` (using `toUnit` uniqueness).
  have hSndFW :
      snd (ProjectiveLineBar kbar) (Gm kbar)
        ≫ (lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar))
          ≫ (gmScalingP1 kbar ≫ f))
        = (1 : ProjectiveLineBar kbar ⊗ Gm kbar ⟶ A) := by
    rw [hfW, Hom.one_def, ← Category.assoc]
    congr 1
    exact toUnit_unique _ _
  -- `key` now reads `σ ≫ f = fst ≫ fV` (after collapsing the W-axis to 1).
  rw [hSndFW, _root_.mul_one] at key
  -- Name the V-axis restriction `fV`.
  set fV : ProjectiveLineBar kbar ⟶ A :=
    lift (𝟙 (ProjectiveLineBar kbar)) (toUnit (ProjectiveLineBar kbar) ≫ Gm.onePt kbar)
      ≫ (gmScalingP1 kbar ≫ f) with hfVdef
  -- Precompose `key` with `gmInP1 := lift (toUnit Gm ≫ onePt) (𝟙 Gm) : Gm → ℙ¹ ⊗ Gm`
  -- ("λ ↦ (1, λ)"). The resulting morphism `ι := gmInP1 ≫ σ : Gm → ℙ¹` is the canonical
  -- inclusion `Gm ↪ ℙ¹` ("λ ↦ σ×(1, λ) = λ"); on its image, `f` is constant at `onePt ≫ fV`.
  set iotaGm : Gm kbar ⟶ ProjectiveLineBar kbar :=
    lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
      ≫ gmScalingP1 kbar with hιdef
  have hιf :
      iotaGm ≫ f = toUnit (Gm kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
    calc iotaGm ≫ f
        = lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
            ≫ (gmScalingP1 kbar ≫ f) := by rw [hιdef, Category.assoc]
      _ = lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
            ≫ (fst (ProjectiveLineBar kbar) (Gm kbar) ≫ fV) := by rw [key]
      _ = (lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
            ≫ fst (ProjectiveLineBar kbar) (Gm kbar)) ≫ fV := by
          rw [Category.assoc]
      _ = (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) ≫ fV := by rw [lift_fst]
      _ = toUnit (Gm kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
          rw [Category.assoc]
  -- Separatedness of the target `A` over `Spec k̄` in `OverClass.fromOver` form.
  haveI hAsep : IsSeparated A.hom := IsProper.toIsSeparated
  haveI : IsSeparated (A.left ↘ Spec (CommRingCat.of kbar)) := hAsep
  -- `IsReduced (ProjectiveLineBar kbar).left` and the product geom-irred / LOFT / IsReduced
  -- instances are all auto-resolved via Lane A's exports in `Genus0BaseObjects`
  -- (`projectiveLineBar_isReduced`, `projGm_geomIrred`, `projGm_locallyOfFiniteType`,
  -- `projGm_isReduced`). Dominance of `ι.left` is the only file-local bridge, cited
  -- explicitly via `iotaGm_isDominant` (the `set`-binding `hιdef` exposes `iotaGm.left`
  -- definitionally as `(lift _ _ ≫ gmScalingP1 kbar).left`).
  haveI hιDom : IsDominant iotaGm.left := iotaGm_isDominant
  -- Globalise: `ι ≫ f = ι ≫ (toUnit ℙ¹ ≫ (onePt ≫ fV))` gives, by dominance, `f = toUnit ℙ¹ ≫ c`.
  have hf_eq :
      f = toUnit (ProjectiveLineBar kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
    -- Promote the Over morphism equality from the underlying scheme equality.
    have hgoal :
        iotaGm ≫ f
          = iotaGm ≫ (toUnit (ProjectiveLineBar kbar) ≫
              (ProjectiveLineBar.onePt kbar ≫ fV)) := by
      have hreshape :
          iotaGm ≫ (toUnit (ProjectiveLineBar kbar) ≫
              (ProjectiveLineBar.onePt kbar ≫ fV))
            = toUnit (Gm kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
        rw [← Category.assoc,
          toUnit_unique (iotaGm ≫ toUnit (ProjectiveLineBar kbar)) (toUnit (Gm kbar))]
      rw [hreshape, hιf]
    refine Over.OverMorphism.ext ?_
    refine ext_of_isDominant_of_isSeparated' (S := Spec (.of kbar))
      (X := (ProjectiveLineBar kbar).left) (Y := A.left)
      (f := f.left)
      (g := (toUnit (ProjectiveLineBar kbar) ≫
        (ProjectiveLineBar.onePt kbar ≫ fV)).left) iotaGm.left ?_
    rw [← Over.comp_left, ← Over.comp_left]
    exact congrArg Over.Hom.left hgoal
  -- Pin `onePt ≫ fV = η[A]` via the basepoint hypothesis `hf0`.
  have hc : ProjectiveLineBar.onePt kbar ≫ fV = η[A] := by
    have hcomp := hf0
    rw [hf_eq] at hcomp
    rw [← Category.assoc,
      toUnit_unique (ProjectiveLineBar.zeroPt kbar ≫ toUnit (ProjectiveLineBar kbar))
        (𝟙 _),
      Category.id_comp] at hcomp
    exact hcomp
  rw [hf_eq, hc, ← Hom.one_def]

/-- **A morphism `ℙ¹ → A` is constant.** Over an algebraically closed field `k̄`, every
morphism `f : ProjectiveLineBar kbar ⟶ A` from the projective line into an abelian variety
`A` (a smooth proper geometrically irreducible group scheme) is constant: it factors through
a single `k̄`-point `a₀ : 𝟙_ ⟶ A`, i.e. `f = toUnit ℙ¹ ≫ a₀`.

The single-curve base case of Milne's Proposition 3.10. **Route resolved iter-164: the
𝔾ₘ-scaling shortcut** — NO theorem of the cube, NO Milne Thm 3.2, NO `Hom(𝔾ₐ, A) = 0`,
char-general. The proof body proceeds by translating in the group `A` to reduce to the
basepoint case `zeroPt ≫ f = η[A]` (handled by the helper
`morphism_P1_to_grpScheme_const_aux`), then un-translating.

See blueprint `prop:morphism_P1_to_AV_constant`
(Milne, *Abelian Varieties*, Prop. 3.10).

**Status (iter-166):** body landed. Carries propagated `sorryAx` via the helper's residuals
(three product-instance Mathlib bridges + dominance of the canonical `Gm → ℙ¹` map). Lifts
to axiom-clean once those are discharged. -/
theorem morphism_P1_to_grpScheme_const
    [IsAlgClosed kbar]
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : ProjectiveLineBar kbar ⟶ A) :
    ∃ a₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ A,
      f = toUnit (ProjectiveLineBar kbar) ≫ a₀ := by
  -- Witness: `a₀ := zeroPt ≫ f` (the value of `f` at the scaling fixed point `0 ∈ ℙ¹`).
  refine ⟨ProjectiveLineBar.zeroPt kbar ≫ f, ?_⟩
  -- Translate: form `f' := f / (toUnit ℙ¹ ≫ a₀)` and apply the helper to `f'`.
  have hf' :
      (f / (toUnit (ProjectiveLineBar kbar) ≫ ProjectiveLineBar.zeroPt kbar ≫ f))
        = (1 : ProjectiveLineBar kbar ⟶ A) := by
    apply morphism_P1_to_grpScheme_const_aux
    -- Show `zeroPt ≫ (f / (toUnit ℙ¹ ≫ a₀)) = η[A]`.
    rw [GrpObj.comp_div]
    have hv :
        ProjectiveLineBar.zeroPt kbar ≫
            toUnit (ProjectiveLineBar kbar) ≫
              (ProjectiveLineBar.zeroPt kbar ≫ f)
          = ProjectiveLineBar.zeroPt kbar ≫ f := by
      rw [← Category.assoc,
        toUnit_unique (ProjectiveLineBar.zeroPt kbar ≫ toUnit (ProjectiveLineBar kbar))
          (𝟙 _),
        Category.id_comp]
    rw [hv, div_self', Hom.one_def, toUnit_unique (toUnit _) (𝟙 _), Category.id_comp]
  -- Untranslate: `f / (toUnit ℙ¹ ≫ a₀) = 1` ⟺ `f = toUnit ℙ¹ ≫ a₀`.
  exact div_eq_one.mp hf'

/-- **A genus-`0` curve over `k̄` is isomorphic to `ℙ¹`.** Over an algebraically closed field
`k̄`, a smooth proper geometrically irreducible curve `C` with `genus C = 0` is isomorphic — in
`Over (Spec (.of kbar))` — to the concrete projective line `ProjectiveLineBar kbar`.

Hartshorne's Example IV.1.3.5 (Riemann–Roch). Its formalisation is a genuine sub-build:
Mathlib has no Riemann–Roch for curves; this is the dominant long pole flagged by the
iter-164 progress-critic.

See blueprint `prop:genusZero_curve_iso_P1`
(Hartshorne, *Algebraic Geometry*, Example IV.1.3.5).

**Status (iter-166):** signature refactored to the concrete `ProjectiveLineBar kbar`; body
remains `sorry` (RR bridge — iter-167+). -/
theorem genusZero_curve_iso_P1
    [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (_hgenus : genus C = 0) :
    Nonempty (C ≅ ProjectiveLineBar kbar) :=
  sorry

/-- **Headline: rigidity for a pointed genus-`0` curve.** Over an algebraically closed field
`k̄` (arbitrary characteristic — no `[CharZero kbar]`), let `C` be a smooth proper geometrically
irreducible curve with `genus C = 0` and `A` an abelian variety (smooth proper geom-irred group
scheme). Then every morphism `f : C ⟶ A` killing a `k̄`-point `p` (`p ≫ f = η[A]`) equals the
constant morphism at the identity, `f = toUnit C ≫ η[A]`.

This is the project's committed characteristic-free statement that `genusZeroWitness` consumes
(via the `k̄ → k` descent step hosted in `AlgebraicJacobian.Jacobian`). Its signature mirrors
`AlgebraicGeometry.rigidity_over_kbar` of `AlgebraicJacobian.RigidityKbar` **verbatim except**
the `[CharZero kbar]` instance is dropped. Combine `genusZero_curve_iso_P1` (`C ≅ ℙ¹`) with
`morphism_P1_to_grpScheme_const` (`ℙ¹ → A` constant) and pin the constant value to `η[A]` via
the pointed hypothesis. No `df = 0`, no Serre duality, no Picard representability.

**Status (iter-166):** body landed. Carries propagated `sorryAx` via `genusZero_curve_iso_P1`
(RR bridge, iter-167+) and `morphism_P1_to_grpScheme_const`'s helper residuals. Once the RR
bridge closes and the helper's product-instance + dominance sorries discharge, lifts to
axiom-clean. -/
theorem rigidity_genus0_curve_to_grpScheme
    [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom]
    [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    (_hgenus : genus C = 0)
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : C ⟶ A)
    (p : 𝟙_ (Over (Spec (.of kbar))) ⟶ C)
    (_hf : p ≫ f = η[A]) :
    f = (toUnit C ≫ η[A]) := by
  -- Transport `f` along `C ≅ ProjectiveLineBar kbar` to a morphism `g : ℙ¹ ⟶ A`.
  obtain ⟨φ⟩ := genusZero_curve_iso_P1 _hgenus
  set g : ProjectiveLineBar kbar ⟶ A := φ.inv ≫ f with hgdef
  -- `morphism_P1_to_grpScheme_const` gives `g = toUnit ℙ¹ ≫ a₀` for some `a₀`.
  obtain ⟨a₀, hga₀⟩ := morphism_P1_to_grpScheme_const g
  -- Pin `a₀ = η[A]` via the pointed hypothesis on `f`.
  have hpoint : (p ≫ φ.hom) ≫ g = η[A] := by
    rw [hgdef, Category.assoc, ← Category.assoc φ.hom, φ.hom_inv_id, Category.id_comp]
    exact _hf
  have hcst : a₀ = η[A] := by
    rw [hga₀, ← Category.assoc,
      toUnit_unique ((p ≫ φ.hom) ≫ toUnit (ProjectiveLineBar kbar)) (𝟙 _),
      Category.id_comp] at hpoint
    exact hpoint
  rw [hcst] at hga₀
  -- Back-transport: `f = φ.hom ≫ g = φ.hom ≫ toUnit ℙ¹ ≫ η[A] = toUnit C ≫ η[A]`.
  calc f
      = φ.hom ≫ φ.inv ≫ f := by
        rw [← Category.assoc, φ.hom_inv_id, Category.id_comp]
    _ = φ.hom ≫ g := by rw [hgdef]
    _ = φ.hom ≫ toUnit (ProjectiveLineBar kbar) ≫ η[A] := by rw [hga₀]
    _ = toUnit C ≫ η[A] := by
        rw [← Category.assoc,
          toUnit_unique (φ.hom ≫ toUnit (ProjectiveLineBar kbar)) (toUnit C)]

end AlgebraicGeometry
