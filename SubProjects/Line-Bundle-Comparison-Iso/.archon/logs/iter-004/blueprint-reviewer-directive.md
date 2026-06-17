# Blueprint Reviewer Directive

## Slug
iter-004-blueprint-review

## Strategy snapshot

Goal: build the comparison-isomorphism substrate on line bundles for the A.1.c.sub cone, with the three seed deliverables `lem:pullback_tensor_iso_loctriv`, `lem:dual_isLocallyTrivial`, and `thm:rel_pic_addcommgroup_via_tensorobj`.

Active phases:

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|-------|--------|-----------|-----|-------------------|-------|
| D3′ comparison iso (`TensorObjSubstrate.lean`) | ACTIVE | ~3–5 | ~120–300 | `CategoryTheory.conjugateEquiv` (Mates) + project `_whiskerLeft` helper to build; sheafification adjunction | Sq1 mate-calculus is the hard step; D4′ chart-chase after |
| DUAL dual-inverse (`DualInverse.lean`) | ACTIVE | ~3–5 | ~100–250 | `PresheafOfModules.restrictScalarsLaxε`, `leftAdjointUniq` | `dual_restrict_iso` Step-4 `isoMk` naturality chase |
| Consumer assembly (`RelPicFunctor.lean`) | BLOCKED | ~1–2 | ~30–80 | — | gated on both routes closing (`exists_tensorObj_inverse`) |

## Routes

Single project route family with two active proof lanes:
- D3′ comparison iso in `TensorObjSubstrate.lean`
- DUAL dual-inverse in `DualInverse.lean`
- Consumer assembly in `RelPicFunctor.lean` is downstream and blocked on both.

## References

- `references/summary.md`: `challenge.lean.ref`, `stacks-modules.md`, `kleiman-picard.md`, `fga-explained.md`

## Specific concerns

- Audit the chapters modified in this worktree: `Picard_TensorObjSubstrate.tex`, `Picard_LineBundlePullback.tex`, and `Picard_RelPicFunctor.tex`.
- Check whether the new chapter prose/proof sketches still match the current Lean file state and whether any `\uses{}` edges need tightening after the recent rewiring.
- Check whether the blueprint still provides enough detail for the D3′/DUAL lanes without overpromising the scaffold targets.
