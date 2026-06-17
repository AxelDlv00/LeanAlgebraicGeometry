# Blueprint Reviewer Directive

## Slug
iter002

## Strategy snapshot

**Goal.** Prove the protected, frozen-signature target
`AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`):
for `f : X ⟶ S` separated and quasi-compact, `F` quasi-coherent, `𝒰` a finite affine
open cover of `X`, the weak existence form
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under
`[HasInjectiveResolutions X.Modules]`), where
`higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`.
End-state: zero inline `sorry` in the cone, zero project axioms, kernel-only axioms.

**Chosen route (Route A — acyclic-resolution comparison).** The augmented Čech complex
`0 → F → C⁰ → C¹ → ⋯` on `X` (with `Cᵖ = ∏ (j_s)_*(F|_{U_s})` over (p+1)-fold
intersections) is (i) a resolution of `F` and (ii) termwise `(pushforward f)`-acyclic
(each intersection is affine ⇒ relative Serre vanishing). Then ONE abstract
homological-algebra theorem "a `G`-acyclic resolution computes `G.rightDerived`"
(`Cohomology_AcyclicResolution.tex`) yields `Hⁱ(CechComplex) ≅ (pushforward f).rightDerived i F`.
No spectral sequences. Route B (two spectral sequences) is rejected/fallback only.

### Phases & estimations (the REMAINING phases — assess blueprint coverage for each)

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| P1 `pushPullMap_comp` (functor law) | ACTIVE | ~1–2 | ~60–120 | `conjugateEquiv_comp`, `pseudofunctor_associativity` | definitional coherence; mate calculus |
| P2 `CechNerve`/`CechComplex` assembly | NEXT (needs P1) | ~1 | ~30–80 | `Over.lift`, `CosimplicialObject.whiskering`, `alternatingCofaceMapComplex` | nerve assembly |
| P3 affine acyclicity (`CechAcyclic.affine`) | NEXT (parallel) | ~3–6 | ~200–500 | standard-cover Čech = localisations; prime-local homotopy | building localisation description from scratch for `Scheme.Modules` |
| P4 abstract acyclic-resolution lemma (Leray 015E) | NEXT (parallel) | ~3–5 | ~200–450 | `InjectiveResolution.isoRightDerivedObj`, `isZero_rightDerived_obj_injective_succ`, `rightDerivedZeroIsoSelf` | NEW file `AcyclicResolution.lean`. **Mathlib has NO LES / δ-functor for `Functor.rightDerived`** — intended build via comparison-of-resolutions, NOT a hand-built LES |
| P5 comparison assembly | LAST (needs P2,P3,P4) | ~2–4 | ~100–300 | the above + termwise `f_*`-acyclicity | augmented Čech resolution; relative affine vanishing |

## Routes
- **Route A (acyclic-resolution comparison)** — CHOSEN. Chapters:
  `Cohomology_AcyclicResolution.tex` (abstract lemma) + `Cohomology_CechHigherDirectImage.tex`
  (geometric construction + comparison assembly) + `Cohomology_HigherDirectImage.tex` (defines the RHS `higherDirectImage`).
- **Route B (two spectral sequences)** — REJECTED/fallback. Intentionally has NO blueprint
  coverage; do NOT flag it as a missing-route gap.

## References
- `references/stacks-coherent.md` → `stacks-coherent.tex`: Stacks ch.30 Cohomology of Schemes.
  Tags 02KE/02KG. Backs the Čech construction + comparison (`Cohomology_CechHigherDirectImage.tex`).
- `references/homological-acyclic.md` → `homological-acyclic-derived.tex` + `-homology.tex`:
  Stacks derived/homology. Tags 0157/015C/015D/015E/05TA. Backs `Cohomology_AcyclicResolution.tex`.

## Focus areas (extra attention — do NOT skip the others)

1. **`Cohomology_AcyclicResolution.tex` — feasibility of the chosen Lean route.** The
   chapter's proofs of `lem:acyclic_dimension_shift` and
   `lem:acyclic_resolution_computes_derived` are written in terms of the **long-exact-sequence
   / δ-functor structure of `{R^k G}`**, and the chapter's own closing remark admits the proof
   "depends on the long exact sequence / δ-functor structure of the right-derived functors".
   The strategy (P4) records that **Mathlib provides NO LES / δ-functor for
   `Functor.rightDerived`**, and the intended Lean build route is
   **comparison-of-resolutions** (compare the acyclic resolution `J•` to an injective
   resolution `I•`; `isZero_rightDerived_obj_injective_succ` makes `G(J•) → G(I•)` a
   `G`-quasi-iso; transport via `isoRightDerivedObj`), NOT a hand-built LES. Please assess:
   does the chapter's current δ-functor-based proof prose adequately guide a Lean prover that
   must take the comparison-of-resolutions route? Or is there a blueprint↔route mismatch that
   would send a prover to build LES infrastructure Mathlib lacks? If so, flag it as a
   correctness/completeness must-fix on this chapter (the prose should describe the
   comparison-of-resolutions argument, or clearly mark which homological infrastructure is
   assumed and how it is sourced from Mathlib).
2. **HARD GATE for `CechHigherDirectImage.lean`.** Its covering chapter
   `Cohomology_CechHigherDirectImage.tex` was rewritten in iter-001 to Route A and has NOT
   been re-reviewed since. The ready-frontier node `lem:push_pull_comp` (Lean
   `pushPullMap_comp`) is the most prover-ready target; confirm whether this chapter is now
   `complete + correct` so the gate can clear for it.
3. **`\mathlibok` anchor faithfulness** in `Cohomology_AcyclicResolution.tex`: verify
   `CategoryTheory.InjectiveResolution.isoRightDerivedObj`,
   `CategoryTheory.Functor.isZero_rightDerived_obj_injective_succ`,
   `CategoryTheory.Functor.rightDerivedZeroIsoSelf` exist in Mathlib with the stated forms.

## Known issues (don't re-report)
- The doctor already flags that `Cohomology_AcyclicResolution.tex` covers
  `AcyclicJacobian/Cohomology/AcyclicResolution.lean`, which does not yet exist. This iter's
  plan scaffolds that file (the covers line is a sanctioned forward reference). No need to
  re-flag the covered-file-missing issue.
- Route B has no blueprint coverage by design (rejected route). Not a gap.
