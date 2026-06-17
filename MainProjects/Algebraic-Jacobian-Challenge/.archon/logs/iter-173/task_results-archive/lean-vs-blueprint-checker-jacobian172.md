# Lean ↔ Blueprint Check Report

## Slug
jacobian172

## Iteration
172

## Files audited
- Lean: `AlgebraicJacobian/Jacobian.lean`
- Blueprint: `blueprint/src/chapters/Jacobian.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.IsAlbanese}` (chapter: `def:IsAlbanese`)
- **Lean target exists**: yes (`AlgebraicGeometry.IsAlbanese` at L71).
- **Signature matches**: yes — `def IsAlbanese (C : Over (Spec (.of k))) (P : 𝟙_ _ ⟶ C) (J : Over (Spec (.of k))) [GrpObj J] [IsProper J.hom] [Smooth J.hom] [GeometricallyIrreducible J.hom] : Prop` carries the four AV typeclass binders on `J` as the blueprint's `rem:IsAlbanese_typeclasses` requires.
- **Proof follows sketch**: N/A (definition).
- **notes**: ✓

### `\lean{AlgebraicGeometry.IsAlbanese.ofCurve}` (chapter: `def:IsAlbanese_ofCurve`)
- **Lean target exists**: yes (L81).
- **Signature matches**: yes — `Classical.choose h` on the existential body matches the chapter prose verbatim.
- **Proof follows sketch**: N/A.
- **notes**: ✓

### `\lean{AlgebraicGeometry.IsAlbanese.comp_ofCurve}` (chapter: `lem:IsAlbanese_comp_ofCurve`)
- **Lean target exists**: yes (L86).
- **Signature matches**: yes (`P ≫ h.ofCurve = η[J]`).
- **Proof follows sketch**: yes — `(Classical.choose_spec h).1`.
- **notes**: ✓

### `\lean{AlgebraicGeometry.IsAlbanese.exists_unique_ofCurve_comp}` (chapter: `lem:IsAlbanese_exists_unique_ofCurve_comp`)
- **Lean target exists**: yes (L92).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `(Classical.choose_spec h).2`.
- **notes**: ✓

### `\lean{AlgebraicGeometry.IsAlbanese.unique}` (chapter: `thm:IsAlbanese_unique`)
- **Lean target exists**: yes (L102).
- **Signature matches**: yes — produces `∃! e, h₂.ofCurve = h₁.ofCurve ≫ e`. `rem:IsAlbanese_unique_iso` already records that the Lean body computes the inverse but doesn't expose it in the conclusion; that loose end is documented, not hidden.
- **Proof follows sketch**: yes — the universal-property zig-zag the chapter describes.
- **notes**: ✓

### `\lean{AlgebraicGeometry.JacobianWitness}` (chapter: `def:JacobianWitness`)
- **Lean target exists**: yes (L157).
- **Signature matches**: yes — seven fields `J / grpObj / proper / smooth / geomIrred / smoothGenus / isAlbaneseFor` as enumerated in the blueprint; `isAlbaneseFor : ∀ P, IsAlbanese …` matches `rem:JacobianWitness_quantifier_order`.
- **Proof follows sketch**: N/A (structure).
- **notes**: ✓

### `\lean{AlgebraicGeometry.genusZeroWitness}` (chapter: `def:genusZeroWitness`, §`sec:genusZeroWitness`)
- **Lean target exists**: yes (L198, `noncomputable def genusZeroWitness …`).
- **Signature matches**: yes — `(C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom] (h : genus C = 0) : JacobianWitness C`, witness object `𝟙_` (= `Spec k`), `smoothGenus` rewritten via `h`. Matches the blueprint enumeration.
- **Proof follows sketch**: partial — non-sorry fields (`J`, `grpObj`, `proper`, `smooth`, `geomIrred`, `smoothGenus`, the pointed-condition leg, and the uniqueness epi-cancellation) mirror the blueprint proof. The sole substantive `sorry` is the `key : f = toUnit C ≫ η[A]` step (L235–L236), which is exactly the "consume `rigidity_genus0_curve_to_grpScheme` over `k̄` + descend to `k`" step the blueprint identifies in C.2.d–f and in the proof at L564.
- **notes**: The iter-172 refreshed docstring (L176–L197) accurately describes route C: it pins `AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme` as the upstream consumer (this is the blueprint's `thm:rigidity_genus0_curve_to_AV`; cross-verified — the blueprint's `\lean{…}` tag at `AbelianVarietyRigidity.tex` L1701 maps the label to that exact Lean name), and notes char-free / route-C / iter-163, all of which match the chapter prose. The `Status (iter-172)` block ("`key` body remains `sorry`; rigidity consumer exists; propagates upstream sorries from the iter-171 body skeleton in `Genus0BaseObjects.lean`; closes once (i) `Genus0BaseObjects` internal sorries discharge and (ii) the `k → k̄` pullback / descent step is filled") is consistent with the blueprint's body-closure-status paragraph at `def:genusZeroWitness` L568 and the C.2.f descent paragraph at L498–L504.

### `\lean{AlgebraicGeometry.positiveGenusWitness}` (chapter: `def:positiveGenusWitness`)
- **Lean target exists**: yes (L270, body `:= sorry`).
- **Signature matches**: yes.
- **Proof follows sketch**: N/A — out of scope this iter (no body change).
- **notes**: ✓ (untouched this iter, included for completeness).

### `\lean{AlgebraicGeometry.nonempty_jacobianWitness}` (chapter: `thm:nonempty_jacobianWitness`)
- **Lean target exists**: yes (L300).
- **Signature matches**: yes — `Nonempty (JacobianWitness C)`.
- **Proof follows sketch**: yes — iter-135 `by_cases h : genus C = 0` body restructure delegating to `genusZeroWitness` / `positiveGenusWitness`, exactly as the blueprint's "Iter-135 body restructure" paragraph (L527) describes.
- **notes**: ✓

### `\lean{AlgebraicGeometry.Jacobian}` (chapter: `def:Jacobian`)
- **Lean target exists**: yes (L326).
- **Signature matches**: yes — `(jacobianWitness C).J`.
- **notes**: ✓

### `\lean{AlgebraicGeometry.Jacobian.instGrpObj}` / `…smoothOfRelativeDimension_genus` / `…instIsProper` / `…instGeometricallyIrreducible`
- **Lean targets exist**: yes (L336, L340, L344, L347).
- **Signatures match**: yes — each is a projection from the witness as the blueprint's four projection-theorem proofs say (L139, L171, L195, L225).
- **notes**: ✓

## Red flags

(None this iter on the audit-scope items. The sole remaining `sorry` — `genusZeroWitness.key` at L235 — is explicitly authorised by the directive's "Out of scope" clause and by the blueprint's "Body closure status" paragraph at L568; it is not a placeholder-on-substantive-claim violation but a properly gated WIP.)

## Unreferenced declarations (informational)

- `geometricallyIrreducible_id_Spec` (L134) — helper, mentioned by name in the blueprint prose at L556 ("project-local helper `AlgebraicGeometry.geometricallyIrreducible_id_Spec`") but without a `\lean{…}` block, which is acceptable for a small Lean-side instance helper. **Stale line-number reference**: the blueprint prose cites "AlgebraicJacobian/Jacobian.lean:120--126" but the helper now sits at L134–L140. Cosmetic — not a `\lean{…}` pin, so plastex is unaffected.
- `jacobianWitness` (L310) — `Classical.choice` extractor; legitimately helper-only (the blueprint never names it).

## Blueprint adequacy for this file

A bidirectional check: does the blueprint chapter give a prover enough detail to formalize this file correctly?

- **Coverage**: 12/12 substantive Lean declarations have a corresponding `\lean{…}` block. Unreferenced declarations: 2 helpers (`geometricallyIrreducible_id_Spec`, `jacobianWitness`), both acceptable.
- **Proof-sketch depth**: adequate for everything outside the open `genusZeroWitness.key` substep, which is downstream of `AbelianVarietyRigidity.tex`'s keystone and routed there explicitly. The chapter's C.2.f descent paragraph (L498–L504) and the body-closure-status paragraph at `def:genusZeroWitness` (L564–L568) give the prover the full ingredient list (base-change functor, instance transfer, genus stability, base-change-square identities, terminal epi-cancellation via `Flat.epi_of_flat_of_surjective`).
- **Hint precision**: precise — every `\lean{…}` block names a fully-qualified Lean target that matches the Lean side. Cross-file pin from `thm:rigidity_genus0_curve_to_AV` to `AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme` verified.
- **Generality**: matches need — the bundled `JacobianWitness` reverses the classical `∀P, ∃J` quantifier order to `∃J, ∀P` exactly as the Lean consumer requires (`Jacobian.ofCurve P` projects per-`P` Albanese data from one shared `J`).
- **Recommended chapter-side actions**:
  - **(major, see below)** Reconcile the bypass-claim prose in §"Route A — per-sub-phase LOC and iter budget" and §"Mathlib-prerequisite cascade for Route A" with the iter-172 audit conclusion now captured under §"Route A.4". As written, the chapter contradicts itself.
  - **(minor)** Refresh the stale `AlgebraicJacobian/Jacobian.lean:120--126` line-number reference at L556 to L134--L140.

### Blueprint adequacy red flag — Audit (B): bypass-FAILS contradicts surviving bypass-holds prose

The directive Audit (B) asks whether the chapter still carries any prose claiming the A.4 bypass holds — i.e. A.4 iters-left $\sim 7$–$11$ without the dual-figure caveat that Theorem 3.2 / Lemma 3.3 is an unscheduled Mathlib build-out. **Answer: yes, in three locations.** The chapter is internally inconsistent: the iter-172 audit's "outcome (b) — bypass FAILS" is captured under §`sec:Jacobian_routeA4_albaneseUP` (the `% NOTE` at L574–L602 and the dependency audit inside the proof of `thm:albanese_universal_property` at L641–L657), but the pre-audit bypass-holds prose was left in three earlier paragraphs:

- **L344** ("`\emph{Mathlib status for Route A}`" itemisation): "Sub-step A.4 requires the universal property of $\Pic^0_{C/k}$, which is the classical Albanese functoriality and is not in Mathlib in this form. (See per-sub-phase budget below: $\sim 900$–$1200$ LOC, $\sim 7$–$11$ iters.)" — no Thm 3.2 / Lemma 3.3 caveat.
- **L384–L390** ("`(A.4)` Albanese universal property"): "Net new project material: $\sim 900$–$1200$ LOC. Iters: $\sim 7$–$11$. Milne Proposition~6.1 / 6.4. Reuses the proven Rigidity Lemma + Cor 1.2 + Cor 1.5 from the genus-$0$ stack (already in tree, axiom-clean per iter-162); the remaining work is Picard-functor functoriality + the seesaw / Albanese-UP arguments Milne~\S III.6 covers in $\sim 3$ pages. Char-free." — directly states the bypass.
- **L425–L427** ("Mathlib-prerequisite cascade for Route A" itemisation): "(A.4) $\to$ no new Mathlib namespace; reuses `AlgebraicJacobian.AbelianVarietyRigidity` (in tree, axiom-clean) + Mathlib's Albanese-style universal property machinery."

These three paragraphs directly contradict L656 of the same chapter: "The STRATEGY.md A.4 row claim ``no new Mathlib namespace'' is incorrect with respect to this Lemma~3.3 sub-build; the planner should re-estimate A.4 with the codim-$1$ extension treated as an explicit upstream piece." A planner reading the chapter top-to-bottom would see the optimistic $\sim 7$–$11$-iter estimate first and only encounter the contradiction inside the `thm:albanese_universal_property` proof. Severity: **major** (not must-fix-this-iter) because both readings are present and the audit block explicitly flags the inconsistency; downstream planner code that already routes through STRATEGY.md is the load-bearing decision point, not these prose blocks. But this is exactly the "blueprint is the failure" pattern lean-vs-blueprint-checker exists to flag: the chapter does not yet give a prover (or a planner) a single internally-consistent picture of A.4's cost.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: blueprint internal inconsistency — three paragraphs (L344, L384–L390, L425–L427) still carry pre-audit "A.4 bypass-holds / no new Mathlib namespace" prose that the iter-172 audit at L574–L602 + L656 explicitly refutes. Audit-(B) flag.
- **minor**: stale line-number reference at L556 ("`AlgebraicJacobian/Jacobian.lean:120--126`" → current L134–L140) for `geometricallyIrreducible_id_Spec`. Cosmetic.

Overall verdict: **Lean ↔ blueprint alignment on `genusZeroWitness` and `nonempty_jacobianWitness` is sound this iter — the iter-172 docstring refresh accurately reflects the Route C path the chapter prescribes; the only deficiency is a blueprint-side internal inconsistency (major) in the §Route A budget paragraphs that the next blueprint-writer pass should reconcile with the iter-172 A.4 audit.**
