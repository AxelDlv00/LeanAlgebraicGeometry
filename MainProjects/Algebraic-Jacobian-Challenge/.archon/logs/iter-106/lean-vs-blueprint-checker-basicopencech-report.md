# Lean ↔ Blueprint Check Report

## Slug
basicopencech

## Iteration
105

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` (1793 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_MayerVietoris.tex` (1185 lines)

## Scope note

The chapter covers three cohort files: `MayerVietorisCore.lean`,
`MayerVietorisCover.lean`, and this file. I audit only blueprint blocks
whose `\lean{...}` targets `AlgebraicGeometry.Scheme.<name>` for a `<name>`
defined in `BasicOpenCech.lean`. Blueprint blocks for the other cohort
files are out of scope and handled by their own checker dispatches.

## Per-declaration

In-scope blueprint blocks (chapter §`basic_open_infrastructure` +
§`basic_open_acyclicity`):

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover}` (chapter `def:Scheme_basicOpenCover`, blueprint L949)
- Lean target exists: yes — `BasicOpenCech.lean:55`.
- Signature matches: yes — `s → Opens` sending `f ↦ C.left.basicOpen f.1`. Matches prose "$f \in s \mapsto D(f)$".
- Proof follows sketch: N/A (definition).
- notes: noncomputable; parameterised by the project's `C : Over (Spec (.of k))` convention as expected.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_supr_of_span_eq_top}` (chapter `thm:Scheme_basicOpenCover_supr_of_span_eq_top`, blueprint L955)
- Lean target exists: yes — `BasicOpenCech.lean:73`.
- Signature matches: yes — `IsAffineOpen U → Ideal.span s = ⊤ → ⨆ i, basicOpenCover s i = U`.
- Proof follows sketch: yes — `hU.iSup_basicOpen_eq_self_iff.mpr hs`.
- notes: thin Mathlib wrapper, matches blueprint's "standard characterisation".

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_isAffineOpen}` (chapter `thm:Scheme_basicOpenCover_isAffineOpen`, blueprint L970)
- Lean target exists: yes — `BasicOpenCech.lean:91`.
- Signature matches: yes.
- Proof follows sketch: yes — `hU.basicOpen i.1`.

### `\lean{AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen}` (chapter `thm:Scheme_hasAffineCechAcyclicCover_of_basicOpen`, blueprint L986)
- Lean target exists: yes — `BasicOpenCech.lean:117`.
- Signature matches: yes — destructures per-affine existence of a spanning set with both Čech-acyclic + comparison-iso evidence.
- Proof follows sketch: yes — bundles `basicOpenCover_supr_of_span_eq_top` into the existential carrier.

### `\lean{AlgebraicGeometry.Scheme.hasAffineCechAcyclicCover_of_basicOpen_curve}` (chapter `thm:Scheme_hasAffineCechAcyclicCover_of_basicOpen_curve`, blueprint L1000)
- Lean target exists: yes — `BasicOpenCech.lean:139`.
- Signature matches: yes — direct curve specialisation at `F := toModuleKSheaf C`.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_inter_eq_basicOpen_mul}` (chapter `thm:Scheme_basicOpenCover_inter_eq_basicOpen_mul`, blueprint L1019)
- Lean target exists: yes — `BasicOpenCech.lean:164`.
- Signature matches: yes — `𝒰 i ⊓ 𝒰 j = C.left.basicOpen (i.1 * j.1)`.
- Proof follows sketch: yes — `(Scheme.basicOpen_mul …).symm`.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_inter_isAffineOpen}` (chapter `thm:Scheme_basicOpenCover_inter_isAffineOpen`, blueprint L1034)
- Lean target exists: yes — `BasicOpenCech.lean:187`.
- Signature matches: yes.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_eq_basicOpen_prod}` (chapter `thm:Scheme_basicOpenCover_finset_inf_eq_basicOpen_prod`, blueprint L1049)
- Lean target exists: yes — `BasicOpenCech.lean:222`.
- Signature matches: yes — `t.inf' h (basicOpenCover s) = C.left.basicOpen (∏ i ∈ t, i.1)`.
- Proof follows sketch: yes — `Finset.cons_induction` with binary case from the previous theorem, matching prose "induction on the finite subset, using the binary case".
- notes: blueprint label string `_inf_` (single primed) vs Lean name `_inf'_`; the `\lean{...}` hint pins the correct Lean name so this is a label-vs-Lean-name asymmetry only, not a mismatch.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_isAffineOpen}` (chapter `thm:Scheme_basicOpenCover_finset_inf_isAffineOpen`, blueprint L1067)
- Lean target exists: yes — `BasicOpenCech.lean:261`.
- Signature matches: yes.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_le}` (chapter `thm:Scheme_basicOpenCover_finset_inf_le`, blueprint L1082)
- Lean target exists: yes — `BasicOpenCech.lean:296`.
- Signature matches: yes.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_finset_inf'_isLocalization}` (chapter `thm:Scheme_basicOpenCover_finset_inf_isLocalization`, blueprint L1097)
- Lean target exists: yes — `BasicOpenCech.lean:330`.
- Signature matches: yes — `IsLocalization.Away (∏ i ∈ t, i.1) Γ(C.left, V)` with the algebra structure threaded via `presheaf.map _.op).hom.toAlgebra`, matching prose "with the algebra structure given by the presheaf restriction map".
- notes: the explicit `@`-algebra binding is documented inline in the Lean docstring; this is the iter-058 plan-confirmed shape. No prose-vs-Lean divergence.

### `\lean{AlgebraicGeometry.Scheme.splitEpi_pi_lift_of_injective}` (chapter `def:Scheme_splitEpi_pi_lift_of_injective`, blueprint L1121)
- Lean target exists: yes — `BasicOpenCech.lean:362`.
- Signature matches: yes — `SplitEpi (Pi.lift (fun b ↦ Pi.π M (f b)))` from `Function.Injective f`.
- Proof follows sketch: yes — section by `by_cases ∃ b, f b = a` then `dif_pos`/`dif_neg`; transport via `h.choose_spec ▸ Pi.π …`; matches prose "Choose a retraction of $f$ ..., extend families on $B$ to families on $A$ by the chosen values on the complement".

### `\lean{AlgebraicGeometry.Scheme.cechCohomology_subsingleton_of_cechCochain_exactAt}` (chapter `thm:Scheme_cechCohomology_subsingleton_of_cechCochain_exactAt`, blueprint L1139)
- Lean target exists: yes — `BasicOpenCech.lean:404`.
- Signature matches: yes — `ExactAt n → Subsingleton (cechCohomology … n)`. Blueprint prose says "$n \ge 1$" but the Lean omits an explicit `1 ≤ n`; the prose's restriction is operational only (the consumer adds `hn : 0 < n` separately). Acceptable.
- Proof follows sketch: yes — chains `ExactAt.isZero_homology` with `ModuleCat.subsingleton_of_isZero`.

### `\lean{AlgebraicGeometry.Scheme.basicOpenCover_isCechAcyclicCover_toModuleKSheaf}` (chapter `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`, blueprint L1153)
- Lean target exists: yes — `BasicOpenCech.lean:1170`.
- Signature matches: yes — `IsCechAcyclicCover (toModuleKSheaf C) (basicOpenCover s)` from `IsAffineOpen U` and `Ideal.span s = ⊤`. Matches prose "Čech cohomology vanishes for every $n \ge 1$"; the `n ≥ 1` constraint is structural (lives in `IsCechAcyclicCover.subsingleton_cechCohomology`'s `hn` argument).
- Proof follows sketch: in progress (six labelled `sorry`s remain; see directive's "Known issues"). The mapping is:
  - Blueprint Step 3 "Contraction by extra degeneracy" ↔ Lean substep (a) `h_a` (L1212) and `h_a₀` (L1564).
  - Blueprint Step 2 "Identification of the localized complex" ↔ Lean substep (b1)/(b2) (the R-linearity scaffolding via `cechCofaceMap_pi_smul`, `f_R.map_smul'` L1733/`g_R.map_smul'` L1754, and `h_loc_exact` L1783).
  - Blueprint Step 1 "Reduction to per-generator local exactness" + Step 4 "Globalization" ↔ Lean `exact_of_localized_span` at L1786.
  - Blueprint Remark `rem:basic_open_cech_finite_subspanning` ↔ Lean `hs_fin` finite-subspanning extraction at L1377 plus the iter-064/065 transport `h_transport` (L1418, closing sorry at L1536).
- notes: the Lean proof faithfully splits along the four blueprint steps. The transport `K → K₀` (Lean L1418–L1536) is introduced because the Lean side needs a *finite* index to commute localization with products; the blueprint's Remark `rem:basic_open_cech_finite_subspanning` (L1173–L1176) authorizes this reduction.

## Red flags

None in this iteration. All six remaining `sorry`s (L1120, L1212, L1536, L1564, L1754, L1783) are explicitly endorsed by the directive as known transient substeps, each guarded by a structured `have …` whose statement is mathematically correct and whose surrounding prose names the missing computational step. No `:= rfl` / `:= True` / `Classical.choice _` placeholders, no excuse-comments dressing up wrong code, no unauthorized `axiom` introductions.

## Unreferenced declarations (informational)

Helper declarations in `BasicOpenCech.lean` with no `\lean{...}` reference in the chapter. All are proof-scaffolding for the R-linearity transport needed by `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`; none claim a standalone mathematical statement the blueprint would need to expose:

- `presheafMap_restrict_collapse` (L425) — restriction-chain collapse `Γ(U) → Γ(W) → Γ(V) = Γ(U) → Γ(V)`; pure presheaf manipulation.
- `cechCofaceMap_summand_family` (L454) — names the anonymous `Pi.lift` summand of the expanded Čech differential so its head symbol is a defined constant rather than a closure. Pure HOU-avoidance scaffolding (iter-102).
- `cechCofaceMap_summand_family_R_linear` (L502) — per-summand R-linearity proof (iter-104).
- `cechCofaceMap_summand_family'` (L612) — `Fin (n+1)`-indexed wrapper around the prior family (iter-105, called out in the directive as a new top-level helper).
- `cechCofaceMap_summand_family'_R_linear` (L642) — R-linearity of the wrapper (iter-105, called out in the directive).
- `alternating_sum_pi_smul_aux` (L764) — abstract: if each summand of a Finset sum is R-linear then the sum is.
- `alternating_sum_pi_smul_aux_sum_comp` (L813) — sum-through-composition extension of the prior lemma, factoring through an intermediate object so an `eqToHom` slot lands outside the family.
- `alternating_zsmul_pi_smul_aux_sum_comp` (L863) — adds a per-summand sign as a separate binder so the per-summand R-linearity hypothesis is about the sign-free composite. Currently inert (not yet applied at the call site).
- `cechCofaceMap_pi_smul` (L928) — the consumer: the Čech differential at degree `(prev n, n)` is R-linear in the product representation. Specialized to the Čech-cochain context. Body has the active prover target `sorry` at L1120.

The four `cechCofaceMap_summand_family*` and the three `alternating_*_pi_smul_aux*` lemmas are all clearly named as iter-stamped proof scaffolding (each carries an `Iter-NNN` tag in its docstring); they cleanly map to "Lean implementation helpers" rather than blueprint declarations. The blueprint's "Lean implementation" remark at L1178 anticipates this category of helper. No suspect bodies.

## Blueprint adequacy for this file

- **Coverage**: 14/23 Lean declarations have a corresponding `\lean{...}` block in the chapter. Unreferenced declarations: 9 helpers (acceptable: all proof-scaffolding tagged with iter stamps and explicit refactor docstrings). Zero substantive unreferenced declarations.
- **Proof-sketch depth**: adequate for the simple wrappers (def:Scheme_basicOpenCover through thm:Scheme_basicOpenCover_finset_inf_isLocalization), adequate for `splitEpi_pi_lift_of_injective` and `cechCohomology_subsingleton_of_cechCochain_exactAt`. **Adequate-but-coarse** for `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`: the four-step proof at L1162–L1171 (Reduction → Localized identification → Extra-degeneracy contraction → Globalization) gives the prover the correct strategic outline, and the iter-063 finite-subspanning Remark at L1173–L1176 covers the `s → s₀` refinement transport step. What the chapter does NOT preview is the per-summand R-linearity machinery that the Lean side needs in order to feed `exact_of_localized_span` (which consumes `R`-linear maps, while `(K.sc n).f.hom` is `k`-linear by construction). That gap is acknowledged in the Lean implementation remark at L1178 but not surfaced as a labelled blueprint block.
- **Hint precision**: precise. Every `\lean{...}` block names the exact Lean target; no asymmetric prose-vs-`\lean{...}` mismatches were observed. The label-vs-Lean-name asymmetry on `finset_inf'_` (blueprint label uses `_inf_`, Lean uses `_inf'_`) is harmless because the `\lean{...}` hint is precise.
- **Generality**: matches need. The chapter parameterises over a general sheaf $\mathcal F$ where the Lean does, and specialises to $\mathcal O_C$ only where the Lean does. The iter-063 finite-subspanning reduction is correctly framed at the level of the blueprint Remark so the Lean side's `hs_fin` / `K → K₀` transport is licensed by prose rather than ad-hoc.
- **Recommended chapter-side actions**:
  - (minor) Consider adding a brief sentence to `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`'s Step 2 prose stating that the localized differential is recovered as an *$R$-linear* map via the presheaf-restriction algebra structure on each cochain factor. This would document why the Lean proof spends significant infrastructure on R-linearity transport (the `cechCofaceMap_pi_smul`, `f_R`/`g_R` scaffolding) — currently the iter-072+ R-linearity work is justified only by the Lean implementation remark, not by a sentence in the proof sketch.
  - (minor) `thm:cechCohomology_subsingleton_of_cechCochain_exactAt` (L1139) and `def:Scheme_splitEpi_pi_lift_of_injective` (L1121) lack `\uses{...}` annotations. Both are dependencies of `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (which already lists them) but each should declare its own dependencies. The iter-105 `mv-fix` writer report explicitly noted these as "soon" follow-ups (see `.archon/logs/iter-105/blueprint-writer-mv-fix-report.md` L34).
  - (minor / informational) None of the seven R-linearity scaffolding helpers warrant promotion to blueprint blocks — their docstrings already identify them as Lean-mechanical infrastructure (HOU avoidance, refactor extraction).

## Iter-105 directive cross-checks

- **mv-fix outcome verified**: `blueprint/src/chapters/Cohomology_MayerVietoris.tex:779` now references `def:Scheme_HModule_prime_eq_HModule_linearEquiv` (defined at L644, also used at L666). No occurrences of the previously broken label `Scheme_HModule_eq_HModule_prime_linearEquiv` remain. The iter-105 `blueprint-writer-mv-fix` report at `.archon/logs/iter-105/blueprint-writer-mv-fix-report.md` confirms the fix is in place and exhaustive across the blueprint tree.
- **New top-level helpers** (`cechCofaceMap_summand_family`, `_R_linear`, `'`, `'_R_linear` at L454/L494/L604/L634 in the directive — actually at L454/L502/L612/L642 in the file): all four are clearly identified as helpers via their docstrings; none silently shadow a blueprint declaration; none have suspect bodies. Per §"Unreferenced declarations" above, they map cleanly to "Lean implementation helpers".

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - Blueprint Step 2 of `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` could explicitly mention `R`-linearity of the localized differential to justify the R-linearity scaffolding (`cechCofaceMap_pi_smul`, `f_R`/`g_R`) the Lean side carries.
  - `thm:cechCohomology_subsingleton_of_cechCochain_exactAt` and `def:Scheme_splitEpi_pi_lift_of_injective` lack `\uses{...}` annotations.

Overall verdict: the Lean file follows the blueprint faithfully; the blueprint chapter gives a prover enough detail to formalize this file modulo a minor R-linearity wording gap and two missing `\uses{...}` annotations — both already flagged as known follow-ups in iter-105's `blueprint-writer-mv-fix` report.
