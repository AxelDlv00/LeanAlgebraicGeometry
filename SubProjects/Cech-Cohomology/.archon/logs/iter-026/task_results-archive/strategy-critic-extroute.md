# Strategy Critic Report

## Slug
extroute

## Iteration
026

## Routes audited

### Route A — acyclic-resolution comparison (CHOSEN)

- **Verdict**: SOUND

The P4 abstract lemma (`rightDerivedIsoOfAcyclicResolution`, done) reduces the goal to (i)
augmented-Čech-is-a-resolution and (ii) termwise `(pushforward f)`-acyclicity, the latter feeding
`affine_serre_vanishing`. This is the standard Cartan–Leray route and is goal-aligned. No issue.

### Route B — two spectral sequences (REJECTED, fallback)

- **Verdict**: SOUND

Correctly rejected, and the strategy honestly notes B does not escape the irreducible
`injective_cech_acyclic` brick. Fine as a documented fallback.

### Route: the acyclicity bridge + absolute-cohomology realization (Ext-Form-A)

- **Goal-alignment**: PASS — the torsor-free 01EO/02KG bridge is the legitimate, non-circular path to `affine_serre_vanishing`.
- **Mathematical soundness**: PASS — the bridge math is correct; all of Ext's load-bearing Mathlib infra is VERIFIED present (see Prerequisite verification).
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: yes — `restriction-preserves-injectives` (≈ `j_!`) is named as a "NEW obligation under analogist investigation," "Route TBD," with no chosen construction, no LOC, and no iter estimate. See Infrastructure-deferral findings.
- **Phantom prerequisites**: none — every named Ext lemma exists (verified).
- **Effort honesty**: under-counted — P3b is `~3–5` iters / `~200–450` LOC, but that range was set *before* the iter-026 discovery that Form A forces building `restriction-preserves-injectives` from scratch (no `j_!` in Mathlib). A bespoke `j_!` + exactness + adjunction on `Scheme.Modules` is itself plausibly 200–400 LOC; the range does not visibly absorb it.
- **Parallelism under-exploited**: no — the file-split directive already lanes the work.
- **Verdict**: CHALLENGE

The route is sound but commits, for ~3–5 remaining iters, to a realization whose own iter-026
analysis shows re-introduces exactly the class of missing infrastructure (an extension-by-zero
left adjoint / its consequence) that the Ext route was chosen to avoid — without pricing the one
alternative that provably needs neither `j_!` nor `restriction-preserves-injectives`. The planner
must price that alternative (below) and commit to a concrete build plan + iter estimate for whatever
it keeps, before proceeding.

## Format compliance

- **Size**: 159 lines / 15389 bytes — **over budget** (15.4 KB > 12 KB; line count within the 250 bound).
- **Headings**: PASS — the six canonical headings appear in canonical order, `## Completed` correctly between `## Phases & estimations` and `## Routes`.
- **Per-iter narrative detected**: yes — pervasive. Representative: "`decided iter-026`", "`DECIDED (iter-025): absolute Hⁿ(U,F) := …`", "`DECIDED (iter-026): the Ext form is Form A`", "`BUILT iter-018`", "`anchors added iter-025`", "`the iter-025 analogist's … was incorrect`", "`strategy-critic iter-019`". This is iter-by-iter decision history living in STRATEGY.md.
- **Accumulation detected**: yes — `## Open strategic questions` has degraded into a "Historical decisions" log (a stack of `DECIDED (iter-NNN): …` entries recording *when* and *why* each route choice flipped). That is appendix/history-tracking content; it belongs in iter sidecars, not STRATEGY.md.
- **Table discipline**: FAIL — `## Phases & estimations` Risks and Key-Mathlib-needs cells are multi-sentence paragraphs carrying iter tags (e.g. the P3b Risks cell is a full paragraph), not "one short line per cell."
- **Appendix sections**: `## Open strategic questions` is functioning as a "Historical decisions / Considered alternatives" appendix.
- **Format verdict**: NON-COMPLIANT

## Infrastructure-deferral findings

### Deferred: restriction-preserves-injectives (`I` injective ⟹ `restrictFunctor j I` injective), equivalently `j_!`

- **Required by goal**: partially — required by the *chosen* Ext-Form-A realization, NOT intrinsic to the goal. The Mathlib injective-vanishing lemma for Ext (`HasInjectiveDimensionLT.subsingleton`, verified) needs the **second** Ext argument injective, so the 01EO step `Hⁿ(U,I)=Ext^n_{O_U}(O_U,I|_U)=0` genuinely demands `I|_U` injective. Independently, the **frozen P5a resolution form** needs the bridge `Hᵏ((f_*I^•)(V)) = Hᵏ(f⁻¹V,G)`; under Form A that bridge ALSO needs `I^•|_{f⁻¹V}` to be an injective resolution in `Mod(O_{f⁻¹V})` — i.e. the same obligation, twice.
- **Current plan for building it**: none with a timeline — "Route TBD (build `j_!` exact, or a bespoke Hom-exactness argument); analogist iter-026."
- **Timeline**: vague.
- **Verdict**: CHALLENGE — the planner must either (a) commit to building `restriction-preserves-injectives` (via `j_!` or directly) with a concrete iter/LOC estimate, or (b) switch to the rightDerived-global realization below, under which this construction is **not needed at all** and the P5a bridge becomes near-definitional.

## Alternative routes (suggested)

### Alternative: rightDerived-global — `Hᵏ(U,F) := ((Γ_U).rightDerived k).obj F` with `Γ_U : X.Modules ⥤ Ab` (sections over the open `U`), computed in the GLOBAL category

- **What it looks like**: realize absolute cohomology as the right-derived functor of global-sections-over-`U`, derived via injective resolutions in `Mod(O_X)` (not `Mod(O_U)`). Injective vanishing `Hᵏ(U,I)=0` (k>0) is then **free and trivial** — `Functor.isZero_rightDerived_obj_injective_succ` (verified): an injective object is its own resolution, so no restriction is taken. `H⁰=Γ_U` is `toRightDerivedZero` (verified, `Γ_U` left-exact ⇒ PreservesFiniteLimits). The P5a bridge `Hᵏ((f_*I^•)(V)) = Hᵏ(f⁻¹V,G)` becomes **definitional**: `(f_*I^•)(V)=Γ_{f⁻¹V}(I^•)`, whose homology is `R^kΓ_{f⁻¹V}(G)` by the very definition of `rightDerived` (same global resolution `I^•`). The one genuine gap is the δ-functor **LES**, which Mathlib does not package for `Functor.rightDerived` — but it is hand-buildable from `ShortComplex.ShortExact.δ` + `HomologySequence` (verified present) wired through the horseshoe `ofShortExact` + dimension-shift machinery the project **already built in P4** (`AcyclicResolution.lean`).
- **Why it might be cheaper or sounder**: it is the ONLY realization that needs neither `j_!` nor `restriction-preserves-injectives` — both confirmed absent from Mathlib and both nontrivial to build. It computes everything in the global category where injective acyclicity is trivial, and it reuses P4 horseshoe infra rather than introducing open-immersion extension-by-zero. The 01EO/02KG comparison (Čech-to-derived, effaced by `injective_cech_acyclic`) goes through identically — the comparison is between Čech and "the derived functor," indifferent to whether the derived functor is spelled `Ext` or `rightDerived`.
- **What the current strategy may have rejected**: the strategy dismisses `rightDerived` in one line ("injective vanishing free, but NO LES in Mathlib"). That is accurate as far as it goes (LES verified absent for classical `rightDerived`), but it omits that (i) the LES is reachable via the project's own P4 horseshoe + Mathlib's `ShortComplex.ShortExact.δ`, and (ii) this route eliminates the brand-new `restriction-preserves-injectives` obligation entirely. The comparison "Ext's off-the-shelf LES vs. one hand-built LES that saves building `j_!`" was never made.
- **Severity of the omission**: major.

### Alternative: Route γ — colim-Čech `Hᵖ := colim_𝒰 Ȟᵖ` (the strategy's named fallback)

- **What it looks like**: as the directive describes — LES from a SES of colim-Čech complexes + filtered-colimit exactness.
- **Why it might be cheaper or sounder**: it does avoid `j_!`.
- **What the current strategy may have rejected**: correctly held as a γ-fallback. But two caveats temper the directive's framing that γ is "already in hand": (1) `ses_cech_h1`/`injective_cech_acyclic` are at a **fixed cover**; γ's LES needs them at the **colimit** (a SES of sheaves is NOT a SES of Čech complexes at a fixed cover — right-exactness `Č(𝒰,F)→Č(𝒰,F'')→0` only recovers after refinement), so the refinement-colimit category + filtered-colimit-exactness + local-surjectivity-after-refinement are NEW machinery, not in hand; (2) γ still must cross the same P5a bridge. So γ is heavier than rightDerived-global, which gets the same `j_!`-avoidance more cheaply. Prefer rightDerived-global as the primary alternative; keep γ as a tertiary fallback.
- **Severity of the omission**: minor (already named; just over-credited).

## Sunk-cost flags

- `**All 3 bridge bricks DONE** (… axiom-clean)` and the iter-tagged "DECIDED" chain in `## Open strategic questions` — Why this is near-sunk-cost: the realization choice is being narrowed iter-by-iter (β refuted → Ext → Form B unbuildable → Form A) while the hardest prerequisite (an extension-by-zero left adjoint, or its consequence `restriction-preserves-injectives`) survives every narrowing unbuilt. Recommendation: decide the realization on the merits of "which route's irreducible new construction is cheapest," with rightDerived-global (no new construction) explicitly on the table — not by continuing to refine within the Ext family.

## Prerequisite verification

- `CategoryTheory.Abelian.Ext.covariant_sequence_exact₁/₂/₃'`, `Ext.covariantSequence_exact`: VERIFIED (`…DerivedCategory.Ext.ExactSequences`) — the load-bearing 01EO LES, covariant in the 2nd variable (matches Form A's fixed first arg `O_U`).
- Ext injective vanishing: VERIFIED as `CategoryTheory.HasInjectiveDimensionLT.subsingleton` — requires the **2nd** Ext argument injective, confirming Form A needs `I|_U` injective.
- `AlgebraicGeometry.Scheme.Modules.restrictAdjunction`: VERIFIED — `restrictFunctor ⊣ pushforward` (restriction is a LEFT adjoint, the wrong direction for preserving injectives).
- `j_!` (any `_ ⊣ restrictFunctor`): MISSING (loogle empty) — confirms Form B unbuildable and Form A's standard proof route blocked.
- `restriction-preserves-injectives` lemma: MISSING.
- `Functor.isZero_rightDerived_obj_injective_succ` + `toRightDerivedZero` injective iso: VERIFIED — backs the rightDerived-global alternative's free injective vanishing + `H⁰=Γ`.
- `Functor.rightDerived` LES: MISSING for classical `rightDerived` (no packaged δ-LES) — but `CategoryTheory.ShortComplex.ShortExact.δ` + `Mathlib.Algebra.Homology.HomologySequence` VERIFIED present, so the LES is hand-buildable on top of P4's horseshoe.

## Must-fix-this-iter

- Route (acyclicity bridge / Ext-Form-A): CHALLENGE — price the new `restriction-preserves-injectives` (≈ `j_!`) obligation against the rightDerived-global realization, and either commit to building it (concrete iter/LOC) or switch realization. Record the decision + rebuttal in `iter/iter-026/plan.md`.
- Infrastructure-deferral CHALLENGE: `restriction-preserves-injectives` is required by the chosen route and has no project-side build plan with a timeline. Build it this iter or produce a concrete plan with an iter estimate — or adopt the rightDerived-global route where it is not required.
- Alternative rightDerived-global: major omission — it is the only realization needing neither `j_!` nor `restriction-preserves-injectives`, with the P5a bridge near-definitional and the sole gap (δ-LES) reachable via existing P4 horseshoe + `ShortComplex.ShortExact.δ`. Must be evaluated head-to-head before committing.
- Format: NON-COMPLIANT — (1) pervasive per-iter narrative ("DECIDED (iter-0NN)" chain, "BUILT iter-018", etc.); (2) `## Open strategic questions` has become a historical-decisions appendix; (3) multi-sentence table cells in `## Phases & estimations` + over the 12 KB byte budget. Restructure in-place this iter: strip iter tags, state decisions as current facts, move the decision-history into the iter-026 sidecar, collapse table cells to one line each.

## Overall verdict

Route A and the rejection of Route B are SOUND, and every Mathlib name the Ext route leans on is
verified present — the strategy is not built on phantoms. But the iter-026 realization, Ext-Form-A,
is a CHALLENGE: the strategy defers `restriction-preserves-injectives` (equivalently `j_!`), which
is required by the chosen route (twice over — for the 01EO injective-vanishing step and for the
frozen P5a bridge) and currently has no project-side build plan with a timeline. The strategy's own
iter-026 finding shows the Ext route, chosen to avoid building extension-by-zero infrastructure, now
forces building it anyway — a pivot that renamed the hard prerequisite without solving it. The
decisive omission is the **rightDerived-global** realization (`(Γ_U).rightDerived`), the one route
that needs neither `j_!` nor `restriction-preserves-injectives` (injective vanishing trivial in the
global category, P5a bridge near-definitional, LES hand-buildable from the project's existing P4
horseshoe), which the strategy dismisses in a single line without the cost comparison. The planner
must run that comparison and either commit to building the deferred construction with a concrete
estimate or switch realizations. Separately, STRATEGY.md is NON-COMPLIANT (pervasive per-iter
narrative, a decisions-log appendix, oversized table cells, over the byte budget) and must be
restructured in-place this iter.
