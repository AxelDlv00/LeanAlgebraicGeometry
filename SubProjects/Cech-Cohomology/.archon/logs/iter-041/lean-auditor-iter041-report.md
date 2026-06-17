# Lean Audit Report

## Slug
iter041

## Iteration
041

## Scope
- files audited: 1 (per directive)
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/QcohTildeSections.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor — see notes)
- **excuse-comments**: none
- **notes**:
  - **`res_trans_apply` (lines 576–581)**: Clean presheaf-functoriality helper. `rw [← ModuleCat.comp_apply, ← P.map_comp]; rfl` correctly assembles two restriction maps into one via the functor composition law, then closes by `rfl` — which fires because in the thin opens-poset the composite morphism equals the direct one definitionally. Not spurious.
  - **`qcoh_section_equalizer` (lines 592–639)**: Substantive two-part theorem; no sorry, no spurious rfl. Injectivity branch calls `hsheaf.section_ext` and supplies, for each point `x ∈ W`, a cover-member open `U i ≤ W` containing `x` where the restrictions agree — exactly the form that lemma needs. Exactness branch: forward direction calls `P.existsUnique_gluing'` from the `UniqueGluing` import with the correct arguments (`U`, `W`, `fun i => homOfLE (hUW i)`, `hWU`, `t`, `hcompat`) and destructs the unique section; backward direction uses two `res_trans_apply` rewrites that each collapse a composite restriction to the single restriction, leaving both sides identical (goal closes implicitly). The compatibility proof `hcompat` correctly extracts `hij.symm` from the `δ t = 0` hypothesis and matches `IsCompatible`'s field order.
  - **`qcoh_section_equalizer` — `.2` accessor (line 610)**: `P.2 : P.presheaf.IsSheaf` where `P = modulesSpecToSheaf.obj F : TopCat.Sheaf (ModuleCat R) _`. This IS the real `IsSheaf` proof — the second component of the `Sheaf` subtype. Not an unrelated `FullSubcategory.property`.
  - **`isLocalizedModule_powers_restrictScalars_of_algebraMap` (lines 662–701)**: Direct three-clause `IsLocalizedModule` proof; no sorry. `map_units` clause: converts between `f^k`- and `(algebraMap R A f)^k`-endomorphisms using `hsmul` + `convert hb using 1; ext n` — mildly verbose but logically tight. `surj` clause: calc chain `f^k • y = (algebraMap R A f)^k • y = (s : A) • y = φ m` is correct. `exists_of_eq` clause: symmetric calc chain `f^k • x₁ = ... = f^k • x₂` is correct.
  - **LSP diagnostics**: zero errors, zero warnings in the focal range (lines 576–702) and file-wide.
  - **Axiom check (`lean_verify`)**: both `qcoh_section_equalizer` and `isLocalizedModule_powers_restrictScalars_of_algebraMap` use only `propext`, `Classical.choice`, `Quot.sound` — Lean's standard foundational axioms. No `sorry`, no unauthorized axioms.
  - **Import**: `Mathlib.Topology.Sheaves.SheafCondition.UniqueGluing` is new this iter and appropriate — it supplies `existsUnique_gluing'`, `IsCompatible`, and `IsSheaf.section_ext`. No deprecation warnings.
  - **Minor — `simp only []` no-ops**: Empty simp lists appear at approximately lines 284, 291, 320, 321, 684, 693 (inside the private helpers `per_j_surj`, `per_j_eq`, and `isLocalizedModule_powers_restrictScalars_of_algebraMap`). These are defensive normalization calls after `obtain` destructs that introduce coercion/subtype noise. Harmless but mildly code-smelly; could be replaced by `change ...` or simply removed if the goal is already in normal form.
  - **Rest of file (lines 1–575)**: No new issues. Pre-existing declarations (`qcoh_iso_tilde_sections`, `isLocalizedModule_of_span_cover`, `tilde_section_isLocalizedModule`, `section_isLocalizedModule_of_isIso_fromTildeΓ`, etc.) are unchanged and were clean in previous audits.

---

## Must-fix-this-iter

*None.*

---

## Major

*None.*

---

## Minor

- `QcohTildeSections.lean:~284,291,320,321,684,693` — `simp only []` (empty simp, no-op) in private helpers and one public lemma. Stylistically unclean; implies the authors wanted something to normalize but left an empty list. Suggest removing or replacing with explicit `change`/`show` if normalization is genuinely needed.

---

## Excuse-comments (always called out separately)

*None.*

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 1 (empty `simp only []` calls, no soundness impact)
- **excuse-comments**: 0

Overall verdict: All three focal declarations (`res_trans_apply`, `qcoh_section_equalizer`, `isLocalizedModule_powers_restrictScalars_of_algebraMap`) are genuine, non-vacuous proofs with no sorry, no spurious rfl, no unauthorized axioms, and no kernel-soundness traps; the file is clean.
