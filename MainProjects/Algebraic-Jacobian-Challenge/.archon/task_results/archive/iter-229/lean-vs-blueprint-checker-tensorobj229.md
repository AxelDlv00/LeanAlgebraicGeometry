# Lean ↔ Blueprint Check Report

## Slug
tensorobj229

## Iteration
229

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv}` (chapter: `\lem:open_immersion_slice_sheaf_equiv`)

- **Lean target exists**: yes — `noncomputable def overSliceSheafEquiv` at line 2321
- **Signature matches**: yes (core), with one minor prose overreach (see notes)
  - Blueprint: `Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology U) A`
  - Lean: `Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology ↥U) A`
  - `↥U` is the coercion `U : Opens X` → the subtype topological space, which correctly corresponds to `\widetilde{U}` / `Opens.grothendieckTopology U` in the blueprint.
  - Lean is **more general** than the blueprint states: `variable {X : Type u} [TopologicalSpace X]`, not "scheme". Appropriate generalization; not a mismatch.
  - Blueprint statement says "compatible with the module-pullback comparison `restrictFunctorIsoPullback`" — this compatibility is **not formally asserted** in the Lean type. The Lean declaration returns only the bare `≌`; no compatibility data is bundled. This is a minor prose overreach in the blueprint statement.
- **Proof follows sketch**: partial (mathematical content correct, wrong API name in sketch — see Red Flags §Blueprint adequacy)
- **notes**: Body is `(TopologicalSpace.Opens.overEquivalence U).sheafCongr (...)` — one-line, axiom-clean, no sorry. `\leanok` in the blueprint statement block is correctly set.

---

## Red Flags

### Blueprint adequacy: wrong API name in proof sketch

Blueprint proof (lines 2877–2905) says:

> "One therefore applies the dense-subsite transfer `Functor.IsDenseSubsite.sheafEquiv`: a continuous, cocontinuous, dense inclusion of sites induces an equivalence of the associated sheaf categories."

The Lean formalization does **not** use `Functor.IsDenseSubsite.sheafEquiv`. It uses
`CategoryTheory.Equivalence.sheafCongr` (called as `(TopologicalSpace.Opens.overEquivalence U).sheafCongr …`), supported by the project-local `instance overEquivInverseIsDenseSubsite` that provides the required `IsDenseSubsite` datum. These are related but distinct API entry points: `sheafCongr` consumes the `IsDenseSubsite` instance internally, whereas `IsDenseSubsite.sheafEquiv` (if it exists) would be called directly on the functor. A prover following the blueprint proof sketch would look for `IsDenseSubsite.sheafEquiv` and either not find it or find it does not apply directly, requiring discovery of the `sheafCongr` route independently.

**Severity: major** — the sketch correctly describes the mathematical strategy (dense subsite transport) but names the wrong Mathlib API endpoint. The formalization succeeded because the iter-229 prover deviated from the sketch; the blueprint would not reliably guide a future prover.

### Placeholder / suspect bodies
None. All three new declarations (`overSliceSheafEquiv`, `overEquivInverseIsDenseSubsite`, `overEquiv_image_cover_iff`) have complete, non-sorry bodies.

### Excuse-comments
None found in the new `section OverSliceSheafEquiv` block.

### Axioms / Classical.choice on non-trivial claims
No `axiom` declarations in the new block. The grep for `axiom` in the file returns only comments containing "axiom-clean".

---

## Unreferenced declarations (informational)

### `AlgebraicGeometry.Scheme.Modules.overEquivInverseIsDenseSubsite` (line 2295)
This `instance` is not pinned via any `\lean{...}` block in the blueprint. It is the load-bearing `Functor.IsDenseSubsite` datum that `sheafCongr` consumes. The directive describes it as a "supporting instance" rather than a primary declaration; its absence from the blueprint is **minor** given that it is a proof-internal instance supporting `overSliceSheafEquiv`. If the blueprint-writer subagent adds a separate pin for it in the future, a one-sentence block under `lem:open_immersion_slice_sheaf_equiv` would suffice.

### `overEquiv_image_cover_iff` (line 2266, `private`)
Private lemma — not expected to appear in the blueprint. Its sole mathematical content (the pointwise neighbourhood-cover correspondence across `Subtype.val`) is accurately summarized in the blueprint proof prose.

---

## Blueprint adequacy for this file (iter-229 additions only)

- **Coverage**: 1/1 primary Lean declarations have a `\lean{...}` block. The instance `overEquivInverseIsDenseSubsite` is unreferenced but classifiable as a helper. The private `overEquiv_image_cover_iff` is correctly absent.
- **Proof-sketch depth**: under-specified on the API. The sketch correctly identifies the dense-subsite strategy and the thinness-trivializes-coherence argument, but names the wrong Mathlib entrypoint (`IsDenseSubsite.sheafEquiv` instead of `Equivalence.sheafCongr`). A dedicated prover would have to discover `sheafCongr` independently.
- **Hint precision**: partially loose. The `\lean{AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv}` pin is correct. But the statement prose claims "compatible with `restrictFunctorIsoPullback`" which is not a formal assertion in the Lean type; this overstatement could mislead a consumer expecting a bundled compatibility field.
- **Generality**: too narrow in the statement ("Let X be a scheme") — Lean correctly uses a topological space. The blueprint should say "Let X be a topological space (in particular a scheme)."
- **`\uses{}`**: The statement block has no `\uses{}` tag at all. Since the proof's inputs are all Mathlib declarations (`overEquivalence U`, `sheafCongr`), omitting `\uses{}` is acceptable. If `overEquivInverseIsDenseSubsite` were separately pinned, a `\uses{overEquivInverseIsDenseSubsite}` in the proof block would be appropriate.
- **Recommended chapter-side actions** (for blueprint-writer subagent, not must-fix this iter):
  1. Correct the proof sketch: replace "`Functor.IsDenseSubsite.sheafEquiv`" with "`CategoryTheory.Equivalence.sheafCongr` (consuming the `IsDenseSubsite` instance `overEquivInverseIsDenseSubsite`)".
  2. Soften the statement's "Let X be a scheme" to "Let X be a topological space (in particular, any scheme)."
  3. Remove "compatible with `restrictFunctorIsoPullback`" from the formal statement text, or demote it to a parenthetical remark, since no such compatibility is asserted in the Lean type.
  4. Optionally add a one-sentence informal note for `overEquivInverseIsDenseSubsite` under the proof (not a separate `\lean{}` pin required).

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint proof sketch names wrong Mathlib API (`sheafEquiv` vs `sheafCongr`) | **major** |
| Blueprint statement overreaches: "compatible with `restrictFunctorIsoPullback`" not in Lean type | **minor** |
| Blueprint says "scheme" where "topological space" is the actual generality used | **minor** |
| `overEquivInverseIsDenseSubsite` not separately pinned in blueprint | **minor** (acceptable helper) |
| No `\uses{}` in `lem:open_immersion_slice_sheaf_equiv` | **minor** |

**No must-fix-this-iter findings.** All three new Lean declarations (`overSliceSheafEquiv`, `overEquivInverseIsDenseSubsite`, `overEquiv_image_cover_iff`) are axiom-clean, body-complete, and free of sorry, placeholder bodies, and excuse-comments. The `\lean{...}` pin is correct. The only actionable issues are blueprint-side inaccuracies in the proof sketch and statement prose, classified as major (wrong API name) and minor (overstatement/generality). These should be addressed by the blueprint-writer subagent in a future iter but do not block downstream Lean work on the affected file.

**Overall verdict**: Lean declarations for `lem:open_immersion_slice_sheaf_equiv` are axiom-clean and correctly implement the stated equivalence; blueprint has one major inaccuracy (wrong Mathlib API name in proof sketch) and two minor imprecisions (overstatement of compatibility, wrong generality level), none blocking.
