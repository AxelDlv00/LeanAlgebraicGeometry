# Mathlib Analogist Report

## Mode
api-alignment

## Slug
gm-grpobj-representable

## Iteration
179

## Question

What is the canonical Mathlib idiom for installing the `GrpObj` instance on
`𝔾_m = Spec (k̄[t, t⁻¹])` via the representable-by-units functor construction?
Concretely, `AlgebraicJacobian/Genus0BaseObjects/Points.lean:251` —

```lean
instance gm_grpObj (kbar : Type u) [Field kbar] : GrpObj (Gm kbar) := sorry
```

— deferred 11+ iters; load-bearing for `gm_smooth`, the Route C base case,
and `iotaGm_isDominant`.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Is `GrpObj.ofRepresentableBy` the right Mathlib idiom? | PROCEED | informational |
| Does Mathlib already install `GrpObj` on a `Spec`-of-units construction? | NEEDS_MATHLIB_GAP_FILL | informational |
| What's the closed body's shape? | PROCEED (3-step bijection, ~75-115 LOC) | informational |
| Cross-domain: any `MonObj`/`GrpObj` on `Spec (Localization.Away _)` shipped? | PROCEED (no prior art; project FIRST) | informational |

## Major

(No ALIGN_WITH_MATHLIB verdicts — the project's planned path IS the
Mathlib idiom; the project simply hasn't shipped the body yet.)

## Informational

- **`GrpObj.ofRepresentableBy` EXISTS** at
  `Mathlib/CategoryTheory/Monoidal/Cartesian/Grp_.lean:35`. The signature
  is `(F : Cᵒᵖ ⥤ GrpCat.{w}) (α : (F ⋙ forget _).RepresentableBy X) → GrpObj X`.
  All five group-object axioms (mul-assoc, one-mul, mul-one, left-inv,
  right-inv) are discharged inside `ofRepresentableBy` itself. The
  caller's only obligation is supplying `F` and `α`.

- **`Functor.RepresentableBy`** is at `Mathlib/CategoryTheory/Yoneda.lean:285`:
  a per-`X` Equiv `(X ⟶ Y) ≃ F.obj (op X)` plus naturality
  `homEquiv_comp`.

- **No concrete-scheme uses of `GrpObj.ofRepresentableBy` in Mathlib.**
  Grepped `Mathlib/AlgebraicGeometry/` and found zero callers. The only
  uses are the abstract round-trip lemma
  `ofRepresentableBy_yonedaGrpObjRepresentableBy` and three internal
  Mon_/CommMon_/CommGrp_ hooks. No `Mathlib.AlgebraicGeometry.Group.Gm`,
  no `GroupScheme.Gm` namespace, no instance on
  `Spec (Localization.Away _)` or `Spec (FractionRing _)`. The project
  is the FIRST in the Mathlib ecosystem to install a concrete-scheme
  `GrpObj` via `ofRepresentableBy`.

- **Mathlib's `AffineSpace.homOverEquiv`** at `AffineSpace.lean:155`
  closes the analogous `ga_grpObj` in 2-3 lines as a one-shot
  `(n → Γ(X, ⊤))` bijection. The `Gm` case lacks this one-shot
  bridge — the project must compose the 3-step chain by hand from
  `Over.homMk` / `ΓSpec.adjunction.homEquiv` / `IsLocalization.Away.lift`.

- **Recipe** (8 steps, per Decision 3 in the persistent file):
  1. Define `F : (Over (Spec (.of kbar)))ᵒᵖ ⥤ GrpCat.{u}` with
     `obj T := GrpCat.of Γ(T.unop.left, ⊤)ˣ` and `map φ := Units.map (φ.unop.left.appTop).hom.toMonoidHom`.
  2. Build the per-`T` equiv `(T ⟶ Gm kbar) ≃ Γ(T.unop.left, ⊤)ˣ` as
     a 3-step composition:
     - **2a** (over-cat unfold): `(T ⟶ Gm) ≃ {f : T.unop.left ⟶ Spec(k̄[t,t⁻¹]) // f ≫ Gm.hom = T.unop.hom}` via `Over.homMk`.
     - **2b** (Spec adjunction): `≃ (k̄[t,t⁻¹] →ₐ[k̄] Γ(T.unop.left, ⊤))` via `ΓSpec.adjunction.homEquiv` with the `IsOver` condition forcing `k̄`-linearity.
     - **2c** (Away-lift bijection): `≃ {u : Γ(T.unop.left, ⊤) // IsUnit u} = Γ(T.unop.left, ⊤)ˣ` via `IsLocalization.Away.lift` + `IsLocalization.Away.algebraMap_isUnit` + `MvPolynomial.aeval`/`aeval_unique` for well-definedness.
  3. Build `homEquiv_comp` (naturality) — `cat_disch` + `Scheme.Hom.appTop` naturality + `Units.map` functoriality.
  4. Apply `GrpObj.ofRepresentableBy (Gm kbar) F ⟨homEquiv, homEquiv_comp⟩`.

- **LOC estimate**: ~75-115 LOC for a clean closed body (20-30 functor +
  40-60 homEquiv + 15-25 naturality). Recommend splitting the
  `homEquiv` into three named helper Equivs (one per sub-step) so the
  assembly is just `.trans ∘ .trans`.

- **Reversal trigger**: if universe issues (`GrpCat.{w}` vs `.{u}`),
  `IsOver` defeq, or `IsScalarTower` synthesis stall the Yoneda path for
  ≥2 iters with the same root cause, fall back to the **direct
  `GrpObj.mk`** path — hand-define `μ`, `η`, `ι` as `Spec.map` of explicit
  ring maps (`t ↦ t ⊗ t`, `t ↦ 1`, `t ↦ t⁻¹`), prove the 5 axioms by
  `Spec.map_comp` + `CommRingCat.hom_ext` + ring-level computation. More
  wiring (~150-200 LOC) but no over-category Yoneda. Same iter-170
  `Algebra.compHom` fix may apply to step 2c if `IsScalarTower` fails.

## Persistent file
- `analogies/gm-grpobj-representable.md` — design-rationale + 8-step
  recipe + LOC estimate + fallback trigger captured for iter-180+ prover
  lane.

Overall verdict: the project's planned `GrpObj.ofRepresentableBy` path
IS the Mathlib idiom — proceed with the 3-step homEquiv chain and the
8-step recipe above; ~75-115 LOC for a kernel-clean closed body.
