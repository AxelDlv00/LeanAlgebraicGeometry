# Mathlib Analogist Directive

## Slug
cotangent-vanishing-pile-over-k-iter127

## Iter
127

## Question

Can the shared cotangent-vanishing pile (pieces (i)+(ii)+(iii), per iter-126 analogist `analogies/cotangent-vanishing-pile.md`) be built **directly over an arbitrary base field `k`** (no algebraic closure assumed), eliminating the Galois-descent step M2.c (300–500 LOC / 4–8 iter)? Iter-125 strategy-critic's "direct over-k rigidity" alternative (now in STRATEGY.md § Alternative "direct over-k rigidity (drops M2.c)") claims: the cotangent-triviality argument is local; `Ω_{A/k}` has a global frame from left-invariant forms over any base field, not just `k̄`. For the C(k) ≠ ∅ branch, the C.2.d argument allegedly runs verbatim over k.

Per-piece sub-questions:

1. **Piece (i) over k vs over k̄.** Does the construction `Lie-algebra-of-GrpObj → mulRight-globalisation → relative-cotangent-presheaf trivialisation` work over any base field k, or does some step force algebraic closure? Specifically: (a) does the Lie algebra at the identity have rank `dim G` over k without alg-closure (Mathlib `Stacks 0BFD` machinery used in `AlgebraicGeometry/Group/{Abelian,Smooth}.lean` — does it bake in alg-closed via `smooth_of_grpObj_of_isAlgClosed`, or does it generalize)? (b) Does the mulRight globalisation require k̄-rational points to translate the cotangent at the identity to a frame on the whole group?

2. **Piece (ii) over k vs over k̄.** The Mathlib idiom `Differential.ContainConstants` (`Mathlib.RingTheory.Derivation.DifferentialRing:62–70`) is a typeclass over arbitrary commutative rings/algebras — does it admit a char-0 instance for an arbitrary k-algebra without requiring k alg-closed, or does Liouville-style usage in `Mathlib.FieldTheory.Differential.Liouville` lean on alg-closure?

3. **Piece (iii) Frobenius iteration over k vs over k̄.** `Mathlib.Algebra.CharP.Frobenius` defines `frobenius R p` / `iterateFrobenius R p n` for any commutative ring `R` of `CharP R p`. Does the iteration argument work over an arbitrary characteristic-p field k, or does the descent step require perfectness / alg-closure to be effective? In particular: does Mathlib have `Mathlib.FieldTheory.Perfect` machinery that bridges to non-perfect base fields?

4. **Meta: is M2.c truly avoidable under the over-k route?** If pieces (i)+(ii)+(iii) over k work, M2.c (Galois descent of morphism equality) is unnecessary — the project would have `rigidity_over_k` directly. But the iter-126 progress-critic noted the "C.2.f Galois descent" appears in `Jacobian.tex` C.2; verify whether that consumer is genuinely eliminated by an over-k variant or whether some other downstream consumer still needs Galois descent.

## Project artifacts

- `analogies/cotangent-vanishing-pile.md` (iter-126 over-`k̄` analogist) — the persistent file you are extending. Read it in full before writing yours; the over-k variant should produce a SEPARATE persistent file `analogies/cotangent-vanishing-pile-over-k.md`, NOT overwrite this one. Cross-reference the iter-126 over-`k̄` decisions inline where they bear on yours.
- `blueprint/src/chapters/RigidityKbar.tex:57–77` — § "The shared cotangent-vanishing Mathlib pile" — current over-`k̄` framing.
- `blueprint/src/chapters/Jacobian.tex` § C.2 (specifically C.2.f Galois descent of morphism equality, C.2.g cross-ref to the shared pile) — verify the over-k variant eliminates the C.2.f use site.
- `AlgebraicJacobian/Rigidity.lean:91` — `Scheme.Over.ext_of_eqOnOpen` (post iter-125 refactor). Does this lemma require alg-closed source, or does it apply over k? (Per `Rigidity.tex`: ambient base is `Spec (.of k)`, no alg-closure hypothesis.)
- `AlgebraicJacobian/RigidityKbar.lean:75–87` — `rigidity_over_kbar` named declaration (Option B encoding, `[Field kbar]` only). The hypothesis is just `[Field kbar]`, not `[IsAlgClosed kbar]` — does this mean the iter-126 scaffold ALREADY implicitly supports the over-k variant, modulo body closure?

## Mathlib snapshot

`b80f227` (Mathlib snapshot pinned in the project's `lake-manifest.json` / `lakefile.toml`).

## Decision wanted

Per piece (i)+(ii)+(iii): **OK_OVER_K** (the iter-126 over-`k̄` build directive carries over verbatim, only the hypothesis pattern changes), **REQUIRES_MODIFICATION** (specific Mathlib idiom or proof step forces alg-closure/perfectness), or **BLOCKED_OVER_K** (the over-k variant introduces a strict superset of the over-`k̄` cost; the over-`k̄` + Galois descent is cheaper).

If **OK_OVER_K** on all three pieces: write the persistent file recommending the **over-k variant** with revised build directive; the project will (i) drop M2.c entirely (300–500 LOC / 4–8 iter savings); (ii) re-name the iter-126 scaffold `rigidity_over_kbar` → `rigidity` (or keep `_over_kbar` as a legacy name); (iii) update STRATEGY.md and `RigidityKbar.tex` accordingly.

If **REQUIRES_MODIFICATION** on any piece: write the persistent file naming the specific modifications + LOC delta vs the over-`k̄` variant. The savings may shrink from 300–500 LOC to (say) 100–200 LOC depending on the modification cost.

If **BLOCKED_OVER_K** on any piece: write the persistent file naming the specific blocker. The project will reject the alternative and proceed with the over-`k̄` + M2.c path.

## Output

Per the descriptor:

- **Persistent file** `analogies/cotangent-vanishing-pile-over-k.md` with the decision and full reasoning.
- **Report** at `task_results/mathlib-analogist-cotangent-vanishing-pile-over-k-iter127.md` per the standard format.
- Tag named Mathlib targets `[verified]` / `[expected]` / `[gap]`.

## Severity

high-stakes — the verdict directly determines whether the project's iter-129+ build target is "over-`k̄` then descend" or "over-k directly", with a 4–8 iter / 300–500 LOC delta and a re-naming of the M2.a critical-path declaration. Get it right.

## Out of scope

- Do NOT re-scope pieces (i)+(ii)+(iii)'s over-`k̄` variant — that's settled by the iter-126 analogist `cotangent-vanishing-pile.md`. You are scoping the over-k delta vs the over-`k̄` baseline.
- Do NOT re-litigate piece (iv) Serre duality — that's deferred regardless of variant per the iter-126 verdict.
- Do NOT scope M3 — that's a different milestone.
