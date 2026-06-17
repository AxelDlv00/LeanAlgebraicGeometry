# Effort-breaker directive — decompose the free-complex quasi-iso

## Target
`lem:cech_free_complex_quasi_iso` in `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(`\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}`, target type `QuasiIso (cechFreeComplexAug 𝒰)`).

This is the single largest remaining combinatorial build in the project (the per-`V` sectionwise
contracting homotopy, ~20 declarations). It must be split into a `\uses`-linked chain of smaller
sub-lemmas, each with its own statement, informal proof, and `\uses`, so a prover can formalize the
pieces bottom-up this iteration.

## Granularity
One level (the proof's main steps). If a resulting sub-lemma is still clearly a multi-decl build
(the prepend homotopy + its `dh+hd=id` identity), give that one a slightly finer internal break
(separate the homotopy *definition* sub-lemma from the *identity* sub-lemma).

## Chosen route — DECIDED, decompose along it
**Route (a): direct sectionwise prepend homotopy at the ModuleCat level**, mirroring the chapter's
existing proof prose and the already-proved `AlgebraicGeometry.CombinatorialCech.combHomotopy` /
`combHomotopy_spec` (`dh+hd=id`) in `CechAcyclic.lean`. Package the sectionwise homotopy as a
`HomologicalComplex.Homotopy`, obtain a `HomotopyEquiv` to `O_𝒰(V)[0]`, conclude `QuasiIso` per `V`,
then lift objectwise. Route (b) (`SimplicialObject.Augmented.ExtraDegeneracy` à la
`Rep.standardComplex`) is the documented fallback only — do NOT decompose along it; mention it in one
sentence as an alternative but build the `\uses` chain for route (a).

## Proof structure to cut along (from the iter-019 prover handoff, verified)
The named target is reached by:

1. **Objectwise reduction (already built — make it an explicit `\uses` dep, not a new sub-lemma).**
   `AlgebraicGeometry.quasiIso_of_evaluation` (already in `FreePresheafComplex.lean`, public) reduces
   `QuasiIso (cechFreeComplexAug 𝒰)` to: for every open `V`, the evaluation
   `((PresheafOfModules.evaluation X.ringCatSheaf.obj V).mapHomologicalComplex _).map (cechFreeComplexAug 𝒰)`
   is a quasi-isomorphism. Add a blueprint block for `quasiIso_of_evaluation` (it is currently an
   unmatched helper) and make `lem:cech_free_complex_quasi_iso` `\uses` it.

2. **Sectionwise description of the evaluated complex.** For fixed `V`, with
   `I₁ := {i : V ≤ coverOpen 𝒰 i}`: `(evaluation V).obj (freeYoneda.obj W) = O_X(V)` if `V ≤ W`, else
   `0` (poset hom-set subsingleton); so the degree-`p` term evaluates to `⊕_{σ : Fin(p+1)→I, V≤U_σ} O_X(V)`
   = the combinatorial Čech complex of the full simplex on `I₁` with coefficients `O_X(V)`, and the
   augmentation target evaluates to `O_𝒰(V) = O_X(V)` if `I₁ ≠ ∅`, else `0`. Lean entry point:
   `cechFreePresheafComplex_X` (degreewise unfolding, already in the file) + `PresheafOfModules.evaluation`.

3. **Case split `I₁ = ∅` vs `I₁ ≠ ∅`.**
   - `I₁ = ∅`: every summand vanishes (no `σ : Fin(p+1)→I` lands in `∅`); source complex `= 0` and
     `O_𝒰(V) = 0`; the augmentation is `0 → single₀ 0`, a quasi-iso of zero objects.
   - `I₁ ≠ ∅`: fix `i_fix ∈ I₁`; the prepend homotopy `h(s)_{i₀…i_{p+1}} = (i₀ = i_fix)·s_{i₁…i_{p+1}}`
     contracts the augmented complex.

4. **Prepend homotopy (the hard core — give this its own sub-lemma(s)).** Define the degreewise
   `O_X(V)`-linear maps `h_p : K_p(V) → K_{p+1}(V)` (as `Sigma.desc` / `LinearMap` over the `I₁`-indexed
   direct sum), then prove `d ∘ h + h ∘ d = id` (the same alternating-sum computation as
   `CombinatorialCech.combHomotopy_spec`). Package as `HomologicalComplex.Homotopy` between `id` and `0`
   on the augmented complex ⇒ `HomotopyEquiv` of `K(𝒰)_•(V)` with `O_𝒰(V)[0]` ⇒ `QuasiIso`
   (`Homotopy.toQuasiIso` / `HomotopyEquiv.toQuasiIso`).

## Lean API pathway to name in the sub-lemma sketches (this addresses the must-fix)
The iter-019 lean-vs-blueprint-checker flagged the current proof sketch as under-specified because it
omits the Lean packaging pathway. Each sub-lemma's informal proof must name the relevant Lean tool:
`HomologicalComplex.Homotopy`, `Homotopy.toQuasiIso` (or `HomotopyEquiv.toQuasiIso` /
`QuasiIso.ofHomotopyEquiv`), `quasiIso_of_evaluation` as the objectwise-reduction entry point,
`cechFreePresheafComplex_X` as the degree-`p` unfolding entry point, and an explicit pointer to
`CombinatorialCech.combHomotopy` / `combHomotopy_spec` in `CechAcyclic.lean` as the combinatorial
content to port. Keep these as prose pointers (named Lean declarations), NOT tactic blocks.

## Source
The chapter already carries the verbatim `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` from Stacks
Cohomology `lemma-homology-complex` (references/stacks-cohomology.tex L1198–1284). Reuse the existing
quotes; attach the relevant fragment to each sub-lemma. Do not invent new citations.

## Out of scope
- Do NOT touch other blocks' `\lean{}` lists (coverage-debt bundling is a separate writer pass).
- Do NOT add `\leanok` (deterministic sync owns it). You MAY add `\mathlibok` only on genuine Mathlib
  anchors (e.g. `Homotopy.toQuasiIso` if you choose to anchor it) — not on project sub-lemmas.
- Keep statements in project notation; no Lean tactics in proofs.
