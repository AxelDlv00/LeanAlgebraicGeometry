# Mathlib Analogist Report

## Slug
rigidity-refactor-scoping-iter124

## Iteration
124

## Question

Scope the iter-125 refactor of `AlgebraicGeometry.GrpObj.eq_of_eqOnOpen`
(`AlgebraicJacobian/Rigidity.lean:79–114`): which hypotheses are
truly used by the proof, what is the Mathlib-aligned refactored
signature, where are the project's consumers, and what does the
M2.a application site (rigidity for `ℙ¹_{k̄} → A_{k̄}`) need?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Drop unused hypotheses (`[GrpObj X]`, `[GrpObj Y]`, `[SmoothOfRelativeDimension n X.hom]`, `[SmoothOfRelativeDimension m Y.hom]`, `[IsProper X.hom]`, `[GeometricallyIrreducible Y.hom]`, `{n m : ℕ}`) | ALIGN_WITH_MATHLIB | critical |
| Weaken `[IsProper Y.hom]` to `[IsSeparated Y.hom]` (only the latter is used) | ALIGN_WITH_MATHLIB | informational (cost-free generalization) |
| Keep `[GeometricallyIrreducible X.hom]` vs weakening to `[IrreducibleSpace X.left]` | PROCEED | informational |
| Rename `GrpObj.eq_of_eqOnOpen` → `Scheme.Over.ext_of_eqOnOpen` (or root `AlgebraicGeometry.eq_of_eqOnOpen`) | ALIGN_WITH_MATHLIB | major |

## Must-fix-this-iter (iter-125)

- **Drop unused hypotheses**:
  `AlgebraicJacobian/Rigidity.lean:79–89` should drop
  `{n m : ℕ}`, `[SmoothOfRelativeDimension n X.hom]`,
  `[IsProper X.hom]`, `[GrpObj X]`,
  `[SmoothOfRelativeDimension m Y.hom]`,
  `[GeometricallyIrreducible Y.hom]`, `[GrpObj Y]`. The
  current shipped signature blocks the M2.a use case
  (`X = ℙ¹_{k̄}`, which is not a `GrpObj`). The file's own
  comment block (L62–68) already enumerates these as unused, so
  this is dead weight that has actively hardened into a downstream
  blocker.
- **Rename to drop the `GrpObj.` namespace prefix**: the existing
  namespace `GrpObj.` is misleading (the proof never touches any
  `GrpObj` operation); after the hypothesis drop, the namespace
  becomes actively wrong. Recommended target:
  `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` (Mathlib `ext_of_*`
  style). Two blueprint references must be updated
  (`Rigidity.tex:13` `\lean{...}`, `Jacobian.tex:248`
  `\uses{thm:GrpObj_eq_of_eqOnOpen}`).

## Major

- **Weaken `[IsProper Y.hom]` to `[IsSeparated Y.hom]`**: the proof
  body only uses separatedness (line 96–97: `IsProper.toIsSeparated`
  projection). The weakening costs the M2.a caller nothing
  because `A_{k̄}` is proper and `IsProper` extends `IsSeparated`
  as a typeclass parent (`Mathlib.AlgebraicGeometry.Morphisms.Proper:42`).
  This is a strict-more-general signature for zero cost.

## Informational

- **Keep `[GeometricallyIrreducible X.hom]` over the more general
  `[IrreducibleSpace X.left]`**: PROCEED. The geometrically-natural
  hypothesis matches M2.a's caller context (`ℙ¹_{k̄}` is
  geometrically irreducible) and uses the existing Mathlib lemma
  `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`
  (`Mathlib.AlgebraicGeometry.Geometrically.Irreducible:98`). A
  future `[IrreducibleSpace X.left]`-only sibling lemma can be
  added if a non-geometric-irreducible caller appears.
- **Mathlib downstream contribution candidate**:
  `AlgebraicGeometry.ext_of_eqOnNonemptyOpen` packaged as a thin
  ~5-line corollary of `ext_of_isDominant_of_isSeparated'` placed
  in `Mathlib.AlgebraicGeometry.Morphisms.Separated`. The refactored
  declaration itself in `Over (Spec S)`-bundled form is NOT a
  strong contribution candidate (Mathlib already has the strict
  generalization in `[X.Over S]` form). The contribution value
  would be the "non-empty open of irreducible space" API
  packaging.

## Recommended refactored signature

```lean
/-- Rigidity for morphisms of schemes (scheme-level form): two morphisms
`g₁, g₂ : X ⟶ Y` between schemes over `Spec k` whose restrictions to a
non-empty open `U ⊆ X` agree as scheme morphisms — for `X` reduced and
geometrically irreducible over `Spec k`, and `Y` separated over `Spec k`
— agree everywhere. -/
theorem AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen
    {X Y : Over (Spec (.of k))}
    [IsSeparated Y.hom]
    [GeometricallyIrreducible X.hom]
    [IsReduced X.left]
    (g₁ g₂ : X ⟶ Y) (U : X.left.Opens) (hU : (U : Set X.left).Nonempty)
    (h : (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₁.left =
      (U.ι : (U : X.left.Opens).toScheme ⟶ X.left) ≫ g₂.left) :
    g₁ = g₂
```

Proof body: unchanged modulo the first `haveI` line, which becomes
`haveI : IsSeparated (Y.left ↘ Spec (CommRingCat.of k)) := ‹IsSeparated Y.hom›`
(now drawing from the explicit hypothesis rather than
`IsProper.toIsSeparated`). The remaining three lines
(`IrreducibleSpace`, `IsDominant`, `refine … exact
ext_of_isDominant_of_isSeparated'`) are unchanged.

## Hypothesis-use audit (line-by-line)

| Hypothesis | Status | Where used (if used) |
|---|---|---|
| `[SmoothOfRelativeDimension n X.hom]` | UNUSED | — |
| `[IsProper X.hom]` | UNUSED | — |
| `[GeometricallyIrreducible X.hom]` | USED | L101–102 (`irreducibleSpace_of_subsingleton`) |
| `[GrpObj X]` | UNUSED | — |
| `[SmoothOfRelativeDimension m Y.hom]` | UNUSED | — |
| `[IsProper Y.hom]` | USED (over-stated) | L96–97 (only as a source of `IsSeparated`; weakening to `[IsSeparated Y.hom]` removes this redundancy) |
| `[GeometricallyIrreducible Y.hom]` | UNUSED | — |
| `[GrpObj Y]` | UNUSED | — |
| `[IsReduced X.left]` | USED | L113 (`ext_of_isDominant_of_isSeparated'` typeclass) |
| `{n m : ℕ}` (the dimension parameters) | UNUSED | — |

## Mathlib canonical form

The proof reduces to `ext_of_isDominant_of_isSeparated'` in
`Mathlib.AlgebraicGeometry.Morphisms.Separated:319–322`:

```lean
lemma ext_of_isDominant_of_isSeparated' [X.Over S] [Y.Over S] [IsReduced X]
    [IsSeparated (Y ↘ S)]
    {f g : X ⟶ Y} [f.IsOver S] [g.IsOver S] {W} (ι : W ⟶ X) [IsDominant ι]
    (hU : ι ≫ f = ι ≫ g) : f = g :=
  ext_of_isDominant_of_isSeparated (Y ↘ S) (by simp) ι hU
```

The project's `eq_of_eqOnOpen` is a thin wrapper that (i) unwraps
`Over (Spec (.of k))` into `OverClass.fromOver` instances, (ii)
specializes `[IsDominant ι]` to `ι := U.ι` for `U` a non-empty open
(invoking `Scheme.PartialMap.Opens.isDominant_ι` and
`IsOpen.dense`), and (iii) derives `IrreducibleSpace X.left` from
`GeometricallyIrreducible X.hom` plus the `Subsingleton (Spec k)`
fact via `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`.

Mathlib's canonical form is `ext_of_isDominant_of_isSeparated'`,
and the project's declaration is correctly delegated to it. The
refactor does NOT change the Mathlib delegation; it only strips
unused decorations from the project's wrapper.

## Project consumers

- Lean code: **ZERO** consumers outside `Rigidity.lean` itself.
  (Grep `eq_of_eqOnOpen` on `*.lean` returns only line 21 and
  line 79 of `Rigidity.lean`.)
- Blueprint:
  - `blueprint/src/chapters/Rigidity.tex:10–19` —
    `\lean{AlgebraicGeometry.GrpObj.eq_of_eqOnOpen}` reference;
    informal hypotheses to be relaxed.
  - `blueprint/src/chapters/Jacobian.tex:248,328` —
    `\uses{thm:GrpObj_eq_of_eqOnOpen}` and the C.2.b note "however,
    the group-object structure on $X$ is used in the proof of
    Theorem~\ref{thm:GrpObj_eq_of_eqOnOpen} only to form a
    difference morphism …" — the latter becomes obsolete.
- HTML blueprint mirror: generated; will refresh automatically.

## LOC + iter cost estimate

**One iter, ~25 LOC net delta** (estimated breakdown):

| Change | LOC delta |
|---|---|
| `Rigidity.lean:79–89` signature | −8 lines (drop 8 hypotheses + 2 universe params `{n m : ℕ}`) |
| `Rigidity.lean:90–98` first `haveI` body adjustment | ±2 lines |
| `Rigidity.lean:62–68` stale "kept for forward-compatibility" comment | −7 lines (remove) |
| `Rigidity.lean:21–25` "Status" docstring | ±0 (factual update, same LOC) |
| Namespace rename (replace_all in file): | ±2 lines |
| `Rigidity.tex:10–19` informal statement relaxation | ±3 lines |
| `Rigidity.tex:13` `\lean{...}` update | ±0 |
| `Jacobian.tex:248,328` `\uses{}` rename + obsolete note replacement | ±2 lines |

**No new sorries**: the proof body is essentially unchanged.

**No risk to the iter-124 sorry inventory** (`Differentials.lean:362`,
`Jacobian.lean:179`): both files import `Rigidity` transitively
or not at all (`Differentials.lean` does not import it;
`Jacobian.lean` imports it via `AbelJacobi.lean` chain, but the
import-level name change is localized to the new namespace
identifier).

**Compilation impact**: under one minute incremental rebuild for
the rename (`Rigidity.lean` plus any transitive importers — currently
none in the closed M2.a chain since M2.a is iter-126+).

## Persistent file
- `analogies/rigidity-refactor.md` — full per-decision rationale,
  M2.a use-site context, and Mathlib contribution-candidate
  framing captured for iter-125 (refactor execution) and iter-126+
  (M2.a prover lane) reference.

Overall verdict: the iter-125 refactor is a one-iter ~25-LOC
mechanical change that unblocks M2.a; the unused decorations on
the current signature have hardened from "harmless forward-
compatibility" to "active downstream blocker", and the namespace
prefix `GrpObj.` is misleading. ALIGN_WITH_MATHLIB on hypothesis
minimality and rename; ship the refactor as scoped.
