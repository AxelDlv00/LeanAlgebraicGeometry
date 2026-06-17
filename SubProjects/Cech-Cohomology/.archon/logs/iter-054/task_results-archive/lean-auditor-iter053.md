# Lean Audit Report

## Slug
iter053

## Iteration
053

## Scope
- files audited: 2 (per directive — only prover-touched files this iter)
- files skipped (per directive): all other project .lean files — auditing only the two files listed in the iter-053 directive

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged (line 180 `sorry` inside `cechAugmented_exact`)
- **bad practices**: 1 flagged (embedded planner-strategy comment block)
- **excuse-comments**: none
- **notes**:
  - **Line 52–59 (`isZero_of_faithful_preservesZeroMorphisms`)**: Proof is clean. Axioms: `propext`, `Classical.choice`. Uses `IsZero.iff_id_eq_zero` + `Functor.map_injective` + `F.map_id/F.map_zero`. No kernel-soundness issues.
  - **Line 76–106 (`isZero_presheafToSheaf_of_locally_isZero`)**: Proof is clean. Axioms: `propext`, `Classical.choice`, `Quot.sound`. The `Subsingleton.elim _ _` usages at lines 97 and 104 close equality goals in a zero-object subsingleton context; this is valid and the LSP reports no free-variable issues. `AddCommGrpCat.subsingleton_of_isZero` is a genuine Mathlib lemma (`Mathlib.Algebra.Category.Grp.Zero`). `Presheaf.IsLocallyInjective/IsLocallySurjective` construction is standard. The locally-surjective witness at lines 98–104 uses `J.top_mem U` (trivial cover) correctly.
  - **Line 141–196 (`cechAugmented_exact`)**: Axioms: `propext`, `sorryAx`, `Classical.choice`, `Quot.sound`. Exactly one `sorry` at line 180, correctly acknowledged in surrounding comments as the genuine homotopy gap. The covering-sieve assembly (lines 182–195) is sound: the sieve is well-formed, `iSup_opensRange` is used correctly (the return type `⨆ i, Scheme.Hom.opensRange (𝒰.f i) = ⊤` unifies with the goal involving `coverOpen` — verified: no diagnostics error), and the `TopologicalSpace.Opens.mem_iSup` unwrap at line 192 is standard.
  - **Line 108–128 (planner-strategy comment)**: A `/-  Planner strategy: ... -/` prose block describing the proof route. Not wrong or stale, but it is an internal planning artifact that should be removed before any publication/submission. Minor style issue.
  - **`mapHomologyIso'` at line 173**: Resolves to `CategoryTheory.Functor.mapHomologyIso'` — a project-local lemma (imported from `HigherDirectImagePresheaf`) lifting `ShortComplex.mapHomologyIso` to `HomologicalComplex`. Correct usage. Not a Mathlib parallel-API smell — it fills a genuine Mathlib gap at this abstraction level.
  - **Goal at line 180 (`sorry`)**: Before the `sorry` the goal is `IsZero (((GV.mapHomologicalComplex cc).obj Kp).homology p)` where `GV` is evaluation-at-`V` through the toPresheaf functor. The `refine IsZero.of_iso ?_ (GV.mapHomologyIso' cc Kp p).symm` at line 173 correctly shifts this to `IsZero (GV.obj (Kp.homology p))` = `IsZero (Q.obj (op V))`. The sorry represents the contracting-homotopy vanishing; it is genuinely open (no fake progress before it).
  - **No kernel-soundness trap**: All `change` / `Subsingleton.elim` usages are for concrete goals that match the changed type definitionally (verified: no diagnostics errors). Axiom set contains no surprises.

---

### `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged (line 87 and line 128 `sorry`)
- **bad practices**: 2 flagged (misplaced docstring; overclaiming inline comment; embedded planner-strategy block)
- **excuse-comments**: none
- **notes**:
  - **Line 50–62 (docstring), line 63 (`isAffineHom_of_affine_separated`)**: **MAJOR** — The `/-- **Higher direct images of an affine open immersion vanish** ... -/` docstring (lines 50–62) is Lean-attached to `private lemma isAffineHom_of_affine_separated` at line 63, not to `theorem higherDirectImage_openImmersion_acyclic` at line 71. The private lemma only proves `IsAffineHom j`; the docstring describes the *entire* higher-direct-image vanishing theorem, its proof route, and its blueprint reference. This was confirmed via `lean_hover_info` on `isAffineHom_of_affine_separated`: the hover returns "Higher direct images of an affine open immersion vanish ... `R^q j_* H = 0` ...". The public theorem `higherDirectImage_openImmersion_acyclic` (line 71) has **no docstring**.
  - **Line 63–69 (`isAffineHom_of_affine_separated`)**: Proof typechecks (no diagnostic errors). `IsAffineHom.of_comp` has Mathlib signature `[IsAffineHom (f ≫ g)] [IsSeparated g] : IsAffineHom f` (confirmed via hover). `have hg` and `have hcomp` provide both instance hypotheses. Minor note: `have hg` may be redundant if `IsSeparated (terminal.from X)` is auto-derived from `[X.IsSeparated]` via an existing Mathlib instance chain (cannot confirm without deeper search), but since no diagnostic error appears and the proof is correct, this is low risk.
  - **Line 71–87 (`higherDirectImage_openImmersion_acyclic`)**: Axioms: `propext`, `sorryAx`, `Classical.choice`, `Quot.sound`. The `haveI : IsAffineHom j` + `IsZero.of_iso ?_ (higherDirectImage_iso_sheafify_presheafHomology j q (injectiveResolution H))` reduction at lines 77–81 is a genuine and correct reduction step (hover confirms `higherDirectImage_iso_sheafify_presheafHomology` exists with the right type). The `sorry` at line 87 is honestly labeled "RESIDUAL (genuine cohomological gap, handed off)". Goal before the sorry: `IsZero ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj ((pushforwardResolutionPresheafComplex j (injectiveResolution H)).homology q))` — exactly the sheafification-of-locally-zero step that the surrounding comment accurately describes as remaining.
  - **Lines 111–117 (`higherDirectImage_openImmersion_comp` proof comment)**: **MAJOR** — The inline comment "Structural plan (all categorical building blocks below are verified to exist)" uses the word *verified* when none of the listed building blocks are established in the proof body (the entire body reduces to `haveI ... sorry`). The building blocks described (acyclic-resolution machinery, `pushforwardComp`, etc.) are claimed to "exist" — which may be true in Mathlib — but the phrasing "verified to exist" overstates the proof state. In combination with the honest "RESIDUAL" comment at lines 118–127, intent is recoverable, but the wording of lines 111–117 is misleading to a reader who scans the proof.
  - **Line 104–128 (`higherDirectImage_openImmersion_comp`)**: Axioms: `propext`, `sorryAx`, `Classical.choice`, `Quot.sound`. The only real reduction step before `sorry` is `haveI : IsAffineHom j := isAffineHom_of_affine_separated j`. The `sorry` at line 128 is labeled "RESIDUAL (genuine cohomological gaps, handed off)". Goal state before sorry: `Nonempty (higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H)` — matches the theorem statement exactly; no spurious narrowing has been performed on this goal.
  - **Lines 37–48 (planner-strategy comment)**: Same pattern as in `CechAugmentedResolution.lean` — planning artifact, not wrong, but should be removed before publication. Minor.

---

## Must-fix-this-iter

- `CechAugmentedResolution.lean:141` — `cechAugmented_exact` uses `sorryAx`. The sorry at line 180 (inside the section-level vanishing, `hSec V i hi`) is a load-bearing gap: without it `cechAugmented_exact` does not close. Why must-fix: `sorryAx` on the main theorem of this file blocks downstream uses of the blueprint target `lem:cech_augmented_resolution`.
- `OpenImmersionPushforward.lean:71` — `higherDirectImage_openImmersion_acyclic` uses `sorryAx`. The sorry at line 87 (sheafification-of-locally-zero step) is the entire residual proof obligation for this theorem. Why must-fix: `sorryAx` on a load-bearing intermediate result.
- `OpenImmersionPushforward.lean:104` — `higherDirectImage_openImmersion_comp` uses `sorryAx`. The sorry at line 128 is the entire proof obligation. Why must-fix: `sorryAx` on the pinned blueprint declaration `lem:open_immersion_pushforward_comp`.

---

## Major

- `OpenImmersionPushforward.lean:50–63` — Docstring misplacement: the `/-- **Higher direct images of an affine open immersion vanish** ... -/` block (lines 50–62) is attached by Lean's parser to `private lemma isAffineHom_of_affine_separated` instead of `theorem higherDirectImage_openImmersion_acyclic`. The private lemma proves only `IsAffineHom j`. The public theorem at line 71 has no docstring. Confirmed via `lean_hover_info` on both declarations.
- `OpenImmersionPushforward.lean:111–117` — Overclaiming inline comment: "all categorical building blocks below are verified to exist" inside a proof that immediately reduces to `sorry`. The word "verified" misleads readers into thinking the listed building blocks (acyclic-resolution API, `pushforwardComp`, etc.) have been checked in this file or project context, when the proof provides no such verification.

---

## Minor

- `CechAugmentedResolution.lean:108–128` — Planner-strategy block (`/-  Planner strategy: ... -/`) embedded in the production source file. Accurate description of the proof route, but constitutes internal iteration noise. Should be removed or condensed into the declaration docstring before any submission.
- `OpenImmersionPushforward.lean:37–48` — Same issue: planner-strategy block in production source. Should be cleaned up before submission.
- `OpenImmersionPushforward.lean:65` — `have hg : IsSeparated (terminal.from X) := Scheme.IsSeparated.isSeparated_terminal_from` may be redundant if `IsSeparated (terminal.from X)` is already derivable by instance synthesis from `[X.IsSeparated]`. If redundant, it is dead code and can be removed. Not harmful; risk is zero.

---

## Excuse-comments (always called out separately)

None found. The sorry-adjacent comments ("RESIDUAL (genuine cohomological gap, handed off)"; "Remaining: the augmented section complex...") are accurate descriptions of the gaps, not excuses. The overclaiming comment at lines 111–117 is classified as a major issue above but does not meet the excuse-comment definition (it does not claim the code is wrong or temporarily wrong).

---

## Severity summary

- **must-fix-this-iter**: 3 — three `sorryAx`-bearing declarations blocking downstream work
- **major**: 2 — docstring misplacement; overclaiming inline comment
- **minor**: 3 — two planner-strategy blocks; one potential dead `have`
- **excuse-comments**: 0

Overall verdict: the two completed auxiliary lemmas (`isZero_of_faithful_preservesZeroMorphisms`, `isZero_presheafToSheaf_of_locally_isZero`) are axiom-clean and kernel-sound; no subsingleton-coherence traps detected; the three must-fix sorries are acknowledged genuine gaps from this iter matching the prover's own accounting; the main actionable non-sorry findings are the docstring misplacement on `OpenImmersionPushforward.lean:63` and the overclaiming "verified to exist" comment at `OpenImmersionPushforward.lean:111`.
