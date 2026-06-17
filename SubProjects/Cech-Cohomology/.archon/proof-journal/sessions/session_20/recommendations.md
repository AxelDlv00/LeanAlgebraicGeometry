# Recommendations — next plan iteration (after iter-020)

## CRITICAL / HIGH — must address before the relevant prover lane

### H1. FreePresheafComplex lane is HARD-GATE blocked — blueprint the `FreeCechEngine` engine + fix private references
**lvb `freepresheafcomplex` returned 2 MUST-FIX blueprint-adequacy failures.** Do NOT re-dispatch
a FreePresheafComplex prover until a blueprint-writer fixes:
1. The entire `FreeCechEngine.*` namespace (9 decls: `combDifferential`, `combHomotopy`,
   `combHomotopy_zero`, `cons_comp_succAbove_succ`, `combHomotopy_spec`,
   `combDifferential_eq_of_cocycle`, `combSign_flip`, `combDifferential_comp`,
   `combDifferential_exact`) has **zero `\lean{}` coverage** — add a `FreeCechEngine` blueprint
   block (e.g. `lem:free_cech_engine`) or bundle into `lem:cech_free_eval_prepend_homotopy_spec`'s
   `\lean{}` list.
2. The blueprint proof sketches for `lem:cech_free_eval_prepend_homotopy_spec` reference the
   **private** `CombinatorialCech.combHomotopy_spec` (not importable) — correct them to point at
   the public `FreeCechEngine.*`.
- See report: `.archon/task_results/lean-vs-blueprint-checker-freepresheafcomplex.md`.

### H2. Structural decision: de-duplicate `FreeCechEngine` vs `CombinatorialCech` (lean-auditor major)
`FreeCechEngine.*` (FreePresheafComplex.lean:445–553) is a **verbatim copy** of 9 private
`CechAcyclic.CombinatorialCech.*` lemmas (forced because the originals are `private`). lean-auditor
recommends de-privatizing `CombinatorialCech.*` or extracting both to a shared file, and notes a
public/private inconsistency (FreeCechEngine public, CombinatorialCech private). **Decide before
investing more in either:** a refactor (shared engine file) now avoids maintaining two copies as the
nonempty homotopy build grows. If kept duplicated, blueprint H1 against `FreeCechEngine` and accept
the duplication explicitly. Report: `.archon/task_results/lean-auditor-iter020.md`.

### H3. Then attack the nonempty case bottleneck (step 1 only)
Once H1/H2 are settled, the FreePresheafComplex remaining work is well-scoped (engine + per-summand
inputs all axiom-clean). The single hard sub-step is the **evaluated-differential ↔
`FreeCechEngine.combDifferential` match on coproduct injections** (`Limits.Sigma.hom_ext`, reindex
`σ ↦ σ ∘ Fin.succAbove i`, sign from `objD`). Consider an **effort-breaker at sentence granularity**
on this match before dispatch — it is the chain/coproduct dual of the proved section-side cochain
identification and is the all-or-nothing gate for steps 2–5 (prepend homotopy → `HomotopyEquiv` →
`QuasiIso` → glue via `quasiIso_of_evaluation` with the `I₁=∅`/`I₁≠∅` split). Do NOT re-dispatch as
a body-fill (the target decl does not exist; the homotopy is one all-or-nothing `def`).

## CLOSEST TO COMPLETION — prioritize

### P1. CechBridge `injective_cech_acyclic` — one-step assembly, gated only on H3
The bridge is complete: `sectionCechComplexMapOpIso` + `quasiIso_map_preadditiveYoneda_of_injective`
(present) make `injective_cech_acyclic` a one-step assembly the MOMENT `cechFreeComplex_quasiIso`
lands. Recipe (from task_results/CechBridge.md): opposite `cechFreeComplexAug 𝒰` via
`HomologicalComplex.opFunctor`/`φ.op`, map through `preadditiveYoneda.obj F`, transport across
`sectionCechComplexMapOpIso`. **Caveat to verify when wiring:** `quasiIso_map_preadditiveYoneda_of_injective`
wants `φ : K ⟶ L` of `HomologicalComplex Cᵒᵖ c` directly — confirm `HomologicalComplex.op X` agrees
with `(opFunctor _ _).obj (op X)` or restate via `opFunctor`. CechBridge is otherwise complete (0
sorries this iter); no prover needed until H3 lands.

### P2. CechAcyclic step (c) `sectionCech_homology_exact` — effort-break into 3 sub-lemmas
The P3 module-algebra core (`dDiff_exact`) and step (b) (`qcohSectionsAwayLocalized`) are done. Step
(c) is **not new mathematics** — it is categorical-product bookkeeping. Effort-break it (mirrors the
FreePresheafComplex 6-link split) into:
1. `∏ᶜ ≅ pi` element-level transport via `CategoryTheory.Limits.Concrete.productEquiv` (verified
   present; needs `[PreservesLimit (Discrete.functor F) (forget Ab)]`, available for `Ab`).
2. unfold `alternatingCofaceMapComplex`'s degree-`p` differential and match each
   `F.presheaf.map (restriction).op` to `dCoface` via `qcohRestriction_eq_comparison` +
   `basicOpen_sprod`.
3. `exactAt_iff_isZero_homology` + `ShortComplex.ab_exact_iff` (verified present:
   `S.Exact ↔ ∀ x₂, g x₂ = 0 → ∃ x₁, f x₁ = x₂`) to transport `dDiff_exact` across the product
   `AddEquiv`.
**Also blueprint:** lvb `cechacyclic` flagged `lem:section_cech_homology_exact` is under-specified at
the Lean-framework level (no pinned signature, no `isoOfComponents` assembly path) — have the
blueprint-writer add these before the prover attempt. Step (d) `sectionCech_affine_vanishing` is pure
assembly of (b)+(c), unblocks once (c) lands. **Dead end (do not retry):** `moduleCat_exact_iff` on
`sectionCechComplex` — it is `Ab`-valued.

## BLOCKED — do not re-assign without the named structural change
- **`cechFreeComplex_quasiIso` (nonempty case)** — blocked behind H1 (blueprint) + H2 (structural)
  + H3 (the differential match). Same wall character as a body-fill would hit; the corrective is
  blueprint + effort-break, not another prover round on the monolith.
- **`injective_cech_acyclic`** — correctly held; gated on H3. Not a prover target until then.

## Coverage debt (1-to-1 Lean↔blueprint) — `archon dag-query unmatched` = 24
All 24 are this-session helpers (or 2 carried `preadditiveYoneda_*` from iter-019) needing blueprint
entries from the planner. Group for blueprint-writer:
- **FreeCechEngine engine (9):** `FreeCechEngine.combDifferential`, `.combDifferential_comp`,
  `.combDifferential_eq_of_cocycle`, `.combDifferential_exact`, `.combHomotopy`,
  `.combHomotopy_spec`, `.combHomotopy_zero`, `.combSign_flip`, `.cons_comp_succAbove_succ`
  (= H1; relies on `Fin.cons/succAbove/predAbove` API, `Finset.sum_involution`).
- **FreePresheafComplex sectionwise (5):** `cechFreeEval_isZero_of_isEmpty`,
  `coverStructurePresheaf_eval_isZero_of_isEmpty`, `freeYonedaEval_isZero_of_not_le`,
  `freeYonedaEval_iso_of_le` (bundle into `lem:cech_free_eval_sectionwise`/`lem:cech_free_eval_empty`),
  plus generics `isZero_sigma_of_forall_isZero`, `isZero_homology_of_isZero_X`.
- **CechAcyclic (3):** `basicOpen_sprod`, `qcohRestriction_eq_comparison` (bundle into
  `def:qcoh_sections_localized`), `iInf_fin_succ` (private; bundle under `basicOpen_sprod`).
- **CechBridge (4):** `homCechComplexMapOpIso`, `sectionCechComplexMapOpIso` (new blocks, e.g.
  `def:hom_cech_complex_map_op_iso` / `def:section_cech_complex_map_op_iso`; the latter is what
  `lem:injective_cech_acyclic` should `\uses`), `homCechComplex_d_eq`, `homCechCosimplicial_δ`
  (private; bundle into the `homCechComplexMapOpIso` `\lean{}` list).
- **carried (2):** `preadditiveYoneda_obj_preservesFiniteColimits_of_injective`,
  `quasiIso_map_preadditiveYoneda_of_injective` — bundle into `lem:injective_cech_acyclic`.

## Reusable proof patterns discovered (added to Knowledge Base)
- Empty-case `IsZero.of_epi` needs a syntactic-image `change` before instance search.
- Defeq-carrier hom-complex differential identity: `have hop := op_sum …` (explicit args) +
  `erw` + explicit `rfl`.
- `(Spec R).Opens` ≠ `Opens (PrimeSpectrum.Top R)` syntactically — annotate `⨅`-identities.
- `sectionCechComplex` Ab/`∏ᶜ`: `ShortComplex.ab_exact_iff` + `Concrete.productEquiv`, not `moduleCat_exact_iff`.

## Minor (lean-auditor LOW/minor)
- `FreePresheafComplex.lean:21` header overclaims ownership of `cechFreeComplex_quasiIso` → reword.
- `CechBridge.lean:206,208` show-vs-change linter warnings; CechAcyclic long-line warnings;
  CechAcyclic:131 imprecise namespace docstring; FreePresheafComplex:337 forward-ref to absent decl.
  All cosmetic; fold into the next refactor pass on these files.

## blueprint-doctor
Clean — no orphan chapters, no broken `\ref`/`\uses`, no stray `axiom`. Nothing to action.
