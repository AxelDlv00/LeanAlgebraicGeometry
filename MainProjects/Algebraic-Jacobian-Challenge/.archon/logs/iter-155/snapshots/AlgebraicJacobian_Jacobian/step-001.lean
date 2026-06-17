/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus

/-! # The Jacobian of a smooth proper curve

The Jacobian of a smooth, proper, geometrically irreducible curve over a field, equipped with
its structure as an abelian variety.

## Status (Phase C scaffolding)

The Jacobian is defined uniformly as the underlying scheme of an Albanese witness
(`JacobianWitness`) for the curve `C`; the four protected instances on `Jacobian C` all
project from the witness directly.

This file currently contains TWO `sorry`-bodied declarations (the Phase-C scaffolding
inventory):

1. `genusZeroWitness` (iter-127 scaffold): a `JacobianWitness C` for a genus-`0` curve,
   with underlying scheme `Spec k`. The body is a `sorry` to be closed once pieces
   (i)+(ii)+(iii) of the shared cotangent-vanishing pile land (iter-138+); the
   substantive mathematical content is the genus-`0` rigidity statement
   `rigidity_over_kbar` (M2.a; `AlgebraicJacobian.RigidityKbar`).
2. `nonempty_jacobianWitness` (Phase-C OFF-LIMITS sorry): existence of an Albanese
   witness for an arbitrary smooth proper geometrically irreducible curve; gated on
   M2 + M3 closure (Albanese existence in genus `≥ 1` plus genus-`0` rigidity).

The file contains:
- `IsAlbanese`: the Albanese universal property for a pointed curve.
- `IsAlbanese.unique`: uniqueness of the Albanese object up to canonical isomorphism.
- `JacobianWitness`: a bundled candidate Albanese object together with the universal
  property uniformly over the choice of $k$-rational marked point.
- `genusZeroWitness`: an Albanese witness for a genus-`0` curve, body `sorry`
  (iter-127 scaffold; closure deferred to iter-138+).
- `nonempty_jacobianWitness`: existence of an Albanese witness for every curve —
  the headline Phase-C sorry, absorbing both higher-genus Albanese existence and
  genus-`0` rigidity.
- `Jacobian` and its four protected instances, each obtained by projection from the
  Albanese witness.

### Forbidden shortcut (sanity check)

Defining `Jacobian C := 𝟙_ (Over (Spec (.of k)))` *unconditionally* (the terminal object,
i.e. `Spec k`) compiles and discharges three of the four instances for free, but the
fourth instance `SmoothOfRelativeDimension (genus C) (𝟙_ _).hom` would force `genus C = 0`,
which is mathematically wrong for any curve of genus `≥ 1`. The terminal-object definition
is therefore forbidden when `genus C > 0`. The witness-based definition avoids this
issue: in genus `0` the witness's underlying scheme `J` is `Spec k`, and in genus `> 0`
the witness's `J` is the honest Albanese object.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

/-- The Albanese universal property for a pointed smooth proper curve `(C, P)`.
An object `J` (with abelian-variety structure) is the Albanese of `(C, P)` if it
receives a universal pointed morphism `C ⟶ J` sending `P` to the identity. -/
def IsAlbanese (C : Over (Spec (.of k))) (P : 𝟙_ (Over (Spec (.of k))) ⟶ C)
    (J : Over (Spec (.of k)))
    [GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom] : Prop :=
  ∃ α : C ⟶ J, P ≫ α = η[J] ∧
    ∀ {A : Over (Spec (.of k))} [GrpObj A] [IsProper A.hom]
      [Smooth A.hom] [GeometricallyIrreducible A.hom] (f : C ⟶ A) (_ : P ≫ f = η[A]),
      ∃! (g : J ⟶ A), f = α ≫ g

namespace IsAlbanese

noncomputable def ofCurve {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {P : 𝟙_ _ ⟶ C} {J : Over (Spec (.of k))} [GrpObj J] [IsProper J.hom] [Smooth J.hom]
    [GeometricallyIrreducible J.hom] (h : IsAlbanese C P J) : C ⟶ J :=
  Classical.choose h

lemma comp_ofCurve {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {P : 𝟙_ _ ⟶ C} {J : Over (Spec (.of k))} [GrpObj J] [IsProper J.hom] [Smooth J.hom]
    [GeometricallyIrreducible J.hom] (h : IsAlbanese C P J) :
    P ≫ h.ofCurve = η[J] :=
  (Classical.choose_spec h).1

lemma exists_unique_ofCurve_comp {k : Type u} [Field k] {C : Over (Spec (.of k))}
    {P : 𝟙_ _ ⟶ C} {J : Over (Spec (.of k))} [GrpObj J] [IsProper J.hom] [Smooth J.hom]
    [GeometricallyIrreducible J.hom] (h : IsAlbanese C P J)
    {A : Over (Spec (.of k))} [GrpObj A] [IsProper A.hom] [Smooth A.hom]
    [GeometricallyIrreducible A.hom] (f : C ⟶ A) (hf : P ≫ f = η[A]) :
    ∃! (g : J ⟶ A), f = h.ofCurve ≫ g :=
  (Classical.choose_spec h).2 f hf

/-- The Albanese object is unique up to a unique isomorphism compatible with the
universal morphisms. -/
theorem unique {k : Type u} [Field k] {C : Over (Spec (.of k))} {P : 𝟙_ _ ⟶ C}
    {J₁ J₂ : Over (Spec (.of k))}
    [GrpObj J₁] [IsProper J₁.hom] [Smooth J₁.hom] [GeometricallyIrreducible J₁.hom]
    [GrpObj J₂] [IsProper J₂.hom] [Smooth J₂.hom] [GeometricallyIrreducible J₂.hom]
    (h₁ : IsAlbanese C P J₁) (h₂ : IsAlbanese C P J₂) :
    ∃! (e : J₁ ⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e := by
  have ⟨g, hg_eq, hg_unique⟩ := h₁.exists_unique_ofCurve_comp h₂.ofCurve h₂.comp_ofCurve
  have ⟨h, hh_eq, hh_unique⟩ := h₂.exists_unique_ofCurve_comp h₁.ofCurve h₁.comp_ofCurve
  have ⟨g₁, hg₁_eq, hg₁_unique⟩ := h₁.exists_unique_ofCurve_comp h₁.ofCurve h₁.comp_ofCurve
  have g₁_eq_id : g₁ = 𝟙 J₁ := by
    refine (hg₁_unique (𝟙 J₁) ?_).symm
    simp
  have ggh_eq_g₁ : g ≫ h = g₁ := by
    refine hg₁_unique (g ≫ h) ?_
    change h₁.ofCurve = h₁.ofCurve ≫ (g ≫ h)
    rw [← Category.assoc, ← hg_eq, ← hh_eq]
  have hgh : g ≫ h = 𝟙 J₁ := by rw [ggh_eq_g₁, g₁_eq_id]
  have ⟨k₂, hk₂_eq, hk₂_unique⟩ := h₂.exists_unique_ofCurve_comp h₂.ofCurve h₂.comp_ofCurve
  have k₂_eq_id : k₂ = 𝟙 J₂ := by
    refine (hk₂_unique (𝟙 J₂) ?_).symm
    simp
  have hhg_eq_k₂ : h ≫ g = k₂ := by
    refine hk₂_unique (h ≫ g) ?_
    change h₂.ofCurve = h₂.ofCurve ≫ (h ≫ g)
    rw [← Category.assoc, ← hh_eq, ← hg_eq]
  have hhg : h ≫ g = 𝟙 J₂ := by rw [hhg_eq_k₂, k₂_eq_id]
  exact ⟨g, hg_eq, fun g' hg' => hg_unique g' hg'⟩

end IsAlbanese

/-- The identity morphism on `Spec k` is geometrically irreducible.
This is a small helper needed for the genus-0 case of `Jacobian`. -/
lemma geometricallyIrreducible_id_Spec (k : Type u) [Field k] :
    GeometricallyIrreducible (𝟙 (Spec (.of k))) where
  geometrically_irreducibleSpace := by
    intro K _ y Z fst snd h
    haveI : IsIso snd := h.isIso_snd_of_isIso
    exact ObjectProperty.prop_of_iso (P := (IrreducibleSpace · : ObjectProperty Scheme))
      (asIso snd).symm inferInstance

/-- A bundled Albanese witness for the smooth proper geometrically irreducible curve
`C`: a candidate group scheme `J` (with proper, smooth, geometrically irreducible
structure, smooth of relative dimension `genus C`), and a proof that `J` satisfies
the Albanese universal property of Definition `IsAlbanese` for `C` *for every choice
of $k$-rational marked point* `P : 𝟙_ _ ⟶ C`.

Mathematically, the underlying scheme `J` (and its group/proper/smooth/irreducible
structure) is intrinsic to `C`; only the universal morphism `C ⟶ J` depends on the
choice of marked point `P`. Encoding `isAlbaneseFor` as a `∀ P, IsAlbanese …` field
keeps the bundle independent of any specific pointing, which is what
`AbelJacobi.Jacobian.ofCurve P` needs in order to project the Albanese morphism for
an *arbitrary* input `P`.

The smoothness witness is recorded at the specific relative dimension `genus C`,
which is the form required by `Jacobian.smoothOfRelativeDimension_genus`. -/
structure JacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] where
  /-- The candidate Albanese object. -/
  J : Over (Spec (.of k))
  /-- The group-scheme structure on `J`. -/
  grpObj : GrpObj J
  /-- `J` is proper over `k`. -/
  proper : IsProper J.hom
  /-- `J` is smooth over `k`. -/
  smooth : Smooth J.hom
  /-- `J` is geometrically irreducible over `k`. -/
  geomIrred : GeometricallyIrreducible J.hom
  /-- `J` is smooth of relative dimension `genus C` (so dim `J = genus C`). -/
  smoothGenus : SmoothOfRelativeDimension (genus C) J.hom
  /-- The Albanese universal-property data: for every choice of $k$-rational marked
  point `P : 𝟙_ _ ⟶ C`, the scheme `J` together with its group/proper/smooth/irreducible
  structure satisfies the Albanese universal property for the pointed curve `(C, P)`. -/
  isAlbaneseFor : ∀ (P : 𝟙_ _ ⟶ C), @IsAlbanese k _ C P J grpObj proper smooth geomIrred

/-- The Albanese witness for a smooth proper geometrically irreducible curve `C`
of genus `0` over `k`. The underlying scheme is `Spec k` (the terminal object), with
the trivial group structure, smoothness of relative dimension `0` (matching the
hypothesis `genus C = 0`), properness, and geometric irreducibility. The
`isAlbaneseFor` field encodes the universal property: for every $k$-rational
marked point `P` of `C`, the universal morphism `C ⟶ Spec k` is the unique
terminal map `toUnit C`; the substantive content is the rigidity statement
`rigidity_over_kbar` (M2.a; `AlgebraicJacobian.RigidityKbar`), gated on the
shared cotangent-vanishing pile (iter-129+).

**Status**: iter-127 scaffold — body is `sorry`. The body closure is iter-138+
work, after pieces (i)+(ii)+(iii) of the shared cotangent-vanishing pile land.

**Iter-135**: now consumed by the genus-stratified body of
`nonempty_jacobianWitness` (Change 2.1 of iter-135 refactor); body
closure remains iter-138+ work but the witness is now load-bearing
for the protected `nonempty_jacobianWitness` chain.

**Iter-155 (skeleton)**: the bare `sorry` is replaced by the blueprint's
explicit terminal-object witness (Jacobian.tex § C.3). The underlying
scheme is `J := 𝟙_ (Over (Spec k))` (whose `.hom` is defeq `𝟙 (Spec k)`),
and all six structural fields close from Mathlib instances on the identity
plus the project helper `geometricallyIrreducible_id_Spec`. The single
remaining mathematical gap is localized in the `isAlbaneseFor` field, and
within it to exactly the two obstructions the blueprint identifies:
  * `key : f = toUnit C ≫ η[A]` — the genus-0 RIGIDITY content (C.2). This
    is `rigidity_over_kbar` (over `k̄`, NAMED GAP) base-changed and then
    *descended* to the base field `k` along the faithfully-flat surjection
    `Spec k̄ → Spec k` (C.2.f, via `Flat.epi_of_flat_of_surjective`). NOTE:
    `rigidity_over_kbar` additionally requires `[CharZero kbar]`, so the
    char-`p` arm of this `[Field k]` goal is *also* unbacked.
  * the uniqueness clause — cancels the epimorphism `toUnit C` (the structure
    morphism `C.hom` is faithfully flat + surjective, hence epi). -/
noncomputable def genusZeroWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (h : genus C = 0) :
    JacobianWitness C where
  J := 𝟙_ (Over (Spec (.of k)))
  grpObj := inferInstance
  proper := inferInstance
  smooth := inferInstance
  geomIrred := geometricallyIrreducible_id_Spec k
  smoothGenus := by rw [h]; infer_instance
  isAlbaneseFor := by
    -- For every `k`-rational marked point `P`, exhibit the Albanese datum for
    -- the pointed curve `(C, P)` with `J = 𝟙_` (blueprint C.2 / C.3).
    intro P
    -- The universal pointed morphism is the unique terminal map `toUnit C`.
    refine ⟨toUnit C, ?_, ?_⟩
    · -- Pointed condition: both `P ≫ toUnit C` and `η[𝟙_]` are maps `𝟙_ ⟶ 𝟙_`,
      -- equal by uniqueness of morphisms into the terminal object.
      exact toUnit_unique _ _
    · -- Universal factorisation: given `f : C ⟶ A` with `P ≫ f = η[A]`, the
      -- factoring morphism `𝟙_ ⟶ A` is the identity element `η[A]`.
      intro A _ _ _ _ f _hf
      -- The genus-0 RIGIDITY keystone (C.2): `f` equals the constant morphism
      -- at the identity. Over `k̄` this is `rigidity_over_kbar`; over the base
      -- field `k` it is obtained by base-change + faithfully-flat descent
      -- (C.2.f). NAMED GAP — blocked on `rigidity_over_kbar`'s body and on the
      -- char-`p` arm (`rigidity_over_kbar` assumes `[CharZero kbar]`).
      have key : f = toUnit C ≫ η[A] := by
        sorry
      refine ⟨η[A], key, ?_⟩
      -- Uniqueness: any `g'` with `f = toUnit C ≫ g'` equals `η[A]`, by cancelling
      -- the epimorphism `toUnit C` (the structure morphism `C.hom` is faithfully
      -- flat + surjective, hence an epimorphism of schemes).
      intro g' hg'
      have hcancel : toUnit C ≫ g' = toUnit C ≫ η[A] := by rw [← hg', ← key]
      sorry

/-- The Albanese witness for a smooth proper geometrically irreducible curve `C`
of positive genus `g ≥ 1` over `k`. The underlying scheme is the Albanese
variety of `C` — classically the connected component of the identity of
`Pic_{C/k}`, or equivalently the Stein factorisation of the Abel–Jacobi
morphism on `Sym^g(C)`. Both constructions require infrastructure not yet
in Mathlib (FGA representability of the Picard functor for Route A;
symmetric powers + finite-group quotients + Stein factorisation +
Brill–Noether–Riemann–Roch for Route B); the iter-123 M3 route audit
(`analogies/m3-route-audit.md`) records both at midpoint ~6500 and
~9000 LOC respectively.

**Status**: iter-134 scaffold — body is `sorry`. The body closure is M3
work, currently OFF-CRITICAL-PATH until M2 closes (per STRATEGY.md
§ M3, user-escalation-pending).

**Iter-135**: the genus-stratified body restructure of
`nonempty_jacobianWitness` is now in place (Change 2.1 of iter-135
refactor); this scaffold is the positive-genus arm. Body closure
remains M3 work (off-critical-path; user-escalation-pending per
`analogies/m3-route-audit.md`). -/
noncomputable def positiveGenusWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (hg : 0 < genus C) :
    JacobianWitness C :=
  sorry

/-- Existence of an Albanese witness for every smooth proper geometrically irreducible
curve. This is one of the two open mathematical sorries of the Phase-C Jacobian
scaffolding (the other being `genusZeroWitness`); both are scheduled for body
closure post M2 + M3 per STRATEGY.md. It packages all five protected sorries
(`Jacobian`, `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`,
`instGeometricallyIrreducible`) into a single existence hypothesis, *and* records
that the Albanese property of the underlying scheme `J` is uniform over every
choice of $k$-rational marked point `P : 𝟙_ _ ⟶ C` (via the `isAlbaneseFor`
field of `JacobianWitness`).

Mathematically this corresponds to the construction of the Albanese variety of `C`,
classically via symmetric powers $\mathrm{Sym}^g(C)$ and the Abel--Jacobi map
(Brill--Noether--Riemann--Roch), or equivalently as the identity component of the
Picard scheme. Both routes require infrastructure not yet available in Mathlib
(quotients of schemes by finite group actions; FGA representability), so the
existence is assumed.

**Iter-135 body restructure**: the body is now a `by_cases h :
genus C = 0` decomposition consuming `genusZeroWitness` (genus-0 arm)
and `positiveGenusWitness` (positive-genus arm). Both arms' bodies
remain `sorry` (M2.b body closure iter-138+; M3 body closure
off-critical-path); the restructure converts the inline `sorry` here
into honest delegation to the two scaffolds, removing one inline-`sorry`
site without prejudging either arm's body closure. -/
theorem nonempty_jacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    Nonempty (JacobianWitness C) := by
  by_cases h : genus C = 0
  · exact ⟨genusZeroWitness C h⟩
  · exact ⟨positiveGenusWitness C (Nat.pos_of_ne_zero h)⟩

/-- A choice of Albanese witness for `C`, extracted via `Classical.choice`.
Used to define `Jacobian C` and to discharge each of the four protected instances
on it. -/
noncomputable def jacobianWitness (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
    JacobianWitness C :=
  Classical.choice (nonempty_jacobianWitness C)

-- data
/-- The Jacobian of a smooth, proper curve over a field `k`.

The Jacobian is the underlying scheme of an Albanese witness for `C` (see
`JacobianWitness` and `nonempty_jacobianWitness`); the existence of such a
witness is one of the two open mathematical sorries of the Phase-C scaffolding
(the other being `genusZeroWitness`), both scheduled for body closure post
M2 + M3 per STRATEGY.md. The genus-`0` specialisation is implicit in the
witness — a smooth proper geometrically irreducible group scheme over `k` of
relative dimension `0` is `Spec k` — and the genus-`0` rigidity content is
absorbed into `nonempty_jacobianWitness`. -/
noncomputable def Jacobian (C : Over (Spec (.of k))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] : Over (Spec (.of k)) :=
  (jacobianWitness C).J

namespace Jacobian

/-! ## The Jacobian of `C` is an abelian variety. -/

-- data
/-- The group scheme structure on the Jacobian of the curve `C`. -/
noncomputable instance instGrpObj : GrpObj (Jacobian C) := (jacobianWitness C).grpObj

/-- The Jacobian of `C` is smooth of relative dimension `g` over `k`, where `g` is the
genus of `C`. -/
instance smoothOfRelativeDimension_genus : SmoothOfRelativeDimension (genus C) (Jacobian C).hom :=
  (jacobianWitness C).smoothGenus

/-- The Jacobian of `C` is proper over `k`. -/
instance instIsProper : IsProper (Jacobian C).hom := (jacobianWitness C).proper

/-- The Jacobian of `C` is geometrically irreducible over `k`. -/
instance instGeometricallyIrreducible : GeometricallyIrreducible (Jacobian C).hom :=
  (jacobianWitness C).geomIrred

end Jacobian

end AlgebraicGeometry
