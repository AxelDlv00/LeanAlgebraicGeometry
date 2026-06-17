# Refactor directive — `Differentials.lean` signature refactor (Option iii)

## Target

`AlgebraicJacobian/Differentials.lean`

## What changed and why

The iter-119 prover lane on `smooth_locally_free_omega` returned PARTIAL
with one residual `sorry` at L136. The diagnosis: the project-local
lemma `relativeDifferentialsPresheaf_obj_kaehler` (`Differentials.lean:58`,
`rfl`) identifies the section module of `relativeDifferentialsPresheaf`
at an open `V` with `KaehlerDifferential` of a ring map whose **source**
is the COLIMIT ring
`((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)`
= `colim_{f V ⊆ W ⊆ S} Γ(S, W)` — NOT `Γ(S, U)` for any affine `U ⊆ S`
containing `f V`.

Hence the current conclusion
`Module.Free Γ(X, V) (relativeDifferentialsPresheaf f).presheaf.obj (.op V)`
cannot be directly closed from the Mathlib chain on the appLE algebra
`Γ(S, U) → Γ(X, V)`: there's a colimit-source bridge in between.

The iter-120 plan agent (after consulting strategy-critic, blueprint-
reviewer, progress-critic, and mathlib-analogist) decided to **restate
the theorem on the appLE algebra Kähler module `Ω[Γ(X, V) ⁄ Γ(S, U)]`
directly**, eliminating the bridge from the theorem's content. This is
Option (iii) in the iter-120 analysis. The mathlib-analogist report
`task_results/mathlib-analogist-cotangent-presheaf.md` and the
strategy-critic report `task_results/strategy-critic-iter120.md` both
recommend Option (iii) (alignment with Mathlib's existing
`Algebra.IsStandardSmooth*` API).

## Required change

Replace the existing theorem `smooth_locally_free_omega` declaration
(lines 87–136) with the following algebra-Kähler form:

```lean
/-- Forward direction of the Jacobian criterion (algebra-Kähler form).
If `f : X → S` is smooth of relative dimension `n`, then for every
point `x ∈ X` there exist affine opens `U ⊆ S` and `V ⊆ X` with
`f V ⊆ U` and `x ∈ V`, on which the Kähler differential module
`Ω[Γ(X, V) ⁄ Γ(S, U)]` (over the appLE algebra structure) is a free
module of rank `n` over `Γ(X, V)`.

The bridge from this algebra-Kähler form to the project's presheaf
form `(relativeDifferentialsPresheaf f).presheaf.obj (.op V)` is a
Mathlib gap: the section module of the presheaf identifies with the
Kähler module over the inverse-image-presheaf colimit ring
`colim_{f V ⊆ W ⊆ S} Γ(S, W)`, which is a localization of `Γ(S, U)`
and hence yields an iso `Ω[Γ(X, V) ⁄ Γ(S, U)] ≃ Ω[Γ(X, V) ⁄ A_colim]`
via `KaehlerDifferential.isLocalizedModule_map`; constructing the iso
requires presheaf-level cofinality machinery (~200–400 LOC) that is
out of autonomous-loop scope. See `blueprint/src/chapters/Differentials.tex`
§ "Bridge to the relative cotangent presheaf — out of autonomous-loop
scope" for the mathematical content.

The reverse direction (locally free Ω of rank `n` implies smooth of
relative dimension `n`) is **mathematically false** as stated without
additional deformation-theoretic input (vanishing of
`Algebra.H1Cotangent A B` on each chart); see the chapter
`Differentials.tex` for the counterexample (`Spec k → Spec k[t]`,
`t ↦ 0`) and the converse-direction disclosure. -/
theorem smooth_locally_free_omega {n : ℕ} (f : X ⟶ S)
    [SmoothOfRelativeDimension n f] :
    ∀ (x : X), ∃ (U : S.Opens) (V : X.Opens) (e : V ≤ f ⁻¹ᵁ U),
        x ∈ V ∧ IsAffineOpen U ∧ IsAffineOpen V ∧
          letI : Algebra Γ(S, U) Γ(X, V) :=
            (Scheme.Hom.appLE f U V e).hom.toAlgebra
          (Module.Free Γ(X, V) (Ω[Γ(X, V) ⁄ Γ(S, U)]) ∧
           Module.rank Γ(X, V) (Ω[Γ(X, V) ⁄ Γ(S, U)]) = n) := by
  sorry
```

Key points:
- The theorem name `smooth_locally_free_omega` is preserved.
- It is **non-protected** (NOT listed in `archon-protected.yaml`);
  signature refactor is allowed.
- The existential structure is `∃ U V e, ...` so that the algebra
  structure `(Hom.appLE f U V e).hom.toAlgebra` can be installed via a
  `letI` inside the existential body. This is the cleanest shape
  matching the `mk_iff` output of `SmoothOfRelativeDimension`.
- The body is a single `sorry`. **Do NOT attempt to fill it.** The
  iter-120 prover lane will close this `sorry` from the algebraic
  Mathlib chain.
- Keep `relativeDifferentialsPresheaf` and
  `relativeDifferentialsPresheaf_obj_kaehler` intact at the top of the
  file. They are leaf objects in the project; they survive as Mathlib-
  bound future-iter material.
- Remove the iter-119 PARTIAL proof body (`intro x`, the `algebraize`
  call, the `haveI` chain, etc.) — it's no longer needed since the new
  signature has a `sorry` body.
- Preserve all imports.
- Preserve the file's module docstring (lines 1–28) and the namespace
  block.

## Verification you must perform before reporting COMPLETE

1. `lean_diagnostic_messages` on the file returns no errors (the one
   expected `declaration uses sorry` warning at the new
   `smooth_locally_free_omega` is fine).
2. The two preserved declarations `relativeDifferentialsPresheaf` and
   `relativeDifferentialsPresheaf_obj_kaehler` still compile.
3. `lake build AlgebraicJacobian.Differentials` succeeds.
4. The sorry count on the file is exactly **1** (the new
   `smooth_locally_free_omega` sorry).
5. No new axioms.
6. No new declarations introduced (you are only refactoring an existing
   signature; you are not adding the bridge helper lemma — that is
   either project-external Mathlib work or a future iter's task).

## What NOT to do

- Do NOT add the bridge lemma
  `relativeDifferentialsPresheaf_iso_kaehler_appLE` to the file. The
  iter-120 strategy explicitly avoids this expensive helper. The
  blueprint chapter documents it as a Mathlib gap.
- Do NOT modify `relativeDifferentialsPresheaf` or
  `relativeDifferentialsPresheaf_obj_kaehler`.
- Do NOT add new imports unless required by the new signature.
- Do NOT touch any file other than
  `AlgebraicJacobian/Differentials.lean`.
- Do NOT touch `archon-protected.yaml` (it has no entry for
  `smooth_locally_free_omega`; the refactor is signature-only on a
  non-protected declaration).

## Write-domain

`AlgebraicJacobian/Differentials.lean` (single file).
