# Recommendations for the next plan iteration (post iter-004)

## CRITICAL / must-fix-this-iter — false `\leanok` on the horseshoe (DAG poisoning)

`lem:injective_resolution_of_ses` carries `\leanok` on its statement (chapter L190) and proof
(chapter L217), but its `\lean{}` target `CategoryTheory.InjectiveResolution.ofShortExact` **does
not exist** (`lean_verify`: "Unknown constant"). The horseshoe is the *sole remaining P4 blocker*,
so this false-done risks the DAG/planner treating the hardest piece as built.

- **Root cause** (Lean-side): the `/-! ... -/` strategy comment in `AcyclicResolution.lean`
  (lines ~230–347) has a ``` ```-fenced "Output type (suggested)" snippet whose first line is the
  literal `def InjectiveResolution.ofShortExact {A B C : 𝒜} (ses : ShortComplex 𝒜)` (file L283).
  The `sync_leanok` matcher reads that fenced text as a real sorry-free declaration.
- **Action (next iter, do this FIRST)**: dispatch a `refactor` (or fold into the P4 prover lane,
  which owns the file) to reformat that code fence so the matcher stops matching it — replace the
  fenced `def ...` with plain prose or a `-- ` line-comment prefix, or guard it. A `% NOTE:` is
  already on the blueprint block (added this review) documenting this. Once the `.lean` comment is
  fixed, `sync_leanok` will strip both `\leanok` markers automatically next iter — do NOT hand-edit
  `\leanok`.
- **Tooling follow-up (surface to user via TO_USER, already done)**: `sync_leanok` should cross-check
  its declaration-match against `lean_verify` (Unknown-constant ⇒ not done) before stamping `\leanok`;
  a fenced signature inside a `/-! -/` comment currently produces a false positive.
- Evidence: `task_results/lean-vs-blueprint-checker-acyclic.md` (findings 1–3); confirmed by
  lean-auditor (`task_results/lean-auditor-iter004.md`, which notes the L283 fence is inert as code
  but is exactly what the matcher trips on).

## HIGH — re-issue the P4 horseshoe lane, but DECOMPOSE it first

The lane has now spent iter-004 building all *consumers* of the horseshoe; the only thing left in the
whole P4 chain that this prover could not land is the horseshoe object itself. It is a single large
ℕ-recursion that admits no `sorry`-free partial fragment beyond the per-stage mono already landed.
**Do not re-dispatch it as one monolithic `mathlib-build` target** — that is the shape that stalled.

- **Action**: dispatch `effort-breaker` on `lem:injective_resolution_of_ses` (fine granularity) BEFORE
  the next prover round, splitting the horseshoe into independently-formalizable sub-lemmas:
  (a) `horseshoe_τ (n) : I_C.X n ⟶ I_A.X (n+1)` (off-diagonal, via `Injective.factorThru` against the
  cosyzygy SES — reuse `mono_biprod_lift_factorThru_of_exact`);
  (b) `horseshoe_d (n)` differential `[[d_A,τ],[0,d_C]]` and its `d² = 0`;
  (c) per-degree exactness / "I_B resolves B";
  (d) packaging as `InjectiveResolution B` + exposing the degreewise-split SES of complexes.
  Model the recursion on `InjectiveResolution.ofCocomplex` / `exact_f_d` / `ofCocomplex_exactAt_succ`
  (`Mathlib/CategoryTheory/Abelian/Injective/Resolution.lean:270–352`).
- Everything downstream is already proven and wired: feed the resulting `(φ,ψ,w,splits)` straight to
  `rightDerivedShiftIsoOfSplitResolutionSES` (decl #4) to get TARGET 2, then the staircase for TARGET 3.

## HIGH — restore 1-to-1 coverage for the 5 new `lean_aux` decls (and reconcile TARGET-2 hint)

`archon dag-query unmatched` lists **15** uncovered `lean_aux` nodes. **5 are new this iter** (all in
`AlgebraicJacobian/Cohomology/AcyclicResolution.lean`); the other 10 are inherited push-pull/Čech
helpers (carry-forward debt, listed below). The planner writes the prose — these are flagged here per
the "when there is Lean there must be tex" doctrine.

New this iter (suggested blueprint home + Lean deps):
- `Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic` — sub-lemma of
  `lem:acyclic_dimension_shift`; deps `isoRightDerivedObj`, `IsRightAcyclic.vanish`.
- `shortExact_of_degreewise_splitting` — sub-lemma of `lem:acyclic_dimension_shift`; dep
  `HomologicalComplex.shortExact_of_degreewise_shortExact`, `ShortComplex.Splitting.shortExact`.
- `shortExact_map_mapHomologicalComplex_of_degreewise_splitting` — same; dep `ShortComplex.Splitting.map`.
- **`Functor.rightDerivedShiftIsoOfSplitResolutionSES`** (substantive) — the resolution-level form of
  `lem:acyclic_dimension_shift` part (1); deps `δIso`, `isoRightDerivedObj`, decls #1+#3. The blueprint
  `lem:acyclic_dimension_shift` currently names only the *object-level* `\lean{rightDerivedShiftIsoOfAcyclic}`
  (which does not yet exist). Have a blueprint-writer add a `\lean{...rightDerivedShiftIsoOfSplitResolutionSES}`
  secondary hint in the `lem:acyclic_dimension_shift` proof block, marked as the resolution-level precursor.
- **`mono_biprod_lift_factorThru_of_exact`** (substantive) — per-stage horseshoe mono; add a
  `\lean{...}` hint in the `lem:injective_resolution_of_ses` proof block. Deps `ShortComplex.Exact.lift`,
  `Injective.factorThru`/`comp_factorThru`.

Carry-forward unmatched (inherited, still uncovered): `coverCechNerveOver`, `coverCechNerveOverAug`,
`pushPullMap_eq_raw`, `pushPull_pentagon`, `pushPull_unit_comp`, `pushforwardComp_hom_app_id`,
`rawPushPullMap`, `rawPushPullMap_comp`, `rawPushPullMap_self`, `rawPushPullMap_self_gen` (all in
`CechHigherDirectImage.lean`).

## Closest-to-completion / ready lanes
- **P4 horseshoe** (above) is the rate-limiter and the highest-value next action — its entire consumer
  side is proven. Decompose, then dispatch.
- **P3** (`CechAcyclic.affine`, L774): still blocked by the standard-cover statement gap (iter-003 D3 —
  Lean signature takes a general `X.OpenCover`, blueprint proves the standard `U=⋃D(fᵢ)` case). The
  decided fix is a Lean-only signature narrowing; it was teed up but not executed. This converts P3 into
  a genuine parallel lane and unblocks the deferred file-split — worth executing now that P4 is mid-flight.
- **P5** (`cech_computes_higherDirectImage`, L811, protected): needs P3 + P4. Not ready.

## Do NOT retry without a structural change
- The P4 horseshoe as a **single monolithic `mathlib-build` target**: the prover correctly declined it
  this iter (no `sorry`-free partial possible). Re-dispatching the same monolith without an
  `effort-breaker` split first will reproduce the same "build everything around it, leave the core" stall.

## Reusable pattern discovered (also in Knowledge Base)
- **Dimension shift via `δIso`, not a hand-rolled LES**: for an acyclic-middle SES of complexes, the
  connecting iso `Hⁱ(X₃) ≅ Hʲ(X₁)` is `ShortComplex.ShortExact.δIso i j (h) (mid₁=0) (mid₂=0)`; compose
  with `InjectiveResolution.isoRightDerivedObj` on both ends for a 3-step `Iso.trans`. Eliminates the
  homology_exact₁/₂/₃ chase the strategy budgeted for. (`HomologySequence.lean:355`.)
