# Lean ↔ Blueprint Check Report

## Slug
ts249

## Iteration
249

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Summary of iter-249 work

The prover closed the abstract mate-calculus telescope inside `pullbackEtaUnitSquare`,
adding real proof code for steps 1–6 axiom-clean. The file now has **TWO sorries**:

1. `exists_tensorObj_inverse` (L699) — the deferred ⊗-inverse lane, explicitly documented
   as requiring bridges C and A; not touched this iter and not at issue.
2. `pullbackEtaUnitSquare` (L1741) — the `(∗∗)` presheaf-level residual (Y-side
   sheafification triangle + step-7 `ε`-reconciliation). This is the lone remaining
   content of D2′.

The chapter was updated to introduce `epsilonPresheafToSheafUnit` as a new blueprint block
(step 7, `lem:epsilon_presheaf_to_sheaf_unit`) with a `\lean{...}` hint but no `\leanok`.

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (L145)
- **Signature matches**: yes — `{X : Scheme.{u}} (M N : X.Modules) : X.Modules`
- **Proof follows sketch**: yes — sheafification of `PresheafOfModules.Monoidal.tensorObj`
- **notes**: fully defined, no sorry, `\leanok` on blueprint statement block ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (L160)
- **Signature matches**: yes — `(f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'`
- **Proof follows sketch**: yes
- **notes**: fully defined, no sorry ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}` (chapter: `lem:pullback_tensor_iso_unit`)
- **Lean target exists**: yes (L1747)
- **Signature matches**: yes — `IsIso (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf) (SheafOfModules.unit X.ringCatSheaf))`
- **Proof follows sketch**: yes — chains `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` →
  `isIso_sheafifyEta_of_unitSquare` → `pullbackEtaUnitSquare`
- **notes**: own body has no sorry; depends on `pullbackEtaUnitSquare` (which has a sorry).
  Blueprint statement block has `\leanok` ✓; proof block lacks `\leanok` ✓ (correct: not sorry-free).

### `\lean{AlgebraicGeometry.Scheme.Modules.compHomEquivFactor}` (chapter: `lem:comp_homequiv_factor_sheafify_pullback`)
- **Lean target exists**: yes (L1561)
- **Signature matches**: yes — for composable adjunctions, `(adj₁.comp adj₂).homEquiv c e g = adj₁.homEquiv c (R₂.obj e) (adj₂.homEquiv (L₁.obj c) e g)`
- **Proof follows sketch**: yes — `simp only [Adjunction.homEquiv_unit, Adjunction.comp_unit_app, ...] + Category.assoc`
- **notes**: proof CLOSED (no sorry). Blueprint statement block has `\leanok` ✓; proof block
  lacks `\leanok` — a `sync_leanok` state gap (not a blueprint error; sync_leanok should
  add this on next run). Minor only.

### `\lean{AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta}` (chapter: `lem:leftadjointuniq_app_unit_eta`)
- **Lean target exists**: yes (L1602)
- **Signature matches**: yes — `A.homEquiv _ _ (sheafificationCompPullback φ).hom.app 𝟙_ = presheafAdj.unit.app 𝟙_ ≫ (pushforward φ').map (sheafificationAdj_Y.unit.app (pullback φ' (𝟙_)))`, per the two-equality chain the blueprint describes
- **Proof follows sketch**: yes — uses `rfl`-linchpin `sheafificationCompPullback_eq_leftAdjointUniq`,
  then `homEquiv_leftAdjointUniq_hom_app A B` and `Adjunction.comp_unit_app`
- **notes**: proof CLOSED (no sorry). Blueprint statement block has `\leanok` ✓; proof block
  lacks `\leanok` — sync_leanok gap (minor).

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafUnit_comp_map_eta}` (chapter: `lem:presheaf_unit_comp_map_eta`)
- **Lean target exists**: yes (L1502)
- **Signature matches**: yes — `presheafAdj.unit.app 𝟙_ ≫ (pushforward φ').map (η (pullback φ')) = LaxMonoidal.ε (pushforward φ')`
- **Proof follows sketch**: yes — `Adjunction.unit_app_unit_comp_map_η` instantiated at the concrete adjunction
- **notes**: proof CLOSED (no sorry). Blueprint statement block has `\leanok` ✓; proof block
  lacks `\leanok` — sync_leanok gap (minor).

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_eq_leftAdjointUniq}` (chapter: `lem:sheafification_comp_pullback_eq_leftadjointuniq`)
- **Lean target exists**: yes (L1582)
- **Signature matches**: yes — `SheafOfModules.sheafificationCompPullback φ = (A.leftAdjointUniq B)` for the named composite adjunctions A and B
- **Proof follows sketch**: yes — `:= rfl` (the equality is definitional, as the blueprint proof says "holds by reflexivity")
- **notes**: proof CLOSED by `rfl` (no sorry). Blueprint statement block has `\leanok` ✓;
  proof block lacks `\leanok` — sync_leanok gap (minor).

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackEtaUnitSquare}` (chapter: `lem:eta_bridge_unit_square`)
- **Lean target exists**: yes (L1648)
- **Signature matches**: yes — `(pullbackValIso f 𝒪_X).inv ≫ a_Y.map (η (pullback φ')) ≫ sheafifyUnitIso.hom = pullbackObjUnitToUnit φ`
- **Proof follows sketch**: partial — steps 1–6 are closed axiom-clean (homEquiv
  transposition, compHomEquivFactor/leftAdjointUniqUnitEta, X-side triangle); step 7
  (`epsilonPresheafToSheafUnit`) is a remaining `sorry` at L1741
- **notes**: One `sorry` at L1741, the `(∗∗)` residual. Blueprint statement block has
  `\leanok` ✓ (declaration exists with sorry); proof block correctly lacks `\leanok` ✓.
  The comment at L1720–1740 documents the three remaining steps (i) pushforward-forget
  compat, (ii) Y-side triangle, (iii) `epsilonPresheafToSheafUnit`. The Lean comment at
  L1737-1740 also records the `Category.assoc` friction idiom
  `(Category.assoc _ _ _).symm.trans (hXtri ▸ Category.id_comp _)` needed for the
  Y-triangle — this implementation detail is NOT mentioned in the blueprint.

### `\lean{AlgebraicGeometry.Scheme.Modules.epsilonPresheafToSheafUnit}` (chapter: `lem:epsilon_presheaf_to_sheaf_unit`)
- **Lean target exists**: **no** — no `lemma`, `def`, or `axiom` with this name appears
  anywhere in `TensorObjSubstrate.lean`
- **Signature matches**: N/A (does not exist)
- **Proof follows sketch**: N/A
- **notes**: This is the step-7 target of `pullbackEtaUnitSquare`'s `(∗∗)` sorry, and it
  is the SOLE genuinely open mathematical item this iter. The blueprint correctly lacks
  `\leanok` on its statement block, reflecting the unformalized state. The `\lean{...}`
  hint pins the intended future Lean name — this is standard project workflow (plan agent
  writes `\lean{...}` hints before formalization). The sorry in `pullbackEtaUnitSquare`
  at L1741 explicitly documents this dependency as step (iii). No
  `must-fix-this-iter` issue; the blueprint is accurately forward-looking.

---

## Red flags

### Placeholder / suspect bodies
- `exists_tensorObj_inverse` at L699: `:= sorry` — the deferred ⊗-inverse lane.
  Blueprint correctly lacks `\leanok` on its proof block. Explicitly documented (C-bridge and
  A-bridge still pending). This is a **tracked open residual**, not introduced this iter.
- `pullbackEtaUnitSquare` at L1741: one `sorry` (the `(∗∗)` presheaf residual).
  Blueprint correctly lacks `\leanok` on the proof block. The statement block has `\leanok`
  (declaration exists). This is the **active D2′ sorry**, the expected state at end of iter-249.

### Excuse-comments
None. The comments in `pullbackEtaUnitSquare`'s sorry block (L1720–1740) document
WHAT REMAINS and HOW TO DO IT; they are forward-looking work notes, not excuse-comments
on wrong or temporary code.

### Axioms / Classical.choice on non-trivial claims
None found. No `axiom` declarations.

---

## Unreferenced declarations (informational)

Several declarations in the file have no corresponding `\lean{...}` in the chapter.
Most are helpers or infrastructure; the following are notable:

- `dualIsoOfIso` (L212) — "dual respects isos" helper; fits under `lem:internal_hom_isSheaf`
  informally but has no dedicated `\lean{...}` pin.
- `restrictIsoUnitOfLE` (L378) — helper for `tensorObj_isLocallyTrivial`; no pin.
- `isIso_of_isIso_restrict` (L551) — the B-connector; the chapter mentions it by name in
  prose but no `\lean{...}` block. **Worth pinning** (substantive, B-bridge label); currently
  a "major" adequacy gap (the chapter references the concept but not the Lean name).
- `homMk` (L592), `toPresheaf_map_homMk` (L600) — module-morphism promotion helpers; no pin.
- `unitToPushforwardObjUnit_comp` (L853), `pullbackObjUnitToUnit_comp` (L894) — pullback
  pseudofunctor coherence lemmas; `pullbackObjUnitToUnit_comp` is `\uses{}`-referenced in
  the chapter but lacks a `\lean{...}` statement block.
- `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` (L1386),
  `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` (L1435),
  `isIso_sheafifyEta_of_unitSquare` (L1525) — intermediate D2′ plumbing; referenced by name
  in the chapter prose or nearby comments but lack dedicated `\lean{...}` blocks.
- `sheafifyUnitIso` (referenced in `pullbackEtaUnitSquare` statements) — not separately
  referenced in the chapter.

These absences are informational; the chapter's coverage of the primary declarations
(`tensorObj`, `tensorObj_functoriality`, the 6 new D2′ lemmas) is complete.

---

## Blueprint adequacy for this file

- **Coverage**: The 8 `\lean{...}` blocks identified in the directive are all present in
  the chapter. The unreferenced helpers (see above) are minor; `isIso_of_isIso_restrict`
  is the one substantive declaration worth pinning in a future plan pass.
- **Proof-sketch depth**: **adequate** for the D2′ section. The 7-step proof sketch for
  `lem:eta_bridge_unit_square` is the most detailed in the chapter — it names each
  intermediate lemma (`compHomEquivFactor`, `leftAdjointUniqUnitEta`,
  `presheafUnit_comp_map_eta`, `sheafificationCompPullback_eq_leftAdjointUniq`) and
  specifies the mathematical content of each step. The `epsilonPresheafToSheafUnit` block
  clearly describes the step-7 goal (sectionwise equality, both maps act as
  `φ.hom.app X`). The prover should have no ambiguity about what to prove.
- **Hint precision**: **precise** for the 8 declarations in scope. The `\lean{...}` names
  are accurate for the 7 existing declarations and correctly point at the intended future
  name for `epsilonPresheafToSheafUnit`.
- **Generality**: matches need.
- **Technical debt noted**: The Lean comment at L1737-1740 documents the
  `Category.assoc` friction (`(Category.assoc _ _ _).symm.trans (hXtri ▸ Category.id_comp _)`)
  needed for Y-side triangle reasoning on `PresheafOfModules`-over-`Sheaf.val` composites.
  The blueprint doesn't mention this. It is a tactic-level detail, not a mathematical gap —
  the blueprint is not required to document it. However, adding a `% NOTE:` line to the
  `lem:eta_bridge_unit_square` proof block would help the prover avoid re-discovering the
  idiom for step (ii). This is a **minor** recommendation.
- **Recommended chapter-side actions**:
  - Add a `\lean{AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict}` block
    (statement-only, no proof obligation) to formally pin the B-connector.
  - Optionally add a `% NOTE:` in `lem:eta_bridge_unit_square`'s proof block documenting
    the `(Category.assoc _ _ _).symm.trans` idiom for the Y-side triangle (step ii).
  - After `epsilonPresheafToSheafUnit` is formalized and `sync_leanok` runs, the proof
    blocks of `compHomEquivFactor`, `leftAdjointUniqUnitEta`, `presheafUnit_comp_map_eta`,
    and `sheafificationCompPullback_eq_leftAdjointUniq` will gain `\leanok` automatically.

---

## Severity summary

- **must-fix-this-iter**: **NONE**
  - `epsilonPresheafToSheafUnit` is missing from the Lean file, but the blueprint
    correctly marks it as unformalized (no `\leanok`). This is the known open residual,
    not a blueprint misrepresentation.
  - No fake/placeholder statements, no wrong signatures, no excuse-comments, no axioms.
- **major**: `isIso_of_isIso_restrict` (and to a lesser extent `pullbackObjUnitToUnit_comp`)
  are substantive declarations that the chapter references by name but lacks `\lean{...}`
  blocks for. These are plan-agent tasks, not urgent prover blockers.
- **minor**:
  - Proof blocks of 4 closed lemmas (`compHomEquivFactor`, `leftAdjointUniqUnitEta`,
    `presheafUnit_comp_map_eta`, `sheafificationCompPullback_eq_leftAdjointUniq`) are
    missing `\leanok` markers — `sync_leanok` will repair these automatically on next run.
  - The `Category.assoc` idiom for Y-triangle reasoning is undocumented in the blueprint.

**Overall verdict**: Blueprint accurately represents the iter-249 state — the `(∗∗)` sorry in
`pullbackEtaUnitSquare` is the sole open residual of D2′, correctly shown as unformalized
`epsilonPresheafToSheafUnit`; all other checked declarations are complete and correctly matched.
8 declarations checked, 0 must-fix-this-iter red flags.
