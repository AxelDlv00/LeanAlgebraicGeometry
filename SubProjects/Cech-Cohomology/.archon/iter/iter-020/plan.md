# Iter-020 plan — effort-break the per-V homotopy, clear coverage debt, dispatch 3 CONVERGING lanes

## Entering state (verified)
iter-019 ran all 3 lanes: **+29 axiom-clean decls, 0 new sorries, build GREEN, TWO named targets
landed** — `dDiff_exact` (P3 L1 step (a): positive-degree `Function.Exact` of the un-localised section
module complex `D•`, incl. the localisation-transitivity keystone `comparison_isLocalizedModule`) and
`cechComplex_hom_identification` (P3b bridge). Project sorry = 2 (superseded relative-form
`CechAcyclic.affine` line 109; frozen P5b at `CechHigherDirectImage.lean:715`).

Residual handoffs: P3 steps (b)–(d) (sheaf-section sub-build, `dDiff_exact` ready as input);
`cechFreeComplex_quasiIso` reduced to one per-`V` obligation by iter-019's `quasiIso_of_evaluation`
(the per-`V` contracting homotopy is the ~20-decl combinatorial core); `injective_cech_acyclic` held on
the quasi-iso. iter-019 review must-fix: blueprint for `lem:cech_free_complex_quasi_iso` under-specified
(no Lean packaging pathway). lean-auditor: 0 must-fix on Lean, 4 stale-comment majors.

## What I did this iter (plan phase)
1. **Processed iter-019 results** (task_done/task_pending updated; 3 prover result files cleared).
2. **progress-critic `iter020`** (dispatched first): all 3 routes **CONVERGING**, 0 CHURNING/STUCK,
   dispatch=OK. Binding conditions recorded (see Decision D1).
3. **effort-breaker `quasiiso`**: split `lem:cech_free_complex_quasi_iso` into a 6-link `\uses` chain
   along route (a) (direct prepend homotopy). Resolves the iter-019 lvb must-fix (Lean packaging
   pathway now in each sub-lemma sketch). Gave the already-built `quasiIso_of_evaluation` a blueprint home.
4. **blueprint-writer `coverage`**: 28→0 unmatched. New `def:section_cech_module_complex` +
   `lem:section_cech_module_exact` blocks for the D• infra; bundled `homCechSectionCosimplicialIso`,
   `isIso_Fmap_homologyMap`, `isIso_of_evaluation`. (One judgment call: wired the new def downward to
   avoid a 4-cycle; proposes splitting `depDiff_exact` into its own leaf — non-blocking, noted in PROGRESS.)
5. **blueprint-clean `iter020`**: purity pass (4 small edits: stripped 2 file-path refs + the
   Lean-strategy ExtraDegeneracy sentence + a "private"→"auxiliary" keyword). Source quotes verified.
6. **blueprint-reviewer `iter020`** (whole blueprint, HARD GATE): **CLEARS all 3 prover files**; 0
   must-fix; quasi-iso under-specification must-fix **RESOLVED**; 1 "soon" wire-up (I fixed it directly:
   added `lem:section_cech_module_exact` to `lem:cech_acyclic_affine`'s proof `\uses`).
7. **refactor `stalecomments`**: fixed the 2 stale-comment majors in files no prover touches this iter
   (CechHigherDirectImage `pushPullMap_comp` "not closed" landmine; AcyclicResolution module docstring).
   The other 2 (CechBridge, FreePresheafComplex docstrings) folded into this iter's prover instructions.
8. Verified deterministically: `unmatched` = 0, `gaps` = 0. Wrote PROGRESS.md (3 lanes), task ledgers.

## Decision made

### D1 — Dispatch the same 3 files, re-scoped to this iter's frontier (effort-broken + gate-cleared).
- **Lane 1 `FreePresheafComplex.lean`** (the per-V homotopy, BINDING): the progress-critic set a hard
  clock — Route 2 must ATTEMPT the per-`V` contracting homotopy this iter, not another infra round, or
  it tips to CHURNING at iter-021. The corrective the critic named (blueprint expansion) is done via the
  effort-break, which turns the monolith into 5 small bottom-up sub-lemmas with the Lean pathway. This
  is the sanctioned response and it executes the homotopy attempt.
- **Lane 2 `CechAcyclic.lean`** (P3 steps b–d): step (a) `dDiff_exact` landed; b–d are lighter
  sheaf-section bookkeeping with a ready `Function.Exact` input. SLIPPING watch — aim to close b–d.
- **Lane 3 `CechBridge.lean`** (injective bridging infra): `injective_cech_acyclic` is blocked on
  Lane-1's quasi-iso, but its step-1 bridging lemma (contravariant additive `Hom(-,I)` on injective `I`
  sends a resolution quasi-iso to `Hom`-cochain exactness) is a GENERAL categorical fact provable
  standalone — productive parallel prep that makes `injective_cech_acyclic` a one-step assembly next iter.

### D2 — Route (a) (direct prepend homotopy) over route (b) (ExtraDegeneracy) for the quasi-iso.
The iter-019 prover flagged a fork: (a) port `CombinatorialCech.combHomotopy` to ModuleCat vs (b) reuse
`AugmentedCechNerve.extraDegeneracy` à la `Rep.standardComplex`. I DECIDED (a): the chapter's existing
prose already describes the prepend homotopy directly, and `CombinatorialCech.combHomotopy`/`_spec`
(`dh+hd=id`) already proves exactly this combinatorial content — route (b) would additionally need a
sectionwise identification of `(evaluation V).obj K(𝒰)` with the linearized Čech nerve of `I₁`, an extra
bridge. Route (b) is recorded as the documented fallback. Cheapest reversal signal: if the prover finds
the ModuleCat-level `dh+hd=id` port intractable (e.g. the dependent-direct-sum index algebra resists),
re-dispatch effort-breaker at sentence granularity on `_prepend_homotopy_spec`, or pivot to route (b).

## Subagent skips
- **strategy-critic**: STRATEGY.md content unchanged this iter (no route swap, no phase
  complete/split, no >30% estimate change); the iter-019 CHALLENGE (P5a re-sign RELOCATES the
  absolute-cohomology obligation) was addressed in STRATEGY.md and is not live. All 3 active routes
  are CONVERGING (progress-critic). Re-running a fresh-context strategy critic on an unchanged,
  uncontested strategy would be a hollow dispatch.
- **strategy-auditor / mathlib-analogist**: not needed — no new route or infrastructure-definition
  design this iter; the quasi-iso route shape was validated in iter-018 (`p5a`/analogies) and the fork
  is decided in D2 on the prover's own analysis.

## Risks / watch
- Lane 1: `_prepend_homotopy_spec` (`dh+hd=id`) is the genuine combinatorial core (~effort 1105); it is
  a transcription of the proved `combHomotopy_spec`, but the constant-coefficient ModuleCat repackaging
  may surface index/sign bookkeeping. Fallback in D2.
- Lane 2: if b–d don't all close, revise P3 iters-left upward next iter (progress-critic SLIPPING).
- No external-LLM key in env; rely on subagents + LSP.
