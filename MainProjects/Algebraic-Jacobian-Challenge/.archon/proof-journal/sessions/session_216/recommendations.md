# Recommendations for iter-217 (plan agent)

## CRITICAL / BLOCKING — fix the blueprint before any prover on the linchpin

The iter-216 blueprint rewrite (the structural pivot) is now **demonstrably wrong in two must-fix ways** (lean-vs-blueprint-checker ts216, `task_results/lean-vs-blueprint-checker-ts216.md`). The HARD GATE will block the prover anyway, but address it deliberately:

1. **`lem:tensorobj_restrict_iso` + `lem:tensorobj_assoc_iso` — "free-cover avoids H1" is FALSE.** The prover's make-or-break (which the planner explicitly requested as the reversal signal) found the consumer `tensorObj_isLocallyTrivial` applies `tensorObj_restrict_iso W.ι M N` to **arbitrary** `M N`; the restrict is commuted past the sheafified tensor before triviality is used, so **H1 is on the critical path**. Dispatch a **blueprint-writer** to delete the free-cover-shortcut paragraphs (chapter lines ~641–657) and state H1 as the genuine residual. *(Review agent has already added a `% NOTE:` at both proof blocks flagging this.)*

2. **`lem:tensorobj_assoc_iso` proof sketch ≠ Lean.** The rewritten sketch says "direct gluing, no whiskering"; the Lean pin still uses the route-(d) three-step composite (`W_whiskerRight_of_W`/`W_whiskerLeft_of_W`/`isIso_sheafification_map_of_W` + presheaf associator) and never invokes `tensorObj_restrict_iso`. The writer must EITHER align the sketch to the actual whiskering route OR explicitly mark direct-gluing as the *planned, not-yet-realized* target. *(`% NOTE:` added.)*

**The planner's own pre-committed reversal signal has fired.** iter-216 plan.md: "prover finds the free-cover restriction-compatibility itself requires the general presheaf-pushforward adjunction (H1) → the pivot relocated the gap." This is exactly what happened. Per that plan, the recorded fallback was "run the `J.W.IsMonoidal`→`Sheaf.monoidalCategory` head-to-head." **However, the prover explicitly recommends NOT reverting to route-(e)/d.2** (d.2 = varying-ring stalk-⊗ is harder than H1). The pivot did relocate the gap to a *smaller, more mechanical* one (H1, ~100–150 LOC), so the de-risking is real even though the "avoids H1" claim was wrong. The decision for iter-217 is: **build H1**, not revert.

## Closest-to-completion / promising

- **H1 = presheaf-level `pushforwardPushforwardAdj`** is now the single named Mathlib-absent linchpin for `tensorObj_restrict_iso`. Concrete recipe (prover-supplied): presheaf-level `pushforward β ⊣ pushforward φ` ⇒ `pushforward β ≅ pullback φ` via `Adjunction.leftAdjointUniq`; mirror `SheafOfModules.pushforwardPushforwardAdj` at the presheaf level, adding presheaf `pushforwardNatTrans`/`pushforwardCongr` (`pushforwardId`/`pushforwardComp` already exist). ~100–150 LOC.
- **Presheaf H2 lift (bounded, NO Mathlib gap):** from a NatIso `α` of ring presheaves, build `(PresheafOfModules.restrictScalars α).Monoidal` via `Functor.Monoidal.ofLaxMonoidal`, app-wise using the new `restrictScalars_isIso_{μ,ε}_of_bijective` + a `CommRingCat`/`RingCat`-iso→`Bijective` bridge + a `toPresheaf`-reflects-isos step. Then `tensorObj_restrict_iso = H1.symm ≫ H2 ≫ defeq`.
- After H1+H2 close `restrict_iso` → re-route `assoc_iso` onto it and delete the 18 vestigial in-file helpers (−1 sorry from the whiskering wall).

## Do NOT retry (blocked / dead ends — confirmed multi-iter)

- **Free-cover specialisation of `tensorObj_restrict_iso`** — does NOT avoid H1 (iter-216 make-or-break, first-hand-verified by review + lean-vs-blueprint-checker). Do not re-dispatch on this premise.
- **Route-(e) `(J.W).IsMonoidal` / d.1 / d.2** (varying-ring stalk-⊗) — d.2 is harder than H1; the whiskering apparatus is vestigial. Do not revert.
- **Sectionwise flatness; section-level Tor₁** — abandoned dead ends (iters 211–213).

## Stale-documentation cleanup (lean-auditor ts216, 4 major + 4 minor)
Non-blocking but accumulating. Fold into the next prover's objective or a `refactor` pass:
- Module "Status" header (L37–72) + `tensorObj` (L826) + `tensorObj_functoriality` (L843) docstrings still claim "typed sorry" though bodies are real; `monoidalCategory` listed as pinned but was removed.
- ROUTE (d)/(e) label inconsistency (L605 says "(e)", L555/583 say "(d)", L692 says "(e)").
- Minor: `@[simp]` on `restrictScalarsRingIsoTensorEquiv_apply_tmul` with `letI`-local instances likely won't fire in simp contexts (BP-1) — consider a canonical-instance variant if it's meant for `simp`.
- Minor: pin the 5 substantive iter-216 decls in the blueprint (`restrictScalars_isIso_{μ,ε}`, `restrictScalarsMonoidalOfRingEquiv`, `_of_bijective` ×2) — they are the H2 core and currently have no `\lean{}` hint.

## Process note for the planner
The iter-216 deferral ("no prover dispatch this iter") did **not** prevent a prover from running. If a future deferral must truly hold, ensure `Current Objectives` carries no dispatchable lane, not just narrative text saying "deferred".

## Standing strategic escalation (still live — surface to USER unchanged)
The 7-iter ⊗-substrate grind is route-A-specific and would be **mooted** if the USER lifts the RR pause (then `Pic⁰` via divisor classes; infra already present). The PRIMARY GOAL (A.2.c) has no live discharge lane under the pause except this substrate. This is the project's highest-leverage decision — unchanged from iter-216.
