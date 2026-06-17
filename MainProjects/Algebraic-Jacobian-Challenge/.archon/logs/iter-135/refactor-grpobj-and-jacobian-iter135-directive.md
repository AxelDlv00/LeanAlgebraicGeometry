# Refactor Directive — iter-135

## Slug

grpobj-and-jacobian-iter135

## Problem

Two structural issues across two Lean files:

### Problem 1 — `AlgebraicJacobian/Cotangent/GrpObj.lean`: 3 weakened-wrong-definition placeholders

The iter-134 prover lane added 3 theorems whose declared types do not
match the names. Both iter-134 review-phase audits classified this as
**must-fix-this-iter** under the strict rubric (weakened-wrong-definition
+ signature mismatch + excuse-comment pattern on load-bearing
declarations):

- `lean-auditor-review134`: 3 critical-severity excuse-comments at L473–475,
  L504–507, L561–565; 3 must-fix at L476–482, L508–514, L566–572.
- `lean-vs-blueprint-checker-cotangent-grpobj-review134`: 3 strict-rubric
  must-fix + 1 major + 2 minor.

The 3 placeholder theorems are at:

- `Cotangent/GrpObj.lean:476-482` — `relativeDifferentialsPresheaf_basechange_along_proj_two`
- `Cotangent/GrpObj.lean:508-514` — `relativeDifferentialsPresheaf_restrict_along_identity_section`
- `Cotangent/GrpObj.lean:566-572` — `mulRight_globalises_cotangent`

Each is declared with body `⟨Iso.refl _⟩` typed as
`Nonempty (Scheme.relativeDifferentialsPresheaf G.hom ≅
Scheme.relativeDifferentialsPresheaf G.hom)` — a structurally trivial
reflexive iso wrapped in `Nonempty`. The intended sheaf-level RHS using
`PresheafOfModules.pullback` lives only in docstrings.

### Problem 2 — `AlgebraicJacobian/Jacobian.lean`: `nonempty_jacobianWitness` inline-sorry body

`nonempty_jacobianWitness` at `Jacobian.lean:233-236` carries an
inline `:= sorry` body. Both genus arms are now scaffolded:

- `genusZeroWitness C (h : genus C = 0)` at `Jacobian.lean:188-192` (iter-127)
- `positiveGenusWitness C (hg : 0 < genus C)` at `Jacobian.lean:211-215` (iter-134)

Per `strategy-critic-iter135` Alternative 1 (`task_results/strategy-critic-iter135.md`
§ "Alternative 1"), the body of `nonempty_jacobianWitness` should now
be restructured via `by_cases h : genus C = 0` to call the two scaffolds.
This converts one inline `sorry` site into a structural decomposition
of two pre-existing scaffolds (whose bodies remain `sorry`), reducing
project sorry count 4 → 3 without closing any sorry independently and
without modifying any protected signature.

## Mathematical Justification

### Justification 1 (Problem 1, the placeholder refactor)

The iter-135 mathlib-analogist
(`task_results/mathlib-analogist-phi-compatibility-morphisms-iter135.md`,
verdict: **PROCEED-WITH-INTENDED-TYPES-AS-WRITTEN**) verified via
`lean_run_code` that the intended sheaf-level RHS signatures **elaborate
cleanly** against current Mathlib using Mathlib's canonical helper
`Scheme.Hom.toRingCatSheafHom`
(`Mathlib/AlgebraicGeometry/Modules/Presheaf.lean:42–45`):

```
def Hom.toRingCatSheafHom (f : X ⟶ Y) :
    Y.ringCatSheaf ⟶ ((TopologicalSpace.Opens.map f.base).sheafPushforwardContinuous
      _ _ _).obj X.ringCatSheaf where
  hom := Functor.whiskerRight f.c _
```

`(Scheme.Hom.toRingCatSheafHom f).hom` (the `.hom` field unwraps the
`InducedCategory.Hom` of a `TopCat.Sheaf`) is exactly the
`φ : S ⟶ F.op ⋙ R` shape that `PresheafOfModules.pullback` consumes
(`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean:38–45`).

**Critical: do NOT use `schemeHomRingCompatibility`** (at
`Cotangent/GrpObj.lean:417–419`) here — that helper is the *adjunction
transpose* (a morphism of presheaves on X, not on Y), the correct shape
for `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`
which is what `relativeDifferentialsPresheaf` consumes, but **the wrong
shape** for `PresheafOfModules.pullback`. Keep
`schemeHomRingCompatibility` in place for its existing
`relativeDifferentialsPresheaf` consumer, but DO NOT propagate it to
the new use sites.

### Justification 2 (Problem 2, the body restructure)

`genus C : ℕ` is decidable-equality (`DecidableEq ℕ`), so
`by_cases h : genus C = 0` is well-formed in Lean. The two arms cover
the disjunction:
- `genus C = 0` → use `genusZeroWitness C h`
- `¬ (genus C = 0)` → `0 < genus C` via `Nat.pos_of_ne_zero h`; use
  `positiveGenusWitness C (Nat.pos_of_ne_zero h)`

The restructure does not modify any protected signature
(`nonempty_jacobianWitness` is NOT in `archon-protected.yaml` —
verified iter-135 directly; the 5 protected declarations in
`Jacobian.lean` are `Jacobian`, `instGrpObj`,
`smoothOfRelativeDimension_genus`, `instIsProper`,
`instGeometricallyIrreducible`). Both arms' bodies remain `sorry` as
honest scaffolds.

## Changes Requested

### File: `AlgebraicJacobian/Cotangent/GrpObj.lean`

#### Change 1.1 — `relativeDifferentialsPresheaf_basechange_along_proj_two`

- **Old (lines 449–482)**: The docstring at 449–475 + the placeholder
  theorem at 476–482 typed `Nonempty (Scheme.relativeDifferentialsPresheaf G.hom ≅
  Scheme.relativeDifferentialsPresheaf G.hom)` with body `⟨Iso.refl _⟩`.

- **New**: Rewrite the docstring to reflect the iter-135 honest-scaffold
  pattern (remove "**Iter-134 placeholder**" stanza; replace with
  "**Iter-135 honest scaffold**: signature is the intended sheaf-level
  base-change iso; body is `sorry`. Closure target: chain
  `KaehlerDifferential.tensorKaehlerEquiv` + the sheaf-side
  `PresheafOfModules.pullback` per `analogies/mulright-globalises-cotangent.md`
  Decision 2; ~150–300 LOC; load-bearing piece (i.b) Step 2."). Then
  declare the theorem with the **intended type** (per the iter-135
  analogist's literal Lean text, `task_results/mathlib-analogist-phi-compatibility-morphisms-iter135.md`
  § (B1)):

  ```lean
  noncomputable def relativeDifferentialsPresheaf_basechange_along_proj_two
      (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
      {n : ℕ} [SmoothOfRelativeDimension n G.hom]
      [IsProper G.hom] [GeometricallyIrreducible G.hom] :
      Scheme.relativeDifferentialsPresheaf (fst G G).left ≅
        (PresheafOfModules.pullback
            (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
          (Scheme.relativeDifferentialsPresheaf G.hom) :=
    sorry
  ```

  Notes:
  - Drop the `Nonempty (...)` wrapper. The iter-135 analogist
    (informational note) authorises this: "the closure is by construction
    a concrete iso, not an existential." The keyword `noncomputable def`
    (returning the iso directly) matches the `positiveGenusWitness`
    honest-scaffold pattern. **Use `noncomputable def`, not `theorem`,
    because the return type is `Iso` (Type-valued), not `Prop`.**
  - The instance binders `[CategoryTheory.GrpObj G]
    {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom]
    [GeometricallyIrreducible G.hom]` are preserved verbatim from the
    iter-134 placeholder (even if some are not currently load-bearing
    for the signature, they pin the consumer class precisely).
  - If `noncomputable def` with body `:= sorry` produces a compile
    warning about unused binders (the iter-134 audit flagged this
    minor), that is acceptable — the iter-136+ body closure will use
    them. If Lean rejects unused binders at `def` level (it shouldn't
    for `noncomputable`), fall back to `theorem` keyword with
    `Nonempty (...)` wrapper, but mark this in your task result.

#### Change 1.2 — `relativeDifferentialsPresheaf_restrict_along_identity_section`

- **Old (lines 484–514)**: docstring + placeholder theorem.

- **New**: same shape as Change 1.1. Rewrite docstring per iter-135
  honest-scaffold pattern (closure target: `PresheafOfModules.pullbackComp`
  + `PresheafOfModules.pullbackId` on `pr_2 ∘ s = η_G ∘ π_G`; ~30–80 LOC).
  Declare with intended type per analogist § (B2):

  ```lean
  noncomputable def relativeDifferentialsPresheaf_restrict_along_identity_section
      (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
      {n : ℕ} [SmoothOfRelativeDimension n G.hom]
      [IsProper G.hom] [GeometricallyIrreducible G.hom] :
      (PresheafOfModules.pullback
            (Scheme.Hom.toRingCatSheafHom
              (lift (𝟙 G) (toUnit G ≫ η[G])).left).hom).obj
          ((PresheafOfModules.pullback
              (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj
            (Scheme.relativeDifferentialsPresheaf G.hom)) ≅
        (PresheafOfModules.pullback
            (Scheme.Hom.toRingCatSheafHom G.hom).hom).obj
          ((PresheafOfModules.pullback
              (Scheme.Hom.toRingCatSheafHom
                (CategoryTheory.CommaMorphism.left η[G])).hom).obj
            (Scheme.relativeDifferentialsPresheaf G.hom)) :=
    sorry
  ```

#### Change 1.3 — `mulRight_globalises_cotangent`

- **Old (lines 516–572)**: docstring + placeholder main lemma.

- **New**: same shape. Rewrite docstring per iter-135 honest-scaffold
  pattern (preserve the Step 1 / Step 2 / Step 3 / Compose proof
  outline; remove "**Iter-134 placeholder**" stanza). Declare with
  intended type per analogist § (B3):

  ```lean
  noncomputable def mulRight_globalises_cotangent
      (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G]
      {n : ℕ} [SmoothOfRelativeDimension n G.hom]
      [IsProper G.hom] [GeometricallyIrreducible G.hom] :
      Scheme.relativeDifferentialsPresheaf G.hom ≅
        (PresheafOfModules.pullback
            (Scheme.Hom.toRingCatSheafHom G.hom).hom).obj
          ((PresheafOfModules.pullback
              (Scheme.Hom.toRingCatSheafHom
                (CategoryTheory.CommaMorphism.left η[G])).hom).obj
            (Scheme.relativeDifferentialsPresheaf G.hom)) :=
    sorry
  ```

#### Change 1.4 — section-introduction docstring at L421–447

- **Old**: the multi-paragraph block at lines 421–447 framing the 3
  declarations below as "placeholders pending the multi-iter piece (i.b)
  lane closure".

- **New**: replace with a much shorter section docstring (~10 lines)
  reflecting the iter-135 honest-scaffold pattern:

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
  that declaration's docstring). -/
  ```

#### Change 1.5 — `schemeHomRingCompatibility` docstring sentence

- **Old (lines 407–416)**: docstring of `schemeHomRingCompatibility`
  at line 417.

- **New**: ADD a final sentence to the docstring clarifying:
  "**Note**: this is **not** the φ for `PresheafOfModules.pullback`,
  which expects a morphism of presheaves on the *codomain* `Y`
  (`Y.ringCatSheaf ⟶ (Opens.map f.base).op ⋙ X.ringCatSheaf`) and is
  obtained via `(Scheme.Hom.toRingCatSheafHom f).hom`. The two
  conventions serve distinct downstream consumers."

#### Change 1.6 — stale Lean-line anchors in the file-header docstring

- **Old (lines 28, 30, 31–32)**: cites lines `149` / `198` / `244` for
  `cotangentSpaceAtIdentity` / `cotangentSpaceAtIdentity_eq_extendScalars`
  / `cotangentSpaceAtIdentity_finrank_eq`.

- **New**: update to the actual lines `161` / `210` / `256` (verified
  iter-134 lean-auditor). Equivalently, **de-pin the line numbers**
  by replacing with the declaration names only (e.g. "the definition
  `cotangentSpaceAtIdentity` below, the structural-shape acceptance
  lemma `cotangentSpaceAtIdentity_eq_extendScalars` below, and the
  companion rank lemma `cotangentSpaceAtIdentity_finrank_eq` below
  (rank = relative dimension `n` from
  `[SmoothOfRelativeDimension n G.hom]`, closed iter-132)").
  De-pinning prevents future drift.

### File: `AlgebraicJacobian/Jacobian.lean`

#### Change 2.1 — `nonempty_jacobianWitness` body restructure

- **Old (lines 233–236)**:

  ```lean
  theorem nonempty_jacobianWitness (C : Over (Spec (.of k)))
      [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
      Nonempty (JacobianWitness C) :=
    sorry
  ```

- **New**: replace the body with the `by_cases` decomposition,
  preserving the signature verbatim:

  ```lean
  theorem nonempty_jacobianWitness (C : Over (Spec (.of k)))
      [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] :
      Nonempty (JacobianWitness C) := by
    by_cases h : AlgebraicGeometry.genus (k := k) C.left = 0
    · exact ⟨genusZeroWitness C h⟩
    · exact ⟨positiveGenusWitness C (Nat.pos_of_ne_zero h)⟩
  ```

  Notes:
  - This converts the inline `sorry` into a `by_cases` decomposition
    that consumes the two pre-existing scaffolds. Both scaffolds still
    have `sorry` bodies; the restructure only re-routes the witness
    extraction.
  - **Signature is preserved verbatim** — `nonempty_jacobianWitness` is
    NOT in `archon-protected.yaml`, but the iter-135 plan-agent
    pre-commitment is to preserve the signature anyway since downstream
    `jacobianWitness` (line 241–244) consumes it.
  - **Expected sorry count delta**: per-file `Jacobian.lean` 3 → 2
    (the inline `sorry` on `nonempty_jacobianWitness` body is replaced
    by the `by_cases` decomposition). Project sorry count 4 → 3.
  - If `Nat.pos_of_ne_zero` is the wrong name, alternatives include
    `Nat.zero_lt_of_ne_zero` (less idiomatic) or `Nat.pos_iff_ne_zero.mpr`
    or `(Nat.pos_iff_ne_zero).mpr h`. `Nat.pos_of_ne_zero h` is the
    expected Mathlib name — please verify via `lean_local_search` or
    `lean_leansearch` before committing the exact spelling. If absent,
    fall back to `Nat.pos_of_ne_zero (h : genus C ≠ 0) : 0 < genus C`
    via Mathlib's `Nat.pos_of_ne_zero` (which exists).

#### Change 2.2 — `genusZeroWitness` docstring status update

- **Old (lines 186-187)**: "The body closure is iter-138+ work, after
  pieces (i)+(ii)+(iii) of the shared cotangent-vanishing pile land."

- **New**: ADD a sentence at the end of the docstring:
  "**Iter-135**: now consumed by the genus-stratified body of
  `nonempty_jacobianWitness` (Change 2.1 of iter-135 refactor); body
  closure remains iter-138+ work but the witness is now
  load-bearing for the protected `nonempty_jacobianWitness` chain."

#### Change 2.3 — `positiveGenusWitness` docstring status update

- **Old (lines 208–210)**: "The scaffold exists to unblock the
  genus-stratified body restructure of `nonempty_jacobianWitness`
  (the `by_cases h : genus C = 0` decomposition needs both arms
  scaffolded; `genusZeroWitness` is in place since iter-127)."

- **New**: REPLACE that sentence with:
  "**Iter-135**: the genus-stratified body restructure of
  `nonempty_jacobianWitness` is now in place (Change 2.1 of iter-135
  refactor); this scaffold is the positive-genus arm. Body closure
  remains M3 work (off-critical-path; user-escalation-pending per
  `analogies/m3-route-audit.md`)."

#### Change 2.4 — `nonempty_jacobianWitness` docstring status update

- **Old (lines 217–232)**: docstring framing the body as "deferred to a
  future iteration".

- **New**: REPLACE the final sentence with:
  "**Iter-135 body restructure**: the body is now a `by_cases h :
  genus C = 0` decomposition consuming `genusZeroWitness` (genus-0
  arm) and `positiveGenusWitness` (positive-genus arm). Both arms'
  bodies remain `sorry` (M2.b body closure iter-138+; M3 body closure
  off-critical-path); the restructure converts the inline `sorry`
  here into honest delegation to the two scaffolds, removing one
  inline-`sorry` site without prejudging either arm's body closure."

## Affected Files

- `AlgebraicJacobian/Cotangent/GrpObj.lean` — primary changes (5 sub-
  changes in Problem 1).
- `AlgebraicJacobian/Jacobian.lean` — primary changes (4 sub-changes in
  Problem 2).

No cascading breakage expected:

- The 3 placeholder theorems are not referenced anywhere downstream
  (they are iter-134 new declarations; piece (i.c) `omega_free` is
  iter-137+ work and the only intended consumer).
- The `nonempty_jacobianWitness` signature is preserved verbatim;
  `jacobianWitness` (line 241–244 of `Jacobian.lean`) consumes via
  `Classical.choice` which only sees `Nonempty (JacobianWitness C)`,
  unchanged.

Run `lean_diagnostic_messages` on both files after the edits to confirm
clean compilation (only the expected `declaration uses sorry` warnings
on `genusZeroWitness` / `positiveGenusWitness` /
`relativeDifferentialsPresheaf_basechange_along_proj_two` /
`relativeDifferentialsPresheaf_restrict_along_identity_section` /
`mulRight_globalises_cotangent`).

## Expected Outcome

### Sorry landscape after iter-135 refactor

- `AlgebraicJacobian/Jacobian.lean`: 3 → 2 sorries
  (`genusZeroWitness` body, `positiveGenusWitness` body; the
  `nonempty_jacobianWitness` inline-sorry GONE, replaced by `by_cases`).
- `AlgebraicJacobian/Cotangent/GrpObj.lean`: 0 → 3 sorries
  (the 3 iter-134 placeholders refactored from
  `:= ⟨Iso.refl _⟩` to honest intended-type signatures + `:= sorry`
  bodies).
- `AlgebraicJacobian/RigidityKbar.lean`: 1 → 1 (unchanged;
  `rigidity_over_kbar` body).
- **Project total**: 4 → 5 (NET +1; but **3 of the 5 are honest
  intended-type scaffolds replacing 3 iter-134 weakened-wrong
  placeholders that were not visible to `sorry_analyzer`**, and 1
  inline-sorry on `nonempty_jacobianWitness` is replaced by structural
  decomposition into the two pre-existing scaffolds). The semantic
  health of the sorry landscape is materially improved even though
  the count went up.

### Type-elaboration sanity check

The 3 intended-type signatures elaborate cleanly per the iter-135
mathlib-analogist's `lean_run_code` verification
(`task_results/mathlib-analogist-phi-compatibility-morphisms-iter135.md`
§ (D)). If your `lean_diagnostic_messages` returns elaboration errors
on any of the 3, that is a discrepancy with the analogist — STOP the
refactor and write a "discrepancy" section in your task result naming
the error verbatim. Do not invent type ascriptions to silence errors.

### Axiom hygiene

After the refactor, `lean_verify` on each of the 3 refactored
declarations should return `{propext, Classical.choice, Quot.sound,
sorryAx}` (kernel + sorry, no new axioms). `lean_verify` on
`nonempty_jacobianWitness` should return `{propext, Classical.choice,
Quot.sound, sorryAx}` (sorry transmitted through the two scaffold
bodies).

### Blueprint coordination

The blueprint side (cleanup writer pass, dispatched in parallel as
`blueprint-writer-cleanup-bundle-iter135`) handles `RigidityKbar.tex`
NOTE-block updates + `Jacobian.tex` `\lean{positiveGenusWitness}`
addition + 3 broken `\ref`s in MV chapter + ModuleK label-prefix
asymmetry + orphan-file decision. Do NOT touch any blueprint chapter
yourself.

### Hard constraints

- MUST NOT modify any protected declaration's signature (read
  `archon-protected.yaml`).
- MUST NOT introduce any new axiom declarations.
- MUST keep `cotangentSpaceAtIdentity` body unchanged (META-PATTERN
  TRIPWIRE iter-132 non-promise binds).
- MUST keep `shearMulRight`, `shearMulRight_hom_fst`,
  `shearMulRight_hom_snd`, `schemeHomRingCompatibility` declarations
  unchanged (only Change 1.5 adds a sentence to `schemeHomRingCompatibility`'s
  docstring).
- MUST keep `cotangentSpaceAtIdentity_eq_extendScalars` and
  `cotangentSpaceAtIdentity_finrank_eq` bodies unchanged (piece (i.a)
  DONE iter-132).

### Task result

Write to `.archon/task_results/refactor-grpobj-and-jacobian-iter135.md`.
Report:

- The new sorry landscape (per-file + project totals).
- `lean_verify` axiom output for the 3 refactored placeholders + the
  restructured `nonempty_jacobianWitness`.
- `lean_diagnostic_messages` output for both files (must be clean
  except for `declaration uses sorry` warnings on the 5 expected
  sites: 2 in Jacobian.lean + 3 in Cotangent/GrpObj.lean).
- LOC delta per file.
- Any deviations from the directive (e.g. if the `Nat.pos_of_ne_zero`
  lemma name is wrong and you used a fallback, or if `noncomputable def`
  with `sorry` body requires the `Nonempty (...)` wrapper).
- Spot-check that the section docstring at L421 (Change 1.4) is now
  a clean ~10-line summary, not the 26-line iter-134 placeholder-
  apology block.
