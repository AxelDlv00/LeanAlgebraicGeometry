# Blueprint Review Report

## Slug
iter104

## Iteration
104

## Top-level summaries

### Incomplete parts
- `Cohomology_MayerVietoris.tex` / `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`: the proof sketch (Step 1–4, localize/identify/contract/globalize) is the textbook classical argument. It does **not** reflect the Lean-side decomposition that the iter-104/iter-105 cycles actually built: per-summand `cechCofaceMap_summand_family` / `cechCofaceMap_summand_family'` (named family + wrapper), R-linearity transport lemmas `cechCofaceMap_summand_family_R_linear` / `cechCofaceMap_summand_family'_R_linear`, alternating-sum helpers `alternating_sum_pi_smul_aux` / `alternating_sum_pi_smul_aux_sum_comp` / `alternating_zsmul_pi_smul_aux_sum_comp`, and the active target `cechCofaceMap_pi_smul`. Section `\sec:basic_open_acyclicity` is silent on this engine — there is no prose pointing the reader at "Route B via wrapper" or the residual eqToHom-vs-Pi.π identification at coordinate `j'` (Lean L1147). Per the directive these are project-local helpers and do not need `\lean{...}` entries, but the proof-sketch prose should at least mention that R-linearity of the per-summand restriction is the active sub-obligation; right now Step 1 ("Reduction to per-generator local exactness") jumps directly to global exactness without naming the per-coface map at all.
- `Cohomology_MayerVietoris.tex`: there is no section/subsection covering the `cechCofaceMap` API at all — neither a definition block for the alternating-coface differential decomposition, nor a lemma block for R-linearity of the per-summand restriction chain. The chain that the Lean prover is actually attacking is invisible from the blueprint side.

### Proofs lacking detail
- `Cohomology_MayerVietoris.tex` / `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (Step 3 "Contraction by extra degeneracy"): asserts that the augmented Čech complex on `D(f)` admits an extra degeneracy, but does not name (a) the section map being constructed, (b) which simplicial-object API is being used, or (c) how the contraction descends to exactness of the unaugmented complex. A prover reading this cannot reconstruct the decomposition `cechCofaceMap_pi_smul → splitEpi_pi_lift_of_injective → cechCohomology_subsingleton_of_cechCochain_exactAt` from the prose alone.
- `Cohomology_MayerVietoris.tex` / `\thm:Scheme_subsingleton_HModule_of_isCechAcyclicCover_top` (Top-supremum transport): proof sketch is "rewrite supremum to $\top$, transport across whole-space bridge". The `\uses{}` cites `def:Scheme_HModule_eq_HModule_prime_linearEquiv` which is a non-existent label (see Cross-chapter notes). Without naming the bridge correctly, the reader cannot follow the transport.
- `Modules_Monoidal.tex` / `\thm:Modules_MonoidalCategory` (proof): describes the `LocalizedMonoidal` strategy but never explicitly states that `W.IsMonoidal` is the load-bearing hypothesis and that the chapter has chosen NOT to formalize it (it lives only in the `[Status of $W$.IsMonoidal...]` remark on line 59). A prover reading the proof-block sequentially would expect a Lean obligation that, per the deferral, does not exist as a `\lean{...}` block.
- `Cohomology_StructureSheafModuleK.tex` / `\thm:Scheme_subsingleton_HModule_prime_supr_of_isCechAcyclicCover` (line 627–636): cites `def:Scheme_HModule'` which is not a defined label; the proof sketch is one line ("Transport the subsingleton structure along the symmetric form of the comparison isomorphism") and gives no detail on which comparison the hypothesis carries.

### Lean difficulty quality
- `Cohomology_MayerVietoris.tex` / `\thm:Scheme_basicOpenCover_supr_of_span_eq_top` (line 956): hint `\lean{AlgebraicGeometry.Scheme.basicOpenCover_supr_of_span_eq_top}` — the prose says "spans the unit ideal" but does not pin the universe of `s` (subset vs `Set` vs `Finset`), the predicate ("Ideal.span = ⊤" vs "Submodule.span ⊤" vs "Ideal.IsUnit"), or whether the conclusion is `iSup = ⊤` or set-theoretic union. Prover has to guess from the surrounding API.
- `Cohomology_MayerVietoris.tex` / `\def:Scheme_splitEpi_pi_lift_of_injective` (line 1121): hint `\lean{AlgebraicGeometry.Scheme.splitEpi_pi_lift_of_injective}` — prose says "Let $\{M_\alpha\}$ be a family of $k$-modules and $f : B \to A$ injective…the projection admits a section". The signature is ambiguous: the prover has no way from the prose to infer whether `M : A → ModuleCat k`, whether the projection is into `ModuleCat k` or `Type`, or which retraction is used. Lean target needs to either name the projection explicitly (`Pi.lift … ∘ Pi.π`) or give the type expression for the section.
- `Cohomology_MayerVietoris.tex` / `\def:Scheme_HasCechToHModuleIso` (line 812): hint `\lean{AlgebraicGeometry.Scheme.HasCechToHModuleIso}` — the predicate's `\uses` lists `def:Scheme_cechCohomology` and `def:Scheme_HModule_prime` but the statement says "the existence of a $k$-linear comparison isomorphism…in every degree". The carrier as a Prop-class vs structure-class is left implicit; if a prover instantiates the wrong shape, the downstream existence producers will not fire.
- `Differentials.tex` / `\thm:cotangent_exact_sequence` (line 142): hint `\lean{AlgebraicGeometry.Scheme.cotangent_exact_sequence}` — statement gives the three-term exact sequence in prose but does not pin which `ShortComplex`/`LongExact`/short-exact API is the target. Prover guessing from prose alone may produce a structurally different statement than the one expected by `\lem:cotangent_exact_structure`.
- `Cohomology_MayerVietoris.tex` / `\thm:Scheme_HModule_prime_sequenceIso` (line 357) and `\thm:Scheme_HModule_prime_sequence_exact` (line 371): the comparison isomorphism is described componentwise but the formulation as a `LongExact`/`Composable` data shape is not pinned. Prover needs to know whether the target uses `Mathlib.CategoryTheory.Composable` 5-tuple or a hand-rolled tuple.

### Multi-route coverage
- Route "single (Phase A active = `cechCofaceMap_pi_smul` closure)": PASS — the directive states a single strategic route; tactical Route 1 (`Pi.lift_ext`) vs Route 3 (`convert h_wrap_pt using 3`) are tactic choices, not blueprint-level routes. The blueprint chapter contains the surrounding scaffolding but is silent on the specific tactical choice; this is acceptable per the directive's "pure-Lean helpers without `\lean{...}` entries are acceptable" rule.
- Route "Phase C3 representability — (a) FGA-Hilbert vs (b) Sym^g/S_g": PASS — `Picard_Functor.tex` Step C3 (line 43) explicitly names both routes, calls out their Mathlib prerequisites, and defers the choice to step C2. Both routes appear in the blueprint.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All three protected declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) have `\lean{...}` hints matching `archon-protected.yaml`. Proof sketches reduce cleanly to `nonempty_jacobianWitness` + `IsAlbanese.unique`.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - missing — section/subsection on the `cechCofaceMap` per-summand R-linear decomposition (iter-104/iter-105 named family + wrapper helpers `cechCofaceMap_summand_family[']`, R-linearity transport theorems, alternating-sum helpers, and active target `cechCofaceMap_pi_smul`). Directive marks these as project-local helpers without need for `\lean{...}`, but the chapter prose does not surface the decomposition at all — Step 3 of `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` skips straight from "extra degeneracy" to "exact in all positive degrees".
  - wrong — line 779 `\thm:Scheme_subsingleton_HModule_of_isCechAcyclicCover_top` `\uses{... def:Scheme_HModule_eq_HModule_prime_linearEquiv, ...}` references a label that does not exist. The reverse-direction label `def:Scheme_HModule_prime_eq_HModule_linearEquiv` exists (line 644); this is almost certainly a typo for the forward direction.
  - vague — line 1138 `\thm:Scheme_cechCohomology_subsingleton_of_cechCochain_exactAt` proof sketch is one sentence; the actual Lean closure pulls `splitEpi_pi_lift_of_injective` + `IsCechAcyclicCover` machinery and the prose does not preview that.
  - observation — `\def:Scheme_AffineCoverMVSquare_HModule_prime_sequence_curve` (line 533) has `\uses{def:Scheme_toModuleKSheaf}` but `def:Scheme_toModuleKSheaf` is in `Cohomology_StructureSheafModuleK.tex` — cross-chapter dependency, valid but worth confirming once the plastex graph regenerates.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-theorem chapter; statement matches `instHasSheafCompose_forget_CommRing_AddCommGrp`. Proof sketch ("limits-create" composition) is adequate.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three pieces (`HasSheafify`, `HasExt`, `toAbSheaf`) all line up with the corresponding Lean instances. Proof sketches are short but adequate ("instance inferable, only universe pinning"); these are not load-bearing for prover work.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - wrong — line 629 `\thm:Scheme_subsingleton_HModule_prime_supr_of_isCechAcyclicCover` `\uses{def:Scheme_IsCechAcyclicCover, def:Scheme_HModule'}` — the label `def:Scheme_HModule'` does not exist; the correct label is `def:Scheme_HModule_prime` (defined at line 259 of this same file). Broken cross-reference.
  - observation — comprehensive (655 lines) and covers Phase A step 5 plus the Čech scaffolding handoff to `Cohomology_MayerVietoris.tex`; the bulk of the chapter is well-formed.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - observation — `\lem:cotangent_exact_structure` proof block explicitly captures the iter-086+iter-087 deferral of `case h_exact` as "deferred upstream parallel to `instIsMonoidal_W`" with a long `% NOTE` block (lines 93–96). This matches the directive's status note.
  - observation — `\lem:sheafOfModules_exact_iff_stalkwise` (line 105) is labelled "mathematical statement only; not formalised" with no `\lean{...}` hint and a `% NOTE` explaining the absence. Correct framing.
  - vague — `\thm:cotangent_exact_sequence` (line 137) is two sentences and does not pin the target API shape (ShortComplex vs hand-rolled tuple). Prover would benefit from an explicit hint at the expected Lean signature.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Protected declaration `\def:genus` matches `AlgebraicGeometry.genus`. `\noncomputable` authorization is correctly recorded in §2. Three reformulations (Serre duality, $\chi$, topological genus) flagged as future work.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All five protected declarations (`Jacobian`, `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) have `\lean{...}` hints matching `archon-protected.yaml`. The bundled-hypothesis route via `nonempty_jacobianWitness` is documented with the Pic-scheme / Sym^g / rigidity alternatives.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - observation — `\thm:Modules_MonoidalCategory` (line 33) statement and proof both carry `\leanok`. This is correct: only `instIsMonoidal_W` (line 173 in `Modules/Monoidal.lean`) is sorry; `instMonoidalCategory` and `instMonoidalCategoryStruct` are closed via `inferInstanceAs (LocalizedMonoidal …)`.
  - observation — the `[Status of $W$.IsMonoidal …]` remark (line 59) captures the C0 deferral cleanly in prose. No `\lean{...}` entry for `instIsMonoidal_W` itself, which is acceptable per directive guidance (not protected, project-local helper).
  - missing — the chapter does not name the `instIsMonoidal_W` declaration at all, only `W.IsMonoidal` in prose. A prover wanting to attack the upstream Mathlib gap would have to grep the Lean source to discover the name.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - observation — `\thm:Pic_representable` is intentionally left as a deferred sorry; the proof block reduces it to Phase C steps C0–C3 with both routes (FGA-Hilbert and Sym^g/S_g) named. Matches the directive's strategy.
  - observation — "Forward-compatibility note (LineBundle approximation)" subsection (line 75) explicitly acknowledges the iter-106+ LineBundle refactor required before `representable` can be honestly closed. Good gating documentation.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Definition and forget-and-recover compatibility lemmas all match `AlgebraicGeometry.Scheme.PicardFunctorAb*` declarations. The étale-sheafification is correctly framed as definition-only (no representability claim).

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - observation — `\def:Scheme_LineBundle` (line 10) states "an invertible quasi-coherent $\mathcal O_X$-module: a sheaf $L$ of $\mathcal O_X$-modules that is quasi-coherent and locally free of rank $1$". This is the TARGET definition for iter-106+. The current Lean `Scheme.LineBundle` is still the `CommRing.Pic Γ(X,⊤)` approximation per the cross-chapter prose in `Picard_Functor.tex` and `Modules_Monoidal.tex`. The chapter prose does **not** flag this divergence between blueprint-as-target vs Lean-as-approximation — only the downstream chapters do. A reader of this chapter alone would mistakenly think the geometric definition is what Lean carries.
  - observation — `\thm:Scheme_Pic_commGroup` and `\thm:Scheme_Pic_pullback` carry `\leanok` markers, which are accurate for the current approximation-level Lean code, but will need re-validation once the LineBundle refactor lands.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\thm:GrpObj_eq_of_eqOnOpen` matches the Lean declaration. Proof sketch lists every Mathlib ingredient needed and frames the lemma as standalone (no Picard/Jacobian dependency). The "Mathlib ingredients" enumeration is the strongest in the blueprint and a model for other chapters.

## Cross-chapter notes

- `Cohomology_MayerVietoris.tex:779` references `def:Scheme_HModule_eq_HModule_prime_linearEquiv` (does not exist) where the intended target is plausibly `def:Scheme_HModule_prime_eq_HModule_linearEquiv` (defined line 644 of the same file). The directionality reversal — `HModule = HModule_prime` vs `HModule_prime = HModule` — matters because the proof transport runs left-to-right on the type. Either the label is mistyped or the cross-reference points at a bridge that was never defined; resolve by either (a) adding the missing forward-direction definition or (b) fixing the `\uses` to reverse direction.
- `Cohomology_StructureSheafModuleK.tex:629` references `def:Scheme_HModule'` (does not exist) where the intended target is `def:Scheme_HModule_prime` (line 259). Pure typo fix.
- `Cohomology_MayerVietoris.tex` and the iter-104/iter-105 `BasicOpenCech.lean` helpers (`cechCofaceMap_summand_family`, `cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family_R_linear`, `cechCofaceMap_summand_family'_R_linear`, `cechCofaceMap_pi_smul`, `alternating_sum_pi_smul_aux`, `alternating_sum_pi_smul_aux_sum_comp`, `alternating_zsmul_pi_smul_aux_sum_comp`): no `\lean{...}` entries anywhere in the chapter. Per the directive this is acceptable (project-local helpers, not protected), but the *proof sketch* of `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` does not even mention "per-coface R-linearity" or "alternating-sum decomposition" — a prover working from the blueprint alone has no signal that the active sub-obligation is the eqToHom-vs-Pi.π identification at coordinate `j'`. The plan agent should dispatch a blueprint-writer to add at least one paragraph documenting the decomposition into named helpers, even without `\lean{...}` hooks.
- `Modules_Monoidal.tex` describes the C0 strategy in terms of `W.IsMonoidal`, while `Differentials.tex` (line 93) cross-references the C0 deferral as "parallel to `instIsMonoidal_W`". Consistent naming, but a reader of `Modules_Monoidal.tex` cannot immediately identify which Lean declaration is the deferred sorry — the chapter would benefit from a one-line `\texttt{instIsMonoidal_W}` mention in the `[Status of $W$.IsMonoidal...]` remark.
- `Picard_LineBundle.tex` defines `LineBundle` as the geometric "invertible quasi-coherent" target, while `Picard_Functor.tex` §"Forward-compatibility note" and `Modules_Monoidal.tex` line 72 both flag that the current Lean side uses the `CommRing.Pic Γ(X,⊤)` approximation. The forward chapters acknowledge the approximation; `Picard_LineBundle.tex` itself does not. This is a definition/Lean-state mismatch warning that should sit inside `Picard_LineBundle.tex` rather than only in the downstream chapters.

## Strategy-modifying findings (if any)

None. The blueprint is consistent with the strategy at the level of strategic routes (single Phase A target; Phase C0 deferral acknowledged; Phase C3 dual routes both documented). The findings above are all chapter-rewrite or cross-reference fixes, not strategy modifications.

## Severity summary

- **must-fix-this-iter**: 0 findings — no strategy-modifying issues; no route with MISSING coverage.
- **soon**: 4 findings — (1) `Cohomology_MayerVietoris.tex` missing prose documentation of `cechCofaceMap` decomposition + active L1147 obligation; (2) broken cross-ref `def:Scheme_HModule_eq_HModule_prime_linearEquiv` in `Cohomology_MayerVietoris.tex:779`; (3) broken cross-ref `def:Scheme_HModule'` in `Cohomology_StructureSheafModuleK.tex:629`; (4) `Picard_LineBundle.tex` missing forward-compatibility note about Lean-side approximation vs blueprint-target definition.
- **informational**: 5 findings — Lean-target-quality items on `splitEpi_pi_lift_of_injective`, `HasCechToHModuleIso`, `basicOpenCover_supr_of_span_eq_top`, `cotangent_exact_sequence`, and the `HModule_prime_sequenceIso`/`HModule_prime_sequence_exact` API-shape pinning.

Overall verdict: The blueprint covers every chapter the strategy requires and tracks the deferrals (C0, `h_exact`) accurately; the gating issues are two broken `\uses{}` cross-references plus a missing proof-decomposition prose paragraph in `Cohomology_MayerVietoris.tex` describing the iter-104/iter-105 `cechCofaceMap` engine that the prover is actively working on.
