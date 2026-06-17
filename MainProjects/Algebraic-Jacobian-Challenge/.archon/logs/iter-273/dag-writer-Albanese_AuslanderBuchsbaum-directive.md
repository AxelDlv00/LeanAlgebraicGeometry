# Blueprint-writer directive --- Albanese_AuslanderBuchsbaum (iter-273, DAG 1-to-1 coverage)

## Goal of this dispatch

Close the **1-to-1 Lean<->blueprint coverage debt** for chapter
`blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`. The Lean file(s) for this chapter contain
helper declarations that are **proved sorry-free in Lean but have NO blueprint
entry** (no `\lean{}` points at them). `leandag` lists each as an uncovered
`lean-aux` node. Your job: add ONE blueprint block per uncovered declaration so
every Lean decl in this chapter has exactly one `\lean{}`-pinned blueprint
entry, **and wire each new block into the chapter's dependency cone** so it is
NOT an isolated node.

This chapter covers the Auslander--Buchsbaum / Cohen--Macaulay depth machinery (regular local ring => depth >= dim, Ext-vanishing, regular-sequence and matrix/Koszul decomposition helpers) supporting the codim-1 extension argument.

## The uncovered declarations to cover (add one block each)

Each name below is the EXACT Lean declaration name. Pin it verbatim with
`\lean{<name>}`. These are stable substrate helpers under an already-blueprinted public API.

```
AlgebraicGeometry.Scheme.PrimeDivisor.ext
RingTheory.CohenMacaulay.exists_isRegular_of_regularLocal
RingTheory.CohenMacaulay.exists_isSMulRegular_notMemSq_of_regularLocal_succ
RingTheory.CohenMacaulay.exists_isSMulRegular_quotient_isRegularLocal_succ
RingTheory.CohenMacaulay.exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes
RingTheory.CohenMacaulay.exists_notMemSq_of_spanFinrank_pos
RingTheory.CohenMacaulay.finrank_cotangentSpace_quot_span_singleton_succ
RingTheory.CohenMacaulay.isDomain_of_isLocalRing_of_spanFinrank_maximalIdeal_eq_zero
RingTheory.CohenMacaulay.isDomain_of_regularLocal
RingTheory.CohenMacaulay.length_le_ringKrullDim_of_isRegular
RingTheory.CohenMacaulay.notMem_minimalPrimes_of_regularLocal_succ
RingTheory.CohenMacaulay.regularLocal_inductive_step
RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq
RingTheory.CohenMacaulay.toCotangent_ne_zero_of_not_mem_sq
RingTheory.Module.depth_eq_of_linearEquiv
RingTheory.Module.depth_pi_const_eq_depth_of_nonempty
RingTheory.Module.depth_ses_ineqs_of_surjection_finite_localRing
RingTheory.Module.elemMap
RingTheory.Module.elemMap_apply
RingTheory.Module.exists_isSMulRegular_of_one_le_depth
RingTheory.Module.exists_ne_zero_ext_of_depth_eq
RingTheory.Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator
RingTheory.Module.ext_smul_eq_zero_of_mem_annihilator
RingTheory.Module.ext_vanish_of_natCast_lt_depth
RingTheory.Module.ideal_smul_top_pi_const
RingTheory.Module.ideal_smul_top_pi_const_eq_top_iff
RingTheory.Module.isRegular_pi_const_iff_of_nonempty
RingTheory.Module.linearMap_finFunR_matrix_decomp
RingTheory.Module.natCast_add_one_le_of_le_sub_one
RingTheory.Module.quotSMulTopPiConstLinearEquiv
RingTheory.enat_ab_inductive_combine
RingTheory.projectiveDimension_ker_eq_of_surjection
```

## How to write each coverage block

1. **Read the Lean file(s)** for this chapter to get each declaration's exact
   signature and intent:
   - `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
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
   least one `\uses{}` edge in or out, connecting it into the chapter's public results (e.g. \cref{thm:auslander_buchsbaum}, the depth/projective-dimension lemmas, and the regular-local => Cohen--Macaulay corollary). Determine
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

- Edit ONLY `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`.
- **Never add `\leanok`** --- the deterministic `sync_leanok` phase owns it.
- Every new block has exactly one `\lean{}`; no broken `\uses{}`; purely
  mathematical prose.
- Additive coverage plus REF cleanup only; do not delete/restate existing blocks.

## Report

List every block you added (label + `\lean{}` name), the `\uses{}` edges you
added to wire them in, how many literal-REF placeholders you fixed, and any decl
whose intent you could not determine from the Lean source (flag, do not
fabricate).
