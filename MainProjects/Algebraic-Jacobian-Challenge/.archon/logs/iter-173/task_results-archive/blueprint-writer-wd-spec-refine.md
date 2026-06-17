# Blueprint Writer Report

## Slug
wd-spec-refine

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RiemannRoch_WeilDivisor.tex

## Changes Made

### New blocks
- **Added definition** `\definition` / `\label{def:prime_divisor}` / `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` (chapter L139–L210)
  — pins the previously-unreferenced helper structure `Scheme.PrimeDivisor` to the predicate
  `Order.coheight point = 1` on `X.carrier`'s specialisation preorder (Mathlib
  `Mathlib.Order.KrullDimension`). Includes:
  - Hartshorne II.6, p.~130 `% SOURCE QUOTE` for "prime divisor = closed integral subscheme of
    codim 1".
  - Generic-point correspondence prose explaining why `Order.coheight point = 1` captures
    "codim-1 integral" (closure of `{point}` is always irreducible, so reduced subscheme structure
    is automatically integral — the only non-automatic condition is codimension).
  - Concrete Mathlib pointer to the specialisation preorder convention
    (`x ≤ y ↔ y ⤳ x`, verified by `lean_run_code` in the writer session; generic point is the
    unique maximal element, codim-1 generic points have a length-1 chain above them).
  - **Lean encoding (iter-173 pin)** paragraph: instructs the prover to refine
    `isCodim1AndIntegral : True := trivial` in `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:84–90`
    to a named field `coheight : Order.coheight point = 1` (type `Prop`), preserving the
    `point : X` field for downstream defeq.
  - **Rejected alternatives** paragraph documenting why the iter-172 lean-vs-blueprint-checker's
    other proposals (`IsIntegral (X.closedSubschemeOfPoint x)`, bundled `IdealSheafData`) were
    not adopted: Mathlib `b80f227` ships no `closedSubschemeOfPoint`, and bundling
    `IdealSheafData` adds redundant data the chapter never consumes.

### Refined blocks
- **Revised** `def:codim1_cycles` (chapter L212–L249) — removed the multi-line iter-172 `% NOTE`
  block describing the `True` placeholder + must-fix flag, replaced with a `\uses{def:prime_divisor}`
  cross-reference and a "Lean signature scope" paragraph clarifying that the bare additive group
  `Scheme.WeilDivisor X` is given for any `X : Scheme` (integrality threaded at downstream layers,
  not on this carrier).
- **Revised** "Throughout this chapter" prose (chapter L63–L135) — added a new paragraph block
  "Standing hypothesis $(*)$ in the Lean encoding (iter-173 pin)" with a three-layer
  decomposition of Hartshorne $(*)$ into Mathlib typeclass sets:
  - Basic formal-sum layer: `[IsIntegral X]` only.
  - Order/principal layer: adds `[IsLocallyNoetherian X]` plus a project-side regular-in-codim-1
    predicate (no Mathlib typeclass exists; documented as the conjunction
    `∀ x, Order.coheight x = 1 → IsDiscreteValuationRing (𝒪_{X,x})`).
  - Curve layer: the project-standard `[IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]` typeclass set used by
    `AlgebraicJacobian.Genus` / `AlgebraicJacobian.AbelianVarietyRigidity`.
- **Revised** `def:divisor_closed_point` (chapter L297–L338) — appended a "Lean signature scope"
  paragraph explaining that the Lean signature is given for arbitrary
  `C : Scheme.{u}` + `P : C` + `IsClosed ({P} : Set C)` and does NOT typeclass-pin "smooth proper
  curve over `k̄`". The promotion of `P` to a `PrimeDivisor` (i.e., the `Order.coheight P = 1`
  obligation) is threaded inside the proof body, not in the signature.
- **Revised** `def:divisor_degree` (chapter L342–L384) — appended a "Lean signature scope"
  paragraph explaining that `WeilDivisor.degree` is the bare-coefficient sum
  `Finsupp.sum D (fun _ n => n)` for any `X : Scheme.{u}` (no curve typeclass), and that this
  coincides with the curve-theoretic `Σ nᵢ` only when every closed point has residue field `k̄`
  (the smooth-proper-curve-over-k̄ hypothesis is threaded at downstream call sites:
  `thm:principal_deg_zero`, RR.2/RR.3/RR.4).

## Cross-references introduced
- `\uses{def:prime_divisor}` added in `def:codim1_cycles` — `def:prime_divisor` is defined in this
  same chapter (this iteration).
- The new "Standing hypothesis" prose block references `\Cref{def:prime_divisor}`,
  `\Cref{def:codim1_cycles}`, `\Cref{def:divisor_degree}`, `\Cref{thm:divisor_degree_hom}`,
  `\Cref{def:divisor_closed_point}`, `\Cref{def:order_at_point}`, `\Cref{def:principal_divisor}`,
  `\Cref{thm:principal_hom}`, `\Cref{thm:principal_deg_zero}` — all already exist in this chapter.

## References consulted
- `references/summary.md` — verified `hartshorne-algebraic-geometry.md` is the canonical source for
  the Hartshorne $(*)$ pin + II.6 divisor definitions; no new retrieval needed.
- `references/hartshorne-algebraic-geometry.md` — confirmed PDF location of II.6 (doc p.~129 / PDF
  p.~146) and the standing $(*)$ quote ("noetherian integral separated, regular in codim one")
  + the prime-divisor definition. No new verbatim quote needed: the existing chapter blocks
  already quote II.6 p.130–131 verbatim, and my added `def:prime_divisor` block re-uses one of the
  already-quoted Hartshorne sentences ("A prime divisor on $X$ is a closed integral subscheme $Y$
  of codimension one").
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (iter-172 file-skeleton) — verified the
  `Scheme.PrimeDivisor` structure currently at L84–L90 (with the `True` placeholder field) and the
  9 pinned declarations. The chapter's new `def:prime_divisor` block pins this Lean object
  explicitly and instructs the prover how to refine the placeholder.
- `.lake/packages/mathlib/Mathlib/Order/KrullDimension.lean` — confirmed via
  `lean_declaration_file` that `Order.coheight` is `noncomputable def Order.coheight {α} [Preorder α]
  (a : α) : ℕ∞` with semantics `coheight a = sup {n : a = a₀ < a₁ < ... < aₙ}`. Sanity-checked via
  `lean_run_code` that:
  - `Order.coheight x` typechecks for `(X : Scheme) (x : X)` (the preorder on `X.carrier` is
    inferred);
  - Mathlib's preorder on `Scheme.carrier` is `x ≤ y ↔ y ⤳ x` (i.e., generic point is maximal —
    confirmed by `example (X : Scheme) [IrreducibleSpace X] (y : X) : y ≤ genericPoint X`
    closing via `genericPoint_specializes`).
- `.lake/packages/mathlib/Mathlib/AlgebraicGeometry/IdealSheaf/Basic.lean` — confirmed that
  `Scheme.IdealSheafData` is the closest Mathlib API to "closed subscheme from a point"; there is
  no `closedSubschemeOfPoint`. Documented this in the `def:prime_divisor` rejected-alternatives
  block.
- `.lake/packages/mathlib/Mathlib/AlgebraicGeometry/Noetherian.lean` — confirmed
  `AlgebraicGeometry.IsLocallyNoetherian` is the right Mathlib class for Hartshorne's
  "noetherian"; cited in the "Standing hypothesis" prose.
- `.lake/packages/mathlib/Mathlib/AlgebraicGeometry/Properties.lean` (transitive via
  `IsIntegral`) — confirmed `IsIntegral X` implies `IrreducibleSpace X.carrier` (used to justify
  that the function field is a field on the bare formal-sum layer).
- `.lake/packages/mathlib/Mathlib/AlgebraicGeometry/FunctionField.lean` — confirmed
  `Scheme.functionField` requires `[IrreducibleSpace X]` (auto from `[IsIntegral X]`).
- `blueprint/src/macros/common.tex` — verified the macros in use; the `\codim` / `\Div` / `\Cl` /
  `\ord` / `\div` macros are not defined here but were already used in the chapter and render
  through `leanblueprint`'s plasTeX path. Replaced one `\ie\` I had introduced with literal `i.e.\`
  for portability. Replaced an erroneous `\Order` (no such macro) with `\texttt{Order.coheight}`
  before final commit.

## Macros needed (if any)
- None new. All my additions use existing macros (`\texttt`, `\Cref`, `\codim`, `\overline`,
  `\mathcal`) plus literal `i.e.\` instead of `\ie`.

## Reference-retriever dispatches (if any)
- None. The Hartshorne PDF is on disk (`references/hartshorne-algebraic-geometry.pdf`,
  RETRIEVED 2026-05-20) and all verbatim quotes I needed were already present in the chapter from
  pre-iter-173 writes; no new external source had to be fetched.

## Notes for Plan Agent

### Specific instructions for iter-173 prover

The chapter now answers the four questions the directive listed; here is the explicit prover
to-do list distilled from the new pins, so iter-173's prover-agent can act without re-reading the
chapter:

1. **`Scheme.PrimeDivisor.isCodim1AndIntegral` placeholder** (`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:84–90`):
   refactor from `isCodim1AndIntegral : True := trivial` to a named Prop field `coheight :
   Order.coheight point = 1`. Keep the `point : X` field intact (the chapter's `def:prime_divisor`
   block notes this is the substantive piece for downstream defeq).

2. **`Scheme.RationalMap.order` / `Scheme.WeilDivisor.principal` / `Scheme.WeilDivisor.principal_hom`**
   (Lean L133, L218, L233): these are the order/principal layer. The chapter pins
   `[IsLocallyNoetherian X]` here, but Mathlib has NO single typeclass for Hartshorne's
   regular-in-codim-1 clause. The iter-173 prover should either:
   - (a) thread an explicit hypothesis at each codim-1 prime divisor: `(hY : Order.coheight Y.point = 1)
     → IsDiscreteValuationRing (X.presheaf.stalk Y.point)`, OR
   - (b) introduce a project-side class `Scheme.IsRegularInCodimensionOne X` (separate file under
     `AlgebraicJacobian/RiemannRoch/` or similar) and thread it as a typeclass argument.

   The chapter does not pick between (a) and (b); it documents both options. The prover should
   take the path of least sorrow given Mathlib's current state.

3. **`Scheme.WeilDivisor.degree` / `Scheme.WeilDivisor.ofClosedPoint`**: keep the broad Lean
   signatures (scheme-level, no curve typeclass pinned). The chapter prose now explicitly widens
   to acknowledge the bare-sum semantics. The curve hypothesis is threaded only at
   `principal_degree_zero` (already done in the iter-172 file-skeleton) and at downstream RR.2/.3/.4
   consumers.

### Cross-chapter inconsistency flagged but NOT fixed

- `blueprint/src/macros/common.tex` does not define `\codim`, `\Div`, `\Cl`, `\ord`. These macros
  are used in this chapter (pre-existing usage; my additions extend a small number of them) and
  rendered correctly by `leanblueprint` (verified via `blueprint/web/chap-RiemannRoch_WeilDivisor.html`
  containing pre-iter-173 output for them). Status: not a regression; flagged in case the plan
  agent wants to add `\DeclareMathOperator` entries to the macros file for pdflatex robustness.
- `Scheme.functionField` in Mathlib requires `[IrreducibleSpace X]`, but the iter-172 file-skeleton
  uses `[IsIntegral X]` as the standing hypothesis on the relevant signatures. Since
  `IsIntegral X ⟹ IrreducibleSpace X.carrier` (instance chain in
  `Mathlib.AlgebraicGeometry.Properties`), this is sufficient — the prover does NOT need to
  rewrite the typeclass arguments; the chapter's "Standing hypothesis" pin is consistent with the
  existing Lean signatures.

## Strategy-modifying findings
None. The directive's four questions had concrete Mathlib-grounded answers; the chapter now
documents them as iter-173 pins. No strategy-level issue surfaced: the chapter is faithful to
Hartshorne II.6 and consistent with the project's existing curve typeclass conventions.
