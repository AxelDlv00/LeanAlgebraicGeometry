# Lean Audit Report

## Slug
iter047

## Iteration
047

## Scope
- files audited: 3
- files skipped (per directive): 0 — directive explicitly scoped to 3 prover-touched files

---

## Per-file checklist

### AlgebraicJacobian/Picard/SectionGradedRing.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Declarations audited**: `sheafification`, `MonoidalPresheaf` (abbrev), `tensorObj`, `unitModule` (abbrev), `tensorPow`, `tensorPow_zero`, `tensorPow_succ`, `moduleTensorPow`, `moduleTensorPow_zero`, `sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`. All 13 top-level items.
  - **Axiom check (lean_verify)**: all declarations resolve to exactly `{propext, Classical.choice, Quot.sound}` — standard Mathlib baseline, no project-level axioms.
  - **Diagnostics**: zero errors, zero warnings.
  - **`tensorPowAdd` genuinely absent**: `grep tensorPowAdd` finds only comments/docstrings (lines 117, 123, 132, 156, 164, 168). There is no declaration, no `def tensorPowAdd`, no `sorry`-backed stub. The absence is clean.
  - **Block comment L163–202** ("DEFERRED (handoff)"): this is an engineering handoff note describing what is absent and why. It is NOT an excuse-comment — it explicitly states the feature is *absent* (not wrong), names the single missing Mathlib ingredient (strong-monoidality of the module sheafification localizer), and describes the proof skeleton. No apology, no "will fix later."
  - **`MonoidalPresheaf` abbrev (L72–73)**: the definitional-equality claim `X.ringCatSheaf.obj = X.sheaf.obj ⋙ forget₂ CommRingCat RingCat` is unproven in the comment but accepted by Lean elaboration — the file compiles and all downstream uses type-check. No issue.
  - **`sheafificationCounitIso` construction (L124–127)**: uses `asIso` on `PresheafOfModules.sheafificationAdjunction.counit`, which requires `IsIso` on the counit component. The `asIso` call succeeds (no diagnostic error), confirming Lean synthesizes the `IsIso` instance for the reflective counit. Sound.
  - **`tensorObjUnitIso`/`tensorObjRightUnitor` (L133–149)**: both are the pattern `sheafification.mapIso (presheaf_unitor) ≪≫ sheafificationCounitIso`. Types chain correctly. Axiom-clean.
  - **`tensorBraiding` (L157–161)**: `sheafification.mapIso (BraidedCategory.braiding ...)` — pure functoriality, axiom-clean.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: none (new region only)
- **suspect definitions**: none
- **dead-end proofs**: none (in the 3 new decls; the pre-existing `genericFlatness` sorry at L2451 is unchanged)
- **bad practices**: 1 flagged (minor; see notes)
- **excuse-comments**: none
- **notes**:
  - **New declarations audited (L2273–2328)**: `gf_affine_qcoh_Gamma_epi`, `gf_qcoh_finite_sections_globally_generated`, `gf_qcoh_finite_sections_of_free_epi`.
  - **Axiom check (lean_verify)**: all 3 resolve to `{propext, Classical.choice, Quot.sound}` — axiom-clean.
  - **Diagnostics**: one warning at L2360 — `declaration uses sorry` on `genericFlatness`. That declaration begins at L2360 (well outside the new range L2273–2328) and is pre-existing/expected. No warnings on the 3 new decls themselves.
  - **`gf_affine_qcoh_Gamma_epi` (L2273–2287)**: hypothesis set `[Epi π] [IsIso G.fromTildeΓ] [IsIso F.fromTildeΓ]` is non-circular — these are standard quasi-coherence + epimorphism assumptions. Proof: naturality of `fromTildeΓNatTrans` gives `tilde(Γπ) ≫ F.counit = G.counit ≫ π`; composing with `inv F.counit` yields `tilde(Γπ) = (G.counit ≫ π) ≫ inv F.counit`; RHS is epi (iso ≫ epi ≫ iso); faithfulness of `tilde.functor` reflects epi; `ModuleCat.epi_iff_surjective` closes. Logic is sound.
  - **`gf_qcoh_finite_sections_globally_generated` (L2299–2304)**: one-liner `Module.Finite.of_surjective _ (gf_affine_qcoh_Gamma_epi π)`. Direct and correct. The source-finiteness hypothesis `[Module.Finite R (moduleSpecΓFunctor.obj G)]` is a genuine load-bearing assumption (not vacuous).
  - **`gf_qcoh_finite_sections_of_free_epi` (L2318–2328)**: discharges the source-side hypotheses of `gf_qcoh_finite_sections_globally_generated` for the case `G = tilde N`. Three `haveI` steps:
    - `hiso` (L2322–2323): proves `IsIso (tilde N).fromTildeΓ` via the adjunction counit. Correct — the counit of `tilde.adjunction` at `tilde N` is an iso for a fully faithful left adjoint.
    - `hN` (L2324): **minor code smell** — registers `Module.Finite R ((𝟭 (ModuleCat R)).obj N)` via `inferInstanceAs`. This is definitionally equal to the hypothesis `[Module.Finite R N]` but is needed because the domain of `tilde.adjunction.unit.app N` has type `(𝟭 _).obj N`, which blocks direct instance lookup. The step is technically correct and presumably necessary; the named variable `hN` is never explicitly referenced (it acts as an anonymous `haveI`). **Minor practice issue**: the name `hN` suggests a debugging artifact — would be cleaner as unnamed `haveI`.
    - `hfin` (L2325–2327): `Module.Finite.of_surjective (unit.app N).hom (... inferInstance)` — `inferInstance` synthesizes `Epi (unit.app N)` from `IsIso` (fully faithful left adjoint's unit is iso). Correct.
  - **Pre-existing sorry (L2451)**: `genericFlatness` terminates in `sorry`. The surrounding comment (L2448–2450) is a transparency note: "the construction terminates in an honest sorry here rather than committing to an unjustified open." This is NOT an excuse-comment — it accurately describes the state and doesn't claim correctness of an incorrect definition.
  - **lean_verify warning "local instance" at L1912**: pre-existing, in `genericFlatnessAlgebraic`. The comment at that line accurately describes the `letI`/`haveI` lines that follow. No issue.

---

### AlgebraicJacobian.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single change: `import AlgebraicJacobian.Picard.SectionGradedRing` added (L7). Import list remains alphabetical within the `Picard.*` block.
  - Diagnostics: zero errors, zero warnings.
  - The new import resolves correctly (the imported file compiles cleanly).

---

## Must-fix-this-iter

None.

All new declarations are axiom-clean. No sorry stubs, no weakened definitions, no excuse-comments, no parallel APIs re-implementing Mathlib. `tensorPowAdd` is cleanly absent.

---

## Major

None.

---

## Minor

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:2324` — `haveI hN` is a technically-necessary definitional cast (`Module.Finite R ((𝟭 R).obj N)` from `[Module.Finite R N]`) registered via `haveI` but the named variable `hN` is never explicitly referenced. Suggests a debugging artifact; would be cleaner as `haveI : Module.Finite R ((𝟭 _).obj N) := inferInstanceAs (Module.Finite R N)` (anonymous). No correctness issue.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 1
- **excuse-comments**: 0

Overall verdict: iter-047 is clean — all new code (13 SectionGradedRing decls + 3 FlatteningStratification decls) is axiom-clean with standard axioms only, `tensorPowAdd` is honestly absent with no sorry stub, and the 3 FlatteningStratification theorems carry non-vacuous, non-circular hypotheses.
