# Refactor Directive

## Slug
lofft-thread

## Problem

The Rigidity-Lemma chain in `AlgebraicJacobian/AbelianVarietyRigidity.lean` is
**under-hypothesized**. Its route-B globalisation step (proven last iter as
`morphism_eq_of_eqAt_closedPoints`) requires the closed points of the ambient open
subscheme `U ⊆ (X ⊗ Y).left` to be **dense**, i.e. `U` must be a `JacobsonSpace`. Over the
algebraically closed base `Spec k̄` that follows from `(X ⊗ Y)` being **locally of finite
type**, but the chain signatures carry no finite-type hypothesis. The result is an
undischargeable in-body `haveI : JacobsonSpace (...) := sorry` at
`AbelianVarietyRigidity.lean:237` inside `rigidity_eqOn_saturated_open_to_affine`, plus a
deep residual sorry at `:172` (`rigidity_eqAt_closedPoint_of_proper_into_affine`) whose own
proof needs `κ(y) = k̄` from finite type. Two independent iter-160 audits (lean-auditor,
lean-vs-blueprint-checker) flagged this as the must-fix; the fix is a plan-authorized
signature change, NOT a proof.

## Mathematical Justification

Adding `[LocallyOfFiniteType (X ⊗ Y).hom]` to the chain is sound and free downstream:
the genus-0 curve / abelian-variety application is finite type over `k̄` (curves and
abelian varieties are of finite type), so every eventual instantiation supplies the
instance automatically.

The instance flows purely by typeclass resolution because the same binder is added to
**every** lemma in the chain — each caller already has `[LocallyOfFiniteType (X ⊗ Y).hom]`
in scope when it invokes the next lemma down, so no explicit argument needs to be passed at
any call site (the binders are instance-implicit). The relevant Mathlib facts (already
verified to exist this iter, do NOT re-derive):

- `AlgebraicGeometry.LocallyOfFiniteType.jacobsonSpace (f : X ⟶ Y) [LocallyOfFiniteType f]
  [JacobsonSpace ↥Y] : JacobsonSpace ↥X`  (a `theorem`, not an instance — must be applied
  explicitly when the prover later discharges the `JacobsonSpace` derivation).
- `Spec k̄` is a `JacobsonSpace` (a field is an `IsJacobsonRing`, giving
  `PrimeSpectrum.instJacobsonSpaceOfIsJacobsonRing`).
- `JacobsonSpace.of_isOpenEmbedding [JacobsonSpace Y] (hf : IsOpenEmbedding f) :
  JacobsonSpace X` (an open subscheme inherits Jacobson-ness — for the open `U`).

You are NOT asked to discharge the `JacobsonSpace` derivation or the `:172` deep residual —
those stay `sorry` for the prover phase. Your job is purely to thread the binder so the
statements become provable-as-typed.

## Changes Requested

- File: `AlgebraicJacobian/AbelianVarietyRigidity.lean`

  Add the instance binder `[LocallyOfFiniteType (X ⊗ Y).hom]` to the implicit/instance
  binder list of EACH of the following five theorems. Place it adjacent to the existing
  `[GeometricallyIrreducible (X ⊗ Y).hom]` / `[IsReduced (X ⊗ Y).left]` instance binders
  (same `{X Y Z : Over (Spec (.of kbar))}` context), so the new binder reads exactly:

      [LocallyOfFiniteType (X ⊗ Y).hom]

  1. `rigidity_eqAt_closedPoint_of_proper_into_affine` (currently ~L151)
  2. `rigidity_eqOn_saturated_open_to_affine`            (currently ~L203)
  3. `rigidity_eqOn_dense_open`                          (currently ~L271)
  4. `rigidity_core`                                     (currently ~L438)
  5. `rigidity_lemma`                                    (currently ~L520)

  Do **NOT** add the binder to `morphism_eq_of_eqAt_closedPoints` (~L107): it already takes
  `[JacobsonSpace W]` directly as its hypothesis and is correct as-is.

  After adding the binders, the four internal call sites
  (`rigidity_lemma`→`rigidity_core` at ~L538, `rigidity_core`→`rigidity_eqOn_dense_open` at
  ~L457, `rigidity_eqOn_dense_open`→`rigidity_eqOn_saturated_open_to_affine` at ~L377,
  `rigidity_eqOn_saturated_open_to_affine`→`rigidity_eqAt_closedPoint_of_proper_into_affine`
  at ~L242) must continue to elaborate with NO explicit-argument changes (the binder is
  instance-implicit and is in scope at each caller). If any call site nonetheless fails to
  resolve the instance, that is a genuine breakage — insert `sorry` there and report it; do
  NOT pass the instance explicitly unless Lean demands it.

  Leave the in-body `haveI : JacobsonSpace (...) := sorry` at ~L237 in place as a `sorry`
  (the prover will discharge it next phase using the now-available finite-type, via the
  three Mathlib facts above). However, UPDATE the stale explanatory comment block
  immediately above it (~L227–236, the "SIGNATURE GAP" note that asserts "the frozen chain
  signature carries no finite-type hypothesis ... not provable as literally typed"): reword
  it to state that `[LocallyOfFiniteType (X ⊗ Y).hom]` is now a hypothesis of this lemma, so
  `JacobsonSpace U` is now derivable (open subscheme of a Jacobson scheme; `Spec k̄` Jacobson
  + `LocallyOfFiniteType.jacobsonSpace` + `JacobsonSpace.of_isOpenEmbedding`) and this
  `sorry` is a routine instance discharge left for the prover — NOT an as-typed-unprovability.

  Leave the `:172` body `sorry` of `rigidity_eqAt_closedPoint_of_proper_into_affine`
  untouched (deep residual for the prover).

## Affected Files

`AlgebraicJacobian/AbelianVarietyRigidity.lean` (self-contained chain; no external non-sorry
callers — the only downstream consumers are the deferred scaffolds
`morphism_P1_to_grpScheme_const` / `genusZero_curve_iso_P1` /
`rigidity_genus0_curve_to_grpScheme`, all with `sorry` bodies, and they do not currently
invoke the chain). Verify `AlgebraicJacobian/Jacobian.lean` and any importer still compile
(they should — `rigidity_lemma` is not yet consumed outside this file).

## Expected Outcome

Five chain lemmas carry `[LocallyOfFiniteType (X ⊗ Y).hom]`. Build is GREEN. The sorry
landscape in the file is unchanged in COUNT (still the `:237` JacobsonSpace instance sorry +
the `:172` deep residual + the three pre-existing deferred scaffolds), but both remaining
chain sorries are now provable-as-typed. No new axioms. No protected signature touched
(none of the five is in `archon-protected.yaml`).
