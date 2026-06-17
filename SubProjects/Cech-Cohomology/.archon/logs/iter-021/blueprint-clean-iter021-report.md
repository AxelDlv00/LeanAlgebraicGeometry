# blueprint-clean report — iter-021

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Source-quote validation

Checked the two new nodes that carry `% SOURCE:`/`% SOURCE QUOTE:` blocks:

- **`lem:free_cech_engine`** — cites `references/stacks-cohomology.tex` L1245–1268
  (`lemma-homology-complex` region). Verified verbatim against the source file: the
  quoted text (differential formula + prepend-homotopy definition) matches exactly. ✓

- **`lem:cech_free_eval_engine_iso`** — cites `references/stacks-cohomology.tex`
  L1236–1251 (same region). Verified verbatim: the non-empty case description and
  differential formula match exactly. ✓

No source-quote blocks were found on the three bridge blocks
(`lem:cech_complex_op_identification`, `lem:section_cech_complex_mapop_iso`,
`lem:hom_into_injective_exact`) or the three section sub-lemmas
(`lem:section_cech_product_equiv`, `lem:section_cech_coface_match`,
`lem:section_cech_ab_exact`). These are project-built constructions; the relevant Stacks
source text for the section sub-lemmas is already quoted on the parent
`lem:section_cech_homology_exact`. No fabricated or missing quotes to fix.

## Lean-syntax leakage removed

Two Lean dot-accessor occurrences stripped from prose/formulae:

1. **`lem:section_cech_coface_match` formula** (was line 813):
   - Removed: `\mathcal{F}.\mathrm{map}\,(\text{restriction})^{\mathrm{op}}`
   - Replaced with: `\mathcal{F}(\operatorname{res}_j)`
   *(Lean `Functor.map` dot accessor → standard presheaf-applied-to-morphism notation.)*

2. **Proof of `lem:cech_free_eval_engine_iso`** (was line 1766):
   - Removed: `\operatorname{cechFreeSimplicial}.\mathrm{map}`
   - Replaced with: `\operatorname{cechFreeSimplicial}` (with "face action of" added for
     clarity)
   *(Lean `.map` field accessor → implicit functor action.)*

## Process verbosity removed

Four occurrences of "public free-side / project-internal" language stripped from rendered
prose (they belong in the `% NOTE:` comment, which was preserved untouched):

3. **`lem:cech_free_eval_prepend_homotopy` statement** — removed parenthetical
   "(the public free-side engine; the same prepend-…content as the affine vanishing
   Lemma~\ref{lem:cech_acyclic_affine}),"

4. **Proof of `lem:cech_free_eval_prepend_homotopy_spec`** — removed
   "(the public free-side copy of the affine port's bookkeeping)"

5. **Proof of `lem:cech_free_complex_quasi_iso`** — removed
   "(the public free-side copy of the engine used for the affine vanishing
   Lemma~\ref{lem:cech_acyclic_affine})"

6. **`lem:cech_complex_op_identification` statement** — removed "are project-internal but"
   from "The two drivers … are project-internal but carry the differential-matching
   content of this iso."

## Preserved

- The `% NOTE:` tradeoff comment at line 1628 (FreeCechEngine-vs-private-CombinatorialCech)
  is intact.
- All `\leanok` markers untouched.
- Mathematical content unchanged.
- The `:=` occurrences at former lines 2828 and 2955 are standard mathematical "let g :=
  f ∘ j" definitional notation, not Lean syntax; left in place.
