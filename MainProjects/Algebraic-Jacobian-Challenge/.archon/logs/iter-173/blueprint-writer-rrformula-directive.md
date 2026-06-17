# Blueprint-writer directive — slug `rrformula`

## Target chapter

`blueprint/src/chapters/RiemannRoch_RRFormula.tex` (NEW chapter).

## Strategy phase

Genus-0 RR.2 — Riemann–Roch formula for genus 0. STRATEGY.md row gated on RR.1; RR.1 chapter `RiemannRoch_WeilDivisor.tex` landed iter-171 + file-skeleton landed iter-172. Without RR.2, RR.3 (`O_C(P)` global sections) + RR.4 (rational curve ⟹ ≅ ℙ¹) cannot proceed, and the final RR bridge `genusZero_curve_iso_P1` consumed by `AbelianVarietyRigidity.tex`'s `prop:genusZero_curve_iso_P1` stays blocked.

## Scope (4 declarations + proof-sketches)

Per the iter-173 `blueprint-reviewer route173` proposal — read its task result for the full outline. Core declarations:

1. `\definition` `\label{def:eulerChar_curve}` — Euler characteristic `χ(F) := Σ_i (-1)^i dim_{k̄} H^i(C, F)`. `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic}` [expected]. Source: Hartshorne IV §1 (formula 1.2.1).
2. `\definition` `\label{def:l_invariant}` — `ℓ(D) := dim_{k̄} H^0(C, O_C(D))`. `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l}` [expected]. Source: Hartshorne IV §1 (eq. (1.2)).
3. `\theorem` `\label{thm:euler_char_eq_deg_plus_one_minus_genus}` — `χ(O_C(D)) = deg(D) + 1 - g`. `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus}` [expected]. Source: Hartshorne IV Thm 1.3.
4. `\theorem` `\label{thm:riemannRoch_genus_zero}` — Genus-0 specialisation: `ℓ(D) = deg(D) + 1` for `deg(D) ≥ 0`. `\lean{AlgebraicGeometry.Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero}` [expected]. Source: Hartshorne IV.1.3.5.

## Constraints

- `% archon:covers AlgebraicJacobian/RiemannRoch/RRFormula.lean` at the top.
- Each declaration block: `% SOURCE: <pointer> (read from references/<file>)` + `% SOURCE QUOTE: <verbatim>`. **You must open the local file and quote verbatim from `references/hartshorne-algebraic-geometry.pdf` (IV §1, pp. 294–296).** Authorize `--write-domain 'references/**'` so the retriever can fill any gaps.
- Stay within the chapter scope: RR.2 only. Do NOT pull RR.3 (`O_C(P)` global sections) or RR.4 (rational curve ≅ ℙ¹) content forward.
- **NEVER** add `\leanok` or `\mathlibok` markers.

## Sub-phase choices (planner directives)

1. **Serre duality vs. direct χ**: per the iter-173 reviewer proposal, **use the direct χ inductive proof**, NOT Serre duality (Mathlib has no dualizing sheaf). Document this in `% NOTE:`.

2. **Genus-0 carve-out vs. general g**: per the reviewer proposal, **restrict to `g = 0`** (matching STRATEGY.md row 2's intent; general genus is downstream and not needed for the genus-0 critical path). Document this in `% NOTE:`.

## Authorization

- `--write-domain 'blueprint/src/chapters/RiemannRoch_RRFormula.tex'`
- `--write-domain 'references/**'` (the writer may dispatch a reference-retriever if any source needs fetching; `references/hartshorne-algebraic-geometry.pdf` exists, verify).

## Verification step

- 4 `\lean{...}` pins.
- 4 `% SOURCE:` + `% SOURCE QUOTE:` blocks (verbatim from Hartshorne IV §1).
- `\uses{...}` graph: roots in RR.1 (`def:codim1_cycles`, `def:divisor_degree`, `thm:principal_deg_zero`) + `Genus.tex` (`def:genus`).
- Chapter explicitly names "Mathlib has `CategoryTheory.ShortExact.eulerChar_additive`" as the additivity assumption that grounds the inductive proof — verify the Mathlib name and add a `[verified]` / `[expected]` tag.
