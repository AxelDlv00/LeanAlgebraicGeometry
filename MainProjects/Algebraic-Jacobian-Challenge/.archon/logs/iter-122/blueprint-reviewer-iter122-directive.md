# Blueprint Reviewer Directive

## Slug
iter122

## Strategy snapshot

The project formalizes the nine protected declarations of Christian
Merten's Jacobian challenge (`references/challenge.lean`). The
strategy adopted iter-121 (per a user directive) drops the
"ship-with-sorry" framing and operates as a Mathlib contributor:
zero-inline-sorry end-state, M1/M2/M3 milestone roadmap with sub-step
decomposition.

**Iter-122 is the first iter under that pivot to attempt a prover lane.**
The intended objectives:

1. Confirm that `Differentials.tex` and `Jacobian.tex` now clear the
   HARD GATE (both were `complete: partial` at iter-121 review).
2. If green, dispatch a refactor subagent to introduce the M1 bridge
   declaration `relativeDifferentialsPresheaf_equiv_kaehler_appLE` in
   `AlgebraicJacobian/Differentials.lean` with a `sorry` body, plus
   auxiliary `IsAffineOpen.appLE_isLocalization` (also with `sorry`).
3. Dispatch the M1.a prover lane on the new bridge declaration —
   target the submonoid `M := {g ∈ A : appLE(g) ∈ B^×}` first
   (M1.a is the smallest concrete sub-step).

The chapters of immediate consumption this iter are:

- `Differentials.tex` — contains the M1 bridge theorem
  `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE` and three
  auxiliary lemmas (`lem:appLE_isLocalization`,
  `lem:kaehler_localization_subsingleton`,
  `lem:kaehler_quotient_localization_iso`). Iter-122 plan agent
  applied inline corrections per the mathlib-analogist-bridge-iter121
  findings: renamed `_iso_` → `_equiv_`, namespace `Scheme.appLE_isLocalization`
  → `IsAffineOpen.appLE_isLocalization`, re-framed M1.b cofinality
  argument to use `IsLocalization.of_le` (avoiding `Functor.Final`
  colim-comparison), and corrected M1.c from "Mathlib gap" to
  "thin re-export of `FormallyUnramified.of_isLocalization` +
  `subsingleton_kaehlerDifferential`".

- `Jacobian.tex` — iter-121 blueprint-writer landed expanded C.2
  (genus-0 rigidity via base change to `k̄` + Galois descent, seven
  sub-steps C.2.a-C.2.g). Iter-122 plan agent applied inline
  corrections to lines 376 ((γ) Mathlib summary bullet) and 388
  (Layer I) to remove the stale `Hom(P¹_k, A) = A(k)` framing
  identified by `lean-vs-blueprint-checker-jacobian-review121` major
  findings.

## Routes

Single end-state with multi-arm decomposition. Active routes:

- **M1 — Bridge**: presheaf-form ↔ algebra-Kähler form on an affine
  chart. Active this iter. Chapters: `Differentials.tex`.
- **M2 — Genus-0 witness** (Brauer-Severi-aware via base change to
  `k̄`): blocked behind M1; chapters: `Jacobian.tex` § C.2.
- **M3 — Positive-genus witness** (Route A: Picard via FGA; or
  Route B: symmetric powers via Stein): blocked behind M1; chapters:
  `Jacobian.tex` § "Mathlib infrastructure summary" (α), (β); also
  `Picard_Functor.tex`, `Picard_FunctorAb.tex`, `Picard_LineBundle.tex`
  for Route A.

## References

- `references/challenge.lean`: the authoritative formal statement of
  the missing definitions. Verify `\lean{...}` hints against the
  declarations there.
- `analogies/relative-differentials-presheaf-bridge.md`: persistent
  mathlib-analogist findings from iter-121 on the M1 bridge API
  shape. The plan agent's iter-122 inline corrections to
  `Differentials.tex` are intended to bring the chapter into
  alignment with these findings.

## Focus areas

- **`Differentials.tex`** — extra attention this iter. The inline
  corrections must be checked for:
  1. Internal consistency: every label, `\uses{...}`, and
     `\lean{...}` hint resolves and points at a coherent
     declaration name.
  2. Mathematical correctness of the re-framed M1.b cofinality
     proof (two-direction `IsLocalization.of_le` argument with
     `Localization M`-side construction via `IsLocalization.lift`
     and cocone-side construction via basic-open refinement).
  3. Adequacy of the proof sketch for a prover assigned M1.a (the
     submonoid `M`).

- **`Jacobian.tex`** — extra attention this iter. The C.2 sub-step
  expansion (iter-121) plus the (γ)-bullet correction (iter-122)
  should now be free of the stale `Hom(P¹_k, A) = A(k)` /
  `C ≅ ℙ¹_k`-with-rational-point framing. Verify no further stale
  prose remains in §"Mathlib infrastructure summary" or §"Layer I".

## Known issues

- The iter-121 review by `lean-auditor-review121` re-confirmed three
  known major findings (already documented):
  - `IsAffineHModuleHomFinite` dead chain in
    `StructureSheafModuleK.lean` (must-fix, review118 #1);
  - producerless classes `HasCechToHModuleIso` and
    `HasAffineCechAcyclicCover` in `MayerVietorisCover.lean`
    (major, review118 #1);
  - six redundant typeclass args on `GrpObj.eq_of_eqOnOpen`
    (major, review118 #2).
  Do NOT re-report these. They are cohomology-side / Rigidity
  scaffolding; not part of the M1/M2 active routes this iter.

- The single project-wide `sorry` at `Jacobian.lean:179`
  (`nonempty_jacobianWitness`) is the load-bearing foundational
  existence claim; queued behind M1/M2/M3. The chapter's `\leanok`
  inside its proof block is incorrect (proof is `sorry`); this is
  `sync_leanok`'s responsibility. Do not flag the `\leanok`-in-proof
  mismatch as a chapter defect.

- Iter-122 has NOT yet introduced the bridge declaration in Lean
  (`relativeDifferentialsPresheaf_equiv_kaehler_appLE`,
  `IsAffineOpen.appLE_isLocalization`,
  `Scheme.kaehler_localization_subsingleton`,
  `Scheme.kaehler_quotient_localization_iso`). They exist in the
  blueprint with `\lean{...}` hints but not in Lean. Per the iter-122
  workflow, the refactor subagent will introduce them later this iter
  (after this blueprint-reviewer dispatch returns). Treat the
  `\lean{...}` hints as forward-design references and do NOT flag
  them as `\lean{...}`-hint-misses; they are intentional iter-122
  pre-design.
