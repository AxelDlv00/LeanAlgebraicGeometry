# Mathlib analogist directive — iter-200 slug coe-stacks00oe

## Mode: cross-domain-inspiration

## Structural problem

The project needs to formalize the Krull-dimension equality
\[
  \dim(R_{\mathfrak m}) = n
\]
for a smooth `R`-algebra `S` of relative dimension `n`, where `R` is a field (or contains a field, the algebraically closed setting on a closed-point variant), `\mathfrak m` is a maximal ideal of `S`, and `R_{\mathfrak m}` is the localization at `\mathfrak m`. This is **Stacks 00OE** (`lemma-smooth-locally-finite-type-equidimensional`).

This is Lane COE's Stage 6 sub-gap (ii.B); the only residual sorry on `isRegularLocalRing_stalk_of_smooth` (L1101 of `Albanese/CodimOneExtension.lean`) after iter-199 closed (ii.A) via the cotangent-iso Stacks 02JK helpers.

Mathlib has the categorical and ring-theoretic infrastructure for Krull dimension (`ringKrullDim`, `Order.krullDim`), the smooth algebra typeclass (`Algebra.Smooth`, `Algebra.IsStandardSmoothOfRelativeDimension`), and the relative-dimension API. But the named result "smooth `R`-algebra of relative dimension `n` localizes to a local ring of Krull dimension `n` at a maximal ideal" is not present as a single Mathlib lemma.

## Failed approaches

iter-198 → iter-199 Lane COE explored direct routes to (ii.B) but did not commit a closure attempt. The conjectured proof in the blueprint (Stacks 00OE itself):

1. Reduce to the affine standard-smooth case by smoothness of the structure morphism.
2. Compute `\dim(R_{\mathfrak m})` via the closed-fiber dimension: the closed fiber is smooth over `\kappa`, so its Krull dimension at any closed point is `n` (this is what we want to formalize).
3. The going-up / going-down for smooth ring maps plus the fact that the fiber has dim `n` everywhere closes the proof.

The structural difficulty: steps 2 and 3 invoke a chain of intermediate results (going-down for flat ring maps, dimension of polynomial rings, closed-point Krull-dim formula) that exist in Mathlib but require careful chaining.

## Search radius

`wide` — find any Mathlib structural analogue. The relevant abstract pattern is "Krull dim of a localization at a closed point equals a numerical invariant computable from the closed fiber" — this pattern appears in commutative-algebra contexts that are not necessarily about smooth algebras (e.g. local-ring theory of fibers of flat morphisms, Cohen-structure theorem for complete local rings, Eisenbud's dimension calculus).

## What to find

1. Mathlib's API for `ringKrullDim` on localizations (specifically: when does `ringKrullDim (Localization.atPrime p) = height p`?).
2. The state of Mathlib's "going-down for flat ring maps" lemmas (`RingHom.flat`, `IsFlat.height_eq`).
3. Whether Mathlib has any version of the closed-fiber Krull-dim formula at the polynomial-ring level (`MvPolynomial`, `Polynomial`); the smooth algebra reduces to a polynomial-ring case via the standard-smooth presentation.
4. Cross-domain: Mathlib's `Module.height_le_finrank` or analogous results connecting Krull-dimension to module-theoretic invariants — does that admit a "smooth ⟹ finrank equals relative dim" reading?
5. Any precedent for closed-point Krull-dim formula in Mathlib (algebraic geometry or commutative algebra).

## What to produce

A ranked list of structural Mathlib analogues for Stacks 00OE, each with:

- The Mathlib citation (declaration name + file path);
- The technique used there (e.g. "via Krull's height theorem + Noetherian induction" or "via fiber dimension + flat going-down");
- A concrete porting suggestion: how the Mathlib analogue's proof structure maps to the Lane COE (ii.B) closure.

If the ranked list contains a directly portable analogue (e.g. Mathlib has a polynomial-ring Krull-dim formula that the smooth-algebra reduction can ride), say so and give the iter-201+ Lean prover lane a 3-step recipe ready to formalize.

If the ranked list is empty (no Mathlib analogue exists), say so and recommend a project-side build estimate.

## Out-of-scope

- Do NOT propose proofs for the Lane COE prover this iter; cross-domain inspiration is a list of analogues with technique citations, not a directive replacement.
- Do NOT touch `STRATEGY.md`, `PROGRESS.md`, blueprint chapters, or any `.lean` file.

## Write domain

- `analogies/**` (you produce `analogies/coe-stacks00oe.md` persistent rationale)
- `task_results/**` (you produce the report)

## Report

`task_results/mathlib-analogist-coe-stacks00oe.md` + persistent `analogies/coe-stacks00oe.md`.
