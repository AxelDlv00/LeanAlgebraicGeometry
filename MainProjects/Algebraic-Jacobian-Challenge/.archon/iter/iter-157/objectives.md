# Iter-157 objectives detail

## Lane 1 (DEEP) — `AlgebraicJacobian/AbelianVarietyRigidity.lean` : `rigidity_lemma`

**Target:** `AlgebraicGeometry.rigidity_lemma` (the Rigidity Lemma, Mumford *Abelian
Varieties*, Form I, Ch. II §4 p.43). Cube-free, prover-ready entry of route (c). Blueprint:
`chapters/AbelianVarietyRigidity.tex` `thm:rigidity_lemma` (+ `rmk:rigidity_lemma_cube_free`).

**Scaffolded signature (refactor, iter-157):** `f : (X ⊗ Y) ⟶ Z` with `[IsProper X.hom]`,
collapse hypothesis `lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀`; conclusion
`∃ g : Y ⟶ Z, f = snd X Y ≫ g`. Cartesian-monoidal product; the prover owns the file and may
re-encode (e.g. `Limits.prod`) if cleaner.

**Proof recipe (Mumford, verbatim in the chapter):**
1. Fix `x₀ ∈ X`, define `g := (y ↦ f(x₀, y))`.
2. `U` affine open ∋ `z₀`; `F = Z ∖ U`; `G = p₂(f⁻¹ F)`.
3. `X` complete ⟹ `p₂ : X × Y → Y` is a CLOSED map ⟹ `G` closed in `Y`.
4. `y₀ ∉ G` (since `f(X×{y₀}) = {z₀} ⊆ U`), so `V := Y ∖ G` is nonempty open.
5. For `y ∈ V`: `f(X×{y}) ⊆ U`; `X×{y}` proper connected → affine `U` ⟹ image a point ⟹
   `f(x,y) = f(x₀,y) = g(y)`.
6. `f` and `snd ≫ g` agree on the dense open `X×V` of the irreducible `X×Y`; `Z` separated
   ⟹ agree everywhere.

**Mathlib bridges to locate (use `lean_leansearch`/`lean_loogle`, do NOT pre-trust names):**
- "proper morphism ⇒ base-change projection is a closed map" — `[expected]` Mathlib has
  `IsProper`/`UniversallyClosed`/`IsClosedMap` API.
- "a proper connected scheme over a field mapping to an affine scheme has image a single
  point" (global sections of a proper connected scheme over `k̄` are just `k̄`) — `[expected]`
  may need `AlgebraicGeometry.IsProper` + `H⁰`-constant; possibly a small build.

**Out of scope (reviewer caveat):** do NOT touch `morphism_P1_to_grpScheme_const` (blocked on
the deferred theorem of the cube) or `genusZero_curve_iso_P1` (blocked on absent Riemann–Roch).
Single deep lane on `rigidity_lemma`.

**Reversal signal:** if the categorical encoding fights the point-set proof badly (the
fast-path review flagged the point-set→categorical bridge as the real difficulty), the prover
may re-encode the statement; if even that stalls, next iter consult mathlib-analogist on the
"proper ⇒ closed projection / proper-connected → affine constant" idioms before re-dispatch.
