# Blueprint Reviewer Directive

## Slug
init-bp

## Strategy snapshot

Goal: comparison-isomorphism substrate on line bundles (A.1.c.sub). Three seeds +
108-node cone, zero `sorry`, kernel-only axioms:
- `lem:pullback_tensor_iso_loctriv` — `Modules.pullbackTensorIsoOfLocallyTrivial` (D3′)
- `lem:dual_isLocallyTrivial` — `Modules.dual_isLocallyTrivial` (DUAL)
- `thm:rel_pic_addcommgroup_via_tensorobj` — `PicSharp.addCommGroup_via_tensorObj` (consumer)

### Phases & estimations
| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|-------|--------|-----------|-----|-------------------|-------|
| D3′ comparison iso (`TensorObjSubstrate.lean`) | ACTIVE | ~3–5 | ~120–300 | `Adjunction.Mates.conjugateEquiv_whiskerLeft`, sheafification | Sq1 mate-calculus |
| DUAL dual-inverse (`DualInverse.lean`) | ACTIVE | ~3–5 | ~100–250 | `PresheafOfModules.restrictScalarsLaxε`, `leftAdjointUniq` | `dual_restrict_iso` Step-4 naturality |
| Consumer assembly (`RelPicFunctor.lean`) | BLOCKED | ~1–2 | ~30–80 | — | gated on both routes |

## Routes
- **D3′** — comparison iso `f^*(M⊗N)≅f^*M⊗f^*N` on loc-triv pairs; chapter
  `Picard_TensorObjSubstrate.tex`. Remaining: Sq1 (`sheafificationCompPullback_comp_tail`),
  `pullbackTensorMap_restrict`, D4′ chart-chase.
- **DUAL** — `exists_tensorObj_inverse` via `sliceDualTransport`/`dual_restrict_iso`;
  chapter `Picard_TensorObjSubstrate.tex` (covers DualInverse.lean too — confirm).

## References
- `references/stacks-modules.md` → tag 01CR §17.25 invertible modules; backs the
  invertibility / tensor-object / dual content in `Picard_TensorObjSubstrate.tex`.
- `references/kleiman-picard.md` → relative Picard sheaf; backs `Picard_RelPicFunctor.tex`.

## Focus areas
- Whether `Picard_TensorObjSubstrate.tex` (huge, 347KB) carries complete+correct,
  prover-ready coverage for the 6 open sorries: `sliceDualTransport`,
  `sliceDualTransportInv`, `dual_restrict_iso`, `sheafificationCompPullback_comp_tail`,
  `pullbackTensorMap_restrict`, `exists_tensorObj_inverse`.
- Confirm the chapter↔file mapping: does `Picard_TensorObjSubstrate.tex` declare a
  `% archon:covers` line for `DualInverse.lean`, `StalkTensor.lean`,
  `PresheafInternalHom.lean`, `Vestigial.lean`? The HARD GATE needs to know which
  chapter gates `DualInverse.lean`.
- Frontier-ready nodes to validate as prover-dispatchable:
  `lem:pullback_compatible_with_tensorobj`, `lem:pullback_tensor_iso_loctriv`,
  `lem:slice_dual_transport_inv`, `lem:sheafificationcomppullback_comp_tail`.

## Known issues
- 91 Lean decls have no blueprint entry (`leandag unmatched`) — coverage debt.
  List the most load-bearing of these (those in the seed cone) so I can prioritise
  authoring blueprint blocks; do not enumerate all 91.
- STRATEGY.md was just restructured to the canonical skeleton this iter.
