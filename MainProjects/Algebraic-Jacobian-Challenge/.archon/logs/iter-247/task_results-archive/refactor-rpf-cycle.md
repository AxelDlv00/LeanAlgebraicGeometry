# Refactor Report

## Slug
rpf-cycle

## Status
COMPLETE

## Directive
**Problem**: `TensorObjSubstrate.lean` imported `RelPicFunctor.lean`, creating a cycle that
prevented `RelPicFunctor.lean` from importing the tensor-substrate decls it needs
(`tensorObj`, `tensorObj_isLocallyTrivial`, etc.).

**Changes requested**:
- Delete `import AlgebraicJacobian.Picard.RelPicFunctor` from `TensorObjSubstrate.lean`.
- Move `tensorObjOnProduct` from `TensorObjSubstrate.lean` into `RelPicFunctor.lean`
  (inside `namespace Modules`).
- Delete the dead stub `addCommGroup_via_tensorObj` from `TensorObjSubstrate.lean`.
- Update stale header comments in `TensorObjSubstrate.lean`.
- Add `import AlgebraicJacobian.Picard.TensorObjSubstrate` to `RelPicFunctor.lean`.
- Reorder Picard imports in `AlgebraicJacobian.lean` so `TensorObjSubstrate` precedes
  `RelPicFunctor`.

## Changes Made

### File: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- **What:** Replaced the 4-import block (including `RelPicFunctor`) with a 4-import block
  that drops `RelPicFunctor` and adds `LineBundlePullback` (the previously-transitive dep).
- **Why:** Removing `RelPicFunctor` broke the transitive path to `LineBundlePullback`; since
  `tensorObj_isLocallyTrivial` and `exists_tensorObj_inverse` reference `LineBundle.IsLocallyTrivial`
  (defined in `LineBundlePullback`), a direct import was required.
- **Header update (Status section):** Removed `, \`addCommGroup_via_tensorObj\`` from the
  sorry-residual list; updated the consumer sentence to refer to downstream `RelPicFunctor.lean`.
- **Header update (blueprint pins):** Removed pin #3 (`addCommGroup_via_tensorObj`); updated
  count "3" → "2"; added one-line note that the stub now lives downstream.
- **Header update (sub-module layout):** Removed `addCommGroup_via_tensorObj (sorry)` from
  the file's entry; added one-line note pointing to `RelPicFunctor.lean`.
- **Deleted:** `tensorObjOnProduct` definition + docstring (formerly ≈L706–709).
- **Deleted:** Entire `§4. Consumer` section: section comment, `namespace PicSharp`,
  `addCommGroup_via_tensorObj` (sorry body), `end PicSharp`.
- **Cascading:** None — the directive confirmed both decls were dead (used nowhere in the file).

### File: `AlgebraicJacobian/Picard/RelPicFunctor.lean`
- **What:** Added `import AlgebraicJacobian.Picard.TensorObjSubstrate` as a third import
  (after `LineBundlePullback`).
- **What:** Inserted `tensorObjOnProduct` (with its docstring, updated with a one-line move
  note) inside a `namespace Modules … end Modules` block just before `namespace PicSharp`.
  Body is verbatim from the original; `tensorObj` and `tensorObj_isLocallyTrivial` now
  resolve from the upstream import.
- **Not touched:** `PicSharp.addCommGroup` body, `pTensor`, `pAssoc`, `pLeftUnitor`,
  `pRightUnitor`, `pBraiding`, `pTensor_isLocallyTrivial`, `isLocallyTrivial_unit`,
  `exists_pTensor_inverse`, and the architectural-note prose.

### File: `AlgebraicJacobian.lean`
- **What:** Swapped lines 20–21: `TensorObjSubstrate` now appears before `RelPicFunctor`
  in the Picard import block.

## New Sorries Introduced
None. `tensorObjOnProduct` is sorry-free (body is a trivial struct constructor); it
introduced 0 new sorries in `RelPicFunctor.lean`.

## Sorry Count Delta
| File | Before | After | Delta |
|------|--------|-------|-------|
| `TensorObjSubstrate.lean` | 2 (exists_tensorObj_inverse + addCommGroup_via_tensorObj) | 1 (exists_tensorObj_inverse only) | **−1** |
| `RelPicFunctor.lean` | 4 (pTensor_isLocallyTrivial, pAssoc, isLocallyTrivial_unit, exists_pTensor_inverse) | 4 (unchanged) | **0** |

## Final Import Lines

**TensorObjSubstrate.lean** (lines 6–9):
```
import AlgebraicJacobian.Picard.TensorObjSubstrate.StalkTensor
import AlgebraicJacobian.Picard.TensorObjSubstrate.Vestigial
import AlgebraicJacobian.Picard.TensorObjSubstrate.PresheafInternalHom
import AlgebraicJacobian.Picard.LineBundlePullback
```

**RelPicFunctor.lean** (lines 6–8):
```
import Mathlib
import AlgebraicJacobian.Picard.LineBundlePullback
import AlgebraicJacobian.Picard.TensorObjSubstrate
```

**AlgebraicJacobian.lean** (lines 19–21):
```
import AlgebraicJacobian.Picard.RelativeSpec
import AlgebraicJacobian.Picard.LineBundlePullback
import AlgebraicJacobian.Picard.TensorObjSubstrate
import AlgebraicJacobian.Picard.RelPicFunctor
```

## Compilation Status
- `AlgebraicJacobian.Picard.TensorObjSubstrate`: **builds clean** (only pre-existing
  deprecated-API warnings, no errors)
- `AlgebraicJacobian.Picard.RelPicFunctor`: **builds clean** (4 pre-existing sorry warnings
  at lines 313, 321, 348, 359 — unchanged from before this refactor)

## Notes for Plan Agent
1. **Extra import added** (`LineBundlePullback` into `TensorObjSubstrate`): The directive did
   not list this, but it was mechanically necessary — removing the `RelPicFunctor` import broke
   the transitive path to `LineBundle.IsLocallyTrivial`. The chain
   `LineBundlePullback → TensorObjSubstrate → RelPicFunctor` now holds as a direct-import chain.

2. **Architectural note in RelPicFunctor.lean not updated**: The `/-! ### Substrate for the
   relative-Picard group law (iter-246) -/` prose note (and the `pTensor`/`pAssoc` private
   substrate copies) still describe the import-cycle obstacle as if it were present. Now that
   `TensorObjSubstrate` is upstream, those local copies could in principle be replaced by the
   real upstream decls. This is intentionally left for the prover to rewire — the directive
   explicitly forbids touching them.

3. **`tensorObjOnProduct` is now in `AlgebraicGeometry.Scheme.Modules`** in RelPicFunctor.lean
   (not `PicSharp`), matching its original qualified name from TensorObjSubstrate.lean.

4. **Next prover step**: The 4 typed-sorry bridges in `RelPicFunctor.lean` (`pTensor_isLocallyTrivial`,
   `pAssoc`, `isLocallyTrivial_unit`, `exists_pTensor_inverse`) can now be rewired to the
   real upstream proofs (`tensorObj_isLocallyTrivial`, `tensorObj_assoc_iso`, etc.) from
   `TensorObjSubstrate.lean`. This was the architectural goal of this refactor.
