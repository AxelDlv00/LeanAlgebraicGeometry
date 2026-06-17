# Recommendations — next plan iteration (after iter-030)

## Audit verdict: clean iter, no Lean must-fix
All three review subagents returned 0 critical / 0 must-fix on the Lean. The only actionable items
are (1) the next prover lane and (2) the blueprint coverage debt. No CHURNING/STUCK route.

## 1. Closest-to-completion / highest-priority next lane

### CechBridge family-form `injective_cech_acyclic` (closes the iter-029 ⊤-vs-D(f) design fork)
The FreePresheafComplex half of the fork-fix is DONE: `cechFreeComplex_quasiIsoFam` and the full
`…Fam` chain landed axiom-clean, cover-agnostic. **Next**: re-prove positive-degree section-Čech
vanishing for an injective sheaf over an arbitrary finite family `{ι}[Finite ι](U : ι → Opens X)` in
`CechBridge.lean`, consuming `cechFreeComplex_quasiIsoFam U` (the prover's task_result enumerates the
full supporting `…Fam` chain it needs). This discharges `BasisCovSystem.injective_acyclic` over
standard covers of arbitrary `D(f)` directly — no `Spec R_f` restriction, no `j_!` apparatus.
- Mathematically validated (iter-029/030 strategy-critic: stalkwise exactness on the simplex over
  `{i : x ∈ U_i}`, contractible/all-zero, covering never enters).
- HARD GATE: this re-uses the existing CechBridge `injective_cech_acyclic` proof shape (op-transport
  via `opFunctor`, `single₀`, `maxHeartbeats 2000000`) — the prover should mirror it onto the family
  form. The `X.OpenCover` decls were kept byte-identical so the existing `injective_cech_acyclic`
  stays green; the family form is an addition, not a replacement.

### Then (02KG remaining geometry — separate lanes, after the fork closes)
- `standard_cover_cofinal` — build from `Scheme.isBasis_affineOpens` + `OpenCover.finiteSubcover`
  (no Mathlib cofinality lemma; ref Stacks 009L in `references/stacks-sheaves.tex`).
- `affine_surj_of_vanishing` — `O_X`-module epi ⇒ local section surjectivity via
  `Presheaf.IsLocallySurjective` + `Sheaf.isLocallySurjective_iff_epi'`, gated on the one gap-fill
  `SheafOfModules.toSheaf.PreservesEpimorphisms`. Do NOT discharge from `injective_cech_acyclic`
  (its `S.X₁` is a quotient, not injective).

## 2. Blocked target — do NOT re-assign without a structural change

### Unconditional `qcoh_iso_tilde_sections` / 01I8 step (1) — affine global generation
Steps (2)–(3) are now SHIPPED (`isIso_fromTildeΓ_of_genSections`,
`qcoh_iso_tilde_sections_of_genSections`, `free_isQuasicoherent`). The remaining gap is EXACTLY:
produce `σ : F.GeneratingSections` (and `τ` for the kernel) for quasi-coherent `F` on `Spec R`. This
needs ~few-hundred LOC of genuinely-new affine sheaf theory absent from Mathlib:
- localisation-of-sections `Γ(D(f),F) ≅ (Γ(Spec R,F))_f` (Stacks 01HV(4), `IsLocalizedModule` form);
- partition-of-unity / quasi-compactness assembly into a global generating family;
- qcoh abelian-subcategory closure (kernel of an epi between qcoh is qcoh) for `τ`.
**Do NOT** re-dispatch as a Mathlib re-export, and **do NOT** add the single-hypothesis reduction
`(∀ qcoh G, Nonempty G.GeneratingSections) → IsIso F.fromTildeΓ` — it still needs kernel-qcoh, so it
merely relabels the gap (this is the iter-031 progress-critic STUCK signal). If this lane is taken, it
must be a dedicated multi-iter effort-broken build of affine global generation, not a body-fill. Best
attempted with the external-LLM informal helper available (no API key currently in env).

## 3. Coverage debt — 54 unmatched `lean_aux` nodes (blueprint-writer needed)
`archon dag-query unmatched` = 54. These are Lean decls with no blueprint block, invisible to the DAG.
The reviewer does not author prose; the planner must dispatch a blueprint-writer to add/bundle these
into the consolidated `Cohomology_CechHigherDirectImage.tex`. Suggested bundling:

**(a) Dead decl — recommend the user delete (drops sorry 2→1):** `AlgebraicGeometry.CechAcyclic.affine`
  (superseded relative-form, has_sorry, 0 rdeps). Listed unmatched every iter since ~024. It is the
  `CechAcyclic.lean:110` sorry. De-pinned from `lem:cech_acyclic_affine` already; safe to delete.

**(b) 50 `…Fam` decls (FreePresheafComplex)** — the exact family-form mirrors of the already-blueprinted
  `X.OpenCover` chain. Bundle each into the corresponding existing `\lean{…}` list (e.g.
  `cechFreeComplex_quasiIsoFam` → `lem:cech_free_complex_quasi_iso`; `cechFreePresheafComplexFam` →
  `def:cech_free_presheaf_complex`; `coverStructurePresheafFam` → `def:cover_structure_presheaf`), OR
  give the family-form `lem:injective_cech_acyclic` a `\lean{}` list covering the chain. The 38 public
  names: `coverInterOpenFam`, `coverInterOpen_comp_leFam`, `cechFreeSimplicialFam`,
  `cechFreePresheafComplexFam`, `cechFreePresheafComplex_XFam`, `cechFreeAugFam`,
  `coverStructurePresheafFam`, `cechFreeComplexAugFam`, `cechFreeComplexAug_f_zeroFam`,
  `cechFreeEval_XFam`, `cechFreeEval_isZero_of_isEmptyFam`,
  `coverStructurePresheaf_eval_isZero_of_isEmptyFam`, `cechFreeEval_quasiIso_of_isEmptyFam`,
  `le_coverInterOpen_iffFam`, `survivingEquivFam`, `cechFreeEvalDropZerosFam`, `cechFreeEvalEngine_XFam`,
  `cechEngineXFam`, `cechEngineDFam`, `cechEngineD_ιFam`, `cechEngineD_compFam`, `cechEngineComplexFam`,
  `cechEnginePrependFam`, `cechEnginePrepend_ιFam`, `cechEnginePrepend_specFam`, `cechEngineD_exactFam`,
  `cechEngineComplex_exactAtFam`, `cechEngineAug0Fam`, `cechEngineAug0_ιFam`, `cechEngineD_comp_augFam`,
  `cechEngineComplexAugFam`, `cechEngineAug0_splitFam`, `cechEngineComplexAug_f_zeroFam`,
  `cechEngineComplexAug_quasiIsoFam`, `cechFreeEvalEngineIsoFam`, `coverStructurePresheafEval_isoFam`,
  `cechFreeEval_quasiIso_of_nonemptyFam`, `cechFreeComplex_quasiIsoFam`.
  (12 private helpers also unmatched: `cechFreeSimplicial_δ_comp_augFam`, `cechFree_d_comp_augFam`,
  `cechFree_d_comp_factorThruImageFam`, `cechFreeEval_X_ι_invFam`, `cechFreeEvalEngine_X_inv_hom_ιFam`,
  `cechFree_d_ιFam`, `cechFreeEvalEngine_map_ιFam`, `cechFreeEvalEngine_commFam`,
  `cechFreeEvalEngineIso_hom_fFam`, `cechFreeAug_eval_eqFam`, `epi_cechEngineAug0Fam`,
  `coverStructurePresheafEval_iso_homFam`.)
  Proofs rely on the same facts as the `X.OpenCover` originals (objectwise `quasiIso_of_evaluation` +
  `FreeCechEngine` contracting homotopy + engine iso).

**(c) 3 QcohTilde decls** — natural home near `lem:qcoh_iso_tilde_sections` / `rem:o1i8_decomposition`:
  - `free_isQuasicoherent` — free `𝒪_{Spec R}`-module is qcoh (Mathlib `tildeFinsupp` + iso-closure).
  - `isIso_fromTildeΓ_of_genSections` — 01I8 steps (2)–(3): two global generating families ⟹
    `IsIso fromTildeΓ`; suggested `\uses{lem:isIso_fromTildeGamma_of_presentation}`.
  - `qcoh_iso_tilde_sections_of_genSections` — `F ≅ ~(ΓF)` from two generating families.

## 4. Reusable proof patterns discovered (added to PROJECT_STATUS Knowledge Base)
- **Cover-agnostic re-parameterization by PURE ADDITION, not delegation** — keep originals
  byte-identical when downstream `dsimp`-unfolds them; a delegating wrapper breaks the one-layer
  unfold (`Sigma.ι_desc` can't fire).
- **01I8 steps (2)–(3) packaging** — `have P : F.Presentation := {generators := σ, relations := τ}` in
  TACTIC mode (term-mode defaults universes to 0) → `isIso_fromTildeΓ_of_presentation`; `free` qcoh via
  `tildeFinsupp` + `prop_of_iso` with `.{u}`.

## 5. Watch (for progress-critic iter-031, MANDATORY per iter-030 plan)
- Route A (re-param): RESOLVED on the FreePresheafComplex side — the next CechBridge family lane should
  converge (mirrors an existing axiom-clean proof). Not a churn risk.
- Route B (01I8): genuinely STUCK without a multi-iter affine-global-generation build. Do not loop
  body-fills on it; if attempted, it needs effort-breaking + ideally the informal-LLM helper.

## 6. Blueprint-doctor: clean (no orphan chapters, no broken `\ref`/`\uses`).
