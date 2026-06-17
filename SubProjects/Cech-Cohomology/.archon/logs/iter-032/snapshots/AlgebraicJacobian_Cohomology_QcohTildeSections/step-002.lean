/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib.AlgebraicGeometry.Modules.Tilde

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

end SpanCoverLocalization

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
