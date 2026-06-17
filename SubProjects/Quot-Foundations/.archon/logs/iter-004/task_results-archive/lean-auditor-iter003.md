# Lean Audit Report

## Slug
iter003

## Iteration
003

## Scope
- files audited: 5
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pure import file (4 lines). No content to audit.

---

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged
- **excuse-comments**: none
- **notes**:
  - **Lines 291, 330, 333, 337, 367, 381, 383, 431, 482, 509, 512, 520, 569, 574, 576, 577, 580, 581, 583, 602, 612 (21 sites)** — `CategoryTheory.Sheaf.val` is deprecated; replacement is `ObjectProperty.obj`. All 21 uses are in *proved, axiom-clean* declarations (`gammaPushforwardIso`, `gammaPushforwardIsoAt`, `fromTildeΓ_app_isIso_of_isLocalizedModule`, `tildeRestriction_isLocalizedModule`, `pushforward_spec_tilde_iso`). LSP confirms these are active warnings. Will become breaking errors when Mathlib removes the deprecated field.
  - **Lines 181–244** — Long STATUS comment references iteration numbers "iter-234", "iter-236", "iter-240", "iter-241" inherited from the predecessor project *Algebraic-Jacobian-Challenge*. These numbers have no meaning in the current *Quot-Foundations* project. Not misleading about the code, but confusing for anyone trying to correlate code history with the current project log.
  - **Line 1** — `import Mathlib` without `set_option autoImplicit false` at file top. All other source files set this option explicitly. The omission is low-risk (all declarations have explicit type annotations) but inconsistent.
  - **Lines 750–757** (`pullbackIsoEquivalenceOfIso`) — Uses `CategoryTheory.Equivalence.mk` with the triangle-identity coherence field (`functor_unitIso_comp`) discharged by the default `aesop_cat`. LSP reports no errors; the definition elaborates cleanly. Flagged as a minor note per the directive's focus area: the coherence discharge is implicit and should remain monitored if the unit/counit isos are ever refactored.
  - **Lines 291, 580** — Two lines exceed the 100-character linter limit (linter warnings confirmed by LSP).
  - **Lines 830–845** (`base_change_mate_generator_trace`) — `sorry` body. Surrounding comment names the "genuine outstanding crux" explicitly and describes the generator-trace step. Honest deferral; not an excuse-comment.
  - **Lines 920–951** (`affineBaseChange_pushforward_iso`) — `sorry` in the proof body. Comment gives a detailed account of the affine-reduction obligation. Honest deferral.
  - **Lines 960–973** (`flatBaseChange_pushforward_isIso`) — `sorry` body. Comment names the Čech-cohomology infrastructure gap. Honest deferral.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: 1 flagged (iter-number provenance)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - **Lines 273–285** (`exists_localizationAway_finite_mvPolynomial` return type) — Instance-existential binding pattern: the existential binds three anonymous instances (`∃ (_ : Algebra …) (_ : Algebra …) (_ : IsScalarTower …), …`). When consumed via `obtain`, the destructured variables are anonymous; the consumer must `haveI`/`letI`-revive each one before Lean can unify subsequent type class goals (including the `Module.Finite` conclusion which depends on them). The sorry in `genericFlatnessAlgebraic` means this consumption has not been tested. The interface is fragile.
  - **Comments referencing "iter-173" through "iter-177"** — These are predecessor-project iteration numbers (same issue as in FlatBaseChange.lean). Not an excuse-comment; just a cross-project numbering artefact.
  - **Lines 247** (`exists_free_localizationAway_of_shortExact`) — `sorry` body. Comment lists three concrete sub-steps (localised SES exactness, `Module.free_of_isLocalizedModule` transport, SES splitting). Honest scaffolding deferral.
  - **Lines 292** (`exists_localizationAway_finite_mvPolynomial`) — `sorry` body. Comment describes the Noether-normalisation + clearing-denominators route. Honest deferral.
  - **Lines 333** (`exists_free_localizationAway_polynomial`, inductive step) — `sorry` body. Comment names the generic-rank dévissage as the surviving residue. Honest deferral.
  - **Lines 400** (`genericFlatnessAlgebraic`) — `sorry` body. Comment names the prime-filtration assembly route and lists all component lemmas by name. Honest deferral.
  - **Lines 467** (`genericFlatness`) — `sorry` body. Comment gives the full geometric assembly outline. Honest deferral.

---

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: 1 flagged (iter-number provenance)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Lines 123, 161, 198** (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`) — `sorry` bodies. All three carry "iter-177+:" prefixed comments that describe the planned proof route. The iter-number references are from the predecessor project (minor cross-project artefact). The comments are honest deferrals naming the outstanding infrastructure (graded Euler characteristics, Setoid quotient wiring, chart-gluing). Not excuse-comments.
  - **Line 225** (`Grassmannian.representable`) — `sorry` body. Honest deferral; comment names the full Nitsure §1 chart-gluing proof route.

---

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: 1 flagged (iter-number provenance)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Lines 22–48** (module docstring) — References "iter-173", "iter-174", "iter-176", "iter-177", "iter-178", "iter-179" and mentions "lean-auditor iter-177 flagged both CRITICAL 'weakened-wrong'". These are predecessor-project iteration numbers. The comment is historically accurate about why the carrier was upgraded; not an excuse-comment. A reader working in the current project cannot match these iter numbers to the project log.
  - **Lines 184–185** (`RelativeSpec`) — Body `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued`. Correct Mathlib-aligned body; no sorry.
  - **Lines 199–201** (`RelativeSpec.structureMorphism`) — Body `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase`. Correct; no sorry.
  - **Lines 233–258** (`RelativeSpec.UniversalProperty`) — Full proof body; no sorry. Uses `isAffineHom_of_forall_exists_isAffineOpen`, `Cover.RelativeGluingData.toBase_preimage_eq_opensRange_ι`, and `isAffineOpen_opensRange`. Proof looks structurally sound.
  - **Lines 280–287** (`RelativeSpec.affine_base_iff`) — Full proof body; no sorry. Correctly reduces to `isAffine_of_isAffineHom`.
  - **Lines 228–232** (comment on `UniversalProperty`) — "iter-174+: refine the type signature to the full Yoneda-bijection statement". This is a forward-looking comment about strengthening the signature, not an excuse for the current statement being wrong. The current statement (`IsAffineHom`) is non-tautological and correct. Not an excuse-comment.

---

## Must-fix-this-iter

None.

No finding meets the must-fix bar: no excuse-comments, no weakened-wrong definitions, no suspect bodies (`:= True`, `:= rfl` on non-trivial goals, unauthorised `Classical.choice`), no unauthorised axioms, no Mathlib-parallel copies.

---

## Major

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:291,330,333,337,367,381,383,431,482,509,512,520,569,574,576,577,580,581,583,602,612` — **21 uses of deprecated `CategoryTheory.Sheaf.val`** (replacement: `ObjectProperty.obj`). All are in *proved, axiom-clean* declarations. LSP reports active deprecation warnings at every site. This will become a build-breaking change when Mathlib removes the deprecated field; the proved code would need to be reworked entirely.

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:273–285` — **Instance-existential binding in `exists_localizationAway_finite_mvPolynomial`**. Three anonymous existential instances (`∃ (_ : Algebra …)`, two `Algebra`, one `IsScalarTower`) in the return type make the lemma hard to consume: the caller must `letI`/`haveI`-revive them after `obtain`, and the `Module.Finite` conclusion's implicit dependence on the anonymous instances will force awkward roundabouts. The assembly (`genericFlatnessAlgebraic`) that must consume this has a `sorry` body, so the consumption is untested. The type signature is mathematically correct but will likely require revision when the `sorry` is filled.

---

## Minor

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1` — Missing `set_option autoImplicit false`. All other source files (`FlatteningStratification.lean`, `QuotScheme.lean`, `RelativeSpec.lean`) set this explicitly. Inconsistency is low-risk (all declarations have explicit annotations) but worth aligning.

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:750–757` (`pullbackIsoEquivalenceOfIso`) — `Equivalence.mk` used with explicit unit/counit; the triangle-identity field defaults to `aesop_cat`. LSP confirms no errors at this declaration; the coercion elaborates cleanly. Flagged per directive focus area: if the unit/counit are ever refactored, the implicit coherence discharge should be re-verified.

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:291,580` — Two lines exceed the 100-character linter limit (active linter warnings).

- All source files — Comments throughout reference predecessor-project iteration numbers (iter-173 through iter-241) from *Algebraic-Jacobian-Challenge*. These have no meaning in the current *Quot-Foundations* project and can mislead anyone trying to correlate code with the current project's iteration log. Not harmful to mathematical correctness, but confusing for project navigation.

---

## Excuse-comments (always called out separately)

None found. Every sorry-bearing declaration has surrounding comments that honestly name the specific missing proof ingredient, the Mathlib infrastructure gap, or the blocking crux. No comment uses language equivalent to "temporary", "placeholder", "wrong but works", or "will fix later" — the pattern is consistently "REMAINING: [concrete next step]" or "surviving residue".

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: The codebase is in good shape mathematically — all `sorry`s are honest scaffold deferrals, no weakened-wrong definitions were found, and the proved code (`RelativeSpec`, `pushforward_spec_tilde_iso` chain, the `fromTildeΓ` assembly) is clean. The one actionable concern before the next Mathlib pin bump is the 21-site `Sheaf.val` deprecation cluster in `FlatBaseChange.lean`; the instance-existential interface in `FlatteningStratification.lean` is a fragility that will surface when the dévissage `sorry`s are filled.
