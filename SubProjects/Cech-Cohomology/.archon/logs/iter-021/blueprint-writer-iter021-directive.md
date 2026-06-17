# Blueprint-writer directive — iter-021

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter;
`% archon:covers` CechAcyclic.lean, FreePresheafComplex.lean, CechBridge.lean, PresheafCech.lean,
HigherDirectImagePresheaf.lean, CechHigherDirectImage.lean).

## Why you are dispatched
The iter-020 prover round landed 18 axiom-clean declarations, but the blueprint now lags the Lean in
three specific ways flagged by lean-vs-blueprint-checkers + a progress-critic CHURNING verdict on the
free-complex route. Your job: bring the chapter back into 1-to-1 alignment AND add the one missing
sub-lemma node that unblocks the churning route. **All declarations named below ALREADY EXIST and are
axiom-clean in the Lean files** (except the new differential-match node and the section-homology
sub-lemmas, which are to-be-built targets you are blueprinting ahead of the prover). Do NOT add
`\leanok` anywhere — that is the deterministic sync phase's job.

You may also write `references/**` if you need to re-open a source; all sources cited below are
already in `references/` (`stacks-cohomology.tex`, `stacks-coherent.tex`, `stacks-schemes.tex`). Do
not fabricate citations — reuse the existing `% SOURCE`/`% SOURCE QUOTE` blocks already in the chapter
where the same source backs the new sub-lemma, and only quote text you have actually read.

---

## TASK A — Free-complex route (FreePresheafComplex.lean): the CHURNING corrective + coverage

### A1 (MUST-FIX, the corrective). Add a new differential-match sub-lemma node.
The named target `cechFreeComplex_quasiIso` has not landed in 3 prover iters. The genuine bottleneck
is NOT the contracting-homotopy identity (already built as `FreeCechEngine.combHomotopy_spec`) but the
**degreewise identification of the evaluated free complex with the engine's constant-coefficient
complex together with the matching of differentials**. Currently this hard step is buried inside the
proof prose of `lem:cech_free_eval_prepend_homotopy`. Promote it to its own lemma so the prover has a
small, ready target.

Insert a new lemma block `lem:cech_free_eval_engine_iso` (place it BETWEEN
`lem:cech_free_eval_sectionwise` and `lem:cech_free_eval_empty`, since the empty/nonempty cases both
consume it). Content:

- **Statement (project notation).** Fix an open `V` with `I₁(V) = {i : V ≤ Uᵢ} ≠ ∅`. There is an
  isomorphism of chain complexes of `O_X(V)`-modules
  `((eval V).mapHomologicalComplex _).obj (cechFreePresheafComplex 𝒰) ≅ C•`, where
  `C•_p = ⊕_{σ : Fin(p+1) → I₁(V)} O_X(V)` (coproduct in `ModuleCat (O_X(V))`) and the differential of
  `C•` is `FreeCechEngine.combDifferential` (the constant-coefficient alternating-sum Čech
  differential on the index set `I₁(V)`). I.e. the degreewise iso intertwines the evaluated
  alternating-face differential with `combDifferential`.
- **Proof sketch.** Degreewise: `cechFreeEval_X` gives
  `(eval V).obj (K(𝒰)_p) ≅ ∐_{σ:Fin(p+1)→𝒰.I₀} (eval V).obj (freeYoneda U_σ)`; split the index into
  `σ` landing in `I₁(V)` (each summand `≅ O_X(V)` by `freeYonedaEval_iso_of_le`) and the rest
  (`= 0` by `freeYonedaEval_isZero_of_not_le`), so `∐` collapses to `∐_{σ:Fin(p+1)→I₁(V)} O_X(V) = C•_p`.
  The **differential match** is the hard content: the evaluated differential is
  `(eval V).map` of the alternating face sum `AlternatingFaceMapComplex.objD (cechFreeSimplicial 𝒰)`;
  the face `δᵢ` reindexes the `σ`-summand by `σ ↦ σ ∘ Fin.succAbove i` (see `cechFreeSimplicial.map`),
  which on the `I₁`-summands is precisely the index-drop the engine encodes, and the sign `(-1)ⁱ`
  comes from `objD`. Prove the match on coproduct injections via `Limits.Sigma.hom_ext`, reusing
  `Limits.PreservesCoproduct.iso` naturality. State that this is the chain/coproduct dual of the
  section-side cochain identification in `lem:section_cech_homology_exact`.
- `\lean{}`: leave it pinned to the to-be-built name `AlgebraicGeometry.cechFreeEvalEngineIso`
  (the prover will create this name; do NOT mark `\leanok`).
- `\uses{lem:cech_free_eval_sectionwise, lem:free_cech_engine}`.
- SOURCE: same `lemma-homology-complex` proof region already cited by the sectionwise lemma
  (`references/stacks-cohomology.tex`); reuse a verbatim quote you have actually read from there
  (the "$K^{ext}_p(W) = \bigoplus ... \mathcal{O}_X(W)$" / differential description).

Then update `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_nonempty` to
`\uses{lem:cech_free_eval_engine_iso}` (in addition to their current uses), and add
`lem:cech_free_eval_engine_iso` to `lem:cech_free_complex_quasi_iso`'s `\uses{}`.

### A2 (MUST-FIX). Blueprint the `FreeCechEngine` namespace.
Add a lemma/definition block `lem:free_cech_engine` (place it just before `lem:cech_free_eval_engine_iso`)
bundling the 9 engine declarations, all already axiom-clean in FreePresheafComplex.lean. Single block,
one `\lean{...}` list with all of:
`AlgebraicGeometry.FreeCechEngine.combDifferential`, `.combDifferential_comp`,
`.combDifferential_eq_of_cocycle`, `.combDifferential_exact`, `.combHomotopy`, `.combHomotopy_spec`,
`.combHomotopy_zero`, `.combSign_flip`, `.cons_comp_succAbove_succ`.
- Statement prose: this is the constant-coefficient combinatorial Čech contracting-homotopy engine —
  for a fixed index set `J` (`= I₁(V)`) nonempty with a chosen `i_fix ∈ J` and a single coefficient
  module, the alternating-sum differential `combDifferential` satisfies `d² = 0`
  (`combDifferential_comp`), and the prepend-`i_fix` homotopy `combHomotopy` satisfies
  `d∘h + h∘d = id` (`combHomotopy_spec`), giving positive-degree exactness
  (`combDifferential_exact`). The remaining names are sign/index bookkeeping
  (`combSign_flip`, `cons_comp_succAbove_succ`) and a degenerate-case simp lemma (`combHomotopy_zero`).
- Add a `% NOTE:` (LaTeX comment) recording that `FreeCechEngine.*` is a deliberate constant-coefficient
  free-side **copy** of the `private` `CombinatorialCech.*` engine in CechAcyclic.lean (privacy barrier
  prevents cross-file reuse; de-privatizing was deemed too risky to attempt mid-convergence — the copy
  is the chosen tradeoff).
- `\uses{}`: none needed (self-contained `Fin.cons`/`succAbove`/`predAbove` + `Finset.sum_involution`).
- This is project-bespoke combinatorial infrastructure mirroring the Stacks `lemma-homology-complex`
  contracting homotopy; cite that source region (already quoted in the chapter for `_prepend_homotopy`).

### A3 (MUST-FIX). Fix the private-name references in the existing proof sketches.
In `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_prepend_homotopy_spec` proof bodies,
replace every reference to `CombinatorialCech.combHomotopy`, `CombinatorialCech.combHomotopy_spec`,
`cons_comp_succAbove_succ`, `combSign_flip` (which name PRIVATE declarations in CechAcyclic.lean,
inaccessible from FreePresheafComplex.lean) with the public `FreeCechEngine.*` names. Keep the math
identical; only the operator names change.

### A4 (MAJOR). Fix the `cechFreeEval_X` signature annotation + bundle per-summand helpers.
`lem:cech_free_eval_sectionwise` currently `\lean{}`-pins only `cechFreeEval_X`, whose Lean type is the
coproduct-commutation iso `(eval V)(K_p) ≅ ∐_σ (eval V)(freeYoneda U_σ)` — strictly weaker than the
full `⊕_{I₁} O_X(V)` claim of the lemma. Add to its `\lean{}` list the two per-summand collapse helpers
that complete the identification: `AlgebraicGeometry.freeYonedaEval_iso_of_le`,
`AlgebraicGeometry.freeYonedaEval_isZero_of_not_le`. Add one prose sentence noting the full
identification is `cechFreeEval_X` (eval commutes with `∐`) + `freeYonedaEval_iso_of_le` (surviving
summand `≅ O_X(V)`) + `freeYonedaEval_isZero_of_not_le` (non-`I₁` summand `= 0`).

### A5 (MINOR coverage). Bundle the remaining empty-case + utility helpers.
Add to `lem:cech_free_eval_empty`'s `\lean{}` list:
`AlgebraicGeometry.cechFreeEval_isZero_of_isEmpty`,
`AlgebraicGeometry.coverStructurePresheaf_eval_isZero_of_isEmpty`,
`AlgebraicGeometry.isZero_homology_of_isZero_X`. And add a one-line generic-utility block (or bundle
into the engine block's `\lean{}` list) for `AlgebraicGeometry.isZero_sigma_of_forall_isZero`
(coproduct of zero objects is zero) — a generic category-theory helper.

---

## TASK B — Section route (CechAcyclic.lean): effort-break + coverage

### B1 (MAJOR coverage). Add the two missing `\lean{}` entries to `def:qcoh_sections_localized`.
Add `AlgebraicGeometry.basicOpen_sprod` (the multi-index intersection identity
`⨅ₖ D(s_{σk}) = D(∏ₖ s_{σk})` in `(Spec R).Opens`, first step of `qcohSectionsAwayLocalized`) and
`AlgebraicGeometry.qcohRestriction_eq_comparison` (item (5): the presheaf restriction between
basic-open section groups IS `AwayComparison.comparison`, the differential brick) to the `\lean{}` list
of `def:qcoh_sections_localized`. Both already exist + are axiom-clean.

### B2 (MAJOR / effort-break). Correct + decompose `lem:section_cech_homology_exact`.
The prover was blocked: the blueprint proof sketch says to use `ShortComplex.moduleCat_exact_iff`, but
`sectionCechComplex` is a `CochainComplex Ab ℕ` whose degree-`p` object is the **categorical product**
`∏ᶜ (σ ↦ F.presheaf.obj (op (⨅ₖ U(σk))))` in `Ab` — NOT a `ModuleCat` object — so `moduleCat_exact_iff`
does not apply. Fix the sketch and split the lemma into a `\uses`-linked chain of three sub-lemmas
(each one mathematical step), mirroring the free-side 6-link split. Keep the top-level
`lem:section_cech_homology_exact` as the glue; add three sub-lemma nodes it `\uses`:

1. `lem:section_cech_product_equiv` — the element-level product equivalence
   `ToType (∏ᶜ Fσ) ≃ ∀ σ, ToType (Fσ)` in `Ab`, via Mathlib
   `CategoryTheory.Limits.Concrete.productEquiv` (needs `[PreservesLimit (Discrete.functor F) (forget Ab)]`,
   available for `Ab`). This is what moves between the categorical product and the per-`σ` localised
   modules. Per-`σ`, identify `ToType (F.presheaf.obj (op (⨅ₖ U(σk))))` with `SectionCechModule.dCoeff`
   via `IsLocalizedModule` uniqueness (both localise `M` at `s_σ`; `qcohSectionsAwayLocalized`).
2. `lem:section_cech_coface_match` — unfold `AlgebraicTopology.alternatingCofaceMapComplex`'s degree-`p`
   differential of `sectionCechCosimplicial` to the alternating sum `∑ⱼ (-1)ʲ • coface_j` with
   `coface_j = Pi.lift (… Pi.π (σ∘dⱼ) ≫ F.presheaf.map (restriction).op)`, and match each
   `F.presheaf.map (restriction).op` to the localisation comparison via `qcohRestriction_eq_comparison`
   + `basicOpen_sprod`, identifying it with `SectionCechModule.dDiff`.
3. `lem:section_cech_ab_exact` — reduce `IsZero (homology p)` to `Function.Exact` of the underlying
   group homs via `exactAt_iff_isZero_homology` + **`ShortComplex.ab_exact_iff`** (the Ab analogue:
   `S.Exact ↔ ∀ x₂, g x₂ = 0 → ∃ x₁, f x₁ = x₂`), then transport the already-proved
   `SectionCechModule.dDiff_exact` (iter-019) across the product equivalence of sub-lemma 1.

Give each sub-lemma an explicit intended Lean signature sketch and pin a to-be-built `\lean{}` name
(`AlgebraicGeometry.sectionCechProductEquiv`, `…sectionCechCofaceMatch`, `…sectionCechAbExact` — or
names you judge cleaner; the prover will create them). Replace the wrong `moduleCat_exact_iff`
reference in the top-level proof with `ShortComplex.ab_exact_iff` + the product-equivalence route.
State the intended top-level signature of `sectionCech_homology_exact` explicitly (an `IsZero (homology
p)` conclusion for `1 ≤ p`, OR the iff — pick the directed `IsZero` form that `sectionCech_affine_vanishing`
actually needs and say so).
SOURCE: the `lemma-cech-cohomology-quasi-coherent-trivial` quote already in the block backs the complex
identification; no new source needed.

---

## TASK C — Bridge route (CechBridge.lean): coverage + assembly path

### C1 (MAJOR coverage). Add `\lean{}` blocks for the 4 uncovered public bridge declarations.
Add blueprint coverage (new sub-lemma/def blocks under `lem:cech_complex_hom_identification`, or a new
`lem:cech_complex_op_identification`) for:
- `AlgebraicGeometry.homCechComplexMapOpIso` — cochain-complex iso
  `homCechComplex 𝒰 F ≅ ((preadditiveYoneda.obj F).mapHomologicalComplex (up ℕ)).obj
  (HomologicalComplex.op (cechFreePresheafComplex 𝒰))`; built from
  `HomologicalComplex.Hom.isoOfComponents (fun _ => Iso.refl _)` with the differential squares supplied
  by the degreewise identity `homCechComplex_d_eq`. `\uses{lem:cech_complex_hom_identification,
  def:cech_free_presheaf_complex}`. Bundle the two PRIVATE drivers
  `AlgebraicGeometry.homCechComplex_d_eq`, `AlgebraicGeometry.homCechCosimplicial_δ` into this block's
  `\lean{}` list (private does NOT exempt from coverage debt).
- `AlgebraicGeometry.sectionCechComplexMapOpIso` — composite iso
  `(mapOp free complex) ≅ sectionCechComplex (coverOpen 𝒰) F` = `homCechComplexMapOpIso.symm ≪≫
  cechComplex_hom_identification`. `\uses` the above + `lem:cech_complex_hom_identification`.
- A sub-lemma block (e.g. `lem:hom_into_injective_exact`) for
  `AlgebraicGeometry.preadditiveYoneda_obj_preservesFiniteColimits_of_injective` (instance: `Hom(-,I)`
  preserves finite colimits for injective `I`) and
  `AlgebraicGeometry.quasiIso_map_preadditiveYoneda_of_injective` (`Hom(-,I)` carries quasi-isos to
  quasi-isos for injective `I`). Prose: for injective `I`, `Hom(-,I)` is exact, hence preserves
  homology, hence carries quasi-isos to quasi-isos. Stated for a general abelian category (right
  generality for reuse). SOURCE: standard homological algebra (`Injective` + exact contravariant
  functor) — project-bespoke, no external citation needed beyond a Stacks/standard pointer if natural.

### C2 (MAJOR, non-blocking). Expand the `lem:injective_cech_acyclic` assembly path.
Add to its `\uses{}` (and describe in prose) the assembly route now that the bridge is complete: take
`cechFreeComplexAug 𝒰` (QuasiIso, from `lem:cech_free_complex_quasi_iso`), opposite it via the
`HomologicalComplex` op-functor machinery, map through `preadditiveYoneda.obj F`
(`quasiIso_map_preadditiveYoneda_of_injective`), transport source/target across
`sectionCechComplexMapOpIso`; the mapped-opposite of the degree-0-concentrated target has vanishing
positive homology, giving Čech vanishing. Add `lem:cech_complex_op_identification` (or whichever labels
you used in C1) + `lem:hom_into_injective_exact` + `lem:cech_free_complex_quasi_iso` to its `\uses{}`.

---

## Out of scope
- Do NOT touch `\leanok` anywhere (sync phase owns it).
- Do NOT modify the P5a (`HigherDirectImagePresheaf`) or P5b (`cech_computes_higherDirectImage`) blocks.
- Do NOT change any existing correct statement's mathematical content — only the items A1–C2 above.
- Do NOT rename or re-sign any existing `\lean{}`-pinned declaration.

## Acceptance
After your pass, `archon dag-query unmatched` should reach 0 (all 24 currently-unmatched Lean decls get
a blueprint home), the FreeCechEngine + differential-match nodes exist with accurate `\uses{}`, the
private-`CombinatorialCech.*` references in the free-eval proof sketches are gone, and
`lem:section_cech_homology_exact` references `ab_exact_iff` (not `moduleCat_exact_iff`) with its
3-sub-lemma chain.
