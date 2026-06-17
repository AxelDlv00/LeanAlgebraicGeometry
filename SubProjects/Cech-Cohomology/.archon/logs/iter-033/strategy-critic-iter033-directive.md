# Strategy-critic directive — iter-033

Read these (and ONLY these) for a fresh-context soundness check:
- `/home/archon/proj/Cech-Cohomology/.archon/STRATEGY.md` (verbatim — the strategy under review).
- `/home/archon/proj/Cech-Cohomology/references/summary.md` (the reference index).
- Blueprint chapter list (titles / one-line topic):
  - `Cohomology_CechHigherDirectImage.tex` — consolidated chapter: the whole Čech-computes-Rⁱf_*
    arc (P3 standard-cover vanishing, P3b free/section Čech bridge, absolute cohomology Form B,
    01EO basis criterion, 02KG affine Serre vanishing cover-system, 01I8 `F≅~ΓF` Route-P chain,
    P5a/P5b assembly inputs).
  - `Cohomology_AcyclicResolution.tex` — P4 abstract Cartan–Leray acyclic-resolution lemma.
  - `Cohomology_HigherDirectImage.tex` — push–pull functor, CechNerve/CechComplex.

Do NOT read iter sidecars, task_pending/task_done, PROGRESS.md, or any prover/review narrative.

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (protected, frozen signature): for
`f : X ⟶ S` separated quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover, an
isomorphism `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` under
`[HasInjectiveResolutions X.Modules]`. End-state: zero inline sorry in the cone, zero project axioms.

## Specific question this iter
The only strategy delta this iter is a within-phase re-estimate: the 02KG cover-system's last gate
`toSheaf_preservesEpimorphisms` was found (iter-032 prover) to be NOT a small instance but
`(SheafOfModules.toSheaf).PreservesFiniteColimits` (toSheaf right-exactness), a multi-lemma Mathlib
gap. The 02KG row's `Iters left` and the Mathlib-gaps bullet are being adjusted accordingly. The
routes, the Route-P 01I8 decomposition (P0–P4), and the goal are unchanged from your iter-032 SOUND
verdict. Confirm the strategy is still sound, or CHALLENGE/REJECT with specifics. In particular:
is there any circularity risk in 02KG now depending on a toSheaf right-exactness build, and does the
two-front structure (02KG cover-system vs 01I8 global-generation, both feeding the top theorem)
still hold up?
