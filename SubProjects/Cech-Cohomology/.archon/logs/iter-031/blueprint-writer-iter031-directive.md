# blueprint-writer directive — iter-031

Chapter to edit: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter,
`% archon:covers` all 10 Cohomology files). THREE jobs. Do NOT touch `\leanok` markers (sync owns them).
Do NOT add `\mathlibok` except where explicitly named below. Source-citation discipline applies: every
new statement/proof deriving from a source needs `% SOURCE:` + `% SOURCE QUOTE:` (verbatim, original
notation) + visible `\textit{Source: …}`. The only source files you need are ALREADY local — quote from
`references/stacks-schemes.tex` (you may open it to copy verbatim text). Do NOT invent sources.

---

## JOB 1 — clear coverage debt (50 `…Fam` decls + 3 QcohTilde decls), MECHANICAL

iter-030's prover added 50 family-parameterized `…Fam` mirrors of the already-blueprinted
`X.OpenCover` free-Čech chain (in `FreePresheafComplex.lean`) and 3 QcohTilde decls. They are all
axiom-clean but have NO blueprint entry (`archon dag-query unmatched` lists them). Bundle each into an
EXISTING block's `\lean{...}` list — do NOT create new blocks for the Fam decls. The rule: each
`fooFam` is the raw-finite-family `{ι}[Finite ι](U : ι → Opens X)` mirror of `foo`; add `…Fam` to the
`\lean{...}` list of whatever block already pins `foo`. Match by stripping the `Fam` suffix.

The 50 Fam decls (append each to the block pinning its non-`Fam` analog):
`coverInterOpenFam, coverInterOpen_comp_leFam` → block of `coverInterOpen` (def:cover_structure_presheaf
or wherever `coverInterOpen` is pinned — search the chapter for `coverInterOpen`);
`cechFreeSimplicialFam, cechFreeSimplicial_δ_comp_augFam` → `def:cech_free_presheaf_complex`;
`cechFreePresheafComplexFam, cechFreePresheafComplex_XFam` → `def:cech_free_presheaf_complex`;
`cechFreeAugFam, cechFreeAug_eval_eqFam, coverStructurePresheafFam,
coverStructurePresheaf_eval_isZero_of_isEmptyFam` → `def:cover_structure_presheaf`;
`cechFreeComplexAugFam, cechFreeComplexAug_f_zeroFam, cechFree_d_comp_augFam,
cechFree_d_comp_factorThruImageFam, cechFree_d_ιFam` → `def:cech_free_presheaf_complex` or the
augmentation block (search `cechFreeComplexAug`);
`quasiIso_of_evaluation` already pinned — its Fam consumers below;
`cechFreeEval_XFam, cechFreeEval_X_ι_invFam, cechFreeEval_isZero_of_isEmptyFam,
cechFreeEval_quasiIso_of_isEmptyFam` → `lem:cech_free_eval_sectionwise` / `lem:cech_free_eval_empty`;
`le_coverInterOpen_iffFam, survivingEquivFam, cechFreeEvalDropZerosFam, cechFreeEvalEngine_XFam,
cechEngineXFam, cechEngineDFam, cechEngineD_ιFam, cechEngineD_compFam, cechEngineComplexFam,
cechEnginePrependFam, cechEnginePrepend_ιFam, cechEnginePrepend_specFam, cechEngineD_exactFam,
cechEngineComplex_exactAtFam, cechEngineAug0Fam, cechEngineAug0_ιFam, cechEngineD_comp_augFam,
cechEngineComplexAugFam, cechEngineAug0_splitFam, cechEngineComplexAug_f_zeroFam,
cechEngineComplexAug_quasiIsoFam, epi_cechEngineAug0Fam` → `lem:cech_engine_complex` / `lem:free_cech_engine`;
`cechFreeEvalEngineIsoFam, cechFreeEvalEngineIso_hom_fFam, cechFreeEvalEngine_X_inv_hom_ιFam,
cechFreeEvalEngine_map_ιFam, cechFreeEvalEngine_commFam, coverStructurePresheafEval_isoFam,
coverStructurePresheafEval_iso_homFam` → `lem:cech_free_eval_engine_iso`;
`cechFreeEval_quasiIso_of_nonemptyFam` → `lem:cech_free_eval_nonempty`;
`cechFreeComplex_quasiIsoFam` → `lem:cech_free_complex_quasi_iso`.
(If any name's home block is ambiguous, grep the chapter for the non-`Fam` name; it is pinned in exactly
one block. The full authoritative list + grouping is in `.archon/task_results/FreePresheafComplex.md`
under "Needs blueprint entry".) In each touched block, add a ONE-SENTENCE note that the `…Fam` decls are
the cover-agnostic raw-finite-family mirror (no covering hypothesis), used by the family-form
`injective_cech_acyclic`. No new `\uses` edges needed (they mirror the same dependencies).

The 3 QcohTilde decls (iter-030): `free_isQuasicoherent`, `isIso_fromTildeΓ_of_genSections`,
`qcoh_iso_tilde_sections_of_genSections`. Create SMALL blocks for these near
`lem:qcoh_iso_tilde_sections` (they belong to the Route-P chain you build in JOB 3): `free_isQuasicoherent`
= "the free 𝒪-module is quasi-coherent" (proof: `free ι ≅ tilde(ι→₀R)` + tilde-qcoh + iso-closure;
Mathlib `tildeFinsupp`); `isIso_fromTildeΓ_of_genSections` = "two GLOBAL generating families σ:GeneratingSections,
τ:(ker σ.π).GeneratingSections ⟹ IsIso fromTildeΓ" (builds a Presentation, feeds
`isIso_fromTildeΓ_of_presentation`) — this is P4; `qcoh_iso_tilde_sections_of_genSections` = "F≅~ΓF from
the two generating families". Pin each with `\lean{AlgebraicGeometry.<name>}` and accurate `\uses`.

---

## JOB 2 — add the CechBridge family-form pins (tex precedes lean; THIS iter's Route-A lane creates them)

iter-031's CechBridge prover lane builds the family-parameterized `injective_cech_acyclic` consuming
`cechFreeComplex_quasiIsoFam`. The blueprint statement `lem:injective_cech_acyclic` (line ~2572) is
already general — just ADD the expected family decl name `AlgebraicGeometry.injective_cech_acyclicFam`
to its `\lean{...}` list, and add a one-sentence note that the family form is over a raw finite family
`{ι}[Finite ι](U : ι → Opens X)` with NO covering hypothesis (the cover-agnostic form 02KG consumes over
standard covers of arbitrary `D(f)`). Likewise, if `lem:section_cech_complex_mapop_iso` (line ~2516)
gets a family mirror, add `AlgebraicGeometry.sectionCechComplexMapOpIsoFam`. (If the prover names them
differently, next iter reconciles — pin the convention-expected names now to keep `unmatched` at 0.)

---

## JOB 3 — expand `rem:o1i8_decomposition` into the Route-P `\uses`-chain (the substantive job)

A Mathlib-analogist consult (`analogies/o1i8-qcoh-tilde-route.md`, read it) decisively selected
**Route P (global generation, Hartshorne II.5.14-17 / Stacks 01I8)** for the missing instance
`[IsQuasicoherent F] → IsIso F.fromTildeΓ`, and REJECTED Route G (module gluing) because Mathlib has no
`Module.GlueData` and effective faithfully-flat descent is an explicit Mathlib TODO. Mathlib's
`isIso_fromTildeΓ_iff` reduces the goal to `F ∈ essImage(tilde)`. Currently `rem:o1i8_decomposition`
(line ~3621) is a 3-step prose remark with NO named sub-lemmas — turn it into a real `\uses`-linked chain
of five blocks P0–P4, each with `\lean{...}` (names the provers will create), `\uses{...}`, source anchor,
and a textbook-level informal proof. Keep the remark itself as the overview that `\uses` the chain.

The chain (anchor ALL of it to `references/stacks-schemes.tex`, the section "Quasi-coherent sheaves on
affine schemes", which you must open and quote verbatim — it contains every supporting fact):

- **P0 `lem:exists_finite_basicOpen_subcover`** (THIS-ITER LANE — must be COMPLETE + CORRECT). Pure
  topology, no sheaf math. Statement: for `U : ι → (Spec R).Opens` with `⨆ i, U i = ⊤`, there exist
  finitely many `f : Fin n → R` and `φ : Fin n → ι` with `basicOpen (f j) ≤ U (φ j)` and
  `Ideal.span (range f) = ⊤`. `\lean{AlgebraicGeometry.exists_finite_basicOpen_subcover}`.
  Proof: basic opens form a basis (`PrimeSpectrum.isBasis_basic_opens`), refine the cover to basic opens
  each inside a `U i`; `Spec R` is quasi-compact (`PrimeSpectrum.compactSpace`,
  `IsCompact.elim_finite_subcover`) so finitely many suffice; the finite basic-open family covering ⊤ ⟺
  span = ⊤ (`PrimeSpectrum.iSup_basicOpen_eq_top_iff`). SOURCE-anchor to stacks-schemes.tex L1289–1301
  ("Since every standard open $D(f)$ is quasi-compact … refine this covering to a standard open
  covering"). `\uses{}` may be empty (pure Mathlib topology).
- **P1 `lem:qcoh_localized_sections`** (localized sections for qcoh; the load-bearing core; GAP). For a
  qcoh `F` on `Spec R` and `f : R`, the restriction `Γ(X,F) → Γ(D(f),F)` is
  `IsLocalizedModule (.powers f)`. Proof: on the P0 finite basic-open cover, `F` is locally `~Mᵢ` (the
  `QuasicoherentData` presentation on `D(fᵢ)`=`Spec R_{fᵢ}` gives `F.over D(fᵢ) ≅ tilde Mᵢ` via
  `isIso_fromTildeΓ_of_presentation`); sections of `tilde Mᵢ` over `D(g)` localize
  (Mathlib `tilde.toOpen` is `IsLocalizedModule (.powers …)`, and stacks-schemes.tex L1241–1276
  `lemma-widetilde-pullback`: `Γ(D(f),~M)=M_f`); patch with the sheaf condition over the finite cover.
  `\uses{lem:exists_finite_basicOpen_subcover, lem:qcoh_iso_tilde_sections_of_presentation}`. Anchor to
  stacks-schemes.tex L1241–1276 + L1278–1387.
- **P2 `lem:qcoh_global_generation`** (global generation; GAP, depends on P1). A qcoh `F` on `Spec R`
  admits a global epi `𝒪_X^{(I)} ↠ F`, i.e. a `F.GeneratingSections`: each local generator on `D(fⱼ)`,
  multiplied by a power of `fⱼ` (the surjectivity half of P1's `IsLocalizedModule`), extends to a global
  section; finitely many opens (P0) give a global generating family.
  `\uses{lem:qcoh_localized_sections, lem:exists_finite_basicOpen_subcover}`. Anchor: stacks-schemes.tex
  (the equivalence proof) — and note this is Hartshorne II.5.16-17 / Stacks 01I8 global generation.
- **P3 `lem:qcoh_kernel_qcoh`** (kernel of a generating epi is qcoh, hence globally generated; GAP).
  `kernel σ.π` for `σ : F.GeneratingSections` is again qcoh on `Spec R` (locally `tilde(ker)`, using that
  the tilde functor is EXACT / preserves kernels — record this as the sub-gap
  `lem:tilde_preserves_kernels`, NOT in Mathlib, stacks-schemes.tex L1418–1432
  `lemma-kernel-cokernel-quasi-coherent` + "exactness of the functor ~"); then qcoh ⟹ globally generated
  by P2, giving `τ : (kernel σ.π).GeneratingSections`. `\uses{lem:qcoh_global_generation,
  lem:tilde_preserves_kernels}`. Anchor: stacks-schemes.tex L1418–1432.
  Add the sub-gap block **`lem:tilde_preserves_kernels`** ("tilde.functor preserves kernels / is exact",
  anchored to stacks-schemes.tex L1426 + `lemma-spec-sheaves` 01HV exactness of ~; note Mathlib has
  tilde additive + colimit-preserving but NOT `PreservesFiniteLimits`, so this is a project gap-fill).
- **P4 `lem:isIso_fromTildeGamma_of_quasicoherent`** (the TARGET instance). `[IsQuasicoherent F] → IsIso
  F.fromTildeΓ` on `Spec R`: feed σ (P2) and τ (P3) to `isIso_fromTildeΓ_of_genSections` (the JOB-1
  block). `\lean{AlgebraicGeometry.isIso_fromTildeΓ_of_quasicoherent}` (instance the prover will create).
  `\uses{lem:qcoh_global_generation, lem:qcoh_kernel_qcoh, lem:isIso_fromTildeGamma_of_genSections}`.
  This is what upgrades `lem:qcoh_iso_tilde_sections` to the unconditional qcoh form (update that block's
  `% NOTE` to point at P4 as the discharge once built; do NOT delete the conditional-form note yet).

Record explicitly (prose, not a marker) that Route G (module gluing) was rejected — no `Module.GlueData`
in Mathlib, effective descent is a Mathlib TODO — so the chain deliberately takes the global-generation
route. Keep `rem:o1i8_decomposition` as the overview block whose `\uses{}` names P0–P4.

After all three jobs: verify the chapter has no broken `\uses` (every referenced label exists), and that
P0's block is fully self-contained (a prover will formalize it this iter from the block alone).
