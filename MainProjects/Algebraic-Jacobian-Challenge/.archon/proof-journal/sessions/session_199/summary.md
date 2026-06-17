# Session 199 (iter-199) — Review

## Session metadata

- **Session number / iter**: 199
- **Sorry count before / after**: 78 → 78 (no net change; substrate-only iter)
- **Axiom count**: 0 → 0 (**19th consecutive zero-axiom build streak**)
- **Build status**: `lake build AlgebraicJacobian` GREEN (per
  `logs/iter-199/meta.json` `prover.status: done`).
- **planValidate objectives**: 4 (Lane WD, Lane AB, Lane COE, Lane FGA).
  All 4 prover lanes returned `done` clean; no API 529 errors.
- **Lanes HELD**: RPF (Mathlib upstream `Scheme.Modules.tensorObj`
  gap), T32 (COE derivative; gated on Stage 6.B), RCI (USER Route C
  PAUSE).
- **User directive context**: iter-198 / iter-199 standing directives
  (Route C PAUSE permanent; Route A bottom-up; reference-driven
  proofs) frame the active lane scope.

## Targets attempted (4 lanes)

### Lane WD-A4a — `WeilDivisor.lean`

**HARD BAR**: build helper `rationalMap_order_finite_support_of_isNoetherian`
under `[IsNoetherian X]` axiom-clean (Stacks 02RV +
`Ideal.finite_minimalPrimes_of_isNoetherianRing`).

- **Outcome**: HARD BAR NOT MET. Helper **NOT ADDED**.
- **Substrate landed (PUSH-BEYOND, 2 axiom-clean helpers)**:
  - `Scheme.RationalMap.order_neg` (L290): sign-flip identity via
    `(-f)^2 = f^2` + `WithZero.log_pow` + `smul_right_injective`.
    Axioms `{propext, Classical.choice, Quot.sound}`.
  - `Scheme.RationalMap.order_pow_of_ne_zero` (L308): `n`-induction
    on `pow_succ` + iter-198 `order_mul_of_ne_zero` + `pow_ne_zero`.
    Axioms `{propext, Classical.choice, Quot.sound}`.
- **HARD BAR blocker**: the planner's directive cited a recipe that
  requires *three* Mathlib-pending infrastructure pieces NOT in the
  pinned revision `b80f227`:
  1. Open-immersion-induced bijection from height-1 primes of the
     affine chart to prime divisors of `X` with point in the chart's
     image (`Order.coheight = 1` ↔ ideal height 1 transport across
     `IsOpenImmersion.iff_isIso_stalkMap`).
  2. Compatibility of `Ring.ordFrac` across open-immersion stalk
     isomorphisms (`MonoidWithZeroHom`-structure transport via
     `Scheme.Hom.stalkMap`).
  3. Topological-coheight-to-ring-height bridge (Stacks 02IZ / 005X)
     — same project-wide gap already exposed in Lane I closure
     (`isRegularInCodimOneProjectiveLineBar`).
- **Approaches considered (all rejected for soundness)**:
  1. Affine cover + finite subcover + per-chart Krull min-primes —
     blocked by per-chart bound infrastructure gaps (a) (b) above.
  2. Hartshorne split via single affine open `U` with
     `NoetherianSpace.finite_irreducibleComponents` on `X \ U` —
     blocked by same coheight ↔ height bridge.
  3. Black-box reduce to existing `rationalMap_order_finite_support`
     (L307) — that has weaker hypothesis but its body has `sorry`,
     so reusing would violate axiom-cleanliness.
  4. Weaker statement on a different carrier — planner's signature
     is frozen.
- **Sorry count**: 3 → 3 (file-level, unchanged).

### Lane AB-gap1 — `AuslanderBuchsbaum.lean`

**HARD BAR**: build per-syzygy substrate for gap (1) of
`auslander_buchsbaum_formula_succ_pd` — Stacks
`lemma-add-trivial-complex` first step
(minimal-surjection with kernel ≤ 𝔪·⊤).

- **Outcome**: HARD BAR MET. 1 new axiom-clean substrate helper landed.
- **`RingTheory.Module.exists_minimalSurjection_finite_localRing`**
  (L1198–L1296, ~99 LOC body): for finite `R`-module `M` over local
  ring `(R, 𝔪)`, exists `n` and surjection `f : (Fin n → R) →ₗ[R] M`
  with `n = dim_κ(κ ⊗_R M)` AND `ker f ≤ 𝔪 • ⊤`. Recipe: pick
  κ-basis via `Module.finBasis`; surjectivity via
  `TensorProduct.mk_surjective` + `Ideal.Quotient.mk_surjective` lifts
  to `m_i ∈ M`; define `f` via `Pi.basisFun.constr R m`; surjectivity
  via Nakayama
  (`IsLocalRing.span_eq_top_of_tmul_eq_basis`); kernel ⊆ 𝔪·⊤ via
  `TensorProduct.tmul_smul` + `Module.Basis.linearIndependent` of κ-basis +
  `IsLocalRing.residue_eq_zero_iff`.
  Axioms `{propext, Classical.choice, Quot.sound}`.
- **Docstring fixes applied** to `auslander_buchsbaum_formula_succ_pd`
  (L1330–L1432): replaced stale "All four pieces are absent"
  with current "gap (4) closed iter-198; gap (1) first-step substrate
  landed iter-199; gaps (2)-(3) remain" structure. Iter-196 chronology
  also corrected.
- **Push-beyond skipped**: snake-lemma (gap 3), two-term iterated
  wrapper, named `Module.Syzygy` wrapper. All three rejected with
  stated reasons (snake-lemma needs full iterated resolution; the
  other two add LOC without new mathematical content).
- **Sorry count**: 1 → 1 (file-level, unchanged).

### Lane COE-stage6-iiA — `CodimOneExtension.lean`

**HARD BAR**: land closed-point cotangent ↔ Kähler iso axiom-clean
per iter-199 mathlib-analogist `coe-stacks02jk` Analogue 2 recipe
(Stacks 02JK via `Algebra.FormallySmooth.iff_split_injection`).

- **Outcome**: HARD BAR MET. 4 new axiom-clean substrate helpers
  landed.
- **`cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`**
  (L466–L515): Sₘ-linear iso
  `(ker (algMap Sₘ κ)).Cotangent ≃ₗ[Sₘ] κ ⊗_Sₘ Ω[Sₘ⁄R]`
  under `[FormallySmooth R Sₘ] [FormallySmooth R κ] [Subsingleton Ω[κ⁄R]]`.
  Three-step proof per `analogies/coe-stacks02jk.md`:
  retraction → injection via `iff_split_injection`; `Ω[κ⁄R] = 0` +
  `exact_kerCotangentToTensor_mapBaseChange` → surjection;
  `LinearEquiv.ofBijective`.
- **`cotangent_iso_maximalIdeal_residue_tensor_kaehler_of_formallySmooth_residue`**
  (L527–L539): same iso with `(maximalIdeal Sₘ).Cotangent` domain;
  `rw [← hker]` transport via
  `IsLocalRing.ResidueField.algebraMap_eq` + `IsLocalRing.ker_residue`.
- **`finrank_cotangentSpace_of_formallySmooth_residue`** (L568–L592):
  `finrank κ (CotangentSpace Sₘ) = n` composing iter-198 6.B-RHS
  substrate (`finrank_residueField_tensor_kaehlerDifferential_of_free_rank_eq`)
  + maximal-ideal-form iso (helper 2) +
  `LinearEquiv.extendScalarsOfSurjective` (Sₘ-linear → κ-linear) +
  `LinearEquiv.finrank_eq`.
- **`finrank_cotangentSpace_of_bijective_algebraMap_residue`**
  (L612–L628): closed-point-friendly bundled wrapper; single
  hypothesis `Function.Bijective (algebraMap R κ)` discharges both
  FS-residue + Subsingleton-Ω typeclasses via
  `RingHom.FormallySmooth.of_bijective` +
  `KaehlerDifferential.subsingleton_of_surjective`.
- **All 4**: axioms `{propext, Classical.choice, Quot.sound}` per
  `lean_verify`.
- **Trailing sorry on `isRegularLocalRing_stalk_of_smooth` (L1101)**:
  unchanged per directive scope-fence; now strictly (ii.B)-gated
  (Stacks 00OE Krull-dim formula).
- **Sorry count**: 3 → 3 (file-level, unchanged).
- **Blueprint pin updated this review**:
  `lem:cotangent_kahler_over_field` `\lean{...}` updated from the
  Mathlib placeholder `Algebra.KaehlerDifferential.cotangent_iso_residue_tensor_kaehler`
  to the project-local axiom-clean target
  `AlgebraicGeometry.Scheme.cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue`
  (Stage 6.B Cotangent ↔ Kähler over a field).

### Lane FGA-sorry4 — `FGAPicRepresentability.lean`

**HARD BAR**: close Sorry 4 (`smoothProperQuotient` body) via
carrier-soundness probe pattern (the file's existing pattern;
verdict CONFIRMED iter-199 plan).

- **Outcome**: HARD BAR MET via carrier-soundness refactor.
  Theorem body now **axiom-clean**.
- **New `Prop`-valued typeclass `HasSmoothProperQuotient`** (L320–L341,
  field `is_representable : P.IsRepresentable`).
- **Global default instance `instHasSmoothProperQuotient`** (L346–L349)
  carries the single `⟨sorry⟩` site.
- **`smoothProperQuotient` rewritten** (L377–L391): added
  `[HasSmoothProperQuotient α]` hypothesis, extracts via
  `HasSmoothProperQuotient.is_representable (_α := α)`. Theorem body
  axiom-clean per `lean_verify`:
  `{propext, Classical.choice, Quot.sound}` (no `sorryAx`).
- **Push-beyond skipped**: Sorries 1–3 (`instHasPicSharp`,
  `instHasDivFunctor`, `instHasAbelMap`) NOT addressed. Tautological
  closures via `Functor.const (PUnit)` were available but explicitly
  rejected as headline-laundering per the iter-198 review CRIT-0
  finding + the iter-199 Lane RPF `rpf-placeholder-note` directive.
- **Genuine mathematical gap (NOT discharged)**: Altman–Kleiman
  effective-equivalence-relation theorem + EGA IV 8.11.5 (proper
  monomorphism = closed immersion) — both Mathlib gaps explicitly
  flagged in the blueprint chapter's `subsec:sorry_smooth_proper_quotient`
  Rank-2 analysis.
- **Sorry count**: 7 → 7 (the free sorry at the old L354 became the
  `⟨sorry⟩` instance constructor at the new L349). All 7 sorries in
  the file now follow the structurally homogeneous
  carrier-soundness probe pattern.

## Trajectory across recent iters

| Iter | Sorries (entering) | Net delta | Hard closures | Hard BARs met | Build |
|---|---|---|---|---|---|
| 195 | 88 | −2 | 0 | 6/8 (2 errored API 529) | GREEN, 0 axioms |
| 196 | 86 | −1 | 0 | 4/6 | GREEN, 0 axioms |
| 197 | 85 | −1 | **3** | 5/5 | GREEN, 0 axioms |
| 198 | 84 | −5 (4 placeholder) | 0 mathematical | 1/5 source-wise | GREEN, 0 axioms |
| 199 | 78 | **0** | 0 | 3/4 substrate-MET | GREEN, 0 axioms |

iter-199 is a pure substrate iter: 0 sorries closed, but 7 new
axiom-clean substrate helpers landed (2 WD + 1 AB + 4 COE) plus a
1-instance carrier-soundness refactor on FGA. Net effect on
trajectory: the iter-198 plan agent's "realistic 78 → 76-77 (−1 to
−2)" lands at the **worst-case band** (78 → 78); the recipe gap
discovered on Lane WD-A4a (3 Mathlib substrate sub-builds) is the
single largest unanticipated obstruction.

## Key findings / patterns discovered

### Pattern: `Algebra.FormallySmooth.iff_split_injection` as the missing retraction for Stacks 02JK closed-point cotangent iso

**Discovery context**: Lane COE-stage6-iiA. Iter-198 attempts at
this same iso failed because they used only the right half of the
conormal sequence; the *retraction*
`l : κ ⊗_{S_m} Ω[S_m⁄R] →ₗ[S_m] m.Cotangent` satisfying
`l ∘ₗ kerCotangentToTensor = id` was missing. The iter-199
mathlib-analogist `coe-stacks02jk` report (cross-domain-inspiration
mode) surfaced
`Algebra.FormallySmooth.iff_split_injection` from
`Mathlib.RingTheory.Smooth.Basic` as packaging exactly this
retraction as an iff-equivalent of `FormallySmooth R κ`.

**Recipe (3-step, ~40-50 LOC core + ~30 LOC κ-finrank
corollary)**: (1) retraction → injection via `iff_split_injection`;
(2) `Subsingleton Ω[κ⁄R]` (typeclass hypothesis discharged on
k̄-rational closed points via Nullstellensatz +
`KaehlerDifferential.subsingleton_of_surjective`) +
`exact_kerCotangentToTensor_mapBaseChange` → surjection;
(3) `LinearEquiv.ofBijective`.

**Reusable for ANY Stacks 02JK closed-point closed-point cotangent
iso build** — the formally-smooth-residue formulation generalizes
to any local-algebra/residue-field setting where the residue field
is formally smooth over the base (typically the k̄-rational case via
Nullstellensatz reduction).

### Pattern: `Pi.basisFun.constr R m` + `IsLocalRing.span_eq_top_of_tmul_eq_basis` for per-step minimal surjection

**Discovery context**: Lane AB-gap1. Iter-199 first-step substrate
for Stacks `lemma-add-trivial-complex`. The construction
`Nakayama-lift κ-basis → R^n →ₗ[R] M` factors through 5 substantive
Mathlib pieces: `Module.finBasis` (basis of finite κ-vector space) +
`TensorProduct.mk_surjective` (residue-tensor surjectivity) +
`Pi.basisFun.constr` (basis-extension universal property) +
`IsLocalRing.span_eq_top_of_tmul_eq_basis` (Nakayama-lift core) +
`Module.Basis.linearIndependent` (kernel containment).

**Reusable for** ANY "minimal generator-set" construction in
local-ring Module theory; pairs with iter-200+ Nat-recursive
iterated-resolution construction.

### Pattern: Substrate-only iter as the canonical response to multi-piece infrastructure gaps on Route A

**Discovery context**: Lane WD-A4a HARD BAR not met. The directive
recipe required *three* Mathlib substrate sub-builds (open-immersion
stalk-bridge, ordFrac transport, topological coheight ↔ ring height)
that no single-iter helper budget can deliver. The substrate-only
PUSH-BEYOND path (2 axiom-clean §2 substrate lemmas) preserves iter
velocity even when the HARD BAR is unreachable.

**Reusable for** ANY iter where the HARD BAR closure depends on
Mathlib gaps discovered mid-iter. The pattern preserves
no-regression-on-sorry-count discipline while still landing
forward-compatible substrate; the residual is precisely scoped
for future iters (here: 3 named Mathlib sub-builds).

## Plan-phase actions of note (for context)

The iter-199 plan agent dispatched 5 plan-phase subagents
(progress-critic `route199`, strategy-critic `route199`,
blueprint-reviewer `iter199`, blueprint-writer `rpf-placeholder-note`,
mathlib-analogist `coe-stacks02jk`).
- The strategy-critic returned **CHALLENGE** overall with a
  **REJECT-level finding on A.2.c representability**: the protected
  decls' kernel-triple end-state contract is unreachable without
  USER action or re-routing because the dependency cone transits
  A.2.c which is RR-substrate-blocked under Route C PAUSE. The plan
  agent's response edits to STRATEGY.md present three resolution
  candidates: (a) surgical Route C re-engagement of
  `AbelianVarietyRigidity.lean` + `RigidityKbar.lean`
  for the genus-0 arm (recommended); (b) full Route C re-engagement;
  (c) re-scope Goal. The TO_USER.md banner reflects (a).
- The progress-critic returned: WD UNCLEAR, AB STUCK, RPF STUCK +
  OVER BUDGET, COE CHURNING, FGA STUCK, T32 UNCLEAR. The plan-agent
  actions landed: blueprint-writer `ab-gap-sequence` (new
  per-gap decomposition subsection in
  `Albanese_AuslanderBuchsbaum.tex`); STRATEGY.md A.1.c.SubT phase
  row (~3-6 iters / ~200-400 LOC `Scheme.Modules.tensorObj` upstream
  build); STRATEGY.md A.4.c.0 widening to ~6-10 iters. Lane FGA
  dispatched this iter; the prover landed the carrier-soundness
  refactor. Lane T32 binding trigger condition recorded.
- Blueprint-reviewer's HARD GATE verdicts: ALL 4 prover-gate
  chapters CLEAR.

## Recommendations summary (see recommendations.md for details)

1. **CRIT-0**: Lane WD-A4a Sub-build 1 (open-immersion stalk-bridge
   for prime divisors, ~150-250 LOC) is the new genuine bottleneck;
   queue it as an iter-200 isolated mathlib-build target.
2. **CRIT-1**: Lane AB iter-200 gap (1) iteration — Nat-recursive
   minimal-resolution construction built on iter-199 substrate.
3. **CRIT-2**: Lane COE iter-200 sub-gap (ii.B) Stacks 00OE
   Krull-dim formula — final piece to close
   `isRegularLocalRing_stalk_of_smooth` AND cascade-close Lane T32.
4. **MEDIUM**: Lane RPF iter-200 `Scheme.Modules.tensorObj`
   upstream-style substrate build per STRATEGY.md A.1.c.SubT.
5. **LOW**: Lane FGA carrier-soundness refactor pattern landed
   cleanly; Sorries 1-3 remain gated on A.1.c.SubT, A.2.b Quot.

## Blueprint markers updated (manual)

- `Albanese_CodimOneExtension.tex`, `lem:cotangent_kahler_over_field`:
  corrected `\lean{Algebra.KaehlerDifferential.cotangent_iso_residue_tensor_kaehler}`
  → `\lean{AlgebraicGeometry.Scheme.cotangent_iso_residue_tensor_kaehler_of_formallySmooth_residue}`
  (Mathlib-placeholder → project-local axiom-clean target landed
  iter-199 by the Lane COE prover); LaTeX comment added documenting
  the 3 companion siblings for downstream consumers.
- `RiemannRoch_WeilDivisor.tex`, `lem:rationalMap_order_finite_support`:
  corrected `\lean{AlgebraicGeometry.Scheme.rationalMap_order_finite_support}`
  → `\lean{AlgebraicGeometry.rationalMap_order_finite_support}` (the
  spurious `.Scheme.` segment was introduced by the iter-199 plan
  agent; the theorem at `WeilDivisor.lean:357` lives in `namespace
  AlgebraicGeometry` only — `Scheme.RationalMap` closed at L159).
  `% NOTE:` added documenting the `private` visibility caveat and
  the closure path. Per
  `lean-vs-blueprint-checker wd-iter199` MAJOR finding.
- `Albanese_AuslanderBuchsbaum.tex`, `lem:auslander_buchsbaum_formula_succ_pd`:
  `% NOTE iter-199 review` added documenting the `private`-visibility
  caveat on the pinned declaration (`auslander_buchsbaum_formula_succ_pd`
  at `AuslanderBuchsbaum.lean:1398`). Two resolution options recorded
  (preferred: an iter-200 refactor / prover lane removes `private`
  from the Lean declaration). Per `lean-vs-blueprint-checker ab-iter199`
  finding F-3 (MAJOR).
- `Picard_FGAPicRepresentability.tex`, `\sec:fga_pic_sorry_closure_order`
  intro (L575 area): `% NOTE iter-199 review` block added flagging 3
  stale paragraphs (Sorry 4 location says "L354 free sorry" but
  iter-199 moved to `⟨sorry⟩` at L349; "six carrier typeclasses"
  list missing the new seventh `HasSmoothProperQuotient`;
  closure-order summary motivation "removes the only non-instance
  sorry" now inoperative). iter-200 blueprint-writer should refresh
  these prose blocks. Per `lean-vs-blueprint-checker fga-iter199`
  findings F-1, F-2, F-3 (all MAJOR, none must-fix).

No `\mathlibok`, `\notready`, or `% NOTE` additions this iter
(beyond the COE pin comment). The 4 prover-touched chapters were all
pre-touched by plan-phase iter-199 blueprint edits + the
`rpf-placeholder-note` writer + the `ab-gap-sequence` writer, and
the iter-199 blueprint-reviewer cleared all 4 HARD GATE chapters.

## Subagent dispatches (review phase)

Highly-recommended review subagents dispatched in parallel:
- `lean-auditor` slug `iter199` (project-wide audit of the 4
  modified files).
- `lean-vs-blueprint-checker` slugs `wd-iter199`, `ab-iter199`,
  `coe-iter199`, `fga-iter199` (per-file bidirectional verifiers).

See the latest entries in `task_results/` for full reports.
Findings integrated into `recommendations.md`.

## Blueprint doctor

Run for iter-199 reports **no structural findings**: every chapter
is `\input`'d by `content.tex`, every `\ref{...}` / `\uses{...}`
resolves to a defined `\label{...}`, every annotation has a
non-empty argument, no `axiom` declarations under `.lean` files.
The iter-198 doctor's empty-`\uses{}` finding (false positive on
`AbelianVarietyRigidity.tex`) does not re-appear. The iter-198
`\cref{df:Pfs}` finding in FGA was fixed plan-phase iter-199.

## `\leanok` sync attribution

Per `.archon/sync_leanok-state.json`: iter=199, sha=98a4844c,
added=4, removed=0, chapters_touched=[`Albanese_AuslanderBuchsbaum.tex`,
`Albanese_CodimOneExtension.tex`,
`Picard_FGAPicRepresentability.tex`]. The 4 added `\leanok` markers
are this iter's deterministic verdict on the new axiom-clean
declarations. No headline-laundering flag this iter (Lane RPF —
the only iter-198 laundering exposure — was HELD).
