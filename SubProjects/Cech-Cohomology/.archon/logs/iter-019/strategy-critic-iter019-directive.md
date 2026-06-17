# Strategy-critic directive — iter-019

Read these files (and ONLY these) for a fresh-eyes assessment:
- `.archon/STRATEGY.md` (verbatim — the current strategy, just edited).
- `references/summary.md` (the reference index).
- For a blueprint summary, skim only the chapter titles / section headers of
  `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (consolidated: Čech machinery, push–pull
  functor, standard-cover Čech vanishing P3, presheaf-Čech bridge P3b, higher-direct-image presheaf P5a,
  comparison assembly P5b), `blueprint/src/chapters/Cohomology_AcyclicResolution.tex` (P4 abstract
  acyclic-resolution-computes-derived-functor lemma), `blueprint/src/chapters/Cohomology_HigherDirectImage.tex`
  (the `higherDirectImage` definition).

Do NOT read PROGRESS.md, task_results, iter sidecars, or any per-iter narrative.

## Project goal
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (protected, frozen signature): for
`f : X ⟶ S` separated quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover, an iso
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)`, via Route A
(acyclic-resolution comparison). Zero sorry in the cone, kernel-only axioms.

## What changed this iter (the thing to scrutinize)
The **P5a re-sign** (new "Open strategic questions" bullet + updated P5a row + Mathlib-gaps bullet):
`lem:higher_direct_image_presheaf` is re-signed from the absolute-cohomology-presheaf form
(`Rⁿf_*G = sheafify(V↦Hⁿ(f⁻¹V,G))`) to the **resolution form** already proved in Lean
(`Rⁿf_*G ≅ sheafify(V↦Hⁿ((f_*I^•)(V)))` for an injective resolution `I`, via the engine
`PresheafOfModules.homologyIsoSheafify`). Rationale recorded: the absolute form would need a standalone
module-valued `Hⁿ(open,F)` object that Mathlib lacks for `SheafOfModules` (a fork, "zero lemmas"); the
downstream P5a consumers (`open_immersion_pushforward_comp`, `cech_term_pushforward_acyclic`) only need
the "vanishes iff presheaf-homology vanishes on a basis" criterion, which the resolution form supplies.

## Questions for you
1. Is the P5a re-sign SOUND, or does it hide a gap — specifically, can the downstream consumers
   (`open_immersion_pushforward_comp`, `cech_term_pushforward_acyclic`, and ultimately the P5b assembly
   `cech_computes_cohomology`) actually be completed from the resolution form, WITHOUT ever needing the
   absolute `Hⁿ(f⁻¹V,G)` identification as a Lean object? If the last-mile `Hⁿ((f_*I^•)(V)) = Hⁿ(f⁻¹V,G)`
   identification is genuinely required somewhere downstream, the re-sign defers a real obligation rather
   than eliminating it — flag that.
2. Does Route A (acyclic-resolution comparison) remain the correct global skeleton, and is the
   P3 / P3b / P5a / P5b decomposition still coherent after this re-sign?
3. Any CHALLENGE / REJECT on the strategy as written.

Report SOUND / CHALLENGE / REJECT with specifics.
