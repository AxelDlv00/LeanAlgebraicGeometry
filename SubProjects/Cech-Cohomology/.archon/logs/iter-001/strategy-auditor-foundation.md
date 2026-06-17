# Strategy Auditor Directive

## Slug
foundation

## What to audit

Audit `STRATEGY.md` (pasted below) and the blueprint chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` against the ACTUAL source
text in `references/stacks-coherent.tex` (the `.md` is only a pointer; read the `.tex`).

The project goal is to prove `AlgebraicGeometry.cech_computes_higherDirectImage`
(blueprint `lem:cech_computes_cohomology`): for `f : X ⟶ S` separated + quasi-compact,
`F` quasi-coherent, `𝒰` a finite affine cover, an isomorphism (existence form
`Nonempty (… ≅ …)`) between `(CechComplex f 𝒰 F).homology i` and the derived-functor
`higherDirectImage f i F`. End-state: zero sorry in the cone, zero axioms.

## STRATEGY.md (verbatim)

(See the strategy-critic directive for the identical text; the strategy decomposes the
proof into three phases — (1) Čech nerve/complex via a push-pull functor with a stalled
pentagon coherence law `pushPullMap_comp`; (2) affine acyclicity `CechAcyclic.affine`
via a standard-cover localisation complex + prime-local contracting homotopy; (3) the
comparison theorem via TWO spectral sequences (Čech-to-cohomology + Leray) for
`Scheme.Modules`.)

## The specific structural questions to answer FROM THE SOURCE

Read the relevant tags in `references/stacks-coherent.tex` and report what the source
ACTUALLY does, so I can correct the strategy if it has invented or over-built a route:

1. **Tag 02KE** (`lemma-cech-cohomology-quasi-coherent`) and
   `lemma-quasi-coherence-higher-direct-images-application`: what is the PRECISE proof the
   Stacks Project gives for "Čech computes cohomology / `H^q(X,F)=H^0(S,R^qf_*F)`"? Does it
   genuinely route through TWO spectral sequences (a Čech-to-cohomology SS AND the Leray
   SS), as the blueprint's proof prose claims? Or does Stacks derive 02KE more directly
   (e.g. from a single Čech-to-cohomology comparison plus affine vanishing, with Leray only
   for the affine-base global-sections corollary)? Quote the actual proof text.

2. Is there a route in the Stacks development to the comparison that AVOIDS spectral
   sequences entirely for the sheaf-level (relative) isomorphism — e.g. via the
   Čech-to-cohomology comparison on a basis of affines
   (`cohomology-lemma-cech-vanish-basis` / the lemma that an affine-intersection cover
   computes cohomology), treating the augmented Čech complex as a resolution? Report what
   ingredients that route needs and whether they are lighter than building two spectral
   sequences.

3. **Tag 02KG** + `lemma-cech-cohomology-quasi-coherent-trivial`: confirm the standard-cover
   Čech-vanishing proof structure (the prime-local contracting homotopy
   `h(s)_{i₀…i_p}=s_{i_fix i₀…i_p}` and the reduction to
   `algebra-lemma-cover-module`/`algebra-lemma-characterize-zero-local`). Does the blueprint's
   `lem:cech_acyclic_affine` proof faithfully match the source, or does it conflate the
   standard-cover Čech vanishing (02KG-trivial) with the general affine Serre vanishing
   (02KG) in a way that introduces an unnecessary or circular dependency?

4. Flag any **missing prerequisite** the source introduces before 02KE/02KG that the
   strategy/blueprint omits, any **unnecessary case split**, and any **hallucinated route**
   (a step the strategy claims the source takes but the source does not).

Report findings so I can correct STRATEGY.md and the blueprint before assigning provers.
Return the outcome and the path to your report.
