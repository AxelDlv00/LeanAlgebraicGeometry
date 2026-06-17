# Mathlib-analogist directive — iter-054 — slug deepbridge

## Mode: api-alignment

Two ACTIVE prover lanes have each collapsed to a "deep categorical bridge" residual. Both are the
recurring blocker shape (the same family that has kept `CechAcyclic.affine` open). Find the Mathlib
idiom for each so the next prover lane builds the aligned version, not a bespoke parallel.

Project context: `X.Modules = SheafOfModules` on a scheme `X`; complexes are `HomologicalComplex`
with `cc = ComplexShape.up ℕ` (cochain). `toPresheaf : X.Modules ⥤ PresheafOfModules`, evaluation
`(evaluation _ _).obj (op V) : PresheafOfModules ⥤ AddCommGrp`. The Čech augmented complex
`cechAugmentedComplex 𝒰 F : HomologicalComplex X.Modules cc` is already built; there is an existing
combinatorial homotopy `CombinatorialCech.combHomotopy`/`combHomotopy_spec` (private, CechAcyclic.lean)
and an objectwise contracting-homotopy recipe in FreePresheafComplex.lean (lines ~83–92, ~640–1235)
for the FREE presheaf Čech complex.

## Question 1 (Lane 1 — cechAugmented_exact residual)
After reflecting through `SheafOfModules.toSheaf` + `homologyIsoSheafify` + the sheafification square +
the locally-zero site lemma, the residual goal is:
```
IsZero (((GV.mapHomologicalComplex cc).obj Kp).homology p)
```
where `GV = toPresheaf ⋙ (evaluation _ _).obj (op V)` (so `GV.obj X = Γ(V, X)` as an AddCommGrp),
`Kp = ((forget ⋙ restrictScalars α).mapHomologicalComplex cc).obj (cechAugmentedComplex 𝒰 F)`, and the
hypothesis is `V ≤ coverOpen 𝒰 i` (V sits inside one cover member). Mathematically: the section complex
`Γ(V, cechAugmentedComplex 𝒰 F)` is contractible because the restricted cover `{U_s ∩ V}` has the member
`U_i ∩ V = V`, giving the prepend-i_fix homotopy `(h s)_{i_0..i_p} = s_{i_fix i_0..i_p}` with
`d∘h + h∘d = id`.
- (1a) Given a `Homotopy (𝟙 C) (0 : C ⟶ C)` (or a `HomotopyEquiv C 0`) on a `HomologicalComplex
  AddCommGrp cc`, what is the EXACT Mathlib lemma yielding `IsZero (C.homology p)` for all p? (Candidates
  to confirm/refute: `Homotopy.homologyMap_congr`/`homologyMap_eq`, `HomotopyEquiv.homologyIso`,
  `HomologicalComplex.homology` of a contractible complex, `ChainComplex`/`CochainComplex` contractible
  ⟹ acyclic. Give the precise name + signature + import.)
- (1b) What is the cleanest Mathlib idiom to OBTAIN that homotopy on `(GV.mapHomologicalComplex cc).obj
  Kp`? Two sub-routes — tell me which is aligned: (i) build the `Homotopy` directly on the abstract
  `mapHomologicalComplex` complex via `HomologicalComplex.Hom`/`Homotopy` field-by-field; or (ii) first
  identify `(GV.mapHomologicalComplex cc).obj Kp` with a concrete `CochainComplex` of products
  `∏_σ Γ(coverInter σ ⊓ V, F)` (an explicit Čech complex) via `Functor.mapHomologicalComplex` naturality,
  then reuse `CombinatorialCech.combHomotopy_spec`. Is there a Mathlib `extraDegeneracy`/`ExtraDegeneracy.
  homotopyEquiv` route that applies to a COSIMPLICIAL/cochain Čech object with an augmentation, or does the
  variance rule it out (project memory says Mathlib's simplicial ExtraDegeneracy has the wrong variance)?

## Question 2 (Lane 2 — open-immersion f_*-acyclicity, "bridge (1)")
The residual is the cohomology-presheaf identification: identify the objectwise homology
`(pushforwardResolutionPresheafComplex f I).homology n` evaluated at `V` — i.e. `Hⁿ(I^•(f⁻¹V))` where
`I^•` is an injective resolution of `G` in `(f⁻¹·)`-modules — with the absolute cohomology presheaf
`V ↦ Hⁿ(f⁻¹V, G) = Ext^n(jShriekOU (f⁻¹V), G)` (project's Form-B absolute cohomology, file
AbsoluteCohomology.lean). This is the deferred hand-off documented in HigherDirectImagePresheaf.lean
(lines 131–157).
- (2a) Is there a Mathlib idiom relating `(F.mapHomologicalComplex I.cocomplex).homology n` (objectwise
  homology of an additive functor applied to an injective resolution) to `Ext n` or `Functor.rightDerived
  n`? (Confirm/refute `InjectiveResolution.extEquivCohomologyClass`, `CategoryTheory.Abelian.Ext`, the
  `rightDerived`-via-injective-resolution computation, and whether evaluation-at-V commutes with this.)
- (2b) The Form-B absolute cohomology is `Ext^n(jShriekOU U, G)`. The presheaf-homology side is
  `Hⁿ` of a section/pushforward-resolution complex. Name the cleanest Mathlib bridge between
  "Ext via injective resolution of the 2nd argument" and "cohomology of the global-sections/pushforward of
  that resolution" — i.e. the H⁰=Hom + derived-functor-agree statement.

## Deliverable
For each sub-question: the precise Mathlib decl name(s) + signature + import (or GAP if absent), and a
one-line "build this shape" recommendation. Persist to `analogies/deepbridge.md`. These two bridges are
the dominant remaining work of phase P5a; an aligned recipe de-risks both lanes.
