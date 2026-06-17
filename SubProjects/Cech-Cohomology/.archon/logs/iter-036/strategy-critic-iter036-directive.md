# Strategy-Critic Directive — iter-036

Give the project's strategy a fresh-eyes soundness review. You see the strategy as a fresh
mathematician would — challenge sunk cost.

## Read (and ONLY these)
- `/home/archon/proj/Cech-Cohomology/.archon/STRATEGY.md` (verbatim — just updated this iter).
- `/home/archon/proj/Cech-Cohomology/references/summary.md` (the reference index).
- Blueprint chapter titles / one-line topics (do not read full chapters):
  - `Cohomology_CechHigherDirectImage.tex` — the main chapter: Čech complex, the cover-system /
    affine Serre vanishing (02KG), absolute cohomology (Form B), the 01EO basis comparison, the
    01I8 `F≅~(ΓF)` affine lemma, and the higher-direct-image comparison.
  - `Cohomology_AcyclicResolution.tex` — Leray acyclic-resolution lemma (Stacks 015E): an
    `F`-acyclic resolution computes `RF`.
  - `Cohomology_HigherDirectImage.tex` — `Rⁱf_*` of quasi-coherent sheaves (`i ≥ 1`), thin pointer
    chapter.

Do NOT read iter sidecars, task_results, PROGRESS.md, or recent prover/review narrative.

## Project goal (one paragraph)
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (a protected, frozen-signature target):
for `f : X ⟶ S` separated quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover of
`X`, an isomorphism (weak/`Nonempty` form) between the Čech-complex homology
`(CechComplex f 𝒰 F).homology i` and the higher direct image `((pushforward f).rightDerived i).obj F`,
under `[HasInjectiveResolutions X.Modules]`. End-state: zero inline `sorry` in the cone, zero project
axioms, kernel-only axioms.

## What changed this iter (so you can focus your challenge)
The 01I8 affine row was PIVOTED from "Route P (global generation)" to "Route B (section-localization)":
instead of building an affine restriction `F|_{D(f)}≅tilde(M_f)` (which needs a tilde base-change lemma
absent from Mathlib) plus `tildePreservesFiniteLimits`, Route B proves the single keystone
`IsLocalizedModule (.powers f) (Γ(X,F)→Γ(D(f),F))` for quasi-coherent `F` and feeds it to Mathlib's
counit `fromTildeΓ` (whose `D(f)`-component is exactly that localization map). Challenge whether: (a)
Route B's keystone is genuinely the irreducible hard core (no hidden circularity with the 02KG affine
vanishing it feeds); (b) dropping `tildePreservesFiniteLimits`/P2/P3 leaves no gap; (c) the overall
multi-phase arc (02KG ← 01I8; P5a; P5b Route-A comparison) is still the right shape and ordering.
