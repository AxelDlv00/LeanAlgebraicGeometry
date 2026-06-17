Target: blueprint/src/chapters/Picard_TensorObjSubstrate.tex — `lem:slice_dual_transport_inv` block ONLY (lines ~4960–5031) + its surrounding naturality prose (~4748–4779).

Action: align the blueprint prose with the actual Lean API. Three fixes:

1. **B1 (must-fix).** `sliceDualTransportInv`'s Lean signature carries an extra compatibility
   hypothesis the prose omits. After the reverse-component formula (~line 5008) add a sentence:
   the construction requires `β` to satisfy `hβ : ∀ P, (β.app (op P)).hom ≫ (f.appIso P).hom.hom = id`
   (the double-restrict `restrictScalarsComp'App` collapse needs it; it is FALSE for arbitrary β,
   and is discharged at the call site via `Iso.hom_inv_id` when β is the open-immersion structure map).
   State it as an explicit hypothesis the lemma takes.

2. **B2 (minor).** Prose at lines ~4771–4779 still says step (b)'s naturality is supplied by the
   natural transformation `PresheafOfModules.restrictScalarsLaxε`. This is wrong/unused. Rewrite to:
   naturality is delivered by the extracted lemma `sliceDualTransport_naturality_apply`, which closes
   the module-map square pointwise via `appIso_hom_naturality_apply` and `dualUnitRingSwap_apply`.
   (Leave the unrelated `\lean{}` pin of `lem:restrictscalars_laxmonoidal` at line ~5572 untouched.)

3. **B3 (minor).** The reverse component formula (~lines 5007–5013) lists 3 legs; add the missing 4th
   leg `unitRelabelSwap (eqToHom he.symm)` transporting the codomain unit across the cross-fiber relabel.

Also: in `lem:sheafify_tensor_unit_iso_comp`, add `lem:toringcatsheafhom_comp_hom_reconcile` to the
PROOF block `\uses{}` (already in the statement block).

Constraints: edit ONLY this chapter. Mathematical/API prose only. Do NOT add or remove `\leanok`.
Do NOT touch the D3′ brick blocks' math (reviewer judged them adequate) beyond the one `\uses{}` line above.
