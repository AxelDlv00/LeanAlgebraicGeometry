# Blueprint Review Report

## Slug
ts233

## Iteration
233

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex`: consumer `thm:rel_pic_addcommgroup_via_tensorobj` still `\uses` the old group-law lemma `lem:tensorobj_isoclass_commgroup` + sorry-transitive `lem:tensorobj_assoc_iso`; repoint to `thm:pic_commgroup` is deferred per PROGRESS.md but not annotated in the blueprint prose itself.
- `Picard_TensorObjSubstrate.tex`: internal-consistency section (§ sec:tensorobj_consistency_check) characterises `lem:flat_whisker_localizer` as "superseded on the critical path" — stale since the new `lem:tensorobj_assoc_iso_invertible` explicitly uses it.
- `Albanese_AlbaneseUP.tex`: `def:symmetric_power_curve` body carries a `\notready` placeholder (Sym^g gluing, ts232 standing deferral).
- `Picard_QuotScheme.tex`: several lemmas past `lem:quot_valuative_criterion` lack proof sketches (ts232 standing).
- `Picard_FlatteningStratification.tex`: `\lean{}` pins absent on `lem:flat_locus_open`, `lem:nonflat_locus_proper`, `lem:noetherian_induction_strata` (ts232 standing).
- Route-C chapters (`RiemannRoch_*`, parts of `Rigidity.tex`): declarations present but proofs sparse; Route C PAUSED (standing deferral).

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_assoc_iso_invertible`: proof refers to "restricting the construction of `lem:tensorobj_assoc_iso`" without spelling out the gluing-uniqueness step on double overlaps — acceptable for a blueprint sketch but a prover should note this gap explicitly.
- `Cohomology_HigherDirectImage.tex` / `thm:flat_base_change_higher` (quasi-separated case): proof says "by the separated case" for intersections and "spectral sequences" argument; the step "flatness propagates through spectral sequences to the abutment" is not detailed. Adequate for a scaffolding lane; the deep Čech-to-cohomology spectral sequence comparison should be left as a `sorry` initially.

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_assoc_iso_invertible` (`\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso_invertible}`): the blueprint proof says "restricting the construction of `lem:tensorobj_assoc_iso` to invertible arguments". The prover must be aware that `lem:flat_whisker_localizer` IS already formalized (it has `\leanok` even though the preceding text says "must not be formalized"); a careful reading of the proof sketch and the `\uses` block makes this clear, but the inconsistency could cause wasted time.

### Citation discipline

All `% SOURCE:` lines in `Picard_TensorObjSubstrate.tex` (new carrier section) and `Cohomology_HigherDirectImage.tex` carry correct `(read from references/...)` parentheticals, and the named files (`references/stacks-modules.tex`, `references/stacks-coherent.tex`, `references/stacks-coherent.md`, `references/kleiman-picard-src/kleiman-picard.tex`) all exist on disk. `% SOURCE QUOTE:` verbatim text is in the source's original language (English for Stacks, English for Kleiman/FGA Explained). No citation-discipline failures found in the two priority chapters.

---

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Picard_CMRegularity.tex`

**Covers**: `AlgebraicJacobian/Picard/CMRegularity.lean`
**Strategy phase**: A.2.c-engine — Quot/Cartier (RR-free)
**Why now**: `Cohomology_HigherDirectImage.tex` is now blueprinted; CM-regularity (Castelnuovo–Mumford regularity bounds) is the next engine gate after higher direct images — no prover can start this sub-lane without a blueprint chapter.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:cm_regularity}` — Castelnuovo–Mumford m-regularity of a coherent sheaf: `\mathcal{F}` is m-regular if `R^i f_* \mathcal{F}(m-i) = 0` for all `i ≥ 1`. `\lean{AlgebraicGeometry.isCMRegular}` [expected]. Source: `references/kleiman-picard-src/kleiman-picard.tex` §4 / Nitsure §5.
2. `\lemma` `\label{lem:cm_regularity_twist}` — if `\mathcal{F}` is m-regular then it is (m+1)-regular (regularity passes to twists). `\lean{AlgebraicGeometry.isCMRegular_twist}` [expected]. Source: Kleiman §4, Mumford.
3. `\lemma` `\label{lem:cm_regularity_global_generation}` — m-regular implies globally generated after twisting by `\mathcal{O}(m)`. `\lean{AlgebraicGeometry.isCMRegular_globalGeneration}` [expected]. Source: Kleiman §4.
4. `\theorem` `\label{thm:cm_regularity_bound}` — existence of a uniform regularity bound for a flat family of coherent sheaves on projective space. `\lean{AlgebraicGeometry.cmRegularityBound}` [expected]. Source: Kleiman §4, Stacks tag 08A4.

**`\uses` skeleton**:
- `lem:cm_regularity_twist` uses `def:cm_regularity`, `def:higher_direct_image`
- `lem:cm_regularity_global_generation` uses `lem:cm_regularity_twist`
- `thm:cm_regularity_bound` uses `lem:higher_direct_image_quasi_coherent`, `lem:cm_regularity_global_generation`, `thm:flat_base_change_higher`

**Main theorem proof strategy**: The bound follows from Kleiman's method of reducing to the affine case via `R^i f_*` vanishing for large twists, then using the flatness hypothesis to conclude the bound is uniform. Key Mathlib needs: projective space `\mathbb{P}^n_S`, twisting, coherent sheaves on projective space, `R^i f_*` for projective morphisms.

**References for writer**:
- `references/kleiman-picard-src/kleiman-picard.tex` §4 — CM-regularity in the representability argument
- `references/stacks-coherent.tex` §"Boundedness of Hilbert polynomials" — Stacks treatment
- retrieval needed: Nitsure FGA Explained §5 — no local file; plan agent should retrieve

**Subphase choices exposed**:
- Implement via `R^i f_*` and Serre duality (classical, needs some extra machinery) vs via Čech complex bounds (more elementary, consistent with the project's existing Čech approach in `Cohomology_FlatBaseChange.tex`). Recommendation: Čech approach to stay consistent with the engine's existing infrastructure.

---

### Proposed chapter: `blueprint/src/chapters/Picard_SemiContinuity.tex`

**Covers**: `AlgebraicJacobian/Picard/SemiContinuity.lean`
**Strategy phase**: A.2.c-engine — Quot/Cartier (RR-free)
**Why now**: Higher direct images are now blueprinted; semicontinuity of fibre cohomology dimensions depends on `R^i f_*` quasi-coherence and flat base change — both now blueprinted — and is the gate before the Quot representability argument.

**Key declarations** (in dependency order):
1. `\definition` `\label{def:cohomology_base_change_map}` — the base-change map `g^*(R^i f_* \mathcal{F}) → R^i f'_* ((g')^* \mathcal{F})` for arbitrary `g` (generalising `def:pushforward_base_change_map` to higher degree). `\lean{AlgebraicGeometry.cohomologyBaseChangeMap}` [expected]. Source: Stacks Tag 02KH (already sourced in `Cohomology_HigherDirectImage.tex`).
2. `\lemma` `\label{lem:semicontinuity_lower}` — lower semicontinuity of `h^i(\mathcal{F}_t)` in the fibre direction for a flat family. `\lean{AlgebraicGeometry.lowerSemiContinuous_cohomologyDim}` [expected]. Source: Hartshorne III.12 / EGA.
3. `\theorem` `\label{thm:cohomology_constancy_criterion}` — `h^i(\mathcal{F}_t)` is locally constant on the base iff the base-change map is an isomorphism for all base changes. `\lean{AlgebraicGeometry.cohomologyConstancyCriterion}` [expected]. Source: Hartshorne III.12.9, Kleiman §4.

**`\uses` skeleton**:
- `def:cohomology_base_change_map` uses `def:higher_direct_image`, `def:pushforward_base_change_map`
- `lem:semicontinuity_lower` uses `def:cohomology_base_change_map`, `thm:flat_base_change_higher`, `lem:higher_direct_image_quasi_coherent`
- `thm:cohomology_constancy_criterion` uses `lem:semicontinuity_lower`, `def:cohomology_base_change_map`

**Main theorem proof strategy**: Reduce to the affine case via quasi-coherence of `R^i f_*`; in the affine case the statement becomes a statement about flatness of modules of cohomology, proved via the base-change isomorphism and Nakayama. The constancy criterion follows from the lower semicontinuity bound and an upper semicontinuity argument via Euler characteristics.

**References for writer**:
- `references/stacks-coherent.tex` §"Cohomology and base change" (Tags 02KH and surrounding) — base-change maps
- retrieval needed: Hartshorne Chapter III §12 — semicontinuity theorem; no local file
- retrieval needed: Kleiman §4 §"Representability" — how semicontinuity feeds into the Quot argument

**Subphase choices exposed**:
- Prove semicontinuity via the full machinery (Tor groups, perfect complexes) vs the elementary Čech-complex route consistent with the project. Recommendation: Čech approach; matches the project's existing cohomology infrastructure and avoids importing derived-category machinery.

---

## Per-chapter

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- **complete**: partial
- **correct**: partial
- **notes**:
  - HARD GATE FAIL (new this iter): The "Superseded route --- off path, not to be formalized" paragraph preceding `lem:flat_whisker_localizer` says "This block is retained for the historical record only and must **not** be formalized." This is STALE — `lem:flat_whisker_localizer` is already formalized (closed in TensorObjSubstrate.lean, 0 sorries in that block) and is explicitly \uses'd by `lem:tensorobj_assoc_iso_invertible`'s proof sketch. A prover reading the "must not be formalized" instruction would be confused about whether to reference it.
  - HARD GATE FAIL (new this iter): Internal-consistency section (§ sec:tensorobj_consistency_check, lines ~2694–2695) states `lem:flat_whisker_localizer` "is superseded on the critical path by the flatness-free `_of_W` variants." This is now incorrect: `lem:flat_whisker_localizer` IS on the critical path for `lem:tensorobj_assoc_iso_invertible`.
  - The same stale "Superseded route" paragraph also appears before `lem:whisker_of_W` — that one is correctly labelled (only the flat_whisker entry needs updating).
  - Informational: `lem:tensorobj_restrict_iso` and `lem:presheaf_pushforward_adj_substrate` lack `\leanok` markers in the blueprint. Lean file evidence confirms `tensorObj_restrict_iso` is proved (uses `PresheafOfModules.pushforwardPushforwardAdj` from `PresheafInternalHom.lean` which has 0 sorries). Marker sync issue; `sync_leanok` will resolve.
  - Informational: Consumer `thm:rel_pic_addcommgroup_via_tensorobj` still `\uses` `lem:tensorobj_isoclass_commgroup` (old locally-trivial carrier) and `lem:tensorobj_assoc_iso` (sorry-transitive general associator). Repoint to `thm:pic_commgroup` is noted as deferred in PROGRESS.md but carries no deferral annotation in the blueprint.
  - The new `sec:tensorobj_pic_carrier` section (def:scheme_modules_isinvertible, def:pic_carrier, lem:isinvertible_tensor, lem:isinvertible_unit, lem:isinvertible_inverse_welldef, lem:tensorobj_assoc_iso_invertible, thm:pic_commgroup) is mathematically complete and correct. Each block has adequate proof sketches, correct sources, and internally consistent `\uses`.
  - Proof soundness of the associator bypass: `lem:tensorobj_assoc_iso_invertible` routes through `lem:flat_whisker_localizer` (closed) + `lem:tensorobj_restrict_iso` (closed per Lean file) and does NOT use `lem:islocallyinjective_whisker_of_W` (the open sorry). The bypass is SOUND; the sorry-transitivity is genuinely eliminated for invertible modules.

### `blueprint/src/chapters/Cohomology_HigherDirectImage.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - HARD GATE CLEARS for scaffold+prove lane. All 4 declarations (def:higher_direct_image, lem:higher_direct_image_quasi_coherent, lem:higher_direct_image_affine_vanishing, thm:flat_base_change_higher) are present with adequate proof sketches.
  - Source quotes verified: `% SOURCE:` lines cite `references/stacks-coherent.tex` and `references/stacks-coherent.md`, both of which exist on disk. Verbatim quotes match Stacks Tags 02KE/02KG/02KH.
  - `def:pushforward_base_change_map` cross-reference in `\uses` resolves to `Cohomology_FlatBaseChange.tex` which has that label with `\leanok`.
  - The quasi-separated case proof (Čech-to-cohomology spectral sequences) is correctly at sketch level; the prover should leave `thm:flat_base_change_higher` as a deep `sorry` if the spectral-sequence argument is not fully available in Mathlib. Adequate for a scaffolding lane.
  - `AlgebraicJacobian/Cohomology/HigherDirectImage.lean` does not yet exist; the blueprint-doctor flags the chapter as covering a non-existent file, which is expected for a scaffold target.

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelJacobi.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` — complete + correct, no notes.
*(Pointer chapter with no declaration blocks; all Lean declarations in the covered file are listed correctly; no blueprint obligation beyond the pointer.)*

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex`
- **complete**: partial
- **correct**: partial
- **notes**:
  - `def:symmetric_power_curve` (Sym^g): still carries a `\notready` placeholder body with a note that the full construction awaits affine-and-glue descent. This was a ts232 must-fix; standing deferral per PROGRESS.md ("Albanese_AlbaneseUP (`\notready` Sym^g)").
  - The non-placeholder declarations (thm:albanese_universal_property, lem:abel_jacobi_morphism, lem:symmetric_product_av_map, lem:symmetric_product_to_jacobian, lem:descent_through_birational_sigma) are present and correctly sourced.
  - Standing deferral from ts232; no change this iter.

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Route-1 Albanese cone; excised/held per PROGRESS.md. Content is present but Route 1 is retained reversibly behind the closed deletion gate.
  - No active prover lane; no must-fix action required beyond the standing hold.

### `blueprint/src/chapters/Albanese_CoheightBridge.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelianVarietyRigidity.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 41 `\leanok` out of 58 labels; many declarations in the Genus0BaseObjects sub-section are unproved. No active prover lane for the outstanding declarations (gated Route-A below the substrate). Not a this-iter blocker.

### `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_SheafCompose.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Differentials.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 9 `\leanok` out of 14 labels; declarations below `thm:smooth_locally_free_omega` lack `\leanok`. No active lane; no this-iter action.

### `blueprint/src/chapters/Genus.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 2 `\leanok` out of 4 labels. `def:genus` exists; some downstream results pending. No active lane.

### `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Jacobian.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 14 `\leanok` out of 24 labels. Scaffold declarations with `\leanok` (typed sorries). No active lane this iter.

### `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 6 `\leanok` out of 32 labels. Held (gated behind A.1.c.SubT → A.1.c → A.2.c). No this-iter action.

### `blueprint/src/chapters/Picard_FlatteningStratification.tex`
- **complete**: partial
- **correct**: partial
- **notes**:
  - `\lean{}` pins absent on `lem:flat_locus_open`, `lem:nonflat_locus_proper`, `lem:noetherian_induction_strata` (ts232 standing must-fix; standing deferral per PROGRESS.md).
  - `thm:generic_flatness`, `thm:flattening_stratification_exists`, `thm:flattening_stratification_universal`, `def:coherent_sheaf_flat` have `\leanok` and correct `\lean{}` hints.
  - No change this iter; standing deferral applies.

### `blueprint/src/chapters/Picard_IdentityComponent.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 10 `\leanok` out of 26 labels. Gated A.3; no this-iter action.

### `blueprint/src/chapters/Picard_LineBundlePullback.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 11 `\leanok` out of 20 labels. Held pending carrier re-base. No this-iter action.

### `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 5 `\leanok` out of 20 labels. Gated A.3; no this-iter action.

### `blueprint/src/chapters/Picard_QuotScheme.tex`
- **complete**: partial
- **correct**: partial
- **notes**:
  - ts232 standing must-fix: lemmas after `lem:quot_valuative_criterion` lack proof sketches; `\lean{}` hints on sub-lemmas past the Grassmannian block are thin.
  - 15 `\leanok` (Hilbert polynomial, Quot functor, Grassmannian, Quot representable, flat base change cohomology, canonical base-change declarations) are correct.
  - Standing deferral applies; engine chapter, no active prover lane this iter.

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 11 `\leanok` out of 21 labels. Held pending carrier pivot. No this-iter action.

### `blueprint/src/chapters/Picard_RelativeSpec.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 19 `\leanok` out of 17 labels (labels slightly undercount). Route C PAUSED (standing deferral).

### `blueprint/src/chapters/RiemannRoch_OCofP.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 0 `\leanok`; Route C PAUSED. Standing deferral.

### `blueprint/src/chapters/RiemannRoch_OcOfD.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 4 `\leanok` out of 15 labels; Route C PAUSED. Standing deferral.

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 13 `\leanok` out of 6 labels. Route C PAUSED. Standing deferral.

### `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 1 `\leanok` out of 10 labels; Route C PAUSED; ts232 standing deferral.

### `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 24 `\leanok` out of 26 labels. Route C PAUSED. Standing deferral.

### `blueprint/src/chapters/Rigidity.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 2 `\leanok` out of 33 labels; much content present but unproved. No active prover lane; gated by the Route-A spine.

### `blueprint/src/chapters/RigidityKbar.tex`
- **complete**: partial
- **correct**: partial
- **notes**:
  - ts232 standing must-fix; 30 `\leanok` out of 33 labels. Standing deferral per PROGRESS.md.

---

## Cross-chapter notes

- `Picard_TensorObjSubstrate.tex` / `thm:rel_pic_addcommgroup_via_tensorobj` \uses `lem:tensorobj_isoclass_commgroup` (old locally-trivial group law) and `lem:tensorobj_assoc_iso` (sorry-transitive via flatness-free whiskering). The new carrier group `thm:pic_commgroup` supersedes the old one. PROGRESS.md notes the repoint as "consumer `\uses` repoint — deferred." The blueprint does not carry a deferral annotation on this block, so future readers may be confused about which group law is authoritative. Should be annotated or repointed when the carrier group lands.

---

## Severity summary

### must-fix-this-iter

1. **`Picard_TensorObjSubstrate.tex` — correct: partial (NEW).** The "Superseded route — off path, not to be formalized" paragraph before `lem:flat_whisker_localizer` and the internal-consistency characterisation "superseded on the critical path" directly contradict the new `lem:tensorobj_assoc_iso_invertible` proof sketch which `\uses lem:flat_whisker_localizer`. The "must NOT be formalized" instruction is factually wrong (the lemma IS formalized) and could mislead a prover into not using it. **Action**: dispatch a blueprint-writer to update these two stale passages; then re-dispatch me (same-iter fast path) scoped to `Picard_TensorObjSubstrate.tex` to re-clear the HARD GATE for `thm:pic_commgroup` / `lem:tensorobj_assoc_iso_invertible`.

2. **`Picard_TensorObjSubstrate.tex` — complete: partial.** Consumer `thm:rel_pic_addcommgroup_via_tensorobj` uses old group law without deferral annotation. (Lower urgency — the prover lane does not touch this block — but the chapter is partial until the repoint lands or the block is annotated as deferred.)

3. **Unstarted-phase proposal: A.2.c-engine / `Picard_CMRegularity.tex`.** No blueprint chapter exists for CM-regularity. Was deferred in ts232 pending HigherDirectImage; HigherDirectImage is now blueprinted. **Action**: dispatch blueprint-writer for `Picard_CMRegularity.tex` or record explicit deferral.

4. **Unstarted-phase proposal: A.2.c-engine / `Picard_SemiContinuity.tex`.** No blueprint chapter exists for semicontinuity. Same history as CM-regularity. **Action**: dispatch blueprint-writer for `Picard_SemiContinuity.tex` or record explicit deferral.

5. **Standing (ts232, all with explicit deferral rationale in PROGRESS.md):**
   - `Albanese_AlbaneseUP.tex` — `\notready` Sym^g
   - `Picard_QuotScheme.tex` — partial proof sketches
   - `Picard_FlatteningStratification.tex` — missing `\lean{}` pins
   - `RigidityKbar.tex` — partial
   - `Albanese_CodimOneExtension.tex` — Route-1 held
   - Route-C chapters (`RiemannRoch_*`, `Rigidity.tex`) — PAUSED
   - Various partial chapters (Differentials, Genus, Jacobian, Picard_FGAPicRepresentability, Picard_IdentityComponent, Picard_LineBundlePullback, Picard_Pic0AbelianVariety, Picard_RelPicFunctor, AbelianVarietyRigidity) — gated by Route-A spine; standing deferrals apply.

### soon

- Add a "deferred — repoint to `thm:pic_commgroup` when carrier group lands" annotation to `thm:rel_pic_addcommgroup_via_tensorobj` in `Picard_TensorObjSubstrate.tex` so future readers understand its status.
- `\leanok` sync: once `sync_leanok` runs, `lem:tensorobj_restrict_iso` and `lem:presheaf_pushforward_adj_substrate` will gain their markers. No manual action needed.

**Overall verdict**: `Cohomology_HigherDirectImage.tex` is complete + correct — hard gate CLEARS for the scaffold lane. `Picard_TensorObjSubstrate.tex` is correct: partial due to stale "must not be formalized" + "superseded on critical path" labels for `lem:flat_whisker_localizer` — hard gate FAILS; a targeted writer fix + same-iter re-review can clear it this iter. 2 unstarted A.2.c-engine sub-lanes (CMRegularity, SemiContinuity) remain without blueprint coverage; proposals provided for immediate writer dispatch.
