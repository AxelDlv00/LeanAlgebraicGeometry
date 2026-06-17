# AlgebraicJacobian/Albanese/CodimOneExtension.lean

## iter-182 outcome — NO-EDIT, plan-deferred file dispatched in error

**Status**: file UNCHANGED. 3 sorries remain (lines 222, 356, 397), same as
iter-181. Build GREEN (`lean_diagnostic_messages` returns exactly the 3
`declaration uses sorry` warnings, 0 errors).

**Root cause**: this file is explicitly listed under PROGRESS.md's
**"Off-limits this iteration"** and **"Standing deferrals"** sections, and
task_pending.md tags it `iter-182 DEFERRED`. The iter-182 plan-phase
mathlib-analogist consult `stacks-00tt-coheight` (full report at
`analogies/stacks-00tt-coheight.md`) concluded:

> Should iter-182 dispatch a CodimOneExtension prover lane?
> **No on the file directly — yes on the new CoheightBridge scaffold.**

iter-182 lanes A/B/D/E/F/G/I do **not** include this file. The parallel
prover harness nonetheless dispatched me on it. This task_results is the
honest report.

## The 3 sorries and what's needed

### Sorry 1 — `hreg_dim` (L243, inside `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`)

```lean
have hreg_dim : IsRegularLocalRing (X.left.presheaf.stalk z) ∧
                  ringKrullDim (X.left.presheaf.stalk z) = 1 := sorry
```

**Needs two Mathlib bridges, both genuinely absent at the pinned commit
`b80f227`:**

- **Stacks 00TT** (`Algebra.Smooth k A → IsRegularLocalRing A` at every
  prime): verified absent — `grep -rn "IsRegularLocalRing"
  .lake/packages/mathlib/Mathlib/RingTheory/Smooth/` returns 0 hits;
  `Mathlib.RingTheory.Smooth.Locus` characterises `smoothLocus` via
  `H¹Cotangent` + `freeLocus` but does NOT export an `IsRegularLocalRing`
  instance. Project-side build ≈ 200–300 LOC standalone (analogist
  Decision 1).

- **Coheight → KrullDim** (`Order.coheight z = 1 → ringKrullDim (X.presheaf.stalk z) = 1`):
  `lean_loogle` reports `AlgebraicGeometry.ringKrullDim_stalk_eq_coheight`
  in `Mathlib.AlgebraicGeometry.Properties`, **but `grep` on the pinned
  Mathlib at `b80f227` returns 0 hits** — this lemma is in newer Mathlib
  but not landed in this project's pinned version. Analogist's
  Decision 2 (~60–100 LOC project-side scaffold `CoheightBridge.lean`)
  is iter-183+ work per the planner.

### Sorry 2 — `extend_of_codimOneFree_of_smooth` (L368)

Milne 3.1 specialised: codim-1-indeterminacy-free + smooth source + complete
target ⇒ unique regular extension. **Gated** on:
- Sorry 1 (DVR construction) for Step-1 codim-1 valuative criterion.
- `Albanese/AuslanderBuchsbaum.lean`'s `cor:regular_cohen_macaulay`
  (depth-≥2 reflexive extension) for Step-2 codim-≥2 extension.

The AuslanderBuchsbaum input is itself iter-183+ (Lane G this iter pivots
to `depth_of_short_exact`, not the full corollary).

### Sorry 3 — `indeterminacy_pure_codim_one_into_grpScheme` (L411)

Milne Lemma 3.3: rational map into a group scheme has indeterminacy locus
empty or pure codim-1. Proof: diagonal/difference-map argument via
`Φ : X × X ⇢ G`, `(x,y) ↦ f(x) · f(y)⁻¹`, pole-divisor analysis.

**Multi-iter sub-project** (analogist Decision 3 estimates 300–500 LOC
standalone). Mathlib has the valuative criterion building blocks
(`Mathlib.AlgebraicGeometry.ValuativeCriterion`) but does **not** package
the codim-1-indeterminacy lemma. NOT iter-182 scope by any reasonable
sizing.

## Why no partial attempt was made

Per the prover prompt:
> NEVER revert to a bare `sorry`. Always leave your partial proof attempt
> in the code.

The current file is already the best partial-attempt state:

- `hreg_dim` is **NOT a bare sorry**. The surrounding proof skeleton
  (L222–271) extracts `hprin` (principal max ideal) and `hne` (non-bot)
  from the conjunction via `IsRegularLocalRing.iff_finrank_cotangentSpace`
  + `IsLocalRing.finrank_cotangentSpace_le_one_iff` + the
  `IsField → ringKrullDim = 0` contradiction. **Every line outside the
  `sorry` is closed.** The sorry is precisely the named Mathlib gap.

- `extend_of_codimOneFree_of_smooth` and
  `indeterminacy_pure_codim_one_into_grpScheme` carry **substantive typed
  signatures** matching the blueprint pins (no `True`, no reflexive-iso,
  no `Classical.choice` placeholders), with ~50 LOC of section docstrings
  explaining the intended Milne proof. Per the prompt:
  > Litmus test: if you `unfold` your declaration, does it expose the
  > named substantive content … or does it stop at `Classical.choice` …
  These unfold to the named substantive content (`∃! g, …`, the
  disjunction over indeterminacy points).

## What WOULD improve this file (iter-183+ plan, already committed)

Per `PROGRESS.md` "Next iter (iter-183) — preliminary commitments" item 2:

> **Lane M (NEW)**: scaffold `Albanese/CoheightBridge.lean` per
> `analogies/stacks-00tt-coheight.md` recipe (~60–100 LOC). Requires
> plan-phase blueprint-writer for `Albanese_CoheightBridge.tex`.

Once `CoheightBridge.lean` lands the coheight↔KrullDim bridge, the
`hreg_dim` refactor becomes:

```lean
have hdim : ringKrullDim (X.left.presheaf.stalk z) = 1 := by
  rw [Scheme.ringKrullDim_stalk_eq_coheight, _hz]; rfl
have hreg : IsRegularLocalRing (X.left.presheaf.stalk z) := sorry
  -- ↑ remains: Stacks 00TT, multi-iter project-side build
```

Net change: same sorry count, but the remaining sorry shrinks to *just*
the Stacks 00TT half. That is the right next step, but it depends on the
analogist's iter-183 Lane M lane.

## Considered (and rejected) inline build of CoheightBridge

I considered adding the `CoheightBridge` scaffold (4 helpers, ~70 LOC,
3–4 internal sorries) inline in this file to enable the `hreg_dim`
refactor. Rejected because:

1. The planner's iter-183 commitment is `Albanese/CoheightBridge.lean`
   as a **separate file** (Lane M). Pre-building it here would force
   iter-183 to either (a) duplicate or (b) delete-and-rebuild, both wasteful.
2. The scaffold itself opens 3–4 new named-but-unclosed sorries. Net
   sorry count on the file would jump from 3 → 6–7, against a planner
   "deferred" classification.
3. Per the prover prompt: "Don't add features, refactor, or introduce
   abstractions beyond what the task requires." This file's task is
   "defer per planner" — adding scaffold infrastructure exceeds that.

## Search log (no fresh discoveries vs. analogist)

- `lean_loogle "Smooth, IsRegularLocalRing"` — No results.
- `lean_loogle "ringKrullDim, Scheme.presheaf.stalk"` — No results.
- `lean_loogle "Order.coheight, ringKrullDim"` — returns
  `AlgebraicGeometry.ringKrullDim_stalk_eq_coheight`, BUT not in pinned
  Mathlib (verified via `grep` and `lean_run_code`).
- `lean_leansearch "smooth scheme regular local ring at point"` — only
  `Algebra.IsSmoothAt`, `Algebra.smoothLocus`,
  `AlgebraicGeometry.IsSmooth.exists_isStandardSmooth`. None ship a
  `→ IsRegularLocalRing` arrow.
- `lean_leansearch "smooth algebra implies regular local ring at prime"`
  — same lemmas as above; `Algebra.smoothLocus_eq_univ_iff` is the
  closest but characterises the locus, not the ring property at a point.
- `grep -rn "IsRegularLocalRing\|IsRegularRing"
  .lake/packages/mathlib/Mathlib/RingTheory/Smooth/` — 0 hits.
- `grep -rn "ringKrullDim_stalk_eq_coheight" .lake/packages/mathlib/` —
  0 hits.

Confirms: analogist `analogies/stacks-00tt-coheight.md` is fully accurate
for this commit. No fresh discovery this iter changes the deferral.

## Concrete next steps (for iter-183+ prover on this file)

1. **iter-183 Lane M** lands `Albanese/CoheightBridge.lean` (~60–100 LOC,
   4 helper sorries per analogist recipe).
2. **iter-184+** refactor `hreg_dim` to `hdim` (closed via the bridge) +
   `hreg` (remaining sorry on Stacks 00TT half).
3. **iter-185+** open a `SmoothToRegular.lean` lane targeting Stacks 00TT
   (analogist's "Strategic note on Stacks 00TT", 3 helpers, ~200–300 LOC)
   to close the remaining `hreg`. This finishes `localRing_dvr_of_codim_one`.
4. **iter-186+** with Lane G (AuslanderBuchsbaum) and the DVR in hand,
   close `extend_of_codimOneFree_of_smooth` (Milne 3.1 specialised).
5. **iter-187+** (or later, possibly parallel) standalone multi-iter
   build of `indeterminacy_pure_codim_one_into_grpScheme` (Milne 3.3
   diagonal/difference-map, ~300–500 LOC).

## Lemmas confirmed existing in pinned Mathlib (for downstream provers)

- `IsRegularLocalRing.iff_finrank_cotangentSpace`
  (`Mathlib.RingTheory.RegularLocalRing.Defs` L65) — *used* in current
  file body.
- `IsLocalRing.finrank_cotangentSpace_le_one_iff` — *used*.
- `IsLocalRing.isField_iff_maximalIdeal_eq` — *used*.
- `ringKrullDim_eq_zero_of_isField` — *used*.
- `IsDiscreteValuationRing.TFAE` — *used* (entry index 4 is principal
  maximalIdeal).
- `LocallyOfFiniteType.isLocallyNoetherian` — *used* (Noetherian stalk
  setup).
- `Mathlib.AlgebraicGeometry.ValuativeCriterion` (file) — building blocks
  for Sorry 2's valuative-criterion step; NOT a drop-in.

## Lemmas confirmed ABSENT in pinned Mathlib

- `Algebra.Smooth → IsRegularLocalRing` (Stacks 00TT). 0 grep hits.
- `Order.coheight z = 1 → ringKrullDim (X.presheaf.stalk z) = 1` (the
  `Scheme.ringKrullDim_stalk_eq_coheight` bridge). 0 grep hits at
  `b80f227`. (Available upstream but not landed.)
- Codim-1-indeterminacy lemma for rational maps into proper / group
  targets. 0 hits.

## Blueprint chapter

`blueprint/src/chapters/Albanese_CodimOneExtension.tex` — read; no
edits needed (this is a prover-side report, not a blueprint update).
The 6 pinned declarations match the file's current state and the prose
correctly identifies the dependencies on `cor:regular_cohen_macaulay`
(AuslanderBuchsbaum) and the codim-1 valuative criterion. The
`\leanok` markers for the 3 declarations carrying the bare `sorry`
should remain absent until iter-184+; `sync_leanok` handles this
deterministically.

## Summary line for plan agent

`CodimOneExtension.lean`: NO-EDIT, 3 sorries unchanged, all 3
plan-deferred per `analogies/stacks-00tt-coheight.md` + PROGRESS.md
"Off-limits". Harness dispatched a deferred file; honest report
filed. Next active iter for this file: **iter-184+** after iter-183
Lane M (CoheightBridge) lands.
