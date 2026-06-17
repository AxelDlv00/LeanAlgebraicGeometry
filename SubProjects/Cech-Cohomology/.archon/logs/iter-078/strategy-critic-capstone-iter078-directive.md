Read (verbatim, as a fresh mathematician): `.archon/STRATEGY.md`, `references/summary.md`, and the chapter list below. Do NOT read iter sidecars, task_results, PROGRESS.md, or any per-iter narrative.

## Project goal (one paragraph)
Formalize Stacks Tag 02KE: for `f : X → S` quasi-compact separated, `F` quasi-coherent, `𝒰` a finite affine open cover of `X` with all intersections affine, the cohomology of the relative Čech complex computes the higher direct images `R^i f_* F`. The intended deliverable is `cech_computes_higherDirectImage_of_affineCover` (the protected sibling `cech_computes_higherDirectImage` is frozen and false-as-signed; left a documented `sorry`).

## Blueprint chapters (titles / one-line topics)
- Cohomology_CechHigherDirectImage.tex — consolidated: Čech nerve/complex, push–pull functor, augmented Čech resolution, acyclic-resolution comparison capstone, plus 01EO/02KG/01I8 bridge results.
- Cohomology_AcyclicResolution.tex — Leray acyclic-resolution lemma (Stacks 015E), `rightDerivedIsoOfAcyclicResolution`.
- Cohomology_OpenImmersionPushforward.tex — `R^q j_* = 0` for affine open immersions; `R^k f_*(j_* H) ≅ R^k(j∘f)_* H`.
- Cohomology_AffineSerreVanishing.tex — affine Serre vanishing (02KG), general-affine-open form.
- (others: CSI section identification, tilde sections 01I8, free presheaf Čech, absolute cohomology Form B).

## The specific decision to audit
The protected target is FALSE as signed (general `X.OpenCover`, only `[IsSeparated f]`). We instead prove `cech_computes_higherDirectImage_of_affineCover` with FOUR added hypotheses, each claimed mathematically forced:
1. `h𝒰 : ∀ i, IsAffine (𝒰.X i)` + `[X.IsSeparated]` (else single-element-cover ℙ¹/O(-2) counterexample).
2. `[S.IsSeparated]` (so `f∘j_s : U_s → S` from affine `U_s` to separated `S` is affine — Stacks 01SG — enabling relative affine Serre vanishing; doubled-origin counterexample without it).
3. `hres` family `∀(n)(σ), HasInjectiveResolutions (coverInterOpen 𝒰 σ).Modules` (Mathlib gap: no synthesis of per-subscheme injective resolutions).

Questions: (a) Are these four hypotheses each genuinely forced, or is any over-strong / avoidable under a cleaner formulation? (b) Is `_of_affineCover` (with all four) the right deliverable for Tag 02KE, or does the standard statement need different/weaker hypotheses? (c) Does the acyclic-resolution route (Route A) as described soundly reach this conclusion? Flag any structural error. Verdict: SOUND / CHALLENGE / REJECT with reasoning.
