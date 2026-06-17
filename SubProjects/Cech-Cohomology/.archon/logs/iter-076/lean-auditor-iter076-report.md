# Lean Audit Report

## Slug
iter076

## Iteration
076

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (unused theorem hypotheses)
- **excuse-comments**: none
- **notes**:

  **Wrapper faithfulness — `cechSection_isZero_homology` (lines 155–167)**

  - The `let`-bound chain (`α`, `cc`, `K`, `Kp`, `GV`) in the statement is copied verbatim from `cechSection_complex_iso`'s return-type `let`-chain.  The conclusion `IsZero (((GV.mapHomologicalComplex cc).obj Kp).homology p)` is definitionally `IsZero (D.homology p)` matching the `D` in `cechSection_complex_iso 𝒰 F V : D ≅ D'`.
  - `cechSection_contractible 𝒰 F V i hiV : Homotopy (𝟙 D') 0` has `D'` equal to `(sectionCechComplexV 𝒰 F V).augment (sectionCechAugV 𝒰 F V) (sectionCechAugV_comp_d 𝒰 F V)` — the same `D'` that `cechSection_complex_iso` targets.  `isZero_homology_of_iso_homotopy_id_zero` unifies `D` and `D'` from these two arguments.  The wrapper is faithful.
  - No `sorry`, no `#check`/`#eval`, no axioms anywhere in the file.
  - LSP diagnostic query returned `success: false, items: []` — LSP may not have been live for this file.

  **Closure of `cechAugmented_exact` — `exact cechSection_isZero_homology …` (line 243)**

  - After `refine IsZero.of_iso ?_ (GV.mapHomologyIso' cc Kp p).symm` (line 234), the open goal is `IsZero (GV.obj (Kp.homology p))` = `IsZero (Q.obj (op V))`.  The `set`-bound `GV` and `Kp` in the outer proof are definitionally equal to the `let`-bound names in `cechSection_isZero_homology`.  The `exact` application reduces correctly.  The closure is structurally sound.

  **Stale planner-strategy comment (lines 169–189)** — *major, see below*

  - The block `/- Planner strategy: ... -/` describes an entirely different proof route (affine basis + `qcoh_iso_tilde_sections` + `sectionCech_homology_exact_of_localizationAway` + `affineCoverSystem`) that was **not** taken.
  - None of the lemmas named in Steps 3–4 of that comment (`qcoh_iso_tilde_sections`, `sectionCech_homology_exact_of_localizationAway`, `standard_cover_cofinal`, `affineCoverSystem`, `exact_of_isLocalized_span`, `combDifferential_exact`) appear anywhere in the proof body.
  - The actual proof uses `cechSection_isZero_homology` → contracting-homotopy route (Sub-brick A of `CechSectionIdentification.lean`).
  - Step 4 of the comment ("degree-0 augmentation node uses `combDifferential_exact`") is entirely absent from the proof — the contracting homotopy on the AUGMENTED complex handles all degrees simultaneously.

  **Stale module-doc listing phantom proof ingredients (lines 23–24)** — *major, see below*

  - The module-doc comment lists `sectionCech_homology_exact_of_localizationAway`, `affineCoverSystem`, `qcoh_iso_tilde_sections` as "every ingredient of the sections/sheafification proof route".  Only `PresheafOfModules.homologyIsoSheafify` (the first item) is actually used.  The other three are from the abandoned route and do not appear in the proof.

  **Unused theorem hypotheses (lines 203–204)** — *major, see below*

  - `h𝒰 : ∀ i, IsAffine (𝒰.X i)`, `[X.IsSeparated]`, and `hF : F.IsQuasicoherent` are declared in the signature of `cechAugmented_exact` but appear nowhere in the proof body.
  - The proof is carried through purely by: (1) the general faithfulness of `SheafOfModules.toSheaf`; (2) `homologyIsoSheafify`/`sheafificationCompToSheaf` (hold for any `α = 𝟙`, topology-independent); (3) `isZero_presheafToSheaf_of_locally_isZero`; and (4) the contracting-homotopy `cechSection_isZero_homology` (F-agnostic, cover-agnostic).
  - The proof as written establishes `cechAugmented_exact` for **any** open cover and **any** sheaf of modules (no affineness, no separatedness, no quasi-coherence required).  The stated hypotheses are unnecessary and produce likely Lean `unused variable` warnings for `h𝒰` and `hF`.  This either means the theorem proves a strictly stronger result than its name/documentation claim, or the signature was not updated when the proof route changed.

  **Minor comment inaccuracy (lines 235–242)** — *minor, see below*

  - Inline comment: "prepending that fixed index `i` is a contracting homotopy … (template `CombinatorialCech.combHomotopy` / the objectwise homotopy of FreePresheafComplex)".  The actual mechanism inside `cechSection_contractible` is `Homotopy.mkCoinductive` (CechSectionIdentification.lean:1118), not `combHomotopy` or `FreePresheafComplex`.  The named constructs are from the planned route, not the executed one.

---

## Must-fix-this-iter

None.

No `sorry`, no excuse-comments, no weakened-wrong definitions, no unauthorised axioms, no placeholder bodies.

---

## Major

- `CechAugmentedResolution.lean:169–189` — `/- Planner strategy: -/` block describes an abandoned proof route (affine-basis + `qcoh_iso_tilde_sections` + `sectionCech_homology_exact_of_localizationAway` + `combDifferential_exact`).  None of the lemmas named in Steps 3–4 appear in the proof.  The block actively misleads about what the proof does; a future maintainer following the comment will look for code that does not exist.

- `CechAugmentedResolution.lean:23–24` — Module-doc names `sectionCech_homology_exact_of_localizationAway`, `affineCoverSystem`, `qcoh_iso_tilde_sections` as actual proof ingredients.  Only `homologyIsoSheafify` is used.  The other three are ghost names from the abandoned route.

- `CechAugmentedResolution.lean:203–204` — Theorem hypotheses `h𝒰 : ∀ i, IsAffine (𝒰.X i)`, `[X.IsSeparated]`, and `hF : F.IsQuasicoherent` are entirely unused in the proof body.  The proof holds for any open cover and any sheaf of modules.  This silent strengthening is invisible from the theorem signature and is likely producing `unused variable` warnings.  The stated hypotheses should either be removed (if the stronger result is intentional and correct) or the proof should be audited to confirm that the missing steps are genuinely not needed rather than accidentally bypassed.

---

## Minor

- `CechAugmentedResolution.lean:235–242` — Inline tactic comment names `CombinatorialCech.combHomotopy` and "objectwise homotopy of FreePresheafComplex" as the internal mechanism; the actual mechanism is `Homotopy.mkCoinductive` in `CechSectionIdentification.lean`.  Slightly inaccurate about the internal lemma but not misleading about the mathematical argument.

---

## Excuse-comments (always called out separately)

None flagged.  No line in the file admits that a declaration is wrong, temporary, or placeholder.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3
- **minor**: 1
- **excuse-comments**: 0

Overall verdict: The file is sorry-free and structurally sound; `cechSection_isZero_homology` is a faithful wrapper and its call at line 243 closes correctly, but the proof of `cechAugmented_exact` silently establishes a stronger result than stated (hypotheses `h𝒰`, `IsSeparated`, `hF` unused), and two stale planning-route comments name lemmas that were never part of the actual proof.
