# Refactor Directive

## Slug
differentials-signatures-iter113

## Problem

`AlgebraicJacobian/Differentials.lean` carries three pre-existing
signature mismatches between Lean and the blueprint
(`blueprint/src/chapters/Differentials.tex`). All three were latent and
surfaced iter-112 by `lean-vs-blueprint-checker-differentials-iter112`
(report at `.archon/task_results/lean-vs-blueprint-checker-differentials-iter112.md`).
The review agent added 3 `% NOTE:` annotations to the chapter
documenting the mismatches; this refactor directive operationalizes the
corrections on the Lean side.

The three mismatches:

1. **`smooth_iff_locally_free_omega` (L816)** — Lean uses dimension-free
   `Smooth f` predicate plus a free standalone `(n : ℕ)` parameter. The
   biconditional `Smooth f ↔ locally rank n` for free `n` is
   structurally unsatisfiable (two different `n` values would give
   logically-equivalent LHS but inequivalent RHS).
   Blueprint prose: "Let `f : X → S` be a finite-presentation morphism
   of schemes. Then `f` is **smooth of relative dimension n** if and
   only if `Ω_{X/S}` is locally free of rank `n` as a sheaf of
   `O_X`-modules."

2. **`cotangent_at_section` (L832)** — same mismatch shape: hypothesis
   `(hsmooth : Smooth f)` is dimension-free while the conclusion talks
   about rank `n`. The parameter `(n : ℕ)` is unconstrained.
   Blueprint prose: "If `f : X → S` is **smooth of relative dimension
   n** and `s : S → X` is a section of `f`, then the cotangent space
   `s^*Ω_{X/S}` is a locally free `O_S`-module of rank `n`."

3. **`serre_duality_genus` (L976)** — Lean equation has BOTH sides at
   cohomological index `0`:
   ```
   Module.rank k (HModule k (toModuleKSheaf C) 0) =
     Module.rank k (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0)
   ```
   This says `dim H^0(O_C) = dim H^0(Ω_{C/k})`. For a smooth proper
   geometrically irreducible curve of genus g > 1 this is **false**:
   `H^0(O_C)` is 1-dimensional, `H^0(Ω_{C/k})` is g-dimensional.
   The local Lean docstring at L971–975 in fact agrees with the blueprint
   (mentions H^0 vs H^1), so the docstring contradicts the signature.
   Blueprint prose: `dim_k H^0(C, Ω_{C/k}) = dim_k H^1(C, O_C)`.

## Mathematical Justification

### 1. `smooth_iff_locally_free_omega`

The intended Mathlib predicate is `AlgebraicGeometry.IsSmoothOfRelativeDimension n f`
(verified iter-113 via `lean_leansearch`; location:
`Mathlib.AlgebraicGeometry.Morphisms.Smooth`; type signature:
`ℕ → {X Y : Scheme} → (X ⟶ Y) → Prop`). The smoothness predicate is
itself dimension-parameterized, so the rank parameter `n` flows from
the LHS smoothness hypothesis into the RHS rank condition. The
biconditional becomes structurally satisfiable: `IsSmoothOfRelativeDimension n f`
on the LHS pins the dimension, then asks the RHS rank to match.

### 2. `cotangent_at_section`

Same correction applied as hypothesis. The smoothness hypothesis
becomes `[IsSmoothOfRelativeDimension n f]` (as a typeclass) or
`(hsmooth : IsSmoothOfRelativeDimension n f)` (as a positional
hypothesis). The standalone `(n : ℕ)` parameter is preserved as the
rank parameter; the rank in the conclusion matches it.

### 3. `serre_duality_genus`

The Serre duality equation per the blueprint is
`dim_k H^0(C, Ω_{C/k}) = dim_k H^1(C, O_C)`. The correction:

- LHS = `H^0(Ω_{C/k})`: `Module.rank k (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0)`.
- RHS = `H^1(O_C)`: `Module.rank k (HModule k (toModuleKSheaf C) 1)`.

This is a swap of which sheaf gets which index. The `HModule` definition
(at `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:248`)
accepts an arbitrary cohomological index `n : ℕ`, so changing `0` to
`1` is a one-character signature edit with no downstream typing impact.

Additionally, the blueprint says "geometrically irreducible curve" but
the Lean has only `IsIntegral C.left`. **Do NOT add an
`IsGeometricallyIntegral` typeclass** — `AlgebraicGeometry.IsGeometricallyIntegral`
does not exist in Mathlib b80f227 (verified iter-113 via
`lean_leansearch`: only `Algebra.IsGeometricallyReduced` exists, on the
algebra side, not the scheme side). Keep `IsIntegral C.left` as-is for
this refactor — promoting to "geometrically" is a separate concern that
requires Mathlib infrastructure not yet present.

Similarly, the blueprint says "curve" (dimension 1) but the Lean has no
dimension hypothesis. **Do NOT add a dimension-1 hypothesis** — the
declaration is sorry-bodied and the dimension is implicit in the
intended use. A future refactor can tighten this if/when an active proof
attempt benefits.

## Changes Requested

### Change 1: `smooth_iff_locally_free_omega` signature

- File: `AlgebraicJacobian/Differentials.lean`
- Old (L816–823):
  ```lean
  theorem smooth_iff_locally_free_omega (f : X ⟶ S)
      (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f) (n : ℕ) :
      Smooth f ↔
        ∀ (x : X), ∃ (U : X.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
          let R := X.ringCatSheaf.presheaf.obj (.op U)
          let M := (relativeDifferentials f).val.obj (.op U)
          Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
    sorry
  ```
- New:
  ```lean
  theorem smooth_iff_locally_free_omega (f : X ⟶ S)
      (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f) (n : ℕ) :
      AlgebraicGeometry.IsSmoothOfRelativeDimension n f ↔
        ∀ (x : X), ∃ (U : X.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
          let R := X.ringCatSheaf.presheaf.obj (.op U)
          let M := (relativeDifferentials f).val.obj (.op U)
          Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
    sorry
  ```
- Only change: replace LHS `Smooth f` with `AlgebraicGeometry.IsSmoothOfRelativeDimension n f`. The RHS rank expression already references the parameter `n`; no other changes needed.

### Change 2: `cotangent_at_section` signature

- File: `AlgebraicJacobian/Differentials.lean`
- Old (L832–840):
  ```lean
  theorem cotangent_at_section (f : X ⟶ S)
      (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f)
      (s : S ⟶ X) (hs : s ≫ f = 𝟙 S) (n : ℕ)
      (hsmooth : Smooth f) :
      ∀ (x : S), ∃ (U : S.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
        let R := S.ringCatSheaf.presheaf.obj (.op U)
        let M := ((Scheme.Modules.pullback s).obj (relativeDifferentials f)).val.obj (.op U)
        Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
    sorry
  ```
- New:
  ```lean
  theorem cotangent_at_section (f : X ⟶ S)
      (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f)
      (s : S ⟶ X) (hs : s ≫ f = 𝟙 S) (n : ℕ)
      (hsmooth : AlgebraicGeometry.IsSmoothOfRelativeDimension n f) :
      ∀ (x : S), ∃ (U : S.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
        let R := S.ringCatSheaf.presheaf.obj (.op U)
        let M := ((Scheme.Modules.pullback s).obj (relativeDifferentials f)).val.obj (.op U)
        Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
    sorry
  ```
- Only change: replace `(hsmooth : Smooth f)` with `(hsmooth : AlgebraicGeometry.IsSmoothOfRelativeDimension n f)`. The conclusion's rank expression already references `n`; no other changes needed.

### Change 3: `serre_duality_genus` signature

- File: `AlgebraicJacobian/Differentials.lean`
- Old (L976–982):
  ```lean
  theorem serre_duality_genus {k : Type u} [Field k]
      (C : Over (Spec (CommRingCat.of k))) [IsIntegral C.left] [IsProper C.hom]
      (hsmooth : Smooth C.hom) :
      Module.rank k (HModule k (toModuleKSheaf C) 0) =
        Module.rank k
          (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0) := by
    sorry
  ```
- New:
  ```lean
  theorem serre_duality_genus {k : Type u} [Field k]
      (C : Over (Spec (CommRingCat.of k))) [IsIntegral C.left] [IsProper C.hom]
      (hsmooth : Smooth C.hom) :
      Module.rank k
          (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0) =
        Module.rank k (HModule k (toModuleKSheaf C) 1) := by
    sorry
  ```
- Two changes:
  1. **Swap LHS ↔ RHS** so the equation reads LHS = `H^0(Ω_{C/k})` and RHS = `H^1(O_C)` (matches blueprint LHS=Ω, RHS=O_C wording).
  2. **Change RHS index `0` to `1`** to pin RHS as `H^1` (not `H^0`).
- Do NOT modify the smoothness hypothesis on this theorem (it is dimension-free `Smooth C.hom` because the equation already constrains the dimension via the genus implicitly; the blueprint prose specifies "curve" but we are NOT adding the dimension-1 hypothesis in this refactor per the rationale above).
- Do NOT change `[IsIntegral C.left]` to `IsGeometricallyIntegral` — that typeclass does not exist (verified iter-113).

## Affected Files

Only `AlgebraicJacobian/Differentials.lean` requires editing. The three
declarations are all sorry-bodied, so no broken proofs are introduced.

Downstream consumers:

- `cotangent_at_section` is used by NO other declaration in the project
  (verified by `grep -rn cotangent_at_section AlgebraicJacobian/` —
  result: 1 hit at `AlgebraicJacobian/Differentials.lean:840`, the
  declaration itself). No cascading edits expected.
- `smooth_iff_locally_free_omega` is used by NO other declaration
  (similar grep verification).
- `serre_duality_genus` is used by NO other declaration.

No protected declarations are touched (none of the 3 mismatched
declarations appear in `archon-protected.yaml`).

## Expected Outcome

After the refactor:
- `AlgebraicJacobian/Differentials.lean` still compiles (verified by
  `lake env lean AlgebraicJacobian/Differentials.lean`).
- File sorry count unchanged at **5** (the three sorries at lines
  ~823, ~840, ~982 remain; only their statement above the `sorry`
  changed).
- Project sorry count unchanged at **16**.
- The three blueprint `% NOTE:` annotations now describe a resolved
  issue (the plan agent will arrange their removal in a subsequent
  blueprint-writer round once they are no longer load-bearing).
- The `% NOTE:` annotations in the blueprint chapter remain UNTOUCHED
  by this refactor (you do NOT edit the blueprint; the plan agent
  handles blueprint cleanup separately).

## Verification Steps

After every change:
1. Run `lean_diagnostic_messages` on `AlgebraicJacobian/Differentials.lean`
   and confirm severity=error returns `[]`.
2. Run `sorry_analyzer.py AlgebraicJacobian/Differentials.lean --format=summary`
   and confirm 5 sorries total.
3. Run `sorry_analyzer.py AlgebraicJacobian/ --format=summary` and
   confirm project total is 16.
4. Run `grep -rn 'cotangent_at_section\|smooth_iff_locally_free_omega\|serre_duality_genus' AlgebraicJacobian/`
   and confirm only the three declaration sites match (no downstream
   consumers).

Write the post-refactor compilation status into your report so the plan
agent does not need to re-verify.
