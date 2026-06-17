# Blueprint-writer directive --- RiemannRoch_WeilDivisor (iter-273, DAG 1-to-1 coverage)

## Goal of this dispatch

Close the **1-to-1 Lean<->blueprint coverage debt** for chapter
`blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`. The Lean file(s) for this chapter contain
helper declarations that are **proved sorry-free in Lean but have NO blueprint
entry** (no `\lean{}` points at them). `leandag` lists each as an uncovered
`lean-aux` node. Your job: add ONE blueprint block per uncovered declaration so
every Lean decl in this chapter has exactly one `\lean{}`-pinned blueprint
entry, **and wire each new block into the chapter's dependency cone** so it is
NOT an isolated node.

This chapter covers basic Weil-divisor vocabulary on a curve: order of a rational function at a prime divisor (homomorphism laws for product/inverse/power/one/zero), degree of a divisor (additivity, single, zero, neg, sub, positive-part), the principal divisor map, regular-in-codimension-one / DVR-stalk instances for the projective line, and ordFrac ring-equiv transport helpers.

## The uncovered declarations to cover (add one block each)

Each name below is the EXACT Lean declaration name. Pin it verbatim with
`\lean{<name>}`. NOTE: this chapter is on the permanently USER-paused Riemann--Roch route; these are stable off-critical-path helpers --- coverage is 1-to-1 hygiene only.

```
AlgebraicGeometry.Scheme.IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk
AlgebraicGeometry.Scheme.IsRegularInCodimensionOne.instKrullDimLEStalk
AlgebraicGeometry.Scheme.PrimeDivisor.ofOpen_point
AlgebraicGeometry.Scheme.PrimeDivisor.ordFrac_stalkIso_naturality
AlgebraicGeometry.Scheme.PrimeDivisor.restrictToOpen_point
AlgebraicGeometry.Scheme.RationalMap.order_inv
AlgebraicGeometry.Scheme.RationalMap.order_mul_of_ne_zero
AlgebraicGeometry.Scheme.RationalMap.order_neg
AlgebraicGeometry.Scheme.RationalMap.order_one
AlgebraicGeometry.Scheme.RationalMap.order_pow_of_ne_zero
AlgebraicGeometry.Scheme.RationalMap.order_units_inv
AlgebraicGeometry.Scheme.RationalMap.order_zero
AlgebraicGeometry.Scheme.WeilDivisor.degree_add
AlgebraicGeometry.Scheme.WeilDivisor.degree_hom_apply
AlgebraicGeometry.Scheme.WeilDivisor.degree_neg
AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_eq_sum_max
AlgebraicGeometry.Scheme.WeilDivisor.degree_single
AlgebraicGeometry.Scheme.WeilDivisor.degree_sub
AlgebraicGeometry.Scheme.WeilDivisor.degree_zero
AlgebraicGeometry.Scheme.WeilDivisor.instIsLocallyNoetherianProjectiveLineBar
AlgebraicGeometry.Scheme.WeilDivisor.isRegularInCodimOneProjectiveLineBar
AlgebraicGeometry.Scheme.WeilDivisor.one_le_degree_positivePart_principal_of_order_one
AlgebraicGeometry.Scheme.WeilDivisor.positivePart_single
AlgebraicGeometry.Scheme.WeilDivisor.positivePart_zero
AlgebraicGeometry.Scheme.WeilDivisor.principal_apply
AlgebraicGeometry.Scheme.WeilDivisor.principal_one
Finsupp.sum_max_zero_eq_sum_filter_pos
Ring.nonZeroDivisors_ringEquiv
Ring.ordFrac_ringEquiv
Ring.ordMonoidWithZeroHom_ringEquiv
Ring.ord_ringEquiv
```

## How to write each coverage block

1. **Read the Lean file(s)** for this chapter to get each declaration's exact
   signature and intent:
   - `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
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
   least one `\uses{}` edge in or out, connecting it into the chapter's divisor-degree and principal-divisor results. Determine
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

- Edit ONLY `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`.
- **Never add `\leanok`** --- the deterministic `sync_leanok` phase owns it.
- Every new block has exactly one `\lean{}`; no broken `\uses{}`; purely
  mathematical prose.
- Additive coverage plus REF cleanup only; do not delete/restate existing blocks.

## Report

List every block you added (label + `\lean{}` name), the `\uses{}` edges you
added to wire them in, how many literal-REF placeholders you fixed, and any decl
whose intent you could not determine from the Lean source (flag, do not
fabricate).
