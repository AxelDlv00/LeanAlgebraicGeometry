# Blueprint Review Report

## Slug
iter154

## Iteration
154

## Top-level summaries

### Proofs lacking detail
(none rising to a finding — the KDM live route is, if anything, over-detailed; see per-chapter note.)

### Multi-route coverage
- KDM forward direction — single live route (single-element / perfect-field / Jacobi–Zariski H1Cotangent (FT.1)–(FT.3)): **PASS**. Fully covered in `RigidityKbar.tex` KDM proof block, corroborated by 8 type-checking `example` blocks in `analogies/ftthree-kernel-iter154.md`. The prior separating-transcendence-basis route is explicitly DISCARDED (no `IsTranscendenceBasis`-keyed Ω-freeness lemma ships); the (p1) char-p and (p2) `Differential.ContainConstants` explorations are demoted to a clearly-marked historical record. No live route lacks coverage.

### Citation discipline
(no findings — spot-checks below all pass.)
- `RigidityKbar.tex` KDM live route: every `[verified by compilation]` Mathlib name is corroborated by the citation table + `example` blocks in `analogies/ftthree-kernel-iter154.md` (file exists, 13.5 KB). Names used in correct roles (verified below).
- `thm:rigidity_over_kbar`: `% SOURCE` cites Mumford II §4 with **no** `% SOURCE QUOTE` and an explicit honest disclosure that the source is paywalled/not bundled and recalled text must not be substituted. This is the correct citation-discipline behaviour for an unbundled source, **not** a fabrication.
- Source-file existence: `references/stacks-{varieties,fields,coherent,algebra}.tex` and `references/kleiman-picard-src/kleiman-picard.tex` all exist on disk; the `(read from …)` parentheticals across `RigidityKbar.tex`, `ChartAlgebraS3.tex`, `Jacobian.tex` resolve.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The two carrier typeclasses `HasCechToHModuleIso` and `HasAffineCechAcyclicCover` are honestly documented (§"Use in the project", "Producer status") as currently *unproduced*; downstream genus-finiteness ships as a conditional theorem under these hypotheses. This is disclosed, not a defect.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.
  (Definition closed; Serre-finiteness for the *theorem* is correctly documented as a deferred Mathlib gap, distinct from the definition.)

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.
  (Forward smoothness criterion closed in algebra-Kähler form; converse correctly documented as mathematically false with an explicit counterexample and the missing `Subsingleton (H1Cotangent A B)` hypothesis named.)

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.
  (Pointer chapter; orphan-helper disposition after the iter-145 excise is documented.)

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All four (S3.*) sub-claims correctly marked DESCOPED / off-path under the alg-closed pivot; retained as upstream-PR / auditable record. Stacks tag corrections (035U/04QM/0BUG/02KH/030K) and verbatim `% SOURCE QUOTE` blocks are consistent with the bundled `.tex` sources. Pointer chapter; no live prover obligation.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.
  (Scheme-level `ext_of_eqOnOpen` form closed; consumed by the RigidityKbar C.2 chain.)

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.
  (All blocks closed by projection from the Albanese witness; the genus-0 descent to `k` via `Flat.epi_of_flat_of_surjective` is consistently described.)

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:nonempty_jacobianWitness` is the project's single explicit foundational gap (documented); genus-0 (`def:genusZeroWitness`) and positive-genus (`def:positiveGenusWitness`) arms are sorry-scaffolds with detailed, internally-consistent recipes. The genus-0 arm correctly routes through `thm:rigidity_over_kbar` over `k̄` + faithfully-flat descent. No correctness issue; depth is adequate for the scaffolds' role.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **KDM live route is sound and prover-ready.** The (FT.1)–(FT.3) route in the proof of `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` is mathematically correct: (FT.1) push to `K=Frac B` via injective `IsFractionRing` + `map_D` functoriality; (FT.2) transcendence-by-contradiction through the perfect-field tower `k→F=RatFunc k→K`, using `FormallySmooth.of_perfectField` ⟹ `Subsingleton (H1Cotangent F K)` ⟹ (via `H1Cotangent.exact_δ_mapBaseChange`) `mapBaseChange` injective ⟹ (via `FaithfullyFlat.one_tmul_eq_zero_iff`) `D_F b = 0`, contradicting (FT.3); (FT.3) base case `D_{RatFunc k} X ≠ 0` via `isLocalizedModule_map` + `IsLocalizedModule.eq_zero_iff` + `polynomialEquiv_D`, then the algebraic-closure closer via `IsAlgClosed.algebraMap_bijective_of_isIntegral`. Every named lemma is used in the correct role; all are corroborated as `[verified by compilation, b80f227]` by the 8 `example` blocks in `analogies/ftthree-kernel-iter154.md` (which I inspected). The corrected joint hypotheses `[IsAlgClosed k] + [IsDomain B]` are correctly justified against the two documented counterexamples (k×k; ℚ(√2)/ℚ).
  - **Statement-block `\uses` over-declaration (SOON, not must-fix).** The KDM *statement* block still carries `\uses{lem:chart_algebra_isPushout_of_affine_product, lem:KaehlerDifferential_constants_in_chart_of_proper_curve}`, while (a) neither lemma appears in the KDM *statement* (which is purely `D b = 0 ⇒ b ∈ range(algebraMap k B)`), and (b) the live proof depends on no blueprint label — the proof block correctly carries no `\uses`. See Cross-chapter / dependency-hygiene note below for the impact analysis and recommended fix.
  - The (p1)/(p2)/(C.a)–(C.c) demotions to "Historical record (NOT on the critical path)" are unambiguous and do not bleed into the live route; chapter is internally consistent.

## Cross-chapter notes

- **Dependency-graph hygiene — KDM statement-block `\uses` over-declaration (directive's central question).**
  - *Is it a must-fix?* **No — soon-severity, recommend writer fix, does NOT block the prover lane.** Rationale:
    1. Both labels **exist** (`lem:chart_algebra_isPushout_of_affine_product`, `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`), so this is an *over-declaration to real labels*, **not** a broken `\uses` edge. `blueprint-doctor` will not flag it as broken.
    2. It does **not** mis-propagate `\leanok`: `\leanok` is set per-declaration by the deterministic `sync_leanok` pass from actual Lean sorry-analysis, not propagated through blueprint `\uses`. The over-declaration cannot move a `\leanok` marker.
    3. Its only real effect is spurious edges in the plasTeX dependency graph (KDM → those two lemmas) and the resulting "proved/green" coloring: a node colours green only once all its `\uses` deps are green, so the spurious edge would keep KDM (and its downstream `df_zero` → `ext_of_diff_zero` chain) from ever showing green even after the bodies close. But KDM's body is itself still `sorry`, and the whole downstream chain plus `rigidity_over_kbar` are gated on that sorry this iter, so there is **no practical gating effect in iter-154**.
    4. The proof prose is unambiguous about the live FT route and explicitly disclaims the historical-record dependencies, so a prover reading the chapter will **not** be misled into using the two lemmas.
  - *Recommended fix (next writer round, low priority):* prune the KDM statement-block `\uses` to match the (already-empty) proof-block `\uses`. The statement uses no lemma; the live proof uses no blueprint label.
  - *Is `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` orphaned?* **Not currently** — the spurious KDM statement-block edge is its only inbound edge and keeps it connected. It is *orphaned-in-waiting*: `lem:chart_algebra_df_zero_factors_through_constant_on_chart` uses `constants_integral_over_base_field` (NOT `…_constants_in_chart_…`), and the live KDM route uses neither, so once the over-declaration is pruned this lemma has **no live consumer** and `blueprint-doctor` will flag it as an orphan chapter/label. Recommendation: when pruning, the writer should also demote `…_constants_in_chart_of_proper_curve` to a clearly-marked "retained / off-path record" (mirroring the S3.* descope language) — it remains tied only to the demoted (p1) char-p historical route.
- No broken `\ref`/`\uses`/`\cref` were introduced by the rewrite: the live route cites only Mathlib names; the historical-record prose's `\cref`s to `lem:chart_algebra_isPushout_of_affine_product` and `…_constants_in_chart_…` resolve to existing labels; `df_zero`'s proof-`\uses` of `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` resolves to the real label in `Cohomology_MayerVietoris.tex`.

## Severity summary

- **must-fix-this-iter**: none.
- **soon**:
  - `RigidityKbar.tex` — KDM statement-block `\uses` over-declaration of `lem:chart_algebra_isPushout_of_affine_product` and `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` (depgraph hygiene; recommend prune + demote the now-consumerless `…_constants_in_chart_…` helper). Non-blocking.
- **informational**:
  - `Cohomology_MayerVietoris.tex` — two carrier typeclasses remain unproduced (disclosed; conditional shipping).

**HARD GATE decision (the single decision the directive requested):**
`RigidityKbar.tex` **CLEARS the HARD GATE** for a KDM prover lane on
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean` this iter. The chapter is
`complete: true` and `correct: true`; the KDM live (FT.1)–(FT.3) route is
mathematically sound, uses every named Mathlib lemma in the right role, and is
corroborated by compilation in `analogies/ftthree-kernel-iter154.md`. The only
finding (statement-block `\uses` over-declaration) is soon-severity hygiene,
not a must-fix, and does not corrupt the proof recipe or the prover's task.

Overall verdict: Blueprint is healthy across all 12 chapters; `RigidityKbar.tex`'s rewritten KDM block is correct and prover-ready, so the KDM lane on `ChartAlgebra.lean` is cleared to dispatch, with one soon-severity depgraph-hygiene cleanup (prune the KDM statement-block `\uses`; demote the consequently-orphaned `constants_in_chart` helper).
