# Iter-233 (Archon canonical) — review

## Outcome at a glance

- **The "three parallel lanes land axiom-clean infra, but the lead lane stops at the d.2 *forward map*
  (not the iso), the critical-path counter rises, and 2 of 3 new files are orphans" iter.** Three
  prover lanes, all status `done`:
  - **`StalkTensor.lean`** (mathlib-build, d.2 — the named critical path): NEW file, 7 axiom-clean decls
    building the FORWARD comparison map `stalkTensorDesc : (A⊗ᵖB).stalk x ⟶ A_x⊗_{R_x}B_x`. The
    blueprint-pinned ISO `stalkTensorIso` is **not** built. **Orphan** (not imported). 0 sorries.
  - **`FlatBaseChange.lean`** (mathlib-build, engine): 3 axiom-clean `Scheme.Modules` iso-locality
    criteria; first wired into `affineBaseChange_pushforward_iso`'s reduction. 2 engine sorries unchanged.
    **Imported into the canonical build this iter** (plan refactor `wire-flatbasechange`).
  - **`HigherDirectImage.lean`** (prove, engine): NEW scaffold, 4 decls; `higherDirectImage` no-sorry but
    conditional on `[HasInjectiveResolutions X.Modules]`; 3 honest sorries. **Orphan.**
- **Canonical sorry count:** the FlatBaseChange wiring took canonical **81 → 83** (its 2 deep sorries now
  counted); **no prover lane closed an existing canonical sorry.** Canonical exits ≈83. (iter-232
  `meta.json` = 82; persistent ±1 nuance. iter-233 `meta.json` not finalized at review time.) **16 iters
  since iter-217 with no canonical-sorry elimination on the Picard critical path.**
- **Build GREEN** (all three files compile; FlatBaseChange `lake env lean` exit 0). **Blueprint-doctor
  CLEAN.** **`sync_leanok` +51/−0, sha `35e4721a`**; no `\leanok` on the unbuilt `stalkTensorIso` — no
  laundering.

## The defining tension

Real motion in absolute terms — the d.2 lane is the **first concrete construction** toward the
varying-ring stalk–tensor commutation, a bottleneck dodged ~20 iters via the now-dead dual detour — but
three things sting:

1. **The d.2 ISO does not exist.** Only the forward additive map landed. The iso (`stalkTensorIso`) is
   what unblocks `isLocallyInjective_whiskerLeft_of_W` → unconditional associator → `thm:pic_commgroup`,
   and it is multi-iter away (`stalkTensorDescU_smul` carrier-duality plumbing → linear map → reverse map
   ~150–250 LOC → bundling). So the counter-moving datapoint is still owed.
2. **The canonical counter rose +2** (deliberate FlatBaseChange wiring) and no existing sorry closed.
   Honest — those sorries were always real — but critical-path velocity remains 0/iter.
3. **Two of three new files are orphans.** `StalkTensor.lean` (0 sorries) and `HigherDirectImage.lean`
   (3 sorries) are invisible to the canonical build. Wiring StalkTensor is **free** and the single
   highest-priority mechanical follow-up; the prover flagged it explicitly.

The planner's pre-committed rebuttal — "the counter cannot drop via the substrate this iter; that is a
*finding*, not avoidance" — is defensible: the d.2 dependency is a genuine ~200–400 LOC infra build, and
both alternative associator routes were correctly refuted (flat-restriction is circular/false;
Mathlib monoidal-sheafification absent). But progress-critic ts233 = STUCK on TS stands, and the lead
lane must not become a helper-churn loop. **The next d.2 round must land at least `stalkTensorLinearMap`,
or the reverse-map strategy should be reconsidered before continuing.**

## Process correctness

- **Provers: all three on-target and honest.** Axiom-clean for everything landed (`{propext,
  Classical.choice, Quot.sound}` verified repeatedly in-session); mathlib-build lanes pinned **no** sorry
  (each step fully proved or absent); the `prove` lane's 3 sorries are honestly scoped with precise
  Mathlib-gap write-ups. The HigherDirectImage prover made the right call carrying `[HasInjectiveResolutions]`
  as an explicit hypothesis rather than sorrying an `EnoughInjectives` instance (which would have silently
  contaminated consumers).
- **Planner: sound diagnosis + real parallelism.** The d.2 reframe is the correct read of the bottleneck;
  the FlatBaseChange wiring discharged iter-232's top mechanical action item; the engine de-gating opened
  genuine stall-independent work. One process slip recorded by the planner itself (a botched duplicate
  blueprint-writer dispatch, recovered by hand) — already logged, not recurring here.
- **Review subagents: 4 dispatched, 0 must-fix-this-iter across all.** lean-auditor + 3
  lean-vs-blueprint-checkers. Findings are "major" blueprint-documentation gaps + 2 code-correctness
  items on `flatBaseChange_higherDirectImage_isIso` (missing `1 ≤ i`; `Nonempty (…≅…)` weakening) — all
  folded into `recommendations.md`. Auditor confirmed the StalkTensor cocone proof is a genuine
  computation, not a defeq-collapsed triviality.

## Markers updated (manual)

- `Picard_TensorObjSubstrate.tex`, `lem:stalk_tensor_commutation`: `% NOTE (iter-233)` — only the forward
  map `stalkTensorDesc` formalized; iso `stalkTensorIso` deferred (block stays unmarked).
- `Cohomology_HigherDirectImage.tex`, `def:higher_direct_image`: `% NOTE (iter-233)` — conditional
  `[HasInjectiveResolutions X.Modules]` hypothesis; orphan module.

## Owed datapoints / watch

- d.2: `stalkTensorLinearMap` next round (gate the lane).
- Mechanical: wire `StalkTensor.lean` into the aggregator (free).
- Code: fix `flatBaseChange_higherDirectImage_isIso` (`1 ≤ i` + `Nonempty`).
- Blueprint-writer: 3 "major" documentation gaps (StalkTensor sketch under-specified; HigherDirectImage
  hypothesis/weakening recording; FlatBaseChange locality-lemma supplement).
