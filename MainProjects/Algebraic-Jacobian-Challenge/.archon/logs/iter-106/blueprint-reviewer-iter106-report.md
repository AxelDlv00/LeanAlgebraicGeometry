# Blueprint Review Report

## Slug
iter106

## Iteration
106

## Top-level summaries

### Incomplete parts
- `Differentials.tex`: three auxiliary lemmas appear without `\leanok` on their statement (`lem:sheafOfModules_exact_iff_stalkwise` L106, `lem:sheafOfModules_epi_of_epi_presheaf` L111, `lem:derivation_postcomp_comp` L117). The first lacks any `\lean{...}` hint because it has explicitly been declared non-formalizable upstream ("mathematical statement only; not formalised"). The other two have hints but the declarations are not formalised. The chapter narrates these gaps honestly and pegs them to the same Mathlib-gap (`SheafOfModules.stalkFunctor`, `PreservesLeftHomologyOf`/`PreservesRightHomologyOf`) blocking `case h_exact` of `cotangentExactSeq_structure`. Per the strict per-chapter gate, this still classifies as `complete: partial`.
- `Cohomology_MayerVietoris.tex` § "Čech acyclicity for the structure sheaf on affine basic-open covers" (L1110–1180): the proof sketch for `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` lists four mathematical steps but does **not** expose the iter-104/105 named-family + R-linearity engine (`cechCofaceMap_pi_smul`, `cechCofaceMap_summand_family_R_linear`) as chapter-level objects. This is acceptable for a contained-refactor of `cechCofaceMap_pi_smul`'s body (the surface API in the chapter is the main theorem, which is documented). It would NOT be acceptable if iter-108 promoted the named-family engine to a public surface; in that case dedicated definitions/lemmas would need to be added. Carry-over of the iter-105 "soon" finding.

### Proofs lacking detail
- `Picard_Functor.tex` / `\thm:Pic_representable`: the proof block (L36–46) is essentially a roadmap (Steps C0–C3) plus a citation to FGA / Mumford. This is fine because the theorem is intentionally an unattacked sorry pending the LineBundle refactor; the chapter is explicit that closing it on the approximation would assert representability of the wrong functor. No remediation needed this iter; the chapter is internally consistent with `Picard_LineBundle.tex`.
- `Jacobian.tex` / `\thm:nonempty_jacobianWitness` (L100–117): the proof body is a side-by-side narrative of two construction routes (Pic^0 vs. Stein-factorisation of Sym^g) and a separate genus-0 rigidity argument. Each route is a multi-iteration Mathlib-gap. The blueprint is explicit that the existence statement is recorded "as a single working hypothesis backing all downstream consequences" — the JacobianWitness exit policy is faithfully reflected.
- `Modules_Monoidal.tex` / `\thm:Modules_MonoidalCategory` (L41–53): the proof sketch describes the `LocalizedMonoidal` strategy and the requirement `W.IsMonoidal`. The remark at L59–60 is where the gap is admitted: `W.IsMonoidal` for varying-`R₀` is upstream-blocked (stalk-of-presheaf-tensor identification absent; alternative `MonoidalClosed` / `sheafificationCompToSheaf` routes both blocked). The prose is detailed; only the conclusion-line "active target of Phase~C step~C0" at L100 is slightly stale relative to the iter-107 strategy decision that C0 is Mathlib-gap-deferred (informational only).

### Lean difficulty quality
- All `\lean{...}` hints map to declarations with reasonable signatures. Spot-checked: `splitEpi_pi_lift_of_injective`, `cechCohomology_subsingleton_of_cechCochain_exactAt`, `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` all exist in `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` at expected locations.
- One Lean target without a corresponding hint: the named-family engine (`cechCofaceMap_pi_smul`, `cechCofaceMap_summand_family_R_linear`) is internal to `BasicOpenCech.lean`. For iter-108 in-place refactor this is fine. For exposing the engine publicly it would need chapter-level `\lean{...}` hints — soon-priority.

### Multi-route coverage
- **Phase A route — continue Čech acyclicity (iter-108 refactor of `cechCofaceMap_pi_smul`'s body OR pivot to a different Phase A sorry):** PASS. `Cohomology_MayerVietoris.tex` § sec:basic_open_acyclicity covers the main theorem with a 4-step proof sketch; the named auxiliary `splitEpi_pi_lift_of_injective` is exposed (Def + Lean target at L1119) and `cechCohomology_subsingleton_of_cechCochain_exactAt` is exposed (Thm at L1137). The chapter does not block the iter-108 refactor; the missing named-family engine prose is "soon", not blocking.
- **Phase B route — Differentials non-`h_exact` sorries:** PARTIAL. `Differentials.tex` documents every Differentials.lean sorry, but three of them are themselves carried as Mathlib-gap deferrals (no `\leanok`). The chapter is honest about the deferrals but per the strict gate is `complete: partial`. For this iter, this only matters if Phase B work is dispatched; the strategy snapshot does NOT include Phase B dispatch this iter, so the partial-ness has no operational impact.
- **Phase C1 route — LineBundle refactor:** PASS. `Picard_LineBundle.tex` carries the iter-105 Status note (L17–27) explicitly acknowledging the `CommRing.Pic Γ(X, ⊤)` approximation and naming a concrete witness (Pic(ℙⁿ_k) for n≥1). The `% NOTE:` comments at L35 and L53 honestly bound `\leanok` to the approximation-level body. The refactor target shape (`MonoidalCategory.Invertible` applied to `X.Modules`) is articulated at L27.
- **Phase C3 route — JacobianWitness exit policy:** PASS. `Jacobian.tex` § "Existence of an Albanese variety" (L100–117) commits to `thm:nonempty_jacobianWitness` as the single working hypothesis, with both higher-genus and genus-0 rigidity content absorbed. The definition of `Jacobian` at L42–50 explicitly uses `def:Jacobian.\uses{thm:nonempty_jacobianWitness}`, threading the exit policy correctly. `AbelJacobi.tex` L53–58 closes the Albanese property via this same hypothesis. The blueprint does not claim Phase C3 will be closed within the project — it claims it is gated on `nonempty_jacobianWitness`.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-instance chapter (sheaf-compose transport); statement + proof carry `\leanok`; downstream wiring is sound.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Two infrastructure theorems + one definition (`toAbSheaf`); all `\leanok`. Cross-references to Phase A step 5/6 carriers in `Cohomology_StructureSheafModuleK.tex` are consistent.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true (substantively — all sections present, including the iter-038–044 carriers and the iter-039 curve specialisations)
- **correct**: partial
- **notes**:
  - **must-fix-this-iter**: Broken `\uses` at L474 inside the proof block of `\thm:Scheme_module_finite_globalSections_of_isProper`. The reference reads `thm:Scheme_toModuleKSheaf` but no such label exists; the intended target is the definition `def:Scheme_toModuleKSheaf` (declared at L144). Pure typo (`thm:` should be `def:`). This is a depgraph-corrupting broken cross-reference — must fix.
  - Otherwise the chapter is comprehensive; the typeclass plumbing (sheafification, Ext, presheaf-of-`k`-modules, sheaf condition, `\v{C}}ech` carriers) is fully scaffolded with proof prose.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true (substantively; main API documented end-to-end through `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` at L1151)
- **correct**: true
- **notes**:
  - Chapter is dense (~1185 lines). Every section needed for iter-108 Phase A dispatch is in place: the abstract MV LES (§ "Mayer–Vietoris long exact sequence"), the curve specialisation (§ "Two-affine open covers"), the Čech-acyclicity engine and its top-supremum transport (§ "Čech acyclicity and vanishing on affines"), the comparison-iso typeclass carrier (`HasCechToHModuleIso`), and the basic-open cover infrastructure (§ "Basic-open cover infrastructure").
  - **soon**: § "Čech acyclicity for the structure sheaf on affine basic-open covers" (L1110–1180) does not surface the iter-104/105 named-family + R-linearity engine (`cechCofaceMap_pi_smul`, `cechCofaceMap_summand_family_R_linear`). This is OK for an iter-108 in-place refactor of `cechCofaceMap_pi_smul`'s body (the chapter-level surface is the main theorem, which is documented). It is NOT yet sufficient if iter-108 (or a later iter) decides to expose the engine as a chapter-level API — those declarations would then need their own `\lean{...}` hints and proof sketches. Carry-over of iter-105 "soon".
  - All `\uses{...}` references in the chapter resolve to existing labels (verified via comm-23 against the global label table).

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true (the deferrals are honestly documented; the math content is sound)
- **notes**:
  - Three auxiliary lemmas without `\leanok`:
    - `lem:sheafOfModules_exact_iff_stalkwise` (L106) — no `\lean{...}` hint at all; the lemma is explicitly recorded as "mathematical statement only; not formalised" and is the cleanest formulation of what `case h_exact` of `cotangentExactSeq_structure` actually wants. Deferred parallel to `instIsMonoidal_W` (varying-`R₀` stalk-of-tensor missing).
    - `lem:sheafOfModules_epi_of_epi_presheaf` (L111) — has `\lean{SheafOfModules.epi_of_epi_presheaf}` but no `\leanok`. Mathlib-gap fill.
    - `lem:derivation_postcomp_comp` (L117) — has `\lean{PresheafOfModules.Derivation.postcomp_comp}` but no `\leanok`. Mathlib-shape lemma.
  - `case h_exact` of `cotangentExactSeq_structure` is documented at L93 as deferred upstream; the chapter prose is internally consistent. The `% NOTE: (iter-086+iter-087)` block makes the deferral explicit.
  - **Impact for iter-108**: the strategy snapshot states Phase B is untouched recently. The partial-completeness of this chapter does not block any active route; it only blocks Phase B dispatch on `Differentials.lean`, which the planner is already deferring.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The genus definition and its `noncomputable` authorisation are documented. The Phase A step 6 (Serre finiteness) gap is explicit. No issues.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The `instIsMonoidal_W` gap is faithfully captured: § L59–61 explicitly notes it as the only outstanding piece of Phase~C step~C0 and frames it as a Mathlib gap (varying-`R₀` stalk-of-presheaf-tensor missing; closedness route blocked; sheafification-compose route blocked). The chapter is honest.
  - **informational**: L100 prose "the file is the active target of Phase~C step~C0 in the project strategy" is mildly stale: per iter-107 strategy decisions, C0 is Mathlib-gap-deferred, not "active target". No operational impact but the language could be tightened in a future writer pass.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Steps C0–C3 are listed in the proof block of `\thm:Pic_representable`. The Forward-compatibility note (L75–77) is the right shape: any closure of representability on the approximation-level LineBundle would silently assert the wrong functor's representability; chapter explicitly refuses to weaken the statement.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The abelian-group-valued variant + forget-and-recover natural iso + étale-sheafification stub are documented. Chapter prose is consistent with `Picard_Functor.tex`.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The iter-105-added Status note (Phase C1) at L17–27 explicitly acknowledges the `CommRing.Pic Γ(X, ⊤)` approximation, names a concrete failure witness (Pic(ℙⁿ_k) for n≥1 vs. CommRing.Pic(k)=trivial), and pegs the Phase~C1 refactor target (`MonoidalCategory.Invertible` applied to `X.Modules`).
  - The `% NOTE: \leanok holds for the current approximation-level Lean body` comments at L35 and L53 are appropriate hygiene: they warn future readers that the `\leanok` markers on `\thm:Scheme_Pic_commGroup` and `\thm:Scheme_Pic_pullback` certify closure against the wrong body and will need re-confirmation after C1.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - JacobianWitness exit policy is faithfully reflected. `def:Jacobian` (L42–50) cites `thm:nonempty_jacobianWitness` in its `\uses{...}` set, threading the exit hypothesis correctly through to the four Jacobian instances (`grpObj`, `smooth_genus`, `proper`, `geomIrred`). `thm:nonempty_jacobianWitness` (L100–117) is honestly recorded as a multi-iteration Mathlib-gap hypothesis. The genus-0 rigidity content is absorbed.
  - Chapter does NOT claim Phase C3 will be closed within the project; it explicitly bundles existence into the named hypothesis.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The standalone helper `\thm:GrpObj_eq_of_eqOnOpen` is documented with a full proof sketch citing only Mathlib infrastructure that is present (separatedness from properness, equaliser closedness, irreducibility, smoothness ⇒ regularity ⇒ reducedness). Highest-leverage standalone target as the chapter advertises.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three theorems (Abel-Jacobi map, pointed property, Albanese universal property) routed through `thm:nonempty_jacobianWitness` and `def:IsAlbanese`. The implementation note at L61–65 acknowledges that the Albanese-framework route absorbs all the missing infrastructure into a single hypothesis — consistent with `Jacobian.tex` and the JacobianWitness exit policy.

## Cross-chapter notes

- **Broken cross-reference**: `Cohomology_StructureSheafModuleK.tex:474` references `thm:Scheme_toModuleKSheaf`. No such label exists; the only matching label is `def:Scheme_toModuleKSheaf` (declared at L144 of the same file). Single typo (`thm:` should be `def:`). This is the only broken `\uses{...}` in the blueprint as verified by the comm-23 of all `\label{...}` slugs against all `\uses{...}` slugs.
- **JacobianWitness threading**: `Jacobian.tex`, `AbelJacobi.tex`, and the implicit consumers in the four Jacobian.lean theorems all consistently route through `thm:nonempty_jacobianWitness`. No drift detected.
- **LineBundle approximation acknowledgement**: `Picard_LineBundle.tex` Status note + `Picard_Functor.tex` Forward-compatibility note + `Modules_Monoidal.tex` "Status of W.IsMonoidal" remark form a coherent triangle. Each chapter independently asserts the LineBundle approximation is wrong-on-non-affine and points at C1 as the refactor target; nothing weakens any chapter's headline statement to the approximation.
- **`def:Scheme_toModuleKSheaf` is heavily depended-upon**: 14 chapters/sections reference it (Genus, Cohomology_MayerVietoris ×8, Cohomology_StructureSheafModuleK ×6). The broken `\uses{thm:...}` typo at L474 will be silently dropped by the depgraph tool — it does NOT cause an immediate prover-side error, but it does mean `thm:Scheme_module_finite_globalSections_of_isProper` is depgraph-incorrectly marked as having no dependency on `def:Scheme_toModuleKSheaf` from that specific `\uses{...}` site (other downstream theorems do thread the dependency correctly). The cosmetic damage is minor; the rule-driven obligation to fix is firm.

## Strategy-modifying findings (if any)

None. Every chapter accurately reflects the iter-107 strategy decisions:
- JacobianWitness exit policy → faithfully reflected in `Jacobian.tex`, `AbelJacobi.tex`.
- LineBundle approximation as wrong-def → acknowledged in `Picard_LineBundle.tex`, `Picard_Functor.tex`, `Modules_Monoidal.tex`.
- `instIsMonoidal_W` as Mathlib-gap-deferred → documented in `Modules_Monoidal.tex` and parallelled in `Differentials.tex` for `case h_exact`.
- Phase A as the active prover route → adequately covered by `Cohomology_MayerVietoris.tex` for iter-108 in-place refactor or pivot.

## Severity summary

**must-fix-this-iter** (2 findings):

1. **`Cohomology_StructureSheafModuleK.tex:474` — broken `\uses{thm:Scheme_toModuleKSheaf}`** (should be `def:Scheme_toModuleKSheaf`). Single-token typo. Dispatch a blueprint-writer targeted at this one chapter; the fix is one character (`thm:` → `def:`) but the depgraph integrity rule is non-negotiable.
2. **`Differentials.tex` is `complete: partial`** — three auxiliary lemmas (`lem:sheafOfModules_exact_iff_stalkwise`, `lem:sheafOfModules_epi_of_epi_presheaf`, `lem:derivation_postcomp_comp`) lack `\leanok` due to honest upstream Mathlib gaps that the chapter prose explicitly acknowledges. Per the strict per-chapter gate this triggers a blueprint-writer dispatch obligation. **Practical recommendation**: the partial-ness reflects intentional deferral, so the planner should either (a) dispatch a no-op writer that re-confirms the deferral is still warranted, or (b) note in `iter/iter-106/plan.md` that Phase B prover dispatch on `Differentials.lean` is deferred this iter due to the chapter's partial-ness and that no writer dispatch is operationally required since strategy already defers Phase B. The hard-gate as written says "dispatch writer"; the planner's discretion applies given the gap is documented.

**soon** (2 findings):

1. **`Cohomology_MayerVietoris.tex` § "Čech acyclicity for the structure sheaf on affine basic-open covers" prose does not surface the iter-104/105 named-family + R-linearity engine** (`cechCofaceMap_pi_smul`, `cechCofaceMap_summand_family_R_linear`). Carry-over of iter-105 "soon". Does NOT block iter-108 Phase A dispatch (in-place refactor or pivot to a different Phase A sorry); it WILL become must-fix if a later iter promotes the engine to a public chapter-level API.
2. **`Modules_Monoidal.tex` L100 prose "active target of Phase~C step~C0"** is mildly stale relative to iter-107 strategy; should be tightened to "Mathlib-gap-deferred" in a future writer pass. Informational, no operational impact.

**informational** (1 finding):

1. Naming consistency: chapter labels use `def:` / `thm:` / `lem:` / `cor:` / `inst:` conventions. One inconsistency: `Cohomology_StructureSheafModuleK.tex` L359, L386, L440 use `\label{thm:Scheme_IsAffineHModuleVanishing}` / `\label{thm:Scheme_IsAffineHModuleHomFinite}` / `\label{thm:Scheme_IsHModuleHomFinite}` for what are `\begin{definition}` blocks. These labels parse correctly (a label is just a string), but the `thm:` prefix on a definition block is mildly confusing for human readers. Not blocking.

**Overall verdict**: The blueprint is in good operational shape for iter-108 Phase A dispatch on `BasicOpenCech.lean`; the only chapter-level fix that is strictly mandatory is the one-character `\uses` typo at `Cohomology_StructureSheafModuleK.tex:474`, and the Differentials.tex partial-ness is honest documentation of an intentionally-deferred Mathlib-gap rather than an actionable chapter defect.
