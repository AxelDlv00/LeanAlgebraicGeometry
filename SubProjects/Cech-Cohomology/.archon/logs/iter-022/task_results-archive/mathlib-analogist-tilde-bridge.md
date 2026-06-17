# Mathlib Analogist Report

## Mode
api-alignment

## Slug
tilde-bridge

## Iteration
022

## Question
Mathlib's canonical idiom for moving between the three tilde-section accessors
((1) `toPresheafOfModules` Ab-presheaf, (2) `modulesSpecToSheaf`/`tilde.toOpen` ModuleCat
sections, (3) `LocalizedModule (powers s_σ) M`) into one per-σ `AddEquiv` + naturality
square; and whether the section-Čech complex should have been built on a different accessor.

## Headline

**The (1)↔(2) gap the directive calls "the blocker" is DEFINITIONAL — it dissolves into
`rfl`.** Verified by three `lean_run_code` checks (all `success: true`, axiom-clean): the
carriers agree, the per-σ `AddEquiv` (the exact blocked goal) constructs in one line, and the
restriction maps coincide on the underlying function. No coherence iso needs to be built or
searched for.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Coherence iso (1)↔(2) | PROCEED (it's defeq; use `rfl`) | informational |
| Ab- vs ModuleCat-valued section complex | PROCEED (keep Ab; do NOT rebuild) | informational |
| AddEquiv-from-localisations + exactness transport | ALIGN_WITH_MATHLIB | major |

## Answers to the four questions

1. **Coherence iso (1)↔(2)?** No named lemma, and none is required: accessors (1) and (2)
   are *definitionally equal* (carrier, additive structure, and restriction maps), because
   every functor on the path is carrier-preserving — `SheafOfModules.forget` (`obj = .val`,
   `ModuleCat/Sheaf.lean:67`), `forgetToPresheafModuleCatObjObj_coe` (rfl,
   `ModuleCat/Presheaf.lean:377`), `ModuleCat.restrictScalars`/`RestrictScalars.obj'`
   (`ChangeOfRings.lean:85`), `sheafCompose`. The nearest *named* coherence,
   `SheafOfModules.toSheafCompSheafToPresheafIso` (`ModuleCat/Sheaf.lean:109`), is literally
   `Iso.refl _`. Verified: `rfl` proves both the carrier equality and the restriction-map
   equality.

2. **IsLocalizedModule directly on accessor (1)?** Not registered as such — the instance lives
   on `tilde.toOpen M (basicOpen f)).hom` (accessor 2, `Tilde.lean:115`). But defeq transports
   it for free; `qcohSectionsAwayLocalized` (`CechAcyclic.lean:1165`) already packages the
   multi-index form `IsLocalizedModule (powers (∏ s_{σk})) (tilde.toOpen M (⨅ k, D s_{σk})).hom`.

3. **Was Ab the wrong choice?** No — keep it. The Ab choice *is* the Mathlib-aligned one: the
   whole downstream exactness toolchain is Ab-shaped (`ShortComplex.ab_exact_iff_function_exact`
   already used at `CechAcyclic.lean:1256`, `Function.Exact.of_ladder_addEquiv_of_exact`,
   `alternatingCofaceMapComplex Ab`, `preadditiveYoneda`). Rebuilding on `modulesSpecToSheaf`
   ModuleCat sections would force re-deriving the entire iter-019/020 stack
   (`freeYonedaHomAddEquiv`, `homCechSectionCosimplicialIso`, `cechComplex_hom_identification`,
   `homCechComplexMapOpIso`) in ModuleCat, for zero benefit — the (1)↔(3) bridge is `rfl` plus
   one `IsLocalizedModule.iso`.

4. **AddEquiv route?** Confirmed. `IsLocalizedModule.iso S f : LocalizedModule S M ≃ₗ[R] M'`
   (`Mathlib.Algebra.Module.LocalizedModule.Basic`, verified present) → `.toAddEquiv.symm`;
   naturality via `IsLocalizedModule.iso_symm_comp` / `iso_mk_one` / `IsLocalizedModule.ext`.
   `Function.Exact.of_ladder_addEquiv_of_exact` (`Mathlib.Algebra.Exact.Basic`, verified
   present, signature: three `≃+`, two `AddMonoidHom` commuting squares, one `Function.Exact`)
   is the right tool to transport `dDiff_exact` across the degreewise AddEquiv ladder into the
   Ab `Function.Exact` consumed by `sectionCech_isZero_homology_of_objD_exact`.

## Major

- AddEquiv-from-localisations + exactness transport (in-proposal, so adopt rather than
  refactor): build `φ_σ := (IsLocalizedModule.iso _ (tilde.toOpen M (⨅ k, basicOpen (s (σ k)))).hom).toAddEquiv.symm`
  (discharge the instance with `qcohSectionsAwayLocalized M s σ`), close the per-coface square
  with `qcohRestriction_eq_comparison` + `AwayComparison.comparison_unique` /
  `IsLocalizedModule.ext`, then `Function.Exact.of_ladder_addEquiv_of_exact` + `dDiff_exact` +
  `sectionCech_isZero_homology_of_objD_exact`. Full step-by-step recipe (with the verified
  snippets) is in `analogies/tilde-section-bridge.md`.

## Informational

- The one genuine (small) piece of new work: upgrade `sectionCechProductEquiv`
  (`CechAcyclic.lean:1221`, currently a plain `Equiv`) to an `AddEquiv` so the product enters
  the `of_ladder_addEquiv_of_exact` ladder. Follow the additivity pattern already used for
  `freeYonedaHomAddEquiv` (`PresheafCech.lean:274`).
- Do NOT build a (1)↔(2) coherence iso — it would be dead infrastructure wrapped around a
  `rfl`.

## Persistent file
- `analogies/tilde-section-bridge.md` — defeq finding, verified snippets, and the concrete
  bridge-the-accessors recipe.

Overall verdict: the (1)↔(2) "blocker" is `rfl`; keep the Ab-valued section complex and finish
the bridge with `IsLocalizedModule.iso` + `Function.Exact.of_ladder_addEquiv_of_exact` — no
rebuild, no coherence iso.
