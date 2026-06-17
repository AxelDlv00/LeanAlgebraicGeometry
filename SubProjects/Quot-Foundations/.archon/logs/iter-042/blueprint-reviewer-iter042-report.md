# Blueprint Audit Report — iter-042

**Subagent**: blueprint-reviewer  
**Date**: 2026-06-08  
**Scope**: Full audit of `blueprint/src/chapters/` + DAG integrity + two directive-specific focus areas  

---

## Executive Summary

- **9 sorry nodes** across the codebase (4 FBC conjugate-chain, 1 GF geometric, 4 QuotScheme downstream).  
- **GrassmannianCells and RelativeSpec are fully clean** — zero sorry, zero isolated unused nodes (GR isolated node is harmless).  
- **QuotScheme gap1 is correctly \leanok**; G1-core is gate-clear pending 3 pin-mismatch fixes + 4 missing helper blocks + stale NOTE cleanup.  
- **FBC tilde-transport route**: the chapter already has ALL prerequisites (`lem:pullback_spec_tilde_iso`, `lem:pushforward_spec_tilde_iso`, `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:cancelBaseChange_mathlib`). ONE new lemma block is missing: a direct section-value computation that routes through the tilde isos WITHOUT the conjugate calculus. Outline provided below.  
- **DAG**: 0 gaps (no phantom `\lean{}` pins with missing `\leanok`), 2 isolated nodes (both proved, zero impact), sorry chain contained.

---

## 1 — Per-Chapter Completeness + Correctness Checklist

### `Cohomology_RegroupHelper.tex`
| | |
|---|---|
| **Status** | ✅ COMPLETE AND CORRECT |
| **Summary** | Single lemma `lem:base_change_regroup_linearEquiv` (\leanok). Uses `lem:isPushout_cancelBaseChange_mathlib` (\mathlibok). No outstanding issues. |

---

### `Cohomology_FlatBaseChange.tex`
`% archon:covers FlatBaseChange.lean FlatBaseChangeGlobal.lean`

| | |
|---|---|
| **Status** | ⚠️ MOSTLY COMPLETE — 4 sorry nodes (conjugate-chain) |
| **Correctness** | Prose and \uses{} graphs are correct throughout |

**\leanok (axiom-clean):**
- All tilde-dictionary lemmas: `lem:pullback_spec_tilde_iso`, `lem:pushforward_spec_tilde_iso`
- Locality criterion: `lem:base_change_map_affine_local`
- All conjugate-calculus scaffolding (conj-0/0'/unit/codomain-legs): \leanok
- `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`: \leanok
- `lem:base_change_mate_fstar_reindex_legs_conj`, `lem:base_change_mate_gstar_generator_close`: \leanok
- `lem:base_change_mate_extendScalars_inner_value_counit` (step b): \leanok
- All FBC-B globalisation blocks (`lem:fbcb_baseChangeGammaEquiv` etc.): \leanok

**Sorry chain (4 nodes):**
| Label | Lean decl | Root cause |
|---|---|---|
| `lem:base_change_mate_gstar_transpose` | `base_change_mate_gstar_transpose` | **ROOT** — the counit-conjugate crux `huce`; 5 iters exhausted |
| `lem:base_change_mate_section_identity` | `base_change_mate_section_identity` | Depends on `gstar_transpose` |
| `lem:pushforward_base_change_mate_cancelBaseChange` | `pushforward_base_change_mate_cancelBaseChange` | Proof routes through section identity |
| `lem:affine_base_change_pushforward` | `affineBaseChange_pushforward_iso` | Depends on cancelBaseChange |
| `thm:flat_base_change_pushforward` | `flatBaseChange_pushforward_isIso` | Depends on affine lemma |

> **Note:** `lem:pushforward_base_change_mate_cancelBaseChange`'s STATEMENT (lines 3322–3352) already correctly describes the tilde-transport identification. The proof block (lines 3356–3388) routes through the conjugate calculus. The tilde-transport pivot replaces the proof, not the statement.

**Must-fix this iter:**
- See §3 for the full tilde-transport blueprint outline (new lemma + revised proof route for `pushforward_base_change_mate_cancelBaseChange`)
- No prose/\uses corrections needed elsewhere

---

### `Picard_FlatteningStratification.tex`
| | |
|---|---|
| **Status** | ⚠️ MOSTLY COMPLETE — 1 sorry node (geometric bridge) |

**\leanok (axiom-clean):**
- All algebraic GF lemmas: L1–L5b, torsion base/reindex, Nagata, generic-rank SES
- `thm:generic_flatness_algebraic` (\leanok, axiom-clean)
- `lem:gf_polynomial_core` (\leanok): OreLocalization instance alignment resolved (NOTE at line 1434 superseded)
- `lem:gf_away_tower_descent` (\leanok): composite-localisation route via `IsBaseChange.comp` closed
- `lem:gf_flat_finite`, `lem:gf_free_moduleFinite`: \leanok

**Unformalized (no \leanok, Lean decl not yet built):**
- `lem:gf_qcoh_fintype_finite_sections` (G1 bridge): has `\lean{}` pin, correct prose, no Lean decl
- `lem:gf_flat_locality_assembly` (G3 bridge): has `\lean{}` pin, correct prose, no Lean decl

**Sorry:**
- `thm:generic_flatness`: \leanok (Lean decl exists) but sorry because G1/G3 bridges missing. Proof prose is correct.

**Must-fix this iter:** None urgent. G1/G3 bridges are the current GF-geo objective. Blueprint prose for both is complete and correct — provers can proceed directly.

**\uses{} correctness:** `thm:generic_flatness` \uses{lem:gf_qcoh_fintype_finite_sections, lem:gf_flat_locality_assembly} — correct.

---

### `Picard_GrassmannianCells.tex`
| | |
|---|---|
| **Status** | ✅ COMPLETE AND CORRECT |

**\leanok (axiom-clean):**
- All chart/overlap/transition definitions
- Full glue datum and `def:gr_glued_scheme`
- Separatedness: `lem:gr_diagonalRingMap_surjective`, `lem:gr_separated_toSpecZ`, `lem:gr_separated`
- All properness ingredients: E1–E5, `lem:gr_isProper_of_valuativeExistence`
- `lem:gr_isProper` (final properness): \leanok

**Isolated node:** `lem:gr_de...` (2 deps, 0 impact). Proved, not yet cited by any downstream block. Low severity.

---

### `Picard_RelativeSpec.tex`
| | |
|---|---|
| **Status** | ✅ COMPLETE AND CORRECT |

All blocks \leanok: `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base`.  
NOTE on `thm:relative_spec_univ` (IsAffineHom form vs Yoneda-bijection, iter-174+ pending) is accurate.

---

### `Picard_QuotScheme.tex`
`% archon:covers QuotScheme.lean GradedHilbertSerre.lean`

| | |
|---|---|
| **Status** | ⚠️ MOSTLY CORRECT — gap1 done, 3 stale pins, 4 missing helper blocks, 4 downstream sorry |

**gap1 correctly closed (iter-041):**
- `lem:section_localization_descent` (\leanok, NOTE updated: "BUILT axiom-clean iter-041")
- `lem:qcoh_affine_isIso_fromTildeΓ` (\leanok, NOTE updated: "BUILT axiom-clean iter-041")
- `lem:section_localization_hfr_basicOpen` (\leanok, NOTE updated: "BUILT axiom-clean iter-041")
- All gap1 sub-lemmas (\leanok): `lem:section_localization_descent_of_cover`, `lem:section_localization_descent_of_basicOpen_cover`, `lem:over_restrict_iso`, `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`, etc.

**Three stale `\lean{}` pin mismatches (MUST FIX):**

| Label | Stale pin | Issue |
|---|---|---|
| `lem:composite_immersion_flocus_basicOpen` (line 4330) | Non-existent decl | Content absorbed inline into `section_localization_hfr_aux`. Re-pin needs split into `compositeBasicOpenImmersion_image_basicOpen` + `image_basicOpen_eq_inf` per session_41 §2 recommendation. |
| `lem:gamma_image_iso_semilinear_top` (line 4357) | Non-existent decl | `he₁`/`he₂` inline in `section_localization_hfr_aux`. Remove `\lean{}` pin and add `% NOTE: absorbed inline iter-041` |
| `lem:flocus_section_scalar_tower` (line 4384) | Non-existent decl | `IsScalarTower` instances built inline in `section_localization_hfr_aux`. Remove `\lean{}` pin and add note. |

**Four missing blueprint blocks (MUST ADD):**
- `image_basicOpen_of_affine`
- `compositeBasicOpenImmersion_image_basicOpen`
- `image_basicOpen_eq_inf`
- `section_localization_hfr_aux` (the opaque-immersion core; load-bearing for the whnf runaway fix)

**Stale `% NOTE: does NOT yet exist` status:** Lines 2721 and 2482 contain accurate "does NOT yet exist" notes (G1-core Lean decl does not exist yet). The gap1 sub-lemmas (lem:section_localization_descent etc.) have ALREADY been updated to "BUILT axiom-clean iter-041" by the iter-041 review agent — no further cleanup needed there.

**Isolated node:** `lem:annih...` = `lem:modules_annihilator_ideal_le` (proved, 0 deps, 0 impact). The reverse inclusion is noted as unformalized ("annihilator forward direction", line 2334). Low severity.

**Downstream sorry (4 nodes — expected, not blockers for G1-core):**
| Label | Status |
|---|---|
| `def:hilbert_polynomial` | Sorry — not yet started |
| `def:quot_scheme` | Sorry — not yet started |
| `def:grassmannian_representability` | Sorry — not yet started |
| `thm:grassmannian_representability` | Sorry — not yet started |

---

## 2 — G1-core Gate-Clear Assessment

**Target:** `lem:qcoh_affine_section_localization` → Lean `isLocalizedModule_basicOpen_of_isQuasicoherent`  
**Block location:** Lines 2716–2762

**Analysis of the proof block (lines 2746–2763):**
> "Since M is quasi-coherent, gap1 (lem:qcoh_affine_isIso_fromTildeΓ) gives that the counit fromTildeΓ is an isomorphism. Then lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ gives isLocalizedModule at every basic open. G1-core and gap1 are interderivable."

The proof in Lean is essentially **one line**: 
```lean
exact isLocalizedModule_restrict_of_isIso_fromTildeΓ M.fromTildeΓ
  (isIso_fromTildeΓ_of_isQuasicoherent hqc)
```

**Prerequisites check:**
- `lem:qcoh_affine_isIso_fromTildeΓ` (\leanok, axiom-clean) — ✅ exists and correct
- `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` — needs verification of \leanok status (the block is cited in gap1's \uses chain and was built as part of gap1's infrastructure in iter-041)
- `\uses{}` chain at lines 2719: `{lem:qcoh_affine_isIso_fromTildeΓ, lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ, lem:isLocalization_basicOpen_mathlib}` — correct and complete

**Verdict: GATE-CLEAR** once the three pin mismatches, four missing helper blocks, and stale NOTE cleanup are performed. The proof is a one-liner corollary; a prover can close it in a single session with no new sorry obligations.

**Caveat:** The `% NOTE: the Lean decl does NOT yet exist.` at line 2721 is ACCURATE (the Lean declaration `isLocalizedModule_basicOpen_of_isQuasicoherent` has not been written yet). This note must stay — it correctly marks G1-core as the prover's objective.

---

## 3 — FBC Tilde-Transport Route: Blueprint Chapter Outline

**Context:** The conjugate route (5 iters, 037–041) proved all conjugate-calculus scaffolding but the root `lem:base_change_mate_gstar_transpose` (the `huce` counit-coherence identity) remains sorry. The pivot is to REPLACE the proof of `lem:pushforward_base_change_mate_cancelBaseChange` with a direct tilde-dictionary computation that bypasses `gstar_transpose` entirely.

**Key insight:** The STATEMENT of `lem:pushforward_base_change_mate_cancelBaseChange` (lines 3322–3352) ALREADY correctly describes the tilde-transport route. The PROOF block (lines 3356–3388) is the problem — it routes through `lem:base_change_mate_section_identity` → `lem:base_change_mate_gstar_transpose`. The fix is a new sub-lemma + proof revision.

### Already in the chapter (no new blocks needed for these):

| Lemma | Status | Role in tilde-transport |
|---|---|---|
| `lem:pullback_spec_tilde_iso` | \leanok | `(Spec φ)^* M̃ ≅ (R' ⊗_R M)~` |
| `lem:pushforward_spec_tilde_iso` | \leanok | `(Spec φ)_* M̃ ≅ (restrM)~` |
| `lem:base_change_mate_domain_read` | \leanok | `Γ(g^*(f_* M̃)) ≅ R' ⊗_R M` via Θ_src |
| `lem:base_change_mate_codomain_read` | \leanok | `Γ(f'_*(g')^* M̃) ≅ (R'⊗A)⊗_A M` via Θ_tgt |
| `lem:cancelBaseChange_mathlib` | \mathlibok | `cancelBaseChange` is an iso |
| `def:pushforward_base_change_map` | \leanok | The map `α` itself |
| `lem:base_change_map_affine_local` | \leanok | Affine-open locality reduction |
| `lem:affine_base_change_pushforward` | \leanok (sorry) | Assembles from the section-value lemma |

### New blueprint block needed (1 lemma):

```latex
\subsection{Tilde-transport direct proof of the section-level value}
\label{sec:fbc_tilde_transport_direct}

% This subsection replaces the conjugate-calculus proof route for
% lem:pushforward_base_change_mate_cancelBaseChange.
% It does NOT depend on lem:base_change_mate_section_identity or
% lem:base_change_mate_gstar_transpose.

\begin{lemma}
  [Direct section-level value of the affine base-change map]
  \label{lem:pushforward_base_change_mate_sections_direct}
  \lean{AlgebraicGeometry.pushforward_base_change_mate_sections_direct}
  \uses{def:pushforward_base_change_map,
        lem:base_change_mate_domain_read,
        lem:base_change_mate_codomain_read,
        lem:cancelBaseChange_mathlib}
  In the affine-affine model --- S = Spec R, S' = Spec R', X = Spec A,
  F = M̃ for an A-module M, g = Spec ψ (ψ : R → R'), f = Spec φ (φ : R → A) ---
  the composition
  \[
    \Theta_{\mathrm{tgt}}
      \;\circ\; \Gamma\!\bigl(\alpha\bigr)
      \;\circ\; \Theta_{\mathrm{src}}^{-1}
    \;:\; R' \otimes_R M
    \;\longrightarrow\; (R' \otimes_R A) \otimes_A M
  \]
  equals the inverse cancellation isomorphism
  \(\operatorname{cancelBaseChange}^{-1} : r' \otimes m \mapsto (r' \otimes 1) \otimes m\)
  of Lemma~\ref{lem:cancelBaseChange_mathlib}, where
  \(\Theta_{\mathrm{src}}\) and \(\Theta_{\mathrm{tgt}}\) are the domain and codomain
  identifications of Lemmas~\ref{lem:base_change_mate_domain_read}
  and~\ref{lem:base_change_mate_codomain_read}.
\end{lemma}
\begin{proof}
  \uses{def:pushforward_base_change_map,
        lem:base_change_mate_domain_read,
        lem:base_change_mate_codomain_read,
        lem:cancelBaseChange_mathlib}
  The proof is a direct module computation. The map
  \(\alpha = \mathtt{pushforwardBaseChangeMap}\) is defined as the natural
  transformation obtained from the adjunction
  \((f'^*, f'_*)\) and \((g^*, g_*)\) applied to the identity on \(f_* \widetilde M\).
  Concretely, on an affine chart the adjunction units/counits reduce to algebra maps
  between tensor products. Tracing \(\Gamma(\alpha)\) through its definition yields,
  on a generator \(r' \otimes m\):
  \begin{enumerate}
    \item Apply \(\Theta_{\mathrm{src}}^{-1}\): pass to the \(\Gamma\)-representation
      of the domain via the two tilde dictionaries
      (Lemma~\ref{lem:base_change_mate_domain_read}).
    \item Apply \(\Gamma(\alpha)\): use the explicit definition of
      \(\mathtt{pushforwardBaseChangeMap}\) as an adjunction natural transformation;
      on global sections over the affine model this collapses to the canonical map
      \(R' \otimes_R M \to (R' \otimes_R A) \otimes_A M\) sending
      \(r' \otimes m \mapsto (r' \otimes 1) \otimes m\) (the universal property of the
      tensor product and the algebra map \(\varphi : R \to A\)).
    \item Apply \(\Theta_{\mathrm{tgt}}\): the result lands in
      \((R' \otimes_R A) \otimes_A M\) by Lemma~\ref{lem:base_change_mate_codomain_read}.
  \end{enumerate}
  The composed map is \(r' \otimes m \mapsto (r' \otimes 1) \otimes m =
  \operatorname{cancelBaseChange}^{-1}(r' \otimes m)\). Since
  \(\operatorname{cancelBaseChange}\) is an isomorphism (Lemma~\ref{lem:cancelBaseChange_mathlib}),
  so is \(\operatorname{cancelBaseChange}^{-1}\). No flatness hypothesis is needed.
\end{proof}
```

### Revised proof for `lem:pushforward_base_change_mate_cancelBaseChange`:

The existing STATEMENT block (lines 3283–3354) is correct and unchanged. The PROOF block (lines 3356–3388) is REPLACED with:

```latex
\begin{proof}
  \uses{def:pushforward_base_change_map,
        lem:base_change_mate_domain_read,
        lem:base_change_mate_codomain_read,
        lem:pushforward_base_change_mate_sections_direct,
        lem:cancelBaseChange_mathlib}
  By Lemma~\ref{lem:pushforward_base_change_mate_sections_direct}, the composition
  \(\Theta_{\mathrm{tgt}} \circ \Gamma(\alpha) \circ \Theta_{\mathrm{src}}^{-1}\)
  equals \(\operatorname{cancelBaseChange}^{-1}\), which is an isomorphism
  (Lemma~\ref{lem:cancelBaseChange_mathlib}). Hence \(\Gamma(\alpha)\) is an
  isomorphism (being the composition of isomorphisms
  \(\Theta_{\mathrm{src}} \circ \operatorname{cancelBaseChange}^{-1} \circ \Theta_{\mathrm{tgt}}^{-1}\)).
  Since both source and target of \(\alpha\) are quasi-coherent, the tilde-equivalence
  is fully faithful and \(\mathrm{IsIso}\,\Gamma(\alpha) \Rightarrow \mathrm{IsIso}\,\alpha\).
  No flatness hypothesis is needed; the identification is an \(R'\)-module isomorphism.
\end{proof}
```

### Updated `\uses{}` seam for `lem:affine_base_change_pushforward`:

Remove `lem:pushforward_base_change_mate_cancelBaseChange`'s dependency on `lem:base_change_mate_section_identity` and `lem:base_change_mate_gstar_transpose`. The revised `\uses{}` for the entire assembly:

```latex
% lem:affine_base_change_pushforward (revised)
\uses{def:pushforward_base_change_map,
      lem:base_change_map_affine_local,
      lem:modules_isIso_iff_affineOpens,
      lem:pushforward_base_change_mate_cancelBaseChange,
      lem:pullback_spec_tilde_iso,
      lem:pushforward_spec_tilde_iso}
```

`lem:base_change_mate_section_identity` and `lem:base_change_mate_gstar_transpose` are **removed from the dependency chain** of `lem:affine_base_change_pushforward`. They remain in the chapter as dead-end sorry nodes (the conjugate-calculus scaffolding stays for the record but is no longer on the critical path).

### Lean prover objective for the tilde-transport pivot:

1. Prove `pushforward_base_change_mate_sections_direct` (new decl) — a direct module computation.
2. Replace the proof body of `pushforward_base_change_mate_cancelBaseChange` (currently sorry via `gstar_transpose`) with a call to the new direct lemma.
3. Verify `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso` close axiom-clean downstream.

The direct computation in step 1 should be approachable via `ext` + `Finsupp.induction` or `TensorProduct.induction_on`, unfolding `pushforwardBaseChangeMap`'s adjunction definition.

---

## 4 — DAG Integrity Findings

**Tool:** `leandag`

| Filter | Count | Notes |
|---|---|---|
| `gaps` | 0 | No `\lean{}` pins missing from the DAG |
| `sorry` | 9 | See chain breakdown above |
| `isolated` | 2 | Both proved; zero downstream impact |
| `unproved` | ~2 | G1/G3 GF bridges (have `\lean{}` pins, no `\leanok`) — expected, current GF-geo targets |

**Isolated nodes:**
1. `lem:modules_annihilator_ideal_le` (QuotScheme) — proved, 0 deps, 0 impact. The reverse inclusion is noted as not yet a blueprint block (line 2334). No action needed for G1-core.
2. `lem:gr_de...` (GrassmannianCells) — proved, 0 deps, 0 impact. Minor helper result not yet consumed by any downstream statement block.

**Broken `\uses{}`:** None found. All cited labels resolve in the DAG.

**Phantom `\lean{}` pins (stale, not reflected in DAG):**
Three blocks in QuotScheme have `\lean{}` pins pointing to non-existent Lean decls (absorbed into `section_localization_hfr_aux` in iter-041). These do NOT corrupt the DAG (leandag treats them as "declared but not yet proved" rather than broken), but they WILL produce false positives in `lean-vs-blueprint-checker`. Fix priority: MUST before dispatching G1-core prover.

---

## 5 — Priority Severity Table

| # | Severity | File | Action |
|---|---|---|---|
| 1 | **MUST (pre-G1-core)** | `Picard_QuotScheme.tex` lines 4330, 4357, 4384 | Fix 3 stale `\lean{}` pins (remove or re-pin to correct split decls per session_41 §2) |
| 2 | **MUST (pre-G1-core)** | `Picard_QuotScheme.tex` | Add 4 missing blueprint blocks: `image_basicOpen_of_affine`, `compositeBasicOpenImmersion_image_basicOpen`, `image_basicOpen_eq_inf`, `section_localization_hfr_aux` |
| 3 | **MUST (this iter)** | `Cohomology_FlatBaseChange.tex` | Add `lem:pushforward_base_change_mate_sections_direct` block + revise proof of `lem:pushforward_base_change_mate_cancelBaseChange` per §3 outline |
| 4 | **SHOULD** | `Cohomology_FlatBaseChange.tex` lines 3356–3388 | Remove `lem:base_change_mate_section_identity` and `lem:base_change_mate_gstar_transpose` from proof `\uses{}` once tilde-transport route is operative |
| 5 | **SHOULD** | `Picard_FlatteningStratification.tex` | Dispatch prover for G1/G3 bridges (`gf_qcoh_fintype_finite_sections`, `gf_flat_locality_assembly`) — blueprint prose complete, gate-clear |
| 6 | **LOW** | `Picard_GrassmannianCells.tex` | Triage isolated `lem:gr_de...` — confirm it is a genuine helper or add a downstream `\uses{}` reference |
| 7 | **LOW** | `Picard_QuotScheme.tex` line 2334 | Add blueprint block for annihilator reverse inclusion (not blocking anything) |
