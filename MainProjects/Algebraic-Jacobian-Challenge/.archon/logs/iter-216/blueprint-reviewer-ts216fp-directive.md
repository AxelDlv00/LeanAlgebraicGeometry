# Blueprint-reviewer directive — iter-216 FAST-PATH (scoped re-clear)

Same-iter fast-path re-review to clear the HARD GATE for ONE chapter:
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (backs the active prover lane
`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`).

## Why re-review
This chapter was substantially rewritten this iter (writers ts216/b/c + clean ts216) to execute a
structural pivot:
- `lem:tensorobj_assoc_iso` re-routed from the (now-superseded) route-(e)/whiskering composite to a
  DIRECT gluing construction: glue the canonical local isos `((M⊗N)⊗P)|_U ≅ … ≅ (M⊗(N⊗P))|_U` (the
  `tensorObj` restriction-compatibility twice + the canonical presheaf associator), agreeing on
  overlaps by naturality, via Hom-is-a-sheaf.
- `lem:tensorobj_restrict_iso` Step 3: H2 closed in-file (`restrictScalarsRingIsoTensorEquiv`, new
  pinned block `lem:restrictscalars_ringiso_tensorequiv`); residual is H1 ALONE; PRIMARY obligation is
  the FREE-COVER specialisation (sheaf-⊗ = presheaf-⊗ on free pieces), NOT the general
  presheaf-pushforward adjunction.
- `lem:tensorobj_isoclass_commgroup` reframed as a BY-HAND CommGroup (four axioms, each one
  existence-of-iso), explicitly NOT via `Skeleton`/`monoidOfSkeletalMonoidal` (those need the coherent
  `MonoidalCategory (X.Modules)` this avoids); `CommRing.Pic` cited only as the analogous object.
- Seven route-(e)/whiskering/stalk blocks marked SUPERSEDED/off-path (the group law never needs them).

## What to verify (gate decision for THIS chapter)
Return a per-chapter verdict (`complete: true|partial|false`, `correct: true|false`) for
`Picard_TensorObjSubstrate.tex`, plus any must-fix-this-iter findings. Specifically check:
1. The direct-gluing associator proof is mathematically adequate to formalize (the overlap-naturality
   compatibility and the Hom-sheaf gluing are stated, not hand-waved).
2. `lem:tensorobj_restrict_iso`'s free-cover make-or-break is coherent (the free-cover case genuinely
   avoids H1) and the H1 residual is honestly flagged Mathlib-absent.
3. The commgroup by-hand framing is correct (no leftover claim that reuses `Skeleton` over `X.Modules`).
4. No internal contradiction remains between the superseded route-(e) blocks and the live direct route.
5. The four open sorries (`tensorObj_restrict_iso`, `exists_tensorObj_inverse`,
   `addCommGroup_via_tensorObj`, and the to-be-deleted whiskering sorry) have adequate proof sketches.

If the chapter returns `complete: true` + `correct: true` with no must-fix, the gate is satisfied and
the prover is dispatched this iter. You may read the rest of the blueprint for cross-chapter context,
but the gate decision needed is for this one chapter.
