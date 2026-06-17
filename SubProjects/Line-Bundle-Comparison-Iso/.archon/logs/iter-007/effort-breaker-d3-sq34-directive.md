# Effort-breaker directive — decompose the D3′ Sq3/Sq4 residual

## Target
`lem:pullback_tensor_map_basechange` (`AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict`,
`TensorObjSubstrate.lean` ~L3144). Chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.

## Granularity
One level — split the residual into named sub-lemmas, each with its own statement, informal proof,
and `\uses`. Do NOT touch the already-closed parts of the proof.

## Proof structure (from the iter-006 prover task result — the residual after `erw [hδ]`)
The decl is sorry-free EXCEPT the final paste, whose residual is a 4-square interleave. The first two
squares are CLOSED (Sq2/Sq2b via `pullbackComp_δ`/`hδ`, committed `erw [hδ]`). The remaining residual:
- **(i) hom/inv cancellation**: cancel `aZ.map (PrPbComp.hom.app (M⊗N)) ≫ aZ.map (pb.inv.app (M⊗N))`.
  Documented route: build the cancellation as a standalone equation via `Iso.hom_inv_id_app` +
  `congrArg aZ.map` (the proven `hδ` technique), then splice with `erw`. → make this sub-lemma L_cancel.
- **(ii) Sq3** — the `sheafifyTensorUnitIso` composition coherence (the sheafified tensor-unit
  comparison square). Currently has no project lemma. → sub-lemma L_Sq3.
- **(iii) Sq4** — the `pullbackValIso` composition coherence. Per the blueprint it is a corollary of
  Sq1 (`sheafificationCompPullback_comp`, now CLOSED) + counit naturality. → sub-lemma L_Sq4.
- **(iv)** δcomp split via `Functor.OplaxMonoidal.comp_δ` (mechanical) — fold into the final assembly
  step, name it L_assemble.

For each sub-lemma give: `\label`, a `\lean{}` pin (the name the prover will create), an accurate
`\uses{}` (Sq4 \uses lem:sheafificationcomppullback_comp; L_cancel \uses the relevant Iso), and a
1–3 sentence informal proof. All cross-elaboration rewrites in this region need `erw` (carrier-spelling
instance mismatch) — note that in the relevant proof sketches. Recipe context: `analogies/d3cocycle006.md`.

## Constraints
- Edit ONLY the `lem:pullback_tensor_map_basechange` block + insert the new sub-lemma blocks before it.
- Do NOT add `\leanok`. You MAY add `\mathlibok` only on a genuine Mathlib anchor (none expected here).
- Preserve the existing `% SOURCE`/`% SOURCE QUOTE` citation discipline if you split a sourced block.
