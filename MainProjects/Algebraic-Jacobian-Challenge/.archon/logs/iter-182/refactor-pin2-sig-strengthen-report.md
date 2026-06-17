# Refactor Report

## Slug
pin2-sig-strengthen

## Status
COMPLETE

## Directive

### Problem
`AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:310-320` — the
iter-177 file-skeleton signature of
`Scheme.morphism_degree_via_pole_divisor` was flagged "weakened-wrong"
by the iter-181 `lean-vs-blueprint-checker`: the output existential
`∃ (d : ℕ) (D : C.left.WeilDivisor), 0 < d ∧ D.degree = (d : ℤ)`
references neither `φ` nor the function-field-extension degree, and is
discharged by any positive-degree divisor on `C` (e.g. `(1, [P])` for
any closed point `P ∈ C`) without saying anything substantive about
`φ`.

### Changes Requested
- New `noncomputable def Scheme.Hom.poleDivisor` (typed sorry) on
  `(φ : C ⟶ ProjectiveLineBar k̄) ↦ C.left.WeilDivisor` immediately
  above the theorem.
- Replace the theorem signature so the output existential pins
  `D = Scheme.Hom.poleDivisor φ` and
  `D.degree = (Module.finrank K(ℙ¹) K(C) : ℤ)`, threading the canonical
  `[Algebra K(ℙ¹) K(C)]` instance binder per the iter-181 Pin 3 sig
  convention.

## Changes Made

### File: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

- **What (new def):** Added `noncomputable def Scheme.Hom.poleDivisor`
  at L278-296 (just below the §2 section docstring and above the
  theorem). Signature:
  ```lean
  noncomputable def Hom.poleDivisor
      {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
      {C : Over (Spec (.of kbar))}
      [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
      [GeometricallyIrreducible C.hom] [IsIntegral C.left]
      (_φ : C ⟶ ProjectiveLineBar kbar) :
      C.left.WeilDivisor := sorry
  ```
  The argument is `_φ` (underscored) because the body is `sorry`;
  iter-183+ will rename to `φ` when wiring the
  `Ideal.sum_ramification_inertia` body.

- **What (theorem sig replace):** Replaced the body of
  `morphism_degree_via_pole_divisor` (L342-372). New signature:
  ```lean
  theorem morphism_degree_via_pole_divisor
      {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
      {C : Over (Spec (.of kbar))} [IsProper C.hom]
      [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
      [IsIntegral C.left] [IsIntegral (ProjectiveLineBar kbar).left]
      (φ : C ⟶ ProjectiveLineBar kbar)
      (_hφ_non_const :
        ∀ Q : 𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar,
          φ ≠ toUnit C ≫ Q)
      [Algebra (ProjectiveLineBar kbar).left.functionField C.left.functionField] :
      ∃ (D : C.left.WeilDivisor),
        D = Scheme.Hom.poleDivisor φ ∧
          Scheme.WeilDivisor.degree D =
            (Module.finrank
              (ProjectiveLineBar kbar).left.functionField
              C.left.functionField : ℤ) := by
    sorry
  ```
  Added the iter-182 strengthening rationale to the docstring (new
  paragraph "**Signature strengthening (iter-182 Pin 2).**").

- **Why:** Strengthen the substantive content so the existential is
  pinned to `φ` and to the function-field-extension degree (matches
  the blueprint claim `[K(C):k̄(ℙ¹)] = deg(φ^*[Q])` for every closed
  `Q ∈ ℙ¹`, blueprint L271-275).

- **Cascading:** None. `grep` for `morphism_degree_via_pole_divisor`
  and `Scheme.Hom.poleDivisor` confirms no other Lean file consumes
  either (the only hit-list outside this file is the blueprint chapter
  TeX prose and the iter-181 analogy note, neither of which is Lean
  code).

#### Divergences from directive verbatim (necessary for typecheck)
1. **Non-constancy hypothesis kept as the existing inline form**
   `(_hφ_non_const : ∀ Q : 𝟙_ ⟶ ProjectiveLineBar kbar, φ ≠ toUnit C ≫ Q)`
   rather than the directive's paraphrased `(_hφ_non_const : ¬ IsConstant φ)`.
   **Reason:** `IsConstant` is not defined anywhere in the project
   (verified by `Grep -r "IsConstant"` returning zero hits) and the
   directive's helper budget is explicitly capped at 1 (the
   `poleDivisor` def). Introducing `IsConstant` as a second helper
   would exceed the helper budget without delivering substantive
   content beyond the existing inline form. The original inline form
   `∀ Q, φ ≠ toUnit C ≫ Q` is the textbook unfolding of `IsConstant`
   for a morphism between `Over (Spec k̄)`-objects (a morphism is
   non-constant iff it does not factor through the terminal object
   `𝟙_ (Over (Spec k̄))`), so the semantics are unchanged.

2. **Added instance binder `[IsIntegral (ProjectiveLineBar kbar).left]`.**
   **Reason:** The directive's proposed signature uses
   `(ProjectiveLineBar kbar).left.functionField` which requires
   `IrreducibleSpace (ProjectiveLineBar kbar).left` to typecheck (per
   `Mathlib.AlgebraicGeometry.FunctionField.Scheme.functionField`).
   This is not derivable from the project's existing
   `projectiveLineBar_geomIrred` instance (which carries scaffold
   sorry). Threading `[IsIntegral (ProjectiveLineBar kbar).left]` at
   the call site is the standard pattern — it implies
   `IrreducibleSpace` automatically — and matches how `[IsIntegral
   C.left]` is already threaded on the `C` side. Verified by
   `lean_run_code` that without this binder the type fails to
   synthesize `IrreducibleSpace ↥(ProjectiveLineBar kbar).left`; with
   it, the signature compiles.

3. **Dropped `[IsLocallyNoetherian C.left]`** to match the directive's
   explicit replacement signature (which does not list it). The body
   is `sorry` so no downstream proof breaks.

## New Sorries Introduced
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:290` — new
  `Scheme.Hom.poleDivisor` typed-sorry def (the structurally
  necessary helper to pin the existential of
  `morphism_degree_via_pole_divisor` to `φ`). Body is the iter-183+
  affine-chart-localised `Ideal.sum_ramification_inertia`
  construction per `analogies/ratcurveiso-pin2.md` body recipe.

## Existing sorries (unchanged)
- `RationalCurveIso.lean:342` — `morphism_degree_via_pole_divisor`
  body (already `sorry` at iter-181; signature now strengthened).
- `RationalCurveIso.lean:438` — `iso_of_degree_one` body (untouched).

## Compilation Status
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`:
  **compiles** (`lake env lean` exits 0 with only the three expected
  `declaration uses sorry` warnings at L290, L342, L438).
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`: **compiles**
  (unchanged; same two pre-existing `sorry`s at L205, L407).
- `AlgebraicJacobian/AbelianVarietyRigidity.lean`: **compiles**
  (unchanged; same two pre-existing `sorry`s at L98, L337).

File sorry count: 2 → 3 (net +1, as the directive expects).
Project axioms: unchanged (no axiom declarations added).

## Notes for Plan Agent

### `IsConstant` predicate (suggested follow-up refactor)
The directive's `¬ IsConstant φ` paraphrase exposes a recurring
pattern: every "morphism is non-constant" hypothesis in the
RationalCurveIso / AVR / Genus0 chain is currently spelled out as
`∀ Q : 𝟙_ ⟶ X', φ ≠ toUnit C ≫ Q`. If the plan agent later wants
the predicate name `IsConstant` on its own (e.g., to refactor
`morphism_P1_to_grpScheme_const` / `rigidity_genus0_curve_to_grpScheme`
into a uniform shape), a one-line `def Scheme.IsConstant ...` in
`Genus0BaseObjects.lean` (or a Scheme-level namespace) would be the
natural home. This is **not in scope** for the present directive —
flagged only as a low-cost cleanup for a future iter.

### `[IsIntegral (ProjectiveLineBar kbar).left]` as a project-wide instance
The same observation: this instance binder will need to be threaded
at every call site of `morphism_degree_via_pole_divisor` (currently
only the iter-183+ body site inside `genusZero_curve_iso_P1`). A
project-wide `instance projectiveLineBar_isIntegral` in
`Genus0BaseObjects/BareScheme.lean` (sibling of
`projectiveLineBar_geomIrred` and `projectiveLineBar_smoothOfRelDim`)
would let consumers infer it. The proof is non-trivial (Mathlib lacks
an `IsIntegral` instance for `Proj` of a polynomial ring), so the
plan agent may prefer to keep it threaded at the call site for now
and add the project-wide instance only when the iter-183+ body lane
demands it. **Not in scope** for the present directive.

### Helper budget honoured
1 helper added (`Scheme.Hom.poleDivisor`), exactly matching the
directive's explicit budget.

### Mathematical justification was sufficient
The directive's analogy reference (`analogies/ratcurveiso-pin2.md`)
plus the explicit "Where `Scheme.Hom.poleDivisor` is a NEW typed-sorry
`noncomputable def`" clause cleanly disambiguated the intended helper
shape. No follow-up clarifications needed.
