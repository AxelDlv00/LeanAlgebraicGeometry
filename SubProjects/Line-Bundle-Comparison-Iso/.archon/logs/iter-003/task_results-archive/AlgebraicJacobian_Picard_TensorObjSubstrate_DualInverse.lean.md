## Result

Partial progress.

## Completed

- Added and proved `Scheme.Modules.dualUnitRingSwap_apply`, identifying the underlying map of
  `dualUnitRingSwap f W'` with `(Scheme.Hom.appIso f W').hom.hom`.
- Strengthened the forward `sliceDualTransport.naturality` hole from a bare `sorry` to a typed
  partial proof: it constructs the induced over-morphism `i` and records `φ.naturality i.op`.

## Remaining gaps

- `sliceDualTransportInv.naturality` remains open.
- `sliceDualTransport.naturality` remains open. The pointwise paste is clear:
  use `hφ`, rewrite the unit swaps with `dualUnitRingSwap_apply`, apply
  `Scheme.Hom.appIso_inv_naturality`, then cancel `hom ≫ inv`. A full in-structure proof was
  tested and closed locally, but made later fields in the monolithic `LinearEquiv` exceed
  heartbeat limits.
- `sliceDualTransport.left_inv` and `sliceDualTransport.right_inv` remain open.

## Needs blueprint entry

- `Scheme.Modules.dualUnitRingSwap_apply`

## Verification

- `lake env lean AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` completed
  successfully, with the expected `sorry` warnings.
