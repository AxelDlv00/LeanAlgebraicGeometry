# Refactor directive — scaffold + wire GrassmannianCells.lean (slug: scaffold-grcells)

## Goal
Create a NEW Lean file `AlgebraicJacobian/Picard/GrassmannianCells.lean` containing a stub for the
single blueprint-pinned declaration `def:gr_affine_chart`
(`\lean{AlgebraicGeometry.Grassmannian.affineChart}`), and WIRE it into the build by adding its import
to the root aggregator `AlgebraicJacobian.lean`. This is a structural scaffold: insert a `sorry`-bodied
definition with the correct signature; do NOT attempt to construct the scheme (a prover fills it this
same iter).

## Files you may write
- `AlgebraicJacobian/Picard/GrassmannianCells.lean` (create)
- `AlgebraicJacobian.lean` (add ONE import line)

## What to create in GrassmannianCells.lean
- Standard header comment + `import Mathlib` (match the style of `AlgebraicJacobian/Picard/QuotScheme.lean`).
- `namespace AlgebraicGeometry.Grassmannian` (so the declaration's fully-qualified name is exactly
  `AlgebraicGeometry.Grassmannian.affineChart`).
- A `/-! ... -/` module doc + a `/- Blueprint: def:gr_affine_chart (chapters/Picard_GrassmannianCells.tex) -/`
  pointer comment, and a `/- Planner note: ... -/` block conveying the construction the prover must build
  (see below).
- The declaration stub:
  ```
  noncomputable def affineChart (d r : ℕ) (I : Finset (Fin r)) : Scheme := sorry
  ```
  Adjust the argument list ONLY if the blueprint clearly needs it (e.g. a hypothesis `I.card = d`); keep
  it minimal and faithful to the blueprint. The body MUST be `sorry` (do not construct the scheme).
- Close the namespace.

## Planner note to embed above the stub (the construction the prover formalizes)
Blueprint `def:gr_affine_chart` (Nitsure §1, "Construction by gluing together affine patches"): for
`I ⊆ {1..r}` with `#I = d`, `X^I` is the `d×r` matrix whose `I`-minor is the `d×d` identity and whose
other `d(r-d)` entries are independent indeterminates `x^I_{p,q}` over ℤ. The affine chart is
`U^I := Spec ℤ[X^I] = Spec (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ)` — the spectrum of the
polynomial ring on the `d(r-d)` free entries; non-canonically `≅ 𝔸^{d(r-d)}_ℤ`. The prover should build
`affineChart` as `AlgebraicGeometry.Spec` of that `CommRingCat` (the MvPolynomial ring on the free-entry
index type), via `MvPolynomial (Fin d × {q // q ∉ I}) ℤ` or an equivalent index of cardinality `d(r-d)`.

## Build verification
After creating the file and adding `import AlgebraicJacobian.Picard.GrassmannianCells` to
`AlgebraicJacobian.lean` (place it in import order with the other Picard imports), run `lake build` and
confirm the whole project still compiles (the new `sorry` is expected; no errors). Report the new total
sorry count delta (+1 expected).

## Constraints
- Do NOT edit any other `.lean` file, any blueprint chapter, or any other Picard file.
- Do NOT add `\leanok` or touch the blueprint.
- The declaration name `AlgebraicGeometry.Grassmannian.affineChart` is fixed by the blueprint `\lean{}`
  pin — match it exactly.

## Report
Confirm: file created, import wired into `AlgebraicJacobian.lean`, `lake build` green with exactly one
new `sorry` (the `affineChart` body), and the declaration's fully-qualified name resolves to
`AlgebraicGeometry.Grassmannian.affineChart`.
