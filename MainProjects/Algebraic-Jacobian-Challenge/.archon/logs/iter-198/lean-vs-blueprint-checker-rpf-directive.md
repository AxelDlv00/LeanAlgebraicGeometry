# lean-vs-blueprint-checker — RelPicFunctor (slug rpf-iter198)

## File

`AlgebraicJacobian/Picard/RelPicFunctor.lean`

## Blueprint chapter

`blueprint/src/chapters/Picard_RelPicFunctor.tex`

## Context (minimal — only what bears on file vs chapter)

iter-198 committed 5 source-level sorry closures (L287, L328, L373,
L433, L482) and renamed `etSheafUnit` → `etSheaf_group_structure`
to match a blueprint pin. The prover's own task report calls the
closures "placeholder" because the `addCommGroup` instance at L235
is still a `sorry`, so the quotient's group operations are not
concrete and the math-correct functor bodies cannot be discharged.
Each closure was filled with `(Functor.const _).obj
(AddCommGrpCat.of PUnit)`, `0` (zero hom), or `⟨0⟩` (zero natural
transformation), instead of the intended `Quotient (preimage_subgroup
...)` / pullback adjunction / sheafification.

`PicSharp.functorial` has axiom set
`{propext, sorryAx, Classical.choice, Quot.sound}` — `sorryAx` from
the `addCommGroup` typeclass leak — while the other 4 closures show
the kernel-only triple.

## Questions to answer

Bidirectional check:

- **Lean → blueprint**: do the placeholder closures cause a
  signature/semantics drift relative to the chapter? Specifically:
  - `def:rel_pic_sharp` (`PicSharp`): chapter says "on objects `T`,
    `Pic^♯_{X/S}(T) := Pic(X ×_S T) / Pic(T)`". Lean body uses
    constant `PUnit`. Is the signature still the SAME functor type
    (so iter-199+ can swap the body without signature edits), or
    does the placeholder change the functor's *type*?
  - `lem:rel_pic_sharp_functorial`: chapter expects a group
    homomorphism between quotients. Lean body is the zero map.
    Same question.
  - `thm:rel_pic_sharp_presheaf`, `def:rel_pic_etale_sheafification`,
    `thm:rel_pic_etale_sheaf_group_structure`: same question.
- **Blueprint → Lean**: does the chapter clearly note that the
  current Lean closures are placeholders gated on `addCommGroup`?
  Or does the chapter present the proof as complete (which would
  be misleading once sync_leanok adds `\leanok` to the proof
  block)?

## What to flag

- If the placeholder closures collapse the functor to a *different
  mathematical object* (e.g. the constant PUnit functor is NOT a
  reparameterization of `Pic^♯` but a strictly weaker structure),
  flag as must-fix-this-iter.
- If `\leanok` was added by sync_leanok to a proof block whose body
  is a placeholder, flag as must-fix-this-iter (semantic
  laundering).
- If gate annotations in either the chapter or the Lean file still
  reference `LineBundle.OnProduct` (closed iter-188) as the
  blocker, flag (the actual blocker is the tensor-product
  `AddCommGroup` on `Scheme.Modules` upstream Mathlib gap).
- Standard pin / signature / docstring drift checks.

## Files to read

Read the WHOLE Lean file and the WHOLE blueprint chapter. Both are
moderate in size.
