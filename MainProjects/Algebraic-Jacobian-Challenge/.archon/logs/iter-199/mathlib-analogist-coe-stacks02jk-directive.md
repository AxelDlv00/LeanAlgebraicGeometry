# Mathlib analogist directive — iter-199 (slug: `coe-stacks02jk`)

## Mode: cross-domain-inspiration

## Structural problem

We need the **closed-point case** of Stacks 02JK:

> Let \(R\) be a ring, \(M\) a maximal ideal of \(R\), and
> \(\mathfrak m = M_{M}\) the maximal ideal of the localization
> \(R_M\). Let \(\kappa = R_M / \mathfrak m\) be the residue field
> (equivalently \(R / M\)). Assume \(R\) is an algebra over a
> ground ring \(k\) such that \(\kappa\) is a field (e.g.\ \(k\) a
> field). Then there is a canonical isomorphism of \(\kappa\)-modules
> \[
>   \mathfrak m / \mathfrak m^2 \;\cong\; \kappa \otimes_{R_M}
>   \Omega^1_{R_M / k}.
> \]
> Equivalently, the cotangent space at the closed point coincides
> with the residue-field base change of the (localized) Kähler
> differentials.

The Mathlib API has all the pieces but not the assembled iso:

- `Algebra.KaehlerDifferential.exact_mapBaseChange_map` — gives
  exactness of the conormal sequence
  `I/I² → κ ⊗_R Ω[R/k] → Ω[κ/k] → 0`.
- `Module.Cotangent` (in `Mathlib.RingTheory.LocalRing.Defs` /
  `Mathlib.RingTheory.LocalRing.Module`?) — the closed-point cotangent
  space `m/m²` as a κ-module.
- `LocalRing.ResidueField`, `LocalRing.cotangentSpace`.
- For a field \(k\), `Ω[κ/k] = 0` when \(κ\) is separably generated
  over \(k\); over an algebraically closed field \(\bar k\) and
  \(κ = \bar k\), `Ω[κ/k] = 0` trivially.

The project's `Albanese/CodimOneExtension.lean` `isRegularLocalRing_stalk_of_smooth`
(L526) is gated on this iso. iter-198 prover landed the
`finrank κ (κ ⊗ Ω[Sₘ/R]) = n` substrate (RHS); the iso itself is
the remaining gap.

## Failed approaches

The iter-198 prover documented two approaches that did not close
the gap:

1. **Direct application of exact_mapBaseChange_map** — gives
   surjectivity of `m/m² → κ ⊗ Ω` directly, but not injectivity.
   The codomain identification between Mathlib's `m.Cotangent`
   and `κ ⊗_R I` requires a chain of bridges that has not been
   assembled in Mathlib at b80f227.

2. **CONORMAL SEQUENCE + Ω[κ/k] = 0** — over \(k\) algebraically
   closed (matching the iter-198 ProjectiveLineBar setting),
   `Ω[κ/k] = 0` should turn the conormal sequence into a short
   exact sequence `0 → m/m² → κ ⊗ Ω[R/k] → 0` (with the right side
   `Ω[κ/k] = 0`). But the Mathlib API does not directly expose
   this conclusion; the conormal sequence is built on
   `KaehlerDifferential.kerToTensor`, and the bridge from there to
   `m.Cotangent` requires intermediate identifications.

Estimated 100-200 LOC for just the closed-point case.

## Search radius

`wide` — any Mathlib domain. We want to find:

- Mathlib uses of the cotangent-space ↔ Kähler-differential
  identification in a DIFFERENT setting (e.g., for affine schemes
  with regular sheaf structure, for graded algebras, for Lie
  algebras, for de Rham cohomology base changes, for Tor /
  Ext-functor arguments around quotients by ideals, for derived-
  category arguments in `CategoryTheory.Triangulated`).
- Mathlib structural patterns for assembling iso's from exactness
  + vanishing-on-one-end (e.g. snake lemma + `Quotient.lift` chain;
  or `LinearEquiv.ofExact`-style helpers).
- Mathlib identifications between `Submodule.toModule (I^n)` /
  `Ideal.cotangent` / `LocalRing.cotangentSpace` /
  `KaehlerDifferential.kerToTensor.range` — any of these may give
  an existing chain.

## What I want back

A ranked list of structural analogues with:

1. The Mathlib citation (module path + declaration name).
2. The pattern used there (exact sequence assembled into iso;
   Tor / Ext vanishing argument; specific tactic combo).
3. A concrete suggestion for how to port the pattern to our
   problem: identify the `m/m² ≃ κ ⊗ Ω[Sₘ/R]` iso for a closed
   point over an algebraically closed field.

Especially welcome:

- Patterns from `Mathlib.RingTheory.Etale.*`,
  `Mathlib.RingTheory.LocalRing.*`,
  `Mathlib.RingTheory.Smooth.*`,
  `Mathlib.AlgebraicGeometry.Modules.*`.
- Patterns where the closed-point cotangent-space is identified
  via `Module.Free` arguments (e.g. standard-smooth presentations).
- Decompositions where the iso is built via `LinearMap.exact`,
  `LinearMap.exact_iff_split`, or `Module.Cotangent.equivQuotientMaximalIdealPow`.

Out-of-scope: do not try to formalize the iso itself. The output is
analysis only — the project will dispatch a prover lane on the
recommended pattern.
