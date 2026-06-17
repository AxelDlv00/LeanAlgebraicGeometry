# Iter-151 objectives — detail

## Lane 1 — `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (single lane)

**Target**: close the KDM (BR.5) transfer step `(C.d)` in
`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (lemma L256; residual
`sorry` at L388). This is the ONLY sanctioned Route-C prover step under the
STRATEGY.md bright-line, and the progress-critic's CHURNING convergence test.

**Signature** (frozen by iter-149/150 inflation; not protected):
`{k} [Field k] [CharZero k] {B} [CommRing B] [Algebra k B] [Algebra.FiniteType k B]
{n} [Algebra.IsStandardSmoothOfRelativeDimension n k B] {b} (hDb : D k B b = 0)
: b ∈ (algebraMap k B).range`.

**Pre-staged (closed in Lean iter-150)**:
- `_mvPoly_mem_range_C_of_D_eq_zero` (FREE-CASE: `D f = 0 ⇒ f ∈ C.range`, char 0).
- `SubmersivePresentation` extraction (`Algebra.IsStandardSmooth.out`) +
  surjection `π : MvPolynomial ι k → B` (`Generators.algebraMap_surjective`).
- `_hFunct`: `(map k k P.Ring B)(D_A bTilde) = 0` via `KaehlerDifferential.map_D`.

**(C.d) closure paths** (pick one; do NOT add new helper decomposition):
- (S5.a) explicit: `KaehlerDifferential.ker_map_of_surjective` ⟹ kernel =
  submodule gen by `{D r : r ∈ I}` + `I·Ω` (`I = ker π`); Leibniz-modify `bTilde`
  to absorb `D(I)`; chase the `I·Ω` residue via the free `mvPolynomialBasis`;
  apply FREE-CASE + `_hFunct`. ~30 LOC.
- (S5.b) abstract: `Algebra.FormallySmooth.subsingleton_h1Cotangent` [expected]
  to bypass the explicit chase. ~10–20 LOC.

**Mathlib existence (confirmed b80f227)**: `MvPolynomial.mkDerivation`,
`pderiv`, `mvPolynomialBasis_repr_D`, `ker_map_of_surjective` — all verified
(strategy-critic + iter-150 lane).

**Success** = `sorry` at L388 gone, KDM lemma sorry-free, project 9 → 8.
**Acceptable PARTIAL** = (C.d) hits an unexpected Mathlib gap; document it
SPECIFICALLY (which lemma/shape is missing) for an iter-152 pivot decision. Do
NOT introduce a new sorry-bearing helper (bright-line).

**OFF-LIMITS in this file**: the hPI branch of
`constants_integral_over_base_field` (L617) — gated on the user `[IsAlgClosed kbar]`
decision; do not touch.

**Blueprint**: `chapters/RigidityKbar.tex` § "Chart-algebra piece (ii)",
`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`, now with first-class
**(BR.5′)** route-(C) prose (landed by `blueprint-writer-rigiditykbar-iter151`).
Also `analogies/h1cotangent-vanishing-iter150.md` § "Top suggestion (C)".
