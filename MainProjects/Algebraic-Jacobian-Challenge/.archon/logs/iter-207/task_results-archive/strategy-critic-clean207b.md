# Strategy Critic Report

## Slug
clean207b

## Iteration
207

## Routes audited

### Route: J := Pic⁰ / bottom-up critical path (A.1.c.SubT → A.1.c → A.2.c)

- **Goal-alignment**: PASS — `J := Pic⁰_{C/k}` is the correct Albanese/Jacobian object; the ordering (define the relative Picard functor, then prove it representable) is the only sound dependency order.
- **Mathematical soundness**: PASS — SubT (line-bundle tensor group law) is a prerequisite of the RelPic functor, which is a prerequisite of representability. No step assumes a downstream result.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none in the SubT lane — see Prerequisite verification (all four named Mathlib hooks exist).
- **Effort honesty**: reasonable for SubT/A.1.c; see A.2.c block for the one serious under-count.
- **Parallelism under-exploited**: no (the three nodes are genuinely sequential; the serialization is intrinsic, not a planning artifact).
- **Verdict**: SOUND

### Route: A.2.c — FGA Pic representability is RR-free

- **Goal-alignment**: PASS — representability is exactly what makes `Pic⁰` a scheme, hence a legitimate witness `J`.
- **Mathematical soundness**: PASS on the RR-free claim. The FGA/Nitsure existence proof runs through Hilbert/Quot + flattening + descent and cohomology-and-base-change, none of which is the Riemann–Roch *formula* (h⁰−h¹ = deg+1−g). "Cohomology and base change ≠ RR" — the distinction is real and correctly drawn. The RR transit is correctly isolated to the *degree identification* of the component, not to representability.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — representability itself is encoded as "6 Prop-valued typeclasses with `⟨sorry⟩` constructors," and downstream Route A "proceeds under these." The genuinely hard construction (the Quot/Cartier engine, absent from Mathlib) is the thing being deferred behind those sorries. See Infrastructure-deferral findings.
- **Phantom prerequisites**: "Quot/Cartier engine" is named as a need but not separately phased; Quot schemes do not exist in Mathlib and are a multi-thousand-LOC construction in their own right.
- **Effort honesty**: under-counted. `≈600–800 LOC · 0/it` for "FGA Pic representability" is the classic "200 LOC for representability of Pic" smell. Charitably, 600–800 LOC scaffolds the sorry'd typeclass layer; it does **not** budget the Quot engine that would actually discharge the sorries. The row should disclose that the LOC covers scaffolding, not the proof.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE — not on the RR-free claim (sound) but on (a) the undisclosed gap between "wire sorry typeclasses" and "prove representability," and (b) the absent Quot-engine phase with no LOC/iter budget.

### Route: Albanese UP — `rmk:Alb` vs Milne Thm 3.2

- **Goal-alignment**: PARTIAL — `rmk:Alb` yields the UP for `J^∨`; landing on `J` itself requires autoduality `J^∨ ≅ J`, which the strategy itself flags as "separate, possibly needing RR." The goal's `isAlbaneseFor` is on `J`, so the autoduality bridge is load-bearing, not optional.
- **Mathematical soundness**: PASS — representability does supply the Poincaré bundle, from which a Yoneda-style UP for `J^∨` follows without the RR formula. This is a genuine pivot, not avoidance: `rmk:Alb` leans on representability (already on the critical path for `J` regardless) and trades the codim-1 + codim-≥2 (02JK) + Thm-3.2 cone for the autoduality step. The hardest prerequisite genuinely changes between the two routes, so the infrastructure-deferral "same-hard-prereq pivot" test passes.
- **Sunk-cost reasoning detected**: no — if anything the strategy is correctly trying to *retire* the 27-iter-stuck 02JK node rather than protect it.
- **Phantom prerequisites**: none verified-missing; `rmk:Alb` is a real remark in Kleiman §9.5.
- **Effort honesty**: reasonable, conditional on the route choice resolving.
- **Verdict**: SOUND — with one must-track caveat: do **not** delete the Thm-3.2 cone / 02JK node until `rmk:Alb` is confirmed to deliver the UP-on-`J` *including* an acceptable autoduality bridge. The strategy currently keeps it "EXCISION-PENDING" (hedged, not deleted), which is correct; premature deletion would strand the goal if autoduality's RR-dependence proves blocking.

### Route: `Pic⁰` definition — `degComp` vs `Pic^z`

- **Goal-alignment**: PARTIAL — the goal asserts the witness `J` is "built unconditionally," but the live `degComp` witness transits RR at the degree identification, and RR is USER-PAUSED. The truly-unconditional witness needs `Pic^z` (RR-free identity-component route, ~350 LOC), which is deferred "downstream."
- **Mathematical soundness**: PASS — the `degComp` (degree-0 part, needs RR) vs `Pic^z` (identity component, clopen-descent, RR-free) tension is the standard `Pic⁰`-vs-`Pic^τ`/identity-component distinction and is correctly stated.
- **Infrastructure-deferral detected**: yes — see findings. Deferral is honest (named construction, ~350 LOC, gated "decide near A.2.c") and partly USER-imposed via the Route C pause.
- **Verdict**: SOUND (statement is accurate) but carries an infrastructure-deferral finding below.

### Route: Route C (Riemann–Roch) — PAUSED

- **Verdict**: SOUND — paused by explicit USER directive; files kept imported with sorries satisfied modulo option (c); needed only at the three named Goal nodes. Correctly scoped.

### Route: Genus-0 arm

- **Verdict**: SOUND — both sub-arms ((a) Pic⁰-via-AV-wrap, (b) direct `J := Spec k` via Mumford rigidity) are coherent; (b) is PAUSED under a USER amendment, correctly recorded.

## Format compliance

- **Size**: 98 lines / ~6 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order. (`**Posture:**` and `**Total Route A**` are bold lines, not extra `##` sections.)
- **Per-iter narrative detected**: no — "27-iter-stuck" / "27 iters flat" are stagnation metrics, not references to a specific named iteration. Borderline but acceptable.
- **Accumulation detected**: no — Route C (paused) and A.4.c.0 (excision-pending) are live/under-decision, not completed-dead rows occupying space.
- **Table discipline**: PASS — six canonical columns; every LOC cell carries both `remaining · realized/it`.
- **Format verdict**: COMPLIANT

## Infrastructure-deferral findings

### Deferred: FGA Pic representability (Quot/Cartier engine)

- **Required by goal**: yes — `J := Pic⁰` is a *scheme* only if the relative Picard functor is representable; the witness construction depends on it.
- **Current plan for building it**: representability is axiomatized as 6 Prop-valued typeclasses with `⟨sorry⟩` constructors; downstream Route A proceeds under the sorries. The Quot/Cartier engine that would discharge them is named as a "need" but is not a phased construction with its own budget.
- **Timeline**: vague — the `A.2.c` row's `≈600–800 LOC · 12–16 iters` covers typeclass scaffolding, not the Quot-scheme construction (absent from Mathlib, realistically far larger). No separate timeline for the engine.
- **Verdict**: CHALLENGE — the strategy must either (a) phase the Quot/Cartier engine explicitly with an honest LOC/iter budget, or (b) state plainly that representability remains sorry-axiomatized under option (c) and that no protected decl will be kernel-clean until the engine lands. Conflating "scaffold the typeclasses" with "prove representability" hides the project's single largest construction.

### Deferred: `Pic^z` (fully-RR-free witness)

- **Required by goal**: yes — the goal says `J` is "built unconditionally"; the live `degComp` witness transits RR, so the unconditional end-state needs `Pic^z` (or full Route C).
- **Current plan for building it**: named (`Pic^z` redefinition, identity-component / clopen-descent, ~350 LOC), gated "decide near A.2.c."
- **Timeline**: gated, not absent — a concrete trigger exists, and the underlying RR is USER-PAUSED (so this deferral is partly directive-imposed, not planner avoidance).
- **Verdict**: CHALLENGE (low) — acceptable as a tracked dependency, but the planner must keep the `Pic^z` trigger concrete and not let "decide near A.2.c" drift; the Posture paragraph already honestly admits no protected decl is kernel-clean, which is the right disclosure.

## Prerequisite verification

- `PresheafOfModules.pullbackPushforwardAdjunction`: VERIFIED (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`).
- `CategoryTheory.Adjunction.leftAdjointOplaxMonoidal` (+ `_δ`): VERIFIED (`Mathlib.CategoryTheory.Monoidal.Functor`) — supplies the δ comparison map the SubT lane relies on.
- `ModuleCat.restrictScalars` lax monoidal lemma → `ModuleCat.instLaxMonoidalRestrictScalars`: VERIFIED (`Mathlib.Algebra.Category.ModuleCat.Monoidal.Adjunction`), `[CommRing R] [CommRing S]` (fine for structure sheaves). The strategy's "lift of the existing lax lemma" is accurate.
- `(PresheafOfModules.restrictScalars φ).LaxMonoidal` (sectionwise): MISSING (as the strategy claims) — the genuine project-side gap. Plausible ~40–90 LOC lift of the ModuleCat instance to the presheaf level. The blocker pin is honest.

## Must-fix-this-iter

- Route A.2.c: CHALLENGE — disclose that the `600–800 LOC` budgets only the sorry'd typeclass scaffolding, and either phase the Quot/Cartier engine with an honest budget or state explicitly that representability stays sorry-axiomatized under option (c).
- Infrastructure-deferral (FGA representability): CHALLENGE — Quot engine is required by the goal and has no project-side phase/timeline; resolve per above.
- Route Albanese: track the autoduality (`J^∨ ≅ J`) RR-dependency as load-bearing; keep 02JK "excision-pending," do not delete until `rmk:Alb` is confirmed to deliver UP-on-`J`.
- Infrastructure-deferral (`Pic^z`): CHALLENGE (low) — keep the "decide near A.2.c" trigger concrete.

## Overall verdict

The strategy is mathematically sound and well-formatted (COMPLIANT), and its load-bearing Mathlib prerequisites for the active SubT lane all verify — the blocker pin to a single ~40–90 LOC `(restrictScalars φ).LaxMonoidal` sectionwise instance is honest and the δ/adjunction/lax-monoidal scaffolding genuinely ships in Mathlib. The bottom-up critical path is correctly ordered and A.2.c representability is legitimately RR-free; the `degComp`-vs-`Pic^z` and `rmk:Alb`-vs-Thm-3.2 framings are accurate and the latter is a real pivot, not avoidance. The compression preserved internal coherence (I could not diff against the prior version, only audit the current file, which is self-consistent). The two material concerns are deferrals the planner must surface rather than paper over: **the strategy defers FGA Pic representability (the Quot/Cartier engine), which is required for the stated goal**, behind sorry'd typeclasses with an under-counted 600–800 LOC budget that does not include the engine; and **the strategy defers `Pic^z`, which is required for the goal's "unconditional witness"** (the live `degComp` witness transits USER-paused RR). Both are honestly flagged in prose but should be either explicitly phased with budgets or explicitly declared as accepted option-(c) sorry-axiomatizations so the gap between "scaffolded" and "proven" is not lost.
