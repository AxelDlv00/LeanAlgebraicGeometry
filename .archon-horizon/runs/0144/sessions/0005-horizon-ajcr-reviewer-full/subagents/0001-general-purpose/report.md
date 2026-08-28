Done. The file is complete and verified.

## Status: complete

**File created:** `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/RelPicBaseLocalTriviality.lean` (185 lines, new file only — no existing file touched)

## Declarations proved (all `sorry`-free)

1. `CommRing.Pic.exists_notMem_mapAlgebra_eq_one` (line 61) — Zariski-local triviality of `Pic B`: for any class `P` and prime `q`, some `f ∉ q.asIdeal` has `mapAlgebra B (Localization.Away f) P = 1`.
2. `AlgebraicGeometry.exists_notMem_cechPicMap_specMap_eq_one` (line 91) — the same for Čech Picard classes of `Spec B`, via `toPic`/`toPic_injective`/`toPic_map` and the `ΓSpecIso` naturality bridge.
3. `AlgebraicGeometry.exists_notMem_cechPicMap_eq_of_relPicMk_eq` (line 140) — **spec theorem 1**, statement verbatim as specified.
4. `AlgebraicGeometry.DivFamZarAff.exists_notMem_picClass_map_eq_of_relPicMk_eq` (line 169) — **spec theorem 2** (picClass consumer), statement verbatim, via `mapAlgHom_eq_mapAlg (fun _ => rfl)` + `picClass_mapAlg`.

## Axiom audit

`#print axioms` via `lake env lean` (independent of LSP), all four declarations: exactly `[propext, Classical.choice, Quot.sound]`. `lean_verify` MCP confirms the same for both spec theorems; its source scan flags only the `attribute [local instance]` line, which is the standard project idiom copied from sibling files (DivisorFamilyAffAbel.lean).

## Verification commands

- `lake env lean AlgebraicJacobian/Picard/RelPicBaseLocalTriviality.lean` → exit 0, empty output (no errors, no warnings), 8.6s.
- Axiom audit ran `lake env lean` on a copy of the file with `#print axioms` appended (no `lake build` executed, per spec). LSP diagnostics: zero items.

## Deviations from the spec (with reasons)

1. **Step 3 (Pic mini-lemma) uses a cleaner mathlib route** than the suggested `Module.exists_notMem_bijective_toSpanSingleton`: invertible ⇒ finite projective ⇒ `FinitePresentation`; stalk-free by `Module.free_of_flat_of_isLocalRing`; then mathlib's `Module.FinitePresentation.exists_free_localizedModule_powers` spreads freeness to a basic open directly, and `mapAlgebra_apply` + `mk_eq_one_iff_free` + `LocalizedModule.equivTensorProduct` kill the class. Same mathematics (invertible modules are Zariski-locally free), but no fibre-nonzero element construction needed. Consequently `cechPicEquivPic` (step 2) was unnecessary — `toPic`, `toPic_injective`, `toPic_map` suffice; the Γ-vs-B identification is handled by `Scheme.ΓSpecIso` + `CommRing.Pic.mapRingHom` functoriality.
2. **Step 4 square re-derived at homogeneous spelling**: rewriting with `relCurveMap_snd` inside the goal failed (kabstract type-check at instances transparency, `relCurve` vs `(C ⊗ overSpec k B).left` spelling). I instead derived the same square from `whiskerLeft_snd` + `Over.comp_left` fully at the Over-product spelling (the identical computation performed inside `relCurveMap_snd`/`picFromBase_le_comap`), converted the goal by definitional `change`, and transported `hkill` to `(overSpecMap …).left` by `rfl`-defeq.
3. **Theorem 1 carries an `omit`** of the three unused curve instances (`SmoothOfRelativeDimension 1`, `IsProper`, `GeometricallyIrreducible`): the standing variable block is present exactly as specified, but the mathlib linter set flags auto-included unused section variables, and `omit … in` is the established project idiom (e.g. DivisorFamilyAffAbel.lean). The statement is otherwise verbatim and strictly more general; the corollary keeps all three (required by `genus C` and the `DivFamZarAff` machinery).
4. Added `set_option backward.isDefEq.respectTransparency false` with the project's standard comment — same option as every sibling file mixing the `relCurve`/product spellings. No `maxHeartbeats` bump was needed.
