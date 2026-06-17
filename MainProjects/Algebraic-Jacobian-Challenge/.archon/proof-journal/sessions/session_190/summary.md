# Session 190 — Review of iter-190

## Session metadata

- **Session/iter**: session_190 (= iter-190).
- **Sorry count entering iter-190 prover phase**: 79 (= 78 post-iter-189 + 1
  from plan-phase `refactor lane-e-iotagm-packaging` introducing
  `iotaGm_r_1_range_subset`).
- **Sorry count exiting iter-190 prover phase**: **integration build RED**.
  Per-file build reports 80 `declaration uses 'sorry'` warnings on the
  partially-built target list (including the 2 warnings emitted *before*
  RationalCurveIso errors out — file does not produce a `.olean`).
  The naively expected post-prover count would be 79 (AVR −1; WeilDivisor
  +1; Cross01Substrate / AuslanderBuchsbaum / RationalCurveIso / QuotScheme 0
  net per task reports), but the integration step never completes.
- **Project axioms**: cannot verify (build RED on
  `AlgebraicJacobian.RiemannRoch.RationalCurveIso` ⟹
  `AlgebraicJacobian.lean` chain broken). The 10-consecutive-zero-axiom
  streak as reported in PROJECT_STATUS.md is **interrupted** until the
  iter-191 plan-phase resolves the naming clash.
- **Targets attempted (6 prover lanes)**:
  - `AlgebraicJacobian/AbelianVarietyRigidity.lean` (Lane E post-refactor)
  - `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (Lane G Stacks 00NQ)
  - `AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean` (Lane B Substrate 2)
  - `AlgebraicJacobian/Picard/QuotScheme.lean` (Lane F Step 3)
  - `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (Lane I Pin 2 corrective + Pin 3 Step 2)
  - `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (Lane I positivePart substrate)

## CRITICAL — integration build RED on parallel-prover naming clash

The paired Lane I prover dispatch in iter-190 was split across two files
(`WeilDivisor.lean` for the public `positivePart` def + Hartshorne~II.6.9
existential pin; `RationalCurveIso.lean` for the `Hom.poleDivisor` body
refactor that consumes it). Both provers ran in parallel and **both
landed an `AlgebraicGeometry.Scheme.WeilDivisor.positivePart` definition**
— one as the public `noncomputable def` in `WeilDivisor.lean:502`, one
as a `private noncomputable def` in `RationalCurveIso.lean:416`. Because
`RationalCurveIso.lean` imports `WeilDivisor.lean` (which is in the same
namespace `AlgebraicGeometry.Scheme.WeilDivisor`), Lean reports:

```
error: AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean:416:26:
  a non-private declaration `AlgebraicGeometry.Scheme.WeilDivisor.positivePart`
  has already been declared
```

`lake build AlgebraicJacobian` returns exit code 1. The iter-190 `meta.json`
records `prover.status: "done"` because each per-file prover session built
its own snapshot in isolation (each saw only the WeilDivisor.lean OR
RationalCurveIso.lean changes, not both), but the cross-file integration
that runs after all provers report `done` fails on the clash. `sync_leanok`
nevertheless ran (sha=2e130481, removed 4 markers from RationalCurveIso /
WeilDivisor chapters) — its per-file mode is partly resilient to the
downstream build break, which is why the JSON state is present.

**Root cause**: the iter-190 plan paired Lane I across two files without a
coordination contract specifying ownership of the public `positivePart`
name. The plan said "the positivePart def lands in WeilDivisor.lean; the
Pin 2 body close lands in RationalCurveIso.lean after the dependency
lands" — but "after the dependency lands" implies sequencing, while the
loop dispatched both lanes in parallel. The RationalCurveIso prover did
not see the WeilDivisor prover's public def in its snapshot, so it landed
its planned file-local fallback (anticipating that "the public version is
parallel iter-190 prover work; iter-191+ migrate"). The WeilDivisor prover
correctly landed the public version. Result: name collision at integration.

**Fix recommendation for iter-191 plan-phase**: delete lines 416-462 of
`RationalCurveIso.lean` (the file-local `WeilDivisor.positivePart` def
+ the file-local
`WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank`
pin), and rewrite the `Hom.poleDivisor` body and the
`Hom.poleDivisor_degree_eq_finrank` consumer to use the public
`Scheme.WeilDivisor.positivePart` from `WeilDivisor.lean`. The consumer
pin signature in `WeilDivisor.lean` is in *existential* form (the
WeilDivisor task chose this for soundness — see "Mismatch flag" section
of `task_results/AlgebraicJacobian_RiemannRoch_WeilDivisor.lean.md`), so
the call site needs `Classical.choose`/`Classical.choose_spec` extraction
of the witness `t : K` or a parallel rewrite of the consumer signature to
take the local-parameter witness as input. Detailed recipe in
recommendations.md.

## Per-lane results

### Lane I — `RationalCurveIso.lean` + `WeilDivisor.lean` (Pin 2 corrective Option (a))

**WeilDivisor.lean side (`task_results/.../WeilDivisor.lean.md`)**:

- `Scheme.WeilDivisor.positivePart` (L502): **NEW, axiom-clean** via
  `Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp) D`.
  - First attempt used `D ⊔ 0` lattice form (`Finsupp.semilatticeSup`);
    pivoted to `mapRange` for downstream `change`/`unfold` transparency.
- `Scheme.WeilDivisor.positivePart_zero` (L507): **NEW, axiom-clean** via
  `change Finsupp.mapRange ... = ...; exact Finsupp.mapRange_zero`.
- `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` (L543):
  **NEW typed-sorry pin**. *Statement landed in existential form*
  `∃ (t : K) (halg : algebraMap K K(C) t ≠ 0), degree (positivePart ...) = finrank`,
  NOT the equational form the blueprint label suggests.
  - Reason: the equational form is mathematically FALSE for arbitrary
    `t : K` (only true when `t` is a local parameter at a closed point
    of the abstract base); the existential form is true (witness =
    local parameter at any closed point of Spec K) and downstream-safe
    against typed-sorry exploitation.
  - **Blueprint mismatch flag** raised by the prover. The blueprint pin
    `lem:degree_positivePart_principal_eq_finrank` (in
    `RiemannRoch_WeilDivisor.tex` §6) reads as an equation. iter-191
    plan-phase should either re-write the blueprint prose to match the
    existential signature or retighten the Lean signature with an
    explicit local-parameter hypothesis.
- *Dropped*: `positivePart_apply` coordinate-wise unfold lemma —
  does not elaborate because `Scheme.WeilDivisor` is a `def`, not an
  `abbrev`, and Lean refuses function-application on the inner Finsupp
  carrier. Mathematically equivalent to `Finsupp.mapRange_apply`;
  workaround is `change ... = ...` inside consumer proofs (the project's
  pre-existing idiom in `principal_degree_zero`).
- File sorry count: 2 → 3 (+1 NEW typed-sorry pin).
- Helper budget consumed: 1 / 1.

**RationalCurveIso.lean side (`task_results/.../RationalCurveIso.lean.md`)**:

- **Pin 2 corrective Option (a)** — landed but as a FILE-LOCAL pin (the
  blocking naming clash described above). The proof body itself for
  `Hom.poleDivisor_degree_eq_finrank` (L585) is:
  ```
  unfold Scheme.Hom.poleDivisor
  exact WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank
      φ _hφ_non_const _
  ```
  This would close axiom-clean **if** the file-local pin were valid; it
  is invalid because the underlying file-local `WeilDivisor.positivePart`
  def is rejected by Lean.
- **Pin 3 Step 2 sub-step (b)** axiom-clean: `IsProper φ.left` derivation
  via the slice-category morphism `φ.w : φ.left ≫ C'.hom = C.hom` +
  `IsProper.comp_iff`:
  ```
  haveI hφ_left_isProper : IsProper φ.left := by
    haveI : IsProper (φ.left ≫ C'.hom) := hφ_w ▸ (inferInstance : IsProper C.hom)
    exact (IsProper.comp_iff (f := φ.left) (g := C'.hom)).mp inferInstance
  ```
  Companion `[QuasiCompact φ.left]` + `[QuasiSeparated φ.left]` synthesise
  from the `IsProper` instance.
- Sub-steps (a), (c), (d) of Pin 3 Step 2 remain typed sorry, gated on
  Mathlib gap chain: `IsAffineHom` of non-constant smooth-proper-curve
  morphisms; `Scheme.Hom.normalization` identification under smoothness;
  slice-category `Over (Spec (.of kbar))` lift. Recipe documented inline
  + in `analogies/ratcurveiso-pin3.md`.
- File sorry count: 2 → 2 (structural; closed Pin 2 false-as-stated pin,
  added new file-local typed-sorry pin).

### Lane G — `Albanese/AuslanderBuchsbaum.lean` (Stacks 00NQ project-side build)

- 2 NEW axiom-clean helpers landed:
  - `isDomain_of_isLocalRing_of_spanFinrank_maximalIdeal_eq_zero` (L1299):
    base case `spanFinrank 𝔪 = 0 ⟹ R is a field ⟹ R is a domain`.
  - `regularLocal_quotient_isRegularLocal_of_notMemSq` (L1323): inductive
    step prep — `R/(x)` regular local of `spanFinrank = k` for `x ∈ 𝔪 \ 𝔪²`
    *without* needing `IsSMulRegular` (relies on
    `ringKrullDim_le_ringKrullDim_quotient_add_encard` — Krull's height
    theorem — instead of
    `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`).
- `isDomain_of_regularLocal` body (L1300 entering → L1537 exiting)
  refactored from a bare `sorry` into structured strong induction on
  `spanFinrank 𝔪`. Base + inductive step `x ∉ 𝔭` branch closed axiom-clean
  via Nakayama (`Submodule.FG.eq_bot_of_le_jacobson_smul`); inductive step
  `x ∈ 𝔭` branch is the residual typed-sorry, scoped explicitly to
  `(x) ∈ minimalPrimes R`.
- Mathlib gap on the residual: Stacks `lemma-regular-graded`
  (`gr_𝔪(R) ≅ κ[X₁,...,X_d]`) is not in Mathlib at b80f227. Three
  alternative bypass attempts considered (prime avoidance / dimension
  formula / direct nilpotence) — all blocked, documented in task report.
- Auxiliary reorganization: moved `exists_notMemSq_of_spanFinrank_pos`
  from L1482 to L1296 for the forward reference.
- File sorry count: 2 → 2 (substrate dramatically narrowed; +0 helper
  count above the 3 helper budget).
- HARD BAR (≥1 axiom-clean helper): **MET** (2 helpers landed).

### Lane B — `Genus0BaseObjects/Cross01Substrate.lean` (Substrate 2)

- `gmRing_tensor_homogeneousAway_isDomain` (L129) closed axiom-clean
  (`{propext, Classical.choice, Quot.sound}` kernel-only).
  - Recipe: explicit kbar-AlgHom
    `φ : (Away f) ⊗[kbar] (GmRing kbar) →ₐ[kbar] L`
    where `L := Localization.Away (X () : MvPolynomial Unit (Away f))`
    (a domain via localization of polynomial ring at non-zero-divisors).
    `φ` constructed via `Algebra.TensorProduct.lift` with components
    `f1_kbar := Algebra.ofId` and `f2 := IsLocalization.Away.lift`.
    Left-inverse `ψ_ring : L →+* target` built via
    `IsLocalization.Away.lift` on `Algebra.TensorProduct.map (id, algebraMap)`.
    `ψ_ring ∘ φ = id` verified pointwise via `IsLocalization.ringHom_ext`
    on the localized generator chain.
  - LOC: ~270 LOC (well above the analogist's 50-80 LOC estimate; the
    extra plumbing is needed because `Away f` is not natively an
    `MvPolynomial Unit kbar`-algebra, so manual algebra-map composition
    is required for the tensor lift).
  - Key Mathlib idioms: `HomogeneousLocalization.val_injective`,
    `MvPolynomial.algebraTensorAlgEquiv`, `IsLocalization.Away.lift_eq`,
    `IsLocalization.isDomain_of_le_nonZeroDivisors`,
    `IsLocalization.ringHom_ext`,
    `powers_le_nonZeroDivisors_of_noZeroDivisors`.
- 12 stylistic `linter.style.show` warnings — build is GREEN
  (single-file scope); recommend `set_option linter.style.show false`
  at file scope or `change` replacements next iter (low priority).
- File sorry count: 0 → 0 (Substrate 2 axiom-clean closure).
- HARD BAR: **MET**.

### Lane A (Lane E post-refactor) — `AbelianVarietyRigidity.lean`

- `iotaGm_r_1_range_subset` (L104) — **CLOSED axiom-clean** on Attempt 2
  (Attempt 1 transplant of the iter-184 closed body FAILED because
  `↥(ProjectiveLineBar kbar).left` vs `↥(Proj 𝒜)` defeq is bridgeable
  by `change` but NOT by `rw`).
- Attempt 2 recipe: reshape the membership step-by-step via `change`
  before invoking `Proj.opensRange_awayι`:
  ```
  rintro _ ⟨x, rfl⟩
  change (ProjectiveLineBar.onePt kbar).left.base x ∈ (Proj.awayι _ _ _ _).opensRange.1
  rw [Proj.opensRange_awayι]
  change x ∈ (ProjectiveLineBar.onePt kbar).left ⁻¹ᵁ Proj.basicOpen _ _
  change x ∈ Proj.fromOfGlobalSections _ _ _ ⁻¹ᵁ _
  rw [Proj.fromOfGlobalSections_preimage_basicOpen ...]
  refine (Scheme.basicOpen_of_isUnit _ ?_).symm ▸ Opens.mem_top x
  -- IsUnit ((ΓSpecIso _).inv.hom (eval (1,1) (X 1))) collapses to IsUnit 1 via simp
  ```
- Cascade upgrade: `iotaGm_r_1` def + `iotaGm_r_1_fac` lemma now
  `lean_verify`-clean (`{propext, Classical.choice, Quot.sound}`).
- `iotaGm_chart1_composition_isOpenImmersion` (L261) — NOT CLOSED.
  Scope assessment showed ~150 LOC realistic budget after sub-task (b)
  closure; deferred to iter-191+.
- `genusZero_curve_iso_P1` (L766) — UNCHANGED (Lane H off-limits iter-190).
- File sorry count: 3 → 2 (−1 axiom-clean closure).
- HARD BAR: **MET** (sub-task (b) closed; iter-190 plan-phase refactor's
  +1 absorbed by prover phase's −1; file net 0 across the full iter).

### Lane F — `Picard/QuotScheme.lean` (Step 3 axiom-clean)

- `pullback_of_openImmersion_iso_restrict` (L650): **PARTIAL**.
  Substantial qualitative progress: the AddEquiv is fully closed
  (toFun/invFun/left_inv/right_inv/map_add'), the smul through
  `Hom.app` is migrated via `Scheme.Modules.Hom.app_smul`. Residual
  sorry is the ring-level identity
  `Y.presheaf.map (eqToHom hImg.symm).op ((hU.fromSpec.appIso ⊤).inv ((ΓSpecIso _).inv.hom r)) = r`
  combined with `Scheme.Modules.map_smul` to pull algebra-map images
  through the presheaf restriction.
- Key bridges identified but not chained:
  - `Scheme.Hom.appLE_appIso_inv` (`OpenImmersion.lean:229`)
  - `IsAffineOpen.fromSpec_app_self` (`AffineScheme.lean:561`)
  - `ModuleCat.restrictScalars.smul_def` (`ChangeOfRings.lean`)
- Estimated 30-60 LOC iter-191 closure. **No Mathlib upstream PR needed**
  — all ingredients are in `b80f227`, just need careful chaining.
- File sorry count: 13 → 13 (residual sorry moved deeper but file count
  unchanged).
- HARD BAR (axiom-clean closure): **NOT MET**.

## Plan-phase artefacts (recap)

For full context, iter-190 plan-phase ran 3 critic dispatches (all
`[HIGHLY RECOMMENDED]`):

| Critic | Slug | Verdict (summary) |
|---|---|---|
| `blueprint-reviewer` | `iter190` | 3 MUST-FIX (Pin 2 corrective + 2 missing QuotScheme pins + broken `\cref{chap:RR_H1Vanishing}`); 2 unstarted-phase proposals (RR_H1Vanishing landed; Pic0AV deferred to iter-191+). |
| `progress-critic` | `route190` | 4 must-fix routes (A.3.i CHURNING, F CHURNING, H CHURNING, E STUCK + OVER_BUDGET, I UNCLEAR-must-act). |
| `strategy-critic` | `iter190` | CHALLENGE — Lane M↓ Option (c) REJECT (`sorryAx` not in kernel-only allow-list), A.3.0/A.4.d.0 substrates enumerated, STRATEGY.md format DRIFTED. |

Plan-phase also ran `blueprint-writer rr-h1vanishing-skeleton` (560 lines)
and `refactor lane-e-iotagm-packaging` (transplant friction added +1
sorry to AVR).

## Blueprint markers updated (manual)

None this iter. The integration build being RED makes any new semantic
marker addition premature — `\mathlibok` / `% NOTE:` / `\notready`
hygiene is unchanged from iter-189 (`sync_leanok` deterministically
managed the 4 `\leanok` removals in the touched chapters).

The blueprint mismatch on
`lem:degree_positivePart_principal_eq_finrank` (equational prose vs
existential Lean signature) is logged in recommendations.md as a
plan-phase action for iter-191; this review does not edit
`RiemannRoch_WeilDivisor.tex` because the resolution (re-tighten Lean
signature vs re-phrase blueprint) is a strategy-level call belonging to
the next plan agent.

## Subagent skips

- **lean-auditor**: skipped this iter. Rationale: the integration build
  is RED on a localized parallel-prover naming clash; a whole-project
  Lean audit would mostly re-discover the build break + the
  pre-existing structural sorries. The next plan agent must prioritise
  the clash resolution before any audit signal becomes actionable.
- **lean-vs-blueprint-checker**: skipped per-file dispatch for all 6
  prover-touched files this iter. Rationale: same as above —
  `RationalCurveIso.lean` does not produce a `.olean` so any
  blueprint↔lean alignment query against it would fail at the LSP
  level; per-file checks on the other 5 files would not surface
  iter-191's highest-priority finding (the cross-file integration
  bug is invisible to single-file audits). Re-enable per-file checks
  iter-191 review *after* the clash is resolved.

## Blueprint doctor (iter-190)

The deterministic `blueprint-doctor` report at
`.archon/logs/iter-190/blueprint-doctor.md` flags ONE finding:

> chapter `RiemannRoch_H1Vanishing.tex` covers
> `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`, which does not exist

This is **expected** — the chapter was landed iter-190 plan-phase via
`blueprint-writer rr-h1vanishing-skeleton` ahead of the Lean file
scaffold (iter-191+ work per plan §HALTED). Surfaced in recommendations
for iter-191 plan-phase: either drop the `% archon:covers` line until
the Lean file exists, or create the Lean skeleton first thing iter-191.

## `\leanok` sync attribution

`.archon/sync_leanok-state.json` records `iter=190, sha=2e130481,
timestamp=2026-05-26T09:03:52Z, added=0, removed=4, chapters_touched=
[RiemannRoch_RationalCurveIso.tex, RiemannRoch_WeilDivisor.tex]`. The
4 removals are consistent with: (a) per-file `lake env lean` on
`RationalCurveIso.lean` failing (so any `\leanok` proof-block markers
on its declarations are stripped), and/or (b) the new typed-sorry pin
added to `WeilDivisor.lean` reducing the marker count there. iter=190
matches this iteration, so the markers are the script's deterministic
verdict — no laundering audit needed.

## Key findings / patterns discovered

1. **Paired prover dispatch across two files in one iter is unsafe when
   the contract is "land a public def in file A and consume it in file
   B"**. The loop dispatches both files in parallel, each with its own
   snapshot, so file B's prover does NOT see file A's edit. The plan
   either has to land A iter-(N), consume in B iter-(N+1), or use a
   distinct private name in B with explicit migration scheduled. The
   parallel-paired pattern as planned in iter-190 is the failure mode.
2. **Existential vs equational typed-sorry pins**: when a downstream
   equational statement is mathematically false-as-stated for free
   parameters, prefer an existential signature in the typed-sorry pin
   (Lane I WeilDivisor route). This is downstream-safe against
   typed-sorry exploitation but introduces a blueprint↔lean mismatch
   the reviewer/writer must reconcile.
3. **`change`-based defeq reshape beats `rw`-based pattern match for
   `OverClass.asOver` carrier identifications**. Lane E iter-190's
   Attempt 2 confirmed iter-188's KB entry: `rw` does not unfold
   `Scheme.asOver` / `OverClass.asOver` projections; `change` does.
4. **Krull's height theorem
   `ringKrullDim_le_ringKrullDim_quotient_add_encard` sidesteps
   `IsSMulRegular` for the regular-quotient half** (Lane G2 prep).
   New axiom-clean route for "regular local of dim k+1 / (x ∉ 𝔪²) is
   regular local of dim k".

See PROJECT_STATUS.md Knowledge Base for new entries logged from this
iter.

## Recommendations for next session

See `recommendations.md`. Top priority: resolve the
`positivePart` clash before any other iter-191 prover work — without
this, every downstream prover lane runs against a broken integration.
