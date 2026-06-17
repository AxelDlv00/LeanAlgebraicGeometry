# Lean ↔ Blueprint Check Report

## Slug
jacobian-iter127

## Iteration
127

## Files audited
- Lean: `AlgebraicJacobian/Jacobian.lean`
- Blueprint: `blueprint/src/chapters/Jacobian.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.IsAlbanese}` (chapter: `def:IsAlbanese`)
- **Lean target exists**: yes (line 57).
- **Signature matches**: yes — four abelian-variety conditions on `J` encoded as typeclass parameters (matches `rem:IsAlbanese_typeclasses` convention), body is the existential plus universal-factorisation property.
- **Proof follows sketch**: N/A (definition).
- **notes**: typeclass binders `[GrpObj J]`, `[IsProper J.hom]`, `[Smooth J.hom]`, `[GeometricallyIrreducible J.hom]` agree with the prose's "smooth proper geometrically irreducible group scheme". The universal-property body's typeclass binders on `A` mirror those on `J`.

### `\lean{AlgebraicGeometry.IsAlbanese.ofCurve}` (chapter: `def:IsAlbanese_ofCurve`)
- **Lean target exists**: yes (line 67).
- **Signature matches**: yes — `C ⟶ J` extracted via `Classical.choose` on the existential body of `h`.
- **Proof follows sketch**: yes — body is `Classical.choose h`, matching the prose.

### `\lean{AlgebraicGeometry.IsAlbanese.comp_ofCurve}` (chapter: `lem:IsAlbanese_comp_ofCurve`)
- **Lean target exists**: yes (line 72).
- **Signature matches**: yes — `P ≫ h.ofCurve = η[J]` is the pointed condition (the LaTeX `P \circ h.\mathtt{ofCurve}` reads in Lean diagram-order convention).
- **Proof follows sketch**: yes — body is `(Classical.choose_spec h).1`.

### `\lean{AlgebraicGeometry.IsAlbanese.exists_unique_ofCurve_comp}` (chapter: `lem:IsAlbanese_exists_unique_ofCurve_comp`)
- **Lean target exists**: yes (line 78).
- **Signature matches**: yes — `∃! (g : J ⟶ A), f = h.ofCurve ≫ g` matches the universal factorisation.
- **Proof follows sketch**: yes — body is `(Classical.choose_spec h).2 f hf`.

### `\lean{AlgebraicGeometry.IsAlbanese.unique}` (chapter: `thm:IsAlbanese_unique`)
- **Lean target exists**: yes (line 88).
- **Signature matches**: yes — conclusion is `∃! (e : J₁ ⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e`. Aligns with `rem:IsAlbanese_unique_iso`: the invertibility witnesses (`g ≫ h = 𝟙 J₁`, `h ≫ g = 𝟙 J₂`) are computed but not retained in the return type.
- **Proof follows sketch**: yes — the proof first produces `g : J₁ ⟶ J₂` and `h : J₂ ⟶ J₁` via mutual universal factorisation, then derives `g ≫ h = 𝟙 J₁` and `h ≫ g = 𝟙 J₂` by uniqueness of the self-factorisation, exactly as the remark describes.

### `\lean{AlgebraicGeometry.JacobianWitness}` (chapter: `def:JacobianWitness`)
- **Lean target exists**: yes (line 143).
- **Signature matches**: yes — exactly the seven enumerated fields (`J`, `grpObj`, `proper`, `smooth`, `geomIrred`, `smoothGenus`, `isAlbaneseFor`). The `smooth`/`smoothGenus` redundancy is documented in `rem:JacobianWitness_smooth_redundancy` and reflected in Lean. `isAlbaneseFor` is the quantifier-reversed form documented in `rem:JacobianWitness_quantifier_order`.
- **Proof follows sketch**: N/A (structure).

### `\lean{AlgebraicGeometry.genusZeroWitness}` (chapter: `def:genusZeroWitness`)  *[new in iter-127]*
- **Lean target exists**: yes (line 174).
- **Signature matches**: yes — Lean has `(C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] (h : genus C = 0) : JacobianWitness C`, which matches the blueprint statement "smooth proper geometrically irreducible curve over $k$ with $\genus(C) = 0$ … there exists a `JacobianWitness C`". Hypothesis encoding `h : genus C = 0` matches the prose.
- **Proof follows sketch**: N/A — body is `sorry` (recognized iter-127 scaffold per directive). The blueprint proof sketch is detailed: it enumerates all seven fields, names `toUnit C` as the universal morphism, identifies the rigidity step as the consumer of `thm:rigidity_over_kbar` with `P ∈ C(k)` feeding the pointing hypothesis, and addresses the `C(k) = ∅` branch via vacuity of the `∀ P` quantifier.
- **notes**: the proof block opens with `\leanok` while the statement carries `\notready`. With the body still `sorry`, the proof-side `\leanok` is technically premature (the marker means "proof closed, no sorry"). `sync_leanok` should reconcile this between prover and review phases each iter, so this is informational rather than blocking. Helper `geometricallyIrreducible_id_Spec` at lines 120–126 is cited in the proof prose by exact line range, and the reference is accurate.

### `\lean{AlgebraicGeometry.nonempty_jacobianWitness}` (chapter: `thm:nonempty_jacobianWitness`)
- **Lean target exists**: yes (line 194).
- **Signature matches**: yes — `Nonempty (JacobianWitness C)` matches "the type of Albanese witnesses for $C$ is non-empty".
- **Proof follows sketch**: N/A — body is `sorry` (recognized Phase-C deferred scaffold per directive). The blueprint proof sketch is extensive (Routes A/B/C plus reduction-to-$P$-independent step (0)) and properly itemises the missing Mathlib infrastructure.

### `\lean{AlgebraicGeometry.Jacobian}` (chapter: `def:Jacobian`)
- **Lean target exists**: yes (line 217).
- **Signature matches**: yes — `(jacobianWitness C).J` matches "the underlying scheme of a (uniform-over-$P$) Albanese witness".
- **Proof follows sketch**: yes — projection from `jacobianWitness C` is the construction the blueprint describes.

### `\lean{AlgebraicGeometry.Jacobian.instGrpObj}` (chapter: `thm:Jacobian_grpObj`)
- **Lean target exists**: yes (line 227).
- **Signature matches**: yes — `GrpObj (Jacobian C)`.
- **Proof follows sketch**: yes — body is `(jacobianWitness C).grpObj`, matching the prose "the witness carries the group-object structure as its field `grpObj`".

### `\lean{AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus}` (chapter: `thm:Jacobian_smooth_genus`)
- **Lean target exists**: yes (line 231).
- **Signature matches**: yes — `SmoothOfRelativeDimension (genus C) (Jacobian C).hom`. This is exactly the predicate the blueprint specifies; correctly avoids the "wrong-predicate" trap (`Smooth f` vs `SmoothOfRelativeDimension n f`).
- **Proof follows sketch**: yes — `(jacobianWitness C).smoothGenus`.

### `\lean{AlgebraicGeometry.Jacobian.instIsProper}` (chapter: `thm:Jacobian_proper`)
- **Lean target exists**: yes (line 235).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `(jacobianWitness C).proper`.

### `\lean{AlgebraicGeometry.Jacobian.instGeometricallyIrreducible}` (chapter: `thm:Jacobian_geomIrred`)
- **Lean target exists**: yes (line 238).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `(jacobianWitness C).geomIrred`.

## Red flags

(None at must-fix-this-iter severity, after applying the directive's recognized-scaffold exemptions.)

### Placeholder / suspect bodies
- `AlgebraicGeometry.genusZeroWitness` at line 174: body is `:= sorry`. **Recognized iter-127 scaffold per directive — not flagged as must-fix.**
- `AlgebraicGeometry.nonempty_jacobianWitness` at line 194: body is `:= sorry`. **Recognized Phase-C deferred scaffold per directive — not flagged as must-fix.**

### Excuse-comments
None. The `Status (Phase C scaffolding)` docstring (lines 13–28) and the `Forbidden shortcut (sanity check)` block (lines 30–38) are mathematically substantive notes, not excuse-comments: they document the architectural reason for the witness-based definition (rather than terminal-object) and the role of `nonempty_jacobianWitness` as the single Phase-C sorry. The per-declaration docstrings (notably lines 162–173 for `genusZeroWitness` and lines 180–193 for `nonempty_jacobianWitness`) explicitly mark scaffold status with an iter cross-reference and link to the corresponding blueprint route — appropriate workflow notes, not excuses.

### Axioms / Classical.choice on non-trivial claims
- `jacobianWitness` (line 202) uses `Classical.choice (nonempty_jacobianWitness C)` to extract a witness from the existence theorem. This is the standard pattern for unbundling a `Nonempty`; the substantive content sits in `nonempty_jacobianWitness` itself (the blueprint's `thm:nonempty_jacobianWitness`), not in this projection. Not flagged.
- `IsAlbanese.ofCurve` (line 67) uses `Classical.choose` to extract the universal morphism from an `IsAlbanese` term. This is the standard pattern documented in `def:IsAlbanese_ofCurve` and authorised by the blueprint. Not flagged.

## Unreferenced declarations (informational)

- `AlgebraicGeometry.geometricallyIrreducible_id_Spec` (line 120) — helper for the genus-0 witness. Not `\lean{...}`-tagged, but the prose of `def:genusZeroWitness` (line 398) cites it by name and exact line range. Acceptable as a project-local helper. The blueprint could optionally promote it to its own (small) `\lean{...}` block, but this is minor.
- `AlgebraicGeometry.jacobianWitness` (line 202) — `Classical.choice` extractor for `nonempty_jacobianWitness`. Used by all four protected `Jacobian.inst*` projections and by `Jacobian` itself. Not `\lean{...}`-tagged but cited by name across the proofs of `thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`, `thm:Jacobian_geomIrred`, and `def:Jacobian`. Acceptable as an internal helper.

Both helpers are exactly the kind of glue declaration the blueprint does not need to formalise as standalone blocks.

## Blueprint adequacy for this file

A bidirectional check: does the blueprint chapter give a prover enough detail to formalize this file correctly?

- **Coverage**: 13/15 substantive Lean declarations have a corresponding `\lean{...}` block in the chapter. Unreferenced declarations: 2 helpers (acceptable; both cited by name in prose) + 0 substantive (none flagged).
- **Proof-sketch depth**: **adequate**. The blueprint goes well beyond skeletal — `def:genusZeroWitness`'s proof walks all seven fields of `JacobianWitness` in order, names `toUnit C` as the universal morphism, identifies the rigidity step's consumption of `thm:rigidity_over_kbar` with the marked point feeding the pointing hypothesis, and addresses the empty-`C(k)` branch by vacuity. `thm:nonempty_jacobianWitness`'s proof itemises three Mathlib build-outs (α/β/γ) and the gap status of each sub-step. `thm:IsAlbanese_unique`'s sketch matches the Lean proof's bidirectional-factorisation argument step for step. The four protected-instance proofs each consist of a one-line projection plus a Mathematical context paragraph — perfectly matching the Lean projection bodies.
- **Hint precision**: **precise**. The smoothness predicate is pinned to `SmoothOfRelativeDimension (genus C) J.hom` everywhere on both sides — no `Smooth` vs `SmoothOfRelativeDimension n` ambiguity. Group-scheme structure is pinned to `GrpObj` (CategoryTheory monoidal-category encoding), matching the Lean. Properness is pinned to `IsProper J.hom` on the structure morphism. Geometric irreducibility is pinned to `GeometricallyIrreducible J.hom`. The `\lean{...}` hints all name the correct fully-qualified identifiers.
- **Generality**: **matches need**. `JacobianWitness` is defined at the right level of generality for the Jacobian definition to consume directly. The `smooth` / `smoothGenus` redundancy is documented in `rem:JacobianWitness_smooth_redundancy` and serves a real Lean-side ergonomic purpose (the typeclass-binder form `Smooth` vs the dimensional form `SmoothOfRelativeDimension`). The quantifier-reversed `isAlbaneseFor : ∀ P, IsAlbanese C P J` is documented in `rem:JacobianWitness_quantifier_order` and is the form `AbelJacobi.Jacobian.ofCurve` needs.
- **Recommended chapter-side actions**: (minor/optional only)
  - `def:genusZeroWitness`: the proof block opens with `\leanok` while the body is still `sorry`. `sync_leanok` should remove this automatically between prover and review phases each iter; verify the next `sync_leanok` run actually fires for this block. (Not a blueprint-author action; flagging only so plan agent knows to expect the marker shift.)
  - `def:genusZeroWitness` uses the `theorem` environment with a `def:` label, while sister data-producing declarations (`def:Jacobian` at line 105, `def:JacobianWitness` at line 199) use the `definition` environment. Pure stylistic inconsistency — cross-references still resolve, no semantic effect. Optional follow-up: switch to `\begin{definition}` for consistency.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - Premature `\leanok` on the proof block of `def:genusZeroWitness` while the Lean body is `sorry`. Expected to be reconciled by `sync_leanok`; informational only.
  - Environment-vs-label inconsistency on `def:genusZeroWitness` (`\begin{theorem}` + `\label{def:...}`) relative to sister data-producing definitions. Cosmetic; cross-refs work.

Overall verdict: **Lean file and blueprint chapter are in faithful agreement** — all 13 `\lean{...}`-tagged blocks have matching declarations with correct signatures, both recognized sorries are properly documented on both sides, the new iter-127 `def:genusZeroWitness` block aligns precisely with the Lean signature and gives a detailed seven-field proof sketch routed through `thm:rigidity_over_kbar`; only two minor cosmetic items remain, neither blocking.
