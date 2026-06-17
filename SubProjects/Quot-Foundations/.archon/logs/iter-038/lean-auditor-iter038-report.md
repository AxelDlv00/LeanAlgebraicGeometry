# Lean Audit Report

## Slug
iter038

## Iteration
038

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/GrassmannianCells.lean

- **outdated comments**: 2 flagged (stale `scaffold` archon markers on now-complete sections)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All 6 new declarations (lines 1866–2044) are sorry-free. No `admit`, no `axiom`, no `sorry`.
  - **`existence_chart_kpoint_eq` (line 1866)**: Term-mode `congrArg`/`calc` justified by the
    documented Scheme-category instance diamond on heavy localisation objects — the same diamond
    that forced `erw` throughout the earlier chart-gluing proofs. The proof chain (reassociate,
    apply glue condition, localization lift property) is mathematically honest.
  - **`existence_lift` (line 1920)**: `noncomputable def` returning `sq.LiftStruct` is the
    correct shape — this is *data* (the morphism `l` plus two triangle proofs), not a Prop, so
    `def` not `theorem` is appropriate. The `fac_right` one-liner via `specZIsTerminal.hom_ext`
    is correct (both legs land in the terminal `Spec ℤ`). The `fac_left` term-mode calc is
    honest for the same instance-diamond reason.
  - **`liftToBaseOfMemRange` (line 1977)**: Correct construction (codRestrict → inverse of
    rangeRestrict-bijection). The proof of `algebraMap_comp_liftToBaseOfMemRange` is correct.
    Minor: the `letI hinj` block is duplicated verbatim between the definition (line 1980) and
    the lemma (line 1994); both are `private`, so the duplication is contained. Extracting a
    shared private `hinj` would clean this up but is not a correctness issue.
  - **`valuativeExistence_toSpecZ` (line 2017)**: Assembles E1–E5 cleanly. Each step is named
    and justified. The `isUnit_iff_ne_zero.mpr` bridge (nonzero in a field = unit) is correct.
  - **`isProper` (line 2042)**: One-liner. Correct.
  - **Stale `scaffold` labels (lines 1836, 1963)**: Section headers
    `/-! ## Existence step E4 — … (`scaffold` GrassmannianCells.lean) -/` and
    `/-! ## Existence step E5 — … (`scaffold` GrassmannianCells.lean) -/` still carry the
    Archon planning keyword. Both sections are now fully proved (no sorry). The label is
    harmless to Lean but is a stale signal to the Archon objective filter; it could cause the
    planner to re-issue E4/E5 objectives next iter. Severity: minor.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none
- **suspect definitions**: 3 flagged (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian` —
  `def`s whose bodies are `sorry`; pre-existing acknowledged scaffolding)
- **dead-end proofs**: none
- **bad practices**: 1 flagged (`erw` + `rfl` fragility)
- **excuse-comments**: 0 — the sorry-stub docstrings are honest scaffold (see below)
- **notes**:
  - **`gammaImageRingEquiv` (line 1815)**: One-line definition, correct direction.
    `(j.appIso V).commRingCatIsoToRingEquiv.symm : Γ(X, V) ≃+* Γ(Y, j ''ᵁ V)` maps
    source → image, consistent with the docstring. No direction-mismatch hazard.
  - **`gammaPullbackImageIso_hom_semilinear` (line 1825)**: The `simp only [...]` / `erw
    [Scheme.Modules.Hom.app_smul]` / `rfl` close is accepted by Lean (file is sorry-free). The
    `erw` is needed to fire through the instance diamond (established pattern in this file). The
    `rfl` relies on the definitional equality `gammaImageRingEquiv j V a = (j.appIso V).inv a`,
    which holds because `commRingCatIsoToRingEquiv.symm` is defined with `.invFun = iso.inv`.
    **Fragility flag (major)**: if a future Mathlib bump changes the body of
    `commRingCatIsoToRingEquiv` or `Hom.app_smul`, this `rfl` will silently break without
    surfacing a mathematical error. The defeq claim in the comment is accurate but the proof has
    no structural guard. A `show ... from ...` wrapper would make the claimed equality explicit.
  - **Pre-existing sorry stubs (lines 126, 165, 201, 228)**:
    - `hilbertPolynomial := sorry` (line 126), `QuotFunctor := sorry` (line 165),
      `Grassmannian := sorry` (line 201): these are `def`s whose bodies are `sorry`. Their types
      are substantive (not weakened). The docstring comments ("iter-177+: the body unfolds to
      …; for the iter-176 file-skeleton the body is a typed `sorry`") are **honest scaffold**,
      not excuses: they state the dependency gating condition explicitly (Snapper's Lemma /
      `QCoh(Spec R) ≃ Mod R`) and give a forward iteration target.
    - `Grassmannian.representable := sorry` (line 228): same pattern. A `theorem ... := sorry`
      is an open proof obligation, not a fake proof.
    - **Assessment**: NOT dead code. The types are correct and load-bearing for the blueprint
      goals. No other file in the project currently consumes the *values* of these definitions,
      so they are not presently blocking downstream compilation. However, per the lean-auditor
      strict rule (`:= sorry` on a load-bearing claim → must-fix-this-iter), these are flagged
      accordingly. The plan agent should interpret them as known pre-existing scaffold, not as
      new regressions.

---

## Must-fix-this-iter

All four are pre-existing acknowledged scaffolding, not new regressions introduced this iter.
The plan agent should confirm they remain gated on Mathlib infrastructure, not silently slip to
"never fix" status.

- `AlgebraicJacobian/Picard/QuotScheme.lean:126` — `hilbertPolynomial := sorry`. Substantive
  `def` with a sorry body; the returned polynomial is fake.  
  Why must-fix: `:= sorry` on a load-bearing declaration whose value is the object of the
  project's blueprint goal.
- `AlgebraicJacobian/Picard/QuotScheme.lean:165` — `QuotFunctor := sorry`. Substantive
  contravariant functor with sorry body.  
  Why must-fix: same.
- `AlgebraicJacobian/Picard/QuotScheme.lean:201` — `Grassmannian := sorry`. Substantive
  functor with sorry body.  
  Why must-fix: same.
- `AlgebraicJacobian/Picard/QuotScheme.lean:228` — `Grassmannian.representable := sorry`.
  Substantive theorem with sorry body; the representing scheme is not constructed.  
  Why must-fix: `:= sorry` on a load-bearing theorem.

---

## Major

- `AlgebraicJacobian/Picard/QuotScheme.lean:1832–1840` — `erw` + `rfl` close in
  `gammaPullbackImageIso_hom_semilinear`. The `rfl` at line 1840 is accepted by Lean but
  encodes a non-trivial definitional equality (`commRingCatIsoToRingEquiv.symm a = iso.inv a`)
  with no structural guard. A future Mathlib refactor of `commRingCatIsoToRingEquiv` or
  `Scheme.Modules.Hom.app_smul` could silently break this without a mathematical error message.
  Recommend wrapping the `rfl` close with a `show LHS = RHS` making the claimed equality
  explicit, so a Mathlib bump produces a legible error rather than a "type mismatch" mystery.

---

## Minor

- `AlgebraicJacobian/Picard/GrassmannianCells.lean:1980–1983 / 1994–1997` — `letI hinj`
  construction duplicated verbatim between `liftToBaseOfMemRange` (def) and
  `algebraMap_comp_liftToBaseOfMemRange` (lemma). Both are `private`, so the duplication is
  contained. Could be extracted to a shared `private lemma algebraMap_rangeRestrict_injective`.
- `AlgebraicJacobian/Picard/GrassmannianCells.lean:1836, 1963` — Section headers for E4 and
  E5 still carry the Archon `scaffold` planning marker keyword. Both sections are now
  sorry-free and complete. The marker may cause the Archon planner to re-issue these objectives
  in the next iteration. Removing or updating the label (e.g., changing `scaffold` to `done`)
  would prevent spurious re-dispatch.

---

## Excuse-comments (always called out separately)

None. The four sorry-stub docstrings in QuotScheme.lean ("for the iter-176 file-skeleton the
body is a typed `sorry`") are honest scaffold annotations: they accurately describe the current
state, identify the blocking dependency (Snapper's Lemma / `QCoh ≃ Mod`), and give a specific
forward target (iter-177+). They do not try to justify *wrong* definitions or obscure
incompleteness; they document it. The underlying `sorry` bodies are flagged as must-fix above
on independent grounds.

---

## Severity summary

- **must-fix-this-iter**: 4 — pre-existing sorry stubs on the four blueprint-pinned declarations
  in QuotScheme.lean; block downstream proof work in that file once any code tries to use their
  values. Honest scaffolding, but blocking per the strict rule.
- **major**: 1 — `erw` + `rfl` fragility in `gammaPullbackImageIso_hom_semilinear`
  (structurally unguarded definitional equality).
- **minor**: 2 — duplicate `letI hinj` (contained); stale `scaffold` labels on complete
  sections (Archon planner signal).
- **excuse-comments**: 0

Overall verdict: GrassmannianCells.lean is fully clean — six new declarations, all sorry-free,
mathematically honest proofs, term-mode glue properly justified; QuotScheme.lean's two new
declarations are clean, while its four pre-existing sorry stubs remain the only open
obligations (honest scaffolding, gated on Mathlib infrastructure not yet at the pinned commit).
