# Blueprint-writer directive — iter-235 — add the stage-(iii) `\lean{}` pin block

## Chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Scope (narrow — ONE new lemma block, no other edits)

The iter-234 lean-vs-blueprint check flagged one major blueprint-side gap: the stage-(iii)
deliverable of `lem:stalk_tensor_commutation`, the Lean declaration
`PresheafOfModules.stalkTensorLinearMap` (now built, axiom-clean), has **no standalone
`\lean{}`-pinned lemma block**, whereas the stages-(i)–(ii) forward map `stalkTensorDesc`
does (`lem:stalk_tensor_desc_forward`, currently at ~line 2013–2036). Without a dedicated
block, the `sync_leanok` phase has nothing to mark when stage (iii) closes, and a prover
navigating the chapter cannot jump to the stage-(iii) target.

## Action

Add ONE new lemma block immediately AFTER the existing `lem:stalk_tensor_desc_forward` block
(after its `\end{lemma}`, ~line 2036) and BEFORE the `lem:islocallyinjective_whiskerleft_via_stalk`
block (~line 2038). Model it exactly on the `lem:stalk_tensor_desc_forward` block's shape (it is an
Archon-original partial-construction block, so NO `% SOURCE`/`% SOURCE QUOTE` citation lines — it is
derived from the same Stacks lemma already cited on `lem:stalk_tensor_commutation`).

Required content of the new block:
- Label: `\label{lem:stalk_tensor_linear_map}`
- Lean pin: `\lean{PresheafOfModules.stalkTensorLinearMap}`
- `\uses{def:scheme_modules_tensorobj, lem:stalk_tensor_desc_forward, lem:stalk_linear_map}`
- Human name in brackets, e.g. `[R_x-linear stalk--tensor comparison map (d.2, stage (iii))]`
- Statement prose (project notation): with `R, A, B, x` as in `lem:stalk_tensor_commutation`, the
  additive forward map `stalkTensorDesc` of `lem:stalk_tensor_desc_forward` upgrades to an
  `R.stalk x`-LINEAR map
  `stalkTensorLinearMap : (A ⊗ᵖ B).stalk x →ₗ[R.stalk x] A.stalk x ⊗_{R.stalk x} B.stalk x`,
  agreeing with `stalkTensorDesc` on underlying additive maps (so still characterised on germs of
  simple tensors by `germ_x(a⊗b) ↦ germ_x a ⊗ germ_x b`). State that this is the stage-(iii) landing
  and the direct input to stage (iv) (the reverse map); mention in one line that the linearity check
  passes through the CommRingCat/RingCat carrier-duality bridge (`stalkTensorDescU_smul`) described in
  stage (iii) of the `lem:stalk_tensor_commutation` proof, and that `stalkTensorLinearMap_germ_tmul` is
  the `@[simp]` germ-tmul characterisation used downstream in the stage-(v) inversion check.

Do NOT give this block its own `\begin{proof}` — like `lem:stalk_tensor_desc_forward`, it is a
statement-only pin whose construction is narrated in stages (i)–(iii) of the
`lem:stalk_tensor_commutation` proof.

## Out of scope
- Do NOT touch the `\lean{PresheafOfModules.stalkTensorIso}` pin on `lem:stalk_tensor_commutation`
  (it already carries correct `% NOTE: forward-looking pin, NOT YET BUILT` annotations — leave them).
- Do NOT touch any other block, the dead duplicate whisker lemma, or the route-(e) apparatus.
- Do NOT add or remove any `\leanok` / `\mathlibok` marker (managed by sync_leanok / review).
- No Lean tactic syntax in prose.
