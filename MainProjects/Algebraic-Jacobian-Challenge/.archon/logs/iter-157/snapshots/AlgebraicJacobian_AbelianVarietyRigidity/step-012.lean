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

The minimal chain has four links, all scaffolded here as `sorry`:

1. `rigidity_lemma` — the Rigidity Lemma (Mumford, Form I): the cube-free, cohomology-free
   properness/closed-map entry point.
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

/-- **The dense-open agreement (the genuine geometric content, deferred).** Mumford's open
`X × V` together with the slice-constancy `f(x, y) = f(x₀, y)` on it, packaged as the single
existential that `rigidity_core`'s gluing step consumes: there is a non-empty open `U` of
`(X ⊗ Y).left` on which `f` and the collapsed map `retract ≫ f` agree as scheme morphisms.

This is where the two char-free Mathlib bridges of `rigidity_core`'s docstring are discharged:
the closed-map argument (`IsProper.toUniversallyClosed` ⟹ the projection is closed) produces the
non-empty open `U = X × V`, and the affine-constancy argument
(`isField_of_universallyClosed` on each proper integral slice mapping to an affine) supplies the
scheme-level equality on `U`. It is the sole remaining `sorry` of the Rigidity-Lemma chain. -/
theorem rigidity_eqOn_dense_open
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    (f : (X ⊗ Y) ⟶ Z)
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X) :
    ∃ U : (X ⊗ Y).left.Opens, (U : Set (X ⊗ Y).left).Nonempty ∧
      (U.ι : (U : (X ⊗ Y).left.Opens).toScheme ⟶ (X ⊗ Y).left) ≫ f.left =
        (U.ι : (U : (X ⊗ Y).left.Opens).toScheme ⟶ (X ⊗ Y).left) ≫
          (lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f).left :=
  sorry

/-- **Geometric core of the Rigidity Lemma (honestly deferred).** With `X` complete (proper)
and `x₀ : 𝟙_ ⟶ X` a `k̄`-point, the morphism `f : X ⊗ Y ⟶ Z` is invariant under the
"collapse-the-`X`-axis-onto-`x₀`" endomorphism `retract := lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y)`:

  `f = retract ≫ f`,

i.e. `f(x, y) = f(x₀, y)` for all `(x, y)` — `f` depends only on the `Y`-coordinate. This is
the entirety of the *geometric* content of Mumford's Rigidity Lemma (Form I); the rest of
`rigidity_lemma` is the cartesian-monoidal algebra discharged by `rigidity_snd_lift`.

## Mumford's proof of this core (Abelian Varieties, Ch. II §4, p. 43)

Set `g(y) = f(x₀, y)` (so `retract ≫ f` is exactly `(x, y) ↦ g(y)`). To prove `f = retract ≫ f`
it suffices, since `X ⊗ Y` is a variety (reduced + irreducible) and `Z` is separated, to prove
agreement on a non-empty open `X × V ⊆ X ⊗ Y` (then `Scheme.Over.ext_of_eqOnOpen` of
`AlgebraicJacobian.Rigidity` finishes — it needs `[GeometricallyIrreducible (X ⊗ Y).hom]`,
`[IsReduced (X ⊗ Y).left]`, `[IsSeparated Z.hom]`). The open `V` is produced as follows:
let `U` be an affine open neighbourhood of a chosen point in `Z`, `F = Z ∖ U`, and
`G = (snd X Y) '' (f ⁻¹ F)`. Then for each `y ∈ V := Y ∖ G`, the slice `f(X × {y}) ⊆ U`.

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
no cohomology beyond `H⁰`). Until they are assembled, this core is the sole `sorry` of the
Rigidity-Lemma chain. -/
theorem rigidity_core
    {X Y Z : Over (Spec (.of kbar))}
    [IsProper X.hom]
    [GeometricallyIrreducible (X ⊗ Y).hom]
    [IsReduced (X ⊗ Y).left]
    [IsSeparated Z.hom]
    (f : (X ⊗ Y) ⟶ Z)
    (x₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ X) :
    f = lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) ≫ f := by
  -- The gluing step is scheme-level rigidity: two maps out of a geometrically irreducible reduced
  -- source into a separated target that agree on a non-empty open agree everywhere. We replicate
  -- the argument of `AlgebraicJacobian.Rigidity`'s `Scheme.Over.ext_of_eqOnOpen` inline (that
  -- file is *downstream* of this one, so its wrapper is unavailable here) directly from Mathlib's
  -- `ext_of_isDominant_of_isSeparated'`. The non-empty open and the agreement on it are the
  -- genuine geometric content, isolated in `rigidity_eqOn_dense_open`.
  obtain ⟨U, hU, h⟩ := rigidity_eqOn_dense_open f x₀
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
  exact rigidity_core f x₀

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
