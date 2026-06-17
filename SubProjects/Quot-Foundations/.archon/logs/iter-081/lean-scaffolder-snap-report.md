# lean-scaffolder report — slug: snap

**Status: SUCCESS**

## File modified

`AlgebraicJacobian/Picard/SectionGradedRing.lean`

## Changes

### 1. New import added (line 1)

```lean
import Mathlib.Algebra.GradedMonoid
```

`GradedMonoid.GMul`/`GradedMonoid.GOne` are not in the file's transitive imports; this import was
required for the `GMul`/`GOne` instance scaffolds and the coherence lemma signatures.

### 2. Scaffold block appended (lines 1802–1903)

Declarations added in namespace `AlgebraicGeometry.Scheme.Modules`, after `tensorPowAdd`, before
`end`:

| Decl | Kind | Blueprint label | Notes |
|------|------|-----------------|-------|
| `sectionDeg` | `abbrev` | (infrastructure) | Carrier type `↥((tensorPow L m).val.obj (op ⊤))`; no proof needed |
| `sectionsCast` | `noncomputable def` | `def:sectionsCast` | `sectionDeg L i ≃ₗ[Γ𝒪] sectionDeg L j`; ring spelled `↥(X.ringCatSheaf.obj.obj (op ⊤))` (new API, no deprecation) |
| `sectionsCast_refl` | `@[simp] lemma` | `lem:sectionsCast_refl` | `sectionsCast L rfl = LinearEquiv.refl _ _` |
| `gradedMonoid_eq_of_cast` | `lemma` | `lem:gradedMonoid_eq_of_cast` | Sigma-Eq bridge; body hint: `cases a; cases b; cases h; simpa [sectionsCast_refl]` |
| `GradedMonoid.GMul (sectionDeg L)` | `noncomputable instance` | (unlisted — needed for sig) | mul body `sorry`; see note below |
| `GradedMonoid.GOne (sectionDeg L)` | `noncomputable instance` | (unlisted — needed for sig) | one body `sorry`; see note below |
| `sectionsMul_one_mul` | `theorem` | `lem:sectionMul_coherent` | `sectionsCast L (zero_add n) (GMul.mul GOne.one a) = a` |
| `sectionsMul_mul_one` | `theorem` | `lem:sectionMul_coherent` | `sectionsCast L (add_zero n) (GMul.mul a GOne.one) = a` |
| `sectionsMul_mul_assoc` | `theorem` | `lem:sectionMul_coherent` | `sectionsCast L (add_assoc …) (GMul.mul (GMul.mul a b) c) = GMul.mul a (GMul.mul b c)` |
| `sectionsMul_mul_comm` | `theorem` | `lem:sectionMul_coherent` | `sectionsCast L (add_comm …) (GMul.mul a b) = GMul.mul b a` |

## Diagnostics

Final diagnostic check on the scaffold block (lines 1835–1904):
- **Errors: 0**
- **Warnings: 9 × `sorry`** (expected — all scaffold bodies are `sorry`)
- **Long-line warning:** fixed

## Uncovered declarations

Two instance scaffolds (`GradedMonoid.GMul (sectionDeg L)` and `GradedMonoid.GOne (sectionDeg L)`)
were added beyond the directive's list of 7 blueprint decls. These are **not separate blueprint
entries** but are required structural prerequisites for the coherence lemma signatures to typecheck:
`GradedMonoid.GMul.mul` and `GradedMonoid.GOne.one` are typeclass projections that need the instances
in scope. Without them the four `sectionsMul_*` theorems would have elaboration errors.

Per directive: the `GradedMonoid.GMonoid` / `DirectSum.GSemiring` / `DirectSum.GCommSemiring` /
`DirectSum.Gmodule` assembly instances remain **unscaffolded** — the prover constructs them from the
above bricks using the verbatim `TensorPower.Basic` assembly pattern (see planner strategy comment
in file at L1807–1830).

## Prover handoff notes

- `sectionsCast` body: `((eqToIso (congrArg (tensorPow L) h)).hom.val.app (op ⊤)).toLinearEquiv`
  or `LinearEquiv.ofLinear` from the iso components; `toLinearEquiv` may require a `ModuleCat`
  iso-to-LinearEquiv bridge (check `ModuleCat.isoToLinearEquiv` or `CategoryTheory.Iso.toLinearEquiv`).
- `sectionsCast_refl`: `eqToIso_refl`, `Iso.refl`, functor `map_id`, then `simp`.
- `gradedMonoid_eq_of_cast`: `cases a; cases b; cases h; simp [sectionsCast_refl]` should close it.
- Coherence proofs: naturality of sheafification unit η through `tensorObjAssoc`/`tensorObjUnitIso`/
  `tensorPowAdd`; presheaf-level evaluation at `op ⊤` is strict monoidal (ModuleCat monoidal).
- `GMul.mul` body: `(tensorPowAdd L i j).hom.val.app (op ⊤) (sectionsMul (tensorPow L i) (tensorPow L j) (a ⊗ₜ b))`.
- `GOne.one` body: unit via `tensorPow_zero` + canonical `Γ𝒪 ≅ Γ(unitModule X)` (ring unit image).
- `import Mathlib.Algebra.DirectSum.Ring` will be needed when the prover adds the `GSemiring`/
  `GCommSemiring` instances.
