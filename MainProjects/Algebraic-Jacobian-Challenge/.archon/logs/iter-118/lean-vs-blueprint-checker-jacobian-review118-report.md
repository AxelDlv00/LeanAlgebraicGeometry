# Lean ↔ Blueprint Check Report

## Slug
jacobian-review118

## Iteration
118

## Files audited
- Lean: `AlgebraicJacobian/Jacobian.lean`
- Blueprint: `blueprint/src/chapters/Jacobian.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.IsAlbanese}` (chapter: def:IsAlbanese)
- **Lean target exists**: yes (line 57)
- **Signature matches**: yes (the four "smooth proper geometrically irreducible group scheme" hypotheses on `J` are encoded as `[GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom]`; same four conditions are placed on the universal-property target `A` as typeclass binders). Remark `rem:IsAlbanese_typeclasses` correctly documents the typeclass-vs-conjunct encoding choice.
- **Proof follows sketch**: N/A (definition)
- **notes**: The blueprint prose says the factoring morphism `g : J → A` is "a morphism of group schemes", while the Lean conclusion takes `g : J ⟶ A` (a morphism in the over-category, i.e. of `k`-schemes). Mathematically the Lean formulation is the standard / slightly stronger universal property (uniqueness among all scheme morphisms implies uniqueness among group-scheme morphisms; classical rigidity guarantees the produced `g` is automatically a group homomorphism). Not a substantive divergence, but the prose-vs-Lean wording could be tightened.

### `\lean{AlgebraicGeometry.IsAlbanese.ofCurve}` (chapter: def:IsAlbanese_ofCurve)
- **Lean target exists**: yes (line 67)
- **Signature matches**: yes (`C ⟶ J` extracted from the existential body of an `IsAlbanese` term)
- **Proof follows sketch**: yes (body is `Classical.choose h`, exactly as the blueprint specifies)
- **notes**: —

### `\lean{AlgebraicGeometry.IsAlbanese.comp_ofCurve}` (chapter: lem:IsAlbanese_comp_ofCurve)
- **Lean target exists**: yes (line 72)
- **Signature matches**: yes (`P ≫ h.ofCurve = η[J]`)
- **Proof follows sketch**: yes (`(Classical.choose_spec h).1`)
- **notes**: —

### `\lean{AlgebraicGeometry.IsAlbanese.exists_unique_ofCurve_comp}` (chapter: lem:IsAlbanese_exists_unique_ofCurve_comp)
- **Lean target exists**: yes (line 78)
- **Signature matches**: yes (`∃! (g : J ⟶ A), f = h.ofCurve ≫ g` with the four typeclass hypotheses on `A`)
- **Proof follows sketch**: yes (`(Classical.choose_spec h).2 f hf`)
- **notes**: Same minor prose drift on "morphism of group schemes" vs Lean's `J ⟶ A` as noted on `IsAlbanese`.

### `\lean{AlgebraicGeometry.IsAlbanese.unique}` (chapter: thm:IsAlbanese_unique)
- **Lean target exists**: yes (line 88)
- **Signature matches**: yes (`∃! (e : J₁ ⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e`)
- **Proof follows sketch**: yes. The Lean proof exactly matches the description in remark `rem:IsAlbanese_unique_iso`: produces `g : J₁ ⟶ J₂` and `h : J₂ ⟶ J₁`, computes the two self-factorisations `g₁` of `h₁.ofCurve` and `k₂` of `h₂.ofCurve`, identifies each with the identity via the uniqueness clause, then derives `g ≫ h = 𝟙 J₁` and `h ≫ g = 𝟙 J₂`. Returns only `⟨g, hg_eq, hg_unique⟩` — the invertibility witnesses are computed but not retained in the return type, exactly as documented.
- **notes**: —

### `\lean{AlgebraicGeometry.JacobianWitness}` (chapter: def:JacobianWitness)
- **Lean target exists**: yes (line 143)
- **Signature matches**: yes. All seven fields enumerated in the blueprint are present with matching names and types: `J : Over (Spec (.of k))`, `grpObj : GrpObj J`, `proper : IsProper J.hom`, `smooth : Smooth J.hom`, `geomIrred : GeometricallyIrreducible J.hom`, `smoothGenus : SmoothOfRelativeDimension (genus C) J.hom`, `isAlbaneseFor : ∀ (P : 𝟙_ _ ⟶ C), IsAlbanese C P J`. The quantifier-reversal design (single `J` field, family-valued `isAlbaneseFor`) is faithfully implemented and adequately motivated in remark `rem:JacobianWitness_quantifier_order`. The `smooth` / `smoothGenus` redundancy is explicitly justified in remark `rem:JacobianWitness_smooth_redundancy`.
- **Proof follows sketch**: N/A (structure)
- **notes**: The Lean records the `isAlbaneseFor` field with explicit `@`-elaboration to thread `grpObj`, `proper`, `smooth`, `geomIrred` to the `IsAlbanese` typeclass binders. The blueprint correctly anticipates this in the typeclass-encoding remark.

### `\lean{AlgebraicGeometry.nonempty_jacobianWitness}` (chapter: thm:nonempty_jacobianWitness)
- **Lean target exists**: yes (line 176)
- **Signature matches**: yes (`Nonempty (JacobianWitness C)` under the same three typeclass hypotheses as the curve binder)
- **Proof follows sketch**: N/A — body is `sorry`, **explicitly authorised** as the project's single deferred foundational hypothesis. The blueprint's `\begin{proof}` block does NOT claim a proof is in place: it presents three classical routes (Picard scheme / symmetric powers + Stein / genus-0 rigidity), inventories the missing Mathlib infrastructure for each, and concludes "the existence statement is recorded here as the project's single explicit foundational hypothesis". The Lean `sorry` is therefore the formal counterpart of an admitted hypothesis, not a missing proof.
- **notes**: Directive explicitly authorises this sorry; not a red flag. The Lean doc-string and the blueprint converge cleanly on naming this as the single Phase-C foundational hypothesis.

### `\lean{AlgebraicGeometry.Jacobian}` (chapter: def:Jacobian)
- **Lean target exists**: yes (line 199)
- **Signature matches**: yes (`Over (Spec (.of k))`, defined as `(jacobianWitness C).J`)
- **Proof follows sketch**: yes — the definition is exactly the underlying scheme of the chosen Albanese witness, as the blueprint specifies ("Formally, Jac(C) is defined as the underlying scheme of a (uniform-over-P) Albanese witness for C provided by Theorem thm:nonempty_jacobianWitness").
- **notes**: The "forbidden-shortcut" doc-block on lines 30–38 of `Jacobian.lean` is a nice formal-side sanity check that aligns with the blueprint's design discussion.

### `\lean{AlgebraicGeometry.Jacobian.instGrpObj}` (chapter: thm:Jacobian_grpObj)
- **Lean target exists**: yes (line 209)
- **Signature matches**: yes (`GrpObj (Jacobian C)`)
- **Proof follows sketch**: yes (`(jacobianWitness C).grpObj`). The blueprint proof says "Jac(C) inherits it by projection" of the `grpObj` field, and elaborates the mathematical content via the universal-property construction of the multiplication map. The Lean is exactly the projection step; the mathematical justification of why the witness exists is the content of `thm:nonempty_jacobianWitness`.
- **notes**: —

### `\lean{AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus}` (chapter: thm:Jacobian_smooth_genus)
- **Lean target exists**: yes (line 213)
- **Signature matches**: yes (`SmoothOfRelativeDimension (genus C) (Jacobian C).hom`)
- **Proof follows sketch**: yes (`(jacobianWitness C).smoothGenus`). Matches the blueprint proof's first paragraph ("The Lean formalisation projects the field `smoothGenus`…").
- **notes**: —

### `\lean{AlgebraicGeometry.Jacobian.instIsProper}` (chapter: thm:Jacobian_proper)
- **Lean target exists**: yes (line 217)
- **Signature matches**: yes (`IsProper (Jacobian C).hom`)
- **Proof follows sketch**: yes (`(jacobianWitness C).proper`).
- **notes**: —

### `\lean{AlgebraicGeometry.Jacobian.instGeometricallyIrreducible}` (chapter: thm:Jacobian_geomIrred)
- **Lean target exists**: yes (line 220)
- **Signature matches**: yes (`GeometricallyIrreducible (Jacobian C).hom`)
- **Proof follows sketch**: yes (`(jacobianWitness C).geomIrred`).
- **notes**: —

## Red flags

### Placeholder / suspect bodies
- `AlgebraicGeometry.nonempty_jacobianWitness` at line 179: body is `sorry`. **Pre-disclosed in the directive's "Known issues"** as the project's single foundational hypothesis, and the blueprint's existence-section explicitly treats this as an admitted hypothesis (routes A, B, and the genus-0 sub-case are inventoried with a per-step Mathlib-status verdict, all concluding "missing"). Not classified as fake content per the directive.

(No other placeholders, axioms, or `Classical.choice _` patterns on substantive claims appear in the file. The two uses of `Classical.choose` / `Classical.choose_spec` in `IsAlbanese.ofCurve` / `comp_ofCurve` / `exists_unique_ofCurve_comp` are the standard idiomatic extraction from an existential and are exactly what the blueprint's `def:IsAlbanese_ofCurve` block specifies.)

### Excuse-comments
None. Doc-comments are crisp and aligned with the blueprint design; the "Forbidden shortcut (sanity check)" preamble at lines 30–38 is a positive design note rather than an excuse.

### Axioms / Classical.choice on non-trivial claims
- `jacobianWitness` (line 184) uses `Classical.choice (nonempty_jacobianWitness C)` to extract the witness; this is unobjectionable given that the existence is the deliberate admitted hypothesis. Not a red flag.

## Unreferenced declarations (informational)

- `AlgebraicGeometry.geometricallyIrreducible_id_Spec` (line 120). Helper lemma showing `GeometricallyIrreducible (𝟙 (Spec (.of k)))`. The doc-comment claims it is "needed for the genus-0 case of `Jacobian`", but a project-wide grep shows it has no callers in this file or anywhere else in the project — the current witness-based `Jacobian` definition absorbs the genus-0 case into `nonempty_jacobianWitness` and does not invoke this helper. **Minor:** the lemma is dead code in this iteration. Either delete or wire into the genus-0 branch of a future explicit construction.
- `AlgebraicGeometry.jacobianWitness` (line 184, `noncomputable def`). Helper that calls `Classical.choice (nonempty_jacobianWitness C)`. Used by all four `Jacobian.*` projection instances in this file and by `AbelJacobi.lean`. Not `\lean{...}`-tagged in the chapter, but the blueprint prose of the proof of `thm:Jacobian_grpObj` explicitly references it: "`jacobianWitness C` is the Albanese witness extracted from Theorem `thm:nonempty_jacobianWitness` via `Classical.choice`". Acceptable as an unreferenced extraction helper, though promoting it to its own blueprint definition block would be cleaner.

## Blueprint adequacy for this file

- **Coverage**: 12/14 Lean declarations have a corresponding `\lean{...}` block in the chapter. Unreferenced declarations: 1 substantive helper (`jacobianWitness` — referenced in prose but not via `\lean{...}`) + 1 dead helper (`geometricallyIrreducible_id_Spec`).
- **Proof-sketch depth**: **adequate**. The new "Extracting the universal morphism" subsection precisely matches the trio `ofCurve` / `comp_ofCurve` / `exists_unique_ofCurve_comp` and even names the `Classical.choose` / `Classical.choose_spec` pattern. Remark `rem:IsAlbanese_unique_iso` accurately describes the internal-inverse-but-not-returned structure of the Lean proof of `IsAlbanese.unique`. The four `Jacobian.*` projection proofs are stated as one-line projections in both blueprint and Lean, with parallel mathematical-content paragraphs that contextualise (but do not redundantly re-formalise) the trivial projection step. The existence theorem `nonempty_jacobianWitness` is appropriately backed by a multi-route proof sketch + Mathlib-status inventory, despite the Lean body being `sorry`.
- **Hint precision**: **precise**. Every `\lean{...}` names the fully qualified declaration; the chapter explicitly distinguishes `Smooth` vs `SmoothOfRelativeDimension (genus C)` in `JacobianWitness`'s field descriptions (per `rem:JacobianWitness_smooth_redundancy`); the `IsAlbanese` typeclass-encoding choice is documented in `rem:IsAlbanese_typeclasses` so the prover cannot inadvertently shift hypotheses from binders to conjuncts.
- **Generality**: **matches need**. The bundled-witness reformulation (with `isAlbaneseFor : ∀ P, IsAlbanese C P J`) exactly matches what the downstream `AbelJacobi` interface consumes, and the blueprint's quantifier-reversal remark articulates this design decision. No parallel API was written on the Lean side because the blueprint structure already covers the projected per-`P` interface.
- **Recommended chapter-side actions**:
  - (Minor) Tighten the universal-property prose of `def:IsAlbanese` and `lem:IsAlbanese_exists_unique_ofCurve_comp` to say "morphism of schemes (necessarily of group schemes by classical rigidity)" rather than "morphism of group schemes", to match Lean's `J ⟶ A` typing and make the standard equivalence explicit.
  - (Optional) Either promote `jacobianWitness` to its own `\lean{...}`-tagged definition block (since `AbelJacobi.lean` consumes it directly), or add a one-line `% NOTE:` in `def:Jacobian` clarifying that the `jacobianWitness C` helper is the projection underlying the four `Jacobian.*` instances. Either suffices for full coverage.

## Severity summary

- **must-fix-this-iter**: none. The sole `sorry` (`nonempty_jacobianWitness`) is explicitly authorised by the directive and by the blueprint, with appropriate justification on both sides; no placeholder bodies, no signature mismatches, no excuse-comments, no unauthorised axioms.
- **major**: none.
- **minor**:
  - Prose drift on `def:IsAlbanese` / `lem:IsAlbanese_exists_unique_ofCurve_comp`: "morphism of group schemes" in the blueprint vs `g : J ⟶ A` (scheme morphism) in Lean. Mathematically equivalent under classical rigidity; tighten prose for precision.
  - Dead helper `geometricallyIrreducible_id_Spec` at line 120: unused since the genus-0 case was absorbed into the witness. Either delete or wire into a future explicit-construction branch.
  - `jacobianWitness` lacks a `\lean{...}` block of its own (only mentioned in prose).

Overall verdict: Lean and blueprint are in mutual agreement on the `Jacobian` / `IsAlbanese` / `JacobianWitness` surface; the Fix 1+2+3 tightening of `thm:IsAlbanese_unique`, the new "Albanese witness bundle" subsection (`def:JacobianWitness` with all 7 fields enumerated and the two redundancy/quantifier-order remarks), and the new "Extracting the universal morphism" subsection (with `\lean{...}` for `ofCurve`/`comp_ofCurve`/`exists_unique_ofCurve_comp`) all faithfully match the current Lean file, and only minor prose-precision items remain.
