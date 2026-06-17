# Blueprint Writer Directive

## Slug
dag-writer-quotscheme

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Strategy context
This chapter blueprints the **Quot foundations** (QUOT route): the Hilbert-polynomial encoding via
the graded Hilbert function, the QUOT predicates (schematic support / proper support), and the
graded Hilbert–Serre rationality lemma `lem:gradedHilbertSerre_rational` (SNAP-S2). The Lean file
`QuotScheme.lean` carries two helper clusters with **no blueprint entry** (Lean↔blueprint debt):
(a) the **`IsRatHilb` rationality machinery** — a predicate `IsRatHilb f d` ("`f : ℕ → ℚ` is the
eventual-coefficient function of a rational series `p·(1−X)^{−d}`") plus its closure lemmas, used to
run the Stacks 00K1 induction inside `lem:gradedHilbertSerre_rational`; and (b) two
**schematic-support predicate helpers** for `Scheme.Modules`. Add a concise blueprint entry for each.

## Required content
Add one concise block per Lean declaration below. Read `AlgebraicJacobian/Picard/QuotScheme.lean`
for each exact signature. These are **project-internal, Archon-original** helpers — no external
`% SOURCE QUOTE:` block required (the `IsRatHilb` closure lemmas realize standard steps of the
Stacks 00K1 inductive argument; a one-line `\textit{Source: Stacks 00K1.}` pointer is optional on
the predicate `def:` but not required).

Rationality machinery (namespace `AlgebraicGeometry`, names `IsRatHilb...`):
- `AlgebraicGeometry.IsRatHilb` (definition, `Prop`) — `IsRatHilb f d` holds iff the function
  `f : ℕ → ℚ` agrees, for all `n`, with the `n`-th coefficient of some rational power series
  `p(X)·(1−X)^{−d}` with `p ∈ ℚ[X]` (read the def for the exact formulation). This is the
  "is a numerical-polynomial-eventually / rational Hilbert series" predicate the induction tracks.
- `AlgebraicGeometry.IsRatHilb.ofEventuallyZero` — a function eventually zero (`f n = 0` for `n > N`)
  is `IsRatHilb f d` for any `d` (it equals a polynomial times `(1−X)^{−d}` with that polynomial the
  finite sum). Base case of the induction.
- `AlgebraicGeometry.IsRatHilb.bump` — if `IsRatHilb f d` then `IsRatHilb f (d+1)` (raise the pole
  order by multiplying numerator by `(1−X)`).
- `AlgebraicGeometry.IsRatHilb.sub` — `IsRatHilb` is closed under pointwise subtraction at fixed `d`.
- `AlgebraicGeometry.IsRatHilb.shiftRight` — closure under the right shift `n ↦ f (n−1)`
  (multiplication of the series by `X`).
- `AlgebraicGeometry.IsRatHilb.antidiff` — the **anti-difference / summation** step: if the
  difference sequence is `IsRatHilb` (pole order `e`) and agrees beyond `N`, then the summed
  sequence `H` is `IsRatHilb` with pole order `e+1`. This is the inductive heart (a finite
  difference raises the pole order by one).
- `AlgebraicGeometry.IsRatHilb.ofDiffEq` — packaging: if `hM − hC + hK(·−1)` telescopes
  appropriately (read the statement), `hM` is `IsRatHilb`. The form used to apply the SES degree
  recursion.
- `AlgebraicGeometry.coeff_invOneSubPow_one_mul` — coefficient identity for
  `invOneSubPow` (the formal series `(1−X)^{−d}`) multiplied by `X` / a degree-one factor; the
  power-series computation behind `shiftRight`/`bump`. One-to-two lines.
- `AlgebraicGeometry.rationalHilbert_antidiff` — the power-series-level lemma underlying
  `IsRatHilb.antidiff` (the partial-sum series equals numerator over `(1−X)^{e+1}`). One-to-two lines.

Schematic-support predicate helpers (namespace `AlgebraicGeometry.Scheme.Modules`):
- `AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le` — over an affine open `U`, the
  annihilator ideal of `F` is contained in the ideal cutting out the schematic support (read the
  statement). Supports `def:schematic_support`.
- `AlgebraicGeometry.Scheme.Modules.schematicSupportι` (definition) — the closed immersion
  `schematicSupport F ⟶ X` of the schematic support into the ambient scheme. Supports
  `def:schematic_support` / `def:has_proper_support`.

For each: short statement in project notation, `\label{}` (suggest `lem:ratHilb_*` / `def:ratHilb`
/ `lem:modules_*` / `def:schematic_support_immersion` from the basename), exact `\lean{}`, accurate
`\uses{}`, and a one-to-two line proof or `Proved directly in Lean.` note (do NOT add `\leanok`).

**Wire `\uses{}`:** add edges from `lem:gradedHilbertSerre_rational` to the `IsRatHilb` cluster it
uses, edges among the `IsRatHilb` lemmas (e.g. `ofDiffEq \uses{lem:ratHilb_antidiff}`,
`antidiff \uses{lem:rationalHilbert_antidiff}`), and edges from `def:schematic_support` /
`def:has_proper_support` to the two `Scheme.Modules` helpers. Reuse existing Mathlib anchors
(`lem:invOneSubPow_mathlib`, `lem:finrank_ses_additive_mathlib`) via `\uses{}` rather than
re-authoring. Run `leandag build --json`; confirm zero isolated/broken for this cluster.

## Out of scope
- Do NOT modify existing meaningful statements (`def:hilbert_polynomial`, `def:quot_functor`,
  `def:grassmannian_scheme`, `thm:grassmannian_representable`, `lem:gradedHilbertSerre_rational`'s
  statement, `def:sectionGradedRing`, etc.) beyond adding `\uses{}` edges to the new helpers.
- Do NOT add `\leanok`. Do NOT touch other chapters. Do NOT mark these project helpers `\mathlibok`.

## References
- `references/hilbert-serre.md` → Stacks 00K1 (graded Hilbert–Serre, inductive proof) — optional
  one-line pointer for the `IsRatHilb` predicate only; no verbatim quote required for these
  internal closure lemmas.

## Expected outcome
The chapter gains ~11 concise helper blocks (the `IsRatHilb` rationality machinery + two
schematic-support helpers), each with `\label`/`\lean`/`\uses` and a short proof or
"Proved directly in Lean." note, wired into `lem:gradedHilbertSerre_rational` and the schematic-
support predicates so `leandag` reports zero unmatched-lean and zero isolated nodes for this cluster.
