# Blueprint Writer Directive

## Slug
comparison

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Strategy context

The project proves `lem:cech_computes_cohomology`
(`AlgebraicGeometry.cech_computes_higherDirectImage`): for `f : X ⟶ S` separated +
quasi-compact, `F` quasi-coherent, `𝒰` a finite affine cover, an isomorphism (existence form
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)`, under
`[HasInjectiveResolutions X.Modules]`).

We have **PIVOTED the proof of the comparison theorem from spectral sequences to the
acyclic-resolution route** (Cartan–Leray). The current chapter's proof of
`lem:cech_computes_cohomology` (lines ~667–705) argues via a Čech-to-cohomology spectral
sequence + the Leray spectral sequence; BOTH are absent from Mathlib for `Scheme.Modules`
and the Leray degeneration additionally needs quasi-coherence of `R^q f_* F`. The new route
replaces all of that with ONE abstract homological-algebra lemma plus the affine acyclicity
we already plan to build.

The abstract lemma is being written in a sibling chapter
`Cohomology_AcyclicResolution.tex` under the label
`lem:acyclic_resolution_computes_derived` (statement: a resolution `0 → A → J•` by
right-`G`-acyclic objects computes `G.rightDerived`, i.e.
`(G.rightDerived n).obj A ≅ Hⁿ(G(J•))`). Reference that label via `\uses` (it is a real label
the sibling writer is creating this same iteration — do not redefine it here).

## Required content (edit this chapter)

### (A) Rewrite the PROOF of `lem:cech_computes_cohomology` to the acyclic-resolution route.

Keep the STATEMENT block of `lem:cech_computes_cohomology` and its `\lean{}` pin EXACTLY as
is (it is a protected, frozen signature — do not touch the statement, only the proof prose and
the proof's `\uses`). Replace the proof body with the acyclic-resolution argument:

1. The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` (where
   `Cᵖ = ∏_{(i₀…i_p)} (j_{i₀…i_p})_* (F|_{U_{i₀…i_p}})` is the degree-`p` term of the Čech
   nerve) is a **resolution** of `F` in `X.Modules` — i.e. the augmented complex is exact.
   Introduce this as a sub-lemma `\label{lem:cech_augmented_resolution}`
   `\lean{...}` [expected, e.g. `AlgebraicGeometry.cechAugmented_exact`], `\uses{def:cech_nerve}`.
   Sketch: exactness is local; on each affine intersection it is the standard-cover augmented
   complex exactness, the same prime-local contracting homotopy as `lem:cech_acyclic_affine`.

2. Each term `Cᵖ` is **right-`(pushforward f)`-acyclic**:
   `(pushforward f).rightDerived k (Cᵖ) = 0` for `k ≥ 1`. Introduce as a sub-lemma
   `\label{lem:cech_term_pushforward_acyclic}` `\lean{...}` [expected, e.g.
   `AlgebraicGeometry.cechTerm_pushforward_acyclic`],
   `\uses{lem:cech_acyclic_affine, def:cech_nerve}`. Sketch: `Cᵖ` is a product of pushforwards
   of `F` along the open immersions of the affine intersections; because each intersection is
   affine and `f` is separated + quasi-compact, the higher direct images of `F` over each
   intersection vanish (relative Serre vanishing — the relative form of the Serre-vanishing
   half of `lem:cech_acyclic_affine`), so each `Cᵖ` carries no higher `(pushforward f)`-derived
   cohomology. CAREFULLY state why `Rᵏ(f∘j_s)_*(F|_{U_s}) = 0` for `k≥1`: this is the
   strategic-validation point flagged in STRATEGY.md — ground it precisely against the source
   (intersections affine ⇒ `f∘j_s` factors so that higher direct images reduce to affine Serre
   vanishing). If on close reading this acyclicity does NOT reduce cleanly to the affine
   vanishing we already plan, FLAG it under "Strategy-modifying findings" rather than papering
   over it.

3. Conclude by applying `lem:acyclic_resolution_computes_derived` with
   `G = pushforward f`, `A = F`, `J• = C•`: the resolution (1) is termwise acyclic (2), so
   `(pushforward f).rightDerived i F ≅ Hⁱ((pushforward f)(C•)) = Hⁱ(CechComplex f 𝒰 F)`, which
   is exactly `(CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F`. Wrap in `Nonempty`.

   Update the proof's `\uses{}` to:
   `\uses{lem:cech_augmented_resolution, lem:cech_term_pushforward_acyclic,
   lem:acyclic_resolution_computes_derived, def:cech_complex, def:higher_direct_image}`.
   Also update the STATEMENT block's `\uses{}` (line ~597) to add the two new sub-lemmas and
   `lem:acyclic_resolution_computes_derived`, and REMOVE any implication that two spectral
   sequences are needed.

   Replace the old "depends on currently-absent infrastructure: two spectral sequences"
   closing paragraph with an accurate note: the only absent-from-Mathlib ingredient is now the
   abstract `lem:acyclic_resolution_computes_derived` (being built in
   `Cohomology_AcyclicResolution.tex`) plus the affine acyclicity `lem:cech_acyclic_affine`.

### (B) Restructure `lem:cech_acyclic_affine` per the source's two-lemma structure.

The strategy-auditor found that `lem:cech_acyclic_affine` currently CONFLATES two distinct
Stacks lemmas, while the Lean theorem `CechAcyclic.affine` only proves the Čech-complex
vanishing (`IsZero ((CechComplex f 𝒰 F).homology p)`), not the sheaf-cohomology Serre
vanishing. Split the blueprint into two blocks matching Stacks:

- `\label{lem:cech_acyclic_affine}` `\lean{AlgebraicGeometry.CechAcyclic.affine}` (KEEP this
  `\lean{}` pin — the Lean decl exists and is protected-adjacent; do not change its signature):
  the **standard-cover Čech-complex vanishing** `IsZero ((CechComplex f 𝒰 F).homology p)` for
  `p ≥ 1`, via the prime-local contracting homotopy `h(s)_{i₀…i_p} = s_{i_fix i₀…i_p}`. Its
  proof is the algebraic homotopy argument (cite `algebra-lemma-cover-module` and
  `algebra-lemma-characterize-zero-local`).
- A SEPARATE block `\label{lem:affine_serre_vanishing}` `\lean{...}` [expected, e.g.
  `AlgebraicGeometry.affine_serre_vanishing`] for **Serre vanishing** `H^p(U, F) = 0` (`p>0`)
  on affine `U`, derived from the Čech vanishing via the basis-comparison lemma. Mark the
  basis-comparison vehicle (`cohomology-lemma-cech-vanish-basis`) either as a `\mathlibok`
  anchor if Mathlib provides it for `Scheme.Modules` (verify with `archon-lean-lsp`), or as a
  `\uses` to a clearly-named to-build dependency if it does not. The termwise-acyclicity
  sub-lemma (A.2) should `\uses` whichever of these two correctly supplies the relative
  vanishing it needs.

Keep both citation blocks faithful: the chapter already has the correct `% SOURCE QUOTE:` /
`% SOURCE QUOTE PROOF:` text for these (lines ~474–541); redistribute it across the two blocks
verbatim — do NOT rewrite the quotes, just split them to the block each belongs to.

## Out of scope
- Do NOT touch the push–pull blocks (`lem:push_pull_id`, `lem:push_pull_comp`,
  `def:push_pull_obj`, `def:push_pull_map`, the mate lemmas, the three-part construction
  section) — the planner just split/edited those this iteration.
- Do NOT change any `\lean{}` pin on an EXISTING Lean declaration
  (`cech_computes_higherDirectImage`, `CechAcyclic.affine`, `CechComplex`, `CechNerve`).
- Do NOT add `\leanok` markers (managed by `sync_leanok`).
- Do NOT edit `content.tex` or other chapters; the new abstract chapter is a sibling writer's job.

## References
- `references/stacks-coherent.tex` (read the `.tex`, the `.md` is only a pointer): Tags 02KE,
  02KG; `lemma-cech-cohomology-quasi-coherent-trivial`,
  `lemma-quasi-coherent-affine-cohomology-zero`,
  `cohomology-lemma-cech-vanish-basis` (referenced from the Cohomology chapter),
  `lemma-quasi-coherence-higher-direct-images-application`. Re-read the actual 02KE proof
  (it is `In view of [Serre vanishing] this is a special case of
  [cohomology-lemma-cech-spectral-sequence-application]`) so your acyclic-resolution
  restatement is honestly grounded — the acyclic-resolution argument is the standard
  textbook proof of the same fact, so cite the Stacks statements for the geometric inputs and
  the abstract chapter's lemma for the homological-algebra step.

## Expected outcome
The comparison theorem's proof is rewritten to the acyclic-resolution route (two new
geometric sub-lemmas + an application of the abstract chapter's lemma, no spectral sequences),
`lem:cech_acyclic_affine` is split into Čech-complex vanishing + Serre vanishing matching the
source, and all `\uses{}` edges are accurate and acyclic. If the termwise-acyclicity step
(A.2) does not reduce cleanly to the affine vanishing, that is surfaced under
"Strategy-modifying findings".
