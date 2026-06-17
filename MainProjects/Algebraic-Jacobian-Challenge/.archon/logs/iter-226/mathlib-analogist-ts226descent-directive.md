## Mode: api-alignment

## Context (self-contained)

Project file: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`. We are building a
commutative group structure on iso-classes of locally-trivial (invertible) `𝒪_X`-modules
(`Pic X`) BY HAND, over the VARYING structure sheaf `𝒪_X` (no fixed-ring `MonoidalCategory`
is available — `CommRing.Pic`/`Skeleton(Module.Invertible R)` is fixed-ring only and not
reusable). Objects: `X.Modules := SheafOfModules X.ringCatSheaf` (sheaves of `𝒪_X`-modules).

The tensor product `tensorObj : X.Modules → X.Modules → X.Modules` is built as
`sheafification ∘ (presheaf ⊗)`. The dual `Scheme.Modules.dual M := sheafification (PresheafOfModules.dual M.val)`
landed axiom-clean this iter. A CLOSED, axiom-clean linchpin exists:
`tensorObj_restrict_iso : (tensorObj M N)|_U ≅ tensorObj (M|_U) (N|_U)` (⊗ commutes with
restriction along an open immersion).

## The strategic question

Two group-law facts remain, and we need your read on the Mathlib-aligned shape to build
them WITHOUT re-entering an abandoned deep gap:

(1) **`exists_tensorObj_inverse`**: for locally-trivial `L`, exhibit `Linv` (= `dual L`) with
    `Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)` (≅ 𝒪_X), GLOBALLY.

(2) **`tensorObj_assoc_iso`**: the associator `(L⊗M)⊗N ≅ L⊗(M⊗N)`, currently built through a
    superseded "left-whiskering preserves the sheafification localizer" lemma
    (`isLocallyInjective_whiskerLeft_of_W`, an OPEN sorry) which requires the
    **stalk-⊗ commutation** `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x` over the varying ring ("d.2") —
    a deep, Mathlib-absent build the project ABANDONED as too large.

The blueprint's INTENDED design (chapter `Picard_TensorObjSubstrate.tex`, §"superseded route",
lines ~440-465, 875-885) is that BOTH should be built by **direct gluing of canonical local
isomorphisms through the closed `tensorObj_restrict_iso`**, making the whiskering/stalk/d.2
apparatus vestigial. The missing technical ingredient blocking this re-route is described in the
project as "**SheafOfModules morphism descent**". We need to know if that ingredient exists in
Mathlib and what its canonical shape is.

## Specific api-alignment questions

A. **Morphism gluing / descent for `SheafOfModules` (or `PresheafOfModules` / `Sheaf J A`).**
   Given an open cover `{Uᵢ}` of `X` and a family of morphisms `fᵢ : M|_{Uᵢ} ⟶ N|_{Uᵢ}`
   (restrictions of `M,N : SheafOfModules X.ringCatSheaf`) that AGREE on overlaps `Uᵢ ∩ Uⱼ`,
   does Mathlib provide a unique glued `f : M ⟶ N` restricting to each `fᵢ`? I.e. is
   "Hom of sheaves of modules is itself a sheaf / determined locally" available as a usable
   API (e.g. via `CategoryTheory.Sheaf` hom being a sheaf, `GrothendieckTopology.Sheaf`
   amalgamation, `PresheafOfModules`/`SheafOfModules` sections-gluing, or a localization/
   restriction-functor adjunction)? Name the exact lemmas/defs and their namespaces.

B. **"Locally-iso ⇒ iso" for sheaf-of-module morphisms.** Given `f : M ⟶ N` of
   `SheafOfModules X.ringCatSheaf` such that each restriction `f|_{Uᵢ}` is an isomorphism for
   an open cover, is `f` an isomorphism? (Needed to conclude the global `tensorObj L (dual L) ≅ 𝒪_X`
   and the associator from local isos.) Mathlib idiom? (`isIso_of_isIso_app`-style? stalkwise?
   `Sheaf`-level local-iso criterion on `Opens X`?)

C. **Internal-hom / dual commuting with restriction along an open immersion.** We have
   `tensorObj_restrict_iso` (⊗ vs restriction). Is there a Mathlib idiom for the Hom/dual
   analogue `(dual M)|_U ≅ dual_{𝒪_U}(M|_U)` (restriction commutes with internal-Hom /
   `Module.Dual` / `ihom`), at the presheaf-of-modules or sheaf level? This backs
   `dual_isLocallyTrivial`.

D. **Confirm or refute the route choice.** Does building (1) and (2) via A+B+C genuinely AVOID
   the stalk-⊗ commutation "d.2" gap? Or does the morphism-descent route secretly re-require a
   stalkwise/filtered-colimit-⊗ statement? If Mathlib's morphism-descent idiom is ALSO absent
   for `SheafOfModules`, say so plainly (that changes our fork).

## Failed / abandoned approaches (do not recommend)
- Sectionwise flatness `∀U, Module.Flat (𝒪_X(U)) (M(U))` — FALSE for line bundles over
  non-affine opens (project's iter-212 finding). Dead end.
- The d.2 stalk-⊗ commutation build itself — abandoned as too large; we are trying to AVOID it.

## What I need back
Per-question: does Mathlib have it (cite exact decls/namespaces), or is it a genuine gap; and a
verdict on question D (does the descent route avoid d.2). Write the persistent analysis to
`analogies/ts226descent.md`.
