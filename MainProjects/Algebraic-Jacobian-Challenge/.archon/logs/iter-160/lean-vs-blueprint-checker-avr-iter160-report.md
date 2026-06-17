# Lean ↔ Blueprint Check Report

## Slug
avr-iter160

## Iteration
160

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Summary of the three directive checks
- **(a) New sub-lemmas have no `\lean{}`/`\uses` coverage** — CONFIRMED missing. `morphism_eq_of_eqAt_closedPoints` and `rigidity_eqAt_closedPoint_of_proper_into_affine` are now top-level declarations but have no `\lean{...}` block anywhere in the chapter. **major** (coverage / missing references).
- **(b) Prose claims `[IsAlgClosed]` is the only added instance, but the Lean now needs finite-type/Jacobson** — CONFIRMED. The new in-body `:= sorry` at line 237 (a `JacobsonSpace U` instance) is a signature gap the blueprint does not authorize; the proof block nonetheless carries `\leanok` and the `dense_open` formalization-note claims `[IsAlgClosed kbar]` is the sole added instance. **must-fix-this-iter** (blueprint adequacy / under-specified hypothesis + unauthorized placeholder).
- **(c) Signature fidelity of `rigidity_eqOn_saturated_open_to_affine`** — the signature is faithful to the blueprint lemma statement (all hypotheses present and correctly typed). I cannot byte-compare against the prior iter's text (read-only, no diff requested), but nothing in the signature diverges from the chapter prose.

## Per-declaration

### `\lean{AlgebraicGeometry.rigidity_lemma}` (chapter: thm:rigidity_lemma)
- **Lean target exists**: yes (line 520).
- **Signature matches**: yes — `[IsProper X.hom]`, `[GeometricallyIrreducible (X⊗Y).hom]`, `[IsReduced (X⊗Y).left]`, `[IsSeparated Z.hom]`, collapse hyp `_hf`, conclusion `∃ g, f = snd ≫ g`. Matches Mumford Form I prose, including the iter-157 soundness-correcting instances.
- **Proof follows sketch**: yes — witness `g := lift (toUnit Y ≫ x₀) (𝟙 Y) ≫ f`, then `rigidity_snd_lift` + `rigidity_core`. Matches the decomposition in rmk:rigidity_lemma_decomposition.
- **notes**: transitive `sorry` via the chain (lines 151, 203) is honestly propagated; `\uses{lem:rigidity_eqOn_dense_open}` edge present.

### `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` (chapter: lem:rigidity_eqOn_dense_open)
- **Lean target exists**: yes (line 271).
- **Signature matches**: yes — carries the load-bearing collapse hyp `_hf`; conclusion is the existential non-empty open with the agreement equation. Matches prose (incl. the explicit "collapse hypothesis is load-bearing" / `f = fst` counterexample).
- **Proof follows sketch**: yes — Mumford's `U = X×V`, `G = p₂(f⁻¹(Z∖U₀))` construction; bridge 1 (`snd_left_isClosedMap`) for closedness of `G`; `_hf` ⟹ `y₀∉G` for non-emptiness; `hfib` fibre fact closed; delegates the agreement to `rigidity_eqOn_saturated_open_to_affine`. `\uses{lem:rigidity_eqOn_saturated_open_to_affine}` edge present.
- **notes**: this lemma's own body is `sorry`-free (confirmed: not in the diagnostic sorry list).

### `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}` (chapter: lem:rigidity_eqOn_saturated_open_to_affine)
- **Lean target exists**: yes (line 203).
- **Signature matches**: yes — `[IsAlgClosed kbar]`, `[IsProper X.hom]`, `[GeometricallyIrreducible (X⊗Y).hom]`, `[IsReduced (X⊗Y).left]`, `[IsSeparated Z.hom]`, `f`, `x₀`, saturated open `U` with `_hUV : U = (snd).base ⁻¹' Vset`, affine `U₀` with `_hU₀`, containment `_hfU`; conclusion `U.ι ≫ f.left = U.ι ≫ (lift (toUnit (X⊗Y) ≫ x₀) (snd) ≫ f).left`. This is exactly the chapter's "p₂-saturated open mapping into an affine" statement. **Signature faithful (check (c) PASS).**
- **Proof follows sketch**: PARTIAL — the body wires Step 2 (`morphism_eq_of_eqAt_closedPoints`) over Step 1 (`rigidity_eqAt_closedPoint_of_proper_into_affine`), matching the chapter's two-step proof. **BUT** the body contains an unadvertised `haveI : JacobsonSpace (U.toScheme) := sorry` (line 237), and the chapter proof block is marked `\leanok` (claims closed, no sorry). Diagnostic confirms line 203 "declaration uses `sorry`".
- **notes**: see Red flags — this is the signature-gap finding (b).

### `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` (chapter: prop:morphism_P1_to_AV_constant)
- **Lean target exists**: yes (line 554).
- **Signature matches**: yes — `ℙ¹` encoded as smooth-of-rel-dim-1 / proper / geom-irred genus-0 proxy; `A` an abelian-variety proxy; conclusion `∃ a₀, f = toUnit P1 ≫ a₀`.
- **Proof follows sketch**: N/A — body is `sorry` (pre-existing scaffold, blocked on theorem of the cube). **Exempt per directive** (do not flag).
- **notes**: `\uses{thm:rigidity_lemma, thm:theorem_of_the_cube}` edges present.

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (chapter: prop:genusZero_curve_iso_P1)
- **Lean target exists**: yes (line 578).
- **Signature matches**: yes — two genus-0 smooth proper geom-irred curves over `k̄`; conclusion `Nonempty (C ≅ P1)`.
- **Proof follows sketch**: N/A — body is `sorry` (Riemann–Roch sub-build). **Exempt per directive**.
- **notes**: `\uses{def:genus}` edge present.

### `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` (chapter: thm:rigidity_genus0_curve_to_AV)
- **Lean target exists**: yes (line 603).
- **Signature matches**: yes — mirrors `rigidity_over_kbar` minus `[CharZero]`; pointed hyp `p ≫ f = η[A]`; conclusion `f = toUnit C ≫ η[A]`.
- **Proof follows sketch**: N/A — body is `sorry` (headline scaffold). **Exempt per directive**.
- **notes**: `\uses{prop:morphism_P1_to_AV_constant, prop:genusZero_curve_iso_P1}` edges present.

### `thm:theorem_of_the_cube` (no `\lean{}`)
- Recorded as a deferred deep input with no Lean target. Correct — no obligation. N/A.

## Red flags

### Placeholder / suspect bodies
- `rigidity_eqOn_saturated_open_to_affine` at line 237: in-body `haveI : JacobsonSpace ((U : ...).toScheme) := sorry`. This is **not** the documented deep residual (that is the separate lemma `rigidity_eqAt_closedPoint_of_proper_into_affine`, line 151, called transitively). It is a **signature gap**: the lemma carries no finite-type / locally-of-finite-type hypothesis, so `JacobsonSpace U` (density of closed points) is undischargeable as the statement is currently typed. The chapter's proof block for `lem:rigidity_eqOn_saturated_open_to_affine` is marked `\leanok` (claims a complete proof) and Step 2 asserts "the closed points are dense in the locally-of-finite-type k̄-scheme U" as if automatic — but the formal statement never makes `U` locally of finite type. Per the verbatim severity rule (placeholder `:= sorry` on a declaration the blueprint claims substantive + blueprint under-specifies a load-bearing hypothesis), this is **must-fix-this-iter**.
  - The Lean comment (lines 227–236) already diagnoses this and proposes the fix: add `[LocallyOfFiniteType (X ⊗ Y).hom]` (hence `[JacobsonSpace (X ⊗ Y).left]`, inherited by the open `U`) to the chain. The blueprint must be updated to match (statement-side hypothesis), and the prover (or a signature change to the chain, currently noted as off-limits this iter) must thread it.

### Excuse-comments
- None that are improper. The lines 227–236 comment honestly labels the gap "SIGNATURE GAP ... the lone undischargeable input here" and explains the fix; this is a legitimate flag-to-planner note, not an excuse for wrong code. (Listed for transparency, not as a violation.)

### Axioms / Classical.choice on non-trivial claims
- None. No `axiom` declarations in the file.

## Unreferenced declarations (informational)

These Lean declarations have **no** `\lean{...}` block in the chapter:

- `rigidity_snd_lift` (line 66) — pure cartesian-monoidal algebra helper. Described in rmk:rigidity_lemma_decomposition prose. Helper; acceptable unreferenced, but worth a block (minor).
- `snd_left_isClosedMap` (line 85) — bridge 1, axiom-clean. Described in the dense_open proof prose ("Bridge 1 — BUILT"). Helper; acceptable, worth a block (minor).
- **`morphism_eq_of_eqAt_closedPoints`** (line 107) — **NEW this iter**, fully proven (sorry-free), the reusable "agree at dense closed points ⟹ equal" connective. Described in Step 2 of the `saturated_open` proof prose but **not** `\lean{}`-tagged. **major** (substantive declaration the blueprint should reference — directive check (a)).
- **`rigidity_eqAt_closedPoint_of_proper_into_affine`** (line 151) — **NEW this iter**, the deep Step-1 residual (`sorry`, exempt as deep geometry). Described in Step 1 of the `saturated_open` proof prose but **not** `\lean{}`-tagged. **major** (substantive declaration the blueprint should reference — directive check (a)).
- `rigidity_core` (line 438) — scheme-level gluing. Described in rmk:rigidity_lemma_decomposition. Helper; acceptable, worth a block (minor).

## Blueprint adequacy for this file

- **Coverage**: 6/11 substantive declarations have a `\lean{...}` block (the 6 named theorems/lemmas/props). Unreferenced: 4 helpers described in prose (`rigidity_snd_lift`, `snd_left_isClosedMap`, `rigidity_core` — acceptable as decomposition helpers) + **2 NEW top-level sub-lemmas that the prover explicitly extracted and asked be added** (`morphism_eq_of_eqAt_closedPoints`, `rigidity_eqAt_closedPoint_of_proper_into_affine`). The latter two are flagged — they are now first-class obligations (one fully proven, one the lone deep residual), so they merit `\lean{}` blocks with `\uses` edges from `lem:rigidity_eqOn_saturated_open_to_affine`.
- **Proof-sketch depth**: adequate for prose content (Step 1 / Step 2 of `saturated_open` map exactly onto the two new sub-lemmas), BUT **under-specified on hypotheses**: the prose treats `U` as locally of finite type / Jacobson without making it a stated hypothesis, while the formal chain signature provides no such instance — producing the line-237 `sorry`. The chapter must surface this as a required hypothesis.
- **Hint precision**: precise for the 6 tagged blocks; the `\lean{...}` targets all resolve to the correct declarations with matching signatures.
- **Generality**: matches need, with one exception — the chain lemma statements are **too weak** (missing the finite-type/Jacobson hypothesis the route-B globalisation demonstrably requires). This is the signature-gap.
- **Recommended chapter-side actions**:
  1. Add `\lean{AlgebraicGeometry.morphism_eq_of_eqAt_closedPoints}` and `\lean{AlgebraicGeometry.rigidity_eqAt_closedPoint_of_proper_into_affine}` blocks (or `\lean` references within `lem:rigidity_eqOn_saturated_open_to_affine`'s Step 1/Step 2), with `\uses` edges, so the dependency DAG and `\leanok` sync track them.
  2. Amend `lem:rigidity_eqOn_saturated_open_to_affine` (and the chain note in `lem:rigidity_eqOn_dense_open` that currently claims `[IsAlgClosed k̄]` is the *only* added instance) to state the **locally-of-finite-type / Jacobson hypothesis** explicitly as a required antecedent, matching the Lean comment's proposed `[LocallyOfFiniteType (X ⊗ Y).hom]` fix. The "this costs nothing downstream / IsAlgClosed is the only added instance" claim is now contradicted by the Lean.
  3. Until (2) lands, the `\leanok` on the `lem:rigidity_eqOn_saturated_open_to_affine` proof block is inaccurate (the body has a `sorry`); the deterministic `sync_leanok` phase should remove it — flagging here so the review agent does not re-add it.

## Severity summary

- **must-fix-this-iter**:
  - Blueprint adequacy / signature under-specification: `lem:rigidity_eqOn_saturated_open_to_affine` (and the `lem:rigidity_eqOn_dense_open` "only `[IsAlgClosed]` added" claim) omits the load-bearing finite-type/Jacobson hypothesis that the Lean demonstrably needs; the result is the unauthorized in-body `:= sorry` at line 237. Fix on both sides (blueprint hypothesis + Lean signature thread, per the chain's proposed `[LocallyOfFiniteType]`).
- **major**:
  - Two NEW substantive sub-lemmas (`morphism_eq_of_eqAt_closedPoints`, `rigidity_eqAt_closedPoint_of_proper_into_affine`) lack `\lean{...}` blocks / `\uses` edges (directive check (a)).
- **minor**:
  - Helpers `rigidity_snd_lift`, `snd_left_isClosedMap`, `rigidity_core` are prose-described but unreferenced by `\lean{}` (promotion optional).

**Not flagged (per directive):** the deep residual `sorry` at line 151 (`rigidity_eqAt_closedPoint_of_proper_into_affine`) and the pre-existing scaffolds at lines 554/578/603 (`morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`).

Overall verdict: Signatures of all 6 tagged blocks are faithful (check (c) passes), but the chapter under-specifies the finite-type/Jacobson hypothesis the Lean now needs (producing an unauthorized `sorry`, must-fix) and lacks `\lean{}` coverage for the two newly-extracted sub-lemmas (major).
