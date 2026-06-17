# Refactor directive — scaffold `CechBridge.lean` (new downstream bridge file)

## Goal
Create a new, empty-of-declarations Lean file `AlgebraicJacobian/Cohomology/CechBridge.lean` and wire
it into the project barrel, so a prover can fill `cechComplex_hom_identification` (and later
`injective_cech_acyclic`, `ses_cech_h1`, `cech_to_cohomology_on_basis`) into it next phase.

## Why a new file (architecture)
`cechComplex_hom_identification : Hom(K(𝒰)_•, F) ≅ Č•(𝒰, F)` needs BOTH:
- `AlgebraicGeometry.sectionCechComplex` (in `PresheafCech.lean`), and
- `AlgebraicGeometry.cechFreePresheafComplex` (in `FreePresheafComplex.lean`).
The current import direction is `FreePresheafComplex.lean` **imports** `PresheafCech.lean`. So a file
that needs both must sit DOWNSTREAM of `FreePresheafComplex.lean`. That is the new `CechBridge.lean`.
(This is exactly why the iter-016 PresheafCech prover was cross-file blocked.)

## Exact changes
1. Create `AlgebraicJacobian/Cohomology/CechBridge.lean` with:
   - the same license/import header style as `FreePresheafComplex.lean`;
   - `import Mathlib`
   - `import AlgebraicJacobian.Cohomology.CechHigherDirectImage`
   - `import AlgebraicJacobian.Cohomology.PresheafCech`
   - `import AlgebraicJacobian.Cohomology.FreePresheafComplex`
   - `open CategoryTheory Limits`
   - `namespace AlgebraicGeometry` ... `end AlgebraicGeometry`
   - a module docstring describing the file's purpose: the bridge/assembly layer that consumes the
     section Čech complex (`sectionCechComplex`) and the free presheaf complex
     (`cechFreePresheafComplex`) to build `cechComplex_hom_identification`, and (later)
     `injective_cech_acyclic`, `ses_cech_h1`, `cech_eq_cohomology_of_basis` → `affine_serre_vanishing`.
   - a `/- Planner strategy: ... -/` comment block for `cechComplex_hom_identification`: per-degree
     `Ab`-iso `(K(𝒰)_p ⟶ F) ≅ ∏_σ F(⨅σ)` built from `AlgebraicGeometry.freeYonedaHomAddEquiv`
     (PresheafCech) + a biproduct/coproduct-hom-as-product equiv (`Hom(∐ A, F) ≅ ∏ Hom(A,F)` via
     `preadditiveYoneda` preservation or hand-rolled `Sigma.desc`/`Sigma.ι`), then intertwine the
     differentials and assemble with `HomologicalComplex.Hom.isoOfComponents`. Target category is
     abelian groups (Ab), matching `sectionCechComplex : CochainComplex Ab ℕ`.
   - **NO declarations** (no `def`/`lemma`/`theorem`). The file must compile (it is just imports +
     namespace + comments). Do NOT insert any `sorry`.
2. Add `import AlgebraicJacobian.Cohomology.CechBridge` to the barrel `AlgebraicJacobian.lean`
   (append after the `FreePresheafComplex` import line so import order respects the dependency).

## Constraints
- Do NOT modify any other `.lean` file's contents (only create `CechBridge.lean` + append the one
  barrel import line).
- Do NOT touch `archon-protected.yaml` (no protected decl is moved).
- After the change, the project must `lake build` green (an imports-only file with no decls compiles).

## Report back
Confirm the file was created, the barrel import added, and the build is green.
