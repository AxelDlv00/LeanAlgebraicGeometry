# Recommendations for the next plan iteration (post iter-033)

## HIGH — correct the misleading `TildeExactness.lean` module docstring (lean-auditor MAJOR)
The file's module docstring (lines 31–55) lists TWO obstructions to `tildePreservesFiniteLimits`.
**Obstruction 2 ("missing categorical glue: right-exact + preserves-monos ⟹ left-exact") is FALSE
as written** — the file's own `tilde_preservesFiniteLimits_of_preservesKernels` (L95) already uses
the Mathlib kernel-route lemma `Functor.preservesFiniteLimits_of_preservesKernels`, which supplies
exactly that reduction. **Only obstruction 1 (the stalk-map mono identification) remains.**
- Action: when the next prover (or a `refactor` subagent) touches this file, correct the docstring
  to state the single remaining gap. The review agent cannot edit `.lean` files.
- Strategic upshot: the planner's mental model of 01I8 Route-P P3 should be "ONE ~100–200 LOC
  Ab-stalk transport," not "two builds." Update STRATEGY.md's 01I8 row accordingly.
- Report: `task_results/lean-auditor-iter033.md`.

## HIGH — a planned lane did not run (process, not math)
The plan dispatched two parallel mathlib-build lanes, but **only the TildeExactness prover session
started** (`provers-combined.jsonl` has a single `session_start`; `AffineSerreVanishing.lean` is
byte-unchanged since iter-032). Lane A (toSheaf cover-system) was blueprint-gate-cleared and is
recipe-ready (`analogies/tosheaf-epi.md`).
- Action: **re-dispatch Lane A unchanged** next iter. Verify the loop actually launches two provers;
  if a `max_parallel`/per-iter cap silently dropped the second lane, either raise the cap or
  serialize the two lanes across iters. Do NOT re-blueprint Lane A — its gate already cleared.

## Closest-to-completion / promising

### Lane B continuation — `tildePreservesFiniteLimits` (01I8 P3), recipe in hand
Dispatch a continuation `mathlib-build` lane on `TildeExactness.lean`:
1. Build `(tilde.functor R).PreservesMonomorphisms` (equivalently the per-`f`
   `PreservesLimit (parallelPair f 0)`) via the **Ab-valued** stalk route:
   `Scheme.Modules.toPresheaf X` (faithful, reflects isos, preserves limits — Mathlib
   `Modules/Sheaf.lean` L72–78) + `app_injective_of_stalkFunctor_map_injective` +
   germ-naturality transport (`TopCat.Presheaf.stalkFunctor_map_germ` + a ⊤-section naturality
   matching `tilde.toOpen`/`toOpen_map_app`) + the delivered `tilde_toStalk_map_injective`.
2. Assemble via the delivered `tilde_preservesFiniteLimits_of_preservesKernels`.
- **Do NOT retry the ModuleCat-valued stalk route** — `toStalkₗ'`, `stalkIsoₗ`,
  `stalkToLocalizationₗ`, `structurePresheafInModuleCat` are module-private in Mathlib (verified
  `#check` → Unknown identifier). This is a confirmed dead end.
- **Do NOT build a "right-exact + mono ⟹ left-exact" categorical lemma** — unneeded (see HIGH above).
- Minor polish for the continuation prover: change `(H : …)` to `[H : …]` in
  `tilde_preservesFiniteLimits_of_preservesKernels`.

### Lane A — toSheaf cover-system (`AffineSerreVanishing.lean`)
Re-dispatch unchanged (see process note). Build order in PROGRESS objective 1 is recipe-ready:
`toSheaf_preservesFiniteColimits` (sheafification square + counit-iso retract; never via `forget`)
→ `toSheaf_preservesEpimorphisms` → `affine_surj_of_vanishing` → `affineCoverSystem`.

## Coverage debt (`archon dag-query unmatched` = 4) — blueprint these next iter
All in `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter that
`% archon:covers` QcohTildeSections/TildeExactness). The 3 new helpers should be bundled into the
`\lean{}` list of `lem:tilde_preserves_kernels` (L4218) or given their own anchor blocks:
- `AlgebraicGeometry.tilde_preservesFiniteColimits` — "right-exactness of `~` (left adjoint preserves
  colimits)"; depends on `AlgebraicGeometry.tilde.adjunction`.
- `AlgebraicGeometry.tilde_toStalk_map_injective` — "flatness core: localized stalk map of an
  injective map is injective"; depends on `IsLocalizedModule.map_injective` +
  `IsLocalizedModule (tilde.toStalk · x).hom`.
- `AlgebraicGeometry.tilde_preservesFiniteLimits_of_preservesKernels` — "reduction to
  kernel-preservation"; depends on `Functor.preservesFiniteLimits_of_preservesKernels`.
- `AlgebraicGeometry.CechAcyclic.affine` — pre-existing **dead** sorry node (superseded relative
  form). Recommend deleting it to drop the project sorry 2→1 (the relative form was superseded by the
  family/section developments). (User-domain file edit; flag only.)

## Root barrel import
`AlgebraicJacobian.lean` must gain `import AlgebraicJacobian.Cohomology.TildeExactness` (prover
cannot edit the barrel). Confirm before the file's decls count toward the build cone. (Note:
`AlgebraicJacobian.lean` shows as `M` in git status — verify the import was added by the loop, else
the planner should ensure it lands.)

## Do NOT retry
- The ModuleCat-valued stalk route for tilde mono-preservation (module-private Mathlib symbols).
- A bespoke "right-exact + preserves-monos ⟹ left-exact" categorical lemma (kernel route already
  supplies the glue).
- `CechAcyclic.affine` as a `prove`-mode body fill (dead/superseded; delete instead).
