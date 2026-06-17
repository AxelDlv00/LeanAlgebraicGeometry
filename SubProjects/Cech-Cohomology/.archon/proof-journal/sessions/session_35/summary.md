# Session 35 (iter-035) — review summary

## Metadata
- **Iteration / session**: iter-035 / session_35
- **Total sorry**: 2 → 2 (no regression). Both frozen/superseded (`CechAcyclic.affine` dead with
  sorry; `CechHigherDirectImage.lean:~679` frozen P5b). Both prover files are 0-sorry.
- **Build**: GREEN. Both edited files `lake env lean … EXIT 0`, diagnostics empty.
- **Lanes planned 2, ran 2** (both `mathlib-build`, distinct files). **+9 axiom-clean decls**
  (`QcohRestrictBasicOpen.lean` +5 new file, `TildeExactness.lean` +4 appended); 0 new sorries.
- `archon dag-query`: **gaps = 0**, **unmatched = 8** (1 pre-existing dead `CechAcyclic.affine`
  + 7 new prover helpers, see Coverage debt).

## Targets attempted

### Lane A — `QcohRestrictBasicOpen.lean` (NEW file, 01I8 Route-P step P1a, L1)
**Both named targets SOLVED, axiom-clean.**
- `modulesRestrictBasicOpen f F : (Spec R).Modules → (Spec R_f).Modules` — the transport of
  `F|_{D(f)}` to a sheaf of `O_{Spec R_f}`-modules, built as the iterated Mathlib restriction
  `(F.restrict (specBasicOpen f).ι).restrict (basicOpenIsoSpecAway f).inv`.
- `modulesRestrictBasicOpenIso f F : modulesRestrictBasicOpen f F ≅ (Scheme.Modules.pullback (specAwayToSpec f)).obj F`
  — the comparison iso `F|_{D(f)} ≅ F_{(f)}`, via
  `(restrictFunctorComp …).app F).symm ≪≫ (restrictFunctorIsoPullback …).app F`.
- Feeder `specAwayToSpec_eq : specAwayToSpec f = Spec.map (CommRingCat.ofHom (algebraMap R (Localization.Away f)))`
  (proof `rw [specAwayToSpec, Iso.inv_comp_eq]; exact (IsOpenImmersion.isoOfRangeEq_hom_fac _ _ _).symm`).
  Reduces L2 to a single clean gap.
- Helpers `specBasicOpen`, `specAwayToSpec` (abbrevs).

**Blocked (correctly, no sorry):** `tilde_restrict_basicOpen` (L2) and `presentation_restrict_basicOpen`
(L3). L2 is exactly Stacks 01I8 `lemma-widetilde-pullback` — *pullback/base-change compatibility of
`tilde`*: `pullback (Spec.map φ) ∘ tilde ≅ tilde ∘ baseChange φ`. Confirmed ABSENT from Mathlib via
`loogle`/`leansearch` (no results). The section-level instance
`tilde.instAway…ToOpen : IsLocalizedModule.Away f (tilde.toOpen M (basicOpen f))` exists but lifting it
to a full sheaf-of-modules iso over `Spec R_f` is multi-hundred-LOC (same order as the
`qcoh_iso_tilde_sections` crux). L3 is transitively blocked on L2.

### Lane B — `TildeExactness.lean` (01I8 Route-P step P3, sub-step A)
**4 helpers SOLVED, axiom-clean** — the precise partial the plan named as preferable to a typed pin:
- `tilde_germ_algebraMap_smul` — germ is `R`-linear (`erw [PresheafOfModules.germ_smul,
  StructureSheaf.algebraMap_germ_apply]; rfl`), rebuilding the unexported `StructureSheaf.germₗ.map_smul`.
- `stalkMapₗ` (`noncomputable def`) — the public `Ab`-stalk map packaged as a genuine `R`-LINEAR map
  `(tilde M).presheaf.stalk x →ₗ[R] (tilde N).presheaf.stalk x`. The `map_smul'` field is the new content.
- `stalkMapₗ_eq` — identifies `stalkMapₗ f x` with `IsLocalizedModule.map _ (toStalk M x) (toStalk N x) f`
  via `IsLocalizedModule.ext` + the iter-034 germ-naturality helper `tilde_stalkFunctor_map_toStalk`.
  Genuine identification of two differently-constructed maps (auditor + lvb both confirm not a tautology).
- `stalkMapₗ_injective` — stalkwise injectivity for a mono (`rw [stalkMapₗ_eq]; exact tilde_toStalk_map_injective …`).

**Blocked (correctly, no sorry):** the named target `tildePreservesFiniteLimits`. It is NOT one hard
step but a multi-decl categorical build: natural-iso packaging of the stalk composite + localisation-is-
flat finite-limit preservation + jointly-reflecting stalk lift. **Infra blocker found:**
`Scheme.Modules.toSheaf` does not exist, so `toPresheaf` lands in *presheaves* where stalks do not jointly
reflect isos; `preservesLimitsOfShape_of_evaluation` then reduces to sections-over-each-`U` (the
sheaf-condition equalizer of products of localisations), not a single localisation.

## Key findings / patterns
- **`erw`, not `rw`, around structure-sheaf ring sections**: the section `Γ(Spec R, U)` appears in ≥3
  defeq-but-not-syntactic forms (`Γ(Spec (.of R), U)`, `(structurePresheafInCommRingCat R).obj (op U)`,
  `(structureSheafInType R R).obj.obj (op U)`); scalar/algebra instances live on different ones. State
  germ lemmas on `(tilde M).presheaf.germ` (not `(moduleStructurePresheaf R M).presheaf.germ`) so callers' `rw` match.
- **R-linearity of an `Ab`-valued map must be proved INSIDE the `LinearMap` structure**: a standalone
  `r • σ ζ` statement fails `HSMul` synthesis (the stalk codomain is only DEFEQ to `(tilde N).presheaf.stalk x`).
- **`Scheme.Modules.Hom.app (~f) U` lands in `Ab`, not `ModuleCat O_X(U)`**; its `O_X(U)`-linearity is the
  dedicated `Scheme.Modules.Hom.app_smul` (found via `exact?`), not `map_smul` of a `.hom`.
- **`specAwayToSpec_eq` technique**: `basicOpenIsoSpecAway` is *definitionally*
  `IsOpenImmersion.isoOfRangeEq (Opens.ι _) (Spec.map (ofHom (algebraMap …)))`, so `Iso.inv_comp_eq` +
  `isoOfRangeEq_hom_fac` identifies the geometric transport with the algebraic `Spec.map (algebraMap)`.

## Reviewer subagent results
- **lean-auditor `iter035`** (`task_results/lean-auditor-iter035.md`): 0 must-fix, 0 major, 3 minor — all
  stale-docstring fragments (TildeExactness header item (a) is now delivered but still listed; "germₗ"
  approach reference bypassed; QcohRestrictBasicOpen docstring over-claims "Stacks 01I8 lemma-widetilde-
  pullback" for what is only the infrastructure). All 9 decls genuine, non-vacuous, axiom-clean; the three
  `opaque` scanner hits are the English word in docstrings, not the keyword.
- **lean-vs-blueprint-checker `qcoh-iter035`** (`task_results/lean-vs-blueprint-checker-qcoh-iter035.md`):
  no must-fix. Both named targets faithfully realize `lem:modules_restrict_basicOpen`. 3 majors, all
  **structural** (not Lean-correctness): missing root import (blocks sync_leanok), missing `% archon:covers`
  entry, 3 unreferenced helpers. `tilde_restrict_basicOpen`/`presentation_restrict_basicOpen` correctly
  absent + honestly unmarked.
- **lean-vs-blueprint-checker `tilde-iter035`** (`task_results/lean-vs-blueprint-checker-tilde-iter035.md`):
  no must-fix. The 4 helpers faithfully realize sub-step (A); `stalkMapₗ_eq` is a genuine identification.
  Major = coverage debt (4 unreferenced helpers) + named-target absence (expected/documented). Minor = the
  remaining-build sketch lives only in `% NOTE`s, not formal proof-sketch steps.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:modules_restrict_basicOpen`: added `% NOTE:` recording that
  both named Lean targets are formalized + axiom-clean but `\leanok` is pending only because the new file is
  not yet imported by the root barrel (sync can't see it); planner action = wire import + add covers entry.

No `\mathlibok` added (all 9 new decls are project theorems, not bare Mathlib re-exports). No `\lean{...}`
renames (the two named targets match the blueprint names exactly). No stale `\notready` (none present on
the affected blocks). No `\leanok` touched (sync ran iter 35, sha 5754138, added 0/removed 0 — consistent
with `QcohRestrictBasicOpen` being unimported and the TildeExactness helpers carrying no `\lean{}` block).

## Notes (low severity)
- The covers-list omission of `QcohRestrictBasicOpen.lean` and the root-import gap are the same underlying
  "new file not wired in" issue; both are planner-actionable (refactor + blueprint header), neither corrupts
  any Lean content.

## Recommendations
See `recommendations.md`. Headline: wire the root import for `QcohRestrictBasicOpen.lean` (unblocks
`\leanok` for `lem:modules_restrict_basicOpen`); the two genuinely-blocked targets (`tilde_restrict_basicOpen`
and `tildePreservesFiniteLimits`) both require building absent Mathlib infrastructure — do NOT re-dispatch
either as a single step without decomposition first.
