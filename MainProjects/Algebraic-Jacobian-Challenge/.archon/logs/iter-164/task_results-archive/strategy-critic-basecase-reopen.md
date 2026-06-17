# Strategy Critic Report

## Slug
basecase-reopen

## Iteration
164

## Base-case route adjudication (the directive's central question)

**Verdict: the circularity finding is INCORRECT for the genus-0 base case, and none of
candidates (A)/(B)/(C) is the right answer. There is a 4th route — the one the directive
itself half-named — and it is the soundest, least-Mathlib-blocked, char-free path. It is
already supported by the project's proven infrastructure almost end-to-end.**

### Why the "circularity" is illusory

The circularity in `thm32-extend.md` / STRATEGY.md arises *only* because the blueprint
insists on extending the additive-defect map `ψ(x,y)=f(x+y)−f(x)−f(y)` over the **complete
symmetric surface `ℙ¹×ℙ¹`** via the abstract Theorem 3.2 (whose emptiness half = Lemma 3.3
needs Auslander–Buchsbaum). That is Milne's *general* Theorem 3.4 machinery, which exists to
handle a morphism `α : V×W → A` on a **non-complete** source `V` that must first be
completed and the map abstractly extended.

The genus-0 base case is not that general situation. Here the source curve is **already
complete** (`C_{k̄} ≅ ℙ¹`), and `f : ℙ¹ → A` is **already a total morphism**. The defect map
can be written so that it is *manifestly a total morphism on `ℙ¹ × 𝔾_a`* with **no abstract
extension and no codim-2 emptiness anywhere**:

- Let `σ : ℙ¹ × 𝔾_a → ℙ¹`, `σ(x,y) = x + y`, be the translation action of `𝔾_a` on
  `ℙ¹ = 𝔸¹ ∪ {∞}` (Möbius, fixes `∞`). This is a genuine scheme morphism on **all** of
  `ℙ¹ × 𝔾_a` — in the chart `u = 1/x` at `∞`, the target coordinate `1/(x+y) = u/(1+uy)` is
  regular at `u=0`; points with `x+y=0` are covered by the other target chart. No
  indeterminacy. Char-free, explicit.
- Define `h := σ ≫ f : ℙ¹ ⊗ 𝔾_a → A`. Every constituent (`σ`, `f`, the group ops on `A`) is
  a total morphism, so `h` is a **total** morphism. Verified against Milne PDF p.19
  (`/tmp/milne_23_28.txt` L86–94): the only place Milne invokes Thm 3.2 is to extend a
  *general* `α` over `C × W`; with `σ ≫ f` the extension is free.

Now apply the **already-proven** `hom_additive_decomp_of_rigidity` (Milne Cor 1.5,
`AbelianVarietyRigidity.lean:809`) with `V := ℙ¹` (`IsProper` ✓), `W := 𝔾_a` (no
completeness needed ✓), `A` the abelian variety, normalizing `f(0)=η`:

- `h(v₀,w₀) = f(0+0) = f(0) = η[A]` ✓ (the `hh` hypothesis).
- V-axis restriction `x ↦ h(x,0) = f(x)`; W-axis restriction `y ↦ h(0,y) = f(y)`.
- Cor 1.5 gives `h = (p ≫ f) · (q ≫ g)`, i.e. `f(x+y) = f(x) + f(y)` on `𝔸¹`.

So `f|_{𝔾_a}` is a homomorphism `𝔾_a → A`. Then `Hom(𝔾_a, A)=0` (already an itemized,
char-free task: affine connected image in a complete group is a point / Milne's `𝔾_a`–`𝔾_m`
double-additivity, PDF L127–130) forces `f` constant.

**This uses the proven `rigidity_lemma` (whose signature `AbelianVarietyRigidity.lean:760`
takes `[IsProper X.hom]` on the first factor and an arbitrary second factor `Y` — exactly
`X=ℙ¹`, `Y=𝔾_a`) and the proven Cor 1.5. It needs NO Theorem 3.2, NO Lemma 3.3, NO
Auslander–Buchsbaum, NO theorem of the cube, NO differentials, NO Frobenius.**

### Scoring the three candidates the directive asked me to weigh

- **(A) gap-fill Auslander–Buchsbaum + full Thm 3.2** — REJECT *for the base case*. It is a
  large, deep commutative-algebra construction (regular local ⟹ UFD) that Mathlib lacks, and
  the base case provably does **not** require it. Pursuing (A) for the base case is
  *over-building* — the inverse of infrastructure deferral, but just as wasteful. (It may
  remain genuinely no-regret for Route A's Albanese UP — see the note below — but that is a
  Route-A decision, not a reason to put it on the genus-0 path.)
- **(B) differential `H⁰(ℙ¹,Ω¹)=0` / `df=0`** — REJECT. `route-support.md` confirms it needs
  THREE absent from-scratch foundations (scheme-level `Ω` sheaf H1, a complete
  coherent-sheaf cohomology theory + `O(n)` + Serre's `H⁰` computation H2 — "the single
  largest gap surfaced anywhere", scheme Frobenius H3). Worse, the `df=0 ⇏ constant` Frobenius
  subtlety is a genuine char-p hole, and the protected goal is **char-general** (no
  `[CharZero]`), so a char-0-only base case would not close the challenge. Strictly dominated.
- **(C) theorem of the cube / seesaw** — REJECT. Correctly excised at iter-163; the base case
  needs neither, and the 4th route confirms it.

### The 4th route's only genuinely new ingredient

The translation action `σ : ℙ¹ × 𝔾_a → ℙ¹` as a scheme morphism. This is elementary
(an algebraic `𝔾_a`-action by Möbius maps), bounded, and orders of magnitude smaller than
Auslander–Buchsbaum. The other ingredients are all already in the plan: `rigidity_lemma`
(DONE), Cor 1.5 (DONE), `Hom(𝔾_a,A)=0` (itemized), and the `genus-0 ⟹ ℙ¹` RR bridge
(itemized, needed regardless). The 4th route therefore *removes* the scariest gap from the
genus-0 path and replaces it with a small construction.

## Routes audited

### Route: A — Picard/Quot/Hilbert FGA engine

- **Goal-alignment**: PASS — the positive-genus object `J = Pic⁰_{C/k}` is genuinely required
  (object must be a real dim-`g` AV even when `C(k)=∅`).
- **Mathematical soundness**: PASS — standard FGA.
- **Effort honesty**: reasonable but admittedly large — `~5100+ · 0/it`, `~40–70` iters, with
  the honest caveat "Albanese UP NOT yet itemised in ~5100 — true budget higher." The `0/it`
  velocity is honest (no work started) rather than a stagnation flag, since the row is
  explicitly gated behind the genus-0 stack.
- **Verdict**: SOUND — not the focus of this re-open; representability (A.2) remains the
  known dominant project risk and is honestly flagged.

### Route: C — genus-0 rigidity completion via Milne §I.3

- **Goal-alignment**: PASS — `ℙ¹→A const` + RR bridge + trivial `Spec k` object closes the
  genus-0 arm.
- **Mathematical soundness**: PARTIAL — the *route* is sound and in fact stronger than the
  strategy states, but the strategy's **current description of the base case is wrong**: it
  asserts the base case "cannot route through Thm 3.2 (circular); the emptiness half needs
  Auslander–Buchsbaum (absent)" and frames this as a live blocker. The base case does not
  route through Thm 3.2 at all (see adjudication). The mis-description risks the planner
  committing to candidate (A)'s large Auslander–Buchsbaum gap-fill.
- **Infrastructure-deferral detected**: no (the opposite — an over-building risk; see finding).
- **Phantom prerequisites**: none — `rigidity_lemma` and `hom_additive_decomp_of_rigidity`
  verified present with the right signatures.
- **Verdict**: CHALLENGE — adopt the 4th route, correct the circularity framing, and stop
  treating Auslander–Buchsbaum / Lemma 3.3 as on the genus-0 path.

## Format compliance

- **Size**: 179 lines / 12965 bytes — slightly **over byte budget** (>12 KB / 12288 B);
  within the 250-line budget.
- **Headings**: PASS — the five canonical sections appear in order. (`**Soundness rules
  (operational)**` is inline bold under "Mathlib gaps", not a separate top-level heading —
  acceptable, but it is the kind of operational boilerplate that ideally lives in the plan
  prompt, not STRATEGY.md.)
- **Per-iter narrative detected**: yes — e.g. `"base-case sub-route RE-OPENED (iter-164)"`,
  `"SPLITS (iter-164 mathlib-analogist \`thm32-extend\`)"`, `"**CIRCULARITY (iter-164):**"`,
  `"**RE-OPENED (iter-164): how is the genus-0 base case..."`, and a cross-ref to
  `iter/iter-163/plan.md`. Iter tags belong in iter sidecars, not STRATEGY.md.
- **Accumulation detected**: minor — the "Off-path fallbacks (kept in tree, NOT pursued)"
  block plus the dedicated "FALLBACK route (a) only" Mathlib-gaps subsection keep excised
  routes resident; the `rigidity_over_kbar` `[CharZero]` artifact is repeatedly cited.
- **Table discipline**: PASS.
- **Format verdict**: DRIFTED — strip the `(iter-NNN)` tags and the `iter/iter-163/plan.md`
  cross-ref into the iter sidecar, trim the fallback prose to claw back under 12 KB.

## Infrastructure-deferral findings

### Deferred: (inverted) Auslander–Buchsbaum / Lemma 3.3 emptiness

- **Required by goal**: no — the genus-0 base case does not require it (see adjudication).
  The strategy currently treats it as a live genus-0 blocker; that is a *mis-classification*,
  not a deferral, but it has the same downstream danger: it points the planner at a large
  absent construction.
- **Current plan for building it**: STRATEGY.md gates it "on the base-case route decision"
  and offers candidate (A) "gap-fill Auslander–Buchsbaum" as an option.
- **Timeline**: absent (it is the open question).
- **Verdict**: CHALLENGE — remove Auslander–Buchsbaum/Lemma 3.3 from the genus-0 critical
  path. If it is retained anywhere, it must be solely as a *Route-A Albanese-UP* line item,
  and even there the planner should first check whether the same complete-source escape (the
  curve `C` is proper) dissolves it before scheduling an Auslander–Buchsbaum build.

## Alternative routes (suggested)

### Alternative: direct `ℙ¹ × 𝔾_a` rigidity via the explicit translation morphism (the 4th route)

- **What it looks like**: build `σ : ℙ¹ × 𝔾_a → ℙ¹` (translation), set `h := σ ≫ f`, apply
  the proven `hom_additive_decomp_of_rigidity` (Cor 1.5) with proper first factor `ℙ¹` and
  non-complete second factor `𝔾_a` to get `f(x+y)=f(x)+f(y)`, then `Hom(𝔾_a,A)=0`. Detailed
  above.
- **Why it might be cheaper or sounder**: it reuses two **already-proven, axiom-clean**
  theorems (`rigidity_lemma`, Cor 1.5) whose signatures already permit a non-complete second
  factor; it adds only the small explicit `σ` construction; it is fully char-general; and it
  deletes the project's single scariest genus-0 gap (Auslander–Buchsbaum). It is essentially
  Milne's Prop 3.9 read correctly — Milne only ever invokes Thm 3.2 to extend a *general*
  map, never one of the form `σ ≫ f` with `f` already total on the complete curve.
- **What the current strategy may have rejected**: it appears the strategy conflated the
  base case with Milne's general Theorem 3.4 / Prop 3.10 (unirational, genuinely high-dim,
  genuinely needs the surface extension) and inherited that route's Thm 3.2 dependency.
- **Severity of the omission**: critical — this is the answer to the re-opened question, and
  it averts a multi-thousand-LOC detour into either Auslander–Buchsbaum (A) or
  Serre-duality/cohomology/Frobenius (B).

## Prerequisite verification

- `AbelianVarietyRigidity.rigidity_lemma`: VERIFIED — `[IsProper X.hom]` on the first factor,
  arbitrary `Y`; conclusion `∃ g, f = snd X Y ≫ g`. Supports `X=ℙ¹`, `Y=𝔾_a`.
- `AbelianVarietyRigidity.hom_additive_decomp_of_rigidity` (Cor 1.5): VERIFIED — `V` proper,
  `W` arbitrary, `A` an AV; gives the additive decomposition. Directly drives the base case.
- `AlgebraicGeometry.ValuativeCriterion.Existence` / `IsProper.eq_valuativeCriterion` /
  `Scheme.PartialMap.ofFromSpecStalk`: VERIFIED present (per `route-support.md` /
  `thm32-extend.md`) — relevant to the codim-1 Thm 3.1 infra, which remains genuinely
  no-regret and is unaffected by this adjudication.
- `IsRegularLocalRing → UniqueFactorizationMonoid` (Auslander–Buchsbaum): MISSING — confirmed
  absent; and now shown **not needed** on the genus-0 path.

## Must-fix-this-iter

- Route C: CHALLENGE — replace the base-case description with the 4th route (direct
  `ℙ¹ × 𝔾_a` rigidity via `σ`); the "RE-OPENED" open question is hereby adjudicated and
  should be marked RESOLVED = 4th route, not left for the planner to pick (A)/(B)/(C).
- Infrastructure (inverted) Auslander–Buchsbaum CHALLENGE — strike Lemma 3.3 / Auslander–
  Buchsbaum from the genus-0 critical path; keep it (if at all) only as a flagged, not-yet-
  needed Route-A item to re-examine via the complete-source escape.
- Format: DRIFTED — strip `(iter-NNN)` narrative tags and the `iter/iter-163/plan.md`
  cross-ref into the iter sidecar; trim fallback prose to get back under 12 KB.

## Overall verdict

Route A is SOUND and unchanged. Route C is fundamentally sound and, once the base case is
described correctly, **less blocked than the strategy currently believes**: the re-opened
genus-0 base case `ℙ¹→A const` does **not** require Theorem 3.2's emptiness half, does **not**
require Auslander–Buchsbaum, and is **not** circular. The directive's three candidates
(A)/(B)/(C) are all suboptimal; the correct answer is the 4th route — a direct rigidity
argument on `ℙ¹ × 𝔾_a` using the explicit translation morphism `σ`, the already-proven
`rigidity_lemma` and Corollary 1.5, and the already-itemized `Hom(𝔾_a,A)=0`, all char-general.
The strategy's standing claim that "Lemma 3.3 IS on the genus-0 path, NOT deferrable" is a
genuine error and must be corrected this iter; left uncorrected it risks steering a prover
into a large unnecessary Auslander–Buchsbaum or cohomology build. The only genuinely new
ingredient the 4th route needs is the elementary `𝔾_a`-translation action on `ℙ¹`. Format is
DRIFTED on per-iter narrative and is marginally over the byte budget; restructure in place.
