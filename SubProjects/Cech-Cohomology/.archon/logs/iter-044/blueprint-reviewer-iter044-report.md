# Blueprint Review Report

## Slug
iter044

## Iteration
044

---

## Hard-gate re-confirm: `Cohomology_CechHigherDirectImage.tex` → `QcohTildeSections.lean`

**Verdict: HARD GATE CLEARS. Both gate questions answered affirmatively. No must-fix finding on this chapter. Prover lane may proceed.**

### Gate Q1 — Is the chapter `complete: true` AND `correct: true` for the active prover target?

Yes.

The iter-043 full-review clearing plus the single regression (stale `lem:tile_section_comparison` sketch) is now resolved. The writer added two `rfl`-bridge lemma blocks and rewrote the comparison proof note. Assessment of each changed element:

**`lem:modulesSpecToSheaf_smul_eq`** (line 4411):
- Statement: native R-action of the global-ring section functor equals the structure-sheaf action of the restricted global-sections image. Correct — this is the right statement for a definitional bridge.
- `\lean{AlgebraicGeometry.modulesSpecToSheaf_smul_eq}`: verified **not** in leandag's `unmatched_lean` list → declaration exists in the Lean codebase.
- `\uses{}`: empty. Correct — the proof is "by definitional unfolding", requiring no lemma dependencies.
- Proof note says "holds by definitional unfolding" → prover closes by `rfl`/`simp only []`; no misdirection.

**`lem:modulesRestrictBasicOpen_smul_eq`** (line 4436):
- Statement: the tile R_g-action of `F_{(g)}` transports to the ambient F-action via the two open-immersion ring isomorphisms `α_g^{-1}(β_g^{-1}(c))`. Correct — this is the accurate companion bridge for the restriction-of-scalars chain.
- `\lean{AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq}`: verified **not** in `unmatched_lean` → declaration exists.
- `\uses{lem:tile_image_opens_identities}`: correct — the proof invokes the image-open identity `W = D(g)` to make the two carriers agree.
- Proof note says "holds by definitional unfolding" → again `rfl`/`simp only []`.

**`lem:tile_section_comparison`** (revised, line 4467):
- The revised proof note decomposes correctly into **three** parts:
  1. *Carriers*: coincide definitionally via `lem:restrict_obj_mathlib`. ✓
  2. *Scalar actions*: both are definitional — the R-side via `lem:modulesSpecToSheaf_smul_eq`, the R_g-side via `lem:modulesRestrictBasicOpen_smul_eq`. ✓
  3. *Residual*: exactly ONE structure-sheaf ring identity, `ρ^{D(g)}(θ_R(r)) = β_g^{-1}(θ_{R_g}(r̄))`, with two named closure routes: (A) Γ-Spec naturality; (B) `IsLocalization.Away` uniqueness. ✓
- This no longer claims "genuinely non-definitional" and no longer overstates the residual.
- **Does not misdirect** the prover into a 100–150 LOC construction: the sole open task is a one-line ring identity with two clean algebraic routes.
- `\uses{}` now correctly lists all five ingredients: `lem:presentation_modulesRestrictBasicOpen`, `lem:restrict_obj_mathlib`, `lem:tile_image_opens_identities`, `lem:modulesSpecToSheaf_smul_eq`, `lem:modulesRestrictBasicOpen_smul_eq`. ✓
- No `\lean{}` (this is a blueprint-level lemma; the actual formalization target downstream is `lem:tile_section_localization`). Correct.

**`lem:tile_section_localization`** (line 4538):
- Complete, non-circular 5-step proof sketch in place (Steps 1–5: global presentation of tile → R_g-localisation → opens identities → section comparison → base-ring descent to R). ✓
- Correctly references `lem:tile_section_comparison` as the "load-bearing step" in Step 4. ✓
- `\lean{AlgebraicGeometry.tile_section_localization}` is in `unmatched_lean` (expected — not yet proved). ✓

### Gate Q2 — Any remaining must-fix finding on this chapter?

None. See Severity summary below.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:modulesSpecToSheaf_smul_eq` and `lem:modulesRestrictBasicOpen_smul_eq` both lack `\leanok` — expected (prover has not run yet; sync_leanok has not fired for this iter). Not a correctness issue.
  - `lem:tile_section_comparison` has no `\lean{}` hint (correct — it is a blueprint-level sub-lemma whose Lean content is subsumed by `lem:tile_section_localization`).
  - The dormant `lem:qcoh_localized_sections` (noted in STRATEGY.md as circular via old span-cover mechanism) remains in the chapter. It has no DAG path to the goal and is **not on the active prover route** — flagged **soon** per existing STRATEGY.md note.

---

## Dependency & isolation findings

### leandag build results

- **`unknown_uses`**: 0. No broken `\uses{}` cross-references.
- **`unmatched_lean`** (56 entries): all are either Mathlib declarations (leandag does not scan Mathlib sources — expected for every `\mathlibok` block) or project to-build declarations not yet proved. No new entries introduced by this iter's changes.
- **Conflicts**: 0.
- **Isolated nodes**: 1. The single isolated node is `lean:Alg…`, type `lean_aux`, no chapter assignment. This is an uncovered Lean helper (not a blueprint node). **Disposition: keep** — it is a Lean auxiliary declaration with no blueprint entry, not orphaned scaffolding.

### blueprint-doctor results

Clean. `malformed_refs: []`, `broken_refs: []`, `orphan_chapters: []`, `covers_problems: []`, `axiom_decls: []`. Blueprint renders correctly.

---

## Severity summary

Severity summary: HARD GATE CLEARS — no must-fix-this-iter findings.

**Soon (non-blocking):**
- `Cohomology_CechHigherDirectImage.tex` / `lem:qcoh_localized_sections`: noted in STRATEGY.md as circular via the old span-cover mechanism and DORMANT (no DAG path to goal). **wire-up-or-remove** in a future writer pass; does not block the active prover lane.

**Informational:**
- The `unmatched_lean` count (56) is structurally expected: it combines all `\mathlibok` declarations (Mathlib-sourced, not in the project tree) with the to-prove project declarations. No action needed.
- The 2 `with_sorry` nodes in leandag are in-progress formalizations; consistent with the ACTIVE status of the 01I8 lane.

---

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is `complete: true` and `correct: true` — the Sub-lemma B region is now accurately stated with two correctly-formulated `rfl`-bridge lemmas and a revised `lem:tile_section_comparison` proof note that isolates exactly one ring identity and names two closure routes; HARD GATE CLEARS for the `QcohTildeSections.lean` prover lane. 3 chapters audited, 1 soon-severity finding, 0 must-fix findings, 0 unstarted-phase proposals.
