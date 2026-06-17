# Lean ↔ Blueprint Check Report

## Slug
jacobian-review135

## Iteration
135

## Files audited
- Lean: `AlgebraicJacobian/Jacobian.lean`
- Blueprint: `blueprint/src/chapters/Jacobian.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.IsAlbanese}` (def:IsAlbanese, chapter line 28)
- **Lean target exists**: yes (`Jacobian.lean:71`)
- **Signature matches**: yes — the four abelian-variety conditions on `J` (`GrpObj`, `IsProper`, `Smooth`, `GeometricallyIrreducible`) sit on typeclass binders of the def, and the body is the existential `∃ α : C ⟶ J, P ≫ α = η[J] ∧ ∀ {A …} f hf, ∃! g, f = α ≫ g`, exactly as `rem:IsAlbanese_typeclasses` prescribes.
- **Proof follows sketch**: N/A (definition).
- **notes**: encoding matches `rem:IsAlbanese_typeclasses` faithfully.

### `\lean{AlgebraicGeometry.IsAlbanese.ofCurve}` (def:IsAlbanese_ofCurve, line 47)
- **Lean target exists**: yes (`Jacobian.lean:81`)
- **Signature matches**: yes — `Classical.choose h : C ⟶ J`, as the blueprint specifies.
- **Proof follows sketch**: yes — `Classical.choose` extraction, matches prose.
- **notes**: none.

### `\lean{AlgebraicGeometry.IsAlbanese.comp_ofCurve}` (lem:IsAlbanese_comp_ofCurve, line 61)
- **Lean target exists**: yes (`Jacobian.lean:86`)
- **Signature matches**: yes — `P ≫ h.ofCurve = η[J]`.
- **Proof follows sketch**: yes — `(Classical.choose_spec h).1`.
- **notes**: none.

### `\lean{AlgebraicGeometry.IsAlbanese.exists_unique_ofCurve_comp}` (lem:IsAlbanese_exists_unique_ofCurve_comp, line 74)
- **Lean target exists**: yes (`Jacobian.lean:92`)
- **Signature matches**: yes — `∃! (g : J ⟶ A), f = h.ofCurve ≫ g` for `f : C ⟶ A` with `P ≫ f = η[A]`.
- **Proof follows sketch**: yes — `(Classical.choose_spec h).2 f hf`.
- **notes**: none.

### `\lean{AlgebraicGeometry.IsAlbanese.unique}` (thm:IsAlbanese_unique, line 84)
- **Lean target exists**: yes (`Jacobian.lean:102`)
- **Signature matches**: yes — `∃! (e : J₁ ⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e`, matching the weaker conclusion explicitly authorised by `rem:IsAlbanese_unique_iso`.
- **Proof follows sketch**: yes — the Lean tactic block constructs `g`, `h`, computes `g ≫ h = 𝟙 J₁` and `h ≫ g = 𝟙 J₂` as intermediate witnesses, and returns the `(g, hg_eq, hg_unique)` triple, matching the prose ("each of the two universal morphisms factors through the other, the two composites equal the unique self-factorisation id … invertibility witnesses are computed as intermediate lemmas").
- **notes**: matches `rem:IsAlbanese_unique_iso` — invertibility witnesses computed but not retained in return type.

### `\lean{AlgebraicGeometry.JacobianWitness}` (def:JacobianWitness, line 204)
- **Lean target exists**: yes (`Jacobian.lean:157`)
- **Signature matches**: yes — seven fields `J`, `grpObj`, `proper`, `smooth`, `geomIrred`, `smoothGenus`, `isAlbaneseFor` exactly as enumerated in the blueprint definition. The `isAlbaneseFor` field carries the `∀ (P : 𝟙_ _ ⟶ C), IsAlbanese …` quantifier-reversed form authorised by `rem:JacobianWitness_quantifier_order`, and the `smooth`/`smoothGenus` redundancy matches `rem:JacobianWitness_smooth_redundancy`.
- **Proof follows sketch**: N/A (structure).
- **notes**: none.

### `\lean{AlgebraicGeometry.nonempty_jacobianWitness}` (thm:nonempty_jacobianWitness, line 242)
- **Lean target exists**: yes (`Jacobian.lean:249`)
- **Signature matches**: yes — `Nonempty (JacobianWitness C)` on a smooth proper geometrically irreducible curve.
- **Proof follows sketch**: yes — the iter-135 body restructure (`by_cases h : genus C = 0` ⇒ `⟨genusZeroWitness C h⟩` on the `h` branch, `⟨positiveGenusWitness C (Nat.pos_of_ne_zero h)⟩` on the `¬h` branch) matches blueprint paragraph "Iter-135 body restructure" (chapter line 376–377) and the chapter's Mathlib-infrastructure summary paragraph (γ) at line 372, both of which describe the case-split delegation to the two named scaffolds.
- **notes**: per the directive's "Known issues" list, the body restructure from inline `:= sorry` to `by_cases` is intentional and not a new sorry site; downstream `sorry`s now live in the two scaffolds.

### `\lean{AlgebraicGeometry.genusZeroWitness}` (def:genusZeroWitness, line 387)
- **Lean target exists**: yes (`Jacobian.lean:193`)
- **Signature matches**: yes — `(C) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] (h : genus C = 0) : JacobianWitness C`, matching the blueprint prose "with $\genus(C) = 0$ … there exists a JacobianWitness C".
- **Proof follows sketch**: N/A — body is `:= sorry` (acknowledged scaffold per directive; blueprint carries `\notready`).
- **notes**: blueprint proof block (lines 393–413) gives a thorough field-by-field sketch (underlying scheme = terminal object, terminal group-object structure, identity properness/smoothness, helper `geometricallyIrreducible_id_Spec`, `Nat.zero` rewrite of `smoothGenus`, terminal-map `α := toUnit C`, rigidity reduction to `thm:rigidity_over_kbar` for the universal factorisation, vacuity on `C(k) = ∅`); blueprint adequacy is excellent for this scaffold.

### `\lean{AlgebraicGeometry.positiveGenusWitness}` (def:positiveGenusWitness, line 422)
- **Lean target exists**: yes (`Jacobian.lean:219`)
- **Signature matches**: yes — `(C) […] (hg : 0 < genus C) : JacobianWitness C`. The Lean uses `0 < genus C : Prop`, equivalent to the blueprint's `\genus(C) \ge 1` (Nat-valued genus).
- **Proof follows sketch**: N/A — body is `:= sorry` (acknowledged scaffold per directive; blueprint carries `\notready`).
- **notes**: blueprint proof block (lines 428–440) recites the M3-route gap analysis (Route A α / Route B β with LOC estimates) and explicitly names the iter-135 load-bearing role of this scaffold.

### `\lean{AlgebraicGeometry.Jacobian}` (def:Jacobian, line 108)
- **Lean target exists**: yes (`Jacobian.lean:275`)
- **Signature matches**: yes — `Over (Spec (.of k))` returned, defined as `(jacobianWitness C).J`, matching prose "the underlying scheme of a (uniform-over-$P$) Albanese witness".
- **Proof follows sketch**: yes (definition body); definition matches the "underlying scheme of jacobianWitness" prose at line 110.
- **notes**: signature is protected (directive flag), not reformatted; the >100-char linter line at `Jacobian.lean:275` is intentional and skipped per directive.

### `\lean{AlgebraicGeometry.Jacobian.instGrpObj}` (thm:Jacobian_grpObj, line 122)
- **Lean target exists**: yes (`Jacobian.lean:285`)
- **Signature matches**: yes — `GrpObj (Jacobian C)` as a noncomputable instance projecting `(jacobianWitness C).grpObj`.
- **Proof follows sketch**: yes — the proof block (line 130) authorises projection from the witness; the mathematical Albanese-functoriality justification is in the second paragraph of the proof block.
- **notes**: none.

### `\lean{AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus}` (thm:Jacobian_smooth_genus, line 138)
- **Lean target exists**: yes (`Jacobian.lean:289`)
- **Signature matches**: yes — `SmoothOfRelativeDimension (genus C) (Jacobian C).hom` projecting `.smoothGenus`. Predicate name is the precise one pinned by the chapter prose.
- **Proof follows sketch**: yes — projection from witness, matching proof block at line 144–148.
- **notes**: none.

### `\lean{AlgebraicGeometry.Jacobian.instIsProper}` (thm:Jacobian_proper, line 154)
- **Lean target exists**: yes (`Jacobian.lean:293`)
- **Signature matches**: yes — `IsProper (Jacobian C).hom` projecting `.proper`.
- **Proof follows sketch**: yes — projection from witness.
- **notes**: none.

### `\lean{AlgebraicGeometry.Jacobian.instGeometricallyIrreducible}` (thm:Jacobian_geomIrred, line 170)
- **Lean target exists**: yes (`Jacobian.lean:296`)
- **Signature matches**: yes — `GeometricallyIrreducible (Jacobian C).hom` projecting `.geomIrred`.
- **Proof follows sketch**: yes — projection from witness.
- **notes**: none.

## Red flags

(No findings beyond the directive's pre-known scaffold sorries on `genusZeroWitness` / `positiveGenusWitness`, which are not to be re-reported.)

No `axiom` declarations. No `:= True`, `:= rfl`-on-non-trivial, suspicious `Classical.choice` (only the standard `Classical.choice (nonempty_jacobianWitness C)` extraction pattern from a `Nonempty` proof). No excuse-comments such as "TODO replace", "wrong but works", or "temporary". The Phase-C status header (lines 13–53) and the per-scaffold docstring status paragraphs (lines 186–192, 210–218, 242–248) are workflow status notes documenting the iter-127 / iter-134 / iter-135 scaffold structure and forbidden-shortcut sanity check — informational, not red flags.

## Unreferenced declarations (informational)

- `AlgebraicGeometry.geometricallyIrreducible_id_Spec` (`Jacobian.lean:134`) — small helper for the genus-0 case of `Jacobian`. The blueprint prose explicitly references it (chapter line 400, in the `def:genusZeroWitness` proof block) as `AlgebraicGeometry.geometricallyIrreducible_id_Spec`. No standalone `\lean{...}` block, but this is an acceptable helper-only inline citation, not a coverage gap.
- `AlgebraicGeometry.jacobianWitness` (`Jacobian.lean:259`) — `Classical.choice (nonempty_jacobianWitness C)` extractor, used by `Jacobian` and the four protected instances to project per-field. Pure bookkeeping; the existence content lives in `nonempty_jacobianWitness`, which has a `\lean{...}` block. Acceptable helper.

## Blueprint adequacy for this file

- **Coverage**: 14/14 `\lean{...}`-tagged blocks map to existing Lean declarations with matching signatures. Two helper declarations (`geometricallyIrreducible_id_Spec`, `jacobianWitness`) have no `\lean{...}` block; one is referenced inline in prose, the other is pure bookkeeping. Coverage is essentially complete.
- **Proof-sketch depth**: **adequate** for every block, including the new `def:genusZeroWitness` and `def:positiveGenusWitness` proof blocks introduced this iteration. The `genusZeroWitness` proof sketch (chapter lines 393–413) gives a field-by-field reduction including the rigidity entry-point at `thm:rigidity_over_kbar`, the universal-factorisation argument, and the vacuity branch on `C(k) = ∅`. The `positiveGenusWitness` proof block (lines 428–440) explicitly defers to the chapter's main `thm:nonempty_jacobianWitness` proof for the Route-A/B decomposition. The main `thm:nonempty_jacobianWitness` proof (lines 247–378) contains the full Route-A / Route-B / genus-0 sub-case analysis with explicit Mathlib-status sections. The iter-135 body restructure paragraph (lines 376–377) records exactly the `by_cases` decomposition the Lean now exhibits.
- **Hint precision**: **precise**. Each `\lean{...}` block names the exact Mathlib-style declaration the file exposes; the `SmoothOfRelativeDimension (genus C)` predicate is pinned (not loosely "smooth"); the witness-bundle structure is named; both scaffolds are pinned to their genus hypothesis.
- **Generality**: **matches need**. The blueprint's choice of the witness-bundle indirection (with quantifier-reversal as documented in `rem:JacobianWitness_quantifier_order`) is exactly what the four `Jacobian.*` projections consume; the genus-stratified scaffold pair is exactly what the iter-135 `by_cases` body consumes.
- **Recommended chapter-side actions**: one minor item only —
  - Chapter line 400 cites `AlgebraicJacobian/Jacobian.lean:120--126` as the location of `geometricallyIrreducible_id_Spec`, but the helper is now at `Jacobian.lean:134--140` after iter-135 docstring growth shifted line numbers. Either drop the line-range citation or update it. **Minor**, not blocking.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**: stale line-range citation at chapter line 400 (cites `Jacobian.lean:120--126`, actual location is `134--140`); blueprint-side fix only.

Overall verdict: The iter-135 plan-phase refactor (body restructure of `nonempty_jacobianWitness` via `by_cases`, plus the new `positiveGenusWitness` subsection and updated proof block) is faithful, well-documented, and bidirectionally consistent — Lean and blueprint match cleanly with only a single minor line-range drift on a prose citation.
