/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib
import AlgebraicJacobian.Picard.StableAffineCover

/-!
# The `G`-stable affine cover for a bare finite group action

`Sym^n C` is a quotient of `C^n` by `S_n`, and the route to it that
`Albanese/SymPowColimit.lean` §6 identifies — explicit `Scheme.GlueData` from affine charts —
needs one geometric input above all others: **every point has an affine open neighbourhood
stable under the whole group**. Without it the charts cannot be chosen compatibly and the
quotient exists only as an algebraic space (the Hironaka trap recorded in
`Picard/FiniteGaloisQuotient.lean`).

That input was believed missing for `S_n`. It is not: `Picard/StableAffineCover.lean` proves
it, sorry-free, and its proof **never uses the Galois structure it is stated over**.

## What was actually going on

`Picard/StableAffineCover.lean`'s `exists_stable_affineOpen_of_orbitsInAffineOpen` is stated
for a `SemilinearGalAction K L X f` — a group homomorphism `Gal(L/K) →* Aut X` *together with*
a field `compat`, the commuting square over `Spec γ` that makes the action semilinear. Reading
the proof, the only things it consumes are `ρ.act` and the two one-line consequences
`act_one_hom` / `act_mul_hom`, which are `map_one` and `map_mul` of the underlying
`MonoidHom`. `compat` — all of the semilinearity — is never mentioned, and
`[FiniteDimensional K L]` is spent only on getting a `Fintype` for `Finset.univ`.

So the theorem is about a **finite group acting on a scheme by automorphisms**; the Galois
data decorates the statement. This file states that version. It is a re-derivation, not a
generalisation of the original in place: `Picard/` belongs to another lane, so the proof is
copied here with the binder replaced (`G →* Aut X` plus `Fintype G`) rather than the original
being weakened. The two files should eventually be one, and the note below says which
direction that should go.

## Main results

* `StableGroupAction.OrbitsInAffineOpen` — the EGA II 4.5.4 hypothesis, for a bare action:
  every orbit lies in an affine open. Essential, not technical — see the Hironaka trap.
* `StableGroupAction.IsStableOpen` — a `G`-stable open.
* `exists_stable_affineOpen_of_orbits` — **the theorem**: under that hypothesis every point
  has a `G`-stable affine open neighbourhood. Prime avoidance puts the orbit in a basic open
  `D(s)` inside `⋂_g g⁻¹U`, and the norm `N = ∏_g g(s)` cuts out a stable affine basic open.
**No `S_n` instantiation is provided, and that is a real gap, not an omission.** An earlier
version of this list advertised a `permAction : Equiv.Perm (Fin n) →* Aut (C^n)`; no such
declaration exists, here or anywhere in the tree, and building it is not free:
`MonObj.permAut` is a bare *morphism* never shown to be an isomorphism, and
`SymPowColimit.permEnd` lands in `End`, not `Aut`. So the theorem below is stated at the
generality `S_n` needs but has **no producer** for it yet — see the scope section.

## Why the proof needs no averaging, and so no characteristic hypothesis

The norm `∏_g g(s)` is a *product*, not an average: it needs no `1/|G|` and works in every
characteristic. That matters here for the same reason it matters in
`Albanese/SymPowTensorAction.lean` — `g!` may vanish in `k̄` when `char k̄ ≤ g`, so any route
through averaging would exclude exactly the cases the challenge is stated over.

## Scope — what this does and does not give

**Does**: prove the stable-cover statement at the generality a glue-data construction wants —
a *finite group acting on a scheme by automorphisms*, with no Galois hypothesis and no
characteristic hypothesis.

**Does not**: apply it to `S_n` acting on `C^n`. An earlier version of this section said it
did. That was wrong, and the missing piece is named above: there is no
`Equiv.Perm (Fin n) →* Aut (C^n)` in the tree, because `MonObj.permAut` is not known to be an
isomorphism. Until that exists, this theorem has the right hypotheses and no producer.

**Also does not**: build the glue data. `HasColimit (permDiagram C g)` remains open and
`AlbaneseUP.lean`'s six sorries are unchanged. Counting honestly, a glue-data assembly still
needs *four* things and this file supplies one of them:

1. ✓ a `G`-stable affine cover — below;
2. the `Aut`-valued `S_n`-action just described;
3. the identification of the `n`-fold coproduct of algebras with the `n`-fold tensor power,
   matching its permutation action to `PiTensorProduct.permAlgHom` — mathlib has only the
   *binary* case (`Algebra/Category/Ring/Constructions.lean`), and nothing in AJC builds the
   `n`-ary one. Without it the affine layer of `Albanese/SymPowInvariantsUnder.lean` and
   `SymPowColimit.symPowData_affineAlgebra` are about different objects;
4. the cocycle/overlap agreement of the chart quotients, plus `OrbitsInAffineOpen` **for the
   curve** — where quasi-projectivity would enter, and mathlib has no quasi-projectivity
   vocabulary at this pin.

Nothing consumes this file yet, and item 2 is why: it is not wired in, and it cannot be until
that action exists.

## References

Milne, *Abelian Varieties*, §III.3 Proposition 3.1, p. 94. EGA II 4.5.4 for the
orbit-in-affine hypothesis. The original proof is
`AlgebraicJacobian.GaloisDescent.SemilinearGalAction.exists_stable_affineOpen_of_orbitsInAffineOpen`
(`Picard/StableAffineCover.lean:193`), whose supporting lemmas
(`exists_basicOpen_le_of_finite`, `mem_finset_inf`, `preimage_finset_inf`,
`basicOpen_finset_prod`) are imported and reused unchanged.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicJacobian.GaloisDescent

namespace AlgebraicGeometry

namespace StableGroupAction

variable {G : Type u} [Group G] [Finite G] {X : Scheme.{u}} (act : G →* Aut X)

/-- **Orbit-in-affine hypothesis for a bare action** (EGA II 4.5.4): every orbit is contained
in an affine open. This hypothesis is *essential*, not a convenience — without it the
quotient need only be an algebraic space (Hironaka; see `Picard/FiniteGaloisQuotient.lean`'s
module docstring). It holds for quasi-projective `X`, but mathlib has no quasi-projectivity
at this pin, so for the curve it must be supplied by hand. -/
def OrbitsInAffineOpen : Prop :=
  ∀ x : X, ∃ U : X.affineOpens, ∀ g : G, (act g).hom.base x ∈ U.1

/-- A `G`-stable open of `X`. -/
def IsStableOpen (U : X.Opens) : Prop :=
  ∀ g : G, (act g).hom ⁻¹ᵁ U = U

omit [Finite G] in
/-- The identity acts as the identity. This and `act_mul_hom` are the *only* structural facts
the main theorem uses about the action — both are `map_one`/`map_mul` of the `MonoidHom`,
which is why no semilinearity is needed. -/
lemma act_one_hom : (act 1).hom = 𝟙 X := by rw [map_one]; rfl

omit [Finite G] in
/-- Multiplicativity, in the composition order `Aut` gives. -/
lemma act_mul_hom (g t : G) : (act (g * t)).hom = (act t).hom ≫ (act g).hom := by
  rw [map_mul]; rfl

/-- **The `G`-stable affine neighbourhood theorem, for a bare finite group action.**

Under the orbit-in-affine hypothesis, every point has a `G`-stable affine open neighbourhood.

The argument, in three moves: prime avoidance (`exists_basicOpen_le_of_finite`) puts the whole
orbit of `x` inside a basic open `D(s)` contained in `W = ⋂_g (act g)⁻¹U`; the **norm**
`N = ∏_g g(s)|_W` then satisfies `D(N) = ⋂_g (act g)⁻¹ D(s)`, which is `G`-stable by
reindexing the intersection; and `D(N) ⊆ D(s) ⊆ U` is affine as a basic open of an affine.
Stability is proved at the level of *opens*, which is what avoids transporting sections along
the action isomorphisms.

The norm is a product, so no `1/|G|` appears and the statement is characteristic-free.

**Provenance.** This is `Picard/StableAffineCover.lean:193` with its `SemilinearGalAction`
binder replaced by `G →* Aut X` and `[Fintype G]`; the proof term is otherwise unchanged, which
is the evidence that the semilinearity field was never load-bearing. See the module header. -/
theorem exists_stable_affineOpen_of_orbits (h : OrbitsInAffineOpen act) (x : X) :
    ∃ U : X.Opens, IsAffineOpen U ∧ x ∈ U ∧ IsStableOpen act U := by
  classical
  -- `[Finite G]` is the honest binder; the `Fintype` is an artefact of `Finset.univ`.
  letI : Fintype G := Fintype.ofFinite G
  obtain ⟨U, hxU⟩ := h x
  -- the whole orbit meets every translated chart: `g(t(x)) = (g*t)(x) ∈ U`.
  have horb : ∀ t g : G, (act g).hom.base ((act t).hom.base x) ∈ U.1 := by
    intro t g
    have hh : (act g).hom.base ((act t).hom.base x) = (act (g * t)).hom.base x := by
      rw [act_mul_hom act g t]; rfl
    rw [hh]; exact hxU (g * t)
  -- prime avoidance: `orbit ⊆ D(s) ⊆ W := ⋂_g (act g)⁻¹ U`.
  obtain ⟨s, hs_mem, hs_le⟩ := exists_basicOpen_le_of_finite U.2
    (fun g : G => (act g).hom.base x) hxU
    (V := Finset.univ.inf fun g : G => (act g).hom ⁻¹ᵁ U.1)
    (fun t => mem_finset_inf.mpr fun g _ => horb t g)
  have hWle : ∀ g : G,
      (Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) ≤ (act g).hom ⁻¹ᵁ U.1 :=
    fun g => Finset.inf_le (Finset.mem_univ g)
  -- the norm `N = ∏_g g(s)|_W` and its factors
  set t : G → Γ(X, Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) :=
    fun g => X.presheaf.map (homOfLE (hWle g)).op ((act g).hom.app U.1 s) with ht
  set N : Γ(X, Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) := ∏ g : G, t g with hN
  -- each factor cuts out the corresponding translate of `D(s)` inside `W`
  have hbo_t : ∀ g : G, X.basicOpen (t g) =
      (Finset.univ.inf fun d : G => (act d).hom ⁻¹ᵁ U.1) ⊓ (act g).hom ⁻¹ᵁ X.basicOpen s := by
    intro g
    rw [ht, Scheme.basicOpen_res, ← Scheme.preimage_basicOpen]
  -- the `g = 1` translate is `D(s)` itself
  have hP1 : (act (1 : G)).hom ⁻¹ᵁ X.basicOpen s = X.basicOpen s := by
    rw [act_one_hom act]; rfl
  -- `D(N) = ⋂_g (act g)⁻¹ D(s)`
  have hbo_N : X.basicOpen N = Finset.univ.inf fun g : G => (act g).hom ⁻¹ᵁ X.basicOpen s := by
    rw [hN, basicOpen_finset_prod ⟨1, Finset.mem_univ 1⟩,
      Finset.inf_congr rfl fun g _ => hbo_t g]
    refine le_antisymm
      (Finset.le_inf fun g _ => (Finset.inf_le (Finset.mem_univ g)).trans inf_le_right)
      (Finset.le_inf fun g _ => le_inf (le_trans ?_ hs_le)
        (Finset.inf_le (Finset.mem_univ g)))
    exact le_of_le_of_eq (Finset.inf_le (Finset.mem_univ 1)) hP1
  -- `D(N) ⊆ D(s)` (the `g = 1` factor)
  have hNs : X.basicOpen N ≤ X.basicOpen s := by
    rw [hbo_N]
    exact le_of_le_of_eq (Finset.inf_le (Finset.mem_univ 1)) hP1
  refine ⟨X.basicOpen N, ?_, ?_, ?_⟩
  · -- affineness: `D(N)` is a basic open of the affine `D(s)`
    have heq : X.basicOpen (X.presheaf.map (homOfLE hs_le).op N) = X.basicOpen N := by
      rw [Scheme.basicOpen_res]
      exact inf_eq_right.mpr hNs
    rw [← heq]
    exact (U.2.basicOpen s).basicOpen _
  · -- membership: prime avoidance put the whole orbit in `D(s)`
    rw [hbo_N, mem_finset_inf]
    intro g _
    change (act g).hom.base x ∈ X.basicOpen s
    exact hs_mem g
  · -- stability, at the level of opens: preimage functoriality plus reindexing
    intro tau
    rw [hbo_N, preimage_finset_inf]
    have hPt : ∀ g : G, (act tau).hom ⁻¹ᵁ ((act g).hom ⁻¹ᵁ X.basicOpen s)
        = (act (g * tau)).hom ⁻¹ᵁ X.basicOpen s := by
      intro g
      rw [act_mul_hom act]; rfl
    rw [Finset.inf_congr rfl fun g _ => hPt g]
    refine le_antisymm (Finset.le_inf fun d _ => ?_) (Finset.le_inf fun d _ => ?_)
    · have hh := Finset.inf_le (s := Finset.univ)
        (f := fun g : G => (act (g * tau)).hom ⁻¹ᵁ X.basicOpen s)
        (Finset.mem_univ (d * tau⁻¹))
      rwa [inv_mul_cancel_right] at hh
    · exact Finset.inf_le (Finset.mem_univ (d * tau))

end StableGroupAction

end AlgebraicGeometry
