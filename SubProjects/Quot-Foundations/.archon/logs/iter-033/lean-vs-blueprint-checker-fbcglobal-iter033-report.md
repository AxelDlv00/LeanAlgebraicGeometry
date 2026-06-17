# Lean ↔ Blueprint Check Report

## Slug
fbcglobal-iter033

## Iteration
033

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.exists_finite_affineCover_inter_isQuasiCompact}` (chapter: `lem:finite_affine_cover_qcqs`)

- **Lean target exists**: yes
- **Signature matches**: yes
  - Blueprint hypotheses "quasi-compact" → `[CompactSpace X]`, "quasi-separated" → `[QuasiSeparatedSpace X]` both present.
  - Blueprint conclusion "finite affine open cover with quasi-compact pairwise intersections" matches Lean conclusion `∃ s : Set X.affineOpens, s.Finite ∧ (⨆ i ∈ s, ...) = ⊤ ∧ ∀ U ∈ s, ∀ V ∈ s, IsCompact ((U : Set X) ∩ (V : Set X))`.
  - Blueprint additionally mentions the separated case (U_ij affine), which is absent from the Lean signature; this is intentional — only the qcqs case is needed downstream.
- **Proof follows sketch**: yes — blueprint says "quasi-compactness extracts a finite subcover" and "quasi-separatedness gives quasi-compact intersections"; Lean uses `isCompact_iff_finite_and_eq_biUnion_affineOpens` and `quasiSeparatedSpace_iff_forall_affineOpens` directly.
- **notes**: Blueprint has `\leanok` (justified — no sorry, verified clean). Axioms: standard `propext / Classical.choice / Quot.sound` only.

---

### `\lean{AlgebraicGeometry.Modules.gammaIsLimitSheafConditionFork}` (chapter: `lem:gamma_finite_equalizer`)

- **Lean target exists**: yes
- **Signature matches**: partial — mismatch in generality of hypotheses.
  - Blueprint states: "Let X be a **quasi-compact, quasi-separated** scheme, F a sheaf, U a **finite affine** cover."
  - Lean signature: `(M : X.Modules) {ι : Type u} (U : ι → X.Opens) : IsLimit (fork M.presheaf U)` — takes **any** cover over **any** scheme, no `CompactSpace`/`QuasiSeparatedSpace` hypotheses, no finiteness.
  - The Lean is strictly more general: it packages the sheaf condition for any open family, not just finite affine ones. The Lean result implies the blueprint's specific case (when `⨆ i, U i = ⊤`, the fork's apex is `Γ(X, M)`).
  - The `\lean{}` pin is pointing to a result whose signature is weaker (fewer hypotheses) than what the blueprint claims to be formalizing. The statement is correct but the stated context differs.
- **Proof follows sketch**: yes — blueprint proof says "apply the equalizer-products form of the sheaf condition (`isSheaf_iff_isSheafEqualizerProducts`)"; Lean body is exactly `((isSheaf_iff_isSheafEqualizerProducts M.presheaf).mp M.isSheaf U).some`.
- **notes**: Blueprint has `\leanok` (appropriate — no sorry, verified clean). The declaration is a `noncomputable def` (not a `theorem`), returning a term of type `IsLimit ...`; this is the correct formulation for a limit witness. The generality discrepancy is a blueprint-side precision issue (see Blueprint adequacy section).

---

### `AlgebraicGeometry.Modules.exists_finite_affineCover_isLimit_sheafConditionFork` (NO blueprint pin)

- **Lean target exists**: yes (line 78)
- **Signature matches**: N/A — no `\lean{}` block in the chapter
- **Proof follows sketch**: N/A
- **notes**: This is a substantive consolidation theorem combining L1 and L2. It states: for a QCQS scheme X and M : X.Modules, there exists a **finite** index type ι with an affine cover U : ι → X.Opens of X (⨆ U = ⊤), quasi-compact pairwise intersections, and a nonempty `IsLimit (fork M.presheaf U)`. Its doc-string explicitly calls it "the directly-usable global sections as a finite equalizer input of the flat-base-change argument." Full proof (no sorry). Axioms: standard only. This declaration has no blueprint counterpart — coverage debt.

---

## Red flags

None. No `:= sorry`, no `:= True`, no excuse-comments, no axiom declarations, no `Classical.choice` on substantive claims. LSP diagnostics: zero errors/warnings.

---

## Unreferenced declarations (informational)

- `Modules.exists_finite_affineCover_isLimit_sheafConditionFork` (line 78) — **substantive** consolidation theorem, not a mere internal helper. Its doc-string describes it as the "directly-usable" input to the flat-base-change argument, making it a public-facing API point that should appear in the blueprint. See coverage-gap finding below.

---

## Blueprint adequacy for this file

- **Coverage**: 2/3 Lean declarations have a corresponding `\lean{}` block. The unreferenced declaration (`exists_finite_affineCover_isLimit_sheafConditionFork`) is substantive — not a proof-internal helper — and is missing from the chapter. Coverage debt: 1 substantive declaration.

- **Proof-sketch depth**: adequate for the two pinned declarations. Both proofs are short (≤10 lines) and the blueprint sketches correctly identify the key Mathlib hooks used. No formalization detour went unexplained by the prose.

- **Hint precision**: loose for `lem:gamma_finite_equalizer`. The prose says "Fix a finite affine cover of a QCQS scheme" but the `\lean{}` pin names a declaration with **no such hypotheses** (any cover, any scheme). A reader following the `\lean{}` pin would find a strictly more general declaration and might not immediately recognise it subsumes the stated case. The pin is not wrong, but the prose does not explain the generality gap.

- **Generality**: matches need for the pinned declarations. The Lean's extra generality in `gammaIsLimitSheafConditionFork` is genuinely useful (it works for the whole-X cover and for partial covers simultaneously) and does not indicate a blueprint-design failure.

- **Recommended chapter-side actions**:
  1. **Add a `\lean{}` block for `Modules.exists_finite_affineCover_isLimit_sheafConditionFork`** — either a new standalone lemma block (label e.g. `lem:gamma_finite_equalizer_consolidated`) or a named remark/corollary immediately after `lem:gamma_finite_equalizer`. Its statement packages L1+L2 into the single existential that the flat-base-change Lean proof actually consumes as its input.
  2. **Annotate `lem:gamma_finite_equalizer`** with a prose note clarifying that the pinned Lean declaration is more general than stated: it applies to any cover, and the finite affine cover is the intended application. A one-sentence `% NOTE:` comment suffices: e.g., "% NOTE: Lean declaration takes any cover; the finite affine case is the application."

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `exists_finite_affineCover_isLimit_sheafConditionFork` has no `\lean{}` blueprint pin (substantive public API) | **major** |
| `lem:gamma_finite_equalizer` prose hypotheses (finite affine, QCQS) differ from the Lean declaration's hypotheses (any cover, any scheme) without explanation | **minor** |

**Overall verdict**: The Lean file is clean — no sorries, no placeholder bodies, no excuse-comments, three substantive proofs verified — but the blueprint has a coverage gap (the consolidation lemma `exists_finite_affineCover_isLimit_sheafConditionFork` is unreferenced) and a minor hint-precision issue on `gammaIsLimitSheafConditionFork`.
