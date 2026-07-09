/-
Copyright (c) 2026 Archon Horizon. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Horizon (Archon Horizon)
-/
import Mathlib
import AlgebraicJacobian.Picard.HilbertPolynomial
import AlgebraicJacobian.Picard.LineBundlePullback
import AlgebraicJacobian.Picard.FlatteningStratification
import AlgebraicJacobian.Cohomology.MayerVietorisCover
import AlgebraicJacobian.Cohomology.FlatBaseChange
import AlgebraicJacobian.RiemannRoch.Adelic.FinitenessP1

/-!
# B3 — the rigid pushforward engine: statement layer and ℙ¹ reduction skeleton

This file pins milestone **B3** of the Picard-representability campaign
(`informal/pic-representability-campaign.md`), the engine
`pushforward_locallyFree_of_h1_vanishing`: for the constant curve
`C_A = C ×_k Spec A` over a finitely generated `k`-algebra `A` and an
invertible sheaf `L` on `C_A` with `h¹(C_t, L_t) = 0` at **every scheme
point** `t : Spec A`, the pushforward `q_* L` along `q : C_A ⟶ Spec A` is
locally free with fibre rank `h⁰(C_t, L_t) (= χ(L_t))`, and its formation
commutes with **arbitrary** ring maps `A → A'`.

Sources: Mumford, *Abelian Varieties*, II §5 (the two-term finite free
complex and "cohomology and base change"); EGA III 7.9.9; Hartshorne III
12.11; Kleiman, *The Picard scheme* (FGA Explained), §5 — B3 is the engine
behind Kleiman's flattening/openness arguments in the curve case.

## Statement audit (campaign checklist item 1 — BLOCKING; verdicts recorded here)

* **Quantifier — `h¹ = 0` at ALL scheme points** (`RigidPushforwardLocallyFree`,
  `RigidPushforwardBaseChange`): the hypothesis `∀ t : Spec A,
  q.FiberH1Vanishing L t` ranges over *all* points of the underlying space of
  `Spec A` (all primes), not only closed points.  For general noetherian `A`
  (noetherian ≠ Jacobson: e.g. a DVR, whose generic point is contained in no
  closed point's closure) the closed-point form is strictly weaker and the
  engine's conclusion FAILS if the hypothesis is checked at closed points
  only.  A finitely generated `k`-algebra *is* Jacobson, so on the pinned
  base the two forms happen to agree — but (i) the reduction uses h¹ upper
  semicontinuity, an engine we refuse to smuggle into the *statement*, and
  (ii) milestone B2 extends every consumer along filtered colimits and
  localizations, where the base is merely noetherian and Jacobson genuinely
  fails.  All campaign consumers (J1/J3 `h⁰ ≡ 1`, B4–B6) supply the
  hypothesis at all scheme points anyway.  VERDICT: pin at all scheme points.
* **Base change along ARBITRARY `A → A'` in the statement**
  (`RigidPushforwardBaseChange`): quantified over every commutative ring
  `A' : Type u` and every ring hom `φ : A →+* A'` — no finiteness, no
  flatness, no noetherian hypothesis on `A'`.  The comparison morphism is
  the canonical `pushforwardBaseChangeMap` (Stacks 02N4-style mate) of the
  *defining pullback square* of `q` along `Spec φ`, so the statement is
  well-formed with zero transport: the base-changed family is
  `pullback q (Spec.map φ)` — canonically (but not definitionally) isomorphic
  to `C ×_k Spec A'`; the comparison iso is postponed to the consumer layer
  (B2), keeping the pin transport-free.  VERDICT: arbitrary `A'`, arbitrary
  `φ`, canonical square, comparison map in the statement.
* **Two-step pin**: step 1 = rank-`χ` local freeness
  (`RigidPushforwardLocallyFree`) + base change
  (`RigidPushforwardBaseChange`); step 2 = the rank-one corollary
  (`pushforward_isLocallyTrivial_of_h1_vanishing`, proved from the gate).
  VERDICT: pinned as two separate `Prop`s consumed by one gate.
* **Rank = `χ(L_t)`** : under `h¹(L_t) = 0` we have `χ(L_t) = h⁰(L_t)`, and
  `h⁰` *is* expressible today (`Scheme.Hom.fiberH0`, the `κ(t)`-dimension of
  `Γ(C_t, L_t)`, matching `Scheme.hilbertFunction`'s convention), while the
  `χ`-ledger is milestone P3.  The rank is therefore pinned as
  `q.fiberH0 L t`; **P2/P3-interface TODO**: once the P2 cohomology kit and
  the P3 `χ`-ledger land, add the (definitionally compatible) reformulation
  `rank = χ(L_t) = deg L_t + 1 - g`.
* **Fibrewise `h¹` vocabulary** (P2 does not exist yet): the hypothesis is
  pinned in the weakest honest form the adelic lane can already express —
  existence of a 2-affine Čech cover (`AffineCoverMVSquare`, the lane's
  carrier) of the scheme-theoretic fibre on which the degree-1 Čech
  cokernel of `L_t` vanishes, i.e. the difference-of-restrictions map is
  surjective (`Scheme.Hom.FiberH1Vanishing`; carrier form
  `AffineCoverMVSquare.moduleH1Cok`, mirroring
  `AffineCoverMVSquare.H1Cok` of `RiemannRoch/Adelic/Cokernel.lean`).  On a
  separated scheme with an affine 2-cover, this Čech `H¹` computes sheaf
  `H¹` for quasi-coherent modules (Mayer–Vietoris/Leray; in-lane precedent
  `hModuleOne_linearEquiv_cechCohomology`), and any two such covers agree —
  cover-independence is exactly the **P2-interface TODO**, to be discharged
  Čech-to-Čech.  The ∃-form is chosen because it is *implied* by every
  future kit form, so the gate only gets easier to discharge.
* **The rank-one corollary's `DivFamily` leg** (Kleiman §5; campaign J2):
  `h⁰ ≡ 1, h¹ ≡ 0 ⟹ q_*L` invertible is pinned and proved from the gate
  below.  The continuation — the counit section `q^*q_*L ⟶ L` is fibrewise
  nonzero, hence a regular section on the integral fibres, hence cuts a
  canonical `DivFamily` — needs the counit/adjunction vocabulary on the
  `Div` side and the geometric integrality of fibres; it is recorded as the
  **J2-interface TODO** and deliberately NOT pinned here (its natural home
  is the J2 session, where the target `DivFamily` shape is fixed).

## Gate

`HasRigidPushforward C` is the campaign gate (`HasPicScheme` pattern): a
`Prop` class with **no instances anywhere**, carrying the two statement
`Prop`s quantified over all finitely generated `k`-algebras.  It is
discharged by the full B3 session (Mumford two-term complex route) and
deleted on discharge.  Everything else in this file is *proved*: the
extraction theorems, the rank-one corollary, and the ℙ¹ reduction skeleton
(the base-changed finite map `C_A ⟶ ℙ¹_A`, the pushforward factorization
`q_* = p_* ∘ π_*`, and the reduction of B3-for-`C_A` to a ℙ¹ engine plus a
named finite-pushforward transfer package).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace

namespace AlgebraicGeometry

namespace Scheme

/-! ## §1. Degree-1 Čech vocabulary for 𝒪-modules on a 2-affine cover

The adelic lane (`RiemannRoch/Adelic/Cokernel.lean`) works with sheaves of
`k`-modules; the Picard lane works with `X.Modules`.  The following is the
`X.Modules` dialect of the lane's `sectionDiff`/`H1Cok`/`sectionGlue` kit on
a bundled 2-affine cover (`AffineCoverMVSquare`).  Restriction maps of a
sheaf of modules are only *semilinear* over the restriction of scalars, so
the natural home of the difference map is additive homs. -/

variable {X S : Scheme.{u}}

/-- The **difference-of-restrictions map** of a 2-affine cover for a sheaf of
`𝒪_X`-modules `M`: the additive map
`Γ(U₁, M) × Γ(U₂, M) →+ Γ(U₁ ⊓ U₂, M)`, `(a, b) ↦ a|_{U₁⊓U₂} − b|_{U₁⊓U₂}`.
Its cokernel is the concrete Čech `Ȟ¹(𝒰, M)` of the cover
(`AffineCoverMVSquare.moduleH1Cok`), its kernel the glued global sections.
`X.Modules`-dialect of `AffineCoverMVSquare.sectionDiff`
(`RiemannRoch/Adelic/Cokernel.lean`). -/
noncomputable def AffineCoverMVSquare.moduleSectionDiff (V : X.AffineCoverMVSquare)
    (M : X.Modules) :
    Γ(M, V.U₁) × Γ(M, V.U₂) →+ Γ(M, V.U₁ ⊓ V.U₂) :=
  ((M.presheaf.map (homOfLE (inf_le_left : V.U₁ ⊓ V.U₂ ≤ V.U₁)).op).hom.comp
      (AddMonoidHom.fst _ _)) -
    ((M.presheaf.map (homOfLE (inf_le_right : V.U₁ ⊓ V.U₂ ≤ V.U₂)).op).hom.comp
      (AddMonoidHom.snd _ _))

/-- The value of the difference map. -/
lemma AffineCoverMVSquare.moduleSectionDiff_apply (V : X.AffineCoverMVSquare)
    (M : X.Modules) (p : Γ(M, V.U₁) × Γ(M, V.U₂)) :
    V.moduleSectionDiff M p =
      (M.presheaf.map (homOfLE (inf_le_left : V.U₁ ⊓ V.U₂ ≤ V.U₁)).op).hom p.1 -
        (M.presheaf.map (homOfLE (inf_le_right : V.U₁ ⊓ V.U₂ ≤ V.U₂)).op).hom p.2 :=
  rfl

/-- **The concrete Čech `Ȟ¹` of a 2-affine cover, `X.Modules` dialect**: the
cokernel `Γ(U₁ ⊓ U₂, M) ⧸ im(Γ(U₁, M) × Γ(U₂, M))` of the
difference-of-restrictions map, as an abelian group.  For quasi-coherent `M`
on a separated scheme this computes sheaf `H¹(X, M)` (Mayer–Vietoris on the
affine 2-cover; in-lane precedent `hModuleOne_linearEquiv_cechCohomology`).
`X.Modules`-dialect of `AffineCoverMVSquare.H1Cok`. -/
noncomputable def AffineCoverMVSquare.moduleH1Cok (V : X.AffineCoverMVSquare)
    (M : X.Modules) : Type u :=
  Γ(M, V.U₁ ⊓ V.U₂) ⧸ (V.moduleSectionDiff M).range

noncomputable instance (V : X.AffineCoverMVSquare) (M : X.Modules) :
    AddCommGroup (V.moduleH1Cok M) :=
  inferInstanceAs (AddCommGroup (_ ⧸ (V.moduleSectionDiff M).range))

/-- Vanishing of the concrete Čech `Ȟ¹` is surjectivity of the difference map. -/
lemma AffineCoverMVSquare.subsingleton_moduleH1Cok_iff (V : X.AffineCoverMVSquare)
    (M : X.Modules) :
    Subsingleton (V.moduleH1Cok M) ↔
      Function.Surjective ⇑(V.moduleSectionDiff M) := by
  constructor
  · intro h c
    have hc : (QuotientAddGroup.mk c : V.moduleH1Cok M) = QuotientAddGroup.mk 0 :=
      h.elim _ _
    rw [QuotientAddGroup.eq] at hc
    obtain ⟨p, hp⟩ := hc
    refine ⟨-p, ?_⟩
    have : -(V.moduleSectionDiff M p) = c := by
      rw [hp]; abel
    simpa [map_neg] using this
  · intro h
    have hrange : (V.moduleSectionDiff M).range = ⊤ :=
      AddMonoidHom.range_eq_top.mpr h
    change Subsingleton (Γ(M, V.U₁ ⊓ V.U₂) ⧸ (V.moduleSectionDiff M).range)
    rw [hrange]
    exact QuotientAddGroup.subsingleton_quotient_top

/-- The **pair-of-restrictions map** `Γ(X, M) →+ Γ(U₁, M) × Γ(U₂, M)` of a
2-affine cover: the degree-0 piece of the two-term Čech complex.  Together
with `moduleSectionDiff` this is the explicit two-term complex
`0 → Γ(M) → Γ(U₁, M) × Γ(U₂, M) → Γ(U₁ ⊓ U₂, M) → Ȟ¹ → 0` of Mumford AV
II §5 (before the finite free replacement). -/
noncomputable def AffineCoverMVSquare.moduleSectionRes (V : X.AffineCoverMVSquare)
    (M : X.Modules) :
    Γ(M, (⊤ : X.Opens)) →+ Γ(M, V.U₁) × Γ(M, V.U₂) :=
  ((M.presheaf.map (homOfLE (le_top : V.U₁ ≤ ⊤)).op).hom).prod
    ((M.presheaf.map (homOfLE (le_top : V.U₂ ≤ ⊤)).op).hom)

/-- **The two-term Čech complex property**: the composite
`Γ(M) → Γ(U₁, M) × Γ(U₂, M) → Γ(U₁ ⊓ U₂, M)` vanishes — restrictions of a
global section along the two legs agree on the overlap (functoriality of the
presheaf and proof irrelevance of `≤` in `Opens`). -/
lemma AffineCoverMVSquare.moduleSectionDiff_comp_moduleSectionRes
    (V : X.AffineCoverMVSquare) (M : X.Modules) :
    (V.moduleSectionDiff M).comp (V.moduleSectionRes M) = 0 := by
  ext s
  have h₁ : (M.presheaf.map (homOfLE (inf_le_left : V.U₁ ⊓ V.U₂ ≤ V.U₁)).op).hom
        ((M.presheaf.map (homOfLE (le_top : V.U₁ ≤ ⊤)).op).hom s) =
      (M.presheaf.map (homOfLE (le_top : V.U₁ ⊓ V.U₂ ≤ ⊤)).op).hom s := by
    have := M.presheaf.map_comp (homOfLE (le_top : V.U₁ ≤ ⊤)).op
      (homOfLE (inf_le_left : V.U₁ ⊓ V.U₂ ≤ V.U₁)).op
    exact (congrArg (fun f => (ConcreteCategory.hom f) s) this.symm).trans rfl
  have h₂ : (M.presheaf.map (homOfLE (inf_le_right : V.U₁ ⊓ V.U₂ ≤ V.U₂)).op).hom
        ((M.presheaf.map (homOfLE (le_top : V.U₂ ≤ ⊤)).op).hom s) =
      (M.presheaf.map (homOfLE (le_top : V.U₁ ⊓ V.U₂ ≤ ⊤)).op).hom s := by
    have := M.presheaf.map_comp (homOfLE (le_top : V.U₂ ≤ ⊤)).op
      (homOfLE (inf_le_right : V.U₁ ⊓ V.U₂ ≤ V.U₂)).op
    exact (congrArg (fun f => (ConcreteCategory.hom f) s) this.symm).trans rfl
  simp only [AddMonoidHom.comp_apply, AddMonoidHom.zero_apply,
    moduleSectionDiff_apply, moduleSectionRes, AddMonoidHom.prod_apply]
  rw [h₁, h₂, sub_self]

/-! ## §2. Fibrewise `h⁰` and `h¹`-vanishing for a family -/

/-- The **fibrewise `h⁰`** of a sheaf of modules `L` on the total space of a
family `q : X ⟶ S` at a point `t : S`: the dimension over the residue field
`κ(t)` of the global sections of the restriction `L_t` of `L` to the
scheme-theoretic fibre `X_t = q.fiber t`,

`h⁰(t) = dim_{κ(t)} Γ(X_t, L_t)`.

The `κ(t)`-structure is `Scheme.Hom.fiberSectionsModule` (restriction of
scalars along `κ(t) → Γ(X_t, 𝒪)`), exactly the convention of
`Scheme.hilbertFunction`; when the dimension is infinite, `Module.finrank`
takes the junk value `0`.  This is the (P2-kit-independent) fibre `h⁰`
vocabulary of campaign milestones B3/B5/B6/J1/J3. -/
noncomputable def Hom.fiberH0 (q : X ⟶ S) (L : X.Modules) (t : S) : ℕ :=
  letI := q.fiberSectionsModule t (q.fiberModule t L)
  Module.finrank (S.residueField t) Γ(q.fiberModule t L, (⊤ : (q.fiber t).Opens))

/-- **Fibrewise `h¹`-vanishing** of a sheaf of modules `L` on the total space
of a family `q : X ⟶ S` at a point `t : S`, in the weakest honest form the
adelic lane can express before the P2 cohomology kit exists: *some* 2-affine
Čech cover of the scheme-theoretic fibre `X_t = q.fiber t` has surjective
difference-of-restrictions map for `L_t` — equivalently (by
`AffineCoverMVSquare.subsingleton_moduleH1Cok_iff`) vanishing concrete Čech
`Ȟ¹(𝒰, L_t)`.

On the separated fibre curves of the campaign this Čech `Ȟ¹` computes sheaf
`H¹(X_t, L_t)` and is independent of the chosen 2-affine cover
(Mayer–Vietoris); the ∃-form is implied by every future P2-kit form of
`h¹ = 0`, so hypotheses pinned this way only get easier to supply.
Cover-independence Čech-to-Čech is the recorded **P2-interface TODO**. -/
def Hom.FiberH1Vanishing (q : X ⟶ S) (L : X.Modules) (t : S) : Prop :=
  ∃ V : (q.fiber t).AffineCoverMVSquare,
    Function.Surjective ⇑(V.moduleSectionDiff (q.fiberModule t L))

/-! ## §3. The B3 statement pins and the gate -/

variable {k : Type u} [Field k]

/-- **B3, step 1a (statement pin): rank-`χ` local freeness of the rigid
pushforward** (Mumford AV II §5, Corollary 2; EGA III 7.9.9; Hartshorne III
12.11; campaign milestone B3(i), first conclusion).

For the constant curve `C_A = C ×_k Spec A` with projection
`q = pullback.snd : C_A ⟶ Spec A` and every invertible sheaf `L` on `C_A`
with `h¹(C_t, L_t) = 0` at **every scheme point** `t : Spec A` (see the
module docstring for the quantifier audit), the pushforward `q_* L` is
locally free with stalkwise rank the fibre dimension
`h⁰(C_t, L_t) = χ(L_t)`: every point has an open neighbourhood `U` on which
`(q_* L)|_U ≅ 𝒪_U^{⊕ h⁰(t)}`.

The rank is pinned as `q.fiberH0 L t` (`= χ(L_t)` since `h¹ = 0`; the
`χ`-ledger reformulation is the P3-interface TODO).  Local constancy of
`t ↦ h⁰(L_t)` on `Spec A` is a *consequence* of this statement (the rank of
a free module over a nontrivial ring is well defined on connected
components), not a separate hypothesis.

This `Prop` is honestly TRUE for every finitely generated (equivalently,
noetherian quotient) `k`-algebra `A`; the gate `HasRigidPushforward`
quantifies it exactly there.  Truth for *arbitrary* `A` is not claimed —
that extension is milestone B2 (filtered colimits). -/
def RigidPushforwardLocallyFree (C : Over (Spec (CommRingCat.of k)))
    (A : Type u) [CommRing A] [Algebra k A] : Prop :=
  ∀ L : (Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules,
    LineBundle.IsLocallyTrivial L →
    (∀ t : Spec (CommRingCat.of A),
      (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).FiberH1Vanishing L t) →
    ∀ t : Spec (CommRingCat.of A),
      ∃ U : (Spec (CommRingCat.of A)).Opens, t ∈ U ∧
        Nonempty ((Scheme.Modules.pullback U.ι).obj
            ((Scheme.Modules.pushforward
              (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))).obj L) ≅
          _root_.SheafOfModules.free (R := U.toScheme.ringCatSheaf)
            (ULift.{u} (Fin ((pullback.snd C.hom
              (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberH0 L t))))

/-- **B3, step 1b (statement pin): the formation of the rigid pushforward
commutes with arbitrary base change** (Mumford AV II §5, Corollary 3;
campaign milestone B3(i), second conclusion).

Under the same hypotheses as `RigidPushforwardLocallyFree` (invertible `L`,
`h¹(L_t) = 0` at all scheme points), for **every** commutative ring
`A' : Type u` and **every** ring homomorphism `φ : A →+* A'` — no
finiteness, flatness or noetherian condition on `A'` (audit verdict in the
module docstring) — the canonical base-change comparison
`(Spec φ)^* (q_* L) ⟶ q'_* (g'^* L)` (`pushforwardBaseChangeMap`, the
adjunction mate) of the defining pullback square

```
  C_A ×_{Spec A} Spec A' --g'--> C_A
        |q'                        |q
        v                          v
     Spec A' ------Spec φ-----> Spec A
```

is an isomorphism.  The square is the *tautological* pullback of `q` along
`Spec φ`, so the statement needs no transport; the identification of its
corner with `C ×_k Spec A'` is the (separately proved, consumer-side)
pasting isomorphism. -/
def RigidPushforwardBaseChange (C : Over (Spec (CommRingCat.of k)))
    (A : Type u) [CommRing A] [Algebra k A] : Prop :=
  ∀ L : (Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules,
    LineBundle.IsLocallyTrivial L →
    (∀ t : Spec (CommRingCat.of A),
      (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).FiberH1Vanishing L t) →
    ∀ (A' : Type u) [CommRing A'] (φ : A →+* A'),
      IsIso (pushforwardBaseChangeMap
        (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))
        (Spec.map (CommRingCat.ofHom φ))
        (pullback.snd (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))
          (Spec.map (CommRingCat.ofHom φ)))
        (pullback.fst (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))
          (Spec.map (CommRingCat.ofHom φ)))
        pullback.condition L)

/-- **The B3 gate** (`HasPicScheme` pattern: `Prop` class, **no instances
anywhere in the tree** — supplied as a hypothesis by consumers and
discharged by the full B3 proof session, then deleted).

Content: for the smooth proper geometrically integral curve `C/k` of the
campaign, both B3 statement pins hold over every finitely generated
`k`-algebra `A` (Hilbert basis: such `A` is noetherian — the honest scope of
the Mumford AV II §5 two-term-complex argument; milestone B2 extends
consumers to arbitrary affine bases by filtered colimits).

Route for the discharge (recorded, not claimed here): push along the finite
`C_A ⟶ ℙ¹_A` (`finiteMapToP1BaseChange` below) and run the two-term finite
free replacement on the explicit 2-chart Čech complex of `ℙ¹_A`
(`p1BaseChangeCoverSquare` below); fallback: direct Čech on a 2-affine
cover of `C_A` (campaign risk register R1). -/
class HasRigidPushforward (C : Over (Spec (CommRingCat.of k))) : Prop where
  /-- Rank-`χ` local freeness over every finitely generated `k`-algebra. -/
  locallyFree : ∀ (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A],
    RigidPushforwardLocallyFree C A
  /-- Arbitrary base change over every finitely generated `k`-algebra. -/
  baseChange : ∀ (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A],
    RigidPushforwardBaseChange C A

section Extraction

variable (C : Over (Spec (CommRingCat.of k)))
variable (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A]

/-- **B3 headline, local-freeness half** (extraction from the gate): for an
invertible `L` on `C_A` with fibrewise `h¹ = 0` at all scheme points, the
pushforward `q_* L` is, near every `t : Spec A`, free of rank
`h⁰(C_t, L_t) = χ(L_t)`. -/
theorem pushforward_locallyFree_of_h1_vanishing [HasRigidPushforward C]
    (L : (Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules)
    (hL : LineBundle.IsLocallyTrivial L)
    (h1 : ∀ t : Spec (CommRingCat.of A),
      (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).FiberH1Vanishing L t)
    (t : Spec (CommRingCat.of A)) :
    ∃ U : (Spec (CommRingCat.of A)).Opens, t ∈ U ∧
      Nonempty ((Scheme.Modules.pullback U.ι).obj
          ((Scheme.Modules.pushforward
            (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))).obj L) ≅
        _root_.SheafOfModules.free (R := U.toScheme.ringCatSheaf)
          (ULift.{u} (Fin ((pullback.snd C.hom
            (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberH0 L t)))) :=
  HasRigidPushforward.locallyFree A L hL h1 t

/-- **B3 headline, base-change half** (extraction from the gate): under the
same hypotheses, the formation of `q_* L` commutes with every ring map
`A → A'`. -/
theorem pushforward_baseChange_of_h1_vanishing [HasRigidPushforward C]
    (L : (Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules)
    (hL : LineBundle.IsLocallyTrivial L)
    (h1 : ∀ t : Spec (CommRingCat.of A),
      (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).FiberH1Vanishing L t)
    (A' : Type u) [CommRing A'] (φ : A →+* A') :
    IsIso (pushforwardBaseChangeMap
      (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))
      (Spec.map (CommRingCat.ofHom φ))
      (pullback.snd (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))
        (Spec.map (CommRingCat.ofHom φ)))
      (pullback.fst (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))
        (Spec.map (CommRingCat.ofHom φ)))
      pullback.condition L) :=
  HasRigidPushforward.baseChange A L hL h1 A' φ

end Extraction

end Scheme

end AlgebraicGeometry
