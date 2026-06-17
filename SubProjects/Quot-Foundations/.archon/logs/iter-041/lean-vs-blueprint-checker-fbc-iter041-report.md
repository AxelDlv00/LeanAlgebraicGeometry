# Lean ↔ Blueprint Check Report

## Slug
fbc-iter041

## Iteration
041

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Directive-specific checks

### Check 1 — `lem:base_change_mate_fstar_reindex_legs_conj` `\leanok` proof marker

**Verdict: correctly NOT marked in the proof block. sync_leanok did not wrongly mark it.**

Blueprint structure (lines 2213–2274):
- `\begin{lemma}` at line 2213, then blank line, then `\leanok` at line 2215 → this is the **statement block** marker.
  - Correct: the declaration `AlgebraicGeometry.base_change_mate_fstar_reindex_legs_conj` exists at Lean line 1757 with an explicit `sorry` at line 1848. Statement-level `\leanok` is the correct signal for "formalized but not yet closed."
- `\begin{proof}` block (lines 2250–2274): **no `\leanok`** present.
  - Correct: the proof has an open `sorry` at line 1848. A proof-block `\leanok` would be wrong here.

Throughout this chapter, proof blocks are in the external `\begin{proof}...\end{proof}` pattern (outside `\end{lemma}`), and **no** proof block in the entire chapter carries `\leanok` — this is the project-wide convention for this file. The absence here is consistent, not a gap.

---

### Check 2 — Three supporting legs: blueprint pins and honest marking

#### conj-2b — `base_change_mate_reindex_conj_pullbackLeg`

- **Blueprint pin**: `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_pullbackLeg}` at blueprint line 2127.
- **Lean declaration**: `theorem base_change_mate_reindex_conj_pullbackLeg` at Lean line 1625. Pin matches. ✓
- **Statement block** `\leanok`: present at line 2124. ✓
- **Lean proof**: single term `Adjunction.conjugateEquiv_leftAdjointCompIso_inv _ _ _ _` at line 1635. **No sorry.** ✓
- **Proof block** `\leanok`: absent (lines 2144–2150). Per project convention (see above), this is expected even for closed proofs.

#### conj-2c — `base_change_mate_reindex_conj_pushforwardCollapse`

- **Blueprint pin**: `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_pushforwardCollapse}` at blueprint line 2157.
- **Lean declaration**: `theorem base_change_mate_reindex_conj_pushforwardCollapse` at Lean line 1736. Pin matches. ✓
- **Statement block** `\leanok`: present at line 2154. ✓
- **Lean proof**: term proof `⟨gammaMap_pushforwardComp_inv_eq_id _ _ _, gammaMap_pushforwardComp_hom_eq_id _ _ _, gammaMap_pushforwardCongr_hom _ _⟩` at lines 1746–1747. **No sorry.** ✓
- **Proof block** `\leanok`: absent (lines 2170–2176). Per project convention.

#### conj-2d — `base_change_mate_reindex_conj_crossLayer`

- **Blueprint pin**: `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_crossLayer}` at blueprint line 2183.
- **Lean declaration**: `theorem base_change_mate_reindex_conj_crossLayer` at Lean line 1652. Pin matches. ✓
- **Statement block** `\leanok`: present at line 2180. ✓
- **Lean proof**: multi-step tactic proof (lines 1652–1724) with no `sorry`. **No sorry.** ✓
- **Proof block** `\leanok`: absent (lines 2200–2211). Per project convention.

All three are honestly marked: statement `\leanok` signals the declaration exists; absent proof-block `\leanok` is consistent with the chapter-wide convention. The proofs are confirmed sorry-free by direct inspection (file-wide grep finds only four `sorry` lines: 1848, 2315, 2496, 2518 — none in these three).

---

### Check 3 — Blueprint sketch reflects Fallback B; roadmap comment does not cite a sorry-backed lemma as proven

**Verdict: correct on both counts.**

**Blueprint proof sketch** (lines 2256–2273): Describes Fallback B unambiguously — "mirror Mathlib's `leftAdjointCompNatTrans₀₂₃_eq_conjugateEquiv_symm` … and *peel one adjunction-pair / functor-layer at a time*: split the composite into single-pair conjugate factors with `conjugateEquiv_symm_comp` … The resulting per-layer identities are exactly the three isolated legs." This is Fallback B. ✓

**Lean roadmap comment** (lines 1792–1848):
- Lines 1808–1811: correctly records all three legs as BUILT and axiom-clean. ✓
- Lines 1816–1830: accurately describes iter-041 partial progress — 2 of 3 Γ-collapses applied by `simp` (`.inv` factor via `gammaMap_pushforwardComp_inv_eq_id` and congruence via `gammaMap_pushforwardCongr_hom`); the `.hom` factor blocked by discrimination-tree mismatch. ✓
- Lines 1830–1848: correctly records the remaining blocker (building the multi-pair `adjL`/`adjR` and assembled `β` across 5 adjunction layers) without claiming any sorry-backed lemma is proven. ✓
- The single `sorry` at line 1848 is for the main goal only. None of the three legs (lines 1635, 1746–1747, 1724) is sorry. ✓

---

## Per-declaration (focused on the iter-041 cluster)

### `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_pullbackLeg}` (chapter: `lem:base_change_mate_reindex_conj_pullbackLeg`)
- **Lean target exists**: yes (line 1625)
- **Signature matches**: yes
- **Proof follows sketch**: yes — "Both identifications are direct applications of the cited conjugation identities." Lean proof is exactly `Adjunction.conjugateEquiv_leftAdjointCompIso_inv _ _ _ _`.
- **notes**: Axiom-clean, no sorry.

### `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_pushforwardCollapse}` (chapter: `lem:base_change_mate_reindex_conj_pushforwardCollapse`)
- **Lean target exists**: yes (line 1736)
- **Signature matches**: yes — bundles all three collapse facts as a conjunction.
- **Proof follows sketch**: yes — term proof directly applies the three atomic collapse lemmas.
- **notes**: Axiom-clean, no sorry.

### `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_crossLayer}` (chapter: `lem:base_change_mate_reindex_conj_crossLayer`)
- **Lean target exists**: yes (line 1652)
- **Signature matches**: yes
- **Proof follows sketch**: yes — sets up the composite adjunctions `adjL`/`adjR`, applies `unit_conjugateEquiv_symm` (Seam 1 mechanism one layer up), matches the blueprint's "transposed unit-across-conjugate coherence … composed through the conjugation-composition coherence to raise it past the `(Spec φ)_*` layer."
- **notes**: Axiom-clean, no sorry. General-ψ port of Seam 1.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_conj}` (chapter: `lem:base_change_mate_fstar_reindex_legs_conj`)
- **Lean target exists**: yes (line 1757)
- **Signature matches**: yes — universal over `g'`, `f'`, `hfst`, `hsnd`, `comm`, comparing the inner composite against `base_change_mate_inner_value` with the conjugate-native codomain read.
- **Proof follows sketch**: **partial** — iter-041 successfully applies the initial `rw [base_change_mate_codomain_read_legs_conj]` rewrite and then collapses 2 of 3 Γ-coherences via `simp`. The `.hom`-factor of `pushforwardComp` is not collapsible via the simp set (discrimination-tree asymmetry). The blueprint-prescribed `conjugateEquiv.injective` layer-peel strategy has not been implemented yet; the `sorry` at line 1848 remains.
- **notes**: The blueprint sketch describes the right strategy; the Lean code is partway through a slightly different ordering (collapse first, then peel). One explicit `sorry`.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (chapter: `lem:base_change_mate_fstar_reindex_legs`)
- **Lean target exists**: yes (line 1861)
- **Signature matches**: yes
- **Proof follows sketch**: yes — thin wrapper that applies `base_change_mate_fstar_reindex_legs_conj` and bridges via `base_change_mate_codomain_read_legs_conj_eq`. Matches the blueprint exactly.
- **notes**: Transitively sorry-backed through `_legs_conj`. Statement `\leanok` correct; proof block no `\leanok` (expected).

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (chapter: `lem:base_change_mate_fstar_reindex`)
- **Lean target exists**: yes (line 1912)
- **Signature matches**: yes
- **Proof follows sketch**: yes — instantiates `_legs` at literal pullback projections via `hfst`/`hsnd` from `pullback_fst_snd_specMap_tensor`.
- **notes**: Transitively sorry-backed through `_legs`. Statement `\leanok` correct.

---

## Red flags

No placeholder bodies, no excuse-comments, no axioms on substantive claims.

The four explicit `sorry` lines in the file:
- Line 1848: `base_change_mate_fstar_reindex_legs_conj` — the keystone, documented and expected.
- Line 2315: `base_change_mate_gstar_transpose` — separate crux, unrelated to this iter's change.
- Line 2496: `affineBaseChange_pushforward_iso` — documented scaffold.
- Line 2518: `flatBaseChange_pushforward_isIso` — documented scaffold.

All four are documented in blueprint NOTE comments and/or Lean comment blocks. None is a hidden or excuse-commented placeholder.

---

## Unreferenced declarations (informational)

All 59 substantive declarations in `FlatBaseChange.lean` have a corresponding `\lean{...}` reference in `Cohomology_FlatBaseChange.tex` (noting that the chapter covers both `FlatBaseChange.lean` and `FlatBaseChangeGlobal.lean` per the `archon:covers` annotation). No unreferenced substantive declarations found.

---

## Blueprint adequacy for this file

- **Coverage**: All Lean declarations in scope have `\lean{...}` blueprint blocks. **59/59** substantive declarations referenced. ✓
- **Proof-sketch depth**: **adequate** overall, with one minor gap noted below.
- **Hint precision**: **precise** — every `\lean{...}` tag names the exact fully-qualified Lean identifier, and all checked signatures match the informal prose.
- **Generality**: **matches need** — the chapter correctly states the generic form of each lemma.
- **Recommended chapter-side actions** (minor):
  1. The conj-2c sketch says all three Γ-collapses "drop out" uniformly, but the iter-041 Lean attempt showed the `.hom` form of `pushforwardComp` has a discrimination-tree asymmetry that prevents direct `simp`/`rw` collapse at the section level (while the `.inv` form and `pushforwardCongr` collapse cleanly). The blueprint could add a brief remark: "Note: in Lean the `.hom`-factor collapse cannot be triggered via `simp` in the section-level context due to a discrimination-tree asymmetry; a `conv`/`change` step or a direct application in the conjugate layer is required." This is informational, not blocking.
  2. The proof sketch for `lem:base_change_mate_fstar_reindex_legs_conj` prescribes applying `(conj)^{-1}` **first** and then using the per-layer legs. The iter-041 Lean attempt tries collapsing the Γ-coherences at the section level **first** (before applying `.injective`). These are mathematically compatible orderings, but the blueprint sketch doesn't make clear that the section-level collapse can precede the conjugate injection. A one-line note would improve guidance for a future prover.

---

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - Blueprint conj-2c sketch doesn't note the `.hom`-factor discrimination-tree asymmetry that blocked its direct simp-application at the section level in iter-041 (the abstract lemma is proven; only its mechanical use as a simp rule in the target context is blocked).
  - Blueprint proof sketch for `_legs_conj` doesn't clarify that collapsing Γ-coherences first (before applying `conjugateEquiv.injective`) is a valid alternative ordering to the prescribed "invert first, then discharge per layer" flow.
  - Conj-2b/2c/2d proof blocks lack proof-level `\leanok` despite being fully closed — this matches the chapter-wide convention (no proof block in the entire chapter carries `\leanok`), so this is a project-wide note, not a per-declaration error.

**Overall verdict**: Blueprint and Lean are correctly synchronized for iter-041; the keystone `base_change_mate_fstar_reindex_legs_conj` is honestly marked as statement-formalized / proof-open, the three supporting legs are confirmed sorry-free and correctly pinned, and the blueprint sketch accurately encodes Fallback B. No must-fix findings block downstream work.
