# Blueprint Writer Directive

## Slug
mv-iter112

## Target chapter
blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Strategy context

STRATEGY.md authoritatively lists **7 named Mathlib-gap sorries + 1 budget-deferral**. The 7th gap (`serre_duality_genus` at `Differentials.lean:877`) was added in the iter-110 mathlib-analogist-serre-duality reclassification. The current text of the `\begin{remark}` block at `Cohomology_MayerVietoris.tex:1194-1199` (`rem:basicOpenCover_step2_status`) lists only **6 entries** in its enumeration and explicitly attributes the count to "iter-110" — this contradicts the iter-110 reclassification itself.

The named-gap roster (verified this iter against Lean sources by blueprint-reviewer-iter112):
- `instIsMonoidal_W` (`Modules/Monoidal.lean:173`) — varying-ring `stalk_tensorObj` gap. Load-bearing post-C1.
- `cotangentExactSeq_structure.h_exact` (`Differentials.lean:636`) — sheaf-of-modules exactness criterion.
- `nonempty_jacobianWitness` (`Jacobian.lean:179`) — Hilbert/Quot schemes + finite-group quotients.
- `PicardFunctor.representable` (`Picard/Functor.lean:181`) — gated on Phase C3.
- `SheafOfModules.pullback_tensorObj` (`Picard/LineBundle.lean:82`) — μ-iso of absent monoidal-pullback instance.
- `SheafOfModules.pullback_oneIso` (`Picard/LineBundle.lean:96`) — ε-iso, sibling to the above.
- **`serre_duality_genus` (`Differentials.lean:877`)** — Serre duality for smooth proper curves; iter-110 mathlib-analogist named-deferred.

The 1 budget-deferred sorry stays at `BasicOpenCech.lean:1846` and is correctly distinguished from the named-gap surface (per Option (i) escape-valve fired iter-108).

## Required content

Update the `\begin{remark}` block at lines `1194-1199` (label `rem:basicOpenCover_step2_status`) of `Cohomology_MayerVietoris.tex`:

1. **Update count**: replace "comprises six entries" → "comprises seven entries".
2. **Add the missing entry**: extend the enumeration to include `\texttt{serre\_duality\_genus}` (Serre duality for smooth proper curves; `\texttt{Differentials.lean:$877$}`). Use the same `\texttt{...}` formatting convention as the other entries.
3. **Update temporal qualifier**: replace "As of iter-110" → "As of iter-112" so a future reader doesn't think the enumeration is stale relative to its own framing.
4. **Optional minor cleanup**: the entries are listed in roughly the order they appeared in named-gap-roster history. Keep that order; insert `serre_duality_genus` either at the end of the enumeration (chronologically — iter-110 added it last to the 6-then-7 roster) or in topical order alongside `cotangentExactSeq_structure.h_exact` (both Differentials.lean gaps). Either choice is fine; pick the cleaner one.

No other changes needed in this chapter. The substep numbering (i)–(iv) is internally consistent per blueprint-reviewer-iter112; do not touch it.

## Out of scope

- Do NOT edit any other chapter.
- Do NOT touch the Lean source in `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`.
- Do NOT introduce any new theorem/lemma block; this is a cosmetic remark touch-up only.
- Do NOT propose any strategy change — the named-gap count is already authoritative in STRATEGY.md.
- Do NOT add a `\leanok` or `\mathlibok` marker; this is informational prose.

## References

- `STRATEGY.md` (named-gap roster authoritative).
- `analogies/serre-duality.md` (rationale for `serre_duality_genus` named-deferred status).
- `blueprint/src/chapters/Differentials.tex` lines `220-230` for the `serre_duality_genus` theorem statement (Serre duality genus equality `dim_k H^0(C, Ω_{C/k}) = dim_k H^1(C, O_C)`).

## Expected outcome

Single remark block updated. Count corrected 6→7, temporal qualifier refreshed, `serre_duality_genus` added to the enumeration. No structural changes; <20 LOC delta in the LaTeX source.
