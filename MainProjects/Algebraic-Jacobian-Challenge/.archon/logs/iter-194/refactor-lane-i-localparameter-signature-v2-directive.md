# Refactor Directive

## Slug

lane-i-localparameter-signature-v2

## Problem

The public theorem
`AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
in `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (currently at L725) is
**STILL mathematically false** even after iter-193's `hlp` augmentation
(Option 1 of the iter-192 review). The iter-193 prover identified a fresh
counter-witness inside the body and recorded it in the in-file docstring
(L770–L777):

```
K = K(C) = k̄(u) (i.e. C = ℙ¹), algebraMap = id, t = u(u-1) ∈ K.
- algebraMap _ _ t = u(u-1) ≠ 0  ⟹ halg holds.
- ord_{u=0} t = 1  ⟹ hlp satisfied (∃ Y with order Y t = 1).
- positivePart(principal t) = [{u=0}] + [{u=1}]
- degree = 2
- Module.finrank K K(C) = Module.finrank k̄(u) k̄(u) = 1
- 2 ≠ 1 — false at this specialisation.
```

`hlp` captures "some zero of order 1" but `t` may still have other zeros
(or doubled-poles like `u(u-1)` with `ord_∞ = -2`), so the equation
breaks. Plain `hlp` is necessary-but-not-sufficient.

The root cause is that the Lean signature lets the user pick **any
`Algebra K C.left.functionField`** structure, including the identity
(when `K = K(C)`) — but Hartshorne II.6.9 IMPLICITLY assumes the algebra
embedding is geometric: `K = k̄(t) ⊂ K(C)`, the smallest subfield of
`K(C)` containing `t`. With that interpretation, the counter-witness
disappears: for `t = u(u-1)`, `K = k̄(t) ⊊ k̄(u) = K(C)` with
`[K(C):K] = 2`, matching `LHS = 2`. The bug is that the Lean signature
does NOT pin `K = k̄(t)`.

## Mathematical justification

Hartshorne II.6.9 (`RiemannRoch_WeilDivisor.tex` §6,
`lem:degree_positivePart_principal_eq_finrank`): for a complete
non-singular curve `C/k̄` and a non-constant rational function
`f ∈ K(C)^×`, the degree of the **zero divisor** `(f)_0` equals
`[K(C) : k̄(f)]`. The morphism `f : C → ℙ¹` corresponding to the field
extension `k̄(f) ⊂ K(C)` is finite of degree `[K(C):k̄(f)]`, and
`(f)_0 = f^*[0_{ℙ¹}]`.

The two correct ways to encode this in Lean:

- **Option (b) [chosen — narrowest signature]**: drop the abstract `K`
  parameter; specialise to `K = (ProjectiveLineBar kbar).left.functionField`
  via the project's already-pinned `Algebra` instance. Take `t` to be an
  element of `(ProjectiveLineBar kbar).left.functionField` (i.e. of
  `k̄(u)` on the standard ℙ¹), and ADD a predicate asserting that the
  function `t` is a **uniformiser** on ℙ¹: its zero divisor has degree
  exactly 1. The reduced predicate is:
  ```
  degree (positivePart (principal t (proof_nonzero))) = 1
  ```
  but stated more elementarily as: `t` has exactly one prime divisor `Y₀`
  with `order Y₀ t = 1`, and `order Y t ≥ 0 ⟹ Y = Y₀ ∨ order Y t = 0`.
- **Option (a) [richer abstract K, more boilerplate]**: keep the
  `K` parameter; add a hypothesis that `K = k̄(t)` as a `k̄`-algebra
  (e.g. via `IsFractionRing (Algebra.adjoin k̄ {t}) K`); the body proof
  then exploits the structure.

We commit to **Option (b)** because:

- The consumer at `RationalCurveIso.lean:560-562` already passes
  `K = (ProjectiveLineBar kbar).left.functionField` and
  `t = (localParameterAtInfty kbar).val`. So dropping `K` matches the
  consumer's actual usage.
- The function `(localParameterAtInfty kbar).val` is **provably** a
  uniformiser at `∞ ∈ ℙ¹`: it equals `1/u` (a Möbius transform), with
  a simple zero at `∞` and a simple pole at `u = 0`. So the new
  `hLPUnif` hypothesis (uniformiser predicate) is mathematically true
  and discharge-able as iter-194+ work (currently typed sorry at the
  consumer site).
- Option (a) requires `IsFractionRing (Algebra.adjoin _ _) K` which is
  itself a non-trivial typeclass to set up at the consumer.

## Changes requested

### Change 1 — `degree_positivePart_principal_eq_finrank` signature

(in `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`, currently L725–L803)

**Old signature** (the current iter-193 still-false form):

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

**New signature** (Option b, narrow):

```lean
theorem degree_positivePart_principal_eq_finrank
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    [IsIntegral C.left] [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    [IsIntegral (ProjectiveLineBar kbar).left]
    [IsLocallyNoetherian (ProjectiveLineBar kbar).left]
    [Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left]
    [Algebra (ProjectiveLineBar kbar).left.functionField
       C.left.functionField]
    [Module.Finite (ProjectiveLineBar kbar).left.functionField
       C.left.functionField]
    (t : (ProjectiveLineBar kbar).left.functionField)
    (halg : algebraMap (ProjectiveLineBar kbar).left.functionField
       C.left.functionField t ≠ 0)
    -- t is a uniformiser on ℙ¹: it has a unique zero of order 1 and no
    -- other zero of positive order (i.e. its zero divisor on ℙ¹ has
    -- degree 1 — equivalently, t is a degree-1 element of K(ℙ¹)).
    (hLPUnif : ∃ Y₀ : (ProjectiveLineBar kbar).left.PrimeDivisor,
       Scheme.RationalMap.order Y₀ t = 1 ∧
       ∀ Y : (ProjectiveLineBar kbar).left.PrimeDivisor,
         Scheme.RationalMap.order Y t > 0 → Y = Y₀) :
    degree (positivePart
      (principal (algebraMap _ C.left.functionField t) halg)) =
      (Module.finrank (ProjectiveLineBar kbar).left.functionField
                       C.left.functionField : ℤ) := by
  -- Iter-194 plan-phase: body REMAINS sorry. Refactor sets the
  -- signature correctly; body close (Hartshorne II.6.9 affine-chart +
  -- Ideal.sum_ramification_inertia chain) is iter-194+ work.
  sorry
```

**Notes for the refactor agent:**

- The new typeclass instances `[IsIntegral (ProjectiveLineBar kbar).left]`,
  `[IsLocallyNoetherian (ProjectiveLineBar kbar).left]`,
  `[Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left]` are
  needed because `Scheme.RationalMap.order Y₀ t` (for `Y₀` a prime
  divisor of `ProjectiveLineBar`) requires the underlying scheme to
  support the order machinery. These should already be derivable from
  `ProjectiveLineBar`'s smooth-properness; if Lean can't synthesize one,
  surface as a typed sorry (`have : Scheme.IsRegularInCodimensionOne _ :=
  by sorry  -- iter-194+: derive from smooth-1-dim`).
- The 8 axiom-clean substrate helpers landed iter-193 (`principal_apply`,
  `positivePart_single`, `degree_single`, `degree_zero`, `degree_add`,
  `Scheme.RationalMap.order_one`, `principal_one`,
  `one_le_degree_positivePart_principal_of_order_one`) remain valid and
  USEFUL post-refactor — they apply to any `Scheme.WeilDivisor`, not
  specifically to the consumer's setup. Keep them.
- The pre-existing typed sorry body of the theorem (L803) stays as
  `sorry` — iter-194+ owes the body close. The refactor's only job is
  to make the signature mathematically truthful so the body CAN in
  principle be closed honestly.

### Change 2 — `Hom.poleDivisor_degree_eq_finrank` consumer

(in `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`, currently
L521–L565)

The current consumer body is:

```lean
unfold Scheme.Hom.poleDivisor
refine Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank
  C (localParameterAtInfty kbar).val _ ?hlp
-- ?hlp : ∃ Y, order Y (...) = 1
sorry
```

**New consumer body** (per the v2 signature):

```lean
unfold Scheme.Hom.poleDivisor
refine Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank
  C (localParameterAtInfty kbar).val _ ?hLPUnif
-- ?hLPUnif : ∃ Y₀, order Y₀ t = 1 ∧ ∀ Y, order Y t > 0 → Y = Y₀
-- iter-194+: exhibit Y₀ = the prime divisor at ∞ ∈ ℙ¹, prove order 1
-- via the localParameterAtInfty's uniformiser property, prove
-- uniqueness via "1/u has a single zero on ℙ¹"
sorry
```

Notes:

- The new `?hLPUnif` is genuinely owed: producing the prime divisor at
  `∞ ∈ ℙ¹` and proving uniqueness of its zero of order 1 is genuine
  Hartshorne content. The iter-194+ body-close is the work.
- The previous typed sorry for `?hlp` (iter-193 plan-phase) is replaced
  by this stronger typed sorry for `?hLPUnif`. NET sorry count: 0 change
  in `RationalCurveIso.lean` (1 in, 1 out).
- The old iter-193 plan-phase consumer setup may need adjustment for
  Lean to infer the implicit `[Algebra ProjectiveLineBar.functionField
  C.functionField]` etc. The consumer ALREADY has these instances; no
  new instance declaration should be needed.

### Change 3 — docstring update on the theorem

Replace the in-file iter-193 NOTE block at L766–L803 with a one-paragraph
note:

```lean
  -- **Iter-194 refactor v2** (lane-i-localparameter-signature-v2):
  -- the signature now drops the abstract `K` parameter and pins to
  -- `(ProjectiveLineBar kbar).left.functionField`, with the uniformiser
  -- hypothesis `hLPUnif` enforcing the local-parameter constraint
  -- correctly (iter-193 `hlp` was insufficient; counter-witness
  -- `K=K(C), t=u(u-1)` is now excluded because `t` lives strictly in
  -- `K(ℙ¹)` and `hLPUnif` requires `t` to have a single zero of order
  -- 1 on ℙ¹, ruling out functions with multiple zeros). The body
  -- (~50-80 LOC owed iter-194+) chains
  -- `Ideal.sum_ramification_inertia` + `Ideal.finrank_quotient_map` on
  -- the Dedekind extension `A → B` at the maximal ideal `m_Y₀ = (t) ⊂ A`,
  -- per `analogies/ratcurveiso-pin2.md` Decision 2.
  sorry
```

Leave the 8 substrate helpers (`principal_apply` etc.) untouched.

## Affected files

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — signature reshape
  (drop K, add ProjectiveLineBar typeclass instances, replace `hlp` with
  `hLPUnif`). Body remains `sorry`.
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` — consumer
  refactor (replace `?hlp` typed sorry with `?hLPUnif` typed sorry).

NO other files reference `degree_positivePart_principal_eq_finrank`
(grep'd from `AlgebraicJacobian/` and `analogies/`).

## Expected outcome

After this refactor:

1. `degree_positivePart_principal_eq_finrank` in `WeilDivisor.lean` has
   the v2 signature (no `K`; uniformiser `hLPUnif` hypothesis).
   Mathematically truthful: the counter-witness `K = K(C), t = u(u-1)`
   no longer applies because `t` is required to live in `K(ℙ¹)`, AND
   `hLPUnif` requires `t` to have a unique simple zero on ℙ¹ (which
   `u(u-1)` does not — it has TWO simple zeros at `u=0` and `u=1`, so
   the `hLPUnif`'s uniqueness clause fails).
2. Consumer in `RationalCurveIso.lean` carries the typed sorry for
   `?hLPUnif`; body otherwise unchanged.
3. `lake build AlgebraicJacobian` returns exit 0. NO new project axioms.
4. Project sorry-count delta: **0** (the old `?hlp` typed sorry
   becomes the new `?hLPUnif` typed sorry; 1:1 swap). WeilDivisor sorry
   count unchanged (3). RationalCurveIso sorry count unchanged (3).
5. Build verification: `lake build AlgebraicJacobian` exit 0; the
   refactor compiles cleanly through the new typeclass instances on
   `ProjectiveLineBar`.

## Build verification

After all edits, run `lake build AlgebraicJacobian` and confirm exit 0.
Sorry count should be unchanged (the `hlp` typed sorry is replaced 1:1
by the `hLPUnif` typed sorry). DO NOT attempt to close `?hLPUnif`
axiom-clean — that is iter-194+ body-close content.

If the new `ProjectiveLineBar` typeclass instances cannot be derived
(e.g. `IsRegularInCodimensionOne (ProjectiveLineBar kbar).left` doesn't
resolve), insert them as named typed sorrys directly above the theorem:

```lean
private instance : Scheme.IsRegularInCodimensionOne
    (ProjectiveLineBar kbar).left := by
  -- iter-194+: derive from `SmoothOfRelativeDimension 1` of the
  -- ProjectiveLineBar (smooth ⟹ regular ⟹ regular in codim 1).
  sorry
```

Each such typed sorry should be private and adds at most ~3 to the file
sorry count. The plan agent accepts this — soundness of the signature is
the priority; the typed sorries are honest scaffolding.

## Reversal signal

If the refactor reports that `hLPUnif`'s uniqueness clause introduces
unresolvable typeclass-friction or proof-irrelevance issues at the
consumer (e.g. the consumer can't construct `Y₀` without further machinery
that isn't in the project), fall back to Option (a) — keep the abstract
`K`, add the `IsFractionRing (Algebra.adjoin k̄ {t}) K` hypothesis — and
record the fallback in the report. Iter-195 plan-phase will then dispatch
a refactor v3.
