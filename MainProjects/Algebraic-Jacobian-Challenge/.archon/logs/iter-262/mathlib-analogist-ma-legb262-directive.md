# mathlib-analogist ma-legb262 — directive

## Mode: api-alignment

## Context

We are building a per-open-set linear iso inside the project file
`AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` (decl
`AlgebraicGeometry.Scheme.Modules.sliceDualTransport`). The construction's
"leg-B" component is a unit ring-iso swap on `ModuleCat`: the canonical
comparison `ε` (lax-monoidal unit) of `ModuleCat.restrictScalars` along a
bijective ring hom, inverted, to send `(restrictScalars φ).obj (𝟙_)` back to
`𝟙_`. Two concrete frictions block the intended term
`CategoryTheory.inv (CategoryTheory.Functor.LaxMonoidal.ε (ModuleCat.restrictScalars φ.hom))`.

I need Mathlib-idiom guidance on BOTH frictions. This is an alignment question:
does Mathlib already have the right idiom, lemma, or instance path, and what is
the canonical way to discharge each — so we do not hand-roll a parallel API.

## Friction (a) — recovering `CommRing` on a `forget₂ CommRingCat RingCat` image

The project's section rings are `CommRingCat`-valued (e.g.
`Y.ringCatSheaf.obj.obj (op W')`), but in the relevant subgoal they appear
through `forget₂ CommRingCat RingCat`, i.e. as the carrier
`↑(Y.ringCatSheaf.obj.obj (op W'))` typed as a `RingCat` object. The candidate
lemma `restrictScalars_isIso_ε_of_bijective (f : R →+* S) [CommRing R] [CommRing S]`
(a top-level lemma in the project's `PresheafInternalHom`) requires `CommRing R`
and `CommRing S`, but Lean fails with `failed to synthesize CommRing ↑(...)`
because the `CommRing` instance is not found at the `forget₂`'d / `RingCat`
spelling even though the underlying object is a `CommRingCat`.

Questions:
- What is the Mathlib idiom for recovering / transporting the `CommRing` instance
  on the carrier of a `CommRingCat` object that is currently being viewed through
  `forget₂ CommRingCat RingCat`? Is there a canonical instance, `CommRingCat`
  coercion lemma, or `change`/defeq route Mathlib uses for exactly this?
- Does Mathlib have a `restrictScalars` ε-iso (lax unit iso) lemma stated for
  `RingCat` homs or for `CommRingCat` homs directly (so no `CommRing R/S`
  hypothesis re-synthesis is needed)? Look at `ModuleCat.restrictScalars`'s
  monoidal/lax-monoidal API: `restrictScalarsLaxMonoidal`, `ε`, and any
  `isIso_ε` / `IsIso (ε …)` results, especially "of bijective" or "of ring
  equiv" variants. Name the exact decls and their hypotheses.
- If the cleanest path is a small project-local lemma "ε of a bijective RingCat
  hom between CommRingCat-forget₂ rings is iso", say so and sketch its Mathlib
  building blocks.

## Friction (b) — `𝟙_`-vs-`restrictScalars`-unit-section defeq bridge

`ε`'s type is `𝟙_ (ModuleCat S) ⟶ (ModuleCat.restrictScalars φ).obj (𝟙_ (ModuleCat R))`.
The goal instead carries the unit in a defeq-but-not-syntactic spelling coming
from the project's internal-Hom section functor: forms like
`(restr V (𝟙_ ...)).obj W` and `(restr fV (𝟙_ ...)).obj (op (Over.mk _))`, and
the rings differ syntactically too
(`((Over.forget V).op ⋙ Y.presheaf ⋙ forget₂).obj W` vs
`Y.ringCatSheaf.obj.obj (op W'.left)`, defeq). So `exact inv (ε …)` does not
unify.

Questions:
- What is the Mathlib idiom for bridging a tensor-unit `𝟙_ (ModuleCat R)` to a
  defeq presheaf-section spelling of the same unit — `eqToHom` of an object
  equality, `change`, or a dedicated `MonoidalCategory.tensorUnit`/`whiskerLeft`
  coherence lemma? How does Mathlib reconcile `𝟙_` with concrete carriers when
  they are defeq but not syntactic?
- Is there a Mathlib pattern (e.g. in `ModuleCat` or `PresheafOfModules`
  monoidal code) for transporting `ε` / `μ` components across such unit-section
  spellings without re-proving the iso?

## Search radius

Narrow — `ModuleCat` / `PresheafOfModules` / `CommRingCat` / `RingCat`
change-of-rings and monoidal-functor (`ε`/`μ`) API in current Mathlib.

## Deliverable

For each friction: the Mathlib idiom (named decls + signatures, tagged with
whether you verified they exist via search), the canonical discharge path, and —
if no Mathlib idiom exists — a minimal project-local lemma statement with its
building blocks. Write the persistent rationale to `analogies/<slug>.md`.
