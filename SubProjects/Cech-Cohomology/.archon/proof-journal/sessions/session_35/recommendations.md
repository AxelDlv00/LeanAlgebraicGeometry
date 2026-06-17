# Recommendations for the next plan iteration (post iter-035)

## HIGH — wire the root import for `QcohRestrictBasicOpen.lean` (cheap, unblocks \leanok + downstream)
`AlgebraicJacobian.lean` does NOT import `AlgebraicJacobian.Cohomology.QcohRestrictBasicOpen`. Consequences:
- `sync_leanok` cannot find `modulesRestrictBasicOpen` / `modulesRestrictBasicOpenIso` in the module graph,
  so `lem:modules_restrict_basicOpen` has no `\leanok` despite BOTH targets being axiom-clean (EXIT 0).
  The DAG understates completeness.
- Downstream 01I8 assembly (`QcohTildeSections`) cannot import it transitively.

**Action**: dispatch the `refactor` subagent to add `import AlgebraicJacobian.Cohomology.QcohRestrictBasicOpen`
to the root barrel (established pattern, same as the iter-034 `TildeExactness` import). The planner already
flagged this in iter-035 plan.md item 79 — promote it to a concrete refactor task. `\leanok` then propagates
automatically next sync. (Confirmed by lvb-qcoh-iter035 as a **major** structural finding.)

## HIGH — add the missing `% archon:covers` header entry (blueprint prose domain)
The `Cohomology_CechHigherDirectImage.tex` header `% archon:covers` list (lines 3–12) omits
`AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`, even though its lemmas live in that chapter. Add
`% archon:covers AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`. This is a header/prose edit (not a
review-agent semantic marker) — planner or a blueprint-writer should make it. (lvb-qcoh-iter035, major.)

## MEDIUM — coverage debt: 7 new prover helpers are DAG-invisible (`archon dag-query unmatched`)
All are real Lean decls with NO blueprint `\lean{}` block. The planner should add `\lean{...}` references
(bundle into the existing lemma blocks, or add short helper/remark blocks):
- **Under `lem:modules_restrict_basicOpen`** (or a new helper block): `AlgebraicGeometry.specBasicOpen`,
  `AlgebraicGeometry.specAwayToSpec`, `AlgebraicGeometry.specAwayToSpec_eq`.
- **Under `lem:tilde_preserves_kernels`** (as the iter-034 helpers were bundled):
  `AlgebraicGeometry.tilde_germ_algebraMap_smul`, `AlgebraicGeometry.stalkMapₗ`,
  `AlgebraicGeometry.stalkMapₗ_eq`, `AlgebraicGeometry.stalkMapₗ_injective`.
- Pre-existing dead node `AlgebraicGeometry.CechAcyclic.affine` (has sorry, no block) — still unmatched; either
  cover or remove (frozen/superseded; lowest priority).

## MEDIUM — stale docstrings in `TildeExactness.lean` (lean-auditor minor, .lean edit)
The module docstring "What still has to be built" still lists sub-task (a) (R-linear `Ab`-stalk map ⟹
`IsLocalizedModule.map`) as open — it is now DELIVERED by `stalkMapₗ` + `stalkMapₗ_eq`. The same section says
(a) uses `germₗ`, but the proof bypasses the private `germₗ` via `PresheafOfModules.germ_smul`. Have the next
prover/refactor on this file update the header so only (b) (jointly-reflecting stalk assembly) remains listed.
Also the `QcohRestrictBasicOpen.lean` docstrings open with "Stacks 01I8, lemma-widetilde-pullback" for what is
only the restriction infrastructure (the lemma itself needs the absent base-change compat) — soften.

## BLOCKED — do NOT re-dispatch these as single steps without structural decomposition first

### `tilde_restrict_basicOpen` (L2) + `presentation_restrict_basicOpen` (L3)  [QcohRestrictBasicOpen.lean]
The blocker is exactly Stacks 01I8 `lemma-widetilde-pullback`: **base-change/pullback compatibility of
`tilde`** — `pullback (Spec.map φ) ∘ tilde ≅ tilde ∘ baseChange φ` for a ring hom `φ`. Confirmed ABSENT from
Mathlib (`loogle`/`leansearch` empty). The section-level instance
`tilde.instAway…ToOpen : IsLocalizedModule.Away f (tilde.toOpen M (basicOpen f))` exists but lifting it to a
full sheaf-of-modules iso over `Spec R_f` is multi-hundred-LOC (same order as `qcoh_iso_tilde_sections`).
**Next step**: dispatch `effort-breaker` (or a `dag-walker`) to decompose a NEW blueprint lemma
"`tilde` commutes with pullback along `Spec.map φ`" into buildable sub-pieces (general `φ`, reusable beyond
`Away f`), grounded in `references/stacks-schemes.tex` L1241–1276. Only then dispatch a prover. L3 follows L2.

### `tildePreservesFiniteLimits` (named target)  [TildeExactness.lean]
NOT a single hard step. Requires: (1) natural iso `tilde.functor R ⋙ toPresheaf ⋙ stalkFunctor x ≅
LocalizedModule-functor ⋙ forget₂ _ Ab` (components from `stalkMapₗ`/`stalkMapₗ_eq`); (2) `PreservesFiniteLimits`
of the localisation functor (flat); (3) jointly-reflecting stalk lift. **Infra blocker: `Scheme.Modules.toSheaf`
does not exist** — `toPresheaf` lands in presheaves where stalks do NOT jointly reflect isos, so
`preservesLimitsOfShape_of_evaluation` reduces to sections-over-each-`U` (sheaf-condition equalizer of products
of localisations), not a single localisation. **Next step**: blueprint-writer / effort-breaker to add the
remaining-build sketch as FORMAL sub-steps (lvb-tilde flagged it lives only in `% NOTE`s), and decide between
building a `toSheaf` functor vs the section-equalizer route, BEFORE the next prover lane. iter-035 plan.md's
watchpoint (3rd PARTIAL on the same blocker at iter-036 → CHURNING → mathlib-analogist consult) is now live —
heed it: do NOT dispatch a 3rd identical lane; decompose or consult first.

## Closest-to-completion / converging
- **02KG cover-system** (`AffineSerreVanishing.lean`): COMPLETE + Cov-correct (iter-035 fix); top theorems are
  FALSE-ready and gated on the UNCONDITIONAL 01I8 `qcoh_iso_tilde_sections`. No prover lane until 01I8 lands.
- **P1a L1** (this iter): DONE. Frontier now sits at L2 (`tilde_restrict_basicOpen`) — blocked, see above.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- `erw` (not `rw`) around structure-sheaf ring sections (≥3 defeq forms); state germ lemmas on
  `(tilde M).presheaf.germ` for caller match.
- R-linearity of an `Ab`-valued map: prove `map_smul'` INSIDE the `LinearMap` structure (standalone fails HSMul).
- `Scheme.Modules.Hom.app` lands in `Ab`; its scalar-linearity is `Scheme.Modules.Hom.app_smul`.
- `specAwayToSpec_eq`: `basicOpenIsoSpecAway` defeq `IsOpenImmersion.isoOfRangeEq` ⟹ `Iso.inv_comp_eq` +
  `isoOfRangeEq_hom_fac`.
