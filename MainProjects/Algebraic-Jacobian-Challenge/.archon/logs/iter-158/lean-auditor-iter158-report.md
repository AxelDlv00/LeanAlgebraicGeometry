# Lean Audit Report

## Slug
iter158

## Iteration
158

## Scope
- files audited: 3 (per directive)
- files skipped (per directive): 0
- Note: the directive narrowed scope to the three named files. I did not sweep the
  whole tree this iteration; if a full-tree sweep is wanted, re-dispatch with
  Scope=all. The three audited files import only `AlgebraicJacobian.Genus`.

## Focus-area findings (directive items 1–4)

### 1. Is `_hf` genuinely consumed in `rigidity_eqOn_dense_open`, or laundered?

**GENUINELY CONSUMED — the prior "dropped `_hf`" defect is FIXED.**

Trace in `AbelianVarietyRigidity.lean`:
- Line 161: `_hf` is fed to `congrArg Over.Hom.left _hf` to produce
  `hcomp : s ≫ f.left = (toUnit X ≫ z₀).left`.
- Lines 162–166: `hcomp` proves `hfx : f.left.base (s.base x) = z₀pt`, which proves
  `hy₀ : y₀pt ∉ Gset` (lines 156–166).
- Lines 168–176: `hy₀` is the witness that `s.base x₀pt ∈ Gsetᶜ`, i.e. the
  non-emptiness of the open `U`. Without `_hf` this branch is unprovable for
  arbitrary `f` (the docstring's own `f := fst` counterexample, line 102).

So `_hf` is threaded into a non-`sorry` part of the proof and is required for it to
typecheck. It is also threaded correctly up the stack: `rigidity_core` passes it on
(line 261), `rigidity_lemma` passes it to `rigidity_core` (line 341). No laundering.

### 2. Are the two internal `sorry`s honest gaps, or false/unsatisfiable?

Both are **honest TRUE gaps**, neither is false or unsatisfiable under the hypotheses.

- `hfib` (line 154): `(snd X Y).left.base ⁻¹' {y₀pt} ⊆ Set.range s.base` — "the
  topological fibre of the projection over the `k̄`-rational point `y₀pt` is covered
  by the section `s`." TRUE: `y₀` is a rational point (`𝟙_ ⟶ Y`, residue field the
  base field), so the scheme fibre is `X ×_{k̄} k̄ ≅ X` and `s` parametrises it. The
  reverse inclusion (`range s.base ⊆ fibre`) already holds via `s ≫ snd = toUnit ≫ y₀`;
  this is the surjectivity direction. Honest fibre-topology gap; the inline comment
  (lines 150–153) describes it accurately.
- Final agreement (line 181): `U.ι ≫ f.left = U.ι ≫ (retract ≫ f).left` on the
  constructed `U = snd⁻¹(Y ∖ G)`. This is the genuine geometric heart of Mumford's
  Rigidity Lemma (each proper slice `X × {y}`, `y ∈ V`, maps into the affine `U₀`,
  hence to one point; reducedness of `(X⊗Y).left` + separatedness of `Z` lift the
  pointwise equality to a scheme-morphism equality). All hypotheses Mumford needs
  (`IsProper X.hom`, `GeometricallyIrreducible (X⊗Y).hom`, `IsReduced (X⊗Y).left`,
  `IsSeparated Z.hom`) are in scope. TRUE for the `U` actually constructed — not a
  dead-end.

### 3. Is `snd_left_isClosedMap` honest and complete?

**YES — complete, no `sorry`, no error.** Diagnostics report no warning at line 83.
The proof (lines 86–91) is sound: `IsProper.toUniversallyClosed` →
`universallyClosed_isStableUnderBaseChange.of_isPullback` on
`IsPullback.of_hasPullback X.hom Y.hom` (after rewriting `(snd X Y).left` to the
pullback projection via `Over.snd_left`) → `Scheme.Hom.isClosedMap`. The docstring
(lines 71–82) matches the proof faithfully.

### 4. Stale / misleading docstrings

See Major/Minor blocks. The principal stale claim: `rigidity_core`'s docstring still
calls BOTH Mathlib bridges "still to be built", but bridge 1 was completed this iter
as `snd_left_isClosedMap`.

## Per-file checklist

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none (the 4 `sorry`-bearing decls are honest gaps)
- **bad practices**: 1 minor (underscore-named hypothesis `_hf` is actually used)
- **excuse-comments**: none
- **notes**:
  - `_hf` genuinely consumed in `rigidity_eqOn_dense_open` (lines 156–176); prior
    laundering defect fixed.
  - `snd_left_isClosedMap` (line 83) complete and sound, no `sorry`.
  - `rigidity_snd_lift` (64), `rigidity_core` (243), `rigidity_lemma` (324) all
    compile sorry-free (confirmed by diagnostics — no sorry warning on these lines).
  - 4 honest `sorry`s remain: line 111 (`rigidity_eqOn_dense_open`, containing two
    internal gaps at 154/181), 357 (`morphism_P1_to_grpScheme_const`, deferred to
    theorem of the cube), 381 (`genusZero_curve_iso_P1`, deferred to Riemann–Roch),
    406 (`rigidity_genus0_curve_to_grpScheme`, headline scaffold). All carry
    `Status`/`SCAFFOLD` comments naming the deferred deep input — documented honest
    gaps, not excuse-comments.
  - STALE: `rigidity_core` docstring (lines 213–242) says "two Mathlib bridges still
    to be built" / "the obstruction is assembly" — bridge 1 (closed map) is now
    BUILT as `snd_left_isClosedMap`. (Major.)
  - STALE: module docstring (lines 21–22) says the four-link chain is "all scaffolded
    here as `sorry`" — link 1 `rigidity_lemma` is now proven modulo the helper.
    (Major.)
  - `rigidity_eqOn_dense_open` docstring overclaims slightly: "the two char-free
    Mathlib bridges ... are discharged" (line 106) — bridge 2 is still the `sorry` at
    181; "the sole remaining `sorry`" (line 110) is now two internal sorries. (Minor.)

### AlgebraicJacobian/Jacobian.lean (unchanged this iter)
- **outdated comments**: none material
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 2 honest `sorry`s: `genusZeroWitness.isAlbaneseFor.key` (line 265) and
    `positiveGenusWitness` (line 303). Both heavily documented with the precise
    out-of-file blockers (import cycle, char-`p` gap, missing base-change functor /
    M3 infrastructure). Honest gaps.
  - Consumer note (informational, not a defect): the new `AbelianVarietyRigidity.lean`
    header claims `genusZeroWitness` "can consume the genus-`0` rigidity keystone
    directly," but Jacobian.lean does NOT yet import it and `key` is still `sorry`.
    The two files are siblings (both import only `Genus`), so the wiring is now
    *possible* but not *done*. Not a fault of the audited file; flag for the planner.

### AlgebraicJacobian/RigidityKbar.lean (unchanged this iter)
- **outdated comments**: none material
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 1 honest `sorry`: `rigidity_over_kbar` (line 88), the fallback route (a) artifact,
    carries `[CharZero kbar]` and is documented as gated on the cotangent-vanishing
    pile. Honest scaffold gap.

## Must-fix-this-iter

None. No excuse-comments, no weakened-wrong definitions, no parallel-API copies, no
suspect bodies on substantive claims (`:= sorry` sites are all honest, documented
gaps), no unauthorized axioms. Crucially, the previously-flagged `_hf`-dropping
unsoundness in the `rigidity_eqOn_dense_open` / `rigidity_core` / `rigidity_lemma`
stack is resolved: `_hf` is genuinely consumed.

## Major

- `AbelianVarietyRigidity.lean:213-242` — `rigidity_core` docstring describes "two
  Mathlib bridges still to be built (the cube-free heart)" and "the obstruction is
  assembly," but bridge 1 ("Properness ⇒ the projection is a closed map") was
  completed THIS iter as `snd_left_isClosedMap` (line 83). The docstring now
  misrepresents project state and could lead a future prover to re-build an
  already-proven bridge. Update to reflect that only bridge 2 (affine-constancy)
  remains.
- `AbelianVarietyRigidity.lean:21-22` — module docstring says the four-link chain is
  "all scaffolded here as `sorry`." Link 1 (`rigidity_lemma`) is now proven modulo
  the helper `rigidity_eqOn_dense_open` (no `sorry` on it per diagnostics). Stale
  status claim.

## Minor

- `AbelianVarietyRigidity.lean:106` — `rigidity_eqOn_dense_open` docstring states "the
  two char-free Mathlib bridges ... are discharged"; bridge 2 (affine-constancy) is
  still the `sorry` at line 181, so only bridge 1 is discharged here.
- `AbelianVarietyRigidity.lean:110` — same docstring calls this "the sole remaining
  `sorry`"; the lemma now contains two internal `sorry`s (lines 154 `hfib`, 181
  agreement). The intent ("sole remaining sorry-bearing lemma of the chain") is
  defensible but the wording undercounts.
- `AbelianVarietyRigidity.lean:121,253,334` — the hypothesis is named `_hf` (leading
  underscore conventionally signals "intentionally unused") yet it is used in every
  proof in the stack. Consider renaming to `hf` for honesty; harmless but mildly
  misleading.

## Excuse-comments (always called out separately)

None found. The `sorry`s in all three files are accompanied by precise mathematical
justifications and named deferred inputs (theorem of the cube, Riemann–Roch, the
affine-constancy bridge, the cotangent-vanishing pile), not "temporary / will-fix /
placeholder" admissions.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (both stale docstrings in `AbelianVarietyRigidity.lean` that misstate
  which bridge/link is already proven)
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: The iter-158 edits are SOUND — `_hf` is genuinely consumed (prior
unsoundness fixed), `snd_left_isClosedMap` is complete, both remaining internal
`sorry`s are honest true gaps; the only issues are two stale docstrings that now
overstate how much of the rigidity chain is still unbuilt.
