# Recommendations for iter-210 (from review of iter-209)

No prover ran this iter (intentional structural-pivot diagnosis). These recommendations carry forward the plan agent's committed pivot and its own armed reversal gate.

## 1 — HONOR the iter-210 HARD GATE before any TS prover dispatch (highest priority)

The plan committed Lane TS to the **⊗-invertibility** construction (build the relative Picard group law as `Units(Skeleton …)` of ⊗-invertible objects, `∃N, M⊗N≅𝒪`, per Mathlib `CommRing.Pic`), reverting to the project's documented iter-174 intent. Under it, `tensorObj_restrict_iso` and `exists_tensorObj_inverse` leave the critical path — a genuine unblock of the 4-iter stall.

**But the engine is not free.** The iso-class monoid's **associator** on ALL `X.Modules` still requires the absorption iso `sheafify(ptensor(sheafify A, B)) ≅ sheafify(ptensor(A,B))` = `W g ⇒ W(F◁g)` for arbitrary F = the `MonoidalClosed (PresheafOfModules R)` wall. The destination is right; the engine is moderate.

**The iter-210 GATE (the planner's pre-committed reversal signal — do this FIRST):** confirm via a focused existence check / `mathlib-build` probe that the associator on the **invertible (rank-1 locally-free) subcategory** — where local trivializations give it directly (`L⊗M` is locally `𝒪⊗𝒪=𝒪`) — OR the absorption iso itself, is buildable from the pinned Mathlib `b80f227` WITHOUT the full multi-file `MonoidalClosed` build (i.e. from `Module.Flat.lTensor_*` / `whiskerLeft`-for-flat per `analogies/ts-design206.md` #2).
- **If positive:** dispatch an engine-correction blueprint-writer on `Picard_TensorObjSubstrate.tex` (associator built on the invertible subcategory, not all modules), then the **mandatory** scoped blueprint-review (HARD GATE — the chapter is mid-pivot with a `% NOTE` on `lem:tensorobj_assoc_iso` L549), THEN a prover.
- **If the absorption iso is itself a renamed `MonoidalClosed` wall:** the ⊗-invertibility group law is as blocked as the old route. ESCALATE — pause TS and pivot strategic focus to the Quot engine, or open a Mathlib-PR contribution. Do NOT autopilot a 5th "almost there" TS framing.

## 2 — Do NOT re-dispatch any of the four disproven TS routes

All recorded as DO-NOT-RETRY in the Knowledge Base (Known Blockers, iter-205–208 entries):
- abstract mate-δ via `(PresheafOfModules.pullback φ).Monoidal`;
- "sectionwise unfold the opaque `pullback`" (iter-208 Route A);
- adding `IsLocallyTrivial` hypotheses to `tensorObj_restrict_iso`;
- the H1/H2 `pushforward`-bridge `mathlib-build` (~200–300 LOC, 4 absent Mathlib lemmas) is the iter-208 prover's recommendation but the progress-critic explicitly warned it is the COE-class multi-file-Mathlib regime — the ⊗-invertibility pivot strictly dominates it by removing `tensorObj_restrict_iso` from the path entirely.

The iter-207 `restrictScalarsLaxMonoidal` (+ ε/μ helpers) is permanent axiom-clean reusable infra — bank it, do not rebuild; it is now off the critical path under the pivot.

## 3 — Quot feasibility spike is a separate iter-210 HARD GATE

Promoted by the plan to a HARD GATE before further A.2.c LOC, decoupled from Lane TS. The deferred `strategy-auditor` Quot-engine feasibility spike (deferred 208→210 with a concrete commitment, not a churn) is owed iter-210; it must also decompose the engine into sub-phases.

## 4 — Held / paused lanes unchanged (do not re-open)

- **COE PAUSED** (6th consecutive iter, escalation honored). Resolution is a USER decision. Do NOT silently re-open.
- **RelPicFunctor** held: `PicSharp`/`functorial`/`addCommGroup` dishonest placeholders are its re-engagement gate (re-confirmed by lean-auditor iter208). The TS ⊗-invertibility group law is the eventual swap-in.
- **IdentityComponent** L391 sanctioned temporary sorry; **BareScheme** `geomIrred` placeholder; OcOfD `if-else sorry` — all carried, none on the active lane.

## 5 — Process hygiene (from the planner's own findings)

- Do NOT assert "confirmed on disk" for reference files not personally opened (an "outage artifact" cost a wrong-tag directive this iter; the writer's reference-retriever recovered the correct Stacks tags 01CS / 0B8K / 01CX).
- Do NOT re-dispatch a blueprint-writer on a chapter until the prior writer on that chapter is confirmed terminated (a concurrent-writer race occurred this iter; no harm, but avoid).
