# Blueprint Writer Directive

## Slug
rr-bridge-subbuild

## Target chapter
`blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` (NEW chapter — does not yet exist)

## Strategy context

The headline `genusZero_curve_iso_P1` (AVR L1141) — "a smooth proper geometrically irreducible curve over `k̄` with `genus = 0` is isomorphic to `ℙ¹_{k̄}`" — has been the project's RR-bridge sorry for 5+ iters with zero dispatch (progress-critic iter-171 verdict: **STUCK by inaction**, dishonest-estimate signature). iter-170 deferred to "upstream Mathlib"; iter-171 reverses to an **in-tree sub-build COMMITMENT** per `analogies/rrbridge-survey.md` option (1).

The standard Hartshorne IV.1.3.5 proof decomposes into 4 sub-phases:
- **RR.1** Weil divisor of a closed point on a 1-dimensional regular scheme — the foundational building block.
- **RR.2** Riemann–Roch dimension formula on a genus-0 curve (the precise statement: `l(D) = deg(D) + 1` for `deg(D) ≥ 0`).
- **RR.3** Linear-equivalence + `𝒪_C(P)` global-sections argument: for any closed point `P`, `dim_k H^0(C, 𝒪_C(P)) = 2`, the two sections being `1` and a non-constant function.
- **RR.4** "rational curve ⟹ `≅ ℙ¹`" — pulling back the two sections via `Proj.fromOfGlobalSections` produces a morphism `C → ℙ¹` which is degree-1 hence an isomorphism.

**iter-171 commits to writing the RR.1 sub-phase chapter** — the smallest, **parallel-startable** entry, requiring NO Mathlib RR / Pic infrastructure (just divisors on a scheme, which Mathlib does not ship and which the project will build in-tree). RR.2/RR.3/RR.4 follow in subsequent iters.

Your job: write a NEW chapter `RiemannRoch_WeilDivisor.tex` that is **prover-ready** for iter-172 to dispatch a file-skeleton lane on `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`. The chapter declares `% archon:covers AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` at the top.

## Required content

The chapter must contain (in order):

1. **`% archon:covers AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`** at the top.

2. **Section "Setup and motivation"** — one paragraph explaining the role within the genus-0 RR sub-build (RR.1 / 4): we need the formal-sum-of-codim-1-points data structure that subsequent sub-phases (`l(D)`, linear equivalence, `𝒪_C(D)`) consume. The construction is project-bespoke (Mathlib has no `WeilDivisor` on a scheme); the only adjacent Mathlib pieces are `MeromorphicOn.divisor` (analytic / normed-field, NOT a formal-sum-on-scheme) and `CommRing.Pic` (ring-level only). The chapter establishes the formal divisor group `Div(X) = ⊕_{Z ⊂ X codim 1} ℤ` on a Noetherian scheme `X`, plus the principal-divisor map and the divisor of a Cartier divisor.

3. **`\begin{definition}[Codim-1 cycle group]` block** with `\label{def:codim1_cycles}` and `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (project-bespoke). Source: **Hartshorne II §6 p.130** (definition of `Div(X)` = free abelian group on integral closed subschemes of codim 1) + **Stacks tag 02RW**. Required content of the definition: for a Noetherian integral scheme `X`, the group `Div(X)` is the free abelian group on the set of codim-1 integral closed subschemes of `X` (equivalently, prime divisors). Verbatim `% SOURCE QUOTE:` from `references/hartshorne-algebraic-geometry.pdf` (read pages 130–131 via `pages: "130-131"`).

4. **`\begin{definition}[Divisor of a closed point on a curve]` block** with `\label{def:divisor_closed_point}` and `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}`. Statement: for a smooth proper curve `C` over a field `k` and a closed point `P ∈ C`, the associated Weil divisor `[P] ∈ Div(C)` is the prime divisor `P` itself (well-defined since `P` is automatically codim-1 on a 1-dim scheme). Provide a verbatim `% SOURCE QUOTE:` block — Hartshorne IV.1 p.294 or Stacks tag **02RW**.

5. **`\begin{definition}[Degree of a divisor on a curve over `k̄`]` block** with `\label{def:divisor_degree}` and `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}`. Statement: for `C` a smooth proper curve over an algebraically closed field `k̄`, the degree map `deg : Div(C) → ℤ` is `deg(∑ n_P [P]) = ∑ n_P` (where each `[P]` has degree 1 over an alg-closed field). Source: Hartshorne IV.1.3 (p.295) or Stacks tag **0BE0**. Verbatim `% SOURCE QUOTE:`.

6. **`\begin{theorem}[Degree is a group homomorphism]` block** with `\label{thm:divisor_degree_hom}` and `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}`. Statement: `deg : Div(C) → ℤ` is a group homomorphism (`deg(D₁ + D₂) = deg(D₁) + deg(D₂)`). Trivial proof (free abelian group → ℤ via the basis count); included for the prover's record.

7. **`\begin{definition}[Order of a rational function at a point]` block** with `\label{def:order_at_point}` and `\lean{AlgebraicGeometry.Scheme.RationalMap.order}`. Statement: for `C` a smooth proper curve over `k̄`, `P ∈ C` a closed point, and `f` a nonzero rational function on `C` (i.e. `f ∈ k(C)^×`), the order `ord_P(f) ∈ ℤ` is the standard discrete-valuation-ring order in `𝒪_{C,P}` (which is a DVR by smoothness + dim 1). Source: Hartshorne II.6.3 (p.131) + Stacks tag **02ME**. Verbatim `% SOURCE QUOTE:` from Hartshorne.

8. **`\begin{definition}[Principal divisor]` block** with `\label{def:principal_divisor}` and `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}`. Statement: for `f ∈ k(C)^×`, the principal divisor `div(f) := ∑_P ord_P(f) [P]` is well-defined (only finitely many `ord_P(f)` are nonzero, since `f` has only finitely many zeros and poles on a proper curve). Source: Hartshorne II.6.4 (p.131). Verbatim `% SOURCE QUOTE:`.

9. **`\begin{theorem}[Principal-divisor map is a group homomorphism]` block** with `\label{thm:principal_hom}` and `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}`. Statement: `div : k(C)^× → Div(C)` is a group homomorphism. Source: Hartshorne II.6.A (p.132) "shows that `Div : f ↦ (f)` is a homomorphism from `k(C)^×` to `Div(C)`". Provide a brief informal proof sketch (`ord_P(fg) = ord_P(f) + ord_P(g)` by the DVR axiom; each term is additive; finite-supportedness sums to finite-supportedness).

10. **`\begin{theorem}[Principal divisors have degree 0 on a proper curve]` block** with `\label{thm:principal_deg_zero}` and `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}`. Statement: for `C` a smooth proper curve over `k̄` and `f ∈ k(C)^×`, `deg(div(f)) = 0`. Source: Hartshorne II.6.10 (p.137) or Stacks tag **0BE3**. Verbatim `% SOURCE QUOTE:`. The proof uses the fact that `f` defines a finite morphism `C → ℙ¹_{k̄}` and the pullback of `[0] - [∞]` is `div(f)`, then `deg ∘ pullback = (degree of f) * (degree of [0] - [∞])` = 0 since `[0]` and `[∞]` have the same degree on `ℙ¹`. **NOTE**: this theorem proof itself decomposes into a separate sub-build, but the STATEMENT is part of RR.1.

11. **Section "Divisor class group"** — one paragraph naming the quotient `Cl(C) := Div(C) / im(div)` (the **divisor class group**, also called the **Picard group of a curve**). Reference Hartshorne II.6.5–6.7 (pages 132–134) for context.

12. **`\begin{definition}[Linear equivalence]` block** with `\label{def:linear_equivalence}` and `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}`. Statement: two divisors `D₁, D₂ ∈ Div(C)` are linearly equivalent (`D₁ ∼ D₂`) iff `D₁ - D₂ = div(f)` for some `f ∈ k(C)^×`. Source: Hartshorne II.6.B (p.132). Verbatim `% SOURCE QUOTE:`.

13. **Section "Out of scope"** — one paragraph:
    - The `𝒪_C(D)` line-bundle construction and `H^0(C, 𝒪_C(D))` — that lives in `RiemannRoch_OcOfD.tex` (sub-phase RR.3, separate chapter).
    - The Riemann-Roch dimension formula `l(D) - l(K - D) = deg(D) + 1 - g` — that lives in `RiemannRoch_RRFormula.tex` (RR.2).
    - The "rational ⟹ ≅ ℙ¹" classification — that lives in `RiemannRoch_RationalIsoP1.tex` (RR.4).
    - Cartier divisors (as opposed to Weil divisors) — not needed for the smooth-curve case; defer to a future Mathlib upstream PR.
    - Higher-codim cycles — out of scope (this chapter is curve-focused).

14. **Source citation block** (above the first theorem) — `% SOURCE: Hartshorne, Algebraic Geometry, II §6 (pp. 130–137) + IV.1 (read from references/hartshorne-algebraic-geometry.pdf)` + Stacks tags. Reference resolution: `references/hartshorne-algebraic-geometry.pdf` is in tree.

15. **`\uses{}` annotations** on each theorem block, citing the prior block(s) it depends on.

## Out of scope

- Do NOT write the other 3 RR sub-phase chapters (RR.2/RR.3/RR.4). They are separate iters' work.
- Do NOT add `\leanok` or `\mathlibok` markers.
- Do NOT touch any other chapter file (your write-domain is `RiemannRoch_WeilDivisor.tex` only).
- Do NOT modify `content.tex` (the plan agent updates that to `\input` the new chapter).
- Do NOT cite a source you have not just read locally. If a needed reference is missing, dispatch the reference-retriever (your `--write-domain` authorizes `references/**`).

## References

- `references/hartshorne-algebraic-geometry.pdf` — Hartshorne II §6 (pp. 130–137) — divisors on curves, principal divisors, divisor class group; IV.1.3 (pp. 294–296) for the curve-specific specializations. Required for verbatim `% SOURCE QUOTE:`.
- `references/stacks-coherent.md` and underlying Stacks tex — Stacks tags 02RW (divisors), 02ME (order at a point), 0BE0/0BE3 (degree, principal-divisor degree-0).
- `analogies/rrbridge-survey.md` — the iter-168 Mathlib survey verifying the gap. Required reading for the in-scope/out-of-scope decisions.

## Expected outcome

A NEW chapter file `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` of ~200–300 lines containing the declaration blocks above with verbatim source quotes from the local reference files. The chapter is prover-ready: iter-172 can dispatch a file-skeleton lane on `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (~400–600 LOC target). First line declares `% archon:covers AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`. No `\leanok` / `\mathlibok` markers.
