# Blueprint-writer directive --- RiemannRoch_OCofP (iter-273, DAG 1-to-1 coverage)

## Goal of this dispatch

Close the **1-to-1 Lean<->blueprint coverage debt** for chapter
`blueprint/src/chapters/RiemannRoch_OCofP.tex`. The Lean file(s) for this chapter contain
helper declarations that are **proved sorry-free in Lean but have NO blueprint
entry** (no `\lean{}` points at them). `leandag` lists each as an uncovered
`lean-aux` node. Your job: add ONE blueprint block per uncovered declaration so
every Lean decl in this chapter has exactly one `\lean{}`-pinned blueprint
entry, **and wire each new block into the chapter's dependency cone** so it is
NOT an isolated node.

This chapter covers the line bundle O_C(P) at a closed point: its carrier set/submodule subfunctor, global-sections characterisation, the h0-h1=2 computation, local-lift and trivialisation helpers, and algebra-over-function-field instances.

## The uncovered declarations to cover (add one block each)

Each name below is the EXACT Lean declaration name. Pin it verbatim with
`\lean{<name>}`. NOTE: this chapter is on the permanently USER-paused Riemann--Roch route; these are stable off-critical-path helpers --- coverage is 1-to-1 hygiene only.

```
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.algebraMap_bijective_of_finite_isDomain_isAlgClosed
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierSet
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierSet_mono
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierSubmodule
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierSubmoduleSheaf_le
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierTypeSubfunctor
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.exists_nonconstant_rational_from_dim_eq_two
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.functionField_localUnit_of_orderZero_at_primeDivisor
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff_mp
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.h0_sub_h1_lineBundleAtClosedPoint_eq_two
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.instAlgebraKbarFunctionField
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.instNonemptyTopOpen
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.localLift_of_log_ordFrac_eq_zero
AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.trivAtBot
```

## How to write each coverage block

1. **Read the Lean file(s)** for this chapter to get each declaration's exact
   signature and intent:
   - `AlgebraicJacobian/RiemannRoch/OCofP.lean`
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
   least one `\uses{}` edge in or out, connecting it into the chapter's O_C(P) global-sections / Riemann--Roch-at-a-point results. Determine
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

- Edit ONLY `blueprint/src/chapters/RiemannRoch_OCofP.tex`.
- **Never add `\leanok`** --- the deterministic `sync_leanok` phase owns it.
- Every new block has exactly one `\lean{}`; no broken `\uses{}`; purely
  mathematical prose.
- Additive coverage plus REF cleanup only; do not delete/restate existing blocks.

## Report

List every block you added (label + `\lean{}` name), the `\uses{}` edges you
added to wire them in, how many literal-REF placeholders you fixed, and any decl
whose intent you could not determine from the Lean source (flag, do not
fabricate).
