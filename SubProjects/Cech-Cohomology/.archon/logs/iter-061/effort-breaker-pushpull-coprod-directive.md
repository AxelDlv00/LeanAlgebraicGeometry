# Effort-breaker directive — iter-061

## Target
`lem:pushPull_coprod_prod` in `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(the standalone indexed-coproduct→product disjoint-union module-sheaf decomposition; Lean build
target `AlgebraicGeometry.pushPull_coprod_prod`, ~200–400 LOC, not yet in Lean).

## Why
This is the single HARD new-infra leaf gating CSI Stub 2 (`lem:pushPull_sigma_iso`). The
progress-critic flagged that dispatching it as one ~200–400 LOC monolith reproduces the exact
multi-iter stall pattern that preceded the successful Stub-1 decomposition. Break it into named
sub-lemmas with stated types so the prover (mathlib-build mode) attacks small ready leaves.

## Granularity
Fine — one mathematical claim per lemma. Each sub-lemma must have its own `\label`, a `\lean{}`
naming the Lean declaration the prover will create (these are build targets; they do not exist
yet — pick clear `AlgebraicGeometry.*` names), an accurate `\uses{}`, and a textbook-rigorous
one-to-few-sentence informal proof.

## Proof structure to cut along
The statement: for a finite family `legs : ι → Over X` (finite `ι`) with structure map
`q = Sigma.desc (fun i => (legs i).hom) : (∐_i legs i).left ⟶ X`, the push–pull object
`pushPullObj F (Over.mk q) ≅ ∏_i pushPullObj F (legs i)` in `X.Modules`.

The proof has three genuinely distinct mathematical steps — make each a named sub-lemma:

1. **Reflection wrapper.** A morphism of `X.Modules` (sheaves of modules) is an isomorphism iff its
   image under `Scheme.Modules.toPresheaf` (the forgetful functor to presheaves of abelian groups,
   which is faithful, reflects isomorphisms, and preserves limits) is an isomorphism. So it suffices
   to exhibit the comparison as a presheaf-of-Ab isomorphism. (This is the "reduce to presheaf level"
   step; cite the Mathlib faithful/reflects-iso/preserves-limits facts for `toPresheaf`.)

2. **Binary disjoint-union base case.** For TWO legs (or, at the presheaf level, for a binary
   coproduct scheme `Y₀ ⊔ Y₁`), sections over any open decompose as the product of the two component
   traces: `coprodPresheafObjIso` (`lem:coprodPresheafObjIso_mathlib`) plus `isProductOfDisjoint`
   (`lem:isProductOfDisjoint_mathlib`) for the disjoint-inside-the-coproduct-space sheaf condition.
   State the binary push–pull product iso as its own lemma.

3. **Finite-index induction.** Iterate the binary decomposition over the finite index set `ι`
   (induct on a `Fintype`/`Finset` / via an equiv `ι ≃ Fin n`) to obtain the full indexed product.
   State the inductive assembly as its own lemma, `\uses`-linked to the base case (2) and the
   reflection wrapper (1).

If any of these three is itself still large after the split (especially the induction), say so in
your report so I can re-break it next; do not force a single-pass over-decomposition.

## Out of scope
- Do NOT edit `lem:pushPull_sigma_iso` (it already `\uses lem:pushPull_coprod_prod`; just keep that
  edge — if you re-home the content, ensure `pushPull_sigma_iso` still resolves).
- Do NOT touch any `.lean` file, any `\leanok` marker, or any other chapter.
- Keep the existing `lem:pushPull_coprod_prod` label resolvable for `pushPull_sigma_iso`'s `\uses`
  (either keep it as the top assembly node that `\uses` the new leaves, or repoint
  `pushPull_sigma_iso` to the new top node and report the change).
