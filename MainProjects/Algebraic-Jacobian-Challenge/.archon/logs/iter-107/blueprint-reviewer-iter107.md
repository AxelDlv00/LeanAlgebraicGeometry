# Blueprint Review Report

## Slug
iter107

## Iteration
107

## Top-level summaries

### Incomplete parts

- `Differentials.tex` / `lem:sheafOfModules_exact_iff_stalkwise` (line 105–108): no `\leanok` and no `\lean{...}` hint; the lemma is a "mathematical statement only; not formalised". Acknowledged Mathlib-gap deferral (no `SheafOfModules.stalkFunctor` available, alternative section-wise route via `ShortComplex.exact_map_iff_of_faithful` blocked on `PreservesLeftHomologyOf`/`PreservesRightHomologyOf` instances also absent). Per directive: do not flag as must-fix-this-iter.
- `Differentials.tex` / `lem:sheafOfModules_epi_of_epi_presheaf` (line 110–114): no `\leanok`; named `SheafOfModules.epi_of_epi_presheaf`. Mathlib-shape lemma; honest deferral.
- `Differentials.tex` / `lem:derivation_postcomp_comp` (line 116–124): no `\leanok`; named `PresheafOfModules.Derivation.postcomp_comp`. Mathlib-shape lemma about `Derivation'` missing from upstream; honest deferral.
- All three are paused-upstream-of-Mathlib items and are correctly off-route this iter (Phase B is OFF-LIMITS).

### Proofs lacking detail

- `Cohomology_MayerVietoris.tex` / `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (line 1159–1171): the 4-step proof sketch describes the math accurately (local-to-global reduction, identification of the localized complex, extra-degeneracy contraction, globalization), but **Step 2** ("Identification of the localized complex") is the iter-107 prover target (`h_loc_exact` at `BasicOpenCech.lean:L1802`) and the prose collapses this to a one-sentence "naturally isomorphic" claim. The 4-piece analogist recipe (per-coord `IsAffineOpen.isLocalization_of_eq_basicOpen` + `IsLocalizedModule.pi` + `IsLocalizedModule.iso` + `Function.Exact.iff_of_ladder_linearEquiv`) is in `analogies/finite-product-localisation-and-cech-r-linearity.md`, not in the blueprint. The Lean-implementation remark (line 1178–1180) names four ingredients but does not decompose Step 2. **Verdict: adequate for this iter** because the analogist's recipe is in the analogies file (cited by the iter-107 directive), and the prover is expected to execute it inline. **Suggestion for later iters:** promote the recipe summary into the chapter's Lean-implementation remark so future readers can find the formal route without crossing into `analogies/`.
- `Cohomology_MayerVietoris.tex` / `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` Step 1 (line 1164): "exactness of a map of $\mathcal O_X(U)$-modules is a local property at the cover" is the local-to-global statement, but the name `exact_of_localized_span` is not surfaced. Minor — soon-tier suggestion.

### Lean difficulty quality

- No findings. All `\lean{...}` hints in actively-used routes name well-formed targets matching the corresponding `.lean` files. The crucial iter-107 target `AlgebraicGeometry.Scheme.basicOpenCover_isCechAcyclicCover_toModuleKSheaf` exists in `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (verified by grep) and `h_loc_exact` is the active obligation inside its proof.

### Multi-route coverage

- **Route "h_loc_exact via analogist 4-step recipe at L1802"**: **PASS** — covered in `Cohomology_MayerVietoris.tex` § `basic_open_acyclicity`. The chapter's prose anchors the global proof shape; the analogist recipe lives in `analogies/finite-product-localisation-and-cech-r-linearity.md`. Per directive this is the single primary route this iter.

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single theorem (`thm:HasSheafCompose_forget`), clean prose, both statement and proof blocks carry `\leanok`. Phase~A step~1 fully documented.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three blocks (sheafification, $\Ext$, `Scheme.toAbSheaf`). All carry `\leanok`. Cross-refs to `chap:Cohomology_SheafCompose` resolve. Phase~A step~2–4 documented.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Large chapter (≈25 named blocks); covers Phase~A step~5 plus the carriers `IsAffineHModuleVanishing`, `IsAffineHModuleHomFinite`, `IsHModuleHomFinite`, `IsCechAcyclicCover`, and the Stein-finiteness producer chain. Iter-103 fix to use `def:Scheme_toModuleKSheaf` (not `thm:`) on line ~474 has landed (verified — the `\uses` in `thm:Scheme_module_finite_globalSections_of_isProper` cites `def:Scheme_kToSection, def:Scheme_algebraSection, def:Scheme_toModuleKSheaf`, all real labels).

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Iter-107 focus chapter. Mayer–Vietoris LES + Čech-acyclicity pipeline both covered (≈40 named blocks). All `\uses{...}` references resolve to real labels (spot-checked: `def:Scheme_HModule_prime_top_sourceIso`, `def:Abelian_Ext_chgUnivLinearEquiv`, `def:Scheme_HasAffineCechAcyclicCover`).
  - `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (line 1151–1171) is the L1802 anchor for the iter-107 prover. Proof sketch is mathematically correct and decomposes into 4 conceptual steps; Step 2 (local identification) is the in-scope work this iter and is intentionally light on Lean-implementation specifics, relying on the analogist recipe in `analogies/finite-product-localisation-and-cech-r-linearity.md`. See "Proofs lacking detail" for a soft suggestion to inline a recipe summary in a future iter.
  - The chapter's "Lean implementation" remark (line 1178–1180) correctly cites the four ingredients (local-to-global, structure-sheaf-as-localization, exactness preservation under localization, extra-degeneracy contraction).
  - The `\uses{...}` chain on `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (line 1155) is dense but consistent (`def:Scheme_basicOpenCover`, `def:Scheme_IsCechAcyclicCover`, four intersection helpers, `thm:Scheme_cechCohomology_subsingleton_of_cechCochain_exactAt`, `def:Scheme_splitEpi_pi_lift_of_injective`).
  - One micro-observation (informational): the chapter has `lem:Scheme_AffineCoverMVSquare_corners` (line 444–448) which is **stated without a `\leanok` and without a `\lean{...}` hint** (it's an "umbrella" lemma followed by four `\leanok`-carrying split lemmas with `\lean{...}` hints). This is fine as written — the umbrella lemma is informal commentary and the actual four split lemmas formalize it.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Three auxiliary lemmas (`lem:sheafOfModules_exact_iff_stalkwise`, `lem:sheafOfModules_epi_of_epi_presheaf`, `lem:derivation_postcomp_comp`) lack `\leanok`. Honest Mathlib-gap deferrals (verified: blocked on `SheafOfModules.stalkFunctor`, `PreservesLeftHomologyOf`/`PreservesRightHomologyOf` instances, and a Mathlib `Derivation'` postcomp lemma respectively).
  - Proof of `lem:cotangent_exact_structure` (line 86–96) contains a long `% NOTE (iter-086+iter-087)` block documenting the upstream block. The status note is mathematically correct and matches the directive's "h_exact policy" framing.
  - All `\uses{...}` resolve (`def:cotangent_alpha`, `def:cotangent_beta`, `lem:sheafOfModules_epi_of_epi_presheaf`, `lem:sheafOfModules_exact_iff_stalkwise`, `lem:derivation_postcomp_comp`, `lem:cotangent_exact_seq_beta_hη` — all real labels in this chapter).
  - **Severity classification**: per directive's "Known issues", Phase~B is OFF-LIMITS this iter and the `complete: partial` verdict has no operational impact. Treated as `soon`/`informational` per directive instruction (see § Severity summary).

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single `def:genus` block with substantive Lean-implementation remark. `\uses{def:Scheme_HModule, def:Scheme_toModuleKSheaf}` — both labels real (in StructureSheafModuleK).
  - Sections "Mathlib gap" and "User authorisation of noncomputable" honestly disclose the open Serre-finiteness obligation and the `noncomputable` modifier authorization.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase~C0 chapter. Two named blocks (`def:Modules_tensorObj`, `thm:Modules_MonoidalCategory`) plus an informal `def:Modules_Invertible` (no `\leanok`, no `\lean{...}` hint — this is by design, mirroring the future Phase~C1 refactor).
  - "Status of W.IsMonoidal and the stalks-level argument" remark (line 59–60) is the honest Mathlib-gap disclosure; correctly notes that the gap-fill does not block downstream consumers.
  - No `\lean{...}` hint targets `instIsMonoidal_W` directly, matching the directive's note that this is the C0 Mathlib gap.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**:
  - "Status note (Phase C1)" section (line 17–27) is the disclosed iter-105 Lean-state note: the current Lean body uses `CommRing.Pic(Γ(X, ⊤))` rather than the geometric definition. The mismatch is correctly propagated forward (notes in Picard_Functor.tex and the `W.IsMonoidal` status in Modules_Monoidal.tex). Per directive: not must-fix-this-iter.
  - Two `% NOTE:` comments above `thm:Scheme_Pic_commGroup` and `thm:Scheme_Pic_pullback` indicate that the iter-104 sync_leanok markers are against the approximation; this is the correct shape per blueprint marker vocabulary.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The representability theorem `thm:Pic_representable` carries `\leanok` on the statement (file-level: signature exists and compiles) but its proof block intentionally remains an open sorry (multi-iteration Mathlib-gap task; documented decomposition into C0–C3).
  - "Forward-compatibility note (LineBundle approximation)" (line 75–77) honestly disclosed.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three blocks (`def:Pic_functorAb`, `def:PicardFunctorAb_forgetCompare`, `def:PicardFunctorAb_etaleSheafified`) plus one simp-lemma (`lem:PicardFunctorAb_forget_obj`). All carry `\leanok`. Universe-pinning gymnastics for étale sheafification documented.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Albanese-framework route documented. All four protected declarations (`Jacobian`, `instGrpObj`, `smoothOfRelativeDimension_genus`, `instIsProper`, `instGeometricallyIrreducible`) carry `\leanok`. The bundled `thm:nonempty_jacobianWitness` correctly absorbs Pic-scheme representability + symmetric-power quotients + genus-0 rigidity (`Hom(ℙ¹, A) = A(k)`) into a single existence hypothesis.
  - "Implementation route via the Albanese functor" section closes with a clean Layer~I/Layer~II decomposition. Genus-0/1/≥2 sanity checks present.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Standalone helper, ground-truth provable from current Mathlib. Single theorem `thm:GrpObj_eq_of_eqOnOpen` with a 5-bullet Mathlib-ingredients list. Proof shape (equaliser closedness + reduced + irreducible) is correct.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three blocks (`def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`). All carry `\leanok`. The Albanese-framework reduction (line 53–58) is the same shape used in Jacobian.tex.

## Cross-chapter notes

- Cross-chapter dependency chain verified clean for the iter-107 critical path:
  - `Cohomology_MayerVietoris.tex` → `Cohomology_StructureSheafModuleK.tex` (consumes `def:Scheme_HModule`, `def:Scheme_HModule_prime`, `def:Scheme_toModuleKSheaf`, `def:Scheme_IsCechAcyclicCover`) — all labels real.
  - `Genus.tex` → `Cohomology_StructureSheafModuleK.tex` — clean.
  - `Jacobian.tex` → `Genus.tex` (`def:genus`) + `Differentials.tex` (indirectly, via `cor:cotangent_at_section` — not invoked this iter as Phase~B is OFF-LIMITS) — clean.
- The analogies file `analogies/finite-product-localisation-and-cech-r-linearity.md` is **not currently cited** by `Cohomology_MayerVietoris.tex`. The iter-107 directive references it; the chapter's Lean-implementation remark on line 1178–1180 names the four ingredients but does not cite the analogies path. **Soon-tier suggestion**: add a one-line pointer in the Čech-acyclicity remark naming `analogies/finite-product-localisation-and-cech-r-linearity.md` for the Lean recipe details. This is *informational only* — the prover this iter has the directive's pointer.
- The `def:Modules_Invertible` block in `Modules_Monoidal.tex` (line 65–68) does not carry a `\lean{...}` hint. This is correct — the formalized substitute is `MonoidalCategory.Invertible` applied to `X.Modules`, which is Mathlib's name and lives downstream of the (still-open) Phase~C1 refactor.

## Strategy-modifying findings (if any)

None this iter. The single primary route ("h_loc_exact via 4-step analogist recipe at L1802") is well-covered by the existing blueprint plus analogies file; no strategy modification needed.

## Severity summary

- **must-fix-this-iter**: none.
  - Per the directive's "Known issues" section, the three auxiliary lemmas in `Differentials.tex` without `\leanok` (`lem:sheafOfModules_exact_iff_stalkwise`, `lem:sheafOfModules_epi_of_epi_presheaf`, `lem:derivation_postcomp_comp`) are honest Mathlib-gap deferrals, Phase~B is OFF-LIMITS this iter, and the directive explicitly says: "Do not flag this as must-fix-this-iter unless you find a new structural issue." No new structural issue found. The `complete: partial` verdict on `Differentials.tex` carries no operational impact this iter because no prover is dispatched against `Differentials.lean`. Dispatching a blueprint-writer cannot close the gap (the gap is upstream of Mathlib, not a missing prose problem).
  - The blueprint-gate's per-file rule would normally classify any `partial` chapter as a blueprint-writer trigger, but the directive's local instruction overrides per CLAUDE.md priority rule ("local takes precedence"). The plan agent is encouraged to confirm this reading on the next mandatory-dispatch cycle.
- **soon**:
  - `Cohomology_MayerVietoris.tex` § `basic_open_acyclicity` (line 1159–1171): Step 2 of the proof sketch (the iter-107 prover's `h_loc_exact` target) could be sharpened by (a) explicitly naming `exact_of_localized_span` for the local-to-global step and (b) inlining a one-paragraph summary of the analogist's 4-step recipe (per-coord `IsAffineOpen.isLocalization_of_eq_basicOpen` + `IsLocalizedModule.pi` + `IsLocalizedModule.iso` + `Function.Exact.iff_of_ladder_linearEquiv`). Not blocking this iter — the analogies file carries the recipe and the directive cites it.
  - Add a one-line pointer to `analogies/finite-product-localisation-and-cech-r-linearity.md` in the Čech-acyclicity "Lean implementation" remark.
- **informational**:
  - `lem:Scheme_AffineCoverMVSquare_corners` in MayerVietoris (line 444) is an "umbrella" lemma stated without `\leanok`/`\lean{...}` followed by four split lemmas with full markers — by design.
  - `def:Modules_Invertible` (Modules_Monoidal.tex line 65) is correctly without a Lean hint pending Phase~C1.
  - The `Picard_LineBundle.tex` Lean-state status note (iter-105 disclosure) is the expected shape for the C1 refactor.

**Overall verdict**: Blueprint is in good shape for the iter-107 prover round; the iter-107 critical path (`Cohomology_MayerVietoris.tex` § Čech-acyclicity) is well-covered by prose + analogies file, no must-fix-this-iter findings, no broken `\uses{}`, no strategy-modifying issues.
