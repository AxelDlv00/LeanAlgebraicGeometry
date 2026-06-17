# Blueprint Writer Directive

## Slug
grquot-functor-coherence

## Target chapter
blueprint/src/chapters/Picard_GrassmannianQuot.tex

## Strategy context
This chapter covers the tautological-quotient / Grassmannian-functor construction. Two proved Lean
helper lemmas in the "functor coherence" section currently have no blueprint entry, breaking the
project's 1-to-1 Lean ↔ blueprint correspondence. Both are sibling coherence lemmas of the existing
`lem:gr_pullbackObjUnitToUnit_comp` / `lem:gr_pullbackFreeIso_id` blocks. Add the two missing
entries and wire their existing consumers. No new mathematics; both are proved sorry-free in
`GrassmannianQuot.lean`.

## Required content

1. **New lemma block: `homEquiv_conjugateEquiv_app` (adjunction mate / conjugate compatibility).**
   - `\label{lem:gr_homEquiv_conjugateEquiv_app}`
   - `\lean{AlgebraicGeometry.Scheme.Modules.homEquiv_conjugateEquiv_app}`
   - `\uses{}`: the Mathlib conjugate-equivalence / adjunction `homEquiv` results it rests on. If a
     suitable Mathlib anchor label already exists in another chapter (e.g. a `conjugateEquiv`
     anchor), `\uses{}` it; otherwise leave `\uses{}` empty and rely on the incoming edge below —
     do NOT fabricate a Mathlib anchor label.
   - Place it next to `lem:gr_pullbackObjUnitToUnit_id` / before `lem:gr_pullbackObjUnitToUnit_comp`.
   - Statement (project / categorical notation, no Lean): Given two adjunctions
     `L₁ ⊣ R₁` and `L₂ ⊣ R₂` between categories `𝒞, 𝒟`, a natural transformation `α : L₂ ⟶ L₁`,
     objects `c ∈ 𝒞`, `d ∈ 𝒟`, and a morphism `f : L₁ c ⟶ d`, the adjunction transpose satisfies
     `(adj₂.homEquiv) (α_c ≫ f) = (adj₁.homEquiv) f ≫ (conjugateEquiv adj₁ adj₂ α)_d`, where
     `conjugateEquiv` is the mate/conjugate of `α` on the right adjoints.
   - Proof sketch (two lines): expand both transposes by the unit formula
     `homEquiv f = unit ≫ R(f)` and use the defining relation of the conjugate
     `conjugateEquiv adj₁ adj₂ α` (its unit characterization), then chain the resulting
     whiskering identities. Project-bespoke (Archon-original packaging of Mathlib mate calculus) —
     NO external source citation block.

2. **Wire the consumer.** The block `lem:gr_pullbackObjUnitToUnit_comp` (around line 881) uses this
   lemma in its proof. Add `lem:gr_homEquiv_conjugateEquiv_app` to its `\uses{}` (statement and/or
   proof line, matching the chapter's convention).

3. **New lemma block: `pullbackFreeIso_comp` (composite free-pullback coherence).**
   - `\label{lem:gr_pullbackFreeIso_comp}`
   - `\lean{AlgebraicGeometry.Scheme.Modules.pullbackFreeIso_comp}`
   - `\uses{def:modules_pullbackComp, lem:gr_pullbackFreeIso}` (the free-pullback iso and the
     pullback-composition iso it relates; both already labelled in this chapter).
   - Place it immediately after `lem:gr_pullbackFreeIso_id` (around line 862).
   - Statement (project notation, no Lean): For schemes `Tx, Ty, Tz`, morphisms `a : Ty ⟶ Tx`,
     `b : Tz ⟶ Ty`, and an index type `I`, the canonical free-pullback comparison isomorphisms are
     coherent with the pullback-composition isomorphism on the free module `𝒪_{Tx}^{(I)}`: the
     composite `(pullbackComp b a) ▸ pullbackFreeIso (b ≫ a)` equals
     `(pullback b)(pullbackFreeIso a) ≫ pullbackFreeIso b` (i.e. pulling a free module back along
     `b ≫ a` agrees with pulling back along `a` then `b`).
   - Proof sketch (two lines): both sides are maps out of a coproduct (the free cofan on `I`), so it
     suffices to check on each coproduct injection (`Cofan.IsColimit.hom_ext`); on the `i`-th
     injection both reduce, via naturality of the pullback-composition comparison and the
     free-cofan comparison maps, to the same morphism. Project-bespoke — NO external source citation.

4. **Wire the consumer.** The block `def:grassmannian_functor` (around line 912) uses this lemma in
   establishing functoriality. Add `lem:gr_pullbackFreeIso_comp` to its `\uses{}`.

## Out of scope
- Do NOT touch any other block (glue chain, cells, chart, representability).
- Do NOT add `\leanok`. Do NOT invent Mathlib anchor labels — if unsure a `conjugateEquiv` anchor
  exists, leave the `\uses{}` lighter and flag it under "Notes for Plan Agent".

## References
None — both are project-bespoke coherence lemmas already proved in the Lean file.

## Expected outcome
Two new lemma blocks (`lem:gr_homEquiv_conjugateEquiv_app`, `lem:gr_pullbackFreeIso_comp`) pinned to
their Lean decls and wired to their consumers, so both decls leave the uncovered-Lean list and both
lie in the functor's dependency cone.
