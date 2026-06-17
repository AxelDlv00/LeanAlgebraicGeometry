# Blueprint Review Report

## Slug
iter164

## Iteration
164

## Top-level summaries

### Incomplete parts
- `AbelianVarietyRigidity.tex` / `lem:rational_map_to_av_extends` (Milne Thm 3.2, `\lean{rationalMap_to_av_extends}`): **NOT prover-ready — it is still an open research question, not an under-specified proof.** The stated proof = "Theorem 3.1 + Lemma 3.3". Lemma 3.3 (codim-1 indeterminacy of a rational map into a group variety) is proved in Milne via Weil-divisor theory (`div(f)₀ − div(f)₁`, prime divisors, tangent cones), for which `rmk:thm32_codim1_mathlib_gap` itself states Mathlib has **no usable API**. The remark's "pointwise valuative side-step" is explicitly posed as *"An open question for the prover"* — i.e. there is no decided formalisation path. No Lean decl exists. This block must **not** enter prover objectives until the pointwise-valuative approach is fleshed into a concrete sub-lemma stack (or the divisor gap is otherwise resolved).
- `AbelianVarietyRigidity.tex` / `lem:hom_from_Ga_trivial` (Milne Prop 3.9 core, `\lean{morphism_Ga_to_av_const}`): proof is **not detailed enough to formalise** (see "Proofs lacking detail"). No Lean decl exists.
- `AbelianVarietyRigidity.tex` / `prop:genusZero_curve_iso_P1`: genus-0 ⟹ ℙ¹ is a genuine Riemann–Roch sub-build with no Mathlib RR (the chapter's own `rmk:genusZero_iso_subbuild` says so). Body is `sorry`; not prover-ready as a short step.
- `Jacobian.tex` Route A (FGA engine, §"Route A" A.1–A.4 + `def:positiveGenusWitness`): the FGA representability engine (RelativeSpec / Quot / Hilbert / `Pic` representability / identity component `Pic⁰` / degree map / Albanese UP) exists only as **prose itemize sketches**, with zero prover-ready declaration blocks. Strategy labels this "blueprint sketch-level" and schedules expansion *after* the genus-0 stack; flagged here so the planner expands it before any positive-genus FGA prover lane (see Unstarted-phase proposal). Not blocking this iter.

### Proofs lacking detail
- `AbelianVarietyRigidity.tex` / `lem:hom_from_Ga_trivial` (proof, chapter lines ~858–886): the closing **𝔾_a/𝔾_m incompatibility ⟹ f constant** step is a single-sentence parenthetical ("an additive-group homomorphism … that is simultaneously … a multiplicative-group homomorphism … forces the image to be a single point"). It is NOT decomposed into a formalizable argument. Specifically missing:
  1. No explicit **`Hom(𝔾_a, A) = 0`** sub-lemma (a homomorphism from the additive group to an abelian variety is trivial) — the natural formal target the collision should reduce to.
  2. The 𝔾_m side ("the same additive-defect argument applied to the multiplicative structure gives `f(xy)=f(x)+f(y)+c`") is **asserted, not derived**: it silently needs a *second* application of `lem:rational_map_to_av_extends` (extending the multiplicative-defect map over ℙ¹×ℙ¹), which the prose glosses over.
  3. The **group-scheme infrastructure is assumed without provenance**: a concrete ℙ¹, 𝔾_a and 𝔾_m as group objects, the open immersions 𝔾_a ↪ ℙ¹ and 𝔾_m ↪ ℙ¹, and where the additive/multiplicative laws come from in Lean. The chapter gives no `\lean{...}` hint, no definition block, and no `% SOURCE` for any of these. STRATEGY records "the additive-group structure on 𝔸¹ and the triviality lemma are to build" — i.e. it is to-build infra with no blueprint coverage.
  A blueprint-writer must break this into sub-lemmas: (a) `Hom(𝔾_a, A) = 0`; (b) the 𝔾_a/𝔾_m group-object defs + open immersions into ℙ¹ (with `\lean` hints / sources or an explicit "Archon-original infra" tag); (c) the multiplicative-defect extension as its own step; (d) the concrete collision arithmetic that yields constancy.
- `AbelianVarietyRigidity.tex` / `lem:rational_map_to_av_extends` (proof): see Incomplete parts — the proof names the right ingredients but the load-bearing Lemma 3.3 step has no executable Mathlib path; this is research-level, not merely "vague".

### Multi-route coverage
- Route C (genus-0 rigidity via Milne §I.3): **PARTIAL** — covered in `AbelianVarietyRigidity.tex`; the foundation (Rigidity Lemma chain, Cor 1.5, Cor 1.2) is landed axiom-clean, but the two remaining frontier blocks (`lem:rational_map_to_av_extends`, `lem:hom_from_Ga_trivial`) plus the RR bridge `prop:genusZero_curve_iso_P1` are not prover-ready.
- Route A (positive-genus object, Picard via FGA): **PARTIAL** — sketched in `Jacobian.tex` (A.1–A.4) + `def:positiveGenusWitness` scaffold, but no prover-ready declaration blocks for the FGA engine. Strategy-sanctioned deferral until genus-0 closes.
- Fallback (a) differential/`df=0`/Serre-duality route: covered in `RigidityKbar.tex` (off-path artifact, intentionally not pursued).

## Unstarted-phase blueprint proposals

### Proposed chapter: `blueprint/src/chapters/Pic_RelativeSpec.tex` (entry chapter of the Route A engine)

**Covers**: `AlgebraicJacobian/Pic/RelativeSpec.lean` (expected new file; entry point of the FGA engine — exact path TBD by planner)
**Strategy phase**: Route A — Picard/Quot/Hilbert FGA engine (positive-genus OBJECT)
**Why now**: Strategy explicitly schedules Route A expansion *after* the genus-0 stack closes, and the genus-0 frontier is itself currently blocked (this iter's two frontier blocks are not prover-ready). So **the planner may legitimately defer this proposal** with the one-line rationale "Route A expansion deferred per STRATEGY.md §M3 until genus-0 stack closes; FGA engine is sketch-level by design and feeds no active prover lane." I surface the seed now so it is ready the moment genus-0 lands; this is the single largest unwritten phase (~5100+ LOC) and writing its entry chapter early is the cheapest action once it becomes active.

**Key declarations** (in dependency order — speculative seed):
1. `\definition` `\label{def:relativeSpec}` — the relative-Spec functor `RelativeSpec : QCoh-Algebra → Sch/S`, A.1 prerequisite (~700–1100 LOC per iter-123 audit). `\lean{AlgebraicGeometry.RelativeSpec}` [expected]. Source: Nitsure, FGA Explained §5 (`references/nitsure-hilbert-quot.md`); Stacks `01LL`/`01LQ`.
2. `\definition` `\label{def:relativePicardFunctor}` — `Pic^♯_{C/k}(T) = Pic(C_T)/π*Pic(T)`. `\lean{AlgebraicGeometry.relativePicardFunctor}` [expected]. Source: Kleiman, FGA Explained Ch.9 §9.2 (`references/kleiman-picard.md`).
3. `\theorem` `\label{thm:pic_representable}` — FGA representability of `Pic_{C/k}` by a `k`-group scheme l.f.t. (A.2). `\lean{AlgebraicGeometry.Pic.representable}` [expected]. Source: Kleiman §9.4 (`references/kleiman-picard.md`, p.262 of FGA-explained).
4. `\definition` `\label{def:pic0}` + `\theorem` `\label{thm:pic0_abelianVariety}` — identity component `Pic⁰`, degree map `Pic → ℤ`, smoothness + properness + dim = g (A.3). `\lean{AlgebraicGeometry.Pic0}` [expected]. Source: Kleiman §9.5 (`references/kleiman-picard.md`); `lem:agps`/`prp:pic0` quotes already in `Jacobian.tex`.
5. `\theorem` `\label{thm:albanese_universal_property}` — the Albanese UP of `Pic⁰` (A.4), Milne Prop 6.1/6.4. `\lean{AlgebraicGeometry.Pic0.isAlbanese}` [expected]. Source: Milne §III.6 (`references/abelian-varieties.md`). **No-regret note:** this UP reuses Route C's `lem:hom_additivity_over_product` (Cor 1.5) + `lem:av_regular_map_is_hom` (Cor 1.2) + `lem:rational_map_to_av_extends` (Thm 3.2) and is cube-free (per `rmk:cube_not_needed`).

**`\uses` skeleton**:
- `thm:pic_representable` uses `def:relativePicardFunctor`, `def:relativeSpec`
- `def:pic0` uses `thm:pic_representable`
- `thm:pic0_abelianVariety` uses `def:pic0`
- `thm:albanese_universal_property` uses `thm:pic0_abelianVariety`, `lem:hom_additivity_over_product`, `lem:av_regular_map_is_hom`, `lem:rational_map_to_av_extends`

**Main theorem proof strategy**: Build the Quot/Hilbert engine (Nitsure §4–5: generic flatness + flattening stratification, then Quot construction), use it to represent `Pic_{C/k}` (Grothendieck FGA-232), extract the identity component `Pic⁰` as the kernel of the locally-constant degree map, prove smoothness via the deformation-theoretic identification of the tangent space at the identity with `H¹(C,O_C)` (already built in the project's cohomology chapters) + homogeneity, then derive the Albanese UP from the proven Rigidity-Lemma chain (shared with Route C). This is the dominant positive-genus cost and the riskiest, least-Mathlib piece (A.2 representability).

**References for writer**:
- `references/nitsure-hilbert-quot.md` → `.pdf`, §4–5 — Quot/Hilbert construction engine.
- `references/kleiman-picard.md` → `.pdf`, §4 (existence) §5 (`Pic⁰`) — FGA `Pic` representability.
- `references/abelian-varieties.md` → `.pdf`, §III.6 (Prop 6.1/6.4) — Albanese UP, cube-free.
- `references/fga-explained.md` — collected-volume cross-reference for all of the above.

**Subphase choices exposed**:
- One mega-chapter vs. split: the FGA engine is large enough that one chapter cannot cover it. Recommend splitting into (i) Quot/Hilbert engine, (ii) `Pic`/`Pic⁰` representability, (iii) Albanese UP — at least three chapters. Recommendation: write the RelativeSpec/Quot entry chapter first (smallest, unblocks the rest); decide the rest once that lands.
- Whether the Albanese-UP chapter should be a sibling of `AbelianVarietyRigidity.tex` (since it shares Cor 1.5 / Cor 1.2 / Thm 3.2) or live in the Route A cluster. Recommendation: keep the shared corollaries in `AbelianVarietyRigidity.tex` and have the Albanese-UP chapter `\uses` them — avoids duplication.

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Landed + sound (complete+correct, axiom-clean per project memory iter-162): `thm:rigidity_lemma`, `lem:rigidity_eqOn_dense_open`, `lem:rigidity_eqOn_saturated_open_to_affine`, `lem:morphism_eq_of_eqAt_closedPoints`, `lem:eq_comp_of_isAffine_of_properIntegral`, `lem:isIntegral_of_retract_of_integral`, `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`, `lem:hom_additivity_over_product` (Cor 1.5), `lem:av_regular_map_is_hom` (Cor 1.2). Citations clean (Mumford/Milne, all `(read from references/…)` files verified on disk; verbatim quotes in source language/notation).
  - FRONTIER BLOCK 1 — `lem:hom_from_Ga_trivial`: proof under-specified; the 𝔾_a/𝔾_m collision is a one-sentence assertion and the group-scheme infra (𝔾_a/𝔾_m group objects, ℙ¹, the open immersions, the additive/mult laws) is assumed with no `\lean`/def/source. **NOT prover-ready** — needs writer decomposition (see Proofs lacking detail). Correctly carries no `\leanok`.
  - FRONTIER BLOCK 2 — `lem:rational_map_to_av_extends`: **open research question** (Weil-divisor Lemma 3.3, no Mathlib API; pointwise-valuative side-step is an admitted open question in `rmk:thm32_codim1_mathlib_gap`). **NOT prover-ready** — must not enter objectives. Correctly carries no `\leanok`.
  - SCAFFOLD SORRIES (treat as OPEN per directive): `prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1`, `thm:rigidity_genus0_curve_to_AV` carry **proof-block `\leanok` while their Lean bodies are `sorry`** — the known `sync_leanok` keyword-prefix infra bug. Not mine to fix; does not block the gate; but it produces a real `\uses`-graph laundering: `prop:morphism_P1_to_AV_constant`'s `\leanok` proof `\uses{lem:hom_from_Ga_trivial}` which is unproven, and `thm:rigidity_genus0_curve_to_AV`'s `\leanok` proof rests transitively on both unproven frontier blocks. The three are OPEN regardless of marker.
  - `\uses` graph: forward-acyclic; no broken cross-references.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Active-path content is complete+correct: `def:IsAlbanese` + extraction trio (`ofCurve`/`comp_ofCurve`/`exists_unique_ofCurve_comp`) + `thm:IsAlbanese_unique`, `def:Jacobian`, the four protected instances (`grpObj`/`smooth_genus`/`proper`/`geomIrred`), `def:JacobianWitness`, `thm:nonempty_jacobianWitness` (genus-stratified `by_cases` body), `def:genusZeroWitness`, `def:positiveGenusWitness`. Citations (Kleiman) verified — `(read from references/kleiman-picard-src/kleiman-picard.tex)` exists on disk; verbatim quotes preserved.
  - `def:genusZeroWitness` proof prose is detailed and prover-actionable for the descent (C.2.f) and terminal-cluster fields; its body is `sorry` gated correctly on the upstream keystone `thm:rigidity_genus0_curve_to_AV` (which is itself blocked by the two frontier blocks). Proof block correctly carries no `\leanok`.
  - Route A (A.1–A.4) is prose-sketch only; no prover-ready declaration blocks for the FGA engine. Intentional per strategy ("sketch-level"); see Unstarted-phase proposal. `def:positiveGenusWitness` body `sorry`, gated on Route A — correct.
  - The iter-149 `def:Jacobian ↔ thm:nonempty_jacobianWitness` cycle fix is in place (statement `\uses` pruned); graph acyclic.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - **Off-path fallback (route (a)) chapter — feeds NO active prover lane this iter.** `covers AlgebraicJacobian/RigidityKbar.lean AlgebraicJacobian/Cotangent/ChartAlgebra.lean`. The `partial` is by design: the headline `thm:rigidity_over_kbar` (the `[CharZero]` fallback artifact) carries no `\leanok` and is intentionally not pursued; 9 blocks carry `\notready` (excised bundled-route history). ChartAlgebra/KDM stack + several GrpObj-cotangent helpers ARE landed (statement `\leanok`, axiom-clean per memory). 4 blocks carry documented structured sorries with audit trails.
  - No laundering (no `\leanok` proof hiding a sorry), no citation-discipline violations, all 5 external `\uses` (to `Differentials.tex`, `Rigidity.tex`, `Cohomology_MayerVietoris.tex`) resolve.
  - **No writer action required this iter** — the chapter is an honest artifact record off the critical path. The `partial` should NOT trigger a gate block since no prover targets `RigidityKbar.lean` (the committed route is C, in `AbelianVarietyRigidity.lean`).

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.
### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.
### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Albanese consumer interface (`def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`), all `\leanok`. `def:ofCurve` has no proof block (it is a definition — correct). `thm:exists_unique_ofCurve_comp` legitimately depends on the gated `thm:nonempty_jacobianWitness`; this is the intended architecture (the interface consumes the witness), not laundering. No findings.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Thin pointer file (no formal declaration blocks); the mathematical content + statements live in `RigidityKbar.tex`. Off-path (GrpObj-cotangent material supports fallback (a)). Acceptable as a pointer; no findings.

## Cross-chapter notes
- Citation discipline: the seven cohomology/`Differentials` chapters carry NO `% SOURCE:` lines. This is **correct, not a finding** — they are Archon-original Mathlib-infrastructure builds (ModuleCat-valued sheaf cohomology, Mayer–Vietoris, Čech acyclicity), not formalisations of an external source. `Differentials.tex` has classical Stacks/Hartshorne pointers embedded in prose remarks only; its declarations are project-bespoke closure lemmas. Do not dispatch a citation fix.
- None of the cohomology/`Differentials`/`AbelJacobi`/`Cotangent_GrpObj` chapters declares `% archon:covers`; they map 1:1 by slug to their `.lean` files, so the gate's fallback mapping applies. Informational only.
- The whole-blueprint `\uses` graph is forward-acyclic and free of broken cross-references (every external `\uses` resolves to a real label in another chapter).

## Severity summary

**must-fix-this-iter:**
- `AbelianVarietyRigidity.tex` — `complete: partial`. Chapter covers `AlgebraicJacobian/AbelianVarietyRigidity.lean`; consolidated verdict gates the file. **The two frontier blocks (`lem:hom_from_Ga_trivial`, `lem:rational_map_to_av_extends`) must NOT enter prover objectives this iter.** Dispatch a blueprint-writer for this chapter to (a) decompose `lem:hom_from_Ga_trivial`'s 𝔾_a/𝔾_m collision into formalizable sub-lemmas (`Hom(𝔾_a,A)=0` + group-scheme infra defs/`\lean` hints + the multiplicative-defect extension + collision arithmetic), and (b) either flesh `lem:rational_map_to_av_extends` into a concrete pointwise-valuative sub-lemma stack OR flag to the planner that it needs a strategy/research decision (divisor-theory gap) before any prover lane. NOTE: the already-landed declarations in this chapter (Rigidity-Lemma chain, Cor 1.5, Cor 1.2) are complete+correct and are unaffected — only the *new frontier* work is gated.
- `RigidityKbar.tex` — `complete: partial` (strict-rule entry). **No action required**: off-path fallback (route (a)), feeds no active prover lane; no writer dispatch needed. Listed for completeness; does not gate any prover this iter.

**soon:**
- Route A FGA engine (Unstarted-phase proposal `Pic_RelativeSpec.tex` and successor chapters): expand into prover-ready declaration blocks before any positive-genus FGA prover lane. Deferrable this iter per STRATEGY.md §M3 (genus-0 stack must close first); planner should record the one-line deferral rationale supplied in the proposal block.

Overall verdict: The genus-0 Route C foundation is landed and sound, but **both of this iter's deep-frontier blocks are NOT prover-ready** — `lem:rational_map_to_av_extends` is an open research question (no Mathlib divisor path) and `lem:hom_from_Ga_trivial`'s 𝔾_a/𝔾_m closing step is an undecomposed one-sentence assertion with no group-scheme infrastructure; `AbelianVarietyRigidity.tex` is `complete: partial` and must get a blueprint-writer this iter before either block enters objectives. One strategy phase (Route A FGA engine) has only sketch-level coverage; a proposal is provided for immediate writer dispatch once the genus-0 stack closes (deferrable now per strategy).
