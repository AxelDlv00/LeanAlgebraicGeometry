You are auditing (READ-ONLY, do not edit any file) the Lean 4 project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge (AJC).

CONTEXT. The project's one central `sorry` is `Scheme.fgaPicardRepresentability` (`AlgebraicJacobian/Picard/FGAPicRepresentability.lean`), stating for a smooth-relative-dim-1, proper, geometrically integral curve `C` over a field `k`:

```
(∃ (X : Over (Spec (.of k))), Nonempty ((PicScheme.picEt C).RepresentableBy X) ∧
    LocallyOfFiniteType X.hom ∧ IsSeparated X.hom)
  ∧ (HasRationalPoint C → IsIso (PicScheme.picEtComparison C))
```

Around it a large cluster of theorems takes `rep : (picEt …).RepresentableBy X'` (or `picSharp`) as a HYPOTHESIS. ~93 such consumers, zero producers.

YOUR JOB: tell me precisely what hypothesis package, if supplied, would let the seam be CLOSED — i.e. what is the weakest statement `S` such that `S → fgaPicardRepresentability C` is already a landed sorry-free theorem in this project (or is one short composition away).

Do all of:
1. Read in full and summarise, by declaration, these files' §-structure and MAIN statements (name + exact hypotheses + conclusion):
   - `AlgebraicJacobian/Picard/PicEtSubcanonical.lean` (esp. `hasPicSchemeEt_of_picSharp_representability`, `isIso_picEtComparison_of_picSharp_representability`, `picSharp_representableBy_picEt_transport`, `not_exists_representing_picSharp_of_not_isIso`)
   - `AlgebraicJacobian/Picard/PicEtDescentRepresentability.lean` (esp. `representableBy_of_coverCompatibleEquiv`)
   - `AlgebraicJacobian/Picard/PicEtDescentAssembly.lean`
   - `AlgebraicJacobian/Picard/PicEtQuotientHom.lean`
   - `AlgebraicJacobian/Picard/PicEtSeparated.lean`
   - `AlgebraicJacobian/Picard/PicEtCrossBase.lean` (esp. `picEt_crossBaseIso`)
2. For each, state whether it is sorry-free in its BODY (strip comments; `grep -n "sorry"` then check whether the hit is inside a docstring).
3. Then answer the central question explicitly: **starting from `(picEt (baseChangeField C k')).RepresentableBy X'` for a suitable field extension k'/k (say separably closed, or a finite Galois level), what landed theorems already carry that to clause (1) over `k`, and what is the exact remaining gap?** Name the undischarged antecedents by declaration name and give their full statements.
4. Separately: does the project contain ANY statement of the form "for `C` over a separably closed field, picEt/picSharp is representable"? Sorry-free? Search widely (`grep -rn "IsSepClosed" --include=*.lean` and look at `Picard/PicEtAff`, `Curve/SeparablyClosedRationalPoint.lean`).
5. Report the `LocallyOfFiniteType` and `IsSeparated` fields' status: is there a landed theorem giving those from a representing object? (See `PicEtSeparated.lean`.)

Use grep/rg and read files. Do NOT edit. Do NOT run `lake build`.

Return a structured report: (A) per-file declaration inventory with exact signatures for the load-bearing ones, (B) the assembled implication as it stands (write it as a Lean-ish statement), (C) the exact residual gap(s) by name, (D) answers to 4 and 5.
