# blueprint-reviewer — iter-029

**Date:** 2026-06-07  
**Scope:** Whole-blueprint audit (all 6 chapters); HARD-GATE re-review for 3 active chapters  
**Diagnostics:**

| Tool | Result |
|------|--------|
| `leandag show isolated` | **0 isolated nodes** |
| `leandag stats` | 277 nodes, 562 edges, 62.8% proved, 0 ∞-effort nodes |
| `archon blueprint-doctor` | **0 orphan chapters, 0 broken refs, 0 malformed refs, 0 axiom decls** |

---

## HARD-GATE verdicts

### 1. `Cohomology_FlatBaseChange.tex`

```
complete: true
correct:  true
must-fix: none
gate:     PASS — dispatch prover this iter
```

**§1 — `lem:base_change_mate_inner_eCancel_assemble`** (lines 2157–2265):
- `% NOTE:` (lines 2175–2187) explicitly names the X.Modules instance diamond ("nested-image object `G(H(M))` vs composed-functor object `(H⋙G).obj M`"), the term-mode mechanism (`congrArg (· ≫ _)` / `congrArg (_ ≫ ·)` / `Functor.congr_map Γ h`, `.trans`-chained, `exact`-closed), three compiling in-file precedents (`pullbackPushforward_unit_comp`, `base_change_mate_fstar_reindex_legs_gammaDistribute`, `base_change_mate_inner_eCancel_pushforwardComp`), and the direct instruction: "splice them directly; do NOT route through `hpfc`/the bare `gammaMap_pushforwardComp_hom_eq_id`."
- The proof body narratives the residual obstruction, the single-factor surgery resolution, and all three cancellations. **Adequate** to guide the formalization.

**§2 — `lem:base_change_mate_gstar_transpose`** (lines 2414–2545):
- `\uses{}` includes `lem:base_change_mate_inner_eCancel_assemble` + `lem:base_change_mate_fstar_reindex_legs` — the `_legs` routing is explicit in both `\uses{}` and the proof narrative.
- `lem:base_change_mate_inner_value_eq` is cited (as a dependency for the inner value), but the `% NOTE:` (lines 2463–2471) explicitly says it "carries the same `_legs` eCancel obligation as `lem:base_change_mate_inner_eCancel_assemble`; cite it only once that obligation is discharged by the term-mode mechanism." The proof body confirms: "routes through the leg-parametrised reindex … and so carries the same residual eCancel telescoping obligation." **Faithful** — step 3 routes through `_legs` and `_assemble` as required.
- The `% NOTE:` also documents the same nested-image vs composed-functor diamond for the counit-conjugation step.

**§3 — Phantom `base_change_regroup_linearEquiv` ref:** Grep of `Cohomology_FlatBaseChange.tex` for `base_change_regroup_linearEquiv` returns empty. **Confirmed removed.**

**Other observations:**
- `lem:base_change_mate_inner_unitReduce` (A-1), `lem:base_change_mate_inner_eCancel_eUnit` (A-2a), `lem:base_change_mate_inner_eCancel_pushforwardComp` (A-2b), `lem:base_change_mate_inner_eCancel_pullbackComp` (A-2c), `lem:base_change_mate_inner_eCancel` (A-2) — all `\leanok`, `\uses{}` accurate.
- `lem:base_change_mate_inner_value_eq`, `lem:base_change_mate_gstar_generator_close`, `lem:base_change_mate_gstar_counit_transport`, `lem:base_change_mate_section_identity`, `lem:base_change_mate_generator_trace`, `lem:pushforward_base_change_mate_cancelBaseChange` — all `\leanok`, properly chained.
- `lem:affine_base_change_pushforward`, `thm:flat_base_change_pushforward` — both `\leanok`; FBC-B sketch (Mayer–Vietoris equalizer, `lem:flat_preserves_equalizer_mathlib` \mathlibok) present.
- Citation discipline: `% SOURCE:`, `% SOURCE QUOTE:`, `\textit{Source:}` throughout. No phantom anchors detected.

---

### 2. `Picard_QuotScheme.tex`

```
complete: true
correct:  true
must-fix: none
gate:     PASS — dispatch prover this iter
```

**G1-core rewritten as corollary of gap1:** `lem:qcoh_affine_section_localization` (lines 2690–2731) has `% NOTE:` explicitly: "G1-core is now a DOWNSTREAM COROLLARY of gap1 (`lem:qcoh_affine_isIso_fromTildeΓ`)" and "G1-core and gap1 are in fact EQUIVALENT via `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`." The proof derives G1-core from gap1 via `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`. **Confirmed correct.**

**`lem:exists_isIso_fromTildeΓ_basicOpen_cover`** (lines 2752–2804, THIS-ITER prover target):
- Statement: a quasi-coherent sheaf on Spec R has a finite basic-open cover on each member of which the tilde-counit is an isomorphism.
- Proof: QcohData → refine the local-presentation cover to basic opens (using `lem:isBasis_basic_opens_mathlib` + quasi-compactness) → on each D(g_j) transport the local presentation to get a global presentation on D(g_j) → apply `lem:isIso_fromTildeΓ_of_presentation_mathlib` → IsIso on each D(g_j).
- `\uses{}` correctly wires: `lem:isQuasicoherent_quasicoherentData_mathlib`, `lem:isBasis_basic_opens_mathlib`, `lem:isIso_fromTildeΓ_of_presentation_mathlib`, `lem:isLocalizedModule_basicOpen_of_presentation`, `lem:isLocalizedModule_tilde_restrict`.
- The key step ("transporting the local presentation across the affine identification D(g_j) ≅ Spec R_{g_j} via `Presentation.ofIsIso`/`Presentation.map`") is explicit. **Adequate for mathlib-build.**

**Coverage-debt helpers + `\mathlibok` anchor — all confirmed present:**
- `lem:isLocalizedModule_basicOpen_of_presentation` (lines 2611–2630): Route-F endpoint for globally-presented case; `\leanok`-ready.
- `lem:map_units_restrict_basicOpen` (lines 2632–2651): map_units field holding unconditionally; `\leanok`-ready.
- `lem:isUnit_algebraMap_end_basicOpen_mathlib` (lines 2593–2609): `\mathlibok` anchor for `tilde.isUnit_algebraMap_end_basicOpen`.

**Orphaned Route-F anchors — confirmed removed:** Grep for `routeF`/`RouteF` etc. in the chapter returns only one match — the prose string `\textit{The Route-F endpoint for the globally-presented case.}` inside `lem:isLocalizedModule_basicOpen_of_presentation`, which is correct. No orphaned `\label{lem:routeF...}` labels remain.

**Other observations:**
- G1-assemble subsection (lines 2863–3013): `lem:bijective_comp_of_localizations` (`\leanok`), `lem:isIso_sheaf_of_isIso_app_basicOpen` (`\leanok`), `lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict` (`\leanok`), `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (`\leanok`) — all properly chained and `\uses{}` accurate.
- `lem:qcoh_affine_isIso_fromTildeΓ` (gap1, lines 2806–2861): `% NOTE:` documents the module Mayer–Vietoris gluing strategy, the `objSupIsoProdEqLocus` sidestep, and the THIS-ITER routing. `\uses{}` accurate.
- Graded Hilbert–Serre / subquotient induction section: all `\leanok`, complete, no issues.
- Predicates section, Quot functor, Grassmannian: `\leanok` on definitions, proper support chain closed.

---

### 3. `Picard_GrassmannianCells.tex`

```
complete: true
correct:  true
must-fix: none
gate:     PASS — dispatch prover this iter
```

**4 new coverage blocks — all confirmed present** (from prior read, chapter fully read in prior pass):

- `def:gr_chart_transition'`: well-defined with order-swap explanation; `\leanok`.
- `lem:gr_chartTransition'_ringIdentity`: proof with UMP argument; `\leanok`.
- `lem:gr_chartTransition'_fac`: proof with `% NOTE:` documenting `erw [awayPullbackIso_inv_snd]` + `congrArg (_ ≫ ·)` / `Iso.inv_comp_eq` tactic for the GR pullback instance diamond (same mechanism as the memory-resident GR pullback instance diamond); `\leanok`.
- `lem:gr_awayMulCommEquiv_comp_algebraMap`: proof present; `\leanok`.

**`def:gr_glued_scheme` cocycle ring-identity sketch:**
- `% NOTE:` documents partial state (t'/t_fac/ring-identity done; cocycle/GlueData/scheme NOT yet).
- Full `Scheme.GlueData` field-mapping enumeration present (U_I, V_IJ, f_IJ, t_IJ, t'_IJ, J_IJ).
- Cocycle Φ=id ring identity stated explicitly as a ring-homomorphism equality, with proof strategy: "reduce via away-lift UMP to generators, reuse `lem:gr_cocycle_imageMatrix_eq` for (Y_K)^{-1}Y collapse — the ring identity collapses on the standard matrix generators by the same determinant-minor telescoping that closes `lem:gr_cocycle`." This is the THIS-ITER prover target. **Adequate to formalize.**

**Mathlib input anchors:** `lem:mathlib_specMap_localizationAway_isOpenImmersion`, `lem:mathlib_pullbackSpecIso`, `lem:mathlib_isLocalization_away_mul`, `lem:mathlib_isLocalization_algEquiv` — all `\mathlibok`. `lem:gr_separated`, `lem:gr_proper` — both `\leanok` with full valuative-criterion proofs.

---

## Other chapters

**`Cohomology_RegroupHelper.tex`** — Clean, single lemma. `lem:base_change_regroup_linearEquiv` (`\leanok`) correctly proves the tensor regrouping isomorphism via `Algebra.IsPushout.cancelBaseChange`. No issues.

**`Picard_FlatteningStratification.tex`** — `thm:generic_flatness_algebraic` marked `% NOTE: CLOSED, axiom-clean`. Chapter is in DONE state per STRATEGY.md. Brief read confirms structure is intact. No issues.

**`Picard_RelativeSpec.tex`** — `def:qc_sheaf_of_algebras` (`\leanok`), `thm:relative_spec_exists` (`\leanok`). The iter-179 Block A refactor note is present (documenting the NatTrans.Coequifibered carrier upgrade). No coverage debt detected in the brief read.

---

## Graph integrity

- **0 isolated nodes** — all nodes (including the new gap1, G1-assemble, and GR-glue coverage blocks) properly wired.
- **0 unknown `\uses{}`** — no broken label references.
- **63 unmatched `\lean{}`** — expected for nodes whose Lean declarations do not yet exist; not a blueprint defect.
- **39 nodes need `\leanok`** — expected unformalized nodes; not a blueprint defect.
- **0 ∞-effort nodes** — all remaining effort is finite (total remaining ≥ 58,808 Lean chars).

---

## Unstarted-phase proposals

No new unstarted phases to propose this iter. The three active lanes (FBC-A, GR-glue, QUOT-defs via gap1) are gated and ready:

- **FBC-A:** eCancel assembly (`lem:base_change_mate_inner_eCancel_assemble`) + gstar_transpose — closed term-mode mechanism, all atoms present, dispatch immediately.
- **GR-glue:** cocycle ring identity Φ=id + `def:gr_glued_scheme` GlueData assembly — all chart/transition/cocycle atoms `\leanok`, dispatch immediately.
- **QUOT-defs / gap1:** `lem:exists_isIso_fromTildeΓ_basicOpen_cover` — sub-build fully specified, dispatch immediately.

**Open Q1 (SNAP route)** remains deferred until gap1 lands, per STRATEGY.md. No new evidence to accelerate that decision.

---

## Summary

All three gate chapters (`Cohomology_FlatBaseChange`, `Picard_QuotScheme`, `Picard_GrassmannianCells`) return `complete: true`, `correct: true`, and no must-fix items. The whole-blueprint graph is clean (0 isolated nodes, 0 broken refs). Prover dispatch on all three is cleared for iter-029.
