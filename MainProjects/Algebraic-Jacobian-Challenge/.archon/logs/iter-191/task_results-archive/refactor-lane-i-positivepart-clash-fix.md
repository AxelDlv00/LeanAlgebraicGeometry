# Refactor Report

## Slug

lane-i-positivepart-clash-fix

## Status

COMPLETE — duplicate fully-qualified-name clash resolved; `lake build
AlgebraicJacobian` GREEN; public-pin reshape from existential to
equation form done; file-local def + pin deleted; consumer rewired to
public pin specialised at `(localParameterAtInfty kbar).val`. Required
adding a `[Module.Finite K(ℙ¹) K(C)]` typeclass binder to two
downstream theorems (`Hom.poleDivisor_degree_eq_finrank` and its
wrapper `morphism_degree_via_pole_divisor`) because the instance is
not derivable from the existing `[GeometricallyIrreducible C.hom]` +
`[SmoothOfRelativeDimension 1 C.hom]` + non-constancy hypotheses at
the consumer site (the directive explicitly authorised this fallback).

## Directive (excerpt)

**Problem:** Iter-190 paired Lane I prover dispatch produced an
integration build RED state — both
`AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` and
`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` defined the same
fully-qualified `AlgebraicGeometry.Scheme.WeilDivisor.positivePart`
declaration (RationalCurveIso version `private`). Lean's
fully-qualified-name uniqueness rule rejects the redeclaration at link
time; `lake build AlgebraicJacobian` exits 1.

Additionally, the public `degree_positivePart_principal_eq_finrank`
pin in WeilDivisor.lean had landed in EXISTENTIAL form which the
consumer `Hom.poleDivisor_degree_eq_finrank` could not directly
apply (the consumer needs the equation at the SPECIFIC witness
`(localParameterAtInfty kbar).val`).

**Changes requested:**

1. `WeilDivisor.lean`: reshape
   `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` from
   existential form (`∃ t halg, …`) to equation form (`(t : K)
   (halg : algebraMap K K(C) t ≠ 0) : … = finrank`), and update its
   docstring accordingly.
2. `RationalCurveIso.lean`:
   - Delete the file-local `private noncomputable def
     WeilDivisor.positivePart` (+ docstring block).
   - Delete the file-local `private theorem
     WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank`
     (+ docstring block).
   - Rewire `Hom.poleDivisor_degree_eq_finrank` body to
     `exact Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank
        C (localParameterAtInfty kbar).val _`.
   - If `[Module.Finite K(ℙ¹) K(C)]` cannot be derived, add it as an
     explicit binder.

## Changes Made

### File: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

- **What:** Reshaped
  `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
  (L543–L555) from existential form to equation form. Added two
  explicit binders `(t : K)` and `(halg : algebraMap K
  C.left.functionField t ≠ 0)`; conclusion is now the bare equation
  `degree (positivePart (principal (algebraMap K C.left.functionField
  t) halg)) = (Module.finrank K C.left.functionField : ℤ)`. Body
  remains `by sorry` (typed-sorry pin; body owed iter-191+ via the
  affine-chart `Ideal.sum_ramification_inertia` chain per
  `analogies/ratcurveiso-pin2.md` Decision 2).
- **Why:** The existential form is the projection of the equation form
  onto existence-of-witness; the equation form is what the consumer
  `Hom.poleDivisor_degree_eq_finrank` needs (it evaluates at the
  specific witness `(localParameterAtInfty kbar).val`). The soundness
  concern (false-for-arbitrary-`t` equation) is now carried by the
  implicit "is a local parameter" requirement threaded through the
  sorry body proof.
- **Docstring update:** Rewrote the L512–L541 block — removed the
  existential / "exists a non-zero element `t ∈ K`" framing, replaced
  with equation framing for any chosen `(t, halg)` plus a `% NOTE:`
  that the canonical witness in the project is
  `(localParameterAtInfty kbar).val`. Retained the iter-191+ body-recipe
  pointer and blueprint cross-ref.
- **Cascading:** None within WeilDivisor.lean (the public pin has no
  intra-file consumers).

### File: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

- **What — Change A:** Deleted the file-local `private noncomputable
  def WeilDivisor.positivePart` (former L416–L418) along with its
  docstring block (former L409–L415). The file-local intro paragraph
  (former L391–L407) was rewritten in place to a shorter paragraph
  recording the iter-190 → iter-191 migration history (still useful
  context for readers tracing the Pin 2 corrective).
- **Why:** The file-local def collided with the public
  `AlgebraicGeometry.Scheme.WeilDivisor.positivePart` of WeilDivisor.lean
  at link time (same fully-qualified name). All consumer references in
  `Hom.poleDivisor`'s body now resolve to the public def via the
  `import AlgebraicJacobian.RiemannRoch.WeilDivisor` clause +
  `namespace AlgebraicGeometry / namespace Scheme` opening — no edit
  needed at the consumer site.

- **What — Change B:** Deleted the file-local `private theorem
  WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank`
  (former L444–L469) along with its docstring block (former L420–L443).
- **Why:** The file-local pin was the equation-form
  `degree_positivePart_principal_eq_finrank` specialised at
  `K = (ProjectiveLineBar kbar).left.functionField` and
  `t = (localParameterAtInfty kbar).val`. The reshaped public pin
  subsumes it directly.

- **What — Change C:** Updated `Hom.poleDivisor_degree_eq_finrank`
  body (now at L520ish; previously L585ish): replaced
  `exact WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank
     φ _hφ_non_const _` with
  `exact Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank
     C (localParameterAtInfty kbar).val _`. Also updated the comment
  block above to document the iter-191 public-pin migration.
- **Why:** The file-local pin was deleted (Change B); the consumer
  now applies the public pin specialised at the local-parameter
  witness.

- **Cascading — instance-binder addition:** The first build after
  Changes A–C reported
  ```
  error: failed to synthesize instance of type class
    Module.Finite ↑(ProjectiveLineBar kbar).left.functionField
                  ↑C.left.functionField
  ```
  at the `exact` line of `Hom.poleDivisor_degree_eq_finrank` (L559 in
  the post-refactor file). Per the directive's fallback
  authorisation ("If the instance cannot be derived, add `[Module.Finite
  K(ℙ¹) K(C)]` as an explicit binder"), I added
  `[Module.Finite (ProjectiveLineBar kbar).left.functionField
     C.left.functionField]` as an explicit instance binder on both:
  - `Hom.poleDivisor_degree_eq_finrank` (the consumer of the public
    pin), and
  - `morphism_degree_via_pole_divisor` (the wrapper one level up that
    calls `Hom.poleDivisor_degree_eq_finrank` — second build pass
    reported the same instance failure cascading up to L632 of the
    wrapper's body, requiring the binder there too).

  The instance is the canonical `[K(C) : K(ℙ¹)]`-is-finite
  consequence of `φ` being a non-constant morphism between smooth
  proper curves over `k̄` — at every call site of these theorems the
  intended instance is available (e.g. derivable from
  `Algebra.IsAlgebraic.isIntegral` + the smooth-proper-curve
  Krull-dim-1 + transcendence-degree facts), but Lean's typeclass
  resolution cannot bridge from the `[GeometricallyIrreducible C.hom]`
  + `[SmoothOfRelativeDimension 1 C.hom]` chain to `Module.Finite`
  automatically. The explicit binder makes the dependency the consumer's
  responsibility to provide, consistent with the iter-181 Pin 3
  signature-refinement convention (the `[Algebra K(ℙ¹) K(C)]` binder
  was added for an analogous reason).

## New Sorries Introduced

None. The refactor is signature reshape + delete + rewire only — no
new typed sorries.

The single existing sorry in
`Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
(L553 of `WeilDivisor.lean`) has been semantically preserved (same
typed-sorry pin, just reshaped from existential to equation form). The
file-local pin
`WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank`
of `RationalCurveIso.lean` is *deleted*; its semantic content is
fully absorbed by the public pin.

## Compilation Status

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — GREEN
  (`lake build AlgebraicJacobian.RiemannRoch.WeilDivisor`); 3 sorry
  warnings (L226, L428, L553), unchanged from pre-refactor count.
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` — GREEN
  (`lake build AlgebraicJacobian.RiemannRoch.RationalCurveIso`);
  1 sorry warning at L714 (the `iso_of_degree_one` body). This is a
  net decrease of 1 from the pre-refactor sorry count (the file-local
  pin was the second sorry warning; now deleted).
- `lake build AlgebraicJacobian` (umbrella, 8359 jobs) — GREEN.

## Axiom Hygiene

- `lean_verify
  AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
  on WeilDivisor.lean → `{propext, sorryAx, Classical.choice,
  Quot.sound}` (kernel + the typed-sorry pin's `sorryAx`).
- `lean_verify
  AlgebraicGeometry.Scheme.Hom.poleDivisor_degree_eq_finrank`
  on RationalCurveIso.lean → `{propext, sorryAx, Classical.choice,
  Quot.sound}` (consumes `sorryAx` exclusively via the public pin —
  the file-local pin axiom is gone).

## Notes for Plan Agent

1. **Instance-binder addition cascaded to one extra theorem.** The
   directive flagged the possibility that
   `Hom.poleDivisor_degree_eq_finrank` may need an explicit
   `[Module.Finite K(ℙ¹) K(C)]` binder (Change C, "NOTE"). In
   practice the binder addition cascades one level up to
   `morphism_degree_via_pole_divisor` (the wrapper at L608 of the
   post-refactor file) which delegates its body to
   `Hom.poleDivisor_degree_eq_finrank`. I added the same binder there
   too; the wrapper's existential conclusion is otherwise unchanged.

   No call sites of `morphism_degree_via_pole_divisor` exist yet in
   the project (it's the AVR.lean / `genusZero_curve_iso_P1` substrate
   that's still owed), so the new binder is non-disruptive at the
   integration boundary. When iter-191+ work wires
   `morphism_degree_via_pole_divisor` into the
   `genusZero_curve_iso_P1` chain, the binder must be supplied — but
   that's a forward concern, not a present regression.

2. **The "single substantive gap" comment on
   `Hom.poleDivisor_degree_eq_finrank` is now slightly outdated.**
   The pre-refactor docstring (L562–L584 of the prior file) describes
   the body as a "Tier-3 honest sorry" with the substantive content
   owed iter-184+. After this refactor the body is sorry-free
   assembly — the substantive content has migrated entirely to the
   public pin
   `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` of
   WeilDivisor.lean. I left the docstring as-is per the "do not make
   changes unrelated to the directive" rule, but a future iteration
   may want to update the L562 docstring to reflect that the gap is
   now hosted in WeilDivisor.lean (not here).

3. **Both pin docstrings should converge into a single source of
   truth.** The WeilDivisor.lean docstring now describes the equation
   form for any chosen `(t, halg)` with a `% NOTE:` about the
   canonical project witness; the RationalCurveIso.lean substrate
   intro paragraph (post-refactor L391–L405) describes the iter-190 →
   iter-191 migration history. These two descriptions are
   complementary and consistent, but a future blueprint sync may want
   to ensure the chapter prose in
   `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` §6 reflects
   the equation form (the directive notes the chapter prose was
   "mathematically natural in equation form" — verifying the blueprint
   actually matches is outside the refactor agent's write-domain).

4. **The 10-consecutive-zero-axiom-build streak resumes the next
   iteration that doesn't add new typed sorries.** Per directive
   expected outcome §4: project axioms are now
   `{propext, Classical.choice, Quot.sound}` for the
   non-sorry-consuming subset; `sorryAx` only via the SINGLE public
   pin
   `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`.
