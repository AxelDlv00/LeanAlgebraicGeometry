# Project Progress

## Current Stage

prover  (GR-seed cone DELIVERED iter-001; SNAP-S0 residue ACTIVE. iter-013 REDUCED B4 to the isolated
sheaf-level identity ★ `tensorObjAssoc_eta_factor_sheaf` (closing ★ auto-cleans B4/B5). iter-014/015
diagnosed + SOLVED the tactic blocker: the real obstruction was the `LocalizedMonoidal`/`X.Modules`
`CategoryStruct.comp` INSTANCE diamond; iter-015 found the WORKING comp-bridge (keyed to the explicit
native instance `Scheme.Modules.instCategory`, placed inside the big `simp`) ⇒ ★'s PREFIX now COMPILES
and ends in ONE clean residual sorry = the associator-naturality coherence. progress-critic iter-016 =
**CHURNING** (PARTIAL×5 metric; structural-advance caveat: mechanism IS found) → corrective =
**REFACTOR/decompose** (extract the residual as a `private` helper, small goal). LIVE = ★ (gates B4/B5),
B6, B7. comm = invertibility-gated FUTURE, no consumer.)

## Stages
- [x] init
- [x] autoformalize
- [ ] prover — GR-seed cone delivered (iter-001). SNAP-S0 residue ACTIVE.
      iter-007/008 built the inherited canonical monoidal structure; iter-009 closed
      `tensorPowAdd_zero_right`; iter-011 proved B1; iter-012 closed B2/B3 (`rfl`) + assembled B5;
      iter-013 REDUCED B4 to ★ + proved `sheafification_map_unit_eq`; iter-014/015 diagnosed +
      solved the comp-instance diamond (★ prefix compiles, ONE residual sorry). iter-016: DECOMPOSE
      ★ — extract the residual associator-naturality coherence as a `private` helper, prove it in a
      small goal, plug into ★ (auto-cleans B4+B5); then B6, B7. χ-blocked nodes remain DEFERRED.
- [ ] polish — after SNAP residue closes.

## End-state overview

**ACHIEVED (iter-001):** goal seed `AlgebraicGeometry.Grassmannian.represents` sorry-free and
axiom-clean. GR-quot representability cone (Nitsure §1/§5) delivered and merge-ready. SNAP is
self-contained, so SNAP's shape does NOT affect the delivered goal.

**iter-016 — progress-critic `snap-conv-16`: CHURNING (technical) + structural-advance caveat.** Sorry
flat at 3 live-assoc legs for 5 iters (PARTIAL×5 = automatic CHURNING trigger), BUT the critic confirms
this is NOT the same wall 5×: each PARTIAL is a distinct structural advance, and iter-015 found the
WORKING bridge — ★'s proof prefix COMPILES and the leg went from "unknown mechanism" to "one isolable
residual." The flat count is a metric artifact (it measures the ★/B6/B7 legs, not sub-helpers).

**Corrective EXECUTED this iter (endorsed by the critic): REFACTOR / decompose.** The residual at
SGR.lean:2609 is the genuine associator-naturality coherence — a clean, isolable statement. Extract it
as a standalone `private` helper with a SMALL clean signature, prove it in isolation (small goal ⇒ the
bounded-ordered `erw` close + `εc` cancellation is cheap to find, no 1.2M-char goal inspection), then
plug it into ★'s already-compiling prefix. This attacks the goal-size ROOT CAUSE; it is a new action,
NOT a reworded re-dispatch of the unbounded-erw tactic.

**HARD STOP (critic must-fix): the decomposition is the last autonomous mechanical variant. If the
extracted small-goal helper STILL resists a bounded-erw close, escalate to the user (no further
non-user variants) and revise the STRATEGY throughput row. Do NOT fabricate a pin or weaken the
statement.** — Note: escalation is warranted ONLY if the decomposed small-goal proof genuinely fails;
the standing AUTONOMOUS directive means we do NOT escalate while a concrete mechanical path (this
decomposition) remains untried. See `iter/iter-016/plan.md` for the rebuttal to a literal-hard-stop read.

**Live scope = the ∀L assoc chain ONLY** (★, B6, B7). comm (`sectionsMul_mul_comm`,
`tensorBraiding_self_eq_id_of_isInvertible`, `tensorPowAdd_comm`) is invertibility-gated FUTURE work with
no consumer (`GCommSemiring` unbuilt) — NOT chased this iter.

## Current Objectives

1. **`AlgebraicJacobian/Picard/SectionGradedRing.lean`** — Blueprint: `chapters/Picard_SectionGradedRing.tex`
   (`lem:tensorObjAssoc_eta_factor_sheaf` [★, line ~2458], `lem:tensorPowAdd_assoc` [B6, line ~2877],
   `lem:sectionsMul_mul_assoc` [B7, line ~2917]; done modulo ★: `lem:tensorObjAssoc_eta_factor` B4,
   `lem:tensorObjAssoc_hom_sectionsMul` B5; axiom-clean: `lem:sheafification_map_unit_eq`, B1/B2/B3,
   `tensorPowAdd_zero_right`). `[prover-mode: prove]`

   **PRIORITY: ★ to closure FIRST via DECOMPOSITION (full budget on ★ this iter). B6 is a stretch goal
   only if ★ closes early. B7 only after ★.**

   - **★ `tensorObjAssoc_eta_factor_sheaf` (~2458) — THE MUST-FIX. Close via decomposition.**
     The proof PREFIX already compiles (lines 2575–2598): the explicit-`instCategory` comp-bridge `hc`
     (do NOT touch it — it is the verified working bridge, NOT the reflexive default), the big
     `simp only [hc, Category.assoc, tensorObj, MonoidalCategory.tensorHom_def, …]`, and one verified
     `erw [Iso.hom_inv_id_assoc]` @2598. The SINGLE remaining `sorry` @2609 is the genuine
     **associator-naturality coherence**: LHS carries `(α_ A B C).hom` (canonical associator on the
     SHEAVES `A B C`), RHS carries `(α_ (sheafification.obj TA)(sheafification.obj TB)(sheafification.obj TC)).hom`
     (on the sheafified presheaves), related through the three counit isos `εc A`/`εc B`/`εc C`.
     **STEP 1 — EXTRACT.** `lean_goal` at line 2609 (use the DEFAULT pretty-printer, NOT `pp.all` — the
     1.2M-char `pp.all` form is what made the search expensive last iter). Read off the residual
     equation, generalize the relevant morphisms/objects (`A B C` and the `εc`/`α` factors), and state
     it as a NEW `private lemma` (e.g. `tensorObjAssoc_associator_counit_coherence`) ABOVE ★ with that
     small clean signature. `private` ⇒ it leaves the `unmatched` scan, so NO blueprint entry is owed
     (it is a mechanical implementation detail of ★, not a distinct math milestone).
     **STEP 2 — PROVE the helper in its small goal.** The closing steps are already individually
     verified to fire: `erw [MonoidalCategory.associator_naturality]` on the coherence step, then the
     `εc` counit `hom`/`inv` cancellations (`erw [Iso.hom_inv_id_assoc]` / `Iso.inv_hom_id_assoc`) +
     `Category.comp_id`/`rfl`. In the SMALL extracted goal these are cheap to order (no 1.2M-char
     inspection). Use a BOUNDED ordered sequence — `erw [associator_naturality]; erw […]; …` one step
     at a time in goal order; `conv` to focus a subterm if a step's defeq search is slow. NEVER
     unbounded `repeat erw` (200k-heartbeat timeout). NEVER `maxHeartbeats 1e6`.
     **STEP 3 — PLUG IN.** Replace ★'s `sorry` @2609 with `exact <helper> …` (or `rw`/`erw [<helper>]`
     then `rfl`). ★ closes ⇒ B4 (`tensorObjAssoc_eta_factor`) and B5 (`tensorObjAssoc_hom_sectionsMul`)
     become axiom-clean AUTOMATICALLY (their bodies already compile modulo ★).
     **If the extracted small-goal helper STILL will not close with a bounded ordered `erw` sequence**
     (the coherence genuinely resists even in isolation), STOP and write a PRECISE blocker to your task
     result (the exact residual small goal + which `erw` step fails and why) — this triggers user
     escalation. Do NOT fabricate a pin, weaken the statement, or add `maxHeartbeats`.
     **Recipe sources:** `analogies/comp-instance-diamond.md` (the comp-bridge + in-synonym lemma set);
     `task_results` iter-015 "Concrete next step"; worked template `tensorPowAdd_zero_right` (~L2412).

   - **B6 `tensorPowAdd_assoc` (~2877) — STRETCH (only if ★ closes with budget to spare).** Iso-level
     canonical pentagon, diamond-free, independent of ★.
     `(μ_{m,m'} ▷ L^m'') ≫ μ_{m+m',m''} ≫ eqToIso(add_assoc) = α ≫ (L^m ◁ μ_{m',m''}) ≫ μ_{m,m'+m''}`.
     Pentagon induction on `m`, SOUND ∀L. iter-014 reduced the base case to the explicit unit-triangle
     coherence; the succ case unfolds `tensorPowAdd (k+1)`, bridges whiskerings, applies `ih`,
     telescopes `tensorObjIso` pairs ⇒ collapses to `MonoidalCategory.pentagon` `[verified — class field
     of MonoidalCategory]`. If the succ case hits the SAME comp-instance diamond, reuse the
     explicit-`instCategory` `hc` bridge from ★ (the WORKING variant, NOT the reflexive default).

   - **B7 `sectionsMul_mul_assoc` (~2917)** — assemble mirroring `sectionsMul_mul_one`, ONLY after ★
     closes. After `simp only [gMul_mul_apply]`, combine (1) B5 (axiom-clean once ★ closes), (2) a NEW
     μ-slide helper (whiskered-`sectionsMul` naturality with a general comparison `Γ(μ)` in place of a
     single `η` — analogue of B2/B3; build only after ★ is closed), (3) B6, then `sectionsCast_self`.

   **Verify:** `lake build AlgebraicJacobian.Picard.SectionGradedRing` (LSP hides `(kernel) deterministic
   timeout`); `#print axioms` = `[propext, Classical.choice, Quot.sound]` on ★, B4, B5 (and B6/B7 if
   closed), NO `sorryAx`. Do NOT add `maxHeartbeats 1e6`. Commit compiling closed legs; do not leave a
   non-compiling scaffold. comm decls stay `sorry`.

## Deferred (NOT objectives this iter)

- **comm chain (`sectionsMul_mul_comm`, `tensorBraiding_self_eq_id_of_isInvertible`, `tensorPowAdd_comm`):**
  invertibility-gated FUTURE work. Route in the blueprint + `analogies/invertible.md`. No consumer
  (`GCommSemiring` assembly unbuilt) → not chased until the assoc chain lands AND a `GCommSemiring`
  consumer is built.
- **RelativeTensorCoequalizer coverage debt (~15 helpers, L302–445):** lack `\lean{}` blocks + a
  docstring cites the dangling `lem:relativeTensor_as_coequalizer`. PROVEN out-of-cone, NOT in the
  ★/B6/B7 path. Deferred to a dedicated post-assoc blueprint-writer round.
- **χ-blocked (`QuotScheme.lean`, 4 sorries):** `hilbertPolynomial` (χ-semantic), `QuotFunctor`,
  `Grassmannian` functor. Need a higher-cohomology engine this i=0 leg lacks; filled from the
  cohomology leg at merge. Genuine gap; not blind-formalizable.
- **`RelativeSpec.lean`:** Route-A sibling chapter, no phase in this leg. Out of scope.
- **Out-of-cone debt:** weak `Scheme.Grassmannian.representable` skeleton; goal does not rely on it.

## Blueprint health (non-gating, deferred to merge-back)

iter-012 gate12 PASS: `Picard_SectionGradedRing.tex` complete + correct, 0 must-fix on the active cone.
The ★/B6/B7 prose is unchanged + vetted; the iter-016 blocker is pure Lean instance-diamond mechanics
(NOT a blueprint inadequacy — the math, associativity via the pentagon, is sound) ⇒ NO chapter edit this
iter (the extracted helper is a `private` implementation detail that leaves the unmatched scan, owing no
blueprint entry); blueprint-reviewer skipped (see iter sidecar). Dangling refs remain in DEFERRED
chapters (`Cohomology_FlatBaseChange.tex`, `QuotScheme.tex`, `GlueDescent.tex`, `RelativeSpec.tex`) + the
in-file `lem:relativeTensor_as_coequalizer` ref — extraction/out-of-cone artifacts, resolve at merge-back.

## Standing notes

- **Prover model:** `opus`.
- **Cold-build validation:** `lake build AlgebraicJacobian.Picard.SectionGradedRing` (LSP hides
  `(kernel) deterministic timeout`); do NOT add `maxHeartbeats 1e6`.
- **No LLM API key in env** — use blueprint + Mathlib search + the analogist subagent.
- **Nothing is protected** — `archon-protected.yaml` has no active entries; the prover may add the new
  `private` helper + re-sign unprotected SNAP decls freely (the ★ fix needs NO protected-signature edit).
- **Merge-back discipline:** the iter-007 monoidal-localization pivot DIVERGES from the sibling by
  design. Never add `\leanok` by hand.
