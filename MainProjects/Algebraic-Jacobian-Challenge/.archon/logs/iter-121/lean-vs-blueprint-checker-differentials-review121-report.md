# Lean ↔ Blueprint Check Report

## Slug
differentials-review121

## Iteration
121

## Files audited
- Lean: `AlgebraicJacobian/Differentials.lean`
- Blueprint: `blueprint/src/chapters/Differentials.tex`

## Summary

The Lean file holds 3 substantive declarations; the blueprint chapter now
exposes 7 `\lean{...}` blocks (3 existing, 4 forward-design for the M1
bridge). Per the directive, the 4 forward-design declarations
(`relativeDifferentialsPresheaf_iso_kaehler_appLE`,
`appLE_isLocalization`, `kaehler_localization_subsingleton`,
`kaehler_quotient_localization_iso`) are intentionally not yet in Lean —
iter-122's plan-phase will dispatch a refactor subagent to stub them. I
report them as informational, not as Lean-side defects.

I do not re-flag the four mathlib-analogist findings listed in the
directive (the `_iso_` vs `_equiv_` rename, the `IsAffineOpen.` vs
`Scheme.` namespace for `appLE_isLocalization`, the M1.c non-gap, and
the M1.b cofinality framing); the directive marks them as
already-recorded iter-122 inputs.

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf}` (chapter: \def:relative_kaehler_presheaf)
- **Lean target exists**: yes — `Differentials.lean:49`.
- **Signature matches**: yes. Lean returns `X.PresheafOfModules` for
  `f : X ⟶ S`; blueprint says "a presheaf of $\struct{X}$-modules on
  $X$". Match.
- **Proof follows sketch**: yes (definition body). The chapter
  describes the construction as
  `f^{-1}_{\mathrm{psh}}\struct{S} \to \struct{X}` (the adjunction
  transpose of `f.c`) fed into `relativeDifferentials'`. Lean uses
  exactly `TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base`
  then `homEquiv.symm` on `f.c`, then
  `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`.
  One-to-one with the prose.
- **notes**: definition is `noncomputable` and uses universe `u`,
  consistent with the chapter (no universe constraints stated). The
  blueprint prose explicitly names `relativeDifferentials'` as the
  construction used; Lean matches.

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler}` (chapter: \lem:relative_kaehler_presheaf_obj)
- **Lean target exists**: yes — `Differentials.lean:58`.
- **Signature matches**: yes (modulo a stylistic choice — see notes).
  Statement is a type-level equality
  `(Ω(V) : Type _) = CommRingCat.KaehlerDifferential (… homEquiv.symm f.c |>.app V)`,
  which is precisely the chapter's
  `\Omega_{X/S}(V) = \Omega_{\Gamma(X,V)/(f^{-1}_{\mathrm{psh}}\struct{S})(V)}`
  identification.
- **Proof follows sketch**: yes — Lean body is `rfl`, blueprint sketch
  says "by `rfl` after unfolding the definition".
- **notes**: the statement is a `Type` equality, not a `LinearEquiv`
  or `ModuleCat` iso. Blueprint uses `=`, so this is a faithful
  rendering. A future strengthening to a module-level iso would
  follow naturally from the bridge work in M1, but the current
  `rfl`-level fact is the right entry point for the M1.e final
  composition step.

### `\lean{AlgebraicGeometry.Scheme.smooth_locally_free_omega}` (chapter: \thm:smooth_locally_free_omega)
- **Lean target exists**: yes — `Differentials.lean:91`.
- **Signature matches**: yes. Lean: `[SmoothOfRelativeDimension n f] →
  ∀ x, ∃ U V e, x ∈ V ∧ IsAffineOpen U ∧ IsAffineOpen V ∧ (under appLE
  algebra structure: Module.Free B Ω[B/A] ∧ Module.rank B Ω[B/A] = n)`.
  Blueprint asserts exactly this forward-direction statement on the
  appLE-algebra Kähler module. Match.
- **Proof follows sketch**: yes, with one minor name-divergence
  (informational; not a defect):
  - Blueprint Step 1 cites the `@[mk_iff]`-generated
    `smoothOfRelativeDimension_iff`; Lean uses the equivalent direct
    extraction lemma
    `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension`.
    Same chart witness, different entry point.
  - Step 2 → `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`: ✓
  - Step 3 → `Algebra.IsStandardSmooth.free_kaehlerDifferential`: ✓
  - Step 4 → `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`: ✓
  - Step 4.5 (Nontrivial B): blueprint names
    `AlgebraicGeometry.Scheme.component_nontrivial`; Lean discharges
    the side condition via the typeclass shortcut
    `haveI : Nonempty V := ⟨⟨x, hxV⟩⟩` and trusts the instance chain
    to produce `Nontrivial Γ(X, V)`. Same mathematical content, more
    indirect Lean realisation.
- **notes**: the `first | exact … | exact …` branch handles both
  conjuncts (`Module.Free` and `Module.rank = n`) under the same
  algebraize+haveI prelude; clean and direct.

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_iso_kaehler_appLE}` (chapter: \thm:relativeDifferentialsPresheaf_iso_kaehler_appLE)
- **Lean target exists**: **no — by design** (informational per
  directive). The declaration is the M1 milestone goal; iter-122 will
  introduce it with a `sorry` body via a refactor dispatch.
- **Notes for iter-122 refactor**: per the directive, the analogist
  recommended renaming `_iso_` → `_equiv_` (Mathlib convention
  `LinearEquiv`/`AlgEquiv`/etc. tagged with `_equiv_`). Not my
  finding; recorded here for hand-off.

### `\lean{AlgebraicGeometry.Scheme.appLE_isLocalization}` (chapter: \lem:appLE_isLocalization)
- **Lean target exists**: **no — by design** (informational per
  directive).
- **Notes for iter-122 refactor**: per directive, the analogist
  recommended namespace `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`
  rather than `AlgebraicGeometry.Scheme.appLE_isLocalization`,
  matching Mathlib's convention of attaching such results to
  `IsAffineOpen`.

### `\lean{AlgebraicGeometry.Scheme.kaehler_localization_subsingleton}` (chapter: \lem:kaehler_localization_subsingleton)
- **Lean target exists**: **no — by design** (informational per
  directive).
- **Notes for iter-122 refactor**: per directive, this is NOT a
  Mathlib gap; Mathlib already proves the subsingleton conclusion via
  `FormallyUnramified.of_isLocalization` +
  `subsingleton_kaehlerDifferential`. The blueprint claim that this
  is a "genuine Mathlib gap-fill" (chapter line 138) is incorrect; a
  blueprint-writer should land a correction noting that Mathlib
  supplies the result and the project-side stub can be a thin
  re-export. **I flag this as a chapter-side correction needed in
  iter-122**, not a Lean-side defect.

### `\lean{AlgebraicGeometry.Scheme.kaehler_quotient_localization_iso}` (chapter: \lem:kaehler_quotient_localization_iso)
- **Lean target exists**: **no — by design** (informational per
  directive).
- **Notes for iter-122 refactor**: per directive's note on the M1.b
  cofinality framing, the analogist preferred
  `IsLocalization.of_le` with cocone universality over the blueprint
  current `Functor.Final`-via-colim comparison; not my finding.

## Red flags

None on the Lean side. The 3 existing declarations are non-`sorry`,
have substantive proofs, and contain no excuse-comments. No `axiom`
declarations, no `Classical.choice` shortcuts, no `:= True`
placeholders.

The `smooth_locally_free_omega` docstring contains an extensive
prose remark on the converse direction being false and on the bridge
being a Mathlib gap — these are **explanatory comments, not
excuse-comments**. They document the deliberate scope boundary
(forward direction only) and point readers to the blueprint section
that handles the bridge. Acceptable.

## Unreferenced declarations (informational)

None. All 3 Lean declarations are `\lean{...}`-referenced from the
blueprint.

## Blueprint adequacy for this file

- **Coverage**: 3/3 existing Lean declarations have corresponding
  `\lean{...}` blocks; the remaining 4 blueprint blocks are the M1
  forward design intentionally not yet implemented.
- **Proof-sketch depth**: adequate for the 3 existing declarations.
  The chapter's Steps 1–4.5 for `smooth_locally_free_omega` give a
  prover precisely the Mathlib closure pieces it needs; the proof in
  Lean is a faithful rendering. The chapter's proof of
  `relative_kaehler_presheaf_obj` ("by `rfl` after unfolding") is
  exactly what the Lean does. The Definition for
  `relativeDifferentialsPresheaf` correctly identifies the
  adjunction-transpose and the `relativeDifferentials'` construction
  used in Lean.
- **Hint precision**: precise for the 3 existing pairs. Each
  `\lean{...}` names the non-deprecated form
  (`SmoothOfRelativeDimension`, per Remark `rem:smooth_class_naming`).
- **Generality**: matches need.
- **Recommended chapter-side actions** (for iter-122 blueprint-writer):
  1. **Critical**: revise the M1.c proof (chapter line 138) to
     remove the incorrect "Mathlib has no off-the-shelf lemma"
     claim; Mathlib's `FormallyUnramified.of_isLocalization`
     followed by `subsingleton_kaehlerDifferential` discharges the
     conclusion, so M1.c reduces to a thin re-export rather than a
     contribution candidate. (Directive-supplied finding; this is
     the new manifestation, given that the chapter now states a
     concrete plan-of-attack that contradicts the analogist's
     verdict.)
  2. **Minor**: the `\lean{...}` hints for the 4 forward-design
     declarations should match the names the refactor subagent will
     actually create in iter-122; per the analogist's advisory
     these should be `..._equiv_kaehler_appLE` (not `_iso_`) and
     `IsAffineOpen.appLE_isLocalization` (not
     `Scheme.appLE_isLocalization`). The plan/refactor pair will
     either rename the blueprint hints or land the declarations
     under the current hint names; either resolves the mismatch.
  3. **Minor**: a one-line cross-reference in the
     `smooth_locally_free_omega` proof's Step 4.5 noting that the
     Lean discharges `Nontrivial B` via `Nonempty V` + typeclass
     synthesis (rather than calling `component_nontrivial`
     directly) would help future readers reconcile chapter prose
     with the Lean tactic. Stylistic only.

## Severity summary

- **must-fix-this-iter**: 0. The Lean file was not touched this iter
  and the 3 existing declarations remain faithful to the blueprint.
  The chapter-side issue about M1.c being misrepresented as a Mathlib
  gap is already recorded as an iter-122 input per the directive and
  is not a `must-fix-this-iter` blocker per the directive's
  classification.
- **major**: 0.
- **minor**:
  - `smooth_locally_free_omega` Step 1 names a different Mathlib
    entry point in the chapter than the Lean uses
    (`smoothOfRelativeDimension_iff` vs.
    `exists_isStandardSmoothOfRelativeDimension`); same conclusion.
  - Step 4.5's `Nontrivial B` discharge mechanism differs in
    realisation between chapter and Lean.

Overall verdict: **PASS** — the 3 existing Lean declarations
faithfully track the blueprint; the 4 new forward-design blueprint
blocks are deferred to iter-122 by explicit directive and do not
constitute a Lean-side defect this iter.
