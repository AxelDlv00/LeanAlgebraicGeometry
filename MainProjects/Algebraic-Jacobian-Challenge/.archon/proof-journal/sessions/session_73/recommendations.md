# Recommendations for the next plan-agent iteration (iter-074)

## Context

Iter-073 closed **1 active sorry** (16 → 15 syntactic): Phase E `AbelJacobi.lean` is now
**fully closed** after Lane 3's `dite` removal in `Jacobian.lean` unlocked Lane 4's
uniform witness-projection rewrite. Both Phase A (`BasicOpenCech.h_diff_pi_smul_{f,g}`)
and Phase B middle (`Differentials._structure.{h_zero, h_exact, h_epi}`) returned
PARTIAL — extensive in-file scaffolding (strategy comments + Mathlib leverage names +
`try`-wrapped partial tactics) but no closures.

The estimate from iter-072's recommendations ("−4 to −6 sorries this iteration") did
not hold. The two structural lanes (B middle and A continuation) need more time and
ideally a working build environment.

## Priority ranking

### P1 — Differentials.lean `_structure.h_zero` (L451)

**Why highest**: Lane 1 has already scaffolded Steps 1-3 of the proof
(adjunction-injection prefix, unfolding to `Y.Modules`-level statement,
`Equiv.apply_symm_apply` simplification). Steps 4-7 are mechanical from there,
with all Mathlib leverage names pinned in the inline comments.

**Action**: complete Steps 4-7:
1. `apply SheafOfModules.hom_ext` to drop to PresheafOfModules.
2. `apply PresheafOfModules.DifferentialsConstruction.isUniversal'.postcomp_injective`
   to reduce to a Derivation equality.
3. Use β's universal-property identity `(derivation' φ_fg').postcomp β.val = d1`.
4. Vanish via the adjunction-coherence identity (iter-072: `rfl`) + `derivation' φ2'.d_app`.

**Estimated**: 40-80 LOC for the inner Derivation chain. The 4-line prefix is in place.

### P2 — BasicOpenCech.lean `h_diff_pi_smul_f` + `h_diff_pi_smul_g` (L1062, L1077)

**Why high**: Lane 2 has embedded a complete reduction recipe (S1-S8) in the source as
comments, plus `try`-wrapped tactics that are safe-by-construction. The mechanical work
is gated on a working LSP for iterative `dsimp` inspection.

**Action**: follow the embedded recipe:
```lean
dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor,
  FormalCoproduct.cochainComplexFunctor, FormalCoproduct.cosimplicialObjectFunctor,
  FormalCoproduct.evalOp, AlgebraicTopology.alternatingCofaceMapComplex,
  AlgebraicTopology.AlternatingCofaceMapComplex.obj,
  AlgebraicTopology.AlternatingCofaceMapComplex.objD,
  HomologicalComplex.sc, ShortComplex.f, CochainComplex.of, CochainComplex.ofHom,
  ComplexShape.up]
funext j
simp only [Pi.smul_apply, Finset.sum_apply, Finset.smul_sum]
-- reduce each summand via algebraMap_naturality
```

**Estimated**: 60-100 LOC. Closing `h_diff_pi_smul_f` typically closes
`h_diff_pi_smul_g` immediately (identical content at degree shifted by 1).

### P3 — Differentials.lean `_structure.h_epi` helper staging

**Why**: this needs a project-local helper `SheafOfModules.epi_of_epi_presheaf` (Mathlib
does not provide). Once the helper lands, `h_epi` reduces to pointwise
`KaehlerDifferential.map_surjective` via `PresheafOfModules.epi_iff_surjective`.

**Action**: stage the helper:
```lean
lemma SheafOfModules.epi_of_epi_presheaf {R : Cᵒᵖ ⥤ RingCat} {J : GrothendieckTopology C}
    [HasSheafify J _] {M N : SheafOfModules.{u} R} (f : M ⟶ N) :
    CategoryTheory.Epi f.val → CategoryTheory.Epi f
```
The proof uses sheafification preserves+reflects epimorphisms in the abelian category
`SheafOfModules R`.

**Estimated**: 30-50 LOC for the helper, then 20-30 LOC for the main proof.

### P4 — Differentials.lean `_structure.h_exact` helper staging

**Why**: this needs the dual helper `SheafOfModules.exact_iff_stalkwise` (also not in
Mathlib). Once available, `h_exact` reduces to ring-level `KaehlerDifferential.exact_mapBaseChange_map`
applied at each stalk.

**Estimated**: 40-60 LOC for the helper, then 20-40 LOC for the main proof. Lower
priority than P3 because (a) Mathlib's `SheafOfModules` stalk-exactness lemma may
exist under a different name (worth a `lean_local_search` first), and (b) the
stalkwise route involves nontrivial localisation chains.

### P5 — Build environment repair (still critical)

**Why**: persistent since iter-068 (now 6 consecutive iterations). `.lake/packages/*`
root-owned; `lake env lean` fails with `unknown module prefix 'Mathlib'`; LSP
diagnostics returns `success: false` for non-cached files. Iter-073 Lane 1 additionally
discovered that **`lean_run_code` MCP silently swallows compilation errors** when any
import is present (returns `success: true` for trivially-false claims). This breaks all
isolated verification mechanisms.

**Action**: the plan agent must ask the user to:
1. `sudo chown -R $(id -u):$(id -g) .lake/packages/`.
2. `lake update && lake build` to regenerate `.lake/build/lib/Mathlib/**.olean`.
3. Once oleans are fresh, `sync_leanok` and the LSP will resume working.

This blocks not the work but the verification of the work. Treat all
post-edit `error_count: 0` reports as "provisionally clean from the cached olean
view" rather than authoritative.

### P6 — Polish: stale-pattern audit on cached recommendations

The iter-073 recommendations list (now P1-P5) inherits four iterations of unclosed
strategy comments; the iter-074 plan agent should audit
`PROJECT_STATUS.md` § "Known Blockers" and prune any entries that are no longer
load-bearing — e.g. some `BasicOpenCech.lean` blockers may have been semi-superseded
by Lane 2's structural analysis.

## Do NOT assign (blocked / deferred)

- **`Jacobian.nonempty_jacobianWitness`** (Jacobian.lean L177) — Albanese existence;
  now also absorbs genus-0 rigidity content. Multi-month effort.
- **`PicardFunctor.representable`** (Picard/Functor.lean L190) — intentionally deferred.
- **`relativeDifferentialsPresheaf_isSheaf`** (Differentials.lean L122) — large
  but tractable; lower priority than `_structure` closure.
- **`smooth_iff_locally_free_omega`, `cotangent_at_section`, `serre_duality_genus`**
  (Differentials.lean L451, L472, L689 — wait these are wrong, the correct line numbers
  are L451 `h_zero` sorry, L472 `h_exact`, L485 `h_epi`, and the downstream targets are
  L122 (relativeDifferentialsPresheaf_isSheaf), L530, L547, L689 per `grep` results) —
  downstream of `_structure` closure; do not assign until `_structure` is complete.
- **BasicOpenCech.lean L495, L819, L847** (Cluster (a) extra-degeneracy substeps) —
  confirmed dead-end across four iterations; do not retry under the current strategy.
- **BasicOpenCech.lean L1156 `LocalizedModule.map ... = sorry`** (h_a₀_fun region) —
  blocked behind `h_diff_pi_smul_{f,g}` and `h_loc_exact`; secondary target only.

## Reusable patterns to propagate

1. **Witness-Π-family routing pattern** *(confirmed iter-073)*. Store all existence
   data + universal-property predicate as a single structure field `predicate : ∀ x, P x J`.
   Every consumer becomes a single-line `(witness).predicate x . field` projection.
   Replaces the iter-072 dite-and-split-ifs scaffolding with cleaner term-mode bodies.
2. **Adjunction-injection prefix for cross-space sheaf-of-modules identities**
   *(iter-073 partial, iter-072 closure)*. When proving `α ≫ β = 0` for `X.Modules`
   morphisms factoring through a pullback, the prefix
   ```lean
   apply ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).injective
   rw [Adjunction.homAddEquiv_zero, Adjunction.homEquiv_naturality_right]
   ```
   reduces the goal to a `Y.Modules` statement. Subsequent extensionality via
   `SheafOfModules.hom_ext` then `isUniversal'.postcomp_injective` reduces to a
   pointwise Derivation equality.
3. **`try`-wrapped partial tactics for env-broken iterations** *(NEW iter-073)*.
   When LSP cannot verify a tactic chain, wrap each speculative tactic in `try`.
   The compile is preserved by construction (`try t` succeeds whether `t` fires or
   not, leaving the sorry below for the prover); the next iteration converts each
   `try t` to a verified `t` once LSP is live.
4. **Embedded reduction recipes for opaque sorries** *(NEW iter-073)*. When a sorry
   cannot be closed but the reduction is well-understood, embed the complete
   `dsimp only [...]` recipe + Mathlib leverage names + S1-S8-style step list as a
   comment block above the sorry. The next prover follows the recipe step by step
   under a working LSP, avoiding redundant search.
5. **Patterns retained from prior iterations** (still applicable): single-witness
   consolidation, `toFun := ⇑(ConcreteCategory.hom f)`, `localizedModuleIsLocalizedModule`
   one-liner, `refine ⟨?_, ?_, ?_⟩` decomposition, `ModuleCat.piIsoPi + e.toAddEquiv.module R`
   transport, helper-claim factorisation for opaque transport sorries, adjunction-
   coherence-is-`rfl` for composed pullback adjunctions.

## Process notes

- **Build environment caveat persists.** Six iterations now. Treat fresh post-edit
  verification as unavailable until the user fixes `.lake/packages/*` permissions.
- **`lean_run_code` MCP is also broken for import-bearing snippets.** Discovered
  iter-073 by Lane 1. Silently returns `success: true` for trivially-false claims.
  Use only on import-free snippets.
- **Process discipline held.** Four parallel lanes; cross-lane refactor + consume
  (Lane 3 → Lane 4) executed cleanly thanks to PROGRESS.md spelling out the target
  shape ahead of time. Zero new axioms; protected signatures preserved verbatim.
- **Lane budget calibration**: the next plan agent should expect −2 to −4 sorries
  realistically, not −4 to −6. Phases A continuation and B middle are deeper
  mechanical work than the iter-072 high-leverage closures (cotangentExactSeqAlpha,
  AbelJacobi case-split).

## Suggested iter-074 dispatch (3–4 lanes)

1. **Lane A (Differentials)**: complete `h_zero` Steps 4-7 (P1). Tight scope;
   fastest expected closure.
2. **Lane B (BasicOpenCech)**: execute the embedded recipe for `h_diff_pi_smul_f` +
   `h_diff_pi_smul_g` (P2). Single prover; the two sorries close together.
3. **Lane C (Differentials)**: stage `SheafOfModules.epi_of_epi_presheaf` and close
   `h_epi` (P3). Independent of Lanes A and B.
4. **Lane D (Differentials, optional / stretch)**: stage `SheafOfModules.exact_iff_stalkwise`
   and close `h_exact` (P4). Only assign if user repairs the build env so the helper
   can be iterated against live LSP.

Net target for iter-074: **−3 to −5 sorries** (from 15 to 10–12), contingent on
working LSP for Lane A and Lane B.
