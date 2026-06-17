# Strategy Critic Report

## Slug
iter001-init

## Iteration
001

## Routes audited

### Route: FBC — `thm:flat_base_change_pushforward` + `lem:affine_base_change_pushforward`

- **Goal-alignment**: PASS — both target nodes are named project sorries; closing them is exactly what the leg owes.
- **Mathematical soundness**: PASS — the i=0 flat-base-change iso is true and provable; see soundness note below on the *route* it should take.
- **Sunk-cost reasoning detected**: yes — "16/18 chapter nodes already proved, only the two target nodes left" frames the close as nearly-done by accounting for prior work rather than by the difficulty of the two remaining (the hard) nodes.
- **Infrastructure-deferral detected**: yes — the close leans on a "deferred `#37189` bump" (a Mathlib PR/version bump). The goal requires FBC; no route states whether FBC is closeable on the *current* pin, and no project-side workaround is committed. Deferral to an upstream bump with no in-project fallback is an unresolved gap, not an accepted dependency.
- **Phantom prerequisites**: none confirmed phantom, but `#37189` is unverified and the strategy does not say what it provides or whether the target compiles without it.
- **Effort honesty**: cannot assess — the table carries no `Iters left` / `LOC` columns at all (format violation). "Only the two target nodes left" understates: the parent itself flagged these two as "Mathlib-scale," so the remaining 2/18 are the bulk of the cost, not 1/9 of it.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE

Soundness note (the central FBC issue, = directive Q1+Q2): the leg is billed **Čech-independent**, yet the blueprint's `thm:flat_base_change_pushforward` proof reportedly routes through Čech/affine-cover cohomology infrastructure. For **i=0 this is unnecessary**. H⁰ over a finite affine cover `{Uᵢ}` is the *equalizer* `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)` (the sheaf axiom — Čech degree 0/1, **not** Čech cohomology), and a flat `−⊗B` preserves finite equalizers/kernels. Mathlib already ships this substrate: `Module.Flat.ker_lTensor_eq` and `Module.Flat.eqLocus_lTensor_eq` in `Mathlib/RingTheory/Flat/Equalizer.lean`. So the qcqs globalization is in reach **without importing any sibling-leg Čech machinery** — but STRATEGY.md leaves "qcqs globalization" unspecified and does not name the equalizer route. The planner must (a) state explicitly that globalization is the flat-preserves-the-H⁰-equalizer argument over the finite cover, and (b) confirm the blueprint proof does not pull in higher-Rⁱ Čech infra that the Out-of-scope section excised. On Q2: the two-TODO decomposition (affine-reduction naturality + adjoint-mate ↔ `cancelBaseChange` coherence) inherits the parent's abstract-mate framing; given the tilde dictionaries are already proved, proving the iso **directly on global sections** (`ψ*M̃ = (S⊗_R M)~` reduces the affine claim to the canonical `S⊗_R M ≅ S⊗_R M`) is a cheaper cut that sidesteps the `cancelBaseChange` coherence wall and the `#37189` dependency. See Alternatives.

### Route: GF — `thm:generic_flatness` + `thm:generic_flatness_algebraic`

- **Goal-alignment**: PASS — algebraic core + scheme-level statement are both named sorries.
- **Mathematical soundness**: PASS — Nitsure §4 induction is a correct proof of the algebraic core.
- **Sunk-cost reasoning detected**: yes (latent) — "Nitsure §4 proof fully transcribed in the blueprint" creates momentum to *formalize the transcription* before confirming Mathlib doesn't already discharge most of it.
- **Infrastructure-deferral detected**: no.
- **Phantom prerequisites**: none — the opposite problem (see below).
- **Effort honesty**: cannot assess (no `Iters left`/`LOC`). Risk is *over*-building, not under-estimating.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE

Note: Mathlib has more generic-freeness substrate than the strategy's parenthetical "check Mathlib … before hand-building" implies. `Module.FinitePresentation.exists_free_localizedModule_powers` (Mathlib/RingTheory/Localization/Free.lean) gives exactly "f.p. module + free at the generic localization ⇒ free after inverting some `r`," and the whole `Module.freeLocus` API (Mathlib/RingTheory/Spectrum/Prime/FreeLocus.lean) is present. Over a domain `A` the generic fiber is a vector space over `Frac(A)`, hence automatically free — so the §4 prime-filtration induction may collapse to a thin wrapper around existing lemmas. The planner must run a Mathlib-first survey and only hand-build what survives it; formalizing the full transcribed induction without that survey is wasted effort.

### Route: QUOT — `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable`

- **Goal-alignment**: PASS — these are the four named QUOT sorries the parent will consume.
- **Mathematical soundness**: PASS — `(Over S)ᵒᵖ ⥤ Type u` is the right shape for the Quot/Grassmannian functor; Nitsure §5 big-cell patching is the correct representability route.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no (Grassmannian-of-quotients as a scheme is genuinely absent from Mathlib and the strategy commits to building it via §5 — a real plan, not a deferral).
- **Phantom prerequisites**: the representability packaging reinvents existing Mathlib — see Prerequisite verification.
- **Effort honesty**: cannot assess (no `LOC`/`Iters left`). `thm:grassmannian_representable` is the deepest single target and the table gives no sense of its weight.
- **Parallelism under-exploited**: no — correctly identified as Mathlib-only, parallel-authorable.
- **Verdict**: CHALLENGE

Note (directive Q3): the bespoke `∃ Y, Nonempty (RepresentableBy Y)` packaging is **verbatim the definition of `CategoryTheory.Functor.IsRepresentable`** (`IsRepresentable.has_representation : ∃ Y, Nonempty (F.RepresentableBy Y)`; `IsRepresentable.mk` takes exactly that existential). The stub should state `Grassmannian.representable : (quotFunctor …).IsRepresentable` so downstream the parent can call `Functor.representableBy`/`reprX` to recover the representing scheme and universal family as data. Rolling a bespoke existential forces re-bridging at merge-back. Watch the universe constraint: `RepresentableBy F Y` needs `F : Cᵒᵖ ⥤ Type v` with the representing object in the *same* `C` at matching `v` — pin the Quot functor's target universe to the schemes category's hom-universe now, or representability won't typecheck later.

### Route: Sequencing (bottom-up; QUOT defs in parallel)

- **Verdict**: SOUND — FBC/GF leaves first with the four import-isolated QUOT files authored in parallel is the correct dependency order and exploits the available parallelism. Minor: the §5 representability *proof* (deepest target) is serialized behind its own defs within the QUOT lane — justified, since the statement depends on the defs, but its big-cell open-cover scaffolding could begin as soon as `def:grassmannian_scheme` lands rather than waiting for all four stubs.

## Format compliance

- **Size**: ~70 lines / well under budget — within budget (~250 lines / ~12 KB).
- **Headings**: FAIL — actual: `## Goal`, `## Phases & estimations`, `## Routes`, `## Out of scope`, `## Mathlib gaps & new material`. `## Out of scope` is a non-canonical heading; `## Open strategic questions` is missing. Canonical set is `## Goal`, `## Phases & estimations`, `## Completed`(opt), `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`.
- **Per-iter narrative detected**: yes (mild) — Risks cell: "parent flagged a defeq wall here (iter-243, …)" and "deferred `#37189` bump" embed specific-iter/PR narrative in a table cell. Move parent-history detail to an iter sidecar.
- **Accumulation detected**: no.
- **Table discipline**: FAIL — `## Phases & estimations` columns are `Phase | Status | Key references | Risks`; required `Phase | Status | Iters left | LOC | Key Mathlib needs | Risks`. Missing `Iters left` and `LOC` entirely; `Key references` substitutes for `Key Mathlib needs`. `Status` cells carry prose ("OPEN; 16/18 chapter nodes already proved, only the two target nodes left") instead of a short inline tag (`ACTIVE`/`BLOCKED`/…). Risks cells are multi-clause prose.
- **Appendix sections**: `## Out of scope` (not in canonical skeleton).
- **Format verdict**: NON-COMPLIANT

## Infrastructure-deferral findings

### Deferred: FBC affine close pending Mathlib `#37189` bump

- **Required by goal**: yes — `thm:flat_base_change_pushforward` / `lem:affine_base_change_pushforward` are two of the seven sorries this leg must close.
- **Current plan for building it**: none beyond "deferred `#37189` bump" + parent unstick notes; no statement of whether the target compiles on the current pin and no project-side fallback.
- **Timeline**: absent.
- **Verdict**: CHALLENGE — either confirm FBC is closeable on the current toolchain (and drop the `#37189` mention), or adopt the direct-on-sections / H⁰-equalizer route (Mathlib `RingTheory/Flat/Equalizer`) as the in-project path that does not wait on upstream.

## Alternative routes (suggested)

### Alternative: FBC i=0 via the H⁰-equalizer, proved directly on global sections

- **What it looks like**: Prove `lem:affine_base_change_pushforward` by rewriting both sides through the already-proved tilde dictionaries (`ψ*M̃ = (S⊗_R M)~`, `ψ_*Ñ = (N_R)~`), reducing the affine base-change iso to the canonical `S⊗_R M ≅ S⊗_R M`. Globalize over a finite affine cover by expressing `H⁰(X,F)` as the equalizer `∏Γ(Uᵢ) ⇉ ∏Γ(Uᵢⱼ)` and invoking `Module.Flat.eqLocus_lTensor_eq` / `ker_lTensor_eq` so flat `−⊗B` commutes with the equalizer.
- **Why it might be cheaper or sounder**: avoids the abstract adjoint-mate ↔ `cancelBaseChange` coherence wall the parent flagged "Mathlib-scale," uses only proved tilde lemmas + a named Mathlib flatness file, and is genuinely Čech-cohomology-free — consistent with the leg's "Čech-independent" billing and free of the `#37189` dependency.
- **What the current strategy may have rejected**: unclear — the strategy inherited the parent's abstract-mate decomposition and does not mention the equalizer substrate, so it likely never considered this cut.
- **Severity of the omission**: major.

### Alternative: GF algebraic core as a wrapper over Mathlib generic-freeness

- **What it looks like**: Reduce `thm:generic_flatness_algebraic` to `Module.FinitePresentation.exists_free_localizedModule_powers` + the generic-fiber-is-a-`Frac(A)`-vector-space (hence free) observation, using the `Module.freeLocus` API, instead of transcribing Nitsure §4's prime-filtration induction in full.
- **Why it might be cheaper or sounder**: the hard combinatorial induction may already be discharged by Mathlib; a thin wrapper is far less Lean than a hand-built filtration.
- **What the current strategy may have rejected**: the strategy says "check Mathlib … before hand-building," so it is aware but has not committed; the blueprint's full §4 transcription biases toward hand-building.
- **Severity of the omission**: major.

## Sunk-cost flags

- `OPEN; 16/18 chapter nodes already proved, only the two target nodes left` — Why this is sunk-cost: it measures remaining work by node *count* against completed work, masking that the two leftover nodes are the parent-flagged "Mathlib-scale" hard core. Recommendation: reframe FBC by the difficulty of the two open nodes and the concrete route chosen for them, not by the 16 already done.
- `Nitsure §4 proof fully transcribed in the blueprint` — Why this is sunk-cost: a completed transcription creates pressure to formalize it verbatim before checking whether Mathlib obviates it. Recommendation: gate any §4 formalization on the Mathlib-first survey above.

## Prerequisite verification

- `Module.Flat` (+ `RingTheory/Flat/Equalizer.lean`: `ker_lTensor_eq`, `eqLocus_lTensor_eq`): VERIFIED — backs the Čech-free FBC i=0 route.
- `CategoryTheory.Functor.RepresentableBy` / `Functor.IsRepresentable` / `IsRepresentable.has_representation` (`Mathlib.CategoryTheory.Yoneda`): VERIFIED — the strategy's `∃ Y, Nonempty (RepresentableBy Y)` is exactly `Functor.IsRepresentable`; use the Mathlib spelling.
- `Module.FinitePresentation.exists_free_localizedModule_powers`, `Module.freeLocus`, `Module.mem_freeLocus`: VERIFIED — generic-freeness substrate for GF.
- `#37189` (Mathlib PR/bump referenced for FBC): MISSING/UNVERIFIED — content and necessity not established; the FBC plan must not silently depend on it.

## Must-fix-this-iter

- Route FBC: CHALLENGE — state the i=0 globalization route explicitly (flat-preserves-H⁰-equalizer via `RingTheory/Flat/Equalizer`), confirm no sibling-leg Čech-cohomology infra is imported, and resolve the `#37189` dependency (closeable on current pin, or adopt the direct-on-sections route).
- Route FBC: infrastructure-deferral CHALLENGE — `thm:flat_base_change_pushforward` is goal-required; remove the bare "deferred `#37189` bump" deferral and commit to a project-side path with no upstream wait.
- Route GF: CHALLENGE — run a Mathlib-first survey (`exists_free_localizedModule_powers`, `freeLocus`) and only hand-build the §4 induction residue that survives it; do not formalize the full transcription on momentum.
- Route QUOT: CHALLENGE — restate `Grassmannian.representable` as `…IsRepresentable` (Mathlib) rather than a bespoke existential, and pin the Quot-functor target universe now to keep representability typecheckable.
- Alternative FBC equalizer route: major omission — fold into STRATEGY.md as the primary FBC path.
- Format: NON-COMPLIANT — restructure `## Phases & estimations` to the canonical 6 columns (add `Iters left`, `LOC`; rename `Key references`→`Key Mathlib needs`; make `Status` a short tag), replace `## Out of scope` with the canonical headings (add `## Open strategic questions`; fold out-of-scope content into `## Routes` or `## Open strategic questions`), and move the `iter-243`/`#37189` parent-history detail to an iter sidecar.

## Overall verdict

CHALLENGE. The three substantive routes are goal-aligned and mathematically sound at the statement level, and the bottom-up sequencing with parallel QUOT authoring is the right shape. But every active route needs a corrective before provers start. FBC is billed Čech-independent yet its blueprint proof reportedly uses Čech/affine-cover cohomology and the strategy leaves globalization unspecified — the i=0 target is reachable Čech-free via the H⁰-equalizer preserved by flat tensor (`Mathlib/RingTheory/Flat/Equalizer`), and the strategy defers the FBC affine close to an upstream `#37189` bump with no project-side fallback: **the strategy defers the FBC affine close to Mathlib `#37189`, which is required for the stated goal**, so it must either confirm closeability on the current pin or adopt the direct-on-sections route. GF risks over-building the transcribed Nitsure §4 induction when Mathlib's `exists_free_localizedModule_powers`/`freeLocus` substrate may discharge most of it. QUOT's representability stub reinvents Mathlib's `Functor.IsRepresentable` and should use it directly. Finally STRATEGY.md is NON-COMPLIANT with the canonical skeleton (wrong table columns, no `Iters left`/`LOC`, prose `Status`, extra `## Out of scope`, missing `## Open strategic questions`) and must be restructured in place this iter.
