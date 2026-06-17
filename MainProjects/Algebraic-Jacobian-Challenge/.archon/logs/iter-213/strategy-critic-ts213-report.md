# Strategy Critic Report

## Slug
ts213

## Iteration
213

## Routes audited

### Route: A.1.c.SubT — line-bundle ⊗-group law (associator on route (c))

- **Goal-alignment**: PASS — a well-defined group law on line-bundle iso-classes is a genuine prerequisite of `J := Pic⁰_{C/k}`, which the strategy uses to realize the protected `GrpObj (Jacobian C)`.
- **Mathematical soundness**: PASS — route (c) is mathematically *distinct* from the dead flat route, not a reskin of it (see below).
- **Sunk-cost reasoning detected**: no — the strategy does NOT justify route (c) by "we already built the substrate"; it justifies it on merits (local triviality of the whiskered unit). The framing "LAST viable realization" is a risk statement, not a sunk-cost rationalization.
- **Infrastructure-deferral detected**: no for the associator itself; the `IsInvertible ⇒ IsLocallyTrivial` deferral is handled under Route A.1.c below and is legitimate.
- **Phantom prerequisites**: none. The Mathlib backbone route (c) consumes is REAL and verified this audit — `CategoryTheory.GrothendieckTopology.WEqualsLocallyBijective`, `W_iff_isLocallyBijective`, `W_of_isLocallyBijective`, and `Presheaf.IsLocallyInjective`/`IsLocallySurjective` all live in `Mathlib.CategoryTheory.Sites.LocallyBijective`; `PresheafOfModules.Monoidal.tensorObj` is sectionwise (`tensorObj_obj`) exactly as the substrate claims.
- **Effort honesty**: reasonable — `~150–300 · ~0/it` with `Iters left ~3–6`. The `~0/it` is honestly footnoted (helpers landed, the load-bearing existence-iso is the open target). Not a dishonest-estimate row.
- **Parallelism under-exploited**: no (this is the single genuine critical-path bottleneck).
- **Verdict**: SOUND

**Why route (c) is not the same hard problem one layer deeper.** The dead flat route's hardest prerequisite was *sectionwise flatness of the whiskering object over every open* (`∀ U, Module.Flat 𝒪_X(U) (F.val U)`) — which is FALSE on non-affine opens, an impossibility, not a missing lemma. Route (c)'s hardest prerequisite is *local injectivity of `η ▷ P` on a trivializing cover*, scoped to `IsLocallyTrivial P`. On the cover where `P|_U ≅ 𝒪_U`, the whiskered unit `id_P ⊗ η` is locally `≅ η`, which is locally injective for free (`instIsLocallyInjectiveToSheafify`); local surjectivity is hypothesis-free by right-exactness. These are different prerequisites: one is a global false implication, the other a local-on-cover check backed by extant Mathlib API. The pivot solves the problem rather than renaming it. Committing here is the correct call, NOT a sunk-cost trap.

**One caveat for the planner (blueprint, not STRATEGY.md).** The blueprint proof of `lem:tensorobj_assoc_iso` (`Picard_TensorObjSubstrate.tex` ≈L696–811) still narrates the *dead* flat-whiskering three-step composite verbatim, carrying the iter-212 review NOTE that flags it as a real gap. `lem:flat_whisker_localizer` already says the associator is "now proved … by route (c) below," but no route-(c) proof exists below it — the prose is mid-transition and self-contradictory. Route (c) is therefore a PLAN, not a realized proof; the blueprint must be rewritten to actually state the route-(c) argument before a prover is dispatched, or the prover will re-attempt the impossible flat step. This is consistent with STRATEGY.md's `~0/it on the target`.

### Route: A.1.c — RelPic functor (carrier scoped to `IsLocallyTrivial`)

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — scoping the iso-class group carrier to `IsLocallyTrivial` is sound. To form a *group*, every element needs an inverse: for locally-trivial rank-1 `L`, the dual `L^∨ = Hom(L,𝒪)` is itself locally trivial and `L ⊗ L^∨ ≅ 𝒪` holds from the local trivializations alone. So inverses exist *within* `IsLocallyTrivial` directly; the deferred `IsInvertible ⇒ IsLocallyTrivial` is genuinely not consumed by the group construction.
- **Infrastructure-deferral detected**: no (legitimate) — `IsInvertible ⇒ IsLocallyTrivial` is deferred, but the project goal (`challenge.lean.ref`) never mentions Pic or invertible sheaves; it asks only that `Jacobian C` be a `GrpObj` with the listed geometric properties. The `IsInvertible ⇔ IsLocallyTrivial` identification is an internal convenience, required only if one later wants to *call* the carrier "the Picard group of invertible sheaves." The goal does not demand it.
- **Effort honesty**: reasonable.
- **Verdict**: SOUND — **with one verification the planner must record.** The deferral is sound *iff the entire downstream consumer chain* (RelPicFunctor → FGAPicRepresentability → the autoduality/Quot machinery) is uniformly stated in `IsLocallyTrivial` and never needs to recognize an abstractly-⊗-invertible object as locally trivial. The strategy asserts "consumers already use `IsLocallyTrivial`"; confirm that the representability scaffolding and the Route-2 autoduality input are *also* `IsLocallyTrivial`-typed, not `Module.Invertible`-typed, before treating the bridge as permanently off-path.

### Route: A.2.c — Pic representability (scaffolding via 6 `⟨sorry⟩` typeclasses)
- **Verdict**: SOUND — proceeding under Prop-valued placeholder typeclasses to unblock Route A is a defensible scaffolding pattern, provided the `⟨sorry⟩` constructors are honestly tracked as sorry-axioms (the strategy says they are). The real obligation is the engine below.

### Route: A.2.c-engine — general Quot/Cartier (HELD)

- **Goal-alignment**: PASS (this is the discharge of A.2.c's sorries).
- **Infrastructure-deferral detected**: yes — see Infrastructure-deferral findings (`R^i f_*`, i≥1).
- **Effort honesty**: reasonable-but-enormous and honestly labeled — `~3400–5500 · 0/it`, `~30–60 iters`, HELD. The `0/it` is consistent with HOLD status. Under-decomposed (sub-components named but not phased), but the user RR-pause gate excuses near-term decomposition.
- **Verdict**: CHALLENGE (deferral of `R^i f_*` with no decided plan — see findings; downstream of the user RR decision but still the active path while RR is paused).

### Route: A.3 — tangent + Pic⁰ AV-structure
- **Parallelism under-exploited**: yes — `scheme tangent space` and `Hilbert poly` are Mathlib-absent constructions *independent* of the associator, yet gated behind A.2.c (see Parallelism note).
- **Verdict**: SOUND (content); flagged for serialization.

### Route: A.4 — Albanese UP (Route 2, via autoduality `J^∨≅J`)

- **Goal-alignment**: PASS *if it works* — it targets `exists_unique_ofCurve_comp`, the protected Albanese UP.
- **Mathematical soundness**: PARTIAL — the route's RR-freeness rests entirely on the *unverified* claim that autoduality `J^∨≅J` (EGK 2.1 / Poincaré bundle) is RR-free. Classically this rests on the theta divisor and Riemann–Roch. The strategy itself writes "classically RR-dependent; if it transits RR the RR-free posture fails."
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no (it's a soundness risk, not a deferral).
- **Verdict**: CHALLENGE — the entire justification for Route 2 superseding the Route-1 codim cone is "autoduality is RR-free," and that premise is unverified and self-doubted. If it transits RR (paused by USER), Route 2 is circular: an RR-free route whose key step needs RR. Second-verify autoduality RR-freeness BEFORE any Route-2 investment. (Good hygiene already present: Route-1 is retained reversibly behind a closed deletion gate, so a fallback exists — do not close that gate until autoduality is verified.)

### Route: Route C — Riemann–Roch (PAUSED, USER)
- **Verdict**: SOUND as a user-imposed constraint. As a fresh reader I record that this pause is the single largest cost multiplier in the project: the ~3400–5500 LOC engine and the autoduality risk exist *solely* to avoid it (the strategy says so). This is a USER decision, correctly surfaced, not a planner error.

### Route: Genus-0 arm
- **Verdict**: SOUND — both sub-routes are paused/partial and the general Route A is the main thrust, so this is not a goal-weakening "main case vs exceptional case" split. (Watch: the blueprint carries substantial genus-0/RR-specific chapters now off-path — an accumulation risk at the *blueprint* level, not in STRATEGY.md.)

## Format compliance

- **Size**: ~115 lines / well under 12 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: yes — the phases footnote reads "SubT helpers (gate, bridge, unitors, braiding) landed axiom-clean **iters 211–212**". Specific iteration numbers belong in `iter/iter-NNN/plan.md`, not STRATEGY.md. Reword to "landed axiom-clean" with no iter pin.
- **Accumulation detected**: no — excised realizations are named compactly as dead-ends to avoid re-attempt (legitimate), not retained as live phases.
- **Table discipline**: PASS — six-column table, both LOC figures present per row.
- **Format verdict**: DRIFTED (single per-iter-narrative violation; otherwise compliant).

## Infrastructure-deferral findings

### Deferred: `R^i f_*` (i ≥ 1), higher direct images

- **Required by goal**: yes — given the USER RR pause, the Quot/Hilbert engine is the *only* active discharge for A.2.c's representability sorries, and `R^i f_*` is named as its deepest root. The general-genus Jacobian (smooth of relative dimension = genus) cannot be built without representability of Pic, which on this (RR-free) path needs the engine, which needs `R^i f_*`.
- **Current plan for building it**: three options listed (Mathlib PR vs ~800–1200 LOC project Čech build vs named typed-sorry pin) with NO decision; the decision itself is deferred ("Decide when the engine de-gates").
- **Timeline**: absent — gated behind the associator, which is itself the open target.
- **Verdict**: CHALLENGE — a construction required by the goal (on the RR-free path) with no chosen plan and no timeline is an unresolved strategic gap, not an accepted dependency. The user RR-pause explains *why* the engine is held, but does not supply a plan for its deepest root. The planner should either (a) record that lifting the RR pause is the preferred resolution and escalate it to USER as the cheaper fork, or (b) commit to one of the three `R^i f_*` options with an iter estimate so the engine is not an open-ended hole.

## Alternative routes (suggested)

### Alternative: Concrete associator from local trivializations (now that the carrier is `IsLocallyTrivial`)

- **What it looks like**: build `(L⊗M)⊗N ≅ L⊗(M⊗N)` directly by choosing a common cover on which `L,M,N ≅ 𝒪`, where every tensor is the structure sheaf and the reassociation is the canonical `(𝒪⊗𝒪)⊗𝒪 ≅ 𝒪 ≅ 𝒪⊗(𝒪⊗𝒪)`, glued over overlaps. This never touches the sheafification localizer `J.W` at all.
- **Why it might be cheaper or sounder**: the carrier scoping to `IsLocallyTrivial` (decided this iter) makes the local trivializations *available as the carrier hypothesis*, which they were not when the substrate was designed for arbitrary modules. The localizer/whiskering machinery (route (c)) was the right tool when objects were arbitrary; for objects that are locally `𝒪` by hypothesis, the concrete reassociation may be more direct.
- **What the current strategy may have rejected**: the blueprint explicitly avoids "per-object local trivialisation or gluing cocycle on an affine cover," preferring the abstract localizer. That was a *reasonable* choice — it reuses extant Mathlib localizer lemmas and dodges manual cocycle/gluing bookkeeping, which in Lean is often more painful than the abstract route. So this alternative is not obviously cheaper; the gluing overhead may exceed route (c)'s. Worth a one-iter spike comparison only if route (c) stalls.
- **Severity of the omission**: minor (route (c) rests on verified Mathlib infra and should be tried first; keep this as the fallback if route (c)'s sieve-refinement bottoms out).

### Alternative: Pic via `H¹(X, 𝒪_X^×)` (group law free from cohomology)

- **What it looks like**: define the group law as the abelian-group structure of `H¹` of the units sheaf; associativity/commutativity are then automatic.
- **Why it might be cheaper or sounder**: it eliminates the associator problem entirely — the exact thing route (c) is fighting.
- **What the current strategy may have rejected**: the project needs the *relative/functorial* Picard sheaf over a base `S` with étale sheafification, and base-change of `H¹` is its own substantial difficulty; the blueprint cohomology chapters exist but are thin. The tensor substrate is already ~80% landed with verified Mathlib backing, so switching now would discard real progress.
- **Severity of the omission**: minor (do not switch; noted only so the planner can confirm the tensor route was a deliberate, not accidental, choice).

## Prerequisite verification

- `PresheafOfModules.Monoidal.tensorObj`: VERIFIED (sectionwise, `Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal`).
- `CategoryTheory.GrothendieckTopology.WEqualsLocallyBijective` / `W_iff_isLocallyBijective` / `W_of_isLocallyBijective`: VERIFIED (`Mathlib.CategoryTheory.Sites.LocallyBijective`) — these are the load-bearing backbone of route (c).
- `Presheaf.IsLocallyInjective` / `Presheaf.IsLocallySurjective`: VERIFIED (same module).
- `PresheafOfModules.isIso_sheafification_map_of_W`, `instIsLocallyInjectiveToSheafify`: project-local decls (not in Mathlib via loogle, as expected); their existence is asserted by the blueprint and should be confirmed by the prover, but they are not phantom *Mathlib* claims.

## Must-fix-this-iter

- Route A.4 (Albanese, Route 2): CHALLENGE — second-verify that autoduality `J^∨≅J` is RR-free before any Route-2 investment; the strategy's own RR-free posture is circular if it is not. Keep the Route-1 deletion gate closed meanwhile.
- Route A.2.c-engine: infrastructure-deferral CHALLENGE — `R^i f_*` (i≥1) is required by the goal on the RR-free path with no chosen plan/timeline. Pick one of the three options with an iter estimate, or escalate "lift the RR pause" to USER as the cheaper fork.
- Route A.1.c: record the consumer-chain uniformity check — confirm RelPicFunctor / representability / autoduality inputs are uniformly `IsLocallyTrivial`-typed, justifying the `IsInvertible ⇒ IsLocallyTrivial` deferral.
- Format: DRIFTED — remove the per-iter narrative "iters 211–212" from the phases footnote.
- (Blueprint, adjacent) Rewrite `lem:tensorobj_assoc_iso`'s proof prose to the actual route-(c) argument before dispatching a prover; it currently still narrates the dead flat route + iter-212 gap NOTE.

## Overall verdict

The headline decision under review — committing the associator to route (c) and scoping the iso-class group carrier to `IsLocallyTrivial` — is SOUND, and notably is NOT a sunk-cost trap: route (c)'s hardest prerequisite (local-on-cover injectivity of the whiskered sheafification unit) is genuinely different from the dead flat route's (false sectionwise flatness), and it rests on Mathlib infrastructure I verified exists (`WEqualsLocallyBijective`, `W_of_isLocallyBijective`, `Presheaf.IsLocallyInjective/Surjective`). The carrier scoping is internally consistent (it hands route (c) its trivializations for free) and the deferred `IsInvertible ⇒ IsLocallyTrivial` is genuinely off the goal's critical path, since `challenge.lean.ref` never mentions Pic or invertibility. The real live risks are elsewhere: **the strategy defers `R^i f_*` (i≥1), which is required for the stated goal on the RR-free path, with no chosen plan or timeline**, and the Albanese Route-2 rests on an unverified, self-doubted claim that autoduality is RR-free — if it is not, that route is circular against the paused RR. Both are flagged for this iter, alongside a minor format drift (per-iter narrative) and a blueprint prose lag (the associator proof still narrates the dead flat route). Proceed on route (c); resolve the autoduality and `R^i f_*` gaps before treating Route 2 or the engine as funded.
