# Blueprint Review Report

## Slug
iter112

## Iteration
112

## Top-level summaries

### Incomplete parts

- (none) Every chapter under `blueprint/src/chapters/` has its strategy-mandated declarations and proof blocks present.

### Proofs lacking detail

- `Differentials.tex` / `thm:smooth_iff_locally_free_omega` (L190–199, Lean L718): The proof cites multiple Mathlib lemmas (`Algebra.IsStandardSmooth.free_kaehlerDifferential`, `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`, `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`, `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`) without `[verified]` tags. Mathematically sound, but the iter-111 writer rewrite did NOT cover this theorem (only `thm:relative_kaehler_isSheaf`), so the Mathlib-name verification debt persists. Soon, not iter-112-blocking (L718 is the heaviest of the three Phase B prover-viable sorries and is scheduled last per STRATEGY.md).
- `Differentials.tex` / `cor:cotangent_at_section` (L209–214, Lean L735): The proof references `SheafOfModules.pullbackObjFreeIso` in `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree` without `[verified]` tagging. Soon (L735 is moderate-cost and scheduled second per the dispatch ordering, not the iter-112 critical target).

### Lean difficulty quality

- (none) Every `\lean{...}` hint in the audited chapters points at an existing or strategy-licensed protected/auxiliary declaration with a well-formed type. Spot-checked: `relativeDifferentialsPresheaf_isSheaf` (Differentials.lean:113→sorry L122), `cotangentExactSeq_structure` (h_exact at L636), `smooth_iff_locally_free_omega` (sorry L718), `cotangent_at_section` (sorry L735), `serre_duality_genus` (sorry L877), `instIsMonoidal_W` (decl L166, sorry L173), `SheafOfModules.pullback_tensorObj` (decl L82, sorry L86), `SheafOfModules.pullback_oneIso` (decl L96, sorry L98), `nonempty_jacobianWitness` (sorry L179), `PicardFunctor.representable` (sorry L181). All targets are well-formulated for prover work.

### Multi-route coverage

Per directive: "Multi-route handling is INTERNAL to one sorry (L122 basis-to-opens descent has Route (a) and Route (b)); both documented in chapter. Otherwise single-route per file."

- Route (a) "refinement-cofinality against `isSheaf_iff_isSheafOpensLeCover`": PASS — covered explicitly in `Differentials.tex` L48–50 with the named Mathlib lemma `[verified]`.
- Route (b) "explicit affine-cover gluing via `AlgebraicGeometry.Modules.tilde`": PASS — covered explicitly in `Differentials.tex` L46 and L50 with the named Mathlib carrier `[verified]`.

The iter-111 writer rewrite explicitly documents BOTH routes for the L122 basis-to-opens descent inside the single `[gap]` callout at L50.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three protected declarations covered (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) with `\leanok` and proof blocks routed through `nonempty_jacobianWitness` per the Albanese-framework exit policy.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - L1198 (Remark `rem:basicOpenCover_step2_status`) enumerates the named-deferred surface as **six entries** — `instIsMonoidal_W`, `cotangentExactSeq_structure.h_exact`, `nonempty_jacobianWitness`, `PicardFunctor.representable`, `SheafOfModules.pullback_tensorObj`, `SheafOfModules.pullback_oneIso`. **MISSING**: `serre_duality_genus` (Differentials.lean L877), which STRATEGY.md added as the 7th named-deferred gap in the iter-110 mathlib-analogist-serre-duality reclassification. The remark explicitly attributes the count to "iter-110" but contradicts iter-110's own reclassification. Should be updated to 7 entries (+ 1 budget-deferral). LOW impact this iter because BasicOpenCech.lean is OFF-LIMITS (Phase A deferred) and no prover dispatch maps to this chapter.
  - Substep numbering (i)–(iv) is now consistent between L1167–1176 (recipe enumeration) and L1196–1198 (status report). Iter-110 finding "substep numbering inconsistency" appears resolved.
  - All other Mayer–Vietoris LES content (sections through `def:Scheme_HModule_prime_sequence`, `thm:Scheme_HModule_prime_sequence_exact`, the cover-totality bridge, the affine-Čech-acyclic-cover carrier infrastructure) is internally consistent and well-detailed.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single short theorem (Phase A step 1) with adequate proof sketch. Fine.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase A steps 2–4 (sheafification, Ext, toAbSheaf) covered with adequate sketches.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase A step 5 (the k-module promotion + H' carrier + algebraic bridges + producer instance for wholespace Hom-finiteness via Stein + the IsAffineHModuleVanishing/IsHModuleHomFinite carriers + Čech-acyclic carrier) is thoroughly developed across the chapter. Cross-refs to MayerVietoris chapter are well-stitched.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **CRITICAL GATE GREEN for iter-112 L122 dispatch**. The iter-111 writer rewrite of `thm:relative_kaehler_isSheaf` proof block (L28–53) is complete: Step 1 (forget-composite reduction), Step 2 (affine-restricted sheaf via `widetilde{Omega_{B/A}}`), Step 3 (globalising) all with **10 Mathlib lemma names tagged `[verified]`** + **1 honest `[gap]`** at L50 explicitly documenting Routes (a) refinement-cofinality and (b) explicit gluing for the basis-to-opens descent.
  - The L877 `serre_duality_genus` theorem statement (L220–230) is present with `\leanok` on the statement and references `def:relative_kaehler_sheaf`. Per directive this is off-limits for prover dispatch (named-gap #7 per iter-110 reclassification).
  - L636 `cotangentExactSeq_structure` h_exact branch (covered in proof body L120) is correctly framed as a named-deferred Mathlib gap parallel to `instIsMonoidal_W`.
  - Three auxiliary `\lean{...}` hints (`SheafOfModules.epi_of_epi_presheaf`, `PresheafOfModules.Derivation.postcomp_comp`, `AlgebraicGeometry.Scheme.cotangentExactSeqBeta_hη`) are well-formed and Mathlib-shape; these are downstream prover helpers, not iter-112 targets.
  - The L718 and L735 proof blocks (smooth_iff_locally_free_omega, cotangent_at_section) cite Mathlib names without `[verified]` tags — flagged under "Proofs lacking detail" above. This does NOT block iter-112 because L122 is the dispatch target; L718/L735 are dispatched later in the chain and benefit from a future writer touch-up.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:genus` covered with the strategy-mandated `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)` body; honest `noncomputable` disclosure and Mathlib-gap framing for the Serre-finiteness theorem.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All five protected declarations (`Jacobian`, `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) covered, routed through the Albanese framework + `nonempty_jacobianWitness` exit policy per iter-107 strategy decision.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Internal references to the `instIsMonoidal_W` named-deferred sorry use plain prose without an explicit line number (good — avoids drift). Sections covering tensor product, monoidal/braided structure (presheaf-side + sheaf-side), and the W.IsMonoidal load-bearing post-C1 disclosure (Remark `rem:W_IsMonoidal_load_bearing`) are coherent with STRATEGY.md.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - References `Modules/Monoidal.lean:166` (declaration line) at L10, L85, L88 instead of `:173` (sorry line, as STRATEGY.md uses). Both lines are factually valid (one is the def, the other is the sorry inside the def's body); this is a presentational drift but not a falsehood — see Cross-chapter notes. Otherwise the chapter coherently documents the C2 post-C1 status, the inherited pair `pullback_tensorObj` + `pullback_oneIso`, and the C3-deferred `PicardFunctor.representable`.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Universe-bump narrative (codomain $\mathrm{AddCommGrpCat.\{u+1\}}$ post-iter-109) is internally consistent at L66 and L73. No L166/L173 references at all — clean.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**:
  - References `Modules/Monoidal.lean:166` (declaration line) at L25 instead of `:173` (sorry line) — same drift pattern as Picard_Functor.tex. Not a falsehood. Otherwise the chapter is detailed and accurate: post-C1 status note, hand-construction over the split named-deferred pair (`thm:SheafOfModules_pullback_tensorObj` + `thm:SheafOfModules_pullback_oneIso`), the load-bearing transitive dependency disclosure, and the pull-back functoriality lemmas all check out.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-theorem chapter with full proof sketch + Mathlib-ingredient list. Statement is provable from current Mathlib per strategy framing.

## Cross-chapter notes

- **Line-ref drift for `instIsMonoidal_W` (informational, flagged iter-111 carry-over)**: STRATEGY.md uses `Modules/Monoidal.lean:173` (sorry line); `Cohomology_MayerVietoris.tex:1198` uses `:173`; `Picard_Functor.tex` (L10, L85, L88) and `Picard_LineBundle.tex:25` use `:166` (declaration line). Both lines are factually valid for the same gap (verified by source: L166 = decl `noncomputable instance instIsMonoidal_W ... := by`, L173 = the `sorry` inside that body). The iter-111 writer dispatches did NOT unify the convention — Picard_Functor.tex and Picard_LineBundle.tex still cite L166. Recommend a single chosen convention (the strategy-authoritative `:173` sorry-line) for cross-chapter consistency; informational severity because each citation is unambiguous in context.

- **`serre_duality_genus` missing from `Cohomology_MayerVietoris.tex` enumerated gap-list**: STRATEGY.md authoritatively lists **7 named Mathlib-gap sorries** (with `serre_duality_genus` at Differentials.lean:877 as gap #7 per iter-110 reclassification). The Remark at `Cohomology_MayerVietoris.tex:1198` enumerates only **6 entries**, omitting `serre_duality_genus`. The remark explicitly attributes its enumeration to "iter-110" but contradicts the iter-110 reclassification itself. Should be updated to 7. See severity note below.

- **Verified roster of 7 named gaps + 1 budget-deferral matches Lean source state**:
  - `Modules/Monoidal.lean:173` — `instIsMonoidal_W` sorry ✓
  - `Differentials.lean:636` — `cotangentExactSeq_structure.h_exact` sorry ✓
  - `Differentials.lean:877` — `serre_duality_genus` sorry ✓
  - `Jacobian.lean:179` — `nonempty_jacobianWitness` sorry ✓
  - `Picard/Functor.lean:181` — `PicardFunctor.representable` sorry ✓
  - `Picard/LineBundle.lean:86` — `SheafOfModules.pullback_tensorObj` sorry (decl at L82) ✓
  - `Picard/LineBundle.lean:98` — `SheafOfModules.pullback_oneIso` sorry (decl at L96) ✓
  - `Cohomology/BasicOpenCech.lean:1846` — budget-deferral ✓

## Strategy-modifying findings (if any)

(none)

## Severity summary

- **must-fix-this-iter**:
  - `Cohomology_MayerVietoris.tex` is `correct: partial` per the no-exceptions rule, due to the stale 6-entry named-gap enumeration at L1198 missing `serre_duality_genus`. **Plan-agent impact**: this finding does NOT block the iter-112 critical L122 dispatch on `Differentials.lean`, because the corresponding chapter (`Differentials.tex`) is `complete: true, correct: true`. The HARD GATE rule per `dispatcher_notes` is file-scoped: a blueprint-writer dispatch on `Cohomology_MayerVietoris.tex` is the correct response, but no prover defers, since BasicOpenCech.lean is OFF-LIMITS this iter anyway (Phase A deferred). The fix is a small remark touch-up updating "six entries" → "seven entries" + adding `serre_duality_genus` to the bullet list at L1198.

- **soon**:
  - `Differentials.tex` / `thm:smooth_iff_locally_free_omega` (L190–199, Lean L718): proof block cites multiple Mathlib lemmas without `[verified]` tags. The iter-111 writer covered only `thm:relative_kaehler_isSheaf`; the L718 proof was NOT touched. Schedule a writer dispatch when L718 becomes the active prover target (per strategy, L718 is dispatched LAST among the three Phase B prover-viable sorries, after L122 and L735 — so this is not iter-112-blocking).
  - `Differentials.tex` / `cor:cotangent_at_section` (L209–214, Lean L735): proof cites `SheafOfModules.pullbackObjFreeIso` in `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree` without verification tag. Schedule a writer touch-up when L735 becomes the active target.

- **informational**:
  - L166-vs-L173 line-reference drift for `instIsMonoidal_W` across `Picard_Functor.tex`, `Picard_LineBundle.tex`, `Cohomology_MayerVietoris.tex` (some cite decl line, some cite sorry line). Both factually valid; choose one convention (recommend STRATEGY's `:173`) for consistency.
  - `Cohomology_MayerVietoris.tex:1198` remark text says "As of iter-110 that named-deferral surface comprises six entries" — temporal staleness in addition to the count error; updating both the count (6→7) and the temporal qualifier ("As of iter-112" or similar) is the cleanest fix.

**Overall verdict**: Iter-112 critical gate is **GREEN for L122 `relativeDifferentialsPresheaf_isSheaf` prover dispatch** — `Differentials.tex` is `complete: true, correct: true` with the iter-111 rewrite of `thm:relative_kaehler_isSheaf` providing all-`[verified]` Mathlib names + one honest `[gap]` documenting Routes (a) and (b); the single `must-fix-this-iter` finding on `Cohomology_MayerVietoris.tex` is a stale gap-count remark in an inactive (Phase A deferred) chapter and does not block any active prover route.
