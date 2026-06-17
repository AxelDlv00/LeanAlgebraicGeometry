# Blueprint Review: rescope008
**Iter:** 008
**Scope:** Fast-path re-review of `Picard_TensorObjSubstrate.tex` only.
**Verdict: HARD GATE CLEARED — both lanes may proceed.**

---

## Must-fix verification

All four must-fix items from bp008 are resolved.

### B1 (was must-fix): `hβ` hypothesis in `lem:slice_dual_transport_inv` ✅
- Lines 5028–5039: The compatibility identity
  `hβ : ∀ P, (β.app (op P)).hom ∘ (f.appIso P).hom.hom = id`
  is now stated verbatim as a displayed formula, labelled `hβ`, with prose explaining:
  (a) why it is needed (`restrictScalarsComp'App` step collapses two change-of-rings layers),
  (b) why it fails for a general `β`, and
  (c) the discharge at the unique call site via `Iso.hom_inv_id`.
- The `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv}` target exists in
  `SliceTransport.lean:354`.

### B2 (was minor): step-(b) naturality names ✅
- Lines 4763–4771 (in `lem:slice_dual_transport` forward proof): step-(b) naturality names
  `sliceDualTransport_naturality_apply`, `appIso_hom_naturality_apply`, and
  `dualUnitRingSwap_apply` explicitly. `restrictScalarsLaxε` no longer appears in any
  proof prose (line 491 occurrence is a marginal comment-only context, not proof text).

### B3 (was minor): 4th leg `unitRelabelSwap` in reverse formula ✅
- Lines 5004–5022: The reverse component formula lists `unitRelabelSwap (eqToHom he.symm)` as
  the 4th term (after `M.val(eqToHom)`, `restrictScalars (f.appIso P).hom .map ψ_…`, and
  `dualUnitRingSwapHom f P`), with a full explanatory paragraph on why the source relabel
  forces this unit-section mirror.

### `lem:sheafify_tensor_unit_iso_comp` `\uses{}` ✅
- Line 3052 (statement) and 3066 (proof): both `\uses{}` now include
  `lem:toringcatsheafhom_comp_hom_reconcile`, and the prose at line 3060 references it by
  name ("licenses the composite ring map").

---

## D3′ bricks re-confirmation

All 3 remain adequate for formalization:

- **`lem:sheafify_pullbackcomp_hom_inv_cancel`** (lines 3021–3046): Clear formula; proof via
  `Iso.hom_inv_id_app` + `Functor.map_comp`/`map_id`; `erw` splice note retained.
- **`lem:sheafify_tensor_unit_iso_comp`** (lines 3048–3074): Clear statement; proof via
  `lem:sheafify_tensor_unit_iso_hom_eq_prime` + bifunctoriality of `⊗` (interchange law);
  `\uses{}` now complete with reconcile lemma.
- **`lem:pullback_val_iso_comp`** (lines 3076–3109): Clear formula for `pullbackValIso` composition
  coherence; proof via Sq1 (`lem:sheafificationcomppullback_comp`) + counit naturality; `erw`
  carrier-mismatch note present.

---

## Per-chapter

### `Picard_TensorObjSubstrate.tex`
- **Complete:** true (for the two active lanes under prover work)
- **Correct:** true
- **Notes:** No new issues found. Open sorries in the Lean files are the expected in-progress
  state, not a gate failure.

---

## Severity summary

- **must-fix:** none remaining.
- **soon:** none.

---

## Dispatch verdict

**DUAL lane (`SliceTransport.lean`) and D3′ lane (`TensorObjSubstrate.lean`) may both be
dispatched to provers this iter.** The `lem:slice_dual_transport_inv` block is now adequate:
the `hβ` hypothesis is documented with formula and rationale, the reverse component formula
is complete (all 4 legs named), and the step-(b) naturality prose names the correct Lean lemmas.
The D3′ bricks remain well-specified.
