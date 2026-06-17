# Blueprint Review: bp008
**Iter:** 008

## Top-level summaries

- **Incomplete**: `Picard_TensorObjSubstrate.tex` (6 `unmatched_lean`: D3′ 3 bricks + D3′ primary goal + consumer + `lem:pullback_compatible_with_tensorobj`; DUAL 4 open sorries); `Picard_RelPicFunctor.tex` (presheaf+sheaf sections are placeholder bodies per NOTE comments, gated on upstream substrate).
- **Bad Lean targets (unmatched)**: `lem:sheafify_pullbackcomp_hom_inv_cancel` → `sheafifyMap_pullbackComp_hom_inv_id`, `lem:sheafify_tensor_unit_iso_comp` → `sheafifyTensorUnitIso_comp`, `lem:pullback_val_iso_comp` → `pullbackValIso_comp`, `lem:pullback_tensor_iso_loctriv` → `pullbackTensorIsoOfLocallyTrivial`, `thm:rel_pic_addcommgroup_via_tensorobj` → `PicSharp.addCommGroup_via_tensorObj`, `lem:pullback_compatible_with_tensorobj` → `LineBundle.OnProduct.pullback_tensorObj_iso` (all forward-referenced unproved targets, not renames; documented by `% NOTE:` in last case).
- **Deps/Isolated**: 97 isolated nodes — all `lean_aux`, 0 blueprint. Disposition: **keep** (coverage debt, scheduled in Coverage+cleanup phase). `unknown_uses: []` — no broken `\uses{}` labels.
- **Rendering**: `archon blueprint-doctor --json` clean — no `malformed_refs`, no `broken_refs`, no orphan chapters, no axiom decls, no covers problems.

---

## Hard-gate findings for `Picard_TensorObjSubstrate.tex`

### D3′ bricks — assessment: ADEQUATE FOR FORMALIZATION

**lem:sheafify_pullbackcomp_hom_inv_cancel** (lines 3021–3046):
- Statement: `a_Z.map(PrPbComp.hom.app T) ; a_Z.map(PrPbComp.inv.app T) = id`. Precise.
- Proof: `Iso.hom_inv_id_app` → identity; `Functor.map_comp` + `Functor.map_id` collapse. Minimal and self-contained.
- `\uses{}`: none (correct — only Mathlib primitives, no project labels consumed).
- `\lean{sheafifyMap_pullbackComp_hom_inv_id}`: well-named, consistent with project convention.
- **Verdict: adequate**.

**lem:sheafify_tensor_unit_iso_comp** / Sq3 (lines 3048–3076):
- Statement: `sheafifyTensorUnitIso` of composite `h∘f` equals transported interleave of `f` and `h` instances.
- Proof: reduce hom-legs via `lem:sheafify_tensor_unit_iso_hom_eq_prime` to `a.map(tensorHom(η⊗η))`; composite-vs-interleaved = `a_Z.map` of η-naturality against `PrPbComp`; bifunctoriality interchange recombines; `erw` for `Sheaf.val Z` carrier mismatch. Adequate.
- `\uses{}` statement: `def:sheafify_tensor_unit_iso, lem:sheafify_tensor_unit_iso_hom_eq_prime, lem:toringcatsheafhom_comp_hom_reconcile`. Proof block omits `lem:toringcatsheafhom_comp_hom_reconcile` (used to license composite ring map at statement level). Minor inconsistency — non-blocking.
- **Verdict: adequate**.

**lem:pullback_val_iso_comp** / Sq4 (lines 3078–3111):
- Statement: `pullbackValIso(h∘f) = (pullbackComp h f)_M ; h*(pullbackValIso f) ; pullbackValIso h (f*M)`.
- Proof: substitute definition `pullbackValIso = sheafCompPb^{-1} ; counit`; `sheafCompPb^{-1}` parts reassemble by `lem:sheafificationcomppullback_comp` (Sq1 twin); counit parts by pseudofunctoriality/naturality across `pullbackComp h f`; `erw` for carrier mismatch. Adequate.
- `\uses{}`: `def:pullback_val_iso, lem:sheafificationcomppullback_comp`. Matches proof. ✓
- **Verdict: adequate**.

### DUAL block — lem:slice_dual_transport_inv — MUST-FIX B1 CONFIRMED

**B1 (major — must-fix):** Blueprint lines 4978–4992 describe `sliceDualTransportInv` as taking `f, M, V, β, ψ` with `β` fixed as "the open-immersion structure-ring morphism". The Lean signature additionally requires:
```lean
(hβ : ∀ (P : Opens Y), ((β.app (op P)).hom).comp ((Scheme.Hom.appIso f P).hom.hom) = RingHom.id _)
```
This `hβ` is logically essential (the Lean comment notes it is "FALSE for an arbitrary β") and is discharged at the call site via `Iso.hom_inv_id`. A DUAL prover reading the blueprint cannot arrive at the correct Lean API. **Blueprint must document this parameter.**

**B2 (minor — stale prose, partially addressed):** A correcting `% NOTE: (corrected iter-007)` was added at line 4764 in iter-007, acknowledging that step (b) is delivered NOT by `restrictScalarsLaxε` but by `sliceDualTransport_naturality_apply`. However, the prose at lines 4771–4779 was NOT updated — it still reads "supplied by the natural transformation `PresheafOfModules.restrictScalarsLax`ε". A prover reading the prose (not the NOTE) gets wrong guidance. Writer must update prose to reference `sliceDualTransport_naturality_apply` + `appIso_hom_naturality_apply` + `dualUnitRingSwap_apply`.

**B3 (minor):** Reverse component formula at lines 5007–5013 lists 3 legs (`M.val(eqToHom)`, `restrictScalars(f.appIso P).hom.map(ψ...)`, `dualUnitRingSwapHom f P`) but omits the 4th leg `unitRelabelSwap(eqToHom he.symm)` which transports the codomain unit across the cross-fiber relabel. Blueprint description is incomplete (confirmed by prior checker iter-007 B3, still live).

---

## Per-chapter

### `Picard_LineBundlePullback.tex`
- **Complete**: true
- **Correct**: true
- All 3 declarations (`def:line_bundle_on_product`, `def:pullback_along_projection`, `thm:relative_pic_quotient_well_defined`) have `\leanok` statement + proof. `\uses{}` chain accurate per internal-consistency section. Citations present with verbatim source quotes.

### `Picard_RelPicFunctor.tex`
- **Complete**: partial
- **Correct**: true
- `lem:rel_pic_sharp_groupoid` has `\leanok` (both statement and proof); realized as loc-triv iso-class picCommGroup (NOTE iter-247 explains carrier caveat).
- Presheaf section (`rel_pic_sharp`) and étale-sheaf section carry placeholder bodies per NOTE comments (iter-199); blocked on D3′+DUAL. Do NOT promote to `\leanok` until carrier corrected.
- `\uses{}` in proof of `lem:rel_pic_sharp_groupoid` lists `lem:pullback_tensor_iso_loctriv` (the D3′ goal, currently `unmatched_lean`) — correct dependency declaration but target unproved.
- `\lean{}` hints present for all 6 items; the 5 beyond `addCommGroup` are forward references.

### `Picard_TensorObjSubstrate.tex`
- **Complete**: partial
- **Correct**: partial (B1 must-fix, B2 stale prose)
- **Notes**:
  - 108/116 blueprint nodes proved; 4 open sorries in DUAL (SliceTransport.lean); 6 `unmatched_lean` targets.
  - `unknown_uses: []` — all `\uses{}` labels resolve. No broken dependency edges.
  - D3′ bricks (3) and primary goal `lem:pullback_tensor_iso_loctriv` are new unproved forward targets; `lem:pullback_compatible_with_tensorobj` likewise; `thm:rel_pic_addcommgroup_via_tensorobj` likewise. All are normal "unformalized" state, documented.
  - `lem:slice_dual_transport_inv` blueprint is inadequate (B1 missing `hβ`, B2 stale prose, B3 missing 4th leg).
  - `leandag stats: Needs \leanok: 2` — 2 blueprint nodes with existing proved Lean target not yet synced. Normal; handled by `sync_leanok` phase.
  - `restrictScalarsLaxε` still appears at line 5572 as a `\lean{}` pin (for a separate lemma `lem:restrictscalars_laxmonoidal`); this is NOT stale — it names the correct Lean helper for that lemma. Not a B2 recurrence.

---

## Isolated nodes (leandag)

`leandag stats: Isolated (no edges): 97 (0 blueprint)` — all 97 are `lean_aux`. Per instructions: **keep** (these are uncovered Lean helpers, a "needs a blueprint entry" signal already scheduled in the Coverage+cleanup phase, non-blocking). No blueprint isolated nodes.

---

## Unstarted-phase proposals

None. All four strategy phases have blueprint coverage:
- **DUAL** → `Picard_TensorObjSubstrate.tex` (partial; B1 must-fix blocks prover dispatch)
- **D3′** → `Picard_TensorObjSubstrate.tex` (adequate for D3′ section)
- **Coverage+cleanup** → no chapter needed (tex/private work)
- **Consumer assembly** → `Picard_RelPicFunctor.tex`

---

## Severity summary

- **must-fix (blocks DUAL hard-gate)**: `Picard_TensorObjSubstrate.tex` — `lem:slice_dual_transport_inv` missing `hβ` hypothesis (B1); stale prose still references `restrictScalarsLaxε` natTrans despite correcting NOTE (B2). Dispatch blueprint-writer to fix B1+B2+B3 before DUAL prover.
- **hard-gate verdict**: Chapter `correct: partial` → gate NOT satisfied as-is. D3′ section is adequate; DUAL section has must-fix. **Fast-path available**: dispatch blueprint-writer for DUAL section → re-review scoped to DUAL → if cleared, DUAL prover may proceed same iter. D3′ prover may be dispatched if plan agent invokes fast-path scoped to D3′ files (TensorObjSubstrate.lean, not SliceTransport.lean).
- **soon (non-blocking)**: `lem:sheafify_tensor_unit_iso_comp` proof block misses `lem:toringcatsheafhom_comp_hom_reconcile` in `\uses{}` (present in statement block; fix at next writer pass). `lem:pullback_compatible_with_tensorobj` proof sketch thin (affine-cover argument gestured; adequate but could detail the gluing step). Coverage debt: 97 lean_aux isolated nodes need blueprint entries (scheduled).
