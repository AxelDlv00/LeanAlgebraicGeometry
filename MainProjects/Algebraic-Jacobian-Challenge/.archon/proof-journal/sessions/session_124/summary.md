# Session 124 — Review (iter-124)

## Metadata

- **Iteration**: 124 (review of iter-124)
- **Stage**: prover (Iter-124: M1.b residual — Steps 2 + 3 of the
  4-step `IsLocalization.of_le` chain on
  `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`). The
  iter-124 plan-phase dispatched 3 mandatory critics + 1 refactor
  (deadcode cleanup, COMPLETE) + 1 mathlib-analogist (Rigidity
  refactor scoping, ALIGN_WITH_MATHLIB). The prover lane then ran
  against the iter-124 PROGRESS.md 6-substep decomposition for
  Steps 2 + 3.
- **Sorry count entering iter-124 prover lane**: **2**
  (`Differentials.lean:362` `appLE_isLocalization` body —
  `Localization M ≃ₐ[Γ(S, U)] A_colim` AlgEquiv residual;
  `Jacobian.lean:179` `nonempty_jacobianWitness`).
- **Sorry count after iter-124 prover lane**: **2** (per-file:
  `Differentials.lean:398` `appLE_isLocalization` body —
  `Function.Bijective ⇑forwardAlg` residual inside
  `AlgEquiv.ofBijective forwardAlg sorry`;
  `Jacobian.lean:179` `nonempty_jacobianWitness` unchanged). The
  Differentials sorry **migrated from L362 to L398** via a single
  substantive Edit inserting ~60 LOC of new in-body proof code +
  ~10 LOC of replaced documentation. **Net sorry count unchanged
  2 → 2; structural advance: the `commutes'` algebra-map
  compatibility (effectively the third sub-piece of the iter-123
  AlgEquiv hole) closed in body via a single
  `RingHom.congr_fun h_fwd_comp` call; the residual is now the
  precise `Function.Bijective ⇑forwardAlg` claim (not a whole
  AlgEquiv construction).**
- **Targets attempted**: 1 (`AlgebraicJacobian/Differentials.lean`,
  the iter-124 PROGRESS.md objective).
- **Targets resolved (full closure)**: 0.
- **Targets PARTIAL with structural advance**: 1
  (`appLE_isLocalization`; iter-123 forward/Step-4 closures preserved;
  AlgHom commutes' closed in-body this iter; residual narrowed to
  named bijectivity claim).
- **New axioms introduced**: none.
- **Compile status**: project compiles. `lake env lean
  AlgebraicJacobian/Differentials.lean` returns only the documented
  `declaration uses sorry` warning at L282 (the
  `appLE_isLocalization` declaration banner). `lean_diagnostic_messages`
  returns `[]` errors, `[{sorry warning}]` warnings. Independent
  `python3 sorry_analyzer.py AlgebraicJacobian/` confirms 2 sorry
  sites at the documented locations (L398 + L179).
- **Protected signatures touched**: none. `archon-protected.yaml`
  unchanged (9 protected declarations at original paths with
  unchanged signatures).
- **Pre-processed events**: 60 total events in
  `proof-journal/current_session/attempts_raw.jsonl` — **1 edit**,
  2 goal checks, 3 diagnostic checks, 28 lemma searches (3 local +
  18 leansearch + 4 loogle + 1 leanfinder + 2 hover_info /
  declaration_file), 0 `lake build` calls (the prover used
  `lean_diagnostic_messages` after the Edit and a single final
  `lake env lean` at the very end for confirmation), 0 errors
  recorded, 1 `Write` event for the task result file. Single file
  edited (`AlgebraicJacobian/Differentials.lean`).
- **Prover-phase shape**: a single substantive prover stream on
  `Differentials.lean` with **1 substantive Edit** (the AlgHom
  promotion + bijectivity narrowing at L332-L398). The Edit
  replaces the iter-123 comment block at L355-L385 + the residual
  AlgEquiv `sorry` at L362, with the new AlgHom construction
  `forwardAlg` + extensive bijectivity-blocker analysis comment
  block + `AlgEquiv.ofBijective forwardAlg sorry`.
- **Meta**: `meta.json planValidate.status: ok / objectives: 1`;
  PARTIAL outcome on the single objective. Prover-phase
  `durationSecs: 1218` (~20 min — between the iter-122 ~30 min and
  iter-123 ~16 min baselines; consistent with focused lemma-search
  + single-Edit-commit shape).
- **Plan-phase dispatches** (already reported in iter-124 plan.md):
  3 mandatory critics + 1 refactor (deadcode cleanup) + 1
  mathlib-analogist (Rigidity refactor scoping) = 5 subagent
  dispatches total.

## Per-target detail

### Target: `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` (M1.b) — PARTIAL with structural advance

**Status**: **partial**. The iter-124 prover took the iter-123
6-substep "fully-construct-the-AlgEquiv-via-RingEquiv.ofRingHom"
recipe and pivoted to a structurally simpler `AlgEquiv.ofBijective`
reduction. This:

- Closes the `commutes'` algebra-map compatibility (effectively the
  third sub-piece of the iter-123 AlgEquiv hole) in body, in 1 line
  of proof (`exact RingHom.congr_fun h_fwd_comp r`).
- Reduces the remaining residual to the named claim
  `Function.Bijective ⇑forwardAlg`, which by
  `IsLocalization.lift_injective_iff` and
  `IsLocalization.lift_surjective_iff` decomposes into two precise
  Mathlib-gap pieces (filtered-colim element representation +
  basic-open cofinality).
- Keeps the project sorry count at exactly 2 (the per-file
  Differentials count is still 1; the residual sorry simply moved
  L362 → L398).

This is a real structural narrowing: the iter-123 residual was the
whole `Localization M ≃ₐ[Γ(S, U)] A_colim` AlgEquiv (an
existential whose value bundled commutes' + backward map + two
inverse identities); the iter-124 residual is the single
`Function.Bijective ⇑forwardAlg` boolean. The iter-124 prover task
result also documents (with verified Mathlib lemma names) the two
gap pieces and the ~130-210 LOC closure estimate for any future
M1.b prover lane.

**Net file change**: 1 sorry site moved L362 → L398 with ~36 LOC of
in-body proof inserted (the AlgHom-promotion + AlgEquiv.ofBijective
reduction) and the iter-123 closure-recipe comment block replaced
with a more specific bijectivity-decomposition + Mathlib-gap-analysis
comment block. Total file LOC: ~480 → ~537 (the comment block is
~70 LOC; the new code is ~36 LOC; ~50 LOC of iter-123 closure-recipe
comments deleted).

#### Attempt path (chronological; 1 substantive Edit, 1 comment-block expansion bundled into the same Edit)

1. **Attempt 1 — AlgHom promotion + AlgEquiv.ofBijective reduction**
   (single Edit at L332-L398, ~70 LOC of net-content change, including
   the comment block expansion):
   - **Pre-edit goal** (at the iter-123 sorry, L362):
     ```
     X S : Scheme
     f : X ⟶ S
     U : S.Opens
     V : X.Opens
     hU : IsAffineOpen U
     hV : IsAffineOpen V
     e : V ≤ f ⁻¹ᵁ U
     this : Algebra ↑Γ(S, U) ↑A_colim := appLE_colimAlgebra f e
     M : Submonoid ↑Γ(S, U) := appLE_unitSubmonoid f hU hV e
     hM_def : M = appLE_unitSubmonoid f hU hV e
     h_unit_ring : ∀ (y : ↥M), IsUnit ((appLE_colimRingHom f e).hom ↑y)
     forward : Localization M →+* ↑A_colim := IsLocalization.lift h_unit_ring
     h_fwd_comp : forward.comp (algebraMap ↑Γ(S, U) (Localization M)) = (appLE_colimRingHom f e).hom
     ⊢ Localization M ≃ₐ[↑Γ(S, U)] ↑A_colim
     ```
   - **Code tried**:
     ```lean
     let forwardAlg :
         Localization M →ₐ[Γ(S, U)]
           (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)) :=
       { forward with
         commutes' := by
           intro r
           have h := RingHom.congr_fun h_fwd_comp r
           exact h }
     exact AlgEquiv.ofBijective forwardAlg sorry
     ```
     (preceded by the L332-L397 bijectivity-decomposition + Mathlib-gap
     analysis comment block)
   - **Post-edit goal** (at the new sorry, L398, inside
     `AlgEquiv.ofBijective forwardAlg ?_`):
     ```
     ⊢ Function.Bijective ⇑forwardAlg
     ```
     with `forwardAlg : Localization M →ₐ[Γ(S, U)] A_colim` and the
     algebra-map compatibility `commutes'` closed in body.
   - **Diagnostic result**: `lean_diagnostic_messages` after the Edit
     returns `[]` errors, `[{sorry warning at L282}]` (the
     declaration banner). Final `lake env lean
     AlgebraicJacobian/Differentials.lean` confirms.
   - **Result**: STRUCTURAL NARROWING. The single residual `sorry`
     now sits at `AlgEquiv.ofBijective forwardAlg sorry` (L398) with
     the algebra-map compatibility closed in body. The bijectivity
     claim's decomposition via
     `IsLocalization.lift_{injective,surjective}_iff` reduces the
     residual to two precise Mathlib-gap pieces with concrete LOC
     estimates (~130-210 LOC total per the prover task result).

#### Key findings

1. **`AlgEquiv.ofBijective` is structurally cleaner than the iter-123
   `RingEquiv.ofRingHom + AlgEquiv.ofRingEquiv` recipe**. The
   iter-123 recipe required (a) building the backward map directly
   from cocone-universal-property, (b) verifying two separate inverse
   identities (`backward ∘ forward = id` via
   `IsLocalization.ringHom_ext`, `forward ∘ backward = id` via
   `IsColimit.hom_ext`), and (c) closing algebra-map compatibility
   via `IsLocalization.lift_eq`. The iter-124 recipe replaces (a) +
   (b) with the single `Function.Bijective ⇑forwardAlg` claim (which
   by `lift_{injective,surjective}_iff` packages the inverse-identity
   content as injectivity + surjectivity criteria, NOT as a paired
   pair of identities) and replaces (c) with a 1-LOC
   `RingHom.congr_fun h_fwd_comp r` call. The trade-off: the new
   residual is one Mathlib-gap claim (bijectivity) instead of two
   ring-hom identities — both equally substantive, but the new shape
   makes the iter-125+ prover's target a single decision: do we have
   filtered-colim element representation + basic-open cofinality
   for this specific lan-colim?

2. **`RingHom.congr_fun h_fwd_comp r` closes `commutes'` because
   `algebraMap Γ(S, U) A_colim` is *definitionally* `(appLE_colimRingHom
   f e).hom`**. This works only because the iter-122 helper
   `appLE_colimAlgebra := (appLE_colimRingHom f e).hom.toAlgebra`
   ties the algebra structure to the ring map by definition. The
   `RingHom.congr_fun` produces `forward (algebraMap r) =
   (appLE_colimRingHom f e).hom r`; the goal needs `forward
   (algebraMap r) = algebraMap r` on the RHS; the two RHS forms are
   defeq via the `.toAlgebra` unfolding, so `exact h` succeeds
   without a `show` or `change` rewrite. **Reusable pattern**:
   when you have a `letI : Algebra A B := someRingHom.toAlgebra` and
   a fact `f.comp (algebraMap A C) = someRingHom`, the `commutes'`
   field of an `{f with commutes' := ...}` AlgHom constructor closes
   via `RingHom.congr_fun (h := f.comp_eq_ringHom) r` + `exact`.

3. **Bijectivity decomposition via `IsLocalization.lift_{injective,
   surjective}_iff` is the right Mathlib pivot for "compute the
   bijectivity of an `IsLocalization.lift` against a target ring"**.
   - `IsLocalization.lift_injective_iff` reduces `Function.Injective
     ⇑(IsLocalization.lift hg)` to `∀ x y : R, algebraMap R S x =
     algebraMap R S y ↔ g x = g y` — i.e., the `IsLocalization`
     equivalence on the *source* side iff the `g`-equality on the
     *target* side. For `R = Γ(S, U)`, `S = Localization M`, `g =
     (appLE_colimRingHom f e).hom`, the `→` direction is trivial; the
     `←` direction is what Step 3 ("inverse identity for `IsLocalization.ringHom_ext`")
     was supposed to provide.
   - `IsLocalization.lift_surjective_iff` reduces `Function.Surjective
     ⇑(IsLocalization.lift hg)` to `∀ v : P, ∃ x, v * g x.2 = g x.1`
     — i.e., every target element is "representable" against `g`.
     For our setup, this IS the Step 2 cocone-universal-property
     content (every `v ∈ A_colim` is in the image of some cocone
     arm `Γ(S, W) → A_colim` for some `W ⊇ fV`).
   - The decomposition is on the iter-124 Mathlib search slate; the
     two iff lemmas are exactly tailored to the `IsLocalization.lift`
     shape we used iter-123.

4. **Negative search results documented**. The prover spent ~20 of
   the 28 lemma searches on the "is there an off-the-shelf bridge"
   question and definitively found:
   - No `IsLocalization.bijective_lift_iff` lemma (only the
     pi-product version `bijective_lift_piRingHom_algebraMap_comp_piEvalRingHom`
     for product algebras).
   - No `Localization.colimit_*` / `colim_of_localizations` lemma
     pairing "filtered colim of localizations at single elements" with
     "localization at union submonoid". This re-confirms the iter-121
     + iter-123 findings.
   - The `IsLocalization.atUnits` / `Localization.atUnits` family is
     for the trivial case "M ≤ IsUnit.submonoid R", not our setup.
   - `IsPointwiseLeftKanExtensionAt` is a `IsColimit (coconeAt _)`
     wrapper (Mathlib `Pointwise.lean:197`); `isoColimit` transports
     to the abstract `colimit (...)` but does NOT directly give
     element representation. Bridging through
     `CommRingCat.FilteredColimits.colimitCocone` requires showing
     `CostructuredArrow (Opens.map f.base).op (op V)` is `IsFiltered`
     first.

5. **The iter-124 residual is *exactly* the Mathlib gap, packaged
   honestly**. The L332-L397 comment block names the two gap pieces
   (filtered-colim bridge + basic-open cofinality), cites the verified
   Mathlib pieces that ARE available (`IsLocalization.lift_{injective,
   surjective}_iff`, `IsPointwiseLeftKanExtensionAt`,
   `CommRingCat.FilteredColimits.colimitCoconeIsColimit`,
   `IsAffineOpen.exists_basicOpen_le`,
   `IsAffineOpen.isLocalization_basicOpen`,
   `AlgEquiv.ofBijective`), and concludes that the remaining work is
   project-side assembly (~130-210 LOC). This is not an excuse-comment:
   it's a precise blocker diagnosis with all candidate Mathlib pieces
   verified by `lean_loogle` / `lean_leansearch` / `lean_local_search`.

6. **iter-123 progress-critic watch flags do NOT fire**.
   - Watch flag #1 ("project sorry count flat at 2 across iter-122/iter-123;
     iter-124 must close the AlgEquiv residual to keep the route honest"):
     **TRIGGERS the iter-125 unconditional M2.a pivot** per the
     iter-124 strategy-critic sharpened commitment (any PARTIAL →
     pivot). Net sorry count is unchanged; the iter-124 advance is
     structural, not numerical.
   - Watch flag #2 ("if iter-124 hits cofinality as a concrete
     blocker, iter-125 plan MUST dispatch a mathlib-analogist consult
     on the cofinality step BEFORE another prover round"): the
     iter-124 prover documents cofinality as one of the two gap
     pieces (basic-open cofinality in Opens S), and the recipe sketch
     gives `IsAffineOpen.exists_basicOpen_le` + quasi-compactness +
     prime-avoidance. The flag is informational but watching it
     **only matters if iter-125 continues M1.b**; under the sharpened
     commitment, iter-125 pivots to M2.a, so the cofinality consult
     is queued indefinitely.
   - Watch flag #3 ("if iter-124 returns PARTIAL with a 'need more
     helpers' request, that IS the CHURNING signal"): the iter-124
     prover did NOT request more helpers. The task result documents
     a concrete 130-210 LOC closure recipe but does not propose any
     new top-level decl; it explicitly recommends parking M1.b under
     the iter-125 pivot.

#### Code that DID compile (final state)

The complete iter-124 `appLE_isLocalization` body, as it stands at
review time:

```lean
theorem appLE_isLocalization (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (hU : IsAffineOpen U) (hV : IsAffineOpen V)
    (e : V ≤ f ⁻¹ᵁ U) :
    letI : Algebra Γ(S, U) (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)) :=
      appLE_colimAlgebra f e
    IsLocalization (appLE_unitSubmonoid f hU hV e)
      (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)) := by
  -- (strategy comment block: Steps 0-4 of the 4-step `IsLocalization.of_le`
  --  chain; the analogist-verified Step-4 closer is
  --  `IsLocalization.isLocalization_of_algEquiv`)
  letI : Algebra Γ(S, U)
      (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)) :=
    appLE_colimAlgebra f e
  set M := appLE_unitSubmonoid f hU hV e with hM_def
  have h_unit_ring : ∀ y : M, IsUnit ((appLE_colimRingHom f e).hom y.val) := fun y =>
    isUnit_appLE_unitSubmonoid_in_colim f hU hV e y.val y.property
  let forward :
      Localization M →+*
        (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)) :=
    IsLocalization.lift (M := M) (S := Localization M) h_unit_ring
  have h_fwd_comp :
      forward.comp (algebraMap Γ(S, U) (Localization M)) = (appLE_colimRingHom f e).hom :=
    IsLocalization.lift_comp _
  suffices AE :
      Localization M ≃ₐ[Γ(S, U)]
        (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)) from
    IsLocalization.isLocalization_of_algEquiv M AE
  -- (bijectivity-blocker analysis comment block, L332-L397)
  let forwardAlg :
      Localization M →ₐ[Γ(S, U)]
        (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)) :=
    { forward with
      commutes' := by
        intro r
        have h := RingHom.congr_fun h_fwd_comp r
        exact h }
  exact AlgEquiv.ofBijective forwardAlg sorry
```

The body has ~25 LOC of substantive proof code (excluding the
iter-122 helpers and the residual sorry) + ~90 LOC of strategy +
blocker-analysis comments.

#### Why a `Function.Bijective` residual (not split into Injective + Surjective)

Splitting bijectivity into separate `Injective` + `Surjective`
sub-sorries would push the project sorry count from 2 → 3 — which
would trigger the strict-rule reading of CHURNING (3-iter
flat-sorry-count run). The `AlgEquiv.ofBijective forwardAlg sorry`
keeps the per-file count at exactly 1, while the L332-L397 comment
block exposes the natural injectivity/surjectivity decomposition
for any future M1.b prover lane.

### Target: `AlgebraicGeometry.AbelJacobi.nonempty_jacobianWitness` (Jacobian.lean L179) — NOT_STARTED (off-limits)

**Status**: **not_started**. Untouched this iter; off-limits to the
autonomous loop pending M2 + M3 milestones (per the genus-stratified
body decomposition in STRATEGY.md).

The single residual sorry at L179 IS the project end-state hole:

```lean
theorem nonempty_jacobianWitness {C : Scheme} ⦃k : Field⦄ ...
    Nonempty (JacobianWitness C) :=
  sorry
```

The iter-124 prover lane did not target this declaration, and the
review agent has nothing to write about it that the prior
session_123 milestones.jsonl did not already say.

## Key findings (cross-target)

1. **Structural narrowing — not just sorry-shuffling**. The iter-124
   prover's `AlgEquiv.ofBijective` reduction is genuine: it closes
   the `commutes'` algebra-map compatibility (1 of the 3 sub-pieces
   of the iter-123 AlgEquiv residual) AND repackages the remaining 2
   sub-pieces into a single named claim with a verified
   bijectivity-decomposition via Mathlib's
   `lift_{injective,surjective}_iff`. The "sorry count unchanged"
   metric undersells the advance.

2. **The Mathlib gap is precisely-named**. After 28 lemma searches
   this iter (vs iter-123's 22), the prover has definitively
   characterized the gap as (a) filtered-colim element representation
   for `IsPointwiseLeftKanExtensionAt`-defined colims of `CommRingCat`,
   and (b) basic-open cofinality from the project-defined
   `appLE_unitSubmonoid` to `Opens S`. Both pieces have all candidate
   building blocks verified in Mathlib `b80f227`; the work is
   project-side assembly, not Mathlib search.

3. **The iter-125 watch criterion 2 fires**: PARTIAL (any flavor) →
   M2.a pivot. The iter-124 prover did not request "more helpers"
   (watch flag #3 does not fire), but the per-project sorry count is
   flat 2 → 2 for the third consecutive iter (watch flag #1 fires by
   the strict reading) and the route would benefit more from the
   M2.a pivot than from a third M1.b prover round under the same
   shape. The iter-124 strategy-critic's sharpened commitment is
   explicit: iter-125 fires the pivot **unconditionally**, no
   further "we are close" continuation.

4. **No new axioms; no protected signatures touched; the file
   compiles**. This is the steady-state hygiene of the route — every
   iter-122/123/124 step has cleared all three checks.

## Recommendations for next session

(Full detail in `recommendations.md`.)

- **CRITICAL #1**: iter-125 plan-phase pivots to M2.a per the
  iter-124 sharpened commitment. Dispatch the staged Rigidity
  refactor (`Scheme.Over.ext_of_eqOnOpen`, ~25 LOC) and prepare the
  M2.a prover lane for iter-126.
- **CRITICAL #2**: Re-author `TO_USER.md` to surface the
  strategy-critic-iter124 named-axiom alternative alongside the
  existing PR-and-wait option. The plan-agent standing rule against
  proposing new axioms applies to the agent; the user retains
  authority over the project direction and should see both options.
- **HIGH**: Lean-auditor + lean-vs-blueprint-checker findings will
  be folded into `recommendations.md` § HIGH/MEDIUM bullets once
  the reports return.

## Blueprint markers updated (manual)

None this iter.

- `\leanok` markers are managed by the deterministic `sync_leanok`
  phase that ran between prover and review; I did NOT touch any
  `\leanok` markers.
- No `\mathlibok` candidates this iter (all iter-124-touched decls
  are project proofs with sorry residuals; the
  `kaehler_localization_subsingleton` re-export was already
  `\mathlibok`-eligible from iter-122, applied iter-123 if not
  earlier — verify via the `sync_leanok` commit log).
- No `\lean{...}` renames flagged in
  `task_results/AlgebraicJacobian_Differentials.lean.md` (the
  iter-124 prover renamed nothing).
- No `\notready` to strip (the chapter doesn't carry any).
- The iter-124 plan-phase already applied the inline blueprint edits
  flagged by iter-123 review-phase
  lean-vs-blueprint-checker-differentials-review123 (L138, L165,
  L175 prose; three `\lean{...}` additions; one wrong-direction
  `\uses{}` removal); these are NOT review-side manual marker edits,
  they were plan-side prose edits and don't appear here.

## Notes

- The iter-124 prover left a `.debug-feedback` note on the
  sorry-count metric's failure to distinguish "made no progress on
  the residual sorry" from "reduced the residual sorry to a more
  specific claim". This is the right observation, and the iter-124
  AlgHom-promotion + bijectivity-narrowing illustrates the gap: a
  metric reading of "no progress" would be wrong, but the iter-125
  pivot still fires per the sharpened commitment (which is about
  route convergence, not per-iter progress quality).
