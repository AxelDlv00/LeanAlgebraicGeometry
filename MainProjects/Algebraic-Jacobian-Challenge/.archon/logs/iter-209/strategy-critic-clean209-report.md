# Strategy Critic Report

## Slug
clean209

## Iteration
209

## Routes audited

### Route: A.1.c.SubT — line-bundle group law via ⊗-invertibility (iter-209 pivot)

- **Goal-alignment**: PASS — the units-of-⊗-iso-classes group is exactly the Picard group; correct end-state.
- **Mathematical soundness**: PARTIAL — the *endpoint* is correct (for any symmetric monoidal category, ⊗-invertible objects = `Units (Skeleton C)`, and the group axioms come free from the monoidal coherence). The *premise* is what's shaky: see below.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — the pivot's "mechanical coherence isos" presuppose the hard fact rather than removing it. The coherence isos are claimed to be `sheafification.mapIso (PresheafOfModules.Monoidal.<iso>)`. But the presheaf-level associator is an iso `sheafify((M⊗N)⊗P) ≅ sheafify(M⊗(N⊗P))`, whereas the associator you actually need on the **sheaf** category is `(sheafify M ⊗ sheafify N) ⊗ sheafify P ≅ sheafify M ⊗ (sheafify N ⊗ sheafify P)`. Bridging the two requires the lax-monoidal comparison maps `sheafify M ⊗ sheafify N → sheafify(M⊗N)` to be **isomorphisms** — i.e. **sheafification is strong monoidal / "sheafification commutes with ⊗."** That is precisely the "sheafification commutes with localization" fact the directive asks about, and it is the *same* content the discarded `tensorObj_restrict_iso` encoded — moved one layer down, not eliminated. The pivot is only genuinely mechanical IF the pinned Mathlib already ships a **symmetric monoidal instance on the sheaf-of-modules category** (with strong-monoidal sheafification proven upstream). The strategy never names that instance.
- **Phantom prerequisites**: the **monoidal structure on `Scheme.Modules`** and its **coherence isos** (associator/unitor/braiding) — VERIFIED ABSENT from pinned Mathlib `b80f227`. Mathlib ships `PresheafOfModules.Monoidal.tensorObj` (presheaf level) and the `CommRing.Pic = Units (Skeleton (ModuleCat R))` idiom (both confirmed present), but **no monoidal/tensor instance on the sheaf-of-modules category** — the project's own `TensorObjSubstrate.lean:199` defines `Scheme.Modules.tensorObj` by hand, sheafifying the presheaf tensor. So `sheafification.mapIso (PresheafOfModules.Monoidal.<iso>)` does not return a *sheaf-level* coherence iso unless the sheaf-level monoidal structure is built AND sheafification is strong monoidal. The cited `CommRing.Pic` idiom is for modules over a **single fixed ring** — a plain monoidal category with **no sheafification at all** — so it does not establish the sheaf case it is invoked to validate.
- **Effort honesty**: under-counted/internally inconsistent — the row reads `~0/it` realized velocity while claiming `Iters left ~3–5` for `~150–250` LOC. ~0/it realized cannot become 3–5-iter completion unless the route truly is mechanical, which is the very claim in dispute (above). The "new route mechanical" parenthetical is a forward hope, not realized throughput.
- **Verdict**: CHALLENGE

### Route: Critical path (bottom-up TS→RelPic→A.2.c) + A.2.c representability + Quot engine

- **Goal-alignment**: PASS — representability of `Pic⁰_{C/k}` is genuinely required for the protected `Jacobian` scheme.
- **Mathematical soundness**: PASS — Kleiman §4–§5 / Nitsure §5 support FGA representability via Quot; the route is the standard one.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — the Quot/Cartier engine (absent from Mathlib, ~30–60 it, ~2000–4000 LOC) is the load-bearing crux and is sorry-axiomatized under option (c) with no construction plan, only a read-only feasibility spike "owed iter-210." See Infrastructure-deferral findings.
- **Parallelism under-exploited**: no — the RR-free A.2.c typeclass scaffolding is correctly independent and cheap; gated A.3/A.4 are correctly serialized behind it.
- **Effort honesty**: reasonable as ranges, but the substrate (95–150 it total) is being built *around* an unstarted, un-de-risked crux. If the Quot scheme proves infeasible at this Mathlib maturity, the entire substrate is stranded. The spike should be a true **gate before** further A.2.c LOC, not a parallel "owed" item.
- **Verdict**: CHALLENGE — promote the Quot feasibility spike to a hard gate; see deferral finding.

### Route: Albanese UP — Route 2 (autoduality `J^∨≅J`) with Route-1 excision

- **Goal-alignment**: PASS — derives the protected Albanese UP.
- **Mathematical soundness**: PARTIAL — the "**autoduality is RR-free**" claim is the deepest soundness risk in the document. The principal polarization / theta divisor of a Jacobian classically rests on Riemann–Roch for the curve (the theta divisor is `W_{g-1} = image of Sym^{g-1}C`, and its properties use RR). The strategy's own Open question admits it "might secretly transit RR." With Route C (RR) **PAUSED**, if autoduality needs RR, Route 2 collides with the pause — and the Route-1 codim cone (the RR-lighter classical alternative, Milne Thm 3.2) has already been labeled "EXCISED / dead substrate."
- **Sunk-cost reasoning detected**: no — but the *inverse* problem: premature commitment. Excising the fallback before the replacement's key premise (RR-freeness) is verified is over-eager.
- **Infrastructure-deferral detected**: no (distinct from the premature-excision concern).
- **Verdict**: CHALLENGE — do not treat Route-1 as excised/dead until BOTH deletion-gate conditions are met. The gate exists (good) but the prose framing ("EXCISED... dead substrate") contradicts the still-unmet gate.

### Route: Genus-0 arm + Route C pause
- **Verdict**: SOUND — both sub-arms are explicitly USER-paused; no live planner obligation.

## Format compliance

- **Size**: 105 lines / ~6.7 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — pervasive despite the "cleaner" rewrite. Representative verbatim: `"construction pivot iter-209"`, `"pivoted iter-209"`, `"reverts to the project's documented iter-174 intent"`, `"Albanese UP — Route 2 (committed iter-208)"`, `"The prior 4-iter blocker tensorObj_restrict_iso"`, `"Owed iter-210 (read-only; honors USER #4)"`, plus inline analyst tags `"analogist tsconstruct209"`, `"auditor albroute208"`. Iter-NNN history belongs in `iter/iter-NNN/plan.md`, not STRATEGY.md.
- **Accumulation detected**: yes (minor) — the EXCISED Route-1 cone occupies a full paragraph in `## Routes` plus a line in `## Mathlib gaps`. A one-line "excised, repair sketch in blueprint" pointer suffices.
- **Table discipline**: PASS (both LOC figures present) with a minor gap — Status cells carry prose + iter tags ("active; sole productive lane; construction pivot iter-209").
- **Format verdict**: DRIFTED — the document is correctly sized and headed but the per-iter narrative is a material violation that must be scrubbed in-place this iter.

## Infrastructure-deferral findings

### Deferred: Quot/Cartier scheme engine (FGA Pic representability construction)
- **Required by goal**: yes — the protected `AlgebraicGeometry.Jacobian` is a scheme; its existence requires representability of `Pic⁰`, which the engine discharges. The nine decls cannot close kernel-clean while this is a sorry-axiom.
- **Current plan for building it**: none beyond "partial in QuotScheme.lean" + a `~30–60 it` range. The discharge is sorry-axiomatized under option (c); the only scheduled action is a **read-only** feasibility spike iter-210.
- **Timeline**: vague (a range, not a decomposition).
- **Verdict**: CHALLENGE — this is the project's single absent-from-Mathlib crux. Option (c) is USER-sanctioned and honestly declared, so this is not hidden deferral; but the goal provably requires the engine and no route builds it with a concrete decomposition. The planner must either (a) decompose the engine into concrete sub-phases (think like a Mathlib contributor — Quot functor → representability → flattening → Cartier), or (b) make the iter-210 spike a true gate that blocks further A.2.c LOC until the engine is shown Lean-expressible.

### Deferred: strong-monoidal sheaf-of-modules structure (the pivot's hidden prerequisite)
- **Required by goal**: yes — without it the A.1.c.SubT group law (hence RelPic, hence A.2.c) does not type-check honestly.
- **Current plan for building it**: none — the strategy asserts the coherence isos are "mechanical via `sheafification.mapIso`," which silently assumes this prerequisite is already discharged upstream.
- **Timeline**: absent.
- **Verdict**: CHALLENGE — the planner must either cite the exact pinned-Mathlib monoidal sheaf-of-modules instance (with strong-monoidal sheafification) the `mapIso` calls bottom out in, or schedule building it. If neither exists, this is the old `tensorObj_restrict_iso` blocker renamed, and the pivot does not dissolve it.

## Sunk-cost flags

- `"The prior 4-iter blocker tensorObj_restrict_iso ... was an ARTIFACT of building the law on the geometric IsLocallyTrivial predicate; under ⊗-invertibility both drop off the critical path."` — Partly fair (abandoning the `IsLocallyTrivial`-specific restriction bookkeeping IS a real simplification), but it overstates: the restriction-compatibility content reappears as strong-monoidality of sheafification. Reframe on merits: the pivot is a win *iff* Mathlib already provides the monoidal sheaf category; otherwise it relocates the blocker.

## Prerequisite verification

- `CommRing.Pic`: VERIFIED (`Mathlib.RingTheory.PicardGroup`), along with `instCommGroupPic`, `CommRing.Pic.mk` (which consumes `Module.Invertible`), and `instSmallUnitsSkeletonModuleCat : Small (Skeleton (ModuleCat R))ˣ` — the `Units(Skeleton(ModuleCat))` idiom is real. But it is the **fixed-ring** case, not sheaves.
- `Module.Invertible`: VERIFIED (present; consumed by `CommRing.Pic.mk`). Note `LineBundlePullback.lean:50` states b80f227 ships no `Module.Invertible`/`IsInvertible` **on `Scheme.Modules`** — i.e. the predicate exists for modules over a ring but not for sheaves; that gap stands.
- `AlgebraicGeometry.Scheme.Modules`: VERIFIED present as an abelian category (`Mathlib.AlgebraicGeometry.Modules.Sheaf`), with limits/colimits — but **NO monoidal/tensor instance**.
- `PresheafOfModules.Monoidal.tensorObj`: VERIFIED present (presheaf level only).
- Monoidal structure + coherence isos on `Scheme.Modules`/`SheafOfModules`: **MISSING** (loogle: no `MonoidalCategory` instance for either). This is the linchpin of concern 1 — it is project-side work (`TensorObjSubstrate.lean` builds `tensorObj` by sheafifying), not a Mathlib `mapIso` one-liner, and it needs strong-monoidal sheafification.
- `analogies/tsconstruct209.md` (cited twice as the pivot's rationale): **MISSING** — the file does not exist (closest are `tsroute208.md`, `ts-design206.md`). The strategy points the planner at a non-existent rationale doc.

## Must-fix-this-iter

- Route A.1.c.SubT: CHALLENGE — justify "mechanical coherence isos" by naming the pinned-Mathlib strong-monoidal sheaf-of-modules instance, or admit the pivot relocates `tensorObj_restrict_iso` into sheafification-monoidality and re-plan. Reconcile the `~0/it` realized velocity with the `~3–5 iters` claim.
- Route Critical path / Quot engine: infrastructure-deferral CHALLENGE — the Quot engine is required by the goal with no concrete decomposition. Decompose it or make the iter-210 spike a hard gate before further A.2.c LOC.
- Route Albanese UP Route-2: CHALLENGE — the "autoduality is RR-free" premise is unverified and may transit the paused RR; do not frame Route-1 as "EXCISED / dead substrate" until both deletion-gate conditions are met.
- Prerequisite: VERIFIED ABSENT — there is no monoidal structure on `Scheme.Modules`/`SheafOfModules` in `b80f227`; the sheaf-level coherence isos and strong-monoidal sheafification are project obligations, not `mapIso` one-liners. Also fix or remove the non-existent `analogies/tsconstruct209.md` citation.
- Format: DRIFTED — scrub per-iter narrative (iter-209/208/210/174 tags, analyst slugs) from STRATEGY.md in-place; move it to `iter/iter-209/plan.md`. Collapse the excised-Route-1 paragraph to a one-line pointer.

## Overall verdict

The iter-209 ⊗-invertibility pivot is correct in its *destination* — the Picard group genuinely is the units of ⊗-iso-classes — but the strategy defers the strong-monoidality of sheafification ("sheafification commutes with ⊗"), which is required for the stated goal. I verified that pinned Mathlib has `PresheafOfModules.Monoidal.tensorObj` and the `CommRing.Pic = Units(Skeleton(ModuleCat R))` idiom, but **no monoidal structure on `Scheme.Modules`/`SheafOfModules`** — so the "mechanical `sheafification.mapIso` coherence isos" require the project to build the sheaf-level monoidal structure AND prove sheafification strong monoidal, and the cited `CommRing.Pic` idiom (modules over a fixed ring, no sheafification) does not establish that. As written, the pivot relocates the discarded `tensorObj_restrict_iso` blocker one layer deeper rather than removing it. Separately, the strategy defers the Quot/Cartier engine, which is required for the stated goal, with no concrete decomposition and only a read-only feasibility spike — the project is building 95–150 iters of substrate around an unstarted, un-de-risked, absent-from-Mathlib crux. The Route-2 "autoduality is RR-free" premise is unverified and risks colliding with the paused Riemann–Roch, yet the RR-lighter Route-1 fallback is already framed as dead. Finally the document, though correctly sized and headed, is DRIFTED on per-iter narrative and cites a non-existent rationale doc. Net: CHALLENGE — the routes are not broken, but four must-fix items stand before the plan is committed.
