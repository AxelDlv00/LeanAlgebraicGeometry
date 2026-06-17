# Strategy Critic Report

## Slug
clean207

## Iteration
207

## Routes audited

### Route: Critical path A.1.c.SubT → A.1.c → A.2.c (J := Pic⁰ via FGA)

- **Goal-alignment**: PASS — building Pic⁰_{C/k} as a representable scheme is the right spine for the stated `J`.
- **Mathematical soundness**: PASS — bottom-up ordering (group law → relative functor → representability) is the correct dependency order; you cannot represent a functor you have not yet defined with its group structure.
- **Infrastructure-deferral detected**: yes — A.2.c is currently "6 Prop-valued typeclasses with ⟨sorry⟩ constructors; downstream Route A proceeds under these." Acceptable as scaffolding ONLY because the Posture explicitly forbids any protected decl closing kernel-only while these are open. The planner must hold that invariant: nothing downstream may be reported "done" until the 6 sorries are discharged (timeline given: ~12–16 iters / 600–800 LOC).
- **Effort honesty**: under-counted at the head of the lane — see finding E (A.1.c.SubT marked "active; sole productive lane" yet ~0/it with 120–200 LOC remaining and 3–5 iters left is internally inconsistent).
- **Verdict**: SOUND (with the A.2.c-sorry invariant and the velocity caveat)

### Route: A.2.c representability is RR-free

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — the Grothendieck/FGA construction (Quot scheme + flattening stratification + projectivity, where proper smooth curve ⇒ projective) does not use Riemann–Roch. RR computes dimensions/cohomology; it is not needed to *construct* Pic. The "RR-free" label is correct.
- **Verdict**: SOUND

### Route: Witness definition — degComp vs Pic^z

- **Goal-alignment**: FAIL (as currently scheduled) — the goal demands `J` built **unconditionally and RR-free**. The current witness `degComp` identifies the component by degree, which transits RR; under the USER ROUTE C PAUSE it can never close RR-free. The only RR-free witness path, `Pic^z` (intrinsic identity-component, ~350 LOC), has **no row in the Phases table** — it appears only as a parenthetical in Open Questions ("decide near A.2.c").
- **Infrastructure-deferral detected**: yes — `Pic^z` is required by the goal (given the RR pause) but is unscheduled with no concrete timeline. "Decide near A.2.c" frames a goal-mandatory construction as an optional choice.
- **Verdict**: CHALLENGE

### Route: Albanese UP — rmk:Alb vs Milne Thm 3.2

- **Goal-alignment**: PARTIAL — `isAlbaneseFor` is exactly what must be proven; both routes target it, but see soundness.
- **Mathematical soundness**: PARTIAL — two overclaims. (1) "The UP falls out of A.2.c representability" is too strong: representability yields the *object* Pic⁰, not its universal property; the Albanese UP needs additional input (seesaw / theorem-of-the-cube / functoriality of the relative Pic), even if RR-free. (2) rmk:Alb's stated output is `J^∨` and its own caveat admits autoduality `J^∨ ≅ J` "possibly needs RR." For a goal whose `J = Pic⁰`, that relocates a possible RR dependency from the Thm-3.2 rational-map cone into the autoduality/principal-polarization step — and the principal polarization of a Jacobian classically comes from the theta divisor (RR). So the claim that rmk:Alb is "RR-free" and "obsoletes the entire Thm-3.2 cone" is contingent on an unproven RR-freeness of autoduality.
- **Verdict**: CHALLENGE — the settle-via-auditor posture before A.4 spend is right; do NOT label rmk:Alb "RR-free" or treat the Thm-3.2 cone as obsolete until autoduality is shown RR-free.

### Route: Route C — Riemann–Roch (PAUSED)

- **Verdict**: SOUND — pausing under explicit USER directive with inline sorries satisfied modulo option (c) is a legitimate holding pattern. Note its interaction with the witness route: the pause is precisely what forces Pic^z to be mandatory (above).

### Route: Genus-0 arm

- **Goal-alignment**: PARTIAL — possible redundancy: if A.2.c yields Pic⁰ for all curves, genus 0 is just the special case Pic⁰ = Spec k. A separate arm is only justified if the Albanese UP needs special genus-0 handling.
- **Verdict**: SOUND (low priority; flagged PAUSED) — but the strategy should state whether the general route subsumes genus 0.

## Format compliance

- **Size**: 98 lines / 6712 bytes — within budget (~250 lines / ~12 KB).
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order. ("Posture" is a bolded paragraph under Goal, not a heading — acceptable.)
- **Per-iter narrative detected**: borderline — `27 iters flat` / `27-iter-stuck` are stagnation-duration phrases edging toward history. Not `iter-NNN` references, so minor; recommend replacing with a plain status flag (e.g. "long-stalled").
- **Table discipline**: PASS — 6 canonical columns, two-figure LOC cells throughout.
- **Format verdict**: COMPLIANT (minor drift on the two "27 iters" phrasings)

## Infrastructure-deferral findings

### Deferred: Pic^z (intrinsic identity-component witness)

- **Required by goal**: yes — under the RR pause, degComp cannot produce an RR-free unconditional witness; Pic^z is the only RR-free path to the goal's `J`.
- **Current plan for building it**: none scheduled — a parenthetical in Open Questions ("~350 LOC, identity-component / clopen-descent infra, decide near A.2.c"). No phase row.
- **Timeline**: absent (gated on A.2.c but never promoted to a phase).
- **Verdict**: CHALLENGE — schedule Pic^z as a phase (gated on A.2.c) with an iter/LOC estimate, OR obtain a USER lift of the RR pause so degComp can close. The strategy defers Pic^z, which is required for the stated goal.

### Deferred: A.3 scheme tangent space + Hilbert poly + Pic⁰ AV-structure (undecomposed)

- **Required by goal**: yes — needed for the AV/group structure feeding the witness body and the UP.
- **Current plan for building it**: one ~1100–2100 LOC row, self-flagged "likely under-counted," "absent in Mathlib."
- **Timeline**: vague (26–45 iters for three distinct constructions bundled).
- **Verdict**: CHALLENGE — decompose into sub-phases (scheme tangent space; Hilbert polynomial / Pphifin; AV-structure on Pic⁰) so it can be started and estimated honestly. A huge undecomposed phase is a deferral smell.

## Sunk-cost flags

- `A.4.c.0 — codim-≥2 conclusion … 27 iters flat; likely obsoleted by rmk:Alb` — Why this is sunk-cost: a phase stalled 27 iters at ~0/it is kept alive "EXCISION-PENDING" while the decision that would kill it (rmk:Alb vs Thm 3.2) is itself deferred to "before A.4 spend." Recommendation: make the Albanese-route call **this iter** and excise (or revive) the Stacks-02JK node accordingly; do not carry a 27-iter-dead node pending an unmade decision.

## Prerequisite verification

- `PresheafOfModules.restrictScalars`: **VERIFIED** — exists in `Mathlib.Algebra.Category.ModuleCat.Presheaf.ChangeOfRings` with signature `(α : R ⟶ R') : (PresheafOfModules R') ⥤ (PresheafOfModules R)`. The companion `ModuleCat.restrictScalars` (used at `restrictScalars_map_app`) is also present.
- `(PresheafOfModules.restrictScalars φ).LaxMonoidal` instance (the claimed GAP): **CONFIRMED ABSENT** — loogle returns only `Full`, `Faithful`, `Additive` instances on `restrictScalars`; no `LaxMonoidal`/`Monoidal` instance. This *supports* the strategy: the gap is real and correctly localized to a single missing instance.
- `CategoryTheory.Adjunction.leftAdjointOplaxMonoidal` (the δ/mate apparatus): **MACHINERY CONFIRMED PRESENT, exact name to re-check** — leansearch surfaces `CategoryTheory.Adjunction.IsMonoidal` (`(F ⊣ G) → [F.OplaxMonoidal] → [G.LaxMonoidal] → Prop`) plus `Adjunction.IsMonoidal.leftAdjoint_μ` / `leftAdjoint_ε`, all in `Mathlib.CategoryTheory.Monoidal.Functor`. This corroborates the strategy's claim that "the mate lemma and δ comparison map already ship in Mathlib." The planner should confirm the precise constructor name (`leftAdjointOplaxMonoidal` vs the `IsMonoidal`/`leftAdjoint_μ` API) by `#check` before wiring the recipe.
- `pullbackPushforwardAdjunction`: **UNCONFIRMED this session** — verify by `#check` (project-local or Mathlib); the recipe depends on applying `leftAdjointOplaxMonoidal` to it.

## Must-fix-this-iter

- Route Witness (degComp/Pic^z): infrastructure-deferral CHALLENGE — Pic^z is goal-required under the RR pause but unscheduled. Promote it to a phase row with an estimate, or get the RR pause lifted.
- Route Albanese UP: CHALLENGE — stop labeling rmk:Alb "RR-free" and stop treating the Thm-3.2 cone as obsolete until autoduality `J^∨ ≅ J` is shown RR-free (theta-divisor/principal-polarization risk); drop or qualify "the UP falls out of representability."
- Route A.4.c.0: sunk-cost — resolve the rmk:Alb-vs-Thm-3.2 decision this iter to excise/revive the 27-iter-stuck Stacks-02JK node.
- Route A.3: infrastructure-deferral CHALLENGE — decompose the 1100–2100 LOC tangent+Hilbert+AV block into startable sub-phases.
- Route A.1.c.SubT: CHALLENGE — reconcile "active; sole productive lane" with "~0/it": either the velocity, the 3–5 iters-left, or the "productive" label is wrong.
- Prerequisite verification: `PresheafOfModules.restrictScalars` is VERIFIED present and its `LaxMonoidal` instance is CONFIRMED ABSENT (the gap is real and correctly pinned); still `#check` `Adjunction.leftAdjointOplaxMonoidal` and `pullbackPushforwardAdjunction` directly before committing the lane.

## Overall verdict

CHALLENGE, not REJECT. The spine — `J := Pic⁰_{C/k}` constructed via the FGA/Grothendieck route, with representability genuinely RR-free — is mathematically sound and goal-aligned, and the bottom-up ordering is correct. But two findings bear directly on whether the project can actually reach its stated goal. First, **the strategy defers Pic^z, which is required for the stated goal**: under the USER RR pause the current `degComp` witness cannot close RR-free, and the only RR-free witness path has no scheduled phase. Second, the Albanese route's "RR-free" framing is overclaimed — rmk:Alb outputs `J^∨` and its autoduality bridge to `J = Pic⁰` plausibly reintroduces RR via the principal polarization, so rmk:Alb does not yet demonstrably obsolete the Thm-3.2 cone; the settle-via-auditor decision should be made before any A.4 spend and before the 27-iter-stuck Stacks-02JK node is either excised or kept. Supporting issues: A.3 is an undecomposed mega-phase, and A.1.c.SubT's "productive/~0/it" cells contradict each other. On the positive side, the active lane's prerequisite picture checks out: `PresheafOfModules.restrictScalars` is verified present and its missing `LaxMonoidal` instance is confirmed to be the real, correctly-localized gap — only `Adjunction.leftAdjointOplaxMonoidal` and `pullbackPushforwardAdjunction` remain to be `#check`ed before committing the lane. Format is compliant (minor narrative drift on the "27 iters" phrasings).
