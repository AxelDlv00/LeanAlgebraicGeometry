# AlgebraicJacobian/Cohomology/AcyclicResolution.lean

## Summary

- **Declarations added (axiom-clean, no sorry): 27.** The genuinely novel mathematical core of the
  dual Horseshoe Lemma — the twisted biproduct complex, the twist recursion with the cocycle
  identity, the degreewise-split SES of complexes, and the augmentation — all compile and are
  `#print axioms`-clean (`propext, Classical.choice, Quot.sound` only).
- **Declarations blocked: 1 critical (`resolvesMiddle` / a missing-Mathlib `quasiIso_τ₂`), plus the
  3 downstream targets that depend on it** (`ofShortExact`, `rightDerivedShiftIsoOfAcyclic`,
  `rightDerivedIsoOfAcyclicResolution`).
- **sorry count: 0 → 0** across the file (file compiled with 0 sorries before; still 0; all new work
  is fully proved).
- File compiles with **no errors** (only style/long-line + unused-section-variable warnings).

## What was built (all axiom-clean)

### Project-local supplement — twisted biproduct of cochain complexes (`section TwistedBiprod`)
Injective-free structural core; realises blueprint `lem:horseshoe_dComp` + `lem:horseshoe_chainMap`.
- `twistedBiprodD` — the matrix differential `[[d_K, τ], [0, d_L]]` on `K^n ⊞ L^n`.
- `twistedBiprodD_fst`, `twistedBiprodD_snd` — its biproduct components (`@[reassoc simp]`).
- `twistedBiprodD_comp` — `d ∘ d = 0` (uses the cocycle `hτ`). **This is `lem:horseshoe_dComp`.**
- `twistedBiprod` — the cochain complex (via `CochainComplex.of`).
- `twistedBiprod_X`, `twistedBiprod_d` — defeq unfolding lemmas.
- `twistedBiprodInl : K ⟶ twistedBiprod`, `twistedBiprodSnd : twistedBiprod ⟶ L` — chain maps
  (`biprod.inl` / `biprod.snd` degreewise). **These are `lem:horseshoe_chainMap`.**
- `twistedBiprodInl_f`, `twistedBiprodSnd_f`, `twistedBiprodInl_comp_Snd`.
- `twistedBiprodSplitting` — each degree is the canonical biproduct `ShortComplex.Splitting`.

### Project-local supplement — the horseshoe twist family (`namespace InjectiveResolution`,
`section OfShortExact`, variables `hses : ses.ShortExact`, `I_A`, `I_C`)
Realises blueprint `lem:horseshoe_twist` (the recursion kernel) + the augmentation.
- `horseshoeβ₁ : ses.X₂ ⟶ I_A^0` — first augmentation component (`factorThru (I_A.ι.f 0) ses.f`);
  `f_comp_horseshoeβ₁`.
- `horseshoeH : ses.X₃ ⟶ I_A^1` — the map through which `β₁ ≫ d_A^0` factors; `g_comp_horseshoeH`,
  `horseshoeH_comp_d`.
- `horseshoeτZero : I_C^0 ⟶ I_A^1` — base twist; `ιC_comp_horseshoeτZero`, `horseshoeτZero_hf`.
- `twistPair` — the ℕ-recursion carrying consecutive twists + the cocycle at each stage
  (`descToInjective` against `exact_succ` / `exact₀`).
- `horseshoeτ : ∀ n, I_C^n ⟶ I_A^{n+1}` — the off-diagonal twist family. **`lem:horseshoe_twist`.**
- `horseshoeτ_cocycle` — `d_C^n ≫ τⁿ⁺¹ = -(τⁿ ≫ d_A^{n+1})`. **The cocycle identity.**
- `horseshoeMid` — the middle complex `I_B = twistedBiprod horseshoeτ horseshoeτ_cocycle`.
- `horseshoeSES`, `horseshoeSES_splitting`, `horseshoeSES_shortExact` — the degreewise-split short
  exact sequence `0 → I_A → I_B → I_C → 0` of cochain complexes. **This is the exact shape
  `rightDerivedShiftIsoOfSplitResolutionSES` consumes** (modulo `I_B` being a resolution).
- `horseshoeτ_zero` (defeq simp), `ιC0` + `ιC0_comp_d` + `ιC0_comp_τZero` (clean-domain augmentation
  helper — see Dead-ends), `horseshoeβ` + `horseshoeβ_fst/snd`, `horseshoeβ_comp_d`
  (`β ≫ d_B^0 = 0`). **The augmentation half of `lem:horseshoe_twist`.**

## resolvesMiddle / ofShortExact (NOT added) — the precise remaining gap

- **Approach (chosen, correct):** `horseshoeMid` with `β` is an injective *resolution* of `B` iff the
  augmentation chain map `(single₀ B) ⟶ horseshoeMid` is a quasi-isomorphism. Build the map of short
  exact sequences `(single A → single B → single C) ⟶ (I_A → I_B → I_C)` whose outer verticals
  `I_A.ι`, `I_C.ι` are quasi-isos (they are resolution augmentations), then transfer to the middle.
- **Blocker (named precisely):** Mathlib's `HomologicalComplex.HomologySequence` provides only the
  **last-term** transfer `quasiIso_τ₃ (h₁ : QuasiIso τ₁) (h₂ : QuasiIso τ₂) : QuasiIso τ₃`
  (`Mathlib/Algebra/Homology/HomologySequenceLemmas.lean:168`). The **middle-term** version
  `quasiIso_τ₂` (give `τ₁`, `τ₃` quasi-iso, conclude `τ₂`) is **ABSENT** — the file docstring says
  only the four `τ₃` lemmas are stated.
- **Next step (build this first):** prove `quasiIso_τ₂` / `isIso_homologyMap_τ₂` via the homology
  five-lemma. The window centred at `H^i(X₂)` is
  `H^{i'}(X₃) → H^i(X₁) → H^i(X₂) → H^i(X₃) → H^{i+1}(X₁)`, which spans **two** `composableArrows₅`
  windows (`(i', i)` and `(i, i+1)`); assemble a 7-term exact `ComposableArrows` (or apply the
  four-lemmas `mono_of_epi_of_mono_of_mono` / `epi_of_epi_of_epi_of_mono` to extracted sub-windows of
  both), handling the `ℕ`-boundary at `i = 0` (no predecessor) as the `τ₃` proof handles its
  boundary via `by_cases hi : ∃ j, c.Rel i j`. Model directly on the `mono_homologyMap_τ₃` /
  `epi_homologyMap_τ₃` / `isIso_homologyMap_τ₃` proofs (`HomologySequenceLemmas.lean:113–166`).
- **Then:** package `horseshoeMid`+`β` as `InjectiveResolution ses.X₂` (the `quasiIso` field is the
  result above; `injective` field from `Injective.instBiprod`; `ι` from `β` via
  `CochainComplex.fromSingle₀Equiv` + `horseshoeβ_comp_d`). Assemble `ofShortExact` exposing
  `horseshoeSES` + `horseshoeSES_shortExact`, feed to `rightDerivedShiftIsoOfSplitResolutionSES` to
  get `rightDerivedShiftIsoOfAcyclic`, then the staircase induction for
  `rightDerivedIsoOfAcyclicResolution`.

## Dead-ends / gotchas to NOT repeat (cost a lot of time this session)

1. **`namespace InjectiveResolution` + `InjectiveResolution.*`-named decls break instance
   resolution.** Inside that namespace, `Mono (I.ι.f n)` for `I : InjectiveResolution ses.X₃`
   FAILS to synthesize (works fine outside / for `InjectiveResolution Z`). Worked around by passing
   the mono explicitly: `mono_of_isLimit_fork I_C.isLimitKernelFork`. Same for `Mono ses.f` (a
   *hypothesis*, not a global instance) — `Injective.factorThru` won't pick it up from local context
   even via `haveI`; use the explicit `@Injective.factorThru _ _ _ _ _ (I_A.injective k) g f hMono`.
2. **`rw`/`simp` silently fail to match `I_C.ι.f 0` once it is composed under `ses.g`.** Reason:
   `I_C.ι.f 0` has domain `((CochainComplex.single₀ 𝒜).obj ses.X₃).X 0`, which is *defeq* but not
   *syntactically* `ses.X₃`; `ses.g ≫ I_C.ι.f 0` then forces the comp's middle object to `ses.X₃`,
   so the subterm `I_C.ι.f 0 ≫ _` no longer matches a standalone `I_C.ι.f 0 ≫ _`. **Fix:** the
   clean-domain wrapper `def ιC0 : ses.X₃ ⟶ I_C.cocomplex.X 0 := I_C.ι.f 0` (defeq, but with the
   right syntactic domain) — use it everywhere `ses.g ≫ (…ι…)` appears.
3. **`rw` of `Preadditive.neg_comp` (and similar) fails on terms produced by a *prior* `rw`** (e.g.
   the `-hH` introduced by rewriting with a lemma whose RHS is `-hH`). Even `simp only [neg_comp]`
   then makes no progress, and `simp [h]` can leave an unclosable `0 = 0`. **Fix:** prove the needed
   equality on a *fresh* goal (`have e : (-hH) ≫ d = 0 := by rw [Preadditive.neg_comp, hHd,
   neg_zero]`), reach the poisoned form by `rw`, then close with `exact e` (defeq-tolerant).
4. Inside a `def` body still carrying unresolved universe metavariables, `rw`/`simp` behave
   erratically; **extract the side-condition proofs as standalone lemmas** (resolved universes) and
   reference them (done for `horseshoeτZero_hf`).
5. `CochainComplex.ofHom` only builds maps *between two `CochainComplex.of` complexes*; it cannot
   build a map from a general complex `K`. Build such chain maps by the structure constructor with an
   explicit `comm'`.

## Needs blueprint entry (1-to-1 hygiene — mandatory report)

Every non-private declaration added is a `lean_aux` node with NO blueprint block yet (the blueprint
`\lean{}` names for these sub-lemmas are the planner's `ofShortExact_twist` / `_dComp` / `_chainMap`,
which do NOT match the helper names I used). The planner/reviewer should wire these up:

- `twistedBiprodD`, `twistedBiprodD_comp` (`twistedBiprod`, `twistedBiprodInl/Snd`,
  `twistedBiprodSplitting`) ↔ blueprint `lem:horseshoe_dComp` + `lem:horseshoe_chainMap`.
  Proof relies on: `CochainComplex.of`, `CochainComplex.ofHom`-style construction, `biprod.hom_ext`,
  `HomologicalComplex.d_comp_d`, and the cocycle hypothesis only.
- `horseshoeτ`, `horseshoeτ_cocycle` (+ `twistPair`, `horseshoeβ₁`, `horseshoeH`, `horseshoeτZero`,
  `horseshoeβ`, `horseshoeβ_comp_d`, `ιC0`) ↔ blueprint `lem:horseshoe_twist`. Proof relies on:
  `ShortComplex.Exact.descToInjective` / `comp_descToInjective`, `InjectiveResolution.exact₀` /
  `exact_succ` / `ι_f_zero_comp_complex_d`, `Injective.factorThru` / `comp_factorThru`,
  `mono_of_isLimit_fork`, `hses.exact` / `mono_f` / `epi_g`.
- `horseshoeMid`, `horseshoeSES`, `horseshoeSES_splitting`, `horseshoeSES_shortExact` — the
  degreewise-split SES; folds under `lem:injective_resolution_of_ses` as the complex-level precursor.
  Proof relies on the existing `shortExact_of_degreewise_splitting` + `twistedBiprodSplitting`.
- (Carried over, still un-blueprinted from iter-004:
  `isZero_homology_mapHomologicalComplex_of_isRightAcyclic`, `shortExact_of_degreewise_splitting`,
  `shortExact_map_mapHomologicalComplex_of_degreewise_splitting`,
  `rightDerivedShiftIsoOfSplitResolutionSES`.)

## Why I stopped

**Partial progress (strong).** Added **27 axiom-clean declarations** implementing the genuinely novel
content of the dual Horseshoe Lemma (twisted biproduct complex; the ℕ-recursion twist family with the
cocycle identity; the degreewise-split SES `0 → I_A → I_B → I_C → 0`; the augmentation `β` with
`β ≫ d_B^0 = 0`). All verified `#print axioms`-clean.

Hit one precise blocker: `resolvesMiddle` (that `I_B` is a *resolution* of `B`) requires a
**middle-term quasi-isomorphism transfer `quasiIso_τ₂`** that is **absent from Mathlib** (only the
last-term `quasiIso_τ₃` exists). Building it needs the homology five-lemma on a 7-term LES window
spanning two `composableArrows₅` (plus the `ℕ`-degree-0 boundary) — a clean, self-contained next
objective, not a quick alternative route. I did NOT attempt it to avoid leaving half-built
sorry-bearing code; it is the single, well-scoped thing to build next, after which the assembly
(`ofShortExact` → `rightDerivedShiftIsoOfAcyclic` → `rightDerivedIsoOfAcyclicResolution`) follows the
already-proven `rightDerivedShiftIsoOfSplitResolutionSES`.

No external-LLM API key was available (PROGRESS.md standing note confirms only `GEMINI_CLI_*`), so
`archon-informal-agent.py` was not usable; relied on LSP search + Mathlib source reading.

## Per-declaration result (selected)
- `twistedBiprodD_comp` — RESOLVED, axiom-clean. Direct biproduct + cocycle computation.
- `horseshoeτ` / `horseshoeτ_cocycle` — RESOLVED, axiom-clean. ℕ-recursion via `twistPair`; the
  cocycle is `(twistPair n).2.2` (structural-recursion defeq reduction works).
- `horseshoeSES_shortExact` — RESOLVED, axiom-clean. `shortExact_of_degreewise_splitting` +
  `twistedBiprodSplitting`.
- `horseshoeβ_comp_d` — RESOLVED, axiom-clean. `biprod.hom_ext` + the `ιC0` clean-domain fix.
- `ofShortExact_resolvesMiddle` / `ofShortExact` / `rightDerivedShiftIsoOfAcyclic` /
  `rightDerivedIsoOfAcyclicResolution` — NOT ADDED. Blocked on `quasiIso_τ₂` (see above).
