# Iter-150 objectives

Two-lane HYBRID-trimmed dispatch on the chart-algebra envelope.
Aggregate ~90–110 LOC. See `iter/iter-150/plan.md` § "Decisions for
iter-150 prover dispatch" for the full rationale and HYBRID-pivot
context. `PROGRESS.md` § "Current Objectives" carries the canonical
prover-facing brief.

## Lane 1 — `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`

Close two of the four (S3.*) bodies via the CharZero collapse
shortcut surfaced by the iter-150 mathlib-analogist (HYBRID part B):

| Target | Line | Path | Estimate |
|---|---|---|---|
| `isGeometricallyReduced_Gamma_of_smooth` (S3.sep.1) | L166 | `PerfectField.ofCharZero` + smooth ⇒ formally smooth ⇒ geom-reduced (via `IsReduced` on the perfect-base side) | ~15 LOC |
| `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite` (S3.sep.2) | L269 | `PerfectField.ofCharZero` + `Algebra.IsAlgebraic.isSeparable_of_perfectField` (Mathlib `Mathlib.FieldTheory.PurelyInseparable.Basic` or `Mathlib.RingTheory.IsAlgebraic`) | ~15 LOC |

Update `(S3.pi.1)` at L227 and `(S3.pi.2)` at L320 docstrings to
flag the **HYBRID-DEFERRED** status (these bodies remain structured
sorries; iter-151+ status depends on user-input on HYBRID part (A)
recorded in TO_USER).

Lane 1 informal content:
- `blueprint/src/chapters/RigidityKbar.tex` § "Chart-algebra piece
  (ii) first-class decomposition" → the (S3.sep.1) + (S3.sep.2)
  lemma blocks (~lines 1985–2017 + 2050–2065).
- `analogies/h1cotangent-vanishing-iter150.md` § "Top suggestion
  (B)" + "Discarded — H1Cotangent-vanishing pivot" (full analogist
  rationale).
- `references/stacks-0BUG.md` for the geom-reduced + finite ⇒
  separable content underlying (S3.sep.2).

## Lane 2 — `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

Close the KDM (BR.5) joint-kernel collapse at L123 via the
`MvPolynomial.pderiv` route (HYBRID part C):

| Target | Line | Path | Estimate |
|---|---|---|---|
| `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` body (BR.5 closure) | L123 | Translate the standard-smooth presentation to a surjection from `MvPolynomial (Fin n) k`; on the polynomial side, joint-vanishing of `pderiv` implies the polynomial is constant (char 0); transfer the conclusion to `B` via the surjection. | ~60–80 LOC |

Lane 2 informal content:
- `blueprint/src/chapters/RigidityKbar.tex` § "Chart-algebra piece
  (ii) first-class decomposition" → `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
  primary path (p2) (~lines 2200–2270).
- `analogies/h1cotangent-vanishing-iter150.md` § "Top suggestion
  (C) KDM (BR.5) via MvPolynomial.pderiv".
- `references/stacks-07F4.md` for the `0334`-typo audit trail (the
  correct tag for standard-smooth ⇒ Ω free is `00T7`).

Do NOT touch the hPI branch of `constants_integral_over_base_field`
at L394 — it consumes (S3.pi.*), which are deferred pending HYBRID
part (A) user gate.

## What "PARTIAL is acceptable" looks like this iter

Both lanes carry well-scoped Mathlib paths surfaced by the iter-150
analogist consult. If a path doesn't compose as expected:

- **Lane 1**: if `PerfectField.ofCharZero` + `isSeparable_of_perfectField`
  doesn't compose (e.g. the Mathlib API name is slightly different
  or requires additional hypotheses), fall back to the iter-149
  Artinian decomposition scaffold and report the specific gap.
- **Lane 2**: if the MvPolynomial monomial-expansion chase runs
  into unexpected Mathlib gaps (e.g. the standard-smooth surjection
  to `MvPolynomial (Fin n) k` requires constructing the polynomial-
  ring projection by hand from the `Algebra.IsStandardSmoothOfRelativeDimension`
  fields), report the gap and leave the (BR.5) body as the existing
  structured sorry.

PARTIAL reports should name the specific Mathlib lemma sought (so
iter-151 can re-scope or dispatch a focused mathlib-analogist
api-alignment round).

## Off-limits

- All `.lean` files except the two named above.
- `(S3.pi.1)` and `(S3.pi.2)` bodies (deferred indefinitely).
- hPI branch of `constants_integral_over_base_field` (deferred).
- All blueprint chapters (already edited by `blueprint-writer-render-fix-iter150`).
- `archon-protected.yaml`.
