# Lean ↔ Blueprint Check Report

## Slug
tensorobjsubstrate

## Iteration
239

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes — L138
- **Signature matches**: yes — `{X : Scheme.{u}} (M N : X.Modules) : X.Modules`, consistent with blueprint
- **Proof follows sketch**: yes — lifts `PresheafOfModules.Monoidal.tensorObj` through `sheafification`, exactly as blueprint describes
- **notes**: `\leanok` present in blueprint statement block; no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes — L153
- **Signature matches**: yes — bifunctor action on morphisms
- **Proof follows sketch**: yes — inherits from `PresheafOfModules.Monoidal.tensorObj` under sheafification
- **notes**: `\leanok` present; no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (chapter: `def:scheme_modules_isinvertible`)
- **Lean target exists**: yes — L166
- **Signature matches**: yes — `Prop`, `∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: N/A (definition, no proof body to compare)
- **notes**: `\leanok` present in blueprint statement block.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: `lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes — L446
- **Signature matches**: yes — open immersion `f : Y ⟶ X`, arbitrary `M N : X.Modules`, `(tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`
- **Proof follows sketch**: yes — four-step composite (Steps 1–4: `restrictFunctorIsoPullback`, `sheafificationCompPullback`, strip sheafification, H1∘H2), matching the blueprint proof
- **notes**: `\leanok` present; axiom-clean (iter-217).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes — L536
- **Signature matches**: yes — `hM : IsLocallyTrivial M` → `hN : IsLocallyTrivial N` → `IsLocallyTrivial (tensorObj M N)`
- **Proof follows sketch**: yes — common affine open `W`, restrict both trivialisations via `restrictIsoUnitOfLE`, transport through `tensorObj_restrict_iso` + `tensorObjIsoOfIso` + `tensorObj_unit_iso`
- **notes**: `\leanok` present; no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (chapter: `lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes — L341
- **Signature matches**: yes — unconditional, for arbitrary `M N P : X.Modules`
- **Proof follows sketch**: partial — the blueprint proof at the end of § says the single left-whisker obligation is closed via d.2 (`isLocallyInjective_whiskerLeft_of_W`); the Lean body instead uses route (d) `W_whiskerLeft/Right_of_W` (unconditional via `W_toSheafify`), which iter-238 confirmed axiom-clean. The two routes close the same obligation differently (d.2 stalk-tensor vs route-d W-whisker); the Lean body is correct and axiom-clean. The **docstring** (L296–340) retains stale text describing the flatness-residual problem from before iter-238 as if it were still live, but the code comment at L345–348 correctly records the resolution.
- **notes**: `\leanok` present in blueprint; no sorry in body, sorry-transitive through `Vestigial.lean:isLocallyInjective_whiskerLeft_of_W` as documented. Docstring staleness is minor (see Red Flags).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (chapter: `lem:tensorobj_unit_iso`)
- **Lean target exists**: yes — L269 (`tensorObj_left_unitor`), L279 (`tensorObj_right_unitor`)
- **Signature matches**: yes — `𝒪_X ⊗ M ≅ M` and `M ⊗ 𝒪_X ≅ M`
- **Proof follows sketch**: yes — cheap `mapIso` pattern: sheafify presheaf unitors, compose with sheafification counit; matches blueprint sketch exactly
- **notes**: Blueprint block at L1554 does **not** carry `\leanok` even though both declarations are sorry-free. This is a `sync_leanok` discrepancy (informational — managed automatically).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (chapter: `lem:tensorobj_comm_iso`)
- **Lean target exists**: yes — L289
- **Signature matches**: yes — `M ⊗ N ≅ N ⊗ M`
- **Proof follows sketch**: yes — `mapIso` of the presheaf braiding
- **notes**: `\leanok` present; no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes — L693
- **Signature matches**: yes — `IsLocallyTrivial L → ∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit …)`
- **Proof follows sketch**: N/A — body is `:= sorry` (pre-existing, acknowledged in directive)
- **notes**: Sorry is pre-existing and authorized; blueprint block has no `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (chapter: `lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes — L725
- **Signature matches**: yes — takes two `LineBundle.OnProduct` and returns another
- **Proof follows sketch**: yes — carrier is `tensorObj L.carrier L'.carrier`, local triviality from `tensorObj_isLocallyTrivial`
- **notes**: no sorry; blueprint has no `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso_invertible}` (chapter: `lem:tensorobj_assoc_iso_invertible`)
- **Lean target exists**: yes — L742
- **Signature matches**: yes — `IsInvertible M → IsInvertible N → IsInvertible P → tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P)`
- **Proof follows sketch**: yes — immediate specialisation of `tensorObj_assoc_iso`, invertibility hypotheses not consumed
- **notes**: `\leanok` present; no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` (chapter: `def:pic_carrier`)
- **Lean target exists**: yes — L800
- **Signature matches**: yes — `Quotient (picSetoid X)`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.tensorObj}` (chapter: `lem:isinvertible_tensor`)
- **Lean target exists**: yes — L764
- **Signature matches**: yes — `IsInvertible M → IsInvertible M' → IsInvertible (Scheme.Modules.tensorObj M M')`
- **Proof follows sketch**: yes — `tensorObj_middleFour` + `tensorObjIsoOfIso` + `tensorObj_unit_iso`
- **notes**: `\leanok` present; no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.isInvertible_unit}` (chapter: `lem:isinvertible_unit`)
- **Lean target exists**: yes — L774
- **Signature matches**: yes — `IsInvertible (SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: yes — witness `𝒪_X`, iso `tensorObj_unit_iso`
- **notes**: `\leanok` present; no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.inverse_unique}` (chapter: `lem:isinvertible_inverse_welldef`)
- **Lean target exists**: yes — L781
- **Signature matches**: yes — two tensor inverses of same module are isomorphic
- **Proof follows sketch**: yes — inverse-of-inverse chain via unitors + associator + braiding
- **notes**: `\leanok` present; no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.picCommGroup}` (chapter: `thm:pic_commgroup`)
- **Lean target exists**: yes — L834
- **Signature matches**: yes — `CommGroup (PicGroup X)` instance
- **Proof follows sketch**: yes — each axiom filed by existence-of-isomorphism (`Quotient.sound ⟨…⟩`), exactly as blueprint describes
- **notes**: `\leanok` present; body sorry-free (sorry-transitive via `Vestigial.lean`, which the blueprint also acknowledges through the `\uses{lem:islocallyinjective_whiskerleft_via_stalk}` chain).

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict}` (chapter: `lem:isiso_of_isiso_restrict`)
- **Lean target exists**: yes — L567
- **Signature matches**: yes — locally iso ⇒ globally iso, stalkwise criterion
- **Proof follows sketch**: yes — stalkwise iso criterion via `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` + `restrictStalkNatIso`
- **notes**: blueprint block (`lem:isiso_of_isiso_restrict`) appears at the end of the chapter (~L4218); no `\leanok` marker present even though the declaration is sorry-free. `sync_leanok` discrepancy (informational).

### `\lean{AlgebraicGeometry.Scheme.Modules.homMk}` (chapter: `def:scheme_modules_homMk`)
- **Lean target exists**: yes — L608
- **Signature matches**: yes — wraps `PresheafOfModules.homMk` at the `Scheme.Modules` level
- **Proof follows sketch**: yes — straightforward wrapper, `toPresheaf_map_homMk` simp lemma included
- **notes**: blueprint block at end of chapter; no `\leanok` (informational).

### `\lean{AlgebraicGeometry.Scheme.Modules.dual}` (chapter: `lem:internal_hom_isSheaf`)
- **Lean target exists**: yes — L194
- **Signature matches**: yes — sheafification of `PresheafOfModules.dual M.val`
- **Proof follows sketch**: yes — exact analogue of `tensorObj`, `mapIso` of `PresheafOfModules.dual`
- **notes**: Blueprint pin is at end of chapter (~L3827). No `\leanok` on the statement block (informational).

### `\lean{AlgebraicGeometry.Scheme.Modules.dualIsoOfIso}` (chapter: `def:scheme_modules_dual_iso_of_iso`)
- **Lean target exists**: yes — L205
- **Signature matches**: yes — `e : M ≅ M' → dual M' ≅ dual M`
- **Proof follows sketch**: yes
- **notes**: No `\leanok` in blueprint (informational).

---

## **CRITICAL: `sec:tensorobj_pullback_monoidality` — `\lean{}`-pinned blocks with NO Lean counterparts**

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}` (chapter: `lem:pullback_tensor_iso`)
- **Lean target exists**: **no** — declaration absent from the file
- **Signature matches**: N/A
- **Proof follows sketch**: **N/A — the proof sketch is unformalizable** (see Blueprint Adequacy below)
- **notes**: Blueprint has no `\leanok` marker (correctly, since the declaration doesn't exist). The Lean HANDOFF block (L920–L972) explicitly documents why.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (chapter: `lem:pullback_unit_iso`)
- **Lean target exists**: **no** — declaration absent
- **Signature matches**: N/A
- **Proof follows sketch**: N/A — blueprint proof derives it from `pullbackTensorIso`, which doesn't exist
- **notes**: Blueprint has no `\leanok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.pullback}` (chapter: `lem:isinvertible_pullback`)
- **Lean target exists**: **no** — declaration absent
- **Signature matches**: N/A
- **Proof follows sketch**: N/A — downstream of the two missing declarations above
- **notes**: Blueprint has no `\leanok`.

---

## Red flags

### Placeholder / suspect bodies
- `Scheme.Modules.exists_tensorObj_inverse` at L715: `:= sorry` — pre-existing, authorized (acknowledged in directive; blueprint has no `\leanok`).
- `Scheme.PicSharp.addCommGroup_via_tensorObj` at L1005: `:= sorry` — pre-existing, authorized (acknowledged in directive; blueprint has no `\leanok`).

### Stale docstring (minor)
- `tensorObj_assoc_iso` docstring at L296–340 retains old analysis ("the genuine residual is now the flatness feeding steps 1 and 3") as if the problem were still live. The code comment inside the proof body (L345–348) correctly records the iter-238 resolution. The docstring is misleading but the proof body and code comment are accurate. Not an excuse-comment about wrong code; it is stale iteration-level commentary.

### Axioms / Classical.choice
- `Classical.choice` is used inside `picInv` (L817) — this is legitimate and authorized: the blueprint explicitly describes that the inverse is "the membership witness itself" (the existential `Classical.choose` from `IsInvertible`). This is intentional design, not a suspect pattern.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no direct `\lean{...}` reference in the chapter (most are helpers or internal infrastructure):

- `tensorObjIsoOfIso` (L240) — helper for `tensorObj_isLocallyTrivial` and `picCommGroup`; not surprising it's unpinned (it's a supporting lemma).
- `tensorObj_unit_iso` (L256) — **potentially should be pinned**: it proves `tensorObj 𝒪 𝒪 ≅ 𝒪`, referred to in several blueprint proofs by name (`\mathtt{tensorObj\_unit\_iso}`) but not by a `\lean{...}` pin. Substantive declaration, no `\lean{}` reference.
- `restrictIsoUnitOfLE` (L394) — helper, reasonably unpinned.
- `tensorObj_middleFour` (L751) — private helper for `IsInvertible.tensorObj`, correctly private.
- `sheafifyTensorUnitIso` (L884) — **private** internal brick; the HANDOFF block describes it as "the bridge reconciling a presheaf-level tensorator with the substrate ⊗_X" to be consumed by the eventual `pullbackTensorIso`. No `\lean{}` pin is needed or expected for a private declaration.
- `picSetoid` (L793), `picMul` (L805), `picInv` (L814) — internal implementation details of `picCommGroup`; not pinned but referenced structurally by the group instance.
- `toPresheaf_map_homMk` (L616) — `@[simp]` helper for `homMk`, unpinned, acceptable.

**Assessment**: `tensorObj_unit_iso` is the one substantive declaration that the blueprint references by name in multiple proof sketches (e.g., `lem:isinvertible_unit`, `lem:isinvertible_tensor`, `lem:isinvertible_inverse_welldef`) but that lacks a direct `\lean{...}` pin. Worth adding a pin (minor finding).

---

## Blueprint adequacy for this file

### Coverage
12 of 15 `\lean{}`-pinned declarations for this file exist in Lean. 3 are missing (`pullbackTensorIso`, `pullbackUnitIso`, `IsInvertible.pullback`). All 12 existing declarations have signatures consistent with their blueprint statements. The missing 3 are correctly marked without `\leanok` in the blueprint.

### **MUST-FIX: Proof-sketch depth — CRITICALLY WRONG for `sec:tensorobj_pullback_monoidality`**

The proof sketch for `lem:pullback_tensor_iso` (Step 2) claims:

> *"The presheaf-level pullback `PresheafOfModules.pullback φ` is, sectionwise, extension of scalars along the section ring maps of `φ`... Assembling these sectionwise tensorators against the presheaf restriction morphisms furnishes a strong-monoidal structure on `PresheafOfModules.pullback φ`..."*

**This description is factually incorrect for Mathlib at the pinned commit (b80f227).** In Mathlib, `PresheafOfModules.pullback φ` is defined as `(pushforward _).leftAdjoint` — an **abstract left adjoint** with no sectionwise formula. There is no `PresheafOfModules.pullback_obj` lemma, no sectionwise characterization, and no `extendScalars`-based monoidal structure registered on it anywhere in `Mathlib/Algebra/Category/ModuleCat/Presheaf/`. The prover confirmed this wall live (Lean HANDOFF block L920–L972):

> *"Scheme.Modules.pullback f = SheafOfModules.pullback f.toRingCatSheafHom and the underlying PresheafOfModules.pullback φ.hom are BOTH defined as (pushforward _).leftAdjoint — an ABSTRACT left adjoint with NO sectionwise and NO stalkwise formula in Mathlib at the pinned commit."*

A prover following the blueprint's Step 2 ("assemble sectionwise extendScalars tensorators") would be unable to typecheck, because there is no `(PresheafOfModules.pullback φ).obj` to attach the extendScalars tensorator to. The blueprint's proof sketch for `lem:pullback_unit_iso` and `lem:isinvertible_pullback` are downstream of this same gap and are therefore also unformalizable as written.

The blueprints for `lem:pullback_tensor_iso`, `lem:pullback_unit_iso`, `lem:isinvertible_pullback` must be **rewritten** to replace the sectionwise-extendScalars recipe with a correct pivot route. The Lean HANDOFF block (L920–L972) identifies two viable alternatives:
1. **Local-chart-finality route**: verify locally via `isIso_of_isIso_restrict`; on each affine chart `V` the local restriction `g = f.resLE U V` is an open immersion whose `Opens.map g.base` is `Final`, making `pullbackObjUnitToUnit g` an iso; this is the same trick that proves `LineBundle.IsLocallyTrivial.pullback`. Needs a small lemma cluster on naturality of `pullbackObjUnitToUnit` against `pullbackComp`/`restrictFunctorIsoPullback`.
2. **Flat-restricted route**: the RPF projection `π_T : C ×_S T → T` is flat; a flat-restricted `IsInvertible.pullback` may avoid the general pullback-monoidality build entirely.

The blueprint-writing subagent must rewrite `sec:tensorobj_pullback_monoidality` to:
- Document the abstract-pullback wall (no sectionwise formula for `PresheafOfModules.pullback`).
- Replace the Step 2 recipe with the local-chart-finality pivot (recommended) or flag the flat-restricted alternative.
- Note that `sheafifyTensorUnitIso` (private, L884) is the already-landed "sheafification is monoidal" brick that the eventual `pullbackTensorIso` will consume.

### Hint precision: **wrong** for `sec:tensorobj_pullback_monoidality`
The `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIso}` hint names a correct intended Lean target, but the proof sketch attached to that block describes a route that cannot typecheck. The hint name is fine; the proof sketch content is wrong.

### Generality: matches need
All other blocks are at the right level of generality; no parallel API was written to cover a gap in the blueprint's level of generality.

### Recommended chapter-side actions
1. **Rewrite `sec:tensorobj_pullback_monoidality`** (all three proof blocks: `lem:pullback_tensor_iso`, `lem:pullback_unit_iso`, `lem:isinvertible_pullback`): remove the "sectionwise extendScalars" recipe; describe the local-chart-finality pivot route instead, following the HANDOFF block in the Lean file.
2. **Add a `% NOTE:` annotation** on the three blocks explaining the abstract-pullback wall (or incorporate it into the proof sketch text directly, following the HANDOFF block).
3. **Add `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso}`** to the blueprint — this declaration is referenced by name in multiple proof sketches and proofs but lacks a `\lean{...}` pin (minor gap).
4. **Optionally add `\lean{...}` pins** for `isIso_of_isIso_restrict` and `homMk` statement blocks if `\leanok` sync is desired (these are already axiom-clean).

---

## `sheafifyTensorUnitIso` — no action needed

The declaration `sheafifyTensorUnitIso` (L884) is:
- `private noncomputable def` — intentionally not exported.
- Not `\lean{}`-pinned in the blueprint, correctly so.
- The Lean HANDOFF block describes it as a reusable internal brick for the eventual `pullbackTensorIso`; it builds the "sheafification is monoidal" reconciliation via `W_whiskerRight/Left_of_W` + `isIso_sheafification_map_of_W`.
- No marker or pin action is needed or appropriate for a private declaration.

---

## Severity summary

| Finding | Severity |
|---|---|
| `sec:tensorobj_pullback_monoidality` proof sketches describe unformalizable route (sectionwise pullback formula absent in Mathlib) | **must-fix-this-iter** |
| `pullbackTensorIso`, `pullbackUnitIso`, `IsInvertible.pullback` absent from Lean file (blueprint pins point to non-existent declarations) | **major** (no `\leanok` claimed, so not a consistency violation, but the gap blocks the next prover round for this section) |
| Stale docstring in `tensorObj_assoc_iso` (L296–340) retains pre-iter-238 text about flatness residual as live problem | **minor** |
| `tensorObj_unit_iso` (L256) lacks a `\lean{...}` pin in the blueprint despite being referenced by name in multiple proof sketches | **minor** |
| `lem:tensorobj_unit_iso` blueprint block lacks `\leanok` despite both `tensorObj_left_unitor`/`tensorObj_right_unitor` being sorry-free | **minor** (sync_leanok discrepancy) |

**Overall verdict**: The chapter is mostly adequate and faithful for the implemented declarations, but `sec:tensorobj_pullback_monoidality` contains a must-fix blueprint adequacy failure — its proof sketch for `lem:pullback_tensor_iso` describes a route (sectionwise extendScalars assembly on `PresheafOfModules.pullback`) that cannot typecheck in Mathlib at the pinned commit; the section must be rewritten to reflect the abstract-pullback wall and the local-chart-finality pivot before a prover can make progress on the three missing declarations. 12 declarations checked, 1 must-fix blueprint adequacy finding, 2 pre-existing authorized sorries, 3 missing Lean targets (correctly unformalized this iter).
