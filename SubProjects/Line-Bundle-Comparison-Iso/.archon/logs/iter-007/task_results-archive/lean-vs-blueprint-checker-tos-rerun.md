# Lean ↔ Blueprint Check Report

## Slug
tos-rerun

## Iteration
006

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (3152 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (~342 KB, covers 5 files via `archon:covers`)

---

## Per-declaration (key `\lean{...}` blocks for declarations in TensorObjSubstrate.lean)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`, blueprint L310)
- **Lean target exists**: yes (L166)
- **Signature matches**: yes — `(M N : X.Modules) : X.Modules` as stated; body is sheafification of `PresheafOfModules.Monoidal.tensorObj` matching the "affine-local sectionwise tensor, globally sheafified" description.
- **Proof follows sketch**: N/A (definition, no proof block in chapter; body is fully defined, no sorry)
- **notes**: `\leanok` marker present and correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`, blueprint L348)
- **Lean target exists**: yes (L181)
- **Signature matches**: yes — takes `(f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'`; inherits morphism action via `sheafification.map (tensorHom ...)`.
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present and correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (chapter: `def:scheme_modules_isinvertible`, blueprint L1897)
- **Lean target exists**: yes (L194)
- **Signature matches**: yes — `∃ N : X.Modules, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)` exactly matches blueprint prose.
- **Proof follows sketch**: N/A (Prop definition)
- **notes**: `\leanok` present and correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual}` (chapter: `lem:internal_hom_isSheaf`, blueprint L4309)
- **Lean target exists**: yes (L222)
- **Signature matches**: yes — `(M : X.Modules) : X.Modules`; body sheafifies `PresheafOfModules.dual M.val` matching "sheaf-level dual = sheafification of presheaf dual" prose.
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present and correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.dualIsoOfIso}` (chapter: `lem:dualIsoOfIso`, blueprint L4455)
- **Lean target exists**: yes (L233)
- **Signature matches**: yes — `(e : M ≅ M') : dual M' ≅ dual M`; contravariantly functorial in isos.
- **Proof follows sketch**: yes (mapIso of dualIsoOfIso)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoOfIso}` (chapter: `def:tensorobjisoofiso`, blueprint L5460)
- **Lean target exists**: yes (L268)
- **Signature matches**: yes — `(e : M ≅ M') (e' : N ≅ N') : tensorObj M N ≅ tensorObj M' N'`
- **Proof follows sketch**: yes (mapIso of tensorIso)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso}` (chapter: `def:tensorobj_unit_self_iso`, blueprint L5477)
- **Lean target exists**: yes (L284)
- **Signature matches**: yes — `tensorObj 𝒪_X 𝒪_X ≅ 𝒪_X`
- **Proof follows sketch**: yes (presheaf left unitor sheafified ≪≫ counit)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (chapter: `lem:tensorobj_unit_iso`, blueprint L1306)
- **Lean target exists**: yes (L297, L307)
- **Signature matches**: yes — `𝒪_X ⊗ M ≅ M` and `M ⊗ 𝒪_X ≅ M` respectively
- **Proof follows sketch**: yes (both use cheap `mapIso` of the presheaf unitor ≪≫ sheafification counit)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (chapter: `lem:tensorobj_comm_iso`, blueprint L1337)
- **Lean target exists**: yes (L317)
- **Signature matches**: yes — `tensorObj M N ≅ tensorObj N M`
- **Proof follows sketch**: yes (mapIso of presheaf braiding)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (chapter: `lem:tensorobj_assoc_iso`, blueprint L1186)
- **Lean target exists**: yes (L346)
- **Signature matches**: yes — `tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)`, unconditional (no flatness/triviality hypotheses)
- **Proof follows sketch**: yes — the three-step composite (steps 1/2/3: whiskered unit localization, presheaf associator, inverse whiskered unit) exactly matches the blueprint sketch.
- **notes**: `\leanok` present. Axiom-clean per iter-238.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: `lem:tensorobj_restrict_iso`, blueprint L556)
- **Lean target exists**: yes (L451)
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`
- **Proof follows sketch**: yes — four-step structure (restrictFunctorIsoPullback → sheafificationCompPullback → mapIso → H1∘H2) faithfully follows blueprint steps 1–4.
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`, blueprint L744)
- **Lean target exists**: yes (L541)
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) : LineBundle.IsLocallyTrivial (tensorObj M N)`
- **Proof follows sketch**: yes — finds a common refinement open W, applies `restrictIsoUnitOfLE` then `tensorObj_restrict_iso` → `tensorObjIsoOfIso` → `tensorObj_unit_iso`.
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`, blueprint L1360)
- **Lean target exists**: yes (L690)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: N/A — body is `sorry`; **known-open by directive** (import-cycle gated; closes via DualInverse.lean chain)
- **notes**: sorry is sanctioned by directive. `\leanok` should NOT be present; chapter marks this as `\leanok` which will be incorrect until the sorry closes — but this is the `sync_leanok` phase's concern, not a Lean defect.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (chapter: `lem:tensorobj_lift_onproduct`, blueprint L1495)
- **Lean target exists**: **no, not in TensorObjSubstrate.lean** — moved to `RelPicFunctor.lean` (iter-247 import-cycle fix; confirmed by grep: `RelPicFunctor.lean:216`)
- **Signature matches**: yes (declaration exists at the correct fully-qualified name in RelPicFunctor.lean, correct content)
- **Proof follows sketch**: yes (in RelPicFunctor.lean; no sorry)
- **notes**: **STALE PIN — the blueprint chapter's `archon:covers` annotations do not include `RelPicFunctor.lean`**. The `\lean{...}` hint resolves to a declaration outside this chapter's file scope. The declaration name `AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct` is correct, the content is correct, but the cross-chapter file attribution is broken. The blueprint's `\leanok` marker will resolve the declaration via leandag but the chapter-ownership mapping is misleading.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict}` (chapter: `lem:isIso_of_isIso_restrict`, blueprint L5177)
- **Lean target exists**: yes (L572)
- **Signature matches**: yes — stalkwise-iso descent: `IsIso (restrictFunctor (U x).ι).map φ` for all `x` implies `IsIso φ`
- **Proof follows sketch**: yes (stalkFunctor + TopCat.Presheaf.isIso_of_stalkFunctor_map_iso + restrictStalkNatIso)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.homMk}` (chapter, blueprint L5261)
- **Lean target exists**: yes (L613)
- **Signature matches**: yes — wraps `PresheafOfModules.homMk` at the Scheme.Modules level with sectionwise-linearity evidence
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso_invertible}` (chapter: `lem:tensorobj_assoc_iso_invertible`, blueprint L3471)
- **Lean target exists**: yes (L726)
- **Signature matches**: yes — specialises unconditional `tensorObj_assoc_iso` to invertible inputs; invertibility hypotheses accepted but unused
- **Proof follows sketch**: yes (trivial specialisation)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.tensorObj}` (chapter: `lem:isinvertible_tensor`, blueprint L3553)
- **Lean target exists**: yes (L748)
- **Signature matches**: yes — `(hM : IsInvertible M) (hM' : IsInvertible M') : IsInvertible (Scheme.Modules.tensorObj M M')`
- **Proof follows sketch**: yes (uses tensorObj_middleFour + tensorObjIsoOfIso + tensorObj_unit_iso)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.inverse_unique}` (chapter: `lem:isinvertible_inverse_welldef`, blueprint L3610)
- **Lean target exists**: yes (L765)
- **Signature matches**: yes — two tensor-inverse isos for M imply N ≅ N' via inverse-of-inverse chain
- **Proof follows sketch**: yes (right unitor → inverse iso → assoc.symm → braiding/first iso → left unitor)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup, AlgebraicGeometry.Scheme.Modules.picCommGroup}` (chapter: `lem:tensorobj_isoclass_commgroup`, blueprint L1965)
- **Lean target exists**: yes — `PicGroup` (L784), `picCommGroup` (L818)
- **Signature matches**: yes — `PicGroup X := Quotient (picSetoid X)` and `noncomputable instance picCommGroup (X : Scheme.{u}) : CommGroup (PicGroup X)`
- **Proof follows sketch**: yes — CommGroup axioms fed single existence-of-isomorphism witnesses (unitors, associator, braiding); no monoidal coherence
- **notes**: `\leanok` present. Also see "label collision" note below.

### `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` (chapter: `def:pic_carrier`, blueprint L3507)
- **Lean target exists**: yes (L784)
- **Signature matches**: yes — carrier type `Quotient (picSetoid X)`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present. **Second pin for PicGroup** — same declaration pinned by both `lem:tensorobj_isoclass_commgroup` (L1965) and `def:pic_carrier` (L3507). See "Red flags" below.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap}` (chapter: `lem:pullback_tensor_map`, blueprint L2406)
- **Lean target exists**: yes (L1205)
- **Signature matches**: yes — four-fold composite: sheafificationCompPullback → a.map δ → sheafifyTensorUnitIso → a.map (pullbackValIso ⊗ pullbackValIso)
- **Proof follows sketch**: yes (explicit 4-factor assembly)
- **notes**: `\leanok` present. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` (chapter: `lem:pullback_tensor_map_natural`, blueprint L2648)
- **Lean target exists**: yes (L1982)
- **Signature matches**: yes — naturality of pullbackTensorMap in (M, N)
- **Proof follows sketch**: yes (D1′ naturality paste — Sq2 via δ_natural + F-ascription, Sq3/Sq4 via erw/refine)
- **notes**: `\leanok` present. Axiom-clean (iter-255).

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}` (chapter: `lem:pullback_tensor_iso_unit`, blueprint L2794)
- **Lean target exists**: yes (L1826)
- **Signature matches**: yes — `IsIso (pullbackTensorMap f 𝒪_X 𝒪_X)` given `IsIso (sheafifyEta f)`
- **Proof follows sketch**: yes (D2′, closed iter-250)
- **notes**: `\leanok` present. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (chapter: `lem:pullback_tensor_map_basechange`, blueprint L3024)
- **Lean target exists**: yes (L2971)
- **Signature matches**: yes — four-term decomposition `pullbackTensorMap (h ≫ f) M N = (pullbackComp h f).inv ≫ (pullback h).map (pullbackTensorMap f M N) ≫ pullbackTensorMap h (f^*M) (f^*N) ≫ tensorObjIsoOfIso (pullbackComp h f).app ...` matches blueprint precisely.
- **Proof follows sketch**: partial — body is `sorry`; **known-open by directive** (Sq3/Sq4 interleave). Roadmap in body comment is extensive and matches blueprint analysis.
- **notes**: Known-open. `\leanok` marker in blueprint — sync_leanok will remove it if it correctly detects the sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_eq_leftAdjointUniq}` (chapter: `lem:sheafification_comp_pullback_eq_leftadjointuniq`, blueprint L2904)
- **Lean target exists**: yes (L1534)
- **Signature matches**: yes
- **Proof follows sketch**: yes (adjunction-mate calculus)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp}` (chapter: `lem:sheafificationcomppullback_comp`, blueprint L5675)
- **Lean target exists**: yes (L2784) — **private lemma**
- **Signature matches**: yes — composition coherence of `SheafOfModules.sheafificationCompPullback` across h ≫ f
- **Proof follows sketch**: yes — end-to-end sorry-free (iter-006, "end-to-end green" per directive)
- **notes**: **Private declaration pinned by blueprint `\lean{...}`**. The name `AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp` is mangled by `private` in Lean 4; blueprint tooling resolves it via source text matching, not via the elaborated name. The content is correct. (See "Blueprint adequacy" below.)

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_comp_tail}` (private, blueprint L5699)
- **Lean target exists**: yes (L2697) — **private lemma**, CLOSED this iter (directive-confirmed)
- **Signature matches**: yes — unit identity for the two-layer composite adjunction after the R0-peel
- **Proof follows sketch**: yes — sorry-free (iter-006 CLOSED)
- **notes**: Private declaration pinned by blueprint. Same tooling-resolution caveat as above. `\leanok` marker in blueprint will be set correctly.

---

## Red flags

### Placeholder / suspect bodies
- `exists_tensorObj_inverse` at L712: body is `sorry`. **SANCTIONED by directive** — import-cycle gated, closes via DualInverse.lean. Not a defect.
- `pullbackTensorMap_restrict` at L3144: body is `sorry`. **SANCTIONED by directive** — Sq3/Sq4 interleave, known-open. Not a defect.

No other `:= sorry`, `:= True`, or suspect bodies found in the 3152-line file.

### Excuse-comments
None found. Roadmap comments in `exists_tensorObj_inverse` and `pullbackTensorMap_restrict` are technical handoff notes explaining the known-open state, not excuses for wrong code.

### Axioms / Classical.choice on substantive claims
No unauthorized `axiom` declarations. `Classical.choice` appears only in `picInv` (L801–804) to extract the inverse witness from the existential `IsInvertible` predicate — this is expected and blueprint-authorized (the inverse is carried existentially by design).

### Label collision / shared Lean pins (confirmed real)

**Collision 1 (explicitly acknowledged in blueprint)**: Two blueprint nodes pin the same Lean declaration `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W`:
- `lem:islocallyinjective_whisker_of_W` (blueprint L973) — the superseded route-(d)/(e) block
- `lem:islocallyinjective_whiskerleft_via_stalk` (blueprint L1804) — the live unconditional lemma

The blueprint has an explicit comment (L974–978): "Both blueprint nodes legitimately share the pin (leandag flags only Lean-side name collisions, not shared blueprint pins)." This is an acknowledged intentional dual-node pin. The Lean declaration is in `Vestigial.lean` (covered by this chapter) and is sorry-free. **Not a defect; acknowledged.**

**Collision 2 (no acknowledgment comment)**: Two blueprint nodes pin `AlgebraicGeometry.Scheme.Modules.PicGroup`:
- `lem:tensorobj_isoclass_commgroup` (blueprint L1965): `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup, AlgebraicGeometry.Scheme.Modules.picCommGroup}`
- `def:pic_carrier` (blueprint L3507): `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}`

The original monolithic `tensorObjIsoclassCommMonoid` was split into `def:pic_carrier` (carrier type) and `picCommGroup` (group instance); the old `lem:tensorobj_isoclass_commgroup` node still pins both. No blueprint % comment acknowledges this shared pin. This is structurally harmless (both nodes resolve and are otherwise sound), but the dual-pin is worth noting for blueprint cleanup. **Minor.**

### Stale `\lean{...}` pin (confirmed real)

`lem:tensorobj_lift_onproduct` (blueprint L1495) pins `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}`. The declaration was moved from `TensorObjSubstrate.lean` to `RelPicFunctor.lean` in iter-247 (import-cycle fix). The chapter's `% archon:covers` annotations list five files but do NOT include `RelPicFunctor.lean`. The declaration still exists with the fully-qualified name `AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct` and correct content — so the pin resolves mathematically — but the chapter-to-file attribution is broken: the chapter claims to cover a declaration that lives outside its covered file set.

**This is a major blueprint-side issue**: the chapter should either (a) add `% archon:covers AlgebraicJacobian/Picard/RelPicFunctor.lean` if it is intended to cover this declaration, or (b) remove the `\lean{...}` pin and let the RelPicFunctor chapter own it, or (c) add a `% NOTE:` comment explaining the cross-chapter pin. The `\leanok` marker on this block will continue to resolve (the declaration exists), so there is no immediate failure, but the chapter coverage integrity is violated.

---

## Unreferenced declarations (informational)

The following declarations in `TensorObjSubstrate.lean` are not directly pinned by a `\lean{...}` in the chapter (either unpinned helpers, or indirectly referenced via `\uses{}` only):

- `restrictIsoUnitOfLE` (L399): helper for `tensorObj_isLocallyTrivial`; no direct pin. Small utility ("refine trivialisation to smaller open"), warrants a `\lean{...}` mention in `lem:tensorobj_preserves_locally_trivial`'s proof block.
- `isInvertible_unit` (L758): `theorem isInvertible_unit` — `\lean{}` pin absent from blueprint. Referenced in `\uses{}` as `lem:isinvertible_unit` in several places, but no block with a `\lean{}` pin. Worth adding.
- `picSetoid` (L777): pinned at blueprint L5944 (internal-consistency section). OK.
- `picMul` (L789): pinned at blueprint L5960. OK.
- `picInv` (L798): pinned at blueprint L5976. OK.
- `tensorObj_middleFour` (L735): private, helper for `IsInvertible.tensorObj`; pinned at blueprint L5494 (consistency section). OK.
- `isIso_pbu_of_final` (L1025): private, helper for `pullbackObjUnitToUnitIso`; pinned at blueprint L5511. OK.
- `pullbackObjUnitToUnitIso` (L1033): helper; pinned at blueprint L5524. OK.
- `pullbackValIso` (L1188): helper for `pullbackTensorMap`; pinned at blueprint L5590. OK.
- `sheafifyIdOf` (L2461): **private abbrev, NEW this iter** — not in blueprint. Helper used by `sheafificationCompPullback_comp_natTrans`. Expected under coverage/unreferenced per directive.
- `sheafificationCompPullback_comp_natTrans` (L2469): **private lemma, NEW this iter** — not in blueprint. NatTrans-level form of `sheafificationCompPullback_comp`, consumed by `sheafificationCompPullback_comp_tail`. Expected per directive.
- Several other private helper lemmas (L1263, L1312, L1338, L1387, L1437, L1454, L1477, L1635, L1649, L1685, L1728, L1835, L1860, L2096, L2109, L2127, L2143, L2161, L2188, L2221, L2282, L2413, L2442): private helpers, most pinned in the consistency-check section.

---

## Blueprint adequacy for this file

- **Coverage**: The chapter covers all substantive public declarations in `TensorObjSubstrate.lean`. Most have `\lean{...}` pins either in the main narrative or in the consistency-check section. Private helpers are partially pinned (consistency section) and partially unpinned. The two new private declarations (`sheafifyIdOf`, `sheafificationCompPullback_comp_natTrans`) are not yet in the blueprint — per directive, expected and acceptable.

  Count for TensorObjSubstrate.lean specifically: approximately 25/35 public declarations have direct `\lean{...}` pins; the remaining ~10 are helpers whose content is described in proof blocks without pinning. Private declarations are ~20+ total; most appear in the consistency-check section.

- **Proof-sketch depth**: **adequate**. The chapter provides detailed proof sketches (steps 1–4 for `tensorObj_restrict_iso`, three-step composite for `tensorObj_assoc_iso`, D1′/D2′/D3′ full analysis for the pullback-monoidality suite). Roadmap comments in the Lean file closely mirror the blueprint's step-by-step descriptions. The `pullbackTensorMap_restrict` roadmap (Sq1–Sq4 decomposition) is fully worked out in both the blueprint and the Lean comment, consistent with each other.

- **Hint precision**: **precise** for the main declarations. The `\lean{...}` hints name the correct fully-qualified identifiers. The only precision issue is `private` declarations pinned by their non-mangled names (blueprint tooling may have difficulty resolving them via the elaborated name; source-text matching handles them).

- **Generality**: **matches need**. The chapter correctly explains why a full `MonoidalCategory (Scheme.Modules X)` is not built, why the group law consumes only propositions, and why the existing substrate suffices. No parallel API drift detected.

- **Recommended chapter-side actions**:
  1. **(Major)** Resolve the stale `\lean{tensorObjOnProduct}` pin: either add `% archon:covers AlgebraicJacobian/Picard/RelPicFunctor.lean` to the chapter, move the pin to the RelPicFunctor chapter, or add a `% NOTE: moved to RelPicFunctor.lean` comment on the existing pin in `lem:tensorobj_lift_onproduct`.
  2. **(Minor)** Add `% NOTE:` comment on `def:pic_carrier` (L3507) acknowledging the shared `PicGroup` pin with `lem:tensorobj_isoclass_commgroup`, mirroring the existing comment for the `isLocallyInjective_whiskerLeft_of_W` collision.
  3. **(Minor)** Add a `\lean{AlgebraicGeometry.Scheme.Modules.isInvertible_unit}` pin to the `lem:isinvertible_unit` block (currently `\uses{}` only).
  4. **(Informational)** Once `sheafifyIdOf` and `sheafificationCompPullback_comp_natTrans` stabilise, add them to the consistency-check section.

---

## Severity summary

- **must-fix-this-iter**: None. Both sorrys are directive-sanctioned known-open. No signature mismatches. No unauthorized axioms. No excuse-comments on substantive declarations.

- **major**:
  - `lem:tensorobj_lift_onproduct` (blueprint L1495) pins `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}`, a declaration that has been moved to `RelPicFunctor.lean` (iter-247). The chapter's `archon:covers` annotations do not include `RelPicFunctor.lean`, breaking chapter-to-file attribution. The declaration itself is correct and exists; only the chapter ownership is violated. Requires a blueprint-side fix (see recommended actions).

- **minor**:
  - `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` is pinned by two blueprint nodes (`lem:tensorobj_isoclass_commgroup` and `def:pic_carrier`) with no acknowledgment comment on the collision. Structurally harmless; add a `% NOTE:` comment.
  - `isInvertible_unit` at L758 is referenced in `\uses{}` blocks across the chapter but has no `\lean{...}` pin of its own.
  - Several private helper lemmas pinned by unmangled names in the consistency-check section will not resolve via elaborated names in leandag; source-text matching is the effective resolution path.

**Overall verdict**: TensorObjSubstrate.lean faithfully follows the blueprint for all its blueprint-pinned declarations; the two sanctioned sorrys are correctly scoped and annotated; the one major finding is a blueprint-side attribution issue (the `tensorObjOnProduct` stale pin), not a Lean defect. File is in good shape.

**Summary**: tos-rerun: lean-faithfully-follows-blueprint with one major blueprint attribution issue and two minor findings — 33 declarations checked, 0 unsanctioned red flags.
