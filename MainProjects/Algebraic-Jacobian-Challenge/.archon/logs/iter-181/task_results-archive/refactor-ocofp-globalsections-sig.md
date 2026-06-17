# Refactor Report

## Slug
ocofp-globalsections-sig

## Status
COMPLETE

## Directive

### Problem (verbatim from directive)

The Lean signature of `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff` at
`AlgebraicJacobian/RiemannRoch/OCofP.lean:192` was mathematically **false as typed**. The RHS
`Nonempty { s : Scheme.HModule kbar (lineBundleAtClosedPoint (C := C) P hP) 0 // s ≠ 0 }` does
not bind `s` to `f`; because the structural inclusion `𝒪_C ↪ 𝒪_C(P)` always provides a nonzero
global section (the image of `1`), the RHS is always `True`, degenerating the iff to "order
conditions ↔ True" — false for any `f` with a pole at some `Q ≠ P` (e.g. `f = f_Q^{-1}`).

### Changes Requested (verbatim summary)

1. Add a new `noncomputable def Scheme.lineBundleAtClosedPoint.toFunctionField` (typed `:= sorry`)
   between L140 and L192, going from `Scheme.HModule kbar (lineBundleAtClosedPoint P hP) 0` to
   `C.left.functionField` — the section-to-rational-function inclusion `𝒪_C(P) ↪ 𝒦_C ≅ K(C)`.
2. Replace the iff body with `∃ s : Scheme.HModule …, lineBundleAtClosedPoint.toFunctionField
   (C := C) P hP s = f`, binding `s` to `f`. Replace the existing `refine ⟨fun _h => ?_, …⟩`
   skeleton with a single `sorry`.
3. Update the `globalSections_iff` docstring bullet to name the binding explicitly.
4. Update the `exists_nonconstant_genusZero` proof-sketch paragraph to consume the new iff shape
   (take `f := lineBundleAtClosedPoint.toFunctionField P hP s`); leave the body `:= sorry`.

## Changes Made

### File: `AlgebraicJacobian/RiemannRoch/OCofP.lean`

- **What (change 1):** Inserted new declaration `noncomputable def lineBundleAtClosedPoint.toFunctionField`
  between L148 (close of `lineBundleAtClosedPoint`) and the opening of `namespace lineBundleAtClosedPoint`
  (was L150, now L164). Lands at lines 150–162. Full name resolves to
  `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField` inside `namespace AlgebraicGeometry.Scheme`.
  Signature uses explicit `{kbar : Type u} [Field kbar] [IsAlgClosed kbar]` etc. parameters because the def
  lives OUTSIDE the inner `namespace lineBundleAtClosedPoint`'s `variable` block. Body is `sorry`.
- **Why:** Provides the binding map `s ↦ f` that the corrected iff needs on the RHS.
- **Cascading:** None — no in-project Lean file referenced this declaration before this iter.

- **What (change 2):** Re-typed `globalSections_iff` (now at L206) — RHS changed from
  `Nonempty { s : Scheme.HModule … // s ≠ 0 }` to
  `∃ s : Scheme.HModule …, lineBundleAtClosedPoint.toFunctionField (C := C) P hP s = f`.
  Replaced the previous iter-180 Lane D `refine ⟨fun _h => ?_, fun _h => ?_⟩` two-sorry skeleton
  with a single `sorry` body, as the new statement is a single `Iff` whose iter-181 prover lane
  will rebuild the splitting.
- **Why:** Makes the lemma true-as-stated (binding `s` to `f`), fixing the iter-180 reviewer's
  CRITICAL must-fix-this-iter finding.
- **Cascading:** None inside the Lean files. The blueprint chapter is being edited separately by
  the planner per the directive's out-of-scope rule.

- **What (change 3):** Updated the docstring bullet of `globalSections_iff` to read:
  "there exists a global section `s ∈ H⁰(C, 𝒪_C(P))` whose image under the canonical inclusion
  `𝒪_C(P) ↪ 𝒦_C ≅ K(C)` equals `f` (formally, `lineBundleAtClosedPoint.toFunctionField P hP s = f`)".
- **Why:** Keeps the docstring in lockstep with the new binding-shape statement.
- **Cascading:** None.

- **What (change 4):** Rewrote the `iter-177+ body:` paragraph in the `exists_nonconstant_genusZero`
  docstring (now at L335-ish) to explicitly call out: "take `f := lineBundleAtClosedPoint.toFunctionField P hP s`
  and verify the four bullets via `globalSections_iff` applied to `f` (the forward direction supplies
  the order conditions from the existence witness `⟨s, rfl⟩`)". Body still `sorry`.
- **Why:** The old sketch said "lift it through `globalSections_iff` to a rational function `f`",
  which made sense under the old vacuous RHS but does not match the new `∃ s, ι s = f` shape.
- **Cascading:** None.

## New Sorries Introduced
- `AlgebraicJacobian/RiemannRoch/OCofP.lean:154` — `lineBundleAtClosedPoint.toFunctionField` (the
  new section-to-function-field inclusion). Per directive, body is intentionally `sorry` and lands
  together with the body of `lineBundleAtClosedPoint`.

## Sorries Removed (net accounting context)
- The iter-180 Lane D structural splitting of `globalSections_iff` into 2 internal sub-sorries
  (the `refine ⟨fun _h => ?_, fun _h => ?_⟩` skeleton with two `sorry` legs) was replaced by a
  single `sorry` covering the whole rebuilt Iff. So: −2 internal sub-sorries from the iff body, +1
  consolidated sorry on the new iff body.

## Sorry-count delta

| Decl                                           | Before                | After |
|------------------------------------------------|-----------------------|-------|
| `lineBundleAtClosedPoint`                      | 1                     | 1     |
| `lineBundleAtClosedPoint.toFunctionField`      | (didn't exist)        | 1     |
| `globalSections_iff`                           | 2 (Lane D fork legs)  | 1     |
| `h1_vanishing_genusZero`                       | 1                     | 1     |
| `dim_eq_two_of_genusZero`                      | 1                     | 1     |
| `exists_nonconstant_genusZero`                 | 1                     | 1     |
| **Total file sorry count**                     | **6**                 | **6** |

Net file-sorry delta is **0**, not +1 as the directive estimated — because the iter-180 Lane D
split had introduced 2 sub-sorries that fold back into 1 when we re-unify the iff body. **The
*mathematical* content** changes from "false as typed" to "true as typed", which is the structural
correctness fix the directive demanded. (If the planner prefers the directive's accounting
convention — counting the iter-180 Lane D fork as "1 declaration with 2 sorries" — then the delta
is +1 per declaration count, consistent with the directive estimate. Both views are correct.)

## Compilation Status

- `AlgebraicJacobian/RiemannRoch/OCofP.lean`: **compiles GREEN**. `lake env lean
  AlgebraicJacobian/RiemannRoch/OCofP.lean` reports only the expected 6 `declaration uses
  'sorry'` warnings (lines 140, 154, 206, 255, 290, 342). No errors.

## Notes for Plan Agent

- The directive expected "+1 file-sorry" net, but actual delta is 0: the iter-180 Lane D split of
  `globalSections_iff` had introduced 2 internal sub-sorries (the `refine ⟨…⟩` skeleton's two
  legs); re-typing the iff collapses both back into the unified body's single sorry. This is purely
  an accounting reconciliation, not a divergence — the structural intent (one new typed-sorry def
  + reshape the iff body) matches the directive exactly. No plan-agent action needed.

- The new `toFunctionField` def is placed OUTSIDE the inner `namespace lineBundleAtClosedPoint`,
  using the dotted name `lineBundleAtClosedPoint.toFunctionField` and explicit `{kbar}`/`{C}`
  parameters. Inside the namespace at L164+, plain `toFunctionField` would shadow it via name
  resolution (because `namespace lineBundleAtClosedPoint` opens the
  `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint` namespace, where `toFunctionField` now lives).
  The `globalSections_iff` body at L217 disambiguates with the full dotted path
  `lineBundleAtClosedPoint.toFunctionField (C := C) P hP s = f`. The iter-181 prover lane filling
  the iff body can use either `toFunctionField …` (plain) or the dotted form interchangeably.

- No downstream Lean file references `globalSections_iff`, `lineBundleAtClosedPoint`,
  `toFunctionField`, `exists_nonconstant_genusZero`, `h1_vanishing_genusZero`, or
  `dim_eq_two_of_genusZero` (verified via Grep across `AlgebraicJacobian/`). No cascading
  insertions of `sorry` were needed in any other file.

- The blueprint chapter `blueprint/src/chapters/RiemannRoch_OCofP.tex` references the same names
  but per the directive's explicit out-of-scope rule it was NOT touched here. The plan agent owns
  the blueprint update separately.

- For the iter-181 prover lane on the iff body: the proof now must produce a section `s` (not just
  a `Nonempty {s // s ≠ 0}` witness) and prove its image under `toFunctionField` equals `f`. This
  is the substantive Hartshorne II.7.7 content — the body's nonconstructive existence witness from
  the previous (vacuous) statement won't help. The witness construction depends on the body of
  `lineBundleAtClosedPoint` itself (still typed `sorry`), so the iff body is correctly gated.
