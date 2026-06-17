# Lean Auditor Directive

## Slug
iter205

## Scope (files)
all

## Focus areas
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — received the only prover
  edit this iter (two new `noncomputable def`s in a project-local Mathlib
  supplement section near the end of the file, plus four pre-existing typed
  `sorry` bodies). Pay extra attention to: whether the two new declarations are
  honest infrastructure or disguised placeholders; whether the four `sorry`
  bodies carry any excuse-comment laundering; whether `@[implicit_reducible]`
  on the two `noncomputable def`s is sound Lean.
- `AlgebraicJacobian/Picard/RelPicFunctor.lean` — a prior audit flagged
  line ~330 (`PicSharp := const PUnit`) as a weakened-wrong definition with an
  excuse-comment. Re-confirm whether that finding is still live.

## Known issues
- The four `sorry` bodies in `TensorObjSubstrate.lean` (`monoidalCategory` L150,
  `tensorObj_restrict_iso` L249, `exists_tensorObj_inverse` L300,
  `addCommGroup_via_tensorObj` L339) are KNOWN scaffold typed-sorries from the
  Lane TS body-fill effort — report them, but they are not a new regression.
  What is genuinely useful is your read on whether any comment around them
  overstates closure.
