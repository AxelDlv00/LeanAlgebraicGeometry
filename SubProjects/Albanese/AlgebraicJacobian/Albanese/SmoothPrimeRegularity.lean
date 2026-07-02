/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Albanese.StandardSmoothDimension

/-!
# Regularity of standard-smooth algebras at all primes (Stacks 00TT, Serre-free route)

This file closes the residual "non-closed point" gap of the smooth ⟹ regular
pipeline of `Albanese/CodimOneExtension.lean` (Stacks tag `00TT`) **without**
Stacks `00OF` (localisations of regular local rings are regular, via Serre's
homological characterisation — absent from Mathlib at v4.31). Instead of
localising a closed-point regularity witness, we prove regularity at an
arbitrary prime `q` of a standard-smooth algebra `S` over a *perfect* field
`k` directly, via the conormal sequence and a transcendence-degree/height
inequality:

* `Polynomial.step_height_trdeg_of_isPrime` (**step lemma**): for a prime
  `P ⊆ R[X]` over `p = P ∩ R` (`R` Noetherian), either `ht p + 1 ≤ ht P` and
  `trdeg k (R⧸p) ≤ trdeg k (R[X]⧸P)`, or `ht P = ht p` and
  `trdeg k (R⧸p) + 1 ≤ trdeg k (R[X]⧸P)`. The height identity is Stacks
  `00ON` (`Ideal.height_eq_height_add_of_liesOver_of_hasGoingDown`; `R[X]` is
  free, hence flat, hence going-down over `R`), and the fiber prime in
  `R[X]/pR[X] ≅ (R⧸p)[X]` is either `⊥` (the residue algebra gains a
  transcendental element) or nonzero (height `≥ 1`).
* `MvPolynomial.exists_le_trdeg_and_natCard_le_height_add` (**Lemma A**): for
  any prime `P` of `k[xᵢ : i ∈ ι]` (`ι` finite) there is `d : ℕ` with
  `d ≤ trdeg k (k[xᵢ] ⧸ P)` and `#ι ≤ ht P + d`. Induction on `ι` via the
  step lemma. No Noether normalisation is needed.
* `Algebra.IsStandardSmoothOfRelativeDimension.exists_le_trdeg_and_natCast_le_height_add`
  (**Lemma B**): the transfer to a standard-smooth algebra `S` of relative
  dimension `n`: for any prime `q ⊆ S` there is `d : ℕ` with
  `d ≤ trdeg k (S ⧸ q)` and `n ≤ ht q + d`. Same pullback pattern as the
  closed-point `natCast_le_height_of_isMaximal` in
  `StandardSmoothDimension.lean` (Krull's height theorem bounds the height
  defect by the number of relations of a submersive presentation).
* `Algebra.rank_kaehlerDifferential_eq_trdeg` (**Lemma C**): for an
  essentially-finite-type field extension `K` of a perfect field `k`,
  `rank_K Ω[K⁄k] = trdeg k K`. Choose a separating transcendence basis `s`
  (`exists_isTranscendenceBasis_and_isSeparable_of_perfectField`); over the
  rational-function subfield `F = k(s)` the extension is formally étale, so
  `Ω[K⁄k] ≃ K ⊗_F Ω[F⁄k]`, and `Ω[F⁄k]` is the localised module of
  `Ω[k[s]⁄k]`, free with basis `{d xᵢ}`.
* `finrank_cotangentSpace_add_finrank_kaehler_residueField` (**Lemma D**): the
  conormal (Stacks `02JK`) dimension count at an arbitrary prime: for a local
  algebra `Sₘ` formally smooth over `R` with formally smooth residue field
  `κ` and `Ω[Sₘ⁄R]` free of rank `n`,
  `dim_κ (m/m²) + dim_κ Ω[κ⁄R] = n`. This generalises the iter-199
  closed-point computation in `CodimOneExtension.lean` (there
  `Subsingleton Ω[κ⁄R]` forced `dim_κ m/m² = n`): the retraction from
  `FormallySmooth R κ` still makes the conormal map `m/m² → κ ⊗ Ω[Sₘ⁄R]`
  (split) injective, the cokernel is `Ω[κ⁄R]` by exactness
  (`exact_kerCotangentToTensor_mapBaseChange`) plus surjectivity of
  `mapBaseChange`, and rank–nullity gives the identity.
* `isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField`
  (**Theorem**, Stacks `00TT` at every prime): combining B, C, D: at any
  prime `q` of a standard-smooth `k`-algebra (`k` perfect, e.g. algebraically
  closed), any localisation `S_q` is a regular local ring. Indeed
  `dim_κ (m/m²) = n - dim_κ Ω[κ⁄k] = n - trdeg k κ ≤ ht q = dim S_q`, and a
  Noetherian local ring with `dim_κ m/m² ≤ dim` is regular
  (`IsRegularLocalRing.of_finrank_cotangentSpace_le_ringKrullDim` from
  `StandardSmoothDimension.lean`).

The consumer is `isRegularLocalRing_stalk_of_smooth` in
`Albanese/CodimOneExtension.lean` (the Stage-6 keystone of the codim-1
extension pipeline), which instantiates the theorem at the stalk of a smooth
variety over an algebraically closed field.

Blueprint chapter: `blueprint/src/chapters/Albanese_CodimOneExtension.tex`
(nodes `lem:polynomial_step_height_trdeg`, `lem:mvpoly_trdeg_height`,
`lem:standard_smooth_trdeg_height`, `lem:kaehler_rank_eq_trdeg`,
`lem:conormal_finrank_identity`, `thm:standard_smooth_regular_at_prime`).
-/

universe u v

set_option maxSynthPendingDepth 3

open Ideal

section TrdegHelpers

variable {k : Type u} [Field k]

/-- Adjoining a polynomial variable to a domain raises the transcendence degree
by (at least) one: `trdeg k A + 1 ≤ trdeg k A[X]`. Superadditivity of `trdeg`
in the tower `k → A → A[X]` plus `trdeg A A[X] = 1`. -/
private lemma trdeg_add_one_le_trdeg_polynomial
    (A : Type v) [CommRing A] [IsDomain A] [Algebra k A] :
    Algebra.trdeg k A + 1 ≤ Algebra.trdeg k (Polynomial A) := by
  haveI : FaithfulSMul k A :=
    (faithfulSMul_iff_algebraMap_injective k A).mpr (algebraMap k A).injective
  haveI : FaithfulSMul A (Polynomial A) :=
    (faithfulSMul_iff_algebraMap_injective A (Polynomial A)).mpr
      Polynomial.C_injective
  have h := trdeg_add_le (R := k) (S := A) (A := Polynomial A)
  rwa [Polynomial.trdeg_of_isDomain] at h

/-- If a prime `Q ⊆ A[X]` contracts to `⊥` in `A`, the residue algebra
`A[X] ⧸ Q` contains (a copy of) `A`; hence `trdeg k A ≤ trdeg k (A[X] ⧸ Q)`. -/
private lemma trdeg_le_trdeg_polynomial_quotient
    (A : Type v) [CommRing A] [Algebra k A]
    (Q : Ideal (Polynomial A)) (hQA : Q.comap (algebraMap A (Polynomial A)) = ⊥) :
    Algebra.trdeg k A ≤ Algebra.trdeg k (Polynomial A ⧸ Q) := by
  refine trdeg_le_of_injective
    ((Ideal.Quotient.mkₐ k Q).comp (IsScalarTower.toAlgHom k A (Polynomial A))) ?_
  rw [injective_iff_map_eq_zero]
  intro a ha
  simp only [AlgHom.coe_comp, Function.comp_apply, Ideal.Quotient.mkₐ_eq_mk,
    IsScalarTower.coe_toAlgHom', Ideal.Quotient.eq_zero_iff_mem] at ha
  have h1 : a ∈ Q.comap (algebraMap A (Polynomial A)) := ha
  rw [hQA] at h1
  simpa using h1

/-- Quotienting by `⊥` does not lower the transcendence degree (one inequality
suffices downstream). -/
private lemma trdeg_le_trdeg_quotient_bot
    (B : Type v) [CommRing B] [Algebra k B] :
    Algebra.trdeg k B ≤ Algebra.trdeg k (B ⧸ (⊥ : Ideal B)) := by
  refine trdeg_le_of_injective (Ideal.Quotient.mkₐ k ⊥) ?_
  rw [injective_iff_map_eq_zero]
  intro b hb
  rw [Ideal.Quotient.mkₐ_eq_mk, Ideal.Quotient.eq_zero_iff_mem] at hb
  simpa using hb

/-- Transcendence degree is monotone along `k`-algebra isomorphisms (one
inequality suffices downstream). -/
private lemma trdeg_le_of_algEquiv
    {B C : Type v} [CommRing B] [CommRing C] [Algebra k B] [Algebra k C]
    (g : B ≃ₐ[k] C) : Algebra.trdeg k B ≤ Algebra.trdeg k C :=
  trdeg_le_of_injective g.toAlgHom g.injective

/-- The quotient by the (membership-described) preimage of an ideal embeds into
the quotient by the ideal, so transcendence degrees compare. Stated with an
explicit membership equivalence to avoid comparing coercion paths. -/
private lemma trdeg_quotient_le_of_forall_mem_iff
    {B C : Type v} [CommRing B] [CommRing C] [Algebra k B] [Algebra k C]
    (g : B →ₐ[k] C) (P : Ideal C) (P₀ : Ideal B)
    (hmem : ∀ a : B, a ∈ P₀ ↔ g a ∈ P) :
    Algebra.trdeg k (B ⧸ P₀) ≤ Algebra.trdeg k (C ⧸ P) := by
  set φ : B →ₐ[k] C ⧸ P := (Ideal.Quotient.mkₐ k P).comp g with hφdef
  have hφmem : ∀ a : B, φ a = 0 ↔ a ∈ P₀ := by
    intro a
    rw [hφdef]
    simp only [AlgHom.coe_comp, Function.comp_apply, Ideal.Quotient.mkₐ_eq_mk,
      Ideal.Quotient.eq_zero_iff_mem]
    exact (hmem a).symm
  refine trdeg_le_of_injective (Ideal.Quotient.liftₐ P₀ φ
    (fun a ha => (hφmem a).mpr ha)) ?_
  rw [injective_iff_map_eq_zero]
  intro x hx
  obtain ⟨b, rfl⟩ := Ideal.Quotient.mk_surjective x
  rw [Ideal.Quotient.liftₐ_apply, Ideal.Quotient.lift_mk] at hx
  rw [Ideal.Quotient.eq_zero_iff_mem]
  exact (hφmem b).mp hx

end TrdegHelpers

section PolynomialStep

/-! ### The one-variable step of Lemma A -/

variable {k : Type u} [Field k] {R : Type v} [CommRing R] [IsNoetherianRing R]
  [Algebra k R]

/-- **One-variable step for the trdeg–height inequality.** For a prime
`P ⊆ R[X]` lying over `p = P ∩ R` in a Noetherian ring `R`, either the height
jumps (`ht p + 1 ≤ ht P`) while the residue algebra still contains `R⧸p`, or
the height is preserved (`ht P = ht p`) and the residue algebra gains a
transcendental element (`trdeg + 1`). Stacks `00ON` supplies
`ht P = ht p + ht P̄` for the fiber prime `P̄` of `R[X]/pR[X] ≅ (R⧸p)[X]`;
the two cases are `P̄ ≠ ⊥` (then `ht P̄ ≥ 1`) and `P̄ = ⊥` (then
`R[X]⧸P ≅ (R⧸p)[X]`). -/
private theorem Polynomial.step_height_trdeg_of_isPrime
    (P : Ideal (Polynomial R)) (hP : P.IsPrime) :
    ((P.comap (algebraMap R (Polynomial R))).height + 1 ≤ P.height ∧
      Algebra.trdeg k (R ⧸ P.comap (algebraMap R (Polynomial R))) ≤
        Algebra.trdeg k (Polynomial R ⧸ P)) ∨
    (P.height = (P.comap (algebraMap R (Polynomial R))).height ∧
      Algebra.trdeg k (R ⧸ P.comap (algebraMap R (Polynomial R))) + 1 ≤
        Algebra.trdeg k (Polynomial R ⧸ P)) := by
  haveI := hP
  set p : Ideal R := P.comap (algebraMap R (Polynomial R)) with hpdef
  haveI hp : p.IsPrime := Ideal.comap_isPrime _ P
  haveI : P.LiesOver p := ⟨rfl⟩
  -- Stacks 00ON (going-down for the flat extension `R → R[X]`).
  haveI : Module.Flat R (Polynomial R) := Module.Flat.of_free
  have h00 := Ideal.height_eq_height_add_of_liesOver_of_hasGoingDown p P
  -- Notation for the fiber.
  set pX : Ideal (Polynomial R) := p.map (algebraMap R (Polynomial R)) with hpXdef
  have hker_le : pX ≤ P := Ideal.map_le_iff_le_comap.mpr le_rfl
  set Pbar : Ideal (Polynomial R ⧸ pX) := P.map (Ideal.Quotient.mk pX) with hPbardef
  haveI hPbarPrime : Pbar.IsPrime :=
    Ideal.map_isPrime_of_surjective Ideal.Quotient.mk_surjective
      (by rwa [Ideal.mk_ker])
  set A := R ⧸ p with hAdef
  haveI : IsDomain A := Ideal.Quotient.isDomain p
  -- The fiber ring identification `A[X] ≃+* R[X] ⧸ pR[X]`.
  have hCeq : p.map (Polynomial.C (R := R)) = pX := by
    rw [hpXdef, Polynomial.algebraMap_eq]
  set e2 : Polynomial A ≃+* (Polynomial R ⧸ pX) :=
    p.polynomialQuotientEquivQuotientPolynomial.trans (Ideal.quotEquivOfEq hCeq)
    with he2def
  have hcomm : ∀ r : R, e2 (Polynomial.C (Ideal.Quotient.mk p r)) =
      Ideal.Quotient.mk pX (Polynomial.C r) := by
    intro r
    have hs := Ideal.polynomialQuotientEquivQuotientPolynomial_symm_mk p (Polynomial.C r)
    rw [Polynomial.map_C] at hs
    have hfwd : p.polynomialQuotientEquivQuotientPolynomial
        (Polynomial.C (Ideal.Quotient.mk p r)) =
        Ideal.Quotient.mk _ (Polynomial.C r) := by
      rw [← hs, RingEquiv.apply_symm_apply]
    rw [he2def, RingEquiv.coe_trans, Function.comp_apply, hfwd, Ideal.quotEquivOfEq_mk]
  -- The fiber prime `Q ⊆ A[X]` and its basic properties.
  set Q : Ideal (Polynomial A) := Pbar.comap e2 with hQdef
  haveI hQPrime : Q.IsPrime := Ideal.comap_isPrime _ Pbar
  have hQheight : Q.height = Pbar.height := RingEquiv.height_comap e2 Pbar
  have hQmap : Pbar = Q.map (e2 : Polynomial A →+* (Polynomial R ⧸ pX)) := by
    have hcoe : Q = Pbar.comap (e2 : Polynomial A →+* (Polynomial R ⧸ pX)) :=
      Ideal.ext fun x => Iff.rfl
    rw [hcoe, Ideal.map_comap_of_surjective
      (e2 : Polynomial A →+* (Polynomial R ⧸ pX)) e2.surjective]
  -- Membership translation between `Q` and `P`.
  have hmem : ∀ r : R, Polynomial.C (Ideal.Quotient.mk p r) ∈ Q ↔ Polynomial.C r ∈ P := by
    intro r
    rw [hQdef, Ideal.mem_comap, hcomm, hPbardef, Ideal.mem_quotient_iff_mem hker_le]
  -- The contraction of `Q` to `A` is trivial.
  have hQA : Q.comap (algebraMap A (Polynomial A)) = ⊥ := by
    ext a
    obtain ⟨r, rfl⟩ := Ideal.Quotient.mk_surjective a
    rw [Ideal.mem_comap, Polynomial.algebraMap_eq, Submodule.mem_bot, hmem r,
      Ideal.Quotient.eq_zero_iff_mem]
    change Polynomial.C r ∈ P ↔ r ∈ p
    rw [hpdef, Ideal.mem_comap, Polynomial.algebraMap_eq]
  -- The `k`-algebra upgrade of `e2`.
  have he2c : ∀ c : k, e2 (algebraMap k (Polynomial A) c) =
      algebraMap k (Polynomial R ⧸ pX) c := by
    intro c
    rw [IsScalarTower.algebraMap_apply k A (Polynomial A), Polynomial.algebraMap_eq,
      IsScalarTower.algebraMap_apply k R A, Ideal.Quotient.algebraMap_eq, hcomm,
      IsScalarTower.algebraMap_apply k (Polynomial R) (Polynomial R ⧸ pX),
      Ideal.Quotient.algebraMap_eq, IsScalarTower.algebraMap_apply k R (Polynomial R),
      Polynomial.algebraMap_eq]
  set e2alg : Polynomial A ≃ₐ[k] (Polynomial R ⧸ pX) := AlgEquiv.ofRingEquiv he2c
    with he2algdef
  -- The `k`-algebra identification of the residue algebras.
  have hQmapAlg : Pbar = Q.map (e2alg : Polynomial A →+* (Polynomial R ⧸ pX)) := by
    rw [hQmap]
    congr 1
  have gQuot : (Polynomial A ⧸ Q) ≃ₐ[k] (Polynomial R ⧸ P) := by
    refine (Ideal.quotientEquivAlg Q Pbar e2alg hQmapAlg).trans ?_
    refine AlgEquiv.ofRingEquiv (f := DoubleQuot.quotQuotEquivQuotOfLE hker_le) ?_
    intro c
    have hL : algebraMap k ((Polynomial R ⧸ pX) ⧸ Pbar) c =
        Ideal.Quotient.mk Pbar (Ideal.Quotient.mk pX (algebraMap k (Polynomial R) c)) := by
      rw [IsScalarTower.algebraMap_apply k (Polynomial R ⧸ pX)
          ((Polynomial R ⧸ pX) ⧸ Pbar),
        Ideal.Quotient.algebraMap_eq,
        IsScalarTower.algebraMap_apply k (Polynomial R) (Polynomial R ⧸ pX),
        Ideal.Quotient.algebraMap_eq]
    have hR : algebraMap k (Polynomial R ⧸ P) c =
        Ideal.Quotient.mk P (algebraMap k (Polynomial R) c) := by
      rw [IsScalarTower.algebraMap_apply k (Polynomial R) (Polynomial R ⧸ P),
        Ideal.Quotient.algebraMap_eq]
    rw [hL, hR]
    exact DoubleQuot.quotQuotEquivQuotOfLE_quotQuotMk (algebraMap k (Polynomial R) c) hker_le
  -- Case split on the fiber prime.
  by_cases hQ : Q = ⊥
  · -- Fiber prime trivial: heights agree, transcendence degree gains one.
    right
    have hPbarBot : Pbar = ⊥ := by rw [hQmap, hQ, Ideal.map_bot]
    haveI : Nontrivial (Polynomial R ⧸ pX) :=
      Ideal.Quotient.nontrivial_iff.mpr
        (fun htop => hP.ne_top (top_le_iff.mp (htop ▸ hker_le)))
    constructor
    · rw [h00, hPbarBot, Ideal.height_bot, add_zero]
    · calc Algebra.trdeg k A + 1
          ≤ Algebra.trdeg k (Polynomial A) := trdeg_add_one_le_trdeg_polynomial A
        _ ≤ Algebra.trdeg k (Polynomial A ⧸ Q) := by
            rw [hQ]; exact trdeg_le_trdeg_quotient_bot _
        _ ≤ Algebra.trdeg k (Polynomial R ⧸ P) := trdeg_le_of_algEquiv gQuot
  · -- Fiber prime nontrivial: the height jumps by at least one.
    left
    have h1Q : 1 ≤ Q.height := by
      haveI : (⊥ : Ideal (Polynomial A)).IsPrime := Ideal.isPrime_bot
      have hlt : (⊥ : Ideal (Polynomial A)) < Q := bot_lt_iff_ne_bot.mpr hQ
      have h := Ideal.height_add_one_le_of_lt_of_isPrime hlt
      rwa [Ideal.height_bot, zero_add] at h
    constructor
    · rw [h00]
      gcongr
      exact le_trans h1Q (le_of_eq hQheight)
    · calc Algebra.trdeg k A
          ≤ Algebra.trdeg k (Polynomial A ⧸ Q) :=
            trdeg_le_trdeg_polynomial_quotient A Q hQA
        _ ≤ Algebra.trdeg k (Polynomial R ⧸ P) := trdeg_le_of_algEquiv gQuot

end PolynomialStep

section LemmaA

/-! ### Lemma A: the trdeg–height inequality at primes of polynomial rings -/

/-- **Lemma A (trdeg–height inequality in finite polynomial rings).** For a
field `k`, a finite index type `ι` and a prime ideal `P ⊆ k[xᵢ : i ∈ ι]`,
there is a natural number `d` with `d ≤ trdeg k (k[xᵢ] ⧸ P)` and
`#ι ≤ ht P + d`. (Classically `d` is the transcendence degree of the residue
field and both inequalities are equalities; the one-sided witness form is all
the regularity pipeline needs, and keeps the induction free of fraction
fields.) Induction on `ι` via `Finite.induction_empty_option` and the
one-variable step lemma `Polynomial.step_height_trdeg_of_isPrime`. -/
theorem MvPolynomial.exists_le_trdeg_and_natCard_le_height_add
    {k : Type u} [Field k] {ι : Type v} [Finite ι]
    (P : Ideal (MvPolynomial ι k)) (hP : P.IsPrime) :
    ∃ d : ℕ, (d : Cardinal) ≤ Algebra.trdeg k (MvPolynomial ι k ⧸ P) ∧
      (Nat.card ι : ℕ∞) ≤ P.height + d := by
  induction ι using Finite.induction_empty_option with
  | of_equiv e IH =>
    haveI := hP
    set ψ := MvPolynomial.renameEquiv k e with hψdef
    set P₀ := P.comap ψ.toRingEquiv with hP₀def
    haveI hP₀p : P₀.IsPrime := Ideal.comap_isPrime _ P
    obtain ⟨d, hd, hht⟩ := IH P₀ hP₀p
    refine ⟨d, ?_, ?_⟩
    · refine le_trans hd (trdeg_quotient_le_of_forall_mem_iff ψ.toAlgHom P P₀ ?_)
      intro a
      rw [hP₀def, Ideal.mem_comap]
      exact Iff.rfl
    · have hh : P₀.height = P.height := by
        rw [hP₀def]
        exact RingEquiv.height_comap ψ.toRingEquiv P
      rw [← Nat.card_congr e]
      rwa [hh] at hht
  | h_empty =>
    exact ⟨0, by simp, by simp⟩
  | h_option IH =>
    rename_i α _
    haveI := hP
    set ψ : MvPolynomial (Option α) k ≃ₐ[k] Polynomial (MvPolynomial α k) :=
      MvPolynomial.optionEquivLeft k α with hψdef
    set P' : Ideal (Polynomial (MvPolynomial α k)) := P.comap ψ.symm.toRingEquiv
      with hP'def
    haveI hP'p : P'.IsPrime := Ideal.comap_isPrime _ P
    have hPheight : P'.height = P.height := by
      rw [hP'def]
      exact RingEquiv.height_comap ψ.symm.toRingEquiv P
    have htr : Algebra.trdeg k (Polynomial (MvPolynomial α k) ⧸ P') ≤
        Algebra.trdeg k (MvPolynomial (Option α) k ⧸ P) := by
      refine trdeg_quotient_le_of_forall_mem_iff ψ.symm.toAlgHom P P' ?_
      intro a
      rw [hP'def, Ideal.mem_comap]
      exact Iff.rfl
    set p : Ideal (MvPolynomial α k) :=
      P'.comap (algebraMap (MvPolynomial α k) (Polynomial (MvPolynomial α k))) with hpdef
    haveI hpp : p.IsPrime := Ideal.comap_isPrime _ P'
    obtain ⟨d, hd, hht⟩ := IH p hpp
    have hstep := Polynomial.step_height_trdeg_of_isPrime (k := k) P' hP'p
    have hcard : (Nat.card (Option α) : ℕ∞) = (Nat.card α : ℕ∞) + 1 := by
      rw [Finite.card_option]
      push_cast
      rfl
    rcases hstep with ⟨hh, ht⟩ | ⟨hh, ht⟩
    · -- Height jumped: keep the same witness `d`.
      refine ⟨d, ?_, ?_⟩
      · exact le_trans (le_trans hd ht) htr
      · rw [hcard]
        calc (Nat.card α : ℕ∞) + 1 ≤ (p.height + d) + 1 := by gcongr
          _ = (p.height + 1) + d := by
              rw [add_assoc, add_comm (d : ℕ∞) 1, ← add_assoc]
          _ ≤ P'.height + d := by gcongr
          _ = P.height + d := by rw [hPheight]
    · -- Transcendence degree jumped: use `d + 1`.
      refine ⟨d + 1, ?_, ?_⟩
      · push_cast
        refine le_trans ?_ (le_trans ht htr)
        gcongr
      · rw [hcard]
        push_cast
        calc (Nat.card α : ℕ∞) + 1 ≤ (p.height + d) + 1 := by gcongr
          _ = p.height + ((d : ℕ∞) + 1) := by rw [add_assoc]
          _ = P.height + ((d : ℕ∞) + 1) := by rw [← hPheight, hh]

end LemmaA

section LemmaB

/-! ### Lemma B: transfer to standard-smooth algebras -/

/-- **Lemma B (trdeg–height inequality for standard-smooth algebras).** For a
standard-smooth algebra `S` of relative dimension `n` over a field `k` and a
prime ideal `q ⊆ S`, there is `d : ℕ` with `d ≤ trdeg k (S ⧸ q)` and
`n ≤ ht q + d`. Pull `q` back along a submersive presentation
`P.Ring = k[xᵢ] ↠ S`, apply Lemma A to the pullback and Krull's height
theorem (`Ideal.height_le_height_add_spanFinrank_of_le`) to descend, exactly
as in the closed-point lemma `natCast_le_height_of_isMaximal` of
`StandardSmoothDimension.lean`. -/
theorem Algebra.IsStandardSmoothOfRelativeDimension.exists_le_trdeg_and_natCast_le_height_add
    {k : Type u} [Field k] {S : Type u} [CommRing S] [Algebra k S] (n : ℕ)
    [H : Algebra.IsStandardSmoothOfRelativeDimension n k S]
    (q : Ideal S) (hq : q.IsPrime) :
    ∃ d : ℕ, (d : Cardinal) ≤ Algebra.trdeg k (S ⧸ q) ∧ (n : ℕ∞) ≤ q.height + d := by
  obtain ⟨ι, σ, hσ, hι, P, hPdim⟩ := H.out
  haveI := hq
  have hsurj : Function.Surjective (algebraMap P.Ring S) := P.algebraMap_surjective
  set M : Ideal P.Ring := q.comap (algebraMap P.Ring S) with hMdef
  haveI hM : M.IsPrime := Ideal.comap_isPrime _ q
  obtain ⟨d, hd, hA⟩ := MvPolynomial.exists_le_trdeg_and_natCard_le_height_add M hM
  refine ⟨d, ?_, ?_⟩
  · -- Transport trdeg along the induced embedding `P.Ring ⧸ M →ₐ[k] S ⧸ q`.
    set φ : P.Ring →ₐ[k] S ⧸ q :=
      (Ideal.Quotient.mkₐ k q).comp (IsScalarTower.toAlgHom k P.Ring S) with hφdef
    have hφker : ∀ a ∈ M, φ a = 0 := by
      intro a ha
      simp only [hφdef, AlgHom.coe_comp, Function.comp_apply, Ideal.Quotient.mkₐ_eq_mk,
        IsScalarTower.coe_toAlgHom', Ideal.Quotient.eq_zero_iff_mem]
      exact ha
    have hφqinj : Function.Injective (Ideal.Quotient.liftₐ M φ hφker) := by
      rw [injective_iff_map_eq_zero]
      intro x hx
      obtain ⟨r, rfl⟩ := Ideal.Quotient.mk_surjective x
      rw [Ideal.Quotient.liftₐ_apply, Ideal.Quotient.lift_mk] at hx
      have h2 : φ r = 0 := hx
      rw [hφdef] at h2
      simp only [AlgHom.coe_comp, Function.comp_apply, Ideal.Quotient.mkₐ_eq_mk,
        IsScalarTower.coe_toAlgHom', Ideal.Quotient.eq_zero_iff_mem] at h2
      rw [Ideal.Quotient.eq_zero_iff_mem, hMdef]
      exact Ideal.mem_comap.mpr h2
    exact le_trans hd (trdeg_le_of_injective _ hφqinj)
  · -- Height bookkeeping (mirror of the closed-point proof).
    have hker_le : RingHom.ker (algebraMap P.Ring S) ≤ M := fun x hx => by
      rw [hMdef, Ideal.mem_comap, RingHom.mem_ker.mp hx]
      exact q.zero_mem
    have hbound := Ideal.height_le_height_add_spanFinrank_of_le hker_le
    set e := (algebraMap P.Ring S : P.Ring →+* S).quotientKerEquivOfSurjective hsurj
      with hedef
    have hMcomap : M = Ideal.comap (Ideal.Quotient.mk (RingHom.ker (algebraMap P.Ring S)))
        (Ideal.comap e q) := by
      ext x
      simp only [hMdef, Ideal.mem_comap]
      rw [hedef, RingHom.quotientKerEquivOfSurjective_apply_mk]
    have hqheight : (M.map (Ideal.Quotient.mk (RingHom.ker (algebraMap P.Ring S)))).height
        = q.height := by
      rw [hMcomap, Ideal.map_comap_of_surjective _ Ideal.Quotient.mk_surjective,
        RingEquiv.height_comap]
    have hker_span : RingHom.ker (algebraMap P.Ring S) = Ideal.span (Set.range P.relation) :=
      P.span_range_relation_eq_ker.symm
    have hfr : (RingHom.ker (algebraMap P.Ring S)).spanFinrank ≤ Nat.card σ := by
      rw [hker_span]
      refine le_trans (Submodule.spanFinrank_span_le_ncard_of_finite (Set.finite_range _)) ?_
      calc (Set.range P.relation).ncard
          = (P.relation '' Set.univ).ncard := by rw [Set.image_univ]
        _ ≤ (Set.univ : Set σ).ncard := Set.ncard_image_le Set.finite_univ
        _ = Nat.card σ := Set.ncard_univ σ
    have hcards : n + Nat.card σ = Nat.card ι := by
      have hle : Nat.card σ ≤ Nat.card ι := Nat.card_le_card_of_injective P.map P.map_inj
      have hdim : Nat.card ι - Nat.card σ = n := hPdim
      omega
    have h1 : (Nat.card ι : ℕ∞) ≤ (q.height + d) + Nat.card σ := by
      calc (Nat.card ι : ℕ∞) ≤ M.height + d := hA
        _ ≤ ((M.map (Ideal.Quotient.mk (RingHom.ker (algebraMap P.Ring S)))).height
            + (RingHom.ker (algebraMap P.Ring S)).spanFinrank) + d := by gcongr
        _ ≤ (q.height + Nat.card σ) + d := by
            rw [hqheight]
            have hfr' : ((RingHom.ker (algebraMap P.Ring S)).spanFinrank : ℕ∞)
                ≤ (Nat.card σ : ℕ∞) := by exact_mod_cast hfr
            gcongr
        _ = (q.height + d) + Nat.card σ := by
            rw [add_assoc, add_comm (Nat.card σ : ℕ∞) (d : ℕ∞), ← add_assoc]
    rw [← hcards] at h1
    push_cast at h1
    exact (ENat.add_le_add_iff_right (by simp)).mp h1

end LemmaB

section LemmaC

/-! ### Lemma C: Kähler rank equals transcendence degree over a perfect field -/

open KaehlerDifferential Cardinal Module

/-- Ω-rank is invariant under `k`-algebra isomorphisms: transport along the
formally étale algebra structure induced by the isomorphism, then apply the
étale base-change identification of Kähler differentials. -/
private lemma rank_kaehlerDifferential_eq_of_algEquiv
    {k : Type u} [CommRing k] {B C : Type u} [Field B] [Field C]
    [Algebra k B] [Algebra k C] (e : B ≃ₐ[k] C) :
    Module.rank B (Ω[B⁄k]) = Module.rank C (Ω[C⁄k]) := by
  letI : Algebra B C := e.toAlgHom.toRingHom.toAlgebra
  haveI : IsScalarTower k B C := IsScalarTower.of_algebraMap_eq fun x =>
    (e.commutes x).symm
  haveI : Algebra.FormallyEtale B C := by
    have e' : B ≃ₐ[B] C := AlgEquiv.ofBijective (Algebra.ofId B C) e.bijective
    exact Algebra.FormallyEtale.of_equiv e'
  rw [← (tensorKaehlerEquivOfFormallyEtale k B C).rank_eq, Module.rank_baseChange,
    Cardinal.lift_id]

/-- **Lemma C: the Kähler rank of an essentially-finite-type field extension
of a perfect field equals its transcendence degree.** Choose a separating
transcendence basis `s` (`PerfectField` +
`exists_isTranscendenceBasis_and_isSeparable_of_perfectField`); the extension
`K / k(s)` is separable algebraic hence formally étale, so
`Ω[K⁄k] ≃ K ⊗_{k(s)} Ω[k(s)⁄k]`, and `Ω[k(s)⁄k]` is the localisation of the
free module `Ω[k[s]⁄k]` with basis `{d xᵢ : i ∈ s}`. -/
theorem Algebra.rank_kaehlerDifferential_eq_trdeg
    (k K : Type u) [Field k] [PerfectField k] [Field K] [Algebra k K]
    [Algebra.EssFiniteType k K] :
    Module.rank K (Ω[K⁄k]) = Algebra.trdeg k K := by
  obtain ⟨s, hs, H⟩ := exists_isTranscendenceBasis_and_isSeparable_of_perfectField k K
  set F : IntermediateField k K := IntermediateField.adjoin k (s : Set K) with hFdef
  haveI : Algebra.IsSeparable F K := H
  haveI : Algebra.FormallyEtale F K := Algebra.FormallyEtale.of_isSeparable F K
  -- Step 1: étale base change along `F ⊆ K`.
  have h1 : Module.rank K (Ω[K⁄k]) = Module.rank F (Ω[F⁄k]) := by
    rw [← (tensorKaehlerEquivOfFormallyEtale k F K).rank_eq, Module.rank_baseChange,
      Cardinal.lift_id]
  -- Step 2: `F ≃ₐ[k] Frac k[s]` via the transcendence basis.
  have hrange : Set.range ((↑) : {x // x ∈ s} → K) = (s : Set K) := Subtype.range_coe
  have e : FractionRing (MvPolynomial {x // x ∈ s} k) ≃ₐ[k] F := by
    rw [hFdef, ← hrange]
    exact hs.1.aevalEquivField
  have h2 : Module.rank F (Ω[F⁄k]) =
      Module.rank (FractionRing (MvPolynomial {x // x ∈ s} k))
        (Ω[FractionRing (MvPolynomial {x // x ∈ s} k)⁄k]) :=
    (rank_kaehlerDifferential_eq_of_algEquiv e).symm
  -- Step 3: `Ω` of the fraction field of the polynomial ring is free of rank `#s`.
  have h3 : Module.rank (FractionRing (MvPolynomial {x // x ∈ s} k))
      (Ω[FractionRing (MvPolynomial {x // x ∈ s} k)⁄k]) = #{x // x ∈ s} := by
    haveI : IsLocalizedModule (nonZeroDivisors (MvPolynomial {x // x ∈ s} k))
        (map k k (MvPolynomial {x // x ∈ s} k)
          (FractionRing (MvPolynomial {x // x ∈ s} k))) :=
      isLocalizedModule_map k (MvPolynomial {x // x ∈ s} k)
        (FractionRing (MvPolynomial {x // x ∈ s} k))
        (nonZeroDivisors (MvPolynomial {x // x ∈ s} k))
    have b : Basis {x // x ∈ s} (FractionRing (MvPolynomial {x // x ∈ s} k))
        (Ω[FractionRing (MvPolynomial {x // x ∈ s} k)⁄k]) :=
      (mvPolynomialBasis k {x // x ∈ s}).ofIsLocalizedModule
        (FractionRing (MvPolynomial {x // x ∈ s} k))
        (nonZeroDivisors (MvPolynomial {x // x ∈ s} k))
        (map k k (MvPolynomial {x // x ∈ s} k)
          (FractionRing (MvPolynomial {x // x ∈ s} k)))
    exact (b.mk_eq_rank'').symm
  -- Step 4: `#s = trdeg k K` since `s` is a transcendence basis.
  have h4 : (#{x // x ∈ s} : Cardinal) = Algebra.trdeg k K := hs.cardinalMk_eq_trdeg
  rw [h1, h2, h3, h4]

end LemmaC

section LemmaD

/-! ### Lemma D: the conormal dimension identity -/

open KaehlerDifferential IsLocalRing

/-- **Lemma D: the conormal (Stacks 02JK) dimension identity at an arbitrary
prime.** For a local algebra `Sₘ` formally smooth over `R`, with residue field
`κ` also formally smooth over `R` (automatic over a perfect base field) and
Kähler differentials free of rank `n`,

`dim_κ (m/m²) + dim_κ Ω[κ⁄R] = n.`

Proof: the conormal map `m/m² → κ ⊗ Ω[Sₘ⁄R]` is (split) injective by
`Algebra.FormallySmooth.iff_split_injection` (using `FormallySmooth R κ`), its
cokernel is `Ω[κ⁄R]` by `exact_kerCotangentToTensor_mapBaseChange` plus
surjectivity of `mapBaseChange`, and the middle term has dimension `n`;
rank–nullity gives the identity. This generalises the iter-199 closed-point
computation (which additionally assumed `Subsingleton Ω[κ⁄R]`). -/
theorem finrank_cotangentSpace_add_finrank_kaehler_residueField
    {R Sₘ : Type u} [CommRing R] [CommRing Sₘ] [IsLocalRing Sₘ]
    [Algebra R Sₘ] [Algebra.FormallySmooth R Sₘ]
    [Algebra.FormallySmooth R (ResidueField Sₘ)]
    [Module.Free Sₘ (Ω[Sₘ⁄R])]
    (n : ℕ) (hrank : Module.rank Sₘ (Ω[Sₘ⁄R]) = n) :
    Module.finrank (ResidueField Sₘ) (CotangentSpace Sₘ)
      + Module.finrank (ResidueField Sₘ) (Ω[ResidueField Sₘ⁄R]) = n := by
  have hSurj : Function.Surjective (algebraMap Sₘ (ResidueField Sₘ)) := by
    rw [IsLocalRing.ResidueField.algebraMap_eq]
    exact IsLocalRing.residue_surjective
  have hker : RingHom.ker (algebraMap Sₘ (ResidueField Sₘ)) = maximalIdeal Sₘ := by
    rw [IsLocalRing.ResidueField.algebraMap_eq, IsLocalRing.ker_residue]
  -- Step 1: the Sₘ-linear conormal map out of the maximal-ideal cotangent,
  -- injective with range the kernel of `mapBaseChange`.
  obtain ⟨f, hfinj, hfrange⟩ :
      ∃ f : (maximalIdeal Sₘ).Cotangent →ₗ[Sₘ]
          TensorProduct Sₘ (ResidueField Sₘ) (Ω[Sₘ⁄R]),
        Function.Injective f ∧
          ∀ x, x ∈ LinearMap.ker (mapBaseChange R Sₘ (ResidueField Sₘ)) ↔
            x ∈ Set.range f := by
    rw [← hker]
    refine ⟨kerCotangentToTensor R Sₘ (ResidueField Sₘ), ?_, ?_⟩
    · obtain ⟨l, hl⟩ :=
        (Algebra.FormallySmooth.iff_split_injection
          (R := R) (P := Sₘ) (A := ResidueField Sₘ) hSurj).mp ‹_›
      refine Function.LeftInverse.injective (g := l) fun x => ?_
      have h := LinearMap.congr_fun hl x
      simp only [LinearMap.coe_comp, Function.comp_apply] at h
      exact h
    · intro x
      have h := KaehlerDifferential.exact_kerCotangentToTensor_mapBaseChange R Sₘ
        (ResidueField Sₘ) hSurj x
      rw [LinearMap.mem_ker]
      exact h
  -- Step 2: promote to κ-linear and identify `CotangentSpace` with the kernel.
  set f' : CotangentSpace Sₘ →ₗ[ResidueField Sₘ]
      TensorProduct Sₘ (ResidueField Sₘ) (Ω[Sₘ⁄R]) :=
    f.extendScalarsOfSurjective hSurj with hf'def
  have hf'app : ∀ x, f' x = f x := fun x => rfl
  have hf'inj : Function.Injective f' := fun a b hab => hfinj (by
    rw [← hf'app, ← hf'app]; exact hab)
  have hrangeEq : LinearMap.range f'
      = LinearMap.ker (mapBaseChange R Sₘ (ResidueField Sₘ)) := by
    ext x
    rw [LinearMap.mem_range, hfrange x]
    constructor
    · rintro ⟨y, rfl⟩
      exact ⟨y, (hf'app y).symm⟩
    · rintro ⟨y, hy⟩
      exact ⟨y, by rw [hf'app]; exact hy⟩
  -- Step 3: finite-dimensionality of the middle term, of dimension `n`.
  haveI : Module.Finite Sₘ (Ω[Sₘ⁄R]) := by
    rw [← Module.rank_lt_aleph0_iff, hrank]
    exact Cardinal.natCast_lt_aleph0
  have hmid : Module.finrank (ResidueField Sₘ)
      (TensorProduct Sₘ (ResidueField Sₘ) (Ω[Sₘ⁄R])) = n := by
    rw [Module.finrank_baseChange]
    exact Module.finrank_eq_of_rank_eq hrank
  -- Step 4: rank–nullity for `mapBaseChange`.
  have hgsurj : Function.Surjective (mapBaseChange R Sₘ (ResidueField Sₘ)) :=
    KaehlerDifferential.mapBaseChange_surjective R Sₘ (ResidueField Sₘ) hSurj
  have hrn := LinearMap.finrank_range_add_finrank_ker
    (mapBaseChange R Sₘ (ResidueField Sₘ))
  rw [LinearMap.range_eq_top.mpr hgsurj, finrank_top] at hrn
  have hkerfin : Module.finrank (ResidueField Sₘ)
      (LinearMap.ker (mapBaseChange R Sₘ (ResidueField Sₘ)))
      = Module.finrank (ResidueField Sₘ) (CotangentSpace Sₘ) := by
    rw [← hrangeEq]
    exact (LinearEquiv.finrank_eq (LinearEquiv.ofInjective f' hf'inj)).symm
  rw [hkerfin, hmid] at hrn
  omega

end LemmaD

section Main

/-! ### The main theorem: Stacks 00TT at every prime, Serre-free -/

open KaehlerDifferential IsLocalRing

/-- **Stacks `00TT` at an arbitrary prime over a perfect field (algebra form,
Serre-free).** For a standard-smooth algebra `S` over a perfect field `k`
(e.g. an algebraically closed field), any localisation of `S` at any prime
ideal `q` is a regular local ring. This includes the non-closed points that
the closed-point theorem
`isRegularLocalRing_localization_of_isStandardSmooth_of_bijective_residue` of
`CodimOneExtension.lean` cannot reach, and requires neither Stacks `00OF`
(localisation of regular local rings) nor Serre's homological criterion:
the cotangent dimension is computed directly by the conormal identity
(Lemma D), the Kähler–trdeg identification at the residue field (Lemma C),
and the trdeg–height inequality (Lemmas A/B). -/
theorem isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField
    {k : Type u} [Field k] [PerfectField k]
    {S : Type u} [CommRing S] [Nontrivial S] [Algebra k S]
    [Algebra.IsStandardSmooth k S]
    (q : Ideal S) (hq : q.IsPrime)
    (Sq : Type u) [CommRing Sq] [IsLocalRing Sq] [Algebra k Sq] [Algebra S Sq]
    [IsScalarTower k S Sq] [IsLocalization.AtPrime Sq q] :
    IsRegularLocalRing Sq := by
  haveI := hq
  haveI : IsNoetherianRing S := Algebra.FiniteType.isNoetherianRing k S
  haveI : IsNoetherianRing Sq := IsLocalization.isNoetherianRing q.primeCompl Sq ‹_›
  obtain ⟨n, hn⟩ : ∃ n, Algebra.IsStandardSmoothOfRelativeDimension n k S := by
    obtain ⟨ι, σ, _, _, ⟨P⟩⟩ := (inferInstance : Algebra.IsStandardSmooth k S).out
    exact ⟨P.dimension, P.isStandardSmoothOfRelativeDimension rfl⟩
  haveI := hn
  -- Kähler package at the localisation (free of rank `n`).
  haveI : Module.Free S (Ω[S⁄k]) := Algebra.IsStandardSmooth.free_kaehlerDifferential
  haveI : IsLocalizedModule q.primeCompl (KaehlerDifferential.map k k S Sq) :=
    KaehlerDifferential.isLocalizedModule_map k S Sq q.primeCompl
  haveI : Module.Free Sq (Ω[Sq⁄k]) :=
    Module.free_of_isLocalizedModule (R := S) (Rₛ := Sq) (S := q.primeCompl)
      (M := Ω[S⁄k]) (Mₛ := Ω[Sq⁄k]) (KaehlerDifferential.map k k S Sq)
  have hrank : Module.rank Sq (Ω[Sq⁄k]) = n := by
    have h := Module.lift_rank_of_isLocalizedModule_of_free Sq q.primeCompl
      (KaehlerDifferential.map k k S Sq)
    rw [Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential
      (S := S) n] at h
    simpa using h
  -- Formal smoothness of `Sq` and of its residue field over `k`.
  haveI : Algebra.FormallySmooth S Sq := Algebra.FormallySmooth.of_isLocalization q.primeCompl
  haveI : Algebra.FormallySmooth k Sq := Algebra.FormallySmooth.comp k S Sq
  haveI : Algebra.EssFiniteType k S := Algebra.EssFiniteType.of_finiteType k S
  haveI : Algebra.EssFiniteType S Sq := Algebra.EssFiniteType.of_isLocalization Sq q.primeCompl
  haveI : Algebra.EssFiniteType k Sq := Algebra.EssFiniteType.comp k S Sq
  have hResSurj : Function.Surjective (algebraMap Sq (ResidueField Sq)) := by
    rw [IsLocalRing.ResidueField.algebraMap_eq]
    exact IsLocalRing.residue_surjective
  haveI : Algebra.FiniteType Sq (ResidueField Sq) :=
    Algebra.FiniteType.of_surjective (Algebra.ofId Sq (ResidueField Sq)) hResSurj
  haveI : Algebra.EssFiniteType Sq (ResidueField Sq) :=
    Algebra.EssFiniteType.of_finiteType Sq (ResidueField Sq)
  haveI : Algebra.EssFiniteType k (ResidueField Sq) :=
    Algebra.EssFiniteType.comp k Sq (ResidueField Sq)
  -- (the `Algebra.FormallySmooth.of_perfectField` low-priority instance)
  haveI : Algebra.FormallySmooth k (ResidueField Sq) := inferInstance
  -- Lemma D: the conormal dimension identity at `Sq`.
  have hD := finrank_cotangentSpace_add_finrank_kaehler_residueField
    (R := k) (Sₘ := Sq) n hrank
  -- Lemma B: the trdeg–height inequality at `q`.
  obtain ⟨d, hd, hB⟩ :=
    Algebra.IsStandardSmoothOfRelativeDimension.exists_le_trdeg_and_natCast_le_height_add
      (k := k) n q hq
  -- trdeg monotonicity from `S ⧸ q` into the residue field.
  have hmono : Algebra.trdeg k (S ⧸ q) ≤ Algebra.trdeg k (ResidueField Sq) := by
    set φ : S →ₐ[k] ResidueField Sq :=
      (IsScalarTower.toAlgHom k Sq (ResidueField Sq)).comp
        (IsScalarTower.toAlgHom k S Sq) with hφdef
    have hφmem : ∀ a : S, φ a = 0 ↔ a ∈ q := by
      intro a
      simp only [hφdef, AlgHom.coe_comp, Function.comp_apply, IsScalarTower.coe_toAlgHom']
      rw [IsLocalRing.ResidueField.algebraMap_eq, IsLocalRing.residue_eq_zero_iff]
      exact IsLocalization.AtPrime.to_map_mem_maximal_iff Sq q a
    have hφker : ∀ a ∈ q, φ a = 0 := fun a ha => (hφmem a).mpr ha
    have hinj : Function.Injective (Ideal.Quotient.liftₐ q φ hφker) := by
      rw [injective_iff_map_eq_zero]
      intro x hx
      obtain ⟨r, rfl⟩ := Ideal.Quotient.mk_surjective x
      rw [Ideal.Quotient.liftₐ_apply, Ideal.Quotient.lift_mk] at hx
      rw [Ideal.Quotient.eq_zero_iff_mem]
      exact (hφmem r).mp hx
    exact trdeg_le_of_injective _ hinj
  -- Lemma C at the residue field.
  have hC : Module.rank (ResidueField Sq) (Ω[ResidueField Sq⁄k]) =
      Algebra.trdeg k (ResidueField Sq) :=
    Algebra.rank_kaehlerDifferential_eq_trdeg k (ResidueField Sq)
  -- Ω[κ⁄k] is finite-dimensional (surjective image of the f.d. middle term).
  haveI : Module.Finite Sq (Ω[Sq⁄k]) := by
    rw [← Module.rank_lt_aleph0_iff, hrank]
    exact Cardinal.natCast_lt_aleph0
  haveI : Module.Finite (ResidueField Sq) (Ω[ResidueField Sq⁄k]) :=
    Module.Finite.of_surjective (mapBaseChange k Sq (ResidueField Sq))
      (KaehlerDifferential.mapBaseChange_surjective k Sq (ResidueField Sq) hResSurj)
  -- `d ≤ dim_κ Ω[κ⁄k]`.
  have hdfin : (d : ℕ∞) ≤
      (Module.finrank (ResidueField Sq) (Ω[ResidueField Sq⁄k]) : ℕ∞) := by
    have hcard : (d : Cardinal) ≤
        Module.rank (ResidueField Sq) (Ω[ResidueField Sq⁄k]) := by
      rw [hC]
      exact le_trans hd hmono
    rw [← Module.finrank_eq_rank] at hcard
    exact_mod_cast hcard
  -- Conclude via the cotangent criterion.
  apply IsRegularLocalRing.of_finrank_cotangentSpace_le_ringKrullDim
  rw [IsLocalization.AtPrime.ringKrullDim_eq_height q Sq]
  have hfinal : (Module.finrank (ResidueField Sq) (CotangentSpace Sq) : ℕ∞) ≤ q.height := by
    refine (ENat.add_le_add_iff_right
      (k := (Module.finrank (ResidueField Sq) (Ω[ResidueField Sq⁄k]) : ℕ∞))
      (by simp)).mp ?_
    calc (Module.finrank (ResidueField Sq) (CotangentSpace Sq) : ℕ∞)
        + (Module.finrank (ResidueField Sq) (Ω[ResidueField Sq⁄k]) : ℕ∞)
        = (n : ℕ∞) := by exact_mod_cast hD
      _ ≤ q.height + d := hB
      _ ≤ q.height + (Module.finrank (ResidueField Sq) (Ω[ResidueField Sq⁄k]) : ℕ∞) := by
          gcongr
  exact_mod_cast hfinal

end Main
