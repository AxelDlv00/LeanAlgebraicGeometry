# Strategy Critic Report

## Slug
iter009

## Iteration
009

## Routes audited

### Route: A — acyclic-resolution / Cartan–Leray comparison (CHOSEN)

- **Goal-alignment**: PASS — the acyclic-resolution comparison `Hⁱ(f_* C•) ≅ (pushforward f).rightDerived i F` delivers exactly the `Nonempty (… ≅ …)` existence goal; the resolution+termwise-acyclicity inputs are the standard hypotheses of Leray's acyclicity (Stacks 015E) and they are sufficient.
- **Mathematical soundness**: PASS — I traced the full SS-free skeleton (see below) and it closes. Each of the three flagged P5 lemmas has a genuine Route-A (no-spectral-sequence) rewrite; none is a hidden Route-B dependency.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no formal deferral — every gap is project-side-scoped — BUT the basis lemma's *sub-prerequisites* are unenumerated (see Effort honesty / Must-fix).
- **Phantom prerequisites**: none. All four P4 prerequisites verified present (see Prerequisite verification).
- **Effort honesty**: under-counted — P5a (`~150–350` LOC / `~2–4` iters) folds three deep results plus an entire unscoped Čech-to-derived-H¹ comparison sub-theory into roughly the budget that P1 spent on a *single* functoriality lemma (`~120` LOC / 2 iters). See the P5a finding below.
- **Parallelism under-exploited**: no — P3, P4, P5a are correctly marked independent and P5a is flagged as a parallel prover lane.
- **Verdict**: CHALLENGE — the route is mathematically sound and genuinely self-contained, but P5a is under-scoped: the basis lemma 01EO is treated as one atomic gap when its own proof rests on a stack of Čech-to-derived comparison machinery the strategy never lists.

**Answer to directive Q1 (Route A self-containedness).** Route A is genuinely SS-free for the existence goal. I verified each of the three suspect lemmas:

1. **Basis lemma `lem:cech_to_cohomology_on_basis` (Stacks 01EO).** I read the Stacks proof (`stacks-cohomology.tex:1716–1776`). It is *not* a spectral-sequence argument: embed `F ↪ I` (injective), set `Q = I/F`, use the cohomology **LES + dimension shift** ("And so on and so forth"). This is precisely the P4 homological-algebra flavour — Route-A compatible. ✔
2. **Termwise acyclicity `R^q f_* C^p = 0`.** `C^p = ∏_σ (j_σ)_* F_σ`; `R^q f_*` commutes with the finite product, and `R^q f_*((j_σ)_* F_σ) = R^q(f∘j_σ)_* F_σ` via the acyclic-composition corollary (below), reducing to absolute affine Serre vanishing after localising `S` to an affine. No Grothendieck SS. ✔
3. **Open-immersion pushforward `lem:open_immersion_pushforward_comp`.** `j_σ` is a **flat** affine open immersion, so `(j_σ)_*` is exact on QCoh (`R^{>0}(j_σ)_*=0`) **and preserves injectives** (Stacks `lemma-pushforward-injective-flat`, `stacks-cohomology.tex:1820–1833`, an `O_X`-module statement). Hence `g_* I•` is an injective resolution of `g_* F` and `R^q(f∘j_σ)_* = R^q f_* ∘ (j_σ)_*` directly from injective resolutions — strictly weaker than (and not needing) the relative Leray SS. ✔

So the planner's open item "rewrite the three P5 sketches to Route-A before P5a passes the gate" is *achievable*; none of the three doom Route A.

### Route: B — two spectral sequences (REJECTED, fallback)

- **Verdict**: SOUND — correctly rejected. Both the Čech-to-derived and relative Leray spectral sequences are absent from Mathlib (multi-thousand-LOC), and Route A reaches the same `Nonempty (… ≅ …)` with verified infrastructure. Keeping it as a one-paragraph fallback is acceptable, not excised-route bloat.

### Route: The P3-narrowing ↔ P5a-basis-lemma bridge

- **Goal-alignment**: PASS — narrowing `CechAcyclic.affine` to standard covers is downstream-safe *exactly because* the final assembly routes general-cover vanishing through 01EO, not through `CechAcyclic.affine` directly.
- **Mathematical soundness**: PASS — **not circular**. I checked 01EO's hypotheses (`stacks-cohomology.tex:1703–1713`): condition (3) requires Čech vanishing only for the coverings in `Cov` (the standard/cofinal system — what narrowed P3 supplies), and condition (2) is *cofinality of standard affine covers* (a topological fact), *not* general-cover affine acyclicity. 01EO consumes standard-cover Čech vanishing and **produces** the general affine `H^q(U,F)=0`; it never consumes the thing it produces. This is precisely the Stacks bootstrap of 02KG (affine Serre vanishing) and it is the standard, hard-to-avoid path.
- **Verdict**: SOUND.

**Answer to directive Q2.** The bridge is load-bearing and sound, not circular. **Answer to directive Q3.** De-SS-ing the P5a blueprint *prose* now is sound and independent — it only needs the P4 theorem *statement* (settled, signature stable), not P4 compiled. The strategy already correctly gates the P5a *prover lane* on P4 closing ("First action once P4 closes"). No premature dependency.

## Format compliance

- **Size**: ≈95 lines / well under 12 KB — within budget.
- **Headings**: PASS — exactly `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: no — `## Completed` uses the allowed `002 · 2` ledger form; no "this iter / last iter" prose.
- **Accumulation detected**: no — P1/P2 are in `## Completed`, not the active table; Route B is a deliberate fallback, not an excised route.
- **Table discipline**: PARTIAL — columns are correct, but several `Risks` cells (notably P4) and the P5a/P3 cells carry multi-sentence prose rather than "one short line." Borderline cell-verbosity drift; not material.
- **Format verdict**: DRIFTED — only the cell-verbosity nit; tighten Risks cells opportunistically, no in-place restructure required.

## Sunk-cost flags

None detected. Route A is justified on merits (verified infra, fewer gaps), not on prior investment; Route B's rejection is on cost grounds, not "we already built A."

## Prerequisite verification

- `InjectiveResolution.isoRightDerivedObj`: VERIFIED (`Mathlib/CategoryTheory/Abelian/RightDerived.lean:112`).
- `Functor.rightDerivedZeroIsoSelf`: VERIFIED (`…/RightDerived.lean:366`).
- `ShortComplex.ShortExact.homology_exact₁/₂/₃`: VERIFIED (`Mathlib/Algebra/Homology/HomologySequence.lean:293,299,…`).
- `ShortComplex.ShortExact.δ` / `.isIso_δ` / `.δIso`: VERIFIED (`…/HomologySequence.lean:282,350,355`).
- `lemma-pushforward-injective-flat` (flat pushforward preserves injective `O_X`-modules) — backs the SS-free open-immersion rewrite: VERIFIED as a Stacks lemma (`references/stacks-cohomology.tex:1820`); needs project-side formalisation, not present in Mathlib for `Scheme.Modules`.
- Mathlib site sheaf cohomology exists (`CategoryTheory/Sites/SheafCohomology/{Basic,Cech,MayerVietoris}.lean`) BUT `H n := Ext … (Sheaf J AddCommGrpCat)` is **abelian-group sheaves on a site**, not `X.Modules` (`O_X`-modules), and the goal's cohomology is `(pushforward f).rightDerived` on `X.Modules`. Reusing it for the basis lemma requires a non-trivial category bridge — it does not make P5a free.

## Must-fix-this-iter

- **Route A / P5a: effort-honesty + scoping CHALLENGE.** Before dispatching the P5a prover lane, the planner must enumerate and re-estimate the basis lemma's *sub*-prerequisites, which the current `## Mathlib gaps` list collapses into the single line "Čech-to-cohomology-on-a-basis." The Stacks 01EO proof additionally requires, on `Scheme.Modules`: (a) absolute sheaf cohomology `H^p(U,F)` as a derived functor (or a verified bridge to Mathlib's `Sheaf J AddCommGrpCat` `H n`); (b) the Čech-to-derived H¹ comparison `lemma-cech-h1` + locality of cohomology `lemma-kill-cohomology-class-on-covering`; (c) `lemma-ses-cech-h1`; (d) `lemma-injective-trivial-cech` (injectives have trivial higher Čech); (e) cofinality of standard affine covers; (f) `lemma-pushforward-injective-flat`. With these counted, `~150–350` LOC / `~2–4` iters for P5a is optimistic — re-estimate or add a P5a sub-row, in STRATEGY.md or via an explicit plan.md rebuttal.

## Overall verdict

Route A is sound and — contrary to the worry in directive Q1 — genuinely self-contained: I traced an SS-free path for all three suspect P5 lemmas (basis lemma 01EO is an injective-embedding/dimension-shift argument; termwise acyclicity and open-immersion pushforward both reduce to affine Serre vanishing via the *acyclic-composition* corollary, which follows from injective resolutions + flat-pushforward-preserves-injectives, not the Grothendieck/Leray SS). The P3-narrowing ↔ basis-lemma bridge is load-bearing and **not** circular: 01EO consumes standard-cover Čech vanishing (narrowed P3) and produces the general affine vanishing, never the reverse. P4's four named Mathlib prerequisites all verify. The one real problem is effort honesty: the strategy does **not** defer any goal-required construction, but it under-scopes P5a — the basis lemma is treated as atomic when its proof rests on an unenumerated Čech-to-derived comparison sub-theory on `Scheme.Modules` (Mathlib's site cohomology is in the wrong category and only partly reusable). Address P5a's sub-prerequisite scoping/estimate this iter; the math and phase ordering are otherwise green, and starting the P5a blueprint de-spectral-sequencing in parallel now is correct.
