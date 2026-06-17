# Lean ↔ Blueprint Checker Directive

## Slug
tensorobj

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Known issues
- `exists_tensorObj_inverse` (~L715) and the `PicSharp` `addCommGroup` (~L1227) are known pre-existing
  `sorry` bodies (deferred dual-bridge / group-law plumbing); do not re-report as new placeholders.
- This iter added two new instances `presheafPushforwardLaxMonoidal` and `presheafPullbackOplaxMonoidal`
  (presheaf-level lax pushforward / oplax pullback comparison `δ`). They are supporting infrastructure NOT
  currently pinned by any `\lean{...}` block in the chapter. Report whether the chapter SHOULD add
  `\lean{}`-pinned blocks for them, and whether `lem:pullback_tensor_iso` / `lem:isinvertible_pullback`
  remain accurately described as unformalized (they were NOT closed this iter — blocked on a Mathlib-absent
  concrete inverse-image functor).
- The blueprint chapter may be a consolidated chapter covering several files via `% archon:covers`; focus
  on the parts of the chapter that map to this file.
