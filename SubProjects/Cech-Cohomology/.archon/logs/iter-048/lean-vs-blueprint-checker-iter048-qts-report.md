# Lean ↔ Blueprint Check Report

## Slug
iter048-qts

## Iteration
048

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_quasicoherent}` (chapter: `lem:qcoh_isIso_fromTildeGamma`, line 5212)

- **Lean target exists**: yes — `instance isIso_fromTildeΓ_of_quasicoherent` at line 1530, in section `IsoFromTildeGammaAssembly`.
- **Signature matches**: yes. Blueprint: "Let X = Spec R, F quasi-coherent ⟹ IsIso fromTildeΓ." Lean: `instance isIso_fromTildeΓ_of_quasicoherent (F : (Spec R).Modules) [F.IsQuasicoherent] : IsIso F.fromTildeΓ`. Exact match; registered as a typeclass `instance` so it discharges the `[IsIso F.fromTildeΓ]` hypothesis of `qcoh_iso_tilde_sections` unconditionally for quasi-coherent `F`.
- **Proof follows sketch**: partial (minor path deviation; mathematical content is the same).
  - Blueprint proof (lines 5247–5262): "The forgetful functor reflects isomorphisms and {D(f)} is a basis (`lem:forget_reflectsIso_mathlib` = `SheafOfModules.fullyFaithfulForget`); check each D(f) component; each component is the localization lift of ρ_f; both `tilde.toOpen` and ρ_f are `IsLocalizedModule` at powers of f; hence the lift is an iso by `lem:isLocalizedModule_linearEquiv_mathlib`."
  - Lean (lines 1531–1543): reduces to `IsIso (modulesSpecToSheaf.map F.fromTildeΓ)` via `SpecModulesToSheafFullyFaithful.isIso_of_isIso_map` (not `SheafOfModules.fullyFaithfulForget`), then uses `Functor.IsCoverDense.iso_of_restrict_iso` on the basic-open subsite (cover-dense by `TopCat.Opens.coverDense_inducedFunctor`) and `NatIso.isIso_of_isIso_app`, delegating the per-component check to `isIso_fromTildeΓ_app_basicOpen`.
  - **Mathematical content is equivalent** (both arguments reduce to checking on the basis D(r) using fully-faithfulness), but the specific Mathlib lemma for the fully-faithful step is `SpecModulesToSheafFullyFaithful` (about the functor `modulesSpecToSheaf`, Lean's technical path for the affine scheme setting), not `SheafOfModules.fullyFaithfulForget` (the general forgetful functor to abelian groups cited in the blueprint). Neither `isIso_fromTildeΓ_iff` nor `SheafOfModules.fullyFaithfulForget` is invoked in the Lean proof.
- **notes**: No sorry. No excuse-comments. Registered as `instance` — correct, as the blueprint explicitly says it "discharges the [IsIso F.fromTildeΓ] hypothesis of lem:qcoh_iso_tilde_sections." The `\leanok` on both the statement block (line 5210) and proof block (line 5246) is consistent with zero sorries.

---

### `\lean{AlgebraicGeometry.isIso_fromTildeΓ_app_basicOpen}` (private helper, bundled into `lem:qcoh_isIso_fromTildeGamma`, line 5213–5214)

- **Lean target exists**: yes — `private lemma isIso_fromTildeΓ_app_basicOpen` at line 1478.
- **Signature matches**: yes. The helper establishes `IsIso ((modulesSpecToSheaf.map F.fromTildeΓ).hom.app (Opposite.op (PrimeSpectrum.basicOpen r)))` for `[F.IsQuasicoherent]` and `r : R`. This is precisely the per-component step that the blueprint proof sketch describes: "the component of fromTildeΓ over each D(f) is an isomorphism."
- **Proof follows sketch**: yes. The detailed blueprint proof (lines 5249–5262) matches the Lean exactly:
  1. `tilde.toOpen` is `IsLocalizedModule (powers r)` — Lean: `haveI hlf : IsLocalizedModule ... := inferInstance` (Mathlib instance). ✓
  2. `ρ_r` is `IsLocalizedModule (powers r)` via the keystone — Lean: `haveI hlg := qcoh_section_isLocalizedModule F r`. ✓
  3. Component `c.hom ∘ tilde.toOpen = ρ_r` from `toOpen_fromTildeΓ_app` — Lean: `have hcomp := Scheme.Modules.toOpen_fromTildeΓ_app F ...` then `hcomp'` at linear-map level. ✓
  4. `c.hom` agrees with the canonical equiv `IsLocalizedModule.linearEquiv` between the two localizations — Lean: lines 1507–1520. ✓
  5. `e.bijective` → `IsIso` via `ConcreteCategory.isIso_iff_bijective`. ✓
- **notes**: `private` qualifier is appropriate for an internal assembly step. Blueprint directive specifies it is "bundled into the `\lean{}` of `lem:qcoh_isIso_fromTildeGamma`" which matches the `\lean{}` entry at line 5213–5214.

---

## Red flags

No red flags.

### Placeholder / suspect bodies
None. No `:= sorry`, `:= True`, `:= rfl` on non-trivial claims, or `Classical.choice _` patterns found in the new declarations or anywhere in the file.

### Excuse-comments
None. No `-- TODO replace`, `-- placeholder`, `-- temporary`, or `-- wrong but works for now` comments found.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations introduced. (Confirmed by grep: the only `axiom`-string hits in the file are inside doc-string prose.)

---

## Unreferenced declarations (informational)

The following declarations in `QcohTildeSections.lean` have no `\lean{...}` reference in the blueprint chapter. All are genuine helpers or supporting lemmas that the blueprint's prose describes inline:

- `qcoh_iso_tilde_sections_of_genSections` (line 133) — not `\lean{}`-pinned but mentioned in the `## Handoff` comment and in the blueprint's Route-A remark.
- `free_isQuasicoherent` (line 106) — project-local instance, mentioned in the Handoff section as an axiom-clean asset.
- `isIso_fromTildeΓ_of_genSections` (line 120) — as above.
- `qcoh_section_kernel_comparison` (line 1446) — has its own `\lean{}` pin at blueprint line 5095 area (`AlgebraicGeometry.qcoh_section_kernel_comparison`); not part of the scope of this check but exists and is pinned.
- The large collection of private helpers (`exists_sum_pow_eq_one`, `mem_range_of_span_pow`, `per_j_surj`, `per_j_eq`, `bump_eq`, `eq_zero_of_span_pow`, `map_smul_endFun`, `coversTop_iSup_eq_top`, `res_trans_apply`, `overlap_target_eq`, `presheaf_map_comp₂_apply`, `tile_appIso_comp`, `appIso_inv_res`, `appIso_inv_res_assoc`, `tileReconcileEquiv_apply`, `tileReconcileEquiv_symm_apply`, `tile_restrict_map_apply`) — all legitimately private helpers, not expected to have `\lean{}` pins.

None of these suggest the blueprint is under-specified; they are all documented inline as "project-local" or "private helpers" with precise docstrings cross-referencing the blueprint steps.

---

## Blueprint adequacy for this file

**Coverage**: Both public-facing declarations added this iter (`isIso_fromTildeΓ_of_quasicoherent` and its private helper `isIso_fromTildeΓ_app_basicOpen`) are `\lean{}`-pinned in the chapter at lines 5213–5214. The overall chapter coverage for this file is high: every public declaration has either a direct `\lean{}` pin or is documented in an inline remark with explicit reference to the blueprint step it implements.

**Proof-sketch depth**: adequate for `isIso_fromTildeΓ_app_basicOpen` (the per-component argument at blueprint lines 5249–5262 is detailed enough that a prover could reproduce it step-by-step). Adequate-but-imprecise for `isIso_fromTildeΓ_of_quasicoherent` (the "forgetful functor reflects isomorphisms" step is described at the correct mathematical level but names `SheafOfModules.fullyFaithfulForget` while the Lean uses `SpecModulesToSheafFullyFaithful` + `IsCoverDense.iso_of_restrict_iso`; a prover with access to Mathlib could navigate this, but the blueprint doesn't give the precise API path).

**Hint precision**: loose for the proof of `isIso_fromTildeΓ_of_quasicoherent`. The `\uses{}` block lists two entries not actually used in Lean:
  1. `lem:isIso_fromTildeGamma_iff_mathlib` (`AlgebraicGeometry.isIso_fromTildeΓ_iff`): listed, but the Lean proof never invokes `isIso_fromTildeΓ_iff`. It appears in the blueprint proof only as a parenthetical equivalence remark ("Equivalently, this exhibits F in the essential image..."), not as a proof step.
  2. `lem:forget_reflectsIso_mathlib` (`SheafOfModules.fullyFaithfulForget`): listed, but the Lean uses `SpecModulesToSheafFullyFaithful.isIso_of_isIso_map` (fully faithfulness of `modulesSpecToSheaf`, not of the forgetful functor to abelian groups). `SpecModulesToSheafFullyFaithful` has no corresponding `\lean{}`-pinned blueprint lemma and does not appear in `\uses{}`.

**Generality**: matches need — the lemma is stated and proved for general quasi-coherent `F` on `Spec R`.

**Recommended chapter-side actions** (all minor; nothing blocking):
- Correct `\uses{lem:qcoh_isIso_fromTildeGamma}` to remove the stale `lem:isIso_fromTildeGamma_iff_mathlib` entry (only mentioned parenthetically, not a Lean dependency).
- Replace `\uses{lem:forget_reflectsIso_mathlib}` with a reference to the actual Mathlib lemma cluster used: `SpecModulesToSheafFullyFaithful` (fully faithful `modulesSpecToSheaf`) + `Functor.IsCoverDense.iso_of_restrict_iso`. If those don't have dedicated blueprint lemmas, add a `% NOTE:` comment to the proof block clarifying the Lean-side API choice.
- These are blueprint-prose cleanups; they do not affect the correctness of the Lean file.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `\uses{lem:isIso_fromTildeGamma_iff_mathlib}` listed but not a Lean dependency | minor |
| `\uses{lem:forget_reflectsIso_mathlib}` listed; Lean uses `SpecModulesToSheafFullyFaithful` instead | minor |
| Blueprint proof says "forgetful functor"; Lean uses `modulesSpecToSheaf` fully faithful + cover-dense subsite | minor (mathematically equivalent, same proof idea) |

No must-fix-this-iter findings. No major findings. Three minor blueprint-side imprecisions in the `\uses{}` and proof sketch.

**Overall verdict**: Both `isIso_fromTildeΓ_of_quasicoherent` and `isIso_fromTildeΓ_app_basicOpen` are axiom-clean, correctly signed, and mathematically faithful to the blueprint — 2 declarations checked, 0 red flags, 3 minor `\uses{}`/proof-sketch imprecisions on the blueprint side.
