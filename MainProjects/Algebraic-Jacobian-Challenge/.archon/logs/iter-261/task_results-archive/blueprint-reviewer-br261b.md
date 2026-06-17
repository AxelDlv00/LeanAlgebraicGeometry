# Blueprint Review Report

## Slug
br261b

## Iteration
261

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Both must-fix items from br261 are resolved. No remaining findings.

## Severity summary
Severity summary: HARD GATE CLEARS — no findings.

## Overall verdict
`Picard_TensorObjSubstrate.tex` is `complete: true` and `correct: true` with no must-fix-this-iter findings; HARD GATE satisfied for all files this chapter covers.

---

### Detailed verification of the two must-fix items

**Fix 1 — `lem:dual_restrict_iso` route-(2) sketch (lines 5649–5830)**

The statement block (lines 5649–5683) and proof block (lines 5685–5830) both carry
`\uses{lem:internal_hom_isSheaf, lem:restrictscalars_ringiso_dualequiv}`.
No trace of the stale edges `def:sheafofmodules_over_equivalence`,
`lem:sheafofmodules_restrict_over_iso`, or `lem:sheafofmodules_unit_over_iso` appears
anywhere in the chapter (grep confirmed zero hits).

The route-(2) construction is present and mathematically rigorous:

- **Stage H1** (lines 5715–5733): Rewrite pulled-back dual from `pullback φ`-form to
  `pushforward β`-form via left-adjoint uniqueness (`pushforwardPushforwardAdj` +
  `leftAdjointUniq`). Residual is exactly "`pushforward β` commutes with dual."
- **`sliceDualTransport` (Leg A, lines 5757–5808)**: Built by hand as the
  `eqToHom`-conjugation of slice-Hom components across `f.opensFunctor`, transported along
  the down-set identity `image_preimage_of_le` (`ι(ι⁻¹(V)) = V`). Naturality commutes by
  `Subsingleton.elim` because `Opens Y` is a thin poset — the chapter correctly names this
  pattern and notes it mirrors the template of `homLocalSection` and `dualUnitIsoGen`.
- **Leg B (lines 5748–5755)**: Unit codomain reconciled via
  `restrictScalarsRingIsoDualEquiv` along the ring isomorphism `βV = (toRingCatSheafHom f).hom_V`,
  referencing the already-defined `lem:restrictscalars_ringiso_dualequiv` (confirmed at line 5475).
- **Assembly (lines 5780–5784)**: Residual packaged as `PresheafOfModules.isoMk` of the
  sectionwise composite of leg (A) then leg (B), outer naturality thin-poset-trivial.
- **Why inverse-uniqueness shortcut fails (lines 5817–5829)**: Correctly explains why
  `hasRightDualOfEquivalence` / `rightDualIso` cannot substitute (four absent structures),
  and that building the coevaluation + zig-zags would be strictly more work than legs (A)+(B).

The sketch is adequate to guide a prover on `DualInverse.lean` implementing
`sliceDualTransport` and `dual_restrict_iso`.

**Fix 2 — `lem:pullback_tensor_map_basechange` Sq2b prose (lines 3904–4089)**

- **`pushforwardComp_lax_μ` description (lines 4023–4035)**: Correctly characterised as
  a "short sectionwise pure-tensor collapse": `pushforward_μ_eq` holds by `rfl` (reducing
  the pushforward tensorator to the `restrictScalars` tensorator definitionally), then
  `ModuleCat.restrictScalars_μ_tmul` collapses both sides to the same pure tensor `m ⊗ n`.
  The text explicitly states "No `extendScalarsComp` / `restrictScalarsComp` change-of-rings
  build enters anywhere."
- **"Genuinely missing ingredients" list (lines 4074–4078)**: Names only Sq1
  (`sheafificationCompPullback`) and Sq4 (`pullbackValIso`). Sq2b (`pullbackComp_δ`
  together with `pushforwardComp_lax_μ`) is marked "fully discharged." This is consistent
  with the iter-261 prover result.

The corrected Sq2b prose is accurate and adequate to guide a prover on
`pullbackTensorMap_restrict` for the Sq1/Sq4 paste.
