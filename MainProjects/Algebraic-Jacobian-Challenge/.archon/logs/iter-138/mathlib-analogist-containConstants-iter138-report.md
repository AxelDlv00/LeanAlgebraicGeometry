# Mathlib Analogist Report

## Slug
containConstants-iter138

## Iteration
138

## Question

For the scheme-level argument "`df = 0` for `d : Γ(C, V) → Ω_{Γ(C, V) / Γ(Spec k, U)}` implies `f` factors through `Spec k`" (piece (ii) of the M2.body-pile, to be Lean-named `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero`), which Mathlib idiom should the project align to: (a) `Differential.ContainConstants` typeclass install on chart algebras, or (b) direct `KaehlerDifferential` exactness route?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (1) Path (a) `Differential.ContainConstants` typeclass install on chart algebras | DIVERGE_INTENTIONALLY (rejected — wrong-shape, pure overhead) | high-stakes |
| (2) Path (b) direct `KaehlerDifferential` exactness route | ALIGN_WITH_MATHLIB (the universal `KaehlerDifferential.D` idiom is the right shape) | high-stakes |
| (3) Scaffold shape: `ext_of_*` paired morphisms with explicit `[CharZero k]` gate | PROCEED | informational |

## Must-fix-this-iter

**N/A** — piece (ii) `ext_of_diff_zero` is a PHANTOM (not yet scaffolded; scheduled iter-141+). The verdict pins the alignment path BEFORE divergent shipped code exists, which is the cheap window.

However, **one blueprint update obligation lands this iter (or iter-139 at the latest), before any iter-141+ scaffolding starts**:

- `blueprint/src/chapters/RigidityKbar.tex:68` piece (ii) prose currently reads "the ring-level half aligns with Mathlib's `Differential.ContainConstants` typeclass". This framing is **loose and now rejected by this verdict**. Replace with: "the ring-level half builds a new universal-Kähler kernel lemma `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` for `IsStandardSmoothOfRelativeDimension 1 R B` in `IsAddTorsionFree R` (char 0), a clean Mathlib-PR candidate companion to `Polynomial.eq_C_of_derivative_eq_zero`. The scheme-level lift combines this with `Scheme.Over.ext_of_eqOnOpen` (iter-125) via affine-chart reduction." This is a blueprint-writer obligation, not a refactor or prover obligation.

## Major

**(Path-pinning, ahead of iter-141+ scaffolding)**

- **Decision 2 — ALIGN with universal `KaehlerDifferential.D`**: the project should build piece (ii) as a direct `KaehlerDifferential` argument. The algebra-level core lemma is a new declaration `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (or similar name) with signature roughly:
  ```lean
  theorem KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero
      {R B : Type*} [CommRing R] [CommRing B] [Algebra R B]
      [IsAddTorsionFree R] [IsDomain B]
      [Algebra.IsStandardSmoothOfRelativeDimension 1 R B]
      -- + image(R) integrally closed in B (constants-of-curve = k)
      {b : B} (h : KaehlerDifferential.D R B b = 0) :
      b ∈ (algebraMap R B).range
  ```
  This is a clean Mathlib-PR candidate (a natural extension of `Polynomial.eq_C_of_derivative_eq_zero` to standard-smooth-of-rel-dim-1 algebras).

  **LOC envelope**: ~200-350 LOC for the algebra-level core + ~50-100 LOC for the integrally-closed-constants helper + ~100-150 LOC for the scheme-level lift = **~300-600 LOC total**.

  **Mathlib lemmas consumed**: `KaehlerDifferential.exact_mapBaseChange_map`, `KaehlerDifferential.map_surjective`, `KaehlerDifferential.map_D`, `KaehlerDifferential.polynomialEquiv` + `polynomialEquiv_D`, `Polynomial.eq_C_of_derivative_eq_zero`, `Algebra.IsStandardSmooth.free_kaehlerDifferential`, `AlgebraicGeometry.IsSmoothOfRelativeDimension.mk`/`_iff`. Project: `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` (iter-125, in-tree) + the chart-localisation identification for `relativeDifferentialsPresheaf` (piece (i.c.1), iter-137+).

- **Decision 3 — Scaffold shape recommendation for iter-141+** (full template inside `analogies/differential-containConstants-alignment.md` Decision (3)):
  - Lean signature `Scheme.Over.ext_of_diff_zero` follows the `ext_of_*` paired-morphism pattern (matches iter-125's `ext_of_eqOnOpen`), not the "factors_through_terminal" single-morphism pattern. The paired form composes more naturally with the consuming `rigidity_over_k` proof.
  - Instance binders: `[CharZero k]` (gate explicit; char-p handled by piece (iii) composition), `[GeometricallyIrreducible X.hom]` (gives constants-of-X = k AND irreducibility), `[IsReduced X.left]`, `[SmoothOfRelativeDimension 1 X.hom]` (gives `IsStandardSmoothOfRelativeDimension 1` on charts), `[IsSeparated Y.hom]`. Omit `[IsProper X.hom]` from this lemma — consumer-added.
  - Body closure pattern: `(algebra-level core lemma) → (chart-affine reduction) → (Scheme.Over.ext_of_eqOnOpen)`.

## Informational

- **Decision 1 — Path (a) rejected (DIVERGE_INTENTIONALLY)**: Mathlib's `Differential R` typeclass is shaped for differential **field** extensions in the Liouville tradition (`Mathlib.FieldTheory.Differential.{Basic,Liouville}`). The only existing instances are for `AdjoinRoot p` / finite field extensions, requiring `[CharZero F]` and primitive-element selection. There is **no `Differential` instance for any non-field commutative algebra** in Mathlib `b80f227` (verified: no `Differential (Polynomial R)`, no `Differential (MvPolynomial σ R)`, no `Differential` for any scheme-style chart algebra). Installing `Differential B` on a chart algebra of an abstract smooth proper geom-irr curve requires choosing a cotangent generator (non-canonical, `Classical.choose`-chained), yields a STRICTLY WEAKER fact than the universal-Kähler kernel-of-d statement (any single derivation factors through the universal one), and adds API friction without LOC savings. Path (a) LOC envelope (~430-700 LOC) is **larger than path (b)'s** because of the splitting-construction overhead, AND would produce a non-canonical instance polluting downstream signatures.

- **Char-p handling separation**: piece (ii) as scaffolded under path (b) has explicit `[CharZero k]`. The char-p extension is via a SEPARATE composition with piece (iii) `iterateFrobenius` arranging `d(f^{p^n}) = 0` "by construction" then invoking char-0 piece (ii). The two are not unified into a single typeclass-keyed lemma — separation keeps the LOC envelope honest and matches the iter-127 over-k analogist's char-agnostic-with-char-p-via-piece-(iii) framing.

- **Naming consistency**: the recommended lemma name `Scheme.Over.ext_of_diff_zero` follows the iter-125-refactored `Scheme.Over.ext_of_eqOnOpen` pattern (which itself mirrors Mathlib's `ext_of_isDominant_of_isSeparated'` pattern at `Mathlib/AlgebraicGeometry/Morphisms/Separated.lean:319-322`). No naming change needed from the STRATEGY.md current name.

- **Composition with project infrastructure**: path (b) integrates cleanly with the project's existing `KaehlerDifferential.exact_mapBaseChange_map` consumer (`AlgebraicJacobian/Differentials.lean:86-109` for `kaehler_quotient_localization_iso`), `relativeDifferentialsPresheaf_obj_kaehler` definitional unfolding (`Differentials.lean:60-66`), and `Scheme.Over.ext_of_eqOnOpen` (iter-125 in-tree). Path (a) would require building a parallel infrastructure that does not compose with these.

- **Mathlib-PR-able sub-artefact**: the algebra-level core lemma `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (or similar name) is a clean Mathlib-PR candidate. It extends the existing polynomial-ring base case `Polynomial.eq_C_of_derivative_eq_zero` to standard-smooth-of-rel-dim-1 algebras. This is structurally analogous to the M1.d `kaehler_quotient_localization_iso` off-loop PR-extraction precedent — once the in-tree build lands substantively, an off-loop PR-extraction lane can mirror it as upstream-shaped Mathlib content. Decision of "open the PR lane" is **deferred to iter-145+ post-build**.

## Persistent file

- `analogies/differential-containConstants-alignment.md` — design-rationale captured for iter-141+ scaffolding and future analogist re-reads. Includes full per-decision analysis, recommended Lean signature template, and rejected-path documentation.

Overall verdict: **pin path (b) — direct `KaehlerDifferential` route — for piece (ii) `ext_of_diff_zero`**; reject path (a) `Differential.ContainConstants` typeclass install as wrong-shape for the project's abstract chart algebras; revise blueprint piece (ii) prose to drop the loose "aligns with `ContainConstants`" framing before iter-141+ scaffolding starts.
