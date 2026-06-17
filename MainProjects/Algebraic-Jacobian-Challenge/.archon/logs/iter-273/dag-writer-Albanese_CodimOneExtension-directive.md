# Blueprint-writer directive --- Albanese_CodimOneExtension (iter-273, DAG 1-to-1 coverage)

## Goal of this dispatch

Close the **1-to-1 Lean<->blueprint coverage debt** for chapter
`blueprint/src/chapters/Albanese_CodimOneExtension.tex`. The Lean file(s) for this chapter contain
helper declarations that are **proved sorry-free in Lean but have NO blueprint
entry** (no `\lean{}` points at them). `leandag` lists each as an uncovered
`lean-aux` node. Your job: add ONE blueprint block per uncovered declaration so
every Lean decl in this chapter has exactly one `\lean{}`-pinned blueprint
entry, **and wire each new block into the chapter's dependency cone** so it is
NOT an isolated node.

This chapter covers the codimension-one rational-map extension machinery: standard-smooth presentations, Kaehler-differential freeness, cotangent-space finrank computations, Krull-dimension/height of localizations of MvPolynomial rings, regular-sequence collapse, and the principal/codim-1 maximal ideal step.

## The uncovered declarations to cover (add one block each)

Each name below is the EXACT Lean declaration name. Pin it verbatim with
`\lean{<name>}`. These are stable substrate helpers under an already-blueprinted public API.

```
AlgebraicGeometry.Scheme.MvPolynomial.maximalIdeal_height_eq_card
AlgebraicGeometry.Scheme.MvPolynomial.maximalIdeal_height_eq_natCard
AlgebraicGeometry.Scheme.MvPolynomial.maximalIdeal_height_ge_card_of_field
AlgebraicGeometry.Scheme.MvPolynomial.maximalIdeal_height_le_natCard_of_field
AlgebraicGeometry.Scheme.RationalMap.isClosed_indeterminacyLocus
AlgebraicGeometry.Scheme.cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue
AlgebraicGeometry.Scheme.exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth
AlgebraicGeometry.Scheme.exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth
AlgebraicGeometry.Scheme.exists_isStandardSmooth_at_of_smooth
AlgebraicGeometry.Scheme.exists_submersivePresentation_of_isStandardSmoothOfRelativeDimension
AlgebraicGeometry.Scheme.finrank_cotangentSpace_of_bijective_algebraMap_residue
AlgebraicGeometry.Scheme.finrank_cotangentSpace_of_formallySmooth_residue
AlgebraicGeometry.Scheme.finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq
AlgebraicGeometry.Scheme.finrank_residueField_tensor_kaehlerDifferential_of_isStandardSmoothOfRelativeDimension
AlgebraicGeometry.Scheme.gammaSpecField_ringEquiv
AlgebraicGeometry.Scheme.isLocalization_atPrime_stalk_of_affineOpen
AlgebraicGeometry.Scheme.isRegular_cons_of_quotient_ring
AlgebraicGeometry.Scheme.matsumura_descent_cotangent
AlgebraicGeometry.Scheme.matsumura_isRegular_of_linearIndependent_cotangent
AlgebraicGeometry.Scheme.module_free_kaehlerDifferential_of_isStandardSmooth
AlgebraicGeometry.Scheme.open_eq_top_of_subsingleton
AlgebraicGeometry.Scheme.quotSMulTop_quotientRing_linearEquiv
AlgebraicGeometry.Scheme.ringKrullDim_localization_atMaximal_MvPolynomial
AlgebraicGeometry.Scheme.ringKrullDim_localization_eq_height_atPrime
AlgebraicGeometry.Scheme.ringKrullDim_quotient_add_eq_of_regular_sequence
AlgebraicGeometry.Scheme.ringKrullDim_quotient_localization_MvPolynomial_of_regular
AlgebraicGeometry.Scheme.smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot
AlgebraicGeometry.Scheme.stalkMap_flat_of_smooth
AlgebraicGeometry.Scheme.submersivePresentation_relation_cotangent_mk_linearIndependent
AlgebraicGeometry.Scheme.submersivePresentation_relation_cotangent_mk_linearIndependent_localized
```

## How to write each coverage block

1. **Read the Lean file(s)** for this chapter to get each declaration's exact
   signature and intent:
   - `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
   Open them and read the signature + docstring of each listed decl so your
   informal statement is FAITHFUL (right hypotheses, right conclusion). Do not
   guess from the name alone.

2. For each declaration, add a `\begin{lemma}` (or `\begin{definition}` for a
   `def`/`instance`/`structure`, `\begin{theorem}` only for a headline result)
   with:
   - a `\label{}` following the chapter's existing kebab convention;
   - `\lean{<exact Lean name>}` --- pinned EXACTLY ONCE across the whole
     blueprint (do not duplicate a pin that already exists elsewhere);
   - a **one-to-three sentence** mathematical statement in prose (no Lean
     syntax, no tactic blocks --- DAG integrity rule 7);
   - a proof block: since every listed decl is already proved sorry-free in
     Lean, write `\begin{proof} Proved directly in Lean. \end{proof}` (or one
     extra clause naming the parent result it is a sub-step of). These are
     internal helper lemmas; an external `% SOURCE` citation is NOT required
     unless the helper literally restates a Mathlib result, in which case make
     it a `\mathlibok` Mathlib dependency anchor instead (pin the real Mathlib
     `\lean{}` name and add `\mathlibok`).

3. **WIRING IS MANDATORY --- no new isolated nodes.** Each new block must have at
   least one `\uses{}` edge in or out, connecting it into the chapter's public results (e.g. \cref{thm:codim_one_extension} and the smooth-curve regular-local-DVR results). Determine
   the real call graph from the Lean source: if helper H is used in the Lean
   proof of an already-blueprinted result T, then add `H` to T's `\uses{}`
   (preferred), and/or have H `\uses{}` the sub-lemmas its own Lean proof
   calls. End state: the chapter's public result transitively `\uses{}` all
   these helpers, so none is isolated. Do NOT dump edgeless "proved in Lean"
   blocks --- that trades uncovered-lean-aux for isolated-blueprint, equally
   incomplete.

4. **Fix literal `REF` placeholders in THIS chapter** while you are here:
   replace any literal "Theorem~REF", "Lemma~REF", "Definition~REF", etc. in the
   prose with a real `\cref{<label>}` (surrounding `\uses{}`/context usually
   identifies the target). If you genuinely cannot identify the target, rephrase
   to remove the dangling reference rather than leave a literal `REF`.

## Hard constraints

- Edit ONLY `blueprint/src/chapters/Albanese_CodimOneExtension.tex`.
- **Never add `\leanok`** --- the deterministic `sync_leanok` phase owns it.
- Every new block has exactly one `\lean{}`; no broken `\uses{}`; purely
  mathematical prose.
- Additive coverage plus REF cleanup only; do not delete/restate existing blocks.

## Report

List every block you added (label + `\lean{}` name), the `\uses{}` edges you
added to wire them in, how many literal-REF placeholders you fixed, and any decl
whose intent you could not determine from the Lean source (flag, do not
fabricate).
