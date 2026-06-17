# Lean Audit Report

## Slug
iter038

## Iteration
038

## Scope
- files audited: 1 (directive-scoped; focus on `RestrictOverBridge` section)
- files skipped per directive: 13 (all other `.lean` files in `AlgebraicJacobian/Cohomology/`)

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (deprecated API pervasive in new section; `show` vs `change`)
- **excuse-comments**: none
- **notes**:

  **New `RestrictOverBridge` section (lines 151–267) — 8 declarations added this iter:**

  - `specBasicOpen_ι_image_overEquivalence_functor` (private, lines 155–158): Proof via
    `Opens.ext` + `Set.image_preimage_eq_of_subset`. Witness construction `⟨⟨x, leOfHom V.hom hx⟩, rfl⟩`
    is correct: shows `x ∈ range ι` for any `x ∈ V.left` using the structural bound. Clean.

  - `overEquivalence_functor_isContinuous_toScheme` / `overEquivalence_inverse_isContinuous_toScheme`
    (lines 162–173): Wrapper instances delegating to the earlier
    `Opens.overEquivalence_functor/inverse_isContinuous`. The docstrings correctly explain the
    `toScheme` rephrasing is needed to drive instance search. No issue.

  - `overForgetIso` (lines 179–184): `NatIso.ofComponents` with `eqToIso` components and
    `Subsingleton.elim _ _` naturality. **Correct and non-vacuous**: `Over (Opens X)` is a thin
    category (poset-over-poset), so morphisms are unique; `Subsingleton.elim` on morphisms is the
    proper proof. Verified axiom-clean (propext/Classical.choice/Quot.sound only, no sorry).

  - `overForgetInvIso` (lines 200–203): Proved by `Iso.refl _`. The claim is that
    `(overEquivalence D(g)).inverse ⋙ Over.forget D(g)` is *definitionally equal* to
    `D(g).ι.opensFunctor`. Lean LSP `lean_verify` confirms axiom-clean with no errors or
    additional axioms, establishing that the definitional equality holds. Not hiding a real
    obligation — it is the proof (by reduction). See minor finding below for fragility note.

  - `overBasicOpenRingHom` / `overBasicOpenRingInvHom` (lines 189–213): Constructed by
    `Functor.whiskerRight (NatTrans.op ...) ringCatSheaf.val` wrapped in an angle-bracket sheaf
    morphism. This is the standard Lean pattern for constructing sheaf maps from underlying natural
    transformations. Since `overForgetInvIso = Iso.refl _`, its `.inv` is the identity, so
    `overBasicOpenRingInvHom` correctly simplifies to a whiskering of the identity. Clean.

  - `modulesOverBasicOpenEquivalence` (lines 222–240): The two coherence obligations H₁ and H₂
    are the focus of this audit.

    **H₁** (lines 227–232, `Opens ↥(specBasicOpen g)` side): Opens with `NatTrans.ext` + `funext`
    to obtain a per-object goal, then `simp only [...]` unfolds compositions, then
    `erw [← Functor.map_comp]` combines two `map` calls, then
    `congrArg ringCatSheaf.val.map (Subsingleton.elim _ _)` closes by the thin-category
    uniqueness of morphisms in `Opens (Spec R)`. **Genuine and non-vacuous**: thin-category
    subsingleton is being correctly exploited.

    **H₂** (lines 233–240, `Over (specBasicOpen g)` side): Same structure; after `erw`, uses
    `(congrArg ... (Subsingleton.elim _ (𝟙 _))).trans (map_id _)`. **Genuine and non-vacuous**:
    `Over (Opens X)` is also a thin category (morphisms are unique), so `Subsingleton.elim` on the
    morphism is valid. The `.trans (map_id _)` step is necessary and real — it converts
    `map (𝟙 _)` to the identity of the target.

    No evidence of a "bare `ext` closing via a spurious `rfl`" survives: the committed proof
    uses explicit `NatTrans.ext` + `congrArg` + `Subsingleton.elim` throughout.

    Verified axiom-clean (standard floor, no sorry, no extra axioms).

  - **TODO block** (lines 242–265): A `/-  ... -/` block comment describing the future
    `overBasicOpenIsoRestrict` and B4. It is a pure comment — no declaration, no `sorry`, no
    stub. The mathematical content (pushforwardComp defeq, `ι_appIso`, `pushforwardCongr`
    metavariable trap) is internally consistent with the surrounding code. **Not an
    excuse-comment**: it documents work not yet in the file, not work already in the file that is
    wrong. See minor finding below for length/style.

  **Pre-existing declarations (lines 1–149):**

  - `Opens.overEquivalence_functor/inverse_coverPreserving` (lines 35–65): Proofs look correct.
    Note line 46 uses `show` where `change` is required (Lean linter flags this; see bad-practices
    finding below). The tactic does succeed, so it is not dead-end, but it uses a discouraged form.

  - `presentationOverBasicOpen` (lines 129–149): `set_option backward.isDefEq.respectTransparency false`
    is scoped to this single definition. Not new this iter; noted for completeness.

  - No leftover scratch names (`testE`, `testPhi`, `thetaTest`, etc.) anywhere in the file. Confirmed.

---

## Must-fix-this-iter

None.

---

## Major

- `QcohRestrictBasicOpen.lean:195` — `CategoryTheory.Sheaf.val` is deprecated; Lean itself warns
  "Use ObjectProperty.obj". The same deprecated accessor appears at lines **195, 213, 232, 239,
  240** — five occurrences, all in declarations added this iteration (`overBasicOpenRingHom`,
  `overBasicOpenRingInvHom`, `modulesOverBasicOpenEquivalence` H₁+H₂). This is not yet a
  correctness failure but it will break when the deprecated alias is removed from Mathlib. The
  replacement `ObjectProperty.obj` should be applied before the next Mathlib bump.

---

## Minor

- `QcohRestrictBasicOpen.lean:46` — `show` tactic used where `change` is required (Lean style
  linter warning: "this tactic invocation changed the goal"). In
  `overEquivalence_functor_coverPreserving`. No correctness impact.

- `QcohRestrictBasicOpen.lean:30,205,215,220,229,235,245,248` — Eight lines exceed the 100-character
  linter limit. All flagged by Lean's `linter.style.longLine`. The densest cluster is in the
  `simp only [...]` call of `modulesOverBasicOpenEquivalence` (lines 229, 235). Style only; no
  correctness impact.

- `QcohRestrictBasicOpen.lean:203` — `overForgetInvIso g = Iso.refl _` relies on Lean-checked
  definitional equality between `(overEquivalence D(g)).inverse ⋙ Over.forget D(g)` and
  `D(g).ι.opensFunctor`. This is confirmed correct by `lean_verify` (no errors), but the proof is
  invisible to the reader and fragile to upstream Mathlib implementation changes in `overEquivalence`.
  A one-line `native_decide`-style comment or `show`-annotation would improve readability.

- `QcohRestrictBasicOpen.lean:126` — `set_option backward.isDefEq.respectTransparency false` is
  scoped to `presentationOverBasicOpen`. This option suppresses transparency checks in definitional
  equality and can hide real type mismatches. Not new this iter; not a blocker; worth revisiting if
  that definition causes downstream issues.

- `QcohRestrictBasicOpen.lean:242–265` — The TODO block is 24 lines of design documentation
  embedded in the source. The content is accurate and useful, but its length makes it a mini-blueprint
  chapter inside a `.lean` file. Low priority.

---

## Excuse-comments (always called out separately)

None. The TODO block (lines 242–265) describes future-work declarations not yet present in the file,
not existing wrong code; it does not qualify as an excuse-comment under the auditor's criteria.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (deprecated `Sheaf.val` / `ObjectProperty.obj` in 5 locations, all new this iter)
- **minor**: 5 (show/change, 8 long lines, Iso.refl fragility, set_option, long TODO block)
- **excuse-comments**: 0

**Overall verdict**: The 8 new `RestrictOverBridge` declarations are axiom-clean and mathematically
genuine; the `Subsingleton.elim`-based coherence proofs are non-vacuous (thin-category argument),
`overForgetInvIso = Iso.refl _` is Lean-verified, and no sorry or unauthorized axioms are present.
The single actionable finding is pervasive use of the deprecated `Sheaf.val` accessor across the new
section — migrate to `ObjectProperty.obj` before the next Mathlib bump.
