# Lean Audit Report

## Slug
iter052

## Iteration
052

## Scope
- files audited: 2 (directive narrowed scope to two modified files)
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (pre-existing, not in new decls — see notes)
- **excuse-comments**: none
- **notes**:
  - **New decl `affine_tildeVanishing` (line 491, private)**: One-liner term-mode proof delegating to
    `sectionCech_homology_exact_of_localizationAway`. The absence of `[F.IsQuasicoherent]` is correct:
    the statement is about `tilde (moduleSpecΓFunctor.obj F)` (the tilde of the global-section module),
    not about `F` itself. Quasi-coherence of the tilde sheaf is not a hypothesis to `sectionCech_…`;
    the qcoh constraint lives one level up in `affine_cech_vanishing_qcoh_of_tildeVanishing`. No
    weakening, no vacuousness.
  - **New decl `affine_cech_vanishing_qcoh` (line 510)**: One-liner. Carries `[F.IsQuasicoherent]`
    correctly (needed for `qcoh_iso_tilde_sections` inside the reduction). Delegation shape and
    type-class hygiene are sound.
  - **New decl `affine_serre_vanishing` (line 521)**: One-liner. Carries both `[EnoughInjectives …]`
    and `[F.IsQuasicoherent]`, as required by `affine_serre_vanishing_of_tildeVanishing`. Sound.
  - All three new declarations have zero LSP diagnostics (confirmed via `lean_diagnostic_messages`).
  - **Pre-existing (not new)** — bad practices noted for completeness:
    - Lines 336, 355: `show` used where `change` is appropriate (style-linter warning).
    - Lines 220, 363: `set_option maxHeartbeats` without an explanatory comment (style-linter
      warning). These are large but have context-setting preceding comments so the intent is clear.
  - No `sorry` anywhere in file.

---

### `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 3 flagged (all pre-existing, not in new decls — see notes)
- **excuse-comments**: none
- **notes**:
  - **Frozen `sorry` at line 780 (`cech_computes_higherDirectImage`, protected P5b)**: Known and
    intentional per directive. Surrounding docstring at lines 749–780 accurately describes the proof
    route ("Route A: reduce to S affine…"), contains no excuse-phrasing, and gives a concrete
    roadmap. Not misleading.
  - **New decl `isZero_presheafToSheaf_obj_of_W` (line 811)**: Two-step tactic proof. Step 1 uses
    `(J.W_iff f).1 hf` to extract that `presheafToSheaf.map f` is an iso. Step 2 applies
    `hQ.of_iso (asIso …)`. Direction check: `asIso (presheafToSheaf.map f) : P_sh ≅ Q_sh`, which
    matches `IsZero.of_iso : IsZero X → Y ≅ X → IsZero Y` with `Y = P_sh`, `X = Q_sh`. Correct.
    Zero LSP diagnostics.
  - **New decl `isZero_presheafToSheaf_obj_of_W_isZero` (line 825)**: Adds `[Abelian A]` and
    `[HasSheafify J A]` (stronger than the previous lemma's `[HasWeakSheafify J A]`). Uses
    `presheafToSheaf_additive` to obtain additivity, then `Functor.map_isZero` to transfer the zero
    presheaf `Q` to a zero sheaf, then defers to `isZero_presheafToSheaf_obj_of_W`. Correct
    strengthening; the two `haveI`/`exact` steps are kernel-cheap.
  - **New decl `isZero_presheafToSheaf_obj_of_isLocallyBijective` (line 840)**: Term-mode one-liner
    applying `J.W_of_isLocallyBijective f` and delegating to `isZero_presheafToSheaf_obj_of_W_isZero`.
    The explicit `{FA : A → A → Type*}` / `{CA : A → Type*}` implicit parameters and the
    `[ConcreteCategory A FA]` spelling are the Mathlib 4 new-style `ConcreteCategory` API required by
    `WEqualsLocallyBijective`; they are unusual-looking but standard and carry no soundness concern.
    One minor usability note: `FA` must be inferable from context; this is always the case for
    `AddCommGrpCat` (the primary consumer).
  - All three new declarations (lines 811–846) have zero LSP diagnostics.
  - Placement of the three new lemmas outside `AlgebraicGeometry`, in the
    `CategoryTheory.GrothendieckTopology` namespace, is correct: they are pure site theory, and the
    comment at line 797 accurately explains the import-cycle motivation.
  - **Pre-existing (not new)** — bad practices for completeness:
    - Lines 341, 368, 434: `set_option maxHeartbeats` without explanatory comments (style-linter).
    - Line 711: `show` should be `change` (style-linter).

---

## Must-fix-this-iter

*None.*

---

## Major

*None.*

---

## Minor

- `AffineSerreVanishing.lean:336,355` — `show` tactic changes the goal; style linter recommends
  `change`. Pre-existing, not introduced this iter.
- `AffineSerreVanishing.lean:220,363` — `set_option maxHeartbeats` without an explanatory comment.
  Pre-existing.
- `CechHigherDirectImage.lean:341,368,434` — `set_option maxHeartbeats` without explanatory
  comments. Pre-existing.
- `CechHigherDirectImage.lean:711` — `show` changes goal; should be `change`. Pre-existing.
- `CechHigherDirectImage.lean:840` — `isZero_presheafToSheaf_obj_of_isLocallyBijective` exposes
  `{FA}` / `{CA}` implicit parameters from `ConcreteCategory`; callers need those inferrable. No
  soundness issue; minor usability note for future consumers.

---

## Excuse-comments (always called out separately)

*None found.*

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 7 (all pre-existing style-linter findings; none introduced this iter)
- **excuse-comments**: 0 (none)

Overall verdict: Both files are sound; the three new declarations in each file are clean, non-vacuous, and compile without errors or warnings; all style-linter findings are pre-existing and do not affect correctness.
