# Blueprint Review Report

## Slug
iter197-fastpath

## Iteration
197

---

## Scope

Same-iter fast-path scoped re-review of three chapters patched by the
iter-197 plan-phase blueprint-writer dispatches:
- `RiemannRoch_H1Vanishing.tex` (writer: `h1v-mustfix-iter197`)
- `AbelianVarietyRigidity.tex` (writer: `avr-barescheme-mustfix-iter197`)
- `RiemannRoch_OCofP.tex` (writer: `ocofp-pin-cleanup-iter197` + plan-agent 1-line fix)

Each chapter is audited against the specific must-fix and major findings
from the iter-196 `lean-vs-blueprint-checker-{h1v,avr,barescheme,ocofp}.md`
reports. This is NOT a whole-blueprint pass.

---

## Per-chapter

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex

- **complete**: true
- **correct**: true
- **notes**:

**Prior must-fix items (3 from checker-h1v):**

- **M-1** (non-empty branch sorry of `constant_of_irreducible` presented as
  trivial in blueprint): ✓ CLEARED. A `% NOTE` block was added to the proof
  of `lem:isFlasque_constant_irreducible` (file lines 183–220) explicitly
  acknowledging the Mathlib gap, referencing the Lean comment at
  H1Vanishing.lean:150–154, and documenting both closure routes (Route A:
  Full/Faithful instances for `constantSheaf` on irreducible spaces; Route B:
  alternate sheaf construction ~150–200 LOC).

- **M-2** (`Nonempty (iso)` Lean signature weaker than blueprint "naturally
  isomorphic" claim): ✓ CLEARED. The prose of `lem:skyscraperSheaf_eq_pushforward`
  was updated to drop "naturally isomorphic" and a `% NOTE` block (lines
  516–532) was added documenting the `Nonempty` wrapper, its `Classical.choice`
  origin, and the upgrade path when the inner iso is constructed explicitly.

- **M-3** (inner iso `sorry` on substantive step; no named sub-lemma in
  blueprint): ✓ CLEARED. A new sub-lemma block
  `lem:skyscraperSheaf_iso_constantSheaf_punit` was inserted (lines 571–653)
  pinned to `AlgebraicGeometry.Scheme.skyscraperSheaf_iso_constantSheaf_punit`
  (a FUTURE target — does NOT exist in Lean yet). The block includes a detailed
  proof sketch describing the forward map, inverse map (pointwise on ⊥ and ⊤),
  naturality argument, and both Route A / Route B for the Mathlib gap. The
  `lem:skyscraperSheaf_eq_pushforward` proof block was updated to
  `\uses{lem:skyscraperSheaf_iso_constantSheaf_punit}` and explains the
  outer-vs-inner decomposition. The future-target nature is clear from the
  absent `\leanok` and the Mathlib-gap Route A/B prose. **Acceptable per writer
  descriptor: future substrate targets with adequate explanatory prose are
  valid pins.**

**Prior major items (3 from checker-h1v):**

- **J-1** (stale `\uses{...}` on `lem:skyscraperSheaf_isFlasque`): ✓ CLEARED.
  `\uses{...}` on both statement and proof blocks pruned to `{def:isFlasque_sheaf}`
  only (lines 688, 705). A `% NOTE` explains the direct Lean proof route via
  `skyscraperPresheaf_map` case split.

- **J-2** (`injective_flasque` full-sorry body with no `\lean{...}` pin): ✓
  CLEARED. New `lem:isFlasque_injective` block added (lines 313–365) pinned to
  `AlgebraicGeometry.Scheme.IsFlasque.injective_flasque` (EXISTS in Lean at
  H1Vanishing.lean:613 as a typed sorry). Block includes the Hartshorne III.2.4
  j_! proof sketch and a `% NOTE` documenting the out-of-loop scope reduction,
  the `j_!` Mathlib gap, and ~100–150 LOC closure estimate.

- **J-3** (`\uses{...}` on `thm:H1_vanishing_flasque` did not reflect actual
  substrate dependencies): ✓ CLEARED. Statement block `\uses{...}` updated to
  `{def:isFlasque_sheaf, lem:isFlasque_injective, lem:flasque_cokernel_short_exact,
  lem:ext_succ_zero_of_injective_lower_zero}` (line 373–375). All four labels
  verified to exist in the chapter.

**`\leanok`/`\mathlibok` markers:** No new markers added or removed by the
writer. ✓

**New `\uses{...}` — no cycles or broken cross-refs:**
- `lem:skyscraperSheaf_eq_pushforward` proof → `lem:skyscraperSheaf_iso_constantSheaf_punit` (new, exists as new label). ✓
- `lem:skyscraperSheaf_iso_constantSheaf_punit` proof → `def:isFlasque_sheaf` (line 76), `lem:isFlasque_constant_irreducible` (line 157). Both exist. ✓
- `lem:isFlasque_injective` statement/proof → `def:isFlasque_sheaf`, `lem:isFlasque_pushforward` (line 122). Both exist. ✓
- `thm:H1_vanishing_flasque` statement → all four labels verified above. ✓

**No new must-fix findings emerged from the patches.**

---

### blueprint/src/chapters/AbelianVarietyRigidity.tex

(Consolidated chapter; covers AbelianVarietyRigidity.lean, BareScheme.lean,
ChartIso.lean, and siblings.)

- **complete**: true
- **correct**: true
- **notes**:

**Prior must-fix items — AVR half (1 from checker-avr):**

- **M-1** (missing named intermediate `Proj.basicOpenIsoSpec_inv_app_top`; its
  absence caused the dependent-motive blocker across iter-188–196): ✓ CLEARED.
  New lemma block `lem:basicOpenIsoSpec_inv_app_top` inserted at lines 1553–1615,
  pinned to `AlgebraicGeometry.Proj.basicOpenIsoSpec_inv_app_top` (FUTURE target
  — not yet in Lean; acceptable). Block provides the full closed-form factorisation
  statement and a detailed proof sketch (`Scheme.invApp` + `basicOpenIsoSpec_hom` +
  `basicOpenToSpec_app_top` chain, ~5–15 LOC). `lem:awayi_app_basicOpen` now
  carries `\uses{lem:basicOpenIsoSpec_inv_app_top}` (line 1621). ✓

  Additionally, Step 1 of the `lem:awayi_app_basicOpen` proof sketch was
  completely rewritten (lines 1672–1698) to reference the iter-196 landed bridge
  `lem:awayi_eq_specMap_fromSpec` (Lean: `Proj.awayι_eq_specMap_fromSpec`,
  verified at AbelianVarietyRigidity.lean:203, axiom-clean) instead of the
  non-existent `Proj.awayι_eq_isoSpec_ι_comp`. The new Step 1 explicitly notes
  "This route avoids the dependent-motive obstruction that blocked iter-188–iter-196"
  and references `lem:awayi_preimage_basicOpen_self` (Lean:
  `Proj.awayι_preimage_basicOpen_self`, verified at AbelianVarietyRigidity.lean:190,
  axiom-clean) as the key that eliminates the dependent-motive issue.

**Prior must-fix items — BareScheme half (1 from checker-barescheme):**

- **M-3** (`lem:projectiveLineBar_geomIrred` proof sketch under-specified; missing
  the Lean-level Proj base-change iso recipe): ✓ CLEARED. The proof sketch was
  expanded from a brief informal argument into a complete 5-sub-helper recipe
  (lines 1101–1182):
  - Sub-helper A: `Proj.baseChangeIso` (FUTURE target, Stacks 0BLW, ~100–200
    LOC, `\lean{AlgebraicGeometry.Proj.baseChangeIso}` pin).
  - Sub-helper B: `homogeneousLocalizationAwayIso.baseChange` (FUTURE target,
    `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso.baseChange}` pin).
  - Sub-helpers C–E: un-pinned prose (per writer directive scope; iter-197+
    prover names targets as they materialise).
  Total estimated closure cost documented (200–350 LOC; Helper A dominates).
  A `% NOTE` explains the Mathlib gap and acceptable Tier-3 sorry status. ✓

**Prior major items — AVR half (4 from checker-avr):**

- **J-1** (two iter-196 landed primitives had no `\lean{...}` blueprint blocks):
  ✓ CLEARED.
  - `lem:awayi_preimage_basicOpen_self` → `AlgebraicGeometry.Proj.awayι_preimage_basicOpen_self`
    (AbelianVarietyRigidity.lean:190, axiom-clean). ✓
  - `lem:awayi_eq_specMap_fromSpec` → `AlgebraicGeometry.Proj.awayι_eq_specMap_fromSpec`
    (AbelianVarietyRigidity.lean:203, axiom-clean). ✓

- **J-2** (`projectiveLineBar_isProper` had no `\lean{...}` block): ✓ CLEARED.
  New `lem:projectiveLineBar_isProper` block added, pinned to
  `AlgebraicGeometry.projectiveLineBar_isProper`
  (BareScheme.lean:106, axiom-clean). ✓

- **J-3** (`mvPolynomialFin_isStandardSmoothOfRelativeDimension` had no `\lean{...}`
  block): ✓ CLEARED. New `lem:mvPolynomialFin_isStandardSmoothOfRelativeDimension`
  block added with 5-declaration `Algebra.SubmersivePresentation` chain documented.
  Pinned to `AlgebraicGeometry.mvPolynomialFin_isStandardSmoothOfRelativeDimension`
  (BareScheme.lean:207, axiom-clean). `lem:projectiveLineBar_smoothOfRelDim`
  `\uses{...}` updated to include the new substrate block. ✓

- **J-4** (loose Lean API name `Smooth_iff_atOpens` in `lem:projectiveLineBar_smoothOfRelDim`
  sketch): ✓ CLEARED. Corrected to `IsZariskiLocalAtSource.of_openCover` with
  full `HasRingHomProperty ⇒ IsZariskiLocalAtSource` chain documented. ✓

**`\leanok`/`\mathlibok` markers:** No new markers added or removed. ✓

**New `\uses{...}` — no cycles or broken cross-refs:**
- `lem:awayi_app_basicOpen` → `lem:basicOpenIsoSpec_inv_app_top` (new, exists). ✓
- `lem:basicOpenIsoSpec_inv_app_top` proof → `\uses{}` (empty). ✓
- `lem:projectiveLineBar_smoothOfRelDim` → `def:genus0_base_objects`, `lem:mvPolynomialFin_isStandardSmoothOfRelativeDimension` (new, exists). ✓
- `lem:projectiveLineBar_geomIrred` → `def:genus0_base_objects`. ✓

**No new must-fix findings emerged from the patches.**

**Informational only (not blocking):** Sub-helpers A and B in
`lem:projectiveLineBar_geomIrred` (lines 1117 and 1131) carry `\lean{...}` pins
for future Lean targets (`Proj.baseChangeIso`, `homogeneousLocalizationAwayIso.baseChange`);
neither has `\leanok` and both are clearly documented as future substrate work.
The proof prose adequately signals the unformalized status for the prover.

---

### blueprint/src/chapters/RiemannRoch_OCofP.tex

- **complete**: true
- **correct**: true
- **notes**:

**Prior major items (3 from checker-ocofp; 0 must-fixes originally):**

- **Ocofp-1** (broken `\lean{...}` pin to non-existent `order_conditions_of_globalSection`):
  ✓ CLEARED. Lemma block relabelled to
  `lem:lineBundleAtClosedPoint_globalSections_iff_mpr` and re-pinned to
  `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff_mpr`
  (OCofP.lean:1024, private, axiom-clean). Statement and proof rewritten to match
  the private helper's signature (existence-of-section hypothesis ⇒ order conditions).
  Old label `lem:lineBundleAtClosedPoint_order_conditions_of_globalSection` grep
  across all blueprint chapters returns zero matches — no stale cross-references. ✓

- **Ocofp-2** (broken `\lean{...}` pin to non-existent
  `WeilDivisor.principal_ne_zero_of_nonconstant`): ✓ CLEARED. Lemma block
  relabelled to
  `lem:lineBundleAtClosedPoint_functionField_const_of_complete_curve_of_orderZero`
  and re-pinned to
  `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.functionField_const_of_complete_curve_of_orderZero`
  (OCofP.lean:1390, private, sorry body = Stacks 02P0 Mathlib gap). Statement
  restated as the Hartshorne I.3.4 / Stacks 02P0 substrate. A `% NOTE` block
  (lines 842–866) documents the equivalence with the original contrapositive
  framing and points to the inlined wrapper. Old label grep returns zero matches. ✓

- **Ocofp-3** (`\leanok` embedded inside `\uses{...}` argument): ✓ CLEARED
  (confirmed plan-agent direct fix in place). At lines 692–695:
  ```
  \begin{proof}
    \leanok
    \uses{lem:lineBundleAtClosedPoint_globalSections_iff,
          def:lineBundleAtClosedPoint_carrierSubmoduleSheaf}
  ```
  `\leanok` is on its own line before `\uses{...}`, matching the canonical
  format. Blueprint dependency resolution is unblocked. ✓

**`\leanok`/`\mathlibok` markers:** No new markers added or removed. ✓

**New `\uses{...}` — no cycles or broken cross-refs:**
- `lem:lineBundleAtClosedPoint_globalSections_iff_mpr` →
  `lem:lineBundleAtClosedPoint_globalSections_iff`, `def:lineBundleAtClosedPoint_toFunctionField`,
  `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf`. All exist in the chapter. ✓
- `lem:lineBundleAtClosedPoint_functionField_const_of_complete_curve_of_orderZero` →
  `def:lineBundleAtClosedPoint`. Exists. ✓

**No new must-fix findings emerged from the patches.**

**Soon (not blocking):** Both new pins target **private** Lean declarations
(`globalSections_iff_mpr`, `functionField_const_of_complete_curve_of_orderZero`).
`leanblueprint` resolves private names at the kernel-name level; the lean-vs-blueprint
checker may flag visibility in a future full review. Fix: make the helpers non-private
in OCofP.lean (mild refactor). Not a blocker this iter.

---

## Severity summary

**must-fix-this-iter:** None. All prior must-fix findings resolved; no new
must-fix items introduced by the patches.

**soon (2 items, not blocking):**
1. `RiemannRoch_OCofP.tex` — new pins `globalSections_iff_mpr` and
   `functionField_const_of_complete_curve_of_orderZero` target private Lean
   declarations. Future lean-vs-blueprint-checker may flag visibility. Fix:
   de-privatise in OCofP.lean.
2. `RiemannRoch_H1Vanishing.tex` — `lem:skyscraperSheaf_iso_constantSheaf_punit`
   has no explicit `% NOTE: (unformalized)` marker; the future-target status is
   clear from absent `\leanok` and Route A/B prose, but adding a brief
   `% NOTE: (Lean target does not yet exist; pinned for iter-197+ prover)`
   sentence would remove ambiguity for automated tools.

**informational:** None.

Overall verdict: All three patched chapters clear the HARD GATE — all prior
must-fix findings resolved, no new must-fix items introduced, no new
`\leanok`/`\mathlibok` markers added, no broken `\uses{...}` cross-references.

---

## HARD GATE clearance for iter-197 prover re-dispatch

```
HARD GATE clearance for iter-197 prover re-dispatch:
- `RiemannRoch_H1Vanishing.tex` → H1Vanishing.lean: CLEAR
- `AbelianVarietyRigidity.tex` → AbelianVarietyRigidity.lean: CLEAR
- `AbelianVarietyRigidity.tex` → BareScheme.lean (and ChartIso.lean): CLEAR
- `RiemannRoch_OCofP.tex` → OCofP.lean: CLEAR
```
