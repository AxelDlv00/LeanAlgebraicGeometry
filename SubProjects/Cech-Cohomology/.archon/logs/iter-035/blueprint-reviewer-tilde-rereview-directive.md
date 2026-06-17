# Blueprint-reviewer directive — iter-035 fast-path scoped re-review

SCOPE: re-review the single block `lem:tilde_preserves_kernels` in
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (around L4327–4445) ONLY. This is a same-iter
fast-path re-confirmation after the planner addressed your iter-035 must-fixes on this block. You still read
whatever surrounding context you need, but your verdict is needed only for this one block.

## What was must-fixed (your iter-035 report §2, §6)
1. `\lean{}` gap — the two iter-034 helpers `tilde_stalkFunctor_map_toStalk` and
   `tildePreservesFiniteLimits_of_toPresheaf` were MISSING from the `\lean{}` list. **Now added.**
2. Proof-sketch gaps — three sub-steps were missing. **Now added** as an explicit itemized
   "Mechanization remarks" list at the end of the proof:
   - (A) the stalk comparison is R_𝔭-linear (germ-naturality via the linear germ + the helper
     `tilde_stalkFunctor_map_toStalk`), identified with the localised map (injectivity =
     `tilde_toStalk_map_injective`);
   - (B) stalkwise-iso ⟹ sheaf-iso via the jointly-reflecting stalk family (reduce to the underlying
     abelian presheaf; ModuleCat-stalk path noted dead);
   - (C) reduction to the underlying abelian-presheaf composite via `tildePreservesFiniteLimits_of_toPresheaf`.
   Lean helper names are carried in `% NOTE` comments (non-rendering); the rendered prose states the
   mathematical content.

## Your task
Return a crisp verdict for `lem:tilde_preserves_kernels`:
- `complete`: true/false (statement + `\lean{}` + proof sketch at formalize-level detail for the REMAINING build)
- `correct`: true/false
- any remaining must-fix on THIS block.

If `complete: true` AND `correct: true` with no must-fix, the gate is satisfied and the planner dispatches the
TildeExactness prover this iter. If not, name precisely what still blocks.
