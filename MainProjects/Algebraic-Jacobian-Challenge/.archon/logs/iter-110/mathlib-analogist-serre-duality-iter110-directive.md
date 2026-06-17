# Mathlib Analogist Directive

## Slug
serre-duality-iter110

## Trigger
Variance flag on `AlgebraicGeometry.Scheme.serre_duality_genus` at `AlgebraicJacobian/Differentials.lean:877`, live across strategy-critic-iter107/108/109. Progress-critic-iter110 ratified this as a "must fire this iter or next" item to inoculate Phase B against the L1846/L1120 anti-pattern (open route → discover API doesn't fit → accrete inline scaffolding → 5+ iters of PARTIAL).

## Project context

Project: formalize the Jacobian of a smooth proper geometrically irreducible curve over a field. The genus is defined as `dim_k H¹(C, 𝒪_C)`. The protected `AlgebraicGeometry.smoothOfRelativeDimension_genus` is one of the four `Jacobian` instances; it carries content that bridges the cohomological-genus definition with the smoothness-rank definition through Serre duality.

Specifically, `serre_duality_genus` asserts that for `C` smooth proper geometrically irreducible over a field `k`,
```
dim_k H⁰(C, Ω_{C/k}) = dim_k H¹(C, 𝒪_C)
```
and both equal the genus `g(C)`. This is the dimension-1 case of Serre duality applied to the canonical sheaf `ω_C = Ω_{C/k}`.

The Lean signature (`Differentials.lean:871-877`) is:
```lean
theorem serre_duality_genus {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k))) [IsIntegral C.left] [IsProper C.hom]
    (hsmooth : Smooth C.hom) :
    Module.rank k (HModule k (toModuleKSheaf C) 0) =
      Module.rank k
        (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0) := by
  sorry
```

Where `HModule` is the project-local `Scheme.HModule k _ n` for sheaf cohomology with `k`-module coefficients (defined in `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`).

## Question for the analogist

Read-only consult: **does Mathlib b80f227 have infrastructure that bridges Serre duality to a `Module.rank` / `Module.finrank`-style equality, at a level the project can consume here?**

Specifically:

1. **Serre duality at the abstract level**: does Mathlib have any form of Serre duality on smooth proper schemes / projective varieties / curves? Search `Mathlib.AlgebraicGeometry.*` and `Mathlib.CategoryTheory.Duality.*` (and any nearby) for `SerreDuality`, `serre_duality`, or similar. If no exact API exists, are there *partial* pieces (canonical sheaf, dualizing complex, the trace map) that the project could compose into the curve-level statement?

2. **Cohomology dimension equalities**: does Mathlib have any `Module.rank` / `Module.finrank` equalities for sheaf cohomology that could be adapted? E.g. `H⁰(P^n, O) = k`, `H¹(C, O) ≅ H⁰(C, ω)*` (the duality pairing), etc.

3. **Project's `HModule` interface**: the project defines `HModule k (Sheaf k) n` via `Abelian.Ext` (built in iters 003-008). Is this a *parallel API* to anything Mathlib has, or is it the canonical idiom? Does Mathlib's `CategoryTheory.Sheaf.H` (verified to exist via strategy-critic-iter110) interact well with the project's `HModule` shape, or does this introduce friction?

4. **Closure cost estimate**: based on what you find, estimate the LOC cost of closing `serre_duality_genus` in 3 scenarios:
   - (a) Mathlib has full Serre duality already (collapse to a Mathlib lemma + the `HModule`/`Sheaf.H` bridge): ~LOC.
   - (b) Mathlib has partial pieces (dualizing sheaf, trace map, etc.) and project must compose: ~LOC.
   - (c) Mathlib has neither and project must redefine + prove from first principles (the trace map + the duality pairing + the perfect-pairing argument): ~LOC.

5. **Verdict**: PROCEED (project is on the right idiom and Mathlib has adequate infrastructure); ALIGN_WITH_MATHLIB (Mathlib has the canonical idiom and the project should adopt it before closure); NEEDS_MATHLIB_GAP_FILL (Mathlib b80f227 has insufficient infrastructure for any of the 3 scenarios, recommend named-deferred sorry per the project's exit policies).

## What you produce

1. **Persistent file**: `analogies/serre-duality.md` recording the search findings + the verdict + cost estimate. Future iters read this file when they re-engage the route.

2. **Report**: `task_results/mathlib-analogist-serre-duality-iter110.md` with the above structure (verdict, per-question answers, evidence). The plan agent reads this and decides whether iter-111's Phase B prover lane should cover L877 or whether L877 should be re-classified per the verdict.

## Out of scope

- Closing the sorry itself (you are read-only).
- Touching `Differentials.lean` or any other Lean file.
- Closing `h_exact` (L636) — that sorry is correctly deferred parallel to `instIsMonoidal_W` and is NOT the variance-flagged item.
- The other three Phase B sorries L122 / L718 / L735 — those are out of scope per strategy-critic-iter110 Q2 scope clarification (the variance flag gates L877 specifically).

## References

- `references/challenge.lean` — the upstream challenge spec.
- `AlgebraicJacobian/Differentials.lean` (read-only).
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (where the project's `HModule` is defined, read-only).
- `blueprint/src/chapters/Differentials.tex` (current; you may consult but should not edit).
- Mathlib b80f227.

## Search tool checklist

Use:
- `lean_leansearch` with prompts like "Serre duality for smooth curve", "dim H^0 omega = dim H^1 structure sheaf", "dualizing sheaf canonical sheaf".
- `lean_loogle` with type patterns matching the project's signature shape.
- `lean_leanfinder` for conceptual searches.

Rate-limited; budget your calls.
