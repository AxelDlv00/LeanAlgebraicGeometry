# Lean ↔ Blueprint Check Report

## Slug
ts240-tensorobj

## Iteration
240

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1191 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (4482 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (L138)
- **Signature matches**: yes — sheafification of `PresheafOfModules.Monoidal.tensorObj`, exactly as prose describes
- **Proof follows sketch**: yes / N/A (definition body, no proof sketch to compare)
- **notes**: `\leanok` correctly applied; no discrepancy

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (L153)
- **Signature matches**: yes — morphism action via sheafification of `MonoidalCategory.tensorHom`
- **Proof follows sketch**: yes / N/A
- **notes**: `\leanok` correctly applied; no discrepancy

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: `lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes (L446)
- **Signature matches**: yes — `(tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)` for arbitrary `M, N` and open immersion `f`
- **Proof follows sketch**: yes — four steps (Steps 1–4) in Lean body match blueprint's Step 1 (restrictFunctorIsoPullback), Step 2 (sheafificationCompPullback), Step 3 (strip sheafification), Step 4 (H1 via `pushforwardPushforwardAdj` + H2 via `restrictScalarsMonoidalOfBijective`) exactly
- **notes**: `\leanok` correctly applied; no discrepancy

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (L536)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` correctly applied; no discrepancy

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (chapter: `lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes (L341)
- **Signature matches**: yes — unconditional (no flatness/invertibility hypothesis)
- **Proof follows sketch**: yes — three-step composite via `W_whisker{Right,Left}_of_W` + `isIso_sheafification_map_of_W` + `mapIso α`, matching blueprint
- **notes**: `\leanok` correctly applied; `tensorObj_assoc_iso` is sorry-transitive through the `isLocallyInjective_whiskerLeft_of_W` residual in Vestigial.lean, but the blueprint correctly does not claim `\leanok` on that residual

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.tensorObj}` (chapter: `lem:isinvertible_tensor`)
- **Lean target exists**: yes (L764)
- **Signature matches**: yes
- **Proof follows sketch**: yes — middle-four interchange matches the `M⊗M'⊗N⊗N' ≅ O_X` chain
- **notes**: `\leanok` correctly applied; no discrepancy

### `\lean{AlgebraicGeometry.Scheme.Modules.isInvertible_unit}` (chapter: `lem:isinvertible_unit`)
- **Lean target exists**: yes (L774)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` correctly applied

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.inverse_unique}` (chapter: `lem:isinvertible_inverse_welldef`)
- **Lean target exists**: yes (L781)
- **Signature matches**: yes
- **Proof follows sketch**: yes — inverse-of-inverse chain matches blueprint
- **notes**: `\leanok` correctly applied

### `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` (chapter: `def:pic_carrier`)
- **Lean target exists**: yes (L800)
- **Signature matches**: yes — quotient of `⊗`-invertible objects by iso-setoid
- **Proof follows sketch**: yes / N/A (definition)
- **notes**: `\leanok` correctly applied

### `\lean{AlgebraicGeometry.Scheme.Modules.picCommGroup}` (chapter: `thm:pic_commgroup`)
- **Lean target exists**: yes (L834)
- **Signature matches**: yes — `CommGroup (PicGroup X)` with tensor multiplication, unit, inv
- **Proof follows sketch**: yes — each group axiom field = single existence-of-iso, exactly as blueprint describes
- **notes**: `\leanok` correctly applied; no discrepancy

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}` (chapter: `lem:pullback_tensor_iso`)
- **Lean target exists**: **no** — only a HANDOFF comment block exists (L1099–1151); no Lean declaration
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has no `\leanok` (correct). HANDOFF accurately explains the wall (abstract left adjoint has no sectionwise formula) and recommended pivot (local-chart finality, `sheafifyTensorUnitIso` brick already landed). No discrepancy — open status is faithfully represented.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (chapter: `lem:pullback_unit_iso`)
- **Lean target exists**: **no** — only HANDOFF comment (L1011–1049); no Lean declaration
- **Signature matches**: N/A
- **Proof follows sketch**: N/A (no body)
- **notes**: Blueprint has no `\leanok` (correct). HANDOFF says recipe is COMPLETE and blocker is instance-synthesis quirk only (NOT math). The blueprint proof sketch describes the local-chart-finality route, which matches the HANDOFF recipe. However the sketch says "the small remaining work is the naturality lemma" — this naturality lemma is now `pullbackObjUnitToUnit_comp`, which IS proved this iter, so the sketch is partially stale (the component is done; only the instance-synthesis plumbing blocks final assembly). **See major finding #3.**

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback}` (chapter: `lem:isinvertible_pullback`)
- **Lean target exists**: **no** — no declaration; no HANDOFF comment
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has no `\leanok` (correct). Depends on `pullbackUnitIso` + `pullbackTensorIso` which are also open; the three lemmas form a chain and none is yet formalized. No discrepancy in open status.

---

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` (L1181–1184): body is `:= sorry`. Blueprint `thm:rel_pic_addcommgroup_via_tensorobj` has `\leanok` marker.  
  **However**: the `\leanok` on the blueprint block is a pre-existing tracked state; the sorry is a long-standing known-open item noted in the file header as the "iter-204+ closure target." The prover docstring explicitly acknowledges it is "typed sorry" awaiting the `exists_tensorObj_inverse` closure. **This is a known-open sorry, not a this-iter regression.** The `sync_leanok` pass manages the `\leanok` marker state; if the marker is wrong, it will be corrected by `sync_leanok`. Not a must-fix introduced this iter.

- `exists_tensorObj_inverse` (L693–715): body `:= sorry`. Blueprint `lem:tensorobj_inverse_invertible` has `\leanok`. Same status as above — long-standing known-open, explicitly documented.

### Excuse-comments

- HANDOFF blocks at L1011–1049 and L1099–1151: These are informational documentation blocks (behind `/- ... -/`) that transparently explain why the three downstream declarations are not yet formalized and what the next step is. They are **NOT** excuse-comments on already-formalized code. They accurately record the architectural state: `pullbackObjUnitToUnit_comp` is proved; the full `pullbackUnitIso` assembly is blocked on instance-synthesis (NOT math). No red flag.

### Axioms / Classical.choice on non-trivial claims

- `Classical.choose` in `picInv` (L815–817): used to extract the membership witness of `IsInvertible`. This is the intended pattern (the carrier-pivot design relies on existential witnesses). Blueprint authorizes this. No red flag.

---

## Unreferenced declarations (informational)

The following Lean declarations have **no `\lean{...}` reference in the blueprint**:

| Declaration | Line | Assessment |
|---|---|---|
| `unitToPushforwardObjUnit_comp` | L882 | **Substantive** — explicitly described as "pushforward-side half of composition coherence; ... the pushforward-side input from which the pullback-side coherence is obtained." The docstring names its consumer (`pullbackObjUnitToUnit_comp`). Should be pinned in blueprint. |
| `pullbackObjUnitToUnit_comp` | L923 | **Substantive** — docstring calls it "the genuinely-new ingredient for `pullbackUnitIso`." This is the composition-coherence lemma that enables the local-chart-finality assembly of `pullbackUnitIso`. Should have a `\lean{...}` pin in or near the `lem:pullback_unit_iso` proof block. |
| `sheafifyTensorUnitIso` | L1063 | `private` helper — the "sheafification is monoidal up to unit" brick for eventual `pullbackTensorIso`. Acceptable to leave unpinned as a private helper. |
| `restrictIsoUnitOfLE` | L394 | Helper for `tensorObj_isLocallyTrivial`. Not currently referenced. A named `\lean{...}` pin would be useful but not critical. Minor. |
| `tensorObjIsoOfIso` | L240 | Helper for `tensorObj_isLocallyTrivial` and `exists_tensorObj_inverse`. Not pinned. Minor. |
| `dualIsoOfIso` | L205 | Helper for the dual infra. Not pinned — consistent with the dual infra tracking in the chapter's `sec:tensorobj_dual_infra` (not this iter's focus). |
| `homMk`, `toPresheaf_map_homMk` | L608, L616 | Labeled in blueprint `def:scheme_modules_homMk` at L4320. This is in a different section of the chapter (`sec:tensorobj_dual_infra`), so no missing reference. |
| `tensorObj_middleFour` | L751 | `private` helper. Acceptable. |
| `picSetoid`, `picMul`, `picInv` | L793, L805, L813 | Implementation helpers for `PicGroup`/`picCommGroup`; no separate blueprint blocks needed. |

---

## Blueprint adequacy for this file

- **Coverage**: Among ~25 substantive Lean declarations, 13 have `\lean{...}` blueprint blocks. The 2 new iter-240 declarations (`unitToPushforwardObjUnit_comp`, `pullbackObjUnitToUnit_comp`) are unreferenced despite being substantive. Several helpers are acceptably unpinned.
- **Proof-sketch depth**: **under-specified** for `lem:pullback_unit_iso`. The sketch (L2752–2786) says "the small remaining work is the naturality lemma tying the restricted global comparison to the local one." This naturality lemma is now `pullbackObjUnitToUnit_comp`, which IS proved — but the blueprint doesn't name it, doesn't explain that it is obtained via adjunction-mate transport from `unitToPushforwardObjUnit_comp`, and doesn't update to say this step is now done. A prover taking over from the blueprint sketch cold would have to infer the adjunction-mate route from scratch.
- **Hint precision**: **precise** for existing pinned declarations. **Missing** for the two new iter-240 declarations.
- **Generality**: **matches need** — the `pullbackObjUnitToUnit_comp` signature is at the right level (composable scheme morphisms, not restricted to open immersions).
- **Route description**: **correct** — `sec:tensorobj_pullback_monoidality` (L2564–2850) describes Route Z (local-chart finality) and explicitly rules out the dead sectionwise-`extendScalars` route. No stale route description.
- **Recommended chapter-side actions** (for a blueprint-writing dispatch):
  1. Add a lemma block for `pullbackObjUnitToUnit_comp` in or adjacent to the `lem:pullback_unit_iso` proof, with `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` and the statement `pbu (h≫f) = (pullbackComp h f).inv.app unit ≫ (pullback h).map (pbu f) ≫ pbu h`.
  2. Add a (possibly inline or in a remark) reference to `unitToPushforwardObjUnit_comp` as the pushforward-side intermediate via which `pullbackObjUnitToUnit_comp` is obtained by `homEquiv`-injectivity.
  3. Update the `lem:pullback_unit_iso` proof sketch to state that `pullbackObjUnitToUnit_comp` (the "naturality lemma") is now proved, and the remaining blocker is instance-synthesis plumbing (not math), with the NEXT-ITER fix recipe pointed to.

---

## Severity summary

| Finding | Severity |
|---|---|
| `pullbackObjUnitToUnit_comp` (L923) has no `\lean{...}` pin despite being "the genuinely-new ingredient for `pullbackUnitIso`" | **major** |
| `unitToPushforwardObjUnit_comp` (L882) has no `\lean{...}` pin despite being the pushforward-side intermediate feeding the pullback-side coherence | **major** |
| Blueprint proof sketch for `lem:pullback_unit_iso` describes "the naturality lemma" as remaining work, but that lemma is now proved — sketch is partially stale and doesn't name the lemma | **major** |
| Blueprint proof sketch for `lem:pullback_unit_iso` doesn't explain the adjunction-mate transport route; under-specified for a cold prover | **minor** |
| `restrictIsoUnitOfLE`, `tensorObjIsoOfIso` not `\lean{...}`-pinned | **minor** |

**Overall verdict**: Two axiom-clean declarations introduced this iter (`unitToPushforwardObjUnit_comp` and `pullbackObjUnitToUnit_comp`) are the critical-path composition-coherence lemmas for `pullbackUnitIso`, but neither has a `\lean{...}` pin in the blueprint chapter, and the proof sketch for `lem:pullback_unit_iso` does not name them; the blueprint adequacy for the `lem:pullback_unit_iso` block is under-specified — major findings, no must-fix-this-iter.
