# blueprint-writer report — iter-235 — slug `d2-linmap`

## Outcome: DONE

Added exactly ONE new lemma block to
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, the stage-(iii) `\lean{}` pin for
`PresheafOfModules.stalkTensorLinearMap`.

## Placement
Inserted immediately AFTER the `\end{lemma}` of `lem:stalk_tensor_desc_forward`
(was ~line 2036) and BEFORE the `\begin{lemma}` of
`lem:islocallyinjective_whiskerleft_via_stalk`. Block now occupies the gap between them.

## Block contents (as directed)
- NO `\leanok` marker added. The directive explicitly reserves `\leanok`/`\mathlibok` for
  the `sync_leanok` phase ("the `sync_leanok` phase has nothing to mark when stage (iii)
  closes"), so the new block is left unmarked for sync_leanok to mark. (The block thus
  intentionally differs from the sibling `lem:stalk_tensor_desc_forward`, which already
  carries `\leanok` from a prior sync.)
- Human name: `[\(R_x\)-linear stalk--tensor comparison map (d.2, stage (iii))]`
- `\label{lem:stalk_tensor_linear_map}`
- `\lean{PresheafOfModules.stalkTensorLinearMap}`
- `\uses{def:scheme_modules_tensorobj, lem:stalk_tensor_desc_forward, lem:stalk_linear_map}`
- Statement prose: upgrade of `stalkTensorDesc` to an `R.stalk x`-linear map
  `(A ⊗ᵖ B).stalk x →ₗ A.stalk x ⊗ B.stalk x`; agrees on underlying additive maps; germ-of-
  simple-tensor characterisation `germ_x(a⊗b) ↦ germ_x a ⊗ germ_x b`; identified as the
  stage-(iii) landing and direct input to stage (iv) (reverse map); one line on the
  CommRingCat/RingCat carrier-duality bridge `stalkTensorDescU_smul`; mention of the
  `@[simp]` germ-tmul characterisation `stalkTensorLinearMap_germ_tmul` used in the
  stage-(v) inversion check.
- NO `\begin{proof}` (statement-only pin, as directed).
- NO `% SOURCE` / `% SOURCE QUOTE` lines (Archon-original partial-construction block).

## Out-of-scope items — untouched (confirmed)
- `\lean{PresheafOfModules.stalkTensorIso}` pin + its `% NOTE: forward-looking` annotations
  on `lem:stalk_tensor_commutation` — left as-is.
- No other block, no dead duplicate whisker lemma, no route-(e) apparatus touched.
- No `\leanok`/`\mathlibok` added or removed anywhere (new block left unmarked for sync_leanok).
- No Lean tactic syntax in prose.
