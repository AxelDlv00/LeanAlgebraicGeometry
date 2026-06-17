# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ab-natrecursive

## Iteration
200

## Question
Iter-200 Lane AB-gap1-NatRecursive asks the prover to iterate the
iter-199 axiom-clean `RingTheory.Module.exists_minimalSurjection_finite_localRing`
into a full minimal-free-resolution carving: a
`ChainComplex ℕ (ModuleCat R)` of finite-rank free modules of length
`pd_R(M)` whose transition maps have image in `𝔪`, via `Nat`-recursion
on syzygies. Budget: ~40-80 LOC. Stacks tag 00LK + Bruns-Herzog §1.5.18.
Question: is this the right Mathlib-aligned carrier, and is the budget
realistic?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Carrier for "iterated minimal resolution" (ChainComplex vs `HasProjectiveDimensionLT`) | ALIGN_WITH_MATHLIB | critical |
| 2. Per-step syzygy carrier (LinearMap pair vs `ShortComplex.ShortExact`) | PROCEED (with one-shot bridge) | informational |
| 3. Finite-pd hypothesis carrier (`WithBot ℕ∞` vs `HasProjectiveDimensionLT`) | PROCEED | informational |
| 4. Minimality / Stacks 00LK trim lemma | NEEDS_MATHLIB_GAP_FILL (avoidable for AB) | informational |
| 5. Bruns-Herzog 1.5.18 literal carrier (`ChainComplex.mk'` build) | ALIGN_WITH_MATHLIB (pivot away) / RE-SCOPE if pursued literally | critical |

## Mathlib infrastructure ranking (top 10)

Ranked by usefulness to the Lane AB-gap1-NatRecursive close:

1. **`CategoryTheory.HasProjectiveDimensionLT`** + three SES bridges
   (`hasProjectiveDimensionLT_X₁`, `_X₂`, `_X₃`) —
   `Mathlib.CategoryTheory.Abelian.Projective.Dimension`. The natural
   inductive carrier for "pd descent on syzygies". `_X₁` is exactly the
   syzygy step: `ShortExact S` + `pd S.X₂ < n` + `pd S.X₃ < n+1` ⟹
   `pd S.X₁ < n`. **THE central lemma the lane should consume.**
2. **`CategoryTheory.projectiveDimension`** +
   `projectiveDimension_le_iff` / `projectiveDimension_lt_iff` —
   `Mathlib.CategoryTheory.Abelian.Projective.Dimension`. Translates the
   project's `Module.projectiveDimension R M : WithBot ℕ∞` hypothesis to
   `HasProjectiveDimensionLE` / `HasProjectiveDimensionLT` in one rewrite.
   (Project's `Module.projectiveDimension` is a one-line re-export at
   `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:186-188`.)
3. **`CategoryTheory.projective_iff_hasProjectiveDimensionLT_one`** +
   **`ModuleCat.projective_of_free`** + **`Module.Projective.of_free`** —
   `Mathlib.Algebra.Category.ModuleCat.Projective`,
   `Mathlib.Algebra.Module.Projective`. Discharge `pd (R^n) < 1` for the
   middle of the iter-199 SES.
4. **`CategoryTheory.ShortComplex.moduleCatMkOfKerLERange`**,
   **`ShortComplex.moduleCatMk`**, **`ShortComplex.ShortExact.mk'`** —
   `Mathlib.Algebra.Homology.ShortComplex.ModuleCat`,
   `Mathlib.Algebra.Homology.ShortComplex.ShortExact`. Package the
   iter-199 `(f : (Fin n → R) →ₗ[R] M)` + `Surjective f` as a
   `ShortComplex.ShortExact` ready for `hasProjectiveDimensionLT_X₁`.
5. **`Module.FinitePresentation.fg_ker`** +
   **`Module.finitePresentation_of_finite`** —
   `Mathlib.Algebra.Module.FinitePresentation`. Propagate
   `Module.Finite` through the syzygy: kernel of a surjection from
   finite to finite (with `IsNoetherianRing R`) is finitely generated,
   hence `Module.Finite`. **Required** for the recursive call to
   `exists_minimalSurjection_finite_localRing` on the syzygy.
6. **`ChainComplex.mk'`** — `Mathlib.Algebra.Homology.HomologicalComplex`.
   The canonical Nat-recursive ChainComplex builder. Signature:
   `(X₀ X₁ : V) (d₀ : X₁ ⟶ X₀) (succ : (f : X₁ ⟶ X₀) → (X₂ : V) ×' (d : X₂ ⟶ X₁) ×' d ≫ f = 0) → ChainComplex V ℕ`.
   Use only if the lane insists on the literal ChainComplex carrier
   (Decision 5 RE-SCOPE path).
7. **`CategoryTheory.ProjectiveResolution.mk`** +
   **`ProjectiveResolution.ofComplex`** —
   `Mathlib.CategoryTheory.Preadditive.Projective.Resolution`,
   `Mathlib.CategoryTheory.Abelian.Projective.Resolution`. The Mathlib
   constructor for projective resolutions. **Generic, NOT minimal-aware.**
8. **`CategoryTheory.Projective.syzygies`** —
   `Mathlib.CategoryTheory.Preadditive.Projective.Basic`. The categorical
   per-morphism syzygy. Generic, not local-ring-aware; useful only as
   the abstract template that `ProjectiveResolution.ofComplex` consumes.
9. **`ModuleCat.free_shortExact`** —
   `Mathlib.Algebra.Category.ModuleCat.Free`. SES freeness 2-out-of-3.
   Not directly required for AB, but useful as a sanity check on the
   ShortComplex translation.
10. **`Module.free_of_flat_of_isLocalRing`** —
    `Mathlib.RingTheory.LocalRing.Module`. Finite-flat-local ⟹ free. The
    pin for the literal Bruns-Herzog "bottom-out": the `pd_R(M)`-th
    syzygy is free over local. Combined with finite-pd ⟹ k-th syzygy is
    flat, this gives the explicit termination — but the "k-th syzygy is
    flat at k = pd" lemma itself is NOT in Mathlib.

**Notably absent from Mathlib** (NEEDS_MATHLIB_GAP_FILL): a
"minimal projective resolution" predicate or constructor;
a Stacks 00LK "trim to minimal" lemma; a "finite-pd ⟹ k-th syzygy is
free at k = pd_R(M)" termination lemma; any local-ring-specific
projective-resolution API.

## Must-fix-this-iter

- **Decision 1**: The iter-200 prover dispatch should NOT build a
  concrete `ChainComplex ℕ (ModuleCat R)`. The Mathlib idiom is
  `HasProjectiveDimensionLT` SES descent via `hasProjectiveDimensionLT_X₁`.
  Pivot the lane's carrier before the next prover round. The current
  PROGRESS.md objective "ChainComplex ℕ (ModuleCat R) of finite-rank
  free modules of length `pd_R(M)`" should be replaced with
  "`HasProjectiveDimensionLT` descent of the iter-199 SES". Without this
  pivot, the ~40-80 LOC budget is wrong by 3-4× (realistic 150-250 LOC,
  with an additional NEEDS_MATHLIB_GAP_FILL on the bottom-out at
  `pd_R(M)`).
- **Decision 5**: A literal Bruns-Herzog 1.5.18 construction via
  `ChainComplex.mk'` requires an upstream "finite-pd ⟹ k-th syzygy is
  free" lemma that is not in Mathlib. Either pivot to Decision 1's Path
  A or re-scope the iter-200 lane to land just ONE additional
  Nat-recursive STEP (syzygy module + finite carrier + minimal-surjection-
  on-syzygy) and explicitly defer the iterated assembly.

## Major

- **Decision 2**: A one-shot bridge lemma packaging the iter-199 helper
  output as `ShortComplex.ShortExact (ModuleCat R)` is needed before
  `hasProjectiveDimensionLT_X₁` can be applied. ~10-15 LOC, single
  helper, no compounding cost. This is the routing infrastructure the
  iter-199 lane prepared the ground for.

## Informational

- **Decision 3**: The project's `Module.projectiveDimension : WithBot ℕ∞`
  re-export composes cleanly with Mathlib's
  `CategoryTheory.HasProjectiveDimensionLT` / `HasProjectiveDimensionLE`
  via `projectiveDimension_le_iff` and `projectiveDimension_lt_iff`. The
  outer signature of `auslander_buchsbaum_formula` may stay in `WithBot ℕ∞`
  for downstream compat; the internal induction switches to the
  inductive Prop form.
- **Decision 4**: "Minimality" (`d_n` image in `𝔪 · F_{n-1}`) is a
  local-ring-specific property absent from Mathlib's projective-resolution
  API. The iter-199 helper has minimality at the single-step level, but
  the Stacks 00LK trim lemma does NOT exist as a Mathlib bridge. **For
  the AB inductive step, minimality is avoidable**: the `hasProjectiveDimensionLT_X₁`
  Ext-functorial descent does not care whether `d_n` images sit in `𝔪`.
  Minimality matters for downstream depth-pinning (depth-of-resolution-
  upper-bound is sharp when minimal) — but the depth bound for the
  AB-formula-on-base-case is already mediated by `depth_of_short_exact`,
  axiom-clean in this file, which is also minimality-blind.
- **Path A recipe (the recommended ~40-80 LOC budget)**:
  1. ~15 LOC bridge from iter-199 `exists_minimalSurjection_finite_localRing`
     to a `ShortComplex.ShortExact (ModuleCat R)`, including
     `Module.Finite (ker f)` via `Module.FinitePresentation.fg_ker`.
  2. ~15-25 LOC syzygy-descent helper applying
     `hasProjectiveDimensionLT_X₁` with `R^n` projective.
  3. ~20-40 LOC inductive assembly of `auslander_buchsbaum_formula_succ_pd`
     via induction on `k` of `HasProjectiveDimensionLT (ModuleCat.of R M) (k+1)`,
     using `depth_of_short_exact` (already axiom-clean) for the depth side.
- **Per-step requirement check**: the recursion needs
  `Module.Finite (ker f)` over the same `R`. Mathlib has:
  `Module.finitePresentation_of_finite` (Noetherian + finite ⟹ FP) +
  `Module.FinitePresentation.fg_ker` (FP target, finite source, surjection
  ⟹ kernel FG) + `Submodule.FG ↔ Module.Finite` for submodules of finite
  modules. The instance chain compiles axiom-clean from the project's
  existing `IsNoetherianRing R` + `Module.Finite R M` hypotheses.

## Persistent file
- `analogies/ab-natrecursive.md` — design-rationale captured for future iters.

Overall verdict: ALIGN_WITH_MATHLIB on the carrier — pivot Lane
AB-gap1-NatRecursive from a literal `ChainComplex ℕ (ModuleCat R)` build
to `CategoryTheory.HasProjectiveDimensionLT` SES descent via
`hasProjectiveDimensionLT_X₁`; the ~40-80 LOC budget is realistic for
this Path A but unrealistic (3-4× over) for the literal ChainComplex
carrier, which additionally requires a Mathlib-absent termination lemma.
