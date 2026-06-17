# Mathlib Analogist Report

## Slug
c1-route

## Iteration
108

## Question

What is the canonical Mathlib idiom for defining the **Picard group of a
scheme as the units of a monoidal category of `O_X`-modules**, and is
that idiom executable today against the project's already-shipped
`MonoidalCategory (X.Modules)` / `BraidedCategory (X.Modules)` chain
(which transitively depends on the deferred `instIsMonoidal_W` sorry for
`(W X).IsMonoidal`)?

Sub-questions: (1) what is the actual name (is it
`MonoidalCategory.Invertible`?); (2) does the C1 LineBundle materially
depend on the deferred sorry; (3) what is the Mathlib idiom for
pull-back functoriality on Picard groups; (4) how does one register
inhabitants?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| A. Name of the "invertible-objects" type | ALIGN_WITH_MATHLIB | critical (must rename in directive) |
| B. Transitive dependence on `instIsMonoidal_W` | ALIGN_WITH_MATHLIB with disclosure cost | critical (strategy framing) |
| C. Pull-back functoriality on `LineBundle` | NEEDS_MATHLIB_GAP_FILL | critical (largest hidden cost) |
| D. Registering inhabitants of `LineBundle X` | PROCEED | informational |

## Must-fix-this-iter

### A. The strategy's "`MonoidalCategory.Invertible (X.Modules)`" target name does not denote any Mathlib declaration.

`STRATEGY.md` Phase C1 row and the "iter-110 escape-valve menu" option
(ii) both call the C1 refactor target `MonoidalCategory.Invertible
(X.Modules)`. **This name does not exist in Mathlib b80f227** — there is
no `MonoidalCategory.Invertible` type or typeclass. (`Module.Invertible R
M` exists at the ring level; `GrpObj` exists for *cartesian* monoidal
categories only; `RigidCategory`/`HasLeftDual`/`HasRightDual` exist for a
related but distinct purpose.)

The actual Mathlib idiom is **`(Skeleton C)ˣ`** — the units of the
skeleton's monoid structure on the objects of a (braided) monoidal
category. This is exactly what `CommRing.Pic` uses:

```
def CommRing.Pic (R : Type u) [CommSemiring R] : Type u :=
  Shrink (Skeleton <| SemimoduleCat.{u} R)ˣ
```
(`Mathlib.RingTheory.PicardGroup:407-408`)

The supporting infrastructure is
`CategoryTheory.Skeleton.instCommMonoid : [BraidedCategory C] →
CommMonoid (Skeleton C)` (`Mathlib.CategoryTheory.Monoidal.Skeleton:80`),
which combined with `instCommGroupUnits` gives the `CommGroup` instance
needed for the Picard group.

**Fix**: when the plan agent writes the C1 refactor directive (whether
this iter or iter-110+), the target must be `(Skeleton X.Modules)ˣ` (or
`Shrink (Skeleton X.Modules)ˣ` if the prover hits a universe-size
issue), with the existing `LineBundle` and `Pic` aliases pointed at it.
Concretely:

```lean
def LineBundle (X : Scheme.{u}) : Type u :=
  Shrink (Skeleton X.Modules)ˣ
```

or unshrunk if `X.Modules` is small enough:
`def LineBundle (X : Scheme.{u}) : Type u := (Skeleton X.Modules)ˣ`
(verify universe-size during the prover round).

### B. `instIsMonoidal_W` is load-bearing for C1, not "dormant deferred".

`STRATEGY.md`'s end-state framing ("3 named Mathlib gaps", or 4 with
L1802) treats `instIsMonoidal_W` as a named deferred gap on par with
`h_exact`/`nonempty_jacobianWitness`. **Numerically this is correct**
(the count of named sorries is unchanged), but the *transitive reach*
of the sorry changes dramatically under C1 promotion:

- **Pre-C1**: `instIsMonoidal_W` is referenced only by the project's
  `instMonoidalCategoryStruct` / `instMonoidalCategory` instances on
  `X.Modules`, and **nothing in the active proof DAG consumes those
  instances** (the project's `LineBundle` is `CommRing.Pic Γ(X, ⊤)`,
  which does not touch `X.Modules`'s monoidal structure). `lean_verify`
  on `Pic.pullback`, `PicardFunctor`, etc. does **not** surface this
  sorry.
- **Post-C1**: Every Lean term referencing `LineBundle X`, `Pic X`,
  `Pic.pullback`, `PicardFunctor`, `PicardFunctorAb` and the protected
  `Jacobian`/`AbelJacobi` signatures consuming `Pic` will type-check
  against `BraidedCategory (X.Modules)`, hence transitively against
  `instIsMonoidal_W`. **The sorry becomes load-bearing for the entire
  Picard-and-down arc.** `lean_verify` runs on all these declarations
  will surface `sorryAx` in their axiom chains.

This is *honest* (the sorry is named and not silently axiomatized), but
materially different from the present strategy framing. The disclosure
pattern already used for `nonempty_jacobianWitness`
(`STRATEGY.md` §"Honest assessment" / §"Plain-language disclosure")
must be replicated for `instIsMonoidal_W` post-C1:

> "The protected `Jacobian` / `ofCurve` / `Pic` / `Pic.pullback` /
> `PicardFunctor` declarations compile against the sorry-routed
> `instIsMonoidal_W` (the varying-ring `stalk_tensorObj` gap). The
> project ships a Picard *framework* conditional on this Mathlib gap."

**Fix**: if C1 promotion fires, `STRATEGY.md` end-state framing must be
updated to flag `instIsMonoidal_W` as load-bearing (not dormant). The
4-gap → 4-gap-but-3-of-them-load-bearing tally is the honest accounting.

### C. The categorical pull-back functor is not monoidal in Mathlib.

The strategy text contemplates that C1's `Pic.pullback` would derive
from a categorical pull-back functor `f^* : Y.Modules ⥤ X.Modules` plus
that functor's monoidality (a `Functor.Monoidal` instance). Mathlib b80f227
**does not provide** the latter:

- `AlgebraicGeometry.Scheme.Hom.pullback f : Y.Modules ⥤ X.Modules`
  exists (`Mathlib.AlgebraicGeometry.Modules.Sheaf:167-168`).
- A search across `Mathlib.AlgebraicGeometry.Modules.*`,
  `Mathlib.Algebra.Category.ModuleCat.Sheaf.*`, and
  `Mathlib.Algebra.Category.ModuleCat.Presheaf.*` finds **no**
  `Functor.Monoidal` instance on any pullback for `SheafOfModules` /
  `PresheafOfModules`. The only related instance is
  `(pushforward₀OfCommRingCat F R).Monoidal` for the presheaf-side
  *pushforward* (`Mathlib.Algebra.Category.ModuleCat.Presheaf.PushforwardZeroMonoidal:33`).

Without `(SheafOfModules.pullback _).Monoidal`, the categorical bridge
`Pic.pullback = Units.map (Skeleton.monoidHom (pullback f))` does not
type-check. The C1 refactor must therefore choose one of:

(a) **Build `Functor.Monoidal (Scheme.Hom.pullback f)` in the project**.
    This is a *fifth* Mathlib gap-fill comparable in scope to the
    `instMonoidalCategory` chain itself (multi-iter, multi-hundred LOC,
    routed through sheafification + presheaf-side pullback
    monoidality which is also absent from Mathlib).

(b) **Build `Pic.pullback` directly**, producing the iso
    `pullback (M ⊗ N) ≅ pullback M ⊗ pullback N` as a stand-alone
    proof obligation. Avoids the heavy `Functor.Monoidal` packaging
    but still requires the iso, which is the technical content
    anyway.

(c) **Accept a named additional sorry** —
    e.g. `theorem SheafOfModules.pullback_tensorObj :
    (pullback f).obj (M ⊗ N) ≅ (pullback f).obj M ⊗ (pullback f).obj N := sorry`
    — and route `Pic.pullback` through it. This expands the named-gap
    surface from 4 to 5 and is the smallest-scope move, mirroring the
    project's existing `instIsMonoidal_W` deferral pattern.

**The strategy text's "5-8 iters / 200-300 LOC" estimate for C1
plausibly does not include this work.** The `Functor.Monoidal`
instance for the pullback is **the dominant uncosted line-item** in C1
as currently scoped.

**Fix**: the C1 refactor directive must commit upfront to one of (a) /
(b) / (c). Default recommendation: (c) (smallest scope, named
deferral, consistent with the project's existing posture on
`instIsMonoidal_W` and `h_exact`); the named-gap count rises from 4
to 5.

## Major

(None — all ALIGN_WITH_MATHLIB verdicts are on not-yet-shipped C1 code
and surface above as must-fix-this-iter for the refactor directive
itself rather than as cleanup of shipped code.)

## Informational

### D. Inhabitant registration. PROCEED.

Mathlib's `CommRing.Pic.mk` uses a typeclass `Module.Invertible R M`
plus duality (`(Mᵛ ⊗ M → R) bijective`) to produce a `Pic R` inhabitant
via `Units.mkOfMulEqOne ⟦M⟧ ⟦Mᵛ⟧`. There is **no** scheme-side
typeclass analog (`SheafOfModules.Invertible`) in Mathlib b80f227, and
no general dualizability infrastructure for sheaves of modules.

Recommended posture for C1: do not introduce a typeclass; instead let
inhabitants be `Units.mkOfMulEqOne`-ed by hand with an explicit
`M ⊗ M⁻¹ ≅ 𝟙_` witness. A future iter (post-C1, outside the project's
autonomous scope) could add `SheafOfModules.Invertible` as the
scheme-side analog. **No action needed for the C1 refactor itself.**

## Overall verdict

The C1 promotion target name in the strategy text is wrong (the literal
`MonoidalCategory.Invertible` does not exist in Mathlib; the actual
idiom is `(Skeleton C)ˣ`). More importantly, C1 promotion materially
expands the transitive reach of the deferred `instIsMonoidal_W` sorry
(it becomes load-bearing rather than dormant) and likely requires a
fifth named gap on `SheafOfModules.pullback` monoidality. The plan
agent should fix the target name, commit to a pull-back-functoriality
route (preferred: named-deferral expanding gaps 4→5), and update the
end-state framing to disclose `instIsMonoidal_W` as load-bearing,
mirroring the existing `JacobianWitness` honest-accounting paragraph.

## Persistent file

- `analogies/c1-route.md` — full decision-by-decision rationale captured
  for future iters.
