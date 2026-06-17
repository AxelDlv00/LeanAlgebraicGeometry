# Mathlib Analogist Report

## Slug
cotangent-vanishing-pile-over-k-iter127

## Iteration
127

## Question

Can the shared cotangent-vanishing pile (pieces (i)+(ii)+(iii), per
iter-126 analogist `analogies/cotangent-vanishing-pile.md`) be built
**directly over an arbitrary base field `k`** (no algebraic closure
assumed), eliminating the Galois-descent step M2.c (300–500 LOC / 4–8
iter)? Per-piece sub-questions on (i) cotangent triviality, (ii)
`df = 0 ⇒ factors through Spec k`, (iii) Frobenius iteration, plus a
meta-question on whether M2.c is genuinely avoidable.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (i) cotangent triviality of GrpObj over k | OK_OVER_K | informational (proceed) |
| (ii) `df = 0 ⇒ factors through Spec k` over k | OK_OVER_K | informational (proceed) |
| (iii) Frobenius iteration over arbitrary char-p k | OK_OVER_K | informational (proceed) |
| Meta: M2.c avoidability under over-k route | AVOIDED (M2.c+M2.c.aux drop) | **major (strategic refactor)** |

## Must-fix-this-iter

None. All three pieces are still in the proposal stage (iter-126
scaffold has only a `sorry` body); the project has not shipped any
over-`k̄`-specific build artifacts that need refactoring. The
strategic decision to adopt over-k is a planning action, not a
code-refactor.

## Major

**Adopt the over-k path; drop M2.c and M2.c.aux from iter-129+
sequencing.** The iter-126 scaffold's signature
(`AlgebraicJacobian/RigidityKbar.lean:75–87`) is already k-agnostic
(`[Field kbar]`, no `[IsAlgClosed kbar]`) — only the variable name
and body closure need to change.

Concrete refactor items the planner should action in iter-127+:

1. **Rename iter-126 scaffold**: `rigidity_over_kbar` →
   `rigidity_over_k` (or just `rigidity`). Rename `kbar` → `k`
   throughout `AlgebraicJacobian/RigidityKbar.lean` and
   `blueprint/src/chapters/RigidityKbar.tex` (filename likely
   should follow if the renaming sticks). Lean signature is
   otherwise unchanged.
2. **Update `RigidityKbar.tex` § "The shared cotangent-vanishing
   Mathlib pile"** to the over-k framing. Pieces (i)+(ii)+(iii)
   build directly over k; piece (iv) Serre duality remains DEFERRED
   per `analogies/serre-duality.md`.
3. **Update `Jacobian.tex` § C.2** to drop the C.2.f Galois-descent
   sub-step. The over-k rigidity is invoked directly in the C(k) ≠ ∅
   branch (with `p : 1 → C` as the k-rational marked point).
4. **Update `STRATEGY.md` § M2**:
   - Drop M2.c (300–500 LOC, 4–8 iter) and M2.c.aux (200–400 LOC,
     3–5 iter) entirely.
   - Revise the alternative section ("direct over-k rigidity") to
     the **committed** path.
   - Revise M2 closure estimate downward by 7–13 iter: from
     iter-150–170+ to iter-143–157.
5. **Preserve [[cotangent-vanishing-pile]] iter-126 naming
   recommendations**: `GrpObj.omega_free`, `GrpObj.omega_rank_eq_dim`,
   `Scheme.Over.ext_of_diff_zero`, `Scheme.absoluteFrobenius`. These
   names are k-agnostic and require no over-k vs over-`k̄`
   disambiguation.

## Informational

**Three OK_OVER_K verdicts**, with reasoning documented in
`analogies/cotangent-vanishing-pile-over-k.md`:

- **Piece (i)**: cotangent triviality of `Ω_{A/k}` is intrinsic; the
  shear iso `A ⊗ A → A ⊗ A`, `(a, b) ↦ (a, a·b)` is a scheme map
  over any base, no k̄-rational points needed. The mulRight-globalisation
  step must be formulated functorially (via the shear iso), not via
  pointwise translation. Cost unchanged at 800–1500 LOC. [verified]
- **Piece (ii)**: `Differential.ContainConstants` is k-agnostic in
  Mathlib (`Mathlib/RingTheory/Derivation/DifferentialRing.lean:62–66`);
  the project's `Scheme.Over.ext_of_eqOnOpen` (iter-125 refactor) is
  already over `[Field k]`. Cost unchanged at 250–500 LOC. [verified]
- **Piece (iii)**: Mathlib's `frobenius R p` /
  `iterateFrobenius R p n` (`Mathlib/Algebra/CharP/Frobenius.lean`)
  works over any char-p ring, no `[PerfectField]` required. The
  Frobenius iteration descent uses **absolute** Frobenius `F_X`
  (intrinsic to X, independent of base), not relative Frobenius
  `F_{Y/k}` (which over non-perfect k would require perfectness).
  Cost unchanged at 300–600 LOC. [verified]

**Meta-tangential observation** (not required for the verdict but
informative for the iter-126 over-`k̄` cost estimate): even if the
project kept the over-`k̄` baseline, Mathlib's
`isCommMonObj_of_isProper_of_geometricallyIntegral`
(`Mathlib/AlgebraicGeometry/Group/Abelian.lean:128–145`) uses
`(Over.pullback f).map_injective` for its descent step in roughly one
line, suggesting M2.c could be much cheaper than the iter-124 spot-check
estimate of 300–500 LOC. But this is moot under the over-k verdict.

**Defer / preserve**: piece (iv) Serre duality remains DEFERRED as a
named gap per `analogies/serre-duality.md` (iter-110, 3000–8000 LOC
honest closure). The over-k route does NOT change the (iv) verdict.

## Persistent file

- `analogies/cotangent-vanishing-pile-over-k.md` — over-k design
  rationale captured for future iters, with the per-piece verdicts,
  the M2.c-avoidability argument, the refactor action list, and a
  risk register (functorial-shear-iso formulation for piece (i);
  absolute-Frobenius formulation for piece (iii); revert option to
  the over-`k̄` baseline if the over-k path runs into a Mathlib gap
  during iter-129+ build).

**Overall verdict**: **Adopt the over-k variant**; all three pieces
of the shared cotangent-vanishing pile build directly over any base
field `k` with no LOC delta vs the over-`k̄` baseline, and M2.c +
M2.c.aux are eliminated for a net savings of 500–900 LOC / 7–13 iter.
