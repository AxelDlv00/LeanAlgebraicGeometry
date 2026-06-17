# Refactor Report

## Slug

grpobj-and-jacobian-iter135

## Status

COMPLETE

## Directive

(See `.archon/logs/iter-135/refactor-grpobj-and-jacobian-iter135-directive.md`
for the full directive. Summary:)

- **Problem 1**: 3 weakened-wrong-definition placeholders at
  `Cotangent/GrpObj.lean:476-482`, `:508-514`, `:566-572` typed as
  `Nonempty (Ω ≅ Ω)` with body `⟨Iso.refl _⟩` (trivial reflexive iso
  masquerading as load-bearing piece (i.b) lemmas).
- **Problem 2**: `nonempty_jacobianWitness` carries an inline `:= sorry`
  at `Jacobian.lean:233-236` despite both genus arms now being
  scaffolded (`genusZeroWitness` iter-127, `positiveGenusWitness`
  iter-134).
- **Changes requested**: 5 sub-changes in GrpObj.lean (3 theorem
  refactors + 2 docstring edits) + 4 sub-changes in Jacobian.lean
  (body restructure + 3 docstring edits).

## Changes Made

### File: `AlgebraicJacobian/Cotangent/GrpObj.lean`

#### Change 1.6 — File-header docstring (lines 28-32)

- **What**: De-pinned stale Lean-line anchors (`149` / `198` / `244`)
  by replacing with declaration names (`cotangentSpaceAtIdentity`,
  `cotangentSpaceAtIdentity_eq_extendScalars`,
  `cotangentSpaceAtIdentity_finrank_eq`) suffixed by "below". Reduced
  6 lines → 5 lines.
- **Why**: Prevent future drift; lean-auditor iter-134 flagged the
  stale line numbers (actual lines were 161/210/256).
- **Cascading**: none.

#### Change 1.5 — `schemeHomRingCompatibility` docstring addendum

- **What**: Added a final "**Note**" paragraph clarifying that
  `schemeHomRingCompatibility` is **not** the φ for
  `PresheafOfModules.pullback` (it is the adjunction transpose; the
  correct φ for `PresheafOfModules.pullback` is obtained via
  `(Scheme.Hom.toRingCatSheafHom f).hom`). +6 lines.
- **Why**: Prevent future iters from wiring the wrong compatibility
  morphism into the `PresheafOfModules.pullback` use sites (per the
  iter-135 mathlib-analogist verdict (A) ALIGN_WITH_MATHLIB,
  must-fix-this-iter).
- **Cascading**: none.

#### Change 1.4 — Section docstring at L421-447 (the 27-line
placeholder-apology block)

- **What**: Replaced the 27-line iter-134 "**iter-134 placeholders are
  `Iso`-shaped statements that match the **conclusion form** of the
  intended type ... use the *current available* LHS = RHS (i.e.,
  reflexive isomorphism) as a working placeholder**" block with a
  ~17-line iter-135 honest-scaffold docstring. The new block names
  the three intended sheaf-level RHS targets, points at the
  `(Scheme.Hom.toRingCatSheafHom <morphism>).hom` idiom for the
  compatibility morphisms, and contrasts with the
  `schemeHomRingCompatibility` adjunction transpose.
- **Why**: Iter-135 honest-scaffold pattern (intended type + `sorry`
  body, no excuse-comments).
- **Cascading**: none.

#### Change 1.1 — `relativeDifferentialsPresheaf_basechange_along_proj_two`

- **What**: Refactored from `theorem ... : Nonempty (Ω ≅ Ω) := ⟨Iso.refl _⟩`
  to `noncomputable def ... : Scheme.relativeDifferentialsPresheaf (fst G G).left ≅
  (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
  (Scheme.relativeDifferentialsPresheaf G.hom) := sorry`. New docstring is the
  iter-135 honest-scaffold pattern.
- **Why**: Intended sheaf-level base-change-of-Ω signature (piece (i.b)
  Step 2, load-bearing) per iter-135 mathlib-analogist (B1).
- **Cascading**: none (no downstream consumers yet — piece (i.c)
  `omega_free` is iter-137+ work).

#### Change 1.2 — `relativeDifferentialsPresheaf_restrict_along_identity_section`

- **What**: Refactored from `theorem ... : Nonempty (Ω ≅ Ω) := ⟨Iso.refl _⟩`
  to `noncomputable def ... : (PresheafOfModules.pullback ...).obj
  ((PresheafOfModules.pullback ...).obj (...)) ≅ (PresheafOfModules.pullback
  ...).obj ((PresheafOfModules.pullback ...).obj (...)) := sorry` per
  iter-135 mathlib-analogist (B2).
- **Why**: Intended sheaf-level section-restriction signature (piece (i.b)
  Step 3, ~30–80 LOC closure).
- **Cascading**: none.

#### Change 1.3 — `mulRight_globalises_cotangent`

- **What**: Refactored from `theorem ... : Nonempty (Ω ≅ Ω) := ⟨Iso.refl _⟩`
  to `noncomputable def ... : Scheme.relativeDifferentialsPresheaf G.hom ≅
  (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom G.hom).hom).obj
  ((PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom
  (CategoryTheory.CommaMorphism.left η[G])).hom).obj
  (Scheme.relativeDifferentialsPresheaf G.hom)) := sorry` per iter-135
  mathlib-analogist (B3). New docstring preserves Step 1 / Step 2 /
  Step 3 / Compose outline.
- **Why**: Intended sheaf-level main lemma signature (piece (i.b)
  main lemma).
- **Cascading**: none.

#### Import added

- Added `import Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`
  (required for the `PresheafOfModules.pullback` symbol in the 3
  intended-type signatures; absent from the prior import set since
  the prior placeholder bodies did not use it).

### File: `AlgebraicJacobian/Jacobian.lean`

#### Change 2.1 — `nonempty_jacobianWitness` body restructure

- **What**: Replaced the inline `:= sorry` body with a `by_cases h :
  genus C = 0` decomposition consuming `genusZeroWitness` (genus-0
  arm) and `positiveGenusWitness` (positive-genus arm) via
  `Nat.pos_of_ne_zero`. Signature preserved verbatim.
- **Why**: Convert one inline `sorry` site into honest structural
  decomposition over the two pre-existing scaffolds (per
  `strategy-critic-iter135` Alternative 1).
- **Cascading**: none (signature preserved; `jacobianWitness`
  consumes via `Classical.choice` which only sees
  `Nonempty (JacobianWitness C)`).
- **Note**: The directive's literal Lean snippet was
  `AlgebraicGeometry.genus (k := k) C.left = 0`, but `genus`'s
  argument is `C : Over (Spec (.of k))` (not `C.left : Scheme`);
  used `genus C = 0` (matches the existing `genusZeroWitness`
  binder `(h : genus C = 0)`). Documented in "Notes for Plan Agent"
  below. `Nat.pos_of_ne_zero` resolved as the expected Mathlib name
  (no fallback needed).

#### Change 2.2 — `genusZeroWitness` docstring status update

- **What**: Added the iter-135 status sentence after the existing
  "iter-138+" status line.
- **Why**: Document that `genusZeroWitness` is now consumed by
  `nonempty_jacobianWitness` (Change 2.1).
- **Cascading**: none.

#### Change 2.3 — `positiveGenusWitness` docstring status update

- **What**: Replaced the closing "The scaffold exists to unblock the
  genus-stratified body restructure ..." sentence with the iter-135
  language acknowledging Change 2.1 is now in place and reaffirming
  M3 off-critical-path status.
- **Why**: Reflect post-restructure state.
- **Cascading**: none.

#### Change 2.4 — `nonempty_jacobianWitness` docstring status update

- **What**: Replaced the final "so the existence is assumed and the
  proof is deferred to a future iteration" sentence with the iter-135
  body restructure explanation (`by_cases h : genus C = 0`
  decomposition, both arms `sorry`, structural delegation).
- **Why**: Reflect that the body is now an honest case-split, not an
  unstructured deferred sorry.
- **Cascading**: none.

## New Sorries Introduced

Three honest-scaffold `sorry` bodies replacing the prior 3
weakened-wrong placeholders:

- `AlgebraicJacobian/Cotangent/GrpObj.lean:468` —
  `relativeDifferentialsPresheaf_basechange_along_proj_two` body
  (piece (i.b) Step 2; intended-type sheaf-level base-change iso).
- `AlgebraicJacobian/Cotangent/GrpObj.lean:496` —
  `relativeDifferentialsPresheaf_restrict_along_identity_section` body
  (piece (i.b) Step 3; intended-type sheaf-level section-restriction iso).
- `AlgebraicJacobian/Cotangent/GrpObj.lean:560` —
  `mulRight_globalises_cotangent` body
  (piece (i.b) main lemma; intended-type sheaf-level main iso).

One inline `sorry` removed:

- `AlgebraicJacobian/Jacobian.lean:236` (old line, was inline `:= sorry`
  on `nonempty_jacobianWitness`) — converted to `by_cases` decomposition.

## Compilation Status

`lake build` clean — all 8330 jobs succeed. The build log shows
exactly 6 `declaration uses sorry` warnings on the expected sites:

| File | Line | Declaration |
|------|------|-------------|
| `Jacobian.lean` | 193 | `genusZeroWitness` (pre-existing) |
| `Jacobian.lean` | 219 | `positiveGenusWitness` (pre-existing) |
| `Cotangent/GrpObj.lean` | 468 | `relativeDifferentialsPresheaf_basechange_along_proj_two` (new, replacing iter-134 placeholder) |
| `Cotangent/GrpObj.lean` | 496 | `relativeDifferentialsPresheaf_restrict_along_identity_section` (new, replacing iter-134 placeholder) |
| `Cotangent/GrpObj.lean` | 560 | `mulRight_globalises_cotangent` (new, replacing iter-134 placeholder) |
| `RigidityKbar.lean` | 75 | `rigidity_over_kbar` (pre-existing, unchanged) |

Per-file `lean_diagnostic_messages`:

- `Cotangent/GrpObj.lean`: clean (3 `declaration uses sorry` warnings on
  the 3 new honest-scaffold sites).
- `Jacobian.lean`: clean (2 `declaration uses sorry` warnings on
  `genusZeroWitness` and `positiveGenusWitness`; the prior
  `nonempty_jacobianWitness` inline sorry warning is now gone). One
  pre-existing style warning at line 275 (`Jacobian` definition exceeds
  100 chars) — unchanged, this is a protected signature.

## Axiom Hygiene

`lean_verify` on all four refactor-touched declarations returns the
expected kernel + sorry axiom set:

| Declaration | Axioms |
|-------------|--------|
| `relativeDifferentialsPresheaf_basechange_along_proj_two` | `{propext, sorryAx, Classical.choice, Quot.sound}` |
| `relativeDifferentialsPresheaf_restrict_along_identity_section` | `{propext, sorryAx, Classical.choice, Quot.sound}` |
| `mulRight_globalises_cotangent` | `{propext, sorryAx, Classical.choice, Quot.sound}` |
| `nonempty_jacobianWitness` | `{propext, sorryAx, Classical.choice, Quot.sound}` |

No new axioms introduced. The 3 `opaque` source-scan warnings on
`GrpObj.lean` lines 50/53/204 are unrelated docstring text inside
the `cotangentSpaceAtIdentity` block (mentions of "opaque" in
discussion of the iter-131 body refactor) — not actual `opaque`
declarations.

## Sorry Landscape After Iter-135 Refactor

- `AlgebraicJacobian/Jacobian.lean`: 3 → 2 sorries
  (`genusZeroWitness` body, `positiveGenusWitness` body; the
  `nonempty_jacobianWitness` inline-sorry GONE, replaced by `by_cases`).
- `AlgebraicJacobian/Cotangent/GrpObj.lean`: 0 → 3 sorries
  (the 3 iter-134 placeholders refactored from
  `:= ⟨Iso.refl _⟩` to honest intended-type signatures + `:= sorry`
  bodies).
- `AlgebraicJacobian/RigidityKbar.lean`: 1 → 1 (unchanged).
- **Project total**: 4 → 6 declaration-sorry sites.

**Note on directive arithmetic**: the directive's "Expected Outcome"
section said "Project total: 4 → 5 (NET +1)", but the per-file deltas
in the same section sum to 2+3+1 = 6, not 5. The actual post-state
is 6, which matches the per-file accounting (`Jacobian.lean: 3 → 2`,
`Cotangent/GrpObj.lean: 0 → 3`, `RigidityKbar.lean: 1 → 1`). This is
a minor arithmetic typo in the directive that does not change the
qualitative outcome: 3 of the 6 are now honest intended-type scaffolds
replacing 3 iter-134 weakened-wrong placeholders that `sorry_analyzer`
could not see, and the `nonempty_jacobianWitness` inline-sorry site is
replaced by structural decomposition. The semantic health of the sorry
landscape is materially improved even though the count went up.

## LOC Delta Per File

- `AlgebraicJacobian/Cotangent/GrpObj.lean`: 575 → 573 (net −2).
  Sub-deltas: header docstring −1, schemeHomRingCompatibility
  addendum +6, section docstring at L421 −10, three theorem
  refactors ≈ −5 (placeholder docstrings shrunk despite intended-type
  signatures expanding), imports +1, plus minor whitespace.
- `AlgebraicJacobian/Jacobian.lean`: 284 → 301 (net +17). Sub-deltas:
  genusZeroWitness docstring +5, positiveGenusWitness docstring +1,
  nonempty_jacobianWitness docstring +5 (replaced 1 sentence with 6
  lines), nonempty_jacobianWitness body +3 (replaced `:= sorry` with
  4-line `by_cases` block); rounding and minor shaping account for
  the rest.

## Spot-Check: Section Docstring at L421

The new section docstring at lines 421–440 reads (in full):

```
/-! ### Helper sub-lemmas and main lemma of piece (i.b)

The three declarations below state the intended sheaf-level RHS
signatures for piece (i.b)'s closure chain (Step 2 base-change of
differentials, Step 3 section restriction, Compose main lemma).
Bodies are `sorry` — closure is iter-136+ work per
`blueprint/src/chapters/RigidityKbar.tex` § Piece (i.b) +
`analogies/mulright-globalises-cotangent.md` +
`analogies/phi-compatibility-morphisms.md` (iter-135 mathlib-analogist
on the `PresheafOfModules.pullback` compatibility-morphism shape).

The compatibility morphisms for `PresheafOfModules.pullback` are
obtained inline as `(Scheme.Hom.toRingCatSheafHom <morphism>).hom`,
the canonical Mathlib helper at
`Mathlib.AlgebraicGeometry.Modules.Presheaf`. This is structurally
different from `schemeHomRingCompatibility` above (which is the
adjunction transpose used by `relativeDifferentialsPresheaf` — see
that declaration's docstring).
-/
```

That is the iter-135 honest-scaffold pattern (~17 lines instead of
the iter-134 27-line placeholder-apology block).

## Deviations from Directive

1. **Directive's `genus C.left` snippet → corrected to `genus C`**.
   The directive's literal Lean snippet for Change 2.1 was
   `AlgebraicGeometry.genus (k := k) C.left = 0`. However,
   `AlgebraicGeometry.genus` takes `C : Over (Spec (.of k))`, not
   `C.left : Scheme` (cf. `AlgebraicJacobian/Genus.lean:40`). This
   was first surfaced by an `Application type mismatch` diagnostic
   ("`C.left` has type `Scheme` but is expected to have type
   `Over (Spec (CommRingCat.of k))`"). I corrected the call to
   `genus C` (matching the existing `genusZeroWitness` binder
   `(h : genus C = 0)`).

2. **Directive's `Project total: 4 → 5` was 4 → 6 actual**. See "Note
   on directive arithmetic" above. The per-file deltas in the
   directive are correct and were achieved verbatim; the project total
   line in the directive was an arithmetic typo.

3. **No need for `Nonempty` wrapper fallback or `theorem` keyword
   fallback**. The directive cautioned that if `noncomputable def
   ... := sorry` with the `Iso`-valued return type produced trouble,
   I should fall back to `theorem` + `Nonempty (...)`. The intended
   types elaborate cleanly with `noncomputable def`, matching the
   analogist's (D) elaboration sanity check, and no fallback was
   needed.

## Notes for Plan Agent

- **Confirmed**: the iter-135 mathlib-analogist's (B1)/(B2)/(B3)
  intended-type signatures elaborated cleanly against the current
  project state without any type-ascription massaging. The only
  required mechanical adjustment was adding the import
  `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback` to
  `Cotangent/GrpObj.lean` (the prior placeholder bodies did not use
  `PresheafOfModules.pullback`, so the import was missing).

- **`schemeHomRingCompatibility` retention**: kept in place per
  directive Change 1.5; the new docstring addendum prevents future
  confusion with the `PresheafOfModules.pullback`-side
  `Scheme.Hom.toRingCatSheafHom` idiom.

- **`AbelJacobi.lean` cascading**: none. The downstream consumer of
  `nonempty_jacobianWitness` is `jacobianWitness` (via
  `Classical.choice` on `Nonempty (JacobianWitness C)`); the
  signature is preserved verbatim and the build is clean across
  `AbelJacobi.lean`, `Rigidity.lean`, `RigidityKbar.lean`, and the
  top-level `AlgebraicJacobian.lean` aggregator.

- **Stale in-docstring line refs remain**: there are still stale
  "line 244 below" / "line 198 below" references inside the docstring
  of `cotangentSpaceAtIdentity` (at lines 106-108, 145-147, 154-156,
  158-160 of the new file). Change 1.6 in the directive only specified
  the file-header docstring (L28-32), so I did not touch these. If the
  plan agent wants those de-pinned too, that's a small follow-up
  refactor for iter-136. They are not actionable bugs (Lean does not
  care about docstring text), only documentation drift.

- **No protected declarations were touched**. `nonempty_jacobianWitness`
  is not in `archon-protected.yaml`; its signature was preserved
  verbatim per the iter-135 plan-agent pre-commitment.
