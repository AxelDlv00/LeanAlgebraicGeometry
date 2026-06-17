# Blueprint Review Report

## Slug
keystone-rereview

## Iteration
041

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:affine_cech_vanishing_qcoh`: proof invokes `lem:qcoh_iso_tilde_sections` (conditional form, requires `[IsIso F.fromTildeΓ]`) for a general quasi-coherent `F`, but `\uses{}` omits `lem:qcoh_isIso_fromTildeGamma` (which provides that instance). **wire-up** — add `\uses{lem:qcoh_isIso_fromTildeGamma}` to both the statement and proof blocks of `lem:affine_cech_vanishing_qcoh`. *(Soon-severity: `lem:affine_cech_vanishing_qcoh` is not being dispatched this iter; out-of-order risk is for a future iter when that lemma is targeted.)*

- `Cohomology_CechHigherDirectImage.tex` / `lem:qcoh_localized_sections` (Route A dormant, ~L5019): uses `lem:isLocalizedModule_of_span_cover` with the same circular mechanism as the old keystone — the per-`j` hypothesis `IsLocalizedModule (powers f) g_{s_j}` requires `Γ(X,F)_{s_j} ≅ Γ(D(s_j),F)`, which is the keystone-at-`s_j`. **soon** — this lemma is Route A (dormant fallback), not on the live 01I8 path; schedule a cleanup directive (see Question 3 below). Do NOT remove; the blocks are kept as axiom-clean dormant assets.

- Isolated DAG node: one `lean_aux` node (unnamed in leandag output), no `\uses{}` in or out. **keep** — it is an uncovered Lean helper, not a blueprint node; no blueprint action needed.

### Proofs lacking detail

*(None: all four new sub-lemmas and the re-routed keystone carry sufficient detail for formalization — see per-chapter findings below.)*

---

## Question 1: Must-fix resolved?

**YES. The must-fix is fully resolved.**

### Non-circularity: genuine

The re-routed keystone proof is non-circular in exactly the sense required. Tracing the dependency chain:

1. `lem:qcoh_section_equalizer` — pure sheaf axiom applied to the finite cover `{W ∩ D(gⱼ)}` of `W`; no external lemma invoked; no "sections localise" input of any kind. **No `\uses{}` needed; no circular risk.**

2. `lem:localized_module_map_exact_mathlib` — `\mathlibok`, `\lean{IsLocalizedModule.map_exact}`. **Verified**: `IsLocalizedModule.map_exact` exists in Mathlib at `Mathlib/Algebra/Module/LocalizedModule/Exact.lean`. No project obligation.

3. `lem:tile_section_localization` — depends on:
   - `lem:qcoh_finite_presentation_cover` (B1 — supplies the cover `{gⱼ}` whose tiles are globally presented)
   - `lem:presentation_modulesRestrictBasicOpen` (B4 — presents the tile `F_{(g)}` globally over `Spec R_g`) → **proved=True**
   - `lem:section_isLocalizedModule_of_presentation` (DONE tile lemma — gives `IsLocalizedModule (powers f̄)` of the section-restriction on the presented tile) → **proved=True**
   - `lem:restrict_obj_mathlib` (`\mathlibok`, `\lean{AlgebraicGeometry.Scheme.Modules.restrict_obj}`) — **Verified**: exists in Mathlib at `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:328` in namespace `AlgebraicGeometry.Scheme.Modules`. The `leandag` `unmatched_lean` entry for this node is expected: leandag scans project files, not Mathlib packages. No correctness issue.

   The tile lemma operates entirely on `F_{(g)}` (a globally presented tile where `F` is tilde via B4) and never on the global object. **Non-circularity preserved.**

4. `lem:qcoh_section_kernel_comparison` — uses `lem:qcoh_section_equalizer`, `lem:localized_module_map_exact_mathlib`, `lem:tile_section_localization` (via their `\uses` blocks). The kernel-comparison argument (two left-exact sequences intertwined by the per-tile isos, kernels compared) is spelled out in full, including the naturality square justification (`δ′ ∘ iso = iso ∘ δ_f` because restriction and localisation at `f` are induced by the same ring map). **Sufficient for formalization.**

5. `lem:qcoh_section_isLocalizedModule` (keystone) — `\uses{lem:qcoh_finite_presentation_cover, lem:qcoh_section_equalizer, lem:localized_module_map_exact_mathlib, lem:tile_section_localization, lem:qcoh_section_kernel_comparison, lem:section_isLocalizedModule_of_presentation}`. The proof delegates immediately to `lem:qcoh_section_kernel_comparison` and includes an explicit non-circularity paragraph explaining that the only "sections-localise" inputs are per-tile (`F_{(gⱼ)}` is tilde), the global result is recovered by the sheaf axiom and exactness of localisation, and no instance of the keystone at the `gⱼ` is invoked. The circular edge to `lem:isLocalizedModule_of_span_cover` is **absent** from both statement and proof `\uses{}` blocks.

### `\uses` accuracy

leandag `unknown_uses: []` — no broken edges. All six `\uses` entries in the keystone are valid labels defined elsewhere in the chapter. The four sub-lemmas' `\uses` blocks are accurate (cross-checked against proof prose). One minor observation: `lem:qcoh_section_isLocalizedModule` lists `lem:section_isLocalizedModule_of_presentation` in its `\uses` even though the proof delegates that step to `lem:tile_section_localization` → `lem:section_isLocalizedModule_of_presentation` (a 2-hop dependency). This is a redundant but not incorrect `\uses` entry — it makes the non-circularity explicit without adding a false edge.

### Proof detail assessment

All four sub-lemma proofs are sufficient for formalization:
- `lem:qcoh_section_equalizer`: single-paragraph, every claim is a direct reading of the sheaf axiom; formalizable by `simp [sheaf_condition]` style.
- `lem:tile_section_localization`: step-by-step, names every lemma invoked (B4, tile lemma, `restrict_obj`), explains the `Spec R_g`-to-`D(g)` transport explicitly.
- `lem:qcoh_section_kernel_comparison`: both equalizer sequences written out, localisation step cited, product isomorphisms written, naturality argument given, kernel comparison conclusion made explicit.
- `lem:qcoh_section_isLocalizedModule`: structural proof (reduce to kernel comparison), non-circularity paragraph.

---

## Question 2: Chapter verdict

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: true
- **correct**: partial
- **notes**:
  - *(must-fix from iter-041 — RESOLVED)* keystone `lem:qcoh_section_isLocalizedModule`: the circular `lem:isLocalizedModule_of_span_cover` descent step has been removed and replaced by the non-circular sheaf-axiom equalizer route. Four new sub-lemmas with accurate `\uses` chains fill the gap. No remaining must-fix on this topic.
  - *(soon — wire-up)* `lem:affine_cech_vanishing_qcoh` is missing `\uses{lem:qcoh_isIso_fromTildeGamma}`. The proof applies `lem:qcoh_iso_tilde_sections` (conditional form) to a general quasi-coherent `F`, which requires `[IsIso F.fromTildeΓ]`; that instance is provided by `lem:qcoh_isIso_fromTildeGamma` (the keystone's direct downstream). Without the wire-up, the planner could dispatch a prover at `lem:affine_cech_vanishing_qcoh` before `lem:qcoh_isIso_fromTildeGamma` is proved. Add `\uses{lem:qcoh_isIso_fromTildeGamma}` to `lem:affine_cech_vanishing_qcoh`.
  - *(soon — dormant cleanup)* `lem:qcoh_localized_sections`: circular by the same old mechanism (see Question 3). Route A dormant; schedule cleanup.

### Hard gate determination

The sole must-fix finding from iter-041 is resolved. All remaining findings are soon-severity. **The two targeted sub-lemmas are ready:**

- `lem:qcoh_section_equalizer`: no dependencies; proof is the sheaf axiom. Blueprint entry complete + correct. **READY.**
- `lem:tile_section_localization`: all three DONE dependencies present (`section_isLocalizedModule_of_presentation` proved=True, `presentation_modulesRestrictBasicOpen` proved=True, `restrict_obj_mathlib` `\mathlibok` verified). `lem:qcoh_finite_presentation_cover` (proved=False) exists in the Lean file with a full proof body (no sorry, 904 chars of lean_source) — a prover can use it as a dependency. Blueprint entry complete + correct. **READY.**

**HARD GATE CLEARS for dispatching provers at `lem:qcoh_section_equalizer` and `lem:tile_section_localization`.**

The `correct: partial` verdict is due to the soon-severity `lem:affine_cech_vanishing_qcoh` wire-up and the dormant `lem:qcoh_localized_sections` circularity, neither of which falls in the dependency closure of the two targeted sub-lemmas. The plan agent should proceed with dispatch and log the two soon findings for a follow-up writer pass before `lem:affine_cech_vanishing_qcoh` is dispatched.

---

## Question 3: `lem:qcoh_localized_sections` path analysis

**DORMANT — not on any live path to 01I8.**

DAG evidence:
- `lem:qcoh_localized_sections` forward edges: only `lem:qcoh_global_generation` (Route A global-generation step).
- `lem:qcoh_global_generation` feeds Route A dormant blocks (`lem:qcoh_kernel_qcoh`, `lem:isIso_fromTildeGamma_of_genSections`, etc.).
- BFS backward from `lem:cech_computes_cohomology` (the project's main theorem node) does **not** include `lem:qcoh_localized_sections`, `lem:qcoh_global_generation`, or any Route A node in its upstream closure.
- `lem:qcoh_section_isLocalizedModule` (the live keystone) does not `\uses` `lem:qcoh_localized_sections` in either statement or proof block.

The blueprint prose at `rem:o1i8_decomposition` (~L4647) explicitly designates Route A as "dormant fallback... off the live 01I8 critical path" and says "its blocks below are kept as dormant axiom-clean assets."

**Circularity classification**: The same mechanism applies — the per-`j` hypothesis for `lem:isLocalizedModule_of_span_cover` inside `lem:qcoh_localized_sections` requires `Γ(X,F)_{s_j} ≅ M_j = Γ(D(s_j),F)`, which is the keystone-at-`s_j`. Unlike the re-routed keystone, this is not fixed by the re-route (it would require the same sheaf-axiom equalizer treatment). However, since `lem:qcoh_localized_sections` has no path to the main theorem, the circularity does not threaten 01I8.

**Recommendation for planner backlog**: Schedule a blueprint-writer cleanup directive for `lem:qcoh_localized_sections` before it is ever added to a prover route. The fix is the same sheaf-axiom equalizer route (already established by the keystone re-route). No urgency; not blocking any current or planned prover dispatch.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - *(must-fix resolved)* `lem:qcoh_section_isLocalizedModule`: circular descent step removed; four non-circular sub-lemmas introduced with complete `\uses` chains. No remaining must-fix.
  - *(soon — wire-up)* `lem:affine_cech_vanishing_qcoh`: add `\uses{lem:qcoh_isIso_fromTildeGamma}` to statement and proof blocks.
  - *(soon — dormant cleanup)* `lem:qcoh_localized_sections`: circular by the same mechanism as old keystone; dormant Route A node, not on live path.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

---

## Severity summary

No must-fix-this-iter findings.

**Soon:**
1. `Cohomology_CechHigherDirectImage.tex` / `lem:affine_cech_vanishing_qcoh`: add `\uses{lem:qcoh_isIso_fromTildeGamma}` before this lemma is dispatched to a prover (instance-inference ordering dependency on the keystone's downstream).
2. `Cohomology_CechHigherDirectImage.tex` / `lem:qcoh_localized_sections`: schedule writer cleanup (same circular mechanism as old keystone; dormant Route A node currently harmless).

**Overall verdict:** Must-fix from iter-041 is resolved; the keystone re-route constitutes a complete, correct, non-circular textbook-level argument; HARD GATE CLEARS for dispatching provers at `lem:qcoh_section_equalizer` and `lem:tile_section_localization`; 2 soon-severity findings logged for future writer attention.
