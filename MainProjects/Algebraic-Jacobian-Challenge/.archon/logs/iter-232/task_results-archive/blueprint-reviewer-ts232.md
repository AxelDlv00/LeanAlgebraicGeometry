# Blueprint Review Report

## Slug
ts232

## Iteration
232

## Top-level summaries

### Incomplete parts

- **`Picard_TensorObjSubstrate.tex`** / `lem:dual_isLocallyTrivial` proof step 3: references `\mathtt{dual\_unit\_iso}` by name but there is NO `\label{lem:dual_unit_iso}`, NO `\lean{}` pin, and NO dedicated declaration block anywhere in the chapter. The prover needs `dual_unit_iso : dual 𝒪 ≅ 𝒪` as a named target. Must add.

- **`Picard_TensorObjSubstrate.tex`** / `lem:dual_restrict_iso` proof step (a): the per-`V` slice equivalence `Over_Y V ≌ Over_X (f.opensFunctor V)` is the STRATEGY-designated first incremental sub-deliverable (file-split reset, iter-232 directive: "first standalone deliverable: the per-`V` slice equivalence"). It is described only in proof prose at L2959–2972; there is no `\label{}`, no `\lean{}` pin, and no dedicated named block. The prover cannot be directed to this as a named target without it.

- **`Picard_QuotScheme.tex`**: Main theorems (`thm:grassmannian_representable`, `thm:quot_representable`) are complete with 4-step proof sketches. A sub-lemmas section begins (`lem:quot_reduction_to_pi_star_W` etc.) but is incomplete — the agent read terminated midway and multiple sub-lemmas appear as stubs. HELD engine chapter; prover is not dispatched, but blueprint must be writer-completed.

- **`Picard_FlatteningStratification.tex`**: PROGRESS.md (ts229 deferred finding) records a missing `\lean{}` pin on this chapter. Agent read confirmed main theorems are present but the chapter is HELD; must-fix is deferred with Route-A-engine-hold rationale.

- **`Albanese_AlbaneseUP.tex`** / `def:symmetric_power_curve`: explicitly marked `\notready` — the scheme-theoretic symmetric power `Sym^g(C)` has no construction (gated A.2.c). Gated chapter; deferral acceptable.

- **`RigidityKbar.tex`**: `thm:rigidity_over_kbar` has `\leanok` but sorry body. Four pieces (i)–(iv) are documented gaps; piece (iv) Serre duality is ON critical path (iter-155 correction). Route C PAUSED; deferral with USER-PAUSE rationale acceptable.

- **`RiemannRoch_H1Vanishing.tex`** / `lem:isFlasque_injective`: proof explicitly deferred (~100–150 LOC, extension-by-zero scaffolding). Route C PAUSED.

- **`RiemannRoch_RationalCurveIso.tex`** / `lem:degree_via_pole_divisor`: `poleDivisor` is a typed sorry pending iter-183+ closure; `lem:degree_one_morphism_iso` has multiple undocumented sub-obligations. Route C PAUSED.

### Proofs lacking detail

- **`Picard_TensorObjSubstrate.tex`** / `lem:sheafofmodules_hom_of_local_compat` proof, L3173–3176: asserts that `lem:dual_isLocallyTrivial` (the C-bridge) and the A-engine share `lem:open_immersion_slice_sheaf_equiv` as a common root — explicitly false per iter-230 empirical binding probe. The C-bridge (`lem:dual_restrict_iso`) operates at the **presheaf-of-modules level** over the varying ring `𝒪(V)`, NOT through the sheaf-level fixed-value-cat root `overSliceSheafEquiv`. A prover working on the A-engine reading this rationale would be misled about the C-bridge. Needs correcting (this was flagged as a non-blocking follow-up in PROGRESS.md but is a blueprint correctness issue).

### Multi-route coverage

- Route A (active): **COVERED** across `Picard_TensorObjSubstrate.tex` through `Picard_FGAPicRepresentability.tex`, `Picard_IdentityComponent.tex`, `Picard_Pic0AbelianVariety.tex`, and Albanese chain. Coverage is gated at the A.1.c.SubT (C-bridge) step but the chapters exist.
- Route C (Riemann–Roch): **PAUSED** by USER standing directive. Chapters exist (`RiemannRoch_*`) but are partially incomplete. Acceptable under the pause.
- A.2.c-engine (`R^i f_*`, CM-regularity, semicontinuity, Relative Proj): **PARTIAL** — `Cohomology_FlatBaseChange` (i=0) is now wired in content.tex and is complete+correct. The deeper engine components (`R^i f_*` for i≥1, CM-regularity, semicontinuity) have NO blueprint coverage. Proposals provided below.

---

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Cohomology_HigherDirectImage.tex`

**Covers**: `AlgebraicJacobian/Cohomology/HigherDirectImage.lean` (new file)
**Strategy phase**: A.2.c-engine — `R^i f_*` (i≥1), the deepest root of the Quot/Hilbert representability engine
**Why now**: `R^i f_*` (i≥1) is the single deepest un-blueprinted root of the A.2.c representability engine; every downstream engine component (CM-regularity, semicontinuity, FGA Step 2 m-regularity bound) depends on it, and writing this chapter now is the minimal action that makes the USER parallelism directive actionable on a second prover lane.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:higher_direct_image}` — `R^i f_*\mathcal{F}` as the i-th right derived functor of the pushforward for a quasi-coherent sheaf `\mathcal{F}` on a quasi-compact quasi-separated morphism `f : X → S`. `\lean{AlgebraicGeometry.higherDirectImage}` [expected]. Source: `references/stacks-coherent.tex`, §Cohomology of Schemes, higher direct images.
2. `\lemma` `\label{lem:higher_direct_image_quasi_coherent}` — `R^i f_*\mathcal{F}` is quasi-coherent when `f` is quasi-compact and quasi-separated and `\mathcal{F}` is quasi-coherent. `\lean{AlgebraicGeometry.higherDirectImage_isQuasiCoherent}` [expected]. Source: Stacks Tag 02KE / `references/stacks-coherent.tex` §Higher direct images.
3. `\lemma` `\label{lem:higher_direct_image_affine_vanishing}` — For `f` affine and `i ≥ 1`, `R^i f_*\mathcal{F} = 0`. `\lean{AlgebraicGeometry.higherDirectImage_affine_eq_zero}` [expected]. Source: Stacks Tag 02KG / `references/stacks-coherent.tex`.
4. `\theorem` `\label{thm:flat_base_change_higher}` — Flat base change for `R^i f_*`: the canonical map `g^*(R^i f_*\mathcal{F}) → R^i f'_*(g'^*\mathcal{F})` is an isomorphism when `g` is flat. `\lean{AlgebraicGeometry.flatBaseChange_higherDirectImage_isIso}` [expected]. Source: Stacks Tag 02KH (i≥1 case) / `references/stacks-coherent.tex`.

**`\uses` skeleton**:
- `thm:flat_base_change_higher` uses `lem:higher_direct_image_quasi_coherent`, `def:higher_direct_image`, `def:pushforward_base_change_map`
- `lem:higher_direct_image_affine_vanishing` uses `def:higher_direct_image`
- `lem:higher_direct_image_quasi_coherent` uses `def:higher_direct_image`

**Main theorem proof strategy**: Reduce flat base change to the affine target case using quasi-coherence of `R^i f_*`; in the affine case reduce to algebra via the Čech complex (as in the i=0 case of `Cohomology_FlatBaseChange`); use flatness of `g` to commute `- ⊗_A B` through cohomology of the Čech complex. The affine vanishing lemma (d.2) blocks the separated/quasi-separated induction from descending to trivial i≥1 cases.

**References for writer**:
- `references/stacks-coherent.tex`, §Cohomology of Schemes, Tags 02KE–02KH — primary source for higher direct images and flat base change
- `references/stacks-coherent.md` — companion summary
- `references/hartshorne-algebraic-geometry.md` → Hartshorne III §5, Theorem 5.2 — alternative presentation

**Subphase choices exposed**:
- Choice A: Derived-category formulation (`Rf_*`) vs. Choice B: Classical cohomology sheaf `R^i f_*`. Recommendation: Choice B (classical) aligns with the rest of the project's style and avoids importing a derived-category framework.
- Sub-question: Whether to define `R^i f_*` directly via Čech cohomology on affines and glue, or via injective resolutions. Recommendation: Čech approach (matches `Cohomology_FlatBaseChange` style, avoids injective-resolution infrastructure).

---

### Proposed chapter: `blueprint/src/chapters/Picard_CMRegularity.tex`

**Covers**: `AlgebraicJacobian/Picard/CMRegularity.lean` (new file)
**Strategy phase**: A.2.c-engine — Castelnuovo–Mumford regularity, the mechanism bounding the twist `m` in FGA Step 2
**Why now**: CM-regularity is the missing mechanism in `Picard_FGAPicRepresentability.tex` Sorry 5 ("Rank 3 via m-regularity bound") — even if Route C re-engages, this chapter must exist first to provide the step.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:castelnuovo_mumford_regularity}` — An `\mathcal{O}_X`-module `\mathcal{F}` is `m`-regular (Castelnuovo–Mumford) if `H^i(X, \mathcal{F}(m-i)) = 0` for all `i ≥ 1`, where `\mathcal{O}_X(1)` is a chosen ample line bundle. `\lean{AlgebraicGeometry.IsCMRegular}` [expected]. Source: `references/kleiman-picard-src/kleiman-picard.tex` §4 (Step 2 of proof of th:main); `references/nitsure-hilbert-quot.md`.
2. `\lemma` `\label{lem:cm_regularity_implies_global_generation}` — If `\mathcal{F}` is `m`-regular then it is globally generated by `\mathcal{F}(m)`. `\lean{AlgebraicGeometry.IsCMRegular.globallyGenerated}` [expected]. Source: Standard; `references/hartshorne-algebraic-geometry.md` III §5.
3. `\lemma` `\label{lem:cm_regularity_h1_vanishing}` — If `\mathcal{F}` is `m`-regular on a smooth proper curve, `H^1(C, \mathcal{F}(n)) = 0` for `n ≥ m`. `\lean{AlgebraicGeometry.IsCMRegular.h1_vanishing}` [expected]. Source: Riemann–Roch specialisation; `references/stacks-coherent.tex` Tag 02KH.
4. `\theorem` `\label{thm:twist_bound_m_regularity}` — For each Hilbert polynomial `\phi`, there exists `m₀` such that every line bundle `\mathcal{L}` on `C` with Hilbert polynomial `\phi` is `m₀`-regular. `\lean{AlgebraicGeometry.Scheme.twistBound_of_hilbertPolynomial}` [expected]. Source: Kleiman §4 Step 2 / Stacks Tag 02KH regularity argument.

**`\uses` skeleton**:
- `thm:twist_bound_m_regularity` uses `lem:cm_regularity_h1_vanishing`, `def:castelnuovo_mumford_regularity`, `def:hilbert_polynomial` (from `Picard_QuotScheme.tex`)
- `lem:cm_regularity_h1_vanishing` uses `def:castelnuovo_mumford_regularity`, and depends on Riemann–Roch (Route C substrate)
- `lem:cm_regularity_implies_global_generation` uses `def:castelnuovo_mumford_regularity`

**Main theorem proof strategy**: Bound `m₀` in terms of the degree of the line bundle and the genus `g` via `m₀ ≥ 2g - 1 - d + deg 𝒪_C(1)`; use Serre duality / Riemann–Roch to show `H^1(C, ℒ(n)) = 0` for `n ≥ m₀`; deduce the vanishing necessary for `m₀`-regularity. This is Route C dependent at the Riemann–Roch step.

**References for writer**:
- `references/kleiman-picard-src/kleiman-picard.tex` §4, proof of th:main Step 2 — primary
- `references/hartshorne-algebraic-geometry.md` III §5 — Serre vanishing and regularity
- `references/stacks-coherent.tex` — cohomological bounds

**Subphase choices exposed**:
- The m-regularity bound requires either Riemann–Roch (Route C) or a direct-computation substitute for smooth proper curves. If Route C remains paused, the `thm:twist_bound_m_regularity` body must be sorry-axiomatized; the definition and its simpler consequences (`lem:cm_regularity_implies_global_generation`) can be written Route-C-free. Recommendation: write the full chapter now; sorry-axiomatize the Route-C-dependent theorem; this mirrors the project's option-(c) posture.

---

### Proposed chapter: `blueprint/src/chapters/Picard_SemiContinuity.tex`

**Covers**: `AlgebraicJacobian/Picard/SemiContinuity.lean` (new file)
**Strategy phase**: A.2.c-engine — semicontinuity of cohomology, needed for the stratification of `Pic^\sharp_(C/k)et` by Hilbert polynomial (FGA Theorem Step 1)
**Why now**: The stratification step of `thm:fga_pic_representability` (Step 1: decompose by Hilbert polynomial) depends on openness of the flat locus and on the Hilbert polynomial varying semicontinuously. Without this chapter the step has no blueprint support.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:euler_characteristic_family}` — For a flat proper family `f : X → S` and a coherent sheaf `\mathcal{F}` on `X`, the Euler characteristic `χ(X_s, \mathcal{F}_s)` as a function of `s ∈ S`. `\lean{AlgebraicGeometry.eulerCharacteristicFamily}` [expected]. Source: `references/stacks-coherent.tex` §Euler characteristic; EGA III §7.
2. `\theorem` `\label{thm:euler_characteristic_locally_constant}` — For `f : X → S` proper flat with `S` connected, `s ↦ χ(X_s, \mathcal{F}_s)` is locally constant on `S`. `\lean{AlgebraicGeometry.eulerCharacteristicFamily_isLocallyConstant}` [expected]. Source: Kleiman §4 Step 1 / EGA III 7.9.4.
3. `\theorem` `\label{thm:upper_semicontinuity_cohomology}` — For `f : X → S` proper flat and `\mathcal{F}` flat coherent, `s ↦ dim H^i(X_s, \mathcal{F}_s)` is upper semicontinuous. `\lean{AlgebraicGeometry.upperSemiContinuity_cohomology}` [expected]. Source: `references/stacks-coherent.tex` Tag 0BDI / Hartshorne III §12.
4. `\lemma` `\label{lem:hilbert_polynomial_stratification}` — The collection `{P^φ : φ ∈ Q[n]}` of sub-functors of `Pic^\sharp_(C/k)et` stratified by Hilbert polynomial is a disjoint open decomposition. `\lean{AlgebraicGeometry.Scheme.picSharp_hilbertPolynomialStratification}` [expected]. Source: Kleiman §4 Step 1 / `references/kleiman-picard-src/kleiman-picard.tex`.

**`\uses` skeleton**:
- `lem:hilbert_polynomial_stratification` uses `thm:euler_characteristic_locally_constant`, `def:euler_characteristic_family`, `def:hilbert_polynomial`
- `thm:upper_semicontinuity_cohomology` uses `def:euler_characteristic_family`
- `thm:euler_characteristic_locally_constant` uses `def:euler_characteristic_family`

**Main theorem proof strategy**: Use the fact that `R^i f_*\mathcal{F}` commutes with flat base change (from `Cohomology_HigherDirectImage`) together with the base-change theorem for proper flat families to reduce local constancy of χ to the fiber-by-fiber vanishing argument; for upper semicontinuity use the Nakayama-type criterion for `R^i f_*\mathcal{F}` being locally free, which holds when `H^i` is locally constant.

**References for writer**:
- `references/stacks-coherent.tex` §Cohomology and base change, Tags 0BDI, 02KH — semicontinuity and Euler char
- `references/kleiman-picard-src/kleiman-picard.tex` §4, Step 1 proof — Hilbert polynomial stratification
- `references/hartshorne-algebraic-geometry.md` III §12 — semicontinuity theorem

**Subphase choices exposed**:
- `thm:upper_semicontinuity_cohomology` requires `R^i f_*` for i≥1 from `Cohomology_HigherDirectImage`; if that chapter is not yet formalized, sorry-axiomatize. Recommendation: write this chapter in parallel with `Cohomology_HigherDirectImage`, sorry-axiomatizing mutual dependencies under option (c).

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - MISSING BLOCK — `lem:dual_unit_iso`: the third step of the `lem:dual_isLocallyTrivial` proof (L3053–3057) uses `\mathtt{dual\_unit\_iso} : \mathtt{dual}\,\mathcal{O}_U \cong \mathcal{O}_U` by name but there is NO `\label{lem:dual_unit_iso}`, NO `\lean{}` pin, and NO dedicated declaration block anywhere in the chapter. The prover needs this as an explicit named Lean target (small build: `End_{slice}(𝟙_) ≅ R(W)` identification).
  - MISSING BLOCK — per-`V` slice equivalence `Over_Y V ≌ Over_X (f.opensFunctor V)`: mentioned in step (a) of the `lem:dual_restrict_iso` proof (L2959–2972) as the first incremental sub-build, but has no `\label{}`, no `\lean{}` pin, and no named block. The STRATEGY and directive designate this as the "first standalone deliverable" for iter-232. Must be added as a named declaration before the prover can be directed to it.
  - STALE RATIONALE — `lem:sheafofmodules_hom_of_local_compat` proof at L3173–3176 claims `lem:dual_isLocallyTrivial` (the C-bridge) and the A-engine share `lem:open_immersion_slice_sheaf_equiv` as a common root. This is FALSE per iter-230 binding probe: the C-bridge residual lives at the presheaf-of-modules level over the **varying ring `𝒪(V)``, not in the fixed-value-cat sheaf category that `overSliceSheafEquiv` operates on. The C-bridge uses the per-open `Over_Y V ≌ Over_X (...)` comparison, NOT the sheaf-level `overSliceSheafEquiv`. The rationale needs correcting to prevent misleading a prover working on the A-engine.
  - `lem:dual_restrict_iso` (L2907–3003): correctly named, has `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}`, correct objectwise recipe (steps (a)+(b)+(c): per-V slice reindexing, codomain agreement, `restrictScalarsRingIsoDualEquiv` ring-iso transport). Does NOT route through `overSliceSheafEquiv`. No `\leanok` (correct — not yet formalized). `\uses{lem:internal_hom_isSheaf, lem:restrictscalars_ringiso_dualequiv}` — correct.
  - `lem:dual_isLocallyTrivial` (L3005–3061): correctly named, has `\lean{...}`, correct 3-step proof (`dual_restrict_iso` → `dualIsoOfIso` → `dual_unit_iso`). No `\leanok` (correct). `\uses` chain is correct except `lem:dual_unit_iso` is not a real label — it's only a Lean name referenced in prose.
  - All other infrastructure blocks (`lem:restrictscalars_ringiso_dualequiv`, `lem:open_immersion_slice_sheaf_equiv`, `def:presheaf_internal_hom`, `lem:internal_hom_isSheaf`, `def:presheaf_dual`, etc.) are present, well-specified, and have correct `\leanok` or no-`\leanok` status consistent with the current Lean state.
  - `rem:dual_discharges_inverse` (L3213–3244): correctly describes the descent-route assembly of `exists_tensorObj_inverse` via A-bridge + B-connector; does NOT route through the sheafify-the-eval shortcut. This remark is complete and correct.
  - `lem:tensorobj_unit_iso` (L1505–1532): statement present with `\lean{}` pin, but no `\leanok` on the STATEMENT (only `\leanok` on the proof block appears missing — the statement block itself is un-marked). Minor but worth noting: prover needs the statement `\leanok` to confirm it's formalized.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Newly wired into `content.tex` (line 13). Three declaration blocks: `def:pushforward_base_change_map`, `lem:affine_base_change_pushforward`, `thm:flat_base_change_pushforward`.
  - All three have well-formed statements, correct `\lean{}` pins (`AlgebraicGeometry.pushforwardBaseChangeMap`, `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`), complete proof sketches (affine case: tensor associativity; separated case: Čech + flatness; quasi-separated: noted as avoidable via Mayer–Vietoris for i=0).
  - No `\leanok` (correct — new chapter, not yet formalized).
  - Citation discipline: `% SOURCE:` with `(read from references/stacks-coherent.tex, L877–904)` etc. on all blocks; `% SOURCE QUOTE:` and `% SOURCE QUOTE PROOF:` verbatim from the Stacks source; both reference files (`stacks-coherent.tex`, `stacks-coherent.md`) exist on disk ✓. Visible `\textit{Source:}` lines present ✓.
  - `\uses{}` chains: correct and minimal. HARD GATE: adequate to back a parallel engine prover lane for the i=0 flat base change sub-lane.

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Several iter-162 `% NOTE:` annotations in proof blocks reference "STALE as of iter-162 — Step 1 is now PROVEN" (e.g., in `lem:rigidity_eqOn_saturated_open_to_affine`). These stale-prose notes describe a closed sorry as still open. They are documentation artifacts that don't affect blueprint correctness but should be cleaned by the next writer pass. Not must-fix (the `\leanok` markers are managed by `sync_leanok`).

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `def:symmetric_power_curve` is explicitly marked `\notready` — the scheme-theoretic symmetric power `Sym^g(C)` has no construction. This is a documented gap; the chapter is gated A.2.c with no active prover. Deferral rationale: "gated A.2.c; no dispatch before A.2.c."

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - The chapter is very long (~601 lines). The portion read (lines 1–347) shows all top-level declarations (`def:IsAlbanese`, `def:Jacobian`, `thm:nonempty_jacobianWitness` etc.) are present with `\leanok`. The existence theorem `thm:nonempty_jacobianWitness` has a massive documented decomposition covering Routes A/B/C with sorry-axiomatized sub-steps. The chapter is architecturally sound but Route A sub-steps (A.2 representability, A.3 identity component, A.4 Albanese) are explicitly marked as having bodies in sorry.
  - No must-fix findings specific to this chapter; the documented sorry chain is intentional under option-(c) posture.
  - Marked partial only because the chapter prose for sub-steps A.2/A.3/A.4 explicitly says "each sub-step is missing" — this is accurate and intentional, not a blueprint failure.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - ts229 deferred finding: missing `\lean{}` pin (exact declaration unclear without re-read). Main theorems confirmed present by agent read. HELD engine chapter; deferral rationale: "HELD behind A.1.c.SubT → A.1.c → A.2.c chain."

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Main theorems (`def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable`, `thm:quot_representable`) are complete with 4-step proof sketches. A sub-lemmas section starts with `lem:quot_reduction_to_pi_star_W` and siblings but is incomplete. HELD engine chapter; deferral rationale: "HELD behind A.1.c.SubT → A.1.c → A.2.c chain."

### blueprint/src/chapters/Picard_RelPicFunctor.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:rigidity_over_kbar` has `\leanok` but sorry body. Pieces (i)–(iv) are documented named gaps; piece (iv) Serre duality is ON critical path (iter-155 correction). Route C PAUSED; deferral with USER-PAUSE rationale acceptable.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:isFlasque_injective` proof deferred (~100–150 LOC). Route C PAUSED; deferral acceptable.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:degree_via_pole_divisor`: `poleDivisor` typed sorry, pending iter-183+ affine-chart construction. Route C PAUSED; deferral acceptable.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

---

## Cross-chapter notes

- `Picard_TensorObjSubstrate.tex` (`lem:sheafofmodules_hom_of_local_compat` proof, L3173–3176) claims `lem:dual_isLocallyTrivial` uses `lem:open_immersion_slice_sheaf_equiv` as a root. But `lem:dual_isLocallyTrivial` uses `lem:dual_restrict_iso`, whose proof builds at the presheaf-of-modules level via a per-V slice reindexing — NOT through the sheaf-level `overSliceSheafEquiv` that `homOfLocalCompat` uses. The A-engine may validly use `overSliceSheafEquiv`; the C-bridge does not and cannot (iter-230 binding probe). The A-engine's claim of a shared root for both bridges is incorrect and must be removed.

---

## Severity summary

**Must-fix-this-iter:**

1. `Picard_TensorObjSubstrate.tex` / missing `\label{lem:dual_unit_iso}` + `\lean{}` pin: add a named declaration block for `dual_unit_iso : dual 𝒪 ≅ 𝒪` (prover needs it as the third step of `lem:dual_isLocallyTrivial`). Dispatch blueprint-writer for this chapter or take the same-iter fast-path after write + re-review.

2. `Picard_TensorObjSubstrate.tex` / missing per-`V` slice equivalence block: add `\label{lem:per_open_slice_equiv}` (or similar) with `\lean{...}` pin for `Over_Y V ≌ Over_X (f.opensFunctor V)` — the first standalone incremental deliverable designated by STRATEGY. HARD GATE: without this named block the prover cannot be directed to the first incremental sub-build.

3. `Picard_TensorObjSubstrate.tex` / stale C-bridge rationale in `lem:sheafofmodules_hom_of_local_compat` proof (L3173–3176): remove/correct the claim that the C-bridge shares `overSliceSheafEquiv` as a root. `correct: partial` on active prover chapter.

4. Unstarted-phase proposal — `Cohomology_HigherDirectImage.tex`: dispatch blueprint-writer for `R^i f_*` (i≥1) chapter, or record explicit deferral in plan.md.

5. Unstarted-phase proposal — `Picard_CMRegularity.tex`: dispatch blueprint-writer for Castelnuovo–Mumford regularity chapter, or record explicit deferral in plan.md.

6. Unstarted-phase proposal — `Picard_SemiContinuity.tex`: dispatch blueprint-writer for semicontinuity chapter, or record explicit deferral in plan.md.

7. `Picard_QuotScheme.tex` / `complete: partial` (sub-lemmas incomplete): dispatch blueprint-writer, OR record deferral rationale "HELD engine chapter — no prover dispatch pending A.1.c.SubT." in plan.md.

8. `Picard_FlatteningStratification.tex` / `complete: partial` (ts229 deferred missing `\lean{}` pin): dispatch blueprint-writer, OR record deferral rationale "HELD engine chapter" in plan.md.

9. `Albanese_AlbaneseUP.tex` / `complete: partial` (`def:symmetric_power_curve` is `\notready`): dispatch blueprint-writer, OR record deferral "gated A.2.c; no dispatch before A.2.c" in plan.md.

10. `RigidityKbar.tex` / `complete: partial`: dispatch blueprint-writer, OR record deferral "Route C PAUSED by USER standing directive" in plan.md.

11. `RiemannRoch_H1Vanishing.tex` / `complete: partial`: dispatch blueprint-writer, OR record deferral "Route C PAUSED" in plan.md.

12. `RiemannRoch_RationalCurveIso.tex` / `complete: partial`: dispatch blueprint-writer, OR record deferral "Route C PAUSED" in plan.md.

Overall verdict: `Picard_TensorObjSubstrate.tex` has `complete: partial` + `correct: partial` on 3 findings (missing `lem:dual_unit_iso` block, missing per-V slice equivalence block, stale A-engine rationale) — **HARD GATE FAILS for the active prover lane**; blueprint-writer must be dispatched before prover re-engages. 3 unstarted A.2.c-engine phases have no blueprint coverage; proposals provided for immediate writer dispatch. 8 additional must-fix items are on held/paused chapters and admit plan.md deferral rationales.
