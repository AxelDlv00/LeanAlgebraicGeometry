# Refactor Directive

## Slug

lane-i-localparameter-signature

## Problem

The public theorem
`AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
in `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (currently around L585) is
**mathematically false as currently stated**. The iter-191 plan-phase signature
reshape from existential to equation form introduced explicit `(t : K)` and
`(halg : algebraMap K C.left.functionField t ≠ 0)` arguments but did NOT add
the local-parameter constraint that the chapter prose requires.

**Counter-witness** (from iter-192 prover diagnosis): take
`K = C.left.functionField` (so the algebra map is the identity) and `t = 1 ∈ K`.

- `algebraMap K K(C) 1 = 1`, so `halg : 1 ≠ 0` holds.
- For every prime divisor `Y`,
  `order Y 1 = WithZero.log (Ring.ordFrac _ 1) = WithZero.log 1 = 0`, so
  `principal 1 halg = 0`.
- `positivePart 0 = 0`; `degree 0 = 0`. **LHS = 0**.
- `Module.finrank K(C) K(C) = 1`. **RHS = 1**.
- `0 ≠ 1` — equation false at this specialisation.

Per Lean type theory, a theorem cannot be saved by "requirements threaded
through the body proof". The hypothesis that `t` is a local parameter at the
chart at infinity MUST be part of the type signature, OR the consumer-side
witness must be threaded as an extra argument.

The consumer
`AlgebraicGeometry.Scheme.Hom.poleDivisor_degree_eq_finrank` in
`AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (currently L560–L562)
already passes `(localParameterAtInfty kbar).val` — by construction this
witness IS a local parameter at the point `∞ ∈ ℙ¹_{k̄}` corresponding to
`AlgebraicGeometry.localParameterAtInfty`. So the consumer can supply the
required witness directly.

## Mathematical Justification

The Hartshorne II.6.9 identity (chapter `RiemannRoch_WeilDivisor.tex` §6) says

  `deg ((div(f))_0) = [K(C) : k̄(ℙ¹)]`

ONLY when `f = φ^# t_∞` is the pullback of a local parameter at `∞ ∈ ℙ¹`.
For an arbitrary `f ∈ K(C)^×`, both sides depend on `f` in a non-trivial way
and they can disagree (the counter-witness above). The blueprint prose already
states this constraint:

  "Let `t_∞ ∈ K(ℙ¹)` be a local parameter at `∞ ∈ ℙ¹` (equivalently
  `t_∞ = 1/u` for the standard affine coordinate `u` on `ℙ¹ \ {∞}`).
  Write `f := φ^{#} t_∞ ∈ K(C)` for the pullback of `t_∞` along `φ`."
  (`blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`,
  `lem:degree_positivePart_principal_eq_finrank` block.)

The minimal Lean encoding of "is a local parameter" that the project already
has the machinery for is **the order condition on `algebraMap K K(C) t`**: there
must exist a prime divisor at which the pulled-back `t` has order exactly 1.

The simplest practical encoding — and the one we are committing to as Option 1
of the iter-192 review recommendations — is to bundle the witness as an
**existential argument** matching the shape of the consumer's call site (the
consumer ALREADY knows the witness via `localParameterAtInfty kbar`).

## Changes Requested

### Change 1 — `degree_positivePart_principal_eq_finrank` signature
(in `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`, around L585)

**Old signature** (the current false-as-stated form):

```lean
theorem degree_positivePart_principal_eq_finrank
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    [IsIntegral C.left] [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    {K : Type u} [Field K] [Algebra K C.left.functionField]
    [Module.Finite K C.left.functionField]
    (t : K)
    (halg : algebraMap K C.left.functionField t ≠ 0) :
    degree (positivePart
      (principal (algebraMap K C.left.functionField t) halg)) =
      (Module.finrank K C.left.functionField : ℤ) := by
  ...
```

**New signature** (add one hypothesis):

```lean
theorem degree_positivePart_principal_eq_finrank
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    [IsIntegral C.left] [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    {K : Type u} [Field K] [Algebra K C.left.functionField]
    [Module.Finite K C.left.functionField]
    (t : K)
    (halg : algebraMap K C.left.functionField t ≠ 0)
    (hlp : ∃ Y : C.left.PrimeDivisor,
      Scheme.RationalMap.order Y (algebraMap K C.left.functionField t) = 1) :
    degree (positivePart
      (principal (algebraMap K C.left.functionField t) halg)) =
      (Module.finrank K C.left.functionField : ℤ) := by
  ...
```

Notes for the refactor agent:

- `Scheme.RationalMap.order` is `WithZero.log ∘ Ring.ordFrac _`, returning an
  `ℤ` (zero if the witness vanishes; positive at zeros; negative at poles).
  An order `= 1` at some `Y` means `algebraMap K K(C) t` has a simple zero at
  the corresponding closed point — the project's elementary "is a local
  parameter at that point" notion, which is exactly what Hartshorne II.6.9
  needs to pin the affine chart at `∞`.
- We do NOT need the much stronger "order is exactly 1 ONLY at this one
  point and 0 everywhere else"; the chapter prose's affine-chart
  `Ideal.sum_ramification_inertia` argument only requires the local
  parameter to exist at the point we sum over, not exclusivity.
- The hypothesis name `hlp` mnemonically reads "has local parameter".
- The pre-existing typed `sorry` body of this theorem (currently at L663)
  is to be kept as-is — the body close is iter-194+ work. The point of this
  refactor is JUST to make the signature mathematically truthful so the
  body can in principle be closed honestly.

### Change 2 — `Hom.poleDivisor_degree_eq_finrank` consumer
(in `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`, L560–L562)

**Old body** (the current call site):

```lean
unfold Scheme.Hom.poleDivisor
exact Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank
  C (localParameterAtInfty kbar).val _
```

(With `_` filling the `halg : ... ≠ 0` hypothesis, presumably from a local
`haveI` or an existing structure-field projection.)

**New body** — thread an existential witness:

```lean
unfold Scheme.Hom.poleDivisor
refine Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank
  C (localParameterAtInfty kbar).val _ ?hlp
-- ?hlp : ∃ Y : C.left.PrimeDivisor,
--   Scheme.RationalMap.order Y
--     (algebraMap _ _ (localParameterAtInfty kbar).val) = 1
sorry  -- iter-194+ : exhibit the prime divisor at φ⁻¹(∞)
```

Notes for the refactor agent:

- **The witness `?hlp` is genuinely owed.** Producing the prime divisor at
  `φ⁻¹(∞)` and proving its order equals 1 is genuine Hartshorne content
  (the affine chart at `∞` + smoothness ⟹ DVR stalk ⟹ uniformiser has
  order 1). It is the iter-194+ body-close work, NOT plan-phase work.
- **You MUST land a typed `sorry` for `?hlp`.** The consumer will lose
  its kernel-clean axiom status (it now carries a `sorryAx` via `?hlp`).
  This is acceptable plan-phase debt: the iter-191 reshape made the consumer
  axiom-clean by punting the work into the public pin's body; that public-
  pin body is itself a `sorry`; the new arrangement just makes both `sorry`s
  explicit, which is exactly what we want.
- Net sorry-count delta for the refactor: `RationalCurveIso.lean` 1 → 2
  (one new typed sorry for `?hlp`); `WeilDivisor.lean` 3 → 3 (the pre-
  existing body sorry of the public pin remains). **Total +1 sorry**. This
  is acceptable because the new sorry is mathematically honest content,
  whereas the old setup hid a false equation behind a typed sorry that
  could never have been closed.

### Change 3 — internal `private` symmetry (OPTIONAL — not blocking)

If during the refactor you encounter the iter-191 inline comment block at
L538-L582 of `WeilDivisor.lean` referencing "soundness concern… addressed by
the implicit 'is a local parameter' requirement threaded through the body
proof", DELETE that block (it documents the now-fixed bug). Replace with a
one-paragraph comment naming the iter-193 fix: "Iter-193: added explicit
`hlp` hypothesis encoding the local-parameter constraint via order-equals-1
at some prime divisor."

The blueprint chapter prose update (removing the `% NOTE (iter-192 review)`
block) will be handled by the plan agent post-refactor — you do not edit
`blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`.

## Affected Files

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — signature change to
  `degree_positivePart_principal_eq_finrank` (one new `hlp` argument).
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` — consumer
  `Hom.poleDivisor_degree_eq_finrank` updates to supply `?hlp` (new typed
  sorry).

NO other files in the project reference
`degree_positivePart_principal_eq_finrank`. (Grep'd from
`AlgebraicJacobian/` and `analogies/` — only the consumer call site in
`RationalCurveIso.lean` matters.)

## Expected Outcome

After this refactor:

1. `degree_positivePart_principal_eq_finrank` in `WeilDivisor.lean` has the
   new `hlp` hypothesis and is mathematically truthful. Its body is still
   `sorry` (iter-194+ work; the chapter recipe via
   `Ideal.sum_ramification_inertia` is unchanged). WeilDivisor.lean sorry
   count unchanged: 3.
2. `Hom.poleDivisor_degree_eq_finrank` in `RationalCurveIso.lean` compiles
   and threads the witness via a typed sorry. RationalCurveIso.lean sorry
   count: 1 → 2 (NET +1 in the file).
3. `lake build AlgebraicJacobian.RiemannRoch.RationalCurveIso` returns
   exit 0. `lake build AlgebraicJacobian` returns exit 0. Total project
   sorry count: 77 → 78 (NET +1).
4. Project axioms unchanged: kernel-only `{propext, Classical.choice,
   Quot.sound}` per declaration; the new `sorryAx` carriers are the two
   newly-explicit body sorries plus existing carrier set.
5. NO new project-side axioms.

The +1 sorry is acceptable because it converts an unsound theorem into a
sound theorem with explicit owed work; this is project-positive content
even though the count goes up.

## Build verification

After all edits, run `lake build AlgebraicJacobian` and confirm exit 0 +
sorry-count delta = +1 from the new typed sorry in RationalCurveIso.lean.
Do NOT attempt to close `?hlp` axiom-clean — that is iter-194+ content
gated on the affine-chart at `∞` argument.
