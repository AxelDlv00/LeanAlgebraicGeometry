# Strategy-critic directive — iter-056

Provide a fresh-eyes critique of the project's overall strategy. You have NO access to per-iter
history; that is intentional. Read only the materials named below.

## Read these (and ONLY these) for context
- `/home/archon/proj/Cech-Cohomology/.archon/STRATEGY.md` (verbatim — the strategy you are critiquing).
- `/home/archon/proj/Cech-Cohomology/references/summary.md` (the reference index).
- The three blueprint chapter headers (titles + the `% archon:covers` lines + the first few section
  headings) of:
  - `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter — most files)
  - `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`
  - `blueprint/src/chapters/Cohomology_HigherDirectImage.tex`
  You may skim section headings to understand topic coverage; you do not need to read full proofs.

## The project goal (one paragraph)
Prove the protected, frozen-signature theorem `AlgebraicGeometry.cech_computes_higherDirectImage`
(`lem:cech_computes_cohomology`): for `f : X ⟶ S` separated and quasi-compact, `F` quasi-coherent, `𝒰`
a finite affine open cover of `X`, an isomorphism `Nonempty ((CechComplex f 𝒰 F).homology i ≅
higherDirectImage f i F)` where `higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`,
under `[HasInjectiveResolutions X.Modules]`. The chosen route is **Route A**: the augmented Čech
complex is a resolution of `F` (P5a-resolution) that is termwise `(pushforward f)`-acyclic
(P5a-consumer), so Leray's acyclicity lemma (P4, done) computes `Rⁱf_* F` directly.

## What I want challenged
1. Is Route A still the right route now that the two remaining active phases have bottomed out on:
   (a) the **Sub-brick A** section identification `Γ(V,pushPullObj F Y)≅∏_σ Γ(U_σ∩V,F)` (P5a-resolution),
       newly decomposed into `CechSectionIdentification.lean`; and
   (b) a **change-of-scheme Serre vanishing for a general affine open** (P5a-consumer) — i.e.
       Serre vanishing `Ext^q(jShriekOU V, H)=0` for `V` an arbitrary affine open of an affine scheme,
       generalizing the existing `affine_serre_vanishing` which only covers the `Spec R, ⊤` case?
2. Is (b) — change-of-scheme/general-affine-open Serre vanishing — genuinely necessary, or is there a
   cheaper path to termwise `(pushforward f)`-acyclicity of the Čech terms `(j_s)_*(F|_{U_s})` that
   avoids generalizing the affine vanishing infrastructure? (Check the Stacks references on relative
   affine vanishing / the application lemma — `references/summary.md` points at the tags.)
3. Any hidden circularity in the P5a → P5b dependency, or in using Form-B absolute cohomology
   (`Ext^p(jShriekOU U,-)`) to realize cohomology of an affine open `V` inside the affine scheme `U`?
4. Is the `[EnoughInjectives]`-connector / `[HasInjectiveResolutions]` hypothesis bridge sound?

Give SOUND / CHALLENGE / REJECT with concrete reasoning, citing the references where relevant.
