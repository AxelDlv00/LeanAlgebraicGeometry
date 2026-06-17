# Iter-025 plan — both iter-024 bottlenecks closed; dispatch the unblocked `injective_cech_acyclic` frontier; decide the absolute-Hⁿ realization (Ext)

## Entering state (verified)
iter-024 ran both lanes: **+21 axiom-clean decls, 0 new sorries, build GREEN.** BOTH named targets landed:
- **`cechFreeComplex_quasiIso`** (FreePresheafComplex) — free Čech resolution of `O_𝒰`, the project's
  longest churn (absent 020–023), via Route B (arrow-iso transfer along `cechFreeEvalEngineIso`).
- **`ses_cech_h1`** (CechBridge) — Čech-H¹ sheaf-gluing surjectivity, full Stacks `lemma-ses-cech-h1`.

Project sorry = 2 (superseded relative-form `CechAcyclic.affine` L110; frozen P5b
`CechHigherDirectImage.lean:679`). `injective_cech_acyclic`'s two gates are now both in hand → it is the
genuine ready frontier. Coverage debt had grown to 32 unmatched `lean_aux` helpers (both iter-024 lvb
reports flagged this).

## What I did this iter (plan phase)
1. Processed iter-024 results (task_done += the two landings; task_pending rewritten: free side DONE,
   `ses_cech_h1` DONE, `injective_cech_acyclic` promoted to frontier).
2. **blueprint-writer `coverage-025`**: bundled all 32 prover-created helpers into the `\lean{}` lists of
   `lem:ses_cech_h1` / `lem:cech_engine_complex` / `lem:cech_free_eval_engine_iso` /
   `lem:cech_free_eval_nonempty`. `archon dag-query unmatched` 32→0, no broken `\uses`.
3. **mathlib-analogist `abscohom-025`** (api-alignment): settled how to realize absolute `Hⁿ(U,F)` — the
   next obstacle gating 01EO + the P5a consumers. **Headline: `Hᵖ(U,F):=Ext^p(𝒪_U,F|_U)` via Mathlib
   `Abelian.Ext`.** The strategy's suspected `CategoryTheory.Sheaf.H`+forget route was **REFUTED** (no
   AddCommGrp-valued sheaf cohomology exists in Mathlib); `Functor.rightDerived` has injective vanishing
   but **no LES**. Ext is the only route shipping the 01EO LES off-the-shelf
   (`Ext.covariant_sequence_exact`, `Ext.eq_zero_of_injective`, `Ext.homEquiv₀`, `HasExt.standard`).
   → `analogies/absolute-cohomology.md`.
4. **blueprint-writer `extcohom-025`**: added `def:absolute_cohomology` (`Hᵖ:=Ext^p`) + 6 `\mathlibok` Ext/
   restriction anchors; rewired `lem:affine_serre_vanishing` + `lem:cech_to_cohomology_on_basis` to `\uses`
   it and cite the Ext LES + injective vanishing. (Sets up the post-`injective` endgame; cheapest action.)
5. **blueprint-reviewer `iter025`** (whole blueprint, HARD GATE): **CLEARS `lem:injective_cech_acyclic`**
   (faithful + formalize-ready, both gate deps `\leanok`); all 6 Ext anchors sound. One must-fix: undefined
   `\restriction` macro → **fixed by planner** (`\providecommand{\restriction}{\upharpoonright}` in
   `macros/common.tex`). No unstarted-phase proposals.
6. STRATEGY.md: refreshed the P3b + P5a active rows (quasiIso + ses_cech_h1 done; injective next); resolved
   the absolute-Hⁿ open question (→ Ext); updated the Mathlib-gaps line.
7. Wrote PROGRESS.md (1 frontier lane, scaffold keyword ON the path line — noop-trap guard), task ledgers,
   this sidecar.

## Decision made

### D1 — Adopt `Ext` as the absolute-cohomology realization (the analogist's ALIGN_WITH_MATHLIB verdict).
**Chosen:** `Hᵖ(U,F):=Ext^p(𝒪_U,F|_U)` via `CategoryTheory.Abelian.Ext`. **Why:** it is the *only* route
where Mathlib ships the load-bearing 01EO long exact sequence off the shelf — the dimension-shift proof of
01EO is unbuildable without a sheaf-cohomology LES, and both other routes force a multi-hundred-LOC
from-scratch build (β = the whole abelian-sheaf cohomology theory, which is *absent*; α = re-deriving the
derived-category→`rightDerived` LES bridge). **Trade-off:** introduces a second derived-functor framework
(Ext alongside `Functor.rightDerived` for `Rⁱf_*`), but **no bridge between them is forced** — the protected
goal uses the Leray acyclic-resolution lemma (no LES), and absolute `Hᵖ` appears only in 01EO/02KG.
**Cheapest reversal signal:** Ext universe/smallness bookkeeping over `SheafOfModules` proves painful →
fall back to Route γ (Čech colimit `Hᵖ:=colim_𝒰 Ȟᵖ`, reusing the existing section-Čech infra), NEVER β.
Recorded in STRATEGY `## Open strategic questions` and TO_USER (FYI, overridable).

### D2 — One frontier lane this iter (`injective_cech_acyclic`), not forced parallelism.
Both iter-024 lanes closed; the only genuinely-ready frontier node is `injective_cech_acyclic` (a one-step
op-transport assembly, every ingredient `\leanok`). The other candidates are not clean: `cech_eq_cohomology_of_basis`
(01EO) needs the Ext infra scaffolded first (next iter); `cechAugmented_exact` needs the general-qcoh
`F≅~ΓF` relative↔section bridge. Forcing a second cold lane would thrash budget on an unready target. The
parallelism directive is satisfied by the parallel *blueprint* work (coverage + Ext blocks) done this iter;
the prover frontier is honestly width-1 right now. The Ext-scaffold becomes the parallel partner next iter.

## Subagent skips
- **progress-critic**: BOTH active routes (FreePresheafComplex, CechBridge) closed their named targets in
  iter-024 (sorry→0, the cleanest convergence in the recent window) — the descriptor's skip condition "the
  only active route just completed in the prior iter (closing out)" holds for both. This iter opens a fresh
  frontier node (`injective_cech_acyclic`) whose gates *just* landed — there is no multi-iter trajectory to
  extrapolate and no churn signal (it was correctly *gated*, never attempted/churned). Re-running the critic
  would have no trajectory data to assess.
- **strategy-critic**: the strategy's route structure (Route A acyclic-resolution; the P3b torsor-free
  bridge) is unchanged and was confirmed sound by the iter-024 review ("strategy needs no change"). This
  iter's only strategic refinement is *resolving an already-open question* (absolute-Hⁿ → Ext) with a
  well-cited Mathlib finding — a HOW-to-execute infra decision, the mathlib-analogist's territory, not a
  route-soundness question. No new route, split, or reorder; no live CHALLENGE/REJECT from the prior pass.

## Risks / watch
- `injective_cech_acyclic`: the only risk is a defeq-carrier / functor-coercion `rw` snag in the
  op-transport (the recurring project obstacle) — mitigated by the KB `erw`/`refine .trans` escape; partials
  hand off a precise decomposition (mathlib-build, no sorry).
- Ext realization: universe/smallness over `SheafOfModules` (the analogist's named fallback trigger) — will
  surface when the Ext scaffold lane runs next iter, not this iter.
