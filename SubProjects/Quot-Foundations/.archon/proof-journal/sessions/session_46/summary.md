# Session 46 (iter-046) — Review Summary

## Metadata
- **Sorry count:** 4 → 4 (QuotScheme.lean; the 4 are pre-existing protected iter-176 file-skeleton stubs
  at L126/165/201/228 — `hilbertPolynomial`/`QuotFunctor`/`Grassmannian`/`Grassmannian.representable`).
  **New decls add 0 sorries.**
- **Targets attempted:** 1 prover lane — QUOT annihilator characterization (`Scheme.Modules.annihilator_ideal`).
- **Files edited:** `AlgebraicJacobian/Picard/QuotScheme.lean` (+2 axiom-clean decls).
- **Build:** `lake build AlgebraicJacobian.Picard.QuotScheme` GREEN (8317 jobs); only pre-existing style
  lints (long lines, maxHeartbeats comments). `#print axioms` both decls = `{propext, Classical.choice,
  Quot.sound}`.
- **leandag:** gaps=0, unmatched=1 (`annihilator_map_basicOpen` — new helper, no blueprint block yet).

## Target: `annihilator_ideal` (lem:modules_annihilator_ideal) — SOLVED (with justified deviation)
Two decls landed:

### `annihilator_map_basicOpen` (~L2728) — per-affine coherence (the `map_ideal_basicOpen` content)
- **Statement:** for QC `F`, affine `V`, `f : Γ(X,V.1)`, `[Module.Finite Γ(X,V.1) Γ(F,V.1)]`:
  `(Ann_{Γ(X,V.1)} Γ(F,V.1)).map (X.presheaf.map (homOfLE (basicOpen_le f)).op).hom = Ann_{Γ(X,D(f))} Γ(F,D(f))`.
- **Proof:** local instance setup mirroring the file idiom (L2100–2109): `haveI := V.2.isLocalization_basicOpen f`;
  `letI : Module Γ(X,V.1) Γ(F,D(f)) := Module.compHom _ (algebraMap …)`;
  `haveI : IsScalarTower … := IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)`;
  `haveI := isLocalizedModule_basicOpen F V.2 f` (gap2). Body =
  `(Module.annihilator_isLocalizedModule_eq_map (Submonoid.powers f) (restrictBasicOpenₗ F f)).symm`.
- The defeq `algebraMap Γ(X,V.1) Γ(X,D(f)) = (X.presheaf.map …).hom` holds via
  `algebra_section_section_basicOpen` (restriction's `.toAlgebra`); `exact` discharges it.
- This is the genuine new content: localized-annihilator engine transported across gap2 section localization.

### `annihilator_ideal` (~L2761) — affine-open characterization — SIGNATURE DEVIATES FROM BLUEPRINT
- **Delivered:** `(F) [F.IsQuasicoherent] (hfin : ∀ V : X.affineOpens, Module.Finite Γ(X,V.1) Γ(F,V.1)) (U) :
  (annihilator F).ideal U = Module.annihilator Γ(X,U.1) Γ(F,U.1)`.
- **Proof:** assemble `I : X.IdealSheafData := ⟨fun V => Ann …, ?_, _, rfl⟩`, discharge `map_ideal_basicOpen`
  per-`V` via `annihilator_map_basicOpen F V f` (using `hfin V`); then
  `congr($(IdealSheafData.ofIdeals_ideal I).ideal U)` reads off the value at every `U`. Needs
  `set_option backward.isDefEq.respectTransparency false` (structure-literal defeq), mirroring `Hom.ker_apply`.

### Deviation analysis (blueprint asked single-`U` instance form)
- **Attempt 1 (single-`U`, as blueprinted): FAILED — proven unprovable, not just unattempted.**
  `annihilator F = ofIdeals (V ↦ Ann …) = sSup {J | J.ideal ≤ family}` = the *largest coherent* ideal sheaf
  ≤ the family. Forward `≤` is free (`annihilator_ideal_le`). Reverse `Ann_{Γ(X,U)}(Γ(F,U)) ≤ (annihilator
  F).ideal U` at a single `U` holds iff the family already coheres globally (`map_ideal_basicOpen` at *every*
  affine open). The localization route (`le_of_isLocalized_span` over a `D(fᵢ)` cover of `U`) is **circular**:
  reduces to the same reverse inclusion at each `D(fᵢ)`. The blueprint's claimed
  `(ofIdeals I).ideal U = ⨅_{D(f)⊆U} comap_f(I(D(f)))` formula is **FALSE** for `ofIdeals`.
- **Attempt 2 (global `hfin`): SUCCESS.** Honest analogue of Mathlib `Hom.ker_apply` (global `QuasiCompact`).
  Finite-type `F` discharges `hfin` via G1 affine-locality (`lem:gf_qcoh_fintype_finite_sections`) once it lands.

## Subagent reviews (this phase)
- **lean-auditor `quot-iter046`** (0/0/1): both decls axiom-clean, honest, all hypotheses used, idioms correct.
  Sole minor = opaque `_` field-slot in the `⟨…, ?_, _, rfl⟩` structure literal (L2765); cosmetic. Pre-existing
  majors out of focus (deprecated `Sheaf.Hom.mk` L936–945, bare maxHeartbeats L1100–1281). Report:
  `logs/iter-046/lean-auditor-quot-iter046-report.md`.
- **lean-vs-blueprint-checker `quot-iter046`** (2 must-fix / 1 major, all BLUEPRINT-side; Lean correct):
  (1) statement hypothesis wrong (single-`U` vs global) → `% NOTE:` added; (2) proof "section = ⨅ comap"
  step mathematically false → `% NOTE:` added; (3) `annihilator_map_basicOpen` has no `\lean{}` block →
  coverage debt for planner. Report: `logs/iter-046/lean-vs-blueprint-checker-quot-iter046-report.md`.

## Blueprint doctor
- 1 finding: `\Rrightarrow` used in `Cohomology_FlatBaseChange.tex` (L2230–2246, FBC adjunction prose) but
  defined nowhere → `leanblueprint web` will crash. Needs a `\providecommand{\Rrightarrow}` in
  `macros/common.tex` (planner domain; outside review's chapter-only write scope). Surfaced in recommendations.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `lem:modules_annihilator_ideal`: added `% NOTE:` (iter-046 review) documenting
  (a) the global-`hfin` vs single-`U` hypothesis deviation and (b) the false "section = ⨅ comap" proof step,
  with explicit plan-agent rewrite instructions. `\lean{…annihilator_ideal}` name unchanged (correct).
- No `\leanok` override needed: `sync_leanok` (iter 46, sha a9b6c42, +5/-0) correctly marked the decls; the
  deviation is a hypothesis-strength prose mismatch, not a formalization gap.

## Notes (LOW)
- lean-auditor minor: `⟨…, ?_, _, rfl⟩` field slots are auto-inferred without annotation — mildly opaque but
  not wrong; cosmetic only.
