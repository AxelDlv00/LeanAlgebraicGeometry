# Iter-026 plan — P3b bridge COMPLETE; absolute-cohomology realization pinned to Form B (cheap corepresenting object); scaffold `AbsoluteCohomology.lean`

## Entering state (verified)
iter-025 landed **`injective_cech_acyclic`** (CechBridge, axiom-clean, first try) — the THIRD and final
P3b Čech↔derived bridge brick. With `cechFreeComplex_quasiIso` + `ses_cech_h1` (iter-024), **the P3b bridge
is COMPLETE**. Project sorry = 2 (superseded relative `CechAcyclic.affine` L110; frozen P5b
`CechHigherDirectImage.lean:679`). The genuine next frontier is the absolute-cohomology phase
(def → 01EO → 02KG), realized via Ext — but `def:absolute_cohomology` still hedged between two Ext forms.

## What I did this iter (plan phase)
1. Processed iter-025 results (task_done += `injective_cech_acyclic`; task_pending rewritten: bridge COMPLETE,
   new absolute-cohomology lane opened). lvb PASS, lean-auditor 0 must-fix (3 stale-comment majors carried).
2. **Verified the form fork myself (existence check, allowed):** loogle `_ ⊣ restrictFunctor _` is EMPTY ⇒
   `j_!` (extension-by-zero functor) is absent from Mathlib ⇒ Form B-via-functor and Form A's
   restriction-preserves-injectives both blocked at the functor level. Confirmed `Ext.homEquiv₀`,
   `restrictAdjunction` (wrong direction), `open_immersion_pushforward_comp` (it's relative affine vanishing,
   NOT restriction-injectives — the iter-025 analogist remark was wrong).
3. **mathlib-analogist `restrict-inj`** (api-alignment): THE pivotal finding — Form B needs only the **object**
   `jShriekOU U := sheafify(free(yoneda U))`, not the `j_!` functor. ~50–80 LOC from shipped
   `freeYonedaHomEquiv` + `sheafificationAdjunction`. Under Form B injective vanishing + LES are off-the-shelf
   Ext (SES stays in `X.Modules`, `I` 2nd arg), and **restriction-preserves-injectives is eliminated**.
   → `analogies/restriction-preserves-injectives.md`.
4. **strategy-critic `extroute`** (parallel, read-only): CHALLENGE (switch to rightDerived-global) +
   NON-COMPLIANT format. Rebutted the CHALLENGE (below); executed the format fix (STRATEGY.md restructured
   to 89 lines / 8 KB, per-iter narrative stripped, table cells collapsed, decisions-log removed).
5. **blueprint-writer `formb`**: rewrote the absolute-cohomology section to Form B — `def:jshriek_ou`,
   `lem:jshriek_corepr` (corepr iso), `def:absolute_cohomology` (three clauses off `jShriekOU`); removed the
   `restrictFunctor` anchor; reconciled the 01EO proof. leandag clean.
6. **blueprint-clean `formb`**: purity pass — no edits needed; source quotes intact, no Form-A artifacts.
7. **blueprint-reviewer `iter026`** (whole blueprint, HARD GATE): **CLEARS `AbsoluteCohomology.lean`** —
   chapter `complete: true · correct: true`, all Ext API verified against Mathlib source, 0 must-fix.
   Advisory: `letI := HasExt.standard X.Modules` early (TC timeout guard). No unstarted-phase proposals.
8. Wrote STRATEGY.md (Form B realization + Completed row for the P3b bridge), PROGRESS.md (ONE scaffold lane,
   noop-trap keyword on the path line), task ledgers, TO_USER.md, this sidecar.

## Decision made

### D1 — Absolute cohomology = Form B `Ext^p_{X.Modules}(jShriekOU U, F)`, `jShriekOU := sheafify(free(yoneda U))`.
**Chosen** over Form A (`Ext(O_U, F|_U)`) and over the strategy-critic's rightDerived-global. **Why:** the
analogist found the corepresenting OBJECT is cheap (~50–80 LOC of shipped-piece reuse) even though the `j_!`
FUNCTOR is absent (200–500 LOC). Form B then gets injective vanishing AND the LES off-the-shelf from
`Abelian.Ext` with the SES never leaving `X.Modules`, so **restriction-preserves-injectives — the obligation
that made Form A expensive — is not needed at all.** **Trade-off:** introduces a second derived-functor
framework (Ext alongside `rightDerived` for `Rⁱf_*`), but no bridge between them is forced (the protected goal
uses Leray acyclic-resolution, not a LES; absolute `H^p` appears only in 01EO/02KG and the P5a last-mile
bridge, where Ext-via-injective-resolution is clean). **Cheapest reversal signal:** Ext universe/smallness
bookkeeping over `SheafOfModules` proves painful in the scaffold → fall back to Route γ (Čech colimit),
NEVER `Sheaf.H` (absent).

## Prior critique status (strategy-critic `extroute`)
- **CHALLENGE: "price restriction-preserves-injectives or switch to rightDerived-global" — ADDRESSED by
  rebuttal + a better third option.** The critic's challenge rests on the premise that Form B (or Form A's
  injective-vanishing) requires building the full `j_!` functor (≈ restriction-preserves-injectives, 200–500
  LOC). That premise is **refuted** by the analogist's (later, deeper-API) finding: Form B needs only the
  *object* `jShriekOU = sheafify(free(yoneda U))`, ~50–80 LOC of shipped reuse, and then
  restriction-preserves-injectives is **eliminated, not deferred** (the SES stays in `X.Modules`; the
  injective sits in the 2nd Ext arg). So the obligation the critic demanded I price or escape simply does not
  arise under the adopted realization. rightDerived-global, by contrast, requires hand-building the δ-LES
  (the critic concedes Mathlib does not package it) — strictly more work than ~50–80 LOC of Ext-wrapper reuse,
  and it would discard the already-blueprinted+cleared Ext anchors. Form B dominates. The critic's underlying
  worry (don't carry an unbuilt hard prerequisite for ~5 iters) is fully honoured: the realization now has no
  such prerequisite. **No strategy change to rightDerived; recorded as the chosen rebuttal.**
- **NON-COMPLIANT format — ADDRESSED.** STRATEGY.md restructured in-place: per-iter "DECIDED (iter-NNN)"
  narrative stripped, the decisions-log appendix in `## Open strategic questions` removed, table cells
  collapsed to one line, file now 89 lines / 8 KB (< 12 KB). Added a `## Completed` row for the P3b bridge.

## Subagent skips
- progress-critic: the sole active route (P3b bridge) **just completed in the prior iter** —
  `injective_cech_acyclic` landed axiom-clean first try (CONVERGING, zero churn), closing the last brick.
  This iter opens a brand-new file (`AbsoluteCohomology.lean`) with NO prior attempts, so there is no
  trajectory to extrapolate (the descriptor's "the only active route just completed in the prior iter" skip
  condition). No CHURNING/STUCK route is in play.

## Risks / watch
- The scaffold is low-risk reuse, but `Abelian.Ext` over `SheafOfModules X.Modules` may hit TC-synthesis
  (`HasSmallLocalizedHom`) or universe friction — the reviewer's `letI := HasExt.standard X.Modules` advisory
  is in the objective. If the scaffold partials on a TC/universe snag, that is the reversal signal toward
  Route γ; one partial is not yet that signal (re-attempt with the idiom first).
