# Recommendations for the next plan-agent iteration (iter-021)

## Headline

The iter-020 prover round closed the Path-2 Mayer-Vietoris LES *short-exact infrastructure* cleanly. End-state: file compiles, kernel-only axioms on all four substantive new declarations (`HModule'_shortComplex_g_epi`, `HModule'_shortComplex_exact`, `HModule'_shortComplex_shortExact`, plus `HModule'_shortComplex_f_mono` indirectly via consumer chain), sorry count `9 → 9` over the iteration. **Sixth consecutive refactor + prover sub-phase collapse** (sessions 25, 26, 27, 28, 29, 30) — five-declaration extension of the cohort pattern.

## Track 1 (recommended primary for iter-021): named alias for `extClass` + connecting hom `δ` first declaration

The natural continuation of the iter-020 closure is to define the *named alias* for the extension class associated with the now-available `HModule'_shortComplex_shortExact`, and start scaffolding the connecting hom `HModule'_δ` of the Mayer-Vietoris LES.

**Mathlib mirror**: `Mathlib/CategoryTheory/Sites/MayerVietorisSquare.lean` L271–294, which contains:

- `MayerVietorisSquare.extClass` (a noncomputable def: an `Ext _ _ 1`-valued function on the Mayer-Vietoris square, packaging `S.shortComplex_shortExact.extClass`).
- `MayerVietorisSquare.δ` (a noncomputable def: the connecting hom in the LES, defined via `extClass.precomp _ (by omega)`).
- (Plus a few simp/naturality lemmas.)

**Estimated scope for iter-021**: 2 declarations (`HModule'_extClass` + `HModule'_δ`), ~15–25 LOC including docstrings. Both are noncomputable defs; both have value-category-agnostic Mathlib mirrors that should transfer cleanly via `AddCommGrpCat.free → ModuleCat.free k`. The plan-agent should `lean_run_code`-probe the bodies before issuing the directive.

**Critical typeclass gating**: the `extClass` machinery requires `[HasDerivedCategory]` or `[HasExt]` on the value category. The iter-006 closure registered `instHasExt_Sheaf_Opens_ModuleCatK` (`Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} k)`); for the more general `Sheaf J (ModuleCat.{u} k)`, the equivalent typeclass instance may need to be registered first. Plan-agent probe should verify whether the existing typeclass registration suffices or whether an additional `[HasExt (Sheaf J (ModuleCat.{u} k))]` is needed.

## Track 1.5 (refactor URGENT, before iter-021 prover lane)

Split `Cohomology/MayerVietoris.lean` from `Cohomology/StructureSheafModuleK.lean`. The latter is now **~599 LOC, ~199 LOC over the ~400 LOC threshold**.

**Move targets** (all unprotected, all clean):

- iter-016 declarations: `HModule'_cohomologyPresheafFunctor` (L278–287), `HModule'_cohomologyPresheaf` (L297–304).
- iter-017 declarations: `HModule'_toBiprod` (L321–331), `HModule'_fromBiprod` (L345–355).
- iter-018 declarations: `HModule'_toBiprod_fromBiprod` (L379–389).
- iter-019 declarations: `ModuleCat_free_isLeftAdjoint` (L400–402), `HModule'_isPushoutModuleCatFreeSheaf` (L420–430), `HModule'_shortComplex` (L452–473).
- iter-020 declarations: `ModuleCat_free_preservesMonomorphisms` (L491–496), `HModule'_shortComplex_f_mono` (L504–515), `HModule'_shortComplex_g_epi` (L523–530), `HModule'_shortComplex_exact` (L538–545), `HModule'_shortComplex_shortExact` (L556–562).

Total: ~268 LOC of declarations (plus their docstrings) to move into a new `Cohomology/MayerVietoris.lean`. After the split, `StructureSheafModuleK.lean` drops to ~330 LOC; `MayerVietoris.lean` starts at ~270 LOC with room for iter-021+ `δ` (~30 LOC) + iter-022+ LES sequence (~40 LOC) + iter-023+ iso to `Ext.contravariantSequence` (~50 LOC) + iter-024+ exactness theorem (~40 LOC).

**Refactor agent should run before the iter-021 prover lane** to avoid further inflation. Imports needed in the new file: a strict subset of `StructureSheafModuleK.lean`'s imports plus a single `import AlgebraicJacobian.Cohomology.StructureSheafModuleK` line for the iter-014 `HModule'` carrier and the iter-015 `HModule'_zero_linearEquiv`. Plan-agent should `lean_run_code`-probe the import structure works before issuing the directive.

**Blueprint update**: the corresponding `\lean{...}` macros in `Cohomology_StructureSheafModuleK.tex` (sections 5–9) would need their file-references updated. The review agent (next session 31) is the right place to make this call — `\lean{...}` macros live in the chapter file but reference Lean declarations by their fully-qualified name (no file path), so no chapter-level edit is *strictly* required; the Lean-side declarations keep their fully-qualified names whether they live in `StructureSheafModuleK.lean` or `MayerVietoris.lean`.

## Track 2 (parallel low-coupling)

**none recommended**. Polish backlog remains empty.

## Approaches that showed promise but need more work

1. **`/-- … -/` doc-comments above `set_option … in <decl>` wrappers** — Lean's parser does not bind a doc-comment to the next declaration when it has to traverse a `set_option … in` wrapper first. **Workaround**: demote to a `--` line-comment block. Mathlib L251 confirms by example. **For iter-021+**: the plan-agent's directive should explicitly prescribe `--` line-comment blocks (not `/-- … -/` doc-comments) above any `set_option … in <decl>` wrapper.

2. **Five-declaration cohort prover rounds in a single Edit** — extends the iter-019 three-declaration cohort pattern. Pre-condition: the cohort consists of (a) tightly-coupled mirrors of a Mathlib cohort, (b) all bodies plan-agent probe-confirmed, (c) the cohort sits in unprotected territory. **All three conditions held for iter-019 and iter-020**. The pattern generalises across cohorts of size 1, 2, 3, 5 (and presumably more). **For iter-021+**: continue treating "refactor + prover" as collapsable when these conditions are satisfied.

3. **Anonymous-constructor patterns for typeclass instances** (`⟨_, ⟨...⟩⟩` for `IsLeftAdjoint`, `⟨...⟩` for `Nonempty (... ⊣ ...)`, `where exact := ...` for `ShortExact`, `refine ⟨fun {X Y} f hf ↦ ?_⟩; ...` for `PreservesMonomorphisms`) — these are the canonical Mathlib idioms and transfer cleanly across value categories. **For iter-021+**: prefer these over `by aesop` / `by cat_disch` / `by simp` catch-alls.

## Targets that are blocked (do not assign as direct prover objectives)

- The 8 remaining protected sorries (`Jacobian.lean` × 5, `AbelJacobi.lean` × 3) — gated on Phase C representability + Phase E geometric content + multi-iteration upstream Mathlib advances. The Path-2 multi-iteration chain through iter-024+ → iter-025+ ultimately leads to `smoothOfRelativeDimension_genus`; the others (`Jacobian C`, `instGrpObj`, `instIsProper`, `instGeometricallyIrreducible`, `ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) require Albanese / FGA representability machinery that is multi-iteration removed.

- `PicardFunctor.representable` (`Picard/Functor.lean` L190) — closing on the global-sections-approximate `LineBundle` is a forbidden shortcut. Honest closure requires `LineBundle` refinement (gated on `MonoidalCategory X.Modules` still absent in current Mathlib) plus the FGA argument.

- `LineBundle` direct refinement — gated on `MonoidalCategory X.Modules` (still absent).

## Reusable proof patterns discovered (knowledge-base additions)

1. **`Finsupp.mapDomain_injective` is the canonical Mathlib bridge for `(ModuleCat.free k).PreservesMonomorphisms`** — the four-line tactic block `refine ⟨fun {X Y} f hf ↦ ?_⟩; have hf' : Function.Injective f := (CategoryTheory.mono_iff_injective f).mp hf; rw [ModuleCat.mono_iff_injective]; exact Finsupp.mapDomain_injective hf'` is the minimal verifiable proof. (iter-020 helper.)

2. **`set_option backward.isDefEq.respectTransparency false in instance` is the load-bearing attribute pair** for typeclass instances whose body's `infer_instance` step needs to unfold structure-literal projections. Mathlib's `MayerVietorisSquare.shortComplex_f_mono` (L251) uses this annotation; iter-020 mirrors. Without the relaxed transparency, typeclass-search fails on `Mono (-(presheafToSheaf _).map (Functor.whiskerRight (yoneda.map S.f₁₃) (ModuleCat.free k)))`.

3. **`((shortComplex).exact_and_epi_g_iff_g_is_cokernel.2 ⟨pushout.isColimitCokernelCofork⟩).2` is the canonical Mathlib idiom for extracting `Epi g` from a pushout-of-free-sheaves witness**. Value-category-agnostic; transfers cleanly. (iter-020 g_epi.)

4. **`ShortComplex.exact_of_g_is_cokernel _ pushout.isColimitCokernelCofork` is the canonical Mathlib idiom for "colimit-cocone witness for g as a cokernel ⇒ short complex is exact"**. Sibling to (3) but feeding through `exact_of_g_is_cokernel` (a left-of-iff packaging) instead of the iff itself. (iter-020 exact.)

5. **`where exact := <iter-020 exact lemma>` is the Mathlib idiom for `ShortExact`** — the `Mono f` and `Epi g` fields are typeclass-resolved automatically when the corresponding instances are registered. Mathlib L267–268 mirror. (iter-020 shortExact.)

6. **Doc-comments cannot precede `set_option … in <decl>` wrappers in Lean 4.** The `/-- … -/` doc-comment binds to the next *declaration* keyword, but `set_option` is not a declaration keyword. Workaround: demote to `--` line-comment blocks. (iter-020 parser dead-end.)

## Recommended dispatcher / project-level changes

1. **Standardise the refactor + prover collapse for narrow probe-confirmed scaffold rounds in unprotected territory** — sixth consecutive recurrence (sessions 25, 26, 27, 28, 29, 30). Pre-authorised by PROGRESS.md for iter-020. Recommend explicit user confirmation that this can be the default for future iterations whose work scope matches the four conditions above (probe-confirmed bodies, narrow scope, unprotected territory, no signature change). Saves a refactor-agent invocation per iteration.

2. **Plan-agent directives should flag the `set_option … in <decl>` parser idiosyncrasy when applicable** — the iter-020 directive failed to mention that `/-- … -/` doc-comments cannot precede `set_option … in instance` wrappers, leading to an Edit cycle. Adding a one-line note in the directive ("use `--` line-comment blocks above `set_option … in` wrappers, not `/-- … -/` doc-comments") would have saved the round-trip.

3. **File-size monitoring**: `Cohomology/StructureSheafModuleK.lean` is now at ~599 LOC, ~199 LOC over the ~400 LOC project threshold. The iter-021 plan-agent should issue a `Cohomology/MayerVietoris.lean` split refactor directive *before* the iter-021 prover lane runs.

## Specific guidance for iter-021 plan agent

- **Verify post-iter-020 baseline**: sorry count `9 total across 3 file(s)` (5 + 3 + 1); `lean_diagnostic_messages` clean on `Cohomology/StructureSheafModuleK.lean`; `lean_verify` kernel-only on `HModule'_shortComplex_g_epi`, `HModule'_shortComplex_exact`, `HModule'_shortComplex_shortExact`.

- **Issue the `Cohomology/MayerVietoris.lean` split refactor directive first** (recommended). Estimated scope: ~268 LOC moved verbatim, plus the new file's `import` block. The refactor agent's task is to ensure the new file compiles and `StructureSheafModuleK.lean` still compiles (with one new `import Cohomology.MayerVietoris` line if downstream files reference any of the moved declarations directly — none currently do, so this may be a clean cut without downstream import additions).

- **Then issue the iter-021 prover directive** for `HModule'_extClass` and `HModule'_δ` in the new `Cohomology/MayerVietoris.lean`. Both are noncomputable defs. Plan-agent should `lean_run_code`-probe the bodies before writing the directive. Mirror Mathlib L271–294 (`MayerVietorisSquare.extClass` + `MayerVietorisSquare.δ`).

- **Update `task_pending.md`** to mark the Path-2 LES *short-exact infrastructure* (iter-020 cohort) as **CLOSED** and to flag iter-021's `extClass` + `δ` as the next "current Mathlib gap section".

- **Migration note for the iter-020 refactor sub-phase collapse** is appropriate for bookkeeping completeness (sixth consecutive recurrence).
