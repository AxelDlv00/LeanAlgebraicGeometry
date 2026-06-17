# Blueprint Writer Directive

## Slug
a4d-albanese

## Target chapter
`blueprint/src/chapters/Albanese_AlbaneseUP.tex` (NEW)

## Lean file
`AlgebraicJacobian/Albanese/AlbaneseUP.lean` (NEW).

Add `% archon:covers AlgebraicJacobian/Albanese/AlbaneseUP.lean` at top.

## Strategy context

Route A.4.d — gated on A.3 (`Pic⁰` identity component + degree map) and A.4.c (Thm 3.2 rational-map-extension). ~300-500 LOC, ~3-5 iters.

This is the final wiring: the Albanese universal property of `Pic⁰_{C/k}`, namely that every pointed morphism `f : C → A` to an abelian variety factors uniquely through `Pic⁰_{C/k}` via the Abel-Jacobi morphism.

Per Milne *Abelian Varieties* Proposition 6.1 / Proposition 6.4.

## Required content

### Theorem: Albanese universal property of `Pic⁰_{C/k}`
Statement (Milne III §6, Proposition 6.1): For a smooth proper geometrically irreducible curve `C/k` over an algebraically closed field `k̄`, with a marked point `P₀ ∈ C(k̄)`, the Abel-Jacobi morphism
$$\iota_{P_0} : C \to \mathrm{Pic}^0_{C/k}, \qquad Q \mapsto [\mathcal O_C(Q - P_0)]$$
is universal: for every pointed morphism `f : C → A` to an abelian variety `A` with `f(P_0) = \eta_A`, there exists a unique morphism of group schemes `g : Pic⁰_{C/k} → A` such that `f = g ∘ ι_{P_0}`.

### Proof outline (Milne §III.6 verbatim, then project notation)

Quote the Milne proof verbatim. Then split into sub-steps:

1. **Abel-Jacobi rational map**. Extend `\iota_{P_0}` to a rational map `Sym^g C ⇢ Pic^0` via the Abel-Jacobi formula `\sum P_i ↦ [\sum P_i - g P_0]`. Use Pic⁰ from A.2.c.

   Actually: for the project's formulation, we work directly at the level `C → Pic⁰`, not `Sym^g C → Pic⁰`, since we have the FGA representability already (`Pic⁰_{C/k}` is a group scheme).

2. **Universal property of `Pic^0`**. Given `f : C → A` with `f(P_0) = \eta_A`, consider the Poincaré bundle `L_A` on `A × A` (or `A × A^∨`). Pull back via `f × id : C × A → A × A` to get a line bundle on `C × A` trivialized along `{P_0} × A`. This corresponds to an `A`-point of `Pic⁰_{C/k}` (since `Pic⁰` is the moduli space of such line bundles), giving a morphism `A → Pic⁰_{C/k}`. The expected adjoint is `g : Pic⁰_{C/k} → A`.

3. **Use Thm 3.2 (A.4.c) to extend `g` if needed**. If the construction (2) produces a rational map rather than a regular morphism, invoke Thm 3.2.

4. **Verify factorization**. Compose `g ∘ ι_{P_0}` and verify it equals `f`; uniqueness from `Pic⁰` representability + the universal property of the Poincaré bundle.

### Sub-lemmas

- **`lem:abel_jacobi_morphism`** — `ι_{P_0} : C → Pic^0_{C/k}` is a regular morphism, sending `P_0` to the identity. Gates on A.3.
- **`lem:poincare_bundle_pullback`** — `(f × id)*L_A` is a line bundle on `C × A` trivialized along `{P_0} × A`.
- **`lem:moduli_pullback_morphism`** — A line bundle on `C × A` trivialized along `{P_0} × A` corresponds via `Pic⁰`-representability to a morphism `A → Pic⁰_{C/k}`.
- **`thm:albanese_universal_property`** — the main statement.

### Lean signature targets

- `lem:abel_jacobi_morphism` → `AlgebraicGeometry.Pic0.abelJacobi`
- `lem:poincare_bundle_pullback` → `AlgebraicGeometry.Pic0.poincareBundlePullback`
- `lem:moduli_pullback_morphism` → `AlgebraicGeometry.Pic0.moduliPullbackMorphism`
- `thm:albanese_universal_property` → `AlgebraicGeometry.Pic0.albanese_universal_property`

## Required citations

Read verbatim from:
- `references/abelian-varieties.pdf` §III.6 Proposition 6.1 + Proposition 6.4 (pp. 104-110).
- `references/kleiman-picard.pdf` for the Picard-scheme formulation if Milne's gloss is too thin.

`% SOURCE:` + `% SOURCE QUOTE:` + `\textit{Source: ...}`.

## Out of scope

- Do NOT write the Lean file.
- Do NOT re-prove Pic⁰ representability (gates on A.2.c).
- Do NOT re-prove Thm 3.2 (gates on A.4.c).
- Do NOT touch `content.tex`.

## Verification

`\input{...}` is the plan agent's job.

## Report format

Standard.
