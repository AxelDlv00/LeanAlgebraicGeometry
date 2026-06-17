# Blueprint Review Report

## Slug
ts239

## Iteration
239

## Top-level summaries

### Incomplete parts

- `Picard_RelPicFunctor.tex` / `def:rel_pic_sharp` + `lem:rel_pic_sharp_functorial` + `thm:rel_pic_sharp_presheaf` + `def:rel_pic_etale_sheafification` + `thm:rel_pic_etale_sheaf_group_structure`: all five Lean bodies are placeholder stubs (`const PUnit` / `0`) documented via NOTE blocks as gated on the Scheme.Modules monoidal-structure gap. The **mathematical descriptions** are correct; the **Lean targets** need a carrier-pivot rewrite (`IsLocallyTrivial` → `IsInvertible`) before the RPF prover can be dispatched. Lane is HELD this iter, so this is not a HARD GATE failure now — but it becomes one the moment the RPF lane re-opens next iter. Blueprint-writer update of this chapter should be scheduled immediately alongside the RPF prover dispatch.

- `Picard_QuotScheme.tex` / `lem:quot_reduction_to_pi_star_W`, `lem:quot_boundedness`, `lem:quot_alpha_injective`, `lem:quot_valuative_criterion`: these four sub-lemma blocks have no `\lean{...}` hints. The mathematical proof sketches are present and sound; the missing hints mean there are no prover-facing Lean targets for these steps. Since the QuotScheme lane is HELD, this is non-blocking now, but should be pinned before the QuotScheme prover is dispatched.

### Proofs lacking detail

None. All active-lane proof sketches are adequate for hand formalization.

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_unit_iso` (`AlgebraicGeometry.Scheme.Modules.pullbackUnitIso`): the proof note says "if `pullbackObjUnitToUnit` is not directly available as an iso, the iso is obtained from the `extendScalars` unit comparison `ε`." This is mildly under-specified for the prover: it should verify whether Mathlib's `SheafOfModules.pullbackObjUnitToUnit` is an iso for **general** morphisms at the pinned commit before choosing a route. Flagged as low-severity Lean difficulty; the alternative `extendScalars` route given in the sketch is adequate fallback.

### Citation discipline

All new blocks in `sec:tensorobj_pullback_monoidality` have correct citation discipline:
- `lem:pullback_tensor_iso`: `% SOURCE: [Stacks Project], …` with `(read from references/stacks-modules.tex, …)` parenthetical. `references/stacks-modules.tex` exists on disk. `% SOURCE QUOTE:` verbatim from Stacks (English original, correct notation). Visible `\textit{Source: …}` line present. ✓
- `lem:pullback_unit_iso`: Archon-original (corollary of `lem:pullback_tensor_iso`); correctly carries no SOURCE block. ✓
- `lem:isinvertible_pullback`: `% SOURCE: [Stacks Project], …` with `(read from references/stacks-modules.tex, …)`. `% SOURCE QUOTE:` verbatim. `% SOURCE QUOTE PROOF:` verbatim proof block present. Visible `\textit{Source: …}` line present. ✓

## Unstarted-phase blueprint proposals

Both proposals below are **repeats from ts238** (still unstarted). The plan agent deferred them last iter with documented rationale (both depend on `def:higher_direct_image` which is itself deferred; non-dispatchable even if written). Same rationale applies this iter. The plan agent should record a one-line re-deferral for each.

### Proposed chapter: `blueprint/src/chapters/Picard_CMRegularity.tex`

**Covers**: (new file, ~1 Lean file `AlgebraicJacobian/Picard/CMRegularity.lean`)
**Strategy phase**: A.2.c-engine (Castelnuovo–Mumford regularity)
**Why now**: Writing the blueprint now (even if the chapter is non-dispatchable) pins the mathematical spec and lets the writer produce a complete outline that the prover can use the moment the higher-direct-image sub-lane opens.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:cm_regular}` — Castelnuovo–Mumford $m$-regularity of a coherent sheaf on a projective scheme. `\lean{AlgebraicGeometry.Scheme.IsCMRegular}` [expected]. Source: Nitsure §2 (`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`).
2. `\lemma` `\label{lem:cm_vanishing}` — $m$-regular ⟹ $H^i(\mathcal{F}(r)) = 0$ for $i ≥ 1$, $r ≥ m$. `\lean{AlgebraicGeometry.Scheme.CMRegular.higherCohomVanishing}` [expected]. Source: Nitsure §2.
3. `\lemma` `\label{lem:cm_globalGeneration}` — $m$-regular ⟹ $\mathcal{F}(m)$ globally generated. Source: Nitsure §2.
4. `\theorem` `\label{thm:mumford_bound}` — Uniform CM-regularity bound: for fixed Hilbert polynomial $\Phi$ and ranks, there exists $m = m(n, p, \Phi)$ such that $E_s$, all its coherent quotients of Hilbert polynomial $\Phi$, and their kernels are $m$-regular. `\lean{AlgebraicGeometry.mumfordRegularityBound}` [expected]. Source: Nitsure §2, Theorem "Mumford".

**`\uses` skeleton**:
- `thm:mumford_bound` uses `def:cm_regular`, `lem:cm_vanishing`, `lem:cm_globalGeneration`, `def:higher_direct_image`
- `lem:cm_vanishing` uses `def:cm_regular`, `def:higher_direct_image`
- `lem:cm_globalGeneration` uses `def:cm_regular`

**Main theorem proof strategy**: The CM-regularity definition (vanishing of twists ≥ m) implies global generation via a Čech-complex argument on affine covers. The Mumford uniform bound is the key non-trivial result, using the Hilbert polynomial stratification and induction on dimension; the proof is in Nitsure §2. All steps depend on `def:higher_direct_image` being in place.

**References for writer**:
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` §2 ("Castelnuovo–Mumford Regularity") — primary source
- `references/stacks-coherent.tex` tag 02KH — background for cohomology-and-base-change step
- `def:higher_direct_image` in `Cohomology_HigherDirectImage.tex` — mandatory `\uses` root

**Subphase choices exposed**:
- Single decomposition: define CMRegular, prove vanishing + global-generation lemmas, then state the Mumford bound. No significant branching.

**Deferral rationale (same as ts238)**: Every declaration depends on `def:higher_direct_image` (itself deferred; the `Cohomology/HigherDirectImage.lean` lane is blocked by a deep Mathlib-absent prerequisite). Blueprint may be written but the prover cannot run until that sub-lane opens. Plan agent: record one-line deferral if the higher-direct-image sub-lane is not being re-opened this iter.

---

### Proposed chapter: `blueprint/src/chapters/Picard_SemiContinuity.tex`

**Covers**: (new file, ~1 Lean file `AlgebraicJacobian/Picard/SemiContinuity.lean`)
**Strategy phase**: A.2.c-engine (semi-continuity of cohomology)
**Why now**: Same rationale as CMRegularity; deferred until higher-direct-image opens.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:flat_base_change_cohomology_map}` — For a flat base change $g: S' \to S$ and proper $f: X \to S$, the canonical map $g^* R^i f_* \mathcal{F} \to R^i f'_* (g')^* \mathcal{F}$. Source: Stacks 02KH.
2. `\theorem` `\label{thm:semicontinuity}` — Semi-continuity of cohomology dimensions: for a proper flat morphism $f: X \to S$ and coherent $\mathcal{F}$ flat over $S$, the function $s \mapsto \dim_{\kappa(s)} H^i(X_s, \mathcal{F}_s)$ is upper semi-continuous on $S$. `\lean{AlgebraicGeometry.semiContinuity_cohomDim}` [expected]. Source: Hartshorne III §12.
3. `\corollary` `\label{cor:euler_char_locally_constant}` — The Euler characteristic $\chi(\mathcal{F}_s)$ is locally constant. Source: Hartshorne III §12.

**`\uses` skeleton**:
- `thm:semicontinuity` uses `def:flat_base_change_cohomology_map`, `def:higher_direct_image`
- `cor:euler_char_locally_constant` uses `thm:semicontinuity`

**Main theorem proof strategy**: Semi-continuity follows from base-change + Čech complex arguments. The key input is flat base change (Stacks 02KH) which requires higher direct images. Hartshorne III §12 is the primary reference; retrieval needed as the PDF has no text layer.

**References for writer**:
- `references/stacks-coherent.tex` tags 02KH, 02KE — cohomology-and-base-change
- Hartshorne III §12 — retrieval needed: no local file currently has §12 verbatim (the local PDF `references/hartshorne-algebraic-geometry.pdf` has no text layer; the plan agent must dispatch a reference-retriever for §12 before this writer can proceed)
- `def:higher_direct_image` in `Cohomology_HigherDirectImage.tex` — mandatory `\uses` root

**Deferral rationale (same as ts238)**: Every declaration depends on `def:higher_direct_image`. Additionally, a reference retriever for Hartshorne III §12 is needed before writing. Plan agent: record one-line deferral if neither the higher-direct-image sub-lane nor the Hartshorne §12 retriever is being dispatched this iter.

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `sec:tensorobj_pullback_monoidality` (NEW): Three blocks (`lem:pullback_tensor_iso`, `lem:pullback_unit_iso`, `lem:isinvertible_pullback`) present, complete, and correct. Proof sketches adequate for a mathlib-build prover. `\uses{}` DAG sound. Source citations correctly reference `references/stacks-modules.tex` for two blocks; unit-iso treated as Archon-original (corollary). HARD GATE CLEARS for all three.
  - `lem:tensorobj_assoc_iso` title fix confirmed: "[Associator for $\otimes_X$ (unconditional)]" — no stale `IsLocallyTrivial`-hypothesis note remaining in the statement block. The body NOTE confirms the hypotheses were dropped because the construction uses none of them. ✓
  - `lem:stalk_tensor_commutation_naturality_right`: no `\lean{}` pin (mathematical content inlined as `have key` in whiskering lemma per the NOTE); label still valid (consumed by `\uses{}` in `lem:islocallyinjective_whiskerleft_via_stalk`'s proof). Not a broken `\uses{}`. **Soon** — review agent should either add an `\mathlibok` or a `% NOTE: no separate Lean target; content inlined` annotation.
  - `thm:rel_pic_addcommgroup_via_tensorobj` still `\uses{lem:tensorobj_isoclass_commgroup}` (deferred per NOTE: repoint to `thm:pic_commgroup` when RPF prover dispatched). Valid label, not broken. **Soon** — repoint before RPF dispatch.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:pushforward_spec_tilde_iso`: expanded three-movement proof sketch confirmed complete and adequate. Movement 1 ($e_{D(a)}$ linear equiv by analogy with `lem:gammaPushforwardIso`), Movement 2 ($D(a)$-level ring equation), Movement 3 (`hloc(a)` via `lem:powers_restrictScalars` + transport-along-equivalence). All `\uses{}` resolve.
  - `\leanok` placement fix confirmed: the conditional form (`lem:pushforward_spec_tilde_iso_conditional`) proof block has `\leanok` on its own line before `\uses{}` — parses correctly.
  - `thm:flat_base_change_pushforward` proof still a documented sorry (deep Čech+flatness; no change from ts238). HARD GATE CLEARS (the deferred sorry is explicitly documented and not the target of this iter's prover).

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Sub-lemmas `lem:quot_reduction_to_pi_star_W`, `lem:quot_boundedness`, `lem:quot_alpha_injective`, `lem:quot_valuative_criterion` have no `\lean{...}` hints. Mathematical content is present and correct. Lean targets not yet pinned. **Soon** — add `\lean{}` hints before the QuotScheme prover is dispatched.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `def:rel_pic_sharp` / `lem:rel_pic_sharp_functorial` / `thm:rel_pic_sharp_presheaf` / `def:rel_pic_etale_sheafification` / `thm:rel_pic_etale_sheaf_group_structure`: Lean bodies are carrier-pivot stubs (`const PUnit`, `0`) pending the `IsInvertible`-carrier rewrite. Mathematical descriptions correct. Gated on `picCommGroup` (landed iter-238) + `IsInvertible.pullback` (this iter's target). **Soon** — dispatch blueprint-writer to update this chapter for the `IsInvertible` carrier BEFORE the RPF prover is dispatched (next iter).
  - `thm:rel_pic_etale_sheaf_unit_canonical`: intentionally no `\lean{}` pin (forward-looking block). Not a defect.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex — complete + correct, no notes.

## Severity summary

- **must-fix-this-iter**: NONE. Both active prover targets clear the HARD GATE.
  - `unstarted-phase proposal: A.2.c-engine (CMRegularity) — dispatch blueprint-writer for Picard_CMRegularity.tex or record deferral` (re-deferral expected; same rationale as ts238: depends on def:higher_direct_image which is blocked)
  - `unstarted-phase proposal: A.2.c-engine (SemiContinuity) — dispatch blueprint-writer for Picard_SemiContinuity.tex or record deferral` (re-deferral expected; same rationale as ts238: depends on def:higher_direct_image + Hartshorne §12 retrieval needed)

- **soon**:
  - `Picard_TensorObjSubstrate.tex` / `lem:stalk_tensor_commutation_naturality_right`: missing `\lean{}` pin (content inlined in whiskering lemma). Review-agent annotation recommended.
  - `Picard_TensorObjSubstrate.tex` / `thm:rel_pic_addcommgroup_via_tensorobj`: `\uses{lem:tensorobj_isoclass_commgroup}` needs repoint to `thm:pic_commgroup` before RPF prover dispatch.
  - `Picard_RelPicFunctor.tex`: carrier-pivot rewrite needed before RPF prover dispatch. Dispatch blueprint-writer alongside RPF prover.
  - `Picard_QuotScheme.tex`: four sub-lemmas missing `\lean{}` hints; add before QuotScheme prover dispatch.
  - `Picard_TensorObjSubstrate.tex` / `lem:pullback_unit_iso`: mildly under-specified Lean route (should clarify whether `pullbackObjUnitToUnit` is an iso for general morphisms at pinned commit). Low impact; prover can use `extendScalars.Monoidal` unit comparison as described.

- **informational**:
  - The structural cleanup pass on `Picard_TensorObjSubstrate.tex` (delete dead duplicate whisker lemma `lem:islocallyinjective_whisker_of_W` + collapse off-path route-(e) apparatus) remains deferred per PROGRESS.md. Non-blocking.

Overall verdict: Both gated chapters clear the HARD GATE — `sec:tensorobj_pullback_monoidality` (three new pullback-monoidality blocks) is complete + correct, and `lem:pushforward_spec_tilde_iso`'s expanded element-free $D(a)$-transport sketch is complete + correct with `\leanok`/`\uses{}` structure valid. 2 phases have no blueprint coverage (CMRegularity, SemiContinuity — same as ts239, deferral re-recordable with same rationale); proposals provided for writer dispatch or re-deferral.
