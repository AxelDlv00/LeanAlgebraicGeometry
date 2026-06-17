# Lean Audit Report

## Slug
iter044

## Iteration
044

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (deprecated API in type signatures; `maxHeartbeats` override without inline comment)
- **excuse-comments**: none
- **notes**:

  #### New declarations (iter-044 focus: lines 760–895)

  **`appTop_appIso_inv_eq_res` (lines 801–808)** — axiom-clean (`propext, Classical.choice, Quot.sound`).
  The `congr 1` on line 808 closes a goal of the form
  `A ≫ X.presheaf.map (𝟙 …) = A ≫ X.presheaf.map (h.op ≫ eqToHom …)`
  by Subsingleton on morphisms in the thin Opens lattice. LSP confirms
  `goals_after: []` — the closure is mathematically sound (both sides are presheaf
  maps between the same pair of opens in a poset, hence equal). Not a spurious closure.

  **`key_morph` (lines 815–825)** — axiom-clean. Proof uses `Scheme.ΓSpecIso_inv_naturality`
  (the `ΓSpecIso.inv` form, not `globalSectionsIso.hom`) and closes with
  `appTop_appIso_inv_eq_res`. Correct.

  **`tile_appIso_comp` (lines 831–839)** — axiom-clean. The `simp [Iso.trans_inv, eqToHom_map,
  eqToHom_op]` step correctly reduces the `eqToHom`-bookkeeping after `rw [hc]`;
  `goals_after: []` confirmed. Correct.

  **`tile_section_ring_identity` (lines 847–863)** — axiom-clean. The final `congr 1` (line 863)
  closes a goal
  `(Scheme.ΓSpecIso R).inv ≫ (Spec R).presheaf.map (homOfLE ⋯).op =
     (Scheme.ΓSpecIso R).inv ≫ (Spec R).presheaf.map ((homOfLE ⋯).op ≫ (eqToHom ⋯).op)`
  Both sides are presheaf maps between the same objects in the thin Opens category;
  `congr 1` fires Subsingleton, which is correct. Not a spurious closure.

  **`tile_scalar_compat` (lines 876–892)** — axiom-clean (`propext, Classical.choice, Quot.sound`
  only, verified via `lean_verify`). The proof structure:
  1. `congr 1` at line 888: applied to `c • x = d • x`; correctly splits to `case e_a: c = d`
     (the acted-upon element closes by definitional equality). Not a spurious closure.
  2. `convert hG using 2` at line 892: `goals_after: []` confirmed. The hypothesis `hG`
     is the elementwise version of `tile_section_ring_identity`. The `using 2` match closes
     at depth-2 on Opens-thin-category morphisms; all generated sub-goals are sound.
  The statement IS the genuine scalar-compatibility claim it purports to be: it asserts that
  the `R`-action on sections of `F` over the tile image `D(g)` equals the `R_g`-action
  (via `algebraMap`) on the same section.

  #### Deprecated API (major — see below)

  - **Line 732 (`modulesSpecToSheaf_smul_eq` statement)**: `(Spec R).ringCatSheaf.val.map …`
    — `CategoryTheory.Sheaf.val` is deprecated in favour of `ObjectProperty.obj`.
    The deprecation is in the **type signature** (statement), not just the proof body.
  - **Line 741 (`modulesRestrictBasicOpen_smul_eq` statement)**: `F.val.obj …`
    — same deprecation, same concern.
  These two lemmas are the `rfl`-bridges called by `tile_scalar_compat`'s proof. Their
  statements reference the deprecated `.val` accessor; a Mathlib API migration will silently
  break their types.

  #### Block comment (lines 894–934) — stale/inaccurate wording (minor)

  - **Line 895**: The heading reads `tile_scalar_compat / tile_section_comparison /
    tile_section_localization — PARTIAL this iter`. Since `tile_scalar_compat` is fully
    proved in this very block, "PARTIAL" is misleading. The accurate headline would be
    "DONE `tile_scalar_compat`; NEXT `tile_section_localization`."
  - **Lines 905–907**: The claimed "PROVEN tactic prefix" description says `congr 1` is the
    final step. The actual last two steps are `have hG := congrArg … tile_section_ring_identity`
    and `convert hG using 2`. The description is incomplete (minor inaccuracy, not wrong).
  - **"tile_section_comparison"** is listed in the block header but is never defined as a
    named Lean declaration anywhere in the file. It appears to refer to the Step-4 transport
    `σ ≅ ρ` described in the plan, but having an undeclared name in a progress comment is
    noise.
  - The "DONE (iter-044): `tile_scalar_compat` is axiom-clean and kernel-verified" sub-claim
    is **accurate**: `lean_verify` independently confirms it.
  - The `tile_section_localization` "full assembly now unblocked" plan (lines 916–934) is a
    reasonable engineering plan, not an over-claim. The Step descriptions match the available
    lemmas (`tile_image_opens_identities`, `isLocalizedModule_powers_restrictScalars_of_algebraMap`,
    the two smul bridges, `tile_scalar_compat`). The "no math wall, ~100–150 LOC" estimate is
    a good-faith engineering assessment.

  #### `set_option maxHeartbeats 1000000` (line 867) — minor

  The linter requires an inline `-- reason` comment immediately after the `set_option` line
  (warning: `linter.style.maxHeartbeats`). The explanation exists in the doc-comment block
  above (lines 865–866) but NOT as a `--` comment on the line directly following the
  `set_option`, which is what the linter checks. The reason itself ("`convert … using 2`
  defeq check on tile section carriers is heartbeat-heavy") is correct and present
  — it just needs to be a bare `--` comment after the option.

  #### Long-line warnings (minor)

  Lines 708, 713, 799, 843, 844, 865, 898, 906, 908, 916, 925 exceed the 100-character
  limit (linter warnings only; no compilation effect).

---

### `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 3 flagged (deprecated API in proof bodies; `show` tactic misuse; `synthInstance.maxHeartbeats` missing inline comment)
- **excuse-comments**: none
- **notes**:

  - **Lines 196, 214, 233, 240, 241**: `CategoryTheory.Sheaf.val` deprecated (5 occurrences),
    all inside proof bodies of `modulesOverBasicOpenEquivalence` and `overBasicOpenIsoRestrict`.
    These are in proofs, not type signatures, so the risk is lower than the QcohTildeSections
    cases; they will produce deprecation warnings but the declarations' statements are unaffected
    by a future `Sheaf.val` removal if the proofs are updated. Still worth migrating.
  - **Line 47** (`show` tactic): linter warns that `show` here changes the goal — `change`
    should be used instead. Style issue only.
  - **Line 292** (`set_option synthInstance.maxHeartbeats 400000`): same linter pattern as
    line 867 of QcohTildeSections.lean — no inline `-- reason` comment after the option.
  - Long-line warnings: lines 31, 206, 216, 221, 230, 236, 279 (linter only).

---

## Must-fix-this-iter

None. No errors, no sorry's, no extra axioms, no excuse-comments, no weakened definitions,
no unauthorised use of `Classical.choice`, no wrong-directional statements found.

---

## Major

- `QcohTildeSections.lean:732` — `modulesSpecToSheaf_smul_eq` statement uses
  `CategoryTheory.Sheaf.val` (deprecated: use `ObjectProperty.obj`) **in the type signature**.
  This is a load-bearing helper for `tile_scalar_compat`; a Mathlib API migration will silently
  break the statement, not just the proof body.
- `QcohTildeSections.lean:741` — `modulesRestrictBasicOpen_smul_eq` statement uses
  `F.val.obj …` (same `CategoryTheory.Sheaf.val` deprecation, same risk). Also a load-bearing
  helper for `tile_scalar_compat`.

---

## Minor

- `QcohTildeSections.lean:895` — Block comment header says "PARTIAL this iter" but
  `tile_scalar_compat` is fully proved in the same file; heading should be updated to avoid
  confusion about what is done vs. next.
- `QcohTildeSections.lean:905` — Block comment description of `tile_scalar_compat`'s proof
  is incomplete: says `congr 1` is the terminal step, but actual terminal steps are
  `have hG := congrArg … tile_section_ring_identity` and `convert hG using 2`.
- `QcohTildeSections.lean:867` — `set_option maxHeartbeats 1000000` lacks an inline
  `-- reason` comment directly on the line after the option (linter style requirement;
  the prose reason is present in the preceding doc-block but not in `--` form).
- `QcohRestrictBasicOpen.lean:196,214,233,240,241` — `CategoryTheory.Sheaf.val` deprecated
  in proof bodies (5 occurrences); lower risk than the type-signature cases but should be
  migrated to `ObjectProperty.obj` before the API removal lands.
- `QcohRestrictBasicOpen.lean:47` — `show` tactic used to change goal; linter recommends
  `change` instead.
- `QcohRestrictBasicOpen.lean:292` — `set_option synthInstance.maxHeartbeats 400000` missing
  inline `-- reason` comment.
- Both files: multiple lines exceed the 100-character limit (linter warnings only).

---

## Excuse-comments (always called out separately)

None found in either file.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 7
- **excuse-comments**: 0

Overall verdict: Both files compile cleanly with no errors or sorry's; all five iter-044
declarations (`appTop_appIso_inv_eq_res`, `key_morph`, `tile_appIso_comp`,
`tile_section_ring_identity`, `tile_scalar_compat`) are axiom-clean and kernel-sound — the
`congr 1` and `convert using 2` closures are verified against thin-category Subsingleton
semantics and are not spurious. The two major issues are deprecated `Sheaf.val` in the
**type signatures** of the helper pair `modulesSpecToSheaf_smul_eq` /
`modulesRestrictBasicOpen_smul_eq`, which will break under a future Mathlib API migration
and should be ported to `ObjectProperty.obj` before that lands.
