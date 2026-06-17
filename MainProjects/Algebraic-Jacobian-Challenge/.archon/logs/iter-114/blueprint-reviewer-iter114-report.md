# Blueprint Review Report

## Slug
iter114

## Iteration
114

## Top-level summaries

### Incomplete parts

- `Differentials.tex` / proof of `\thm:relative_kaehler_isSheaf` (lines 28–53): The prose enacts Route (a) via `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover` (refinement-cofinality + Step 2 affine identification + Step 3 globalisation, terminating in an explicit `[gap]` paragraph). The iter-113 Lean refactor (`Differentials.lean:209–234`) now closes helper #1 by *delegating* to a **new** unique-gluing sub-helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` (`Differentials.lean:168–175`), which is the actual prover lane target this iter (L175 `sorry`). **The blueprint chapter does not describe the unique-gluing recipe at all** — neither the load-bearing mathematical content (universal derivation + structure-sheaf gluing on `iSup U` + uniqueness via `KaehlerDifferential.span_range_derivation`) nor a `\lean{...}` hint pointing at the new helper. A prover working from the chapter has no blueprint to formalize against.

- `Differentials.tex` / new sub-helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`: no declaration block (no `\lemma{}` + `\lean{}` pair) exists in the chapter for this target. This is the load-bearing claim of the iter-113 reformulation and the iter-114 prover target; not having it in the blueprint is the single most consequential gap.

### Proofs lacking detail

- `Differentials.tex` / `\thm:relative_kaehler_isSheaf` (Step 3, L49–51): the chapter explicitly admits a `[gap]` ("No direct off-the-shelf `sheaf-on-affine-basis-of-a-Scheme ⇒ sheaf` theorem is currently in Mathlib for `Scheme.PresheafOfModules`") and asks the prover to construct the refinement-cofinality argument *or* the alternative gluing construction. After iter-113 this gap is no longer the route in Lean; the prover lane has shifted to the unique-gluing pivot, so the Route (a) gap-prose is now mathematically *correct but moot*. It should be replaced by an analogous prose for the unique-gluing recipe.

- `Differentials.tex` / `\thm:serre_duality_genus` (L241–251): proof is a one-line gloss ("Both sides equal the genus … dimension-one case of Serre duality"). Named-deferred per directive (L1039 `sorry`); the proof block is not required to expand, but the **hypothesis-strength mismatch** between Lean and prose is unresolved (see Cross-chapter notes).

### Lean difficulty quality

- `Differentials.tex` / `\thm:smooth_iff_locally_free_omega` (L189–194), `\cor:cotangent_at_section` (L213–218), and `\thm:serre_duality_genus` (L241–251): each is preceded by a `% NOTE (iter-112 review)` block (L183–188, L209–212, L233–240) claiming the current Lean signature is broken (uses `Smooth f` with free `n`, or `H^0 = H^0`). **These NOTEs are stale.** Verified against `Differentials.lean`:
  - L873–880 `smooth_iff_locally_free_omega` already uses `IsSmoothOfRelativeDimension n f ↔ …` (correct).
  - L889–897 `cotangent_at_section` already uses `IsSmoothOfRelativeDimension n f` (correct).
  - L1033–1039 `serre_duality_genus` already uses `HModule k _ 0 = HModule k _ 1` (correct `H^0 = H^1` form).
  All three "refactor lane required before proof work" warnings are misleading — the refactor has already landed. A prover reading the chapter would block on a fabricated signature mismatch. Cosmetic but actively harmful.

- `Differentials.tex` / `\thm:cotangent_exact_sequence` (L165–179): blueprint asserts "exact sequence" of `α` and `β` as named; the Lean (`Differentials.lean:855–864`) returns an *existential* `∃ α β h, …` rather than the equational form. This is a formulation choice (no mathematical disagreement) but worth surfacing because a prover comparing the two will see structural divergence at the `\lean{...}` target.

### Multi-route coverage

- Single load-bearing route this iter (per directive). PASS — Phase B unique-gluing closure on `Differentials.lean` is the only active prover route; coverage is in `Differentials.tex`, but with the load-bearing gap above (the unique-gluing recipe is not in the chapter).

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All three protected declarations (`def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) have proofs that delegate cleanly to `thm:nonempty_jacobianWitness` (Jacobian.tex) and `def:IsAlbanese` (Jacobian.tex). Cross-refs verify.
  - "Implementation route via the Albanese framework" section (L61–66) clearly explains the framing decision. No issues.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Comprehensive coverage of the Mayer–Vietoris LES + Čech-acyclicity machinery + basic-open cover infrastructure + Step 2 transport status. Every theorem block has a `\lean{...}` hint pointing at a real declaration name.
  - Status remark at L1194–1199 lists the named-deferred surface as of iter-112: 7 entries on the surface + 1 budget-deferral at `BasicOpenCech.lean:1846`. This is accurate per `archon-protected.yaml`-adjacent gap accounting (modulo line numbers — see informational).
  - **Informational** — iter-112 reviewer's "stale line-ref" item: status paragraph L1194–1208 cites `BasicOpenCech.lean:1120,1212,1536,1564,1754,1846`; these may drift across iters. Cosmetic.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single theorem (`thm:HasSheafCompose_forget`), declaration + proof both `\leanok`, references a real instance. Solid.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Two typeclass instances + one definition, all referencing real Lean declarations. Phase A steps 2–4 are cleanly described.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 28+ declaration/lemma blocks all with `\lean{...}` hints and consistent `\uses{...}` chains. Phase A step 5 is fully covered; Phase A step 6 producer chain is in place.
  - Čech-acyclicity carrier predicates and producer instances are correctly typed against the Lean.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **Missing — Route divergence (iter-113):** the chapter prose for `\thm:relative_kaehler_isSheaf` (proof L28–L53) describes Route (a) via `isSheaf_iff_isSheafOpensLeCover`. The Lean now goes through `IsSheafUniqueGluing` (`Differentials.lean:168–234`). The new sub-helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` (the load-bearing math content) has **no declaration block and no `\lean{...}` hint** in the chapter. This is the must-fix gap for the iter-114 prover lane on L175.
  - **Wrong — three stale `% NOTE (iter-112 review)` blocks:** L183–188 (claims `smooth_iff_locally_free_omega` uses `Smooth f` + free `n`), L209–212 (claims `cotangent_at_section` same), L233–240 (claims `serre_duality_genus` writes `HModule k _ 0 = HModule k _ 0`). All three Lean signatures have since been refactored to the correct dimension-graded/`H^1`-paired forms (verified against `Differentials.lean:873, 889, 1033`). The NOTE blocks are misleading and should be removed.
  - **Wrong — Serre duality hypothesis mismatch:** `\thm:serre_duality_genus` prose says "smooth proper geometrically irreducible curve over a field $k$" + dimension-1 implicit, but `Differentials.lean:1033–1035` has `[IsIntegral C.left] [IsProper C.hom] (hsmooth : Smooth C.hom)` — dimension-free, integral rather than geometrically irreducible. Per directive, resolution is to relax prose to match Lean (since `IsGeometricallyIntegral` is a `[gap]` in Mathlib b80f227). Outstanding.
  - **Observation — stale Lean line-ref:** L51 references "Differentials.lean, lines~113--122" for the Lean stub structure of `relativeDifferentialsPresheaf_isSheaf`; the iter-112 Bar B scaffolding now occupies different line ranges (the new structure starts at `Differentials.lean:97–125+` for the scaffolding doc-comment, with main theorem body at `:277–284`). Cosmetic.
  - **Observation — quasi-coherence claim:** `\def:relative_kaehler_sheaf` (L56–62) asserts the sheaf "is quasi-coherent"; `Differentials.lean:290–291` packages it only as `X.Modules` without an explicit `IsQuasicoherent` data field. Treating as "morally QC" prose is acceptable; flagging because a future prover reading "QC" may look for the typeclass.
  - **Observation — `cotangent_exact_sequence` existential form:** L165–179 prose presents the exact-sequence as a structural object with named `α, β`; `Differentials.lean:855–864` returns `∃ α β h, …`. Formulation difference, not a mathematical disagreement.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Genus definition is anchored to `Module.finrank k (HModule k (toModuleKSheaf C) 1)`. Section "Mathlib gap" honestly accounts for what still requires upstream work. Section "User authorisation of `noncomputable`" records the user-approved signature delta. Clean.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All four protected Jacobian instances (`grpObj`, `smoothOfRelativeDimension_genus`, `isProper`, `geometricallyIrreducible`) are routed cleanly through `thm:nonempty_jacobianWitness` and `def:IsAlbanese`. The existence theorem (L100–117) records the bundled hypothesis for both the higher-genus and the genus-0 rigidity content.
  - "Implementation route" L119–127 explains the framing transparently.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase C0 step is fully described; the `instIsMonoidal_W` load-bearing transition (post-C1) is disclosed honestly at L64–72.
  - All five Lean instances (`tensorObj`, `instMonoidalCategoryPresheaf`, `instMonoidalCategoryStruct`, `instMonoidalCategory`, `instBraidedCategoryPresheaf`/`instBraidedCategory`, `instIsMonoidal_W`) are listed at L143–149 with correct status.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\def:Pic_functor` and `\thm:Pic_representable` both present; the latter explicitly deferred under Phase C3 exit policy with full reasoning at L37–47.
  - "Post-C1 dependency note" L77–88 cleanly traces the pull-back and monoidality-of-sheafification chains. References to `Picard/LineBundle.lean:82,93` and `Modules/Monoidal.lean:166` may drift across iters but are still accurate at iter-114 entry.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Definition + forget-compare iso + étale-sheafified Picard functor are all in place with closure status. The pre-iter-109 universe-lift bridging gymnastic is explained as historical.
  - Directive's "Known issues" mentioned "scaffolded" wording at L31–L41 as stale; on inspection the current chapter at L29–L45 talks about the forget-compare definition and proof, which are now closed in Lean. The stale-wording flag may itself be obsolete (no occurrence of "scaffolded" in the current chapter text). If iter-112 already de-staled this, no action needed.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Post-C1 refactor cleanly stated. `LineBundle X := (Skeleton X.Modules)ˣ` matches Lean. The split pair of named-deferred Mathlib gaps (`pullback_tensorObj` µ-iso, `pullback_oneIso` ε-iso) is documented at L120–156 with the collapse condition.
  - Pull-back functoriality lemmas (`pullback_id`, `pullback_comp`) are recorded as closed.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Self-contained Mumford-§4 rigidity helper. Hypotheses, proof sketch, and Mathlib ingredients are all enumerated. Single theorem (`GrpObj.eq_of_eqOnOpen`) referenced by Jacobian.tex / AbelJacobi.tex's uniqueness path.

## Cross-chapter notes

- `Differentials.tex` and `Differentials.lean` (load-bearing for iter-114): the iter-113 Bar-B reformulation introduced a new top-level Lean helper (`relativeDifferentialsPresheaf_isSheafUniqueGluing_type`) carrying the residual mathematical content of the sheaf proof, but the corresponding declaration block (with `\lean{...}` hint + proof recipe) is absent from the chapter. The prover lane target L175 has no blueprint coverage.

- `Differentials.tex` ↔ `Genus.tex` Serre-duality cross-link: the Genus chapter L36–42 lists `g(C) = dim_k H^0(C, Ω^1_{C/k})` as a Serre-duality reformulation that requires Phase B and Serre duality. The Lean form of this equality (`serre_duality_genus`) is in Differentials.lean as `Module.rank k (H^0 of Ω) = Module.rank k (H^1 of O_C)`, which is *both directions of* the genus equality combined. The chapter cross-links are consistent.

- `Picard_Functor.tex` and `Picard_FunctorAb.tex` references to `Picard/LineBundle.lean:82,93` and `Modules/Monoidal.lean:166`: line numbers may drift; current iter-114 entries are accurate per the iter-112 reviewer audit but not re-verified by me this iter. (Informational.)

## Strategy-modifying findings (if any)

None. The iter-113 → iter-114 unique-gluing pivot for the Differentials sheaf proof is consistent with the strategy snapshot; it is a *blueprint-writer* task, not a *strategy-writer* task.

## Severity summary

- **must-fix-this-iter**:
  - `Differentials.tex`: complete = partial, correct = partial (per Per-chapter §). Per the HARD GATE, this blocks any prover dispatch on `Differentials.lean` this iter. The mandatory dispatches are:
    1. Add a top-level declaration block (`\lemma{}` or `\theorem{}` + `\lean{relativeDifferentialsPresheaf_isSheafUniqueGluing_type}` + `\uses{...}`) for the new sub-helper, including the unique-gluing recipe prose (universal derivation + structure-sheaf gluing on `iSup U` + uniqueness via `KaehlerDifferential.span_range_derivation`).
    2. Either rewrite the proof of `\thm:relative_kaehler_isSheaf` to match the iter-113 Lean (Step 1 forgetful reduction + delegate to the new sub-helper via `isSheaf_of_isSheafUniqueGluing_types` + `IsSheaf.isSheafOpensLeCover`), or retain Route (a) as historical and append a "unique-gluing pivot (iter-113)" subsection.
    3. Remove the three stale `% NOTE (iter-112 review)` blocks at L183–188, L209–212, L233–240.
    4. Relax `\thm:serre_duality_genus` prose to match the Lean hypothesis form (`IsIntegral` + `IsProper` + `Smooth`, no dimension-1 assertion, no "geometrically irreducible" assertion), per directive's stated strategy of relaxing prose since `IsGeometricallyIntegral` is a Mathlib gap.
  - **Per directive**, the iter-114 plan-phase will dispatch a blueprint-writer for `Differentials.tex` regardless of this verdict; the four items above should be on that writer's agenda.

- **soon**:
  - `Differentials.tex` L51 stale Lean line-ref ("Differentials.lean, lines~113--122") — fix opportunistically when the writer is in the file.
  - `Differentials.tex` quasi-coherence claim in `\def:relative_kaehler_sheaf` — either add the QC typeclass to the Lean later, or soften the prose to "morally quasi-coherent".
  - `Differentials.tex` `\thm:cotangent_exact_sequence` formulation: align prose with the existential Lean form, or vice versa.

- **informational**:
  - `Cohomology_MayerVietoris.tex` line-ref drift (carried over from iter-112 known-issues).
  - `Picard_FunctorAb.tex` "scaffolded" wording check: no occurrence found in the current text; the iter-112 known-issue flag may itself be obsolete.

**Overall verdict**: the single load-bearing chapter for the iter-114 prover lane (`Differentials.tex`) is `partial` on both axes — the new unique-gluing sub-helper has no blueprint declaration block, and three stale NOTE blocks actively mislead. Every other chapter is complete + correct. The HARD GATE therefore defers prover dispatches on `Differentials.lean` until the pre-committed blueprint-writer dispatch lands the fixes; the writer's agenda is the four must-fix items enumerated above.
