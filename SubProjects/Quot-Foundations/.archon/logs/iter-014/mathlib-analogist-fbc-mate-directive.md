# Mathlib-analogist directive — FBC conjugate-adjunction unit transport

## Mode: api-alignment

## Context (project setting)
In `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` we prove the affine case of flat base
change for the i=0 pushforward by identifying a base-change comparison map on global sections.
The crux ("Seam 1", Lean decl `AlgebraicGeometry.base_change_mate_unit_value`): the UNIT of the
affine pullback–pushforward adjunction `(Spec ι_A)^* ⊣ (Spec ι_A)_*` on `SheafOfModules`, read on
global sections through the proved "tilde dictionaries" `pullback_spec_tilde_iso` /
`pushforward_spec_tilde_iso`, must be shown EQUAL to the purely algebraic unit
`η_M : m ↦ 1 ⊗ₜ m` of the module-level adjunction
`ModuleCat.extendRestrictScalarsAdj` (`extendScalars φ ⊣ restrictScalars φ`).

## The wall (failed approach)
- Element-level `ext`/generator chases DEAD-END: `pullback_spec_tilde_iso` is constructed via
  `CategoryTheory.Adjunction.conjugateIsoEquiv` (the mate/conjugate of one adjunction across a pair
  of comparison isos). Its action on elements `r' ⊗ m` is OPAQUE by construction — `simp` unfolds it
  to a `conjugateIsoEquiv` term that no element computation can push through.
- Conclusion from two iters: the identification must be done by ABSTRACT adjunction calculus
  (naturality / unit-coherence of `conjugateEquiv`), NOT by computing on elements.

## Structural problem (stated abstractly)
Given two adjunctions `L₁ ⊣ R₁` and `L₂ ⊣ R₂` and natural isomorphisms relating `L₁≅L₂`/`R₁≅R₂`
(or a comparison square), the mate/conjugate transport carries the unit `η₁` to the unit `η₂`.
We need: the Mathlib idiom that expresses **"the conjugate (mate) of an adjunction's unit, under a
pair of comparison isomorphisms, is the other adjunction's unit"** — so that
`comparison(geometric unit) = algebraic unit` is a one-step adjunction-calculus identity.

## Questions
1. What does Mathlib provide around `Adjunction.conjugateEquiv` / `Adjunction.conjugateIsoEquiv` /
   `CategoryTheory.mateEquiv` / `Adjunction.transferNatTrans`? Specifically: is there a
   `conjugateEquiv_unit` / `mateEquiv`-unit coherence lemma, or `conjugateEquiv` naturality, that
   identifies the transported unit without touching elements?
2. Is `Adjunction.homEquiv_unit` / `homEquiv_counit` / `unit_naturality` / `leftAdjointUniq` the
   right toolset to rewrite `pullback_spec_tilde_iso ∘ (geometric unit)` into the algebraic unit?
3. Does Mathlib already have a lemma transporting a unit across a `conjugateIsoEquiv`/`mateEquiv`
   that we should consume rather than reprove element-wise?

Tag every named lemma you return as it exists at the project's pinned Mathlib (give the exact
declaration name + signature). The goal is a concrete short abstract-calculus recipe the FBC prover
can apply to Seam 1 (`base_change_mate_unit_value`) THIS iter.
