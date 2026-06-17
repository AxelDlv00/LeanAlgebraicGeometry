# Effort-breaker — `def:gr_transition`

## Target
`def:gr_transition` in `blueprint/src/chapters/Picard_GrassmannianCells.tex`
(Lean target `AlgebraicGeometry.Grassmannian.transitionMap`).

## Why
This single declaration has been dispatched to a `mathlib-build` prover for TWO
consecutive iters and produced ZERO committed edits each time — no partial progress,
no decomposition handoff. It is the Cramer-inverse transition ring homomorphism on a
localized multivariate-polynomial ring, and as one monolithic `def` it is too large
for the prover to land in one go. The supporting node `def:gr_affine_chart`
(`affineChart`) is already done (`\leanok`), so this is a live frontier bottleneck.
Break it into a `\uses`-linked chain of small, independently-formalizable pieces so the
next prover iter has several ready atoms instead of one wall.

## Granularity
**Fine — one mathematical claim/construction per lemma**, split along the matrix-algebra
seams (not arbitrary points). After this break, no resulting block should require more
than a single matrix-algebra fact or a single localization-universal-property step.

## Proof structure to cut along
Work over the affine chart ring `R^I_J := ℤ[X^I, 1/P^I_J]` (the localization of the
chart polynomial ring `ℤ[X^I]` — i.e. `MvPolynomial (Fin d × {q // q ∉ I}) ℤ` — at the
minor determinant `P^I_J`). The construction of `θ_{I,J} : ℤ[X^J, 1/P^J_I] → R^I_J` in
the current proof sketch decomposes naturally as:

1. **The universal matrix and its `J`-minor over the localization.** `X^I` is the
   `d × r` matrix over `ℤ[X^I]` (identity block on the `I` columns, free indeterminates
   off `I`); base-changed into `R^I_J` it gives a matrix, and its `J`-minor
   `X^I_J : Matrix (Fin d) (Fin d) R^I_J` (a `def`).
2. **The minor determinant is a unit in `R^I_J`.** `P^I_J = det (X^I_J)` is invertible
   in the localization `R^I_J` by construction of the chart (`IsUnit (det X^I_J)`). A
   `lem` — the load-bearing fact that lets Cramer's rule apply. [Mathlib:
   `IsLocalization.Away` makes the localized-at element a unit; `Matrix.isUnit_iff_isUnit_det`.]
3. **The Cramer inverse.** With the determinant a unit, `(X^I_J)⁻¹ :
   Matrix (Fin d) (Fin d) R^I_J` exists with `(X^I_J)⁻¹ * X^I_J = 1` and
   `X^I_J * (X^I_J)⁻¹ = 1`. A `def` + a `lem` for the two inverse identities.
   [Mathlib: `Matrix.nonsing_inv`, `Matrix.nonsing_inv_mul`, `Matrix.mul_nonsing_inv`,
   gated on `IsUnit (det _)`.]
4. **The image matrix.** `M := (X^I_J)⁻¹ * X^I : Matrix (Fin d) (Fin r) R^I_J` — the
   matrix whose entries are the images of the `X^J` indeterminates. A `def`.
5. **The pre-localization ring hom.** The ℤ-algebra hom `ℤ[X^J] → R^I_J` sending each
   free indeterminate `x^J_{p,q}` to `M p q` (and the `J`-block to the identity). A
   `def` via `MvPolynomial` universal property (`MvPolynomial.aeval`/`eval₂`).
6. **The transition unit identity.** Under the pre-hom, `P^J_I` (the `I`-minor
   determinant of `X^J`) maps to `det ((X^I_J)⁻¹ X^I_I) = det((X^I_J)⁻¹) = (P^I_J)⁻¹`,
   a unit in `R^I_J`. A `lem` — this is exactly what lets the hom extend to the source
   localization. [`RingHom.IsUnit`, `IsUnit.map`.]
7. **The localization extension = `def:gr_transition`.** The pre-hom sends `P^J_I` to a
   unit, so it factors through `ℤ[X^J, 1/P^J_I] → R^I_J` — this is `transitionMap`. The
   final `def`, now a thin `IsLocalization.Away.lift` / `IsLocalization.lift` wrapper
   over steps 5–6. [Mathlib: `IsLocalization.Away.lift`, `IsLocalization.lift`.]

Keep `\theta_{I,I} = \id` as a one-line corollary (`lem`) of step 7, or fold it into the
existing `lem:gr_cocycle` deps — your call, but make sure `lem:gr_cocycle`'s `\uses{}`
points at whatever new sub-blocks it actually needs (it currently `\uses{def:gr_transition,
def:gr_affine_chart}`).

## Requirements
- Each new sub-block gets its own `\label`, `\lean{...}` (a concrete declaration name in
  the `AlgebraicGeometry.Grassmannian` namespace), a `% LEAN SIGNATURE` block, an
  informal proof, and an accurate `\uses{}` chain. Re-anchor genuine Mathlib facts
  (`Matrix.nonsing_inv` identities, `IsLocalization.Away.lift`) as `\mathlibok` Mathlib
  dependency anchors where that keeps the DAG honest — but `\mathlibok` ONLY on real
  Mathlib re-exports, never on the project's own to-be-built decls.
- Preserve the existing `% SOURCE` / `% SOURCE QUOTE` Nitsure §1 citations; distribute
  the relevant fragment to whichever sub-block it now justifies.
- Do NOT add `\leanok` to anything (the deterministic sync owns it).
- After the break, `def:gr_transition` itself must remain the named target
  `transitionMap` (step 7), so downstream `\uses{def:gr_transition}` edges stay valid.
- Keep `lem:gr_cocycle`, `def:gr_glued_scheme`, etc. intact; only repoint their `\uses{}`
  if the dependency they need is now a new sub-block.
