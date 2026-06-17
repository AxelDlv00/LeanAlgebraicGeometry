# Mathlib Analogist Report

## Mode
api-alignment

## Slug
quot-graded-quotient

## Iteration
016

## Question
(1) Tame encoding: a Mathlib-idiomatic `DirectSum.Decomposition`/`GradedRing` on a
quotient/subtype carrier that avoids the `coeLinearMap`/`coeAddMonoidHom` whnf runaway.
(2) Hilbert-function-level restatement: is there a SOUND induction stated purely about
degreewise dimension functions that feeds the IH for `C = M/xM`, `K = ker x` WITHOUT a
quotient-module `Decomposition` — and what is the MINIMAL structure on `C` that must
actually be built? (3) Which route collapses the most of G2–G5, and what is the residual
build list?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1 — tame derived-carrier `Decomposition` via `ofLinearMap` | NEEDS_MATHLIB_GAP_FILL (buildable; FALLBACK) | informational |
| Q2 — Hilbert-function pivot, ambient **subquotient** form | PROCEED | critical (this is the route) |
| Q2′ — conclusion-only Hilbert restatement (prover's framing) | DOES NOT WORK | — |
| Q3 — G2 (quotient-module Decomposition) | ELIMINATED under Route 2 | — |
| Q3 — G3 (graded quotient ring `R⧸(x)`) | ELIMINATED under Route 2 | — |
| Q3 — G4 (regrade over `R/(x)`) | ELIMINATED under Route 2 | — |
| Q3 — G5 (`Module.Finite` transfer) | REDUCED to ambient FG bookkeeping | informational |

## Answers

### Q1 — Tame encoding exists, but only tames one carrier at a time
`DirectSum.IsInternal A` is *definitionally* `Function.Bijective (DirectSum.coeAddMonoidHom A)`
(verified by hover/loogle, `Mathlib.Algebra.DirectSum.Basic`). Every path the iter-015
prover used — `DirectSum.Decomposition.isInternal`,
`isInternal_submodule_of_iSupIndep_of_iSup_eq_top` — unfolds through this `Bijective`
predicate, forcing `whnf` of `coeAddMonoidHom` over the derived carrier → the runaway.

The Mathlib-idiomatic escape is **`DirectSum.Decomposition.ofLinearMap`**
(`Mathlib.Algebra.DirectSum.Decomposition`):
`ofLinearMap (ℳ) (decompose : M →ₗ ⨁ ↥(ℳ i)) (h_left : coeLinearMap ℳ ∘ₗ decompose = id) (h_right : decompose ∘ₗ coeLinearMap ℳ = id)`.
It constructs the instance without ever unfolding to `Bijective`, so the trigger never
fires; the two identities are dischargeable per-component with `DirectSum.coeLinearMap_of`
+ `DirectSum.linearMap_ext` (controlled `ext`, not blind `isDefEq`). Precedent for the
equiv-based handle: `DirectSum.decomposeLinearEquiv` and `Mathlib.Algebra.Lie.Graded`.

Caveats that make this a FALLBACK, not the primary route: (a) you still build the quotient
`decompose` map and its identities, and if that proof touches `Submodule.map_iSup` on the
quotient family the runaway returns; (b) it does nothing for the graded quotient RING (G3)
— Mathlib has no graded `R ⧸ I` at all (`RingTheory/GradedAlgebra` carries zero `⧸`;
`GradedRing`+`HasQuotient` loogle empty this iter); (c) applying a module-object IH to `K`
still needs a SUBTYPE `Decomposition` on `↥K`, so route-1-only forces an `ofLinearMap`
build for BOTH `K` and `C` plus the missing quotient ring — three separate elaborator
fights. Hence Q1 is buildable but is the wrong primary route.

### Q2 — The pivot is sound only when restated over ambient SUBQUOTIENTS
The prover's framing (quantify the *conclusion* over `n ↦ dim_κ Mₙ`, keep the IH over
graded-module objects) **does not escape the blocker**: applying the IH to `K` instantiates
the IH carrier to `↥K`, and to `C` instantiates it to `M ⧸ xM` — both the blocked
subtype/quotient `Decomposition`. The iter-014 Q3 obstruction ("the recursion payload IS
the graded structure") survives a conclusion-only restatement. The IH *hypothesis* must
also be derived-carrier-free.

The sound restatement ranges the induction over **subquotients of a single fixed ambient
graded module**. Fix `ℳ : ℕ → Submodule κ M`, `[DirectSum.Decomposition ℳ]` (ambient —
the only kind G1 proved safe). Quantify over a pair of homogeneous submodules `N' ≤ N ⊆ M`
and `r` commuting degree-+1 endomorphisms preserving `N`, `N'`; conclude `IsRatHilb` of the
**ambient** dimension-difference `h(n) = dim_κ(N ⊓ ℳ n) − dim_κ(N' ⊓ ℳ n)`. This class is
closed under both SES operations, with both results killed by `x = t_{last}` and written as
ambient pairs of homogeneous submodules of `M`:
- `K = ker x` ↦ `(N ⊓ x⁻¹(N'), N')`;
- `C = coker x = N/(N' + xN)` ↦ `(N, N' + xN)`.

**Minimal structure that must actually be built for `C`: none on a quotient carrier.** `C`
is the ambient pair `(⊤, x·M)` plus the function `n ↦ dim_κ(ℳ n) − dim_κ(x·M ⊓ ℳ n)`, with
`x·M ⊓ ℳ n = x·(ℳ (n-1))` an ambient identity (x homogeneous degree 1 + G1). No
`DirectSum.Decomposition (M⧸xM)`, no `Decomposition ↥K`, no `GradedRing (R⧸(x))` is ever
formed. (Subquotients, not submodules, are required: `coker x = N/xN` is killed by `x` and
so lies in the (r−1)-endo IH domain, but `xN` is not killed by `x`, so the
"`h_C = h_N − h_{xN}`" submodule shortcut is unavailable.)

### Q3 — Route 2 collapses the most
Route 2 (ambient subquotient induction) makes the runaway *structurally impossible* — every
object is an ambient family `fun n => Naux ⊓ ℳ n`, the exact shape G1 proved safe. It
ELIMINATES G2, G3, G4 and REDUCES G5 to ambient FG bookkeeping. Route 1 only tames one
derived carrier at a time and still leaves G3 and the `↥K` subtype `Decomposition`. So
adopt Route 2; keep Route 1's `ofLinearMap` as a documented fallback.

**Residual build list (Route 2), ordered:**
1. `SubquotientHilb` data + ambient Hilbert function `n ↦ (finrank κ ↥(N⊓ℳn) : ℤ) − finrank κ ↥(N'⊓ℳn)` (reuses G1).
2. Ambient `ker`/`coker` closure lemmas: the two subquotient pairs, their homogeneity
   (G1 + `SetLike.IsHomogeneousElem.graded_smul`), endo-preservation, annihilation by `x`.
3. Degreewise difference D6 (small): identify component dims with `ker(x:ℳn→ℳ(n+1))`,
   `ℳ(n+1)/im x`, then apply the landed **D5** (`degreewise_finrank_diff`).
4. Finiteness transfer (residual G5, ambient, low effort): `Submodule.FG` + Noetherian +
   annihilation by `x` (`Submodule.FG.restrictScalars_of_surjective`, `Module.Finite.quotient`).
5. Induction `P(r)`: base via `IsRatHilb.ofEventuallyZero`; step via (2)+(3)+(4) into the
   landed `IsRatHilb.ofDiffEq` + `IsRatHilb.bump`.
6. Thin bridge to `AlgebraicGeometry.gradedModule_hilbertSeries_rational`: instantiate at
   `(⊤,⊥)`, endos = mul-by-degree-1-generators; derive the `r` generators from "f.g.
   κ-algebra generated in degree 1" (blueprint NOTE `Picard_QuotScheme.tex` L429–435).

Reused as-is: G1, D5, the full `IsRatHilb` toolkit. Dropped: G2, G3, G4.

## Major
- **Q2 (route adoption)**: the blueprint proof of `lem:gradedHilbertSerre_rational`
  (`Picard_QuotScheme.tex` L408–491) and `subsec:gradedModuleApi` (G1–G5) are written
  around graded-module OBJECTS over `R/(x)` (`lem:graded_quotient_decomposition`,
  `lem:graded_quotientRing_gradedRing`, `lem:graded_regrade_over_quotient`). Under Route 2
  these `\uses` targets (G2/G3/G4) are not built; the proof should be re-skeletoned around
  the ambient subquotient induction. This is a plan-agent blueprint edit, not shipped Lean
  to refactor — hence Major, not Must-fix.

## Informational
- Q1 (`ofLinearMap`) is a real, idiomatic capability worth keeping in the toolbox; the
  underlying gap (no graded `R⧸I` / `M⧸p` in Mathlib) is upstream, not a project failure.
- Q2′ (conclusion-only restatement) is explicitly NOT viable — recorded so a future iter
  does not retry it.

## Persistent file
- `analogies/quot-hilbert-function-route.md` — full rationale + ordered residual build list.

Overall verdict: **PROCEED via Route 2** (ambient subquotient induction) — it is the sound
realization of the Hilbert-function pivot and structurally eliminates G2/G3/G4, leaving a
short residual build of ambient bookkeeping lemmas on top of the landed G1, D5, and
`IsRatHilb` toolkit; keep `DirectSum.Decomposition.ofLinearMap` as the fallback for any
genuine future derived-carrier graded object.
