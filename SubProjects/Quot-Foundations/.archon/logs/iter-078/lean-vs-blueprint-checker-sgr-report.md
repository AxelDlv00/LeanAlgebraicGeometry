# Lean ↔ Blueprint Check Report

## Slug
sgr

## Iteration
078

## Files audited
- Lean: `AlgebraicJacobian/Picard/SectionGradedRing.lean` (1802 lines)
- Blueprint: `blueprint/src/chapters/Picard_SectionGradedRing.tex` (1485 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjAssoc}` (chapter: `cor:sheafTensorObjAssoc`)
- **Lean target exists**: yes — `noncomputable def tensorObjAssoc` at L1609
- **Signature matches**: yes — `(A B C : X.Modules) : tensorObj (tensorObj A B) C ≅ tensorObj A (tensorObj B C)`, matching the blueprint's `(A⊗B)⊗C ≅ A⊗(B⊗C)`
- **Proof follows sketch**: yes — blueprint describes a three-segment composite:
  (1) `(η_{a⊗b} ▷ c)^#⁻¹ : (A⊗B)⊗C ≅ ((a⊗b)⊗c)^#`;
  (2) presheaf associator under sheafification;
  (3) `(a ⊲ η_{b⊗c})^# : (a⊗(b⊗c))^# ≅ A⊗(B⊗C)`.
  The Lean expands segment (3) into three sub-segments (braiding → whiskered-unit → braiding back), which is the exact route the planner strategy comment prescribes for implementing left-whiskering via `isIso_sheafification_whiskerRight_unit` (right-whiskering only). The direction of the composite is verified correct: `asIso(...).symm` for segment 1 lands in `((a⊗b)⊗c)^#`, the presheaf associator traverses to `(a⊗(b⊗c))^#`, then the braiding conjugate carries to `A⊗(B⊗C)`. Mathematical content ≡ blueprint.
- **notes**: `\leanok` present on both statement and proof blocks in chapter. Proof is axiom-clean (no sorry). The blueprint proof (L1070–1128) and the Lean proof (L1601–1652) are in complete correspondence.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPowAdd}` (chapter: `lem:sheafTensorPow_add`)
- **Lean target exists**: yes — `noncomputable def tensorPowAdd` at L1785
- **Signature matches**: yes — `(L : X.Modules) (m m' : ℕ) : tensorObj (tensorPow L m) (tensorPow L m') ≅ tensorPow L (m + m')`, matching blueprint `μ_{m,m'} : L^⊗m ⊗ L^⊗m' ≅ L^⊗(m+m')`
- **Proof follows sketch**: yes — the five-step induction in the Lean code (L1787–1799) mirrors the blueprint proof (L1186–1222) exactly:
  - base `m = 0`: `tensorObjUnitIso (tensorPow L m') ≪≫ eqToIso (Nat.zero_add)` ← blueprint "left unitor, reindexed";
  - `m = k+1` step (a): `tensorObjAssoc (L^⊗k) L (L^⊗m')` ← blueprint associator `α`;
  - step (b): `tensorObjWhiskerLeftIso (L^⊗k) (tensorBraiding L (L^⊗m'))` ← blueprint "id ⊗ β whiskered into the left factor";
  - step (c): `(tensorObjAssoc (L^⊗k) (L^⊗m') L).symm` ← blueprint `α⁻¹`;
  - step (d): `tensorObjWhiskerRightIso (tensorPowAdd L k m') L` ← blueprint "μ_{m,m'} ▷ L";
  - step (e): `eqToIso (Nat.succ_add k m').symm` ← blueprint reindexing `(k+m')+1 = (k+1)+m'`.
  Direction of each iso is consistent and produces `tensorObj (tensorPow L (k+1)) (tensorPow L m') ≅ tensorPow L ((k+1)+m')`.
- **notes**: `\leanok` present on both statement and proof blocks. Proof is axiom-clean. One structural observation on scope: the blueprint's lemma statement includes commutativity and associativity *constraints* on the family `{μ_{m,m'}}` — these are informally argued in the proof (L1228–1246) but no separate `\lean{...}`-tagged declarations exist for them in the blueprint, and no Lean lemma formalizes them. They will be needed when `sectionGradedRing_gcommSemiring` is attempted; see Blueprint adequacy section.

---

### Private helpers `tensorObjWhiskerRightIso`, `tensorObjWhiskerLeftIso`
- **Lean target exists**: yes — `private noncomputable def tensorObjWhiskerRightIso` at L1660; `private noncomputable def tensorObjWhiskerLeftIso` at L1709
- **Signature matches**: N/A (private, no `\lean{...}` reference in chapter)
- **Proof follows sketch**: N/A
- **notes**: These implement steps (d) and (b) of `tensorPowAdd`'s inductive step. They are proof-level helpers described operationally in the blueprint proof sketch and in the planner strategy comment (L1715–1776). Both are axiom-clean. Exempt from requiring blueprint blocks as proof-internal helpers (they lift a single sheaf-level isomorphism to right- or left-whiskered tensor products, entirely via `sheafification.map`/`sheafification.mapIso` — pure functor application).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.unitModule}` (chapter: `def:unitModule`)
- **Lean target exists**: yes — `noncomputable abbrev unitModule` at L102
- **Signature matches**: yes — `(X : Scheme.{u}) : X.Modules`, body `SheafOfModules.unit X.ringCatSheaf`; chapter says "the structure sheaf viewed as a module over itself, i.e. Mathlib's `SheafOfModules.unit`"
- **Proof follows sketch**: N/A (definition, not a proof)
- **notes**: Made public this iter (previously `private`). No signature change. The chapter's `\leanok` is consistent. The directive's motivation ("SNAP graded assembly states unitality against this object") matches the chapter's prose at `def:unitModule`.

---

### All other `\lean{...}` blocks (pre-existing, not modified this iter)

The following were checked for continued correctness (no regressions from new work):

| Chapter label | Lean decl | Status |
|---|---|---|
| `def:monoidalPresheaf` | `MonoidalPresheaf` (private abbrev, L85) | ✓ |
| `def:schemeModuleSheafification` | `sheafification` (L76) | ✓ |
| `def:sheafTensorObj` | `tensorObj` (L92) | ✓ |
| `def:sheafTensorPow` | `tensorPow` (L108) | ✓ |
| `lem:tensorPow_zero` | `tensorPow_zero` (private simp, L112) | ✓ |
| `lem:tensorPow_succ` | `tensorPow_succ` (private simp, L114) | ✓ |
| `def:sheafModuleTwist` | `moduleTensorPow` (L120) | ✓ |
| `lem:moduleTensorPow_zero` | `moduleTensorPow_zero` (private simp, L123) | ✓ |
| `def:sheafificationCounitIso` | `sheafificationCounitIso` (private, L139) | ✓ |
| `def:tensorObjUnitIso` | `tensorObjUnitIso` (private, L148) | ✓ |
| `def:tensorObjRightUnitor` | `tensorObjRightUnitor` (private, L159) | ✓ |
| `def:tensorBraiding` | `tensorBraiding` (private, L172) | ✓ |
| `def:snap_opensTopology` | `opensTopology` (private abbrev, L213) | ✓ |
| `lem:isIso_sheafification_map_iff` | `isIso_sheafification_map_iff` (L226) | ✓ |
| `lem:localIso_toPresheaf_map_unit` | `localIso_toPresheaf_map_unit` (L251) | ✓ |
| `lem:isIso_sheafification_map_unit` | `isIso_sheafification_map_unit` (L263) | ✓ |
| `def:snap_objRestrict` | `objRestrict` (private, L456) | ✓ |
| `lem:snap_objRestrict_apply` | `objRestrict_apply` (private, L464) | ✓ |
| `lem:snap_objRestrict_id` | `objRestrict_id` (private, L469) | ✓ |
| `lem:snap_objRestrict_comp` | `objRestrict_comp` (private, L477) | ✓ |
| `def:relTensorDomainPresheaf` | `relTensorDomainPresheaf` (L492) | ✓ |
| `def:relTensorTriplePresheaf` | `relTensorTriplePresheaf` (L523) | ✓ |
| `def:relTensorActL` | `relTensorActL` (L560) | ✓ |
| `def:relTensorActR` | `relTensorActR` (L602) | ✓ |
| `def:relTensorProj` | `relTensorProj` (L640) | ✓ |
| `lem:snap_relTensorActL_proj_eq` | `relTensorActL_proj_eq` (L680) | ✓ |
| `lem:relativeTensor_objectwise_coequalizer` | `RelativeTensorCoequalizer.*` (L287–429) | ✓ |
| `lem:relativeTensor_as_coequalizer` | `relativeTensorCoequalizerIso` (L710) | ✓ |
| `lem:snap_ztensor_whisker_localIso` | `ztensor_whisker_localIso` (L1415) | ✓ |
| `lem:isIso_sheafification_whiskerRight_unit` | `isIso_sheafification_whiskerRight_unit` (L1540) | ✓ |
| `def:sectionMul` | `sectionsMul` (L196) | ✓ |

---

## Red flags

### Placeholder / suspect bodies
None. The file is entirely sorry-free. No `:= sorry`, `:= True`, `:= Classical.choice _`, or similar placeholder bodies are present.

### Excuse-comments
None active. There are stale *handoff* comments in `/- ... -/` documentation blocks — specifically:

- **L58–61** (module docstring): states "`lem:sheafTensorPow_add` is **deferred**" — this is now closed in this iter.
- **L856–970** (old handoff block): opens with "The tensor-power comparison isomorphism `tensorPowAdd` — DEFERRED (handoff)" and later says "is **not** provided in this iteration" — now stale.

These are planner/documentation comments in block-comment form, not excuse-comments attached to any active declaration. They describe the state as of a prior iteration and will mislead a future reader. They should be pruned. Classified as **minor** (stale documentation, not active excuse-comments).

### Axioms / Classical.choice on non-trivial claims
None detected. All declarations are `noncomputable` (expected for sheaf-category constructions) and there are no `axiom` declarations.

---

## Unreferenced declarations (informational)

The following declarations have no `\lean{...}` reference in the chapter. All are private and clearly proof-internal infrastructure:

- `ZTensorWhisker` section (L993–1397): 17 private declarations (`toULiftIntLinearMap`, `uTensorEquiv`, `uTripleEquiv`, `uModPresheaf`, `uModRingPresheaf`, `uModHom`, `modToAb`, `W_whiskerRight_modToAb_iff`, `uModForgetIso`, `uDomIso`, `uTripIso`, `domWhisker`, `tripWhisker`, `W_uModHom`, `W_domWhisker`, `W_tripWhisker`, `actL_domWhisker`, `actR_domWhisker`, `proj_domWhisker`) — all private infrastructure for `ztensor_whisker_localIso`. The blueprint's proof sketch for `lem:snap_ztensor_whisker_localIso` (L732–761) describes both the ULift-ℤ transfer step and the coequalizer-descent step at exactly the right level of detail for these helpers; no individual blueprint blocks needed.
- `tensorObjWhiskerRightIso` (L1660) and `tensorObjWhiskerLeftIso` (L1709) — discussed above, proof-internal.

No unreferenced declaration suggests a substantive formalization gap.

---

## Blueprint adequacy for this file

- **Coverage**: All 20 public/named declarations in this file (plus all private helpers) have corresponding `\lean{...}` blocks in the chapter OR are clearly proof-internal and exempt. **Coverage: adequate.**

- **Proof-sketch depth**: **adequate** for all declarations formalized in this file. Both `cor:sheafTensorObjAssoc` (L1070–1128) and `lem:sheafTensorPow_add` (L1161–1247) provide step-by-step proof sketches with explicit sub-step labeling ((a)–(e) for `tensorPowAdd`, three-segment for `tensorObjAssoc`). The matching between sketch and Lean code is tight. The `lem:snap_ztensor_whisker_localIso` proof sketch (L732–761) is detailed enough to have guided the large `ZTensorWhisker` infrastructure.

- **Hint precision**: **precise**. All `\lean{...}` hints name the correct fully-qualified Lean declarations. The private helpers that lack `\lean{...}` references are identified as proof-internal in the planner strategy comments.

- **Generality**: **matches need**. The constructions are at the scheme level, and the private abbreviations (`MonoidalPresheaf`, `opensTopology`) correctly specialize to the required form.

- **One gap — constraints of `tensorPowAdd` not separately formalized**: The statement of `lem:sheafTensorPow_add` (L1130–1159) includes commutativity and associativity *constraints* on the family `{μ_{m,m'}}`. The Lean `tensorPowAdd` provides only the isomorphism; the constraints have no `\lean{...}` references and no Lean lemmas yet. The blueprint's proof of these constraints is informal prose (L1228–1246). When `sectionGradedRing_gcommSemiring` and `sectionGradedModule_gmodule` are attempted, these constraints will need separate Lean lemmas. **Recommended chapter-side action**: add `\lean{...}` stubs for the commutativity and associativity constraint lemmas of `tensorPowAdd` when those are formalized.

- **Three declarations in the chapter are not yet in this Lean file**:
  - `lem:sectionMul_coherent` → `AlgebraicGeometry.Scheme.Modules.sectionsMul_assoc_unit` (no `\leanok` in chapter; not yet formalized)
  - `lem:sectionGradedRing_gcommSemiring` → `AlgebraicGeometry.sectionGradedRing_gcommSemiring` (different namespace, presumably a different file)
  - `lem:sectionGradedModule_gmodule` → `AlgebraicGeometry.sectionGradedModule_gmodule` (same)
  These are open formalization tasks in sections 2 and 3 of the chapter; they are correctly unmarked in the blueprint. No action required now.

- **Recommended chapter-side actions**:
  1. Prune the stale module-level docstring sentence (L58–61) that says `tensorPowAdd` is deferred.
  2. Prune or archive the large deferred-handoff comment block (L856–970) inside the Lean file (these are in the Lean source, not the blueprint, but the plan agent should schedule a cleanup pass).
  3. When `tensorPowAdd` constraints are formalized, add `\lean{...}` references for the commutativity and associativity lemmas to `lem:sheafTensorPow_add`.

---

## Severity summary

| Finding | Severity |
|---|---|
| Stale module docstring (L58–61): says `tensorPowAdd` is deferred | minor |
| Stale handoff comment block (L856–970): says `tensorPowAdd` not provided | minor |
| `tensorPowAdd` commutativity/associativity constraints stated in blueprint but unformalized in Lean; no `\lean{...}` stubs for them | minor |
| `sectionsMul_assoc_unit`, `sectionGradedRing_gcommSemiring`, `sectionGradedModule_gmodule` in chapter but not yet in Lean file | informational (open tasks, correctly unmarked) |

**No must-fix-this-iter findings.**

**Overall verdict**: The two sorries closed this iter (`tensorObjAssoc` and `tensorPowAdd`) are correctly formalized and faithfully follow their blueprint proof sketches; the file is sorry-free; no signature mismatches, no placeholder bodies, no axiom introductions; the blueprint is adequate for all currently-formalized declarations. Two stale handoff comments and the unformalized `tensorPowAdd` coherence constraints are minor issues deferred to a cleanup pass.
