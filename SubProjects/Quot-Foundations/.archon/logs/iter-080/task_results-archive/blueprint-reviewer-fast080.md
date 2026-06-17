# Blueprint Review: fast080
**Iter:** 080
**Scope:** Fast-path re-review of `Picard_GlueDescent.tex` and `Picard_GrassmannianQuot.tex`

---

## Per-chapter

### `Picard_GlueDescent.tex`

- **Complete**: true
- **Correct**: true
- **Notes**:
  - All 13 triple-overlap toolkit blocks present: `lem:gr_glueData_bridges`, `_triple_square`, `_triple_preimage`, `_triple_opensFunctor_eq`, `_triple_appIso_compat`, `lem:gr_glueTripleBaseChangeIso` (+`_inv_app`/`_hom_app`), `lem:gr_glueTripleFactorIso`, `_transpose`, `_mate`, `lem:gr_glueLegA/B_component_transpose`, `lem:gr_glueChartFamily_pullback_map_pi`.
  - `lem:gr_glueChartComponent_leg_compat` present with correct `\lean{}` hint and a 4-step proof sketch:
    1. Reduction: cancel `lem:gr_glueTripleFactorIso` (iso), transpose along chart leg `q_pq`, fire triple mate + leg transposes → "conjugated cocycle equation over V_ipq"
    2. Expand each component, pull back along `q_pq = fst ∘ f_ip`
    3. Three moves: pair mate at (i,p) converts `γ_ip^{-1}`; triangle identity consumes unit/counit; cocycle C2 conjugated via `lem:modules_pullback_basechange_transport`, endpoints aligned by `lem:gr_glueData_bridges`
    4. Degenerate pairs (p=i, q=i) handled through `lem:gr_pullbackCongr_hom_eqToHom`
  - `\uses{}` on `lem:gr_glueChartComponent_leg_compat` correctly lists all 10+ dependencies; all exist in chapter (several without `\leanok` but directive confirms ONE sorry = L2081).
  - Downstream chain: `lem:gr_glueChartFamily_equalizes` (leanok) correctly uses `lem:gr_glueChartComponent_leg_compat` and `lem:gr_glueChartFamily_pullback_map_pi`.
  - `leandag build`: `unknown_uses: 0` — no broken `\uses{}` edges.
  - Sync note: `lem:gr_glueData_bridges` and triple-toolkit lemmas lack `\leanok` markers; directive confirms these are proven in Lean — sync artefact only.

**GATE CLEAR** — chapter complete+correct; prover may be dispatched on `glueChartComponent_leg_compat`.

---

### `Picard_GrassmannianQuot.tex`

- **Complete**: true
- **Correct**: true
- **Notes**:
  - `def:gr_universalQuotient_restrictionIso` present (line 2211): instantiates `def:glueRestrictionIso` (leanok in GlueDescent) at Grassmannian glue data. `\uses{}` correct. No `\leanok` yet — expected TO-DO.
  - `lem:gr_universalQuotient_isLocallyFreeOfRank` present (line 2232): proof sketch uses chart images cover + pullback pseudofunctor comparison + `def:gr_universalQuotient_restrictionIso`. Sound.
  - `def:gr_tautologicalRankQuotient` present (line 2258): packages `⟨U, u⟩` as RankQuotient; `\uses{}` correct.
  - `lem:gr_chartComposite_rqPullback` present (line 2757), leanok: bridges pullback of chart composite through free-pullback comparison. Correct.
  - `lem:gr_chartLocus_rqPullback` present (line 2779), TO-BE-PROVEN:
    - `\lean{AlgebraicGeometry.Grassmannian.chartLocus_rqPullback}` — decl not yet in Lean (confirmed by leandag unmatched_lean).
    - `\uses{def:chartLocus, lem:gr_chartComposite_rqPullback, lem:gr_isIso_pullback_map_comp, def:modules_pullbackComp}` — all present and proven.
    - Proof sketch (6 lines): factors preimage inclusion through chart-locus inclusion → invertibility persists along composite (`lem:gr_isIso_pullback_map_comp`) → pseudofunctor comparison + chart-composite bridge (`lem:gr_chartComposite_rqPullback`) identifies with pullback of chart composite of ψ*y → U ≤ chartLocus(ψ*y, I). Clear and sound.
  - `thm:grassmannian_universal_property` (line 2809, leanok statement, proof not yet closed):
    - Proof sketch split into `right_inv` (existence, lines 2917–2932) and `left_inv` (uniqueness, lines 2934–2951).
    - `right_inv`: over each T_I, uses `def:gr_universalQuotient_restrictionIso` to identify φ*U|_{T_I} with free sheaf, then φ*u recovers q|_{T_I} via chart morphism construction. Sound.
    - `left_inv`: factors through lem:gr_chartLocus_rqPullback to locate chart loci of pullback, then lem:gr_chartComposite_rqPullback identifies chart data with ψ-image of universal matrix, closing via `lem:gr_comp_chartMorphism`. Sound.
    - Proof `\uses{}` (line 2855–2863): 20 entries, all present in chapter.
  - `leandag build`: `unknown_uses: 0`.
  - Isolated blueprint node: 1 node in this chapter (leandag shows impact=0, already proved). Disposition: **keep** — zero impact, no unproven downstream.
  - NOTE (pre-existing): `def:gr_modules_glueRestrictionIso` carries a `% NOTE:` that `def:glueRestrictionIso` in GlueDescent.tex is the canonical home; forward-declaration status tracked there. Non-blocking.
  - NOTE (pre-existing): `lem:gr_modules_glue_unique` and `def:gr_modules_glueHom` tagged `% NOTE: forward declaration (planned work)`. Non-blocking for current gate.

**GATE CLEAR** — chapter complete+correct; provers may be dispatched on `lem:gr_chartLocus_rqPullback` and `thm:grassmannian_universal_property` (filling `represents` sorry via `left_inv`/`right_inv`).

---

## Top-level summaries

- **Deps/Isolated**: GrassmannianQuot — 1 isolated blueprint node (proven, impact=0): **keep**.
- **Unmatched `\lean{}`**: `lem:gr_chartLocus_rqPullback` is expected unmatched (TO-BE-PROVEN target for prover).
- No `unknown_uses`, no broken `\uses{}` in either chapter.

## Severity summary

- **must-fix**: none.
- **soon (non-blocking)**: isolated node wire-up in GrassmannianQuot (impact=0, can defer).
