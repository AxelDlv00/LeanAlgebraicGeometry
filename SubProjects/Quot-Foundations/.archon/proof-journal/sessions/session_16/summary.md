# Session 16 — Review (iter-016)

## Metadata
- **Iteration:** 016 | **Session:** session_16 | **Prover model:** claude-opus-4-8
- **Lanes dispatched:** 2 prover (FBC, GF). QUOT deferred (route pivot decided this iter; build resumes iter-017).
- **Sorry count (active, per file):**
  - FBC `FlatBaseChange.lean`: **4 → 4** (1248 Seam2, 1293 Seam3, 1466 affine, 1488 flatBaseChange). NET helper added (`pullbackPushforward_unit_comp`, axiom-clean).
  - GF `FlatteningStratification.lean`: **5 → 4** (−1: `free_localizationAway_of_away_tower` CLOSED). Remaining: 516 (L4), 1517 (L5), 1597 (genFlatAlg), 1664 (genFlat).
  - QUOT `QuotScheme.lean`: 4 → 4 (no lane). GR / RegroupHelper: 0 (DONE).
- **Net this iter:** −1 active sorry; +2 axiom-clean declarations (1 new helper + 1 closed helper), both independently re-verified via `lean_verify` on the current tree (`{propext, Classical.choice, Quot.sound}` only).
- **Build:** GREEN (LSP diagnostics clean on both touched files; only deprecation/`sorry` warnings).

## Targets

### 1. FBC — `pullbackPushforward_unit_comp` (NEW helper, ~line 1140) — SOLVED
- **Approach:** Abstract mate identity — pseudofunctoriality of the pullback–pushforward unit for
  composable `a : X₁⟶X₂`, `b : X₂⟶X₃` and `N` on the **codomain** `X₃`. Proof body:
  `unit_conjugateEquiv ((adj b).comp (adj a)) (adj (a≫b)) (pullbackComp a b).inv N`, then
  `rw [conjugateEquiv_pullbackComp_inv, Adjunction.comp_unit_app]`, then `rw [← Category.assoc]; exact h`.
- **Key insight:** `conjugateEquiv_pullbackComp_inv : conjugateEquiv … (pullbackComp f g).inv = (pushforwardComp f g).hom`
  is the exact bridge. Initial draft used `N : X₁.Modules` → type mismatch (the unit of the left
  adjoint `pullback` lives on its source = morphism codomain); fixed to `N : X₃.Modules` and
  `.inv.app N` (not `.inv.app (pullback (a≫b) N)`).
- This is the iter-014 conjugate-calculus idiom family (`unit_conjugateEquiv`) reused — the Seam-2
  leg-reindex engine the recipe called for is now a proved, named, reusable lemma.

### 2. FBC — `base_change_mate_fstar_reindex` (Seam 2, ~1168, sorry 1248) — PARTIAL
- **Approach:** Instantiate the engine as `have key := pullbackPushforward_unit_comp e.hom (Spec.map inclA) (tilde M)`;
  with `hfst : pullback.fst = e.hom ≫ Spec.map inclA`, `key`'s RHS unit IS the goal's `unit_pullback.fst`,
  and its LHS `(Spec inclA)`-unit feeds Seam 1 (`base_change_mate_unit_value`). The three pushforward
  coherences are transparent on Γ.
- **Result:** `key` typechecks with the correct shape; goal preserved; `sorry` remains.
- **Dead end (CONFIRMED, documented in-code):** `rw [hfst]` / `rw [hsnd]` both fail
  `motive is not type correct`. The two legs sit in **dependent positions**: the adjunction index,
  the `(IsPullback.of_hasPullback …).w` proof inside `pushforwardCongr`, the `gammaPushforwardIso`
  argument, and — crucially — inside the **type** of the opaque def `base_change_mate_codomain_read`.
  `generalize`-ing the `.w` proof frees the `pushforwardCongr` slot but not the
  `pushforward (pullback.snd …)` / `codomain_read` occurrences (verified via `lean_multi_attempt`).
- **Outstanding obligation:** a multi-hundred-LOC restructure — abstract `codomain_read` with the two
  legs as `subst`-able variables `g' f'`, then after `subst` the Γ-transparent coherences collapse the
  chain to `base_change_mate_inner_value` via Seam 1. **lvb-fbc flags the blueprint as
  under-specifying this mechanism (must-fix).**

### 3. GF — `free_localizationAway_of_away_tower` (was sorry ~1266) — SOLVED (the CHURNING corrective)
- **Approach:** Witness `f := g·a` (`a` a numerator of `h` over `A_g`), three legs:
  1. **Ring side:** `IsLocalization.surj (powers g) h` clears the denominator (`h·algebraMap ↑s = algebraMap a`,
     `s` a unit, `a ≠ 0` ⇒ `g·a ≠ 0`); `Associated (algebraMap a) h` via the unit; then
     `IsLocalization.Away.mul_of_associated` gives `IsLocalization.Away (g·a) A_h`.
  2. **Module side:** the composite `ψ : T →ₗ[A] D` (`D = LocalizedModule (powers h) (LocalizedModule (powers g) T)`)
     is `IsLocalizedModule (powers (g·a))` via **`IsBaseChange.comp`** through `isLocalizedModule_iff_isBaseChange`.
  3. **Transport:** `σ := IsLocalization.algEquiv`; `Module.compHom` action; basis transport via
     `Module.Basis.mapCoeffs σ.symm.toRingEquiv`; `LinearEquiv.extendScalarsOfIsLocalization` upgrade;
     `Module.Free.of_equiv'` finish.
- **Frictions resolved:** `(Units.mul_right_eq_zero u).mp hs` type-mismatch (`h*u=0` vs `u*h=0`) →
  reworked `a ≠ 0` via `calc`; `synthInstance` timeout (20000) on the transported `Away(g·a)`-action →
  `set_option synthInstance.maxHeartbeats 1000000` (honest — the doubly-localised carrier makes the
  `OreLocalization`/`LocalizedModule` instance search genuinely expensive, not looping); `AlgEquiv.commutes`
  via `change` not `show`.
- **Load-bearing simplification:** the auto-resolved `Module A D` (double `LocalizedModule`) — no manual
  `restrictScalars` plumbing. **Witness is the SINGLE product `f := g·a` (`mul_ne_zero hg ha`), NOT `f²`**
  — the plan's `hf0 hf0` squaring worry is **unfounded** (confirmed by lean-auditor + lvb-gf).

### 4. GF — `exists_free_localizationAway_polynomial` (L5, sorry 1517) — BLOCKED (do-not-retry)
- **Approach:** Wire the 5-line assembly: `@IH … hmod1 hfin hmod2 htower` (IH at the reindexed base `A_g`
  on `T_g := (N⧸range φ)_g`) → `free_localizationAway_of_away_tower …` (descend the witness to `f := g·a`).
- **Blocker:** an `OreLocalization` instance-**presentation** diamond between the IH output and the
  generically-compiled helper input. Three layers are defeq but not instance-transparent-equal:
  `CommSemiring A_g` (`OreLocalization.instCommSemiring` vs `CommRing.toCommSemiring`),
  `AddCommMonoid T_g`, and `Module/SMul A_g T_g` (`OreLocalization.instModule` vs `hmod2`/`DistribMulAction.toDistribSMul.toSMul`).
- **Tried (all failed):** `@IH` with explicit instances; `letI`/`haveI` ambient registration + defeq
  synthesis; re-ascribing `htower` against `hmod2.toSMul` / `instAg.toSMul`; full-defeq helper `exact`.
  Even `hmod2.toSMul =?= OreLocalization.instSMul` fails the `haveI` ascription — the mismatch is not
  reducible at the available transparency. The mathematically-complete 5-line assembly is recorded
  verbatim as a code comment above the scoped `sorry`.

## Key findings / patterns
- **`unit_conjugateEquiv` + `conjugateEquiv_pullbackComp_inv` + `comp_unit_app`** is the reusable mate
  idiom for pullback–pushforward unit pseudofunctoriality (now a named project lemma). Reused across
  iter-014 Seam 1 and iter-016 Seam 2.
- **Localisation-of-localisation `IsLocalizedModule`** is best obtained via `IsBaseChange.comp` +
  `isLocalizedModule_iff_isBaseChange` — there *is* a packaged route (the GF chapter's "no packaged
  lemma" note was superseded; `% NOTE` added).
- **`OreLocalization` instance-presentation diamonds** are a recurring GF wall (see Knowledge Base).
  The fix is structural (align the *producing* lemma's emitted instances), never a heartbeat bump.

## Blueprint markers updated (manual)
- `Picard_FlatteningStratification.tex`, `lem:gf_polynomial_core` (proof, step "Descend the witness"):
  added `% NOTE: (iter-016)` documenting the L5 `OreLocalization` instance-presentation blocker and
  the non-local fix (so the planner does NOT re-dispatch a raw L5 prover round).
- `Picard_FlatteningStratification.tex`, `lem:gf_away_tower_descent` (LEAN-DEPS comment): added
  `% NOTE: (iter-016)` superseding the "no packaged localisation-of-localisation lemma" remark — the
  closed proof uses `IsBaseChange.comp`.
- No `\leanok` touched (deterministic sync's domain). No `\mathlibok` (both decls are project decls, not
  Mathlib re-exports). No `\lean{...}` renames (both decls kept the planner's hinted names). No stale
  `\notready` present in the touched chapters.

## Anomaly: GF chapter shows 0 `\leanok` despite closed axiom-clean decls
`Picard_FlatteningStratification.tex` carries **0** `\leanok` markers, even though ≥2 of its pinned decls
(`gf_torsion_reindex` from iter-014, `free_localizationAway_of_away_tower` this iter) are closed and
axiom-clean. `sync_leanok` ran for the current tree (iter 16, sha `9f02062`) but `chapters_touched`
lists only `Picard_QuotScheme.tex` (+2). Root cause is the **known iter-015 KB issue**: `sync_leanok`'s
cold `lake env lean` path times out on this file (heartbeat exhaustion), now **compounded by three
`set_option synthInstance.maxHeartbeats 1000000`** bumps (lines 1015, 1254, 1375) added across iters.
This is **not laundering and not a proof regression** — both decls verify axiom-clean under LSP / `lake build`.
Consequence: the DAG under-represents GF progress (the closed decls look unproven to the dependency graph).
See `recommendations.md` for the suggested mitigation.

## Review subagents (3 dispatched, all returned; reports in `.archon/task_results/` + `logs/iter-016/`)
- **lean-auditor `iter016`** — PASS, **0 must-fix**, 5 major, 3 minor. Both prover-focus decls verified
  REAL (witness `g·a` not `g²`; the 3 `maxHeartbeats` bumps all legitimate). Majors = stale cross-project
  iter markers + one **actively-misleading** stale block (FBC 234–247 claims `pushforward_spec_tilde_iso`
  has an open obligation; it is CLOSED at line 538). All prover-cleanup (review cannot edit `.lean`).
- **lean-vs-blueprint-checker `fbc`** — **2 must-fix** (blueprint under-specifies the Seam-2 abstract-leg
  restructure and the Seam-3 `conjugateEquiv`+`homEquiv_counit` coherence) + new `pullbackPushforward_unit_comp`
  needs a block. 31 decls, no fake statements, no falsely-marked proof blocks.
- **lean-vs-blueprint-checker `gf`** — faithful, **0 red flags**, 42 decls (35 project + 7 Mathlib).
  `free_localizationAway_of_away_tower` matches the chapter; L5 blueprint adequate (blocker is pure Lean
  elaboration). 2 minor enhancements (both applied as `% NOTE`s above).

## Recommendations for next iter
See `recommendations.md`. Headline: (1) blueprint-writer on Cohomology_FlatBaseChange.tex for the Seam-2/3
mechanism (lvb-fbc must-fix, gates the next FBC prover); (2) blueprint block for `pullbackPushforward_unit_comp`
(sole unmatched node); (3) GF L5 is a do-not-retry blocker — structural `gf_torsion_reindex` instance-alignment
refactor first; (4) QUOT Route 2 build resumes (the iter-016 plan decision).
