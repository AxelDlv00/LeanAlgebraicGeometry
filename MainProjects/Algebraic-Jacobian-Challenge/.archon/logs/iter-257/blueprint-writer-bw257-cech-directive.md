# blueprint-writer bw257-cech — author NEW chapter `Cohomology_CechHigherDirectImage.tex`

Create `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` and `\input` it from
`blueprint/src/content.tex` (add the `\input{chapters/Cohomology_CechHigherDirectImage}` line in the
Cohomology group, near the existing `Cohomology_HigherDirectImage` input). This chapter blueprints the
A.2.c-engine `Rⁱf_*` (i ≥ 1) project Čech build — the dominant engine pole — WITHOUT the
`[HasInjectiveResolutions]` hypothesis (which Mathlib lacks for `SheafOfModules` over a varying-ring sheaf
of rings; it exists only for `Sheaf J A` with a fixed value category). No Lean file exists yet; this is a
prover-ready spec for a future `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` (NEW, separate
from the `[HasInjectiveResolutions]`-gated `HigherDirectImage.lean` — keep them isolated).

Declare a `% archon:covers AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` line at the top.

## Source (read it; cite verbatim)

Read `references/stacks-coherent.tex`, tags **02KE–02KH** (Čech-complex computation of `Rⁱf_*`,
quasi-coherence of higher direct images, affine vanishing tag **02KG**, flat base change tag **02KH**).
Each definition/lemma block MUST carry a `% SOURCE: <tag>, (read from references/stacks-coherent.tex)` line
and a verbatim `% SOURCE QUOTE:` (original English, original notation) plus a visible `\textit{Source: …}`
line. For proof blocks add `% SOURCE QUOTE PROOF:`. If a needed passage is not in stacks-coherent.tex,
you may spawn a reference-retriever (your write-domain includes `references/**`); otherwise do not cite
material you have not read.

## Declarations (dependency order — use these `\label`/`\lean` pins and `\uses` edges)

1. `\definition{def:cech_nerve}` `\lean{AlgebraicGeometry.CechNerve}` — Čech nerve of an affine open cover
   of a scheme, as an augmented simplicial object in `Scheme.Modules`.
2. `\definition{def:cech_complex}` `\lean{AlgebraicGeometry.CechComplex}` `\uses{def:cech_nerve}` — the
   Čech complex `C̃ˑ(𝔘, ℱ)` for quasi-coherent `ℱ` and affine cover `𝔘`, a complex in `QCoh(X)`.
3. `\lemma{lem:cech_acyclic_affine}` `\lean{AlgebraicGeometry.CechAcyclic.affine}` `\uses{def:cech_complex}`
   — Čech cohomology of a quasi-coherent sheaf on an AFFINE scheme vanishes in positive degrees
   (Stacks 02KG).
4. `\lemma{lem:cech_computes_cohomology}` `\lean{AlgebraicGeometry.cech_computes_higherDirectImage}`
   `\uses{lem:cech_acyclic_affine, def:cech_complex}` — for separated quasi-compact `f : X → S` and an
   affine open cover of `X`, the Čech complex computes `Rⁱf_*ℱ` (Stacks 02KE).
5. `\definition{def:cech_higher_direct_image}` `\lean{AlgebraicGeometry.cechHigherDirectImage}`
   `\uses{lem:cech_computes_cohomology}` — the UNCONDITIONAL `Rⁱf_*(ℱ)` via the Čech complex (no
   `[HasInjectiveResolutions]`).
6. `\lemma{lem:cech_flat_base_change}` `\lean{AlgebraicGeometry.cech_flatBaseChange}`
   `\uses{def:cech_higher_direct_image, lem:cech_computes_cohomology}` — flat base change
   `g^*(Rⁱf_*ℱ) ≅ Rⁱf'_*((g')^*ℱ)` for flat `g`, from the Čech computation (Stacks 02KH).

Tag the `\lean{}` names `[expected]` in the prose if you wish; they are naming proposals for the future
file (no Lean exists yet). Do NOT add `\leanok`/`\mathlibok`.

## Proof strategy (write each `\begin{proof}` as rigorous prose, project notation)

Build `C̃ˑ(𝔘, ℱ)` from the pushforward `f_*` of `ℱ` on each finite intersection of the cover; prove
affine acyclicity via Stacks 02KG (quasi-coherence + affine vanishing); conclude the cohomology of
`C̃ˑ(𝔘, ℱ)` equals `Rⁱf_*ℱ` (Stacks 02KE); derive flat base change from functoriality of the Čech
construction under base change + flatness of `g` (Stacks 02KH).

## Out of scope
Author ONLY this new chapter (+ the `content.tex` `\input`). Do NOT edit other chapters or any `.lean` file.
This chapter feeds no prover lane this iter — it is forward-spec only.
