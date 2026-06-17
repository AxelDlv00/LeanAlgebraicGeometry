# Recommendations for the next plan iteration (iter-008)

## Closest-to-completion — prioritize (P4 is ~1–2 leaves from closing)

P4 collapsed to **two remaining declarations**, both in `AcyclicResolution.lean`:

1. **`Functor.rightDerivedOneIsoCokerOfAcyclic` (lem:acyclic_one_iso_coker)** — the next frontier
   leaf (confirmed `archon dag-query frontier`). The prover handed off a precise, indexing-checked
   recipe (see `task_results/AlgebraicJacobian/Cohomology/AcyclicResolution.md`):
   - horseshoe-lift `ses` to the degreewise-split resolution SES
     `0 → G(I_A) → G(I_J) → G(I_Z) → 0` (`shortExact_map_mapHomologicalComplex_of_degreewise_splitting`,
     exactly as in `rightDerivedShiftIsoOfSplitResolutionSES`);
   - read the **bottom** of its homology LES: `homology_exact₂/₃` at degree `(0,1)` + acyclic
     vanishing `isZero_homology_mapHomologicalComplex_of_isRightAcyclic I_J 0` (`H¹(GI_J)=0`,
     already in file) ⇒ `δ⁰` epi with kernel = image of `H⁰(GI_J)→H⁰(GI_Z)`;
   - conclude `(R¹G)(A) ≅ coker(G.map ses.g)` via `ShortComplex.Exact.gIsCokernel` +
     `IsColimit.coconePointUniqueUpToIso`.
   - **Hard sub-step (budget an effort-break if it resists)**: identify the homology map
     `H⁰(GI_J)→H⁰(GI_Z)` with `G.map ses.g` under `isoRightDerivedObj` + `rightDerivedZeroIsoSelf`
     — the `R⁰G ≅ G` naturality bookkeeping (see `analogies/p4-derived-les.md`). This is the only
     genuinely new work; everything else mirrors existing in-file lemmas.

2. **`Functor.rightDerivedIsoOfAcyclicResolution` (TARGET-3 assembly)** — straight-line `Nat.rec`
   composition of the 3 closed leaves + leaf (1). Recipe in the task_result; `ses.g` of
   `cosyzygyShortComplex K m` is `K.toCycles m (m+1)` so the cokernels match on the nose.

### BLUEPRINT FIX REQUIRED BEFORE re-dispatching the prover on these two (HARD-GATE relevant)
lean-vs-blueprint-checker (`acyclic`, MAJOR) found the two frontier-leaf sketches are
**under-specified for a prover** — do a focused **effort-break / blueprint-writer** pass on
`Cohomology_AcyclicResolution.tex` first:
- **`lem:acyclic_one_iso_coker`**: sketch is silent on the concrete Lean LES mechanism for the
  **degree-0 cokernel extraction** — `δIso` does NOT apply at degree 0 (flanking middle-complex
  terms not both zero). Add: "use exactness at `(R¹G)(A)` + the zero right-end to get the cokernel
  iso" and name the LES term sequence.
- **`lem:acyclic_resolution_computes_derived` (TARGET-3)**: (Gap 1) **input-type not pinned** — the
  blueprint must say which Lean object encodes "the resolution is exact" (the prover's status
  comment suggests `J : CochainComplex 𝒜 ℕ`, `[∀ n, G.IsRightAcyclic (J.X n)]`, `A : 𝒜`,
  `e : A ≅ K.cycles 0` or `π : (single₀).obj A ⟶ J` with `[QuasiIso π]`). Choose one and state it.
  (Gap 2) the **n=0 empty-staircase** case needs an explicit note. (Gap 3) the bridge from
  `cohomologyAppliedResolutionIso` (typed in `K.toCycles`) to `acyclic_one_iso_coker` (typed in
  `G(J)→G(Z)`) should be spelled out (they coincide because `ses.g = K.toCycles`).

This is the same partial/under-specified pattern as iter-006's `acyclic_dimension_shift` flag —
cheaper to fix the blueprint now than to have the prover discover the input type mid-build.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **Left-exact functor + cycles**: `ShortComplex.mapCyclesIso` is UNUSABLE (needs
  `PreservesLeftHomologyOf`); use `Limits.isLimitForkMapOfIsLimit'` + `conePointUniqueUpToIso`.
- **`← G.map_comp` silently fails** next to a mapped-complex term — isolate the rewrite on a clean
  `have` and close the main goal in term mode (`toCycles_i` as a term).

## Lean comment hygiene (MAJOR, lean-auditor — needs a prover/refactor edit, NOT mine)
- `AcyclicResolution.lean` ~L823: the status comment still says "(b) Cosyzygy SES infrastructure NOT
  yet built" — **false now**; the whole cosyzygy SES + applied-cohomology layer is built. The
  planner should have the next prover (or a `refactor` dispatch) update this block to reflect that
  only `rightDerivedOneIsoCokerOfAcyclic` + the assembly remain. (I cannot edit `.lean`.)

## 1-to-1 coverage debt (`archon dag-query unmatched`) — planner to blueprint or mark keep-as-aux
New `lean_aux` decls this iter with **no blueprint node** (all in `AcyclicResolution.lean`):
- `CategoryTheory.cosyzygy_iCycles_comp_toCycles` — cosyzygy composite `Zⁿ↪Kⁿ↠Zⁿ⁺¹ = 0` (helper).
- `CategoryTheory.epi_toCycles_of_exactAt` — `ExactAt(n+1) ⇒ Epi(toCycles)` (helper for cosyzygy SES).
- `CategoryTheory.cosyzygyKernelFork` — `iCycles` is a kernel of `toCycles` (glue).
- `CategoryTheory.Functor.cosyzygyShortComplex` — packages the cosyzygy triple (could be
  `\lean{}`-referenced from `lem:cosyzygy_ses` since it is the underlying `ShortComplex`).
- `CategoryTheory.Functor.gCosyzygyIsoCocycles_hom_iCycles` — cycles-iso ∘ iCycles compat (helper).
- `CategoryTheory.Functor.gCosyzygyIsoCocycles_toCycles` — naturality square (the non-trivial rewrite
  the blueprint proof of `lem:cohomology_of_applied_resolution` glossed; **worth a one-line blueprint
  mention** so the next reader knows it is non-trivial).
All are genuine internal infrastructure; the planner should add thin blueprint entries or mark them
keep-as-`lean_aux`. (The remaining ~23 unmatched nodes are pre-existing — push-pull helpers from
`CechHigherDirectImage` + earlier horseshoe/twistedBiprod helpers — already known debt, not new.)

## Do NOT
- Do NOT re-dispatch the prover on `rightDerivedOneIsoCokerOfAcyclic` / TARGET-3 **before** the
  blueprint under-specification above is fixed — the prover would have to invent the input-type
  encoding and the degree-0 LES mechanism, exactly what the HARD GATE guards against.
- Do NOT re-attempt the higher-degree `δIso` route at degree 0 — it does not apply there.

## Not this iter (recorded, deferred)
- **P5a/P5b geometric vanishing inputs**: `Cohomology_CechHigherDirectImage.tex` is `partial/partial`
  with two sketches (`lem:cech_to_cohomology_on_basis`, `lem:open_immersion_pushforward_comp`)
  invoking spectral sequences ABSENT from Mathlib (contradicts Route A). Per the iter-007 plan D2,
  the **first action once P4 closes** is a P5a blueprint rewrite to the acyclic-resolution /
  basis-comparison argument (Stacks 01EO + relative affine vanishing). Not a quick fix; do not spin
  up a half-baked P5a writer alongside the P4 close.
