# Recommendations for iter-007 plan

## Review-subagent findings (landed this iter)

- **[MUST-FIX, blueprint] `lean-vs-blueprint-checker-fbc-iter006`:** the proof block of
  `lem:base_change_mate_regroupEquiv` in `Cohomology_FlatBaseChange.tex` prescribes the
  unsound one-liner `LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`. I added a
  `% NOTE:` flagging it; **dispatch a blueprint-writer next iter to rewrite that proof sketch** to
  the transparent-`Module R'` / `ModuleCat` base-change-iso route (the `eT` bridge is essential),
  then a scoped HARD-GATE re-review before the prover re-attacks the lemma. Report:
  `.archon/task_results/lean-vs-blueprint-checker-fbc-iter006.md`.
- **[MAJOR, blueprint] FBC `lem:base_change_mate_generator_trace_eq`:** proof sketch is a 3-step
  informal trace with no Lean sub-lemma structure for the adjunction-mate unwind. Blueprint-writer
  should add the sub-lemma scaffold (unit-on-generator / adjunction-transpose-at-element /
  pseudofunctor-reindex) as part of the effort-break below.
- **[MAJOR, blueprint] GF (`lean-vs-blueprint-checker-gf-iter006`):** both L4 Step-2
  (denominator-clearing) and L5 generic-rank SES are under-specified for next-iter formalization —
  expand both proof sketches before the effort-break. Report:
  `.archon/task_results/lean-vs-blueprint-checker-gf-iter006.md`.
- **[lean-auditor-iter006: 0 must-fix]** 3 files, 0 critical / 2 major / 7 minor — honest
  scaffolding throughout, every sorry confirmed genuine. Majors/minors are polish (deprecated
  `Sheaf.val` sites, comment hygiene); fold into a future golf pass. Report:
  `.archon/task_results/lean-auditor-iter006.md`.

## CRITICAL — do NOT retry the FBC `map_smul'` one-liner (proved unsound this iter)

The iter-006 plan deployed `split-regroup` + the one-liner `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)` as "the CONFIRMED fix" for `base_change_mate_regroupEquiv`'s `map_smul'`. **The prover proved this cannot typecheck** (6 spellings, all genuine type-mismatch): the helper's source `(A⊗[R]R')⊗[A]M` (canonical leftAlgebra A-action) and the object carrier `(extendScalars includeLeftRingHom).obj M` (restrictScalars A-action) are **different types** — the A-module is a `TensorProduct` instance arg, not made defeq by separate compilation. **Do not re-issue this directive.** The `eT` bridge is mathematically essential; the refactor was harmless but did not unblock anything.

## Both active cruxes are now EFFORT-BREAK candidates (the ramp the plan queued)

The iter-006 plan stated: "If iter-006 still returns either lane PARTIAL with no structural advance, the ramp escalates to effort-break." Disposition:
- **FBC `base_change_mate_regroupEquiv` (map_smul'):** the deployed corrective FAILED (unsound). The prover's diagnosis is concrete. → **effort-break / structural infra task next iter.**
- **FBC `base_change_mate_generator_trace_eq`:** structural advance DID land (`ext x` reduction committed), but the residue is the monolithic 3-step mate trace. → **effort-break next iter.**
- **GF `exists_free_localizationAway_polynomial` (L5):** the deployed corrective SUCCEEDED (strong-induction skeleton landed axiom-clean) — this is a genuine structural advance, NOT churn. But it exposed the monolithic dévissage SES residue. → **effort-break next iter.**

### FBC — recommended effort-break / infra tasks (priority order)
1. **`base_change_mate_regroupEquiv` (map_smul'): structural infra first, then prove.** The blocker is instance plumbing, not math. Two routes (prover's recommendation):
   - (preferred) build a **transparent project-local `ModuleCat`-level base-change iso** for the mixed `restrictScalars∘extendScalars` square (Beck–Chevalley style) that keeps generators typed at the object and supplies a *non-opaque* `Module R'` instance — then the documented reduction chain fires.
   - (fallback) a `@`-explicit smul reduction threading the `compHom`/`restrictScalars` instances by hand (cf. the `gammaPushforwardIso` header's route-(a)).
   The settled reduction chain to formalize once the instance is transparent: `restrictScalars.smul_def` → `ModuleCat.ExtendScalars.smul_tmul` → `Algebra.TensorProduct.tmul_mul_tmul` → helper's `comm`/`cancelBaseChange_tmul`/`comm` simp set. (A `mathlib-analogist` consult in api-alignment mode on "transparent `Module R'` on a `restrictScalars∘extendScalars` carrier" would de-risk the infra choice before a prover commits.)
2. **`base_change_mate_generator_trace_eq`: effort-break the 3 mate-trace steps** into `…_unit_value` (`m↦(1⊗1)⊗m`), `…_fstar_reindex` (`f_*=restrictScalars φ` via pushforward pseudofunctor identities), `…_gstar_transpose` (`r'⊗m↦(1⊗r')⊗m`). The RHS already computes through the sorry-free additive part of `regroupEquiv`, so this crux is independent of closing the `map_smul'` sorry — it can proceed in parallel with (1).

### GF — recommended effort-break tasks
3. **L5 dévissage** → effort-break into `gf_generic_rank_ses` (constructs `0→A_g[X]^⊕m→N_g→T→0`), `gf_torsion_reindex` (re-presents `T` as finite over `MvPolynomial (Fin m') A`, `m'<d`), then a thin assembly applying `IH m'` + L3 (`exists_free_localizationAway_of_shortExact`, proved). **Do not pre-stub signatures** — they depend on the chosen generic-rank API (likely a hand-built `Module.rank`-over-`FractionRing` notion); a wrong-typed stub is worse than none. Have the effort-breaker fix the generic-rank notion first.
4. **L4** → effort-break into `gf_clear_one_denominator` (single integral-dependence equation) + a `Finset`-fold to a common denominator `g`, then the AlgHom assembly `MvPolynomial (Fin s) A_g →ₐ[A_g] B_g` + module-finiteness.

## Deferred — do NOT re-assign until upstream lands
- `affineBaseChange_pushforward_iso` (FBC): transitively blocked on `base_change_mate_generator_trace_eq`; also a documented multi-hundred-LOC affine reduction. Hold.
- `flatBaseChange_pushforward_isIso` (FBC-B): hold until the affine iso lands.
- `genericFlatnessAlgebraic` (GF): assembly; wire after L4+L5 land.
- `genericFlatness` (GF): geo wrapper; hold until algebraic version lands.

## Coverage debt / blueprint
- `archon dag-query unmatched` = 0 — **no coverage debt this iter.** No `lean_aux` nodes to blueprint.
- `gaps` = 0, blueprint-doctor CLEAN. No structural blueprint action required.
- If iter-007 effort-breaks the cruxes above, the new sub-lemma chains need blueprint blocks (FBC mate-trace 3-lemma chain in `Cohomology_FlatBaseChange.tex`; GF dévissage chain in `Picard_FlatteningStratification.tex`) BEFORE the prover is dispatched — run blueprint-writer + blueprint-clean + a scoped blueprint-reviewer re-check (HARD GATE) in the same iter.

## Parallelism lever (carried forward)
QUOT-defs frontier is ready (4 nodes: `sectionGradedRing`, `Modules.annihilator`, `IsLocallyFreeOfRank`, `gr_affine_chart`), chapters cleared by the iter-006 blueprint-reviewer. Open a scaffold/prove lane on `Picard/QuotScheme.lean` (or the relevant defs file) once an FBC/GF effort-break frees a slot — this is the next genuine parallelism gain.

## Reusable proof patterns discovered
- `induction d using Nat.strong_induction_on generalizing N` — for dévissage where the IH must apply to a lower-dimension quotient; `generalizing` reverts the module + all dimension-dependent instances into the motive. (Landed in GF L5.)
- Differently-instanced `TensorProduct` carriers are different *types*; reconcile with an explicit identity-linear bridge, never rely on import-boundary defeq.
- `letI := inferInstanceAs` ⇒ opaque aux-def ⇒ blocks `SMul*` synthesis on the resulting `•`; use a transparent instance for generator proofs.
