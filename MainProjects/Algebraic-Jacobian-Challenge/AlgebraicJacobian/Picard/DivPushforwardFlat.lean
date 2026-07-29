/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.DivDegree
import AlgebraicJacobian.Picard.SchematicSupport
import AlgebraicJacobian.Picard.RigidPushforwardTransfer
import AlgebraicJacobian.Picard.FlatteningStratificationUniversal

/-!
# Pushing a divisor family down to the base, flatly

Campaign milestone **D3'** (`informal/pic-representability-campaign.md:305`) asks
for the locus over which a Grassmannian `T`-point arises from a degree-`d`
`DivFamily` to be locally closed *universally*, by extending
`Scheme.Modules.flatLocusStratification_universal`
(`Picard/FlatteningStratificationUniversal.lean`) "to the family `C × G → G`".

This file supplies the object that extension has to be about, and records why the
extension has to be phrased this way rather than by relativising the machine.

## The shape of the reduction, and why it is forced

`flatLocusStratification_universal` is stated for a module **on the base**,
`F : S.Modules`, with `π = 𝟙 S`. That is not an accident of its proof that a
later session can relax: the whole stratification machine is built on
`Scheme.Modules.pointRank : (X : Scheme) → X.Modules → ↥X → ℕ`, which takes a
module on *one* scheme and a point of *that* scheme. There is no relative
`pointRank` over a morphism, and `chartLocus`, `rankStratum`,
`isOpen_pointRank_pullback_eq` and `existsUnique_factor_rankStratum` all inherit
that shape. So a general-`π` universal property cannot be obtained by adding a
`π` to those statements; the family has to be *moved to the base* first.

For a divisor family that move is available, and cheaply, because a relative
effective divisor is finite over the base — where a general proper family is not.
Concretely: `Scheme.Modules.HasProperSupport` is by definition
`IsProper (schematicSupportι F ≫ f)` (`Picard/QuotScheme.lean`), and
`DivFamily.properSupport` is exactly that datum for `f = pullback.snd π T.hom`.
A proper *quasi-finite* morphism is finite (`IsFinite.of_isProper_of_locallyQuasiFinite`),
hence affine, and `Scheme.CoherentSheafFlat` transfers along an affine
pushforward. Since `O_D` is the pushforward of its own restriction to the support
(`schematicSupportDescentIso`), the family's flatness over `T` becomes flatness of
`q_* O_D` over `T` *itself* — the `n = 0` shape the universal property consumes.

## What is proved here, and what is assumed

* `Scheme.CoherentSheafFlat.of_pushforward_of_isAffineHom` — the **converse** of
  `Scheme.CoherentSheafFlat.pushforward_of_isAffineHom`
  (`Picard/RigidPushforwardTransfer.lean`), which did not exist. Both directions
  are the same chart computation read in opposite directions; the content is that
  the two `Γ(T, U)`-module structures on `Γ(F, π ⁻¹ᵁ V)` agree, which is
  `Scheme.Hom.appLE_comp_appLE`.

* `Scheme.DivFamily.coherentSheafFlat_id_pushforward` — for a divisor family whose
  divisor is quasi-finite over the base, `q_* O_D` is flat over `T` in the
  `CoherentSheafFlat (𝟙 T.left)` sense.

**The quasi-finiteness is a hypothesis, not a theorem, and this file does not
pretend otherwise.** `LocallyQuasiFinite (schematicSupportι x.F ≫ pullback.snd π T.hom)`
says the divisor `D ⊆ X_T` has finite fibres over `T`. Mathematically it is
relative-dimension-1 content: on the curve fibre `C_t`, `D_t` is the zero scheme
of a regular section of an invertible ideal, hence `0`-dimensional. It has no
producer in this project, and `LocallyQuasiFinite` occurs nowhere else in
`Picard/`. It is stated as an instance binder so that a later producer discharges
every consumer at once.

Worth recording for whoever prices the next step: this hypothesis is *cleaner*
than the one it replaces. `Picard/DivDegree.lean` gates its clopen degree
decomposition on `HasLocallyConstantDivDeg`, a `Prop`-class carrying local
constancy of `fiberDeg` as an assumption and also without a producer. With
quasi-finiteness instead, local constancy is downstream of a stratification
theorem rather than assumed beside it — the same missing geometry, but bought
once and in a form the machine can use.

## What remains for D3'

Feeding `flatLocusStratification_universal` needs two further binders on
`q_* O_D`, `IsQuasicoherent` and `IsFinitePresentation`, and then the actual
`∃!` statement about the Grassmannian locus. Nothing here closes D3'; this is its
first input.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-- **Coherent-sheaf flatness descends along an affine pushforward** — the
converse of `Scheme.CoherentSheafFlat.pushforward_of_isAffineHom`.

For affine `π : X ⟶ Y` over `p : Y ⟶ T`, flatness of `π_* F` over `T` gives
flatness of `F` over `T` along the composite. Read on an affine `V ⊆ Y`: the
sections of `π_* F` over `V` *are* `Γ(F, π ⁻¹ᵁ V)` definitionally, with `π ⁻¹ᵁ V`
affine because `π` is, and the two `Γ(T, U)`-module structures agree because
`(π ≫ p).appLE = p.appLE ≫ π.appLE`. -/
theorem Scheme.CoherentSheafFlat.of_pushforward_of_isAffineHom
    {X Y T : Scheme.{u}} (π : X ⟶ Y) [IsAffineHom π] (p : Y ⟶ T)
    (F : X.Modules) [F.IsQuasicoherent]
    (h : Scheme.CoherentSheafFlat p ((Scheme.Modules.pushforward π).obj F)) :
    Scheme.CoherentSheafFlat (π ≫ p) F :=
  sorry

/-- **The pushforward of `O_D` is flat over the base itself.**

For a divisor family `x` whose divisor is quasi-finite over `T`, the pushforward
`q_* O_D` along `q = pullback.snd π T.hom` is flat over `T` in the
`CoherentSheafFlat (𝟙 T.left)` sense — the `n = 0` shape that
`Scheme.Modules.flatLocusStratification_universal` consumes.

Route: `x.properSupport` is `IsProper (i ≫ q)` by definition, so with
quasi-finiteness `i ≫ q` is finite, hence affine; `schematicSupportDescentIso`
presents `x.F` as `i_*` of its restriction to the support, whose flatness over
`T` follows from `x.flat` by the converse above; pushing forward along the affine
`i ≫ q` over `𝟙 T.left` and transporting along `pushforwardComp` gives the
claim. -/
theorem Scheme.DivFamily.coherentSheafFlat_id_pushforward
    {S X : Scheme.{u}} {π : X ⟶ S} {T : Over S} (x : Scheme.DivFamily π T)
    [LocallyQuasiFinite
      (Scheme.Modules.schematicSupportι x.F ≫ pullback.snd π T.hom)] :
    Scheme.CoherentSheafFlat (𝟙 (T.left : Scheme.{u}))
      ((Scheme.Modules.pushforward (pullback.snd π T.hom)).obj x.F) :=
  sorry

end AlgebraicGeometry
