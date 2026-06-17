# Lean ↔ Blueprint Check Report

## Slug
jacobian-review129

## Iteration
129

## Files audited
- Lean: `AlgebraicJacobian/Jacobian.lean`
- Blueprint: `blueprint/src/chapters/Jacobian.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.IsAlbanese}` (chapter: `def:IsAlbanese`)
- **Lean target exists**: yes (L71)
- **Signature matches**: yes — typeclass binders `[GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom]` match the blueprint phrasing "smooth proper geometrically irreducible group scheme $J$ over $k$" and the typeclass-on-binder convention is documented in `rem:IsAlbanese_typeclasses`.
- **Proof follows sketch**: N/A — definition. The existential body `∃ α : C ⟶ J, P ≫ α = η[J] ∧ ∀ {A} … ∃! g, f = α ≫ g` is exactly the blueprint statement of the Albanese property.
- **notes**: clean.

### `\lean{AlgebraicGeometry.IsAlbanese.ofCurve}` (chapter: `def:IsAlbanese_ofCurve`)
- **Lean target exists**: yes (L81)
- **Signature matches**: yes — returns `C ⟶ J` extracted via `Classical.choose h`.
- **Proof follows sketch**: yes — implementation is literally `Classical.choose h`, matching the blueprint phrase "obtained by `Classical.choose` on the existential body of $h$".
- **notes**: clean.

### `\lean{AlgebraicGeometry.IsAlbanese.comp_ofCurve}` (chapter: `lem:IsAlbanese_comp_ofCurve`)
- **Lean target exists**: yes (L86)
- **Signature matches**: yes — `P ≫ h.ofCurve = η[J]`, matching the chapter equation $P \circ h.\mathtt{ofCurve} = \eta_J$.
- **Proof follows sketch**: yes — implementation `(Classical.choose_spec h).1`, in line with the chapter's "extracted via Classical.choose_spec".
- **notes**: clean.

### `\lean{AlgebraicGeometry.IsAlbanese.exists_unique_ofCurve_comp}` (chapter: `lem:IsAlbanese_exists_unique_ofCurve_comp`)
- **Lean target exists**: yes (L92)
- **Signature matches**: yes — `∃! (g : J ⟶ A), f = h.ofCurve ≫ g`, matching the blueprint factorisation statement.
- **Proof follows sketch**: yes — `(Classical.choose_spec h).2 f hf`.
- **notes**: clean.

### `\lean{AlgebraicGeometry.IsAlbanese.unique}` (chapter: `thm:IsAlbanese_unique`)
- **Lean target exists**: yes (L102)
- **Signature matches**: yes — conclusion `∃! (e : J₁ ⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e`. The morphism (not isomorphism) form is explicitly authorised by `rem:IsAlbanese_unique_iso`.
- **Proof follows sketch**: yes — the tactic block (L107–128) constructs both $g$ and an inverse $h$, verifies $g ≫ h = 𝟙$ and $h ≫ g = 𝟙$ as intermediate facts, then returns only the morphism-and-uniqueness triple. Exactly the workflow described in the chapter's proof sketch and in `rem:IsAlbanese_unique_iso`.
- **notes**: clean.

### `\lean{AlgebraicGeometry.JacobianWitness}` (chapter: `def:JacobianWitness`)
- **Lean target exists**: yes (L157)
- **Signature matches**: yes — seven fields (`J`, `grpObj`, `proper`, `smooth`, `geomIrred`, `smoothGenus`, `isAlbaneseFor`) match the chapter's enumeration one-to-one. The redundancy of `smooth` vs `smoothGenus` is explicitly acknowledged in `rem:JacobianWitness_smooth_redundancy`. The `isAlbaneseFor : ∀ P, IsAlbanese …` quantifier order matches `rem:JacobianWitness_quantifier_order`.
- **Proof follows sketch**: N/A — structure definition.
- **notes**: clean.

### `\lean{AlgebraicGeometry.genusZeroWitness}` (chapter: `def:genusZeroWitness`)
- **Lean target exists**: yes (L188)
- **Signature matches**: yes — `(C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] (h : genus C = 0) : JacobianWitness C`. Matches the blueprint statement (curve hypotheses + `genus C = 0` hypothesis + `JacobianWitness C` conclusion). The blueprint carries `\notready` and the body is `sorry` on the Lean side — both consistent with the iter-127 scaffold status documented in the directive's "Known issues" and in the file header.
- **Proof follows sketch**: N/A — body is `sorry`; explicitly authorized per directive (iter-127 scaffold; closure deferred to iter-138+).
- **notes**: docstring (L186) self-tags the status as "iter-127 scaffold — body is `sorry`. The body closure is iter-138+ work". Not an excuse-comment; this is the project-tracked status of an authorised scaffold sorry.

### `\lean{AlgebraicGeometry.Jacobian}` (chapter: `def:Jacobian`) [PROTECTED]
- **Lean target exists**: yes (L231)
- **Signature matches**: yes — protected, signature frozen by `archon-protected.yaml`. Body `(jacobianWitness C).J` matches the blueprint phrase "the underlying scheme of a (uniform-over-$P$) Albanese witness for $C$".
- **Proof follows sketch**: yes — projection from witness.
- **notes**: protected; not flagged regardless.

### `\lean{AlgebraicGeometry.Jacobian.instGrpObj}` (chapter: `thm:Jacobian_grpObj`) [PROTECTED]
- **Lean target exists**: yes (L241)
- **Signature matches**: yes — protected. Body `(jacobianWitness C).grpObj` matches the blueprint proof "$\Jac(C)$ inherits it by projection".
- **Proof follows sketch**: yes — projection.
- **notes**: protected.

### `\lean{AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus}` (chapter: `thm:Jacobian_smooth_genus`) [PROTECTED]
- **Lean target exists**: yes (L245)
- **Signature matches**: yes — protected. `SmoothOfRelativeDimension (genus C) (Jacobian C).hom`, matching "smooth of relative dimension $g(C)$".
- **Proof follows sketch**: yes — projection.
- **notes**: protected.

### `\lean{AlgebraicGeometry.Jacobian.instIsProper}` (chapter: `thm:Jacobian_proper`) [PROTECTED]
- **Lean target exists**: yes (L249)
- **Signature matches**: yes — protected.
- **Proof follows sketch**: yes — projection.
- **notes**: protected.

### `\lean{AlgebraicGeometry.Jacobian.instGeometricallyIrreducible}` (chapter: `thm:Jacobian_geomIrred`) [PROTECTED]
- **Lean target exists**: yes (L252)
- **Signature matches**: yes — protected.
- **Proof follows sketch**: yes — projection.
- **notes**: protected.

### `\lean{AlgebraicGeometry.nonempty_jacobianWitness}` (chapter: `thm:nonempty_jacobianWitness`)
- **Lean target exists**: yes (L208)
- **Signature matches**: yes — `Nonempty (JacobianWitness C)` over the curve hypotheses, matching the blueprint phrasing "the type of Albanese witnesses for $C$ is non-empty".
- **Proof follows sketch**: N/A — body is `sorry`; explicitly authorised per directive (Phase-C OFF-LIMITS sorry, gated on M2 + M3 closure).
- **notes**: docstring (L194–207) correctly characterises this as the headline Phase-C sorry and accurately previews Routes A/B and the genus-$0$ branch.

## Red flags

No red flags. The two `:= sorry` bodies (L192, L211) are pre-authorised by the directive and tracked in the file header inventory.

## Unreferenced declarations (informational)

- `AlgebraicGeometry.geometricallyIrreducible_id_Spec` (L134) — helper lemma used only inside the genus-$0$ witness construction. Mentioned in blueprint prose at L398 (with a stale line reference; see Major findings) but does not carry its own `\lean{...}` block. Acceptable as a private helper; could optionally be promoted to a `\lean{…}` block if the project wants the helper to be blueprint-visible.
- `AlgebraicGeometry.jacobianWitness` (L216) — `Classical.choice`-extracted witness, the standard plumbing between `nonempty_jacobianWitness` and `Jacobian`. Mentioned in blueprint prose (proof of `thm:Jacobian_grpObj` at L130) but does not carry its own `\lean{…}` block. Acceptable as derived plumbing.

## Blueprint adequacy for this file

- **Coverage**: 13/15 substantive Lean declarations have a corresponding `\lean{...}` block in the chapter. The 2 unreferenced are the `geometricallyIrreducible_id_Spec` helper and the `jacobianWitness` `Classical.choice` plumbing — both fine as helpers.
- **Proof-sketch depth**: adequate. Every `\lean{...}` block whose Lean side has a substantive proof body has a matching `\begin{proof}` in the chapter, and the sketches are at the right level of detail for a prover to formalize. `thm:IsAlbanese_unique`'s sketch tracks the actual tactic flow (factor each through the other, identify with self-factorisation $=$ id, return existence-uniqueness triple). `def:genusZeroWitness` has a complete proof sketch in the chapter even though the Lean body is currently `sorry`; this is exactly the iter-138+ formalisation target.
- **Hint precision**: precise. Every `\lean{...}` names the exact fully-qualified declaration; no ambiguity about which Mathlib predicate to use.
- **Generality**: matches need. The blueprint anticipates the per-$P$-vs-bundled-once-over-$P$ design tension and resolves it with `rem:JacobianWitness_quantifier_order`; it anticipates the `smooth` vs `smoothGenus` redundancy with `rem:JacobianWitness_smooth_redundancy`. No parallel API was written.
- **Recommended chapter-side actions**: none required this iter beyond what is already on the soft-issue list (the iter-128 acknowledged C.2.a/C.2 prologue over-`k̄` framing) and the minor stale line references called out below.

## Severity summary

### must-fix-this-iter
None.

### major
None.

### minor
- `blueprint/src/chapters/Jacobian.tex:398` references `AlgebraicJacobian/Jacobian.lean:120--126` for `geometricallyIrreducible_id_Spec`; the actual location after the iter-129 header expansion is L134–140.
- `blueprint/src/chapters/Jacobian.tex:410` references `AlgebraicJacobian/Jacobian.lean:174--178` for the `genusZeroWitness` body; the actual location after the iter-129 header expansion is L188–192. Both line refs were correct relative to the pre-iter-129 file but were not re-synced when the header inventory landed.

### informational
- Acknowledged soft-not-must-fix drift: `Jacobian.tex` § C.2.a (L322–326) statement and the § C.2 prologue (L319) still phrase the keystone over $\bar k$, while the iter-127 over-k commitment establishes the result directly over $k$ via `rigidity_over_kbar` (which is already k-agnostic). Per directive: not re-flagged because the previously-known drift has not gotten worse this iter. The narrative around this drift is internally coherent — § C.2.f (L352), § C.2.g (L354), and the Mathlib infrastructure summary point ($\gamma$) at L372 all consistently describe the over-k commitment — only the C.2.a/C.2-prologue surfaces still carry the legacy over-$\bar k$ phrasing.

**Overall verdict**: Jacobian.lean follows the blueprint faithfully; the only post-iter-129-header issues are two stale line references in the chapter's `def:genusZeroWitness` proof, which are minor prose-side noise and do not affect mathematical correctness or block downstream work.
