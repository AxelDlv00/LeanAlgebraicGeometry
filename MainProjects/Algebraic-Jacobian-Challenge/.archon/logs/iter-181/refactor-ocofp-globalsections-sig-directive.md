# refactor directive (iter-181, slug: ocofp-globalsections-sig)

## Background

The iter-180 review-phase `lean-vs-blueprint-checker-iter180-ocofp` returned a **CRITICAL must-fix-this-iter** finding: the Lean signature of `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff` at `AlgebraicJacobian/RiemannRoch/OCofP.lean:192` is mathematically **false as typed**.

The current RHS,

```
Nonempty
  { s : Scheme.HModule kbar (lineBundleAtClosedPoint (C := C) P hP) 0 //
    s ≠ 0 }
```

does not bind `s` to `f`. Since the structural inclusion `𝒪_C ↪ 𝒪_C(P)` always provides a nonzero global section (the image of `1`), the RHS is *always* `True`. So the iff degenerates to `(order conditions on f) ↔ True`, which is false for any `f` with a pole at some `Q ≠ P` (e.g. `f = f_Q^{-1}`).

The intended statement (per blueprint chapter `blueprint/src/chapters/RiemannRoch_OCofP.tex` §2 and Hartshorne II.7.7) is: there exists a global section `s` of `𝒪_C(P)` whose image under the inclusion `𝒪_C(P) ↪ 𝒦_C ≅ K(C)` equals `f`. We need a `Σ`-shape that binds `s` to `f`.

`Scheme.lineBundleAtClosedPoint.globalSections_iff` is **not** in `archon-protected.yaml` — only the `Jacobian.*`, `Genus.genus`, `AbelJacobi.*` declarations are protected. The refactor is permitted.

## Scope of this refactor

You execute only the **signature** change + insert `sorry` for the body. The plan agent has separately scheduled an iter-181 prover lane to fill the body via the iter-176 lineBundleAtClosedPoint infrastructure programme.

## Concrete change

In `AlgebraicJacobian/RiemannRoch/OCofP.lean`:

1. **Add a section-to-function map.** Above `globalSections_iff` (i.e. between the `lineBundleAtClosedPoint` definition at L140 and the `globalSections_iff` lemma at L192), introduce a **typed `:= sorry` placeholder** for the inclusion

   ```lean
   /-- The inclusion `H⁰(C, 𝒪_C(P)) ↪ 𝒦_C ≅ K(C)` of global sections of
   `𝒪_C(P)` into the function field, viewing each section as a rational
   function via the canonical embedding `𝒪_C(P) ↪ 𝒦_C` (Hartshorne II §6 p.
   144).  The body lands together with the body of `lineBundleAtClosedPoint`. -/
   noncomputable def lineBundleAtClosedPoint.toFunctionField
       {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
       {C : Over (Spec (.of kbar))} [IsProper C.hom]
       [SmoothOfRelativeDimension 1 C.hom]
       [GeometricallyIrreducible C.hom] [IsIntegral C.left]
       (P : C.left) (hP : IsClosed ({P} : Set C.left))
       (s : Scheme.HModule kbar (lineBundleAtClosedPoint (C := C) P hP) 0) :
       C.left.functionField :=
     sorry
   ```

   The exact shape matters: the section produced should be a `k̄`-linear map (it's the global-section "evaluation at the generic point" plus the inclusion of the structure sheaf into the function field), so the bare `def` going from `HModule … 0` to `functionField` is correct. Bodies land later — keep `sorry`.

2. **Re-type the iff.** Replace the existing iff body with the binding shape. The new statement is:

   ```lean
   lemma globalSections_iff
       [∀ Q : C.left.PrimeDivisor,
           Ring.KrullDimLE 1 (C.left.presheaf.stalk Q.point)]
       (P : C.left) (hP : IsClosed ({P} : Set C.left))
       (f : C.left.functionField) (_hf : f ≠ 0)
       (hPcoh : Order.coheight P = 1) :
       (∀ Q : C.left.PrimeDivisor, Q.point ≠ P →
           0 ≤ Scheme.RationalMap.order Q f) ∧
         (-1 : ℤ) ≤ Scheme.RationalMap.order ⟨P, hPcoh⟩ f
       ↔
       ∃ s : Scheme.HModule kbar (lineBundleAtClosedPoint (C := C) P hP) 0,
         lineBundleAtClosedPoint.toFunctionField (C := C) P hP s = f := by
     sorry
   ```

   (The previous body had a `refine ⟨fun _h => ?_, fun _h => ?_⟩` skeleton; delete it and leave a single `sorry`.)

3. **Update the docstring.** Replace the existing paragraph "* `f` defines a global section of `𝒪_C(P)` (equivalently: there exists a nonzero `s ∈ H⁰(C, 𝒪_C(P))` …)" with one that names the binding explicitly:

   "* there exists a global section `s ∈ H⁰(C, 𝒪_C(P))` whose image under the canonical inclusion `𝒪_C(P) ↪ 𝒦_C ≅ K(C)` equals `f` (formally, `lineBundleAtClosedPoint.toFunctionField P hP s = f`)"

4. **`exists_nonconstant_genusZero` (L345).** Audit and (if needed) update its body comment/sketch to match the new iff shape — its proof sketch must consume the new `(∃ s, ι s = f)` shape, not the old vacuous `Nonempty { … // … ≠ 0 }`. Leave the body as `sorry`. (The body was already `sorry`; just update the in-file docstring sketch to point to the new iff shape.)

   The `iter-177+ body` paragraph in the docstring currently says "lift it through `globalSections_iff` to a rational function `f`". After this refactor it should explicitly call out: "use `dim_eq_two_of_genusZero` to obtain a section `s ∈ H⁰` not in the constant subspace, then take `f := lineBundleAtClosedPoint.toFunctionField P hP s` and verify the bullets via the iff."

## Out-of-scope

- Do NOT fill the body of `lineBundleAtClosedPoint.toFunctionField`. It is a new typed `:= sorry` whose body lands together with the body of `lineBundleAtClosedPoint`.
- Do NOT fill the body of `globalSections_iff`. Leave `:= by sorry`.
- Do NOT touch `lineBundleAtClosedPoint` itself (L140) — its body is the separately-tracked iter-176 typed sorry.
- Do NOT touch `h1_vanishing_genusZero` or `dim_eq_two_of_genusZero`. Their signatures don't consume the iff and are insulated.
- Do NOT touch any other file. Specifically: do NOT touch the blueprint chapter `RiemannRoch_OCofP.tex` — the planner is editing that separately.

## Build check

After the edits: run `lake env lean AlgebraicJacobian/RiemannRoch/OCofP.lean` to confirm the file compiles GREEN. If it doesn't (e.g. a downstream consumer of `globalSections_iff` breaks), trace the consumer and either (a) report back the consumer for the plan agent to fix in a follow-up, OR (b) if the fix is a one-line `sorry` insertion in the consumer's body, apply it and report.

## Expected sorry-count delta

- Before: 5 sorries in `OCofP.lean` (lineBundleAtClosedPoint, globalSections_iff has 2 internal sub-sorries via the iter-180 Iff split, h1_vanishing_genusZero, dim_eq_two_of_genusZero, exists_nonconstant_genusZero).
- After: 6 sorries (the new `lineBundleAtClosedPoint.toFunctionField` + globalSections_iff now has 1 single sorry not 2 + the other 4 unchanged).

Net +1 file-sorry, but the **mathematical content** changes from "false as typed" to "true as typed", which is the structural correctness fix. Reported clearly in your task_result.

## Permissions

write-domain: `AlgebraicJacobian/RiemannRoch/OCofP.lean` only.
