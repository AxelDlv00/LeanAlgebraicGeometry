# Strategy-critic directive — iter-055

Fresh-context review of the project strategy. Read these files directly (do NOT read iter sidecars,
task files, PROGRESS.md, or any per-iter narrative — your value is the unbiased fresh view):

- `/home/archon/proj/Cech-Cohomology/.archon/STRATEGY.md` (verbatim — the strategy to critique).
- `/home/archon/proj/Cech-Cohomology/references/summary.md` (the reference index).
- Chapter titles + one-line topics from `/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/*.tex`
  (there are 2 chapters: `Cohomology_CechHigherDirectImage.tex` — the big consolidated chapter for the
  whole Čech↔higher-direct-image development — and `Cohomology_HigherDirectImage.tex`).

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`): for
`f : X ⟶ S` separated and quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover of `X`, the
Čech complex computes the higher direct images, `Nonempty ((CechComplex f 𝒰 F).homology i ≅
((pushforward f).rightDerived i).obj F)`, under `[HasInjectiveResolutions X.Modules]`. End-state: zero
inline sorry in the cone, zero project axioms, kernel-only axioms.

## What I specifically want challenged
1. **Route A soundness under the remaining two leaves.** The two ACTIVE phases (P5a-resolution
   `cechAugmented_exact`, P5a-consumer `higherDirectImage_openImmersion_*`) are both now reduced to crisp
   residuals. Is Route A (acyclic-resolution comparison via the augmented Čech complex) still the right
   spine, or is there a materially shorter path to the goal given everything already built (01EO general
   basis criterion, 02KG affine Serre vanishing unconditional, 01I8 `F≅~ΓF`, P4 Leray)?
2. **The Sub-brick A decomposition (iter-055).** `cechAugmented_exact`'s local discharge bottomed on the
   per-degree section identification `Γ(V,pushPullObj F Yₚ)≅∏_σ Γ(U_σ∩V,F)`. I have decomposed it into a
   shared file `CechSectionIdentification.lean` with ONE new-infra leaf (indexed coproduct→product of
   module sheaves) + off-the-shelf pieces. Is this decomposition sound, or does it hide circularity (does
   any leaf secretly assume affine cohomology vanishing / `Ȟᵖ(V,·)=0`)? Note the discharge is over the
   basis `{V ≤ coverOpen 𝒰 i}` (V inside ONE cover member), where the restricted cover has a maximum
   element so contractibility is purely combinatorial — confirm this avoids the circular "section complex
   exact over each affine V" trap.
3. **Any structural risk** in carrying `[EnoughInjectives X.Modules]` as an explicit hypothesis through
   the 01EO/02KG cone vs the frozen target's weaker `[HasInjectiveResolutions]` (the connector is claimed
   ~6 LOC).

Give SOUND / CHALLENGE / REJECT with specifics. If you CHALLENGE, name the exact strategic claim and the
cheapest evidence that would settle it.
