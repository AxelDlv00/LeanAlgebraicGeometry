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
2. The kernel of `free I ⟶ F` is again quasi-coherent on `Spec R`, hence again globally
   generated by step 1; this yields `F.Presentation`.
3. Feed that presentation to `isIso_fromTildeΓ_of_presentation`, register the resulting
   `IsIso F.fromTildeΓ` as the instance above.

Step 1 is the load-bearing ~few-hundred-LOC affine equivalence and is the single genuine
mathematical blocker.  Everything downstream of it (steps 2–3 and the upgrade of
`qcoh_iso_tilde_sections`) is mechanical.
-/

end AlgebraicGeometry
