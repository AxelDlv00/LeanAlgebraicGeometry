/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib.AlgebraicGeometry.Modules.Tilde
import Mathlib.RingTheory.LocalProperties.Exactness
import Mathlib.Topology.Sheaves.SheafCondition.UniqueGluing
import AlgebraicJacobian.Cohomology.QcohRestrictBasicOpen

/-!
# Quasi-coherent sheaves on an affine are sections-tilde (Stacks 01HV/01I8)

Project-local: the affine quasi-coherent structure theorem.  For an `𝒪_X`-module `F`
on an affine `X = Spec R`, with `M = Γ(X, F)`, there is a natural isomorphism
`F ≅ M^~`, under which `Γ(D(f), F) = M_f`.

## The Mathlib gradient

Mathlib's `AlgebraicGeometry.Modules.Tilde` development provides:

* `Scheme.Modules.fromTildeΓ F : tilde (Γ F) ⟶ F` — the counit of the
  tilde ⊣ global-sections adjunction;
* `isIso_fromTildeΓ_iff : IsIso F.fromTildeΓ ↔ (tilde.functor R).essImage F`;
* `isIso_fromTildeΓ_of_presentation F (P : F.Presentation) : IsIso F.fromTildeΓ` —
  the counit is an isomorphism whenever `F` admits a **global** presentation
  (a global generating family together with a global generating family of relations).

The genuine remaining gap — **Stacks Tag 01I8**, the affine equivalence
`QCoh(Spec R) ≃ Mod R` — is the implication

  `[IsQuasicoherent F]  ⟹  IsIso F.fromTildeΓ`   (on the affine `Spec R`).

`IsQuasicoherent F` only supplies *local* presentation data on a cover
(`QuasicoherentData`); turning that into a *global* presentation on the affine base
(or directly into membership of the essential image of `tilde`) is the content of the
affine equivalence and is not yet in Mathlib.  See the `## Handoff` section at the
bottom of this file for the precise decomposition.

This file therefore delivers the structure theorem **conditioned on the counit being
an isomorphism** (`qcoh_iso_tilde_sections`), and a ready-to-use **presentation form**
(`qcoh_iso_tilde_sections_of_presentation`) that discharges that condition via the
Mathlib presentation lemma.  Once the 01I8 instance
`[IsQuasicoherent F] → IsIso F.fromTildeΓ` lands, the conditional form upgrades to the
unconditional quasi-coherent statement with no further work.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

variable {R : CommRingCat.{u}}

/-! ## Project-local Mathlib supplement — affine quasi-coherent structure theorem -/

/-- **Affine structure theorem, conditional form (Stacks 01HV).**  If the tilde–Γ counit
`tilde (Γ F) ⟶ F` of an `𝒪_{Spec R}`-module `F` is an isomorphism — which holds for every
quasi-coherent `F` (the 01I8 globalisation `[IsQuasicoherent F] → IsIso F.fromTildeΓ` is the
sole remaining gap; see `qcoh_iso_tilde_sections_of_presentation` for the presentation-based
discharge) — then `F` is isomorphic to the sheaf associated with its module of global
sections `M = Γ(Spec R, F)`.  Project-local because Mathlib exposes only the counit and the
`IsIso`-criterion, not this packaged `F ≅ M^~` form. -/
noncomputable def qcoh_iso_tilde_sections (F : (Spec R).Modules) [IsIso F.fromTildeΓ] :
    F ≅ tilde (moduleSpecΓFunctor.obj F) :=
  (asIso F.fromTildeΓ).symm

/-- **Affine structure theorem, presentation form (Stacks 01HV).**  An `𝒪_{Spec R}`-module
`F` that admits a *global* presentation (`F.Presentation`) is isomorphic to the sheaf
associated with its module of global sections `M = Γ(Spec R, F)`.  This discharges the
`IsIso F.fromTildeΓ` hypothesis of `qcoh_iso_tilde_sections` via Mathlib's
`isIso_fromTildeΓ_of_presentation`.  Project-local for the same packaging reason. -/
noncomputable def qcoh_iso_tilde_sections_of_presentation (F : (Spec R).Modules)
    (P : F.Presentation) : F ≅ tilde (moduleSpecΓFunctor.obj F) :=
  haveI := isIso_fromTildeΓ_of_presentation F P
  (asIso F.fromTildeΓ).symm

/-- The hom of `qcoh_iso_tilde_sections` is the inverse of the tilde–Γ counit. -/
@[simp]
lemma qcoh_iso_tilde_sections_hom (F : (Spec R).Modules) [IsIso F.fromTildeΓ] :
    (qcoh_iso_tilde_sections F).hom = inv F.fromTildeΓ :=
  rfl

/-- The inverse of `qcoh_iso_tilde_sections` is the tilde–Γ counit `tilde (Γ F) ⟶ F`. -/
@[simp]
lemma qcoh_iso_tilde_sections_inv (F : (Spec R).Modules) [IsIso F.fromTildeΓ] :
    (qcoh_iso_tilde_sections F).inv = F.fromTildeΓ :=
  rfl

/-! ### Reduction to global generation (Stacks 01I8, steps 2–3)

The unconditional quasi-coherent instance `[IsQuasicoherent F] → IsIso F.fromTildeΓ` is, by the
three-step 01I8 decomposition (`rem:o1i8_decomposition`), reduced to producing two *global*
generating families: one for `F` itself and one for the kernel of the resulting epimorphism.  The
declarations below formalise steps (2)–(3) — assembling those two families into a global
presentation and feeding it to Mathlib's `isIso_fromTildeΓ_of_presentation` — turning what were
prose steps in the Handoff into axiom-clean Lean.  The single remaining mathematical input is the
affine global-generation theorem (step (1)), which supplies the two `GeneratingSections`.
-/

/-- A finite-free / free `𝒪_{Spec R}`-module is quasi-coherent: it is the tilde of `ι →₀ R`
(`tildeFinsupp`), and quasi-coherence is closed under isomorphism.  Project-local supplement; used
to recognise the kernel-side coefficient sheaf of the 01I8 presentation route as quasi-coherent. -/
instance free_isQuasicoherent (ι : Type u) :
    (SheafOfModules.free.{u} (R := (Spec R).ringCatSheaf) ι).IsQuasicoherent :=
  (SheafOfModules.isQuasicoherent.{u} (Spec R).ringCatSheaf).prop_of_iso
    (tildeFinsupp (R := R) ι) inferInstance

/-- **01I8 steps (2)–(3), packaged.**  If an `𝒪_{Spec R}`-module `F` is globally generated
(`σ : F.GeneratingSections`, a global epimorphism `free σ.I ⟶ F`) and the kernel of that
epimorphism is itself globally generated (`τ : (kernel σ.π).GeneratingSections`), then the
tilde–Γ counit `tilde (Γ F) ⟶ F` is an isomorphism.  This bundles the two generating families
into a global `F.Presentation` and feeds it to Mathlib's `isIso_fromTildeΓ_of_presentation`; it is
the formal content of steps (2)–(3) of the 01I8 decomposition.  The single remaining mathematical
input is the affine global-generation theorem (step (1)) producing `σ` and `τ` for a quasi-coherent
`F`.  Project-local because it repackages the Mathlib presentation criterion in the
two-generating-families form the 01I8 route consumes. -/
lemma isIso_fromTildeΓ_of_genSections (F : (Spec R).Modules)
    (σ : F.GeneratingSections) (τ : (kernel σ.π).GeneratingSections) :
    IsIso F.fromTildeΓ := by
  have P : F.Presentation := { generators := σ, relations := τ }
  exact isIso_fromTildeΓ_of_presentation F P

/-- **Affine structure theorem from global generation (Stacks 01HV/01I8).**  An `𝒪_{Spec R}`-module
`F` that is globally generated (`σ`) together with a globally generated kernel of the generating
epimorphism (`τ`) is isomorphic to the sheaf associated with its module of global sections
`M = Γ(Spec R, F)`.  Discharges the `IsIso F.fromTildeΓ` hypothesis of `qcoh_iso_tilde_sections`
via `isIso_fromTildeΓ_of_genSections`.  Project-local for the same packaging reason; once the
affine global-generation theorem supplies `σ`/`τ` for quasi-coherent `F` the named
`qcoh_iso_tilde_sections` upgrades to the unconditional statement. -/
noncomputable def qcoh_iso_tilde_sections_of_genSections (F : (Spec R).Modules)
    (σ : F.GeneratingSections) (τ : (kernel σ.π).GeneratingSections) :
    F ≅ tilde (moduleSpecΓFunctor.obj F) :=
  haveI := isIso_fromTildeΓ_of_genSections F σ τ
  (asIso F.fromTildeΓ).symm

/-! ### Route P, step 0 — finite trivialising standard cover

The pure-topology brick of the global-generation route: any open cover of an affine
`Spec R` refines to a *finite* cover by basic opens, each contained in a cover member,
with the defining elements generating the unit ideal.  This is the common prerequisite
of the localisation-of-sections and global-generation steps. -/

/-- **Finite basic-open refinement of a cover of `Spec R` (Stacks 01I8, topology brick).**
Given a family of opens `U : ι → (Spec R).Opens` covering the whole space
(`⨆ i, U i = ⊤`), there are finitely many elements `f : Fin n → R` and indices
`φ : Fin n → ι` such that each basic open `D(f j)` lies inside `U (φ j)` and the `f j`
generate the unit ideal (equivalently the `D(f j)` already cover `Spec R`).  Project-local
because it packages the basis-refinement + quasicompactness of `Spec R` in the exact form
the Route-P localisation/global-generation lanes consume. -/
lemma exists_finite_basicOpen_subcover {ι : Type*} (U : ι → (Spec R).Opens)
    (hU : ⨆ i, U i = ⊤) :
    ∃ (n : ℕ) (f : Fin n → R) (φ : Fin n → ι),
      (∀ j, PrimeSpectrum.basicOpen (f j) ≤ U (φ j)) ∧ Ideal.span (Set.range f) = ⊤ := by
  classical
  -- pointwise: each `x` lies in a basic open contained in some cover member
  have hpt : ∀ x : PrimeSpectrum R, ∃ (g : R) (i : ι),
      x ∈ PrimeSpectrum.basicOpen g ∧ PrimeSpectrum.basicOpen g ≤ U i := by
    intro x
    have hxtop : x ∈ (⊤ : (Spec R).Opens) := trivial
    rw [← hU] at hxtop
    obtain ⟨i, hi⟩ := TopologicalSpace.Opens.mem_iSup.1 hxtop
    obtain ⟨V, hV, hxV, hVU⟩ :=
      (TopologicalSpace.Opens.isBasis_iff_nbhd.1
        (PrimeSpectrum.isBasis_basic_opens (R := R))) hi
    obtain ⟨g, rfl⟩ := hV
    exact ⟨g, i, hxV, hVU⟩
  choose g φ' hxg hgU using hpt
  -- quasicompactness: extract a finite subcover of the pointwise basic opens
  have hcover : (Set.univ : Set (PrimeSpectrum R)) ⊆
      ⋃ x, (PrimeSpectrum.basicOpen (g x) : Set (PrimeSpectrum R)) :=
    fun x _ => Set.mem_iUnion.2 ⟨x, hxg x⟩
  obtain ⟨t, ht⟩ := isCompact_univ.elim_finite_subcover
    (fun x => (PrimeSpectrum.basicOpen (g x) : Set (PrimeSpectrum R)))
    (fun x => (PrimeSpectrum.basicOpen (g x)).isOpen) hcover
  set e := t.equivFin with he
  refine ⟨t.card, fun j => g (e.symm j).val, fun j => φ' (e.symm j).val, fun j => hgU _, ?_⟩
  -- the chosen finite family of basic opens already covers `Spec R`
  rw [← PrimeSpectrum.iSup_basicOpen_eq_top_iff, eq_top_iff]
  intro x _
  rw [TopologicalSpace.Opens.mem_iSup]
  have hxu := ht (Set.mem_univ x)
  rw [Set.mem_iUnion₂] at hxu
  obtain ⟨y, hy, hxy⟩ := hxu
  refine ⟨e ⟨y, hy⟩, ?_⟩
  rw [Equiv.symm_apply_apply]
  exact hxy

/-! ## Project-local Mathlib supplement — `IsLocalizedModule` is local on a finite spanning cover

`isLocalizedModule_of_span_cover` (Stacks 01I8, P1b): the pure commutative-algebra patching
primitive feeding the localisation-of-sections step.  If an `R`-linear map `g : M → N` becomes a
localisation at the powers of `f` after localising at the powers of each member `s j` of a finite
unit-ideal-spanning family, then `g` is itself a localisation at the powers of `f`.  Proved directly
from the three defining clauses of `IsLocalizedModule` by descent along the spanning cover (the
partition-of-unity argument of the blueprint).  Project-local: Mathlib has the analogous
`Module.Finite`/`Module.FinitePresentation` span-descent lemmas but not this one for the
`IsLocalizedModule` predicate itself.
-/

section SpanCoverLocalization

variable {R : Type*} [CommRing R] {M N : Type*}
  [AddCommGroup M] [Module R M] [AddCommGroup N] [Module R N]

/-- Partition of unity for a finite unit-ideal-spanning family raised to a uniform power:
if `s : Fin n → R` spans the unit ideal then so do the `A`-th powers, giving coefficients
`c` with `∑ j, c j * (s j) ^ A = 1`.  Project-local helper for `isLocalizedModule_of_span_cover`. -/
private lemma exists_sum_pow_eq_one {n : ℕ} (s : Fin n → R)
    (hs : Ideal.span (Set.range s) = ⊤) (A : ℕ) :
    ∃ c : Fin n → R, ∑ j, c j * (s j) ^ A = 1 := by
  have hspan : Ideal.span (Set.range fun j => (s j) ^ A) = ⊤ := by
    have h := Ideal.span_pow_eq_top (Set.range s) hs A
    rwa [← Set.range_comp] at h
  have h1 : (1 : R) ∈ Ideal.span (Set.range fun j => (s j) ^ A) := by rw [hspan]; trivial
  rw [Ideal.mem_span_range_iff_exists_fun] at h1
  exact h1

/-- Span-cover descent for membership in the range of a linear map: if `(s j) ^ A • w` lies in the
range of `g` for every member of a unit-ideal-spanning family, then `w` itself does.  Project-local
helper for the surjectivity clause of `isLocalizedModule_of_span_cover`. -/
private lemma mem_range_of_span_pow {n : ℕ} (s : Fin n → R)
    (hs : Ideal.span (Set.range s) = ⊤) (g : M →ₗ[R] N) (A : ℕ) (w : N)
    (hj : ∀ j, ∃ m : M, (s j) ^ A • w = g m) : ∃ m : M, w = g m := by
  obtain ⟨c, hc⟩ := exists_sum_pow_eq_one s hs A
  choose m hm using hj
  refine ⟨∑ j, c j • m j, ?_⟩
  rw [map_sum]
  calc w = (∑ j, c j * (s j) ^ A) • w := by rw [hc, one_smul]
    _ = ∑ j, (c j * (s j) ^ A) • w := by rw [Finset.sum_smul]
    _ = ∑ j, c j • ((s j) ^ A • w) := by simp_rw [mul_smul]
    _ = ∑ j, c j • g (m j) := by simp_rw [hm]
    _ = ∑ j, g (c j • m j) := by simp_rw [map_smul]

/-- Span-cover descent for vanishing: if `(s j) ^ A • w = 0` for every member of a
unit-ideal-spanning family, then `w = 0`.  Project-local helper for the equaliser clause of
`isLocalizedModule_of_span_cover`. -/
private lemma eq_zero_of_span_pow {n : ℕ} (s : Fin n → R)
    (hs : Ideal.span (Set.range s) = ⊤) (A : ℕ) (w : N)
    (hj : ∀ j, (s j) ^ A • w = 0) : w = 0 := by
  obtain ⟨c, hc⟩ := exists_sum_pow_eq_one s hs A
  calc w = (∑ j, c j * (s j) ^ A) • w := by rw [hc, one_smul]
    _ = ∑ j, c j • ((s j) ^ A • w) := by rw [Finset.sum_smul]; simp_rw [mul_smul]
    _ = 0 := by simp_rw [hj, smul_zero, Finset.sum_const_zero]

/-- Localising the multiplication-by-`c` endomorphism of `N` at `S` is multiplication by `c` on the
localised module (as underlying functions).  Project-local helper for the `map_units` clause of
`isLocalizedModule_of_span_cover`. -/
private lemma map_smul_endFun (S : Submonoid R) (c : R) :
    ⇑(LocalizedModule.map S (algebraMap R (Module.End R N) c))
      = ⇑(algebraMap R (Module.End R (LocalizedModule S N)) c) := by
  funext x
  induction x using LocalizedModule.induction_on with
  | _ m t =>
    rw [LocalizedModule.map_mk]
    simp [Module.algebraMap_end_apply, LocalizedModule.smul'_mk]

/-- Arithmetic of "bumping" two scalar powers up to uniform exponents.  Project-local helper for the
surjectivity/equaliser clauses of `isLocalizedModule_of_span_cover`. -/
private lemma bump_eq {P : Type*} [AddCommGroup P] [Module R P] (c d : R) (y : P)
    {a k A K : ℕ} (ha : a ≤ A) (hk : k ≤ K) :
    c ^ A • d ^ K • y = c ^ (A - a) • d ^ (K - k) • (c ^ a • d ^ k • y) := by
  simp only [smul_smul]
  congr 1
  have hc : c ^ A = c ^ (A - a) * c ^ a := by rw [← pow_add, Nat.sub_add_cancel ha]
  have hd : d ^ K = d ^ (K - k) * d ^ k := by rw [← pow_add, Nat.sub_add_cancel hk]
  rw [hc, hd]; ring

/-- Per-cover-member surjectivity datum: from the hypothesis that the `(s j)`-localised map is a
localisation at the powers of `f`, every `y : N` is hit by `g` up to a power of `s j` and a power of
`f`.  Project-local helper for the surjectivity clause of `isLocalizedModule_of_span_cover`. -/
private lemma per_j_surj (g : M →ₗ[R] N) (f : R) (c : R)
    (hj : IsLocalizedModule (Submonoid.powers f)
      (IsLocalizedModule.map (Submonoid.powers c)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) M)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) N) g))
    (y : N) : ∃ (a k : ℕ) (m : M), c ^ a • f ^ k • y = g m := by
  haveI := hj
  obtain ⟨p, hxj⟩ := IsLocalizedModule.surj (Submonoid.powers f)
      (IsLocalizedModule.map (Submonoid.powers c)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) M)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) N) g)
      (LocalizedModule.mk y 1)
  obtain ⟨xj, ⟨tf, kk, (rfl : f ^ kk = tf)⟩⟩ := p
  rw [Submonoid.smul_def, LocalizedModule.smul'_mk] at hxj
  revert hxj
  induction xj using LocalizedModule.induction_on with
  | _ m u =>
    intro hxj
    rw [IsLocalizedModule.map_LocalizedModules] at hxj
    obtain ⟨⟨u', uu, (rfl : c ^ uu = u')⟩, hu'⟩ := (LocalizedModule.mk_eq).1 hxj
    obtain ⟨u2, vv, (rfl : c ^ vv = u2)⟩ := u
    simp only [Submonoid.smul_def, one_smul] at hu'
    refine ⟨vv + uu, kk, c ^ uu • m, ?_⟩
    rw [map_smul]
    rw [show c ^ (vv + uu) • f ^ kk • y = c ^ uu • c ^ vv • (f ^ kk • y) by
          rw [pow_add]; simp only [smul_smul]; ring_nf]
    exact hu'

/-- Per-cover-member equaliser datum: from the hypothesis that the `(s j)`-localised map is a
localisation at the powers of `f`, any `z` with `g z = 0` is annihilated by a power of `s j` times a
power of `f`.  Project-local helper for the equaliser clause. -/
private lemma per_j_eq (g : M →ₗ[R] N) (f : R) (c : R)
    (hj : IsLocalizedModule (Submonoid.powers f)
      (IsLocalizedModule.map (Submonoid.powers c)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) M)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) N) g))
    (z : M) (hz : g z = 0) : ∃ (a k : ℕ), c ^ a • f ^ k • z = 0 := by
  haveI := hj
  have key : (IsLocalizedModule.map (Submonoid.powers c)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) M)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) N) g) (LocalizedModule.mk z 1)
      = (IsLocalizedModule.map (Submonoid.powers c)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) M)
        (LocalizedModule.mkLinearMap (Submonoid.powers c) N) g) 0 := by
    rw [map_zero, IsLocalizedModule.map_LocalizedModules, hz, LocalizedModule.zero_mk]
  obtain ⟨⟨cc, kk, (rfl : f ^ kk = cc)⟩, hcc⟩ := hj.exists_of_eq key
  rw [Submonoid.smul_def, LocalizedModule.smul'_mk, smul_zero] at hcc
  rw [← LocalizedModule.zero_mk (1 : Submonoid.powers c), LocalizedModule.mk_eq] at hcc
  obtain ⟨⟨u, aa, (rfl : c ^ aa = u)⟩, hu⟩ := hcc
  simp only [Submonoid.smul_def, one_smul, smul_zero] at hu
  exact ⟨aa, kk, hu⟩

/-- **`IsLocalizedModule` is local on a finite spanning cover (Stacks 01I8, P1b).**  If an
`R`-linear map `g : M → N` becomes a localisation at the powers of `f` after localising at the
powers of each member `s j` of a finite family spanning the unit ideal, then `g` is itself a
localisation at the powers of `f`.  Proved by descent of the three defining clauses of
`IsLocalizedModule` along the spanning cover (the partition-of-unity argument).  Project-local:
Mathlib has analogous span-descent lemmas for `Module.Finite`/`Module.FinitePresentation` but not
for the `IsLocalizedModule` predicate itself. -/
theorem isLocalizedModule_of_span_cover
    (g : M →ₗ[R] N) (f : R) {n : ℕ} (s : Fin n → R)
    (hs : Ideal.span (Set.range s) = ⊤)
    (h : ∀ j, IsLocalizedModule (Submonoid.powers f)
      (IsLocalizedModule.map (Submonoid.powers (s j))
        (LocalizedModule.mkLinearMap (Submonoid.powers (s j)) M)
        (LocalizedModule.mkLinearMap (Submonoid.powers (s j)) N) g)) :
    IsLocalizedModule (Submonoid.powers f) g := by
  refine ⟨?_, ?_, ?_⟩
  · -- `f` acts invertibly on `N`
    intro x
    obtain ⟨k, hk⟩ := x.2
    rw [show ((x : R)) = f ^ k from hk.symm, map_pow]
    apply IsUnit.pow
    rw [Module.End.isUnit_iff]
    apply bijective_of_localized_span (Set.range s) hs
    rintro ⟨r, j, rfl⟩
    rw [show ⇑(LocalizedModule.map (Submonoid.powers (s j)) (algebraMap R (Module.End R N) f))
        = ⇑(algebraMap R (Module.End R (LocalizedModule (Submonoid.powers (s j)) N)) f)
        from map_smul_endFun _ _, ← Module.End.isUnit_iff]
    exact (h j).map_units ⟨f, 1, by simp⟩
  · -- every `y : N` is hit by `g` up to a power of `f`
    intro y
    choose a k m hm using fun j => per_j_surj g f (s j) (h j) y
    set K := Finset.univ.sup k
    set A := Finset.univ.sup a
    have hw : ∀ j, ∃ mm : M, (s j) ^ A • (f ^ K • y) = g mm := by
      intro j
      have ha : a j ≤ A := Finset.le_sup (Finset.mem_univ j)
      have hkk : k j ≤ K := Finset.le_sup (Finset.mem_univ j)
      refine ⟨(s j) ^ (A - a j) • f ^ (K - k j) • m j, ?_⟩
      rw [bump_eq (s j) f y ha hkk, hm j, map_smul, map_smul]
    obtain ⟨mm, hmm⟩ := mem_range_of_span_pow s hs g A (f ^ K • y) hw
    exact ⟨⟨mm, ⟨f ^ K, K, rfl⟩⟩, hmm⟩
  · -- `g`-equal elements agree up to a power of `f`
    intro x₁ x₂ he
    have hgz : g (x₁ - x₂) = 0 := by rw [map_sub, he, sub_self]
    choose a k hk using fun j => per_j_eq g f (s j) (h j) (x₁ - x₂) hgz
    set K := Finset.univ.sup k
    set A := Finset.univ.sup a
    have hw : ∀ j, (s j) ^ A • (f ^ K • (x₁ - x₂)) = 0 := by
      intro j
      have ha : a j ≤ A := Finset.le_sup (Finset.mem_univ j)
      have hkk : k j ≤ K := Finset.le_sup (Finset.mem_univ j)
      rw [bump_eq (s j) f (x₁ - x₂) ha hkk, hk j, smul_zero, smul_zero]
    have hzero : f ^ K • (x₁ - x₂) = 0 := eq_zero_of_span_pow s hs A _ hw
    refine ⟨⟨f ^ K, K, rfl⟩, ?_⟩
    rw [← sub_eq_zero, ← smul_sub]
    exact hzero

end SpanCoverLocalization

/-! ## Project-local Mathlib supplement — Route B local model: section restriction localizes

The Route B keystone (`qcoh_section_isLocalizedModule`) asserts that for a *quasi-coherent*
`F` the section-restriction `Γ(Spec R, F) → Γ(D(f), F)` exhibits the target as the localization
of the source at the powers of `f`.  The two declarations here are the **local model** of that
statement — the case where `F` is already (isomorphic to) the associated sheaf `M^~` of an
`R`-module.  This is the load-bearing brick the keystone descends over its trivialising cover: on
each piece `D(g_j)` of a finite standard cover, the quasi-coherent `F` becomes `tilde`-of-a-module
(via the local presentation and right-exactness of `tilde`), and the section-restriction there is an
`IsLocalizedModule` precisely by these lemmas.

`tilde_section_isLocalizedModule` is the pure `tilde` case; the `[IsIso F.fromTildeΓ]` corollary
`section_isLocalizedModule_of_isIso_fromTildeΓ` transports it across the canonical isomorphism
`F ≅ Γ(F)^~`.  Project-local because Mathlib states `toOpen` (the localization of `M` itself into
`Γ(D(f), M^~)`) but not the *section-restriction* form `Γ(⊤, F) → Γ(D(f), F)` that the keystone and
the `fromTildeΓ` counit consume. -/

section LocalModel

/-- **Route B local model (pure `tilde` case).**  For an `R`-module `M`, the section-restriction map
`Γ(Spec R, M^~) → Γ(D(f), M^~)` of the associated sheaf exhibits its target as the localization of
its source at the powers of `f`: `IsLocalizedModule (powers f)` of that restriction.  This is the
section-restriction form of Mathlib's `tilde.toOpen` localization instance (which localizes `M`
itself, not the global sections `Γ(⊤, M^~)`), obtained by transporting along the global-sections
isomorphism `tilde.isoTop`.  Project-local; the load-bearing local model of the keystone
`qcoh_section_isLocalizedModule`. -/
lemma tilde_section_isLocalizedModule (M : ModuleCat.{u} R) (f : R) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj (tilde M)).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom := by
  have key := tilde.toOpen_res M ⊤ (PrimeSpectrum.basicOpen f) (homOfLE le_top)
  -- `toOpen M ⊤` is an isomorphism; view it as a linear equivalence `eTop : M ≃ₗ Γ(⊤, M^~)`
  set eTop : M ≃ₗ[R] _ := (asIso (tilde.toOpen M ⊤)).toLinearEquiv with heTop
  -- the section-restriction equals `toOpen (D f) ∘ eTop⁻¹` as linear maps
  have hmap : ((modulesSpecToSheaf.obj (tilde M)).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom
      = (tilde.toOpen M (PrimeSpectrum.basicOpen f)).hom ∘ₗ eTop.symm.toLinearMap := by
    apply LinearMap.ext
    intro x
    have hk := congrArg (fun (m : M ⟶ _) => m.hom (eTop.symm x)) key
    simp only [ModuleCat.hom_comp, LinearMap.comp_apply] at hk
    have heq : ⇑eTop = ⇑(tilde.toOpen M ⊤).hom := by rw [heTop]; ext y; simp
    have htop : (tilde.toOpen M ⊤).hom (eTop.symm x) = x := by
      rw [← heq]; exact eTop.apply_symm_apply x
    conv_lhs => rw [← htop]
    simpa using hk
  rw [hmap]
  exact IsLocalizedModule.of_linearEquiv_right (Submonoid.powers f)
    (tilde.toOpen M (PrimeSpectrum.basicOpen f)).hom eTop.symm

/-- **Route B local model (counit-isomorphism case).**  If the tilde–Γ counit of an
`𝒪_{Spec R}`-module `F` is an isomorphism (equivalently `F ≅ M^~` for `M = Γ(Spec R, F)`), then the
section-restriction `Γ(Spec R, F) → Γ(D(f), F)` exhibits its target as the localization of its
source at the powers of `f`.  Obtained by transporting `tilde_section_isLocalizedModule` along the
isomorphism `F ≅ Γ(F)^~` (naturality of the section restriction under `modulesSpecToSheaf`).
Project-local; this is the per-piece engine of the keystone `qcoh_section_isLocalizedModule`: on
each `D(g_j)` of a trivialising cover the quasi-coherent `F` has an isomorphic counit (it carries a
global presentation there), so this lemma supplies the `IsLocalizedModule` datum the span-cover
descent consumes. -/
lemma section_isLocalizedModule_of_isIso_fromTildeΓ (F : (Spec R).Modules)
    [IsIso F.fromTildeΓ] (f : R) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj F).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom := by
  set M := moduleSpecΓFunctor.obj F with hM
  set α : F ≅ tilde M := qcoh_iso_tilde_sections F with hα
  -- the underlying presheaf morphism of `modulesSpecToSheaf.map α.hom`
  set β := (TopCat.Sheaf.forget (ModuleCat R) (Spec R)).map (modulesSpecToSheaf.map α.hom) with hβ
  haveI : IsIso (modulesSpecToSheaf.map α.hom) := inferInstance
  haveI : IsIso β := inferInstance
  haveI : IsIso (β.app (Opposite.op (⊤ : (Spec R).Opens))) :=
    CategoryTheory.NatIso.isIso_app_of_isIso β _
  haveI : IsIso (β.app (Opposite.op (PrimeSpectrum.basicOpen f))) :=
    CategoryTheory.NatIso.isIso_app_of_isIso β _
  -- the two `β`-components as linear equivalences
  set eTop : _ ≃ₗ[R] _ :=
    (asIso (β.app (Opposite.op (⊤ : (Spec R).Opens)))).toLinearEquiv with heTop
  set eDf : _ ≃ₗ[R] _ :=
    (asIso (β.app (Opposite.op (PrimeSpectrum.basicOpen f)))).toLinearEquiv with heDf
  -- the `tilde M` restriction localizes (the local model), conjugate it by `eTop` on the source
  haveI hbrick := tilde_section_isLocalizedModule M f
  set φ : _ →ₗ[R] _ := ((modulesSpecToSheaf.obj (tilde M)).presheaf.map
      (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom ∘ₗ eTop.toLinearMap with hφ
  haveI hφloc : IsLocalizedModule (Submonoid.powers f) φ := by
    rw [hφ]
    exact IsLocalizedModule.of_linearEquiv_right (Submonoid.powers f)
      ((modulesSpecToSheaf.obj (tilde M)).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom eTop
  -- naturality of `β`, read at `.hom` level: `eDf ∘ ρ_F = ρ_{tilde M} ∘ eTop = φ`
  have hnat := β.naturality (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op
  have hnat' : ∀ x, eDf (((modulesSpecToSheaf.obj F).presheaf.map
      (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom x) = φ x := by
    intro x
    have hx := LinearMap.congr_fun (congrArg ModuleCat.Hom.hom hnat) x
    simp only [ModuleCat.hom_comp, LinearMap.comp_apply] at hx
    exact hx
  -- so `ρ_F = eDf⁻¹ ∘ φ`, hence localizes (post-compose a localization with a linear equiv)
  have hF : ((modulesSpecToSheaf.obj F).presheaf.map
      (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom
      = eDf.symm.toLinearMap ∘ₗ φ := by
    apply LinearMap.ext
    intro x
    change _ = eDf.symm (φ x)
    rw [← hnat' x, eDf.symm_apply_apply]
  rw [hF]
  exact IsLocalizedModule.of_linearEquiv (Submonoid.powers f) φ eDf.symm

/-- **Route B keystone, globally-presented case.**  If an `𝒪_{Spec R}`-module `F` admits a *global*
presentation (`F.Presentation`), then the section-restriction `Γ(Spec R, F) → Γ(D(f), F)` exhibits
its target as the localization of its source at the powers of `f`.  This is the keystone
`qcoh_section_isLocalizedModule` for the special — but key — case of a global presentation: it is
exactly the situation on each affine piece `D(g_j) ≅ Spec R_{g_j}` of a trivialising cover of a
quasi-coherent `F`, where the local quasi-coherence datum supplies a global presentation.  Proved by
discharging `[IsIso F.fromTildeΓ]` via Mathlib's `isIso_fromTildeΓ_of_presentation` and applying
`section_isLocalizedModule_of_isIso_fromTildeΓ`.  Project-local; the unconditional quasi-coherent
keystone descends from this case over the cover via `isLocalizedModule_of_span_cover`. -/
lemma section_isLocalizedModule_of_presentation (F : (Spec R).Modules)
    (P : F.Presentation) (f : R) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj F).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom := by
  haveI := isIso_fromTildeΓ_of_presentation F P
  exact section_isLocalizedModule_of_isIso_fromTildeΓ F f

end LocalModel

/-! ## Project-local Mathlib supplement — Route B step B1: finite presentation cover

`qcoh_finite_presentation_cover` (Stacks 01I8, Route B step B1): for a quasi-coherent `F` on
`Spec R`, the local quasi-coherence datum (`QuasicoherentData`) refines to a *finite* standard
cover `D(g_j) ⊆ U_{φ(j)}` with `span{g_j} = ⊤`, each member `U_{φ(j)}` carrying a presentation of
`F.over U_{φ(j)}`.  This is the entry point of the keystone descent: per `g_j` the attached
presentation restricts (B2) and bridges (B3/B4) to a global presentation of the affine restriction,
which the `IsLocalizedModule` local model then consumes.

`coversTop_iSup_eq_top` is the topological translation feeding `exists_finite_basicOpen_subcover`:
the cover-of-terminal-object condition of a `QuasicoherentData` on the opens-Grothendieck-topology
of a space is the honest `⨆ U_i = ⊤`. -/

section FinitePresentationCover

/-- A family of opens that covers the terminal object of the opens-Grothendieck-topology of a space
has supremum `⊤`.  Project-local: translates the categorical `J.CoversTop` condition carried by a
`QuasicoherentData` into the lattice-theoretic `⨆ = ⊤` that `exists_finite_basicOpen_subcover`
consumes. -/
private lemma coversTop_iSup_eq_top {T : Type*} [TopologicalSpace T] {I : Type*}
    (Y : I → TopologicalSpace.Opens T)
    (hY : (Opens.grothendieckTopology T).CoversTop Y) :
    ⨆ i, Y i = ⊤ := by
  rw [eq_top_iff]
  intro x _
  rw [TopologicalSpace.Opens.mem_iSup]
  obtain ⟨U, f, hf, hU⟩ := hY ⊤ x (TopologicalSpace.Opens.mem_top x)
  obtain ⟨i, ⟨g⟩⟩ := hf
  exact ⟨i, (leOfHom g) hU⟩

/-- **Finite presentation cover from quasi-coherence (Stacks 01I8, Route B step B1).**  For a
quasi-coherent `𝒪_{Spec R}`-module `F`, there is a quasi-coherence datum `q` (a cover `q.X` of
`Spec R` together with a presentation of `F.over (q.X i)` for each `i`) and a *finite* standard
refinement of it: finitely many `g : Fin n → R` with `span (range g) = ⊤` and indices
`φ : Fin n → q.I` such that each basic open `D(g j)` lies inside the cover member `q.X (φ j)`.  The
presentation of `F.over (q.X (φ j))` carried by `q` is what steps B2–B4 restrict to `D(g j)`.
Project-local: packages Mathlib's `QuasicoherentData` (local generation) with the affine finite
basic-open refinement (`exists_finite_basicOpen_subcover`) in the exact form the Route B keystone
descent consumes. -/
lemma qcoh_finite_presentation_cover (F : (Spec R).Modules)
    [hF : F.IsQuasicoherent] :
    ∃ (q : SheafOfModules.QuasicoherentData.{u, u, u, u} F)
      (n : ℕ) (g : Fin n → R) (φ : Fin n → q.I),
      (∀ j, PrimeSpectrum.basicOpen (g j) ≤ q.X (φ j)) ∧ Ideal.span (Set.range g) = ⊤ := by
  obtain ⟨q⟩ := hF.nonempty_quasicoherentData
  have htop : ⨆ i, q.X i = ⊤ := coversTop_iSup_eq_top q.X q.coversTop
  obtain ⟨n, g, φ, hgU, hspan⟩ := exists_finite_basicOpen_subcover q.X htop
  exact ⟨q, n, g, φ, hgU, hspan⟩

end FinitePresentationCover

/-! ## Project-local Mathlib supplement — Route B keystone: degree-0/1 sheaf-axiom equalizer

`qcoh_section_equalizer` (Stacks 01HV(4)/01I8, sheaf-axiom equalizer route) is the degree-`0/1`
{\v C}ech equalizer of a sheaf of modules `F` on `Spec R`, read off the sheaf condition for a finite
(in fact arbitrary) family `U` covering an open `W`:
`0 → Γ(W,F) → ∏ⱼ Γ(Uⱼ,F) → ∏ⱼₖ Γ(Uⱼ ⊓ Uₖ,F)` is exact at both non-zero terms.  It is the entry
point of the keystone kernel comparison: instantiated at `W = ⊤` and `W = D(f)` (with `Uⱼ = D(gⱼ)`
resp. `Uⱼ = D(f gⱼ)`) it exhibits `Γ(X,F)` and `Γ(D(f),F)` as the kernels of the two overlap
differentials, which the localisation comparison then matches.  Non-circular: only the sheaf
condition of `F` is used, never a section-localisation identity. -/

section SectionEqualizer

/-- Restriction of a section across a composite inclusion `A ≤ B ≤ C` equals the single restriction
along `A ≤ C` (presheaf functoriality in the thin opens category).  Project-local helper for the
degree-0/1 differential computation of `qcoh_section_equalizer`. -/
private lemma res_trans_apply (P : TopCat.Presheaf (ModuleCat R) (Spec R))
    {A B C : (Spec R).Opens} (h1 : A ≤ B) (h2 : B ≤ C) (s : P.obj (.op C)) :
    (P.map (homOfLE h1).op).hom ((P.map (homOfLE h2).op).hom s)
      = (P.map (homOfLE (h1.trans h2)).op).hom s := by
  rw [← ModuleCat.comp_apply, ← P.map_comp]; rfl

/-- **Degree-0/1 sheaf-axiom equalizer (Stacks 01HV(4)/01I8).**  For a sheaf of `𝒪_{Spec R}`-modules
`F`, an open `W`, and a family `U : ι → Opens` with `U i ≤ W` for all `i` and `W ≤ ⨆ U i`, the
augmented two-term {\v C}ech sequence
`0 → Γ(W,F) →[ρ] ∏ᵢ Γ(U i,F) →[δ] ∏_{i,k} Γ(U i ⊓ U k,F)` is exact: the restriction product `ρ` is
injective and its range is exactly the kernel of the overlap differential `δ` (the difference of the
two restriction-to-overlap maps).  This is the sheaf condition of `F` read in degrees `0` and `1`,
proved from `TopCat.Presheaf.IsSheaf.section_ext` (injectivity) and
`TopCat.Sheaf.existsUnique_gluing'` (gluing of a matching family).  Project-local: Mathlib packages
the sheaf condition as a categorical limit / unique-gluing statement, not in the explicit
`Function.Exact` form on the section modules that the keystone kernel comparison consumes. -/
theorem qcoh_section_equalizer (F : (Spec R).Modules) {ι : Type u}
    (W : (Spec R).Opens) (U : ι → (Spec R).Opens)
    (hUW : ∀ i, U i ≤ W) (hWU : W ≤ iSup U) :
    Function.Injective
        ((LinearMap.pi fun i =>
          ((modulesSpecToSheaf.obj F).presheaf.map (homOfLE (hUW i)).op).hom) :
          (modulesSpecToSheaf.obj F).presheaf.obj (.op W) →ₗ[R]
            (Π i, (modulesSpecToSheaf.obj F).presheaf.obj (.op (U i)))) ∧
      Function.Exact
        ((LinearMap.pi fun i =>
          ((modulesSpecToSheaf.obj F).presheaf.map (homOfLE (hUW i)).op).hom) :
          (modulesSpecToSheaf.obj F).presheaf.obj (.op W) →ₗ[R] _)
        ((LinearMap.pi fun p : ι × ι =>
          ((modulesSpecToSheaf.obj F).presheaf.map
              (homOfLE (inf_le_right : U p.1 ⊓ U p.2 ≤ U p.2)).op).hom ∘ₗ LinearMap.proj p.2
          - ((modulesSpecToSheaf.obj F).presheaf.map
              (homOfLE (inf_le_left : U p.1 ⊓ U p.2 ≤ U p.1)).op).hom ∘ₗ LinearMap.proj p.1)) := by
  set P := modulesSpecToSheaf.obj F with hP
  have hsheaf : P.presheaf.IsSheaf := P.2
  refine ⟨?_, ?_⟩
  · -- injectivity: a section is determined by its restrictions to the cover (`section_ext`)
    intro s s' hss
    have hcomp : ∀ i, (P.presheaf.map (homOfLE (hUW i)).op).hom s
        = (P.presheaf.map (homOfLE (hUW i)).op).hom s' := fun i => congrFun hss i
    apply hsheaf.section_ext
    intro x hx
    have hxU : x ∈ iSup U := hWU hx
    rw [TopologicalSpace.Opens.mem_iSup] at hxU
    obtain ⟨i, hi⟩ := hxU
    exact ⟨U i, hUW i, hi, hcomp i⟩
  · -- exactness at the middle: `δ t = 0 ↔ t` glues to a section over `W`
    intro t
    constructor
    · intro ht
      have hcompat : TopCat.Presheaf.IsCompatible P.presheaf U t := by
        intro i j
        have hij := congrFun ht (i, j)
        simp only [LinearMap.pi_apply, LinearMap.sub_apply, LinearMap.coe_comp, Function.comp_apply,
          LinearMap.proj_apply, Pi.zero_apply, sub_eq_zero] at hij
        exact hij.symm
      obtain ⟨s, hs, _⟩ := P.existsUnique_gluing' U W (fun i => homOfLE (hUW i)) hWU t hcompat
      exact ⟨s, funext fun i => hs i⟩
    · rintro ⟨s, rfl⟩
      funext p
      simp only [LinearMap.pi_apply, LinearMap.sub_apply, LinearMap.coe_comp, Function.comp_apply,
        LinearMap.proj_apply, Pi.zero_apply, sub_eq_zero]
      rw [res_trans_apply, res_trans_apply]

end SectionEqualizer

/-! ## Project-local Mathlib supplement — base-ring descent of `IsLocalizedModule`

`isLocalizedModule_powers_restrictScalars_of_algebraMap` is the converse of Mathlib's
`IsLocalizedModule.of_restrictScalars`: an `A`-linear map that is a localization at the powers of
`algebraMap R A f` (over the larger base `A`) is, viewed `R`-linearly, a localization at the powers
of `f` (over the smaller base `R`).  This is the base-ring descent the Route B keystone needs: the
per-tile localizations produced over `R_g = Localization.Away g` (the tile's base ring) must be read
as `R`-localizations at the powers of `f ∈ R` to feed the kernel comparison, which localizes the
`X`-cover equalizer at `powers f ⊆ R`.  Project-local: Mathlib supplies only the ascent
direction. -/

section BaseRingDescent

/-- **Base-ring descent of `IsLocalizedModule` (converse of `of_restrictScalars`).**  Let `A` be an
`R`-algebra, let `M N` be `A`-modules with the compatible `R`-module structures (`IsScalarTower`),
and let `φ : M →ₗ[A] N`.  If `φ` is a localization at the powers of `algebraMap R A f` *over `A`*,
then its `R`-linear restriction `φ.restrictScalars R` is a localization at the powers of `f` *over
`R`*.  Proved directly from the three defining clauses of `IsLocalizedModule`, using that
`(algebraMap R A f) ^ k • x = f ^ k • x` by the scalar tower.  Project-local: Mathlib has only the
ascent `IsLocalizedModule.of_restrictScalars`, not this descent. -/
lemma isLocalizedModule_powers_restrictScalars_of_algebraMap
    {R A M N : Type*} [CommRing R] [CommRing A] [Algebra R A]
    [AddCommGroup M] [AddCommGroup N] [Module R M] [Module R N] [Module A M] [Module A N]
    [IsScalarTower R A M] [IsScalarTower R A N] (f : R) (φ : M →ₗ[A] N)
    (h : IsLocalizedModule (Submonoid.powers (algebraMap R A f)) φ) :
    IsLocalizedModule (Submonoid.powers f) (φ.restrictScalars R) := by
  have hsmul : ∀ (k : ℕ) (n : N), (algebraMap R A f) ^ k • n = f ^ k • n := by
    intro k n; rw [← map_pow, algebraMap_smul]
  have hsmulM : ∀ (k : ℕ) (m : M), (algebraMap R A f) ^ k • m = f ^ k • m := by
    intro k m; rw [← map_pow, algebraMap_smul]
  refine ⟨?_, ?_, ?_⟩
  · rintro ⟨s, k, rfl⟩
    rw [Module.End.isUnit_iff]
    have hb := h.map_units ⟨(algebraMap R A f) ^ k, k, rfl⟩
    rw [Module.End.isUnit_iff] at hb
    convert hb using 1
    ext n
    simp only [Module.algebraMap_end_apply]
    exact (hsmul k n).symm
  · intro y
    obtain ⟨⟨m, s⟩, hs⟩ := h.surj y
    obtain ⟨k, hk⟩ := s.2
    simp only [] at hk
    refine ⟨⟨m, ⟨f ^ k, k, rfl⟩⟩, ?_⟩
    rw [Submonoid.smul_def] at hs ⊢
    calc f ^ k • y = (algebraMap R A f) ^ k • y := (hsmul k y).symm
      _ = (s : A) • y := by rw [hk]
      _ = φ m := hs
  · intro x₁ x₂ he
    obtain ⟨s, hs⟩ := h.exists_of_eq he
    obtain ⟨k, hk⟩ := s.2
    simp only [] at hk
    refine ⟨⟨f ^ k, k, rfl⟩, ?_⟩
    rw [Submonoid.smul_def] at hs ⊢
    calc f ^ k • x₁ = (algebraMap R A f) ^ k • x₁ := (hsmulM k x₁).symm
      _ = (s : A) • x₁ := by rw [hk]
      _ = (s : A) • x₂ := hs
      _ = (algebraMap R A f) ^ k • x₂ := by rw [hk]
      _ = f ^ k • x₂ := hsmulM k x₂

end BaseRingDescent

/-! ## Project-local Mathlib supplement — Route B keystone: per-tile section localization

`tile_section_localization` (Stacks 01HV(4)/01I8, the last keystone leaf) shows that for a
quasi-coherent `F` on `Spec R` and elements `f g : R` with the tile `F_{(g)}` globally presented, the
section-restriction `Γ(D(g), F) → Γ(D(gf), F)` exhibits its target as the localization of its source
at the powers of `f`.  It is the per-tile localization datum the sheaf-axiom kernel comparison
consumes (`analogies/keystone-descent.md`).

The naive recipe "the section comparison is the `restrict_obj` rfl" is UNSOUND: `restrict_obj` is rfl
only for the local-ring `SheafOfModules` section functor `Γ(M,-)`, whereas the localization lives in
the global-ring functor `modulesSpecToSheaf.obj`, which does NOT commute with restriction
definitionally.  Hence the honest base-ring descent: Sub-lemma A (opens identities,
`tile_image_opens_identities`) + Sub-lemma B (the load-bearing natural section comparison,
`tile_section_comparison`) + the DONE base-ring descent
`isLocalizedModule_powers_restrictScalars_of_algebraMap`. -/

section TileSectionLocalization

open TopologicalSpace

/-- **Sub-lemma A (Stacks 01I8): image opens of the affine tile identification.**  Let `g f : R`, let
`R_g = Localization.Away g`, and let `ι = specAwayToSpec g : Spec R_g ⟶ Spec R` be the localization
morphism identifying `Spec R_g` with `D(g) ⊆ Spec R`.  Then the image opens of the two relevant opens
of `Spec R_g` are `ι ''ᵁ ⊤ = D(g)` and `ι ''ᵁ D(f̄) = D(gf)` (with `f̄ = algebraMap R R_g f`), where
the images are taken in the iterated-restriction form `(specBasicOpen g).ι ''ᵁ ((iso).inv ''ᵁ -)`
matching `modulesRestrictBasicOpen`.  Project-local: the opens bookkeeping that lets the
`R_g`-section localization on the tile be matched against the `R`-section restriction
`Γ(D(g),F) → Γ(D(gf),F)`. -/
lemma tile_image_opens_identities (g f : R) :
    (specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ
        (⊤ : (Spec (.of (Localization.Away g))).Opens)) = specBasicOpen g ∧
      (specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ
        (PrimeSpectrum.basicOpen (algebraMap R (Localization.Away g) f))) = specBasicOpen (g * f) := by
  constructor
  · rw [show ((basicOpenIsoSpecAway g).inv ''ᵁ
        (⊤ : (Spec (.of (Localization.Away g))).Opens)) = ⊤ from by
          rw [Scheme.Hom.image_top_eq_opensRange]; exact Scheme.Hom.opensRange_of_isIso _]
    simp [Scheme.Hom.image_top_eq_opensRange]
  · have hcomp : (specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ
        (PrimeSpectrum.basicOpen (algebraMap R (Localization.Away g) f)))
        = specAwayToSpec g ''ᵁ (PrimeSpectrum.basicOpen (algebraMap R (Localization.Away g) f)) :=
      (Scheme.Hom.comp_image _ _ _).symm
    rw [hcomp]
    apply Opens.ext
    rw [Scheme.Hom.coe_image]
    rw [show ⇑(specAwayToSpec g)
        = PrimeSpectrum.comap (algebraMap R (Localization.Away g)) from by
          rw [specAwayToSpec_eq]; rfl]
    ext x
    simp only [SetLike.mem_coe, PrimeSpectrum.basicOpen_mul, Set.mem_image]
    constructor
    · rintro ⟨p, hp, rfl⟩
      have hpr : p.asIdeal.IsPrime := p.isPrime
      refine ⟨?_, hp⟩
      change (algebraMap R (Localization.Away g)) g ∉ p.asIdeal
      intro hmem
      exact hpr.ne_top (Ideal.eq_top_of_isUnit_mem _ hmem
        (IsLocalization.Away.algebraMap_isUnit g))
    · rintro ⟨hg, hf⟩
      have hx : x ∈ Set.range (PrimeSpectrum.comap (algebraMap R (Localization.Away g))) := by
        rw [PrimeSpectrum.localization_away_comap_range (Localization.Away g) g]; exact hg
      obtain ⟨p, rfl⟩ := hx
      exact ⟨p, hf, rfl⟩

/-- **Per-tile section localization at `f` (Stacks 01HV(4)/01I8) — the last keystone leaf.**  Let `F`
be an `𝒪_{Spec R}`-module, `f g : R`, and suppose the tile `F_{(g)} = modulesRestrictBasicOpen g F`
over `Spec R_g` admits a global presentation `P` (this holds when `D(g)` lies in a presentation
member of a quasi-coherence cover, via `presentationModulesRestrictBasicOpen` (B4)).  Then the
section-restriction `Γ(D(g), F) → Γ(D(gf), F)` exhibits its target as the localization of its source
at the powers of `f`.

The proof is the honest base-ring descent of the blueprint, but it turns out Sub-lemma B (the
`R_g`-section ↔ `R`-section comparison, `lem:tile_section_comparison`) is *definitional*: the carriers
`Γ_{R_g}(V, F_{(g)})` and `Γ_R((D(g) ↪ X) ''ᵁ ((Spec R_g ≅ D(g)) ''ᵁ V), F)` are defeq (iterated
`restrict_obj`), and the scalar coherence `algebraMap R R_g r • x = r • x` across the two module
structures is `rfl`.  Hence: (Step 2) `section_isLocalizedModule_of_presentation` localizes the tile
over `R_g` at `algebraMap f`; (Step 5) `isLocalizedModule_powers_restrictScalars_of_algebraMap`
descends the base ring to `R` — landing, by the definitional comparison, on the `R`-section
restriction between the image opens `W₀, W₁`; (Step 3) `tile_image_opens_identities` rewrites
`W₀ = D(g)`, `W₁ = D(gf)` to match the target.  Project-local: the per-tile localization datum the
sheaf-axiom kernel comparison (`qcoh_section_kernel_comparison`) consumes; non-circular because the
localization happens entirely on the tile (where `F` is `tilde`-of-a-module), never on global
`Γ(X, F)`. -/
lemma tile_section_localization (F : (Spec R).Modules) (g f : R)
    (P : (modulesRestrictBasicOpen g F).Presentation) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj F).presheaf.map
        (homOfLE (PrimeSpectrum.basicOpen_mul_le_left g f)).op).hom := by
  -- Step 2: localize the globally-presented tile over `R_g` at `f̄ = algebraMap f`.
  have hrho' := section_isLocalizedModule_of_presentation (modulesRestrictBasicOpen g F) P
    (algebraMap R (Localization.Away g) f)
  obtain ⟨hW0eq, hW1eq⟩ := tile_image_opens_identities (R := R) g f
  -- Sub-lemma B (definitional): the two tile section modules `Γ_{R_g}(⊤/D(f̄), F_{(g)})` are *defeq*
  -- to the `F`-side `R`-sections `Γ_R(W₀/W₁, F)` over the image opens, and the scalar coherence
  -- `algebraMap R R_g r • x = r • x` is `rfl`.  We hand those `R`-module structures and scalar towers
  -- to the base-ring descent.  (The `R`-module instance is not found by synthesis on its own because
  -- the defeq with the `F`-side requires unfolding `modulesRestrictBasicOpen`.)
  letI iM : Module R ((modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)).presheaf.obj
      (Opposite.op (⊤ : (Spec (.of (Localization.Away g))).Opens))) :=
    inferInstanceAs (Module R ((modulesSpecToSheaf.obj F).presheaf.obj
      (Opposite.op ((specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ
        (⊤ : (Spec (.of (Localization.Away g))).Opens))))))
  letI iN : Module R ((modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)).presheaf.obj
      (Opposite.op (PrimeSpectrum.basicOpen (algebraMap R (Localization.Away g) f)))) :=
    inferInstanceAs (Module R ((modulesSpecToSheaf.obj F).presheaf.obj
      (Opposite.op ((specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ
        (PrimeSpectrum.basicOpen (algebraMap R (Localization.Away g) f)))))))
  letI tM : IsScalarTower R (Localization.Away g)
      ((modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)).presheaf.obj
        (Opposite.op (⊤ : (Spec (.of (Localization.Away g))).Opens))) :=
    IsScalarTower.of_algebraMap_smul (M := (modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)
      ).presheaf.obj (Opposite.op (⊤ : (Spec (.of (Localization.Away g))).Opens)))
      fun _ _ => rfl
  letI tN : IsScalarTower R (Localization.Away g)
      ((modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)).presheaf.obj
        (Opposite.op (PrimeSpectrum.basicOpen (algebraMap R (Localization.Away g) f)))) :=
    IsScalarTower.of_algebraMap_smul (M := (modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)
      ).presheaf.obj (Opposite.op (PrimeSpectrum.basicOpen (algebraMap R (Localization.Away g) f))))
      fun _ _ => rfl
  -- Step 5: descend the base ring `R_g → R`.  By the definitional comparison, `restrictScalars R`
  -- of the tile map IS the `F`-side restriction between the image opens `W₁ ≤ W₀`.
  have hdesc := isLocalizedModule_powers_restrictScalars_of_algebraMap (R := R)
    (A := Localization.Away g) (f := f) _ hrho'
  have hW : (specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ
      (PrimeSpectrum.basicOpen (algebraMap R (Localization.Away g) f)))
      ≤ (specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ
      (⊤ : (Spec (.of (Localization.Away g))).Opens)) := by
    apply Scheme.Hom.image_mono; apply Scheme.Hom.image_mono; exact le_top
  have hdesc2 : IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj F).presheaf.map (homOfLE hW).op).hom := hdesc
  -- Step 3: rewrite the image opens `W₀ = D(g)`, `W₁ = D(gf)` to land on the target map.
  rw [hW0eq, hW1eq] at hdesc2
  exact hdesc2

end TileSectionLocalization

/-! ## Handoff — closing the 01I8 gap

The unconditional quasi-coherent statement

```
theorem qcoh_iso_tilde_sections_qcoh (F : (Spec R).Modules) [IsQuasicoherent F] :
    F ≅ tilde (moduleSpecΓFunctor.obj F)
```

is obtained from `qcoh_iso_tilde_sections` the instant the following instance is available:

```
instance (F : (Spec R).Modules) [IsQuasicoherent F] : IsIso F.fromTildeΓ
```

equivalently (by `isIso_fromTildeΓ_iff`) `(tilde.functor R).essImage F`, equivalently a
**global** `F.Presentation` (fed to `qcoh_iso_tilde_sections_of_presentation`).

The needed Mathlib-gradient sub-steps (all on the affine base `Spec R`):

1. `IsQuasicoherent F` ⟹ `F` is generated by global sections: produce
   `F.GeneratingSections` (a global epi `free I ⟶ F`).  On `Spec R` this is the affine
   global-generation statement (Hartshorne II.5.16 / Stacks 01I8); `QuasicoherentData`
   only gives generation locally on a basic-open cover, which must be globalised using
   `PrimeSpectrum.exists_idempotent_basicOpen_eq_of_isClopen`-style partition-of-unity /
   the compactness of `Spec R` and the localisation-of-sections property of qcoh sheaves.
   **This is the single genuine remaining blocker** (sections of qcoh `F` over `D(f)`
   localise — `Γ(D(f), F) = Γ(X, F)_f`, Stacks 01HV(4)/01I8 — is itself absent from Mathlib:
   `grep` confirms the only `IsQuasicoherent` content in `Mathlib/AlgebraicGeometry/` is
   `Modules/Tilde.lean`, with no localisation-of-sections and no abelian-subcategory closure).
2. The kernel of `free I ⟶ F` is again quasi-coherent on `Spec R` (NB: not yet a Mathlib
   instance — `kernel σ.π` is not automatically qcoh; this needs the qcoh-is-abelian-subcategory
   fact, itself downstream of step 1's local structure), hence again globally generated by
   step 1; this yields the two `GeneratingSections` `σ`, `τ` of `F.Presentation`.
3. Feed those two generating families to `isIso_fromTildeΓ_of_genSections` (below), which
   bundles them into `F.Presentation` and applies Mathlib's `isIso_fromTildeΓ_of_presentation`,
   producing the `IsIso F.fromTildeΓ` instance above.

**Steps 2–3 are now formalised** as the axiom-clean `isIso_fromTildeΓ_of_genSections` and
`qcoh_iso_tilde_sections_of_genSections` (the structure theorem directly from the two generating
families), with `free_isQuasicoherent` recording that free coefficient sheaves are qcoh.  Step 1 —
the load-bearing ~few-hundred-LOC affine global-generation / localisation-of-sections input — is
the single genuine mathematical blocker; once it supplies `σ : F.GeneratingSections` and
`τ : (kernel σ.π).GeneratingSections` for a quasi-coherent `F`, the instance and the unconditional
upgrade of `qcoh_iso_tilde_sections` follow with no further work.
-/

end AlgebraicGeometry
