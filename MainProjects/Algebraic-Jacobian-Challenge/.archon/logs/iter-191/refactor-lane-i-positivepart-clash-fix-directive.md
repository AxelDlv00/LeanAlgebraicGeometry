# Refactor Directive

## Slug

lane-i-positivepart-clash-fix

## Problem

The iter-190 paired Lane I prover dispatch produced an integration
build RED state: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`
and `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` BOTH define the
same fully-qualified declaration
`AlgebraicGeometry.Scheme.WeilDivisor.positivePart`, with the
RationalCurveIso version `private`. Lean's namespace resolution
treats `private` as a visibility modifier only — fully-qualified names
must still be unique, so the redeclaration is rejected at link time:

```
error: AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:416:26:
  a non-private declaration `AlgebraicGeometry.Scheme.WeilDivisor.positivePart`
  has already been declared
```

`lake build AlgebraicJacobian` exits 1 on this; the 10-consecutive-
zero-axiom build streak is interrupted until this clash resolves.

Additionally, the public pin
`AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
in WeilDivisor.lean landed in EXISTENTIAL form
(`∃ t halg, deg(positivePart(principal (algebraMap K K(C) t) halg)) = finrank`)
for soundness — the equation form is false-as-stated for arbitrary
`t`. But this existential form does not directly support
`Hom.poleDivisor_degree_eq_finrank`'s consumer (which needs the
equation at the SPECIFIC local-parameter witness `localParameterAtInfty
kbar`). The cleanest resolution is to refactor the public pin
signature to take the local-parameter hypothesis as an EXPLICIT
argument (equation form, no existential), and update the consumer in
RationalCurveIso.lean to feed `localParameterAtInfty kbar` plus its
local-parameter proof.

## Mathematical Justification

The mathematical content of Hartshorne II.6.9 is the equation
`deg((div(φ^* t))_0) = [K(C) : K(ℙ¹)]` at any uniformiser `t` of `O_{ℙ¹,
∞}`. The existential form picks SOME local parameter; the equation
form takes the local parameter as a hypothesis. Both are
mathematically equivalent (the existential is the projection of the
equation form onto the existence-of-witness fragment), but the
equation form is what the consumer site `Hom.poleDivisor` needs
(`Hom.poleDivisor φ := positivePart (principal (algebraMap _ _
(localParameterAtInfty kbar).val) halg)` evaluates at a SPECIFIC
witness, not at a chosen one).

Per iter-190 review recommendations §4: option (i) re-tightening the
Lean signature is preferred over option (ii) re-writing the chapter
prose, because the chapter prose is mathematically natural in
equation form (Hartshorne II.6.9 verbatim) and the soundness concern
is addressed by adding the explicit "is a local parameter" hypothesis.

The file-local typed-sorry pin
`WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank`
(L444 of RationalCurveIso.lean, currently `private`) IS the equation
form specialised to `t = (localParameterAtInfty kbar).val`. After
this refactor, the consumer in `Hom.poleDivisor_degree_eq_finrank`
will:
1. Use the public `Scheme.WeilDivisor.positivePart` (no file-local
   shadow).
2. Apply the public `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
   reshaped to take `(localParameterAtInfty kbar).val` as the local-
   parameter argument.

The file-local pin can be removed entirely; the public pin in its
reshaped form is the single source of truth.

## Changes Requested

### File: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

Reshape `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
(L543) from existential form to equation form with an explicit
local-parameter hypothesis.

- **Old** (L543–L555, existential form):
  ```
  theorem degree_positivePart_principal_eq_finrank
      {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
      (C : Over (Spec (.of kbar))) [IsProper C.hom]
      [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
      [IsIntegral C.left] [IsLocallyNoetherian C.left]
      [Scheme.IsRegularInCodimensionOne C.left]
      {K : Type u} [Field K] [Algebra K C.left.functionField]
      [Module.Finite K C.left.functionField] :
      ∃ (t : K) (halg : algebraMap K C.left.functionField t ≠ 0),
        degree (positivePart
          (principal (algebraMap K C.left.functionField t) halg)) =
          (Module.finrank K C.left.functionField : ℤ) := by
    sorry
  ```

- **New** (equation form, explicit local-parameter `t` argument):
  ```
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
    sorry
  ```

  Justification: The equation form takes `t` and `halg` as explicit
  parameters (matching the file-local file-local pin signature
  shape). The signature is now usable directly by any consumer with a
  concrete witness `t`; existence-of-witness is no longer the API
  surface (it's downstream of the consumer's choice).

  NOTE: this changes the type semantically — but since the body is a
  `sorry` (typed-sorry pin; body owed iter-191+ via Hartshorne II.6.9
  affine-chart `Ideal.sum_ramification_inertia` chain), the body
  signature is the only API surface and it is safe to reshape now.

  Update the docstring (the block at L512–L541 of WeilDivisor.lean) to
  match the equation form:
  - Remove the existential / "exists a non-zero element `t ∈ K`"
    framing.
  - State the equation `deg(positivePart(principal(algebraMap K K(C)
    t))) = [K(C) : K]` directly for any chosen `t` and `halg`, with a
    `% NOTE:` that the canonical witness in the project is
    `(localParameterAtInfty kbar).val`.
  - Body recipe remains unchanged (`Ideal.sum_ramification_inertia` +
    `Ideal.finrank_quotient_map` per `analogies/ratcurveiso-pin2.md`
    Decision 2).

### File: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

Two changes.

#### Change A — DELETE the file-local `WeilDivisor.positivePart` def (L416–L418)

The file-local

```
private noncomputable def WeilDivisor.positivePart {X : Scheme.{u}}
    (D : X.WeilDivisor) : X.WeilDivisor :=
  Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp) D
```

becomes redundant once the public `Scheme.WeilDivisor.positivePart`
in WeilDivisor.lean is imported. Delete L416–L418 (the def) and its
docstring block (L405–L415).

Any references in the file to `WeilDivisor.positivePart` (e.g. inside
`Hom.poleDivisor`'s body) will now resolve to
`AlgebraicGeometry.Scheme.WeilDivisor.positivePart` from the
WeilDivisor.lean import — this is the desired outcome and is automatic
(no edit needed at the consumer sites; just ensure the imports +
namespace open are intact).

#### Change B — DELETE the file-local pin
`WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank`
(L444–L469)

The file-local

```
private theorem
    WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank
    ... :
    Scheme.WeilDivisor.degree
        (WeilDivisor.positivePart
          (Scheme.WeilDivisor.principal
            (algebraMap (ProjectiveLineBar kbar).left.functionField
              C.left.functionField (localParameterAtInfty kbar).val)
            halg)) =
      (Module.finrank
        (ProjectiveLineBar kbar).left.functionField
        C.left.functionField : ℤ) := by
  sorry
```

becomes the public
`Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` (in
its reshaped equation form, see WeilDivisor.lean change above)
specialised at:
- `K = (ProjectiveLineBar kbar).left.functionField`
- `t = (localParameterAtInfty kbar).val`
- `halg` = the local `halg` from `Hom.poleDivisor`.

Delete L444–L469 (the pin) and its docstring block (L420–L443).

#### Change C — Update `Hom.poleDivisor_degree_eq_finrank` body (L585–L624)

Currently:

```
unfold Scheme.Hom.poleDivisor
exact
  WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank
    φ _hφ_non_const _
```

Update to:

```
unfold Scheme.Hom.poleDivisor
-- Apply the public WeilDivisor pin (equation form, specialised at
-- t = localParameterAtInfty kbar).
exact Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank
    C (localParameterAtInfty kbar).val _
```

where the `_` argument is Lean's elaboration of the local `halg` from
the `unfold`ed `Hom.poleDivisor` body.

NOTE: the public pin's `[Module.Finite K C.left.functionField]`
instance must be satisfiable at this call site. Since the
`Hom.poleDivisor_degree_eq_finrank` signature already requires
`[GeometricallyIrreducible C.hom]` + `[SmoothOfRelativeDimension 1
C.hom]` + non-constancy, the implied finite extension `K(ℙ¹) → K(C)`
should give the instance via some derivation. If the instance cannot
be derived, add `[Module.Finite (ProjectiveLineBar kbar).left.functionField
C.left.functionField]` as an explicit binder on
`Hom.poleDivisor_degree_eq_finrank` (matching what was implicit in the
file-local pin's signature).

## Affected Files

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — signature
  reshape (~10 LOC change in the theorem signature + docstring update
  ~20 LOC).
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` — three
  cumulative edits: delete file-local def (~14 LOC removed incl.
  docstring), delete file-local pin (~50 LOC removed incl.
  docstring), update `Hom.poleDivisor_degree_eq_finrank` body
  (~5 LOC change).
- No other files should be affected (only `AlgebraicJacobian.lean`
  imports RationalCurveIso.lean as the umbrella, and the umbrella
  doesn't reference these symbols directly).

## Expected Outcome

After this refactor:

1. `lake build AlgebraicJacobian` GREEN (integration restored).
2. `WeilDivisor.lean` sorry count: **unchanged** at 3 (the existential
   pin → equation pin is still one typed-sorry; just reshaped).
3. `RationalCurveIso.lean` sorry count: **decreases by 1** (the
   file-local pin removed; `Hom.poleDivisor_degree_eq_finrank` body
   consumes the public pin axiom-clean modulo the public sorryAx).
4. Project axioms: `{propext, Classical.choice, Quot.sound}` for the
   non-sorry-consuming subset; `sorryAx` only via the SINGLE public
   pin `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`.
   The 10-consecutive-zero-axiom-build streak resumes the next time
   prover phase doesn't add a new typed sorry.
5. `\lean{...}` cross-refs in `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`
   `lem:degree_positivePart_principal_eq_finrank` and
   `RiemannRoch_RationalCurveIso.tex` `def:Hom.poleDivisor` continue
   to resolve correctly.

## What you must NOT do

- Do NOT attempt to PROVE the body of
  `degree_positivePart_principal_eq_finrank` — leave it as `sorry`
  (typed-sorry pin; body iter-191+ via Hartshorne II.6.9 chain). The
  refactor is signature reshape only.
- Do NOT touch other files (`AbelianVarietyRigidity.lean`,
  `OCofP.lean`, etc.) — the clash is localised to the two files
  above.
- Do NOT add or remove `\leanok` markers — those are managed by
  `sync_leanok` between prover and review.

## Verification at end of refactor

- `lake build AlgebraicJacobian` GREEN.
- `lean_diagnostic_messages` on both files reports only `sorry`
  warnings (no errors).
- `lean_verify AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
  reports `sorryAx` + standard kernel axioms.
- `lean_verify AlgebraicGeometry.Scheme.Hom.poleDivisor_degree_eq_finrank`
  reports `sorryAx` (via the public pin) + standard kernel axioms.
- File sorry counts as predicted above.
