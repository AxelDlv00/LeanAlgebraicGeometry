# Lean Audit Report

## Slug
iter007

## Iteration
007

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/GrassmannianCells.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Line 59 (in docstring of `affineChart`)**: The comment reads "For the iter-007
    file-skeleton the body is a typed `sorry`." — but the body is **not** a sorry; it is
    the fully elaborated real definition
    `AlgebraicGeometry.Spec (CommRingCat.of (MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ))`.
    The diagnostic tool confirms no errors: the body type-checks cleanly. The first sentence
    of the same docstring paragraph correctly predicts the definition ("iter-177+: the body
    should be [exact definition]"), so the body is correct — but the second sentence was
    not updated after the body was filled and now directly contradicts the code.
    Classification: **major** (readers relying on the docstring will think this declaration
    is still a stub when it is complete).
  - **Lines 33–44 ("Planner note" block)**: An implementation planning note embedded by
    the planning agent ("The prover should build `affineChart` as…"). Now that the body is
    filled in, this block is fully redundant. The advice it gives is sound, and the
    completed definition follows it exactly — so the note is not misleading, merely
    superseded. Classification: **minor**.
  - `affineChart` definition **is mathematically sound**: the index type
    `Fin d × {q : Fin r // q ∉ I}` has cardinality `d × (r − #I)`, which equals the
    correct `d(r−d)` when `I.card = d`. The signature does not enforce `I.card = d` as a
    hypothesis; this is a minor mathematical imprecision (the definition is well-typed and
    sensible for any `I`, just not necessarily the Grassmannian chart for `I.card ≠ d`).
    Classification: **minor** (no wrong content, just unconstrained signature).
  - No `axiom`, no `sorry`, no debug commands.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none (the "iter-176"/"iter-177+" labels in stub docstrings are
  carryover numbering from the source project; they accurately describe the stubs as
  typed sorries, so they are not misleading about the current code)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:

  #### Pre-existing stubs — confirmed honest

  All four typed-sorry stubs are **intact and honest**:

  | Line | Declaration | Type | Body |
  |------|-------------|------|------|
  | 123 | `Scheme.hilbertPolynomial` | `Polynomial ℚ` | `sorry` |
  | 161 | `Scheme.QuotFunctor` | `(Over S)ᵒᵖ ⥤ Type u` | `sorry` |
  | 198 | `Scheme.Grassmannian` | `(Over S)ᵒᵖ ⥤ Type u` | `sorry` |
  | 225 | `Grassmannian.representable` | `∃ Y : Over S, Nonempty ((Grassmannian V d).RepresentableBy Y)` | `by sorry` |

  None of these types are weakened to `Unit` or any trivial type. All carry the
  substantive content described in the module docstring (non-constant polynomials,
  contravariant functors into `Type u`, a `RepresentableBy` existential). Diagnostic tool
  confirms exactly 4 sorry-warnings (lines 123, 161, 198, 225) and **zero errors**.

  #### New declaration: `SheafOfModules.IsLocallyFreeOfRank` (line 253)

  ```lean
  def IsLocallyFreeOfRank {X : Scheme.{u}} (M : X.Modules) (d : ℕ) : Prop :=
    ∃ (ι : Type u) (U : ι → X.Opens), (⨆ i, U i = ⊤) ∧
      ∀ i, Nonempty ((Scheme.Modules.pullback (U i).ι).obj M ≅
        _root_.SheafOfModules.free (R := (U i).toScheme.ringCatSheaf) (ULift.{u} (Fin d)))
  ```

  - Definition is **mathematically correct**: covering condition `⨆ i, U i = ⊤` in the
    lattice of opens is the right formulation of an open cover; pullback along the open
    immersion is `Scheme.Modules.pullback (U i).ι` (signature confirmed:
    `{X Y : Scheme} (f : X ⟶ Y) : Y.Modules ⥤ X.Modules`); the free sheaf is
    `SheafOfModules.free (ULift.{u} (Fin d))` (confirmed present in Mathlib via loogle);
    the `Nonempty` wrapper is appropriate to make the isomorphism data
    `Prop`-valued.
  - Hover info confirms the elaborated type is `Prop` with no errors.
  - Loogle and local search confirm **no parallel Mathlib predicate** for rank-indexed
    local freeness of a sheaf of modules on a scheme; the claim in the docstring is
    accurate.
  - No issues.

  #### New declaration: `Module.annihilator_isLocalizedModule_eq_map` (line 289)

  ```lean
  theorem annihilator_isLocalizedModule_eq_map
      ... (f : M →ₗ[R] Mₚ) [IsLocalizedModule S f] :
      Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)
  ```

  - **Proof is complete and Lean-verified**: the diagnostic tool reports **no errors** for
    this theorem. The proof does not contain `sorry`.
  - The proof structure is sound:
    - `le_antisymm` splits into two inclusions.
    - `Ann Rₚ Mₚ ⊆ image`: writes an element of `Rₚ` as `mk'(a, s)` via
      `IsLocalization.mk'_surjective`, clears a common denominator over the finite
      generating set (using `Finset.dvd_prod_of_mem`), and rewrites
      `mk'(a, s) = algebraMap(U·a) · mk'(1, U·s)` to land in the ideal image.
    - `image ⊆ Ann Rₚ Mₚ`: the image of an annihilator acts trivially on localized
      generators via `IsLocalizedModule.mk'_smul_mk'`.
  - The hypotheses (`[Module R Mₚ]`, `[Module Rₚ Mₚ]`, `[IsScalarTower R Rₚ Mₚ]`) are
    the standard abstract `IsLocalization`/`IsLocalizedModule` setup and are not
    excessive or circular.
  - Loogle search for Mathlib lemmas combining `Module.annihilator`, `IsLocalization`,
    and `Ideal.map` returns **nothing**. The "Mathlib has no annihilator-localization
    lemma" claim in the docstring is confirmed. No parallel-API concern.
  - No issues.

---

## Must-fix-this-iter

None.

---

## Major

- `GrassmannianCells.lean:59` — **Outdated docstring**: the phrase "For the iter-007
  file-skeleton the body is a typed `sorry`" appears inside the docstring of `affineChart`,
  but the actual body is the complete definition
  `AlgebraicGeometry.Spec (CommRingCat.of (MvPolynomial ...))`. The comment was not
  updated after the body was filled. Readers of the docstring will believe this
  declaration is still a placeholder stub when it is in fact a complete, type-correct
  definition. Should be removed or corrected to reflect the current state.

---

## Minor

- `GrassmannianCells.lean:33–44` — Stale "Planner note" block. The implementation
  advice it contains was followed exactly, so it is now superseded. Not misleading; can
  be removed as cleanup.
- `GrassmannianCells.lean:60` — `affineChart` accepts any `I : Finset (Fin r)` without
  requiring `I.card = d`. The docstring says "a `d`-element subset `I`", but the type
  does not enforce this. The definition is well-typed and sensible for all `I`; the
  mismatch is a minor imprecision, not a mathematical error.
- `QuotScheme.lean` — The "iter-176" / "iter-177+" labels in stub docstrings are from
  the source project's iteration numbering (commit message: "extracted from
  Algebraic-Jacobian-Challenge"). They accurately describe the sorry stubs and are not
  misleading, but the numbering is detached from the current project's iter-007 sequence.
  Cosmetic.

---

## Excuse-comments (always called out separately)

None found. There are no comments of the form "TODO: replace with real def", "placeholder",
"temporary", "wrong but works", or "will fix later" in either file.

The line "For the iter-007 file-skeleton the body is a typed `sorry`"
(GrassmannianCells.lean:59) is an outdated description, not an excuse-comment: it does
not admit the code is wrong; it is simply stale after the body was filled in.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 — outdated docstring on `affineChart` claiming the body is `sorry` when it is not
- **minor**: 3 — stale planner note, unconstrained `I.card` in signature, detached iter numbering labels
- **excuse-comments**: 0

Overall verdict: both files are in good shape — the newly filled `affineChart` body and the two new declarations (`IsLocallyFreeOfRank`, `annihilator_isLocalizedModule_eq_map`) are mathematically correct and Lean-verified with no errors; the only real issue is one major outdated docstring in `GrassmannianCells.lean:59` that contradicts the current code by claiming the body is still a sorry.
