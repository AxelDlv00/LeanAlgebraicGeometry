## Mode: api-alignment

# mathlib-analogist — mate207

## The situation

Project lane TS needs, project-side, the base-change comparison map for the
pullback of presheaves of modules:
```
(PresheafOfModules.pullback φ.hom).obj (A ⊗ B)
   ⟶ (PresheafOfModules.pullback φ.hom).obj A ⊗ (PresheafOfModules.pullback φ.hom).obj B
```
`PresheafOfModules.pullback φ` is defined as the abstract left adjoint
`(PresheafOfModules.pushforward φ).leftAdjoint` (no sectionwise formula), so there is
no map to even state until its oplax-monoidal structure is built. This comparison map
is the **mate** of `pushforward φ`'s monoidal structure.

## What I (planner) found via Lean search this iter — please VERIFY and refine

1. Mathlib HAS `CategoryTheory.Adjunction.rightAdjointLaxMonoidal`
   (`Mathlib.CategoryTheory.Monoidal.Functor`): given `F ⊣ G` and `[F.OplaxMonoidal]`,
   produces `G.LaxMonoidal`.
2. Mathlib does NOT appear to have the DUAL
   `Adjunction.leftAdjointOplaxMonoidal`: given `F ⊣ G` and `[G.LaxMonoidal]`, produce
   `F.OplaxMonoidal`. (loogle/leansearch for that name returned nothing.)
3. Mathlib also has `CategoryTheory.Adjunction.IsMonoidal`, `leftAdjoint_μ`,
   `leftAdjoint_ε`, `Functor.Monoidal.toOplaxMonoidal`,
   `Functor.OplaxMonoidal.ofBifunctor`.
4. The recipe notes `PresheafOfModules.pushforward₀OfCommRingCat` IS `Monoidal`
   (`.../Presheaf/PushforwardZeroMonoidal.lean`) and `ModuleCat.extendScalars` IS
   `Monoidal` (`Mathlib.Algebra.Category.ModuleCat.Monoidal.Adjunction:42`).

## Questions for you (api-alignment)

1. Is the Mathlib-aligned move to build, project-side, the categorical lemma
   `Adjunction.leftAdjointOplaxMonoidal : (F ⊣ G) → [G.LaxMonoidal] → F.OplaxMonoidal`
   by DUALIZING the existing `rightAdjointLaxMonoidal`? Confirm the dual is genuinely
   absent from current Mathlib, and that this is a clean self-contained categorical
   lemma (NOT scheme-specific, NOT a multi-file AG build).
2. Construction shape: how is the oplax δ defined as the mate of G's lax μ via the
   adjunction unit/counit, and is `rightAdjointLaxMonoidal`'s proof directly dualizable
   (i.e. the oplax coherence axioms follow by the same diagram chase)? Point at the
   exact Mathlib source to mirror.
3. Wiring check: is the adjunction `PresheafOfModules.pullback φ ⊣ PresheafOfModules.pushforward φ`
   actually present, and is `pushforward φ` LaxMonoidal (or Monoidal) for the SAME `φ`
   whose `leftAdjoint` is `pullback φ`? Flag any reindexing / restriction-of-scalars
   composition that would make the adjunction-vs-monoidal instances mismatch.
4. Is there an EVEN SIMPLER aligned route I'm missing? Specifically: `tensorObj_restrict_iso`
   restricts along an OPEN IMMERSION (`[IsOpenImmersion f]`), where restriction is
   concrete (sectionwise restriction to an open), not the general abstract pullback. Does
   Mathlib have a concrete monoidal description of restriction-of-sheaves-of-modules along
   an open immersion (or `Scheme.Modules.restrict`) that sidesteps the abstract-left-adjoint
   pullback entirely? If so, that may be cheaper than building the general mate lemma.

## Out of scope
Do not propose proofs of downstream lemmas; only the comparison-map construction route
and its Mathlib alignment. Write the persistent rationale to `analogies/mate207.md`.
