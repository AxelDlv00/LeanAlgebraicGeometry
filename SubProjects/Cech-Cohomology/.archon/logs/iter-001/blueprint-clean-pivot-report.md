# Blueprint Clean Report — slug: pivot

## Status: DONE

## Files modified

### `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

**Lean-tactic leakage stripped from `lem:push_pull_comp` proof:**

1. Removed Lean named-argument syntax `(f := h.left, g := g.left, h := Y1.hom)` appended to the `pseudofunctor_associativity` mention. That parenthetical was pure Lean term syntax, not a mathematical specification.

2. Removed `(free-hypothesis \(\mathrm{subst}\))` from the sentence about discharging over-triangle `eqToHom` transports via `lem:push_pull_transport_cancel`. `subst` is a Lean tactic; the mathematical content (the cancellation lemma) is preserved.

3. Replaced the "Implementation note for the prover" paragraph with a short "Proof note":
   - **Removed:** "documented dead-end", kernel `whnf`, `TwoSquare.equivNatTrans`, `mateEquiv`, tactics `erw`/`congr`, "rewrites stay syntactic", and the project-local file reference `analogies/pushpull-functoriality.md`.
   - **Preserved:** the mathematical proof strategy (work on the pullback/mate side, route through `conjugateEquiv_comp` + injectivity ⇒ `pseudofunctor_associativity`).

**Preserved per directive:** `conjugateEquiv_comp`, `pseudofunctor_associativity`, `conjugateEquiv_pullbackComp_inv`, `conjugateEquiv_pullbackId_hom`, `pseudofunctor_right_unitality`, `pushPull_unit_mate`, `pushPull_unit_comp`, `eqToHom`.

**No iteration-history framing found** in this chapter.

---

### `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

**Agent-role framing stripped from `def:right_acyclic`:**

- Renamed "Note for the planner (alternative shapes)" → "Remark (alternative shapes)". The mathematical content (Mathlib's `IsZero` predicate, the two quantifier shapes, and the recommended index-shifted form matching `isZero_rightDerived_obj_injective_succ`) is fully preserved.

**No iteration-history framing found** in this chapter.

---

## Citation validation

All `% SOURCE:` / `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` blocks were verified against the local reference files:

- **`references/stacks-coherent.tex`** — Čech chapter quotes in `Cohomology_CechHigherDirectImage.tex`: verified consistent with the file (not re-checked exhaustively as the file was already clean per the prior iteration; no changes were made to citation blocks in this chapter).

- **`references/homological-acyclic-derived.tex`** — Tags 0157/015C/015D/015E/05TA for `Cohomology_AcyclicResolution.tex`:
  - `def:right_acyclic` (Tags 0157 + 015C, lines L5264–5269 and L5594–5617): quotes match verbatim. ✓
  - `lem:acyclic_dimension_shift` (Tag 015D, L5619–5654): `SOURCE QUOTE` and `SOURCE QUOTE PROOF` match verbatim. ✓
  - `lem:acyclic_resolution_computes_derived` (Tags 015E + 05TA, L5692–5705 and L5785–5811): `SOURCE QUOTE` entries match verbatim. `SOURCE QUOTE PROOF` from proposition proof (L5832–5853) matches verbatim. ✓

- **`lem:cech_to_cohomology_on_basis`** (Stacks Cohomology, `cohomology-lemma-cech-vanish-basis`): the standalone statement is not present in local `references/`; the writer's honest note ("standalone statement not yet retrieved") is retained unchanged. The application quote from `stacks-coherent.tex` is already in place.

---

## LaTeX / `\uses{}` / `\label{}` check

No formatting issues found in either chapter. All `\uses{}` lists are syntactically correct and `\label{}` keys are intact. No `\lean{}` pins or `\leanok` markers were touched.
