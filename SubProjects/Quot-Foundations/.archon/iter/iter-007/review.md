# Iter 007 — Review (Quot-Foundations)

## Verdict: QUOT-defs lane opened cleanly; 3 axiom-clean decls landed; build GREEN; 0 must-fix

iter-007 was the first prover iter on the **new third lane** (QUOT-defs frontier), with FBC
and GF correctly deferred for blueprint decomposition. `attempts_raw.jsonl`: 3 edits across
the two assigned files (GrassmannianCells, QuotScheme), no `no_prover_lane` flag. All three
reviewers — lean-auditor + 2 lean-vs-blueprint-checkers — returned **0 must-fix-this-iter**.
Every landed declaration is honest and axiom-clean ({propext, Classical.choice, Quot.sound}).

## Overall progress this iter

- **Project sorry: net −1.** `affineChart` (the only stub in GrassmannianCells.lean) filled →
  that file is now 0-sorry. QuotScheme stayed at 4 typed stubs (hilbertPolynomial,
  QuotFunctor, Grassmannian, representable — untouched per objectives). **No new sorry
  introduced** despite 3 new declarations (2 were full definitions/theorems, not stubs).
- **3 declarations landed, all axiom-clean:**
  - `Grassmannian.affineChart` — `Spec (CommRingCat.of (MvPolynomial (Fin d × {q ∉ I}) ℤ))`,
    exact blueprint recipe (`def:gr_affine_chart`).
  - `SheafOfModules.IsLocallyFreeOfRank` — substantive `Prop` predicate
    (`def:is_locally_free_of_rank`); non-vacuous both directions per the checker.
  - `Module.annihilator_isLocalizedModule_eq_map` — a **missing-from-Mathlib** engine lemma
    (`Ann(S⁻¹M) = (Ann M)·S⁻¹R` for f.g. `M`), the algebra half of the blocked annihilator
    ideal sheaf.
- **2 targets blocked on genuine Mathlib-infra gaps** (not proof difficulty):
  `Scheme.Modules.annihilator` (missing QCoh→`IsLocalizedModule` bridge) and
  `sectionGradedRing` (no tensor/monoidal structure on `SheafOfModules`). Both got a
  `% NOTE:` in the blueprint this iter; both documented with precise next steps.
- **solved / blocked: 3 / 2.**
- **Graph health:** `dag-query gaps` = 0; blueprint-doctor CLEAN; `dag-query unmatched` = 1
  (the new engine lemma — coverage debt, surfaced to the planner). sync_leanok (iter-007)
  added `\leanok` to `affineChart` + `is_locally_free_of_rank` — both genuinely sorry-free.

## This session's analysis — two findings shape iter-008

1. **The QUOT-defs lane delivered its cheap wins; the residue is Mathlib infrastructure, not
   proofs.** The two definitional targets that landed (`affineChart`, `IsLocallyFreeOfRank`)
   were the gate-cleared frontier; the engine lemma was a genuine bonus. The two remaining
   QUOT-defs (`Scheme.Modules.annihilator`, `sectionGradedRing`) are both blocked on
   *constructions absent from Mathlib at the pin* — a QCoh→`IsLocalizedModule` section-
   localization bridge, and a monoidal structure on `SheafOfModules`. These must be
   **blueprinted as multi-lemma sub-builds** before any prover re-dispatch; throwing the
   monolithic defs at a prover again will only produce PARTIAL. The annihilator one is the
   closer of the two — its algebra half (the engine lemma) and its localization-of-sections
   input (`IsAffineOpen.isLocalization_basicOpen`) already exist, so only the QCoh bridge +
   a finite-type signature wire-in remain.

2. **iter-008 owes the committed FBC+GF dispatch.** The iter-007 plan deferred FBC/GF to
   decompose their cruxes (progress-critic CHURNING×2), recording an explicit iter-008
   MANDATORY commitment. The QUOT-defs opening was critic-confirmed parallelism, not
   avoidance — but the same critic warned iter-008 "MUST dispatch FBC/GF or it crosses into
   avoidance." The sub-lemma chains cleared the HARD GATE at iter-007; iter-008 is the test
   of whether those stubs are closeable (and the GF STUCK reclassification trigger if not).

Secondary: a stale docstring on `GrassmannianCells.lean:59` ("the body is a typed `sorry`")
contradicts the filled body — flagged by the auditor (major) + grcells checker (minor); the
next prover owning that file should delete it (review agent cannot edit `.lean`).

## Review subagents dispatched (all recommended ones run — both files were edited)

- **lean-auditor `iter007`** (GrassmannianCells + QuotScheme): 0 critical / 1 major / 3 minor,
  **0 must-fix**. Major = the stale docstring. All 4 QuotScheme stubs confirmed honest typed
  scaffolding; both new decls verified sorry-free; no parallel Mathlib API, no excuse-comments,
  no axioms. → `task_results/lean-auditor-iter007.md`.
- **lean-vs-blueprint-checker `grcells-iter007`**: PASS, 0 must-fix, 2 minor (stale docstring;
  `#I = d` precondition not enforced in the Lean signature — def is more general than the
  blueprint). → `task_results/lean-vs-blueprint-checker-grcells-iter007.md`.
- **lean-vs-blueprint-checker `quot-iter007`**: 0 must-fix, 2 major — (i) `representable`
  Lean statement strictly weaker than the blueprint (intentional skeleton, but a formal
  mismatch to track); (ii) coverage gap for the engine lemma. →
  `task_results/lean-vs-blueprint-checker-quot-iter007.md`.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `def:modules_annihilator`: added `% NOTE:` (iter-007 blocker —
  missing QCoh→IsLocalizedModule bridge; algebra engine landed).
- `Picard_QuotScheme.tex`, `def:sectionGradedRing`: added `% NOTE:` (iter-007 blocker — no
  tensor/monoidal structure on SheafOfModules at the pin).
- No `\mathlibok` (all 3 decls project-local), no `\lean{...}` renames (both filled decls
  match their hints), no stale `\notready`. `\leanok` untouched (sync_leanok's domain).
