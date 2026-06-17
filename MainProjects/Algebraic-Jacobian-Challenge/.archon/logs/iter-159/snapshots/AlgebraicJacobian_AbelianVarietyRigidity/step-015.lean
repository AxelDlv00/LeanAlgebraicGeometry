/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus

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
   properness/closed-map entry point. **Proven** (iter-157–159) modulo the single residual
   geometric helper `rigidity_eqOn_saturated_open_to_affine` (bridge 2, the slice-constancy /
   affine-constancy equation), which is the lone `sorry` of the Rigidity-Lemma chain.
2. `morphism_P1_to_grpScheme_const` — every morphism `ℙ¹ → A` into an abelian variety is
   constant (blocked downstream on the theorem of the cube).
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

/-- **Bridge 2 of the Rigidity Lemma (slice-constancy / the agreement equation), the residual
geometric input.** Let `X` be complete (proper) over an algebraically closed `k̄`, `x₀` a
`k̄`-point of `X`, and `f : X ⊗ Y ⟶ Z` into a separated `Z`. Let `U = p₂⁻¹(V)` be a `p₂`-saturated
open of `X ⊗ Y` (the preimage of a set `Vset ⊆ Y`) on which `f` lands inside a single **affine**
open `U₀ ⊆ Z`. Then `f` agrees on `U` with the collapsed map `retract ≫ f`
(`retract := lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y)`, i.e. `(x, y) ↦ (x₀, y)`):

  `U.ι ≫ f.left = U.ι ≫ (retract ≫ f).left`.

This is the cohomology-free **route B** of the iter-159 `mathlib-analogist` consult
(`analogies/rigidity-affineconst.md`); it is the genuinely-deep residual of the Rigidity-Lemma
chain (analogist estimate ≈ 1–2 further iterations) and is therefore isolated here as a named
top-level obligation with a precise statement and `sorry` body. The relative Stein-factorisation /
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
        (lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f).left :=
  sorry

/-- **The dense-open agreement (the genuine geometric content).** Mumford's open
`X × V` together with the slice-constancy `f(x, y) = f(x₀, y)` on it, packaged as the single
existential that `rigidity_core`'s gluing step consumes: there is a non-empty open `U` of
`(X ⊗ Y).left` on which `f` and the collapsed map `retract ≫ f` agree as scheme morphisms.

**Status (iter-159): this lemma is now `sorry`-free in its own body.** The construction of the
non-empty open `U = X × V` (closed-map bridge 1, `snd_left_isClosedMap`) and its non-emptiness
(`y₀ ∉ G` via the collapse hypothesis `_hf`, using the pullback-fibre fact `hfib` over the
`k̄`-point `y₀`) are discharged here. The one remaining geometric input — slice-constancy on `U`
(bridge 2) — is delegated to the named helper `rigidity_eqOn_saturated_open_to_affine` (the lone
`sorry` of the Rigidity-Lemma chain; its affine-containment hypothesis is read off the definition
of `G` inside this proof).

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

/-- **Geometric core of the Rigidity Lemma (PROVEN, modulo `rigidity_eqOn_dense_open`).** With
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
everywhere. The single deferred input is the existence of that non-empty open together with the
agreement on it — `rigidity_eqOn_dense_open` — which is the actual geometry below.

This core carries the **collapse hypothesis** `_hf : f(X × {y₀}) = {z₀}` (encoded
`lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀`), passed straight through to
`rigidity_eqOn_dense_open`: it is exactly what makes Mumford's open `V := Y ∖ G` non-empty
(`y₀ ∉ G`). Without it the core statement is **false** (`f := fst` is not collapse-invariant).

## Mumford's proof of `rigidity_eqOn_dense_open` (Abelian Varieties, Ch. II §4, p. 43)

Set `g(y) = f(x₀, y)` (so `retract ≫ f` is exactly `(x, y) ↦ g(y)`). The open `V` is produced as
follows: let `U` be an affine open neighbourhood of a chosen point in `Z`, `F = Z ∖ U`, and
`G = (snd X Y) '' (f ⁻¹ F)`. Then for each `y ∈ V := Y ∖ G`, the slice `f(X × {y}) ⊆ U`, and `f`
agrees with `retract ≫ f` on the non-empty open `X × V`.

This rests on **two Mathlib bridges still to be built** (the cube-free heart):

  1. **Properness ⇒ the projection is a closed map.** `IsProper X.hom` is universally closed
     (`AlgebraicGeometry.IsProper.toUniversallyClosed`), and `snd X Y` is the base change of
     `X.hom` along `Y.hom`, hence universally closed, hence a closed map
     (`AlgebraicGeometry.UniversallyClosed.universally_isClosedMap` instantiated at the relevant
     pullback square). So `G = snd '' (closed)` is closed and `V` is open. The missing glue is
     identifying the monoidal `snd X Y` in `Over (Spec k̄)` with the scheme-theoretic pullback
     projection `Limits.pullback.snd X.hom Y.hom` and transporting `IsClosedMap` across that
     identification. (Search: `MorphismProperty.pullback`, `Over.tensor`/`Over.cartesian…`,
     `Limits.pullback.snd`.)

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

These are exactly the "two Mathlib bridges to find/build" flagged in `PROGRESS.md`. iter-157
located concrete Mathlib entry points for *both* (named above), upgrading the prior "likely
lacks this" assessment: the obstruction is assembly + the monoidal-`snd`-as-pullback
identification, not absent infrastructure. Both bridges are char-free (no theorem of the cube,
no cohomology beyond `H⁰`). Until they are assembled, `rigidity_eqOn_dense_open` is the sole
`sorry` of the Rigidity-Lemma chain — both the categorical reduction (`rigidity_lemma`,
`rigidity_snd_lift`) and the scheme-level gluing (`rigidity_core`) are closed. -/
theorem rigidity_core
    [IsAlgClosed kbar]
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
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
argument and is the one honestly-deferred obligation — see `rigidity_core` for the full
decomposition into the two Mathlib bridges still to be built.

**Status**: iter-157 — categorical reduction closed; geometric core (`rigidity_core`) is
the sole remaining `sorry`. -/
theorem rigidity_lemma
    [IsAlgClosed kbar]
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
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

/-- **A morphism `ℙ¹ → A` is constant.** Over an algebraically closed field `k̄`, every
morphism `f : ℙ¹ ⟶ A` from the projective line into an abelian variety `A` (a smooth proper
geometrically irreducible group scheme) is constant: it factors through a single `k̄`-point
`a₀ : 𝟙_ ⟶ A`, i.e. `f = toUnit ℙ¹ ≫ a₀`.

The single-curve base case of Milne's Proposition 3.10. Cube-free Rigidity-Lemma additivity
drives the multi-factor induction, but the single-curve base rests on the theorem of the cube
(blueprint `thm:theorem_of_the_cube`), recorded there as a deferred deep input.

SCAFFOLD: signature provisional, prover to refine; `ℙ¹` is encoded by the project's abstract
genus-`0`-curve proxy. See blueprint `prop:morphism_P1_to_AV_constant`
(Milne, *Abelian Varieties*, Prop. 3.10).

**Status**: iter-157 scaffold — body is `sorry`. -/
theorem morphism_P1_to_grpScheme_const
    [IsAlgClosed kbar]
    (P1 : Over (Spec (.of kbar)))
    [SmoothOfRelativeDimension 1 P1.hom] [IsProper P1.hom] [GeometricallyIrreducible P1.hom]
    (_hgenus : genus P1 = 0)
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : P1 ⟶ A) :
    ∃ a₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ A, f = toUnit P1 ≫ a₀ :=
  sorry

/-- **A genus-`0` curve over `k̄` is isomorphic to `ℙ¹`.** Over an algebraically closed field
`k̄`, a smooth proper geometrically irreducible curve `C` with `genus C = 0` is isomorphic — in
`Over (Spec (.of kbar))` — to the projective line `ℙ¹` (itself encoded as a genus-`0` curve).

Hartshorne's Example IV.1.3.5 (Riemann–Roch). Its formalisation is a genuine sub-build:
Mathlib has no Riemann–Roch for curves.

SCAFFOLD: signature provisional, prover to refine; both `C` and `ℙ¹` are encoded by the
project's abstract genus-`0`-curve proxy, so the statement reads "any two such genus-`0` curves
are isomorphic". See blueprint `prop:genusZero_curve_iso_P1`
(Hartshorne, *Algebraic Geometry*, Example IV.1.3.5).

**Status**: iter-157 scaffold — body is `sorry`. -/
theorem genusZero_curve_iso_P1
    [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (_hgenus : genus C = 0)
    (P1 : Over (Spec (.of kbar)))
    [SmoothOfRelativeDimension 1 P1.hom] [IsProper P1.hom] [GeometricallyIrreducible P1.hom]
    (_hP1genus : genus P1 = 0) :
    Nonempty (C ≅ P1) :=
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

**Status**: iter-157 scaffold — body is `sorry`. -/
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
    f = (toUnit C ≫ η[A]) :=
  sorry

end AlgebraicGeometry
