# Recommendations for iter-017 plan

## CRITICAL / must-fix-this-iter (blueprint reconciliations — block the next P3b prover)
From `lean-vs-blueprint-checker-presheafcech`. These must be fixed via a **blueprint-writer** on
`Cohomology_CechHigherDirectImage.tex` BEFORE dispatching a prover at `cechComplex_hom_identification`:
1. **`def:section_cech_complex`**: prose says "cochain complex of $\mathcal{O}_X(U)$-modules", but
   the landed Lean `sectionCechComplex` is `CochainComplex Ab ℕ` (abelian groups), which matches the
   chapter's own quoted Stacks source ("This is an abelian group"). Change prose → abelian groups.
   (`% NOTE` already placed inline this iter.)
2. **`lem:cech_complex_hom_identification`**: same fix — the isomorphism is "of cochain complexes of
   abelian groups", not O_X(U)-modules. The Lean per-term building block is `freeYonedaHomAddEquiv`
   (an `AddEquiv`). Reconcile statement + proof prose. (`% NOTE` already placed inline.)
   The proof sketch itself is otherwise adequate.

## HIGH — coverage debt (19 unmatched `lean_aux` nodes; planner to bundle into `\lean{}` lists)
`archon dag-query unmatched` lists 19 helpers with no blueprint entry. Bundle each into the
existing related declaration's multi-name `\lean{...}` list (bundling pattern), do not author new
environments. Grouping:
- **into `lem:cech_acyclic_affine`** (9, the Dependent L3 port; `AlgebraicGeometry.CombinatorialCech.`):
  `comp_succAbove_swap`, `cons_comp_zero_succAbove`, `depDiff`, `depDiff_comp`,
  `depDiff_eq_of_cocycle`, `depDiff_exact`, `depHomotopy`, `depHomotopy_spec`, `depTransport`.
- **into `def:cech_free_presheaf_complex`** (7; `AlgebraicGeometry.`): `freeYoneda`, `coverOpen`,
  `coverInterOpen`, `coverInterOpen_comp_le`, `cechFreeSimplicial`, `cechFreePresheafComplex_X`,
  `sigma_ι_eqToHom_transport`.
- **into `def:section_cech_complex`** (1): `sectionCechCosimplicial`.
- **into `lem:cech_complex_hom_identification`** (2): `freeYonedaHomEquiv_apply`,
  `freeYonedaHomAddEquiv` (the latter is the must-fix #2's building block — add it as part of that fix).

## HIGH — closest-to-completion next prover targets (both NOW unblocked, prefer these over L1)
1. **`cechComplex_hom_identification`** (PresheafCech.lean): was cross-file blocked on
   `cechFreePresheafComplex` — **that landed this iter**, so the joint step is now buildable.
   Recipe (from PresheafCech task_result): per-degree Ab-iso
   `AddGrp.of(K(𝒰)_p ⟶ F) ≅ (sectionCechComplex U F).X p` from `freeYonedaHomAddEquiv` +
   biproduct-hom-as-product, intertwine differentials, assemble via
   `HomologicalComplex.Hom.isoOfComponents`. **Do the blueprint reconciliation (must-fix above) first.**
   NOTE: requires importing `FreePresheafComplex.lean` into `PresheafCech.lean` (or merging) — a
   structural decision for the planner (refactor subagent).
2. **`cechFreeComplex_quasiIso`** (FreePresheafComplex.lean): route validated
   (`evaluation.PreservesHomology` by `inferInstance`). Needs FIRST a definitional task + blueprint
   block: the augmentation object `O_𝒰` (image presheaf of `∐_i freeYoneda(U_i) →
   PresheafOfModules.unit`) and the augmentation chain map. Then a sectionwise prepend-`i_fix`
   contracting homotopy — **the same combinatorial content as `CombinatorialCech.*` L3** in
   CechAcyclic.lean; consider factoring/porting that skeleton rather than re-deriving. Dispatch a
   blueprint-writer for the `O_𝒰` augmentation block before the prover.

## DO NOT retry as a body-fill — `CechAcyclic.affine` (L1)
The dependent L3 port + L2 certifier are now complete; the **only** remaining blocker is the L1
categorical→module bridge, which is genuinely **missing infrastructure**, not a tactic gap. Do NOT
re-dispatch `CechAcyclic.affine` in `prove` mode expecting a body fill — it has been the same blocker
since iter-011/015. Instead:
- Open L1 as a dedicated **mathlib-build / new-file** lane: bottom-up build (a) sections of
  `pushPullObj F` over basic opens = `IsLocalizedModule.Away` of `Γ(Spec R,F)` (via `tilde` +
  quasicoherence), (b) `relativeCechComplexOfNerve` differential = alternating localisation coboundary
  (= `depDiff` for the concrete `δ`), (c) `IsZero (homology p) ↔ Function.Exact` for cochain complexes
  in `S.Modules`. Then `CechAcyclic.affine` is a short assembly:
  `exact_of_isLocalized_span (Set.range s) hs` + `CombinatorialCech.Dependent.depDiff_exact` per node.
- Recommend a **mathlib-analogist** (api-alignment) pass first on the section-localisation bridge
  (`Scheme.Modules`/`SheafOfModules` sections over basic opens ↔ away localisation) to confirm the
  Mathlib idiom before committing the lane — the strategy notes flag `Scheme.Modules` sheaf
  cohomology as ABSENT in Mathlib.

## MEDIUM — blueprint coverage gaps (blueprint-writer, same chapter)
From `lean-vs-blueprint-checker-freepresheafcomplex`:
- `def:cech_free_presheaf_complex`: add the `[Finite 𝒰.I₀]` hypothesis to the definition block
  (required by the Lean for `HasCoproductsOfShape`; currently absent from prose).
- Add `\lean{}` hints for the substantive backbone decls `freeYoneda`, `coverInterOpen`,
  `cechFreeSimplicial` (covered by the HIGH bundling item above).
- Coproduct vs biproduct is NOT a problem (lvb-checker confirmed notation drift only) — no action.

## MEDIUM — stale comment cleanup (9 major findings, lean-auditor; NOT review-agent-fixable)
`.lean` comment blocks misrepresent project state (describe proved decls as "remaining"). Review
agent cannot edit `.lean`. Dispatch a **refactor** subagent (or fold into the next prover's brief for
each file) to fix:
- `AcyclicResolution.lean:26–31` (module docstring "will be constructed" — all proved);
  `AcyclicResolution.lean:924–963` (iter-006 status block calls `rightDerivedIsoOfAcyclicResolution`
  "REMAINING" — proved at 893–922).
- `CechHigherDirectImage.lean:85–86, 166, 245–293, 410–449, 744` (`pushPullMap_comp`/`CechNerve`
  described as open holes — all proved).
- `PresheafCech.lean:19–24` and `:46–50` (module docstring + planner comment list non-existent decls
  / a `ModuleCat`-valued type never built; actual is `Ab`).
- `FreePresheafComplex.lean:19–22` (docstring claims it "owns" `cechFreeComplex_quasiIso`, absent).
Full list: `.archon/task_results/lean-auditor-iter016.md` (Major section).

## Reusable proof patterns (for the Knowledge Base / next provers)
- **Dependent-coefficient combinatorial Čech**: abstract restriction maps as additive `δ`/`c` + 3
  compat hypotheses (`hu`/`hsh`/`hcomm`); cancellation + `d²=0` transfer from the constant case;
  `depTransport` (`subst;rfl`) isolates transport friction.
- **Simplicial/cosimplicial object over `Sigma`/`Pi` of representables**: `*.hom_ext` + `ι_desc`/
  `lift_π` + `eqToHom`-transport helper + `Subsingleton.elim` on thin-category (Opens X) homs; then
  `alternating{Face,Coface}MapComplex` gives `d²=0` free.
- **`PresheafOfModules.evaluation.PreservesHomology`** by `inferInstance` → objectwise/sectionwise
  homology for presheaf-of-modules complexes.
