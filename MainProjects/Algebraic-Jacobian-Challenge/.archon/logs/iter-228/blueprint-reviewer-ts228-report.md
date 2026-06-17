# Blueprint Review Report

## Slug
ts228

## Iteration
228

---

## ═══ HARD GATE VERDICT — Picard_TensorObjSubstrate.tex ═══

**GATE CLEARS for `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`.**

- **complete: true** — All five iter-228 additions are present and well-formed; the full existing declaration set is intact.
- **correct: true** — No broken `\uses{}`, no mathematically unsound steps, no forbidden-route dependencies, no Lean syntax in blueprint prose.
- **No must-fix-this-iter finding touches this chapter.**

See per-chapter block for full details.

---

## Top-level summaries

### Incomplete parts

- `Picard_FlatteningStratification.tex`: `thm:generic_flatness_algebraic` (algebraic generic-freeness statement) appears as a formal declaration block but has no `\lean{}` pin. The geometric form `thm:generic_flatness → \lean{AlgebraicGeometry.genericFlatness}` is pinned. (HELD lane.)
- `AlgebraicJacobian_Cotangent_GrpObj.tex`: appears to be a pointer chapter with no formal declaration blocks for its covered Lean file. If it carries `% archon:covers AlgebraicJacobian/Cotangent/GrpObj.lean`, at least one pinned declaration block is expected. (Paused genus-0 arm.)

### Proofs lacking detail

None affecting active prover routes.

### Citation discipline

No citation-discipline violations on blocks feeding the active prover route (Picard_TensorObjSubstrate). The two new blocks `lem:restrictscalars_ringiso_dualequiv` and `def:scheme_modules_homMk` are Archon-original (no external source claim required); omitting source lines is correct.

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex

- **complete**: true
- **correct**: true
- **notes**:

  #### GATE-FOCUS CHAPTER — HARD GATE VERDICT: CLEARS

  **1. NEW `lem:restrictscalars_ringiso_dualequiv` (H2′ ingredient for C-bridge).**
  - `\lean{restrictScalarsRingIsoDualEquiv}` — no namespace qualifier, consistent with the analogous H2 lemma `restrictScalarsRingIsoTensorEquiv`. Directive certifies this declaration exists in the Lean file axiom-clean.
  - `\uses{lem:restrictscalars_ringiso_tensorequiv}` — referenced label exists (line ~747); dependency is mathematically appropriate (H2′ is the dual analogue of H2).
  - Statement: `restrictScalars_e(M →_S S) ≅ (restrictScalars_e M →_R R)` via `φ ↦ e⁻¹ ∘ φ`, inverse `ψ ↦ e ∘ ψ`. Both maps are R-linear (e intertwines R- and S-actions; one rewrite per linearity check) and mutually inverse. Proof is complete and mathematically correct.
  - No `\leanok` — correct (sync_leanok manages this automatically once the Lean body closes).

  **2. NEW `def:scheme_modules_homMk` (A-bridge step ii wrapper).**
  - `\lean{AlgebraicGeometry.Scheme.Modules.homMk}` — fully-qualified, consistent with other `Scheme.Modules.*` declarations. Directive certifies axiom-clean in Lean.
  - No `\uses{}` on statement block — correct for a definition. No `\leanok` — correct.
  - Statement accurately characterizes `PresheafOfModules.homMk` at scheme level: takes an ab-group morphism of underlying presheaves plus a sectionwise-linearity hypothesis and produces a morphism of `Scheme.Modules`. Notes `@[simp]` companion `toPresheaf_map_homMk`. Adequate description for a prover.

  **3. EXPANDED `lem:dual_isLocallyTrivial` proof sketch — sufficient to formalize as verbatim mirror.**
  - `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}`. No `\leanok` — correct (THIS iter's primary prover target; not yet formalized).
  - `\uses{lem:internal_hom_isSheaf, lem:tensorobj_restrict_iso, lem:restrictscalars_ringiso_dualequiv}` in both statement and proof blocks — all three labels exist within this chapter.
  - Proof route: Steps 1–3 reused verbatim from the closed `tensorobj_restrict_iso`: (1) reduce restriction to the abstract pullback via `restrictFunctorIsoPullback`; (2) move pullback inside sheafification via `sheafificationCompPullback`; (3) strip outer sheafification with `mapIso`. The blueprint explicitly states this reuse is valid because `dual L` (like `M ⊗_X N`) is of the form `sheafification.obj` of a presheaf — a general fact (every sheaf is canonically the sheafification of its own presheaf). H1 reused verbatim: `pushforwardPushforwardAdj + Adjunction.leftAdjointUniq`. H2′ = `lem:restrictscalars_ringiso_dualequiv` along `f.appIso`. Trivialisation closes: `(dual L)|_U ≅ dual(L|_U) ≅ Hom(O_U, O_U) ≅ O_U` (evaluation-at-1). "No tensor stalk, no whiskering M ◁ η" stated explicitly. Contravariance addressed: `restrictScalars` along a ring isomorphism is an equivalence of module categories, hence commutes with `Hom` in both variances.
  - **No gap detected.** The proof sketch is detailed enough for a prover holding the closed `tensorobj_restrict_iso` proof as template.

  **4. EXPANDED `lem:sheafofmodules_hom_of_local_compat` proof sketch — sufficient.**
  - `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}`. No `\leanok` — correct.
  - Proof (i): forget to ab-sheaf; `presheafHom` as sheaf of types via `Presheaf.IsSheaf.hom` (consuming sheaf condition of N); glue via `existsUnique_gluing` on `TopCat.Sheaf`; `localSection i` data manufactured from each `f_i`; naturality field of `localSection i` identified as the main coherence risk (recommended to build as standalone axiom-clean lemma first); four mechanical sub-steps (a)–(d) enumerated. Proof (ii): sectionwise linearity via separated-presheaf argument; package via `def:scheme_modules_homMk`. Size estimate ~120–190 LOC explicitly noted. "Computes no tensor stalk" confirmed.
  - **No gap detected.**

  **5. CORRECTED `rem:dual_discharges_inverse` — mathematically sound, no eval dependency.**
  - `\uses{lem:tensorobj_inverse_invertible, lem:dual_isLocallyTrivial, lem:sheafofmodules_hom_of_local_compat, lem:isiso_of_isiso_restrict, lem:tensorobj_restrict_iso, lem:tensorobj_unit_iso}` — all six labels exist. `lem:internal_hom_eval` is **NOT** referenced — the forbidden eval route is cleanly excised.
  - Route: `L⁻¹ := dual L`; on each trivialising open U, `tensorObj_restrict_iso` + trivialisation gives `(L ⊗ L⁻¹)|_U ≅ O_U ⊗ O_U`; canonical local contraction `O_U ⊗ O_U → O_U` is the left unitor (an isomorphism); these canonical contractions agree on overlaps (naturality of `tensorObj_restrict_iso` and the unitor under further restriction); glued by A-bridge `lem:sheafofmodules_hom_of_local_compat` to a global morphism; globally iso by B-connector `lem:isiso_of_isiso_restrict`. Argument is mathematically sound: gluing canonical-hence-compatible local contractions → global morphism → locally iso ⇒ globally iso.

  **6. INFORMATIONAL: vestigial `\uses{lem:internal_hom_eval}` in `lem:tensorobj_inverse_invertible` proof block.**
  - The proof block of `lem:tensorobj_inverse_invertible` (lines ~1616–1617) still lists `lem:internal_hom_eval` in `\uses{}`, and the proof prose (~lines 1636–1638) still says "let ε_L be the evaluation of cref{lem:internal_hom_eval}." This is **vestigial**: the corrected `rem:dual_discharges_inverse` has replaced the presheaf-eval route with the gluing-of-local-contractions route. These two blocks' descriptions of how ε_L is constructed are now mutually contradictory.
  - Not blocking this iter: the proof body is a documented placeholder ("infrastructure-blocked") and its `\uses` are not load-bearing for the current Lean formalization. Future writer should align the proof body text with `rem:dual_discharges_inverse` and remove `lem:internal_hom_eval` from the proof block's `\uses`.

  **7. Known deferred items (from PROGRESS.md; not re-flagged).**
  - `lem:tensorobj_unit_iso`, `lem:presheaf_pushforward_adj_substrate`, `lem:restrictscalars_ringiso_strongmonoidal`: missing `\leanok` on axiom-clean blocks — documented as tooling issue (sync_leanok not parsing comma-separated multi-`\lean{..., ...}` form). Deferred to a dedicated polish pass.
  - Vestigial whiskering/stalk blocks (`lem:flat_whisker_localizer`, `lem:islocallyinjective_whisker_of_W`, `lem:whisker_of_W`, `lem:jw_ismonoidal`, `lem:stalk_linear_map`, `lem:isiso_sheafification_map_of_W`): all clearly marked "Superseded route — off path, not to be formalized"; retained for historical record. Their eventual deletion is deferred to the assoc re-route + vestigial apparatus deletion pass.

---

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex

- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:generic_flatness_algebraic` (algebraic form of generic freeness): appears as a formal labeled declaration block but has no `\lean{}` pin. The geometric form `thm:generic_flatness → \lean{AlgebraicGeometry.genericFlatness}` (leanok) is correctly pinned. Plan agent should dispatch a blueprint-writer to add the pin, or record a one-line deferral rationale (HELD lane, A.2.c engine). Per the severity rules this is must-fix-this-iter; it does NOT touch or block the TensorObjSubstrate HARD GATE.

### blueprint/src/chapters/RigidityKbar.tex

- **complete**: partial (assessed from agent summary; full direct read not available)
- **correct**: partial (uncertain without direct read)
- **notes**:
  - Agent summary reports blocks without `\lean{}` hints in certain sections and some declaration blocks without `\leanok`. Unable to determine whether these are declaration blocks missing hints or pure narrative prose sections (where hints are not required). Paused genus-0 arm — not on any active prover route. Plan agent should record a one-line deferral rationale (paused route) and verify the chapter's state directly before re-engaging the genus-0 arm.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex

- **complete**: partial
- **correct**: true
- **notes**:
  - Agent summary reports no formal declaration blocks; chapter is described as a pointer to content in RigidityKbar.tex. If an `% archon:covers AlgebraicJacobian/Cotangent/GrpObj.lean` directive is present, at least one declaration block pinned to that file is expected. If the chapter is intentionally a thin pointer (no Lean declarations to pin), that design choice should be documented in the chapter. Paused genus-0 arm — not on active prover route. Plan agent should record a one-line deferral rationale or dispatch a writer to add the appropriate declaration(s).

---

## Severity summary

**must-fix-this-iter** (per severity rules: any partial/false chapter):

1. `Picard_FlatteningStratification.tex` — `thm:generic_flatness_algebraic` missing `\lean{}` pin → chapter partial. Dispatch blueprint-writer or record deferral (HELD lane, A.2.c engine). Does NOT block TensorObjSubstrate HARD GATE.
2. `AlgebraicJacobian_Cotangent_GrpObj.tex` — no formal declaration blocks for covered Lean file → chapter partial. Dispatch blueprint-writer to add declaration pin(s) or record deferral (paused genus-0 arm). Does NOT block TensorObjSubstrate HARD GATE.

**soon**:

- `RigidityKbar.tex`: uncertain state (blocks possibly missing `\lean{}` hints and `\leanok` markers). Plan agent should verify directly before re-engaging genus-0 arm. Paused route; not blocking any current dispatch.

**informational**:

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_inverse_invertible` proof block: `\uses{lem:internal_hom_eval}` and proof prose lines ~1636–1638 are vestigial under the corrected `rem:dual_discharges_inverse` discharge route. Clean up in a future writer pass (proof body is a documented "infrastructure-blocked" placeholder; no Lean impact this iter).

**HARD GATE for `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`: CLEARS.** The two must-fix findings (Picard_FlatteningStratification.tex, AlgebraicJacobian_Cotangent_GrpObj.tex) do not touch the TensorObjSubstrate chapter; the chapter itself is complete + correct.

**Overall verdict**: HARD GATE CLEARS for TensorObjSubstrate.lean — the focus chapter is complete and correct after iter-228's five additions (lem:restrictscalars_ringiso_dualequiv, def:scheme_modules_homMk, expanded lem:dual_isLocallyTrivial proof, expanded lem:sheafofmodules_hom_of_local_compat proof, corrected rem:dual_discharges_inverse); 2 held/paused chapters are must-fix-this-iter (plan agent should record deferrals); 0 strategy phases lack blueprint coverage; 0 unstarted-phase proposals.
