# Blueprint Writer Directive

## Slug
coheightbridge-skeleton

## Target chapter
blueprint/src/chapters/Albanese_CoheightBridge.tex

This chapter does NOT yet exist — you are creating it from scratch.
After writing the chapter, the plan agent will manually add
`\input{chapters/Albanese_CoheightBridge}` to `blueprint/src/content.tex`
(your descriptor forbids editing `content.tex`).

## Strategy context

The project is formalizing the Algebraic Jacobian challenge. Route A
(positive-genus arm) needs `Albanese/CodimOneExtension.lean`'s
`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` body, which
contains an internal conjunction:

```
have hreg_dim : IsRegularLocalRing (X.left.presheaf.stalk z) ∧
                ringKrullDim (X.left.presheaf.stalk z) = 1 := sorry
```

The iter-182 plan-phase `mathlib-analogist stacks-00tt-coheight` consult
(persistent recipe at `analogies/stacks-00tt-coheight.md`) determined:

- **Stacks 00TT** (`Algebra.Smooth k A → IsRegularLocalRing (A_p)`) =
  GENUINE Mathlib gap; ~200-300 LOC standalone sub-project. Defer.
- **Coheight-to-Krull-dim bridge** (`Order.coheight z = ringKrullDim
  (X.presheaf.stalk z)`) = project-side fillable, ~60-100 LOC scaffold.
  THIS is the iter-183+ Lane M target — the chapter you are writing
  blueprints exactly this scaffold.

Once the coheight bridge lands as `Albanese/CoheightBridge.lean`, the
`hreg_dim` conjunction in `CodimOneExtension.lean` halves: the
Krull-dim half closes via the bridge; the regular-local-ring half remains
as the (separate) Stacks 00TT gap.

The bridge also lets `Scheme.RationalMap.order` (`WeilDivisor.lean`:148-151)
drop its explicit `[Ring.KrullDimLE 1 _]` instance argument — improving
threading hygiene across downstream codim-1 code.

## Required content

The chapter should contain three lemma blocks + one instance block, each
backed by a `\lean{...}` pin matching the declaration name in the eventual
`Albanese/CoheightBridge.lean`. Each block needs a `% SOURCE:` /
`% SOURCE QUOTE:` from the project's analogist recipe + the relevant
Stacks/Mathlib reference, plus a clear informal proof sketch.

### Block 1 — Topology lemma: coheight commutes with open embedding

```latex
\begin{lemma}[coheight on opens]
  \label{lem:coheight_eq_of_isOpenEmbedding}
  \lean{Order.coheight_eq_of_isOpenEmbedding}
  Let $X$ be a topological space and $U \subseteq X$ an open subset.
  For any $z \in U$, the coheight (in the specialization preorder) of $z$
  in $U$ equals the coheight of $z$ in $X$.
\end{lemma}
```

Sketch: every strict-generization chain `z = a₀ < a₁ < ... < aₙ` in `X`
starting at `z` has every `aᵢ ∈ U` because each `aᵢ ⤳ z` and `U` is
open containing `z`. The bijection between chains in `U` and chains in
`X` starting at `z` preserves length.

Source pointer: `analogies/stacks-00tt-coheight.md` Decision 2 sketch L246-257.

### Block 2 — Algebra-geometry duality: coheight on Spec = height of prime

```latex
\begin{lemma}[coheight on Spec equals height in PrimeSpectrum]
  \label{lem:coheight_spec_eq_height_primeSpectrum}
  \lean{Order.coheight_spec_eq_height_primeSpectrum}
  Let $R$ be a commutative ring. For any $p \in \Spec R$ (viewed as a
  point of the scheme spectrum), the coheight of $p$ in $\Spec R$ equals
  the height of $p$'s underlying prime ideal in $\Spec R$ (equivalently:
  the supremum of strict prime-ideal chains $p_0 \subsetneq \cdots
  \subsetneq p$).
\end{lemma}
```

Sketch: the specialization preorder on `Spec R` is the dual of the
inclusion preorder on `PrimeSpectrum R` (folklore; cf. Mathlib
`spec_le_iff` in `AffineSpace.lean`). Coheight in the dual equals
height in the original, by `coheight_orderIso` + `height_toDual`.

Source pointer: `analogies/stacks-00tt-coheight.md` Decision 2 sketch L259-268.

### Block 3 — The bridge: coheight at a scheme point equals Krull dim of stalk

```latex
\begin{theorem}[coheight to Krull dimension bridge]
  \label{thm:ringKrullDim_stalk_eq_coheight}
  \lean{AlgebraicGeometry.Scheme.ringKrullDim_stalk_eq_coheight}
  \uses{lem:coheight_eq_of_isOpenEmbedding, lem:coheight_spec_eq_height_primeSpectrum}
  Let $X$ be a scheme and $z \in X$ any point. Then
  \[
    \dim \mathcal{O}_{X,z} \;=\; \operatorname{coheight}_X(z).
  \]
\end{theorem}
```

Sketch (5-step assembly per analogist recipe Decision 2 L280-296):
1. Pick an affine open `U` of `X` containing `z` (via
   `exists_isAffineOpen_mem_and_subset`).
2. Let `p` be the prime ideal of `Γ(U)` corresponding to `z` (via
   `IsAffineOpen.primeIdealOf`).
3. The stalk `O_{X,z}` is the localization of `Γ(U)` at `p` (via
   `IsAffineOpen.isLocalization_stalk`).
4. `ringKrullDim` of the localization equals the height of `p`, via
   `IsLocalization.AtPrime.ringKrullDim_eq_height` +
   `Ideal.height_eq_primeHeight`.
5. Identify the height of `p` (in `PrimeSpectrum Γ(U)`) with the coheight
   of `z` in `U.carrier` via Lemma 2, then lift back to coheight of `z`
   in `X.carrier` via Lemma 1.

### Block 4 — Instance: coheight = 1 ⟹ `Ring.KrullDimLE 1` on stalk

```latex
\begin{lemma}[coheight 1 forces stalk Krull-dim $\leq 1$]
  \label{lem:ringKrullDimLE_of_coheight_eq_one}
  \lean{AlgebraicGeometry.Scheme.ringKrullDimLE_of_coheight_eq_one}
  \uses{thm:ringKrullDim_stalk_eq_coheight}
  Let $X$ be a scheme and $z \in X$ with $\operatorname{coheight}_X(z) = 1$.
  Then `Ring.KrullDimLE 1` holds on the stalk $\mathcal{O}_{X,z}$.
\end{lemma}
```

Sketch: rewrite via the bridge (Block 3); `coheight z = 1` and
`KrullDimLE 1 ↔ ringKrullDim ≤ 1` gives the result. ~10 LOC in Lean.

This is the load-bearing instance for `CodimOneExtension.lean`'s
`hreg_dim` refactor: after Lane M lands, `hreg_dim` halves into a
Krull-dim half (closed by this instance, given `_hz : coheight z = 1`)
and an `IsRegularLocalRing` half (the Stacks 00TT gap, separate
sub-project).

## Out of scope

- Stacks 00TT (smooth ⟹ regular stalks) itself — separate iter-200+ sub-project.
- Codim-1 valuative criterion / Milne 3.3 difference-map construction — separate.
- `Scheme.RationalMap.order` refactor to drop `[Ring.KrullDimLE 1 _]` instance
  argument — a downstream consequence, not part of this chapter.
- Mathlib upstream PRs — flag in your report as observations, do NOT plan in the chapter.

## References

- `analogies/stacks-00tt-coheight.md` — full plan-phase recipe (L1-394).
- `references/stacks-algebra.md` — Stacks ch.10 pointer (the file you can quote from is
  `references/stacks-algebra.tex` — Stacks tags 00TT and surrounding sections of
  Krull dimension theory). The chapter you write does NOT cite Stacks 00TT directly
  (that's iter-200+ sub-project) — but you may cite the surrounding Krull-dimension
  / coheight foundations if Stacks discusses them in the algebra chapter.
- Mathlib: `Mathlib.Order.KrullDimension` (`coheight_orderIso`,
  `height_toDual`), `Mathlib.AlgebraicGeometry.Stalk`
  (`IsAffineOpen.isLocalization_stalk`, `IsAffineOpen.primeIdealOf`),
  `Mathlib.RingTheory.Ideal.Height` (`IsLocalization.AtPrime.ringKrullDim_eq_height`,
  `Ideal.height_eq_primeHeight`).

## Expected outcome

A new chapter `blueprint/src/chapters/Albanese_CoheightBridge.tex` containing:
- 1 `\chapter{...}` heading (e.g. `\chapter{Coheight–Krull dim bridge}`).
- Optional 1 short `\section{}` per block, or just the 4 blocks in sequence.
- 4 declaration blocks (3 `\begin{lemma}` + 1 `\begin{theorem}`) with
  full `\lean{...}`, `\uses{...}`, `% SOURCE:`, `% SOURCE QUOTE:`,
  `\textit{Source: ...}`, and informal proof body per the
  project's blueprint conventions.
- Total chapter length: ~80-150 lines of LaTeX.

Do NOT add `\leanok` or `\mathlibok` markers. Do NOT edit `content.tex`.
Do NOT touch any other chapter.
