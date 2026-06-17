# Refactor Directive

## Slug
differentials-iter118

## Problem

The current signature of `AlgebraicGeometry.Scheme.smooth_iff_locally_free_omega`
in `AlgebraicJacobian/Differentials.lean` L74–81 is mathematically false:

```lean
theorem smooth_iff_locally_free_omega (f : X ⟶ S)
    (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f) (n : ℕ) :
    AlgebraicGeometry.IsSmoothOfRelativeDimension n f ↔
      ∀ (x : X), ∃ (U : X.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
        let R := X.ringCatSheaf.presheaf.obj (.op U)
        let M := (relativeDifferentialsPresheaf f).presheaf.obj (.op U)
        Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
  sorry
```

The `↔` is mathematically false. The converse direction requires
deformation-theoretic input (`Subsingleton (Algebra.H1Cotangent A B)`
on each affine chart), which is NOT implied by
`LocallyOfFinitePresentation f` + local freeness of Ω of rank `n`.

## Mathematical Justification

Counterexample to the iff: `f : Spec k → Spec k[t]` induced by the
surjection `k[t] → k`, `t ↦ 0`.

- `LocallyOfFinitePresentation f`: ✓ (`k = k[t]/(t)` is f.p. over
  `k[t]`).
- For the unique `x ∈ Spec k` and the unique affine open `U = Spec k`:
  `Ω_{k/k[t]} = 0` (`d` is zero on every element of `k`, since every
  element is the image of an element of `k[t]` whose `d` is killed
  by `R → R/I`-base-change). The zero module is `Module.Free` of
  rank 0. So the RHS holds for `n = 0`.
- But `SmoothOfRelativeDimension 0 f` is **false**: `f` is a closed
  immersion of a non-open point, hence not flat, hence not smooth.

So the iff's `←` direction is false for this `f, n = 0`. The
statement must be demoted to a forward implication.

Mathlib's converse-direction lemma
`Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`
(`Mathlib.RingTheory.Smooth.StandardSmoothOfFree` L49–77) makes
the actually-needed extra hypotheses explicit:

- `[FinitePresentation R S]`,
- `[Subsingleton (Algebra.H1Cotangent R S)]` (formal smoothness),
- a basis whose range ⊆ `Set.range (D R S)` (basis from derivations).

The first does not imply the second; the second is genuinely the
deformation-theoretic content.

The forward direction
"`SmoothOfRelativeDimension n f → ∀ x, ∃ U affine, ..., Ω(U) free
of rank n`"
IS true and provable via the chain
`smoothOfRelativeDimension_iff` → `IsStandardSmoothOfRelativeDimension.isStandardSmooth`
→ instance `IsStandardSmooth.free_kaehlerDifferential` +
`IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
→ project-local `relativeDifferentialsPresheaf_obj_kaehler`.

The Lean signature for this declaration is NOT protected (verified
via `archon-protected.yaml`).

## Changes Requested

### File: `AlgebraicJacobian/Differentials.lean`

#### Change 1 — Replace the iff theorem with a forward implication

**Old** (L74–81):
```lean
/-- Smoothness of a finite-presentation morphism is equivalent to the
relative differential presheaf being locally free of the given rank on
every affine open.

The forward direction is the Jacobian criterion via
`Algebra.IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential`
on affine charts; the converse follows from
`Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`. -/
theorem smooth_iff_locally_free_omega (f : X ⟶ S)
    (hfp : AlgebraicGeometry.LocallyOfFinitePresentation f) (n : ℕ) :
    AlgebraicGeometry.IsSmoothOfRelativeDimension n f ↔
      ∀ (x : X), ∃ (U : X.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
        let R := X.ringCatSheaf.presheaf.obj (.op U)
        let M := (relativeDifferentialsPresheaf f).presheaf.obj (.op U)
        Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
  sorry
```

**New** (forward implication, renamed; deprecated alias dropped):
```lean
/-- Forward direction of the Jacobian criterion: if `f : X → S` is
smooth of relative dimension `n`, then for every point `x ∈ X` there
exists an affine open `U` containing `x` on which the relative
cotangent presheaf is a free module of rank `n` over the section
ring.

The proof routes through `smoothOfRelativeDimension_iff` (Mathlib
auto-generated `mk_iff`), `IsStandardSmoothOfRelativeDimension.isStandardSmooth`
(`Mathlib.RingTheory.Smooth.StandardSmooth`), the instance
`IsStandardSmooth.free_kaehlerDifferential` and theorem
`IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
(`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`), and the
project-local section-identification lemma
`relativeDifferentialsPresheaf_obj_kaehler`.

The reverse direction (locally free Ω of rank `n` implies smooth
of relative dimension `n`) is **mathematically false** as stated
without additional deformation-theoretic input (vanishing of
`Algebra.H1Cotangent A B` on each chart); see the chapter
`Differentials.tex` for the counterexample (`Spec k → Spec k[t]`,
`t ↦ 0`) and the converse-direction disclosure. -/
theorem smooth_locally_free_omega {n : ℕ} (f : X ⟶ S)
    [SmoothOfRelativeDimension n f] :
    ∀ (x : X), ∃ (U : X.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
        let R := X.ringCatSheaf.presheaf.obj (.op U)
        let M := (relativeDifferentialsPresheaf f).presheaf.obj (.op U)
        Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
  sorry
```

Notes on the new signature:
- The renamed theorem `smooth_locally_free_omega` (no `_iff_` infix)
  signals the forward-only shape.
- `IsSmoothOfRelativeDimension n f` (the deprecated alias) is replaced
  by `SmoothOfRelativeDimension n f` per the iter-117
  lean-vs-blueprint-checker minor-2 finding (Mathlib has deprecated
  the `Is` prefix). Note: `SmoothOfRelativeDimension` is a class, not
  a Prop — so the hypothesis is taken as a typeclass instance
  `[SmoothOfRelativeDimension n f]` rather than an explicit argument
  `(hsm : SmoothOfRelativeDimension n f)`. This is the Mathlib-idiomatic
  shape and matches how `Mathlib.AlgebraicGeometry.Morphisms.Smooth`
  consumes it elsewhere.
- The `LocallyOfFinitePresentation` premise is dropped: in the forward
  direction it is implied by `SmoothOfRelativeDimension n f` (smoothness
  implies locally of finite presentation).
- `n` is moved to be implicit and brace-bound — fitting the implicit
  arrow style of Mathlib's neighbouring `SmoothOfRelativeDimension`
  consumers (the n is determined by the typeclass).
- Body remains `sorry` — the prover will close it in the next iter.

#### Change 2 — (optional but recommended) docstring polish on related declarations

If the docstring of `relativeDifferentialsPresheaf` (L39–48) or
`relativeDifferentialsPresheaf_obj_kaehler` (L54–57) needs minor
adjustment to harmonise with the renamed theorem (e.g. internal
cross-references), make those edits. Otherwise leave the first
two declarations untouched.

## Affected Files

- `AlgebraicJacobian/Differentials.lean` — the file being refactored.
- `AlgebraicJacobian.lean` — umbrella import. No edits needed; it
  just imports `AlgebraicJacobian.Differentials`.

No other file consumes `smooth_iff_locally_free_omega` (verified by
`grep -rn smooth_iff_locally_free_omega AlgebraicJacobian/`). The
rename should not cause cascading breakage.

## Expected Outcome

After your refactor:

- `AlgebraicJacobian/Differentials.lean` contains exactly the same
  three declarations as before (presheaf def, section lemma,
  smoothness criterion) plus minor docstring updates.
- The smoothness criterion is renamed to `smooth_locally_free_omega`
  (no `_iff_`), shaped as a forward implication, with body `sorry`.
- The deprecation warning on `IsSmoothOfRelativeDimension` is no longer
  emitted (replaced with `SmoothOfRelativeDimension`).
- `lake build` compiles clean; `lean_diagnostic_messages` returns
  `[]` errors on the file.
- Project sorry count remains 2 (no change — the `sorry` is just
  moved to the new declaration).

The new sorry will be closed in a subsequent prover lane (this iter
or next), now that the signature is mathematically correct.
