# Blueprint Review Report

## Slug
ts238

## Iteration
238

## Top-level summaries

### Incomplete parts

- `Cohomology_FlatBaseChange.tex` / `lem:pushforward_spec_tilde_iso`: three iter-237 helper decls built by the prover (`IsLocalizedModule.powers_restrictScalars`, `fromTildeΓ_app_isIso_of_isLocalizedModule`, `pushforward_spec_tilde_iso_of_isLocalizedModule`) have no `\lean{}` declaration blocks. An existing `% NOTE:` at L260–268 documents this as a plan-agent action item ("Plan agent: add `\lean{}` blocks for those two helpers + the conditional decl"). The proof sketch for the main lemma is correct and complete for the prover's needs; the missing blocks are a tracking/documentation gap.

### Proofs lacking detail

*(none — all active-lane proofs have adequate sketches)*

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `lem:stalk_tensor_commutation_naturality_right` (~L2151–2210): `\lean{PresheafOfModules.stalkTensorIso_naturality_right}` is **dangling** — the iter-237 prover inlined this as a `have key` step inside `isLocallyInjective_whiskerLeft_of_W` rather than building a standalone decl. An existing `% NOTE:` at L2152–2157 documents this. The directive confirms: "it does not block the group-law lane." **Review-agent action needed**: drop the `\lean{}` pin or repoint it to document the inline result. Does not block this iter's prover dispatch.

### Citation discipline

*(no findings — all `% SOURCE:` lines have `(read from references/...)` parentheticals, cited files exist on disk, quotes appear verbatim)*

## Unstarted-phase blueprint proposals

Two A.2.c-engine sub-phases have zero blueprint coverage. Both are explicitly deferred in PROGRESS.md (rationale: "depend on `def:higher_direct_image` which is itself deferred — re-open when the higher-direct-image sub-lane opens"). The plan agent should either dispatch writers or record the deferral in `iter/iter-238/plan.md`; the PROGRESS.md rationale suffices for the latter.

---

### Proposed chapter: `blueprint/src/chapters/Picard_CMRegularity.tex`

**Covers**: `AlgebraicJacobian/Picard/CMRegularity.lean`
**Strategy phase**: A.2.c-engine (Quot/Cartier, CM-regularity bound — one of the named missing Mathlib gaps in STRATEGY.md)
**Why now**: The HigherDirectImage sub-lane must open before this chapter is dispatchable; writing the blueprint now prevents a wasted iter later and enables parallel prover work once the gate opens.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:castelnuovo_mumford_regularity}` — CM-regularity bound for a coherent sheaf on a projective scheme: `\mathcal{F}` is `m`-regular if `H^i(X, \mathcal{F}(m-i)) = 0` for all `i > 0`. `\lean{AlgebraicGeometry.Modules.isCastelnuovoMumfordRegular}` [expected]. Source: Nitsure §5 (references/nitsure-hilbert-quot), Mumford *Lectures on Curves on Algebraic Surfaces* Lect. 14, or Kleiman §4.
2. `\lemma` `\label{lem:cm_reg_vanishing}` — If `\mathcal{F}` is `m`-regular then `H^i(X, \mathcal{F}(n)) = 0` for `i > 0` and `n \ge m - i`. `\lean{AlgebraicGeometry.Modules.cmReg_vanishing}` [expected]. Source: same; uses `def:higher_direct_image`.
3. `\lemma` `\label{lem:cm_reg_globally_generated}` — An `m`-regular coherent sheaf is globally generated and its Hilbert polynomial stabilises at degree `m`. `\lean{AlgebraicGeometry.Modules.cmReg_globallyGenerated}` [expected]. Source: Nitsure §5; uses `lem:cm_reg_vanishing`.
4. `\theorem` `\label{thm:cm_reg_bound}` — For the Quot-scheme construction, there is a bound `m_0(E, X, L)` such that every quotient sheaf of `E` with Hilbert polynomial `\Phi` is `m_0`-regular. `\lean{AlgebraicGeometry.Modules.cmRegBound_quot}` [expected]. Source: Nitsure §5, Kleiman §4.

**`\uses` skeleton**:
- `lem:cm_reg_vanishing` uses `def:castelnuovo_mumford_regularity`, `def:higher_direct_image`
- `lem:cm_reg_globally_generated` uses `lem:cm_reg_vanishing`
- `thm:cm_reg_bound` uses `lem:cm_reg_globally_generated`, `def:castelnuovo_mumford_regularity`

**Main theorem proof strategy**: Use induction on the Hilbert polynomial and the long exact cohomology sequence to establish vanishing, then apply the Serre-twist argument to bound the regularity globally. Nitsure §5 is the canonical reference.

**References for writer**:
- `references/nitsure-hilbert-quot` (likely path; check `references/summary.md`) — §5 on Castelnuovo-Mumford regularity, the key reference for the Quot representability engine.
- Kleiman §4 (already in `references/kleiman-picard-src/kleiman-picard.tex`) — secondary reference for the specific Quot-scheme bound.
- retrieval needed: Mumford *Lectures on Curves* Lecture 14 (no local file yet) — alternative source for the CM regularity bound, useful if the Nitsure reference is insufficient.

**Subphase choices exposed**:
- Define regularity via sheaf cohomology (Nitsure) vs. via Ext vanishing (more general): the cohomology form is standard for Quot schemes; recommend the Nitsure route. Plan agent should decide before the writer proceeds.

---

### Proposed chapter: `blueprint/src/chapters/Picard_SemiContinuity.tex`

**Covers**: `AlgebraicJacobian/Picard/SemiContinuity.lean`
**Strategy phase**: A.2.c-engine (Quot/Cartier, semicontinuity of fibre cohomology — named in STRATEGY.md Mathlib gaps)
**Why now**: Writes the blueprint for the semicontinuity result consumed by the A.2.c engine; gated behind `def:higher_direct_image` but writing early removes a wasted iter when the gate opens.

**Key declarations** (in dependency order):
1. `\lemma` `\label{lem:cohomology_dimension_upper_semicontinuous}` — For a flat morphism `f : X → S` of finite type with `S` Noetherian, the function `s ↦ dim_{k(s)} H^i(X_s, \mathcal{F}_s)` on the topological space of `S` is upper semicontinuous. `\lean{AlgebraicGeometry.semicontinuity_cohomology_dim}` [expected]. Source: Hartshorne III §12 (references/hartshorne-ag), references/stacks-coherent.tex §Cohomology-and-base-change.
2. `\lemma` `\label{lem:euler_characteristic_locally_constant}` — For a flat proper morphism and a flat coherent sheaf, the Euler characteristic `χ(\mathcal{F}_s)` is locally constant. `\lean{AlgebraicGeometry.eulerCharacteristic_locally_constant}` [expected]. Source: Hartshorne III.12.8, uses `def:higher_direct_image`.
3. `\theorem` `\label{thm:grauert_cohomology}` — If additionally `H^i(X_s, \mathcal{F}_s)` has constant dimension, then `R^i f_* \mathcal{F}` is locally free and the base-change map is an isomorphism. `\lean{AlgebraicGeometry.grauert_cohomologyFormation}` [expected]. Source: Hartshorne III.12.9 (Grauert's theorem).

**`\uses` skeleton**:
- `lem:cohomology_dimension_upper_semicontinuous` uses `def:higher_direct_image`, `lem:higher_direct_image_quasi_coherent`
- `lem:euler_characteristic_locally_constant` uses `lem:cohomology_dimension_upper_semicontinuous`
- `thm:grauert_cohomology` uses `lem:euler_characteristic_locally_constant`

**Main theorem proof strategy**: Upper semicontinuity follows from the long exact cohomology sequence applied to Koszul complexes; Grauert's theorem requires flatness + the derived pushforward base-change comparison. Hartshorne III §12 is the standard reference.

**References for writer**:
- retrieval needed: Hartshorne III §12 (no local file covers this section) — the primary reference; dispatcher should retrieve `references/hartshorne-ag.md` sections covering III.12 before dispatching the writer.
- `references/stacks-coherent.tex` — secondary reference for the Stacks treatment of base-change and semicontinuity.

**Subphase choices exposed**:
- Prove semicontinuity via Koszul complexes (classical) vs. via the derived pushforward (requires derived-category Mathlib infrastructure): the classical route is feasible with Mathlib's current state; recommend it. Plan agent should confirm which Mathlib cohomology API to use.

---

## Per-chapter

### Picard_TensorObjSubstrate.tex

- **complete**: true
- **correct**: true
- **notes**:
  - `lem:stalk_tensor_commutation_naturality_right` (~L2151): `\lean{PresheafOfModules.stalkTensorIso_naturality_right}` is dangling (decl was inlined by iter-237 prover). Existing `% NOTE:` documents this. Review-agent should drop or repoint the pin. **Soon** — does not block the prover lane per directive.
  - `lem:islocallyinjective_whiskerleft_via_stalk` proof block carries `\leanok` but PROGRESS.md reports sorry at Vestigial.lean:299 — likely a `sync_leanok` timing artifact (marker placed before Vestigial.lean was modified). Will self-correct when the prover closes the sorry this iter. **Informational**.
  - **Group-law section confirmed correct** (all blocks `sec:tensorobj_invertibility` + `sec:tensorobj_pic_carrier` ~L2280–2932): `lem:tensorobj_assoc_iso_invertible`, `def:pic_carrier`, `lem:isinvertible_tensor`, `lem:isinvertible_unit`, `lem:isinvertible_inverse_welldef`, `thm:pic_commgroup` — all present, correct, with sound proof sketches and adequate detail for hand formalization.
  - **Associator unconditional confirmed**: `lem:tensorobj_assoc_iso_invertible` correctly uses `lem:tensorobj_assoc_iso` (unconditional) directly — no flatness, no locally-trivial hypothesis.
  - **`\uses{}` DAG confirmed correct** for all group-law blocks. `thm:pic_commgroup` uses `{def:pic_carrier, lem:isinvertible_tensor, lem:isinvertible_unit, lem:isinvertible_inverse_welldef, lem:tensorobj_unit_iso, lem:tensorobj_comm_iso, lem:tensorobj_assoc_iso_invertible}` — all labels exist in the chapter.
  - **HARD GATE: CLEARS** for `Picard/TensorObjSubstrate.lean`.

### Cohomology_FlatBaseChange.tex

- **complete**: true
- **correct**: true
- **notes**:
  - Three iter-237 helper decls (`IsLocalizedModule.powers_restrictScalars`, `fromTildeΓ_app_isIso_of_isLocalizedModule`, `pushforward_spec_tilde_iso_of_isLocalizedModule`) lack `\lean{}` declaration blocks. The `% NOTE:` at L260–268 documents this as a plan-agent action item. **Soon** — blueprint-writer task for a near-future iter; does not block the prover lane since the proof sketch is complete.
  - Main `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` pin acknowledged dangling in the `% NOTE:` (the conditional form `pushforward_spec_tilde_iso_of_isLocalizedModule` was built; the unconditional form is the prover's target this iter). **Informational**.
  - **Route-iii proof sketch confirmed correct**: comparison morphism α (tilde-adjoint of `gammaPushforwardTildeIso`) → reduce to basic opens `D(a)` via `lem:modules_isIso_of_isBasis` → on `D(a)`, source `(restr φ M)[1/a]` equals target `M[1/φa]` by `IsLocalizedModule` compat → iso on each `D(a)` → object iso. Matches the implemented decomposition exactly.
  - **`\uses{}` for `lem:pushforward_spec_tilde_iso` proof**: `{lem:modules_isIso_of_isBasis, lem:gammaPushforwardTildeIso}` — both labels exist in the chapter.
  - **HARD GATE: CLEARS** for `Cohomology/FlatBaseChange.lean`.

### Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### AbelianVarietyRigidity.tex — complete + correct, no notes.

### Albanese_AlbaneseUP.tex

- **complete**: true
- **correct**: true
- **notes**:
  - `lem:symmetric_product_to_jacobian` proof references Riemann-Roch for the generic-fibre birationality identification; the chapter documents this is gated on Route C (a `% NOTE:` at ~L421 records this). Not a must-fix (the block is correct, the gate is documented). **Informational**.

### Picard_IdentityComponent.tex — complete + correct, no notes.

### AbelJacobi.tex — complete + correct, no notes.

### Jacobian.tex — complete + correct, no notes.

### Genus.tex — complete + correct, no notes.

### Rigidity.tex — complete + correct, no notes.

### Cohomology_SheafCompose.tex — complete + correct, no notes.

### Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### Cohomology_MayerVietoris.tex — complete + correct, no notes.

### Differentials.tex — complete + correct, no notes.

### AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### RigidityKbar.tex — complete + correct, no notes. (Documented named-gap, route-a fallback; disposition clearly stated.)

### Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### Picard_IdentityComponent.tex — complete + correct, no notes.

### Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### Picard_LineBundlePullback.tex — complete + correct, no notes.

### Picard_RelPicFunctor.tex — complete + correct, no notes.

### Picard_RelativeSpec.tex — complete + correct, no notes.

### Picard_QuotScheme.tex — complete + correct, no notes.

### Picard_FlatteningStratification.tex — complete + correct, no notes.

### Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### Albanese_CodimOneExtension.tex — complete + correct, no notes.

### Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### Albanese_CoheightBridge.tex — complete + correct, no notes.

### RiemannRoch_WeilDivisor.tex — complete + correct, no notes. (Route C PAUSED.)

### RiemannRoch_OcOfD.tex — complete + correct, no notes. (Route C PAUSED.)

### RiemannRoch_RRFormula.tex — complete + correct, no notes. (Route C PAUSED.)

### RiemannRoch_OCofP.tex — complete + correct, no notes. (Route C PAUSED.)

### RiemannRoch_RationalCurveIso.tex — complete + correct, no notes. (Route C PAUSED.)

### RiemannRoch_H1Vanishing.tex — complete + correct, no notes. (Route C PAUSED.)

## Cross-chapter notes

- `thm:rel_pic_addcommgroup_via_tensorobj` (in `Picard_TensorObjSubstrate.tex`, ~L2949) still `\uses` the old locally-trivial group `lem:tensorobj_isoclass_commgroup`; PROGRESS.md records the repoint to `thm:pic_commgroup` as a standing deferral ("Consumer `\uses` repoint" entry). Non-blocking; repoint when the carrier group lands. **Informational**.

## Severity summary

- **must-act-this-iter** (unstarted-phase proposals):
  - `unstarted-phase proposal: Picard_CMRegularity (A.2.c-engine CM-regularity sub-phase)` — dispatch blueprint-writer for `Picard_CMRegularity.tex` OR record one-line deferral rationale in `iter/iter-238/plan.md`. (Deferral rationale already in PROGRESS.md suffices.)
  - `unstarted-phase proposal: Picard_SemiContinuity (A.2.c-engine semicontinuity sub-phase)` — same action. (Same deferral rationale applies.)
- **soon**:
  - `Picard_TensorObjSubstrate.tex` / `lem:stalk_tensor_commutation_naturality_right`: dangling `\lean{PresheafOfModules.stalkTensorIso_naturality_right}` pin needs review-agent action (drop or repoint).
  - `Cohomology_FlatBaseChange.tex` / `lem:pushforward_spec_tilde_iso`: three helper decls need `\lean{}` blocks (blueprint-writer task).
- **informational**:
  - `Picard_TensorObjSubstrate.tex`: proof `\leanok` on `lem:islocallyinjective_whiskerleft_via_stalk` may be stale (`sync_leanok` timing artifact); will self-correct once the prover closes Vestigial.lean:299 this iter.
  - `Picard_TensorObjSubstrate.tex`: `thm:rel_pic_addcommgroup_via_tensorobj` uses old locally-trivial group reference (standing deferral, documented in PROGRESS.md).
  - `Albanese_AlbaneseUP.tex`: birationality proof references RR (documented as gated on Route C).

Overall verdict: **BOTH active-lane chapters CLEAR the HARD GATE** — `Picard_TensorObjSubstrate.tex` complete+correct (group-law section fully formalizable; d.2-wiring proof sketch sound); `Cohomology_FlatBaseChange.tex` complete+correct (route-iii sketch matches iter-237 implementation). 2 unstarted-phase proposals produced for immediate writer dispatch or deferral recording.
