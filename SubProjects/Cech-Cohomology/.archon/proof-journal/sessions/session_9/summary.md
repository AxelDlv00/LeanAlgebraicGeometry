# Session 9 (iter-009) — review

## Metadata
- **Prover lane**: one (P4 → `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`,
  `[prover-mode: mathlib-build]`). Model: sonnet.
- **Global sorry count**: 2 → 2 (unchanged). Both remain in `CechHigherDirectImage.lean`
  (`CechAcyclic.affine` L774, `cech_computes_higherDirectImage` L811 — P3/P5, out of scope this lane).
- **`AcyclicResolution.lean`**: 0 → 0 sorries; **2 new declarations added**, both axiom-clean
  (`{propext, Classical.choice, Quot.sound}`). Full `lake build` passes (style/linter warnings only).
- **Targets attempted (2)**: solved / partial / blocked / not_started = **2 / 0 / 0 / 0**.
- **P4 abstract layer CLOSED.** TARGET 3 (`rightDerivedIsoOfAcyclicResolution`, the
  acyclic-resolution staircase) and its last leaf (`rightDerivedOneIsoCokerOfAcyclic`) are both proven.
  DAG `gaps` = 0 (no ∞ holes); `frontier` = 3, all in the Čech chapter (P3/P5).

## Target 1 — `rightDerivedOneIsoCokerOfAcyclic` (leaf, `lem:acyclic_one_iso_coker`) — SOLVED, axiom-clean

**Statement** (matches the planner's suggested signature exactly):
`(G : 𝒜 ⥤ ℬ) [G.Additive] [PreservesFiniteLimits G] {ses : ShortComplex 𝒜} (hses : ses.ShortExact)
 [G.IsRightAcyclic ses.X₂] : (G.rightDerived 1).obj ses.X₁ ≅ cokernel (G.map ses.g)`

**Proof structure.** Horseshoe-lift `ses` to the degreewise-split SES of injective resolutions
`0 → I_A → I_J → I_Z → 0` (`ofShortExact_resolvesMiddle` + `horseshoeSES`), apply `G` degreewise
(`shortExact_map_mapHomologicalComplex_of_degreewise_splitting`), read the bottom of the homology LES
at degrees `(0,1)`:
- `δ⁰` epi via `hSG.epi_δ 0 1` (uses `isZero_homology_mapHomologicalComplex_of_isRightAcyclic I_J 0` =
  `H¹(GI_J)=0`);
- exactness at `H⁰(GI_Z)` via `hSG.homology_exact₃ 0 1`; `.gIsCokernel` exhibits `H¹(GI_A)` as
  `coker(homologyMap(Gψ) 0)`;
- `(R¹G)(A) ≅ H¹(GI_A)` via `isoRightDerivedObj G 1`, matched against `cokernelIsCokernel` by
  `coconePointUniqueUpToIso`.

**Key attempts (from `attempts_raw.jsonl`):**
1. **Dead end** — one *combined* `cokernel.mapIso` with `p = (isoRD).symm ≪≫ rdzis.app`: the combined
   square forces `rw`/`cancel_epi` through the `homologyMap origS.g 0` vs
   `(mapHC ⋙ homologyFunctor 0).map ψ` defeq on a non-syntactic homology type — both fail.
2. **Fix** — split the cokernel transport into TWO `cokernel.mapIso` steps:
   `coker(homologyMap(Gψ) 0) ≅ coker((R⁰G).map ses.g) ≅ coker(G.map ses.g)`. Step-1 square is exactly
   `isoRightDerivedObj_hom_naturality` (lift `ses.g` to `ψ`; `comm` = `horseshoeφ_comm₂₃` in degree 0);
   step-2 square is *literally* `(G.rightDerivedZeroIsoSelf).hom.naturality ses.g`. The defeq is absorbed
   by feeding `nat1.symm` through `exact` after `Iso.comp_inv_eq` + `Iso.eq_inv_comp`.
3. The degree-0 `comm` discharged by `congrArg (·.f 0) horseshoeφ_comm₂₃` + explicit
   `simp only [HomologicalComplex.comp_f, ShortComplex.map_g, CochainComplex.single₀_map_f_zero]`
   (blunt `simpa using h` was insufficient).
4. The `R⁰G≅G` `key` equation closed by `rw [← cancel_epi (isoRightDerivedObj G 0).hom,
   Iso.hom_inv_id_assoc]; exact (isoRightDerivedObj_hom_naturality …).symm`.

## Target 2 — `rightDerivedIsoOfAcyclicResolution` (TARGET 3, `lem:acyclic_resolution_computes_derived`) — SOLVED, axiom-clean

**Statement** (prover input-type decision, no protected decl touched; matches planner's suggested type):
`(G : 𝒜 ⥤ ℬ) [G.Additive] [PreservesFiniteLimits G] (K : CochainComplex 𝒜 ℕ) (A : 𝒜)
 (e : A ≅ K.cycles 0) (hexact : ∀ n, K.ExactAt (n+1)) [∀ n, G.IsRightAcyclic (K.X n)] (n : ℕ) :
 (G.rightDerived n).obj A ≅ ((G.mapHomologicalComplex (ComplexShape.up ℕ)).obj K).homology n`

The augmentation is given in the "augmentation-dropped" form `e : A ≅ K.cycles 0`, equivalent to the
blueprint's augmented complex `A → K•`.

**Proof structure** (single straight-line attempt, succeeded; built entirely off iter-004…007 + the
iter-009 leaf):
- **Staircase** `stairGen : ∀ m s, (R^{m+1}G)(cycles s) ≅ (R¹G)(cycles (s+m))` by induction on `m`;
  step composes `(rightDerivedShiftIsoOfAcyclic G (cosyzygyShortExact K s (hexact s)) m).symm` with
  `ih (s+1)`; index bookkeeping `(s+1)+m = s+(m+1)` bridged by one `eqToIso (congrArg … (by omega))`.
- **n = 0:** `rightDerivedZeroIsoSelf.app A ≪≫ G.mapIso e ≪≫ gHomologyZeroIso G K`.
- **n = m+1:** `(G.rightDerived (m+1)).mapIso e ≪≫ stairGen m 0 ≪≫ eqToIso (0+m=m) ≪≫
  rightDerivedOneIsoCokerOfAcyclic (cosyzygyShortExact K m (hexact m)) ≪≫ (cohomologyAppliedResolutionIso G K m).symm`.
- Acyclicity of the cosyzygy middle term: `inferInstanceAs (G.IsRightAcyclic (K.X s))` via defeq
  `(cosyzygyShortComplex K s).X₂ = K.X s`.
- Index arithmetic: `s+0`, `m+0`, `m+2=(m+1)+1` are defeq (no transport); `(s+1)+m` vs `s+(m+1)` and
  `0+m` vs `m` are NOT defeq — two `eqToIso`/`omega` sites total.

## Key findings / patterns
- **Two-step cokernel transport beats a combined square** when one leg carries the
  `homologyMap`/`homologyFunctor.map` defeq (see Knowledge Base addition). This is the reusable lesson:
  isolate each naturality square against its own off-the-shelf Mathlib lemma; never thread two defeqs
  through one `cokernel.mapIso`.
- The whole TARGET-3 staircase is **straight-line `Nat.rec`** once the leaf isos exist — confirming the
  decompose-then-build cadence (iters 004→009) converged exactly as planned.

## Subagent reports (this session)
- **lean-vs-blueprint-checker** (`acyclic`) — **PASS, 0 red flags**. Both decls match their blueprint
  blocks faithfully; signatures, hypotheses, and `\leanok` all correct. One **minor**: the blueprint
  did not document the `e : A ≅ K.cycles 0` augmentation-dropped encoding (addressed — `% NOTE` added,
  see below). Report: `.archon/task_results/lean-vs-blueprint-checker-acyclic.md`.
- **lean-auditor** (`iter009`) — the two new decls are sound, sorry-free, axiom-clean. 2 must-fix +
  6 major + 3 minor are **all pre-existing / outside this lane** (see `recommendations.md`). The major
  findings are stale comment blocks in `.lean` files (most critically the now-contradicted "Status
  (iter-006)" block at `AcyclicResolution.lean:924-963`); not review-agent-fixable (`.lean` is outside
  my write domain). Report: `.archon/task_results/lean-auditor-iter009.md`.

## Blueprint markers updated (manual)
- `Cohomology_AcyclicResolution.tex`, `lem:acyclic_resolution_computes_derived`: added
  `% NOTE (iter-009 review)` documenting the `e : A ≅ K.cycles 0` augmentation-dropped encoding
  convention (the checker's one minor finding).
- No `\mathlibok` added (both decls are project-proved, not Mathlib re-exports).
- No `\lean{...}` correction needed (prover decl names match the blueprint hints exactly).
- No stale `\notready` found.

## Blueprint doctor
Clean — no structural findings (every chapter `\input`'d, every `\ref`/`\uses` resolves, no `axiom`
declarations). Report: `.archon/logs/iter-009/blueprint-doctor.md`.

## Recommendations
See `recommendations.md`. Headline: **P4 abstract layer is closed — pivot the next lane to the Čech
side (P3/P5)**, where the two remaining global sorries and all 3 frontier nodes live. The stale
`.lean` comment blocks flagged by the auditor want a `refactor`/cleanup pass.
