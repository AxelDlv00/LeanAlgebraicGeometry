# DAG Walker Report

## Slug
quot-flattening

## Seed
thm:quot_representable

## Status
COMPLETE — cone fully grounded. All six gap nodes pinned with `\lean{}`, both
isolated nodes wired onto the cone; zero ∞ holes and zero broken `\uses` in
either chapter.

## Cone before → after
- ∞ holes (in the two chapters): 0 → 0 (every gap node already carried an
  informal proof; the gaps were missing `\lean{}` pins + floating edges, not
  missing proofs)
- broken \uses: 0 → 0
- isolated nodes: 2 → 0 (`lem:smooth_proper_curve_projective`,
  `cor:flattening_stratification_curve` now on the cone)
- `\lean{}` pins added: 6;  `\uses` edges added: 2

## Blocks added / proofs written
None. Per directive, no statements/proofs were rewritten — this was a pinning +
wiring pass only.

## `\lean{}` pins added
In `chapters/Picard_QuotScheme.tex` (no in-file Lean decl exists for these
named sub-steps of the representability construction → `AlgebraicGeometry.TODO.*`
placeholders per DAG integrity rule 1, matching the existing
`AlgebraicGeometry.TODO.quotBoundedness` convention):
- `lem:quot_reduction_to_pi_star_W` → `\lean{AlgebraicGeometry.TODO.quotReductionToPiStarW}`
- `lem:quot_alpha_injective` → `\lean{AlgebraicGeometry.TODO.quotAlphaInjective}`
- `lem:quot_valuative_criterion` → `\lean{AlgebraicGeometry.TODO.quotValuativeCriterion}`

In `chapters/Picard_FlatteningStratification.tex`:
- `thm:generic_flatness_algebraic` → `\lean{AlgebraicGeometry.TODO.genericFlatnessAlgebraic}`
  (the geometric form `genericFlatness` exists in the Lean file and is already
  pinned; the algebraic form is folded into its proof, so it has no standalone
  decl → placeholder)
- `lem:smooth_proper_curve_projective` → `\lean{AlgebraicGeometry.TODO.smoothProperCurveProjective}`
  (folklore lemma, no Lean decl → placeholder)
- `cor:flattening_stratification_curve` → `\lean{AlgebraicGeometry.flatteningStratification.ofCurve}`
  **REAL declaration** — verified present at
  `AlgebraicJacobian/Picard/FlatteningStratification.lean:438` (sorry-bodied),
  and already named as the curve specialisation in the chapter's "Mathlib
  status" section.

## \uses edges added/fixed (the completeness fixes)
- `cor:flattening_stratification_curve` now
  `\uses{lem:smooth_proper_curve_projective, thm:flattening_stratification_exists}`
  — its proof first invokes the projectivity lemma to factor
  `C ×_k T → T` through `ℙⁿ_T`, then applies the existence theorem to the
  pushed-forward sheaf. Both were used by the proof but undeclared. This single
  edge wires *both* previously-isolated nodes onto the cone:
  `lem:smooth_proper_curve_projective` now has a consumer (rdep 0 → 1), and the
  corollary now has its two real dependencies (dep 0 → 2).
- The three QuotScheme sub-lemmas were already consumed by
  `thm:quot_representable`'s `\uses{}` list — no new edge needed; pinning alone
  made them honest cone members (each now rdep = 1).

## Verification (post-edit `archon dag-query`)
- `thm:quot_representable`: dep 8, descendants 22 — unchanged, intact.
- `cor:flattening_stratification_curve`: lean = `…flatteningStratification.ofCurve`,
  dep 2, rdep 1 (consumed by `Picard_FGAPicRepresentability.tex:175`).
- `lem:smooth_proper_curve_projective`: pinned, rdep 1.
- `thm:generic_flatness_algebraic`: pinned, rdep 1 (consumed by
  `thm:generic_flatness`).
- `archon dag-query gaps` → NONE in either chapter.

## Could not complete (genuine gaps — strategy items)
None at the DAG-integrity level. Note (not a walker action item): five of the
six pins are `AlgebraicGeometry.TODO.*` placeholders — the corresponding Lean
declarations do not yet exist in `Picard/QuotScheme.lean` /
`Picard/FlatteningStratification.lean`. These are real future formalization
obligations (the named Nitsure §5 / §4 sub-steps), but they are correctly
represented as finite-effort, fully-cited blueprint blocks; scaffolding their
Lean decls is a prover/file-skeleton task, not a blueprint-completeness gap.

## References consulted
- None newly retrieved. Both chapters already carry complete `% SOURCE` /
  `% SOURCE QUOTE` citation blocks from `references/nitsure-hilbert-quot.md`
  and `references/stacks-*.tex`; no block lacked a citation line, so per the
  directive no prose was rewritten and no reference-retriever was spawned.

## Notes for dispatcher
- The placeholder pins follow the existing `AlgebraicGeometry.TODO.<camelCase>`
  pattern already in use (`quotBoundedness`, `flatLocusOpen`,
  `nonflatLocusProper`, `noetherianInductionStrata`). When the Lean
  file-skeleton lane scaffolds these five decls, the `sync_leanok` /
  `\lean{}`-correction passes should re-point the pins to the real names.
- `cor:flattening_stratification_curve` is the only one of the six backed by an
  existing (sorry-bodied) Lean decl; it is ready for a prover once its
  dependency `thm:flattening_stratification_exists` (`flatteningStratification`,
  also sorry-bodied) is discharged.
