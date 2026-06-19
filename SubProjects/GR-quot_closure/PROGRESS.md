# Project Progress

## Current Stage

prover  (GR-seed cone DELIVERED iter-001; SNAP-S0 residue ACTIVE. ★ `tensorObjAssoc_eta_factor_sheaf`
math fully PROVEN axiom-clean iter-016; only ★'s final placement is open. iter-017 progress-critic =
**STUCK** (4 iters flat) → corrective = mathlib-analogist consult, DONE, which **re-diagnosed the wall
and returned a concrete fix**: the >4M-heartbeat cost is **head-misalignment, NOT term size** — after
`simp only [hc]` the goal carries the `LocalizedMonoidal` comp head, but the failing `exact` lets the
generic coherence's `M` default to `X.Modules` (native `instCategory` head) ⇒ `isDefEq` can't
short-circuit and traverses the whole 1.2M-char term across the diamond. FIX = pin the generic's `M` to
the synonym so the heads match. LIVE = ★ (gates B4/B5), B6, B7. comm = invertibility-gated FUTURE.)

## Stages
- [x] init
- [x] autoformalize
- [ ] prover — GR-seed cone delivered (iter-001). SNAP-S0 residue ACTIVE.
      iter-007/008 built the inherited canonical monoidal structure; iter-009 closed
      `tensorPowAdd_zero_right`; iter-011 proved B1; iter-012 closed B2/B3 (`rfl`) + assembled B5;
      iter-013 REDUCED B4 to ★ + proved `sheafification_map_unit_eq`; iter-014/015 found the comp-bridge
      `hc` (★ prefix compiles); iter-016 PROVED ★'s residual as a generic coherence
      (`tensorObjAssoc_associator_counit_coherence` + 6 helpers, axiom-clean) but ★'s placement `exact`
      blew >4M heartbeats. iter-017: mathlib-analogist re-diagnosed = head-misalignment; close ★ via the
      head-pinned `exact (M := LocalizedMonoidal …)` recipe, then B6 (committed), B7. χ-blocked DEFERRED.
- [ ] polish — after SNAP residue closes.

## End-state overview

**ACHIEVED (iter-001):** goal seed `AlgebraicGeometry.Grassmannian.represents` sorry-free and
axiom-clean. GR-quot representability cone (Nitsure §1/§5) delivered and merge-ready. SNAP is
self-contained, so SNAP's shape does NOT affect the delivered goal.

**iter-017 — progress-critic `snap-conv-17`: STUCK** (sorry 6→6 for 4 iters; +11 helpers, 0 reduction;
"comp-instance diamond" blocker recurred ≥3 iters). The mandated corrective — a mathlib-analogist consult
— was dispatched and **returned a concrete, actionable diamond-elimination plan**, so the STRATEGY
hard-stop's escalation trigger ("consult yields no actionable path → escalate to user") is **NOT** met.
Per the standing AUTONOMOUS directive (find the best path; do not escalate while a concrete mechanical
route is untried), this iter EXECUTES the analogist's fix; it does NOT escalate. See
`iter/iter-017/plan.md` for the escalation-condition reasoning.

**The re-diagnosis (decision-critical, `analogies/coherence-placement.md`).** The >4M-heartbeat wall is
**head-misalignment, not term size.** The `simp only [hc, …]` prefix already normalizes ★'s goal so every
`≫` carries the `LocalizedMonoidal` comp head. But the closer `exact
tensorObjAssoc_associator_counit_coherence …` leaves the generic's `M` to default to `X.Modules`, whose
ambient `[Category]` is the **native** `Scheme.Modules.instCategory` ⇒ the generic's conclusion
instantiates with the native head, mismatching the goal's synonym head ⇒ `isDefEq` cannot short-circuit
and must unfold the entire ~1.2M-char term across the rfl-diamond. **Align the heads (pin `M` to the
synonym) and the 1.2M chars become cheap.** `Monoidal.induced`/`transport`, statement-abstraction (2a),
and `convert`/`congr` are all REJECTED (see analogies file — they don't dissolve the synonym-headed-API
diamond, break B4, or re-incur whole-term traversal).

**B6 under-dispatch (critic must-fix, addressed):** B6 `tensorPowAdd_assoc` (diamond-free, iso-level,
independent of ★) was bundled behind ★ as a "stretch only if ★ closes" for 3 iters and never attempted.
A separate parallel FILE-lane is blocked by the B6→B7 co-dependency (B7, upstream in this file, consumes
B6). So B6 is instead **promoted to a committed co-equal objective in this lane** (gets dedicated budget
regardless of ★'s outcome) — the intent of the under-dispatch fix, executed within the dependency
constraint. Rationale in `iter/iter-017/plan.md`.

**Live scope = the ∀L assoc chain ONLY** (★, B6, B7). comm (`sectionsMul_mul_comm`,
`tensorBraiding_self_eq_id_of_isInvertible`, `tensorPowAdd_comm`) is invertibility-gated FUTURE work with
no consumer (`GCommSemiring` unbuilt) — NOT chased this iter.

## Current Objectives

1. **`AlgebraicJacobian/Picard/SectionGradedRing.lean`** — Blueprint: `chapters/Picard_SectionGradedRing.tex`
   (`lem:tensorObjAssoc_eta_factor_sheaf` [★, sorry ~line 2737], `lem:tensorPowAdd_assoc` [B6, ~3045],
   `lem:sectionsMul_mul_assoc` [B7, ~3082]; done modulo ★: `lem:tensorObjAssoc_eta_factor` B4,
   `lem:tensorObjAssoc_hom_sectionsMul` B5; axiom-clean: the generic
   `tensorObjAssoc_associator_counit_coherence` + 6 staging helpers, `sheafification_map_unit_eq`,
   B1/B2/B3, `tensorPowAdd_zero_right`). `[prover-mode: prove]`

   **Recipe source (READ FIRST): `analogies/coherence-placement.md`** (the head-alignment re-diagnosis +
   exact closer) and `analogies/comp-instance-diamond.md` (the `hc` comp-bridge). Do these in order:

   - **STEP A — ★ via the head-pinned `exact` (try FIRST; cheap if it works).** ★'s prefix already
     compiles; only the final placement `sorry` (~line 2737) is open, and the residual goal IS the
     proven generic coherence. The wall was head-misalignment, not size. Harvest the explicit residual
     args via `lean_goal` at the sorry (DEFAULT pp, NOT `pp.all`), then close with the generic **pinned
     to the synonym instance** so its conclusion instantiates with the SAME comp head the `hc`-normalized
     goal carries:
     ```
     exact tensorObjAssoc_associator_counit_coherence
       (M := LocalizedMonoidal (sheafificationMon X) (sheafificationW X) (localizationUnitIso X))
       <eA> <eB> <eC> <eF> <eR> <n> <m1> <m3> <m4> <m5> <m6> (sheafification_map_unit_eq _)
     ```
     (substitute the real iso/object names read off the goal). Supplying the five isos + `n` pins all
     objects so NO unification search runs; `(M := synonym)` aligns the comp head ⇒ the `isDefEq` should
     short-circuit at the top instead of traversing the diamond. Verify with `lake build` (LSP hides
     kernel timeouts), NOT a forbidden `maxHeartbeats 1e6`.
     **Residual risk (analogist):** the `▷`/`◁`/`α_` monoidal-STRUCT heads (project `monoidalCategory`
     vs `Localization.Monoidal`'s, rfl-defeq but syntactically distinct) may form a SECONDARY diamond
     `hc` does not bridge; if the head-pinned `exact` still blows ~200k, this risk has materialized → go
     to STEP A′.
   - **STEP A′ — ★ fallback (only if STEP A's head-pinned `exact` still times out).** Restate
     `tensorObjAssoc_eta_factor_sheaf` UNIFORMLY in `LocalizedMonoidal`-comp: build its LHS/RHS from
     `Localization.Monoidal` ops (not project `monoidalCategory` ops) so a single comp/struct head
     appears throughout and the final `exact` is purely syntactic; reconcile the one resulting equation
     at B4 (`tensorObjAssoc_eta_factor`, ~2747, which consumes ★ as `key`) by a single `rfl`/defeq. This
     mirrors Mathlib's own `Localization/Monoidal/Basic.lean` `pentagon`/`triangle` discipline (never
     leaves the synonym) and is the durable fix if the struct-diamond materialized.
   - **★ closes ⇒ B4 (`tensorObjAssoc_eta_factor`) + B5 (`tensorObjAssoc_hom_sectionsMul`) become
     axiom-clean AUTOMATICALLY** (their bodies compile modulo ★).

   - **B6 `tensorPowAdd_assoc` (~3045) — COMMITTED this iter (NOT a stretch; attempt regardless of ★).**
     Iso-level canonical pentagon, diamond-free, SOUND ∀L, independent of ★. Order: do STEP A first
     (cheap); if ★ closes, continue to B6 then B7; if STEP A does NOT close, **bank B6 BEFORE attempting
     the heavier STEP A′** (B6 must get dedicated budget this iter — it has been deferred 3 iters).
     `(μ_{m,m'} ▷ L^m'') ≫ μ_{m+m',m''} ≫ eqToIso(add_assoc) = α ≫ (L^m ◁ μ_{m',m''}) ≫ μ_{m,m'+m''}`.
     Pentagon induction on `m`: iter-014 reduced the base to the explicit unit-triangle coherence; the
     succ case unfolds `tensorPowAdd (k+1)`, bridges whiskerings, applies `ih`, telescopes `tensorObjIso`
     pairs ⇒ collapses to `MonoidalCategory.pentagon` `[verified — class field of MonoidalCategory]`. If
     the succ case hits the comp-instance diamond, reuse the explicit-`instCategory` `hc` bridge (the
     WORKING variant from ★) and, for the final coherence placement, the SAME head-pin lesson as STEP A.

   - **B7 `sectionsMul_mul_assoc` (~3082) — only AFTER ★ closes.** Assemble mirroring
     `sectionsMul_mul_one`: after `simp only [gMul_mul_apply]`, combine (1) B5 (axiom-clean once ★
     closes), (2) a NEW μ-slide helper (whiskered-`sectionsMul` naturality with a general comparison
     `Γ(μ)` in place of a single `η` — analogue of B2/B3; build only after ★ is closed), (3) B6, then
     `sectionsCast_self`.

   **Verify:** `lake build AlgebraicJacobian.Picard.SectionGradedRing` (LSP hides `(kernel) deterministic
   timeout`); `#print axioms` = `[propext, Classical.choice, Quot.sound]` on ★, B4, B5 (and B6/B7 if
   closed), NO `sorryAx`. Do NOT add `maxHeartbeats 1e6`. Commit compiling closed legs; do not leave a
   non-compiling scaffold. comm decls stay `sorry`.
   **If STEP A AND STEP A′ both fail** (the struct-diamond resists even the uniform-synonym restatement),
   write a PRECISE blocker to your task result (the exact residual + which head/step fails and why) —
   this is the genuine last mechanical variant and triggers user escalation. Do NOT fabricate a pin,
   weaken the statement, or add `maxHeartbeats`.

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
The ★/B6/B7 prose is unchanged + vetted; the iter-017 blocker is pure Lean instance-head-alignment
mechanics (NOT a blueprint inadequacy — the math, associativity via the pentagon, is sound + the abstract
coherence is proven) ⇒ NO chapter edit this iter (the 7 staging helpers are `private`, leaving the
unmatched scan, owing no blueprint entry); blueprint-reviewer skipped (see iter sidecar). Dangling refs
remain in DEFERRED chapters (`Cohomology_FlatBaseChange.tex`, `QuotScheme.tex`, `GlueDescent.tex`,
`RelativeSpec.tex`) + the in-file `lem:relativeTensor_as_coequalizer` ref — extraction/out-of-cone
artifacts, resolve at merge-back.

## Standing notes

- **Prover model:** `opus`.
- **Cold-build validation:** `lake build AlgebraicJacobian.Picard.SectionGradedRing` (LSP hides
  `(kernel) deterministic timeout`); do NOT add `maxHeartbeats 1e6`.
- **No LLM API key in env** — use blueprint + Mathlib search + the analogist subagent.
- **Nothing is protected** — `archon-protected.yaml` has no active entries; the prover may add helpers +
  re-sign unprotected SNAP decls freely (the ★ fix needs NO protected-signature edit; the STEP A′
  fallback re-signs ★ to LocalizedMonoidal-comp, which is unprotected).
- **Merge-back discipline:** the iter-007 monoidal-localization pivot DIVERGES from the sibling by
  design. Never add `\leanok` by hand.
