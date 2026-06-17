# Recommendations for iter-008 plan

## HIGH — committed FBC/GF dispatch (do not slip again)
- **iter-008 MUST dispatch the FBC and GF provers.** iter-007 was a sanctioned
  plan-only-on-FBC/GF iter (cruxes mid-decomposition); the progress-critic explicitly
  flagged "iter-008 MUST dispatch FBC/GF or it crosses into avoidance." Both cruxes were
  decomposed into concretely-typed sub-lemmas at iter-007 plan time and cleared the HARD
  GATE — the sub-lemma stubs should now be closeable. If the GF sub-lemma stubs turn out
  un-closeable, GF reclassifies STUCK and pivots (per the iter-007 decision).

## HIGH — coverage debt (Lean exists, no blueprint)
- **`Module.annihilator_isLocalizedModule_eq_map`** (QuotScheme.lean, ~line 289) is an
  unmatched `lean_aux` (`dag-query unmatched` = 1, this node). It is the algebra engine for
  `def:modules_annihilator`'s `map_ideal_basicOpen` coherence. **Planner: add a blueprint
  lemma block** (review agent does not author prose) in `Picard_QuotScheme.tex`'s "Support
  and freeness predicates" section, between `def:modules_annihilator` and
  `def:schematic_support`, stating `Ann(S⁻¹M) = (Ann M)·S⁻¹R` for f.g. `M`, with
  `\lean{Module.annihilator_isLocalizedModule_eq_map}` and a `\uses{}`/`\used-by` link to
  `def:modules_annihilator`. Proof depends only on: `Module.Finite.fg_top`,
  `Submodule.span_induction`, `IsLocalization.mk'*`, `IsLocalizedModule.mk'*`,
  `Finset.dvd_prod_of_mem`, `Module.mem_annihilator`.

## MEDIUM — QUOT-defs blockers are Mathlib-infra builds (blueprint, don't re-prove)
- **`def:modules_annihilator` (`Scheme.Modules.annihilator`)** — BLOCKED on a missing
  QCoh→`IsLocalizedModule` bridge. The algebra half (engine lemma) and the
  localization-of-sections fact (`IsAffineOpen.isLocalization_basicOpen`) both exist.
  Effort-break the def into: (i) a bridge lemma `IsLocalizedModule (powers f)
  (M.val.map (homOfLE …).op)` from quasicoherence + affine `U` (transport the
  `ModuleCat.Tilde` localization across the affine identification, or extract it from
  `QuasicoherentData`); (ii) wire a finite-type hypothesis into the def signature; (iii)
  thin assembly of `map_ideal_basicOpen` via the engine lemma. **Do NOT re-dispatch the
  monolithic def** — `map_ideal_basicOpen` is FALSE without QCoh + finiteness.
- **`def:sectionGradedRing`** — BLOCKED on absent tensor/monoidal structure for
  `SheafOfModules` (no `L^{⊗m}`). This is a deep infra prerequisite (tensor product of
  sheaves of modules + lax-monoidal global sections). Blueprint it as a separate
  multi-lemma sub-build, or defer with the SNAP lane. **Do NOT attempt `L^{⊗m}` ad hoc.**

## MEDIUM — formal statement gaps flagged by the quot checker
- **`Grassmannian.representable`** Lean statement (`∃ Y, Nonempty (RepresentableBy Y)`) is
  strictly weaker than `thm:grassmannian_representable` (drops smooth, projective, relative
  dimension `d(r-d)`, tautological quotient, Plücker embedding). This is the intentional
  iter-177+ skeleton, but the planner should decide whether to (a) strengthen the Lean
  signature now, or (b) leave a `% NOTE` acknowledging the deferred structure so the
  mismatch is tracked rather than silent. (Same situation pre-exists on the other 3
  QuotScheme stubs — they are honest typed scaffolding per the auditor.)

## LOW — cleanup for the next prover that owns these files (review agent cannot edit .lean)
- **`GrassmannianCells.lean:59`** — stale docstring "For the iter-007 file-skeleton the
  body is a typed `sorry`" contradicts the now-filled body. Flagged by BOTH the auditor
  (major) and the grcells checker (minor). The next prover owning this file should delete
  that line.

## Reusable proof patterns discovered this iter (also landed in PROJECT_STATUS Knowledge Base)
- **Universe handling for `SheafOfModules.free` predicates:** keep covering opens in
  universe `u` via `X.Opens` and `ULift.{u}`-lift the rank index (`Fin d`); the
  `Scheme.OpenCover` formulation fails two-universe inference — do not retry it.
- **`mk'_surjective` destructuring:** `IsLocalization.mk'_surjective` /
  `IsLocalizedModule.mk'_surjective` give a `match`/`Function.uncurry` form; after
  `obtain ⟨⟨a,s⟩, rfl⟩` use `dsimp only [Function.uncurry]` to expose `a`, `s`.
- **Annihilator-localization engine:** `Ann(S⁻¹M) = (Ann M)·S⁻¹R` for f.g. `M` via
  `le_antisymm` + clear-one-common-denominator over a spanning finset (`Finite.fg_top`,
  `∏ uₘ`, `Finset.dvd_prod_of_mem`, `Submodule.span_induction`). `Module.Finite` is
  load-bearing.

## Do-NOT-retry (no structural change)
- The `Scheme.OpenCover` formulation of local freeness (universe-inference failure).
- Defining `L^{⊗m}` ad hoc inside QuotScheme.lean (needs full monoidal scaffolding).
- Satisfying `map_ideal_basicOpen` for a general (non-QCoh, non-finite-type) sheaf of
  modules (it is mathematically false).
