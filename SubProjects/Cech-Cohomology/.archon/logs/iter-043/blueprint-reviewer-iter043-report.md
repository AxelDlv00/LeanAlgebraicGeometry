# Blueprint Review Report

## Slug
iter043

## Iteration
043

---

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:tile_section_comparison`: missing `\lean{}` hint (intentional
  per NOTE: "pin deferred until Lean decl is built"). This block is on the active prover route; `leandag` cannot
  track its proof status until the hint is added. **informational** — prover assigns name this iter; review
  agent pins post-iter. No wire-up action needed on the `\uses{}` side (edges are correct and present).
- `lean_aux` isolated node: 1 uncovered Lean helper with no blueprint entry. **keep** — not a blueprint gap;
  standalone Lean aux, not orphaned scaffolding.
- `lem:qcoh_localized_sections`: present in the chapter with `\uses{}` edges (non-isolated), but STRATEGY.md
  explicitly marks it as "circular by the old span-cover mechanism, DORMANT (no DAG path to the main theorem)".
  It is not isolated in the graph (other dormant blocks reference it), but it is unreachable from the goal.
  **wire-up / cleanup (soon)** — either re-route its `\uses{}` chain to the active Route-B path or delete it in
  a future writer pass. Non-blocking because it is dormant.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: true
- **correct**: true
- **notes**:

  **HARD GATE CONFIRMATION — 01I8 keystone lane**

  Every block on the active 01I8 prover route is present, proof-detailed, and mathematically sound:

  1. `lem:tile_section_comparison` (Sub-lemma B, the ~100–150 LOC construction): **present; sketch
     adequate for formalization.** The proof identifies a 5-step path — (i) the definitional equality at
     the local-ring-functor (`restrict_obj`) level; (ii) the obstacle: `modulesSpecToSheaf.obj` for `R_g`
     vs `R` differs by base ring AND by not-rfl opens, so the equality is NOT definitional at the
     global-ring level; (iii) upgrade to `R_g`-linear isomorphism by composing with restriction-of-scalars
     along `R_g ≅ Γ(⊤, O_{Spec R_g})`; (iv) transport across both global-sections bookkeeping maps; (v)
     verify naturality in `V` and compatibility with restriction maps, using opens identities from
     `lem:tile_image_opens_identities`. The `\uses{}` edges are correct (`lem:presentation_modulesRestrictBasicOpen`,
     `lem:restrict_obj_mathlib`, `lem:tile_image_opens_identities`). No math wall; the construction is
     bookkeeping of ring structures across a base-change. **No `\lean{}` hint** (intentional: the NOTE
     says "deferred until Lean decl is built"; prover assigns name this iter).

  2. `lem:tile_section_localization`: complete, `\lean{AlgebraicGeometry.tile_section_localization}` present.
     5-step base-ring descent proof with explicit anti-circularity argument. Ready for formalization.

  3. `lem:qcoh_section_kernel_comparison`: complete, `\lean{AlgebraicGeometry.qcoh_section_kernel_comparison}`.
     Two-equalizer diagram argument; naturality square argument explicit and correct.

  4. `lem:qcoh_section_isLocalizedModule` (Route B keystone): complete,
     `\lean{AlgebraicGeometry.qcoh_section_isLocalizedModule}`. Non-circularity paragraph correct —
     all "sections localize" inputs sit on presented tiles, never on the global object; span-cover
     descent is explicitly excluded.

  5. `lem:qcoh_isIso_fromTildeGamma`: complete, `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_quasicoherent}`.
     Assembly uses `lem:fromTildeGamma_mathlib` + `lem:isIso_fromTildeGamma_iff_mathlib` + keystone;
     correct.

  6. `lem:qcoh_iso_tilde_sections`: complete, `\lean{AlgebraicGeometry.qcoh_iso_tilde_sections}`. Downstream
     consumer of the keystone; correct.

  **P5a / P5b coverage**

  All P5a and P5b blocks are present in the consolidated chapter with `\lean{}` hints and adequate
  proof sketches:

  - `lem:cech_augmented_resolution` (`\lean{AlgebraicGeometry.cechAugmented_exact}`): complete sketch.
    Uses `def:cech_nerve` (done) + `lem:cech_acyclic_affine` (P3, done). **NOT gated on 01I8.**
    Scaffold feasible next iter immediately.

  - `def:cohomology_sheaf_is_sheafify_homology` (`\lean{PresheafOfModules.homologyIsoSheafify, ...}`):
    complete sketch (sheafification exact → commutes with homology). **NOT gated on 01I8.**
    Scaffold feasible next iter.

  - `lem:higher_direct_image_presheaf` (`\lean{AlgebraicGeometry.higherDirectImage_iso_sheafify_presheafHomology}`):
    complete sketch. Uses `def:higher_direct_image` (done) + `def:cohomology_sheaf_is_sheafify_homology`.
    **NOT gated on 01I8.** Scaffold feasible next iter.

  - `lem:open_immersion_pushforward_comp` (`\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}`):
    complete sketch (affine morphism → R^q j_* vanishes → then P4 argument). **Gated on 02KG
    (`lem:affine_serre_vanishing`)**, which is gated on 01I8.

  - `lem:cech_term_pushforward_acyclic` (`\lean{AlgebraicGeometry.cechTerm_pushforward_acyclic}`):
    complete sketch. Gated on `lem:open_immersion_pushforward_comp` and 02KG.

  - `lem:cech_computes_cohomology` (P5b protected goal): `\leanok` present, blueprint complete. Proof
    assembles `lem:cech_augmented_resolution` + `lem:cech_term_pushforward_acyclic` + P4 abstract lemma.
    Blueprint gated only on P5a inputs closing.

  **Intentional `\lean{}` gaps (documented in NOTEs, not blueprint errors)**

  - `lem:cech_free_eval_prepend_homotopy`: no `\lean{}` pin. NOTE: "evaluated-complex form is obtained
    by transporting `cechEnginePrepend` across `cechFreeEvalEngineIso`; not a standalone Lean
    declaration." Correct — the Lean proof transports at the `cechEngineComplex` level (pinned by
    `lem:cech_engine_complex`).
  - `lem:cech_free_eval_prepend_homotopy_spec`: same pattern, same rationale.
  - `lem:isIso_fromTildeGamma_of_quasicoherent`: no `\lean{}` pin. NOTE: "Route-A fallback, superseded
    by Route B; pin omitted to avoid duplicating the target." Dormant block; Route B live formalization
    is `lem:qcoh_isIso_fromTildeGamma`.

  **Cosmetic findings**

  - `def:cohomology_sheaf_is_sheafify_homology` uses a `def:` label prefix for a `\begin{lemma}`
    environment. Cosmetic label-type mismatch; no correctness or rendering impact.

  **leandag summary (all clean)**

  - `unknown_uses`: 0 (no broken `\uses{}` edges)
  - Isolated blueprint nodes: 0 (the 1 isolated node is a `lean_aux` helper)
  - 56 unmatched `\lean{}` names: entirely composed of `\mathlibok` Mathlib declarations and
    unformalized active targets — expected for this stage of the project.

  **Blueprint-doctor**: no malformed refs, no orphan chapters, no rendering issues, no axiom
  declarations, no covers problems.

  **Citation discipline**: all `% SOURCE:` lines carry `(read from references/<file>.md)` parentheticals
  pointing to files that exist on disk (`stacks-coherent.tex`, `stacks-schemes.tex`, `stacks-cohomology.tex`,
  `stacks-sheaves.tex`, `homological-acyclic-derived.tex`). SOURCE QUOTES are verbatim English (Stacks
  Project sources are in English). Visible `\textit{Source: …}` lines present on all sourced blocks
  reviewed. No citation fabrication detected.

---

## Severity summary

| Severity | Count | Items |
|---|---|---|
| must-fix-this-iter | 0 | — |
| soon | 1 | `lem:qcoh_localized_sections` dormant/circular cleanup (writer pass) |
| informational | 3 | `lem:tile_section_comparison` missing `\lean{}` (prover assigns this iter); cosmetic `def:` label on lemma env; 56 unmatched lean names (expected progress metric) |

**Overall verdict**: HARD GATE CLEARS for all active prover lanes — 3 chapters audited, 4 findings (0 must-fix, 1 soon, 3 informational), 0 unstarted-phase proposals. The Sub-lemma B sketch for `lem:tile_section_comparison` is mathematically sound and detailed enough for direct formalization; no math wall. P5a partial scaffold (01I8-independent sub-blocks: `lem:cech_augmented_resolution`, `def:cohomology_sheaf_is_sheafify_homology`, `lem:higher_direct_image_presheaf`) is feasible next iter without a blueprint-writer pass; the remaining P5a blocks await 02KG closing.
