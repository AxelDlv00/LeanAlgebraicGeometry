# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ratcurveiso-pins

## Iteration
181

## Question

For the two long-deferred Pins in
`AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`:
- **Pin 2** (`morphism_degree_via_pole_divisor`, Hartshorne II.6.9):
  does Mathlib expose a `Scheme.Hom.degree`, a Weil-divisor pullback,
  or the multiplicativity-of-degree formula?
- **Pin 3** (`iso_of_degree_one`, Hartshorne I.6.12 / Stacks 0AVX):
  does Mathlib expose `IsBirational`, Zariski's main theorem, or the
  "degree-1 ⟹ iso for smooth proper curves" specialisation?

If yes → the project should align with the Mathlib idiom. If no →
recommend the closest infrastructure + ~K LOC strategy.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Pin 2.1 — `Scheme.Hom.degree` for scheme morphisms | PROCEED | informational |
| Pin 2.2 — Weil-divisor pullback `f^* : Div(Y) → Div(X)` | PROCEED | informational |
| Pin 2.3 — multiplicativity-of-degree (Hartshorne II.6.9) | PROCEED | informational |
| Pin 3.1 — `IsBirational` / birational ⟹ iso for smooth proper curves | PROCEED | informational |
| Pin 3.2 — signature shape (function-field-iso hypothesis) | DIVERGE_INTENTIONALLY | informational |

**No ALIGN_WITH_MATHLIB verdict.** Mathlib has no `Scheme.Hom.degree`,
no `Scheme.WeilDivisor`, no `Scheme.WeilDivisor.pullback`, no
`IsBirational`, no "degree-1 ⟹ iso" for smooth proper curves. Both
pins are genuine gaps in Mathlib's algebraic-geometry coverage; the
project's in-tree path is the correct call.

## Informational

### Pin 2 — `morphism_degree_via_pole_divisor`: PROCEED

Mathlib has the **field-theoretic atom** for the eventual body but no
scheme-level wrapper:

- `Mathlib.AlgebraicGeometry.FunctionField` — exposes
  `Scheme.functionField` (`CommRingCat`-valued) and
  `IsFractionRing (X.presheaf.stalk x) X.functionField` for integral
  `X`. So `[K(C) : k̄(ℙ¹)]` is expressible as
  `Module.finrank C'.functionField C.functionField`.
- `Mathlib.NumberTheory.RamificationInertia.Basic.Ideal.sum_ramification_inertia`
  is the algebraic incarnation of Hartshorne II.6.9 specialised to
  Dedekind bases — the eventual body of Pin 2 routes
  the pole-divisor calculation through this lemma on each affine
  chart of `C'`.
- `Mathlib.AlgebraicGeometry.Morphisms.Finite.IsFinite` and
  `IsFinite.iff_isProper_and_isAffineHom` give the finite-morphism
  predicate the body needs.
- The complex-analytic `Mathlib.Analysis.Meromorphic.Divisor` and the
  affine-ring `Mathlib.RingTheory.PicardGroup.CommRing.Pic` are NOT
  applicable to the scheme-level pole-divisor calculation.

**Body strategy** (iter-178+, ~80-150 LOC):
1. Introduce a private `Scheme.Hom.poleDivisor` (or a
   `Scheme.WeilDivisor.pullback` general construction) inside
   `RationalCurveIso.lean` or `WeilDivisor.lean`.
2. Identify `d := Module.finrank C'.functionField C.functionField` as
   the degree.
3. Cover `C'` by affines `Spec A` containing `∞`; the preimage
   `Spec B` is finite Dedekind-over-Dedekind; apply
   `Ideal.sum_ramification_inertia` to write the local degree as
   `Σ_{Q over P_∞} e(Q|P_∞) · f(Q|P_∞) = d`.

Verdict rationale: PROCEED because no Mathlib API exists to align
with; the project must build the scheme-level wrapper. The current
signature (existence of positive-degree Weil divisor) is the right
substantive content given the project-bespoke `Scheme.WeilDivisor`.

Persistent file: `analogies/ratcurveiso-pin2.md`.

### Pin 3 — `iso_of_degree_one`: PROCEED + DIVERGE_INTENTIONALLY

Mathlib has **partial isomorphism criteria** but no curve-specific
"birational ⟹ iso":

- `Mathlib.AlgebraicGeometry.Normalization.Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom`
  (QuasiCompact + QuasiSeparated + IsIntegralHom ⟹
  `Scheme.Hom.toNormalization f` is iso). Bridge to Pin 3: smooth
  proper curve ⟹ source `C` is normal ⟹
  `Scheme.Hom.toNormalization φ : C ⟶ normalization φ` is iso under
  the integral-hom hypothesis. Then identify `normalization φ = C'`
  via smoothness of `C'`.
- `Mathlib.AlgebraicGeometry.OpenImmersion.isIso_iff_stalk_iso` and
  `isIso_iff_isIso_stalkMap` give the cleanest *reduction* to a
  stalk + topological iso check.
- `Mathlib.AlgebraicGeometry.Morphisms.IsIso.isIso_iff_isOpenImmersion_and_surjective`
  is an alternative criterion when "open immersion + surjective" is
  easier to certify.
- `Mathlib.AlgebraicGeometry.RationalMap.Scheme.RationalMap.ofFunctionField`
  / `.fromFunctionField` give the rational-map side of the
  "function-field iso ↔ birational map" correspondence, but the
  *extension of a rational map to a morphism* (needed to lift an
  abstract function-field iso back to a scheme iso) is absent for
  the smooth-proper-curve setting.

**Body strategy** (iter-178+, ~80-150 LOC):
1. **Refine the hypothesis** of `iso_of_degree_one` from "abstract
   function-field iso" to "function-field map induced by `φ` is iso"
   (or equivalently `Module.finrank C'.functionField C.functionField
   = 1`). The current existence hypothesis is a file-skeleton
   placeholder that is strictly weaker than what the
   birational-extension argument needs.
2. Reduce to `φ` finite via
   `IsFinite.iff_isProper_and_isAffineHom`.
3. Apply `Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom` to
   get the normalisation iso.
4. Identify `Scheme.Hom.normalization φ = C'` via smoothness of
   `C'` (smooth proper curve ⟹ regular ⟹ normal).

Alternative route (sheaf-cohomology, conceptually cleaner but more
API): show `O_{C'} ↪ φ_* O_C` is iso of coherent rank-1 torsion-free
sheaves on a smooth proper Dedekind base.

Pin 3.2 (signature shape) lands **DIVERGE_INTENTIONALLY** because the
file-skeleton hypothesis was deliberately a weak placeholder; the
iter-178+ body work will need to strengthen it.

Persistent file: `analogies/ratcurveiso-pin3.md`.

## Persistent files

- `analogies/ratcurveiso-pin2.md` — design rationale + Mathlib
  precedents + body strategy for Pin 2.
- `analogies/ratcurveiso-pin3.md` — design rationale + Mathlib
  precedents + body strategy for Pin 3.

## Overall verdict

Both pins are **PROCEED** (in-tree project work; Mathlib has the
field-theoretic / normalisation atoms but no scheme-level wrappers to
align with). The iter-182 planner is unblocked: no axiomatise vs.
in-tree decision is forced — the in-tree route is the correct call.
The only material change for iter-178+ body work is Pin 3.2's
signature refinement (strengthen the function-field-iso hypothesis to
"induced by `φ`" or to a `Module.finrank = 1` statement).
