/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.P1SectionsFinite
import AlgebraicJacobian.Picard.StructureSheafPushforward

/-!
# B3-H0, the last anchor: `Γ(ℙ¹_A, 𝒪) = A` reduced to a single statement over `k`

`Picard/P1SectionsFinite.lean` reduced the Serre-finiteness-grade hypothesis
`hH0` of the B3 ℙ¹ engine (finite generation of the Čech `H⁰ = Γ(ℙ¹_A, M)`
for a finitely presented `M`) to one `M`-independent *structure-sheaf* anchor:
bijectivity of the comparison map

`Γ(Spec A, 𝒪) ⟶ Γ(ℙ¹_A, 𝒪)`  (`p1Cech_h0_fg_of_bijective_appTop`, :1298)

— but left it quantified over every finitely generated `k`-algebra `A`.  This
file removes the `A` from the anchor.  What remains is the single, classical,
`A`-free statement

**`Γ(ℙ¹_k, 𝒪) = k`** (`Function.Bijective ((p1Over k).hom.appTop).hom`),

equivalently — via the unconditional field-of-constants machinery of
`Picard/SectionRingUniversal.lean` — the mathlib class
`GeometricallyIntegral (p1Over k).hom`.

## Why the `A` disappears

The `B1` brick `bijective_snd_appTop_baseChange`
(`Picard/StructureSheafPushforward.lean`:80) already does exactly this
reduction, but it is stated for a proper *geometrically integral* `C/k`, so it
cannot be applied to `ℙ¹` before geometric integrality of `ℙ¹` is available.
Reading its proof shows that geometric integrality is used **only** to obtain
`Γ(C, 𝒪) = k` (`bijective_hom_appTop`); every other ingredient — the qcqs `H⁰`
flat base change `globalSectionsBaseChangeAlgEquiv` — needs nothing beyond
`CompactSpace`/`QuasiSeparatedSpace` on the total space, because the base
`Spec k` is a field, hence every `Spec A ⟶ Spec k` is flat.  §1 therefore
restates the brick with the field-of-constants conclusion taken as a
*hypothesis*:

`bijective_snd_appTop_baseChange_of_bijective_appTop` — for **any** qcqs
`k`-scheme `X` with `Γ(X, 𝒪) = k`, the comparison `Γ(Spec A, 𝒪) → Γ(X_A, 𝒪)`
is bijective for **every** `k`-algebra `A`.

`ℙ¹_k` is proper (`ProjectiveSpace.isProper_over`), hence qcqs (§2), so §3
turns the single anchor into the engine's `hH0` at every `A`, and §4 records
the engine conclusion in that form.

## The remaining frontier of this file

`Γ(ℙ¹_k, 𝒪) = k` is *not* proved here.  It is the standard fact that the
projective line over a field has no nonconstant global regular functions; in
this tree the cheapest honest route to it is `GeometricallyIntegral` of the
structural morphism of relative projective space, which by
`MorphismProperty.pullback_fst` reduces to geometric integrality of the
integral model `Proj ℤ[X₀, X₁] ⟶ ⊤_Scheme`, i.e. to `IsIntegral (ℙ¹_K)` for
every field `K` — a genuinely missing mathlib result about `Proj`, not a gap
in the B3 argument.  It is recorded here as the honest leaf
(`GeometricallyIntegral (p1Over k).hom`), with the derivation
`p1_bijective_appTop_of_geometricallyIntegral` supplied so that landing it
discharges everything downstream by `exact`.

Sources: Mumford AV II §5; Stacks 01XZ/01YS; EGA III 3.2.1 (the classical
`H⁰`-finiteness this file replaces by an elementary anchor); Kleiman,
*The Picard scheme*, §5.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

variable {k : Type u} [Field k]

/-! ## §1. `H⁰` base change over a field base, with the field of constants as a hypothesis

The `B1` brick with `[GeometricallyIntegral]` traded for the only consequence
of it the proof uses. -/

open TensorProduct in
set_option backward.isDefEq.respectTransparency false in
/-- **`Γ(Spec A, 𝒪) ≅ Γ(X ×_k Spec A, 𝒪)` from `Γ(X, 𝒪) = k`.**  For a qcqs
`k`-scheme `X` (e.g. proper) whose structure map `k → Γ(X, 𝒪)` is *bijective*
— the field-of-constants conclusion, taken here as a hypothesis rather than
derived from geometric integrality — the comparison map
`Γ(Spec A, 𝒪) → Γ(X ×_k Spec A, 𝒪)` is bijective for **every** `k`-algebra
`A`.

This is `Picard/StructureSheafPushforward.lean`'s `bijective_snd_appTop_baseChange`
with its `[IsProper] [GeometricallyIntegral]` hypotheses weakened to exactly
what its proof consumes: the qcqs `H⁰` flat base change
`globalSectionsBaseChangeAlgEquiv` (unconditional over a field base, since
`Spec A ⟶ Spec k` is automatically flat) composed with `includeLeft`, which
is bijective precisely because the right tensor factor `Γ(X, 𝒪)` collapses to
`k`. -/
theorem bijective_snd_appTop_baseChange_of_bijective_appTop
    {X : Scheme.{u}} (iX : X ⟶ Spec (CommRingCat.of k))
    [CompactSpace X] [QuasiSeparatedSpace X]
    (hX : Function.Bijective (iX.appTop).hom)
    (A : Type u) [CommRing A] [Algebra k A] :
    Function.Bijective
      ((pullback.snd iX
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).appTop).hom := by
  set g : Spec (CommRingCat.of A) ⟶ Spec (CommRingCat.of k) :=
    Spec.map (CommRingCat.ofHom (algebraMap k A)) with hg
  letI instSA : Algebra ↥Γ(Spec (CommRingCat.of k), ⊤) ↥Γ(Spec (CommRingCat.of A), ⊤) :=
    ((Spec.map (CommRingCat.ofHom (algebraMap k A))).appLE ⊤ ⊤ le_top).hom.toAlgebra
  letI instMA : Algebra ↥Γ(Spec (CommRingCat.of k), ⊤) ↥Γ(X, ⊤) :=
    (iX.appTop).hom.toAlgebra
  letI instPull : Algebra ↥Γ(Spec (CommRingCat.of A), ⊤)
      ↥Γ(pullback iX g, ⊤) :=
    ((pullback.snd iX g).appTop).hom.toAlgebra
  have e := globalSectionsBaseChangeAlgEquiv iX A
  set R := ↥Γ(Spec (CommRingCat.of k), ⊤)
  set S := ↥Γ(Spec (CommRingCat.of A), ⊤)
  set M := ↥Γ(X, ⊤)
  have hRM : Function.Bijective (algebraMap R M) := hX
  let φ : M ≃ₐ[R] R := (AlgEquiv.ofBijective (Algebra.ofId R M) hRM).symm
  let ε : (S ⊗[R] M) ≃ₐ[S] S :=
    (Algebra.TensorProduct.congr AlgEquiv.refl φ).trans (Algebra.TensorProduct.rid R S S)
  have hb2 : ∀ s : S, algebraMap S (S ⊗[R] M) s = ε.symm s := by
    intro s
    have h := ε.commutes s
    simp only [Algebra.algebraMap_self, RingHom.id_apply] at h
    exact ε.eq_symm_apply.mpr h
  have hleft : Function.Bijective ⇑(algebraMap S (S ⊗[R] M)) := by
    have : ⇑(algebraMap S (S ⊗[R] M)) = ⇑ε.symm := funext hb2
    rw [this]; exact ε.symm.bijective
  change Function.Bijective ⇑(algebraMap S ↥Γ(pullback iX g, ⊤))
  have hcomp : ⇑(algebraMap S ↥Γ(pullback iX g, ⊤))
      = ⇑e ∘ ⇑(algebraMap S (S ⊗[R] M)) := by
    funext s; exact (e.commutes s).symm
  rw [hcomp]
  exact e.bijective.comp hleft

end Scheme

namespace Adelic

open Scheme

variable {k : Type u} [Field k]

/-! ## §2. `ℙ¹_k` is proper, hence qcqs

`Adelic.p1Over k` is `Over.mk` of the structural morphism of relative
projective space, so the `ProjectiveSpace` instances have to be transported
through `Over.mk` by hand (typeclass search does not unfold `Over.mk`). -/

/-- `ℙ¹_k ⟶ Spec k` is proper (`ProjectiveSpace.isProper_over`, transported
through `Over.mk`). -/
instance isProper_p1Over_hom : IsProper ((p1Over k).hom) :=
  inferInstanceAs (IsProper (ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)) ↘
    Spec (CommRingCat.of k)))

/-- `ℙ¹_k` is quasi-compact (proper ⟹ quasi-compact over the quasi-compact
`Spec k`). -/
instance compactSpace_p1Over_left : CompactSpace ((p1Over k).left) :=
  QuasiCompact.compactSpace_of_compactSpace ((p1Over k).hom)

/-- `ℙ¹_k` is quasi-separated (proper ⟹ separated). -/
instance quasiSeparatedSpace_p1Over_left : QuasiSeparatedSpace ((p1Over k).left) :=
  quasiSeparatedSpace_of_quasiSeparated ((p1Over k).hom)

/-! ## §3. The single `k`-only anchor and the `hH0` it produces at every base -/

/-- **The remaining B3-H0 leaf, stated once and for all over `k`**: the
projective line over a field has only constant global regular functions,
`Γ(ℙ¹_k, 𝒪) = k`.

It is derived below from `GeometricallyIntegral (p1Over k).hom`
(`p1_bijective_appTop_of_geometricallyIntegral`); no other hypothesis of the
B3 ℙ¹ engine remains `A`-dependent. -/
def P1HasTrivialConstants (k : Type u) [Field k] : Prop :=
  Function.Bijective (((p1Over k).hom.appTop)).hom

/-- **The leaf from geometric integrality of `ℙ¹`.**  `Γ(C, 𝒪) = k` for a
proper geometrically integral `C/k` is unconditional in this tree
(`Scheme.bijective_hom_appTop`, using the unconditional field-of-constants
instance `instHasTrivialConstants`), and `ℙ¹_k` is proper; so the anchor
follows from the single mathlib class `GeometricallyIntegral (p1Over k).hom`.

That class is the honest remaining frontier: by
`MorphismProperty.pullback_fst` it reduces to geometric integrality of the
integral model `Proj ℤ[X₀, X₁] ⟶ ⊤_Scheme`, i.e. to `IsIntegral (ℙ¹_K)` for
every field `K` — a missing mathlib fact about `Proj`, not a gap in the
Mumford argument. -/
theorem p1_bijective_appTop_of_geometricallyIntegral
    [GeometricallyIntegral ((p1Over k).hom)] :
    P1HasTrivialConstants k :=
  Scheme.bijective_hom_appTop (p1Over k)

variable (A : Type u) [CommRing A] [Algebra k A]

/-- **The `A`-level anchor from the `k`-level one**: `Γ(Spec A, 𝒪) → Γ(ℙ¹_A, 𝒪)`
is bijective for every `k`-algebra `A`, given only `Γ(ℙ¹_k, 𝒪) = k`.  This is
§1 applied to the qcqs `k`-scheme `ℙ¹_k`. -/
theorem bijective_p1BaseChange_appTop (hk : P1HasTrivialConstants k) :
    Function.Bijective
      ((pullback.snd (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).appTop).hom :=
  Scheme.bijective_snd_appTop_baseChange_of_bijective_appTop ((p1Over k).hom) hk A

set_option maxHeartbeats 800000 in
-- Heartbeat headroom for the instance-heavy `letI` environment (fleet recipe,
-- as in `p1Cech_h0_fg_of_bijective_appTop`).
/-- **THE B3-H0 LEAF, `A`-free**: the engine's named hypothesis `hH0`
(`p1Cech_h0_baseChange_of_fibrewise_h1_vanishing`, verbatim shape) at **every**
finitely generated `k`-algebra `A`, from the single `k`-only anchor
`Γ(ℙ¹_k, 𝒪) = k`.

Chain: `Γ(ℙ¹_k, 𝒪) = k` ⟹ (qcqs `H⁰` flat base change over a field, §1)
`Γ(Spec A, 𝒪) ≅ Γ(ℙ¹_A, 𝒪)` ⟹ (`module_finite_top_of_bijective_appTop`)
`Γ(ℙ¹_A, 𝒪)` base-finite ⟹ (sheaf gluing,
`fg_ker_ringSectionDiffBase_of_module_finite_top`) the structure-sheaf anchor
`hS0` ⟹ (Serre dévissage, `p1Cech_h0_fg_of_structure_h0_fg`) `hH0`. -/
theorem p1Cech_h0_fg_of_p1TrivialConstants [Algebra.FiniteType k A]
    (hk : P1HasTrivialConstants k)
    (M : (Limits.pullback (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules)
    [M.IsFinitePresentation] :
    letI := (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
        (p1BaseChangeCoverSquare A).U₁
    letI := (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
        (p1BaseChangeCoverSquare A).U₂
    letI := (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
        ((p1BaseChangeCoverSquare A).U₁ ⊓ (p1BaseChangeCoverSquare A).U₂)
    (LinearMap.ker ((p1BaseChangeCoverSquare A).moduleSectionDiffBase
      (pullback.snd (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))) M)).FG :=
  p1Cech_h0_fg_of_bijective_appTop A M (bijective_p1BaseChange_appTop A hk)

/-! ## §4. The B3 ℙ¹ endgame with the `hH0` leaf discharged from the `k`-anchor -/

set_option maxHeartbeats 800000 in
-- Heartbeat headroom for the instance-heavy `letI` environment (fleet recipe).
/-- **The full wave-4 ℙ¹ endgame conclusion from the `k`-only anchor.**  Same
statement as `p1Cech_h0_baseChange_of_fibrewise_h1_vanishing`
(`d` surjective, `H⁰ = ker d` finite projective, and the formation of `H⁰`
commuting with arbitrary base change), with the Serre-finiteness-grade
hypothesis `hH0` replaced by `Γ(ℙ¹_k, 𝒪) = k`.

The only hypothesis still local to the statement is the geometric one,
`hfib`: vanishing of the Čech `H¹` of `M` on every closed fibre. -/
theorem p1Cech_h0_baseChange_of_fibrewise_h1_vanishing_of_p1TrivialConstants
    [Algebra.FiniteType k A]
    (hk : P1HasTrivialConstants k)
    (M : (Limits.pullback (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules)
    [M.IsFinitePresentation]
    (hflat : Scheme.CoherentSheafFlat
      (pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))) M) :
    letI := (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
        (p1BaseChangeCoverSquare A).U₁
    letI := (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
        (p1BaseChangeCoverSquare A).U₂
    letI := (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
        ((p1BaseChangeCoverSquare A).U₁ ⊓ (p1BaseChangeCoverSquare A).U₂)
    ∀ _hfib : (∀ (m : Ideal Γ(Spec (CommRingCat.of A), ⊤)), m.IsMaximal →
      Function.Surjective
        (((p1BaseChangeCoverSquare A).moduleSectionDiffBase
          (pullback.snd (p1Over k).hom
            (Spec.map (CommRingCat.ofHom (algebraMap k A)))) M).baseChange
          (Γ(Spec (CommRingCat.of A), ⊤) ⧸ m))),
    Function.Surjective ⇑((p1BaseChangeCoverSquare A).moduleSectionDiffBase
        (pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))) M) ∧
      Module.Finite Γ(Spec (CommRingCat.of A), ⊤)
        (LinearMap.ker ((p1BaseChangeCoverSquare A).moduleSectionDiffBase
          (pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))) M)) ∧
      Module.Projective Γ(Spec (CommRingCat.of A), ⊤)
        (LinearMap.ker ((p1BaseChangeCoverSquare A).moduleSectionDiffBase
          (pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))) M)) ∧
      ∀ (B : Type u) [CommRing B] [Algebra Γ(Spec (CommRingCat.of A), ⊤) B],
        Function.Bijective (AlgebraicJacobian.TwoTerm.kerBaseChange
          ((p1BaseChangeCoverSquare A).moduleSectionDiffBase
            (pullback.snd (p1Over k).hom
              (Spec.map (CommRingCat.ofHom (algebraMap k A)))) M) B) := by
  letI := (pullback.snd (p1Over k).hom
    (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
      (p1BaseChangeCoverSquare A).U₁
  letI := (pullback.snd (p1Over k).hom
    (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
      (p1BaseChangeCoverSquare A).U₂
  letI := (pullback.snd (p1Over k).hom
    (Spec.map (CommRingCat.ofHom (algebraMap k A)))).baseSectionsModule M
      ((p1BaseChangeCoverSquare A).U₁ ⊓ (p1BaseChangeCoverSquare A).U₂)
  intro hfib
  exact p1Cech_h0_baseChange_of_fibrewise_h1_vanishing A M hflat
    (p1Cech_h0_fg_of_p1TrivialConstants A hk M) hfib

end Adelic

end AlgebraicGeometry
