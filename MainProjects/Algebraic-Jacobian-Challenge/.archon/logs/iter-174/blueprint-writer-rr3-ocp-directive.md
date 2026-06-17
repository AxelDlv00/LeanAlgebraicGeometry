# Blueprint Writer Directive

## Slug
rr3-ocp

## Target chapter
`blueprint/src/chapters/RiemannRoch_OCofP.tex` (NEW)

## Lean file
`AlgebraicJacobian/RiemannRoch/OCofP.lean` (NEW).

Add `% archon:covers AlgebraicJacobian/RiemannRoch/OCofP.lean` at top.

## Strategy context

Genus-0 RR.3. Gated on RR.2 (`RiemannRoch_RRFormula.tex`, chapter on disk). ~400-600 LOC, ~3-5 iters.

Per Hartshorne IV.1.3.4: for a smooth proper genus-0 curve `C` over an algebraically closed field `k̄` and a closed point `P ∈ C(k̄)`, the global sections of `O_C(P)` form a `k̄`-vector space of dimension 2.

This is the step that extracts a non-constant rational function `f : C ⇢ ℙ¹` from a genus-0 curve, feeding RR.4 (`C ≅ ℙ¹`).

## Required content

### Definition: invertible sheaf at a point `O_C(P)`
For a closed point `P ∈ C(k̄)` of a smooth curve `C`, define `O_C(P)` as the locally free sheaf of rank 1 obtained by twisting `O_C` along the prime divisor `[P]`. Cite Hartshorne II.6 for the construction.

Reuse `Scheme.PrimeDivisor` and `Scheme.WeilDivisor.ofClosedPoint` from `RiemannRoch_WeilDivisor.tex` — add a `\uses{def:divisor_closed_point}` pin to connect.

### Lemma: order at the marked point
`H^0(C, O_C(P))` consists of rational functions `f` on `C` with `(f) + [P] ≥ 0`, i.e. `ord_Q(f) ≥ 0` for all `Q ≠ P` and `ord_P(f) ≥ -1`. The standard interpretation.

### Theorem: `dim_{k̄} H^0(C, O_C(P)) = 2`
For `C/k̄` smooth proper geometrically irreducible of genus 0 and `P ∈ C(k̄)`, the Riemann-Roch formula gives
$$h^0(C, O_C(P)) - h^1(C, O_C(P)) = \deg(P) + 1 - g(C) = 1 + 1 - 0 = 2.$$
Combined with the **Serre duality** statement `h^1(C, O_C(P)) = h^0(C, K_C ⊗ O_C(-P))` and the (genus-0) computation `deg K_C = -2 ⇒ deg(K_C - P) = -3 < 0 ⇒ h^0 = 0`, this gives `h^0(C, O_C(P)) = 2`.

Cite RR.2 (`thm:riemann_roch_formula`) and either Hartshorne IV.1.3 for Serre duality, or substitute: in genus 0, Serre duality is `h^1(C, F) = h^0(C, F^∨ ⊗ K)^*` and the dualizing sheaf is `O_C(-2)`.

Wait — we don't have full Serre duality in Mathlib. For the **specific case** of `O_C(P)` on genus 0, the simpler argument: since `g=0`, RR says `h^0(O(P)) − h^1(O(P)) = 2`. Since `O_C(P)` has degree 1 > 0 and `g=0`, the Kodaira vanishing or direct sheaf argument: `H^1(C, O(P)) = 0` whenever `deg(L) > 2g-2 = -2`. So `h^0(O(P)) = 2`.

Write the proof using this **direct cohomological vanishing route** to AVOID Serre duality, which is itself a deep gap.

### Corollary: non-constant function
The 2-dimensional space `H^0(C, O_C(P))` contains 1 (the constants) as a 1-dimensional subspace; pick any element `f ∈ H^0(C, O_C(P)) \ k̄·1`. Then `f` is a non-constant rational function with at most a simple pole at `P` and no other poles. This `f` is the seed for RR.4 (the morphism `C → ℙ¹`).

### Lean signature targets

- `def:o_c_of_p` → `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint`
- `lem:o_c_of_p_global_sections_interpretation` → `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff`
- `thm:o_c_of_p_dim_two_genus_zero` → `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.dim_eq_two_of_genusZero`
- `cor:nonconstant_function_genus_zero` → `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.exists_nonconstant_genusZero`

## Required citations

Read verbatim from:
- `references/hartshorne-algebraic-geometry.pdf` IV.1 (genus, Riemann-Roch, sheaves of the form `L(D)`) — specifically IV.1.3.4 if it exists, otherwise IV.1 around the discussion of `L(D)` on curves.
- `references/stacks-coherent.md` for any tag on `h^1` vanishing of `O(D)` with `deg D > 2g-2`.

Per blueprint citation rules: `% SOURCE:` + `% SOURCE QUOTE:` + `\textit{Source: ...}`.

## Out of scope

- Do NOT write the Lean file.
- Do NOT invoke Serre duality at full generality (use the cohomological vanishing direct route).
- Do NOT scope `H^1(L) = 0 for deg L > 2g-2` as a project deliverable in THIS chapter — note it as a Mathlib-status flag (verify whether Mathlib has it; if not, factor it out into RR.2).
- Do NOT touch `content.tex`.

## Verification

`\input{...}` is the plan agent's job.

## Report format

Flag if the genus-0 `H^1(L) = 0` lemma is itself a gap that would block the proof; in that case, recommend splitting this chapter or pushing it into RR.2.
