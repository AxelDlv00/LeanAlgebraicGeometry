# Refactor directive — Lane E `iotaGm_onePt_chart1_factor` packaging

## Mandate

Execute the structural refactor required by iter-189
`mathlib-analogist lane-e-projappiso` verdict (verdict A:
PROCEED-with-refactor). The mathlib-analogist persistent file is at
`analogies/lane-e-projappiso.md` (read it before starting); the
verdict's recommendation is to unpack the existential `∃ r_1, ...`
inside `iotaGm_onePt_chart1_factor` into a `noncomputable def
iotaGm_r_1` plus paired lemmas, so that the consumer
`iotaGm_chart1_composition_isOpenImmersion` can apply
`IsOpenImmersion.lift_app` directly without re-deriving the range-
containment witness through `cancel_mono`.

## Files

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — restructure
  `iotaGm_onePt_chart1_factor` (current location L106-L163) into a
  `def` + paired lemmas as described below. Insert `sorry` at any
  broken proof site you create; do NOT close proofs.
- No other files should be edited.

## Concrete refactor (per analogist Section 2)

The current shape of `iotaGm_onePt_chart1_factor` is approximately:

```lean
private theorem iotaGm_onePt_chart1_factor (...) :
    ∃ (r_1 : ...), r_1 ≫ Proj.awayι ... = onePt.left := by
  refine ⟨IsOpenImmersion.lift (Proj.awayι ...) onePt.left ?_, ?_⟩
  · -- range containment proof, ~30-40 LOC
  · -- factorization proof = IsOpenImmersion.lift_fac
```

Refactor to:

```lean
/-- The range-containment witness for `r_1 = lift _ _ this`. Extracted
    so the consumer of `iotaGm_r_1` can use it directly. -/
private theorem iotaGm_r_1_range_subset (...) :
    Set.range onePt.left.base ⊆
      Set.range (Proj.awayι 𝒜 (X 1) X_1_deg hX_1_pos).base := by
  -- the iter-186/iter-188 ~30-40 LOC range-containment proof, lifted out
  sorry

/-- The lift `r_1 : ... ⟶ Proj.away 𝒜 (X 1)` factoring `onePt.left`
    through the open immersion `Proj.awayι 𝒜 (X 1)`. -/
noncomputable def iotaGm_r_1 (...) :
    Spec _ ⟶ Proj.away 𝒜 (X 1) :=
  IsOpenImmersion.lift (Proj.awayι 𝒜 (X 1) X_1_deg hX_1_pos)
    onePt.left (iotaGm_r_1_range_subset ...)

/-- The factorization `iotaGm_r_1 ≫ Proj.awayι _ = onePt.left`. -/
private theorem iotaGm_r_1_fac (...) :
    iotaGm_r_1 ... ≫ Proj.awayι 𝒜 (X 1) X_1_deg hX_1_pos = onePt.left := by
  exact IsOpenImmersion.lift_fac _ _ _

/-- Retained as a wrapper for backward compat (if there are remaining
    consumers that prefer the existential shape). -/
private theorem iotaGm_onePt_chart1_factor (...) :
    ∃ (r_1 : ...), r_1 ≫ Proj.awayι 𝒜 (X 1) X_1_deg hX_1_pos = onePt.left :=
  ⟨iotaGm_r_1 ..., iotaGm_r_1_fac ...⟩
```

The exact signatures (the `...` placeholders) must match the existing
hypotheses of `iotaGm_onePt_chart1_factor` verbatim. Keep
`iotaGm_onePt_chart1_factor` as a backward-compat wrapper unless every
call site in the file can be migrated to the new `iotaGm_r_1` /
`iotaGm_r_1_fac` pair in one go — if you can migrate cleanly, prefer
removing the wrapper.

## Consumer side: `iotaGm_chart1_composition_isOpenImmersion`

The downstream consumer at L252-L439 currently does a
`cancel_mono`-based re-derivation to recover the `IsOpenImmersion.lift`
shape from the `∃`-packed `r_1`. After the refactor, that
re-derivation collapses: the consumer can use `iotaGm_r_1_fac`
directly to invoke `IsOpenImmersion.lift_app` on `iotaGm_r_1`.

For this refactor pass, **do not modify the consumer's proof body**.
Leave its `sorry` (currently at L439 per the iter-188 state) in place
— the iter-190 prover phase will land the `r_1_appTop_isLocElem_eq_one`
helper that consumes the new packaging.

## Boundary

- This is a STRUCTURAL refactor only. Do not close any proof body.
  Insert `sorry` at any new broken proof site (e.g. the new
  `iotaGm_r_1_range_subset` body — copy the existing range-containment
  argument inline, or leave it as `sorry` if it gets confusing).
- Do not delete the existing `iotaGm_onePt_chart1_factor` body
  content. If you migrate it into `iotaGm_r_1_range_subset` /
  `iotaGm_r_1` / `iotaGm_r_1_fac`, retain it verbatim there.
- Do NOT touch any other file. The refactor is scoped to
  `AbelianVarietyRigidity.lean`.

## Verification

After the refactor:
- `lake build` (or the LSP equivalent via the archon-lean-lsp MCP)
  must succeed.
- Any `sorry`s introduced must be at proof sites (not signature
  sites). The signatures of the new declarations must compile.
- The existing consumer `iotaGm_chart1_composition_isOpenImmersion`
  may still have its iter-188 `sorry` at L439 — that's expected and
  is the iter-190 prover target.

## Report

Write your task_results report to
`task_results/refactor-lane-e-iotagm-packaging.md` with: the new
declarations landed (names + line numbers); the migration status of
the consumer; any unexpected breakage. Persist your findings inline;
do not point the user at intermediate files.
