# Progress Critic Directive

## Slug

iter115

## Iter

115

## Active routes / files under review

For iter-115 the planner is considering exactly one route for a prover dispatch this iter:

### Route: Differentials.lean — Phase B helper #1 / unique-gluing (`L175 relativeDifferentialsPresheaf_isSheafUniqueGluing_type`)

- **Started at iter**: 110 (route under-the-iter-113-pivot-form has been audited continuously since the original `relativeDifferentialsPresheaf_isSheaf` lane was opened iter-110)
- **Iters audited**: iter-110 through iter-114 (K = 5)

#### Sorry counts per iter (project total; per-file `Differentials.lean` in parens)

- iter-110: 16 (file: 5) — deeper-think iter; no prover lane on Differentials.
- iter-111: 16 (file: 5) — deeper-think iter; no prover lane dispatched (validator artifact prevented dispatch).
- iter-112: 16 (file: 5) — Phase B prover PARTIAL Bar B: helper #1 (`_isSheafOpensLeCover_type`) introduced at L159 with sorry body; helper #2 at L188 fully closed; main theorem body at L220 fully closed.
- iter-113: 16 (file: 5) — Phase B prover PARTIAL Bar B variant: helper #1's body closed via Mathlib framework chain (`IsSheafUniqueGluing → IsSheaf → IsSheafOpensLeCover`); new sub-helper `_isSheafUniqueGluing_type` at L168 introduced with sorry body. Reformulation route. Prover self-classified as "reformulation rather than genuine mathematical progress."
- iter-114: 16 (file: 5) — deeper-think iter; NO prover lane (HARD GATE fired on Differentials.tex + STUCK verdict on the route).

#### Helpers added per iter (in `Differentials.lean`)

- iter-110: 0 (deeper-think).
- iter-111: 0 (deeper-think; route not dispatched).
- iter-112: +2 helpers (`relativeDifferentialsPresheaf_isSheafOpensLeCover_type` at L159 with sorry body; `relativeDifferentialsPresheaf_isSheaf_type` at L188 derived from helper #1, fully closed). Net helper count change: +2; net sorry count change: 0.
- iter-113: +1 helper (`relativeDifferentialsPresheaf_isSheafUniqueGluing_type` at L168 with sorry body); helper #1's body closed by delegation via the Mathlib chain. Net helper count change: +1; net sorry count change: 0.
- iter-114: 0 (deeper-think; blueprint-writer + analogist dispatches only).

#### Prover statuses per iter

- iter-110: NO PROVER DISPATCHED (deeper-think).
- iter-111: NO PROVER DISPATCHED (validator artifact).
- iter-112: PARTIAL Bar B — Route (a) selected; ≥2 helpers instantiated; helper #2 + main body fully closed; helper #1 carries sorry.
- iter-113: PARTIAL Bar B variant (reformulation route) — helper #1 closed via framework Mathlib chain; new sub-helper `_isSheafUniqueGluing_type` carries the residual mathematical content. Self-classified by prover as "reformulation rather than genuine mathematical progress."
- iter-114: NO PROVER DISPATCHED (deeper-think; HARD GATE on Differentials.tex + STUCK verdict on the route).

#### Recurring blocker phrases

- "no off-the-shelf Mathlib lemma packages `Scheme.PresheafOfModules`-sheaf-on-affine-basis ⇒ sheaf on X" (or close paraphrase) appears in:
  - iter-110 blueprint-writer report (variant phrasing on the affine-basis bridge).
  - iter-112 prover report (verbatim).
  - iter-113 prover report (verbatim, as the `[gap]` callout in the new sub-helper's docstring).
  - iter-114 mathlib-analogist persistent file `analogies/affine-basis-sheaf-bridge.md` (verbatim, with independent verification by the analogist via Mathlib spot-checks).
  3 of the 4 audited iters where the route received attention; with the analogist re-verifying in iter-114, this is now established as a confirmed Mathlib gap (NOT phantom infrastructure).

#### Planner's current proposal for this iter

The planner proposes to open the L175 prover lane on `Differentials.lean` with the iter-114 analogist-verified corrected recipe:

- Step 1: Affine-basis identification via `KaehlerDifferential.isLocalizedModule_map` + `AlgebraicGeometry.Modules.tilde`.
- Step 2: Hand-rolled cofinality descent against `isSheaf_iff_isSheafOpensLeCover` (no off-the-shelf Mathlib bridge; the descent is hand-rolled this iter and the analogist confirmed this is the only path).
- Step 3: Uniqueness via `TopCat.Presheaf.Sheaf.eq_of_locally_eq` + `KaehlerDifferential.span_range_derivation`.

The iter-114 plan-phase dispatched two corrective subagents that materially change the situation entering iter-115:

1. **`blueprint-writer-differentials-iter114` (two-pass round)**: addressed all 4 iter-114 blueprint-reviewer must-fix items + recipe correction per the analogist Decision 5. The `Differentials.tex` chapter now contains the analogist-verified Mathlib-name recipe for `\lem:relative_kaehler_isSheafUniqueGluing`. Iter-114 ended with a clean (or projected-clean) blueprint chapter — the iter-115 blueprint-reviewer mandatory dispatch will confirm.

2. **`mathlib-analogist-affine-basis-sheaf-bridge-iter114`**: independently verified the iter-110/112/113 recurring blocker phrase is real (no off-the-shelf basis-to-X bridge in Mathlib b80f227; `Functor.IsCoverDense`, `IsDenseSubsite`, 1-hypercover-dense infrastructure all considered and rejected). Verdict: **PROCEED with iter-115+ closure on the existing route** with two corrections (Step 1 recipe fix; hand-roll Step 2 inline).

The planner's proposal is a substantively different prover lane than the prior iters' — it has (a) a corrected mathematical recipe; (b) an independent analogist verification that the route is real-and-tractable rather than chasing phantom Mathlib infrastructure; (c) an upgraded blueprint chapter providing the prover with the full recipe. The proposal is NOT another helper round on a CHURNING route — it is the first prover attempt on the route under the *corrected* recipe + clean blueprint.

## Out of scope

Routes not under consideration for prover dispatch this iter:

- `BasicOpenCech.lean` (all 6 sorries) — STUCK RATIFIED iter-108; off-limits.
- `Picard/LineBundle.lean` L82 + L96 — named Mathlib gap pair; off-limits.
- `Modules/Monoidal.lean` L173 — named Mathlib gap; off-limits.
- `Picard/Functor.lean` L181 — gated on C3; off-limits.
- `Jacobian.lean` L179 — JacobianWitness exit policy; off-limits.
- `Differentials.lean` L798 — named gap #2; off-limits.
- `Differentials.lean` L880 — Phase B prover-viable but **scheduled iter-117+ at earliest** per the strategy's Phase B dispatch order (L175 first, then L880, then L897, then L880-converse); not this iter.
- `Differentials.lean` L897 — Phase B prover-viable but corollary-of-L880-forward; **scheduled iter-118+ at earliest**; not this iter.
- `Differentials.lean` L1039 — named Mathlib gap #7 (serre-duality); off-limits.

The single route under consideration is the L175 unique-gluing helper. Verdict the route + planner proposal as one block.
