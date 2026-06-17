# Refactor Report

## Slug
m2a-scaffold-iter126

## Status
COMPLETE

## Directive

### Problem
The M2.a sub-step of the genus-0 Albanese-witness argument requires a named
project Lean declaration `AlgebraicGeometry.rigidity_over_kbar`. Iter-126 is
the M2.a SCAFFOLD step: introduce the named declaration with a `sorry` body
matching `blueprint/src/chapters/RigidityKbar.tex` § Statement, NOT close the
body. Body closure is iter-149+ work gated on the shared cotangent-vanishing
Mathlib pile.

### Changes Requested
- Create `AlgebraicJacobian/RigidityKbar.lean` with the named declaration
  `AlgebraicGeometry.rigidity_over_kbar` and a single `sorry` body.
- Add `import AlgebraicJacobian.RigidityKbar` to the umbrella
  `AlgebraicJacobian.lean` (which uses explicit per-module imports).

## Changes Made

### File: `AlgebraicJacobian/RigidityKbar.lean` (NEW)
- **What:** Created the new file with the named declaration
  `AlgebraicGeometry.rigidity_over_kbar` and a single `sorry` body. Uses
  the directive-recommended Option B encoding for the source curve (see
  Encoding-choice note below).
- **Why:** Per directive — landing the scaffold so the blueprint chapter's
  `\lean{AlgebraicGeometry.rigidity_over_kbar}` reference resolves and the
  M2.b iter-127 scaffold has a consumer surface to refer to.
- **Cascading:** None. The declaration is project-internal scaffolding with
  no current in-tree consumer.

### File: `AlgebraicJacobian.lean` (UPDATED)
- **What:** Added one line `import AlgebraicJacobian.RigidityKbar` between
  the existing `Rigidity` and `Genus` imports.
- **Why:** The umbrella module uses explicit per-module imports; the new
  file is picked up by the umbrella so downstream consumers (M2.b iter-127
  scaffold) see it.
- **Cascading:** None.

## Encoding Choice (Option B per Directive)

The directive offered two encodings of the source `ℙ¹_{k̄}`:

- **Option A** — Literal `Over.mk (Spec.map (CommRingCat.ofHom (MvPolynomial.C (R := kbar))))`.
- **Option B** — Abstract characterisation: smooth proper geometrically
  irreducible curve over `k̄` of relative dimension `1` with `genus C = 0`.

The literal Option A as written in the directive is mathematically wrong:
`Spec.map (CommRingCat.ofHom MvPolynomial.C)` yields the affine-space
morphism `Spec(MvPolynomial σ kbar) ⟶ Spec kbar`, not the projective line.
A `leansearch` confirms Mathlib `b80f227` ships `AlgebraicGeometry.Proj`
(the general `Proj` of a graded ring) and `AlgebraicGeometry.AffineSpace`
but NO canonical `ProjectiveSpace n S` packaged as a `Scheme.Over S`.

Per the directive's explicit guidance ("favor Option B if Mathlib's
`ProjectiveSpace` API is not directly applicable"), the refactor went with
Option B. The chosen signature is:

```lean
theorem rigidity_over_kbar
    {C : Over (Spec (.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom]
    [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    (_hgenus : genus C = 0)
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : C ⟶ A)
    (p : 𝟙_ (Over (Spec (.of kbar))) ⟶ C)
    (_hf : p ≫ f = η[A]) :
    f = (toUnit C ≫ η[A]) :=
  sorry
```

This encodes "ℙ¹_{k̄}" as "smooth proper geometrically irreducible curve
over `k̄` of relative dimension `1` with `genus C = 0`" via the project's
existing `AlgebraicGeometry.genus` (from `AlgebraicJacobian/Genus.lean`,
defined as `dim_k H¹(C, 𝒪_C)`). This is exactly what the proof decomposition
C.2.c–C.2.d consume: the keystone uses the curve's `H¹(·, 𝒪) = 0` ↔
`genus = 0` characterisation, not a literal `ℙ¹` API.

The `η[A]` notation (group-object identity) resolved without extra imports
because `Rigidity.lean`'s pre-existing `open … MonObj` propagates through
the import chain.

## New Sorries Introduced
- `AlgebraicJacobian/RigidityKbar.lean:75` — body of `rigidity_over_kbar`,
  the iter-126 scaffold sorry. Closure deferred to iter-149+ pending the
  shared cotangent-vanishing pile (see directive + RigidityKbar.tex
  § "The shared cotangent-vanishing Mathlib pile").

## Compilation Status
- `AlgebraicJacobian/RigidityKbar.lean`: compiles cleanly via direct
  `lake env lean` invocation. Only diagnostic is the expected
  `declaration uses 'sorry'` warning at line 75.
- `AlgebraicJacobian.lean` (umbrella): compiles cleanly via direct
  `lake env lean` invocation, no diagnostics.
- Sorry count audit via `sorry_analyzer.py AlgebraicJacobian/ --format=summary`:
  ```
  Sorry Summary: 3 total across 3 file(s)
    AlgebraicJacobian/Differentials.lean: 1 sorries
    AlgebraicJacobian/Jacobian.lean: 1 sorries
    AlgebraicJacobian/RigidityKbar.lean: 1 sorries
  ```
  Matches the directive's "Expected Outcome": 2 → 3.

## Notes for Plan Agent

1. **Encoding deviation from directive's literal signature.** The directive's
   literal `f : ℙ¹_{k̄} → A` signature used
   `Over.mk (Spec.map (CommRingCat.ofHom (MvPolynomial.C (R := kbar))))`
   for the source, which encodes affine — not projective — space. Per the
   directive's explicit Option-A/Option-B fallback (favouring Option B if
   the Mathlib `ProjectiveSpace` API isn't directly applicable), the
   refactor agent picked **Option B**: abstract source curve characterised
   by `SmoothOfRelativeDimension 1 + IsProper + GeometricallyIrreducible +
   genus C = 0`. The blueprint chapter `RigidityKbar.tex` should be updated
   to reflect this Option-B encoding so the `\lean{…}` reference and the
   informal statement match. Specifically:

   - The chapter's "Statement" block currently reads "Let `f : ℙ¹_{k̄} → A`";
     this should become something like "Let `C` be a smooth proper
     geometrically irreducible curve over `k̄` of genus 0, and let
     `f : C ⟶ A`". A short editorial note in the chapter
     (`% Note: encoded abstractly via genus(C) = 0 — see refactor report`)
     is sufficient.
   - The proof-decomposition discussion (C.2.b/c/d/e) is unchanged: those
     steps already work for any smooth proper geometrically integral
     genus-0 curve over `k̄`.

2. **`η[A]` notation worked.** No extra imports beyond
   `AlgebraicJacobian.Rigidity` were needed; the pre-existing
   `open … MonObj` in this project's files propagates correctly.

3. **No existing in-tree encoding of `ℙ¹_{k̄}` was found** (searched
   `Jacobian.lean`, `AbelJacobi.lean`, `Rigidity.lean`, `Genus.lean`).
   The Option-B abstraction is therefore the cleanest path forward.

4. **M2.b iter-127 scaffold reminder.** The M2.b consumer
   (iter-127, `JacobianWitness C` branch on `C(k) ≠ ∅`) will need to
   either base-change `C` to `kbar` and invoke `rigidity_over_kbar` there,
   then Galois-descend back to `k`, OR introduce a `k`-base-level mirror
   of `rigidity_over_kbar`. Either route remains compatible with the
   Option-B abstract source encoding chosen here. The
   `Galois-descent_morphism_equality` remark in `RigidityKbar.tex` § "Use
   in the project" already anticipates the base-change route.

5. **No protected declarations were touched** (`archon-protected.yaml`
   read but not modified).
