# Session 20 (iter-020) — review summary

## Metadata
- **Sorry count: 2 → 2** (no regression). Both intentional: superseded relative-form
  `CechAcyclic.affine` (`CechAcyclic.lean:109`) + frozen P5b assembly
  (`CechHigherDirectImage.lean:679`).
- **Build: GREEN.** All 3 touched files diagnostic-clean; `lake build` 8319 jobs.
- **+18 axiom-clean declarations** across 3 parallel lanes (FreePresheafComplex +10,
  CechAcyclic +4, CechBridge +4); **0 new sorries**.
- **Named/sub-targets landed (5):** `cechFreeEval_quasiIso_of_isEmpty`
  (`lem:cech_free_eval_empty`), `cechFreeEval_X` (`lem:cech_free_eval_sectionwise`, entry
  point), `qcohSectionsAwayLocalized` (P3 step (b), tilde case), `homCechComplexMapOpIso`,
  `sectionCechComplexMapOpIso` (P3b bridge transport). All `#print axioms`-clean
  `{propext, Classical.choice, Quot.sound}`.
- **Named top-line lane targets NOT landed:** `cechFreeComplex_quasiIso` (nonempty case),
  `sectionCech_homology_exact` / `sectionCech_affine_vanishing` (step c/d),
  `injective_cech_acyclic` (gated by design).

## Targets attempted

### Lane 1 — FreePresheafComplex.lean (`cechFreeComplex_quasiIso`, +10)
The per-`V` homotopy lane the progress-critic set a hard clock on. Result: the **empty case
fully landed** and the **combinatorial homotopy engine fully built**, but the **nonempty case
is blocked** on the evaluated-differential ↔ engine-differential match.

- **`FreeCechEngine.*` (9 decls, lines 445–553)** — constant-coefficient combinatorial
  contracting-homotopy engine (`combDifferential`, `combHomotopy`, `combHomotopy_spec`
  `dh+hd=id`, `combDifferential_comp` `d²=0` via the `(j,i)↦(j.succAbove i, i.predAbove j)`
  sign-reversing involution, `combDifferential_exact`). A **verbatim free-side port of the
  `private` `CechAcyclic.CombinatorialCech.*`** (private ⇒ not importable). This is the genuine
  per-`V` homotopy mathematical content.
- **`cechFreeEval_X` (line 574)** — `(eval V).obj K(𝒰)_p ≅ ∐_σ (eval V).obj (freeYoneda U_σ)`
  via `Limits.PreservesCoproduct.iso`. First written as `example ... := by` → "consider
  marking noncomputable"; fixed to a `noncomputable def`.
- **`freeYonedaEval_isZero_of_not_le` / `freeYonedaEval_iso_of_le`** — per-summand collapse:
  hom-set `V ⟶ W` is empty (⇒ zero module) or `Unique` (⇒ `O_X(V)` via
  `Finsupp.LinearEquiv.finsuppUnique`).
- **Empty case `cechFreeEval_quasiIso_of_isEmpty` (line 687, `lem:cech_free_eval_empty`)** —
  both evaluated complexes objectwise zero (`isZero_homology_of_isZero_X`,
  `coverStructurePresheaf_eval_isZero_of_isEmpty`, `eval.mapZeroObject`), homology map iso
  between zero objects. **Key gotcha (cost ~4 iterations):** `IsZero.of_epi`/`Functor.map_epi`
  need the morphism **syntactically** matching the local `Epi` instance — had to `change` the
  goal from `coverStructurePresheaf 𝒰` to `Limits.image (cechFreeAug 𝒰)` (defeq, not syntactic)
  first, else instance search fails.
- **Blocked (nonempty case):** `cechFreeComplex_quasiIso` + `cechFreeEval_quasiIso_of_nonempty`
  + the prepend-homotopy packaging. The bottleneck is step 1: the evaluated differential
  (`(eval V).map` of the alternating face sum) ↔ `FreeCechEngine.combDifferential` match on
  coproduct injections — the chain/coproduct dual of the section-side cochain identification.
  **Not pinned as a sorry** (the nonempty `Homotopy` is one all-or-nothing `def`).

### Lane 2 — CechAcyclic.lean (P3 steps b–d, +4)
- **`qcohSectionsAwayLocalized` (line 1166, named target, tilde case)** — sections over the
  `(p+1)`-fold intersection are `IsLocalizedModule (powers (∏ₖ s_{σ k}))` via the Mathlib
  `tilde.toOpen` localisation instance + `basicOpen_sprod`.
- **`basicOpen_sprod` (line 1142)** — `⨅ₖ D(s_{σ k}) = D(s_σ)`, induction on `n` with
  `Fin.prod_univ_succ` + `PrimeSpectrum.basicOpen_mul` + `iInf_fin_succ`. **Lesson:** must be
  stated with the `: (Spec R).Opens` annotation, else `rw` fails inside `tilde.toOpen` args (the
  `Opens (PrimeSpectrum.Top R)` form is not syntactically the `(Spec R).Opens` lattice form).
- **`qcohRestriction_eq_comparison` (line 1185)** — the step-(c) differential brick: the
  presheaf restriction between basic-open section groups IS `AwayComparison.comparison`, via
  `comparison_unique` + `tilde.toOpen_res`. Needed an explicit `haveI : IsLocalizedModule
  (.powers a) (...).hom := inferInstance` + explicit `fa`/`fb` args (synthesis stalled on `_`).
- **Blocked (step c) `sectionCech_homology_exact`:** `sectionCechComplex` is `CochainComplex Ab ℕ`
  whose degree-`p` object is the **categorical product `∏ᶜ` in `Ab`** — not a `ModuleCat` object,
  not a pi type — so `ShortComplex.moduleCat_exact_iff` does NOT apply. The bridge needs three
  self-contained Mathlib-API lemmas (no new math): (1) `Concrete.productEquiv` at element level
  inside `ab_exact_iff`; (2) unfold the `alternatingCofaceMapComplex` differential and match each
  restriction to `dCoface` via `qcohRestriction_eq_comparison`; (3) `exactAt_iff_isZero_homology`
  + `ShortComplex.ab_exact_iff` to transport the proved `dDiff_exact`. **Dead end recorded:** do
  NOT use `moduleCat_exact_iff` on `sectionCechComplex`.

### Lane 3 — CechBridge.lean (injective bridging prep, +4)
- **`homCechComplex_d_eq` (private, line 285)** — degreewise differential identity; **resolves
  the iter-019 Probe `sorry`** (CechBridge now 0 sorries). Both differentials reduced to
  alternating (co)face sums, then op + the additive `Hom(-,F)` pushed through. **Defeq-carrier
  hazard:** plain `rw [op_sum]`/`rw [Functor.map_zsmul]` fail "pattern not found" though the goal
  matches verbatim — fix is `have hop := op_sum …` (explicit object args) + `erw`, closing the
  residual with an explicit `rfl`.
- **`homCechCosimplicial_δ` (private, line 278)** — `rfl` coface identity.
- **`homCechComplexMapOpIso` (line 326)** — `homCechComplex 𝒰 F ≅ ((preadditiveYoneda.obj
  F).mapHomologicalComplex (up ℕ)).obj (HomologicalComplex.op (cechFreePresheafComplex 𝒰))`, via
  `isoOfComponents (Iso.refl)`; naturality built as a TERM (`simp [id_comp,comp_id]` won't fire
  on defeq-only carrier).
- **`sectionCechComplexMapOpIso` (line 349)** — composite
  `(homCechComplexMapOpIso).symm ≪≫ cechComplex_hom_identification`.
- **`injective_cech_acyclic` NOT added (by design)** — gated on Lane-1 `cechFreeComplex_quasiIso`.
  With the bridge complete it is a one-step assembly next iter (recipe in milestones).

## Subagent reviews (read full reports under `.archon/task_results/`)
- **lean-auditor `iter020`** — 3 files axiom-clean, **0 must-fix**, 0 new sorries, 0
  excuse-comments. 2 majors: (1) `FreePresheafComplex.lean:21` header overclaims it "owns"
  `cechFreeComplex_quasiIso` (doesn't exist — say "building toward"); (2) `FreeCechEngine`
  (lines 445–553) **duplicates 9 `CombinatorialCech` lemmas** with identical bodies — correct
  fix is to de-privatize `CombinatorialCech.*` or extract a shared file (also public/private
  inconsistency). 5 minors (show-vs-change, long lines, stale forward-ref/docstring).
- **lvb `cechacyclic`** — Lean clean (53 decls), 0 must-fix; 3 majors, all blueprint-side
  (`basicOpen_sprod` + `qcohRestriction_eq_comparison` lack `\lean{}`; `lem:section_cech_homology_exact`
  under-specified — needs signature + `isoOfComponents` assembly path).
- **lvb `cechbridge`** — axiom-clean, 0 sorries, 0 must-fix; 4 majors = uncovered public decls.
- **lvb `freepresheafcomplex`** — sorry-free for completed decls but **2 MUST-FIX blueprint
  adequacy failures**: the entire `FreeCechEngine` namespace (9 decls) is unblueprinted AND the
  blueprint proof sketches reference the **private** `CombinatorialCech.*`; `cechFreeEval_X`
  partial vs `lem:cech_free_eval_sectionwise`; 6 intermediate lemmas unblueprinted.

## Blueprint markers updated (manual)
- None this iter. No Mathlib re-export was newly named in a blueprint block (the
  "project-local Mathlib supplement" decls are project-PROVED, not re-exports → no `\mathlibok`);
  no prover flagged a `\lean{...}` rename of an existing block; no `\notready` markers exist to
  strip. `sync_leanok` added 7 markers deterministically (iter 20, sha 133f139).

## Key findings / patterns (full text added to PROJECT_STATUS Knowledge Base)
- **Empty-case `IsZero.of_epi` needs a syntactic-image `change`** (FreePresheafComplex).
- **`change`/`erw` + explicit `rfl` for the defeq-carrier hom-complex differential identity**
  (CechBridge `homCechComplex_d_eq`) — reinforces the iter-018/019 defeq-carrier patterns.
- **`(Spec R).Opens` vs `Opens (PrimeSpectrum.Top R)` are not syntactically equal** — state
  geometric `⨅`-identities with the `(Spec R).Opens` annotation (CechAcyclic `basicOpen_sprod`).
- **`sectionCechComplex` is `Ab`-valued with `∏ᶜ` objects** — use `ShortComplex.ab_exact_iff`
  + `Concrete.productEquiv`, never `moduleCat_exact_iff` (CechAcyclic step-c dead end).

## Recommendations for next session
See `recommendations.md`. Headline: the FreePresheafComplex lane is **blocked behind blueprint
adequacy** (FreeCechEngine namespace must be blueprinted + the private-reference must-fix fixed)
**and a structural decision** (de-privatize/share `CombinatorialCech` vs keep the duplicate
`FreeCechEngine`) — do NOT re-dispatch the FreePresheafComplex prover until those are resolved.
CechAcyclic step (c) and CechBridge `injective_cech_acyclic` are both effort-break / one-step
assembly items.
