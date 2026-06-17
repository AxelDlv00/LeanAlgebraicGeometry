# DAG Walker Directive

## Slug
cohom-ssmk

## Seed
thm:Scheme_module_finite_globalSections_of_isProper

## Strategy context
You are a child of the `cohom-rr` dag-walker, which is wiring the whole
Cohomology + RiemannRoch region into one dependency cone under the
Riemann--Roch genus-zero head. This chapter
(`Cohomology_StructureSheafModuleK.tex`) is the foundational layer: it builds
the structure sheaf as a sheaf of `k`-modules, sheafification / Ext existence,
the `ModuleCat k`-valued sheaf-cohomology functors `HModule`/`HModule_prime`,
the constant-sheaf / global-sections linear equivalences, the Čech cochain /
Čech cohomology definitions, and the finiteness / vanishing results
(`module_finite_HModule*`, `IsAffineHModuleVanishing`, `IsHModuleHomFinite`)
that the Mayer--Vietoris chapter and the Riemann--Roch Euler-characteristic
chapter consume.

## Depth / scope
**Your write domain is ONLY
`blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`.**
Do NOT edit any other chapter. You MAY add `\uses{}` edges pointing at labels in
other chapters (e.g. Čech acyclicity facts in
`Cohomology_CechHigherDirectImage.tex`) — those labels already exist on disk.

### CRITICAL MECHANICAL FACT (verified this iteration)
The leandag graph builder reads `\uses{...}` **only from the statement block**
(the `\begin{lemma/theorem/definition/...}` environment carrying the `\label{}`),
**NOT from the `\begin{proof}` block.** Many nodes here show as isolated
(`dep=0`) despite having proof prose that clearly uses earlier results.
Therefore, for every node, ensure the **statement block** (right after its
`\label{}` / `\lean{}`) carries a `\uses{...}` listing every dependency its
statement and proof actually invoke. If a `\uses{}` already exists only in the
proof, copy it up to the statement block.

### Your job
Walk every isolated node in `Cohomology_StructureSheafModuleK.tex` and give its
statement block a complete `\uses{}`, reading each block's statement + proof
prose to determine the real dependencies. The build is layered:
1. structure sheaf as a sheaf of k-modules:
   `def:Scheme_kToSection`, `def:Scheme_algebraSection`,
   `lem:Scheme_algebraMap_eq_kToSection`, `*_naturality`,
   `def:Scheme_toModuleKPresheaf`, `lem:Scheme_toModuleKPresheaf_obj`,
   `thm:Scheme_toModuleKPresheaf_isSheaf`, `def:Scheme_toModuleKSheaf`,
   `def:Scheme_toModuleKSheaf_forgetCompare`;
2. sheafification / Ext existence:
   `thm:HasSheafify_Opens_ModuleCatK`, `thm:HasExt_Sheaf_Opens_ModuleCatK`;
3. cohomology functors and zero-degree equivalences:
   `def:Scheme_HModule` (already partly wired), `def:Scheme_HModule_prime`,
   `def:Scheme_HModule_zero_linearEquiv`, `def:Scheme_HModule_prime_zero_linearEquiv`,
   adjunction-linearity lemmas (`lemma:Adjunction_left/right_adjoint_linear`,
   `def:Adjunction_homLinearEquiv`), `def:Scheme_constantSheafGammaHom_linearEquiv`,
   `def:Scheme_homFromOne_linearEquiv`, `thm:Scheme_SheafGammaObj_linearEquiv_top`;
4. Čech machinery: `def:Scheme_cechCochain(_OC)`, `def:Scheme_cechCohomology(_OC)`,
   `thm:Scheme_cechCochain_OC_eq`, `thm:Scheme_cechCohomology_OC_eq`,
   `def:Scheme_IsCechAcyclicCover`,
   `thm:Scheme_subsingleton_HModule_prime_supr_of_isCechAcyclicCover(_curve)`;
5. finiteness/vanishing: the `IsAffineHModuleVanishing` /
   `IsAffineHModuleHomFinite` / `IsHModuleHomFinite` instances and the
   `module_finite_HModule(_prime)(_zero)(_of_*)(_curve)` transfer chain, up to
   `thm:Scheme_module_finite_globalSections_of_isProper` and
   `thm:Scheme_module_finite_gammaObj_of_isProper`.
Wire each `_curve` variant to its non-`_curve` counterpart; wire each
`_of_<hypothesis>` theorem to the hypothesis-providing instance/def.

After editing, re-run `archon dag-query node --node <label> --json` on the heads
to confirm `dep_count > 0`.

## Constraints
- Do NOT add `\leanok`. Do NOT add `\mathlibok` unless a node genuinely
  re-exports a real named Mathlib declaration (most are proved directly in
  Lean — just add `\uses{}`).
- Do NOT invent mathematics or rewrite proofs.
- Keep valid LaTeX. Any real-statement node lacking `\lean{}` and not a
  `\begin{remark}`: add `\lean{AlgebraicGeometry.TODO.<name>}`.

## References
None needed unless a block already carries a `% SOURCE` comment you extend.

## Report
Write to `.archon/task_results/dag-walker-cohom-ssmk.md` per the standard
DAG-walker report format.
