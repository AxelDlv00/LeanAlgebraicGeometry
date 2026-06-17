# Lean ↔ Blueprint Check Report

## Slug
abeljacobi-review117

## Iteration
117

## Files audited
- Lean: `AlgebraicJacobian/AbelJacobi.lean`
- Blueprint: `blueprint/src/chapters/AbelJacobi.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Jacobian.ofCurve}` (chapter: `def:ofCurve`)
- **Lean target exists**: yes (`AbelJacobi.lean:51`).
- **Signature matches**: yes. Lean returns `(P : 𝟙_ (Over (Spec (.of k))) ⟶ C) → (C ⟶ Jacobian C)`; blueprint `\alpha_P : C \to \Jac(C)` with `P : \mathbf{1} \to C`. The implicit `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` instances in the surrounding `variable` block mirror "smooth proper curve" in the chapter preamble.
- **Proof follows sketch**: yes (this is a `def`, not a theorem; body is the projection `((jacobianWitness C).isAlbaneseFor P).ofCurve`). Blueprint says "the universal pointed morphism $\iota_P$ supplied by that Albanese structure" / "projection of the universal-pointed-morphism field of the Albanese predicate" — exact match. The four `letI` lines unfold the bundled instances from the witness, which is invisible glue not requiring chapter coverage.
- **notes**: `ofCurve` is `noncomputable` (because `IsAlbanese.ofCurve` is `Classical.choose` of the existential `∃ α, …`); this is consistent with the Layer-I / Layer-II separation described in §"Implementation route".

### `\lean{AlgebraicGeometry.Jacobian.comp_ofCurve}` (chapter: `lem:comp_ofCurve`)
- **Lean target exists**: yes (`AbelJacobi.lean:62`).
- **Signature matches**: yes. Lean: `(P) → P ≫ ofCurve P = η[Jacobian C]`; blueprint: `P \circ \alpha_P = \eta[\Jac(C)]`. The `η[·]` notation in the chapter is the same `MonObj` glyph used in Lean (open `MonObj` at the top of the file).
- **Proof follows sketch**: yes. Blueprint proof: "field projection from the Albanese structure … the pointed-property field of that Albanese structure". Lean: `((jacobianWitness C).isAlbaneseFor P).comp_ofCurve`. Exact correspondence: this projects `Classical.choose_spec.1` from `IsAlbanese`, which is exactly the pointed-property field promised.

### `\lean{AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp}` (chapter: `thm:exists_unique_ofCurve_comp`)
- **Lean target exists**: yes (`AbelJacobi.lean:82`).
- **Signature matches**: yes, modulo one prose-vs-Lean cosmetic difference (see notes). Lean asks for `{A : Over (Spec (.of k))} [Smooth A.hom] [IsProper A.hom] [GrpObj A] [GeometricallyIrreducible A.hom]` — i.e. `A` is a smooth proper group object that is geometrically irreducible over `k`. Blueprint pins "abelian variety over $k$ — i.e.\ a smooth proper geometrically irreducible group scheme over $k$" — verbatim match.  Existence/uniqueness shape `∃! (g : Jacobian C ⟶ A), f = ofCurve P ≫ g` matches blueprint `\exists ! g, f = \alpha_P \circ g`.
- **Proof follows sketch**: yes. Blueprint "Lean closure" paragraph promises "project[ing] this universal-property field of the Albanese witness … applied to the data $(f, hf)$". Lean: `((jacobianWitness C).isAlbaneseFor P).exists_unique_ofCurve_comp f hf` — verbatim. The blueprint's separate "Classical description" paragraph correctly disclaims that the genus-0 rigidity / Pic-scheme route is not replayed in Lean (it is bundled into `nonempty_jacobianWitness`).
- **notes**: minor prose discrepancy: the chapter says "unique **group-scheme** morphism $g$", but the Lean's `∃!` ranges over arbitrary morphisms `Jacobian C ⟶ A` in `Over (Spec k)` (matching the definition `IsAlbanese` in `Jacobian.lean:57-63`). For abelian varieties these coincide by Mumford's rigidity ("a morphism of abelian varieties sending $0$ to $0$ is a group homomorphism"), and the Lean statement is in fact strictly stronger as a universal property (uniqueness in a larger candidate set). This convention is internally consistent with the `IsAlbanese` predicate definition and with how the Albanese property is bundled in `JacobianWitness.isAlbaneseFor`, so it is not a Lean-side error; flagging it as a minor adequacy item below.

## Red flags

No `sorry`, no `:= True`, no `:= rfl` standing in for a substantive proof, no `axiom`, no `Classical.choice` invocation, no `-- TODO`, no `-- placeholder`, no `-- temporary`, no excuse-comments anywhere in `AbelJacobi.lean`. The file is clean.

(All `Classical.choice` use is upstream in `Jacobian.lean`'s `jacobianWitness := Classical.choice (nonempty_jacobianWitness C)` and in `IsAlbanese.ofCurve := Classical.choose h`. The blueprint authorises both: `thm:nonempty_jacobianWitness` is the single deferred existence hypothesis explicitly named, and the universal property in `def:IsAlbanese` is an existential whose witness `\alpha_P` is precisely the choice.)

## Unreferenced declarations (informational)

None. The file contains exactly three top-level declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`); each maps 1-to-1 to a `\lean{...}` block in the chapter.

## Blueprint adequacy for this file

- **Coverage**: 3/3 Lean declarations have a corresponding `\lean{...}` block in the chapter. 0 substantive helpers unreferenced.
- **Proof-sketch depth**: adequate. Each of `def:ofCurve` / `lem:comp_ofCurve` / `thm:exists_unique_ofCurve_comp` carries a precise "Lean closure" prose that names the Albanese structure field being projected (`\iota_P` / "pointed-property field" / "universal-property field"), which matches exactly the four-line projection idiom (`letI`-unbundle-instances + `exact ((jacobianWitness C).isAlbaneseFor P).<field> …`) used in the Lean. A prover could have written this file directly from the chapter prose.
- **Hint precision**: precise. Each `\lean{...}` names a fully-qualified protected declaration that matches `archon-protected.yaml` (`AlgebraicGeometry.Jacobian.ofCurve` / `.comp_ofCurve` / `.exists_unique_ofCurve_comp`). The chapter pins specific Mathlib predicates by name in the abelian-variety unfolding ("smooth proper geometrically irreducible group scheme"), matching `[Smooth] [IsProper] [GeometricallyIrreducible] [GrpObj]` in Lean.
- **Generality**: matches need. The chapter does NOT define `\alpha_P` via the Pic-scheme line-bundle route (that route is deliberately quarantined in `remark` blocks `rem:ofCurve_classical` and `rem:comp_ofCurve_classical`), so there is no Pic-vs-Albanese drift forcing a parallel API. The Lean is the canonical Albanese projection and the chapter front-matter says so: "every block in this chapter [closes] by a single projection from the Albanese structure". This is the iter-117 fix landing successfully.
- **Recommended chapter-side actions**:
  - (minor / optional) In `thm:exists_unique_ofCurve_comp`, the prose says "unique group-scheme morphism $g$" while the Lean `∃!` ranges over all morphisms `Jacobian C ⟶ A` in `Over (Spec k)`. The two are equivalent by Mumford's rigidity for abelian varieties, but a one-sentence remark stating that this equivalence is implicit (or that the Lean adopts the stronger "all morphisms" formulation matching `IsAlbanese`) would tighten the prose-vs-Lean fit. Non-blocking.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - Prose-vs-Lean: `thm:exists_unique_ofCurve_comp` says "group-scheme morphism" where the Lean `∃!` ranges over arbitrary morphisms (equivalent by rigidity; matches the `IsAlbanese` definition). One-sentence clarifying remark would tighten the chapter.

**Overall verdict**: the iter-117 chapter rewrite successfully tracks what the Lean actually does — every block leads with the Albanese-projection content matching the four-line Lean idiom `((jacobianWitness C).isAlbaneseFor P).<field>`, and the classical Pic^0 / line-bundle prose is correctly relegated to `remark` blocks that the Lean does not consume.
