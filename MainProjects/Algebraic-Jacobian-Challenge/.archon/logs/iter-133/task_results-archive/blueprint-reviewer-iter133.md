# Blueprint Review Report

## Slug
iter133

## Iteration
133

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` / `lem:GrpObj_mulRight_globalises` (lines 243–268, piece (i.b) prover-lane candidate): proof sketch is high-level and lacks the named Mathlib lemmas a prover would need. Specifically:
  - No `% Lean signature stub:` comment (in stark contrast to `lem:GrpObj_cotangentSpace`, `lem:GrpObj_cotangent_bridge`, and `lem:GrpObj_lieAlgebra_finrank`, all of which have explicit stubs).
  - The named Lean target `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent` invokes `mulRight` in its name, but the prose actually constructs the categorical shear iso `σ = ⟨pr₁, μ⟩ : G ×ₖ G → G ×ₖ G`. The relationship between `GrpObj.mulRight` (right-translation by a point — a `G ⟶ G` map) and the shear iso (a `G ×ₖ G ⟶ G ×ₖ G` map) is not explained; a prover would have to guess the exact Lean type signature.
  - The proof's pivotal step — "pullback along σ together with the canonical first-projection-cotangent identification `Ω_{(G ×ₖ G)/G} ≅ pr₂* Ω_{G/k}`" — names no Mathlib lemma for the base-change-of-differentials identification, nor specifies which Mathlib API for "pullback of presheaves of modules along a scheme morphism" is in play (the project's own `relativeDifferentialsPresheaf` is presheaf-level; a sheaf-of-modules natural-iso target would need the heavier sheafified API).
  - The "restriction along the section `⟨id_G, η_G⟩`" step that converts pullback-along-σ into the displayed iso `Ω_{G/k} ≅ pr₁*(η_G* Ω_{G/k})` is one prose sentence; the Lean construction it dictates is non-obvious.

- `RigidityKbar.tex` / `lem:GrpObj_omega_free` (lines 270–281, piece (i.c) prover-lane candidate for iter-137+): proof sketch is one sentence ("pullback of a finitely generated free `k`-module along the structure morphism is a finitely generated free `O_G`-module"); no Lean signature stub; no named Mathlib lemma for the pullback construction or the freeness preservation. Not on iter-133 critical path — flag for iter-137+ blueprint hardening before that prover lane.

- `RigidityKbar.tex` / `lem:GrpObj_omega_rank_eq_dim` (lines 283–294, piece (i.c) prover-lane candidate for iter-137+): same as above — one-sentence proof, no Lean signature stub.

- `Jacobian.tex` / C.2.a–C.2.e sub-steps (lines 322–352): prose still framed over the algebraic closure `\bar k` (e.g. "Let A be a smooth proper geometrically irreducible group scheme over `\bar k`", `\mathbb P^1_{\bar k}`), even though C.2.f explicitly DROPs the Galois descent step and C.2.g pivots to the over-k inventory under the iter-127 commitment. Internally consistent (C.2.f drops the descent, C.2.g re-states the gap in over-k form) but misleading on a quick read. Iter-132 reviewer's `correct: partial` flag on this drift still stands; iter-132 plan agent's "defer iter-133+ as informational" pre-deferral is defensible because no active prover route reads C.2.a–C.2.e (the named declaration `thm:rigidity_over_kbar` lives in `RigidityKbar.tex` and is properly over-k framed).

### Proofs lacking detail

- `RigidityKbar.tex` / `lem:GrpObj_mulRight_globalises` (proof, lines 261–268): as above — "One verifies σ ∘ τ = id_{G×G} = τ ∘ σ using the GrpObj axioms (associativity and left-inverse)" is the entire content of the inverse verification; the categorical bookkeeping is non-trivial in Lean's `Over (Spec k)` API (cf. how much scaffolding `cotangentSpaceAtIdentity_eq_extendScalars` needed even for a `rfl`-flavoured proof). The proof needs at least to name the relevant `GrpObj`-API closures (associativity / left-inverse axioms in `Mathlib.CategoryTheory.Monoidal.Grp_`) and to clarify which Mathlib lemma supplies `Ω_{(G ×ₖ G)/G} ≅ pr₂* Ω_{G/k}` (the easy base-change-cancellation direction of the relative cotangent of a fibre product over G).

- `RigidityKbar.tex` lines 302–306 ("Iter-131 Classical.choose-chain body shape", paragraph footer): the "recommended downstream rewrite pattern" describes `obtain ⟨U, V, e, h_top, heq⟩ := cotangentSpaceAtIdentity_eq_extendScalars G`, then `rw [heq]` to expose the explicit `extendScalars` form. The actual closure of `cotangentSpaceAtIdentity_finrank_eq` in `AlgebraicJacobian/Cotangent/GrpObj.lean:276–282` does NOT use this pattern — it uses a direct `change Module.finrank k (TensorProduct …) = n` instead. The blueprint's "recommended pattern" is out of step with what the lemma actually does; downstream consumers seeing the prose would write a heavier rewrite than necessary. (Iter-132 reviewer's MED-C finding — still applicable.)

### Lean difficulty quality

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` (line 245): poor — no signature stub, target name mentions `mulRight` (translation by a point) but the prose constructs a categorical shear iso `σ = ⟨pr₁, μ⟩`. A prover has no way to infer (a) whether the return type is a `LinearEquiv` / `Iso` / `NatIso` / `LinearIso`-of-sheaves, (b) which categorical home (presheaf-of-modules vs sheaf-of-modules vs `ModuleCat (Γ(G, ⊤))`) the conclusion lives in, (c) whether `mulRight` literally appears in the signature or is just a folk name for the underlying construction. This is the central reason piece (i.b) should NOT go to a prover this iter.

- `RigidityKbar.tex` line 121, 206, 307: `cotangentSpaceAtIdentity_eq_extendScalars` is named three times by `\texttt{...}` but has no `\lean{...}` block of its own. The companion lemma exists in the tree (`AlgebraicJacobian/Cotangent/GrpObj.lean:198`) and would benefit from being a first-class blueprint citizen. Iter-132 reviewer's MED-B item — still applicable.

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.omega_free}` and `\lean{AlgebraicGeometry.GrpObj.omega_rank_eq_dim}` (lines 272, 285): poor — no Lean signature stubs. Not on iter-133 critical path; flag for iter-137+ pre-prover hardening.

### Multi-route coverage

(Strategy-snapshot routes from the directive: HARD GATE checks for piece (i.b) prover lane + refactor lane on `Cotangent/GrpObj.lean`. No multi-route alternatives surfaced in directive.)

- Route "M2.a piece (i.b) → mulRight_globalises_cotangent prover lane (iter-133)": **MISSING** — see Incomplete parts and Lean difficulty quality above. Blueprint coverage exists in `RigidityKbar.tex` § (i.b) but is not detailed enough to dispatch a prover. **HARD GATE: DEFER** (see below).
- Route "refactor lane on `Cotangent/GrpObj.lean` docstring updates + MED-B/MED-C bundle": **PARTIAL** — the docstring-level edits don't require blueprint changes; the MED-B `\lean{...}` block and MED-C downstream-rewrite-pattern fix are blueprint-side and small. **HARD GATE: PARTIAL GREEN** (see below).
- Route "iter-127 over-k commitment, broadly": PASS — `RigidityKbar.tex` chapter intro + (i)+(ii)+(iii) decomposition correctly framed over arbitrary `k`; `Rigidity.tex` ext-of-eqOnOpen statement correctly over arbitrary `k`; `Jacobian.tex` C.2.f DROPPED + C.2.g over-k inventory present (C.2.a–C.2.e prose drift documented above is informational).

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single transport theorem `thm:HasSheafCompose_forget`; statement, proof sketch, and `\lean{...}` all sound. `\leanok` on statement and proof.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All three blocks (`thm:HasSheafify_Opens_AddCommGrp`, `thm:HasExt_Sheaf_Opens_AddCommGrp`, `def:Scheme_toAbSheaf`) have `\leanok`, named Lean targets, and adequate proof sketches.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Large chapter (655 lines); all blocks `\leanok` with named Lean targets.
  - Label naming style: a handful of `\begin{definition}` blocks use `\label{thm:Scheme_IsAffineHModule...}` (with `thm:` prefix) rather than `def:`; not a structural problem but causes the broken `\ref{def:Scheme_IsAffineHModuleVanishing}` in Cohomology_MayerVietoris.tex (see cross-chapter notes).

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Two broken `\ref{...}` cross-refs at line 769: `sec:basic_open_acyclicity` and `sec:basic_open_infrastructure` point at sections that do not exist in this file or anywhere in the blueprint. These appear to be stale forward references to never-written sub-sections of the Čech-acyclicity machinery. The Mayer–Vietoris chapter is otherwise complete and entirely `\leanok`; these refs corrupt only the human-readable cross-link, not the dependency graph (all `\uses{...}` cross-refs are clean).
  - One broken `\ref{def:Scheme_IsAffineHModuleVanishing}` at line 917 — the actual label uses prefix `thm:` not `def:` (label declared at Cohomology_StructureSheafModuleK.tex line 358–359).
  - These three broken `\ref{...}` are `soon` severity (not `must-fix-this-iter`) — none corrupts a `\uses{...}` dependency graph entry, and no iter-133 prover route consumes this chapter (everything is `\leanok`). Recommend rolling into the next routine blueprint-cleanup pass.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:relative_kaehler_presheaf`, `lem:relative_kaehler_presheaf_obj`, `thm:smooth_locally_free_omega`, plus the M1-excise standalone Kähler-localization utilities (`lem:kaehler_localization_subsingleton`, `lem:kaehler_quotient_localization_iso`) — all `\leanok` with sound proof sketches and named Mathlib closures.
  - `thm:smooth_locally_free_omega` is the load-bearing existential consumed by both `cotangentSpaceAtIdentity` (in `Cotangent/GrpObj.lean`) and the rank lemma `cotangentSpaceAtIdentity_finrank_eq`; signature and prose remain consistent with the Lean implementation.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:genus` (`\lean{AlgebraicGeometry.genus}`) — `\leanok`, sound. The chapter clearly distinguishes the definition (closed) from the genus-equality-with-`h⁰(Ω)` reformulations (deferred to Serre duality / Riemann–Roch, multi-iteration).

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - All named declarations (`def:IsAlbanese`, `def:IsAlbanese_ofCurve`, `lem:IsAlbanese_comp_ofCurve`, `lem:IsAlbanese_exists_unique_ofCurve_comp`, `thm:IsAlbanese_unique`, `def:Jacobian`, `thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`, `thm:Jacobian_geomIrred`, `def:JacobianWitness`, `thm:nonempty_jacobianWitness`, `def:genusZeroWitness`) present, `\lean{...}` hints sound, signatures consistent with `AlgebraicJacobian/Jacobian.lean`.
  - **Soft drift in C.2.a–C.2.e (lines 322–352)**: prose still framed over `\bar k` even though C.2.f explicitly DROPs the descent step and C.2.g pivots to the over-k inventory. Iter-132 reviewer flagged this; iter-132 plan agent deferred as informational. **Re-verdict for iter-133**: still informational — no active prover route consumes C.2.a–C.2.e (the named declaration is in `RigidityKbar.tex` and is correctly over-k framed). Recommendation: if iter-133's planner has spare blueprint-writer bandwidth (likely yes given the piece (i.b) DEFER), dispatch a narrow blueprint-writer to re-cast C.2.a–C.2.e in over-k prose for human-reader clarity. Not a HARD GATE blocker for any iter-133 prover lane.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:GrpObj_eq_of_eqOnOpen` (`\lean{AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen}`) — `\leanok`, sound. Iter-125 refactor properly documented; Mathlib closure pieces named. The "Use in the project" section correctly cites both M2.a (genus-0 via `RigidityKbar`) and Albanese-uniqueness consumers.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **(must-fix-this-iter for the piece (i.b) HARD GATE)** `lem:GrpObj_mulRight_globalises` (lines 243–268) is `\notready` and substantively under-spec'd for a prover dispatch:
    1. Missing `% Lean signature stub:` comment block.
    2. Lean target name `mulRight_globalises_cotangent` doesn't match the prose construction (shear iso `σ = ⟨pr₁, μ⟩`); need either a name change or an explanation of how `mulRight` enters.
    3. Proof sketch leaves at least three load-bearing Lean-encoding decisions unstated: (a) sheaf-of-modules vs presheaf-of-modules home for the conclusion `Ω_{G/k} ≅ pr₁*(η_G* Ω_{G/k})`; (b) which Mathlib lemma supplies the base-change identification `Ω_{(G ×ₖ G)/G} ≅ pr₂* Ω_{G/k}`; (c) the Lean realisation of "restriction along the section `⟨id_G, η_G⟩`" inside `Over (Spec k)`.
    4. The functorial-vs-pointwise iter-127 over-k risk register at line 258 is correct and remains in force; the discharge plan (shear `σ` is a scheme map in `Over (Spec k)`) is sound, but the blueprint owes the prover a concrete Lean type for `σ`.
  - **(informational, MED-B from iter-132)** `cotangentSpaceAtIdentity_eq_extendScalars` is named by `\texttt{...}` at lines 121, 206, and 307 but lacks its own `\lean{...}` blueprint block. The companion lemma exists in the tree at `AlgebraicJacobian/Cotangent/GrpObj.lean:198`; promoting it would let downstream consumers find it via the dependency graph.
  - **(informational, MED-C from iter-132)** The "Iter-131 Classical.choose-chain body shape" paragraph (line 302–306) recommends a downstream rewrite pattern (`obtain` + `rw [heq]`) that does NOT match the route actually taken by `cotangentSpaceAtIdentity_finrank_eq` in `AlgebraicJacobian/Cotangent/GrpObj.lean:276–282` (which uses `change` directly, no `obtain`). The blueprint's recommendation should be updated to describe the direct `change`-based route, with the `obtain`-based variant retained only as an alternative.
  - **(informational, future iter-137+)** `lem:GrpObj_omega_free` (lines 270–281) and `lem:GrpObj_omega_rank_eq_dim` (lines 283–294) — both `\notready`, both have one-sentence proofs and no Lean signature stubs. Not on iter-133 critical path; flag for blueprint hardening before the iter-137+ piece (i.c) prover lane.
  - **(closed iter-132, retained for context)** `lem:GrpObj_cotangentSpace` (lines 92–110), `lem:GrpObj_cotangent_bridge` (lines 124–153, `\notready`, intentionally deferred under Replacement (B) trio→duo collapse), and `lem:GrpObj_lieAlgebra_finrank` (lines 180–198, closed iter-132 at `AlgebraicJacobian/Cotangent/GrpObj.lean:244`) — all correct, complete, well-formulated. Lean signature stubs present and accurate.
  - **(strategy-track)** `thm:rigidity_over_kbar` (lines 18–32) and `rem:rigidity_over_kbar_dim_dichotomy` — statement clean; the `\leanok` on the statement marks the iter-126 scaffolding (Lean declaration exists with `sorry` body), which is appropriate per the project's `\leanok` conventions.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp` — all `\leanok`, sound, named Lean targets consistent with `AlgebraicJacobian/AbelJacobi.lean`. The classical-description remarks correctly route through `\cref{thm:rigidity_over_kbar}` per the iter-127 over-k commitment.

## Cross-chapter notes

- **Broken `\ref{}` (not `\uses{}`) cross-refs** — three sites; do not corrupt the dependency graph, but are surface-level rendering bugs to clean up in a future blueprint-cleanup pass:
  1. `Cohomology_MayerVietoris.tex:769` references `sec:basic_open_acyclicity` and `sec:basic_open_infrastructure` — neither label exists anywhere in the blueprint.
  2. `Cohomology_MayerVietoris.tex:917` references `def:Scheme_IsAffineHModuleVanishing` — actual label uses `thm:` prefix (`Cohomology_StructureSheafModuleK.tex:358–359`).
- **No broken `\uses{...}` cross-refs**: scan of all 95 distinct `\uses` arguments against the 195 declared `\label`s returned a clean diff. The dependency graph integrity is intact for every prover-relevant consumer.
- **`cotangentSpaceAtIdentity_eq_extendScalars`** is referenced by name three times in `RigidityKbar.tex` (lines 121, 206, 307) and exists in the Lean tree at `AlgebraicJacobian/Cotangent/GrpObj.lean:198` but is not promoted to a first-class blueprint declaration (MED-B). Surfacing it as a `\begin{lemma}...\lean{...}...\end{lemma}` block would let it appear in the dependency graph for the rank lemma.
- **Blueprint vs Lean drift on rank-lemma route pattern** (MED-C): `RigidityKbar.tex:306` describes the recommended `obtain`+`rw` consumption pattern; the actually-closed `cotangentSpaceAtIdentity_finrank_eq` at `Cotangent/GrpObj.lean:276–282` uses a direct `change` route. Update the blueprint prose to describe the direct route.

## Strategy-modifying findings

None. The iter-127 over-k commitment continues to hold cleanly across `RigidityKbar.tex`, `Rigidity.tex`, `Jacobian.tex` (modulo the C.2.a–C.2.e prose drift, which is informational), and `AbelJacobi.tex`. The Replacement (B) trio→duo collapse on piece (i.a) — closed iter-132 — is correctly reflected in the rank-lemma proof body and footer.

## HARD GATE verdicts (per the iter-133 planner's specific questions)

### Question 1: Prover lane on piece (i.b) — `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`

**HARD GATE: DEFER iter-133.** Drop `Cotangent/GrpObj.lean` / piece (i.b) from this iter's prover objectives. Dispatch a blueprint-writer this iter targeted at `RigidityKbar.tex` § `lem:GrpObj_mulRight_globalises` (lines 243–268) with directive:
- Add a `% Lean signature stub:` comment block (mirroring the `lem:GrpObj_cotangentSpace` and `lem:GrpObj_lieAlgebra_finrank` shape) — naming the precise Lean type of the conclusion iso, including the categorical home (`PresheafOfModules` / `SheafOfModules` / `LinearEquiv`).
- Clarify the relationship between the named target `mulRight_globalises_cotangent` and the proof's actual construction (shear iso `σ = ⟨pr₁, μ⟩`); either rename the target to align with `σ` or explain how `mulRight` feeds into the construction.
- Name the Mathlib lemma supplying the base-change-of-differentials identification `Ω_{(G ×ₖ G)/G} ≅ pr₂* Ω_{G/k}` (the "easy" direction of the relative cotangent sequence for a fibre product over G).
- Optionally factor the proof's "restriction along the section `⟨id_G, η_G⟩`" step into a separate sub-lemma if Lean ergonomics warrant it.

Per the dispatcher_notes "What 'deferred' means in practice": the 1-iter latency cost of waiting for a writer is small compared to the cost of a prover formalizing this under-spec'd lemma and the work being thrown away. Log the deferral in iter-133 `plan.md` citing this report.

The iter-132 META-PATTERN TRIPWIRE non-promise commitment on piece (i.a) — "no 4th body reshape under any branch" — is unrelated and does not bind on (i.b).

### Question 2: Refactor lane on `Cotangent/GrpObj.lean` (docstring-only + MED-B/MED-C blueprint bundle)

**HARD GATE: PARTIAL GREEN.** The docstring-only edits to `Cotangent/GrpObj.lean` (5 stale-framing sites) do not depend on the blueprint and can proceed unconditionally — no HARD GATE applies to a non-prover refactor lane.

The blueprint-side MED-B + MED-C items are small enough to bundle into the same iter via a thin blueprint-writer dispatch:
- **MED-B**: Add `\begin{lemma}...\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}...\leanok...\end{lemma}` block to `RigidityKbar.tex`, after `lem:GrpObj_cotangentSpace` and before `lem:GrpObj_cotangent_bridge`, with `\uses{lem:GrpObj_cotangentSpace, thm:smooth_locally_free_omega}`. Statement: the structural-shape rewrite handle described in the body of `Cotangent/GrpObj.lean:190–219`. Marker: `\leanok` (the Lean proof is already closed).
- **MED-C**: Rewrite the second half of the paragraph at `RigidityKbar.tex:302–306` ("recommended downstream rewrite pattern") to describe the direct `change`-based route used in `Cotangent/GrpObj.lean:276–282`, retaining the `obtain`+`rw [heq]` pattern only as an alternative.

Both items are small, additive, and do not interact with the piece (i.b) blueprint-writer dispatch above. They can either ride along on the same writer dispatch or be a separate narrow writer call.

### Question 3: No prover lane on piece (i.a)

**Confirmed**: piece (i.a) — `lem:GrpObj_cotangentSpace`, `lem:GrpObj_lieAlgebra_finrank`, `cotangentSpaceAtIdentity_eq_extendScalars` — all closed iter-128 → iter-132, no 4th body reshape proposed by this report. The META-PATTERN TRIPWIRE non-promise commitment binds; do not dispatch a piece (i.a) prover lane this iter.

## Severity summary

- **must-fix-this-iter**:
  1. `RigidityKbar.tex` `complete: partial` + `correct: partial` — `lem:GrpObj_mulRight_globalises` under-spec'd, blocks the piece (i.b) prover dispatch. Dispatch a `blueprint-writer` for `RigidityKbar.tex` this iter targeting the four items listed under HARD GATE Q1. (The piece (i.a) blocks in this chapter are fine; the must-fix list is specifically the (i.b) lemma.)
- **soon**:
  1. `Jacobian.tex` C.2.a–C.2.e over-`\bar k` prose drift (`correct: partial`). Informational; non-blocking for any iter-133 prover lane (no prover route consumes this prose). If iter-133 plan has writer bandwidth left after the (i.b) dispatch, batch a thin writer pass to re-cast C.2.a–C.2.e in over-k prose; otherwise defer to iter-134+.
  2. Three broken `\ref{}` cross-refs in `Cohomology_MayerVietoris.tex` (lines 769 × 2 + 917 × 1). HTML-rendering bug only; no `\uses{...}` integrity violation; no prover-route impact. Roll into a future blueprint-cleanup pass.
  3. MED-B (`\lean{cotangentSpaceAtIdentity_eq_extendScalars}` block) and MED-C (downstream-rewrite-pattern fix) — both blueprint-side. Bundle with the iter-133 refactor lane on `Cotangent/GrpObj.lean` per HARD GATE Q2 above, or defer to iter-134+.
- **informational**:
  1. `lem:GrpObj_omega_free` and `lem:GrpObj_omega_rank_eq_dim` (piece (i.c) lemmas) have minimal proof prose and no Lean signature stubs. Not on iter-133 critical path; queue for a blueprint-hardening pass before the iter-137+ piece (i.c) prover lane.
  2. `RigidityKbar.tex` `\lean{AlgebraicGeometry.rigidity_over_kbar}` Lean filename still carries the iter-126 over-`\bar k` name even though the signature and prose framing have shifted to over-k. Iter-128+ rename is documented as low-priority; not blocking.

Overall verdict: **One must-fix-this-iter (RigidityKbar.tex § lem:GrpObj_mulRight_globalises) blocks the iter-133 piece (i.b) prover lane; refactor + MED-B/C bundle on `Cotangent/GrpObj.lean` is green to dispatch independently; all other chapters audited clean.**
