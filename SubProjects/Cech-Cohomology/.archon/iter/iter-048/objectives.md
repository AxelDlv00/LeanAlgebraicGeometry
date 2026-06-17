# Iter-048 objectives

## Lane 1 (mathlib-build) — `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
Build the NEW declaration `isIso_fromTildeΓ_of_quasicoherent` (`lem:qcoh_isIso_fromTildeGamma`), the Route-B
assembly — the LAST 01I8 step (frontier-READY; all 5 `\uses` deps DONE: keystone
`qcoh_section_isLocalizedModule` + the 4 Mathlib anchors `fromTildeΓ`, `isIso_fromTildeΓ_iff`,
`SheafOfModules.fullyFaithfulForget`, `IsLocalizedModule.linearEquiv`).

- Source of truth: blueprint `lem:qcoh_isIso_fromTildeGamma` in
  `chapters/Cohomology_CechHigherDirectImage.tex` (4-step forget-reflects-isos / basis / lift-of-localizations
  proof).
- Statement: for `X=Spec R`, qcoh `F`, the counit `fromTildeΓ : tilde(Γ(X,F)) ⟶ F` is an iso. Register as an
  `instance` `[F.IsQuasicoherent] → IsIso F.fromTildeΓ` ⟹ `qcoh_iso_tilde_sections` unconditional for qcoh `F`.
- The keystone is DONE — do NOT rebuild it; supply its `IsLocalizedModule` instance via `@`-application if
  instance synthesis can't find it on the `homOfLE` map term (as iter-047 did for the corollary).
- Likely Mathlib need to confirm: the exact name for "the `D(f)`-component of `fromTildeΓ` IS the localization
  lift `IsLocalizedModule.lift(powers f)` of `ρ_f`". If absent, mathlib-build the ingredient axiom-clean.
- WATCH the `↑R`-Semiring instance diamond — `change`/defeq + presheaf-abstracted helpers, NOT `rw`/`simp` on
  `∘ₗ`/`LinearMap.pi` over basicOpen sections (KB recipe).

## Gate status
- Blueprint HARD GATE: CLEARED (blueprint-reviewer `iter048`, complete + correct, 0 must-fix).
- Coverage debt: `unmatched` 6→1 + `isolated` →1 (both = only the pre-existing dead `CechAcyclic.affine`).
- progress-critic + strategy-critic: skipped with recorded rationale (route landed clean SOLVE of the hardest
  leaf; strategy route unchanged). See `plan.md` § Subagent skips.
