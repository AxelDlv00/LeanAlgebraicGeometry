# Blueprint Review Report

## Slug
iter016

## Iteration
016

## Top-level summaries

### Incomplete parts

- `Cohomology_CechHigherDirectImage.tex`: the chapter header is missing
  `% archon:covers AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`. The
  mathematical content for `def:cech_free_presheaf_complex` and
  `lem:cech_free_complex_quasi_iso` is present and correct in the chapter, but
  without the `% archon:covers` declaration the HARD GATE mapping rule cannot
  resolve a covering chapter for `FreePresheafComplex.lean` (no 1:1 fallback
  chapter `Cohomology_FreePresheafComplex.tex` exists either). Plan agent must
  add the missing `% archon:covers` line before dispatching the prover.

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine` L1 bridge
  (informational nuance, not a blocker): the paragraph correctly identifies the
  route via Tag 01HV(4)–(5), but does not name the specific Mathlib lemma that
  establishes `Γ(D(s_σ), F̃) = M_{s_σ}` in Lean (likely something in
  `Mathlib.AlgebraicGeometry.Modules.Sheaf` or `StructureSheaf`). The
  mathematical description is adequate; the prover will need to search Mathlib
  for the exact declaration name. Adequate for formalization — not a must-fix.

### Citation discipline

No fabricated citations detected. All `% SOURCE: ... (read from references/<file>.md)` parentheticals name files that exist on disk. Spot-check of the new L1 bridge paragraph:

- `references/stacks-schemes.tex` — exists ✓
- `% SOURCE:` pointer matches visible `\textit{Source:}` line ✓  
- `% SOURCE QUOTE:` reproduces items (4)–(5) of Tag 01HV in the source's original English ✓
- No paraphrase detected ✓

One structural note (informational, not a hard fail): the L1 bridge `% SOURCE:` / `% SOURCE QUOTE:` pair appears *inside* an existing `\begin{proof}` environment rather than before it. The citation-discipline rules specify `% SOURCE QUOTE PROOF:` immediately *before* `\begin{proof}`; however, the outer `\begin{proof}` already has a `% SOURCE QUOTE PROOF:` from the original Stacks vanishing proof. The L1 paragraph adds a *nested* source citation within that proof, which is reasonable for a paragraph-level attribution to a different Stacks tag. Not flagged as a hard fail.

### Dependency & isolation findings

- `leandag build --json`: `"unknown_uses": []` — zero broken `\uses{}` edges. ✓
- `leandag show isolated`: 0 isolated blueprint nodes. ✓
- `leandag show gaps`: 0 blueprint nodes missing `\lean{}`. ✓
- 24 `unmatched_lean` entries:
  - 9 correspond to `\mathlibok` Mathlib declarations (e.g., `CategoryTheory.InjectiveResolution.isoRightDerivedObj`, `CategoryTheory.Functor.rightDerivedZeroIsoSelf`). Leandag scans project files, not the full Mathlib tree; this is a tool limitation, not a blueprint defect. All 9 are faithful `\mathlibok` anchors per the audit below. **keep / tool limitation**.
  - 15 correspond to not-yet-formalized project declarations (P3, P3b, P5a): the open proof obligations. Expected. **keep / work-in-progress**.

`\mathlibok` faithfulness audit (all 9):
- `lem:right_derived_injective_resolution` → `CategoryTheory.InjectiveResolution.isoRightDerivedObj` — standard Mathlib. ✓
- `lem:right_derived_vanishes_injective` → `CategoryTheory.Functor.isZero_rightDerived_obj_injective_succ` — standard Mathlib. ✓
- `lem:right_derived_zero_iso_self` → `CategoryTheory.Functor.rightDerivedZeroIsoSelf` — standard Mathlib. ✓
- `lem:homology_long_exact_sequence` → `CategoryTheory.ShortComplex.ShortExact.homology_exact₁/₂/₃` + `δ` — standard Mathlib short complex lemmas. ✓
- `lem:horseshoe_biprod_injective` → `CategoryTheory.Injective.instBiprod` — standard Mathlib. ✓
- `lem:horseshoe_degree_split` → `CategoryTheory.ShortComplex.Splitting.ofHasBinaryBiproduct` — standard Mathlib. ✓
- `lem:injective_of_adjoint` → `CategoryTheory.Injective.injective_of_adjoint` — confirmed in STRATEGY.md / PROGRESS.md. ✓
- `lem:mod_pmod_adjunction` → `PresheafOfModules.sheafificationAdjunction` — confirmed in STRATEGY.md. ✓
- `def:standard_affine_cover` → `AlgebraicGeometry.Scheme.affineOpenCoverOfSpanRangeEqTop` — confirmed in STRATEGY.md (`Mathlib.AlgebraicGeometry.Cover.Open`). ✓

No unfaithful `\mathlibok` anchors detected.

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex
- **complete**: true
- **correct**: true
- **notes**:
  - P4 work (iters 004–009) is fully reflected. All declarations present with
    adequate proof sketches, correct `\uses{}` edges, and 16 `\leanok` markers
    (confirmed by `leandag stats: proved=16`). Chapter is axiom-clean.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **MUST-FIX (covers gap)**: Chapter header lists three `% archon:covers`
    lines (`CechHigherDirectImage.lean`, `CechAcyclic.lean`, `PresheafCech.lean`)
    but is missing `% archon:covers AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`.
    The declarations `def:cech_free_presheaf_complex` and
    `lem:cech_free_complex_quasi_iso` are blueprinted here and target
    `FreePresheafComplex.lean`, but without the `% archon:covers` declaration
    the HARD GATE mapping rule cannot resolve this chapter as the covering
    chapter for that file. Fix: plan agent adds the missing line to the chapter
    header — no blueprint-writer or re-review needed, as the mathematical
    content is already present and `complete + correct`.
  - **L1 bridge paragraph (new this iter) — mathematical assessment**: The
    proof of `lem:cech_acyclic_affine` now has a complete L1 categorical→module
    bridge paragraph. It correctly:
    (a) names the `i`-th cover member as `Spec(A_{s_i}) → Spec(A)` (the open
        immersion of the basic open `D(s_i)`);
    (b) identifies the `(p+1)`-fold intersection indexed by `σ : {0,...,p} → ι`
        as the basic open `D(s_σ)` with `s_σ = ∏_k s_{σ(k)}`;
    (c) cites Tag 01HV(4) for `Γ(D(s_σ), F̃) = M_{s_σ}` (away localisation);
    (d) cites Tag 01HV(5) for the differential = alternating sum of localisation
        maps;
    (e) concludes: iso of cochain complexes, so positive-degree vanishing of the
        abstract Čech complex ≡ positive-degree exactness of the concrete
        localisation complex.
    This is mathematically sound and adequate for the prover to formalize L1.
    **The paragraph is correct.** Gate for `CechAcyclic.lean` clears on this
    dimension (pending the covers fix for `FreePresheafComplex.lean`, which is
    unrelated to `CechAcyclic.lean`).
  - **`CombinatorialCech.*` bundled helpers** (informational): Nine helper
    declarations (`combDifferential`, `combHomotopy`, `combHomotopy_zero`,
    `cons_comp_succAbove_succ`, `combHomotopy_spec`, `combDifferential_eq_of_cocycle`,
    `combSign_flip`, `combDifferential_comp`, `combDifferential_exact`) are
    bundled in `lem:cech_acyclic_affine`'s `\lean{}` list without separate
    blueprint entries. This is coverage-debt bundling per the iter-016 context.
    The prover must independently structure these helpers — no blueprint block
    describes them individually. Acceptable for a capable prover; however, if
    the prover decomposes these differently than the blueprint expects, a
    lean-vs-blueprint-checker pass is advisable post-formalization.
  - **`freeYonedaHomEquiv`** bundled in `lem:cech_complex_hom_identification`:
    reasonable name for the component identification `Hom(free(y(V)), F) ≅ F(V)`.
    Prover should aim for a natural-transformation-level statement for
    functoriality. Adequate.
  - **`injective_toPresheafOfModules`** bundled in `lem:injective_cech_acyclic`:
    reasonable name for "injective O_X-module is injective as a presheaf". 
    Adequate.
  - **`lem:cech_to_cohomology_on_basis` `\lean{cech_eq_cohomology_of_basis}`**:
    equality-suggesting name for a vanishing-conclusion statement. PROGRESS.md
    flags this as non-blocking deferred. Informational only.
  - **No circular dependency**: `lem:cech_to_cohomology_on_basis` correctly
    does NOT `\uses{}` `lem:affine_serre_vanishing`. The proof text also
    confirms the acyclicity argument is non-circular (no affine Serre input).
    `unknown_uses: []` confirms no broken edges. ✓
  - **`def:section_cech_complex` and `def:cech_free_presheaf_complex`**:
    both definitions are clear and complete. Proof obligations for
    `lem:cech_complex_hom_identification` (free-Yoneda + product) and
    `lem:cech_free_complex_quasi_iso` (sectionwise contractibility) are
    detailed enough for formalization. ✓

## Severity summary

**Must-fix this iter (1 finding):**

- `Cohomology_CechHigherDirectImage.tex`: missing
  `% archon:covers AlgebraicJacobian/Cohomology/FreePresheafComplex.lean` in
  the chapter header. Without this, the HARD GATE mapping cannot resolve the
  covering chapter for `FreePresheafComplex.lean`. The mathematical content is
  already present and correct; the fix is a one-line addition to the chapter
  header by the plan agent. **Same-iter self-fix**: plan agent adds the line →
  chapter becomes `complete + correct` for all four covered files → prover can
  be dispatched to `FreePresheafComplex.lean` this same iter. No blueprint-writer
  or additional blueprint-reviewer pass required.

**Informational (3 findings):**

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine`: L1
  bridge does not name the specific Mathlib declaration for `Γ(D(s_σ), F̃) = M_{s_σ}`;
  prover must search Mathlib. Adequate for formalization.
- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_to_cohomology_on_basis`:
  `\lean{}` hint name `cech_eq_cohomology_of_basis` is equality-suggesting for
  a vanishing result. Non-blocking.
- 24 `unmatched_lean` entries: expected — 9 `\mathlibok` Mathlib declarations
  (leandag tool limitation), 15 not-yet-formalized project declarations.

**Overall verdict**: 3 chapters audited; 1 must-fix-this-iter finding
(covers-line omission on the consolidated chapter, self-fixable by the plan
agent in one line before prover dispatch); 0 unstarted-phase proposals (all
strategy phases have adequate blueprint coverage). After the plan agent adds
the missing `% archon:covers` line, the HARD GATE CLEARS for all three gated
files (`CechAcyclic.lean`, `PresheafCech.lean`, `FreePresheafComplex.lean`).
