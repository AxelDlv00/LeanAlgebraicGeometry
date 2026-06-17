# Blueprint Writer Directive

## Slug
rr4-rational-iso-p1

## Target chapter
`blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex` (NEW)

## Lean file
`AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (NEW).

Add `% archon:covers AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` at top.

## Strategy context

Genus-0 RR.4 — gated on RR.3 (`RiemannRoch_OCofP.tex`, NEW THIS ITER). ~400-600 LOC, ~3-5 iters.

This finishes the RR-bridge: a smooth proper geometrically irreducible curve of genus 0 over `k̄` with a `k̄`-rational point is isomorphic to `ℙ¹_{k̄}`. Per Hartshorne IV.1.3.5.

The output is the `genusZero_curve_iso_P1` Lean target (currently `sorry` in `AbelianVarietyRigidity.lean` L290) — once RR.1 + RR.2 + RR.3 + RR.4 land, this gets concrete.

## Required content

### Theorem: genus-0 + `k̄`-point ⟹ `≅ ℙ¹`
Statement: For `C/k̄` smooth proper geometrically irreducible curve of genus 0 over an algebraically closed field `k̄`, with a marked point `P ∈ C(k̄)`, there is an isomorphism of `k̄`-schemes
$$\varphi : C \xrightarrow{\;\sim\;} \mathbb P^1_{\bar k}.$$

### Proof outline (Hartshorne IV.1.3.5)

1. **Non-constant function**. Apply RR.3 (`cor:nonconstant_function_genus_zero`) to get `f ∈ H^0(C, O_C(P)) \ k̄·1`.
2. **Morphism to `ℙ¹`**. The pair `(1, f)` defines a morphism `\varphi : C → \mathbb P^1_{\bar k}` via the standard linear-system construction (Mathlib `Proj.fromOfGlobalSections`). Specifically: `\varphi^{-1}(\infty) = (f)_\infty = [P]` (the single point where `f` has a pole), and `\varphi(P) = \infty`.
3. **Degree of `\varphi`**. The degree of `\varphi` is the number of preimages of any closed point counted with multiplicity. The pole-divisor `(f)_\infty = [P]` has degree 1, so `\deg \varphi = 1`.
4. **Degree-1 ⟹ isomorphism**. A non-constant morphism `\varphi : C → C'` between smooth proper curves of degree 1 is an isomorphism. Reason: `\varphi_* O_C / O_{C'}` is a torsion-free module of rank `deg \varphi - 1 = 0`, hence zero; so `\varphi` is birational, and birational between proper smooth varieties means isomorphism.

### Sub-lemmas

- **`lem:morphism_to_p1_from_function`** — Given `(g_0, g_1) ∈ H^0(C, L)^2` with `L` an invertible sheaf and `(g_0, g_1)` generating `L` at every point (i.e. no common zeros), there exists a morphism `\varphi : C → \mathbb P^1` whose pullback of `O(1)` is `L`. Reference: Mathlib's `AlgebraicGeometry.Proj.fromOfGlobalSections` / `Proj.fromOfGlobalSections.lift` API.
- **`lem:degree_of_finite_morphism_via_pole_divisor`** — For a non-constant `\varphi : C → \mathbb P^1`, `\deg(\varphi) = \deg((\varphi^*[\infty]))`. Reference: Hartshorne II.6.10 + IV.1.
- **`lem:degree_one_morphism_iso`** — A degree-1 finite morphism between smooth proper geometrically irreducible curves is an isomorphism. Reference: Hartshorne IV.2 / Stacks 0AVX.

### Lean signature targets

- `lem:morphism_to_p1_from_global_sections` → `AlgebraicGeometry.Scheme.morphismToP1OfGlobalSections`
- `lem:degree_via_pole_divisor` → `AlgebraicGeometry.Scheme.morphism_degree_via_pole_divisor`
- `lem:degree_one_morphism_iso` → `AlgebraicGeometry.Scheme.iso_of_degree_one`
- `thm:genus_zero_curve_iso_p1` → `AlgebraicGeometry.genusZero_curve_iso_P1`

The last matches the existing pinned Lean target in `AbelianVarietyRigidity.lean` L290.

## Required citations

Read verbatim from:
- `references/hartshorne-algebraic-geometry.pdf` IV.1 (specifically Example/Proposition IV.1.3.5 if it exists with that numbering; otherwise search for "genus 0 implies ℙ¹" in IV.1).
- `references/hartshorne-algebraic-geometry.pdf` IV.2 (degree-1 morphism = iso) — Hartshorne IV.2.1 or thereabouts.

`% SOURCE:` + `% SOURCE QUOTE:` + `\textit{Source: ...}`.

## Out of scope

- Do NOT write the Lean file.
- Do NOT touch `content.tex`.
- Do NOT prove RR.3 inside this chapter — cite it via `\uses{cor:nonconstant_function_genus_zero}`.
- Do NOT scope to the `k`-base case (RR.4 is only the `k̄` case; the `k → k̄` descent is a separate sub-build in `Jacobian.tex` `genusZeroWitness.key`).

## Verification

`\input{...}` is the plan agent's job.

## Report format

Flag if `Proj.fromOfGlobalSections` is the wrong Mathlib API (verify by `lean_local_search` or by `WebFetch` of Mathlib docs at `AlgebraicGeometry/ProjectiveSpectrum`).
