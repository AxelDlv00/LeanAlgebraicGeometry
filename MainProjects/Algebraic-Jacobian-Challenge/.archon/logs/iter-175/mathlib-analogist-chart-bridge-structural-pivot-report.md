# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
chart-bridge-structural-pivot

## Iteration
175

## Structural problem

After `fin_cases i` on `i : Fin 2` (where the indexing `I₀ ≃ Fin 2` from
the chart cover), the goal of `gmScalingP1_chart_PLB_eq` Step C contains
both `MvPolynomial.X (0 : Fin 2)` (from the literal `match`-branch
reduction inside `gmScalingP1_cover_X_iso`'s body) and
`MvPolynomial.X ⟨0, ⋯⟩` (from substituting `i := ⟨0, ⋯⟩` into the outer
chart-ring-iso / algebraMap chain). These are defeq but syntactically
distinct, so the `simp_rw [pullbackSpecIso_hom_base,
pullbackRightPullbackFstIso_hom_fst, pullbackSymmetry_hom_comp_fst, …]`
chain fails to fire — its LHS patterns won't unify across the two shapes.

The categorical shape is: per-chart-`i : Fin 2` reduction of a glued
morphism via `Scheme.Cover.hom_ext`, where the per-chart side equates
two presentations of the same canonical pullback iso obtained from a
`match`-defined chart iso.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `Lean.Meta.Tactic.Simp.BuiltinSimprocs.Fin:92,102` (`Fin.isValue` / `Fin.reduceFinMk` simprocs) | Lean meta | trivial | ANALOGUE_FOUND |
| `Mathlib.RingTheory.Complex:24` (`fin_cases <;> dsimp only [Fin.zero_eta, Fin.mk_one, …]`) | ring theory | trivial | ANALOGUE_FOUND |
| Structural pivot via `Fin.cases` | dependent types | medium | PARTIAL_ANALOGUE |
| `Mathlib.RingTheory.WittVector.IsPoly:354` (`fin_cases <;> simp only <;> rfl`) | Witt vectors | trivial | PARTIAL_ANALOGUE |

## Top suggestion

**Option (a) — syntactic bridge.** In `gmScalingP1_chart_PLB_eq` Step C
(`AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:294-321`), insert

```lean
simp only [Fin.isValue, Fin.zero_eta]   -- `case «0»`
simp only [Fin.isValue, Fin.mk_one]      -- `case «1»`
```

immediately AFTER `unfold gmScalingP1_cover_X_iso gmScalingP1_cover` and
BEFORE the existing `simp only [Iso.trans_hom, …]` chain. The simprocs
+ named Fin-mk lemmas normalize every `⟨0, ⋯⟩` / `⟨1, ⋯⟩` (and the
`(fun i ↦ i)` `fin_cases` artifact) to the OfNat form `(0 : Fin 2)` /
`(1 : Fin 2)`. After normalization the goal has uniform `X 0` (resp.
`X 1`) on both sides, and the existing simp lemmas apply syntactically.

**This is empirically verified.** I exercised the actual iter-174 goal
via `lean_multi_attempt` on lines 309-310 (`case «0»` post-Step-B):

```
simp only [Fin.isValue, Fin.zero_eta]
```

successfully transformed every `MvPolynomial.X ⟨0, ⋯⟩` and
`openCover.f ⟨0, ⋯⟩` to `X 0` / `openCover.f 0` respectively. Same
verified on `case «1»` at line 321 with `Fin.mk_one`. The remaining work
(closing the bridge-chasing chain) is independent of the Fin mismatch
and uses the existing simp-lemma list.

**Cost**: one extra `simp only` per branch, ~2 LOC. No new helpers, no
structural refactor.

**Fallback (option b)**: if option (a) hits any *new* Fin syntactic
conflict elsewhere (e.g. inside an implicit), pivot to a structural
re-write of `gmScalingP1_cover_X_iso` using `Fin.cases` over two named
defs (`_iso_zero`, `_iso_one`). Empirically `fin_cases i <;> rfl`
closes a toy version of this shape. ~30 LOC refactor.

**Option (c) — re-architect `chart_PLB_eq`**: NOT recommended. The
helper's Steps A and B are already axiom-clean; only Step C needed a
Fin-aware nudge.

### Cross-cases of `chart_agreement` ((0,1)/(1,0))

These are independent of the Fin mismatch. The substantive ring
identity `λ·u = (1/t)·λ` in `Localization.Away (X 0 · X 1) ⊗[kbar]
GmRing` is proven via:

| Step | Mathlib lemma | Purpose |
|---|---|---|
| Tensor product algebra | `Algebra.TensorProduct.tmul_mul_tmul` (`Mathlib.RingTheory.TensorProduct.Basic`) | `(a₁ ⊗ b₁) · (a₂ ⊗ b₂) = (a₁ · a₂) ⊗ (b₁ · b₂)` |
| Invariant inversion | `IsLocalization.Away.mul_invSelf` (`Mathlib.RingTheory.Localization.Away.Basic`) | `algMap R S r · IsLocalization.Away.invSelf r = 1` |
| Localization equality | `Localization.mk_eq_mk_iff'` (`Mathlib.GroupTheory.MonoidLocalization.Basic`) or `IsLocalization.mk'_eq_iff_eq_mul` (`Mathlib.RingTheory.Localization.Defs`) | Reduces a `Localization.mk` equality to a polynomial identity |
| MvPolynomial generator action | `MvPolynomial.eval₂Hom_X'` (`Mathlib.Algebra.MvPolynomial.Eval`) | Unfolds `eval₂Hom f g (X j) = g j` |
| Pullback side-swap | `pullback.condition` (`Mathlib.CategoryTheory.Limits.Shapes.Pullback.HasPullback`) | `pullback.fst ≫ f = pullback.snd ≫ g` for the intersection |

Sketch in `analogies/chart-bridge-structural-pivot.md`. Expect ~30-40
LOC per cross case (most of the LOC is the `pullbackSpecIso`-based
pull-through into the intersection-Away tensor); the substantive
algebra collapses in ~5-8 LOC.

## Discarded

- **`Fin.cases` as primary recommendation**: option (a) is verified at
  ~2 LOC; option (b) is ~30 LOC refactor.
- **`change` with type aliasing**: brittle around `(fun i ↦ i) ⟨0, ⋯⟩`
  artifacts left by `fin_cases`.
- **`induction i using Fin.cases`**: cleaner than `fin_cases` but more
  verbose; same final result as option (a).

## Persistent file
- `analogies/chart-bridge-structural-pivot.md` — full recipe, supersedes
  `analogies/chart-bridge-shared-helper.md` (iter-174) on Step C and
  cross-cases.

Overall verdict: PROCEED with option (a) — a 2-LOC syntactic bridge
empirically dissolves the Fin mismatch; structural pivot held in reserve.
