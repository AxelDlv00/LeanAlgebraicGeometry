# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ocofp-sheaf-internalhom

## Iteration
182

## Question

`RiemannRoch/OCofP.lean` has two load-bearing `noncomputable def := sorry`
declarations:
- `lineBundleAtClosedPoint` (L140): returns `Sheaf (Opens.grothendieckTopology
  C.left.toTopCat) (ModuleCat.{u} kbar)`.
- `lineBundleAtClosedPoint.toFunctionField` (L154): returns
  `C.left.functionField` from a section of `Scheme.HModule kbar
  (lineBundleAtClosedPoint P hP) 0`.

Until both bodies land, `globalSections_iff` (the iter-181 refactored iff
`∃ s, toFunctionField P hP s = f`) is mathematically vacuous (iter-181
lean-auditor MAJOR finding). What is the Mathlib idiom, what gaps exist,
and should the project (a) build inline, (b) open `IdealSheafDual.lean`
bottom-up, or (c) `NEEDS_MATHLIB_GAP_FILL`?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1 — Sheaf-internal-Hom for `Sheaf J (ModuleCat R)` | NEEDS_MATHLIB_GAP_FILL | informational |
| 2 — Ideal-sheaf-of-a-closed-point (data layer) | PROCEED | informational |
| 2 — Ideal-sheaf-of-a-closed-point (sheaf layer) | NEEDS_MATHLIB_GAP_FILL | informational |
| 3 — Hartshorne subsheaf-of-`K_C` direct construction | ALIGN_WITH_MATHLIB | critical |
| 4 — In-project `IdealSheafDual.lean` bottom-up file | DIVERGE_INTENTIONALLY | informational |

## Must-fix-this-iter

- **`lineBundleAtClosedPoint` / `toFunctionField` route**: the iter-180 Lane D
  task_result identified the "Sheaf-internal-Hom + ModuleCat-forget Mathlib
  gap" as the blocker; iter-181 PARTIAL landed two directional helpers but
  the underlying `sorry`s remain. The mathlib-analogist analysis confirms
  that Mathlib has **no usable internal-Hom for `Sheaf J (ModuleCat R)`**
  AND **no `IdealSheafData → SheafOfModules` realiser** AND **no
  `SheafOfModules → Sheaf J (ModuleCat kbar)` forget bridge**. All three
  are required for the abstract "Hom_{O_C}(I_P, O_C)" path; none ship at
  the pinned commit.

  → **Refactor**: ship `lineBundleAtClosedPoint` and `toFunctionField`
  inline in `OCofP.lean` via Hartshorne's **subsheaf-of-`K_C`** alternative
  description (Decision 3 above; recipe in `analogies/ocofp-sheaf-internalhom.md`).
  ETA ~195-335 LOC total. The construction template is already in-project
  at `AlgebraicJacobian/Cohomology/StructureSheafModuleK/{Presheaf,SheafProperty}.lean`
  (where `toModuleKSheaf` builds `O_C` as a `Sheaf J (ModuleCat kbar)`
  bottom-up). The signature of `lineBundleAtClosedPoint` needs **one
  amendment**: add `(hPcoh : Order.coheight P = 1)` (the helpers already
  take it). Signature is **non-protected** (grep verified — no entry in
  `archon-protected.yaml`).

  This is the iter-182 single closable lane on this file, modulo the
  in-project bridge "stalk locality of `Scheme.RationalMap.order Q f`"
  (likely already inside `RR.1`'s `WeilDivisor.lean`).

## Informational

- **Decision 1 (Sheaf-internal-Hom)**: Mathlib has *only*
  `CategoryTheory.sheafHom : Sheaf J A → Sheaf J A → Sheaf J (Type _)`
  (`Mathlib.CategoryTheory.Sites.SheafHom`) — codomain is **Type**, not
  `ModuleCat R`. `SheafOfModules.Hom` is the external (bare-Type) Hom,
  not a sheaf. `X.Modules` (`Mathlib.AlgebraicGeometry.Modules.Sheaf`)
  defines pushforward/pullback/restriction but **no internal-Hom or dual
  functor**. Genuine upstream gap; not the project's fault.

- **Decision 2 (Ideal sheaf of a closed point)**:
  `AlgebraicGeometry.Scheme.IdealSheafData.vanishingIdeal :
  Closeds X → IdealSheafData` exists. But Mathlib's own docstring
  (`Mathlib.AlgebraicGeometry.IdealSheaf.Basic` L38): "Ideal sheaves are
  not yet defined in this file as actual subsheaves of `O_X`. … This
  should be refactored as a constructor for ideal sheaves once they are
  introduced into Mathlib." → **`IdealSheafData` is data, NOT a sheaf
  object**. The OCofP docstring at L131-L134 mentions
  `IdealSheafData.idealOfPoint` — that exact name does **not** exist;
  the correct construction is `vanishingIdeal ⟨{P}, hP⟩`.

- **Decision 3 (Subsheaf-of-`K_C` direct construction)**: Hartshorne II.6
  p. 144's primary description (NOT the equivalent II.6 "Hom_{O_C}(I_P,
  O_C)" description, which is the Lean blueprint's secondary description
  at chapter L149-L167). Sections over `U` are rational functions in
  `K(C)` satisfying order conditions at prime divisors in `U`. The project's
  existing `toModuleKSheaf` template (defining `O_C` as a sheaf in the
  ModuleCat kbar codomain) shows the mechanical recipe — same architecture,
  with the underlying carrier being a `Submodule kbar C.left.functionField`
  instead of `C.left.presheaf.obj U`. No abstract `SheafOfModules`
  machinery required; the result is directly a `Sheaf J (ModuleCat kbar)`,
  matching the project's `HModule` pipeline. `toFunctionField` becomes
  the canonical inclusion `subsheaf carrier ↪ K(C)` (4-step chain via
  `HModule_zero_linearEquiv` + nat-trans at `⊤` + `Subtype.val`).

- **Decision 4 (IdealSheafDual.lean)**: building general `IdealSheafData →
  SheafOfModules → Hom_{O_C}(I_P, O_C)` infrastructure in a new project
  file would cost hundreds of LOC of *general* sheaf-of-modules
  scaffolding (Mathlib-equivalent work) — high cost, low payoff when the
  one sheaf the project needs lands directly via Decision 3 in <300 LOC.
  iter-180 Lane D's "open IdealSheafDual.lean bottom-up" suggestion is
  technically viable but strategically dominated.

## Persistent file
- `analogies/ocofp-sheaf-internalhom.md` — design-rationale + concrete LOC
  recipe + Lean signature sketches captured for future iters.

Overall verdict: the iter-180 Lane D Mathlib-gap diagnosis is confirmed
(no Sheaf-internal-Hom, no IdealSheaf→SheafOfModules, no SheafOfModules→
Sheaf-ModuleCat-kbar forget); the project should commit to the **direct
Hartshorne subsheaf-of-`K_C` construction** (Decision 3) inline in
`OCofP.lean`, mirroring the existing `toModuleKSheaf` template, instead of
opening `IdealSheafDual.lean` or waiting on Mathlib upstream.
