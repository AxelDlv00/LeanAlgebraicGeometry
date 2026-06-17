# Blueprint Review Report

## Slug
fbc-rereview

## Iteration
002

## Top-level summaries

### Citation discipline

- `Picard_RelativeSpec.tex` / `thm:relative_spec_univ`: `% SOURCE QUOTE PROOF:` line absent; proof text reads as an Archon-original gluing argument (not a direct transcription of the Stacks lemma-spec proof), but the `% SOURCE QUOTE PROOF: TODO retrieve from references/stacks-constructions.tex` comment acknowledges the gap. Carried forward as **soon**-severity (known deferred, flagged in prior review; no change).

### Dependency & isolation findings

- `leandag build` reports 4 isolated nodes — all `lean_aux` type with no blueprint chapter. No blueprint node is isolated.
- 5 `unmatched_lean` entries:
  - `lem:base_change_map_affine_local` → `AlgebraicGeometry.TODO.base_change_map_affine_local` — **keep**: intentional scaffold placeholder.
  - `lem:pushforward_base_change_mate_cancelBaseChange` → `AlgebraicGeometry.TODO.pushforward_base_change_mate_cancelBaseChange` — **keep**: intentional scaffold placeholder.
  - `thm:generic_flatness_algebraic` → `AlgebraicGeometry.TODO.genericFlatnessAlgebraic` — **keep**: intentional scaffold placeholder.
  - `lem:flat_preserves_equalizer_mathlib` → `LinearMap.tensorEqLocusEquiv` — **keep**: `\mathlibok` anchor; declaration verified present in `Mathlib/RingTheory/Flat/Equalizer.lean`. Unmatched only because it is not in project files.
  - `lem:functor_is_representable_mathlib` → `CategoryTheory.Functor.IsRepresentable` — **keep**: `\mathlibok` anchor; declaration verified present in `Mathlib/CategoryTheory/Yoneda.lean`.
- 0 `unknown_uses` — all `\uses{}` labels resolve.

## Per-chapter

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Repaired proof of `lem:base_change_map_affine_local` — GATE CLEARS.** The prior hand-wave ("pushforwardBaseChangeMap is built from units and counits, all of which commute with restriction … Granting this compatibility …") has been replaced with an explicit three-step derivation:
    - *Step 1*: Unfold `pushforwardBaseChangeMap` as the `(g*, g_*)`-adjunction transpose of `f_*(η_F)`, where `η_F` is the unit of the `((g')*, (g')_*)`-adjunction. Matches `def:pushforward_base_change_map` exactly.
    - *Step 2*: Restriction to an affine open `U ⊆ S'` commutes with each building block, via three named standard facts: (a) adjunction units are natural + pulling a cartesian square back along `U ↪ S'` gives another cartesian square; (b) pushforward commutes with restriction to an open of the base (`(f_*G)|_U = (f|_{f⁻¹U})_*(G|_{f⁻¹U})`); (c) the `(g*, g_*)`-adjunction transpose is natural in both variables.
    - *Step 3*: Chaining (a)–(c) identifies `(pushforwardBaseChangeMap).app U` with `pushforwardBaseChangeMap` for the affine-affine square restricted over `U`; the locality criterion `lem:modules_isIso_iff_affineOpens` then closes.
  - Mathematical soundness: all three items in Step 2 are standard naturality/definitional facts in Lean/Mathlib, not non-trivial coherence obligations. A prover seeing this knows exactly what instances and simp-lemmas to invoke, with no ambiguity about whether any step requires a bespoke coherence proof.
  - `\uses{}` for `lem:base_change_map_affine_local` lists `def:pushforward_base_change_map` and `lem:modules_isIso_iff_affineOpens`; this is correct for the formal signature (the pure locality-reduction implication). The per-open isomorphism is supplied to `lem:affine_base_change_pushforward` by `lem:pushforward_base_change_mate_cancelBaseChange`, whose own `\uses{}` is correct.
  - `lem:pushforward_base_change_mate_cancelBaseChange` (FBC-B frontier): four-step explicit section-level computation correctly identifies `Γ(α)` with `cancelBaseChange⁻¹`; the derivation is internally consistent and prover-ready.
  - `lem:flat_preserves_equalizer_mathlib` (`\mathlibok`): `LinearMap.tensorEqLocusEquiv` confirmed present in Mathlib. Anchor faithful.
  - FBC-B coverage (`thm:flat_base_change_pushforward`): the global theorem proof has both the separated case (finite equalizer + affine lemma + flatness commutativity) and the quasi-separated Mayer–Vietoris induction fully sketched. Blueprint coverage for FBC-B is adequate within this chapter.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:relative_spec_univ`: `% SOURCE QUOTE PROOF:` absent; the TODO comment acknowledges the gap and defers retrieval from `references/stacks-constructions.tex` (L553–L600). **Soon**-severity, not must-fix; deferred from prior review.

## Severity summary

- **must-fix-this-iter**: none.
- **soon**: `Picard_RelativeSpec.tex` / `thm:relative_spec_univ` — missing `% SOURCE QUOTE PROOF:` (known, deferred).

**HARD GATE CLEARS for `Cohomology_FlatBaseChange.tex`**: `complete: true`, `correct: true`, no must-fix finding. The FBC prover may be dispatched this iteration.

Overall verdict: `Cohomology_FlatBaseChange.tex` is now complete and correct — the affine-local proof hand-wave is resolved by the explicit three-step naturality derivation; HARD GATE clears for FBC-A prover dispatch this iter.
