# Session 51 (iter-051) — review summary

## Metadata
- Sorry count: **2 → 2** (no regression). Both pre-existing & frozen/superseded:
  `CechAcyclic.lean:110` dead `affine`; `CechHigherDirectImage.lean:780` protected P5b
  `cech_computes_higherDirectImage`. All new decls 0-sorry.
- Lanes: **2 dispatched, 2 ran.** Lane 1 (`CechAcyclic.lean`) **SOLVED**; Lane 2
  (`CechHigherDirectImage.lean`) **PARTIAL** (object layer built, top theorem missing-infra-blocked).
- Build: GREEN. Prover `lake env lean` on both files = exit 0 (sorry warnings only).
  Every new decl `lean_verify` = `{propext, Classical.choice, Quot.sound}` (axiom-clean).
- **+10 axiom-clean decls** (4 in CechAcyclic, 6 in CechHigherDirectImage), 0 new sorries.

## Lane 1 — `sectionCech_homology_exact_of_localizationAway` SOLVED (the 02KG residual math core)
The route-B (change-of-ring) residual `htilde` is now a real theorem. For `M : ModuleCat R`,
finite `s : ι → R`, `f : R` with `D(f) = ⨆ᵢ D(sᵢ)`, the section Čech complex of `~M` over
`{D(sᵢ)}` has vanishing positive-degree homology. Four axiom-clean decls:

- **`AwayComparison.isLocalizedModule_comp_away`** (~L875) — composite of two away-localizations:
  `mkf : M → M_f` at `powers f` then `gN : M_f → N` at `powers (algebraMap R R_f a)` (with `a^j = f·h`)
  gives the `R`-linear composite `IsLocalizedModule (powers a)`. Built directly via the
  `⟨map_units, surj, exists_of_eq⟩` constructor, clearing the `f^l` factor with `a^{jl}=f^l h^l`.
  Avoids the Mathlib-absent "converse of `of_restrictScalars`". (auditor: each case sound.)
- **`SectionCechModule.dDiff_exact_of_localizationAway`** (~L1217, the math core) — instantiate the
  polymorphic `dDiff_exact` over `R_f = Localization.Away f` with `M_f` and `s/1`, then transport
  positive-degree exactness back to `R` along degreewise `R`-linear isos `M_{sσ} ≅ (M_f)_{sσ}`
  (`IsLocalizedModule.iso` of the composite) via `Function.Exact.of_ladder_addEquiv_of_exact`.
  Needs `maxHeartbeats 1600000` / `synthInstance.maxHeartbeats 800000` (genuine instance-search
  over `dCoeff`-abbreviated `LocalizedModule` carriers — auditor confirmed not masking fragility).
- **`sectionCechAbExact_loc`** (private, ~L1802) — verbatim copy of `sectionCechAbExact` with the
  final `dDiff_exact` swapped for `dDiff_exact_of_localizationAway`; reuses the entire tilde bridge
  (`sectionToModuleAddEquiv`, `sectionCechCofaceMatch`), which is spanning-hyp-independent.
- **`sectionCech_homology_exact_of_localizationAway`** (~L1868, public Lane-1 target) — derives
  `hmem` (via `PrimeSpectrum.basicOpen_le_basicOpen_iff`) and the `R_f`-span `hspan` (inlined replica
  of `affine_cover_span_localizationAway`, which lives in the not-importable downstream file), then
  applies `sectionCechAbExact_loc`.

Friction was pure Lean plumbing (resolved in-lane): `Submonoid.smul_def` pattern-rewrite (→ `simp only []`
+ `dsimp only`), `set_option`-before-docstring parse ordering, `CompleteLattice` metavar on `le_iSup`
(→ explicit motive `le_iSup (fun i => …) i`). The math was settled by the iter-049 reduction.

## Lane 2 — `cechAugmented_exact` PARTIAL (object layer built; exactness genuinely blocked)
Six axiom-clean decls landed the full augmented-complex OBJECT + augmentation layer the planner asked
to build first: `cechComplexOnX`, `cechNervePointIso`, `cechAugmentation`,
`augmentation_comp_alternatingCofaceMap_objD_zero` (private), `cechAugmentation_comp_d`,
`cechAugmentedComplex` (the object `cechAugmented_exact` is asserted about).

The **exactness theorem itself was NOT added** — a genuine missing-infrastructure blocker, not papered:
Mathlib has **no stalk functor for `SheafOfModules`/`X.Modules`** and **no "complex of sheaves of
modules is exact iff exact on every stalk" criterion**. Verified by loogle/leansearch (only
`HomologicalComplex.exact_iff_degreewise_exact` — degreewise, not stalkwise — and object-level
`stalkFunctor` iso/mono for presheaves in a *fixed* concrete category). No sorry inserted.

**Key reusable gotcha (auditor-confirmed sound):** the cosimplicial `Augmented = Comma (const) (𝟭)`
puts `𝟭` on the augmentation's *codomain*, so `N.hom.app [0]` has codomain `(𝟭).obj N.right .obj [0]`.
This pins the composition's middle object; **every additive distribution lemma** (`Preadditive.comp_add`,
`comp_neg`, `comp_zsmul`, even `simp`) fails to match (instances at defeq-but-not-syntactic
`N.right.obj [0]`). **FIX:** `erw` (defeq-matching rewrite) for the distribution step; final `f ≫ 0 = 0`
needs `exact Limits.comp_zero` not `rw [comp_zero]`. Proving the lemma *abstractly* (over any augmented
cosimplicial object) was essential — naturality on the concrete whiskered `CechNerve` `whnf`-timeouts at
200k heartbeats. This is the pre-composition analogue of Mathlib's simplicial `AlternatingFaceMapComplex.ε`
(which post-composes, avoiding the `𝟭`-codomain wall).

## Independent soundness verdict (3 ways)
1. **Prover full `lake env lean`** on both files exit 0 — the real kernel check (excludes the
   LSP-accept/kernel-reject thin-cat trap). `lean_verify` axiom-clean on all 10 new decls.
2. **lean-auditor `iter051`** (whole-file, no strategy bias): **0 critical / 0 major / 3 minor.**
   Explicitly confirmed the `erw`/`change`/`IsLocalizedModule.ext` closures are sound reductions
   (not subsingleton-coherence traps), the heartbeat raises genuine, the two sorries exactly where
   expected. Report: `.archon/logs/iter-051/lean-auditor-iter051-report.md`.
3. **lean-vs-blueprint** (`cechacyclic`, `cechhdi`): Lane-1 main theorem signature + proof faithful
   to the route-B blueprint sketch, sorry-free. Reports under same logs dir.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:cech_augmented_resolution`: added `% NOTE (iter-051)`
  recording that the augmented-complex OBJECT layer is built but the `\lean{}` target
  `cechAugmented_exact` (exactness) is blocked on the Mathlib-absent stalkwise-exactness criterion;
  flags the planner to split into object (done) + exactness (pending).

No `\leanok` touched (sync's domain). No `\mathlibok` added (all new decls are project lemmas, not
Mathlib re-exports). No stale `\notready` found.

## Notes
- **`\leanok` did NOT appear on `lem:affine_cech_vanishing_tilde_subcover`** despite its `\lean{}`-pinned
  decl (`sectionCech_homology_exact_of_localizationAway`) being 0-sorry and the file compiling. This is
  honest (conservative) — its `\uses` deps include `lem:away_comparison_isLocalizedModule` (whose
  `\lean{}` pins a *different* lemma `comparison_isLocalizedModule`, not this iter's new
  `isLocalizedModule_comp_away`) and the unblueprinted `dDiff_exact_of_localizationAway`, so the
  proof-`\leanok` gate isn't satisfied. Resolved once the coverage debt below is blueprinted. Not laundering.
- **Coverage debt: 10 unmatched `lean_aux` nodes** (`archon dag-query unmatched`) — 9 new helpers + the
  pre-existing dead `CechAcyclic.affine`. Listed for the planner in `recommendations.md`.
- Minor (auditor): stale comment in dead `affine` body (L84, "L1 STILL MISSING" now partly done);
  duplicated `sq` proof block in `sectionCechAbExact`/`_loc` (code smell, extract shared lemma);
  `import Mathlib` broad import (project-wide convention).
- Blueprint-doctor: **no structural findings** (all chapters `\input`'d, all refs resolve, no `axiom`).
