# Blueprint review — iter-012 (whole blueprint)

Audit the WHOLE blueprint at `blueprint/src/chapters/*.tex`. This is the mandatory HARD-GATE
pass before iter-012 prover dispatch. Do not scope-limit — the cross-chapter view is the point.

## Context (what changed since your iter-011 pass)

Provers do not edit the blueprint, but the planner is about to dispatch WRITERS this iter to fix
three chapters before any prover touches them. Your job: give the current per-chapter
complete/correct verdict so the planner knows which chapters need a writer and whether the gate
is clear for each file the planner wants to send a prover at.

Files the planner is considering for a prover THIS iter:
- `AlgebraicJacobian/Picard/FlatteningStratification.lean` (chapter
  `Picard_FlatteningStratification.tex`) — target `gf_torsion_reindex` (fill an existing sorry; the 3
  sub-lemmas it assembles landed axiom-clean iter-011).
- `AlgebraicJacobian/Picard/GrassmannianCells.lean` (chapter `Picard_GrassmannianCells.tex`) —
  target `cocycleCondition` (`lem:gr_cocycle`), but ONLY if a writer first pins its `% LEAN
  SIGNATURE` (it currently has none) and your scoped re-review then clears it.

## Known issues to confirm / weigh (from the iter-011 review)

1. **FBC `lem:base_change_mate_section_identity`** — the proof sketch is under-specified on the
   *formalization path*: the LHS adjoint-mate unwinding is narrated at high level but not decomposed
   into named sub-lemmas with Lean signatures. A prover correctly left a typed sorry. Report whether
   this chapter is `correct` but `partial` (needs the 3-sub-lemma decomposition) — the planner will
   effort-break it this iter.
2. **FBC `lem:base_change_mate_regroupEquiv`** — prose says the `R'`-linear equiv is supplied by the
   standalone helper `lem:base_change_regroup_linearEquiv`, but the landed Lean builds it inline via
   an `eT` identity-bridge + `TensorProduct.induction_on` (the `cancelBaseChange` route was abandoned
   over a diamond). Flag as a prose/Lean mismatch to reconcile.
3. **GR `lem:gr_cocycle`** — has a full statement + source quote + proof sketch but NO `% LEAN
   SIGNATURE`; the exact ring-hom identity (which localizations, composition direction, how two
   `IsLocalization.Away.lift`s compose) is ambiguous. Report it as `partial` (signature pin needed).
4. **GR `lem:gr_transition_pre_unit`** — stale `\uses{lem:mathlib_isUnit_iff_isUnit_det}` (listed but
   unused); the anchor `lem:mathlib_isUnit_iff_isUnit_det` (line ~83) is orphaned.
5. **QUOT `lem:qcoh_section_localization_basicOpen`** — genuinely Mathlib-blocked; needs a sizable new
   sub-build (`isIso_fromTildeΓ_of_isQuasicoherent`, QCoh on affine ≅ tilde of sections). Report
   whether the chapter currently has any blueprint coverage for that sub-build (it should not yet) so
   the planner authors it.
6. **Coverage debt** — `archon dag-query unmatched` shows 18 prover-created decls with no blueprint
   block. The non-private ones that need blocks: QuotScheme `annihilator_ideal_le`,
   `schematicSupportι`; GrassmannianCells `universalMatrix_submatrix_self`,
   `imageMatrix_submatrix_self`, `imageMatrix_submatrix_I`, `universalMatrix_map_transitionPreMap`.

## Output

Per-chapter checklist with `complete: true|partial|false` and `correct: true|false`, the must-fix
items per chapter, and your `## Unstarted-phase blueprint proposals` if any. Be explicit about the
gate verdict for `Picard_FlatteningStratification.tex` and `Picard_GrassmannianCells.tex`.
