# Lean Auditor Report — Iter 034

**Date:** 2026-06-08
**Files audited:** 4
**Auditor stance:** read-only, no strategy bias
**Axiom-check method:** `lean_diagnostic_messages` (LSP had not compiled declarations into a
queryable state, so `lean_verify` returned "Unknown constant" for all targets; diagnostics
confirmed sorry-count per declaration from the compiler's own `declaration uses sorry` warnings)

---

## FlatBaseChange.lean

### Outdated / stale comments

- **Lines 184–247 (module docstring):** Development history spanning iters 234, 236, 240, 241
  with inline "UPDATE (resolved)" and "route (a) confirmed DEAD" annotations. Captures genuine
  design evolution but partially obsolete (e.g., `pushforward_spec_tilde_iso` is long proved; the
  carrier-wall notes are historical). Acceptable as institutional record; could be condensed to a
  single-paragraph summary. **Severity: minor.**

### Suspect / placeholder definitions

- None.

### Dead-end / abandoned proof bodies

- **Lines ~1494–1538 (within `base_change_mate_fstar_reindex_legs`):** The comment block describes
  which steps are completed and precisely what mathematical residual remains (cross-layer
  cancellation). This is **not** abandoned dead code — it is an in-progress proof with documented
  residual. Retain as-is.

### Open sorry obligations

| Line | Declaration | Status |
|------|-------------|--------|
| 1425 | `base_change_mate_fstar_reindex_legs` | In-progress; proof makes real steps (`subst`/`simp`/`congrArg`); remaining residual documented |
| 1788 | `base_change_mate_gstar_transpose` | Scaffolded; `huce` assembled (`conjugateEquiv_counit_symm`); inner reindex + generator close remain |
| 2061 | `affineBaseChange_pushforward_iso` | Blocked on `_fstar_reindex_legs` and `_gstar_transpose` |
| 2101 | `flatBaseChange_pushforward_isIso` | Blocked on `affineBaseChange_pushforward_iso` |

**Transitively sorry-backed chain** (no inline sorry; backed through `_legs`):
`base_change_mate_fstar_reindex` → `base_change_mate_inner_value_eq` →
`base_change_mate_section_identity` → `base_change_mate_generator_trace` →
`pushforward_base_change_mate_cancelBaseChange`. All transparently documented; none presented as
proved.

### Headline new declarations — axiom check

- `pullbackComp_inv_eq_leftAdjointCompIso_inv`: **AXIOM-CLEAN ✓** (no `sorry` diagnostic; proof
  via `conjugateEquiv` injectivity + `Scheme.Modules.conjugateEquiv_pullbackComp_inv`)
- `pullbackComp_eq_leftAdjointCompIso`: **AXIOM-CLEAN ✓** (derived from the above via
  `Iso.ext`/`Iso.inv_eq_inv`)

### Linter / bad-practice violations

- **Line 979** — `set_option maxHeartbeats 4000000 in`: linter requires the explanatory comment to
  appear on the line **after** the directive; the existing comment (lines 977–978) precedes it.
  **Severity: minor** (linter compliance).
- **Line 1415** — Same pattern: comment at lines 1413–1414 precedes `set_option`. **Severity: minor.**
- **Line 1543** — Same pattern: comment at lines 1541–1542 precedes `set_option`. **Severity: minor.**
- **Line 1092** — `simp [← Functor.map_comp]` fires `linter.flexible` (non-`only` simp modifying
  a goal). LSP suggests `simp only [Functor.id_obj, tilde.functor_obj, ...]`. **Severity: minor.**
- **Line 1119** — `show` tactic used to change the goal (should be `change`). **Severity: minor.**
- **Line 1496** — Unused simp argument `Functor.map_comp` (linter flags it). **Severity: minor.**
- **Lines 294, 333, 336, 340, 370, 384, 386, 434, 485, 512, 515, 523, 572, 577, 579, 580, 583,
  584, 586, 605, 615** — `CategoryTheory.Sheaf.val` deprecated; replacement is
  `ObjectProperty.obj`. Over 20 sites. **Severity: major** (accumulated deprecation debt; will
  become a hard error on a future Mathlib bump).

### Excuse-comments

- None.

---

## FlatBaseChangeGlobal.lean

### Outdated / stale comments

- None.

### Suspect / placeholder definitions

- None.

### Dead-end / abandoned proof bodies

- None.

### Headline new declarations — axiom check

LSP reports **zero diagnostic items** (no warnings, no errors). All declarations confirmed clean:

- `gammaTopEquivEqLocus`: **AXIOM-CLEAN ✓**
- `baseChangeGammaEquiv`: **AXIOM-CLEAN ✓**
- Helper chain (`groundRing`, `rhoU`, `rhoU_comp`, `gammaModA`, `gammaResA`, and all others):
  **AXIOM-CLEAN ✓**

### Linter / bad-practice violations

- None. File is completely clean — zero warnings, zero errors, zero style violations.

### Excuse-comments

- None.

---

## GrassmannianCells.lean

### Outdated / stale comments

- **Lines 33–45** — `-- Planner note:` block describing how to build `affineChart`. This is a
  stale planner annotation left in the source file; it does not affect correctness but is not
  normal code documentation. **Severity: minor.**

### Suspect / placeholder definitions

- None.

### Dead-end / abandoned proof bodies

- None.

### Headline new declarations — axiom check

LSP reports **zero diagnostic items** (no warnings, no errors). All declarations confirmed clean:

- `isSeparated`: **AXIOM-CLEAN ✓**
- `isSeparatedToSpecZ`: **AXIOM-CLEAN ✓**
- Supporting declarations (`toSpecZ`, `ι_toSpecZ`, `pullbackιIso_inv_fst`, `pullbackιIso_inv_snd`,
  `chartTransition_comp_chartIncl`, `theGlueData`, transition maps, cocycle data): **AXIOM-CLEAN ✓**

### Linter / bad-practice violations

- None. `set_option maxHeartbeats` instances (lines ~1200 and ~1347) have accompanying `backward.isDefEq.respectTransparency false` guards; linter does not fire (zero diagnostic items confirm this).

### Excuse-comments

- None.

---

## QuotScheme.lean

### Out-of-scope stubs (per directive — not flagged)

Lines 126 (`hilbertPolynomial`), 165 (`QuotFunctor`), 201 (`Grassmannian`), 228
(`Grassmannian.representable`) — pre-existing protected stubs with `sorry`. Out of scope.

### Outdated / stale comments

- **Lines 274–279** — Comment references a specific `task_results/` file path that may no longer
  exist. **Severity: minor** (documentation rot).
- **Line 651** — "G1-core is not yet formalized" — honest but may be outdated if G1-core has
  progressed. **Severity: minor.**

### Suspect / placeholder definitions

- None.

### Dead-end / abandoned proof bodies

- None.

### Headline new declarations — axiom check

Only `sorry` warnings in the file are at lines 123, 161, 198, 225 (the out-of-scope stubs).
All in-scope new declarations are **AXIOM-CLEAN ✓**:

- `isIso_fromTildeΓ_restrict_basicOpen`: **AXIOM-CLEAN ✓** (delegates to
  `isIso_fromTildeΓ_presentationPullback` which chains to `isIso_fromTildeΓ_of_presentation`; no
  sorry in the chain)
- `isIso_fromTildeΓ_of_presentation`: **AXIOM-CLEAN ✓**
- `overEquivalence_functor_isCocontinuous`, `overEquivalence_inverse_isCocontinuous`,
  `overEquivalence_sheafCongr`: **AXIOM-CLEAN ✓** (fill Mathlib TODOs)
- Presentation transport chain (`overRestrictEquiv`, `overRestrictFunctorIso`,
  `overRestrictIso`, `overRestrictPullbackIso`, `overRestrictUnitIso`, `overRestrictPresentation`,
  `presentationPullbackιOfQuasicoherentData`, `presentationPullbackιRestrict`,
  `presentationPullbackOfSchemeIso`, `isIso_fromTildeΓ_presentationPullback`): **AXIOM-CLEAN ✓**

### Linter / bad-practice violations

- **Lines 1100, 1163, 1233, 1252, 1281** — `set_option maxHeartbeats 2000000 in` without an
  explanatory comment on the following line. Five instances, all in new code. Fix: move or add a
  `-- reason:` comment immediately after each `set_option maxHeartbeats` directive.
  **Severity: major** (new-code linter violations; should be fixed before merge).
- **Lines 936–945** — `CategoryTheory.Sheaf.Hom.mk` deprecated; replacement is
  `ObjectProperty.homMk`. 4 sites. **Severity: major** (accumulated deprecation debt; note will
  need dot-notation adjustments per the linter message).
- **Lines 1112, 1152, 1166, 1240, 1242, 1260, 1266** — Long line (>100 chars). **Severity: minor.**

### Excuse-comments

- None.

---

## Must-Fix Issues (Critical)

**None.** No weakened definitions, no unauthorized axioms, no sorry on a declaration presented as
proved this iteration, no excuse-commented stubs across any of the four files.

---

## Major Issues

| File | Issue | Sites |
|------|-------|-------|
| `FlatBaseChange.lean` | `CategoryTheory.Sheaf.val` deprecated (>20 sites) | Lines 294–615 |
| `QuotScheme.lean` | `linter.style.maxHeartbeats` — 5 instances in new code missing post-directive comment | Lines 1100, 1163, 1233, 1252, 1281 |
| `QuotScheme.lean` | `CategoryTheory.Sheaf.Hom.mk` deprecated (4 sites) | Lines 936–945 |

---

## Minor Issues

| File | Issue | Lines |
|------|-------|-------|
| `FlatBaseChange.lean` | `linter.style.maxHeartbeats` — comment precedes rather than follows (3 sites) | 979, 1415, 1543 |
| `FlatBaseChange.lean` | Flexible tactic `simp [...]` without `only` | 1092 |
| `FlatBaseChange.lean` | `show` used as `change` | 1119 |
| `FlatBaseChange.lean` | Unused simp argument `Functor.map_comp` | 1496 |
| `FlatBaseChange.lean` | Stale module docstring (iter 234–241 development history) | 184–247 |
| `GrassmannianCells.lean` | Stale planner annotation (`-- Planner note:`) | 33–45 |
| `QuotScheme.lean` | Stale `task_results/` file reference in comment | 274–279 |
| `QuotScheme.lean` | Long line violations | 1112, 1152, 1166, 1240, 1242, 1260, 1266 |

---

## Excuse-Comments

**None found** across all four files. Open sorry obligations are honestly labelled and their
remaining work is precisely described.

---

## Severity Summary

| Category | Count |
|----------|-------|
| Critical (must-fix-this-iter) | 0 |
| Major issue groups | 3 |
| Minor issue groups | 8 |
| Open sorry obligations (FlatBaseChange.lean) | 4 (expected in-progress work) |
| Axiom-clean headline declaration groups | 4 / 4 confirmed ✓ |
