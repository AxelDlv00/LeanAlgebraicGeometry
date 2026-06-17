# Blueprint Review Report

## Slug
grcells-rereview

## Iteration
011

---

## Scope

Scoped fast-path re-review of `blueprint/src/chapters/Picard_GrassmannianCells.tex` only,
per directive. The question: does the new 7-step matrix-algebra chain plus 5 `\mathlibok`
anchors satisfy the HARD GATE for dispatching a `mathlib-build` prover at the bottom leaves
this iter?

---

## Tool runs

- `leandag build --json` — `unknown_uses: []`, 2 isolated nodes (1 blueprint, 1 lean_aux)
- `archon blueprint-doctor --json` — `malformed_refs: []`, `broken_refs: []`
- `leandag query --isolated --json` — identified both isolated nodes
- `leandag query --unproved --json` — 15 unproved nodes in this chapter confirmed

---

## Top-level summaries

### Dependency & isolation findings

- `Picard_GrassmannianCells.tex` / `lem:mathlib_isUnit_iff_isUnit_det`: isolated blueprint
  node (`rdep_count: 0`, `dep_count: 0`). Confirmed genuine Mathlib declaration
  (`Matrix.isUnit_iff_isUnit_det : IsUnit A ↔ IsUnit A.det`,
  `Mathlib.LinearAlgebra.Matrix.NonsingularInverse`). The current proof chain does not use
  the biconditional form — `lem:gr_minorDet_unit` flows directly to `lem:mathlib_nonsing_inv_mul`
  / `lem:mathlib_mul_nonsing_inv` without going through the `IsUnit A` direction.
  **Disposition: remove** — the anchor is orphaned scaffolding. Authorize a writer to
  delete it from the chapter. (This is a **soon** finding; it does not block the
  `mathlib-build` dispatch.)

- `lean:AlgebraicGeometry.base_change_mate_generator_trace_eq`: lean_aux isolated node from
  `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — out of scope for this review; noted
  for completeness. **Disposition: keep** (Lean helper without blueprint entry, separate file).

### Lean difficulty quality

- `Picard_GrassmannianCells.tex` / `lem:gr_universalMinorInv_identities` /
  `\lean{AlgebraicGeometry.Grassmannian.universalMinorInv_mul_cancel}`: the `% LEAN SIGNATURE`
  says "A conjunction (or pair of lemmas)". If the prover splits into two lemmas
  (`universalMinorInv_mul_cancel` and a second), only the named one gets blueprint tracking.
  The spec should commit to one form. **Disposition: soon** — flag for a writer to clarify
  before this node enters active prover work; does not block the bottom-leaf dispatch.

---

## `\mathlibok` Anchor Faithfulness Audit

All 5 anchors verified via `lean_leanfinder` against Mathlib:

| Label | `\lean{}` | Mathlib path | Form match |
|---|---|---|---|
| `lem:mathlib_away_algebraMap_isUnit` | `IsLocalization.Away.algebraMap_isUnit` | `Mathlib.RingTheory.Localization.Away.Basic` | `IsUnit ((algebraMap R S) x)` for `[IsLocalization.Away x S]` — **matches** |
| `lem:mathlib_isUnit_iff_isUnit_det` | `Matrix.isUnit_iff_isUnit_det` | `Mathlib.LinearAlgebra.Matrix.NonsingularInverse` | `IsUnit A ↔ IsUnit A.det` — **matches** (but isolated, see above) |
| `lem:mathlib_nonsing_inv_mul` | `Matrix.nonsing_inv_mul` | `Mathlib.LinearAlgebra.Matrix.NonsingularInverse` | `IsUnit A.det → A⁻¹ * A = 1` — **matches** |
| `lem:mathlib_mul_nonsing_inv` | `Matrix.mul_nonsing_inv` | same | `IsUnit A.det → A * A⁻¹ = 1` — **matches** |
| `lem:mathlib_away_lift` | `IsLocalization.Away.lift` | `Mathlib.RingTheory.Localization.Away.Basic` | `(x : R) → [IsLocalization.Away x S] → {g : R →+* P} → IsUnit (g x) → S →+* P` — **matches** |

No fabricated or over-stated `\mathlibok` anchors. All 5 are genuine re-exports.

---

## Bottom-leaf spec audit (the dispatch targets)

Nodes the directive names as dispatch targets, in dependency order:

### `def:gr_universal_matrix`
- `\lean{AlgebraicGeometry.Grassmannian.universalMatrix}` — clear, formalizable
- `% LEAN SIGNATURE`: `universalMatrix d r I : Matrix (Fin d) (Fin r) R^I` with
  explicit entry formula (identity columns for `q ∈ I` via `orderIso`, indeterminate
  `MvPolynomial.X (p, ⟨q, hq⟩)` for `q ∉ I`). Unambiguous.
- `\uses{def:gr_affine_chart}` — `def:gr_affine_chart` has `\leanok`. Edge correct.
- Source: Nitsure §1 with verbatim French-language quote (original language). **PASS**

### `def:gr_minor_det`
- `\lean{AlgebraicGeometry.Grassmannian.minorDet}` — clear
- `% LEAN SIGNATURE`: `minorDet d r I J : R^I` as
  `(universalMatrix d r I).submatrix id (orderIso J) |>.det`. Precise.
- `\uses{def:gr_universal_matrix}` — correct.
- Source: Nitsure §1 verbatim. **PASS**

### `def:gr_universal_minor`
- `\lean{AlgebraicGeometry.Grassmannian.universalMinor}` — clear
- `% LEAN SIGNATURE`:
  `universalMinor d r I J : Matrix (Fin d) (Fin d) (Localization.Away (minorDet d r I J))`
  as `((universalMatrix d r I).submatrix id (orderIso J)).map (algebraMap _ _)`. Precise.
- `\uses{def:gr_universal_matrix, def:gr_minor_det}` — both reachable. Correct.
- Source: Nitsure §1 verbatim. **PASS**

### `lem:gr_minorDet_unit`
- `\lean{AlgebraicGeometry.Grassmannian.isUnit_det_universalMinor}` — clear
- `% LEAN SIGNATURE`: `isUnit_det_universalMinor d r I J : IsUnit (universalMinor d r I J).det`.
  Clean 1-line type.
- Proof: det of the universal minor equals the image of `P^I_J` under the structure map;
  since `R^I_J` is the away-localisation at `P^I_J`, that image is a unit by
  `lem:mathlib_away_algebraMap_isUnit`. One-step, complete, machine-checkable.
- `\uses{def:gr_universal_minor, def:gr_minor_det, lem:mathlib_away_algebraMap_isUnit}` in
  both statement and proof blocks. All labels resolve. **PASS**

### `def:gr_universalMinorInv`
- `\lean{AlgebraicGeometry.Grassmannian.universalMinorInv}` — clear
- `% LEAN SIGNATURE`: `universalMinorInv d r I J := (universalMinor d r I J)⁻¹`. Uses
  Mathlib `Matrix.nonsing_inv` (total function). No proof obligation at definition time.
- `\uses{def:gr_universal_minor}` — correct (the definition only wraps the minor in `⁻¹`).
- Note: `lem:gr_minorDet_unit` is intentionally not in `\uses{}` here — Lean's
  `Matrix.nonsing_inv` is total, so no proof is needed in the type. **PASS**

### Higher nodes (not the immediate dispatch target, but in scope)

`lem:gr_universalMinorInv_identities` — proof is complete and correct; `\uses{}` covers all
four dependencies. The "pair of lemmas" ambiguity is noted as a **soon** finding above.

`def:gr_image_matrix`, `def:gr_transition_pre`, `lem:gr_transition_pre_unit`,
`def:gr_transition`, `lem:gr_transition_self`, `lem:gr_cocycle`,
`def:gr_glued_scheme`, `lem:gr_separated`, `lem:gr_proper` — all carry full `% LEAN SIGNATURE`
comments, complete informal proofs (or clear definitional content), `\textit{Source:}` lines,
verbatim source quotes, and resolved `\uses{}` edges. No issues found.

---

## Per-chapter

### blueprint/src/chapters/Picard_GrassmannianCells.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:mathlib_isUnit_iff_isUnit_det` is isolated (nothing uses it). **remove** (soon) — it is
    a valid Mathlib anchor but the current chain does not require the biconditional form.
  - `lem:gr_universalMinorInv_identities` `% LEAN SIGNATURE` says "a conjunction (or pair of
    lemmas)" — the single `\lean{}` hint will only track one. **soon** — writer should commit to
    one name or two separate `\lean{}` entries before this node enters active prover work.

---

## Severity summary

- **must-fix-this-iter**: none
- **soon**:
  - `lem:mathlib_isUnit_iff_isUnit_det` isolated; no chain dependency. remove disposition.
  - `lem:gr_universalMinorInv_identities` spec ambiguity ("conjunction or pair of lemmas").
    Resolve before formalizing this node.
- **informational**: none

---

## Gate verdict

**GATE CLEARS for the bottom-leaf `mathlib-build` dispatch.**

The foundational leaves `def:gr_universal_matrix`, `def:gr_minor_det`,
`def:gr_universal_minor`, `lem:gr_minorDet_unit`, `def:gr_universalMinorInv` are all fully
specified: each carries an unambiguous `% LEAN SIGNATURE`, a rigorous informal statement,
correct and complete `\uses{}` edges (zero broken references per `leandag`), and faithful
`\mathlibok` anchors for all 5 Mathlib dependencies. A `mathlib-build` prover may be
dispatched this iter to scaffold and build these declarations.

The two "soon" findings (`lem:mathlib_isUnit_iff_isUnit_det` isolation, and the
`lem:gr_universalMinorInv_identities` name ambiguity) do not touch the dispatch targets and
do not block the gate.
