# Refactor Report

## Slug
dual-green-split

## Status
COMPLETE

Both PRIORITY 1 (green build) and PRIORITY 2 (file split) succeeded. All affected modules compile with `lake build` exit 0.

## Directive
**Problem**: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` was RED with 6 compile errors (whnf-timeouts and "function expected" in naturality fields; "ext z" applied to ∀-typed goals; cascade "Unknown identifier sliceDualTransport").

**Changes Requested**:
- PRIORITY 1: Insert typed `sorry` at failing proof sites, keeping all signatures byte-identical.
- PRIORITY 2: Split the green file along the `sliceDualTransport` / `dual_restrict_iso` seam.

## Changes Made

### PRIORITY 1 — sorry insertions

#### Site 1: `sliceDualTransportInv.naturality` (original L407–410)
- **What**: Replaced `ext z; simp only [PresheafOfModules.pushforward_obj_obj, ..., dualUnitRingSwapHom, unitRelabelSwap]` with `sorry -- REPAIR: sorry inserted at broken proof site; fill via analogies/dualnat006.md`.
- **Why**: The `ext z` / `simp only` block left open goals (the four-leg ε-naturality paste is not yet assembled). Directive L407.

#### Site 2: `sliceDualTransport.toFun.naturality` (original L547–556)
- **What**: Replaced the `· intro X_1 Y_1 f_1 ... exact hφ z` bullet (naturality of the `PresheafOfModules.Hom` inside `toFun`) with `· sorry -- REPAIR: ...`.
- **Why**: `exact hφ z` failed with "function expected" after `simp only` (goal type mismatch post-simp); whnf-timeout on the containing field. Directive L436/L556/L566.
- **Cascade**: Removing the failing bullet restored the goal ordering for the subsequent `map_add'` / `map_smul'` / `invFun` bullets (which are CLOSED) so they addressed the correct goals.

#### Sites 3–4: `sliceDualTransport.left_inv` and `right_inv` (original L658–670)
- **What**: Replaced both `ext z; simp only [sliceDualTransportInv, sliceDualTransport, ...]` bullets with `· sorry -- REPAIR: ...`.
- **Why**: After the naturality sorry was inserted, these goals (type `∀ x, invFun (toFun x) = x`) became reachable; `ext z` does not apply to a `∀`-typed goal (error: "This extensionality tactic only applies to equalities"). The directive's L799 cascade also resolved once `sliceDualTransport` elaborated — `PresheafOfModules.isoMk ... sliceDualTransport` at `dual_restrict_iso` L799 and `subsingleton` at L803 now compile without sorry.

#### Build verification after PRIORITY 1
```
lake build AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse → exit 0
(warnings: sorry at sliceDualTransportInv L317, sliceDualTransport L426 — expected)
```

### PRIORITY 2 — file split

#### New file: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/SliceTransport.lean`
Content (612 lines):
- Copyright + original imports (`TensorObjSubstrate`, `PresheafInternalHom`)
- New module docstring describing the §0/§A content
- `set_option autoImplicit false`, `universe u`, `open CategoryTheory Limits MonoidalCategory`
- **§0** (`namespace PresheafOfModules`): `unitDualSectionEquiv`, `dualUnitIsoGen`
- **§A** (`namespace AlgebraicGeometry.Scheme.Modules`): `isIso_ε_restrictScalars_appIso`, `dualUnitRingSwap`, `dualUnitRingSwapInv`, `dualUnitRingSwap_apply`, `dualUnitRingSwap_comp_dualUnitRingSwapInv`, `dualUnitRingSwapInv_comp_dualUnitRingSwap`, `isIso_ε_restrictScalars_appIso_hom`, `dualUnitRingSwapHom`, `isIso_ε_restrictScalars_presheafMap`, `unitRelabelSwap`, `sliceDualTransportInv`, `sliceDualTransport`
- Closing `end Modules`, `end Scheme`, `end AlgebraicGeometry`

#### Modified: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
Content (638 lines):
- Copyright + original imports + **new** `import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse.SliceTransport`
- Original module docstring (unchanged)
- `set_option autoImplicit false`, `universe u`, `open CategoryTheory Limits MonoidalCategory`
- `namespace AlgebraicGeometry`, `namespace Scheme`, `namespace Modules`
- **Kept content** (original L650–1213): `dual_restrict_iso`, `presheafDualUnitIso`, `dual_unit_iso`, `dual_isLocallyTrivial`, `homLocalSection`, `topSectionToHom`, `topSectionToHom_app`, `image_preimage_of_le`, `homOfLocalCompat`
- Closing `end Modules`, `end Scheme`, `end AlgebraicGeometry`

## New Sorries Introduced

| File | Decl | Field | Note |
|------|------|-------|------|
| `SliceTransport.lean` | `sliceDualTransportInv` | `naturality` | thin-poset ε-naturality paste not assembled |
| `SliceTransport.lean` | `sliceDualTransport` | `toFun.naturality` | ε-naturality of `restrictScalars` through `dualUnitRingSwap` |
| `SliceTransport.lean` | `sliceDualTransport` | `left_inv` | blocked on invFun round-trip (`ext z` wrong tactic) |
| `SliceTransport.lean` | `sliceDualTransport` | `right_inv` | blocked on invFun round-trip (`ext z` wrong tactic) |

All 4 sorries are in `SliceTransport.lean` (moved from the original `DualInverse.lean`). No new sorry sites in `DualInverse.lean` beyond the pre-existing ones.

## Compilation Status

| Module | Exit | Notes |
|--------|------|-------|
| `AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse.SliceTransport` | **0** | Green; sorry warnings only |
| `AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse` | **0** | Green; sorry warnings only |
| `AlgebraicJacobian.Picard.TensorObjSubstrate` | **0** | Green; unaffected |

## Declarations deleted / renamed

None deleted or renamed. All fully-qualified names are preserved:
- `AlgebraicGeometry.Scheme.Modules.sliceDualTransport` now lives in `SliceTransport.lean` (same namespace, new file path)
- `AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv` idem
- All other moved decls retain the same namespace and fully-qualified name

The `archon-protected.yaml` file does not mention any of the moved declarations (confirmed), so no path update is needed.

## Notes for Plan Agent

1. **left_inv / right_inv** in `sliceDualTransport`: the `ext z` failure exposes that these goals have type `∀ x, ...` (the LinearEquiv field), not an equality directly. The correct opener is `intro x` then `ext` on the resulting equality. Once `sliceDualTransportInv.naturality` and `sliceDualTransport.toFun.naturality` are closed, `left_inv`/`right_inv` should be approachable with `intro x; apply PresheafOfModules.hom_ext; intro W` followed by a component-level calculation.

2. **naturality fields**: Both `sliceDualTransportInv.naturality` and `sliceDualTransport.toFun.naturality` are the same thin-poset ε-naturality problem (erw-level paste mirroring `homLocalSection.naturality`). The `analogies/dualnat006.md` analogy file is the intended guide for the next prover pass.

3. **File path for prover assignment**: Both sorry'd fields now live in `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse/SliceTransport.lean`, not in `DualInverse.lean`.
