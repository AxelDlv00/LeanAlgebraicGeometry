# AlgebraicJacobian/Cohomology/MayerVietoris.lean

## Iter-059 — `basicOpenCover_finset_inf'_isLocalization` (appended at L1582)

### Attempt 1
- **Approach:** Verbatim probe-confirmed body from PROGRESS.md.
- **Result:** RESOLVED.
- **Key body:**
  ```lean
  theorem basicOpenCover_finset_inf'_isLocalization
      {k : Type u} [Field k] {C : Over (Spec (.of k))}
      {U : TopologicalSpace.Opens C.left.toTopCat} (hU : IsAffineOpen U)
      (s : Set Γ(C.left, U)) (t : Finset s) (h : t.Nonempty) :
      @IsLocalization.Away _ _ (∏ i ∈ t, (i.1 : Γ(C.left, U)))
        Γ(C.left, t.inf' h (basicOpenCover (C := C) (U := U) s)) _
        ((C.left.presheaf.map (homOfLE
          (basicOpenCover_finset_inf'_le (C := C) (U := U) s t h)).op).hom.toAlgebra) :=
    hU.isLocalization_of_eq_basicOpen _
      (homOfLE (basicOpenCover_finset_inf'_le (C := C) (U := U) s t h))
      (basicOpenCover_finset_inf'_eq_basicOpen_prod (C := C) (U := U) s t h)
  ```
- **Placement:** Inside `namespace AlgebraicGeometry.Scheme` `section CoverTotality`, after iter-058's `basicOpenCover_finset_inf'_le`, before `end CoverTotality`.

### Verification

1. `lean_diagnostic_messages` → `{success: true, items: [], failed_dependencies: []}` (clean: zero errors, zero warnings).
2. `lean_verify AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_isLocalization` → `{axioms: [propext, Classical.choice, Quot.sound], warnings: []}` — kernel-only; no new axiom.
3. Sorry trajectory: `9 → 9` (the iter-059 declaration is purely additive and does not affect any sorry).
4. File LOC: 1584 → 1626 (+42, within the plan's predicted +30-50 band; mostly docstring).

### Blueprint marker readiness

- Declaration `AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_isLocalization` (corresponds to blueprint env `thm:Scheme_basicOpenCover_finset_inf_isLocalization`) is ready for `\leanok` in `blueprint/src/chapters/Cohomology_MayerVietoris.tex` § *N-ary basic-open intersection as a localization (iter-059)* — proof is fully closed with no `sorry`, kernel-only axioms.

### Notes
- Single-Edit iteration (one append before `end CoverTotality`); no other declarations modified.
- No new imports required (probe-confirmed; `IsAffineOpen.isLocalization_of_eq_basicOpen` already in scope via `Mathlib.AlgebraicGeometry.AffineScheme`).
- Explicit `@`-algebra binding in the conclusion type is essential (matches Mathlib's signature; iter-058 plan-agent confirmed inferred-algebra form fails).
- No deviations from the verbatim plan-agent body.
