# Effort Breaker Directive

## Slug
staircase

## Target
`lem:acyclic_resolution_computes_derived` (in
`blueprint/src/chapters/Cohomology_AcyclicResolution.tex`,
`\lean{CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution}`).

## Granularity
"one level" — the proof's main steps, cut along the (a) base-case / (b) cosyzygy
seam given below. Each sub-lemma must be strictly smaller than the monolithic
staircase proof.

## Why now
This is the SOLE remaining P4 target (Leray's acyclicity lemma, Stacks 015E).
The horseshoe lift (`lem:injective_resolution_of_ses`), the SES→LES kernel, and
**part (1)** of the dimension-shift lemma (`lem:acyclic_dimension_shift`,
`\lean{rightDerivedShiftIsoOfAcyclic}` — the `k≥1` connecting isos
`(RᵏG)(Z) ≅ (Rᵏ⁺¹G)(A)`) are all built and axiom-clean. The prover correctly
declined to formalize the staircase as one step: it is a separate multi-lemma
construction needing two NEW ingredients neither built nor in Mathlib. Your job
is to re-express the existing (already-cited, gate-passed) blueprint proof as a
`\uses`-linked chain of small sub-lemmas so a `mathlib-build` prover can build
them bottom-up next.

## Proof structure (the seams to cut along)

The target's current proof (read it on disk, §"The acyclic-resolution comparison
theorem", and the dimension-shift lemma just above it) runs:
`(RⁿG)(A) ≅ (R¹G)(Zⁿ⁻¹) ≅ coker(G(Jⁿ⁻¹)→G(Zⁿ)) ≅ Hⁿ(G(J•))` via a cosyzygy
staircase. Cut it into these leaves (names are suggestions — assign `\lean{}`
hints by convention and report them):

**Ingredient (a) — base-case cokernel iso (= part (2) of the dimension-shift lemma).**
Currently `lem:acyclic_dimension_shift` STATES two parts but its Lean decl
`rightDerivedShiftIsoOfAcyclic` formalizes only part (1). Split **part (2)** into
its OWN block with its OWN `\lean{}` name (suggest
`CategoryTheory.Functor.rightDerivedOneIsoCokerOfAcyclic` or similar): for a SES
`0 → A → J → Z → 0` with `J` right-`G`-acyclic,
`(R¹G)(A) ≅ coker(G(J) → G(Z))`. Proof: the low-degree segment of the
right-derived LES `G(J) → G(Z) →[δ⁰] (R¹G)(A) → (R¹G)(J)=0` is exact with
vanishing right end, so `δ⁰` is epi with kernel `im(G(J)→G(Z))`; hence `δ⁰`
identifies `coker(G(J)→G(Z)) ≅ (R¹G)(A)`. Build it as a SIBLING of the existing
`rightDerivedShiftIsoOfSplitResolutionSES` engine, reusing `homology_exact₂/₃` at
degrees 0,1 and `Functor.rightDerivedZeroIsoSelf` (`R⁰G ≅ G`). After splitting,
update `lem:acyclic_dimension_shift`'s block (remove the iter-006 `% NOTE: PARTIAL
COVERAGE` once part (2) has its own home, or repoint it) and its `\uses` so the
staircase target `\uses` the new part-(2) block by label. Keep
`lem:acyclic_dimension_shift`'s statement of part (1) and its `\lean{}` unchanged.

**Ingredient (b) — cosyzygy SES infrastructure.** For an acyclic resolution of
`A` (an exact `0 → A → J⁰ → J¹ → J² → ⋯` with each `Jⁿ` right-`G`-acyclic):
- `lem:cosyzygy_ses` — define the cosyzygies `Z⁰ := A`, `Zᵐ := ker(Jᵐ → Jᵐ⁺¹) =
  im(Jᵐ⁻¹ → Jᵐ)` for `m ≥ 1`, and prove that for every `m ≥ 0`
  `0 → Zᵐ → Jᵐ → Zᵐ⁺¹ → 0` is short exact (from exactness of the resolution),
  with middle term `Jᵐ` acyclic.
- `lem:cohomology_of_applied_resolution` — the left-exactness identifications:
  `H⁰(G(J•)) ≅ G(A)` (G left-exact applied to `0→A→J⁰→Z¹→0`), and for `n ≥ 1`
  `Hⁿ(G(J•)) ≅ coker(G(Jⁿ⁻¹) → G(Zⁿ))` (G left-exact applied to `(Sₙ)` identifies
  `G(Zⁿ) ↪ G(Jⁿ)` with `ker(G(Jⁿ)→G(Jⁿ⁺¹))`, so the cokernel of `G(Jⁿ⁻¹)→G(Zⁿ)`
  coincides with `ker(G(Jⁿ)→G(Jⁿ⁺¹))/im(G(Jⁿ⁻¹)→G(Jⁿ)) = Hⁿ(G(J•))`).

**Staircase assembly (rewritten target proof).** Compose part (1) of the
dimension shift down the staircase `(RⁿG)(A) ≅ (Rⁿ⁻¹G)(Z¹) ≅ ⋯ ≅ (R¹G)(Zⁿ⁻¹)`
(using `lem:acyclic_dimension_shift`(1) on `(S₀),…,(S_{n-2})`), then close with
ingredient (a) on `(S_{n-1})` giving `(R¹G)(Zⁿ⁻¹) ≅ coker(G(Jⁿ⁻¹)→G(Zⁿ))`, and
finally `lem:cohomology_of_applied_resolution` giving `≅ Hⁿ(G(J•))`; the `n=0`
case is the `H⁰ ≅ G(A) = (R⁰G)(A)` base. The target keeps its statement and
`\lean{}` unchanged; its proof becomes "by `lem:cosyzygy_ses`,
`lem:cohomology_of_applied_resolution`, `lem:acyclic_dimension_shift`(1), and the
part-(2) base case."

If any single leaf still looks too big to formalize in one prover step (in
particular the cosyzygy `Hⁿ` identification, which threads several left-exactness
facts), break it further now or flag it under "Still hard" for a finer re-break.

## Lean realization hint (for `\lean{}` naming only — you write MATH, not Lean)
The prover's suggested Lean input signature for the target is:
`J : CochainComplex 𝒜 ℕ`, `[∀ n, G.IsRightAcyclic (J.X n)]`, `A : 𝒜`,
`π : (single₀).obj A ⟶ J` with `[QuasiIso π]`, `G` additive + left-exact. This
`QuasiIso π` form is the Mathlib-idiomatic way to say "J• is a resolution of A";
it is equivalent to the exact sequence `0→A→J⁰→J¹→⋯` the blueprint writes. The
cosyzygy objects `Zᵐ` are realized via `HomologicalComplex` cycles / kernel
forks. You may keep the blueprint prose in the exact-sequence form; just note in
the report the suggested `\lean{}` names so the planner can scaffold them.

## Strategy context
This is the final leaf of phase P4 (the abstract acyclic-resolution comparison
engine, Route A). Once these leaves are built and the staircase assembled, P4 is
complete and the project pivots to the geometric phases P5a/P3/P5b. The target
`(RⁿG)(A) ≅ Hⁿ(G(J•))` is precisely what lets the Čech complex compute
`R^i f_*` in the final assembly.

## References
- `references/homological-acyclic-derived.tex`: Tag **015D**
  (`lemma-F-acyclic-ses`, the dimension-shift LES — the source of ingredient (a),
  already quoted verbatim in the `lem:acyclic_dimension_shift` block, L5619–5654);
  Tag **015E** (`lemma-leray-acyclicity`, the staircase, L5692–5705) and Prop
  **05TA** (`proposition-enough-acyclics`, L5785–5811) — both already quoted
  verbatim in the target block, including the `% SOURCE QUOTE PROOF:` that breaks
  the complex into the cosyzygy short exact sequences `0 → Jⁿ → Iⁿ⁺¹ → Jⁿ⁺¹ → 0`
  (ingredient (b)). Re-use the existing verbatim quotes when attaching citations
  to the new leaves; do NOT write any quote from memory. The chapter already
  carries these — split/copy the relevant fragment to each new block.
